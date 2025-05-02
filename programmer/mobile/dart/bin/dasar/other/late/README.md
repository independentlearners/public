# late

**lazy initialization** (inisialisasi lambat)

#### Standar Variabel Dart

Standartnya dalam dart, variabel akan dideklarasikan nilainya ketika variabel dibuat, tetapi ketika kita ingin sebuah nilai dalam suatu variabel di deklarasikan kemudian, disnilah kata kunci `late` digunakan

#### Sifat Variabel `late`

Variabel dengan kata kunci `late` adalah variabel **non-nullable**, yang berarti mereka tidak bisa bernilai `null` saat diakses. Ini berarti kita harus memastikan variabel tersebut diinisialisasi sebelum digunakan, jika tidak, maka akan terjadi kesalahan runtime.

### Perbedaan Menggunakan Kata Kunci `late` atau Tidak

| **Menggunakan `late`**                                        | **Tidak Menggunakan `late`**                         |
| ------------------------------------------------------------- | ---------------------------------------------------- |
| Variabel diinisialisasi nanti                                 | Variabel harus diinisialisasi saat deklarasi         |
| Variabel non-nullable (tidak bisa `null`)                     | Variabel nullable (bisa `null`)                      |
| Kesalahan runtime jika tidak diinisialisasi sebelum digunakan | Tidak ada persyaratan inisialisasi sebelum digunakan |

#

**Tanpa menggunakan late**

```dart
void main() {
  var value = getTag();
  print('variabel dipanggil');
  print(value);
}

String getTag() {
  print('fungsi getTag() dipanggil');
  return 'Hello Flutter';
}
```

**Output**

```PS
fungsi getTag() dipanggil # output disini
variabel dipanggil
Hello Flutter
```

**Ketika menggunakan late**

```dart
void main() {
  late var value = getTag();
  print('variabel dipanggil');
  print(value);
}

String getTag() {
  print('fungsi getTag() dipanggil');
  return 'Hello Flutter';
}
```

**Output**

```PS
variabel dipanggil
fungsi getTag() dipanggil # output disini
Hello Flutter
```

#

### Kapan Menggunakan **`late`**?

Kata kunci **`late`** digunakan untuk menunda inisialisasi variabel hingga pertama kali diakses. Ini berguna ketika:

1. **Inisialisasi variabel yang mahal** (proses berat) hanya perlu dilakukan jika diperlukan.
2. Kita tidak dapat langsung memberikan nilai awal saat mendeklarasikan variabel, tetapi yakin bahwa nilainya akan diberikan sebelum digunakan.

Contoh:

```dart
class Example {
  late String name;

  void initializeName() {
    name = "Dart Developer"; // Variabel diinisialisasi sebelum digunakan
  }

  void printName() {
    print(name); // Akan error jika `name` belum diinisialisasi
  }
}
```

**Penjelasan Kode Diatas**

Jika kita menghapus baris ini:

`name = "Dart Developer";`

dan kemudian mencoba memanggil **`printName()`** tanpa pernah menginisialisasi variabel **`name`**, kode kita akan menghasilkan **runtime error**.

Ini terjadi karena variabel **`late`** di Dart harus diinisialisasi **sebelum digunakan**. Jika tidak, saat variabel tersebut diakses tanpa nilai, akan muncul **LateInitializationError**.

Contoh skenario yang akan menghasilkan error:

```dart
void main() {
  Example example = Example();

  // example.initializeName(); // Baris ini tidak dipanggil
  example.printName(); // Akan menyebabkan LateInitializationError

}
```

**Penjelasan:**

- **`late String name;`** berarti variabel **`name`** tidak langsung diinisialisasi ketika dibuat, sedangkan Dart **mengharuskan** kita untuk memberikan nilai sebelum variabel itu digunakan.
- Jika kita mencoba mengakses **`name`** tanpa pernah mengisinya, Dart akan memunculkan **LateInitializationError** karena variabel **`name`** tidak memiliki nilai yang valid walapun kita mengubah variabel **`name`** sebagai **`nullable`**.

Jika kita ingin mencegah kesalahan semacam itu, pastikan **`initializeName()`** dipanggil sebelum **`printName()`**. Jadi urutan dari baris tersebut harus sesuai dan tidak boleh seperti ini

```dart
  var example = Example();
  example.printName();
  example.initializeName();
```

Untuk saat ini, demikianlah penjelasan kode diatas yang harus kita pahami, walaupun untuk menghindari error tersebut masih memiliki banyak cara seperti mengubah kode induk dari fungction menjadi constructor, tetapi pembahasannya bukan sekarang, sebab materi constructor ada di `OOP`

#

### Maka Perlu Diingat

- Jangan menggunakan **`late`** sembarangan, terutama untuk variabel yang sering diakses atau jika kita tidak yakin kapan nilai akan diinisialisasi.
- Jika kita menggunakan **`late`** tetapi tidak pernah menginisialisasi variabelnya, akan terjadi runtime error saat variabel diakses.

Sebagai catatan tambahan, Dart terbaru juga menambahkan alat seperti **`late final`**, yang memungkinkan kita menetapkan nilai satu kali saja, tetapi tetap menunda inisialisasi.

Contoh:

```dart
class Example {
  late final String description;

  void setDescription() {
    description = "Flutter is awesome!";
  }
}
```

#

### `late` Direkomendasikan Untuk :

1. **Pengoptimalan Null Safety**: Dengan menggunakan **`late`**, kita dapat menghindari inisialisasi nilai yang tidak diperlukan tanpa harus membuat variabel nullable (`?`).
   Peran penting kata kunci **`late`**, khususnya disamping untuk mendukung **null safety** juga untuk pengoptimalan pengelolaan memori.

1. **Lazy Initialization**: Inisialisasi variabel dilakukan secara efisien, hanya ketika diperlukan.
1. **Kontrol yang Lebih Baik**: Memastikan nilai diberikan pada runtime sebelum digunakan, memberikan fleksibilitas tanpa kehilangan keamanan null.

### Sumber Dokumentasi Resmi

Temukan informasi lebih lanjut tentang kata kunci `late` dalam Dart di [FlutterX](https://flutterx.com/dart-late-keyword-deep-dive-why-there-are-2-kinds-of-late-in-dart-2020-07-26) dan [Educative](https://www.educative.io/answers/what-is-the-late-keyword-in-dart).

#

**Kode saya**

```dart
import '../../../saya.dart';

void main() {
  print(bawah);

  var value = getTag();
  print('variabel dipanggil');
  print(value);

  print(atas);
}

String getTag() {
  print('${merah}fungsi getTag() dipanggil$reset');
  return 'Hello Flutter';
}
```

**Terminal**

```PS


⬇️

fungsi getTag() dipanggil # objek utama
variabel dipanggil
Hello Flutter

⬆️


```

Diterminal kode yang saya gunakan muncul sebagai output dari objek utama yang akan berwarana merah dengan penampilan responsif, output merah akan menunjukan kemana sebuah perubahan terjadi ketika kita mengubah baris ini `var value = getTag();` sebagai `late` atau non-`late`, mungkin terlihat sedikit lebih membingungkan bagi pemula, jadi anda bisa menggunakan contoh lainnya dan meninggalkan halaman ini sekarang
