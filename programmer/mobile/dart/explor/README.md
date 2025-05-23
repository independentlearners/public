# Hasil Eksplorasi Saya

```dart
void main() {
  var i = 0, f = '-' * 10, d = '\n';

  for (; i <= 10; i = ++i) {
    print('$i ulangi');
    print(f);
  }

  print(d);

  num x = 0, o = 0.1;
  x = 1.1;
  x = 1;

  print(x);
  print(f);
  print(o);

  String a, b, c;

  a = 'Halo';

  print(f);
  print(a);

  b = 'Siap';

  print(f);
  print(b);

  c = 'Bro';

  print(f);
  print(c);
}
```

Perlu dilihat beberapa hal dari potongan kode diatas:

1. **Deklarasi dengan `var` berinisialisasi ganda**

   ```dart
   var i = 0, f = '-' * 10, d = '\n';
   ```

   - Pada Dart, satu deklarasi `var` hanya boleh menginfer tipe yang **sama** untuk semua variabel di baris itu.
   - Karena `i` diinisiasi dengan **int** (`0`), kompiler mengasumsikan semua variabel di situ adalah **int**. Maka `f = '-' * 10` (yang menghasilkan `String`) akan menimbulkan error:

     > The type 'String' used in initializer for 'f' isn't a subtype of the type 'int' inferred for the variable 'i'.

   - **Rekomendasi**: pisahkan menjadi deklarasi terpisah—atau gunakan tipe eksplisit jika memang bermacam tipe:

     ```dart
     var i = 0;
     var f = '-' * 10;
     var d = '\n';
     ```

     atau

     ```dart
     int i = 0;
     String f = '-' * 10;
     String d = '\n';
     ```

2. **Deklarasi dengan tipe eksplisit yang homogen**

   ```dart
   num x = 0, o = 0.1;
   ```

   - Karena `num` adalah supertipe dari `int` dan `double`, deklarasi ganda di sini **boleh**: baik `0` (int) maupun `0.1` (double) kompatibel dengan `num`.
   - Saat Anda menulis

     ```dart
     x = 1.1;  // OK, double → num
     x = 1;    // OK, int → num
     ```

     ini tidak akan error.

   - **Catatan**: menggunakan `num` menurunkan keketatan tipe. Jika Anda memang hanya butuh bilangan pecahan, lebih baik pakai `double`; jika hanya bilangan bulat, pakai `int`.

3. **Deklarasi `String a, b, c;` tanpa inisialisasi**

   ```dart
   String a, b, c;
   a = 'Halo';
   b = 'Siap';
   c = 'Bro';
   ```

   - Ini valid, tapi tetap:

     - **Satu variabel per baris** akan memudahkan saat menambahkan modifier (`late`, `final`) atau komentar:

       ```dart
       late String a;
       late String b;
       late String c;
       ```

     - Jika variabel tidak akan diubah setelah inisiasi, pakailah `final`:

       ```dart
       final String a = 'Halo';
       final String b = 'Siap';
       final String c = 'Bro';
       ```

---

## Ringkasnya

- **Jangan** gabungkan deklarasi `var` dengan inisialisasi tipe berbeda dalam satu baris—itu akan error karena Dart menginfer satu tipe untuk keseluruhan.
- **Boleh** gabungkan deklarasi bertipe eksplisit yang homogen (misal `num x, o;` atau `String a, b;`), tapi untuk **readability** dan fleksibilitas modifier, **lebih baik** satu per baris.
- Gunakan `var` hanya jika Anda langsung inisialisasi **dan** tipe hasil inisialisasi **jelas** (semata `int`, `double`, `String`, dll).
- Jika variabel **konstan** setelah diisi, pakai `final` atau `const` untuk menambah keamanan.

Semoga membantu, terus eksperimen dengan gaya deklarasi yang paling nyaman dan aman. Contoh potongan kode diatas hanya sebagai **eksperimen penulisan** dan **demonstrasi fitur** Dart di konsol, bukan pola yang direkomendasikan untuk **arsitektur aplikasi** produksi—kecuali Anda punya alasan khusus.

Beberapa poin penting:

- **Tujuan eksplorasi**

  - Memang cepat untuk mengetes operator seperti `'-' * 10` atau loop tanpa deklarasi kaku.
  - Ideal di REPL, _scratch pad_, atau demo singkat.

- **Kekurangan di kode aplikasi**

  1. **Readability berkurang**

     - Sulit melacak tipe dan _lifecycle_ variabel ketika semua digabung dalam satu baris.

  2. **Maintainability menurun**

     - Menambahkan modifier (`late`, `final`, `const`) jadi ribet jika Anda perlu memecah deklarasi.

  3. **Potensi bug**

     - Inisiasi campur-campur (int, String, dynamic) dapat menimbulkan kesalahan inferensi tipe yang baru terdeteksi saat runtime.

- **Rekomendasi arsitektur aplikasi**

  1. **Deklarasi eksplisit & satu baris per variabel**

     ```dart
     final String separator = '-' * 10;
     late int counter;
     ```

  2. **Gunakan `final` / `const`** untuk nilai yang tidak berubah:

     ```dart
     const newline = '\n';
     ```

  3. **Tipe spesifik > `num` jika perlu**

     - Pakai `int` atau `double` langsung daripada `num`, kecuali Anda benar-benar perlu menampung keduanya.

  4. **Pisahkan logika bisnis dan output presentation**

     - Loop, perhitungan, dan manipulasi data sebaiknya berada di modul/kelas tersendiri; UI/CLI hanya memanggil hasil akhirnya.

- **Kapan boleh menggabung deklarasi?**

  - **Konstanta berkaitan erat**, misal beberapa key yang dipakai bersama:

    ```dart
    const apiKey = 'XXX', apiUrl = 'https://…';
    ```

  - **Variabel sementara** dalam blok sangat singkat dan lokal:

    ```dart
    void demo() {
      var x = 1, y = 2;  // lokal, sangat terbatas cakupannya
      print(x + y);
    }
    ```

Dengan menerapkan pola di atas, kode Anda akan lebih **robust**, **mudah dipelihara**, dan **scalable** saat arsitektur aplikasi berkembang. Semangat terus berinovasi!
