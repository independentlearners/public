> [pro][fase6]

# **[FASE 6: Networking & Data Management][0]**

### Daftar Isi

<details>
  <summary>📃 Struktur Materi</summary>

---

- **[8. HTTP & API Integration](#8-http--api-integration)**
  - **[8.1. HTTP Client Implementation](#81-http-client-implementation)**
    - [8.1.1. `http` Package](#811-http-package)
    - [8.1.2. `dio` Advanced HTTP Client](#812-dio-advanced-http-client)
  - **[8.2. JSON & Data Serialization](#82-json--data-serialization)**
    - [8.2.1. Manual JSON Serialization](#821-manual-json-serialization)
    - [8.2.2. Code Generation untuk Serialization (`json_serializable`)](#822-code-generation-untuk-serialization-json_serializable)
    - [8.2.3. Advanced Serialization dengan `freezed`](#823-advanced-serialization-dengan-freezed)
- **[9. Local Data Storage](#9-local-data-storage)**
  - **[9.1. Key-Value Storage](#91-key-value-storage)**
    - [9.1.1. SharedPreferences](#911-sharedpreferences)
    - [9.1.2. Secure Storage](#92-database-solutions)
  - **[9.2. Database Solutions](#92-database-solutions)**
    - [9.2.1. SQLite Integration (`sqflite`)](#921-sqlite-integration-sqflite)
    - [9.2.2. Drift (Moor) ORM](#922-drift-moor-orm)
    - [9.2.3. Hive NoSQL Database](#923-hive-nosql-database)
    - [9.2.4. Isar Database](#924-isar-database)
  - **[9.3. Caching Strategies](#93-caching-strategies)**
    - [9.3.1. HTTP Caching](#931-http-caching)
    - [9.3.2. Image Caching](#932-image-caching)

</details>

---

### **8. HTTP & API Integration**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah gerbang aplikasi Anda menuju dunia luar. Hampir semua aplikasi modern perlu berkomunikasi dengan server melalui internet untuk mengambil data (misalnya, berita, produk, profil pengguna), mengirim data (misalnya, postingan baru, formulir pendaftaran), atau berinteraksi dengan layanan pihak ketiga. Bagian ini mengajarkan cara melakukan komunikasi jaringan menggunakan protokol **HTTP**, cara mengelola respons dari server, dan bagaimana mengubah data mentah (seperti JSON) menjadi objek Dart yang dapat digunakan.

---

#### **8.1. HTTP Client Implementation**

##### **8.1.1. `http` Package**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Paket `http` adalah _library_ resmi yang dikelola oleh tim Dart. Ia menyediakan API tingkat tinggi yang sederhana dan mudah digunakan untuk membuat permintaan jaringan dasar. Perannya dalam kurikulum adalah sebagai **titik awal yang fundamental** untuk memahami konsep permintaan HTTP (GET, POST, PUT, DELETE) tanpa terlalu banyak kerumitan. Ini adalah alat yang sempurna untuk proyek-proyek sederhana atau untuk mempelajari dasar-dasarnya.

**Konsep Kunci & Filosofi Mendalam:**

- **Simplicity and Composability:** Filosofi `http` adalah kesederhanaan. Ia menyediakan fungsi-fungsi global yang mudah dipahami (seperti `http.get()`, `http.post()`) yang mengembalikan `Future`. Ia tidak memiliki banyak konfigurasi, membuatnya mudah untuk langsung digunakan.
- **Berbasis `Future`:** Setiap permintaan jaringan adalah operasi asinkron. Oleh karena itu, semua fungsi dalam paket `http` mengembalikan sebuah `Future<Response>`, yang akan selesai dengan objek `Response` jika berhasil atau dengan sebuah `Exception` jika gagal.

**Terminologi Esensial & Penjelasan Detil:**

- **`GET`:** Meminta atau "mengambil" data dari sebuah sumber/URL.
- **`POST`:** Mengirim data ke server untuk "membuat" sumber daya baru (misalnya, membuat pengguna baru).
- **`PUT` / `PATCH`:** Mengirim data untuk "memperbarui" sumber daya yang sudah ada. `PUT` biasanya mengganti seluruh objek, sedangkan `PATCH` hanya memperbarui sebagian.
- **`DELETE`:** Menghapus sumber daya di server.
- **`Headers`:** Metadata yang dikirim bersamaan dengan permintaan, berisi informasi seperti tipe konten (`Content-Type`) atau token otorisasi (`Authorization`).
- **`Body`:** "Isi" dari permintaan, biasanya digunakan pada `POST` dan `PUT` untuk mengirim data (seringkali dalam format JSON).
- **`Response`:** Objek yang dikembalikan oleh server, berisi `statusCode` (mis. 200 untuk OK, 404 untuk Not Found), `headers`, dan `body` (data respons).

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh pengambilan daftar "todos" dari API publik (JSONPlaceholder).

```dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Gunakan alias untuk menghindari konflik nama
import 'dart:convert'; // Untuk jsonDecode

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget { /* ... */ }

// Model sederhana untuk data kita
class Todo {
  final int id;
  final String title;
  final bool completed;
  Todo({required this.id, required this.title, required this.completed});
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});
  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late Future<List<Todo>> _todosFuture;

  // 1. Fungsi untuk melakukan permintaan HTTP GET
  Future<List<Todo>> fetchTodos() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/todos');
    try {
      // 2. Kirim request dan 'await' responsnya
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      // 3. Periksa status code. 200 berarti OK.
      if (response.statusCode == 200) {
        // 4. Ubah body (string JSON) menjadi List<dynamic>
        final List<dynamic> data = jsonDecode(response.body);
        // 5. Ubah setiap item di List menjadi objek Todo
        return data.map((item) => Todo(
          id: item['id'],
          title: item['title'],
          completed: item['completed'],
        )).toList();
      } else {
        // Jika server mengembalikan error
        throw Exception('Gagal memuat data. Status: ${response.statusCode}');
      }
    } catch (e) {
      // Menangani error koneksi atau lainnya
      throw Exception('Terjadi error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _todosFuture = fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HTTP Package Demo')),
      body: FutureBuilder<List<Todo>>(
        future: _todosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(todo.id.toString())),
                  title: Text(todo.title),
                  trailing: Icon(
                    todo.completed ? Icons.check_box : Icons.check_box_outline_blank,
                    color: todo.completed ? Colors.green : Colors.grey,
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Tidak ada data.'));
        },
      ),
    );
  }
}
```

### **Visualisasi Hasil Kode**

```
┌──────────────────────────────────┐
│  Tampilan Todo List              │
├──────────────────────────────────┤
│ AppBar: [HTTP Package Demo]      │
│ -------------------------------- │
│ ┌───┐                            │
│ │ 1 │  delectus aut autem    [v] │  (v = check)
│ └───┘                            │
│ -------------------------------- │
│ ┌───┐                            │
│ │ 2 │  quis ut nam facilis   [ ] │
│ └───┘                            │
│ -------------------------------- │
│ ┌───┐                            │
│ │ 3 │  fugiat veniam minus   [ ] │
│ └───┘                            │
│ ... (dan seterusnya)             │
└──────────────────────────────────┘
```

### **Representasi Diagram Alur (Request-Response)**

```
┌──────────────────────────┐
│  fetchTodos()            │ // Fungsi dipanggil
│  (Fungsi Asinkron)       │
└───────────┬──────────────┘
            │
┌───────────▼──────────────┐
│  http.get(url, ...)      │ // Mengirim permintaan GET
│  (Aksi HTTP)             │─────────┐
└───────────┬──────────────┘         ▼
            │ (Menunggu Future)  Server memproses & mengirim kembali
            │
┌───────────▼──────────────┐
│  Response                │ // Objek hasil dari server
│  (Hasil Future)          │
│  ┌─────────────────────┐ │
│  │ statusCode: 200     │ │
│  │ body: '[{"id":1...}]│ │
│  └─────────────────────┘ │
└───────────┬──────────────┘
            │
┌───────────▼──────────────┐
│  if (response.statusCode)│ // Pengecekan status
│  (Logika Kondisional)    │
└───────────┬──────────────┘
            │
┌───────────▼──────────────┐
│jsonDecode(response.body) │ // Parsing string JSON
│(Deserialisasi Data)      │
└───────────┬──────────────┘
            │
┌───────────▼──────────────┐
│  return List<Todo>       │ // Mengembalikan data terstruktur
│  (Hasil Akhir Fungsi)    │
└──────────────────────────┘
```

---

##### **8.1.2. `dio` Advanced HTTP Client**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**Dio** adalah _library_ HTTP klien pihak ketiga yang sangat kuat dan populer. Jika `http` adalah pisau dapur standar, `dio` adalah pisau koki Swiss Army. Ia menyediakan semua fungsionalitas `http`, ditambah fitur-fitur canggih seperti **interceptors**, pembatalan permintaan, penanganan _form-data_, unggah/unduh file dengan progres, dan banyak lagi. Perannya dalam kurikulum adalah sebagai solusi **tingkat lanjut dan enterprise** untuk menangani skenario jaringan yang kompleks, yang umum ditemui di aplikasi produksi.

**Konsep Kunci & Filosofi Mendalam:**

- **Konfigurasi Global dan Instansiasi:** Berbeda dengan `http` yang menggunakan fungsi global, `dio` bekerja dengan membuat sebuah **instans** dari kelas `Dio`. Anda dapat mengkonfigurasi opsi dasar (seperti `baseUrl`, `headers`, `timeout`) pada instans ini, dan semua permintaan yang dibuat melaluinya akan mewarisi konfigurasi tersebut.
- **Interceptors (Pencegat):** Ini adalah fitur paling kuat dari `dio`. _Interceptor_ adalah "penjaga" yang dapat mencegat dan memodifikasi permintaan (`onRequest`), respons (`onResponse`), atau error (`onError`) secara global.
  - **Kegunaan `onRequest`:** Secara otomatis menambahkan token otorisasi ke setiap permintaan, menambahkan _header_ umum, atau mencatat (_log_) detail permintaan.
  - **Kegunaan `onResponse`:** Memproses data respons secara global, mencatat respons.
  - **Kegunaan `onError`:** Menangani error jaringan secara terpusat, mencoba me-refresh token otorisasi jika kedaluwarsa, atau memformat ulang pesan error.
- **Penanganan Error yang Lebih Baik:** `Dio` membungkus error dalam objek `DioError` yang lebih informatif, yang membedakan jenis-jenis error seperti _timeout_, error koneksi, atau respons error dari server (seperti 404 atau 500).

**Sintaks Dasar / Contoh Implementasi Inti:**
Mengimplementasikan ulang `fetchTodos` dengan `dio` dan menambahkan sebuah _interceptor_ untuk _logging_.

```dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// ... (Model Todo dan widget lainnya sama seperti sebelumnya) ...

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
          // 1. Konfigurasi baseUrl dan opsi lainnya di sini
          baseUrl: 'https://jsonplaceholder.typicode.com',
          connectTimeout: 5000,
          receiveTimeout: 3000,
        )) {
    // 2. Tambahkan Interceptor
    _dio.interceptors.add(LoggingInterceptor());
  }

  // 3. Gunakan instans dio untuk membuat permintaan
  Future<List<Todo>> fetchTodos() async {
    try {
      final response = await _dio.get('/todos'); // Path relatif terhadap baseUrl
      // Dio secara otomatis melakukan jsonDecode jika content-type adalah json
      final List<dynamic> data = response.data;
      return data.map((item) => Todo(/* ... */)).toList();
    } on DioError catch (e) {
      // 4. Penanganan error yang lebih spesifik
      // Handle error seperti timeout, koneksi, dll.
      throw Exception('Gagal memuat data: ${e.message}');
    }
  }
}

// 5. Implementasi Interceptor kustom
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('--> ${options.method.toUpperCase()} ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('<-- ${response.statusCode} ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('<!> ${err.message}');
    return super.onError(err, handler);
  }
}
```

### **Representasi Diagram Alur (Dio dengan Interceptor)**

Diagram ini menggambarkan alur sekuensial yang jelas dari sebuah permintaan HTTP yang melewati _interceptor_.

```
                ┌──────────────────────────────────┐
                │          Aplikasi Anda           │
                └─────────────────┬────────────────┘
                                  │ 1. _dio.get('/todos') dipanggil
                ┌─────────────────▼────────────────┐
                │        Dio Interceptor           │
                │     (LoggingInterceptor)         │
                └─────────────────┬────────────────┘
                                  │ 2. onRequest() dipicu
                                  │    (Mencatat: "--> GET /todos")
                ┌─────────────────▼────────────────┐
                │  handler.next(options)           │
                │  (Meneruskan permintaan asli)    │
                └─────────────────┬────────────────┘
                                  │ 3. Dio Engine mengirim request ke Server
                                  │
                                  │    ( ... Jaringan & Server Bekerja ... )
                                  │
                                  │ 4. Server mengirimkan Response kembali
                ┌─────────────────▼────────────────┐
                │        Dio Interceptor           │
                │     (LoggingInterceptor)         │
                └─────────────────┬────────────────┘
                                  │ 5. onResponse() dipicu
                                  │    (Mencatat: "<-- 200 /todos")
                ┌─────────────────▼────────────────┐
                │ handler.next(response)           │
                │ (Meneruskan respons asli)        │
                └─────────────────┬────────────────┘
                                  │ 6. Future di _dio.get() selesai
                                  │    dengan objek Response.
                ┌─────────────────▼────────────────┐
                │          Aplikasi Anda           │
                │ (Menerima dan memproses data)    │
                └──────────────────────────────────┘
```

Diagram ini juga menunjukkan bagaimana _Interceptor_ berada di "tengah-tengah" alur. Setiap permintaan dan respons akan melewati _interceptor_ terlebih dahulu, memungkinkan kita untuk menjalankan logika global sebelum permintaan dikirim atau sebelum data diterima oleh pemanggil.

---

### **8.2. JSON & Data Serialization**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**JSON (JavaScript Object Notation)** adalah format standar de-facto untuk pertukaran data di web. API hampir selalu mengembalikan data dalam bentuk string JSON. **Serialization** (atau _encoding_) adalah proses mengubah objek Dart menjadi string JSON untuk dikirim ke server. **Deserialization** (atau _decoding_) adalah proses sebaliknya: mengubah string JSON dari server menjadi objek Dart yang terstruktur dan _type-safe_ yang bisa digunakan oleh aplikasi kita. Menguasai ini sangat penting karena data mentah dari internet tidak ada gunanya jika tidak bisa kita ubah menjadi model data yang dapat diandalkan.

---

##### **8.2.1. Manual JSON Serialization**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah pendekatan dasar di mana Anda menulis kode untuk _parsing_ JSON secara manual. Anda menggunakan _library_ `dart:convert` (khususnya `jsonDecode()`) untuk mengubah string JSON menjadi `Map<String, dynamic>` atau `List<dynamic>`, lalu Anda secara manual mengambil setiap nilai dari _map_ tersebut untuk membuat instance dari kelas model Anda. Perannya dalam kurikulum adalah untuk memahami **proses fundamental** dari serialisasi dan masalah-masalah yang muncul darinya (seperti rawan kesalahan ketik dan _boilerplate_).

**Konsep Kunci & Implementasi:**

- **`jsonDecode(source)`:** Mengambil string JSON dan mengembalikannya sebagai struktur data Dart (`Map` atau `List`).
- **`jsonEncode(object)`:** Mengambil `Map` atau `List` dan mengubahnya menjadi string JSON.
- **Factory Constructor (`fromJson`):** Konvensi umum adalah membuat sebuah _factory constructor_ bernama `fromJson` di dalam kelas model Anda. Konstruktor ini menerima `Map<String, dynamic>` dan bertanggung jawab untuk membuat instance dari kelas tersebut.
- **Method `toJson`:** Konvensi umum adalah membuat sebuah method bernama `toJson` di dalam kelas model yang mengembalikan `Map<String, dynamic>` dari properti objek, siap untuk di-_encode_ menjadi JSON.

**Sintaks Dasar / Contoh Implementasi Inti:**
Model `User` dengan parsing manual.

```dart
import 'dart:convert';

// Kelas Model
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  // 1. Factory constructor untuk deserialization (JSON -> Object)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'], // Rawan salah ketik nama field
      name: json['name'],
      email: json['email'],
    );
  }

  // 2. Method untuk serialization (Object -> JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

void main() {
  // --- Proses Deserialization ---
  const jsonString = '{"id": 1, "name": "Leanne Graham", "email": "Sincere@april.biz"}';
  final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  final userObject = User.fromJson(jsonMap);
  print('Deserialized: ${userObject.name}'); // Output: Leanne Graham

  // --- Proses Serialization ---
  final newUser = User(id: 2, name: 'Ervin Howell', email: 'Shanna@melissa.tv');
  final Map<String, dynamic> newUserMap = newUser.toJson();
  final jsonStringOutput = jsonEncode(newUserMap);
  print('Serialized: $jsonStringOutput'); // Output: {"id":2,"name":"Ervin Howell","email":"Shanna@melissa.tv"}
}
```

### **Representasi Diagram Sederhana (Alur Manual)**

```
  String JSON (dari API)
  └── jsonDecode()
      └── Map<String, dynamic>
          └── User.fromJson(map)
              ├── id: map['id']
              ├── name: map['name']
              └── email: map['email']
                  └── Object User (Hasil)

  Object User
  └── user.toJson()
      └── Map<String, dynamic>
          ├── 'id': user.id
          ├── 'name': user.name
          └── 'email': user.email
              └── jsonEncode(map)
                  └── String JSON (Hasil)
```

Kelemahan utama dari pendekatan ini adalah Anda harus menulis banyak kode berulang dan sangat rawan terhadap kesalahan pengetikan nama _key_ JSON, yang tidak akan terdeteksi oleh _compiler_.

---

Saya akan berhenti sejenak di sini untuk menjaga agar respons tidak menjadi terlalu masif dalam satu blok. Kita telah menyelesaikan bagian **8.1 HTTP Client Implementation** dan **8.2.1 Manual JSON Serialization**.

Tentu, kita lanjutkan.

Setelah melihat pendekatan manual yang rawan kesalahan, sekarang kita akan beralih ke solusi modern yang dianjurkan untuk mengatasi masalah tersebut: **code generation**.

---

##### **8.2.2. Code Generation untuk Serialization (`json_serializable`)**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Paket `json_serializable` adalah pendekatan berbasis _code generation_ untuk serialisasi JSON di Flutter. Anda hanya perlu "menghias" (memberi anotasi) kelas model Anda, dan sebuah _builder_ akan secara otomatis **menuliskan** kode `fromJson()` dan `toJson()` yang membosankan dan rawan kesalahan untuk Anda. Perannya dalam kurikulum ini adalah sebagai **praktik terbaik standar industri** untuk serialisasi JSON. Ini menghilangkan kemungkinan kesalahan pengetikan, menangani kasus-kasus kompleks (seperti _nested objects_ dan _enums_) dengan mudah, dan memastikan kode serialisasi Anda selalu sinkron dengan kelas model Anda.

**Konsep Kunci & Filosofi Mendalam:**

- **Single Source of Truth pada Model Class:** Filosofi utamanya adalah bahwa kelas model Dart Anda adalah satu-satunya sumber kebenaran. Anda hanya mendefinisikan properti dan tipenya. Semua logika konversi ke/dari JSON harus diturunkan secara otomatis dari definisi ini. Ini mengurangi duplikasi dan potensi kesalahan secara drastis.
- **Konvensi di atas Konfigurasi:** `json_serializable` bekerja dengan baik dengan asumsi bahwa nama _key_ JSON Anda cocok dengan nama properti di kelas Dart Anda (misalnya, _key_ `"userName"` cocok dengan properti `userName`). Namun, ia juga menyediakan anotasi (`@JsonKey`) untuk menangani kasus di mana nama-namanya tidak cocok (misalnya, _key_ JSON adalah `user_name`).
- **Pemisahan Kode:** Kode yang Anda tulis (kelas model) dan kode yang dihasilkan mesin (`.g.dart` file) disimpan dalam file terpisah. Ini menjaga agar file model Anda tetap bersih dan fokus pada definisi data, sementara logika implementasi yang rumit diserahkan kepada generator.

**Terminologi Esensial & Penjelasan Detil:**

- **`json_annotation`:** Paket yang berisi anotasi-anotasi yang Anda gunakan untuk menghias kelas Anda (seperti `@JsonSerializable` dan `@JsonKey`).
- **`json_serializable`:** Paket _builder_ yang sebenarnya melakukan pekerjaan untuk menghasilkan kode.
- **`build_runner`:** Paket eksekutor yang mendeteksi perubahan pada file Anda dan menjalankan _builder_ yang relevan (seperti `json_serializable`).
- **`@JsonSerializable()`:** Anotasi yang ditempatkan di atas sebuah kelas untuk memberitahu `build_runner` agar menghasilkan kode serialisasi untuk kelas tersebut.
- **`@JsonKey(name: 'json_key_name')`:** Anotasi yang ditempatkan di atas sebuah properti untuk memetakan nama properti Dart ke nama _key_ JSON yang berbeda.
- **`part 'nama_file.g.dart';`:** Pernyataan di awal file model Anda yang menghubungkannya dengan file yang akan dihasilkan oleh _code generator_.
- **`part of 'nama_file.dart';`:** Pernyataan yang secara otomatis akan ada di dalam file `.g.dart` yang dihasilkan, menghubungkannya kembali ke file model Anda.

**Sintaks Dasar / Contoh Implementasi Inti:**
Model `User` yang sama, sekarang diimplementasikan dengan `json_serializable`.

**Langkah 1: Tambahkan Dependensi**
Di `pubspec.yaml`, tambahkan:

```yaml
dependencies:
  flutter:
    sdk: flutter
  json_annotation: ^4.9.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.11
  json_serializable: ^6.8.0
```

**Langkah 2: Buat Kelas Model dengan Anotasi**

```dart
// file: models/user.dart
import 'package:json_annotation/json_annotation.dart';

// Ini menghubungkan file ini dengan kode yang akan dihasilkan
part 'user.g.dart';

// Anotasi ini memberitahu generator untuk membuat kode untuk kelas ini
@JsonSerializable()
class User {
  final int id;
  final String name;
  // Gunakan @JsonKey untuk memetakan ke nama yang berbeda di JSON
  @JsonKey(name: 'username')
  final String username;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
  });

  // 1. Hubungkan ke factory constructor yang dihasilkan
  //    Nama factory adalah _$UserFromJson
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // 2. Hubungkan ke method yang dihasilkan
  //    Nama methodnya adalah _$UserToJson
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

**Langkah 3: Jalankan Code Generator**
Di terminal, dari direktori root proyek Anda, jalankan:
`flutter pub run build_runner build --delete-conflicting-outputs`

Perintah ini akan membuat file baru bernama `user.g.dart` di dalam direktori `models`.

**File yang Dihasilkan (`user.g.dart` - Anda tidak perlu mengedit file ini):**

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String, // Menggunakan nama 'username' dari @JsonKey
      email: json['email'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'email': instance.email,
    };
```

Seperti yang Anda lihat, generator telah menulis semua kode manual yang membosankan untuk kita dengan cara yang aman.

### **Representasi Diagram Alur (Code Generation)**

Diagram ini lebih menekankan pada peran yang berbeda antara "Developer", "Alat", dan "Hasil".

```
┌──────────────────────────────────────────────────────────────┐
│  LANGKAH 1: AKSI DEVELOPER                                   │
│  (Anda menulis definisi di `models/user.dart`)               │
└──────────────────────────┬───────────────────────────────────┘
                           │
             ┌─────────────▼──────────────┐
             │ @JsonSerializable()        │
             │ class User {               │
             │   // Properti (id, name...)│
             │                            │
             │   // Menunjuk ke kode      │
             │   // yang BELUM ada:       │
             │   factory User.fromJson    │
             │     => _$UserFromJson;     │
             │                            │
             │   Map toJson()             │
             │     => _$UserToJson;       │
             │ }                          │
             └────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│  LANGKAH 2: AKSI ALAT (TOOLING)                              │
│  (Anda menjalankan `flutter pub run build_runner build`)     │
└──────────────────────────┬───────────────────────────────────┘
                           │
             ┌─────────────▼───────────────────┐
             │ Build Runner                    │
             │ --------------------------      │
             │ 1. Memindai proyek              │
             │ 2. Menemukan @JsonSerializable  │
             │ 3. Membaca struktur `User`      │
             │ 4. Memanggil `json_serializable`│
             │ 5. Menulis file baru            │
             └─────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│  LANGKAH 3: HASIL (GENERATED CODE)                           │
│  (File `models/user.g.dart` dibuat secara otomatis)          │
└──────────────────────────┬───────────────────────────────────┘
                           │
             ┌─────────────▼──────────────┐
             │ // KODE YANG DIHASILKAN    │
             │                            │
             │ // Implementasi dari       │
             │ // _$UserFromJson:         │
             │ User _$UserFromJson(...) { │
             │   return User(             │
             │     id: json['id'],        │
             │     ...                    │
             │   );                       │
             │ }                          │
             │                            │
             │ // Implementasi dari       │
             │ // _$UserToJson:           │
             │ Map _$UserToJson(...) {..} │
             └────────────────────────────┘
```

Diagram ini menunjukkan alur kerja di mana developer hanya perlu mendefinisikan "apa" (struktur kelas dan anotasi), dan `build_runner` akan menangani "bagaimana" (implementasi logika serialisasi).

---

##### **8.2.3. Advanced Serialization dengan `freezed`**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**Freezed** adalah _code generator_ yang lebih kuat lagi, yang dibangun di atas fungsionalitas `json_serializable`. Freezed tidak hanya menghasilkan kode serialisasi JSON, tetapi juga menciptakan kelas-kelas data yang **immutable** (tidak bisa diubah setelah dibuat), lengkap dengan implementasi metode `copyWith`, `==`, `hashCode`, dan `toString` secara otomatis. Perannya dalam kurikulum adalah sebagai solusi **tingkat lanjut dan sangat direkomendasikan** untuk pembuatan model data. Ia mengurangi _boilerplate_ hingga ke tingkat minimum dan memberlakukan praktik terbaik (seperti imutabilitas) yang membuat state aplikasi Anda jauh lebih prediktif dan aman.

**Konsep Kunci & Filosofi Mendalam:**

- **Immutability by Default:** Filosofi utama Freezed adalah bahwa objek _state_ tidak boleh dimodifikasi. Jika Anda perlu mengubah sebuah properti, Anda harus membuat **salinan** baru dari objek tersebut dengan nilai yang diperbarui. Freezed secara otomatis menghasilkan metode `copyWith` yang membuat proses ini sangat mudah. Ini sangat cocok dengan pola state management modern seperti BLoC dan Riverpod.
- **Boilerplate Elimination:** Freezed menghilangkan hampir semua kode berulang yang terkait dengan kelas data. Anda hanya perlu mendefinisikan "bentuk" dari kelas Anda menggunakan _factory constructor_, dan Freezed akan menghasilkan sisanya.
- **Union Types dan Sealed Classes:** Freezed unggul dalam membuat "sealed classes" atau "union types", yaitu sebuah kelas yang memiliki beberapa kemungkinan sub-tipe yang telah ditentukan. Ini sangat kuat untuk merepresentasikan _state_. Contoh: `sealed class NetworkState { ... }` bisa memiliki sub-tipe `NetworkState.initial()`, `NetworkState.loading()`, `NetworkState.success(data)`, dan `NetworkState.failure(error)`.

**Sintaks Dasar / Contoh Implementasi Inti:**
Model `User` yang sama, sekarang dibuat dengan `freezed`.

**Langkah 1: Tambahkan Dependensi**
Di `pubspec.yaml`:

```yaml
dependencies:
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0 # Tetap dibutuhkan

dev_dependencies:
  build_runner: ^2.4.11
  freezed: ^2.5.2
  json_serializable: ^6.8.0 # Tetap dibutuhkan
```

**Langkah 2: Buat Kelas Model dengan Sintaks Freezed**

```dart
// file: models/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart'; // Menghasilkan implementasi class
part 'user.g.dart';      // Menghasilkan logika JSON

// Anotasi @freezed
@freezed
class User with _$User {
  // 1. Definisikan bentuk class Anda dengan factory constructor
  const factory User({
    required int id,
    required String name,
    @JsonKey(name: 'username') required String username,
    required String email,
  }) = _User; // _User adalah kelas pribadi yang akan dibuat oleh Freezed

  // 2. Hubungkan ke factory constructor JSON.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

**Langkah 3: Jalankan Code Generator**
Jalankan perintah yang sama seperti sebelumnya: `flutter pub run build_runner build --delete-conflicting-outputs`. Ini akan menghasilkan `user.freezed.dart` DAN `user.g.dart`.

**Cara Menggunakannya (Keuntungan `copyWith`):**

```dart
void main() {
  final user1 = User(id: 1, name: 'John', username: 'john_d', email: 'john@example.com');

  // Membuat salinan dari user1, hanya mengubah nama.
  // user1 asli tetap tidak berubah (immutable).
  final user2 = user1.copyWith(name: 'Jonathan');

  print(user1.name); // Output: John
  print(user2.name); // Output: Jonathan
}
```

### **Visualisasi Konseptual (Manfaat Freezed)**

```
┌───────────────────────────┐
│ Anda Menulis Kode         │
│ (models/user.dart)        │
└───────────┬───────────────┘
            │
┌───────────▼───────────────┐
│ @freezed                  │ // Anda hanya mendefinisikan
│ class User with _$User {  │ // "bentuk" data.
│   const factory User({    │
│     required int id,      │
│     required String name, │
│     ...                   │
│   }) = _User;             │
│ }                         │
└───────────┬───────────────┘
            │
┌───────────▼───────────────┐
│ build_runner              │ // Generator bekerja
└───────────┬───────────────┘
            │
┌───────────▼───────────────┐
│ File yang Dihasilkan      │
│ (.freezed.dart, .g.dart)  │
│ ┌───────────────────────┐ │
│ │class _User implements User │ // Implementasi kelas utama
│ │-----------------------│ │
│ │final int id;          │ │ // Properti final (immutable)
│ │final String name;     │ │
│ │-----------------------│ │
│ │copyWith(...) { ... }  │ │ // Metode penyalinan otomatis
│ │-----------------------│ │
│ │operator ==(...) {...} │ │ // Perbandingan objek
│ │-----------------------│ │
│ │hashCode { ... }       │ │ // Kode hash
│ │-----------------------│ │
│ │toString() { ... }     │ │ // Representasi string
│ ├───────────────────────┤ │
│ │ fromJson(...) {...}   │ │ // Logika deserialisasi JSON
│ ├───────────────────────┤ │
│ │ toJson() { ... }      │ │ // Logika serialisasi JSON
│ └───────────────────────┘ │
└───────────────────────────┘
```

Diagram ini menunjukkan bagaimana dengan menulis kode yang sangat minimal, `freezed` menghasilkan serangkaian besar fungsionalitas yang aman dan berguna, menegakkan praktik terbaik secara otomatis.

---

Kita telah menyelesaikan bagian penting mengenai **HTTP & JSON Serialization**. Kita akan melanjutkan ke bagian berikutnya dari Fase 6.

### **9. Local Data Storage**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Tidak semua data perlu diambil dari internet setiap saat. Menyimpan data secara lokal di perangkat pengguna (**persistence**) sangat penting untuk:

1.  **Fungsionalitas Offline:** Aplikasi tetap dapat digunakan meskipun tidak ada koneksi internet.
2.  **Performa:** Mengambil data dari disk lokal jauh lebih cepat daripada dari jaringan.
3.  **Menghemat Kuota:** Mengurangi jumlah permintaan jaringan.
4.  **Menyimpan Preferensi:** Mengingat pilihan pengguna, seperti tema gelap atau status login.

Bagian ini akan membahas berbagai metode penyimpanan lokal, dari yang paling sederhana (key-value) hingga database yang kompleks.

---

#### **9.1. Key-Value Storage**

##### **9.1.1. SharedPreferences**

**Deskripsi Konkret & Peran dalam Kurikulum:**
`SharedPreferences` adalah pembungkus (_wrapper_) untuk mekanisme penyimpanan key-value sederhana bawaan platform (`NSUserDefaults` di iOS, `SharedPreferences` di Android). Ia dirancang untuk menyimpan data yang **kecil dan sederhana**, seperti pengaturan pengguna, flag (misalnya, `telahMelihatOnboarding`), atau token sesi. Perannya dalam kurikulum adalah sebagai solusi **paling mudah dan cepat** untuk menyimpan data non-kritis yang tidak terstruktur.

**Konsep Kunci & Implementasi:**

- **Key-Value:** Bekerja seperti `Map`. Anda menyimpan sebuah nilai (Value) dengan sebuah kunci unik (Key) bertipe `String`.
- **Asinkron:** Semua operasi tulis (`set*`) bersifat asinkron dan mengembalikan `Future<bool>`.
- **Tipe Data Terbatas:** Hanya mendukung tipe data primitif: `bool`, `int`, `double`, `String`, dan `List<String>`. Anda tidak bisa menyimpan objek kompleks secara langsung.

**Sintaks Dasar / Contoh Implementasi Inti:**
Menyimpan dan membaca pengaturan tema aplikasi.

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const _themeKey = 'isDarkMode';

  // Menyimpan pengaturan
  Future<void> saveThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  // Membaca pengaturan
  Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    // Mengembalikan false jika key tidak ditemukan
    return prefs.getBool(_themeKey) ?? false;
  }
}

// Cara menggunakannya di UI
class SettingsScreen extends StatefulWidget {
  // ...
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _themeService = ThemeService();
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _themeService.getThemeMode().then((value) {
      setState(() {
        _isDarkMode = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Mode Gelap'),
      value: _isDarkMode,
      onChanged: (newValue) {
        setState(() {
          _isDarkMode = newValue;
        });
        _themeService.saveThemeMode(newValue);
      },
    );
  }
}
```

### **Representasi Diagram Sederhana (Struktur Penyimpanan)**

```
  SharedPreferences
  ├── 'isDarkMode': true (bool)
  ├── 'username': 'john_doe' (String)
  ├── 'login_attempts': 3 (int)
  └── 'recent_searches': ['flutter', 'dart'] (List<String>)
```

---

##### **9.1.2. Secure Storage**

**Deskripsi Konkret & Peran dalam Kurikulum:**
`SharedPreferences` **tidak aman**. Datanya disimpan dalam teks biasa di perangkat dan dapat diakses jika perangkat di-_root_ atau di-_jailbreak_. Untuk data yang sangat sensitif (seperti token otorisasi, kunci API, atau data pribadi), kita memerlukan solusi yang lebih aman. **Flutter Secure Storage** adalah pembungkus untuk `Keystore` (Android) dan `Keychain` (iOS), yaitu area penyimpanan aman yang disediakan oleh sistem operasi. Perannya adalah sebagai **praktik standar** untuk menyimpan semua data kredensial dan rahasia.

**Konsep Kunci & Implementasi:**

- **Enkripsi Bawaan OS:** Keamanannya tidak bergantung pada enkripsi di level aplikasi, melainkan pada mekanisme perangkat keras dan sistem operasi yang sudah teruji.
- **API Mirip Key-Value:** API-nya sangat mirip dengan `SharedPreferences`, tetapi hanya bekerja dengan `String`. Jika Anda ingin menyimpan data lain, Anda harus mengubahnya menjadi `String` terlebih dahulu (misalnya, menggunakan `jsonEncode`).
- **Asinkron:** Semua operasi juga bersifat asinkron.

**Sintaks Dasar / Contoh Implementasi Inti:**
Menyimpan dan membaca token otentikasi.

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // 1. Buat instance dari storage
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  // 2. Menyimpan token dengan aman
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // 3. Membaca token dengan aman
  Future<String?> getAuthToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // 4. Menghapus token (misalnya, saat logout)
  Future<void> deleteAuthToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
```

---

### **9.2. Database Solutions**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ketika data Anda menjadi lebih kompleks, terstruktur, dan memiliki hubungan antar satu sama lain (misalnya, seorang `User` memiliki banyak `Post`, dan setiap `Post` memiliki banyak `Comment`), penyimpanan key-value sederhana sudah tidak lagi memadai. Di sinilah database berperan. Bagian ini mengajarkan cara mengintegrasikan dan menggunakan berbagai jenis database lokal di dalam aplikasi Flutter, memungkinkan Anda untuk menyimpan, mengambil, dan mengelola data dalam jumlah besar dengan cara yang efisien dan terstruktur.

---

##### **9.2.1. SQLite Integration (`sqflite`)**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**SQLite** adalah sebuah _engine_ database relasional (berbasis tabel, baris, dan kolom) yang sangat populer, ringan, dan bersifat _serverless_ (tidak memerlukan server terpisah), yang tertanam langsung di dalam aplikasi. Paket `sqflite` adalah pembungkus tingkat rendah yang paling umum digunakan untuk berinteraksi dengan SQLite di Flutter. Perannya dalam kurikulum adalah sebagai **fondasi database relasional**. Mempelajari `sqflite` akan mengajarkan Anda konsep-konsep inti dari database seperti tabel, SQL _queries_ (perintah), dan transaksi, yang merupakan pengetahuan fundamental bahkan saat menggunakan alat yang lebih canggih nantinya.

**Konsep Kunci & Filosofi Mendalam:**

- **SQL sebagai Bahasa Interaksi:** Interaksi dengan `sqflite` dilakukan dengan menulis string **SQL (Structured Query Language)** mentah. Anda secara manual menulis perintah seperti `CREATE TABLE`, `INSERT`, `SELECT`, `UPDATE`, dan `DELETE`.
- **Database sebagai File:** SQLite menyimpan seluruh database (tabel, skema, dan data) di dalam satu file di sistem penyimpanan perangkat. `sqflite` membantu Anda menemukan lokasi yang tepat untuk file ini dan mengelolanya.
- **Tipe Data Terbatas:** SQLite hanya memiliki beberapa tipe data inti: `INTEGER`, `REAL` (angka desimal), `TEXT`, dan `BLOB` (data biner). Anda harus memetakan tipe data Dart (seperti `bool` atau `DateTime`) ke tipe-tipe ini (misalnya, `bool` menjadi `INTEGER` 0 atau 1, `DateTime` menjadi `TEXT` format ISO 8601 atau `INTEGER` Unix timestamp).
- **Transaksi (Transactions):** Untuk memastikan integritas data saat melakukan beberapa operasi yang saling bergantung, `sqflite` mendukung transaksi. Jika salah satu operasi di dalam transaksi gagal, semua operasi sebelumnya akan dibatalkan (_rolled back_), menjaga database tetap konsisten.

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh aplikasi daftar tugas (Todo) sederhana dengan operasi CRUD (Create, Read, Update, Delete).

**Langkah 1: Definisikan Model dan Helper Database**

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Model Data
class Todo {
  final int? id; // id bisa null sebelum disimpan ke DB
  final String title;
  final bool isDone;
  // ... (constructor, copyWith, dll)
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  // 1. Inisialisasi database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // 2. Buat tabel saat database dibuat
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        isDone INTEGER NOT NULL
      )
    ''');
  }

  // 3. CREATE (membuat data baru)
  Future<int> create(Todo todo) async {
    final db = await instance.database;
    return await db.insert('todos', todo.toMap()); // `toMap` adalah method di model
  }

  // 4. READ (membaca satu data)
  Future<Todo> read(int id) async {
    final db = await instance.database;
    final maps = await db.query('todos', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Todo.fromMap(maps.first); // `fromMap` adalah method di model
    } else {
      throw Exception('ID $id not found');
    }
  }

  // 5. READ ALL (membaca semua data)
  Future<List<Todo>> readAll() async {
    final db = await instance.database;
    final result = await db.query('todos');
    return result.map((json) => Todo.fromMap(json)).toList();
  }

  // 6. UPDATE (memperbarui data)
  Future<int> update(Todo todo) async {
    final db = await instance.database;
    return await db.update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  // 7. DELETE (menghapus data)
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
```

### **Representasi Diagram Konseptual (Struktur SQLite)**

Diagram ini menunjukkan bagaimana data diorganisir dalam tabel, baris, dan kolom, serta bagaimana perintah SQL digunakan untuk berinteraksi dengannya.

```
┌─────────────────────────────────────────────────────────────┐
│  Database: todos.db (Satu File di Perangkat)                │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ Tabel: todos                                          │  │
│  │ ┌─────────┬──────────────────────┬──────────┐         │  │
│  │ │ id      │ title                │ isDone   │         │  │
│  │ │(INTEGER)│(TEXT)                │(INTEGER) │         │  │
│  │ ├─────────┼──────────────────────┼──────────┤         │  │
│  │ │ 1       │ "Belajar Flutter"    │ 1 (true) │◄────────┤
│  │ │ 2       │ "Mengerjakan Proyek" │ 0 (false)│         │  Baris (Record)
│  │ │ 3       │ "Olahraga"           │ 0 (false)│◄────────┤
│  │ └─────────┴──────────────────────┴──────────┘         │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
      ▲                ▲
      │                │
┌─────┴─────┐    ┌─────┴───────┐
│ Perintah  │    │ Perintah    │
│ SQL SELECT│    │ SQL INSERT  │
│ 'SELECT * │    │ 'INSERT INTO│
│ FROM todos│    │ todos ...'  │
└───────────┘    └─────────────┘
```

**Alur Kerja:**

- Aplikasi Anda memanggil `DatabaseHelper.create(newTodo)`.
- Helper mengubah objek `newTodo` menjadi sebuah `Map` (mis. `{'title': '...', 'isDone': 0}`).
- Helper mengeksekusi perintah SQL `INSERT INTO todos (...) VALUES (?, ?)` dengan data dari _map_.
- Data disimpan sebagai baris baru di dalam file `todos.db`.

---

Tentu, kita lanjutkan.

Menyadari bahwa menulis SQL mentah menggunakan `sqflite` bisa menjadi verbose dan rawan kesalahan (karena tidak ada pengecekan tipe saat kompilasi), komunitas Flutter mengembangkan solusi yang lebih canggih di atasnya. Mari kita masuk ke pendekatan modern untuk database relasional.

---

##### **9.2.2. Drift (Moor) ORM**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**Drift** (sebelumnya dikenal sebagai Moor) adalah sebuah **ORM (Object-Relational Mapper)** yang reaktif dan _type-safe_ untuk Flutter. ORM adalah sebuah teknik yang "memetakan" tabel dan baris dari database relasional ke **objek** dan kelas dalam kode Dart Anda. Alih-alih menulis string SQL, Anda mendefinisikan tabel dan menulis _query_ menggunakan kode Dart murni. Drift kemudian menggunakan _code generation_ untuk mengubah kode Dart tersebut menjadi SQL yang efisien di belakang layar. Perannya dalam kurikulum adalah sebagai solusi **tingkat lanjut dan sangat direkomendasikan** untuk bekerja dengan SQLite. Ia menggabungkan kekuatan database relasional dengan keamanan dan kemudahan dari _type-safety_ dan _code generation_.

**Konsep Kunci & Filosofi Mendalam:**

- **Schema in Dart, not SQL:** Filosofi utamanya adalah Anda tidak perlu lagi menyentuh SQL untuk mendefinisikan struktur database Anda. Anda mendefinisikan tabel sebagai kelas-kelas Dart yang meng-extend `Table`. Anda mendefinisikan kolom sebagai variabel dengan tipe seperti `IntColumn`, `TextColumn`, dll. Ini membuat skema Anda menjadi bagian dari kode Dart yang dapat diperiksa oleh _compiler_.
- **Type-Safe Queries:** Anda tidak lagi menulis `SELECT * FROM todos WHERE id = ?`. Sebaliknya, Anda menulis kode Dart yang mirip seperti ini: `(select(todos)..where((t) => t.id.equals(1))).get()`. Karena ini adalah kode Dart, _compiler_ akan error jika Anda mencoba membandingkan kolom `id` (integer) dengan sebuah `String`, atau jika Anda salah mengetik nama kolom. Ini secara drastis mengurangi _runtime errors_.
- **Reactive API by Default:** Keunggulan besar dari Drift adalah kemampuannya untuk mengembalikan hasil _query_ sebagai `Stream`. Anda bisa "menonton" (`watch`) sebuah _query_. Setiap kali data yang relevan dengan _query_ tersebut berubah di dalam tabel (misalnya, ada data baru yang di-`INSERT`, di-`UPDATE`, atau di-`DELETE`), Drift akan secara otomatis menjalankan ulang _query_ tersebut dan memancarkan hasil terbarunya ke `Stream`. Ini sangat cocok untuk dihubungkan ke `StreamBuilder` di UI.
- **Migrations Made Easy:** Drift memiliki sistem migrasi bawaan yang kuat untuk menangani perubahan skema database Anda dari waktu ke waktu saat aplikasi berkembang.

**Terminologi Esensial & Penjelasan Detil:**

- **`Table`:** Kelas dasar yang Anda _extend_ untuk mendefinisikan setiap tabel dalam database Anda.
- **`IntColumn`, `TextColumn`, `BoolColumn`, `DateTimeColumn`:** Tipe-tipe kolom yang Anda gunakan untuk mendefinisikan skema tabel Anda di dalam Dart.
- **`@DriftDatabase`:** Anotasi yang Anda tempatkan pada sebuah kelas `AppDatabase` untuk memberitahu Drift tabel mana saja yang termasuk dalam database ini dan untuk menghasilkan kode akses data.
- **DAO (Data Access Object):** Pola opsional namun direkomendasikan di Drift. DAO adalah kelas di mana Anda mengelompokkan semua _query_ yang terkait dengan tabel tertentu, menjaga kode Anda tetap terorganisir.
- **`.watch()` vs `.get()`:**
  - `.get()`: Menjalankan _query_ satu kali dan mengembalikan `Future` berisi hasilnya.
  - `.watch()`: Menjalankan _query_ dan mengembalikan `Stream` yang akan memancarkan hasil baru setiap kali data yang relevan berubah.

**Sintaks Dasar / Contoh Implementasi Inti:**
Refactoring aplikasi Todo kita untuk menggunakan Drift.

**Langkah 1: Definisikan Tabel dan Database**

```dart
// file: database/app_database.dart
import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart'; // Dihasilkan oleh build_runner

// 1. Definisikan Tabel menggunakan Dart
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
}

// 2. Anotasi Database dan hubungkan tabel
@DriftDatabase(tables: [Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // --- Metode Query (bisa juga ditaruh di DAO) ---
  Future<List<Todo>> getAllTodos() => select(todos).get();
  Stream<List<Todo>> watchAllTodos() => select(todos).watch();
  Future<int> insertTodo(TodosCompanion todo) => into(todos).insert(todo);
  Future<bool> updateTodo(TodosCompanion todo) => update(todos).replace(todo);
  Future<int> deleteTodo(int id) => (delete(todos)..where((t) => t.id.equals(id))).go();
}

// Fungsi untuk membuka koneksi database
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
```

**Langkah 2: Jalankan Code Generator**
`flutter pub run build_runner build --delete-conflicting-outputs`
Ini akan menghasilkan `app_database.g.dart` yang berisi kelas `_$AppDatabase`, kelas data `Todo`, dan `TodosCompanion`. `TodosCompanion` digunakan untuk operasi tulis (insert/update) untuk menangani nilai yang mungkin `null`.

**Langkah 3: Gunakan di UI**

```dart
// Di dalam StatefulWidget
late AppDatabase database;

@override
void initState() {
  super.initState();
  database = AppDatabase();
}

@override
void dispose() {
  database.close();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return StreamBuilder<List<Todo>>(
    // Gunakan .watch() untuk UI yang reaktif
    stream: database.watchAllTodos(),
    builder: (context, snapshot) {
      final todoItems = snapshot.data ?? [];
      // ... bangun ListView.builder dari todoItems ...
    },
  );
}

// Untuk menambahkan todo baru:
void _addTodo() {
  final newTodo = TodosCompanion(
    title: Value('Todo baru dari Drift'),
    isDone: Value(false),
  );
  database.insertTodo(newTodo);
}
```

### **Representasi Diagram Alur (Drift Abstraction)**

Diagram ini menunjukkan bagaimana Drift menyediakan lapisan abstraksi yang aman di atas `sqflite`.

```
┌──────────────────────────────────┐
│  Aplikasi Anda (UI / BLoC)       │
│  (Bekerja dengan Objek Dart)     │
└─────────────────┬────────────────┘
                  │ 1. Memanggil `database.watchAllTodos()`
┌─────────────────▼────────────────┐
│  Drift Query Engine & DAO        │
│  (Anda menulis kode Dart         │
│   type-safe, mis. select(todos)) │
└─────────────────┬────────────────┘
                  │ 2. Drift menerjemahkan `select(todos)` menjadi SQL
┌─────────────────▼────────────────┐
│  Generated Code                  │
│  (`app_database.g.dart`)         │
└─────────────────┬────────────────┘
                  │ 3. Kode yang dihasilkan memanggil `sqflite`
┌─────────────────▼────────────────┐
│  `sqflite` Plugin                │
│  (Mengeksekusi SQL mentah)       │
└─────────────────┬────────────────┘
                  │ 4. `sqflite` berinteraksi dengan file database
┌─────────────────▼────────────────┐
│  SQLite Engine (File .db)        │
│  (Database aktual di perangkat)  │
└──────────────────────────────────┘
```

Alur ini menunjukkan bagaimana Anda sebagai developer hanya perlu peduli pada dua lapisan teratas (Logika Aplikasi dan Drift API), sementara kerumitan SQL dan interaksi tingkat rendah ditangani secara otomatis oleh _code generator_ dan _plugin_.

---

##### **9.2.3. Hive NoSQL Database**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**Hive** adalah sebuah database **NoSQL key-value** yang sangat cepat dan ringan, ditulis sepenuhnya dalam Dart. Berbeda dengan SQLite yang relasional (berbasis tabel), Hive bekerja lebih seperti `Map` super cepat yang disimpan ke disk. Ia menyimpan objek Dart secara langsung (setelah diadaptasi) tanpa perlu konversi ke format relasional. Perannya dalam kurikulum adalah sebagai **solusi berkinerja tinggi** untuk kasus di mana Anda tidak memerlukan kemampuan _query_ relasional yang kompleks. Ia sangat cocok untuk menyimpan _cache_ data dari API atau daftar objek yang relatif sederhana.

**Konsep Kunci & Filosofi Mendalam:**

- **Key-Value & Boxes:** Data di Hive diorganisir ke dalam **Boxes**. Sebuah _Box_ mirip seperti sebuah tabel di SQL atau sebuah `Map` di Dart. Setiap _item_ di dalam _Box_ disimpan dengan sebuah _key_ unik (bisa `int` atau `String`).
- **Dart-Native & Blazing Fast:** Karena ditulis dalam Dart murni, Hive tidak memiliki jembatan ke kode _native_ (seperti `sqflite`), yang membuatnya sangat cepat untuk operasi baca/tulis sederhana.
- **Type Adapters:** Untuk menyimpan objek kustom Anda (seperti kelas `User` atau `Todo`), Anda perlu membuat sebuah **`TypeAdapter`**. _Adapter_ ini memberitahu Hive bagaimana cara mengubah objek Anda menjadi representasi biner dan sebaliknya. Sama seperti serialisasi JSON, proses pembuatan _adapter_ ini dapat diotomatisasi dengan _code generation_.
- **Lazy Loading:** Hive mendukung "lazy boxes", di mana hanya _key_ yang dimuat ke memori saat _box_ dibuka. Nilai-nilainya hanya dibaca dari disk saat benar-benar diakses, sangat efisien untuk dataset yang sangat besar.

**Sintaks Dasar / Contoh Implementasi Inti:**
Menyimpan dan membaca objek `Todo` dengan Hive.

**Langkah 1: Definisikan Model dengan Anotasi Hive**

```dart
// file: models/todo_hive.dart
import 'package:hive/hive.dart';

part 'todo_hive.g.dart'; // Dihasilkan oleh build_runner

// 1. Anotasi kelas dengan @HiveType dan typeId unik
@HiveType(typeId: 1)
class Todo {
  // 2. Anotasi setiap field dengan @HiveField dan indeks unik
  @HiveField(0)
  final String title;

  @HiveField(1)
  final bool isDone;

  Todo({required this.title, this.isDone = false});
}
```

**Langkah 2: Jalankan Code Generator**
`flutter pub run build_runner build --delete-conflicting-outputs`
Ini akan menghasilkan `todo_hive.g.dart` yang berisi `TodoAdapter`.

**Langkah 3: Inisialisasi Hive dan Gunakan**

```dart
// Di dalam fungsi main()
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  // 1. Inisialisasi Hive
  Hive.init(appDocumentDir.path);
  // 2. Daftarkan adapter yang dihasilkan
  Hive.registerAdapter(TodoAdapter());
  runApp(const MyApp());
}

class HiveTodoService {
  final String _boxName = 'todos';

  // Menambahkan todo baru
  Future<void> addTodo(Todo todo) async {
    final box = await Hive.openBox<Todo>(_boxName);
    await box.add(todo); // Menggunakan auto-incrementing key (int)
  }

  // Mendapatkan semua todos
  Future<List<Todo>> getAllTodos() async {
    final box = await Hive.openBox<Todo>(_boxName);
    return box.values.toList();
  }

  // Menonton perubahan (Hive mendukung ini secara native)
  Future<Stream<BoxEvent>> watchTodos() async {
    final box = await Hive.openBox<Todo>(_boxName);
    return box.watch();
  }
}
```

### **Representasi Diagram Sederhana (Struktur Hive)**

```
  Hive Database
  └── Box<Todo> (nama: 'todos')
      ├── 0: Object Todo { title: "Belajar Hive", isDone: true }
      ├── 1: Object Todo { title: "Coba TypeAdapters", isDone: false }
      ├── 2: Object Todo { title: "Bandingkan Performa", isDone: false }
      └── 'user_settings': Object Settings { theme: "dark" } // Bisa juga key String
```

---

##### **9.2.4. Isar Database**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**Isar** adalah database NoSQL _cross-platform_ yang sangat cepat, modern, dan kaya fitur, yang juga dibuat oleh penulis Hive. Ia mencoba mengambil yang terbaik dari kedua dunia: kecepatan dan kemudahan database NoSQL key-value, dengan kemampuan _query_ yang kaya dan indeks yang kuat seperti pada database relasional. Perannya dalam kurikulum adalah sebagai **solusi generasi berikutnya** yang sangat kuat untuk penyimpanan lokal. Ia menawarkan kemudahan penggunaan, performa luar biasa, dan fitur-fitur canggih seperti _full-text search_ dan _multi-property indexes_ langsung dari kotak.

**Konsep Kunci & Filosofi Mendalam:**

- **Object-Oriented Database:** Isar dirancang untuk menyimpan objek Dart secara langsung. Anda tidak berpikir dalam istilah baris atau dokumen JSON; Anda berpikir dalam istilah objek dan koleksi objek.
- **Query yang Type-Safe dan Ekspresif:** Sama seperti Drift, Isar menyediakan API _query builder_ yang _type-safe_ dan mudah dibaca. Anda dapat memfilter, menyortir, dan membatasi hasil dengan mudah.
- **Indeks adalah Kunci Performa:** Isar sangat menekankan penggunaan indeks. Anda dapat membuat indeks pada properti apa pun untuk mempercepat _query_ secara dramatis. Ia bahkan mendukung indeks komposit (pada beberapa properti) dan _full-text search_.
- **Reaktifitas:** Sama seperti Drift dan Hive, _query_ Isar juga dapat "ditonton" (`.watch()`) untuk memberikan `Stream` hasil yang reaktif.

**Sintaks Dasar / Contoh Implementasi Inti:**
Model `Todo` yang sama, diimplementasikan dengan Isar.

**Langkah 1: Definisikan Skema dengan Anotasi Isar**

```dart
// file: models/todo_isar.dart
import 'package:isar/isar.dart';

part 'todo_isar.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement; // Isar akan mengelola ID ini
  late String title;
  bool isDone = false;
  // Buat indeks pada field isDone untuk mempercepat query filter
  @Index()
  DateTime createdAt = DateTime.now();
}
```

**Langkah 2: Jalankan Code Generator**
`flutter pub run build_runner build --delete-conflicting-outputs`

**Langkah 3: Buka Instance Isar dan Gunakan**

```dart
class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = _openDB();
  }

  Future<Isar> _openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [TodoSchema], // Berikan semua skema Anda
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  // Operasi CRUD
  Future<void> createTodo(Todo newTodo) async {
    final isar = await db;
    // Transaksi tulis
    isar.writeTxnSync<int>(() => isar.todos.putSync(newTodo));
  }

  Stream<List<Todo>> watchAllTodos() async* {
    final isar = await db;
    yield* isar.todos.where().watch(fireImmediately: true);
  }

  // Contoh query yang lebih kompleks
  Stream<List<Todo>> watchUnfinishedTodosSorted() async* {
    final isar = await db;
    yield* isar.todos
        .filter()
        .isDoneEqualTo(false) // Gunakan indeks
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }
}
```

### **Visualisasi Konseptual (Perbandingan Database)**

```
┌───────────────────────────┐      ┌───────────────────────────┐      ┌───────────────────────────┐
│ SQLite (`sqflite`)        │      │ Hive                      │      │ Isar                      │
├───────────────────────────┤      ├───────────────────────────┤      ├───────────────────────────┤
│ Model: Relasional (Tabel) │      │ Model: Key-Value (Box)    │      │ Model: Objek (Koleksi)    │
│ Bahasa: SQL mentah (String)│      │ Bahasa: Dart API (put, get) │      │ Bahasa: Dart Query Builder│
│ Type Safety: Rendah       │      │ Type Safety: Sedang (Adapter)│      │ Type Safety: Tinggi     │
│ Query: Sangat Kuat (JOINs)│      │ Query: Sederhana (Key lookup)│      │ Query: Kuat (Filter, Index)│
│ Performa: Baik, tapi ada  │      │ Performa: Sangat Cepat    │      │ Performa: Sangat Cepat    │
│ overhead (plugin bridge)  │      │                           │      │                           │
└───────────────────────────┘      └───────────────────────────┘      └───────────────────────────┘
```

---

Kita telah menyelesaikan pembahasan mendalam mengenai berbagai solusi database lokal. Sekarang kita akan beralih ke bagian terakhir dari Fase 6, yaitu tentang bagaimana mengelola data sementara atau _cache_.

Saya akan melanjutkan ke **9.3. Caching Strategies**.

---

### **9.3. Caching Strategies**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**Caching** adalah proses menyimpan salinan data secara sementara di lokasi yang lebih cepat diakses. Daripada selalu mengambil data dari sumber aslinya yang lambat (seperti jaringan), kita pertama-tama memeriksa apakah salinan yang valid sudah ada di _cache_. Bagian ini mengajarkan berbagai strategi _caching_ untuk data jaringan dan gambar, yang bertujuan untuk meningkatkan performa aplikasi secara signifikan, mengurangi penggunaan data seluler, dan memberikan pengalaman offline yang lebih baik.

##### **9.3.1. HTTP Caching**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah _caching_ yang terjadi di level protokol HTTP. Server dapat memberikan "petunjuk" kepada klien (aplikasi kita) tentang berapa lama sebuah respons boleh disimpan dan digunakan kembali. _Package_ seperti `dio` dapat dikonfigurasi untuk secara otomatis menghormati petunjuk ini. Memahami ini penting untuk membuat aplikasi yang efisien dan tidak membebani server dengan permintaan yang tidak perlu.

**Konsep Kunci & Implementasi:**

- **`Cache-Control` Header:** Ini adalah _header_ yang dikirim oleh server.
  - `Cache-Control: max-age=3600`: Memberitahu klien bahwa respons ini valid selama 3600 detik (1 jam) dan boleh digunakan kembali dari _cache_ tanpa perlu bertanya ke server.
- **`ETag` (Entity Tag):** Sebuah _identifier_ unik untuk versi tertentu dari sebuah sumber daya.
  - **Alur Kerja:**
    1.  Saat pertama kali meminta data, server mengirimkan `ETag: "v1"`. Klien menyimpan data dan ETag ini.
    2.  Saat meminta data yang sama lagi, klien mengirimkan _header_ `If-None-Match: "v1"`.
    3.  Server memeriksa ETag. Jika datanya tidak berubah, server akan merespons dengan status `304 Not Modified` dan _body_ kosong. Klien kemudian menggunakan data dari _cache_-nya. Ini menghemat _bandwidth_ karena data penuh tidak perlu dikirim ulang.
- **Implementasi dengan `dio_http_cache`:** _Package_ ini menyediakan _interceptor_ yang secara otomatis mengimplementasikan logika _caching_ HTTP.

  - **Struktur:**

    ```dart
      Dio dio = Dio();
      dio.interceptors.add(DioCacheInterceptor(options: CacheOptions(
        store: MemCacheStore(), // Simpan di memori
        policy: CachePolicy.request, // Selalu coba request, tapi gunakan cache jika ada 304
      )));

      // Permintaan ini akan otomatis di-cache jika server mendukung
      dio.get("https://api.example.com/data");
    ```

---

##### **9.3.2. Image Caching**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Mengunduh gambar dari internet adalah operasi yang mahal. Melakukannya berulang kali untuk gambar yang sama akan membuang-buang _bandwidth_ dan membuat UI terasa lambat. _Image caching_ adalah proses menyimpan gambar yang telah diunduh ke memori dan/atau disk. `CachedNetworkImage` adalah _package_ yang paling populer untuk menangani ini secara otomatis.

**Konsep Kunci & Implementasi:**

- **Memory & Disk Cache:**
  - **Memory Cache:** Menyimpan gambar di RAM. Sangat cepat diakses, tetapi akan hilang saat aplikasi ditutup.
  - **Disk Cache:** Menyimpan gambar sebagai file di penyimpanan perangkat. Lebih lambat dari memori, tetapi persisten.
- **`CachedNetworkImage` Widget:** Sebuah widget siap pakai yang menggantikan `Image.network()`.
  - **Cara Kerja:** Saat pertama kali digunakan, ia akan mengunduh gambar, menampilkannya, dan menyimpannya di _cache_. Saat widget ini digunakan lagi dengan URL yang sama di tempat lain, ia akan langsung memuat gambar dari _cache_ alih-alih mengunduhnya lagi.
  - **Fitur Tambahan:** Menyediakan `placeholder` (widget yang ditampilkan saat gambar sedang diunduh) dan `errorWidget` (widget yang ditampilkan jika unduhan gagal).

**Sintaks Dasar / Contoh Implementasi Inti:**

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Caching')),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: "https://example.com/my_image.jpg",
          // Tampilkan ini saat gambar sedang loading
          placeholder: (context, url) => const CircularProgressIndicator(),
          // Tampilkan ini jika terjadi error
          errorWidget: (context, url, error) => const Icon(Icons.error),
          // Atur ukuran gambar
          width: 300,
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
```

### **Visualisasi Konseptual (Alur Image Caching)**

```
┌────────────────────────────────────────┐
│  1. CachedNetworkImage Meminta Gambar  │
│     (dengan "url_A")                   │
└─────────────────┬──────────────────────┘
                  │
┌─────────────────▼────────────────────┐
│  2. Cek Cache Memori (RAM)           │
│     Apakah "url_A" ada?              │
└────────┬───────────────────┬─────────┘
         │                   │
  (YA, DITEMUKAN)      (TIDAK DITEMUKAN)
         │                   │
┌────────▼────────┐    ┌─────▼────────────────────┐
│  5a. Tampilkan  │    │  3. Cek Cache Disk       │
│  Gambar dari    │    │     (Penyimpanan Lokal)  │
│  Memori         │    │     Apakah "url_A" ada?  │
└─────────────────┘    └─────┬──────────────────┬─┘
                             │                  │
                       (YA, DITEMUKAN)    (TIDAK DITEMUKAN)
                             │                  │
                   ┌─────────▼────────┐   ┌─────▼────────────────────┐
                   │ 4a. Muat Gambar  │   │  4b. Unduh dari Jaringan │
                   │ dari Disk ke     │   │      (Internet)          │
                   │ Memori           │   └──────────┬───────────────┘
                   └─────────┬────────┘              │
                             │                       │
                             └──────────┬────────────┘
                                        │
                             ┌──────────▼───────────────┐
                             │  5b. Tampilkan Gambar    │
                             │     (dari Disk/Jaringan) │
                             └──────────┬───────────────┘
                                        │
                             ┌──────────▼───────────────┐
                             │  6. Simpan Gambar ke     │
                             │     Cache Disk & Memori  │
                             │     (jika dari jaringan) │
                             └──────────────────────────┘
```

<!--
Diagram ini menunjukkan hierarki pengecekan: Memori -\> Disk -\> Jaringan. Data hanya diambil dari sumber yang paling lambat (Jaringan) jika tidak ditemukan di sumber yang lebih cepat. -->

Diagram ini menunjukkan alur keputusan yang lebih jelas: aplikasi selalu memeriksa sumber tercepat (Memori), lalu sumber yang lebih lambat (Disk), dan hanya sebagai pilihan terakhir ia akan menggunakan sumber paling lambat dan mahal (Jaringan).

# Selamat!

Kita telah secara resmi menyelesaikan **FASE 6: Networking & Data Management**.

Ini adalah fase yang sangat padat dan teknis. Anda telah belajar bagaimana aplikasi Anda "berbicara" dengan dunia melalui **HTTP** menggunakan `http` dan `dio`. Anda menguasai cara mengubah data mentah **JSON** menjadi objek Dart yang aman menggunakan metode manual, `json_serializable`, dan `freezed`.

Selanjutnya, Anda mendalami berbagai cara untuk membuat aplikasi Anda "mengingat" data secara lokal, mulai dari **SharedPreferences** untuk data sederhana, **Secure Storage** untuk data sensitif, hingga berbagai solusi **database** yang kuat: **SQLite** melalui `sqflite` untuk fondasi relasional, **Drift** untuk ORM yang _type-safe_, serta **Hive** dan **Isar** sebagai alternatif NoSQL yang sangat cepat. Terakhir, kita menutupnya dengan **strategi caching** untuk meningkatkan performa dan efisiensi.

Dengan selesainya fase ini, aplikasi Anda kini sepenuhnya mampu menjadi aplikasi modern yang dinamis: ia bisa berinteraksi dengan pengguna, bernavigasi, mengelola state, berkomunikasi dengan server, dan menyimpan data secara persisten.

Anda telah membangun fondasi yang sangat kokoh. Fase-fase berikutnya akan berfokus pada penyempurnaan, pengujian, dan arsitektur skala besar.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-7/README.md
[fase6]: ../../flash/bagian-6/README.md

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
