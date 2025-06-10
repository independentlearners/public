# var

Dart adalah bahasa yang menggunakan tipe data secara statis. Dalam bahasa pemrograman Dart, `var` adalah cara untuk mendeklarasikan variabel tanpa harus menyatakan tipe datanya secara eksplisit karena inferensi tipe data `var` menggunakan algoritma yang cukup canggih. Sehingga meskipun kita dilarang menyebutkan tipe data secara eksplisit ketika menggunakan `var`, secara otomatis Dart akan menebak dan menentukan tipe data berdasarkan nilai yang diberikan pada saat variabel pertama kali diinisialisasi.

#### Contoh:

```dart
var myNumber = 42; // Dart akan menganggap ini sebagai int
var myText = "Hello, Dart!"; // Dart akan menganggap ini sebagai String
```

**Cek tipe data**: Untuk memastikan dart menentukan `var` sebagai tipe data berdadsarkan nilainya, coba arahkan kursor pada variabel dan popup akan muncul seperti pada contoh berikut:

![Imgur](https://files.catbox.moe/mjtri1.png "jika gambar tidak muncul,")

**Inferensi Tipe**:
Bisa dikatakan `var` di Dart memberikan fleksibilitas dalam penulisan kode karena memungkinkan Dart menentukan tipe data secara otomatis berdasarkan nilai yang diberikan. Namun, ingat bahwa ketika menggunakan `var` seperti contoh diatas. Yaitu ditetapkan secara langsung, maka selanjutnya tipe data tersebut tidak dapat diubah lagi.

#### Sebagai contoh:

```dart
var flexibleVariable = "String value"; // Dart menentukan ini sebagai String
flexibleVariable = 42; // Akan menghasilkan error karena tipe data sudah ditentukan sebagai String
```

> ### Poin penting yang perlu diperhatikan saat menggunakan `var`:

Fleksibilitas ini berguna untuk menulis kode dengan cepat dan singkat, tetapi tetap perlu diperhatikan agar tidak mengorbankan kejelasan dan konsistensi kode, sebab dalam pemrograman, konsistensi adalah bagian paling penting untuk meminimalisir tingkat error. Pahami dengan baik bagaimana Dart melakukan inferensi tipe data agar dapat memanfaatkan `var` secara maksimal.

**Kejelasan Kode**: Terkadang, lebih baik menyatakan tipe data secara eksplisit untuk memperjelas maksud kode Anda kepada pembaca lain atau diri Anda sendiri di masa depan.

**Konsistensi**: Meskipun `var` praktis, gunakan dengan bijak dan pastikan kode tetap mudah dibaca dan dipahami.

**Fleksibilitas**: Kita bisa menjadikan `var` sebagai tipe data dinamik yang memungkinkan untuk membuat variabel satu kali namun bisa dibgunakan untuk berbagai jenis dari nilai tipe data yang berbeda-beda seperti pada contoh berikut:

```dart
void main() {

  var myNumber;
  // Dart menyatakan bahwa ini adalah tipe data Dynamic sehingga nilai dari variabel yang di daklarasikan setelahnya bisa berubah-ubah

  myNumber = 4.2;
  print(myNumber);

  myNumber = 42;
  print(myNumber);

  myNumber = 'Empat Dua';
  print(myNumber);

  myNumber = false;
  print(myNumber);

}
```

Arahkan kursor pada variabel dan kita akan melihat bahwa dart menyatakan `var` sebagai tipe data dynamic seperti pada gambar berikut:

![Imgur](https://files.catbox.moe/18htf5.png "jika gambar tidak muncul,")

### Keuntungan dan Kerugian

**Keuntungan**:

- **Kode yang lebih ringkas**
- **Fleksibilitas**

**Kerugian**:

- **Kurangnya Keterbacaan apabila kode sudah menjadii proyek yang lebih kompleks**
- **Potensi Kesalahan**

### Contoh Penggunaan

```dart
void main() {
  var a = 10; // Dart menentukan ini sebagai int
  print(a); // Output: 10

  a = "Hello Dart"; // Error: Tipe data sudah ditetapkan sebagai int
}
```

### Kesimpulan

Penggunaan `var` dalam Dart sangat berguna untuk penulisan kode yang lebih cepat dan lebih ringkas, tetapi perlu digunakan dengan bijak untuk menjaga keterbacaan dan konsistensi kode. Jika Anda merasa lebih nyaman dengan menyebutkan tipe data secara eksplisit, anda bisa menggunakan tipe data primitif seperti `String` `int` `bool` dan seterusnya sebsb itu juga adalah pilihan yang baik.
