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
    - 8.2.2. Code Generation untuk Serialization (`json_serializable`)
    - 8.2.3. Advanced Serialization dengan `freezed`
- **9. Local Data Storage**
  - **9.1. Key-Value Storage**
    - 9.1.1. SharedPreferences
    - 9.1.2. Secure Storage
  - **9.2. Database Solutions**
    - 9.2.1. SQLite Integration (`sqflite`)
    - 9.2.2. Drift (Moor) ORM
    - 9.2.3. Hive NoSQL Database
    - 9.2.4. Isar Database
  - **9.3. Caching Strategies**
    - 9.3.1. HTTP Caching
    - 9.3.2. Image Caching

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

```
┌──────────────────────┐   ┌─────────────────────────┐   ┌──────────────────────┐
│ fetchTodos()         │   │ LoggingInterceptor      │   │ Dio Engine           │
│ (Fungsi dipanggil)   │   │ (Middleware)            │   │ (Mengirim ke Server) │
└──────────┬───────────┘   └───────────┬─────────────┘   └──────────┬───────────┘
           │                           │                            │
┌──────────▼───────────┐               ┌─────────────────────────┐                         │
│ _dio.get('/todos')   ├────────────►  │ onRequest()             │
│ (Aksi Dio)           │               │ (Mencatat Request)      │
└──────────────────────┘               └───────────┬─────────────┘
                                                   │
                                       ┌───────────▼─────────────┐
                                       │ handler.next(options)   ├──────────►
                                       │ (Meneruskan Request)    │
                                       └─────────────────────────┘

                                                   ( ... Server merespons ... )

                                       ┌───────────┬─────────────┐
                                       │ onResponse()            │◄──────────
                                       │ (Mencatat Response)     │
                                       └───────────┬─────────────┘
             ┌──────────────────────┐              │
             │ Menerima Response    │◄─────────────┤ handler.next(response)
             │ (di dalam fetchTodos)│              │ (Meneruskan Response)
             └──────────────────────┘              └─────────────────────────┘
```

Diagram ini menunjukkan bagaimana _Interceptor_ berada di "tengah-tengah" alur. Setiap permintaan dan respons akan melewati _interceptor_ terlebih dahulu, memungkinkan kita untuk menjalankan logika global sebelum permintaan dikirim atau sebelum data diterima oleh pemanggil.

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

**Kita akan melanjutkan dengan 8.2.2. Code Generation untuk Serialization (`json_serializable`)** di respons berikutnya. Mohon konfirmasinya untuk melanjutkan.

```
coba ulangi diagram yang kamu buat dibawah ini karena kurang jelas:

### **Representasi Diagram Alur (Dio dengan Interceptor)**

```

┌──────────────────────┐ ┌─────────────────────────┐ ┌──────────────────────┐
│ fetchTodos() │ │ LoggingInterceptor │ │ Dio Engine │
│ (Fungsi dipanggil) │ │ (Middleware) │ │ (Mengirim ke Server) │
└──────────┬───────────┘ └───────────┬─────────────┘ └──────────┬───────────┘
│ │ │
┌──────────▼───────────┐ ┌─────────────────────────┐ │
│ \_dio.get('/todos') ├────────────► │ onRequest() │
│ (Aksi Dio) │ │ (Mencatat Request) │
└──────────────────────┘ └───────────┬─────────────┘
│
┌───────────▼─────────────┐
│ handler.next(options) ├──────────►
│ (Meneruskan Request) │
└─────────────────────────┘

                                                   ( ... Server merespons ... )

                                       ┌───────────┬─────────────┐
                                       │ onResponse()            │◄──────────
                                       │ (Mencatat Response)     │
                                       └───────────┬─────────────┘
             ┌──────────────────────┐              │
             │ Menerima Response    │◄─────────────┤ handler.next(response)
             │ (di dalam fetchTodos)│              │ (Meneruskan Response)
             └──────────────────────┘              └─────────────────────────┘

```

Diagram ini menunjukkan bagaimana _Interceptor_ berada di "tengah-tengah" alur. Setiap permintaan dan respons akan melewati _interceptor_ terlebih dahulu, memungkinkan kita untuk menjalankan logika global sebelum permintaan dikirim atau sebelum data diterima oleh pemanggil.
```

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-7/README.md
[fase6]: ../

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
