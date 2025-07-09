> [pro][flash9]

# **[FASE 6: Networking & Data Management][0]**

### **Daftar Isi**

<details>
  <summary>📃 Daftar Isi</summary>

---

- **15. Testing Architecture**
  - **15.1. Unit Testing**
    - 15.1.1. Dart Unit Testing
    - 15.1.2. Advanced Unit Testing
  - **15.2. Widget Testing**
    - 15.2.1. Widget Test Framework
  - **15.3. Integration Testing**
    - 15.3.1. End-to-end Testing
- **16. Test Automation & CI/CD**
  - **16.1. Continuous Integration**
  - **16.2. Code Quality Tools**

</details>

---

### **15. Testing Architecture**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Pengujian (_testing_) adalah proses sistematis untuk memverifikasi bahwa kode Anda bekerja sesuai dengan yang diharapkan. Di Flutter, arsitektur pengujian dibagi menjadi beberapa lapisan, yang sering digambarkan sebagai "Piramida Pengujian". Di dasar piramida ada banyak _unit test_ yang cepat. Di tengah ada _widget test_ yang lebih spesifik untuk Flutter. Dan di puncak ada sedikit _integration test_ yang berjalan di seluruh aplikasi. Fase ini akan mengajarkan Anda cara menulis berbagai jenis tes untuk memastikan setiap bagian dari aplikasi Anda—mulai dari satu fungsi hingga alur pengguna yang kompleks—dapat diandalkan dan berkualitas tinggi.

### **Piramida Pengujian Flutter**

```
            / \
           / _ \      <-- Integration Tests (Sedikit, Lambat, Mahal)
          / ___ \         (Menguji seluruh aplikasi)
         / _____ \
        / _______ \   <-- Widget Tests (Cukup banyak, Cepat)
       / _________ \      (Menguji satu widget/layar)
      /___________ \
     /_____________\  <-- Unit Tests (Sangat banyak, Sangat Cepat, Murah)
    /_______________\     (Menguji satu fungsi/kelas)
```

---

#### **15.1. Unit Testing**

##### **15.1.1. Dart Unit Testing**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**Unit Test** adalah jenis tes yang memverifikasi kebenaran dari satu "unit" kode terisolasi—biasanya satu fungsi, _method_, atau kelas—tanpa ketergantungan pada Flutter UI, database, atau jaringan. Ini adalah tes yang paling cepat dan paling murah untuk ditulis dan dijalankan. Perannya dalam kurikulum adalah sebagai **fondasi dari jaminan kualitas**. Dengan memastikan setiap "batu bata" (unit) dari aplikasi Anda kokoh, Anda membangun kepercayaan diri untuk menyusunnya menjadi struktur yang lebih besar.

**Konsep Kunci & Filosofi Mendalam:**

- **Isolation (Isolasi):** Kunci utama dari _unit test_ adalah isolasi. Unit yang diuji tidak boleh bergantung pada komponen eksternal yang tidak dapat diprediksi (seperti API jaringan). Jika sebuah unit memiliki dependensi (misalnya, sebuah `Repository` yang membutuhkan `ApiService`), dependensi tersebut harus diganti dengan sebuah "objek palsu" yang disebut **Mock**.
- **Pola Arrange-Act-Assert (AAA):** Setiap _unit test_ yang baik mengikuti pola ini:
  1.  **Arrange (Atur):** Siapkan semua yang dibutuhkan untuk tes. Buat instance dari kelas yang akan diuji, buat _mock object_ untuk dependensinya.
  2.  **Act (Aksi):** Jalankan _method_ atau fungsi yang ingin Anda uji.
  3.  **Assert (Tegaskan):** Periksa apakah hasil dari aksi tersebut sesuai dengan yang Anda harapkan. Jika hasilnya sesuai, tes lulus. Jika tidak, tes gagal.
- **Mocking dengan `mockito`:** `mockito` adalah paket populer yang memudahkan pembuatan _mock objects_. Ia memungkinkan Anda untuk "menginstruksikan" sebuah _mock_ untuk berperilaku dengan cara tertentu (misalnya, "Ketika metode `fetchData()` dipanggil, kembalikan nilai `X`") dan untuk memverifikasi bahwa sebuah _method_ telah dipanggil.

**Terminologi Esensial & Penjelasan Detil:**

- **`test` framework:** Paket bawaan Dart untuk menulis dan menjalankan tes.
- **`test('deskripsi', () => ...)`:** Fungsi untuk mendefinisikan satu kasus uji.
- **`group('deskripsi', () => ...)`:** Fungsi untuk mengelompokkan beberapa tes yang terkait.
- **`expect(actual, matcher)`:** Fungsi inti untuk melakukan _assertion_. `actual` adalah nilai yang dihasilkan oleh kode Anda, dan `matcher` adalah definisi dari hasil yang diharapkan (misalnya, `equals(5)`, `isTrue`, `throwsA<Exception>()`).
- **Mock Object:** Objek palsu yang meniru perilaku objek nyata untuk tujuan pengujian.

**Sintaks Dasar / Contoh Implementasi Inti:**
Mari kita uji sebuah kelas `Counter` sederhana.

**Kode yang akan Diuji:**

