# Latihan I/O

1. **Meminta input** dari pengguna (jumlah perulangan atau nilai untuk dicek),
2. **Mengonversi** input ke `int`,
3. **Memproses** logika `if…else` seperti semula,
4. Jika nilai melebihi 100, **melakukan perulangan** (`for`) dan mencetak `Hello World`.

```dart
import 'dart:io';
void main() {
  // 1. Meminta input dari user
  stdout.write('Masukkan sebuah angka: ');
  String? input = stdin.readLineSync();

  // 2. Mengonversi string input menjadi integer (jika gagal, default 0)
  int i = int.tryParse(input ?? '') ?? 0;

  // 3. Memanggil fungsi s dengan parameter i, lalu mencetak hasilnya
  String output = s(i);
  print(output);
}

/// Fungsi s menerima satu parameter integer [i] dan mengembalikan
/// sebuah string hasil pengecekan atau perulangan.
String s(int i) {
  // 4. Konversi angka ke string untuk ditampilkan
  String x = i.toString();
  print('Nilai input sebagai teks: $x');

  // 5. Blok kondisi if…else untuk berbagai rentang nilai
  if (i <= 10) {
    return 'Kurang dari atau sama dengan 10';
  } else if (i <= 30) {
    return 'Kurang dari atau sama dengan 30';
  } else if (i <= 60) {
    return 'Kurang dari atau sama dengan 60';
  } else if (i <= 90) {
    return 'Kurang dari atau sama dengan 90';
  } else if (i <= 100) {
    return 'Mencapai 100 atau kurang';
  } else {
    // 6. Jika nilai > 100, cetak perulangan Hello World
    //    sebanyak i kali (atau bisa diubah sesuai kebutuhan)
    StringBuffer buffer = StringBuffer();
    for (int j = 1; j <= i; j++) {
      buffer.writeln('$j Hello World');
    }
    return buffer.toString();
  }
}
```

---

### Penjelasan setiap bagian kode

1. **`import 'dart:io';`**
   Mengimpor pustaka input/output, agar kita bisa membaca masukan dari konsol (`stdin`) dan menulis ke konsol (`stdout`).

2. **`stdout.write('Masukkan sebuah angka: ');`**
   Menampilkan prompt tanpa memaksa pindah baris—berguna supaya kursor tetap di akhir teks prompt.

3. **`stdin.readLineSync()`**
   Membaca satu baris input dari pengguna dalam bentuk `String`.

4. **`int.tryParse(input ?? '') ?? 0`**

   - `input ?? ''` menjamin kita tidak mem-parse `null`.
   - `int.tryParse(...)` mencoba mengubah string ke integer; jika gagal (misal user mengetik huruf), hasilnya `null`.
   - `?? 0` menetapkan default `0` jika konversi gagal.

5. **Pemanggilan fungsi `s(i)`**
   Memisahkan logika program ke dalam fungsi terpisah agar `main()` tetap ringkas dan mudah dikelola.

6. **Di dalam fungsi `s(int i)`**

   - **Konversi ke string**: `i.toString()` untuk kemudian ditampilkan dengan konteks yang jelas.
   - **Blok `if…else if…else`**: Menangani berbagai rentang nilai `i` dan mengembalikan teks sesuai kondisi.
   - **Bagian `else` terakhir** (nilai >100):

     - Membuat `StringBuffer`—objek yang efisien untuk membangun string panjang.
     - Menggunakan `for (int j = 1; j <= i; j++)` untuk mengulangi dari 1 hingga `i`.
     - `buffer.writeln()` agar setiap baris `Hello World` berurutan di baris baru.
     - Akhirnya `buffer.toString()` mengubah semua isi buffer menjadi satu string utuh.

7. **Cetak hasil akhir**
   Setelah fungsi `s` selesai, `main()` mencetak string yang dikembalikan, sehingga output terstruktur sesuai kondisi atau perulangan yang terjadi.

---

Kode ini bersifat **dinamis**—kamu bisa memasukkan berapa saja angka di konsol, dan program akan menyesuaikan respons atau melakukan perulangan sebanyak angka tersebut.

> ChatGPT
