# Final
#### Kelas Pengubah
Adalah kata kunci immutable, artinya bahwa suatu variabel tidak dapat diubah setelah nilainya diinisialisasi. Ini berarti bahwa setelah Kita menetapkan nilai untuk variabel immutable / `final`, Kita tidak dapat mengubah nilai tersebut. Hal ini sangat berguna untuk memastikan bahwa nilai tetap konstan selama objek tersebut hidup.

#### Contoh:
```dart
final int nilai = 10;
nilai = 20; // Ini akan menyebabkan kesalahan karena nilai final tidak dapat diubah
```

#

### Tipe Data Lain
Berikut adalah beberapa tipe data umum dalam Dart ketika tidak didefinisikan sebagai variabel immutabel / `final`:

1. **String**: Sebuah sekuen dari karakter. Kita dapat mengubah nilai dari variabel `String` yang bukan `final`.
   ```dart
   String nama = "Alice";
   nama = "Bob"; // Ini diperbolehkan
   ```

2. **int**: Bilangan bulat tanpa bagian desimal. Kita dapat mengubah nilai dari variabel `int` yang bukan `final`.
   ```dart
   int umur = 25;
   umur = 30; // Ini diperbolehkan
   ```

3. **double**: Bilangan desimal (floating-point). Kita dapat mengubah nilai dari variabel `double` yang bukan `final`.
   ```dart
   double harga = 19.99;
   harga = 25.50; // Ini diperbolehkan
   ```

4. **List<E>**: Sebuah daftar yang dapat berisi elemen tipe `E`. Kita dapat mengubah nilai dari variabel `List` yang bukan `final`.
   ```dart
   List<int> daftar = [1, 2, 3];
   daftar = [4, 5, 6]; // Ini diperbolehkan
   ```

#
Karena `final` adalah [kelas modifikator](https://dart.dev/language/class-modifiers "Dokementasi Resmi Pengubah kelas"), bukan tipe data. Maka kita dapat menggunakan `final` bersama dengan berbagai tipe data seperti `String`, `int`, `double`, dll, untuk memastikan bahwa nilai variabel tersebut tetap immutable.

**Seperti Contoh Berikut :**
```dart
final String nama = "Alice";
final int umur = 25;
final double harga = 19.99;
final List<int> daftar = [1, 2, 3];
```

Penulisan kode bisa dilakukan dengan beberapa cara seperti ini:

**Deklarasi Langsung**
```dart
final int nilai = 10;
final teks = 'teks';
```

Karena sifatnya immutable kita bisa menulisnya juga seperti ini:

**Deklarasi Kemudian**

```dart
  final vinal;

  vinal = 'berhasil dideklarasi nanti';
```
Perlu kita ingat bahwa ketika mendeklarasikan kemudian, maka variabel tersebut akan bersifat Dynamic, kita akan mempelajari tipe data Dynamic ini nanti, untuk saat ini kita hanya cukup memahami bahwa inilah kata kunci `final` yang masuk dalam kategori kelas modifikator

#
Dengan demikian kelas modifikasi variabel ini bisa kita pahami sebagai tipe datanya-tipe data atau juga bisa disebut sebagai pengunci nilai yang sederhana dimana sifatnya adalah <span style="border-bottom: 1px solid orange;">
immutabel
</span>
yaitu variabel tidak dapat diubah setelah nilainya diinisialisasi.
#

**Ini adalah hasil pembelajaran saya**

```dart
import '../../../saya.dart';

final class Point {
  late int x;
  final y;
  static const z = 1;

  Point(
    this.x,
    this.y,
  );
}

void main() {
  print(bawah);

  final point = Point(
    3,
    2,
  );
  print(point);
  print(garis);

  print(point.x); // Keluaran: 3
  print(point.y); // Keluaran: 2
  print(Point.z); // Keluaran: 1
  print(garis);

  // point.y = 1; // Error: Cannot assign to a final variable

  print(atas);
}
```

### Penjelasan Kode Diatas:

1. **Impor dan Klas Point**:
   - `import '../../../saya.dart';`: Mengimpor file Dart lainnya.
   - `final class Point`: Mendeklarasikan kelas `Point` sebagai `final`, yang berarti kelas ini tidak dapat diubah setelah diinisialisasi.
   - `late int x;`: Variabel `x` yang bertipe `int` dan diinisialisasi `late`, artinya harus diinisialisasi sebelum digunakan.
   - `final y;`: Variabel `y` yang bertipe `int` dan diinisialisasi `final`, artinya nilai ini hanya dapat diatur sekali saat objek dibuat.
   - `static const z = 1;`: Variabel statis `z` yang bertipe `int` dan diinisialisasi `const`, artinya nilai ini tetap dan tidak dapat diubah.

2. **Fungsi Utama**:
   - `void main() { ... }`: Fungsi utama yang menjalankan program.
   - `print(bawah);`: Mencetak nilai dari variabel `bawah`.
   - `final point = Point(3, 2);`: Membuat objek `Point` dengan nilai `x` = 3 dan `y` = 2.
   - `print(point);`: Mencetak objek `point`.
   - `print(garis);`: Mencetak nilai dari variabel `garis`.
   - `print(point.x);`: Mencetak nilai `x` dari objek `point` (Keluaran: 3).
   - `print(point.y);`: Mencetak nilai `y` dari objek `point` (Keluaran: 2).
   - `print(Point.z);`: Mencetak nilai konstanta statis `z` dari kelas `Point` (Keluaran: 1).
   - `print(garis);`: Mencetak nilai dari variabel `garis` lagi.
   - `// point.y = 1;`: Mengkomentar baris yang akan menyebabkan error karena `y` adalah variabel `final` dan tidak dapat diubah.
   - `print(point.x);`: Mencetak nilai `x` dari objek `point` lagi.
   - `print(point.y);`: Mencetak nilai `y` dari objek `point` lagi.
   - `print(atas);`: Mencetak nilai dari variabel `atas`.

### Poin Penting:
- Variabel `final` dan `const` digunakan untuk membuat objek yang tidak dapat diubah setelah diinisialisasi, meningkatkan keamanan dan kinerja.
- Variabel `late` memungkinkan inisialisasi yang dilanjutkan, tetapi nilai dapat diubah setelah diinisialisasi.
- Variabel statis `static` dan konstanta `const` dapat diakses tanpa membuat objek kelas, hanya dengan menggunakan nama kelas.

#

**Jalankan Kode Berikut :**

Sekrang anda bisa mencoba untuk menjalankan kode yang sudah saya sediakan di dalam file final.dart yang isinya seperti berikut:
```dart
import '../../../saya.dart';

void main() {
  print(bawah);

  final int nilai = 10;
  final teks = 'teks';

  print(nilai);
  print(garis);
  print(teks);

  print(atas);
}
```
**Output :**

```
⬇

10
------------------------
teks

⬆️
```