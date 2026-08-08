# [Number System][0]

### 1. Pendahuluan

Dalam pemrograman komputer, termasuk Dart, "Number System" mengacu pada cara bilangan direpresentasikan dan dimanipulasi. Meskipun kita sebagai manusia umumnya bekerja dengan sistem bilangan desimal (basis 10), komputer secara fundamental beroperasi dengan sistem bilangan biner (basis 2). Dart menyediakan cara yang fleksibel untuk bekerja dengan berbagai jenis bilangan dan juga memungkinkan konversi antar sistem bilangan yang umum digunakan.

Di Dart, tipe data numerik utama adalah `int` (bilangan bulat) dan `double` (bilangan floating-point). Dart juga mendukung representasi bilangan dalam basis yang berbeda (seperti biner, oktal, heksadesimal) melalui literal dan konversi string.

---

### 2. Tipe Data Numerik di Dart

Dart memiliki dua tipe data numerik dasar:

#### a. `int` (Integer)

- Digunakan untuk merepresentasikan bilangan bulat (tanpa bagian desimal).
- Rentang nilai `int` tidak terbatas pada 64-bit platform, yang berarti dapat menampung bilangan bulat yang sangat besar. Pada platform 32-bit, `int` mendukung nilai hingga $2^{31} - 1$. Pada platform 64-bit, `int` mendukung nilai hingga $2^{63} - 1$.
- Contoh: `1`, `-5`, `1000000`, `0`.

#### b. `double` (Floating-Point)

- Digunakan untuk merepresentasikan bilangan desimal (dengan bagian pecahan).
- Dart `double` adalah bilangan floating-point presisi ganda 64-bit, sesuai dengan standar IEEE 754.
- Contoh: `3.14`, `-0.5`, `1.0`, `2.5e3` (yang berarti $2.5 \times 10^3$).

#### c. `num` (Induk dari `int` dan `double`)

- `num` adalah tipe abstrak yang merupakan superkelas dari `int` dan `double`.
- Anda bisa menggunakan `num` jika Anda membutuhkan variabel yang bisa menyimpan `int` atau `double`.
- Contoh:
  ```dart
  num x = 1; // x adalah int
  x += 2.5;  // x sekarang adalah double
  print(x);  // Output: 3.5
  ```

### 3. Literal Numerik dalam Berbagai Basis

Dart memungkinkan Anda menulis literal numerik langsung dalam basis yang berbeda:

#### a. Desimal (Basis 10)

- Ini adalah standar dan paling umum.
- Tidak ada prefiks khusus.

  ```dart
  int decimalInt = 42;
  double decimalDouble = 3.14;
  ```

#### b. Heksadesimal (Basis 16)

- Menggunakan prefiks `0x` atau `0X`.
- Angka 0-9 dan huruf a-f (atau A-F) digunakan.

  ```dart
  int hexInt = 0xFF; // Sama dengan 255 dalam desimal
  int anotherHex = 0xA;  // Sama dengan 10 dalam desimal
  print(hexInt);      // Output: 255
  print(anotherHex);  // Output: 10
  ```

#### c. Oktal (Basis 8) - Tidak Ada Literal Langsung

- Dart **tidak memiliki literal langsung untuk oktal** (misalnya, `0o12`).
- Untuk merepresentasikan oktal, Anda harus menggunakan metode konversi dari string.

  ```dart
  // int octalInt = 0o12; // ERROR: Invalid number literal
  ```

#### d. Biner (Basis 2) - Tidak Ada Literal Langsung

- Dart **tidak memiliki literal langsung untuk biner** (misalnya, `0b1011`).
- Untuk merepresentasikan biner, Anda harus menggunakan metode konversi dari string.

  ```dart
  // int binaryInt = 0b1011; // ERROR: Invalid number literal
  ```

**Penting:** Perlu dicatat bahwa meskipun Dart tidak memiliki literal langsung untuk oktal dan biner, ini tidak berarti Dart tidak bisa bekerja dengan bilangan dalam basis tersebut. Ini hanya berarti Anda tidak bisa menuliskannya secara langsung sebagai literal seperti heksadesimal. Anda perlu mengonversinya dari string.

---

### 4. Konversi Antar Sistem Bilangan (String ke Bilangan)

Anda dapat mengonversi string yang merepresentasikan bilangan dalam basis tertentu menjadi tipe numerik Dart menggunakan metode `parse()` pada `int` atau `double`.

#### a. `int.parse(String source, {int? radix})`

- Digunakan untuk mengonversi string ke `int`.
- Parameter `radix` menentukan basis bilangan string tersebut. Jika tidak disebutkan, `radix` defaultnya adalah 10 (desimal).
- `radix` bisa berupa 2 (biner), 8 (oktal), 10 (desimal), atau 16 (heksadesimal).

```dart
void main() {
  // Dari Biner (Basis 2)
  String binaryString = "1011"; // Sama dengan 11 desimal
  int binaryToDecimal = int.parse(binaryString, radix: 2);
  print("Biner $binaryString ke desimal: $binaryToDecimal"); // Output: 11

  // Dari Oktal (Basis 8)
  String octalString = "72"; // Sama dengan 58 desimal ($7 \times 8^1 + 2 \times 8^0 = 56 + 2 = 58$)
  int octalToDecimal = int.parse(octalString, radix: 8);
  print("Oktal $octalString ke desimal: $octalToDecimal");   // Output: 58

  // Dari Heksadesimal (Basis 16)
  String hexString = "FF"; // Sama dengan 255 desimal
  int hexToDecimal = int.parse(hexString, radix: 16);
  print("Heksadesimal $hexString ke desimal: $hexToDecimal"); // Output: 255

  // Dari Desimal (Basis 10)
  String decimalString = "123";
  int decimalFromParse = int.parse(decimalString); // Default radix: 10
  print("Desimal $decimalString ke desimal: $decimalFromParse"); // Output: 123

  // Menangani error parsing: tryParse()
  String invalidNumber = "abc";
  int? parsedInt = int.tryParse(invalidNumber); // Mengembalikan null jika parsing gagal
  print("Parsing 'abc': $parsedInt"); // Output: null

  String validNumber = "123";
  int? parsedInt2 = int.tryParse(validNumber);
  print("Parsing '123': $parsedInt2"); // Output: 123
}
```

