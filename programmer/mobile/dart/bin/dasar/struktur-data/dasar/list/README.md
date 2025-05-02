# list []

**List (Array) dalam Pemrograman dan Implementasinya di Dart**

**1. Konsep Dasar List/Array**

- List (disebut _array_ di beberapa bahasa) adalah struktur data untuk menyimpan koleksi elemen secara terurut.
- **Perbedaan List dan Array Klasik**:
  - Array di bahasa seperti C/Java biasanya berukuran tetap (_fixed-size_), sedangkan List di Dart bersifat _dinamis_ (ukuran dapat berubah).
  - List di Dart dapat menyimpan berbagai tipe data (heterogen) jika tidak ditentukan tipe eksplisit.

**2. List di Dart**

- Digunakan melalui kelas `List`. Dapat dibuat dalam dua versi:
  - **Growable List**: Ukuran dinamis (default).
  - **Fixed-length List**: Ukuran tetap (jarang digunakan).

**3. Operasi Dasar List**

```dart
// Cara membuat List:
// 1. Dengan tipe eksplisit
List<String> fruits = ['Apple', 'Banana'];
// 2. Dengan tipe inferensi (Dart otomatis deteksi tipe)
var numbers = [1, 2, 3];
// 3. List kosong (bisa ditentukan tipe)
var emptyList = <int>[];

// Menambahkan elemen:
fruits.add('Mango'); // Menambah satu elemen
fruits.addAll(['Orange', 'Grape']); // Menambah beberapa elemen
print(fruits); // Output: [Apple, Banana, Mango, Orange, Grape]

// Mengakses elemen:
print(fruits[0]); // Output: Apple (indeks dimulai dari 0)

// Mengubah nilai elemen:
fruits[1] = 'Blueberry';
print(fruits); // [Apple, Blueberry, Mango, Orange, Grape]

// Menghapus elemen:
fruits.remove('Apple'); // Hapus berdasarkan nilai
fruits.removeAt(2); // Hapus berdasarkan indeks (Mango terhapus)
fruits.removeLast(); // Hapus elemen terakhir (Grape terhapus)
print(fruits); // Output: [Blueberry, Orange]

// Iterasi (loop) melalui List:
// Cara 1 - for loop
for (int i = 0; i < fruits.length; i++) {
  print(fruits[i]);
}

// Cara 2 - for-in loop
for (var fruit in fruits) {
  print(fruit);
}

// Cara 3 - forEach
fruits.forEach((fruit) => print(fruit));
```

**4. Fitur Tambahan**

- **Menentukan Panjang List**:

  ```dart
  var fixedList = List<int>.filled(3, 0); // List dengan 3 elemen (semua 0)
  fixedList[1] = 5; // [0, 5, 0]
  // fixedList.add(10); // Error: Panjang tetap
  ```

- **List Campuran Tipe Data** (tidak disarankan):

  ```dart
  var mixedList = [1, 'Dart', true]; // List<dynamic>
  ```

- **Manipulasi List**:
  ```dart
  var numbers = [5, 3, 9, 1];
  numbers.sort(); // [1, 3, 5, 9]
  numbers.shuffle(); // Acak urutan (misal: [3, 1, 9, 5])
  ```

**5. Keunggulan List di Dart**

- Dinamis: Ukuran menyesuaikan kebutuhan.
- Mendukung berbagai operasi: sorting, filtering, mapping.
- Terintegrasi dengan syntax Dart yang sederhana.

---

**Contoh Kasus: Menghitung Total Harga Barang**

```dart
void main() {
  List<double> prices = [10.5, 20.0, 15.75, 8.99];
  double total = 0;

  for (var price in prices) {
    total += price;
  }

  print('Total harga: \$${total.toStringAsFixed(2)}'); // Output: Total harga: $55.24
}
```

[Dokumentasi](https://api.dart.dev/stable/2.14.2/dart-core/List-class.html)

**Hasil eksplorasi saya**

```dart
import '../../../../saya.dart';

void main() {
  print(pembatas * 5);

  // ^ Membuat List kosong
  List<int> emptyInt = []; // $ []

  List<String> emptyString = []; // $ []

  List<String> emptyBool = []; // $ []

  print('$emptyString Tipe String inisialisasi kosong $rege'
      '$emptyInt Tipe Integer inisialisasi kosong $rege'
      '$emptyBool Tipe Boolean inisialisasi kosong');

  print(rege);
  var dinamik = ['Ini', 'adalah', 'Lsit', 'Dinamik'];

  dinamik.add('Dart');

  var string = <String>['Amir', 'Khalil', 'Zain'];
  var integer = <int>[1, 2, 3, 4, 5];
  var boolean = <bool>[false, true, false];

  print('$dinamik Tipe Dinamik\n${dinamik.length}$rege'
      '$string Tipe String$rege'
      '$integer Tipe Integer$rege'
      '$boolean Tipe Boolean$rege');

  // ^ Membuat list dengan beberapa elemen
  List<int> numbers = [1, 2, 3, 4, 5];

  // ^ Menambahkan elemen ke dalam list
  numbers.add(266);
  print('$numbers$rege'); // $ [1, 2, 3, 4, 5, 6]

  // ^ Mengakses elemen berdasarkan indeks
  int firstNumber = numbers[4]; // 1
  print('$tebal {$firstNumber} $reset$merah'
      'Angka 5 berhasil diakses sebagai index ke empat'
      'dan dimasukan kedalam Set{}$rege'); // $ Mengakses elemen pertama dalam list (indeks ke-0) (nilai 1)

  // ^ Menghapus elemen dari list
  numbers.removeAt(2); // $ Menghapus elemen pada indeks ke-2 (nilai 3)

  // ^ Menampilkan semua elemen dalam list secara berurutan menggunakan perulangan "for(in){}"
  //sehingga akan menampilkan nilai 1, 2, 4, 5, 6 dalam bentuk vertikal
  for (int number in numbers) {
    print(number); // $ 1, 2, 4, 5, 6 ditampilkan secara berurutan vertikal
  }

  // ^ Deklarasi secara langsung
  string = ['Oke Google'];
  print(string
      .first); // $ Properti .first dalam List di Dart digunakan untuk mengakses elemen pertama dari daftar tersebut. Misalnya, jika Anda memiliki daftar List<int> numbers = [1, 2, 3, 4, 5];, maka numbers.first akan mengembalikan nilai 1, yaitu elemen pertama dari daftar tersebut. Perlu diingat bahwa jika daftar tersebut kosong, maka mengakses properti .first akan menyebabkan StateError. Jadi, pastikan daftar tidak kosong sebelum mengakses properti ini. pelajari lebih lanjut di https://nextgen.co.id/list-dart/

  print(pembatas * 5);
}
```
