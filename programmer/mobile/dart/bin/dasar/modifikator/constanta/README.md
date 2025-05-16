# const

#### Kelas Pengubah : Immutable

Dalam Dart, kata kunci `const` digunakan untuk mendeklarasikan jenis variable konstanta yang tidak dapat diubah setelah nilainya diinisialisasi seperti contoh yang sederhana ini:

```dart
void main() {
  const String greeting = 'Hello, Dart!';
  print(greeting); // Keluaran: Hello, Dart!
}
```

Sebagaimana `final`, penulisannya juga bisa dilakukan dengan dua cara dimana nilai akhirnya sama-sama menunjukan konstanta

```dart
void main() {
  const int nilai = 10;
  const teks = 'teks';
}
```

> Hal yang perlu diperhatikan:

**Inisialisasi Awal**: `const` harus digunakan saat variabel diinisialisasi untuk pertama kalinya. Ini berarti nilai harus diketahui saat kompilasi. Artinya ketika kita menyertakan kata kunci `const` maka kita wajib menyertakan nilainya pada saat itu juga

**Tidak Bisa Diubah**: Setelah diinisialisasi, nilai dari variabel `const` tidak dapat diubah. Jadi kita tidak bisa menulis seperti contoh berikut:

```dart
  final imutabel;
  imutabel = 'teks'; // berhasil

  const konstanta;
  konstanta = 100; // ini akan error
```

**Efisiensi**: Dart akan menghindari pembuatan ulang objek `const` jika sudah ada di memori, maka kode di bawah ini akan menghasilkan **_Error Exception!!_**

**Input :**

```dart
  final List<int> number = [1, 2, 3];
  number.add(5);
  // berhasil

  const List<int> numbers = [1, 2, 3];
  numbers.add(4);
  // Error: Cannot add to a const List
```

**Ouutput :**

```PS
[1, 2, 3, 5]
------------------------
Unhandled exception:
Unsupported operation: Cannot add to an unmodifiable list
#0      UnmodifiableListMixin.add (dart:_internal/list.dart:114:5)
```

Perbedaan antara `const` dan `final` adalah:

- **`const`**: Nilai harus diketahui saat kompilasi dan tidak dapat diubah setelah diinisialisasi.
- **`final`**: Nilai dapat diinisialisasi di runtime dan tidak dapat diubah setelah diinisialisasi, tetapi tidak harus diketahui saat kompilasi.

Dokumentasi resmi untuk `const` dalam Dart dapat ditemukan di [sini](https://dart.dev/guides/language/language-tour#constants).

```dart
void main() {
  print('\n' * 5);

  final imutabel;
  imutabel = 10;

  const konstanta = 'konstanta';

  print(imutabel);
  print(konstanta);
  print('' * 1 + '=' * 10 + '\n' * 1);

  final List<int> number = [1, 2, 3];
  number.add(5);
  print(number);
  print('' * 1 + '=' * 10 + '\n' * 1);

  const List<int> numbers = [1, 2, 3];
  numbers.add(4);
  print(numbers);

  print('\n' * 5);
}
```