#### b. `double.parse(String source)`

- Digunakan untuk mengonversi string ke `double`.
- Tidak ada parameter `radix` karena bilangan desimal adalah representasi standar untuk _floating-point_.

```dart
void main() {
  String doubleString = "123.45";
  double parsedDouble = double.parse(doubleString);
  print("String '$doubleString' ke double: $parsedDouble"); // Output: 123.45

  String scientificNotation = "1.23e-2"; // Sama dengan 0.0123
  double parsedScientific = double.parse(scientificNotation);
  print("Notasi ilmiah '$scientificNotation' ke double: $parsedScientific"); // Output: 0.0123
}
```

### 5. Konversi Bilangan ke String (Berbagai Basis)

Anda juga dapat mengonversi bilangan `int` Dart menjadi representasi string dalam basis yang berbeda.

#### a. `toRadixString(int radix)`

- Merupakan metode pada objek `int`.
- Mengonversi `int` menjadi string yang merepresentasikan bilangan dalam basis yang ditentukan (`radix`).
- `radix` bisa berupa 2 (biner), 8 (oktal), 10 (desimal), atau 16 (heksadesimal).

```dart
void main() {
  int decimalNumber = 255;

  // Ke Biner (Basis 2)
  String binaryRepresentation = decimalNumber.toRadixString(2);
  print("Desimal $decimalNumber ke biner: $binaryRepresentation"); // Output: 11111111

  // Ke Oktal (Basis 8)
  String octalRepresentation = decimalNumber.toRadixString(8);
  print("Desimal $decimalNumber ke oktal: $octalRepresentation"); // Output: 377

  // Ke Heksadesimal (Basis 16)
  String hexRepresentation = decimalNumber.toRadixString(16);
  print("Desimal $decimalNumber ke heksadesimal: $hexRepresentation"); // Output: ff

  // Ke Desimal (Basis 10) - Meskipun redundant, ini menunjukkan fungsinya
  String decimalRepresentation = decimalNumber.toRadixString(10);
  print("Desimal $decimalNumber ke desimal: $decimalRepresentation"); // Output: 255
}
```

### 6. Operasi Numerik Dasar

Dart mendukung operasi matematika standar pada tipe data numerik.

```dart
void main() {
  int a = 10;
  int b = 3;
  double c = 2.5;

  print("Penjumlahan: ${a + b}");  // Output: 13
  print("Pengurangan: ${a - b}");  // Output: 7
  print("Perkalian: ${a * b}");   // Output: 30
  print("Pembagian: ${a / b}");    // Output: 3.3333333333333335 (hasil double)
  print("Pembagian bulat: ${a ~/ b}"); // Output: 3 (hasil int)
  print("Modulus: ${a % b}");     // Output: 1 (sisa bagi)
  print("Increment: ${++a}");     // Output: 11 (a menjadi 11)
  print("Decrement: ${--b}");     // Output: 2 (b menjadi 2)

  // Operasi dengan double
  print("Penjumlahan double: ${a + c}"); // Output: 13.5
}
```

### 7. Bitwise Operations (Khusus `int`)

Untuk bilangan bulat (`int`), Dart juga mendukung operasi bitwise, yang bekerja langsung pada representasi biner dari bilangan.

- `&` (AND)
- `|` (OR)
- `^` (XOR)
- `~` (NOT)
- `<<` (Left Shift)
- `>>` (Right Shift)
- `>>>` (Unsigned Right Shift - mulai Dart 2.14)

```dart
void main() {
  int x = 10; // Biner: 1010
  int y = 5;  // Biner: 0101

  print("x & y: ${x & y}");   // Biner: 0000 = 0
  print("x | y: ${x | y}");   // Biner: 1111 = 15
  print("x ^ y: ${x ^ y}");   // Biner: 1111 = 15 (XOR)
  print("~x: ${~x}");         // Biner: ...11110101 (tergantung representasi 2's complement) = -11

  print("x << 1: ${x << 1}"); // Biner: 10100 = 20 (geser kiri 1 bit, sama dengan x * 2^1)
  print("x >> 1: ${x >> 1}"); // Biner: 0101 = 5 (geser kanan 1 bit, sama dengan x ~/ 2^1)
}
```

### 8. Ringkasan

Dart menyediakan sistem bilangan yang kuat dan fleksibel dengan tipe data `int` dan `double`. Meskipun literal langsung hanya tersedia untuk desimal dan heksadesimal, Dart menawarkan metode `parse()` dan `toRadixString()` untuk dengan mudah mengonversi bilangan dari dan ke representasi string dalam berbagai basis (biner, oktal, desimal, heksadesimal). Pemahaman tentang sistem bilangan dan operasi terkait sangat fundamental untuk berbagai tugas pemrograman, mulai dari manipulasi data hingga pengembangan algoritma.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-8/README.md
[selanjutnya]: ../bagian-10/README.md

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
