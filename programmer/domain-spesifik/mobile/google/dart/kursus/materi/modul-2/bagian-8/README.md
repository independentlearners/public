# [Boolean Operations][0]

<details>
  <summary>📃 Daftar Isi</summary>

### Daftar Isi

- [Boolean Operations](#boolean-operations)
    - [Daftar Isi](#daftar-isi)
    - [1. Pendahuluan: Apa itu Boolean?](#1-pendahuluan-apa-itu-boolean)
      - [Nilai Kebenaran](#nilai-kebenaran)
      - [Peran dalam Pemrograman](#peran-dalam-pemrograman)
    - [2. Tipe Data `bool` di Dart](#2-tipe-data-bool-di-dart)
      - [Deklarasi dan Inisialisasi](#deklarasi-dan-inisialisasi)
      - [Default Value dan Null Safety](#default-value-dan-null-safety)
    - [3. Operator Logika (Logical Operators)](#3-operator-logika-logical-operators)
      - [Operator NOT (`!`) - Negasi Logika](#operator-not----negasi-logika)
        - [Tabel Kebenaran `!`](#tabel-kebenaran-)
        - [Contoh Penggunaan `!`](#contoh-penggunaan-)
      - [Operator AND (`&&`) - Konjungsi Logika](#operator-and----konjungsi-logika)
        - [Tabel Kebenaran `&&`](#tabel-kebenaran--1)
        - [Contoh Penggunaan `&&`](#contoh-penggunaan--1)
        - [Short-Circuiting dengan `&&`](#short-circuiting-dengan-)
      - [Operator OR (`||`) - Disjungsi Logika](#operator-or----disjungsi-logika)
        - [Tabel Kebenaran `||`](#tabel-kebenaran--2)
        - [Contoh Penggunaan `||`](#contoh-penggunaan--2)
        - [Short-Circuiting dengan `||`](#short-circuiting-dengan--1)
    - [4. Operator Relasional (Relational Operators)](#4-operator-relasional-relational-operators)
      - [Persamaan (`==`)](#persamaan-)
      - [Ketidaksamaan (`!=`)](#ketidaksamaan-)
      - [Lebih Besar (`>`)](#lebih-besar-)
      - [Lebih Kecil (`<`)](#lebih-kecil-)
      - [Lebih Besar atau Sama Dengan (`>=`)](#lebih-besar-atau-sama-dengan-)
      - [Lebih Kecil atau Sama Dengan (`<=`)](#lebih-kecil-atau-sama-dengan-)
    - [5. Operator Kesetaraan (Equality Operators) - Perbandingan Objek](#5-operator-kesetaraan-equality-operators---perbandingan-objek)
      - [Perbandingan Nilai Primitif](#perbandingan-nilai-primitif)
      - [Perbandingan Objek Kustom](#perbandingan-objek-kustom)
    - [6. Urutan Prioritas Operator (Operator Precedence)](#6-urutan-prioritas-operator-operator-precedence)
    - [7. Penerapan Boolean Operations dalam Kontrol Alur](#7-penerapan-boolean-operations-dalam-kontrol-alur)
      - [Conditional Statements (`if`, `else if`, `else`)](#conditional-statements-if-else-if-else)
      - [Looping (`while`, `for`)](#looping-while-for)
    - [8. Ringkasan](#8-ringkasan)
    - [9. Sumber Referensi](#9-sumber-referensi)

</details>

### 1\. Pendahuluan: Apa itu Boolean?

Dalam matematika dan ilmu komputer, **Boolean** (dinamai dari George Boole) merujuk pada sistem logika yang hanya memiliki dua kemungkinan nilai: **true (benar)** atau **false (salah)**. Ini adalah dasar dari semua pengambilan keputusan dan kontrol alur dalam program komputer.

#### Nilai Kebenaran

- **`true`**: Mengindikasikan kondisi yang benar, terpenuhi, atau positif.
- **`false`**: Mengindikasikan kondisi yang salah, tidak terpenuhi, atau negatif.

#### Peran dalam Pemrograman

Boolean operations sangat fundamental karena mereka memungkinkan program untuk:

1.  **Mengambil Keputusan:** Menentukan jalur eksekusi kode berdasarkan kondisi tertentu (`if-else`).
2.  **Mengontrol Perulangan:** Menentukan kapan sebuah _loop_ harus terus berjalan atau berhenti (`while`, `for`).
3.  **Memvalidasi Input:** Memastikan data memenuhi kriteria tertentu.
4.  **Mengevaluasi Kondisi Kompleks:** Menggabungkan beberapa kondisi sederhana menjadi satu evaluasi logika yang kompleks.

---

### 2\. Tipe Data `bool` di Dart

Dart memiliki tipe data bawaan untuk nilai Boolean, yaitu `bool`.

#### Deklarasi dan Inisialisasi

Anda mendeklarasikan variabel `bool` seperti tipe data lainnya:

```dart
void main() {
  bool isRaining = true;
  bool isLoggedIn = false;
  bool hasPermission; // Variabel non-nullable, harus diinisialisasi!

  // Contoh inisialisasi yang benar:
  hasPermission = true;

  print("Apakah sedang hujan? $isRaining");
  print("Apakah pengguna login? $isLoggedIn");
  print("Apakah ada izin? $hasPermission");
}
```

#### Default Value dan Null Safety

Dengan **Null Safety**, variabel `bool` adalah **non-nullable secara _default_**. Ini berarti mereka harus diinisialisasi dengan `true` atau `false` sebelum digunakan. Jika tidak, Anda akan mendapatkan _compile-time error_.

Jika Anda ingin sebuah variabel `bool` dapat menyimpan `null`, Anda harus secara eksplisit menandainya sebagai nullable menggunakan `?`:

```dart
void main() {
  bool? isChoiceMade; // Variabel nullable, defaultnya null
  print("Pilihan dibuat: $isChoiceMade"); // Output: Pilihan dibuat: null

  isChoiceMade = true;
  print("Pilihan dibuat: $isChoiceMade"); // Output: Pilihan dibuat: true

  isChoiceMade = null;
  print("Pilihan dibuat: $isChoiceMade"); // Output: Pilihan dibuat: null
}
```

**Penting:** Dalam Dart, hanya `true` dan `false` yang diperlakukan sebagai nilai Boolean. Angka (`0`, `1`) atau string kosong **tidak secara implisit dianggap sebagai `false` atau `true`** seperti di beberapa bahasa lain (misalnya JavaScript). Anda harus secara eksplisit mengevaluasi mereka ke `bool`.

```dart
// if (0) { } // ERROR: A value of type 'int' can't be assigned to a variable of type 'bool'.
// if ("") { } // ERROR: A value of type 'String' can't be assigned to a variable of type 'bool'.

// Ini cara yang benar:
int count = 0;
String name = "";
if (count > 0) { print("Count is positive"); }
if (name.isNotEmpty) { print("Name is not empty"); }
```

---

### 3\. Operator Logika (Logical Operators)

Operator logika digunakan untuk menggabungkan atau memodifikasi ekspresi Boolean.

#### Operator NOT (`!`) - Negasi Logika

- **Simbol:** `!` (tanda seru)
- **Fungsi:** Membalikkan nilai Boolean. Jika kondisinya `true`, `!` akan membuatnya menjadi `false`, dan sebaliknya.
- **Prioritas:** Tinggi (dieksekusi sebelum `&&` dan `||`).

##### Tabel Kebenaran `!`

| `P`     | `!P`    |
| :------ | :------ |
| `true`  | `false` |
| `false` | `true`  |

##### Contoh Penggunaan `!`

```dart
void main() {
  bool isDay = true;
  bool isNight = !isDay; // isNight akan menjadi false

  print("Apakah siang? $isDay");     // Output: Apakah siang? true
  print("Apakah malam? $isNight");    // Output: Output: Apakah malam? false

  bool hasErrors = false;
  if (!hasErrors) { // Memeriksa jika TIDAK ada error
    print("Operasi berhasil."); // Output: Operasi berhasil.
  }
}
```

#### Operator AND (`&&`) - Konjungsi Logika

- **Simbol:** `&&` (dua ampersand)
- **Fungsi:** Mengembalikan `true` jika dan hanya jika **kedua** operand adalah `true`. Jika salah satu atau keduanya `false`, hasilnya `false`.
- **Prioritas:** Menengah (dieksekusi setelah `!` tapi sebelum `||`).

##### Tabel Kebenaran `&&`

| `P`     | `Q`     | `P && Q` |
| :------ | :------ | :------- |
| `true`  | `true`  | `true`   |
| `true`  | `false` | `false`  |
| `false` | `true`  | `false`  |
| `false` | `false` | `false`  |

##### Contoh Penggunaan `&&`

```dart
void main() {
  int age = 20;
  bool hasDrivingLicense = true;

  bool canDrive = (age >= 18) && hasDrivingLicense;
  print("Bisa mengemudi? $canDrive"); // Output: Bisa mengemudi? true

  int temperature = 25;
  bool isSunny = true;

  if (temperature > 20 && isSunny) {
    print("Cuaca sempurna untuk piknik!"); // Output: Cuaca sempurna untuk piknik!
  }

  bool isAdmin = true;
  bool isAuthenticated = false;

  if (isAdmin && isAuthenticated) {
    print("Akses penuh diberikan.");
  } else {
    print("Akses ditolak."); // Output: Akses ditolak.
  }
}
```

##### Short-Circuiting dengan `&&`

Dart melakukan **short-circuiting** dengan `&&`. Ini berarti jika operand pertama (`P`) dari `P && Q` adalah `false`, maka operand kedua (`Q`) **tidak akan dievaluasi** sama sekali, karena hasilnya sudah pasti `false`. Ini adalah optimasi performa dan juga penting untuk menghindari _runtime error_ jika operand kedua melibatkan operasi yang berisiko.

```dart
void main() {
  String? username = null;

  // Jika username null, username.isEmpty tidak akan dievaluasi, mencegah error
  if (username != null && username.isNotEmpty) {
    print("Username tersedia.");
  } else {
    print("Username kosong atau null."); // Output: Username kosong atau null.
  }

  // Contoh lain:
  bool checkSomethingExpensive() {
    print("Fungsi mahal dieksekusi!");
    return true;
  }

  bool result = false && checkSomethingExpensive();
  print(result); // Output: false
  // "Fungsi mahal dieksekusi!" tidak akan tercetak
}
```

#### Operator OR (`||`) - Disjungsi Logika

- **Simbol:** `||` (dua pipa)
- **Fungsi:** Mengembalikan `true` jika **salah satu atau kedua** operand adalah `true`. Hanya akan mengembalikan `false` jika **kedua** operand adalah `false`.
- **Prioritas:** Rendah (dieksekusi paling akhir di antara operator logika).

##### Tabel Kebenaran `||`

| `P`     | `Q`     | `P      |     | Q`  |
| :------ | :------ | :------ | --- | --- |
| `true`  | `true`  | `true`  |
| `true`  | `false` | `true`  |
| `false` | `true`  | `true`  |
| `false` | `false` | `false` |

##### Contoh Penggunaan `||`

```dart
void main() {
  bool isWeekend = false;
  bool isHoliday = true;

  if (isWeekend || isHoliday) {
    print("Saatnya bersantai!"); // Output: Saatnya bersantai!
  }

  String userRole = "viewer";
  if (userRole == "admin" || userRole == "editor") {
    print("Akses modifikasi diberikan.");
  } else {
    print("Akses hanya untuk melihat."); // Output: Akses hanya untuk melihat.
  }

  int score = 75;
  if (score >= 90 || score < 60) {
    print("Anda mendapatkan A atau Anda gagal.");
  } else {
    print("Nilai Anda sedang."); // Output: Nilai Anda sedang.
  }
}
```

##### Short-Circuiting dengan `||`

Sama seperti `&&`, Dart juga melakukan short-circuiting dengan `||`. Jika operand pertama (`P`) dari `P || Q` adalah `true`, maka operand kedua (`Q`) **tidak akan dievaluasi** sama sekali, karena hasilnya sudah pasti `true`.

```dart
void main() {
  int? userAge = 25;

  // Jika userAge tidak null (true), ekspresi userAge < 18 tidak dievaluasi
  if (userAge == null || userAge < 18) {
    print("Pengguna belum cukup umur atau data usia tidak ada.");
  } else {
    print("Pengguna sudah cukup umur."); // Output: Pengguna sudah cukup umur.
  }

  // Contoh lain:
  bool checkNetworkConnection() {
    print("Memeriksa koneksi jaringan...");
    return false; // Anggap koneksi gagal
  }

  bool isCacheValid = true;
  bool result = isCacheValid || checkNetworkConnection();
  print(result); // Output: true
  // "Memeriksa koneksi jaringan..." tidak akan tercetak karena isCacheValid sudah true
}
```

---

### 4\. Operator Relasional (Relational Operators)

Operator relasional (juga disebut operator perbandingan) digunakan untuk membandingkan dua nilai dan selalu mengembalikan hasil `bool` (`true` atau `false`).

#### Persamaan (`==`)

- **Fungsi:** Mengembalikan `true` jika kedua operand memiliki nilai yang sama.
- **Contoh:**
  ```dart
  print(5 == 5);      // Output: true
  print("hello" == "world"); // Output: false
  print(10 == 10.0);  // Output: true (Dart menangani perbandingan tipe numerik yang berbeda secara cerdas)
  ```

#### Ketidaksamaan (`!=`)

- **Fungsi:** Mengembalikan `true` jika kedua operand memiliki nilai yang berbeda.
- **Contoh:**
  ```dart
  print(5 != 10);     // Output: true
  print("apple" != "apple"); // Output: false
  ```

#### Lebih Besar (`>`)

- **Fungsi:** Mengembalikan `true` jika operand kiri lebih besar dari operand kanan.
- **Contoh:**
  ```dart
  print(10 > 5);      // Output: true
  print(5 > 10);      // Output: false
  ```

#### Lebih Kecil (`<`)

- **Fungsi:** Mengembalikan `true` jika operand kiri lebih kecil dari operand kanan.
- **Contoh:**
  ```dart
  print(5 < 10);      // Output: true
  print(10 < 5);      // Output: false
  ```

#### Lebih Besar atau Sama Dengan (`>=`)

- **Fungsi:** Mengembalikan `true` jika operand kiri lebih besar dari atau sama dengan operand kanan.
- **Contoh:**
  ```dart
  print(10 >= 10);    // Output: true
  print(10 >= 5);     // Output: true
  print(5 >= 10);     // Output: false
  ```

#### Lebih Kecil atau Sama Dengan (`<=`)

- **Fungsi:** Mengembalikan `true` jika operand kiri lebih kecil dari atau sama dengan operand kanan.
- **Contoh:**
  ```dart
  print(5 <= 5);      // Output: true
  print(5 <= 10);     // Output: true
  print(10 <= 5);     // Output: false
  ```

---

### 5\. Operator Kesetaraan (Equality Operators) - Perbandingan Objek

Operator `==` dan `!=` tidak hanya membandingkan nilai primitif, tetapi juga berlaku untuk objek.

#### Perbandingan Nilai Primitif

Untuk tipe primitif seperti `int`, `double`, `bool`, dan `String`, operator `==` membandingkan nilai yang terkandung.

```dart
int num1 = 10;
int num2 = 10;
print(num1 == num2); // Output: true

String str1 = "Dart";
String str2 = "Dart";
print(str1 == str2); // Output: true
```

#### Perbandingan Objek Kustom

Secara _default_, operator `==` untuk objek kustom membandingkan **referensi memori**. Artinya, dua objek dianggap sama hanya jika mereka merujuk ke lokasi memori yang sama (yaitu, mereka adalah objek yang persis sama).

```dart
class Point {
  int x, y;
  Point(this.x, this.y);
}

void main() {
  Point p1 = Point(1, 2);
  Point p2 = Point(1, 2);
  Point p3 = p1; // p3 merujuk ke objek yang sama dengan p1

  print(p1 == p2); // Output: false (dua objek berbeda di memori, meskipun nilainya sama)
  print(p1 == p3); // Output: true (referensi yang sama)
}
```

Untuk mengubah perilaku ini dan membandingkan objek berdasarkan **nilai** mereka (misalnya, dua objek `Point` dianggap sama jika `x` dan `y` mereka sama), Anda perlu **meng-override operator `==` dan metode `hashCode`** di kelas Anda.

```dart
class PointOverride {
  int x, y;
  PointOverride(this.x, this.y);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // Optimasi jika objeknya sama persis
    return other is PointOverride && // Pastikan other adalah PointOverride
           x == other.x &&           // Bandingkan properti x
           y == other.y;             // Bandingkan properti y
  }

  // Meng-override hashCode sangat penting ketika meng-override operator ==
  // Ini memastikan bahwa objek yang dianggap sama (== true) juga memiliki hashCode yang sama.
  // Ini krusial untuk koleksi seperti Set atau Map.
  @override
  int get hashCode => Object.hash(x, y);
}

void main() {
  PointOverride po1 = PointOverride(1, 2);
  PointOverride po2 = PointOverride(1, 2);
  PointOverride po3 = PointOverride(3, 4);

  print(po1 == po2); // Output: true (karena operator == di-override)
  print(po1 == po3); // Output: false
}
```

---

### 6\. Urutan Prioritas Operator (Operator Precedence)

Ketika Anda menggabungkan beberapa operator dalam satu ekspresi, urutan di mana mereka dievaluasi ditentukan oleh prioritasnya. Operator dengan prioritas lebih tinggi dievaluasi terlebih dahulu. Anda bisa menggunakan tanda kurung `()` untuk secara eksplisit mengontrol urutan evaluasi.

Berikut adalah urutan prioritas parsial untuk operator yang relevan dengan Boolean (dari tertinggi ke terendah):

1.  **Postfix operators**: `.` `?.` `!` `[]` `()` (pemanggilan fungsi), `++` `--` (postfix)
2.  **Prefix operators**: `!` `-` `~` `++` `--` (prefix)
3.  **Multiplicative operators**: `*` `/` `%` `~/`
4.  **Additive operators**: `+` `-`
5.  **Shift operators**: `<<` `>>` `>>>`
6.  **Bitwise AND**: `&`
7.  **Bitwise XOR**: `^`
8.  **Bitwise OR**: `|`
9.  **Relational and type test operators**: `==` `!=` `>=` `>` `<=` `<` `is` `is!` `as`
10. **Logical AND**: `&&`
11. **Logical OR**: `||`
12. **Null-aware operators**: `??` `??=`
13. **Conditional operator**: `? :`
14. **Assignment operators**: `=` `*=` `/=` `%=` `+=` `-=` `<<=` `>>=` `&=` `^=` `|=` `??=`

**Contoh Urutan Prioritas:**

```dart
void main() {
  int a = 10;
  int b = 5;
  int c = 12;

  // Ekspresi: (a > b && c < 10 || a + b > c)
  // 1. Relational operators (>, <) dievaluasi terlebih dahulu
  //    (10 > 5) -> true
  //    (12 < 10) -> false
  //    Ekspresi menjadi: (true && false || a + b > c)

  // 2. Additive operator (+) dievaluasi
  //    (a + b) -> 15
  //    Ekspresi menjadi: (true && false || 15 > c)

  // 3. Relational operator (>) lagi
  //    (15 > 12) -> true
  //    Ekspresi menjadi: (true && false || true)

  // 4. Logical AND (&&) dievaluasi
  //    (true && false) -> false
  //    Ekspresi menjadi: (false || true)

  // 5. Logical OR (||) dievaluasi
  //    (false || true) -> true

  bool result = a > b && c < 10 || a + b > c;
  print(result); // Output: true

  // Menggunakan tanda kurung untuk mengubah urutan:
  // (a > b && (c < 10 || a + b > c))
  // 1. Inner (c < 10 || a + b > c)
  //    (c < 10) -> false
  //    (a + b > c) -> (15 > 12) -> true
  //    (false || true) -> true
  // 2. Outer (a > b && true)
  //    (10 > 5) -> true
  //    (true && true) -> true
  bool result2 = a > b && (c < 10 || a + b > c);
  print(result2); // Output: true (kebetulan hasilnya sama di kasus ini)
}
```

**Tips:** Jika Anda ragu tentang prioritas operator atau untuk meningkatkan keterbacaan, selalu gunakan tanda kurung `()` untuk mengelompokkan operasi.

---

### 7\. Penerapan Boolean Operations dalam Kontrol Alur

Operator Boolean adalah tulang punggung dari kontrol alur dalam Dart.

#### Conditional Statements (`if`, `else if`, `else`)

Digunakan untuk mengeksekusi blok kode tertentu berdasarkan apakah suatu kondisi Boolean `true` atau `false`.

```dart
void checkEligibility(int age, bool hasId) {
  if (age >= 17 && hasId) {
    print("Eligible for voting.");
  } else if (age >= 17 && !hasId) {
    print("Please bring your ID card.");
  } else {
    print("Not yet eligible for voting.");
  }
}

void main() {
  checkEligibility(18, true);   // Output: Eligible for voting.
  checkEligibility(17, false);  // Output: Please bring your ID card.
  checkEligibility(15, true);   // Output: Not yet eligible for voting.
}
```

#### Looping (`while`, `for`)

Kondisi Boolean digunakan untuk menentukan apakah sebuah _loop_ harus terus berulang.

```dart
void main() {
  int count = 0;
  while (count < 5) { // Kondisi: count kurang dari 5
    print("Loop count: $count");
    count++;
  }
  // Output:
  // Loop count: 0
  // Loop count: 1
  // Loop count: 2
  // Loop count: 3
  // Loop count: 4

  for (int i = 0; i < 3; i++) { // Kondisi: i kurang dari 3
    if (i == 1) {
      bool skip = true;
      if (skip) continue; // Melewati iterasi ini jika skip true
    }
    print("For loop i: $i");
  }
  // Output:
  // For loop i: 0
  // For loop i: 2
}
```

---

### 8\. Ringkasan

Boolean operations adalah dasar dari logika pemrograman. Mereka memungkinkan Anda untuk:

- Menyimpan nilai `true` atau `false` dalam variabel `bool`.
- Membalikkan kondisi menggunakan `!`.
- Menggabungkan kondisi dengan `&&` (kedua-duanya harus `true`) dan `||` (salah satu saja `true`).
- Membandingkan nilai menggunakan operator relasional (`==`, `!=`, `>`, `<`, `>=`, `<=`).
- Membandingkan objek dengan meng-override `==` dan `hashCode`.
- Mengontrol alur program menggunakan `if/else` dan _loops_.

Penting untuk memahami konsep **short-circuiting** untuk optimasi dan penanganan _error_ yang aman, serta **urutan prioritas operator** untuk memastikan ekspresi Anda dievaluasi seperti yang diharapkan.

### 9\. Sumber Referensi

- **Dart Documentation - Built-in types (bool):** [https://dart.dev/guides/language/language-tour\#numbers-strings-and-booleans](https://www.google.com/search?q=https://dart.dev/guides/language/language-tour%23numbers-strings-and-booleans)
- **Dart Documentation - Operators:** [https://dart.dev/guides/language/language-tour\#operators](https://www.google.com/search?q=https://dart.dev/guides/language/language-tour%23operators)
- **Dart Documentation - Control flow statements:** [https://dart.dev/guides/language/language-tour\#control-flow-statements](https://www.google.com/search?q=https://dart.dev/guides/language/language-tour%23control-flow-statements)

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-7/README.md
[selanjutnya]: ../bagian-9/README.md

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
