> [flash][pro6]

# **[FASE 6: Networking & Data Management][0]**

Kita telah memasuki salah satu aspek paling krusial dalam pengembangan aplikasi modern; ini tentang bagaimana aplikasi Anda berkomunikasi dengan dunia luar melalui jaringan.

Fase ini akan membekali Anda dengan pengetahuan dan keterampilan untuk mengelola pertukaran data antara aplikasi Flutter Anda dan layanan _backend_ atau API lainnya. Pemahaman yang kuat di area ini sangat penting untuk membangun aplikasi yang dinamis dan terhubung.

---

<details>
  <summary>📃 Struktur Daftar Isi</summary>

**[8. HTTP & API Integration](#8-http--api-integration)**

- **[8.1 HTTP Client Implementation](#81-http-client-implementation)**
  - [HTTP Package](#http-package)
    - Basic HTTP requests (GET, POST, PUT, DELETE)
    - Request headers dan authentication
    - Response handling dan parsing
    - Error handling strategies
    - Timeout configuration
    - HTTP Requests (konsep umum)
    - HTTP Interceptors (konsep umum)

**[8. HTTP & API Integration (Lanjutan)](#8-http--api-integration-lanjutan)**

- **[8.1 HTTP Client Implementation (Lanjutan)](#81-http-client-implementation-lanjutan)**
  - [Dio Advanced HTTP Client](#dio-advanced-http-client)
    - Dio instance configuration
    - Request dan response interceptors
    - File upload dengan progress
    - Download dengan progress
    - Request cancellation
    - Connection pooling
    - Certificate pinning
    - Cache implementation
    - Dio Documentation
    - Dio Interceptors
    - Dio Certificate Pinning
- **[8.2 JSON & Data Serialization](#82-json--data-serialization)**
  - [JSON Serialization](#json--data-serialization)
    - Manual JSON parsing
    - `fromJson()` dan `toJson()` methods
    - Nested object serialization
    - List serialization
    - Null safety dalam JSON
    - JSON Serialization Guide
  - Code Generation untuk Serialization
    - `json_annotation` setup
    - `json_serializable` configuration
    - Build runner usage
    - Custom JSON converters
    - Generic serialization
    - `json_annotation` Package
    - `json_serializable`
    - Build Runner
  - Advanced Serialization
    - Freezed untuk immutable classes
    - Union types dengan Freezed
    - Copy-with methods
    - Equality dan hashCode generation
    - Freezed Package

**[9. Local Data Storage](#9-local-data-storage)**

- **[9.1 Key-Value Storage](#91-key-value-storage)**
  - SharedPreferences
    - Basic key-value operations
    - Data type support
    - Async operations
    - Prefix strategies
    - Migration strategies
    - SharedPreferences Guide
    - SharedPreferences Package
  - Secure Storage
    - Keychain/Keystore integration
    - Biometric authentication
    - Encryption keys storage
    - Secure preferences
    - Platform-specific implementations
    - Flutter Secure Storage
    - Secure Storage Guide
- **[9.2 Database Solutions](#92-database-solutions)**
  - SQLite Integration
    - Database creation dan migrations
    - CRUD operations
    - Complex queries dan joins
    - Transactions
    - Database versioning
    - Performance optimization
    - SQLite Tutorial
    - SQFlite Package
  - Drift (Moor) ORM
    - Table definitions
    - Query builder
    - Type-safe queries
    - Migration system
    - Database inspector
    - Drift ORM
  - Hive NoSQL Database
    - Box operations
    - Type adapters
    - Lazy boxes
    - Encryption
    - Performance benchmarks
    - Hive vs SQLite
  - Isar Database
    - Schema definition
    - Query language
    - Indexes optimization
    - Full-text search
    - Database inspector
    - Isar Documentation
    - Isar Inspector
- **[9.3 Caching Strategies](#93-caching-strategies)**
  - HTTP Caching
    - Cache-Control headers
    - ETag implementation
    - Cache invalidation
    - Offline-first strategies
    - Dio Cache Interceptor
  - Image Caching
    - Memory cache
    - Disk cache
    - Cache size management
    - Progressive loading
    - Cached Network Image

---

</details>

#### **8. HTTP & API Integration**

- **Peran:** Bagian ini berfokus pada bagaimana aplikasi Flutter Anda melakukan permintaan HTTP ke server, mengirim data, menerima respons, dan menangani berbagai skenario komunikasi jaringan. Ini adalah fondasi untuk berinteraksi dengan API (_Application Programming Interface_) yang menyediakan data atau fungsionalitas dari server.

---

##### **8.1 HTTP Client Implementation**

- **Gambaran Umum:** Untuk melakukan operasi HTTP, kita membutuhkan _HTTP Client_. Flutter sendiri menyediakan _client_ dasar melalui `dart:io` atau Anda bisa menggunakan _package_ pihak ketiga yang lebih kaya fitur. Kita akan membahas dua _client_ utama: _package_ `http` (yang lebih dasar dan sering digunakan untuk studi kasus sederhana) dan `Dio` (sebuah _HTTP client_ yang lebih canggih untuk aplikasi skala produksi).

---

###### **HTTP Package**

- **Peran:** _Package_ `http` adalah _HTTP client_ ringan dan mudah digunakan yang disediakan oleh tim Dart. Ini sangat baik untuk memulai dengan permintaan HTTP dasar karena API-nya yang sederhana dan langsung.

- **Detail:** Anda perlu menambahkan _package_ `http` ke `pubspec.yaml` Anda.

  ```yaml
  dependencies:
    flutter:
      sdk: flutter
    http: ^latest_version # Ganti dengan versi terbaru
  ```

  Setelah menambahkan, jalankan `flutter pub get`.

- **Basic HTTP Requests (GET, POST, PUT, DELETE)**

  - **Peran:** Mempelajari metode HTTP dasar yang digunakan untuk berinteraksi dengan sumber daya di server.
  - **Detail:**
    - **GET:** Digunakan untuk mengambil (membaca) data dari server. Data dikirim melalui _query parameters_ di URL.
    - **POST:** Digunakan untuk mengirim (membuat) data baru ke server. Data dikirim dalam _body_ permintaan.
    - **PUT:** Digunakan untuk memperbarui (mengganti sepenuhnya) sumber daya yang ada di server. Data dikirim dalam _body_ permintaan.
    - **DELETE:** Digunakan untuk menghapus sumber daya dari server.
  - **Contoh Kode:**

  <!-- end list -->

  ```dart
  import 'package:http/http.dart' as http; // Alias 'http' untuk menghindari konflik nama
  import 'dart:convert'; // Untuk encode/decode JSON

  // Asumsi: URL API dasar Anda
  const String baseUrl = 'https://jsonplaceholder.typicode.com'; // Contoh API publik

  class HttpService {
    // 1. GET Request
    Future<void> fetchData() async {
      final uri = Uri.parse('$baseUrl/posts/1'); // Mendapatkan satu post
      try {
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          // Berhasil mengambil data
          print('GET Response Data: ${response.body}');
          // Konversi JSON string ke Map Dart
          final Map<String, dynamic> data = json.decode(response.body);
          print('Parsed GET Data (title): ${data['title']}');
        } else {
          // Gagal mengambil data
          print('Failed to load data: ${response.statusCode}');
          print('Error body: ${response.body}');
        }
      } catch (e) {
        // Penanganan kesalahan jaringan atau lainnya
        print('Error during GET request: $e');
      }
    }

    // 2. POST Request
    Future<void> createPost(String title, String body) async {
      final uri = Uri.parse('$baseUrl/posts');
      try {
        final response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8', // Penting untuk JSON
          },
          body: jsonEncode(<String, String>{
            'title': title,
            'body': body,
            'userId': '1', // Contoh ID pengguna
          }),
        );

        if (response.statusCode == 201) { // 201 Created untuk POST berhasil
          print('POST Response Data: ${response.body}');
          final Map<String, dynamic> data = json.decode(response.body);
          print('New Post ID: ${data['id']}');
        } else {
          print('Failed to create post: ${response.statusCode}');
          print('Error body: ${response.body}');
        }
      } catch (e) {
        print('Error during POST request: $e');
      }
    }

    // 3. PUT Request
    Future<void> updatePost(int id, String newTitle) async {
      final uri = Uri.parse('$baseUrl/posts/$id');
      try {
        final response = await http.put(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'id': id,
            'title': newTitle,
            'body': 'Updated body content',
            'userId': 1,
          }),
        );

        if (response.statusCode == 200) { // 200 OK untuk PUT berhasil
          print('PUT Response Data: ${response.body}');
          final Map<String, dynamic> data = json.decode(response.body);
          print('Updated Post Title: ${data['title']}');
        } else {
          print('Failed to update post: ${response.statusCode}');
          print('Error body: ${response.body}');
        }
      } catch (e) {
        print('Error during PUT request: $e');
      }
    }

    // 4. DELETE Request
    Future<void> deletePost(int id) async {
      final uri = Uri.parse('$baseUrl/posts/$id');
      try {
        final response = await http.delete(uri);

        if (response.statusCode == 200) { // 200 OK untuk DELETE berhasil
          print('DELETE Response: Post ID $id deleted successfully.');
        } else {
          print('Failed to delete post: ${response.statusCode}');
          print('Error body: ${response.body}');
        }
      } catch (e) {
        print('Error during DELETE request: $e');
      }
    }
  }

  // Cara menggunakan dalam widget:
  /*
  class MyApiCallWidget extends StatefulWidget {
    const MyApiCallWidget({super.key});

    @override
    State<MyApiCallWidget> createState() => _MyApiCallWidgetState();
  }

  class _MyApiCallWidgetState extends State<MyApiCallWidget> {
    final HttpService _httpService = HttpService();

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('HTTP Package Demo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _httpService.fetchData(),
                child: const Text('GET Data'),
              ),
              ElevatedButton(
                onPressed: () => _httpService.createPost('My New Title', 'This is the body of my new post.'),
                child: const Text('POST Data'),
              ),
              ElevatedButton(
                onPressed: () => _httpService.updatePost(1, 'Updated Title from Flutter'),
                child: const Text('PUT Data'),
              ),
              ElevatedButton(
                onPressed: () => _httpService.deletePost(1),
                child: const Text('DELETE Data'),
              ),
            ],
          ),
        ),
      );
    }
  }
  */
  ```

- **Request Headers dan Authentication**

  - **Peran:** Mengirim informasi tambahan dalam permintaan HTTP (disebut _headers_) yang diperlukan oleh server, seringkali untuk otentikasi (verifikasi identitas pengguna).
  - **Detail:** _Headers_ adalah pasangan kunci-nilai yang disertakan dalam permintaan HTTP. `http.post`, `http.get`, dll., memiliki parameter `headers`.
    - **`Content-Type`:** Memberi tahu server format _body_ permintaan (misalnya, `application/json`).
    - **`Authorization`:** Mengirim _token_ otentikasi (misalnya, _Bearer Token_ untuk JWT) untuk membuktikan identitas pengguna.
  - **Contoh Kode:**

  <!-- end list -->

  ```dart
  Future<void> fetchProtectedData(String token) async {
    final uri = Uri.parse('$baseUrl/protected_resource'); // Ganti dengan URL API yang dilindungi
    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Mengirim Bearer Token
          'Accept': 'application/json', // Memberitahu server kita ingin respons JSON
        },
      );

      if (response.statusCode == 200) {
        print('Protected Data: ${response.body}');
      } else if (response.statusCode == 401) {
        print('Authentication failed: Invalid or expired token.');
      } else {
        print('Failed to fetch protected data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching protected data: $e');
    }
  }
  ```

- **Response Handling dan Parsing**

  - **Peran:** Menerima dan memproses respons dari server. Respons HTTP terdiri dari _status code_ dan _body_ respons.
  - **Detail:**
    - **`response.statusCode`:** Kode status HTTP (misalnya, 200 OK, 404 Not Found, 500 Internal Server Error). Ini adalah indikator utama keberhasilan atau kegagalan permintaan.
    - **`response.body`:** Konten aktual dari respons (biasanya dalam format JSON atau XML).
    - **`dart:convert`:** Pustaka ini digunakan untuk mengonversi _string_ JSON menjadi objek Dart (`json.decode()`) dan objek Dart menjadi _string_ JSON (`json.encode()`).
  - **Contoh Kode (Lihat bagian Basic HTTP Requests di atas):**
    - Setelah menerima `response.body`, gunakan `json.decode(response.body)` untuk mengubahnya menjadi `Map<String, dynamic>` atau `List<dynamic>` jika responsnya adalah _array_ JSON.

- **Error Handling Strategies**

  - **Peran:** Mengelola skenario di mana permintaan HTTP gagal, baik karena masalah jaringan, _status code_ non-2xx dari server, atau masalah parsing.
  - **Detail:**
    - **Blok `try-catch`:** Untuk menangkap kesalahan tingkat jaringan (misalnya, tidak ada koneksi internet, _timeout_).
    - **Pemeriksaan `response.statusCode`:** Untuk menangani respons non-sukses dari server. Sangat penting untuk memahami makna kode status HTTP (misalnya, 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 500 Internal Server Error).
    - **Validasi Data/Parsing:** Pastikan data yang diurai sesuai dengan struktur yang diharapkan untuk menghindari _runtime errors_.
  - **Contoh Kode (Lihat bagian Basic HTTP Requests di atas untuk `try-catch` dan pemeriksaan `statusCode`):**

    ```dart
    // Contoh penanganan lebih lanjut
    Future<void> safeFetchData() async {
      final uri = Uri.parse('$baseUrl/nonexistent_path');
      try {
        final response = await http.get(uri);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          // Sukses (2xx codes)
          print('Success: ${response.body}');
        } else if (response.statusCode == 404) {
          print('Error: Resource not found (404)');
        } else if (response.statusCode >= 400 && response.statusCode < 500) {
          print('Client Error: ${response.statusCode} - ${response.body}');
        } else if (response.statusCode >= 500 && response.statusCode < 600) {
          print('Server Error: ${response.statusCode} - ${response.body}');
        } else {
          print('Unhandled HTTP Status: ${response.statusCode} - ${response.body}');
        }
      } on http.ClientException catch (e) { // Kesalahan spesifik dari package http
        print('HTTP Client Exception (e.g., network error): $e');
      } catch (e) {
        print('General Error during request: $e');
      }
    }
    ```

- **Timeout Configuration**

  - **Peran:** Menentukan batas waktu maksimum untuk menyelesaikan permintaan HTTP. Jika permintaan tidak selesai dalam waktu yang ditentukan, itu akan dibatalkan, mencegah aplikasi tampak "macet".
  - **Detail:** Gunakan metode `.timeout()` pada `Future` yang dikembalikan oleh permintaan HTTP.
  - **Contoh Kode:**

  <!-- end list -->

  ```dart
  Future<void> fetchWithTimeout() async {
    final uri = Uri.parse('$baseUrl/posts');
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 5)); // Timeout 5 detik

      if (response.statusCode == 200) {
        print('Data fetched within timeout.');
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      print('Network error: $e');
    } on TimeoutException { // Penting: import dart:async untuk TimeoutException
      print('Request timed out after 5 seconds.');
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }
  ```

  - **Catatan:** Untuk menggunakan `TimeoutException`, Anda perlu mengimpor `dart:async`.

- **HTTP Requests (Gambaran Umum)**

  - **Peran:** Mengacu pada mekanisme fundamental di mana _client_ (aplikasi Flutter Anda) meminta data atau fungsionalitas dari _server_ melalui protokol HTTP. Ini melibatkan _request method_ (GET, POST, dll.), URL, _headers_, dan _body_.

- **HTTP Interceptors (Gambaran Umum)**

  - **Peran:** Sebuah konsep dalam _HTTP client_ yang memungkinkan Anda mencegat dan memodifikasi permintaan dan respons HTTP secara global sebelum mereka dikirim atau diproses. Ini sangat berguna untuk menambahkan _headers_ umum (misalnya, token otentikasi), mencatat (_logging_) permintaan/respons, atau menangani _error_ secara terpusat.
  - **Detail:** _Package_ `http` bawaan tidak memiliki sistem _interceptor_ yang _built-in_. Untuk fungsionalitas _interceptor_ yang sebenarnya, Anda perlu menggunakan _HTTP client_ yang lebih canggih seperti `Dio`.

---

Ini mengakhiri pembahasan tentang _package_ **HTTP Client** dasar. Meskipun sederhana, ini adalah dasar yang bagus untuk memahami konsep inti komunikasi HTTP. Selanjutnya, kita akan beralih ke **Dio Advanced HTTP Client**, yang menawarkan fitur _interceptor_ dan kemampuan lainnya yang lebih canggih, sangat cocok untuk pengembangan aplikasi produksi.

#### **8. HTTP & API Integration (Lanjutan)**

##### **8.1 HTTP Client Implementation (Lanjutan)**

###### **Dio Advanced HTTP Client**

- **Peran:** `Dio` adalah _HTTP client_ yang sangat populer dan kuat untuk Dart dan Flutter. Berbeda dengan _package_ `http` yang lebih sederhana, `Dio` menyediakan fitur-fitur canggih seperti _interceptors_, _request cancellation_, _download_ dengan _progress_, _timeout_ yang lebih baik, _global configuration_, dan banyak lagi, menjadikannya pilihan ideal untuk aplikasi skala besar dan kompleks.

- **Detail:** Anda perlu menambahkan _package_ `dio` ke `pubspec.yaml` Anda.

  ```yaml
  dependencies:
    flutter:
      sdk: flutter
    dio: ^latest_version # Ganti dengan versi terbaru yang stabil
  ```

  Setelah menambahkan, jalankan `flutter pub get`.

- **1. Dio Instance Configuration**

  - **Peran:** Mengatur konfigurasi dasar untuk _instance_ Dio Anda, yang akan digunakan untuk semua permintaan yang dibuat oleh _instance_ tersebut. Ini membantu menghindari pengulangan kode dan memastikan konsistensi.
  - **Detail:** Konfigurasi dapat meliputi `baseUrl`, `connectTimeout`, `receiveTimeout`, `headers` dasar, dll. Dianjurkan untuk membuat satu _instance_ Dio global atau menggunakan _dependency injection_ untuk mengelolanya.

  <!-- end list -->

  ```dart
  import 'package:dio/dio.dart';

  class ApiService {
    final Dio _dio;

    ApiService() : _dio = Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com', // Base URL API Anda
        connectTimeout: const Duration(seconds: 5), // Batas waktu koneksi
        receiveTimeout: const Duration(seconds: 3),  // Batas waktu menerima data
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          // 'Authorization': 'Bearer YOUR_GLOBAL_AUTH_TOKEN', // Contoh header global
        },
      ),
    );

    Dio get dio => _dio; // Getter untuk mengakses instance Dio

    // Contoh penggunaan:
    Future<void> getPost(int id) async {
      try {
        final response = await _dio.get('/posts/$id'); // Gunakan path relatif
        if (response.statusCode == 200) {
          print('Dio GET Post: ${response.data}');
        } else {
          print('Error: ${response.statusCode}, ${response.statusMessage}');
        }
      } on DioException catch (e) { // Tangani DioException untuk error Dio
        _handleDioError(e);
      } catch (e) {
        print('Unexpected error: $e');
      }
    }

    // Metode untuk penanganan error Dio
    void _handleDioError(DioException e) {
      if (e.response != null) {
        print('Dio Error! Status: ${e.response?.statusCode}');
        print('Dio Error! Data: ${e.response?.data}');
        print('Dio Error! Headers: ${e.response?.headers}');
      } else {
        // Kesalahan tanpa respons server (misalnya, masalah koneksi)
        print('Dio Error! Request: ${e.requestOptions.path}');
        print('Dio Error! Message: ${e.message}');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        print('Connection timed out!');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        print('Receive timed out!');
      } else if (e.type == DioExceptionType.badResponse) {
        print('Bad response from server!');
      } else {
        print('Other Dio error: ${e.type}');
      }
    }
  }

  // Cara menggunakan dalam widget:
  /*
  class MyDioCallWidget extends StatefulWidget {
    const MyDioCallWidget({super.key});

    @override
    State<MyDioCallWidget> createState() => _MyDioCallWidgetState();
  }

  class _MyDioCallWidgetState extends State<MyDioCallWidget> {
    final ApiService _apiService = ApiService();

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dio HTTP Client Demo')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => _apiService.getPost(1),
            child: const Text('Get Post with Dio'),
          ),
        ),
      );
    }
  }
  */
  ```

  - **`DioException`:** Ini adalah kelas pengecualian khusus Dio yang perlu Anda tangani untuk berbagai jenis kesalahan jaringan dan API.

- **2. Request dan Response Interceptors**

  - **Peran:** _Interceptors_ adalah salah satu fitur paling kuat dari Dio. Mereka memungkinkan Anda mencegat dan memodifikasi permintaan sebelum dikirim, atau respons setelah diterima (atau bahkan sebelum mencapai kode Anda). Ini ideal untuk _logging_, otentikasi dinamis, _error handling_ global, dan _caching_.
  - **Detail:** Anda menambahkan _interceptors_ ke _instance_ Dio Anda melalui `_dio.interceptors.add()`. Ada tiga jenis _callback_ utama dalam _interceptor_:
    - `onRequest`: Dipanggil sebelum permintaan dikirim.
    - `onResponse`: Dipanggil setelah respons diterima.
    - `onError`: Dipanggil ketika terjadi kesalahan.
  - **Jenis Interceptor Umum:**
    - **Logging Interceptor:** Mencatat detail permintaan dan respons untuk _debugging_.
    - **Auth Interceptor:** Menambahkan token otentikasi ke setiap permintaan, atau memperbarui token jika kedaluwarsa.
    - **Error Handling Interceptor:** Menangani kode status kesalahan tertentu secara global.
  - **Contoh Kode:**

  <!-- end list -->

  ```dart
  import 'package:dio/dio.dart';
  import 'dart:developer' as developer; // Untuk logging yang lebih baik

  class LoggingInterceptor extends Interceptor {
    @override
    void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
      developer.log('REQUEST[${options.method}] => PATH: ${options.path}');
      developer.log('Headers: ${options.headers}');
      developer.log('Data: ${options.data}');
      super.onRequest(options, handler); // Lanjutkan permintaan
    }

    @override
    void onResponse(Response response, ResponseInterceptorHandler handler) {
      developer.log('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
      developer.log('Data: ${response.data}');
      super.onResponse(response, handler); // Lanjutkan respons
    }

    @override
    void onError(DioException err, ErrorInterceptorHandler handler) {
      developer.log('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
      developer.log('Error Message: ${err.message}');
      if (err.response != null) {
        developer.log('Error Data: ${err.response?.data}');
      }
      super.onError(err, handler); // Lanjutkan error
    }
  }

  // Contoh Auth Interceptor (konseptual)
  class AuthInterceptor extends Interceptor {
    final String? authToken; // Bisa diambil dari SharedPreferences dll.

    AuthInterceptor({this.authToken});

    @override
    void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
      if (authToken != null) {
        options.headers['Authorization'] = 'Bearer $authToken';
      }
      super.onRequest(options, handler);
    }

    // Anda bisa menambahkan logika di onResponse/onError untuk refresh token
    // atau redirect ke login jika token invalid/expired
  }

  // Menambahkan interceptor ke Dio instance:
  // class ApiService {
  //   final Dio _dio;
  //
  //   ApiService() : _dio = Dio(BaseOptions(...)) {
  //     _dio.interceptors.add(LoggingInterceptor());
  //     _dio.interceptors.add(AuthInterceptor(authToken: 'your_dynamic_token'));
  //     // Anda juga bisa membuat interceptor untuk caching, penanganan error spesifik, dll.
  //   }
  //   // ...
  // }
  ```

  - **Sumber Daya Tambahan:**
    - [Dio Interceptors](https://pub.dev/packages/dio%23interceptors)

- **3. File Upload dengan Progress**

  - **Peran:** Mengunggah file (gambar, video, dokumen) ke server dengan kemampuan untuk melacak _progress_ unggahan, yang penting untuk UX saat mengunggah file besar.
  - **Detail:** Dio mendukung unggahan file menggunakan `FormData` dan _callback_ `onSendProgress`.
  - **Contoh Kode:**

  <!-- end list -->

  ```dart
  import 'dart:io'; // Untuk File
  import 'package:dio/dio.dart';
  import 'package:file_picker/file_picker.dart'; // package:file_picker untuk memilih file

  Future<void> uploadFileWithProgress(Dio dio) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = file.path.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
        "other_field": "some_value", // Data tambahan jika ada
      });

      try {
        final response = await dio.post(
          'YOUR_UPLOAD_API_URL', // Ganti dengan URL API unggahan Anda
          data: formData,
          onSendProgress: (int sent, int total) {
            double progress = (sent / total) * 100;
            print('Upload Progress: $progress% ($sent/$total)');
            // Anda bisa memperbarui UI di sini (misalnya, ProgressBar)
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('File uploaded successfully! Response: ${response.data}');
        } else {
          print('File upload failed: ${response.statusCode}, ${response.statusMessage}');
        }
      } on DioException catch (e) {
        print('Upload Dio Error: $e');
      } catch (e) {
        print('Unexpected upload error: $e');
      }
    } else {
      print('User canceled the file picker.');
    }
  }
  ```

  - **Catatan:** Anda akan membutuhkan _package_ `file_picker` (atau sejenisnya) untuk memungkinkan pengguna memilih file dari perangkat mereka.

- **4. Download dengan Progress**

  - **Peran:** Mengunduh file dari server sambil melacak _progress_ unduhan, penting untuk pengalaman pengguna saat mengunduh file besar.
  - **Detail:** Dio menyediakan metode `download()` dengan _callback_ `onReceiveProgress`.
  - **Contoh Kode:**

  <!-- end list -->

  ```dart
  import 'package:dio/dio.dart';
  import 'package:path_provider/path_provider.dart'; // Untuk mendapatkan direktori penyimpanan
  import 'dart:io';

  Future<void> downloadFileWithProgress(Dio dio) async {
    String fileUrl = 'https://speed.hetzner.de/100MB.bin'; // Contoh URL file besar
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = '${appDocDir.path}/downloaded_file.bin';

      await dio.download(
        fileUrl,
        savePath,
        onReceiveProgress: (int received, int total) {
          if (total != -1) {
            double progress = (received / total) * 100;
            print('Download Progress: $progress% ($received/$total)');
            // Anda bisa memperbarui UI di sini
          }
        },
      );
      print('File downloaded to: $savePath');
    } on DioException catch (e) {
      print('Download Dio Error: $e');
    } catch (e) {
      print('Unexpected download error: $e');
    }
  }
  ```

  - **Catatan:** Anda mungkin membutuhkan _package_ `path_provider` untuk mendapatkan direktori penyimpanan yang sesuai di perangkat.

- **5. Request Cancellation**

  - **Peran:** Membatalkan permintaan HTTP yang sedang berlangsung. Ini berguna untuk skenario seperti pengguna meninggalkan layar sebelum permintaan selesai, atau jika Anda memiliki permintaan _autocomplete_ yang tidak perlu lagi jika pengguna mengetik lebih lanjut.
  - **Detail:** Dio menggunakan `CancelToken`. Anda membuat _instance_ `CancelToken` dan melewatkannya ke permintaan Dio. Anda kemudian dapat memanggil `.cancel()` pada _token_ tersebut.
  - **Contoh Kode:**

  <!-- end list -->

  ```dart
  import 'package:dio/dio.dart';

  final Dio _dio = Dio();
  CancelToken? _cancelToken; // Deklarasikan sebagai nullable

  Future<void> fetchCancellableData() async {
    _cancelToken = CancelToken(); // Buat token baru setiap kali

    try {
      print('Fetching data with cancellation token...');
      final response = await _dio.get(
        'https://jsonplaceholder.typicode.com/todos',
        cancelToken: _cancelToken, // Lewatkan token
      );
      print('Cancellable Data: ${response.data.length} todos fetched.');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        print('Request cancelled!');
      } else {
        _handleDioError(e); // Gunakan handler error Anda
      }
    } catch (e) {
      print('Unexpected error: $e');
    } finally {
      _cancelToken = null; // Reset token setelah selesai atau dibatalkan
    }
  }

  void cancelRequest() {
    _cancelToken?.cancel("Request was explicitly cancelled by user."); // Batalkan permintaan
    print('Cancellation requested.');
  }

  // Cara menggunakan dalam widget:
  /*
  class CancellableRequestWidget extends StatelessWidget {
    const CancellableRequestWidget({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dio Cancellation Demo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => fetchCancellableData(),
                child: const Text('Start Cancellable Request'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => cancelRequest(),
                child: const Text('Cancel Request'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ),
      );
    }
  }
  */
  ```

- **6. Connection Pooling**

  - **Peran:** Dio secara internal mengelola _connection pooling_ (kumpulan koneksi). Ini berarti Dio dapat menggunakan kembali koneksi HTTP yang sudah ada untuk permintaan berikutnya ke _host_ yang sama, mengurangi _overhead_ pembukaan koneksi baru dan meningkatkan kinerja.
  - **Detail:** Ini adalah fitur _behind-the-scenes_ yang dioptimalkan oleh Dio. Anda tidak perlu mengkonfigurasinya secara eksplisit. Cukup dengan menggunakan _instance_ Dio yang sama untuk semua permintaan Anda ke _host_ yang sama, Anda akan mendapatkan manfaat dari _connection pooling_.

- **7. Certificate Pinning**

  - **Peran:** Sebuah teknik keamanan tingkat lanjut di mana aplikasi "meminjamkan" (atau menyimpan) sertifikat SSL/TLS server yang diharapkan. Saat koneksi dibuat, aplikasi memverifikasi bahwa sertifikat yang diterima dari server cocok dengan sertifikat yang "dipinjamkan". Ini mencegah serangan _man-in-the-middle_ (MITM) di mana penyerang mungkin mencoba memalsukan identitas server.
  - **Detail:** Implementasi _certificate pinning_ dengan Dio biasanya memerlukan pengaturan _HttpClientAdapter_ kustom, seperti `HttpClientAdapter` bawaan Dio atau menggunakan _package_ yang dirancang untuk _pinning_ (misalnya, `http_certificate_pinning`).
  - **Contoh Konseptual (Menggunakan HttpClientAdapter bawaan Dio untuk self-signed certs atau custom CA):**

  <!-- end list -->

  ```dart
  // Contoh sederhana untuk mengizinkan self-signed certificate (TIDAK DIREKOMENDASIKAN UNTUK PRODUKSI)
  // Untuk produksi, Anda akan mem-pin public key atau hash sertifikat tertentu.
  import 'dart:io';
  import 'package:dio/dio.dart';
  import 'package:dio/io.dart'; // Import untuk IOHttpClientAdapter

  void setupCertificatePinning(Dio dio) {
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final HttpClient client = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) {
          // Dalam produksi, Anda akan membandingkan hash sertifikat 'cert'
          // dengan hash yang diharapkan yang Anda pin.
          // Contoh sederhana (TIDAK AMAN untuk produksi):
          // return host == 'your-secure-domain.com'; // Hanya percaya domain ini

          // Untuk demo, kita bisa mengizinkan semua (TIDAK AMAN):
          return true; // Mengizinkan sertifikat tidak valid (Hanya untuk debugging/pengujian)
        };
      return client;
    };
  }

  // Penggunaan:
  // final Dio _dioWithPinning = Dio();
  // setupCertificatePinning(_dioWithPinning);
  // _dioWithPinning.get('https://your-secure-domain.com/api/data');
  ```

  - **Untuk implementasi yang lebih robust dan aman:**
    - Gunakan _package_ khusus seperti `http_certificate_pinning` atau `cert_pinning`.
    - Anda akan mendapatkan _hash_ publik dari sertifikat server Anda (biasanya SHA256 _hash_ dari _public key_ sertifikat).
    - _Hash_ ini kemudian disimpan dalam aplikasi dan diverifikasi saat setiap koneksi.
  - **Sumber Daya Tambahan:**
    - [Dio Certificate Pinning](https://pub.dev/packages/dio%23certificate-pinning)

- **8. Cache Implementation**

  - **Peran:** Menyimpan respons HTTP di sisi _client_ (aplikasi) untuk mengurangi jumlah permintaan ke server, mempercepat pengambilan data, dan memungkinkan fungsionalitas _offline-first_.
  - **Detail:** Dio tidak memiliki _cache_ bawaan, tetapi sangat mudah untuk mengintegrasikan _cache_ melalui _interceptor_. _Package_ `dio_cache_interceptor` adalah solusi populer untuk ini.
  - **Alur Konseptual:**
    1.  **Tambahkan Dependency:** `dio_cache_interceptor: ^latest_version`
    2.  **Konfigurasi `DioCacheInterceptor`:** Tentukan strategi _cache_ (misalnya, `RequestPolicy.refresh` untuk selalu meminta data baru, `RequestPolicy.cacheFirst` untuk mencoba _cache_ terlebih dahulu).
    3.  **Tambahkan ke Dio:** `dio.interceptors.add(DioCacheInterceptor(options: cacheOptions))`
  - **Contoh Kode (dengan `dio_cache_interceptor`):**

  <!-- end list -->

  ```dart
  import 'package:dio/dio.dart';
  import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
  import 'package:path_provider/path_provider.dart';
  import 'dart:io';

  Future<void> setupDioWithCache() async {
    final dio = Dio();

    // Mendapatkan direktori untuk menyimpan cache
    final dir = await getTemporaryDirectory();
    final cacheStore = FileSystemCacheStore(dir.path);

    // Konfigurasi cache options
    final CacheOptions cacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.request, // Kebijakan default: ikuti header cache
      hitCacheOnErrorExcept: [401, 403], // Gunakan cache jika error, kecuali 401/403
      maxStale: const Duration(days: 7), // Berapa lama cache dianggap 'stale'
      priority: CachePriority.normal,
    );

    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

    // Contoh penggunaan cache:
    try {
      print('Fetching data with cache...');
      final response = await dio.get(
        'https://jsonplaceholder.typicode.com/posts',
        options: Options(
          extra: {
            "refresh": true, // Paksa refresh (abaikan cache jika ada)
            "cache_control": CacheControl.maxAge(const Duration(minutes: 5)), // Cache selama 5 menit
          },
        ),
      );
      print('Cached Data Length: ${response.data.length}');
      print('Is from Cache: ${response.extra["_from_cache"] ?? false}');
    } on DioException catch (e) {
      print('Dio Cache Error: $e');
    }
  }

  // Cara menggunakan dalam widget:
  /*
  class DioCacheDemo extends StatelessWidget {
    const DioCacheDemo({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dio Cache Interceptor Demo')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => setupDioWithCache(),
            child: const Text('Fetch Data with Cache'),
          ),
        ),
      );
    }
  }
  */
  ```

- **Sumber Daya Tambahan untuk Dio:**

  - [Dio Documentation](https://pub.dev/packages/dio) - Dokumentasi resmi Dio adalah sumber daya terbaik untuk detail lebih lanjut.
  - [Dio Interceptors](https://pub.dev/packages/dio%23interceptors) - Halaman khusus tentang penggunaan _interceptors_.
  - [Dio Certificate Pinning](https://pub.dev/packages/dio%23certificate-pinning) - Detail tentang cara mengimplementasikan _certificate pinning_.

---

Kita telah menyelesaikan pembahasan mendalam tentang **Dio Advanced HTTP Client**, termasuk konfigurasi, _interceptors_, _upload/download_ dengan _progress_, _cancellation_, dan konsep keamanan seperti _certificate pinning_. Dio adalah pilihan yang sangat kuat untuk kebutuhan jaringan aplikasi Flutter Anda.

Selanjutnya, kita akan beralih ke bagian berikutnya dalam **Fase 6: Networking & Data Management**, yaitu **8.2 JSON & Data Serialization**. Ini adalah langkah penting untuk memahami bagaimana data yang diterima dari API (seringkali dalam format JSON) dikonversi menjadi objek Dart yang dapat Anda gunakan dalam aplikasi Anda.

---

#### **8. HTTP & API Integration (Lanjutan)**

##### **8.2 JSON & Data Serialization**

- **Peran:** `JSON` (_JavaScript Object Notation_) adalah format pertukaran data yang ringan dan mudah dibaca oleh manusia serta mudah diurai oleh mesin. `Data Serialization` (juga dikenal sebagai _marshalling_ atau _encoding_) adalah proses mengonversi objek Dart ke format JSON (untuk dikirim ke _server_), dan `Deserialization` (atau _unmarshalling_ / _decoding_) adalah proses mengonversi data JSON kembali menjadi objek Dart (setelah diterima dari _server_).

---

###### **JSON & Data Serialization**

- **1. JSON Serialization**

  - **Peran:** Mempelajari metode dasar untuk mengonversi data antara format JSON dan objek Dart.

  - **Detail:** Dart menyediakan pustaka `dart:convert` yang memiliki fungsi `json.decode()` dan `json.encode()` untuk menangani operasi ini. Namun, untuk objek yang kompleks atau bersarang, Anda perlu mendefinisikan bagaimana objek Dart dikonversi dari/ke JSON secara eksplisit.

  - **Manual JSON Parsing (`json.decode()` dan `json.encode()`):**

    - **`json.decode(String jsonString)`:** Mengambil _string_ JSON dan mengonversinya menjadi struktur data Dart (`Map<String, dynamic>` untuk objek JSON, `List<dynamic>` untuk _array_ JSON).
    - **`json.encode(Object dartObject)`:** Mengambil objek Dart (`Map` atau `List`) dan mengonversinya menjadi _string_ JSON.

  - **`fromJson()` dan `toJson()` methods:**

    - **Peran:** Ini adalah konvensi umum di Flutter/Dart untuk objek yang dapat di-_serialize_ atau di-_deserialize_. Anda akan menambahkan metode statis `fromJson(Map<String, dynamic> json)` dan metode `toJson()` ke kelas model Anda.
    - **`fromJson()`:** _Factory constructor_ yang bertanggung jawab untuk membuat _instance_ objek dari `Map` yang merupakan hasil _parsing_ JSON.
    - **`toJson()`:** Metode _instance_ yang bertanggung jawab untuk mengonversi _instance_ objek menjadi `Map` yang kemudian dapat di-_encode_ menjadi _string_ JSON.

  - **Contoh Kode (Manual Parsing dengan `fromJson`/`toJson`):**

  <!-- end list -->

  ```dart
  import 'dart:convert'; // Import untuk json.decode dan json.encode

  // Model data untuk Post
  class Post {
    final int id;
    final int userId;
    final String title;
    final String body;

    Post({
      required this.id,
      required this.userId,
      required this.title,
      required this.body,
    });

    // Factory constructor untuk membuat instance Post dari Map (JSON Deserialization)
    factory Post.fromJson(Map<String, dynamic> json) {
      return Post(
        id: json['id'] as int,
        userId: json['userId'] as int,
        title: json['title'] as String,
        body: json['body'] as String,
      );
    }

    // Metode untuk mengonversi instance Post ke Map (JSON Serialization)
    Map<String, dynamic> toJson() {
      return {
        'id': id,
        'userId': userId,
        'title': title,
        'body': body,
      };
    }

    @override
    String toString() {
      return 'Post(id: $id, userId: $userId, title: $title, body: $body)';
    }
  }

  // Contoh penggunaan:
  void demoManualSerialization() {
    // 1. Deserialization (JSON string ke objek Dart)
    const String jsonString = '''
      {
        "userId": 1,
        "id": 101,
        "title": "A new post title",
        "body": "This is the body of the new post."
      }
    ''';

    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final Post post = Post.fromJson(jsonMap);
    print('Deserialized Post: $post');
    print('Post Title: ${post.title}');

    // 2. Serialization (objek Dart ke JSON string)
    final Post newPost = Post(id: 201, userId: 2, title: 'My Awesome Post', body: 'Content here.');
    final Map<String, dynamic> newPostMap = newPost.toJson();
    final String encodedJson = json.encode(newPostMap);
    print('Serialized Post: $encodedJson');
  }

  /*
  // Cara memanggil dari widget:
  class SerializationDemoWidget extends StatelessWidget {
    const SerializationDemoWidget({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Manual JSON Serialization Demo')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => demoManualSerialization(),
            child: const Text('Run Manual Serialization Demo'),
          ),
        ),
      );
    }
  }
  */
  ```

  - **Nested Object Serialization:**
    - **Peran:** Menangani objek JSON yang berisi objek JSON lain di dalamnya.
    - **Detail:** Anda perlu mendefinisikan kelas Dart terpisah untuk setiap objek bersarang. Dalam metode `fromJson()`, Anda akan memanggil `fromJson()` dari kelas bersarang tersebut. Dalam metode `toJson()`, Anda akan memanggil `toJson()` dari objek bersarang.

  <!-- end list -->

  ```dart
  // Contoh model Address yang akan bersarang di User
  class Address {
    final String street;
    final String city;
    final String zipCode;

    Address({required this.street, required this.city, required this.zipCode});

    factory Address.fromJson(Map<String, dynamic> json) {
      return Address(
        street: json['street'] as String,
        city: json['city'] as String,
        zipCode: json['zipCode'] as String,
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'street': street,
        'city': city,
        'zipCode': zipCode,
      };
    }

    @override
    String toString() {
      return 'Address(street: $street, city: $city, zipCode: $zipCode)';
    }
  }

  // Model User dengan Address bersarang
  class User {
    final int id;
    final String name;
    final String email;
    final Address address; // Objek bersarang

    User({required this.id, required this.name, required this.email, required this.address});

    factory User.fromJson(Map<String, dynamic> json) {
      return User(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        // Panggil fromJson Address untuk objek bersarang
        address: Address.fromJson(json['address'] as Map<String, dynamic>),
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'id': id,
        'name': name,
        'email': email,
        // Panggil toJson Address untuk objek bersarang
        'address': address.toJson(),
      };
    }

    @override
    String toString() {
      return 'User(id: $id, name: $name, email: $email, address: $address)';
    }
  }

  void demoNestedSerialization() {
    const String jsonString = '''
      {
        "id": 1,
        "name": "John Doe",
        "email": "john.doe@example.com",
        "address": {
          "street": "123 Main St",
          "city": "Anytown",
          "zipCode": "12345"
        }
      }
    ''';

    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final User user = User.fromJson(jsonMap);
    print('\nDeserialized User with Nested Address: $user');
    print('User City: ${user.address.city}');

    final String encodedJson = json.encode(user.toJson());
    print('Serialized User with Nested Address: $encodedJson');
  }
  ```

  - **List Serialization:**
    - **Peran:** Mengonversi _array_ JSON menjadi `List` objek Dart, atau sebaliknya.
    - **Detail:** Untuk deserialisasi, Anda akan mengiterasi `List<dynamic>` yang dihasilkan oleh `json.decode()` dan memanggil `fromJson()` pada setiap elemen. Untuk serialisasi, Anda akan menggunakan `map()` untuk mengonversi setiap objek dalam `List` ke `Map` menggunakan `toJson()` mereka, lalu mengubahnya menjadi `List` lagi.

  <!-- end list -->

  ```dart
  // Menggunakan model Post yang sudah ada

  void demoListSerialization() {
    const String jsonListString = '''
      [
        {
          "userId": 1,
          "id": 1,
          "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
          "body": "quia et suscipit..."
        },
        {
          "userId": 1,
          "id": 2,
          "title": "qui est esse",
          "body": "est rerum tempore vitae..."
        }
      ]
    ''';

    // Deserialization List (JSON array ke List<Post>)
    final List<dynamic> jsonList = json.decode(jsonListString);
    final List<Post> posts = jsonList.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
    print('\nDeserialized List of Posts (Count: ${posts.length}):');
    posts.forEach(print);

    // Serialization List (List<Post> ke JSON array string)
    final List<Map<String, dynamic>> postMaps = posts.map((post) => post.toJson()).toList();
    final String encodedJsonList = json.encode(postMaps);
    print('Serialized List of Posts: $encodedJsonList');
  }

  void main() {
    demoManualSerialization();
    demoNestedSerialization();
    demoListSerialization();
  }
  ```

  - **Null Safety dalam JSON:**

    - **Peran:** Mengelola properti yang mungkin tidak ada atau bernilai `null` dalam data JSON.
    - **Detail:** Dengan Dart _null safety_, properti model Anda harus dideklarasikan sebagai _nullable_ (`String?`, `int?`). Saat _parsing_, Anda dapat menggunakan operator `as` dengan asumsi bahwa nilai tidak akan `null` jika Anda yakin, atau gunakan `??` untuk memberikan nilai _default_ jika _null_. Saat serialisasi, nilai `null` biasanya akan diabaikan oleh `json.encode` atau Anda bisa mengondisikannya dalam `toJson()`.

    <!-- end list -->

    ```dart
    // Contoh dengan Null Safety
    class Product {
      final int id;
      final String name;
      final double? price; // Price bisa null
      final String? description; // Description bisa null

      Product({required this.id, required this.name, this.price, this.description});

      factory Product.fromJson(Map<String, dynamic> json) {
        return Product(
          id: json['id'] as int,
          name: json['name'] as String,
          price: json['price'] as double?, // Tandai sebagai nullable
          description: json['description'] as String?, // Tandai sebagai nullable
        );
      }

      Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = {
          'id': id,
          'name': name,
        };
        if (price != null) {
          data['price'] = price;
        }
        if (description != null) {
          data['description'] = description;
        }
        return data;
      }

      @override
      String toString() {
        return 'Product(id: $id, name: $name, price: $price, description: $description)';
      }
    }

    void demoNullSafetySerialization() {
      const String jsonStringWithNulls = '''
        {
          "id": 10,
          "name": "Laptop XYZ",
          "description": null
        }
      ''';
      final Product product1 = Product.fromJson(json.decode(jsonStringWithNulls));
      print('\nProduct with null description: $product1');

      const String jsonStringMissingPrice = '''
        {
          "id": 11,
          "name": "Keyboard ABC"
        }
      ''';
      final Product product2 = Product.fromJson(json.decode(jsonStringMissingPrice));
      print('Product with missing price: $product2'); // price akan null

      final String encodedProduct1 = json.encode(product1.toJson());
      print('Encoded Product 1 (null description excluded): $encodedProduct1');

      final String encodedProduct2 = json.encode(product2.toJson());
      print('Encoded Product 2 (missing price excluded): $encodedProduct2');
    }
    ```

  - **Sumber Daya Tambahan:**

    - [JSON Serialization Guide](https://flutter.dev/docs/development/data/json/overview)

- **Visualisasi Konseptual: Alur JSON Serialization & Deserialization (Manual)**

  ```mermaid
  graph TD
      A[JSON String dari API] --> B{json.decode()};
      B --> C[Map<String, dynamic> atau List<dynamic>];
      C --> D{Factory Constructor .fromJson()};
      D --> E[Objek Dart (Model Data)];

      E --> F{Metode .toJson()};
      F --> G[Map<String, dynamic> atau List<Map<String, dynamic>>];
      G --> H{json.encode()};
      H --> I[JSON String untuk API];

      subgraph Deserialization
          A
          B
          C
          D
          E
      end

      subgraph Serialization
          E
          F
          G
          H
          I
      end
  ```

  **Penjelasan Visual:**
  Diagram ini menggambarkan proses bolak-balik antara _string_ JSON dan objek Dart.

  - **Deserialization (atas):** _String_ JSON dari API diubah menjadi `Map` atau `List` Dart oleh `json.decode()`, lalu `Map` tersebut digunakan oleh _factory constructor_ `fromJson()` untuk membuat _instance_ objek Dart yang terstruktur.
  - **Serialization (bawah):** Objek Dart Anda diubah menjadi `Map` oleh metode `toJson()`, lalu `Map` tersebut diubah menjadi _string_ JSON oleh `json.encode()` untuk dikirim ke API.

- **2. Code Generation untuk Serialization**

  - **Peran:** Mengotomatiskan proses pembuatan metode `fromJson()` dan `toJson()`. Ini sangat mengurangi _boilerplate code_, meminimalkan kesalahan, dan meningkatkan _developer productivity_, terutama untuk model data yang kompleks atau sering berubah.
  - **Detail:** _Package_ populer yang digunakan untuk _code generation_ JSON di Flutter adalah `json_serializable` bersama dengan `json_annotation`. Mereka bekerja dengan _package_ `build_runner`.
  - **Setup (`pubspec.yaml`):**

  <!-- end list -->

  ```yaml
  dependencies:
    flutter:
      sdk: flutter
    json_annotation: ^latest_version # Anotasi untuk model Anda

  dev_dependencies:
    build_runner: ^latest_version # Alat untuk menjalankan code generation
    json_serializable: ^latest_version # Generator kode untuk JSON serialization
  ```

  Setelah menambahkan, jalankan `flutter pub get`.

  - **`json_annotation` setup:**
    - **Peran:** Menyediakan anotasi yang Anda gunakan di kelas model Anda untuk memberi tahu `json_serializable` bagaimana menghasilkan kode.
    - **Anotasi Utama:**
      - `@JsonSerializable()`: Anotasi pada kelas model yang menandai bahwa kode serialisasi harus dihasilkan untuk kelas tersebut.
      - `@JsonKey(name: 'api_field_name')`: Digunakan pada properti jika nama _field_ JSON berbeda dari nama properti Dart.
      - `@JsonKey(defaultValue: someValue)`: Memberikan nilai _default_ jika _field_ JSON tidak ada atau `null`.
      - `@JsonEnum()`: Untuk serialisasi/deserialisasi `enum`.
  - **`json_serializable` configuration:**
    - **Peran:** Ini adalah _code generator_ sebenarnya yang membaca anotasi dari `json_annotation` dan menghasilkan kode Dart untuk serialisasi.
  - **Build runner usage:**
    - **Peran:** `build_runner` adalah alat baris perintah yang menjalankan _code generators_ (seperti `json_serializable`).
    - **Perintah:**
      - `flutter pub run build_runner build`: Menjalankan semua _code generators_ satu kali.
      - `flutter pub run build_runner watch`: Menjalankan _code generators_ secara terus-menerus dan otomatis setiap kali ada perubahan pada file sumber. Ini sangat disarankan selama pengembangan.
  - **Contoh Kode (dengan Code Generation):**

  <!-- end list -->

  ```dart
  import 'package:json_annotation/json_annotation.dart'; // Import anotasi

  part 'user.g.dart'; // File yang akan di-generate oleh json_serializable

  @JsonSerializable() // Anotasi kelas ini untuk code generation
  class UserGenerated {
    final int id;
    @JsonKey(name: 'full_name') // Jika nama field JSON berbeda
    final String name;
    final String email;
    final AddressGenerated address; // Objek bersarang

    UserGenerated({
      required this.id,
      required this.name,
      required this.email,
      required this.address,
    });

    // Factory constructor yang memanggil fungsi hasil generate
    factory UserGenerated.fromJson(Map<String, dynamic> json) => _$UserGeneratedFromJson(json);

    // Metode yang memanggil fungsi hasil generate
    Map<String, dynamic> toJson() => _$UserGeneratedToJson(this);

    @override
    String toString() {
      return 'UserGenerated(id: $id, name: $name, email: $email, address: $address)';
    }
  }

  @JsonSerializable()
  class AddressGenerated {
    final String street;
    final String city;
    @JsonKey(name: 'zip_code')
    final String zipCode;

    AddressGenerated({required this.street, required this.city, required this.zipCode});

    factory AddressGenerated.fromJson(Map<String, dynamic> json) => _$AddressGeneratedFromJson(json);
    Map<String, dynamic> toJson() => _$AddressGeneratedToJson(this);

    @override
    String toString() {
      return 'AddressGenerated(street: $street, city: $city, zipCode: $zipCode)';
    }
  }

  // Setelah membuat file di atas, jalankan:
  // flutter pub run build_runner build
  // atau
  // flutter pub run build_runner watch
  // Ini akan menghasilkan file 'user.g.dart' yang berisi implementasi _$UserGeneratedFromJson dan _$UserGeneratedToJson.

  void demoGeneratedSerialization() {
    // Contoh penggunaan (setelah user.g.dart dihasilkan)
    const String jsonString = '''
      {
        "id": 1,
        "full_name": "Jane Doe",
        "email": "jane.doe@example.com",
        "address": {
          "street": "456 Oak Ave",
          "city": "Someville",
          "zip_code": "98765"
        }
      }
    ''';

    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final UserGenerated user = UserGenerated.fromJson(jsonMap);
    print('\nDeserialized User (Generated): $user');

    final String encodedJson = json.encode(user.toJson());
    print('Serialized User (Generated): $encodedJson');
  }
  ```

  - **Custom JSON converters:**
    - **Peran:** Untuk properti yang memiliki tipe data yang tidak didukung secara langsung oleh `json_serializable` (misalnya, `DateTime` kustom, `Color`, atau tipe kompleks lainnya yang memerlukan logika serialisasi/deserialisasi non-standar).
    - **Detail:** Anda dapat membuat kelas yang mengimplementasikan `JsonConverter<T, S>` di mana `T` adalah tipe Dart dan `S` adalah tipe JSON yang sesuai. Kemudian terapkan `@JsonConverter` pada properti di model Anda.
  - **Generic serialization:**
    - **Peran:** Untuk model data yang menggunakan tipe generik (misalnya, `Response<T>`).
    - **Detail:** `json_serializable` dapat mendukung generik, tetapi Anda perlu menyediakan fungsi `fromJson` dan `toJson` untuk tipe generik pada saat _runtime_. Ini biasanya dilakukan dengan melewatkan fungsi deserialisasi tipe generik sebagai parameter.
  - **Sumber Daya Tambahan:**
    - [json_annotation Package](https://pub.dev/packages/json_annotation)
    - [json_serializable](https://pub.dev/packages/json_serializable)
    - [Build Runner](https://pub.dev/packages/build_runner)

- **Visualisasi Konseptual: Code Generation (json_serializable)**

  ```mermaid
  graph TD
      A[Kelas Model Dart Anda] -- @JsonSerializable() --> B[build_runner];
      B -- Membaca Anotasi --> C[json_serializable Generator];
      C --> D[File *.g.dart yang Dihasilkan];
      D --> E[Metode .fromJson() dan .toJson() Terotomatisasi];

      subgraph Development Workflow
          A
          B
          C
          D
          E
      end

      F[JSON String / Map] --> G{UserGenerated.fromJson()};
      G --> H[Objek UserGenerated];

      H --> I{userGeneratedInstance.toJson()};
      I --> J[JSON Map / String];

      subgraph Runtime Usage
          F
          G
          H
          I
          J
      end
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan bagaimana _code generation_ menyederhanakan proses.

  - **Workflow Pengembangan (atas):** Anda hanya menulis kelas model Dart dengan anotasi. `build_runner` kemudian menjalankan `json_serializable` yang menghasilkan file Dart baru (`.g.dart`) yang berisi semua logika `fromJson()` dan `toJson()`.
  - **Penggunaan Runtime (bawah):** Saat aplikasi berjalan, Anda cukup memanggil metode `fromJson()` dan `toJson()` yang telah dihasilkan secara otomatis, tanpa perlu menulis logika _parsing_ manual.

- **3. Advanced Serialization**

  - **Peran:** Memanfaatkan _package_ seperti `Freezed` untuk tidak hanya mengotomatiskan serialisasi JSON tetapi juga untuk menghasilkan kode _boilerplate_ lainnya untuk kelas model Anda, seperti _equality_, _hash code_, dan _copy-with_ _methods_, serta mendukung _union types_ (polymorphism).
  - **Detail:** `Freezed` bekerja secara sinergis dengan `json_serializable` dan `build_runner`. Ini sangat populer untuk membuat kelas model yang _immutable_ (_tidak dapat diubah_), yang merupakan praktik baik dalam Flutter untuk manajemen _state_ dan _performance_.
  - **Setup (`pubspec.yaml`):**

  <!-- end list -->

  ```yaml
  dependencies:
    flutter:
      sdk: flutter
    freezed_annotation: ^latest_version # Anotasi untuk Freezed
    json_annotation: ^latest_version # Anotasi untuk JSON

  dev_dependencies:
    build_runner: ^latest_version
    freezed: ^latest_version # Generator kode untuk Freezed
    json_serializable: ^latest_version
  ```

  Jalankan `flutter pub get`.

  - **Freezed untuk immutable classes:**
    - **Peran:** Memungkinkan Anda mendefinisikan kelas data sebagai _immutable_. Ini berarti setelah objek dibuat, _state_-nya tidak dapat diubah. Ini membantu dalam mencegah _bug_ yang terkait dengan perubahan _state_ yang tidak terduga.
    - **Detail:** Anda menggunakan `abstract class` dengan _factory constructors_ dan anotasi `@Freezed()`. `Freezed` akan menghasilkan kelas konkret untuk Anda.
  - **Union types dengan Freezed (Sealed Classes):**
    - **Peran:** Memungkinkan Anda mendefinisikan kelas dasar yang dapat memiliki beberapa _sub-tipe_ yang diskrit dan diketahui. Ini sangat berguna untuk merepresentasikan _state_ yang berbeda (misalnya, `LoadingState`, `LoadedState(data)`, `ErrorState(error)`).
    - **Detail:** Anda menggunakan beberapa _factory constructors_ di dalam satu kelas `Freezed` abstrak, masing-masing merepresentasikan _state_ atau _tipe_ yang berbeda. Kemudian Anda dapat menggunakan `when` atau `map` untuk menangani setiap _tipe_ secara berbeda.
  - **Copy-with methods:**
    - **Peran:** Dihasilkan secara otomatis oleh `Freezed`, memungkinkan Anda membuat _instance_ baru dari objek _immutable_ dengan memodifikasi hanya beberapa properti.
    - **Detail:** Anda memanggil `obj.copyWith(propertyName: newValue)`.
  - **Equality dan hashCode generation:**
    - **Peran:** `Freezed` secara otomatis menghasilkan implementasi yang benar dari `operator ==` dan `hashCode` berdasarkan semua properti kelas. Ini penting untuk perbandingan objek (misalnya, dalam `Set` atau sebagai _key_ dalam `Map`) dan untuk _widget_ yang bergantung pada _equality_ objek (misalnya, `const` _widget_).
  - **Contoh Kode (dengan Freezed dan JSON Serialization):**

  <!-- end list -->

  ```dart
  import 'package:freezed_annotation/freezed_annotation.dart';
  import 'package:json_annotation/json_annotation.dart';
  import 'dart:convert';

  part 'post_freezed.freezed.dart'; // File Freezed yang akan di-generate
  part 'post_freezed.g.dart';       // File JSON yang akan di-generate

  @freezed // Anotasi Freezed untuk menghasilkan boilerplate
  @JsonSerializable() // Anotasi JSON untuk serialization
  class PostFreezed with _$PostFreezed { // Perhatikan `with _$PostFreezed`
    const factory PostFreezed({
      required int id,
      required int userId,
      required String title,
      required String body,
    }) = _PostFreezed; // Ini adalah factory constructor utama

    // Factory constructor untuk fromJson
    factory PostFreezed.fromJson(Map<String, dynamic> json) => _$PostFreezedFromJson(json);
  }

  // Contoh Union Type/Sealed Class dengan Freezed (State Aplikasi)
  @freezed
  class AppState with _$AppState {
    const factory AppState.initial() = _InitialState;
    const factory AppState.loading() = _LoadingState;
    const factory AppState.loaded(List<PostFreezed> posts) = _LoadedState;
    const factory AppState.error(String message) = _ErrorState;

    // Tidak perlu fromJson/toJson untuk AppState jika hanya digunakan in-memory
    // Tapi bisa ditambahkan jika ingin serialize state.
  }

  // Setelah membuat file di atas, jalankan:
  // flutter pub run build_runner build
  // atau
  // flutter pub run build_runner watch
  // Ini akan menghasilkan file 'post_freezed.freezed.dart' dan 'post_freezed.g.dart'.

  void demoFreezedSerialization() {
    // Deserialization (setelah file .g.dart dan .freezed.dart dihasilkan)
    const String jsonString = '''
      {
        "id": 102,
        "userId": 5,
        "title": "Freezed Post Example",
        "body": "This post uses Freezed for immutability and JSON serialization."
      }
    ''';

    final PostFreezed post = PostFreezed.fromJson(json.decode(jsonString));
    print('\nDeserialized Freezed Post: $post');

    // Serialization
    final String encodedJson = json.encode(post.toJson());
    print('Serialized Freezed Post: $encodedJson');

    // Copy-with method
    final PostFreezed updatedPost = post.copyWith(title: 'Updated Freezed Title');
    print('Updated Post (via copyWith): $updatedPost');

    // Equality check
    print('Are posts equal (id, userId, title, body same)? ${post == updatedPost}'); // False, karena title berbeda
    print('Are posts equal (id, userId, body same)? ${post == post.copyWith()}'); // True, jika tanpa perubahan

    // Contoh Union Type usage
    const AppState state1 = AppState.loading();
    const AppState state2 = AppState.loaded([PostFreezed(id: 1, userId: 1, title: 'A', body: 'B')]);
    const AppState state3 = AppState.error('Network failed');

    state1.when(
      initial: () => print('App is in initial state.'),
      loading: () => print('App is loading data...'),
      loaded: (posts) => print('App loaded ${posts.length} posts.'),
      error: (message) => print('App encountered an error: $message'),
    ); // Output: App is loading data...

    state2.when(
      initial: () => print('App is in initial state.'),
      loading: () => print('App is loading data...'),
      loaded: (posts) => print('App loaded ${posts.length} posts.'),
      error: (message) => print('App encountered an error: $message'),
    ); // Output: App loaded 1 posts.
  }

  // main() di atas bisa diganti dengan:
  // void main() {
  //   demoManualSerialization();
  //   demoNestedSerialization();
  //   demoListSerialization();
  //   demoNullSafetySerialization();
  //   demoGeneratedSerialization(); // Pastikan file .g.dart sudah ada
  //   demoFreezedSerialization();   // Pastikan file .freezed.dart dan .g.dart sudah ada
  // }
  ```

  - **Sumber Daya Tambahan:**
    - [Freezed Package](https://pub.dev/packages/freezed)

---

Kita telah menyelesaikan pembahasan mendalam tentang **8.2 JSON & Data Serialization**, mulai dari metode manual hingga penggunaan _code generation_ dengan `json_serializable` dan `Freezed` untuk manajemen model data yang lebih canggih dan _immutable_. Selanjutnya, kita akan melanjutkan ke bagian **9. Local Data Storage**, yang akan membahas bagaimana menyimpan data langsung di perangkat pengguna. Kita akan memulai dengan **9.1 Key-Value Storage**.

---

#### **9. Local Data Storage**

- **Peran:** Setelah kita memahami bagaimana mengambil dan mengirim data melalui jaringan, penting juga untuk mengetahui bagaimana menyimpan data secara lokal di perangkat pengguna. `Local Data Storage` memungkinkan aplikasi Anda menyimpan _state_ pengguna, _cache_ data, preferensi, atau informasi sensitif, yang meningkatkan kinerja, menyediakan fungsionalitas _offline-first_, dan meningkatkan pengalaman pengguna secara keseluruhan.

---

##### **9.1 Key-Value Storage**

- **Gambaran Umum:** Ini adalah bentuk penyimpanan data lokal yang paling sederhana dan paling umum, di mana data disimpan sebagai pasangan kunci-nilai (_key-value pairs_). Ini cocok untuk menyimpan preferensi pengguna, _flag_ aplikasi, atau data kecil lainnya yang tidak memerlukan struktur relasional yang kompleks. Kita akan membahas dua _package_ utama: `SharedPreferences` untuk data non-sensitif, dan `flutter_secure_storage` untuk data yang memerlukan keamanan lebih tinggi.

---

###### **Key-Value Storage**

- **1. SharedPreferences**

  - **Peran:** Sebuah _wrapper_ di sekitar `NSUserDefaults` (iOS) dan `SharedPreferences` (Android). Ini adalah cara sederhana untuk menyimpan data _key-value_ primitif (_primitive key-value data_) secara persisten di disk. Ideal untuk preferensi pengguna (misalnya, tema gelap/terang, _toggle_ notifikasi) atau _flag_ aplikasi.

  - **Detail:** Data disimpan dalam format _key-value_ sederhana. Kunci selalu berupa `String`, dan nilai dapat berupa `int`, `double`, `bool`, `String`, atau `List<String>`.

  - **Setup (`pubspec.yaml`):**

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      shared_preferences: ^latest_version # Ganti dengan versi terbaru yang stabil
    ```

    Setelah menambahkan, jalankan `flutter pub get`.

  - **Basic Key-Value Operations:**

    - **`SharedPreferences.getInstance()`:** Mendapatkan _instance_ `SharedPreferences` (asynchronous). Anda perlu memanggilnya sekali sebelum menggunakan _instance_ tersebut.
    - **`setString(String key, String value)`:** Menyimpan _string_.
    - **`getInt(String key)`:** Mengambil _int_.
    - **`setBool(String key, bool value)`:** Menyimpan _boolean_.
    - **`getDouble(String key, double value)`:** Menyimpan _double_.
    - **`setStringList(String key, List<String> value)`:** Menyimpan daftar _string_.
    - **`remove(String key)`:** Menghapus data berdasarkan kunci.
    - **`clear()`:** Menghapus semua data yang disimpan oleh aplikasi.

  - **Data Type Support:**

    - `int`
    - `double`
    - `bool`
    - `String`
    - `List<String>`
    - **Catatan:** Untuk tipe data yang lebih kompleks (misalnya, objek kustom), Anda perlu mengubahnya menjadi _string_ JSON menggunakan `json.encode()` sebelum menyimpan, dan `json.decode()` saat mengambil.

  - **Async Operations:**

    - Semua operasi penyimpanan dan pengambilan di `SharedPreferences` bersifat _asynchronous_ dan mengembalikan `Future<bool>` (untuk operasi _set_) atau `Future<T>` (untuk operasi _get_). Oleh karena itu, Anda perlu menggunakan `await`.

  - **Contoh Kode (SharedPreferences):**

  <!-- end list -->

  ```dart
  import 'package:shared_preferences/shared_preferences.dart';
  import 'dart:convert'; // Untuk mengelola JSON jika menyimpan objek kompleks

  class UserSettings {
    static const String _keyThemeMode = 'theme_mode';
    static const String _keyNotificationEnabled = 'notification_enabled';
    static const String _keyUserName = 'user_name';
    static const String _keyRecentSearches = 'recent_searches';
    static const String _keyUserProfile = 'user_profile'; // Untuk menyimpan objek JSON

    // Inisialisasi SharedPreferences
    static Future<SharedPreferences> _getInstance() async {
      return await SharedPreferences.getInstance();
    }

    // Menyimpan preferensi tema (String)
    static Future<bool> setThemeMode(String mode) async {
      final prefs = await _getInstance();
      return prefs.setString(_keyThemeMode, mode);
    }

    // Mengambil preferensi tema
    static Future<String?> getThemeMode() async {
      final prefs = await _getInstance();
      return prefs.getString(_keyThemeMode);
    }

    // Menyimpan status notifikasi (Boolean)
    static Future<bool> setNotificationEnabled(bool enabled) async {
      final prefs = await _getInstance();
      return prefs.setBool(_keyNotificationEnabled, enabled);
    }

    // Mengambil status notifikasi
    static Future<bool?> getNotificationEnabled() async {
      final prefs = await _getInstance();
      return prefs.getBool(_keyNotificationEnabled);
    }

    // Menyimpan nama pengguna (String)
    static Future<bool> setUserName(String name) async {
      final prefs = await _getInstance();
      return prefs.setString(_keyUserName, name);
    }

    // Mengambil nama pengguna
    static Future<String?> getUserName() async {
      final prefs = await _getInstance();
      return prefs.getString(_keyUserName);
    }

    // Menyimpan daftar pencarian terbaru (List<String>)
    static Future<bool> setRecentSearches(List<String> searches) async {
      final prefs = await _getInstance();
      return prefs.setStringList(_keyRecentSearches, searches);
    }

    // Mengambil daftar pencarian terbaru
    static Future<List<String>?> getRecentSearches() async {
      final prefs = await _getInstance();
      return prefs.getStringList(_keyRecentSearches);
    }

    // Menyimpan objek kustom (misalnya, UserProfile) sebagai JSON string
    // Asumsi ada class UserProfile dengan fromJson dan toJson
    static Future<bool> saveUserProfile(Map<String, dynamic> userProfileData) async {
      final prefs = await _getInstance();
      String jsonString = json.encode(userProfileData);
      return prefs.setString(_keyUserProfile, jsonString);
    }

    // Mengambil objek kustom dari JSON string
    static Future<Map<String, dynamic>?> getUserProfile() async {
      final prefs = await _getInstance();
      String? jsonString = prefs.getString(_keyUserProfile);
      if (jsonString != null) {
        return json.decode(jsonString) as Map<String, dynamic>;
      }
      return null;
    }

    // Menghapus sebuah kunci
    static Future<bool> removeKey(String key) async {
      final prefs = await _getInstance();
      return prefs.remove(key);
    }

    // Menghapus semua data aplikasi
    static Future<bool> clearAllData() async {
      final prefs = await _getInstance();
      return prefs.clear();
    }
  }

  // Contoh penggunaan dalam main atau widget:
  /*
  import 'package:flutter/material.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized(); // Wajib jika SharedPreferences di main()

    await UserSettings.setThemeMode('dark');
    print('Theme Mode: ${await UserSettings.getThemeMode()}');

    await UserSettings.setNotificationEnabled(true);
    print('Notifications Enabled: ${await UserSettings.getNotificationEnabled()}');

    await UserSettings.setUserName('Al-Khawarizmi');
    print('User Name: ${await UserSettings.getUserName()}');

    await UserSettings.setRecentSearches(['Flutter', 'Dart', 'OpenAI']);
    print('Recent Searches: ${await UserSettings.getRecentSearches()}');

    await UserSettings.saveUserProfile({'name': 'Ibnu Sina', 'age': 45, 'city': 'Bukhara'});
    print('User Profile: ${await UserSettings.getUserProfile()}');

    await UserSettings.removeKey(UserSettings._keyUserName);
    print('User Name after removal: ${await UserSettings.getUserName()}');

    // await UserSettings.clearAllData(); // Hati-hati menggunakan ini di produksi

    runApp(MyApp());
  }

  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('SharedPreferences Demo')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String? theme = await UserSettings.getThemeMode();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Current Theme: $theme')));
                  },
                  child: const Text('Show Theme'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await UserSettings.setThemeMode('light');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Theme set to light')));
                  },
                  child: const Text('Set Theme to Light'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
  */
  ```

  - **Prefix Strategies:**

    - **Peran:** Menggunakan awalan (_prefix_) untuk kunci-kunci Anda (misalnya, `user_`, `app_settings_`) untuk mengelompokkan data dan menghindari potensi tabrakan kunci, terutama dalam aplikasi besar atau saat menggunakan banyak modul.
    - **Contoh:** `user_id`, `app_settings_darkMode`, `feature_flag_x`.

  - **Migration Strategies:**

    - **Peran:** Menangani perubahan pada struktur data yang disimpan di `SharedPreferences` saat aplikasi diperbarui ke versi baru.
    - **Detail:** Jika Anda mengubah kunci atau format data, aplikasi versi lama mungkin memiliki data yang tidak kompatibel. Anda bisa:
      - **Bump Version:** Simpan nomor versi aplikasi di `SharedPreferences` juga. Saat aplikasi dimulai, periksa versi. Jika versi yang disimpan lebih rendah dari versi aplikasi saat ini, jalankan logika migrasi (misalnya, menghapus kunci lama, memformat ulang data).
      - **Default Values:** Selalu sediakan nilai _default_ saat mengambil data, jika kunci tidak ada.
      - **Clear and Re-populate:** Dalam kasus ekstrem (dan hanya jika data tidak krusial), Anda bisa menghapus semua data dan membiarkan aplikasi membuatnya kembali.

  - **Sumber Daya Tambahan:**

    - [SharedPreferences Guide](https://flutter.dev/docs/cookbook/persistence/key-value)
    - [SharedPreferences Package](https://pub.dev/packages/shared_preferences)

- **Visualisasi Konseptual: SharedPreferences**

  ```mermaid
  graph TD
      A[Aplikasi Flutter] --> B{SharedPreferences.getInstance()};
      B --> C[Instance SharedPreferences];

      C -- setString('key', 'value') --> D[Penyimpanan Persisten (Disk)];
      C -- getInt('key') --> D;

      subgraph Perangkat
          D
      end

      style A fill:#f9f,stroke:#333,stroke-width:2px
      style B fill:#bbf,stroke:#333,stroke-width:2px
      style C fill:#ccf,stroke:#333,stroke-width:2px
      style D fill:#ddf,stroke:#333,stroke-width:2px
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan `SharedPreferences` sebagai jembatan antara aplikasi Flutter Anda dan penyimpanan persisten (disk) di perangkat. Anda mendapatkan _instance_, lalu menggunakan metode `set` untuk menyimpan data dan `get` untuk mengambil data, semuanya dalam format _key-value_ sederhana.

- **2. Secure Storage (`flutter_secure_storage`)**

  - **Peran:** Mirip dengan `SharedPreferences` tetapi dirancang khusus untuk menyimpan data sensitif seperti _token_ autentikasi, kata sandi, atau kunci API. Ini menggunakan mekanisme penyimpanan aman yang disediakan oleh OS (_Keychain_ di iOS, _Keystore_ di Android) untuk mengenkripsi data.

  - **Detail:** Karena data dienkripsi, ini lebih lambat daripada `SharedPreferences`, dan harus digunakan hanya untuk data yang benar-benar memerlukan perlindungan.

  - **Setup (`pubspec.yaml`):**

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      flutter_secure_storage: ^latest_version # Ganti dengan versi terbaru yang stabil
    ```

    Setelah menambahkan, jalankan `flutter pub get`.

    **Konfigurasi Platform-Specific:**

    - **Android:** Tambahkan baris ini ke `android/app/build.gradle` di `android { defaultConfig { ... } }`
      ```gradle
      minSdkVersion 21 // Minimum SDK 21 diperlukan
      ```
    - **iOS:** Tidak ada konfigurasi khusus yang biasanya diperlukan. Pastikan _Keychain Sharing_ diaktifkan di Xcode jika Anda mengalami masalah (biasanya di `Signing & Capabilities`).

  - **Keychain/Keystore Integration:**

    - **iOS:** Menggunakan _Keychain_ iOS, yang secara otomatis menangani enkripsi dan dekripsi menggunakan kunci yang dilindungi oleh _Secure Enclave_ perangkat.
    - **Android:** Menggunakan _Android Keystore System_ yang menyediakan cara untuk menghasilkan dan menyimpan kunci kriptografi dalam wadah yang aman.

  - **Basic Operations:**

    - **`FlutterSecureStorage()`:** Membuat _instance_ dari _storage_.
    - **`write({required String key, required String? value})`:** Menyimpan pasangan kunci-nilai. `value` bisa `null`.
    - **`read({required String key})`:** Mengambil nilai berdasarkan kunci. Mengembalikan `null` jika kunci tidak ditemukan.
    - **`delete({required String key})`:** Menghapus sebuah kunci.
    - **`deleteAll()`:** Menghapus semua data yang disimpan oleh _package_.
    - **`readAll()`:** Mengambil semua pasangan kunci-nilai yang disimpan.
    - Semua operasi bersifat _asynchronous_.

  - **Biometric Authentication (Konseptual):**

    - Meskipun `flutter_secure_storage` menyimpan data dengan aman, untuk akses data yang dilindungi oleh biometrik (sidik jari, _face ID_), Anda akan menggabungkannya dengan _package_ seperti `local_auth`. Alurnya adalah:
      1.  Simpan token sensitif dengan `flutter_secure_storage`.
      2.  Saat ingin mengakses token, gunakan `local_auth` untuk mengautentikasi pengguna secara biometrik.
      3.  Jika autentikasi berhasil, baru ambil token dari `flutter_secure_storage`.

  - **Encryption Keys Storage:**

    - `flutter_secure_storage` secara _default_ akan mengelola kunci enkripsi untuk Anda di _keychain_/ _keystore_. Anda tidak perlu mengelola kunci enkripsi secara manual.

  - **Secure Preferences:**

    - Konsep `secure preferences` mengacu pada penggunaan `flutter_secure_storage` untuk menyimpan preferensi pengguna yang dianggap sensitif, yang tidak boleh disimpan dalam teks biasa.

  - **Platform-specific implementations:**

    - _Keychain_ di iOS dan _Keystore_ di Android adalah implementasi dasar yang digunakan oleh _package_ ini. Mereka menawarkan tingkat keamanan yang sangat tinggi, seringkali melibatkan perangkat keras khusus untuk melindungi kunci enkripsi.

  - **Contoh Kode (flutter_secure_storage):**

  <!-- end list -->

  ```dart
  import 'package:flutter_secure_storage/flutter_secure_storage.dart';

  class SecureStorageService {
    final FlutterSecureStorage _storage = const FlutterSecureStorage();

    static const String _keyAuthToken = 'auth_token';
    static const String _keyApiKey = 'api_key';

    // Menyimpan token otentikasi
    Future<void> saveAuthToken(String token) async {
      await _storage.write(key: _keyAuthToken, value: token);
      print('Auth Token saved securely.');
    }

    // Mengambil token otentikasi
    Future<String?> getAuthToken() async {
      String? token = await _storage.read(key: _keyAuthToken);
      print('Auth Token retrieved securely: ${token?.substring(0, 5)}...'); // Cetak sebagian saja
      return token;
    }

    // Menyimpan kunci API
    Future<void> saveApiKey(String key) async {
      await _storage.write(key: _keyApiKey, value: key);
      print('API Key saved securely.');
    }

    // Mengambil kunci API
    Future<String?> getApiKey() async {
      String? key = await _storage.read(key: _keyApiKey);
      print('API Key retrieved securely: ${key?.substring(0, 5)}...');
      return key;
    }

    // Menghapus token otentikasi
    Future<void> deleteAuthToken() async {
      await _storage.delete(key: _keyAuthToken);
      print('Auth Token deleted securely.');
    }

    // Menghapus semua data aman yang disimpan oleh aplikasi ini
    Future<void> deleteAllSecureData() async {
      await _storage.deleteAll();
      print('All secure data deleted.');
    }
  }

  // Contoh penggunaan dalam widget:
  /*
  import 'package:flutter/material.dart';

  class SecureStorageDemoWidget extends StatefulWidget {
    const SecureStorageDemoWidget({super.key});

    @override
    State<SecureStorageDemoWidget> createState() => _SecureStorageDemoWidgetState();
  }

  class _SecureStorageDemoWidgetState extends State<SecureStorageDemoWidget> {
    final SecureStorageService _secureStorageService = SecureStorageService();
    String? _authToken;
    String? _apiKey;

    @override
    void initState() {
      super.initState();
      _loadSecureData();
    }

    Future<void> _loadSecureData() async {
      _authToken = await _secureStorageService.getAuthToken();
      _apiKey = await _secureStorageService.getApiKey();
      setState(() {}); // Perbarui UI
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Secure Storage Demo')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Auth Token: ${_authToken ?? "Not Set"}'),
              Text('API Key: ${_apiKey ?? "Not Set"}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _secureStorageService.saveAuthToken('super_secret_jwt_token_12345');
                  _loadSecureData();
                },
                child: const Text('Save Auth Token'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _secureStorageService.saveApiKey('my_api_key_for_service_XYZ');
                  _loadSecureData();
                },
                child: const Text('Save API Key'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _secureStorageService.deleteAuthToken();
                  _loadSecureData();
                },
                child: const Text('Delete Auth Token'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _secureStorageService.deleteAllSecureData();
                  _loadSecureData();
                },
                child: const Text('Delete All Secure Data'),
              ),
            ],
          ),
        ),
      );
    }
  }
  */
  ```

  - **Sumber Daya Tambahan:**
    - [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
    - [Secure Storage Guide](https://docs.flutter.dev/data-and-backend/data-storage/shared-preferences%23secure-storage) (Ini adalah bagian dari dokumentasi Flutter yang membahasnya)

---

### **Perbedaan antara `SharedPreferences` dan `flutter_secure_storage`**

Meskipun keduanya digunakan untuk menyimpan data _key-value_ secara lokal, ada perbedaan fundamental dalam tujuan dan mekanisme keamanannya:

1.  **Tujuan Utama:**

    - **`SharedPreferences`**: Dirancang untuk menyimpan preferensi pengguna yang sederhana, _flag_ aplikasi, atau data non-sensitif lainnya yang tidak memerlukan tingkat keamanan tinggi. Contoh: tema aplikasi (gelap/terang), status notifikasi, _last selected tab_.
    - **`flutter_secure_storage`**: Dirancang khusus untuk menyimpan data sensitif seperti _token_ otentikasi, kredensial pengguna, kunci API, atau informasi pribadi lainnya yang harus dilindungi dari akses tidak sah.

2.  **Mekanisme Keamanan:**

    - **`SharedPreferences`**: Data disimpan dalam format teks biasa (tidak dienkripsi) di perangkat. Meskipun tidak mudah diakses oleh aplikasi lain, data ini dapat ditemukan dan dibaca jika perangkat di-_root_ atau di-_jailbreak_, atau jika ada kerentanan keamanan lain. Ini menggunakan `NSUserDefaults` di iOS dan `SharedPreferences` di Android.
    - **`flutter_secure_storage`**: Data dienkripsi sebelum disimpan dan didekripsi saat diambil. Ini memanfaatkan mekanisme penyimpanan aman yang disediakan oleh sistem operasi:
      - **iOS**: Menggunakan _Keychain_.
      - **Android**: Menggunakan _Android Keystore System_.
        Mekanisme ini menyediakan isolasi yang kuat dan seringkali melibatkan _hardware security modules_ untuk melindungi kunci enkripsi, membuatnya jauh lebih aman daripada `SharedPreferences`.

3.  **Kinerja:**

    - **`SharedPreferences`**: Karena tidak ada proses enkripsi/dekripsi, operasinya cenderung lebih cepat.
    - **`flutter_secure_storage`**: Proses enkripsi dan dekripsi menambahkan _overhead_, sehingga operasionalnya sedikit lebih lambat dibandingkan `SharedPreferences`. Oleh karena itu, tidak disarankan untuk menyimpan data dalam jumlah besar atau yang sering diakses dengan _package_ ini.

4.  **Tipe Data yang Didukung:**

    - **`SharedPreferences`**: Mendukung tipe data primitif secara langsung (`int`, `double`, `bool`, `String`, `List<String>`). Untuk objek kompleks, Anda harus mengonversinya menjadi _string_ JSON secara manual.
    - **`flutter_secure_storage`**: Hanya mendukung penyimpanan `String` sebagai nilai. Jika Anda perlu menyimpan data non-string (misalnya, angka atau objek), Anda harus mengonversinya menjadi `String` (misalnya, dengan JSON _encoding_) sebelum menyimpan, dan mengonversinya kembali saat mengambil.

5.  **Penggunaan Umum:**
    - **`SharedPreferences`**: Ideal untuk _user preferences_, _app settings_, _onboarding status_.
    - **`flutter_secure_storage`**: Ideal untuk _authentication tokens_ (JWT), _API keys_, _user credentials_, data kartu kredit yang sangat sensitif.

Singkatnya, gunakan `SharedPreferences` untuk kenyamanan dan kinerja saat menyimpan data non-sensitif, dan gunakan `flutter_secure_storage` saat keamanan adalah prioritas utama untuk data sensitif.

Kita telah meninjau **9.1 Key-Value Storage** dengan dua _package_ utamanya: `SharedPreferences` untuk data non-sensitif dan `flutter_secure_storage` untuk data sensitif yang membutuhkan enkripsi. Selanjutnya, kita akan melanjutkan pembahasan **Local Data Storage** dengan topik **9.2 Database Solutions**, yang akan menyelami solusi basis data yang lebih terstruktur untuk aplikasi Flutter.

#### **9. Local Data Storage (Lanjutan)**

##### **9.2 Database Solutions**

- **Peran:** Untuk aplikasi yang perlu menyimpan data terstruktur dalam jumlah besar, atau data yang memiliki hubungan kompleks antar entitas (misalnya, daftar produk, detail pelanggan, riwayat transaksi), solusi basis data lokal jauh lebih efisien dan terorganisir dibandingkan _key-value storage_. Ini memungkinkan kueri yang kompleks, manajemen data yang lebih baik, dan performa yang lebih optimal untuk data yang sering diakses atau dimodifikasi.

---

###### **Database Solutions**

- **1. SQLite Integration**

  - **Peran:** SQLite adalah mesin basis data relasional _open-source_ yang ringan, mandiri (_self-contained_), dan tanpa server (_serverless_). Ini adalah pilihan yang sangat populer untuk aplikasi _mobile_ karena kemudahannya dalam penggunaan dan jejak memorinya yang kecil. Di Flutter, kita sering menggunakan _package_ `sqflite` sebagai _plugin_ untuk berinteraksi dengan basis data SQLite di platform Android dan iOS.

  - **Detail:** SQLite menyimpan seluruh basis data dalam satu file di disk. Anda berinteraksi dengannya menggunakan SQL (_Structured Query Language_) standar.

  - **Setup (`pubspec.yaml`):**

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      sqflite: ^latest_version # Ganti dengan versi terbaru yang stabil
      path_provider: ^latest_version # Membantu menemukan direktori untuk DB
      path: ^latest_version # Membantu dalam manipulasi path
    ```

    Setelah menambahkan, jalankan `flutter pub get`.

  - **Database Creation dan Migrations:**

    - **Peran:** Menginisialisasi basis data dan menangani perubahan skema basis data antar versi aplikasi.
    - **Detail:** Anda biasanya membuka basis data menggunakan `openDatabase()`. Di dalam `onCreate` _callback_, Anda menentukan tabel dan kolom awal. Untuk _migrasi_, Anda menggunakan `onUpgrade` _callback_ untuk menjalankan perintah SQL yang memodifikasi skema basis data saat versi basis data berubah.

  - **CRUD Operations (Create, Read, Update, Delete):**

    - **Peran:** Operasi dasar untuk mengelola data dalam tabel basis data.
    - **Detail:**
      - **CREATE (Insert):** Menambahkan baris baru ke tabel.
      - **READ (Query):** Mengambil data dari tabel.
      - **UPDATE:** Memodifikasi baris yang ada di tabel.
      - **DELETE:** Menghapus baris dari tabel.

  - **Contoh Kode (SQFlite):**

  <!-- end list -->

  ```dart
  import 'package:sqflite/sqflite.dart';
  import 'package:path/path.dart'; // Untuk join
  import 'package:path_provider/path_provider.dart'; // Untuk getApplicationDocumentsDirectory

  // Model data untuk Todo
  class Todo {
    int? id; // Nullable karena akan di-generate oleh DB
    String title;
    String description;
    bool isDone;

    Todo({this.id, required this.title, this.description = '', this.isDone = false});

    // Konversi Todo menjadi Map untuk disimpan ke DB
    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'title': title,
        'description': description,
        'isDone': isDone ? 1 : 0, // SQLite tidak punya boolean, pakai 0/1
      };
    }

    // Konversi Map dari DB menjadi objek Todo
    factory Todo.fromMap(Map<String, dynamic> map) {
      return Todo(
        id: map['id'] as int?,
        title: map['title'] as String,
        description: map['description'] as String,
        isDone: map['isDone'] == 1,
      );
    }

    @override
    String toString() {
      return 'Todo{id: $id, title: $title, description: $description, isDone: $isDone}';
    }
  }

  class TodoDatabase {
    static Database? _database; // Instance database
    static const String _tableName = 'todos';
    static const String _databaseName = 'todo_app.db';
    static const int _databaseVersion = 1;

    Future<Database> get database async {
      if (_database != null) return _database!;
      _database = await _initDB();
      return _database!;
    }

    Future<Database> _initDB() async {
      // Mendapatkan path direktori dokumen aplikasi
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, _databaseName); // Menggabungkan path dengan nama DB

      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: (db, version) async {
          // Membuat tabel 'todos' saat DB pertama kali dibuat
          await db.execute(
            '''
            CREATE TABLE $_tableName(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              description TEXT,
              isDone INTEGER
            )
            ''',
          );
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          // Logika migrasi jika versi DB berubah
          if (oldVersion < 2) {
            // Contoh: Tambah kolom baru di versi 2
            // await db.execute("ALTER TABLE $_tableName ADD COLUMN new_column TEXT;");
          }
        },
      );
    }

    // --- CRUD Operations ---

    // Create: Menambahkan todo baru
    Future<int> insertTodo(Todo todo) async {
      final db = await database;
      return await db.insert(
        _tableName,
        todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace, // Ganti jika ID sama
      );
    }

    // Read: Mengambil semua todos
    Future<List<Todo>> getTodos() async {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(_tableName);
      return List.generate(maps.length, (i) {
        return Todo.fromMap(maps[i]);
      });
    }

    // Read: Mengambil todo berdasarkan ID
    Future<Todo?> getTodoById(int id) async {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return Todo.fromMap(maps.first);
      }
      return null;
    }

    // Update: Memperbarui todo yang sudah ada
    Future<int> updateTodo(Todo todo) async {
      final db = await database;
      return await db.update(
        _tableName,
        todo.toMap(),
        where: 'id = ?',
        whereArgs: [todo.id],
      );
    }

    // Delete: Menghapus todo
    Future<int> deleteTodo(int id) async {
      final db = await database;
      return await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    }

    // Menutup database (penting untuk membebaskan sumber daya)
    Future<void> close() async {
      final db = await database;
      db.close();
      _database = null; // Reset instance
    }
  }

  // Contoh penggunaan dalam main atau widget:
  /*
  import 'package:flutter/material.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    final todoDb = TodoDatabase();

    // Demo penggunaan
    await todoDb.insertTodo(Todo(title: 'Belajar Flutter', description: 'Fase 6: Database', isDone: false));
    await todoDb.insertTodo(Todo(title: 'Siapkan Sarapan', isDone: true));

    List<Todo> allTodos = await todoDb.getTodos();
    print('All Todos: $allTodos');

    Todo? firstTodo = await todoDb.getTodoById(1);
    if (firstTodo != null) {
      firstTodo.isDone = true;
      await todoDb.updateTodo(firstTodo);
      print('Updated Todo 1: ${await todoDb.getTodoById(1)}');
    }

    await todoDb.deleteTodo(2);
    print('Todos after deletion: ${await todoDb.getTodos()}');

    await todoDb.close(); // Penting untuk menutup DB

    runApp(MyApp());
  }

  class MyApp extends StatelessWidget {
    final TodoDatabase _todoDb = TodoDatabase();

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('SQFlite Demo')),
          body: FutureBuilder<List<Todo>>(
            future: _todoDb.getTodos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No todos yet.'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final todo = snapshot.data![index];
                    return ListTile(
                      title: Text(todo.title),
                      subtitle: Text(todo.description),
                      trailing: Checkbox(
                        value: todo.isDone,
                        onChanged: (bool? newValue) async {
                          if (newValue != null) {
                            todo.isDone = newValue;
                            await _todoDb.updateTodo(todo);
                            // Refresh UI (trigger FutureBuilder rebuild)
                            (context as Element).markNeedsBuild();
                          }
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await _todoDb.insertTodo(Todo(title: 'New Task ${DateTime.now().second}'));
              // Refresh UI
              (context as Element).markNeedsBuild();
            },
            child: const Icon(Icons.add),
          ),
        ),
      );
    }
  }
  */
  ```

  - **Complex Queries dan Joins:**

    - **Peran:** Melakukan kueri SQL yang lebih canggih untuk mengambil data berdasarkan kriteria tertentu, mengurutkan hasil, membatasi jumlah hasil, atau menggabungkan data dari beberapa tabel (menggunakan `JOIN`).
    - **Detail:** `sqflite` memungkinkan Anda mengeksekusi _raw SQL queries_ atau menggunakan metode _helper_ seperti `query`, `rawQuery`, `update`, `rawUpdate`, dll.
    - **Contoh (Konseptual):**

      ```dart
      // SELECT * FROM todos WHERE isDone = 1 ORDER BY title ASC LIMIT 10;
      final completedTodos = await db.query(
        _tableName,
        where: 'isDone = ?',
        whereArgs: [1],
        orderBy: 'title ASC',
        limit: 10,
      );

      // SELECT t.title, u.name FROM todos t JOIN users u ON t.userId = u.id;
      // Ini akan membutuhkan dua tabel dan query manual
      final results = await db.rawQuery(
        'SELECT t.title, u.name FROM todos t JOIN users u ON t.userId = u.id'
      );
      ```

  - **Transactions:**

    - **Peran:** Memastikan bahwa serangkaian operasi basis data diperlakukan sebagai satu unit tunggal. Jika ada bagian dari unit tersebut gagal, seluruh operasi akan dibatalkan (_rolled back_), memastikan integritas data.
    - **Detail:** Gunakan metode `db.transaction(() async { ... })`. Jika ada _exception_ di dalam blok, transaksi akan dibatalkan secara otomatis.

    <!-- end list -->

    ```dart
    Future<void> performComplexOperationsInTransaction() async {
      final db = await database;
      await db.transaction((txn) async {
        // Operasi 1: Update todo
        await txn.update(
          _tableName,
          {'title': 'Updated in Transaction'},
          where: 'id = ?',
          whereArgs: [1],
        );
        print('Todo 1 updated in transaction.');

        // Operasi 2: Insert todo baru
        await txn.insert(
          _tableName,
          Todo(title: 'New Task Txn', description: 'From transaction').toMap(),
        );
        print('New todo inserted in transaction.');

        // Jika ada error di sini, semua perubahan di atas akan dibatalkan.
        // throw Exception('Simulating a failure!');
      });
      print('Transaction completed successfully!');
    }
    ```

  - **Database Versioning:**

    - **Peran:** Mengelola perubahan skema basis data dari satu versi aplikasi ke versi berikutnya. Setiap kali Anda memodifikasi struktur tabel (misalnya, menambah kolom, mengubah tipe data), Anda harus meningkatkan nomor versi basis data.
    - **Detail:** `onUpgrade` _callback_ dalam `openDatabase` digunakan untuk menangani ini. Anda menulis logika SQL di dalamnya untuk memigrasi basis data dari `oldVersion` ke `newVersion`.

  - **Performance Optimization:**

    - **Peran:** Meningkatkan kecepatan dan efisiensi operasi basis data.
    - **Detail:**
      - **Indeks:** Membuat indeks pada kolom yang sering digunakan dalam klausa `WHERE`, `ORDER BY`, atau `JOIN` dapat secara drastis mempercepat kueri.
      - **Batch Operations:** Untuk banyak operasi `INSERT`, `UPDATE`, atau `DELETE`, gunakan `db.batch()` untuk menggabungkan beberapa perintah menjadi satu transaksi yang efisien.
      - **Asynchronous Operations:** Pastikan semua operasi basis data dijalankan secara _asynchronous_ (`await`) agar tidak memblokir UI.
      - **Minimal Data Retrieval:** Hanya ambil kolom yang benar-benar Anda butuhkan.

  - **Sumber Daya Tambahan:**

    - [SQLite Tutorial](https://www.sqlite.org/docs.html) (Dokumentasi resmi SQLite)
    - [SQFlite Package](https://pub.dev/packages/sqflite)

- **Visualisasi Konseptual: SQLite Database**

  ```mermaid
  graph TD
      A[Aplikasi Flutter] -- Panggil Metode DB --> B{SQFlite Plugin};
      B -- SQL Commands (CREATE, INSERT, SELECT, UPDATE, DELETE) --> C[SQLite Engine];
      C -- Simpan/Baca Data --> D[File Database (.db) di Disk];

      subgraph Perangkat Pengguna
          B
          C
          D
      end
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan bagaimana `SQFlite` bertindak sebagai perantara antara aplikasi Flutter dan mesin basis data SQLite yang menyimpan data Anda dalam satu file `.db` di perangkat. Aplikasi mengirimkan perintah SQL melalui `SQFlite`, yang kemudian dieksekusi oleh mesin SQLite.

---

- **2. Drift (Moor) ORM**

  - **Peran:** Drift (sebelumnya Moor) adalah _Object-Relational Mapper_ (ORM) yang kuat dan _reactive_ untuk SQLite di Flutter, Dart, dan bahkan browser. ORM memungkinkan Anda berinteraksi dengan basis data menggunakan objek Dart daripada menulis _raw SQL queries_, yang meningkatkan _type-safety_ dan mengurangi _boilerplate code_.

  - **Detail:** Drift menggunakan _code generation_ untuk menghasilkan kode basis data berdasarkan definisi tabel Dart Anda. Ini menawarkan kueri yang aman tipe, _stream_ data _reactive_, dan sistem migrasi yang komprehensif.

  - **Setup (`pubspec.yaml`):**

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      drift: ^latest_version # ORM utama
      sqlite3_flutter_libs: ^latest_version # Library SQLite native
      path_provider: ^latest_version
      path: ^latest_version
      # tambahkan dependencies tambahan jika menggunakan ffi atau platform spesifik

    dev_dependencies:
      build_runner: ^latest_version
      drift_dev: ^latest_version # Generator kode untuk Drift
    ```

    Setelah menambahkan, jalankan `flutter pub get`.

  - **Table Definitions:**

    - **Peran:** Mendefinisikan struktur tabel basis data Anda menggunakan kelas Dart yang diekstensi dari `Table`. Ini adalah dasar dari pendekatan ORM.
    - **Detail:** Anda mendefinisikan kolom sebagai properti dari kelas `Table` Anda (misalnya, `IntColumn`, `TextColumn`).

  - **Query Builder:**

    - **Peran:** Membangun kueri basis data menggunakan API Dart yang _type-safe_ daripada _string_ SQL. Ini mengurangi kemungkinan kesalahan _syntax_ SQL dan memungkinkan IDE untuk memberikan _autocompletion_ dan pemeriksaan kesalahan.
    - **Detail:** Anda akan menggunakan metode seperti `select()`, `update()`, `insert()`, `delete()` pada objek basis data Anda, diikuti dengan metode seperti `where()`, `orderBy()`, `limit()`.

  - **Type-safe Queries:**

    - **Peran:** Karena definisi tabel dan kueri dilakukan dalam Dart, _compiler_ dapat memeriksa tipe data dan nama kolom pada waktu kompilasi, bukan hanya saat _runtime_. Ini mengurangi _bug_ yang terkait dengan ketidakcocokan tipe atau kesalahan penulisan nama kolom.

  - **Migration System:**

    - **Peran:** Drift menyediakan sistem migrasi yang kuat untuk mengelola perubahan skema basis data dengan aman.
    - **Detail:** Anda mendefinisikan migrasi secara imperatif (dengan kode Dart) dalam metode `onUpgrade` di kelas basis data Anda. Drift membantu dalam melacak versi dan menjalankan migrasi yang diperlukan.

  - **Database Inspector:**

    - **Peran:** Alat untuk melihat dan mengelola data dalam basis data SQLite Anda selama pengembangan.
    - **Detail:** Anda dapat menggunakan `sqlite_browser` atau alat serupa yang memungkinkan Anda membuka file `.db` yang dihasilkan oleh aplikasi Anda. Drift juga memiliki fitur _debug_ yang membantu.

  - **Contoh Kode (Drift):**

  <!-- end list -->

  ```dart
  // file: lib/data/database.dart
  import 'dart:io';

  import 'package:drift/drift.dart';
  import 'package:drift/native.dart';
  import 'package:path_provider/path_provider.dart';
  import 'package:path/path.dart' as p; // Alias path package untuk menghindari konflik

  part 'database.g.dart'; // File yang akan di-generate oleh Drift

  // Definisi tabel Todos
  @DataClassName('TodoItem') // Nama kelas model yang dihasilkan
  class Todos extends Table {
    IntColumn get id => integer().autoIncrement()();
    TextColumn get title => text().withLength(min: 1, max: 32)();
    TextColumn get description => text().named('body').nullable()(); // Nama kolom di DB 'body'
    BoolColumn get isDone => boolean().withDefault(const Constant(false))(); // Default false
  }

  // Kelas basis data utama
  @DriftDatabase(tables: [Todos]) // Daftarkan semua tabel Anda di sini
  class AppDatabase extends _$AppDatabase {
    AppDatabase() : super(_openConnection());

    @override
    int get schemaVersion => 1; // Tingkatkan ini saat ada perubahan skema

    // Logika migrasi (jika schemaVersion berubah)
    @override
    MigrationStrategy get migration => MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll(); // Buat semua tabel saat pertama kali
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Contoh: Tambah kolom baru di versi 2
        // if (from < 2) {
        //   await m.addColumn(todos, todos.newColumn);
        // }
      },
    );

    // --- Query Builder Methods ---

    // Read: Mengambil semua todo (reactive stream)
    Stream<List<TodoItem>> watchAllTodoItems() {
      return select(todos).watch();
    }

    // Read: Mengambil todo yang sudah selesai
    Future<List<TodoItem>> getCompletedTodos() {
      return (select(todos)..where((t) => t.isDone.equals(true))).get();
    }

    // Create: Menambahkan todo baru
    Future<int> insertTodo(TodosCompanion entry) {
      return into(todos).insert(entry);
    }

    // Update: Memperbarui todo
    Future<bool> updateTodo(TodoItem entry) {
      return update(todos).replace(entry);
    }

    // Delete: Menghapus todo
    Future<int> deleteTodo(int id) {
      return (delete(todos)..where((t) => t.id.equals(id))).go();
    }
  }

  // Fungsi helper untuk membuka koneksi basis data
  LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      return NativeDatabase.createInBackground(file); // Untuk kinerja lebih baik
    });
  }

  // Setelah membuat file di atas, jalankan:
  // flutter pub run build_runner build
  // atau
  // flutter pub run build_runner watch
  // Ini akan menghasilkan file 'database.g.dart'

  // Contoh penggunaan dalam main atau widget:
  /*
  import 'package:flutter/material.dart';
  import 'package:your_app_name/data/database.dart'; // Ganti dengan path database Anda

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = AppDatabase();

    // Demo penggunaan
    await database.insertTodo(const TodosCompanion(
      title: Value('Belajar Drift'),
      description: Value('Memahami ORM'),
    ));
    await database.insertTodo(const TodosCompanion(
      title: Value('Membuat Aplikasi dengan Flutter'),
      isDone: Value(true),
    ));

    // Menggunakan stream untuk reactive UI
    runApp(MyApp(database: database));
  }

  class MyApp extends StatelessWidget {
    final AppDatabase database;
    const MyApp({super.key, required this.database});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Drift (Moor) ORM Demo')),
          body: StreamBuilder<List<TodoItem>>(
            stream: database.watchAllTodoItems(), // Mendengarkan perubahan data
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No todo items yet.'));
              } else {
                final todos = snapshot.data!;
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return ListTile(
                      title: Text(todo.title),
                      subtitle: Text(todo.description ?? 'No description'),
                      trailing: Checkbox(
                        value: todo.isDone,
                        onChanged: (bool? newValue) async {
                          if (newValue != null) {
                            // Gunakan copyWith untuk membuat instance baru yang diubah
                            final updatedTodo = todo.copyWith(isDone: Value(newValue));
                            await database.updateTodo(updatedTodo);
                          }
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await database.insertTodo(TodosCompanion.insert(
                title: 'New Drift Task ${DateTime.now().second}',
                description: const Value(''),
              ));
            },
            child: const Icon(Icons.add),
          ),
        ),
      );
    }
  }
  */
  ```

  - **Sumber Daya Tambahan:**
    - [Drift ORM](https://drift.simonbinder.eu/) (Dokumentasi resmi Drift)

---

- **3. Hive NoSQL Database**

  - **Peran:** Hive adalah basis data NoSQL yang ringan dan sangat cepat untuk Flutter. Ini adalah alternatif yang bagus untuk SQLite jika Anda tidak memerlukan model relasional yang kompleks atau kueri SQL. Hive menyimpan data dalam "box" (mirip dengan tabel atau koleksi), dan setiap _box_ dapat berisi objek yang berbeda.

  - **Detail:** Hive dirancang untuk performa tinggi dan kemudahan penggunaan. Ini sangat cepat karena menggunakan _native binary format_ untuk menyimpan data. Mendukung enkripsi dan bekerja secara _asynchronous_.

  - **Setup (`pubspec.yaml`):**

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      hive: ^latest_version # Core Hive
      hive_flutter: ^latest_version # Integrasi Hive dengan Flutter

    dev_dependencies:
      hive_generator: ^latest_version # Generator kode untuk Type Adapters
      build_runner: ^latest_version
    ```

    Setelah menambahkan, jalankan `flutter pub get`.

  - **Box Operations:**

    - **Peran:** `Box` adalah unit penyimpanan utama di Hive, mirip dengan tabel di basis data relasional atau koleksi di basis data NoSQL lainnya.
    - **Detail:**
      - `Hive.initFlutter()`: Inisialisasi Hive (panggil sekali di `main()`).
      - `Hive.openBox<T>('boxName')`: Membuka _box_ (asynchronous).
      - `box.put('key', value)`: Menyimpan data (key-value).
      - `box.get('key')`: Mengambil data.
      - `box.add(value)`: Menambahkan data dengan kunci yang di-_auto-increment_.
      - `box.delete('key')`: Menghapus data.
      - `box.clear()`: Menghapus semua data dari _box_.
      - `box.values`: Mengambil semua nilai dari _box_.

  - **Type Adapters:**

    - **Peran:** Mengajari Hive cara membaca dan menulis objek Dart kustom ke/dari disk.
    - **Detail:** Anda menandai kelas model Anda dengan `@HiveType()` dan propertinya dengan `@HiveField()`. Kemudian gunakan `hive_generator` untuk menghasilkan `TypeAdapter`.

  - **Lazy Boxes:**

    - **Peran:** `Lazy Box` memuat nilai hanya saat diakses, bukan seluruh _box_ ke dalam memori. Ini berguna untuk _box_ besar di mana Anda hanya perlu mengakses sebagian kecil data pada satu waktu.
    - **Detail:** Buka dengan `Hive.openLazyBox('lazyBoxName')`. Operasi `get()` akan bersifat _asynchronous_.

  - **Encryption:**

    - **Peran:** Mengenkripsi data dalam _box_ Hive untuk keamanan.
    - **Detail:** Saat membuka _box_, Anda bisa memberikan kunci enkripsi. Kunci ini harus disimpan dengan aman (misalnya, menggunakan `flutter_secure_storage`).

  - **Performance Benchmarks:**

    - Hive dikenal sangat cepat, seringkali mengungguli solusi basis data lokal lainnya untuk operasi dasar karena arsitektur dan format penyimpanannya yang unik.

  - **Contoh Kode (Hive):**

  <!-- end list -->

  ```dart
  // file: lib/data/hive_todo.dart
  import 'package:hive/hive.dart';
  import 'package:hive_flutter/hive_flutter.dart'; // Untuk initFlutter() dan WatchBoxBuilder

  part 'hive_todo.g.dart'; // File yang akan di-generate oleh hive_generator

  @HiveType(typeId: 0) // typeId harus unik untuk setiap kelas model
  class HiveTodo {
    @HiveField(0)
    int? id; // Hive bisa auto-increment key

    @HiveField(1)
    String title;

    @HiveField(2)
    String description;

    @HiveField(3)
    bool isDone;

    HiveTodo({this.id, required this.title, this.description = '', this.isDone = false});

    @override
    String toString() {
      return 'HiveTodo{id: $id, title: $title, description: $description, isDone: $isDone}';
    }
  }

  class HiveTodoService {
    static const String _boxName = 'todosBox';
    static Box<HiveTodo>? _todoBox;

    // Inisialisasi Hive dan buka box
    static Future<void> init() async {
      await Hive.initFlutter(); // Inisialisasi Hive untuk Flutter
      Hive.registerAdapter(HiveTodoAdapter()); // Daftarkan adapter yang di-generate
      _todoBox = await Hive.openBox<HiveTodo>(_boxName); // Buka box
      print('Hive Todo Box opened.');
    }

    // Create/Update: Menambahkan atau memperbarui todo
    Future<void> putTodo(HiveTodo todo) async {
      if (todo.id == null) {
        todo.id = await _todoBox?.add(todo); // Tambahkan dengan auto-increment key
      } else {
        await _todoBox?.put(todo.id, todo); // Simpan dengan key yang spesifik
      }
      print('Todo saved: $todo');
    }

    // Read: Mengambil todo berdasarkan ID
    HiveTodo? getTodo(int id) {
      return _todoBox?.get(id);
    }

    // Read: Mengambil semua todo
    List<HiveTodo> getAllTodos() {
      return _todoBox?.values.toList() ?? [];
    }

    // Delete: Menghapus todo
    Future<void> deleteTodo(int id) async {
      await _todoBox?.delete(id);
      print('Todo $id deleted.');
    }

    // Clear all todos
    Future<void> clearAllTodos() async {
      await _todoBox?.clear();
      print('All todos cleared.');
    }

    // Menutup box (penting untuk membebaskan sumber daya)
    static Future<void> close() async {
      await _todoBox?.close();
      print('Hive Todo Box closed.');
    }
  }

  // Setelah membuat file di atas, jalankan:
  // flutter pub run build_runner build
  // atau
  // flutter pub run build_runner watch
  // Ini akan menghasilkan file 'hive_todo.g.dart'

  // Contoh penggunaan dalam main atau widget:
  /*
  import 'package:flutter/material.dart';
  import 'package:your_app_name/data/hive_todo.dart'; // Ganti dengan path Anda

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await HiveTodoService.init(); // Inisialisasi Hive
    runApp(MyApp());
  }

  class MyApp extends StatelessWidget {
    final HiveTodoService _hiveTodoService = HiveTodoService();

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Hive NoSQL Database Demo')),
          body: ValueListenableBuilder<Box<HiveTodo>>(
            valueListenable: Hive.box<HiveTodo>('todosBox').listenable(), // Mendengarkan perubahan box
            builder: (context, box, _) {
              final todos = box.values.toList().cast<HiveTodo>(); // Ambil semua data
              if (todos.isEmpty) {
                return const Center(child: Text('No todos yet.'));
              }
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return ListTile(
                    title: Text(todo.title),
                    subtitle: Text(todo.description),
                    trailing: Checkbox(
                      value: todo.isDone,
                      onChanged: (bool? newValue) async {
                        if (newValue != null) {
                          todo.isDone = newValue;
                          await _hiveTodoService.putTodo(todo); // Update
                        }
                      },
                    ),
                    onLongPress: () async {
                      await _hiveTodoService.deleteTodo(todo.id!);
                    },
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await _hiveTodoService.putTodo(HiveTodo(
                title: 'New Hive Task ${DateTime.now().second}',
                description: 'From Hive Demo',
              ));
            },
            child: const Icon(Icons.add),
          ),
        ),
      );
    }
  }
  */
  ```

  - **Hive vs SQLite:**
    - **SQLite (dengan `sqflite`/`Drift`):**
      - **Kapan digunakan:** Jika Anda membutuhkan basis data relasional penuh dengan skema yang kompleks, hubungan antar tabel (JOINs), dan kueri SQL yang rumit. Cocok untuk aplikasi yang memerlukan validasi data ketat dan integritas referensial.
      - **Keunggulan:** Kekuatan SQL, dukungan transaksi, fleksibilitas kueri, standar industri.
      - **Kekurangan:** Lebih banyak _boilerplate_ SQL (tanpa ORM), bisa lebih lambat untuk operasi sederhana, penanganan migrasi yang lebih manual.
    - **Hive:**
      - **Kapan digunakan:** Jika Anda membutuhkan penyimpanan data non-relasional yang cepat dan sederhana, atau jika Anda menyimpan objek Dart secara langsung tanpa perlu transformasi skema. Ideal untuk _caching_, data pengguna offline, atau data yang tidak memiliki hubungan kompleks.
      - **Keunggulan:** Sangat cepat, mudah digunakan, _type-safe_ dengan _Type Adapters_, mendukung enkripsi, cocok untuk _offline-first_.
      - **Kekurangan:** Bukan basis data relasional (tidak ada JOINs), kueri lebih terbatas dibandingkan SQL, tidak ideal untuk data yang sangat terstruktur dengan banyak dependensi.

- **Sumber Daya Tambahan:**

  - [tautan mencurigakan telah dihapus]
  - [tautan mencurigakan telah dihapus] (Perbandingan resmi Hive)

---

- **4. Isar Database**

  - **Peran:** Isar adalah basis data NoSQL _multi-platform_ yang dioptimalkan untuk performa tinggi, modern, dan sangat mudah digunakan untuk Flutter. Ini adalah penerus spiritual dari Hive, yang dikembangkan oleh pencipta Hive dengan fokus pada kecepatan yang lebih ekstrem dan fungsionalitas yang lebih canggih seperti _full-text search_ dan _query language_ yang kuat.

  - **Detail:** Isar dibangun di atas Rust, memberikan performa yang mendekati _native_. Ini mendukung _reactive queries_, _secondary indexes_, _full-text search_, dan _embedded objects_. Isar juga menggunakan _code generation_ untuk menghasilkan kode akses data.

  - **Setup (`pubspec.yaml`):**

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      isar: ^latest_version # Core Isar
      isar_flutter_libs: ^latest_version # Libs platform-specific

    dev_dependencies:
      isar_generator: ^latest_version # Generator kode Isar
      build_runner: ^latest_version
    ```

    Setelah menambahkan, jalankan `flutter pub get`.

  - **Schema Definition:**

    - **Peran:** Mendefinisikan struktur objek yang akan disimpan di Isar.
    - **Detail:** Anda membuat kelas Dart dan menganotasinya dengan `@Collection()`. Properti kelas Anda akan menjadi _field_ di koleksi Isar. Anda dapat menentukan indeks dengan `@Index()`.

  - **Query Language:**

    - **Peran:** Isar memiliki bahasa kuerinya sendiri yang sangat intuitif dan _type-safe_, memungkinkan Anda melakukan kueri kompleks tanpa menulis SQL.
    - **Detail:** Kueri dibangun secara berantai (_chaining_) pada objek koleksi Anda (misalnya, `isar.collectionName.where().filter().contains().findAll()`).

  - **Indexes Optimization:**

    - **Peran:** Meningkatkan kecepatan pencarian dan pengurutan data dengan membuat indeks pada properti yang sering digunakan dalam kueri.
    - **Detail:** Anda menandai properti dengan `@Index()`. Isar mendukung berbagai jenis indeks (misalnya, _hash_, _value_, _composite_).

  - **Full-text Search:**

    - **Peran:** Kemampuan untuk mencari teks di seluruh bidang _string_ dalam koleksi, memungkinkan pencarian yang lebih fleksibel dan relevan (mirip dengan pencarian Google).
    - **Detail:** Anda menandai properti dengan `@Index(type: IndexType.value, unique: false)`.

  - **Database Inspector:**

    - **Peran:** Isar menyediakan alat inspeksi UI (_GUI_) yang memungkinkan Anda melihat, mengedit, dan mengueri data dalam basis data Isar Anda selama pengembangan. Ini adalah alat yang sangat berguna untuk _debugging_.
    - **Detail:** Anda dapat mengaktifkan _Isar Inspector_ dalam kode Anda, dan kemudian mengaksesnya melalui _browser_ web.

  - **Contoh Kode (Isar):**

  <!-- end list -->

  ```dart
  // file: lib/data/isar_todo.dart
  import 'package:isar/isar.dart'; // Import Isar core
  part 'isar_todo.g.dart'; // File yang akan di-generate oleh isar_generator

  @Collection() // Anotasi ini menandai kelas ini sebagai koleksi Isar
  class IsarTodo {
    Id id = Isar.autoIncrement; // Primary key, auto-increment

    @Index(type: IndexType.hash) // Index pada title untuk pencarian cepat
    String title;

    String description;

    bool isDone;

    IsarTodo({required this.title, this.description = '', this.isDone = false});

    @override
    String toString() {
      return 'IsarTodo{id: $id, title: $title, description: $description, isDone: $isDone}';
    }
  }

  class IsarService {
    static late Isar _isar;

    // Inisialisasi Isar
    static Future<void> init() async {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [IsarTodoSchema], // Daftarkan semua skema koleksi Anda di sini
        directory: dir.path,
        inspector: true, // Aktifkan Isar Inspector
      );
      print('Isar Database opened.');
      print('Isar Inspector URL: http://localhost:8080 (default)'); // Periksa konsol untuk URL spesifik
    }

    // Create: Menambahkan todo baru
    Future<void> addTodo(IsarTodo todo) async {
      await _isar.writeTxn(() async { // Semua operasi write dalam transaksi
        await _isar.isarTodos.put(todo);
      });
      print('Todo added: $todo');
    }

    // Read: Mengambil semua todo (reactive stream)
    Stream<List<IsarTodo>> watchAllTodos() {
      return _isar.isarTodos.where().watch(fireImmediately: true);
    }

    // Read: Mengambil todo berdasarkan ID
    Future<IsarTodo?> getTodoById(int id) async {
      return await _isar.isarTodos.get(id);
    }

    // Update: Memperbarui todo (Isar mendukung put() untuk insert/update)
    Future<void> updateTodo(IsarTodo todo) async {
      await _isar.writeTxn(() async {
        await _isar.isarTodos.put(todo); // Jika ID ada, update; jika tidak, insert
      });
      print('Todo updated: $todo');
    }

    // Delete: Menghapus todo
    Future<void> deleteTodo(int id) async {
      await _isar.writeTxn(() async {
        await _isar.isarTodos.delete(id);
      });
      print('Todo $id deleted.');
    }

    // Query dengan filter dan sort
    Future<List<IsarTodo>> getDoneTodosSortedByTitle() async {
      return await _isar.isarTodos.where()
          .isDoneEqualTo(true)
          .sortByTitle()
          .findAll();
    }

    // Pencarian Full-text
    Future<List<IsarTodo>> searchTodos(String query) async {
      return await _isar.isarTodos.filter()
          .titleContains(query, caseSensitive: false)
          .or()
          .descriptionContains(query, caseSensitive: false)
          .findAll();
    }

    // Menutup database
    static Future<void> close() async {
      await _isar.close();
      print('Isar Database closed.');
    }
  }

  // Setelah membuat file di atas, jalankan:
  // flutter pub run build_runner build
  // atau
  // flutter pub run build_runner watch
  // Ini akan menghasilkan file 'isar_todo.g.dart'

  // Contoh penggunaan dalam main atau widget:
  /*
  import 'package:flutter/material.dart';
  import 'package:your_app_name/data/isar_todo.dart'; // Ganti dengan path Anda

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await IsarService.init(); // Inisialisasi Isar
    runApp(MyApp());
  }

  class MyApp extends StatelessWidget {
    final IsarService _isarService = IsarService();

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Isar Database Demo')),
          body: StreamBuilder<List<IsarTodo>>(
            stream: _isarService.watchAllTodos(), // Mendengarkan perubahan data
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No Isar todos yet.'));
              } else {
                final todos = snapshot.data!;
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return ListTile(
                      title: Text(todo.title),
                      subtitle: Text(todo.description),
                      trailing: Checkbox(
                        value: todo.isDone,
                        onChanged: (bool? newValue) async {
                          if (newValue != null) {
                            todo.isDone = newValue;
                            await _isarService.updateTodo(todo); // Update
                          }
                        },
                      ),
                      onLongPress: () async {
                        await _isarService.deleteTodo(todo.id);
                      },
                    );
                  },
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await _isarService.addTodo(IsarTodo(
                title: 'New Isar Task ${DateTime.now().second}',
                description: 'From Isar Demo',
              ));
            },
            child: const Icon(Icons.add),
          ),
        ),
      );
    }
  }
  */
  ```

  - **Isar Documentation:**
    - [Isar Documentation](https://isar.dev/) (Dokumentasi resmi Isar)
  - **Isar Inspector:**
    - [Isar Inspector](https://www.google.com/search?q=https://isar.dev/docs/isar_inspector.html) (Informasi tentang alat inspeksi GUI)

---

Untuk menambah wawasan Anda seputar solusi basis data yang telah kita bahas, mari kita eksplorasi beberapa pertimbangan penting dan informasi tambahan yang dapat memandu Anda dalam memilih dan mengimplementasikan basis data di proyek Flutter tersebut.

---

### **Informasi Tambahan: Pertimbangan & Best Practices Solusi Basis Data**

#### **1. Kapan Memilih Solusi Basis Data yang Mana? (Decision Tree)**

Pemilihan basis data lokal sangat tergantung pada kebutuhan spesifik aplikasi Anda. Berikut adalah panduan singkat:

- **`SharedPreferences`**:

  - **Pilih Jika**: Anda perlu menyimpan _data non-sensitif_ dalam format _key-value_ yang sangat sederhana (preferensi pengguna, _flag_ aplikasi, _state_ UI minimal).
  - **Hindari Jika**: Anda menyimpan data terstruktur, data dalam jumlah besar, atau data sensitif yang perlu dienkripsi.
  - **Contoh Penggunaan**: Menyimpan preferensi mode gelap/terang, status _onboarding_ aplikasi, ID pengguna yang sedang login (jika token autentikasi disimpan di tempat yang lebih aman).

- **`flutter_secure_storage`**:

  - **Pilih Jika**: Anda perlu menyimpan _data sensitif_ (token autentikasi, API _key_, kredensial) yang memerlukan enkripsi dan perlindungan tingkat OS (Keychain/Keystore).
  - **Hindari Jika**: Anda menyimpan data dalam jumlah besar atau data yang tidak memerlukan enkripsi, karena ini lebih lambat dari `SharedPreferences`.
  - **Contoh Penggunaan**: Menyimpan JWT (JSON Web Token), _refresh token_, kunci enkripsi kustom.

- **SQLite (`sqflite` / `Drift`)**:

  - **Pilih Jika**:
    - Anda membutuhkan _basis data relasional_ dengan skema yang terdefinisi dengan baik.
    - Data Anda memiliki _hubungan kompleks_ antar entitas (misalnya, pengguna memiliki banyak pesanan, pesanan memiliki banyak item).
    - Anda perlu melakukan _kueri yang kompleks_ (JOINs, agregasi, filter bersyarat).
    - Anda memprioritaskan _integritas data_ dan konsistensi transaksional.
    - Anda sudah terbiasa dengan SQL atau membutuhkan kekuatan SQL.
  - **`sqflite` vs `Drift`**:
    - **`sqflite`**: Lebih _low-level_, memberikan kontrol penuh atas SQL, bagus jika Anda ingin menulis _raw SQL_.
    - **`Drift`**: ORM yang menyediakan _type-safety_, _reactive queries_ (berkat _stream_), sistem migrasi yang kuat, dan lebih sedikit _boilerplate_ kode SQL. Ideal untuk proyek yang lebih besar dan tim yang menginginkan pengembangan yang lebih cepat dan aman.
  - **Contoh Penggunaan**: Aplikasi manajemen tugas dengan kategori dan tag, aplikasi e-commerce offline dengan produk dan keranjang belanja, aplikasi catatan dengan _relationship_ antara catatan dan folder.

- **Hive (NoSQL)**:

  - **Pilih Jika**:
    - Anda membutuhkan _penyimpanan data non-relasional_ yang sangat cepat dan ringan.
    - Anda menyimpan _objek Dart secara langsung_ tanpa perlu transformasi skema yang kompleks.
    - Anda memprioritaskan _kecepatan_ dan _kemudahan penggunaan_ untuk data yang tidak terlalu terstruktur.
    - Cocok untuk _caching_ data API atau data yang berorientasi dokumen.
  - **Hindari Jika**: Anda membutuhkan JOINs atau kueri relasional yang kompleks.
  - **Contoh Penggunaan**: _Cache_ data API (misalnya, daftar artikel berita), menyimpan preferensi pengguna yang lebih kompleks, daftar item _wishlist_ sederhana, _offline queue_ untuk data yang akan disinkronkan ke _server_.

- **Isar (NoSQL)**:
  - **Pilih Jika**:
    - Anda membutuhkan _database NoSQL super cepat_ dengan fitur modern.
    - Anda menginginkan _query language_ yang intuitif dan _type-safe_ tanpa SQL.
    - Anda membutuhkan _full-text search_ atau _secondary indexes_ yang powerful.
    - Anda mencari pengganti Hive yang lebih canggih dan performa lebih baik.
    - Menginginkan _database inspector GUI_ yang built-in.
  - **Contoh Penggunaan**: Aplikasi catatan dengan pencarian teks lengkap, aplikasi _to-do list_ dengan banyak filter dan kategori, _caching_ data besar yang sering di-_query_, aplikasi manajemen kontak.

#### **2. Praktik Terbaik Umum untuk Penggunaan Basis Data Lokal**

- **Pemisahan Logika (Repository Pattern):**

  - Encapsulasi semua operasi basis data dalam satu atau lebih kelas _Repository_. Ini memisahkan logika akses data dari logika UI atau bisnis Anda, membuat kode lebih bersih, mudah diuji, dan dipelihara.
  - Misalnya, `TodoRepository` yang berisi metode `insertTodo()`, `getTodos()`, `updateTodo()`, `deleteTodo()`.

- **Penanganan Kesalahan (Error Handling):**

  - Selalu gunakan blok `try-catch` saat berinteraksi dengan basis data, terutama untuk operasi tulis (insert, update, delete). Operasi basis data dapat gagal karena berbagai alasan (misalnya, batasan unik, basis data rusak).
  - Berikan _feedback_ yang tepat kepada pengguna jika terjadi kesalahan.

- **Operasi Asynchronous:**

  - Semua interaksi basis data harus dilakukan secara _asynchronous_ (`async`/`await`) di _isolate_ terpisah (biasanya ditangani oleh _package_ itu sendiri atau dengan `compute` untuk operasi yang sangat berat). Ini untuk memastikan UI tetap responsif dan tidak macet (_jank_).

- **Manajemen Sumber Daya (Close Database):**

  - Pastikan untuk menutup _instance_ basis data atau _box_ ketika tidak lagi dibutuhkan, terutama saat aplikasi akan keluar atau ketika menginisialisasi ulang basis data untuk pengujian. Meskipun banyak _package_ modern mengelola ini secara internal, praktik yang baik adalah memahami siklus hidup basis data.

- **Integrasi dengan State Management:**

  - Untuk menjaga UI tetap _up-to-date_ dengan perubahan data di basis data, manfaatkan _reactive capabilities_ dari solusi basis data (misalnya, `Stream<List<T>>` dari Drift atau `ValueListenableBuilder` dari Hive/Isar).
  - Integrasikan _stream_ atau _listener_ ini dengan _state management solution_ pilihan Anda (Provider, BLoC, Riverpod) untuk meregenerasi UI secara otomatis saat data berubah.

- **Debugging dan Inspeksi:**
  - Selama pengembangan, Anda perlu bisa melihat apa yang sebenarnya ada di basis data Anda.
  - **SQLite**: Gunakan alat seperti _DB Browser for SQLite_ atau _Android Studio's Database Inspector_ untuk Android, dan _Simulator's File System_ untuk iOS.
  - **Hive**: Anda bisa menggunakan _Hive Inspector_ (terpisah atau plugin IDE) atau melihat langsung file `.hive` jika Anda tahu lokasinya.
  - **Isar**: Memiliki _Isar Inspector_ bawaan yang dapat diakses melalui _browser_ web, yang sangat memudahkan _debugging_ dan eksplorasi data.

#### **3. Enkripsi (Selain `flutter_secure_storage`)**

- **Hive Encryption**: Hive mendukung enkripsi _box_ dengan kunci yang disediakan. Kunci ini harus disimpan dengan aman (misalnya, menggunakan `flutter_secure_storage`).
- **Isar Encryption**: Isar juga mendukung enkripsi basis data saat membukanya, dengan cara yang mirip dengan Hive.

Memahami poin-poin ini akan membantu Anda membuat keputusan yang lebih tepat dan mengimplementasikan solusi basis data yang kuat dan efisien dalam proyek Flutter Anda.

---

Kita telah menyelesaikan pembahasan mendalam tentang **9.2 Database Solutions**, mencakup SQLite (`sqflite`/`Drift`), Hive (NoSQL sederhana), dan Isar (NoSQL modern dan sangat cepat). Pemilihan solusi basis data bergantung pada kebutuhan spesifik aplikasi Anda terkait struktur data, kinerja, dan kompleksitas kueri.

#### **9. Local Data Storage (Lanjutan)**

##### **9.3 Caching Strategies**

- **Peran:** Caching adalah teknik fundamental dalam pengembangan aplikasi untuk meningkatkan kinerja dan pengalaman pengguna dengan menyimpan salinan data yang sering diakses di lokasi yang lebih cepat (memori atau disk lokal) daripada mengambilnya berulang kali dari sumber aslinya (misalnya, jaringan atau basis data). Ini mengurangi latensi, menghemat _bandwidth_, dan memungkinkan fungsionalitas _offline_ sebagian.

---

###### **Caching Strategies**

- **1. Memory Cache**

  - **Peran:** Menyimpan data di memori RAM (_Random Access Memory_) perangkat. Ini adalah jenis _cache_ tercepat karena data langsung tersedia di memori utama. Ideal untuk data yang sangat sering diakses dan hanya diperlukan selama sesi aplikasi saat ini. Data di _memory cache_ akan hilang ketika aplikasi ditutup.

  - **Detail:**

    - Implementasi seringkali melibatkan _Map_ atau struktur data sejenis untuk menyimpan data.
    - Manajemen memori menjadi krusial; hindari menyimpan terlalu banyak data yang tidak perlu.

  - **Cache Eviction Policies:**

    - **LRU (Least Recently Used):**
      - **Peran:** Algoritma yang menghapus item yang paling tidak baru-baru ini digunakan ketika _cache_ penuh dan perlu membuat ruang. Ini mengasumsikan bahwa item yang baru saja digunakan kemungkinan besar akan digunakan lagi di masa mendatang.
      - **Mekanisme:** Menggunakan struktur data seperti _LinkedHashMap_ atau kombinasi _doubly linked list_ dan _HashMap_ untuk melacak urutan akses. Ketika item diakses, ia dipindahkan ke depan daftar. Ketika _cache_ penuh, item di bagian belakang daftar dihapus.
    - **LFU (Least Frequently Used):**
      - **Peran:** Algoritma yang menghapus item yang paling jarang digunakan ketika _cache_ penuh. Ini mengasumsikan bahwa item yang sering digunakan di masa lalu akan sering digunakan di masa mendatang.
      - **Mekanisme:** Melacak frekuensi akses setiap item. Ketika _cache_ penuh, item dengan frekuensi terendah dihapus. Ini lebih kompleks daripada LRU.

  - **Contoh Implementasi Memory Cache Sederhana (Konseptual LRU):**

    ```dart
    import 'dart:collection'; // Untuk LinkedHashMap

    class SimpleMemoryCache<K, V> {
      final int capacity;
      final LinkedHashMap<K, V> _cache;

      SimpleMemoryCache(this.capacity)
          : _cache = LinkedHashMap<K, V>(
              // Ketika elemen baru ditambahkan, elemen paling lama (LRU) dihapus jika melebihi kapasitas.
              // 'onEvict' callback bisa digunakan untuk membersihkan sumber daya jika V adalah objek kompleks
              // Ini bukan LRU murni, tapi mendekati dengan LinkedHashMap behavior
            ) {
        assert(capacity > 0);
      }

      V? get(K key) {
        final value = _cache.remove(key); // Hapus dan tambahkan kembali untuk menjadikannya "recently used"
        if (value != null) {
          _cache[key] = value;
        }
        return value;
      }

      void put(K key, V value) {
        if (_cache.containsKey(key)) {
          _cache.remove(key); // Jika sudah ada, hapus dulu untuk update posisinya
        } else if (_cache.length >= capacity) {
          _cache.remove(_cache.keys.first); // Hapus item LRU (yang pertama di LinkedHashMap)
        }
        _cache[key] = value;
      }

      void clear() {
        _cache.clear();
      }

      int get size => _cache.length;
    }

    // Contoh penggunaan:
    /*
    void main() {
      final cache = SimpleMemoryCache<String, String>(3);

      cache.put('a', 'data_a');
      cache.put('b', 'data_b');
      cache.put('c', 'data_c');
      print('Cache after 3 puts: ${cache._cache}'); // {a: data_a, b: data_b, c: data_c}

      cache.get('a'); // 'a' menjadi recently used
      print('Cache after get a: ${cache._cache}'); // {b: data_b, c: data_c, a: data_a}

      cache.put('d', 'data_d'); // Cache penuh, 'b' (LRU) akan dihapus
      print('Cache after put d: ${cache._cache}'); // {c: data_c, a: data_a, d: data_d}

      cache.put('a', 'new_data_a'); // 'a' diupdate, posisinya diperbarui
      print('Cache after update a: ${cache._cache}'); // {c: data_c, d: data_d, a: new_data_a}
    }
    */
    ```

  - **`cached_network_image`:**

    - **Peran:** _Package_ Flutter yang sangat populer untuk menampilkan gambar dari URL dan secara otomatis mengelola _caching_ gambar di memori (dan disk). Ini sangat mengurangi beban jaringan dan meningkatkan pengalaman pengguna saat melihat gambar berulang kali.
    - **Detail:** Menyediakan _widget_ `CachedNetworkImage` yang dapat digunakan langsung, mirip dengan `Image.network()`. Ini juga memiliki _placeholder_ dan _error widget_.

  - **`flutter_cache_manager`:**

    - **Peran:** _Package_ umum yang digunakan oleh `cached_network_image` (tetapi dapat digunakan secara independen) untuk mengelola _cache_ berkas di disk dan memori. Ini adalah solusi yang lebih fleksibel untuk _caching_ jenis berkas apa pun (bukan hanya gambar) dari URL.
    - **Detail:** Menyediakan API untuk mengunduh berkas, menyimpannya di _cache_, mengambilnya dari _cache_, dan membersihkan _cache_. Mendukung kebijakan _cache_ kustom dan dapat diatur untuk berbagai kebutuhan.

  - **Contoh Penggunaan `cached_network_image`:**

    ```dart
    import 'package:cached_network_image/cached_network_image.dart';
    import 'package:flutter/material.dart';

    // Setup (`pubspec.yaml`):
    /*
    dependencies:
      cached_network_image: ^latest_version # Ganti dengan versi terbaru
      flutter_cache_manager: ^latest_version # Dependensi dari cached_network_image
    */

    // Contoh penggunaan dalam widget:
    /*
    class ImageCachingDemo extends StatelessWidget {
      final String imageUrl = 'https://via.placeholder.com/150'; // Ganti dengan URL gambar Anda

      const ImageCachingDemo({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Image Caching Demo')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Image with Caching:'),
                const SizedBox(height: 10),
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) => const CircularProgressIndicator(), // Tampilan saat loading
                  errorWidget: (context, url, error) => const Icon(Icons.error), // Tampilan jika error
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                const Text('Image without Caching (re-downloads every time):'),
                const SizedBox(height: 10),
                Image.network(
                  imageUrl,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Untuk membersihkan cache jika diperlukan
                    // DefaultCacheManager().emptyCache(); // Membersihkan semua cache gambar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Try refreshing to see cache in action!')),
                    );
                  },
                  child: const Text('Refresh / Clear Cache (Optional)'),
                ),
              ],
            ),
          ),
        );
      }
    }
    */
    ```

- **Visualisasi Konseptual: Memory Cache**

  ```mermaid
  graph TD
      A[Aplikasi Flutter] --> B{Permintaan Data/Gambar};
      B -- Cek Memory Cache --> C{Memory Cache (RAM)};
      C -- Jika Ada --> D[Tampilkan Data Cepat];
      C -- Jika Tidak Ada --> E[Ambil dari Jaringan/Disk Cache];
      E -- Simpan ke Memory Cache --> C;
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan aliran permintaan data melalui _memory cache_. Jika data ditemukan di _cache_, ia segera ditampilkan. Jika tidak, data diambil dari sumber yang lebih lambat (jaringan atau _disk cache_), dan kemudian disimpan di _memory cache_ untuk akses cepat di masa mendatang.

---

- **2. Disk Cache**

  - **Peran:** Menyimpan data di penyimpanan permanen perangkat (internal atau eksternal). Ini lebih lambat dari _memory cache_ tetapi data tetap ada bahkan setelah aplikasi ditutup atau perangkat di-_restart_. Ideal untuk data yang besar atau yang perlu dipertahankan antar sesi aplikasi, seperti gambar, respons API, atau aset lainnya.

  - **Detail:**

    - Data disimpan sebagai berkas di sistem berkas perangkat.
    - Ukuran _cache_ dan kebijakan penghapusan menjadi penting untuk mengelola penggunaan ruang penyimpanan.
    - Biasanya digunakan untuk _caching_ respons jaringan, gambar, atau berkas media.

  - **File-based Caching:**

    - **Peran:** Menyimpan konten (`JSON`, teks, gambar, video) sebagai berkas individual di direktori _cache_ aplikasi.
    - **Mekanisme:** Gunakan `path_provider` untuk mendapatkan jalur direktori _cache_ (`getTemporaryDirectory()` atau `getApplicationDocumentsDirectory()`), lalu tulis/baca berkas menggunakan `dart:io`.

  - **Image Caching:**

    - Sudah banyak dibahas dengan `cached_network_image` yang secara otomatis mengelola _disk cache_ untuk gambar.
    - Anda juga bisa mengimplementasikan _caching_ gambar secara manual jika membutuhkan kontrol lebih.

  - **Response Caching:**

    - **Peran:** Menyimpan respons lengkap dari permintaan API. Ini memungkinkan aplikasi untuk menampilkan data lama saat tidak ada koneksi jaringan, atau untuk mengurangi jumlah permintaan ke _server_ saat data tidak banyak berubah.
    - **Mekanisme:** Setelah menerima respons dari API, simpan respons (`JSON string`) ke berkas di _disk cache_. Saat permintaan yang sama datang, periksa _cache_ terlebih dahulu.

  - **Cache Invalidation:**

    - **Peran:** Proses untuk menentukan kapan data di _cache_ sudah tidak valid (basi) dan harus diganti dengan data baru dari sumber aslinya.
    - **Mekanisme:**
      - **Time-based:** Data dianggap basi setelah periode waktu tertentu (misalnya, 5 menit, 1 jam).
      - **Event-based:** Data diinvalidate ketika ada peristiwa tertentu (misalnya, pengguna melakukan _pull-to-refresh_, data diperbarui di _server_).
      - **Version-based:** Jika ada versi data baru yang tersedia dari _server_.

  - **Cache-Control Headers:**

    - **Peran:** _Header HTTP_ yang digunakan oleh _server_ untuk menginstruksikan _client_ (aplikasi Anda, browser, atau proxy) bagaimana dan berapa lama respons harus di-_cache_.
    - **Detail:** _Header_ seperti `Cache-Control: max-age=3600`, `no-cache`, `no-store`, `must-revalidate`, `public`, `private` memberikan kontrol granular. Pustaka HTTP di Flutter (misalnya, `Dio`) dapat menafsirkan _header_ ini untuk _caching_ otomatis atau Anda bisa mengimplementasikan logika kustom berdasarkan _header_ ini.

  - **Contoh Implementasi Disk Cache Sederhana untuk Respons API:**

    ```dart
    import 'dart:io';
    import 'dart:convert';
    import 'package:path_provider/path_provider.dart';
    import 'package:path/path.dart' as p;

    class DiskCacheService {
      static Future<String> _getCacheDirectory() async {
        final directory = await getTemporaryDirectory(); // Atau getApplicationDocumentsDirectory()
        final cacheDir = Directory(p.join(directory.path, 'app_api_cache'));
        if (!await cacheDir.exists()) {
          await cacheDir.create(recursive: true);
        }
        return cacheDir.path;
      }

      // Menyimpan respons ke disk
      Future<void> saveResponse(String key, String responseJson, {Duration? ttl}) async {
        final cacheDir = await _getCacheDirectory();
        final file = File(p.join(cacheDir, '$key.json'));
        final Map<String, dynamic> cacheData = {
          'data': responseJson,
          'timestamp': DateTime.now().toIso8601String(),
          'ttl': ttl?.inSeconds ?? -1, // Time-to-live in seconds, -1 for no expiration
        };
        await file.writeAsString(jsonEncode(cacheData));
        print('Response for $key saved to disk cache.');
      }

      // Mengambil respons dari disk
      Future<String?> getResponse(String key) async {
        final cacheDir = await _getCacheDirectory();
        final file = File(p.join(cacheDir, '$key.json'));

        if (await file.exists()) {
          final content = await file.readAsString();
          final Map<String, dynamic> cacheData = jsonDecode(content);
          final String responseJson = cacheData['data'];
          final String timestampStr = cacheData['timestamp'];
          final int ttlSeconds = cacheData['ttl'];

          if (ttlSeconds != -1) {
            final DateTime cachedTime = DateTime.parse(timestampStr);
            final Duration age = DateTime.now().difference(cachedTime);
            if (age.inSeconds > ttlSeconds) {
              print('Cache for $key expired. Deleting.');
              await file.delete();
              return null; // Cache expired
            }
          }
          print('Response for $key retrieved from disk cache.');
          return responseJson;
        }
        return null; // Not found in cache
      }

      // Menghapus cache spesifik
      Future<void> deleteCache(String key) async {
        final cacheDir = await _getCacheDirectory();
        final file = File(p.join(cacheDir, '$key.json'));
        if (await file.exists()) {
          await file.delete();
          print('Cache for $key deleted.');
        }
      }

      // Menghapus semua cache
      Future<void> clearAllCache() async {
        final cacheDir = await _getCacheDirectory();
        final directory = Directory(cacheDir);
        if (await directory.exists()) {
          await directory.delete(recursive: true);
          print('All disk cache cleared.');
        }
      }
    }

    // Contoh penggunaan:
    /*
    void main() async {
      WidgetsFlutterBinding.ensureInitialized(); // Pastikan Flutter diinisialisasi
      final cacheService = DiskCacheService();

      // Simpan data ke cache dengan TTL 10 detik
      await cacheService.saveResponse('products', '{"id": 1, "name": "Laptop"}', ttl: const Duration(seconds: 10));
      print(await cacheService.getResponse('products')); // Harusnya dapat

      // Tunggu sebentar agar kadaluarsa
      // await Future.delayed(const Duration(seconds: 12));
      // print(await cacheService.getResponse('products')); // Harusnya null (expired)

      // Tanpa TTL
      await cacheService.saveResponse('user_profile', '{"name": "Budi", "email": "budi@example.com"}');
      print(await cacheService.getResponse('user_profile')); // Harusnya dapat

      // Hapus cache spesifik
      await cacheService.deleteCache('products');

      // Hapus semua cache
      await cacheService.clearAllCache();
    }
    */
    ```

- **Visualisasi Konseptual: Disk Cache**

  ```mermaid
  graph TD
      A[Aplikasi Flutter] --> B{Permintaan Data (mis. API)};
      B -- Cek Disk Cache --> C{Disk Cache (File System)};
      C -- Jika Ada & Valid --> D[Tampilkan Data Tersimpan];
      C -- Jika Tidak Ada / Basi --> E[Ambil dari Jaringan];
      E -- Simpan ke Disk Cache --> C;
  ```

  **Penjelasan Visual:**
  Diagram ini menggambarkan _disk cache_ sebagai lapisan penyimpanan permanen. Aplikasi pertama-tama memeriksa _disk cache_. Jika data ditemukan dan masih valid, itu digunakan. Jika tidak, data diambil dari jaringan, dan kemudian disimpan di _disk cache_ untuk penggunaan di masa mendatang.

---

- **3. Stale-While-Revalidate**

  - **Peran:** Sebuah strategi _caching_ yang memungkinkan aplikasi untuk segera menampilkan data yang sudah ada (_stale data_) dari _cache_ (untuk pengalaman pengguna yang cepat), sambil secara bersamaan mengambil data terbaru di latar belakang (_revalidate_) dari sumber asli. Setelah data terbaru diterima, _cache_ diperbarui, dan UI dapat diperbarui secara _seamless_.

  - **Keunggulan:**

    - **Offline-first:** Aplikasi tetap fungsional meskipun tidak ada koneksi internet (karena menyajikan data _stale_).
    - **Performa:** Pengguna melihat konten instan, tidak perlu menunggu permintaan jaringan.
    - **User Experience:** Transisi halus dari data lama ke data baru.

  - **Mekanisme:**

    1.  Ketika data diminta, periksa _cache_.
    2.  Jika data ada di _cache_ (terlepas dari apakah itu basi atau tidak):
        - Sajikan data _cache_ ke UI **segera**.
        - Secara _asynchronous_, mulai permintaan jaringan ke sumber asli untuk mendapatkan data terbaru.
    3.  Ketika respons jaringan diterima:
        - Perbarui _cache_ dengan data terbaru.
        - Perbarui UI dengan data terbaru (jika berbeda dari yang disajikan sebelumnya).
    4.  Jika data tidak ada di _cache_, tunggu respons jaringan dan kemudian simpan ke _cache_ dan tampilkan.

  - **Offline-first Approach:**

    - `Stale-While-Revalidate` adalah pilar utama dari strategi _offline-first_. Tujuannya adalah membuat aplikasi terasa cepat dan dapat digunakan bahkan tanpa koneksi internet yang stabil. Pengguna dapat berinteraksi dengan aplikasi, melihat konten yang di-_cache_, dan perubahan lokal disinkronkan saat koneksi tersedia.

  - **Background Updates:**

    - Bagian "revalidate" dari strategi ini seringkali melibatkan _background updates_. Permintaan jaringan untuk mendapatkan data terbaru dilakukan di latar belakang, tanpa memblokir interaksi pengguna dengan UI. Hasilnya kemudian diperbarui secara _silent_ atau dengan indikator halus.

  - **Contoh Konseptual Stale-While-Revalidate (menggunakan `http` dan `DiskCacheService` kita):**

    ```dart
    import 'dart:convert';
    import 'package:http/http.dart' as http;
    // Asumsikan DiskCacheService sudah didefinisikan seperti di atas
    // import 'package:your_app_name/data/disk_cache_service.dart';

    class DataService {
      final DiskCacheService _cacheService = DiskCacheService();
      final String _apiUrl = 'https://api.example.com/products'; // Ganti dengan API Anda

      // Mengambil data menggunakan strategi Stale-While-Revalidate
      Stream<Map<String, dynamic>?> getProductsStream() async* {
        const String cacheKey = 'products_list';

        // 1. Cek cache terlebih dahulu
        final cachedData = await _cacheService.getResponse(cacheKey);
        if (cachedData != null) {
          print('Serving stale data from cache for products.');
          yield jsonDecode(cachedData); // Langsung kirim data basi ke stream
        } else {
          print('No data in cache for products. Fetching from network...');
        }

        // 2. Selalu ambil data terbaru dari jaringan di latar belakang
        try {
          final response = await http.get(Uri.parse(_apiUrl));
          if (response.statusCode == 200) {
            final String freshData = response.body;
            print('Fetched fresh data from network for products.');

            // Simpan data terbaru ke cache (misal TTL 1 jam)
            await _cacheService.saveResponse(cacheKey, freshData, ttl: const Duration(hours: 1));

            // Hanya kirim data segar jika berbeda atau belum ada data basi sebelumnya
            if (cachedData == null || freshData != cachedData) {
              yield jsonDecode(freshData); // Kirim data segar ke stream
            }
          } else {
            print('Failed to fetch fresh data: ${response.statusCode}');
            // Jika ada data basi, itu sudah dikirim. Jika tidak ada, stream akan tetap kosong.
          }
        } catch (e) {
          print('Network error while fetching fresh data: $e');
          // Jika ada data basi, itu sudah dikirim. Jika tidak ada, pengguna akan melihat error atau data kosong.
        }
      }
    }

    // Contoh penggunaan dalam widget (Reactive UI dengan StreamBuilder):
    /*
    import 'package:flutter/material.dart';
    import 'package:your_app_name/data/data_service.dart'; // Ganti dengan path Anda
    import 'package:your_app_name/data/disk_cache_service.dart'; // Pastikan DiskCacheService juga ada

    void main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await DiskCacheService().clearAllCache(); // Untuk demo, mulai dari nol
      runApp(MyApp());
    }

    class MyApp extends StatelessWidget {
      final DataService _dataService = DataService();

      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Stale-While-Revalidate Demo')),
            body: StreamBuilder<Map<String, dynamic>?>(
              stream: _dataService.getProductsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No data available.'));
                } else {
                  final data = snapshot.data!;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Data from API (Stale-While-Revalidate):'),
                        const SizedBox(height: 10),
                        Text('ID: ${data['id']}'),
                        Text('Name: ${data['name']}'),
                        const SizedBox(height: 20),
                        const Text('Perhatikan log di konsol untuk melihat bagaimana data basi disajikan lalu diperbarui.'),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        );
      }
    }
    */
    ```

- **Visualisasi Konseptual: Stale-While-Revalidate**

  ```mermaid
  graph TD
      A[Aplikasi Flutter] -- Permintaan Data --> B{Periksa Cache};
      B -- Cache ada --> C[1. Tampilkan Data Cache (Stale)];
      C -- Mulai Ambil Data Baru (Latar Belakang) --> D[2. Permintaan Jaringan];
      D -- Terima Data Baru --> E[3. Perbarui Cache & UI (Jika Berbeda)];

      B -- Cache tidak ada --> D;
      D -- Gagal Jaringan --> F[Tampilkan Indikator Error / Data Kosong];
  ```

  **Penjelasan Visual:**
  Diagram ini mengilustrasikan alur `Stale-While-Revalidate`. Jika data ada di _cache_, itu disajikan segera (bahkan jika basi), dan pada saat yang sama, permintaan jaringan untuk data terbaru diluncurkan di latar belakang. Setelah data terbaru diterima, _cache_ dan UI diperbarui. Jika _cache_ kosong, aplikasi akan menunggu data jaringan.

# Selamat!

Kita telah menyelesaikan **Fase 6: Networking & Data Management**.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-7/README.md
[pro6]: ../../pro/bagian-6/README.md

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
