# [String Interpolation][0]

### 1. Pendahuluan

Dalam pemrograman, kita sering perlu menggabungkan teks (string) dengan nilai variabel atau hasil ekspresi. Cara tradisional adalah dengan menggunakan operator penggabungan (`+`). Namun, Dart (dan banyak bahasa modern lainnya) menyediakan cara yang lebih elegan, lebih mudah dibaca, dan seringkali lebih efisien untuk melakukan ini, yaitu **String Interpolation**.

**String Interpolation** adalah fitur yang memungkinkan Anda menyisipkan ekspresi Dart ke dalam string literal. Ini menghilangkan kebutuhan untuk memecah string dengan operator `+` dan membuatnya lebih mudah untuk membaca dan menulis string kompleks.

### 2. Sintaks Dasar

String interpolation di Dart menggunakan tanda dolar (`$`).

- **Untuk variabel:** Cukup letakkan `$variableName`.
- **Untuk ekspresi:** Gunakan `${expression}` (ekspresi yang lebih kompleks harus berada dalam kurung kurawal).

### 3. Contoh Penggunaan

#### a. Interpolasi Variabel Sederhana

Ketika Anda ingin menyisipkan nilai dari satu variabel, Anda cukup menggunakan `$namaVariabel`.

```dart
void main() {
  String nama = "Budi";
  int usia = 30;

  // Tanpa String Interpolation (kurang efisien dan sulit dibaca)
  print("Nama saya adalah " + nama + " dan saya berusia " + usia.toString() + " tahun.");

  // Dengan String Interpolation (lebih bersih dan mudah dibaca)
  print("Nama saya adalah $nama dan saya berusia $usia tahun.");
  // Output: Nama saya adalah Budi dan saya berusia 30 tahun.

  double harga = 1500.50;
  print("Harga barang: Rp$harga"); // Output: Harga barang: Rp1500.5
}
```

#### b. Interpolasi Ekspresi

Ketika Anda perlu menyisipkan hasil dari sebuah ekspresi (seperti operasi matematika, pemanggilan metode, atau akses properti), Anda harus mengelilingi ekspresi tersebut dengan kurung kurawal `{}`.

```dart
void main() {
  int a = 10;
  int b = 5;

  // Ekspresi matematika
  print("Hasil penjumlahan $a + $b adalah ${a + b}.");
  // Output: Hasil penjumlahan 10 + 5 adalah 15.

  String pesan = "Halo Dunia";
  // Memanggil metode pada string
  print("Panjang pesan '${pesan}' adalah ${pesan.length} karakter.");
  // Output: Panjang pesan 'Halo Dunia' adalah 10 karakter.

  List<String> buah = ["Apel", "Jeruk", "Mangga"];
  // Mengakses elemen list atau properti lainnya
  print("Buah favorit saya adalah ${buah[0].toUpperCase()}.");
  // Output: Buah favorit saya adalah APEL.

  // Ekspresi boolean
  bool isRaining = true;
  print("Apakah hari ini hujan? ${isRaining ? 'Ya' : 'Tidak'}.");
  // Output: Apakah hari ini hujan? Ya.
}
```

#### c. Menggabungkan Variabel dan Ekspresi

Anda bisa menggabungkan keduanya dalam satu string.

```dart
void main() {
  String produk = "Laptop";
  double hargaPerUnit = 1200.0;
  int kuantitas = 2;

  print("Anda membeli $kuantitas unit $produk dengan total harga Rp${hargaPerUnit * kuantitas}.");
  // Output: Anda membeli 2 unit Laptop dengan total harga Rp2400.0.
}
```

#### d. String Multi-Baris dengan Interpolasi

String multi-baris (menggunakan triple quotes `'''` atau `"""`) juga mendukung string interpolation.

```dart
void main() {
  String event = "Konferensi Dart";
  DateTime tanggal = DateTime(2025, 10, 26);

  String undangan = '''
Halo,

Anda diundang ke acara penting:
${event}!

Tanggal: ${tanggal.day}/${tanggal.month}/${tanggal.year}
Waktu: Pukul 09:00 WIB

Sampai jumpa!
''';
  print(undangan);
}
```