```dart
// file: lib/counter.dart
class Counter {
  int _value = 0;
  int get value => _value;

  void increment() => _value++;
  void decrement() {
    if (_value <= 0) {
      throw Exception('Nilai tidak boleh negatif');
    }
    _value--;
  }
}
```

**Kode Tes:**
**Langkah 1: Tambahkan dependensi `test`** (biasanya sudah ada di `pubspec.yaml`).

**Langkah 2: Buat file tes**
Buat file baru di direktori `test/`, misalnya `test/counter_test.dart`.

```dart
// file: test/counter_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/counter.dart'; // Impor file yang akan diuji

void main() {
  // Gunakan `group` untuk mengelompokkan tes yang terkait dengan Counter
  group('Counter Class', () {
    late Counter counter;

    // `setUp` adalah fungsi khusus yang berjalan sebelum setiap tes di dalam grup ini
    setUp(() {
      // Arrange: Buat instance baru untuk setiap tes untuk memastikan isolasi
      counter = Counter();
    });

    test('Nilai awal harus 0', () {
      // Act: Tidak ada aksi, hanya memeriksa state awal
      // Assert: Periksa apakah nilainya sesuai harapan
      expect(counter.value, 0);
    });

    test('Method increment harus menambah nilai sebesar 1', () {
      // Act: Panggil method yang diuji
      counter.increment();
      // Assert
      expect(counter.value, 1);
    });

    test('Method decrement harus mengurangi nilai sebesar 1', () {
      // Arrange tambahan
      counter.increment(); // Nilai jadi 1
      // Act
      counter.decrement();
      // Assert
      expect(counter.value, 0);
    });

    test('Harus melempar Exception jika decrement dipanggil saat nilai 0', () {
      // Assert: Gunakan expect dengan callback untuk menguji exception
      expect(() => counter.decrement(), throwsA(isA<Exception>()));
    });
  });
}
```

Untuk menjalankan tes, buka terminal dan jalankan `flutter test`.

### **Representasi Diagram Alur (Pola AAA)**

```
┌──────────────────────────────────────────┐
│  test('Deskripsi Kasus Uji', () => {     │
│  ┌────────────────────────────────────┐  │
│  │  // ARRANGE                       │  │
│  │  final counter = Counter();       │  │ // Siapkan objek yang dibutuhkan
│  │  counter.increment();            │  │
│  └──────────────────┬───────────────┘  │
│                     │                  │
│  ┌──────────────────▼───────────────┐  │
│  │  // ACT                         │  │
│  │  counter.decrement();           │  │ // Panggil method yang diuji
│  └──────────────────┬───────────────┘  │
│                     │                  │
│  ┌──────────────────▼───────────────┐  │
│  │  // ASSERT                      │  │
│  │  expect(counter.value, 0);      │  │ // Bandingkan hasil aktual
│  │                                  │  │ // dengan hasil yang diharapkan
│  └────────────────────────────────┘  │
│  });                                  │
└──────────────────────────────────────────┘
```

---

##### **15.1.2. Advanced Unit Testing**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Bagian ini memperluas konsep _unit testing_ untuk menangani skenario yang lebih kompleks, seperti menguji kode asinkron, _stream_, dan memverifikasi interaksi dengan dependensi menggunakan _mock_.

**Konsep Kunci & Implementasi:**

- **Async Testing:** Fungsi `test` secara otomatis dapat menangani `Future`. Jika _body_ dari tes Anda adalah `async`, _test runner_ akan menunggu hingga `Future` selesai sebelum menyelesaikan tes.
  - **Contoh:**
    ```dart
    test('Fetch user harus mengembalikan User object', () async {
      // Arrange: siapkan mock service
      when(mockApiService.fetchUser(1)).thenAnswer((_) async => User(id: 1, name: 'Test'));
      // Act
      final user = await repository.fetchUser(1);
      // Assert
      expect(user.name, 'Test');
    });
    ```
- **Stream Testing:** Menguji `Stream` memerlukan _matcher_ khusus. `emits` adalah _matcher_ yang akan menunggu hingga sebuah _stream_ memancarkan nilai yang cocok.
  - **Contoh:**
    ```dart
    test('Stream harus memancarkan [1, 2]', () {
      // Arrange
      final myStream = Stream.fromIterable([1, 2]);
      // Assert
      expect(myStream, emitsInOrder([1, 2, emitsDone]));
    });
    ```
- **Golden File Testing:** Ini adalah jenis tes yang lebih visual. Ia mengambil sebuah widget, merendernya, lalu menyimpan hasilnya sebagai file gambar ("golden file"). Pada eksekusi tes berikutnya, ia akan merender ulang widget tersebut dan membandingkan piksel per piksel dengan _golden file_. Jika ada perbedaan, tes gagal. Ini sangat berguna untuk mencegah regresi visual yang tidak disengaja.
  - **Struktur:**
    ```dart
    testWidgets('MyWidget harus terlihat benar', (WidgetTester tester) async {
      await tester.pumpWidget(const MyWidget());
      await expectLater(
        find.byType(MyWidget),
        matchesGoldenFile('goldens/my_widget.png'),
      );
    });
    ```

---

Kita telah membahas secara mendalam tentang **Unit Testing**, lapisan pertama dan paling fundamental dalam piramida pengujian.















> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-8/README.md
[selanjutnya]: ../bagian-10/README.md
[flash9]: ../../flash/bagian-9/README.md

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
