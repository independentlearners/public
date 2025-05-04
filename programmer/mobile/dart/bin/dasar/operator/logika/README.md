# Operator logika

Operator logika adalah operator yang digunakan untuk melakukan operasi logika seperti AND, OR, dan NOT. Untuk melakukan operasi logika, kita dapat menggunakan operator

- `&&` (AND)
- `||` (OR)
- `!` (NOT)

Operator logika mengembalikan nilai boolean, yaitu true atau false.

#

### Contoh

1. **Logical AND (&&)**:
   Digunakan untuk mengevaluasi apakah kedua kondisi adalah benar.

   ```dart
   bool a = true;
   bool b = false;
   bool result = a && b; // Nilai result adalah false, karena b adalah false
   ```

2. **Logical OR (||)**:
   Digunakan untuk mengevaluasi apakah setidaknya satu kondisi adalah benar.

   ```dart
   bool a = true;
   bool b = false;
   bool result = a || b; // Nilai result adalah true, karena a adalah true
   ```

3. **Logical NOT (!)**:
   Digunakan untuk membalik nilai kebenaran dari sebuah kondisi.
   ```dart
   bool a = true;
   bool result = !a; // Nilai result adalah false, karena a adalah true
   ```

### Contoh Penggunaan:

Misal kita ingin mengecek apakah sebuah nilai dalam rentang tertentu:

```dart
int x = 5;
bool isBetweenThreeAndTen = x > 3 && x < 10;
// Nilai isBetweenThreeAndTen adalah true, karena x lebih besar dari 3 dan kurang dari 10
```

#

### Coba kita ulang lagi pelajaran ini dengan menambahkan beberapa tambahan penjelasan lagi

Berikut adalah tabel yang merangkum operator logika di Dart beserta penjelasan dan contohnya:

| Operator | Deskripsi                                                                       | Contoh                  | Hasil                                          |
| -------- | ------------------------------------------------------------------------------- | ----------------------- | ---------------------------------------------- | ----- | --- | ------ | ------ |
| `&&`     | Logical AND: True jika kedua kondisi benar                                      | `true && false`         | `false`                                        |
| `        |                                                                                 | `                       | Logical OR: True jika salah satu kondisi benar | `true |     | false` | `true` |
| `!`      | Logical NOT: Membalik nilai kebenaran                                           | `!true`                 | `false`                                        |
| `^`      | XOR: True jika hanya salah satu dari kondisi benar                              | `true ^ false`          | `true`                                         |
| `&`      | Bit-wise AND: Bandingkan bit-bit dan hasilkan 1 jika kedua bit 1                | `5 & 3` (0101 & 0011)   | `1` (0001)                                     |
| `\|`     | Bit-wise OR: Bandingkan bit-bit dan hasilkan 1 jika salah satu atau kedua bit 1 | `5 \| 3` (0101 \| 0011) | `7` (0111)                                     |
| `~`      | Bit-wise NOT: Balikkan semua bit                                                | `~5` (0101)             | `-6` (1010)                                    |
| `^`      | Bit-wise XOR: Bandingkan bit-bit dan hasilkan 1 jika hanya salah satu bit 1     | `5 ^ 3` (0101 ^ 0011)   | `6` (0110)                                     |
| `<<`     | Shift left: Shift bit ke kiri                                                   | `5 << 1` (0101 << 1)    | `10` (1010)                                    |
| `>>`     | Shift right: Shift bit ke kanan                                                 | `5 >> 1` (0101 >> 1)    | `2` (0010)                                     |

Berikut adalah beberapa contoh tambahan untuk operator bit-wise di Dart:

```dart
void main() {
  int a = 5; // 0101 dalam biner
  int b = 3; // 0011 dalam biner

  int andResult = a & b; // 0001 dalam biner, nilai 1
  int orResult = a \| b; // 0111 dalam biner, nilai 7
  int notResult = ~a; // 1010 dalam biner, nilai -6 (menggunakan sistem two's complement)
  int xorResult = a ^ b; // 0110 dalam biner, nilai 6
  int shiftLeftResult = a << 1; // 1010 dalam biner, nilai 10
  int shiftRightResult = a >> 1; // 0010 dalam biner, nilai 2

  print("AND: $andResult");
  print("OR: $orResult");
  print("NOT: $notResult");
  print("XOR: $xorResult");
  print("Shift Left: $shiftLeftResult");
  print("Shift Right: $shiftRightResult");
}
```

### Dokumentasi Resmi:

Untuk informasi lebih lanjut dan lengkap mengenai berbagai operator di Dart, bisa merujuk pada [Dokumentasi Resmi Dart tentang Operator](https://dart.dev/language/operators).

> [Atau disini](https://dart.dev/guides/language/language-tour#logical-operators)

#

### Kode saya

```dart
import '../../saya.dart';

void main() {
var nilaiAkhir = 80;
var nilaiAbsen = 50;

var nilaiAkhirBagus = nilaiAkhir >= 75;
var nilaiAbsenBagus = nilaiAbsen >= 75;

print('$merah$nilaiAkhirBagus$rege');
  print('$biru$nilaiAbsenBagus$rege');

var lulus = nilaiAkhirBagus && nilaiAbsenBagus;
print('$hijau$lulus$rege');

lulus = nilaiAkhirBagus || nilaiAbsenBagus;
print('$kuning$lulus$rege');
  print('$ungu${!true}$rege');
print('$cyan${!false}$rege');

print(enter + garis + enter);
// AND
print('AND');
print(true && true); // true
print(true && false); // false

// ignore: dead_code
print(false && true); // false
// ignore: dead_code
print(false && false); // false

// OR
print('OR');

// ignore: dead_code
print(true || true); // true

// ignore: dead_code
print(true || false); // true

print(false || true); // true
print(false || false); // false

// NOT
print('NOT');
print(!true); // false
print(!false); // true

// Operator AND dan OR juga bisa digunakan untuk mengecek nilai null
print('Operator AND dan OR juga bisa digunakan untuk mengecek nilai null');
}
```