**Output:**

```
Halo,

Anda diundang ke acara penting:
Konferensi Dart!

Tanggal: 26/10/2025
Waktu: Pukul 09:00 WIB

Sampai jumpa!
```

### 4. Keuntungan String Interpolation

1.  **Keterbacaan (Readability):** Kode menjadi jauh lebih mudah dibaca dan dipahami karena string terlihat lebih mirip dengan output yang diharapkan. Anda tidak perlu repot dengan tanda kutip dan operator `+`.
2.  **Kemudahan Penulisan (Writability):** Mengurangi jumlah karakter yang perlu diketik dibandingkan dengan operator `+`.
3.  **Potensi Performa:** Meskipun Dart JIT (Just-In-Time) compiler cukup cerdas, pada beberapa kasus, string interpolation dapat lebih efisien karena kompiler dapat mengoptimalkan pembentukan string secara langsung.
4.  **Menghindari `toString()` Eksplisit:** Dart secara otomatis akan memanggil metode `toString()` pada objek atau ekspresi yang Anda interpolasi, sehingga Anda tidak perlu menuliskannya secara manual (misalnya, `usia.toString()`).

### 5. Kapan Menggunakan `{}`?

Aturan sederhana:

- Jika Anda menginterpolasi **nama variabel tunggal** yang tidak langsung diikuti oleh karakter _identifier_ lain (huruf, angka, atau underscore), gunakan `$namaVariabel`.
  - `print("Hello $name!");` (OK)
  - `print("Umur saya $age.");` (OK)
- Jika Anda menginterpolasi **ekspresi apa pun** (termasuk pemanggilan metode, operasi matematika, akses properti, atau jika nama variabel tunggal Anda langsung diikuti oleh karakter _identifier_ yang bisa salah diartikan), gunakan `${ekspresi}`.
  - `print("Nama panjang: ${user.fullName}");` (OK)
  - `print("Total: ${price * quantity}");` (OK)
  - `print("Nomor urut: ${orderNumber}A");` (Jika tidak pakai `{}` akan dianggap `$orderNumberA`)
    - `print("Nomor urut: ${orderNumber}A");` (Ini benar)
    - `print("Nomor urut: $orderNumberA");` (Ini akan mencari variabel bernama `orderNumberA`)

Contoh kasus terakhir:

```dart
void main() {
  String judul = "Dart";
  print("Ini adalah buku tentang ${judul}Pad. Ini bukan buku tentang ${judul}.");
  // Output: Ini adalah buku tentang DartPad. Ini bukan buku tentang Dart.

  // Jika tidak menggunakan kurung kurawal pada ${judul}Pad:
  // print("Ini adalah buku tentang $judulPad."); // Akan mencari variabel bernama 'judulPad'
}
```

### 6. Pertimbangan Performa

Untuk operasi penggabungan string yang sangat banyak dalam sebuah _loop_ atau skenario _high-performance_, `StringBuffer` bisa menjadi alternatif yang lebih efisien daripada berulang kali menggunakan interpolation atau operator `+`. Namun, untuk sebagian besar kasus penggunaan sehari-hari, string interpolation sangat efisien dan direkomendasikan karena keterbacaannya.

```dart
void main() {
  var sb = StringBuffer();
  for (int i = 0; i < 10; i++) {
    sb.write("Ini adalah baris $i.\n");
  }
  print(sb.toString());
}
```

`StringBuffer` membangun string secara bertahap dalam memori dan kemudian mengonversinya menjadi satu string pada akhirnya, yang mengurangi alokasi memori berulang.

### 7. Ringkasan

**String Interpolation** adalah fitur yang harus Anda gunakan secara teratur di Dart. Ini membuat kode Anda lebih bersih, lebih mudah dipahami, dan seringkali lebih efisien untuk membangun string kompleks. Ingat aturan `$variabel` untuk kasus sederhana dan `${ekspresi}` untuk ekspresi yang lebih kompleks atau ambigu.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-10/README.md
[selanjutnya]: ../bagian-12/README.md

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
