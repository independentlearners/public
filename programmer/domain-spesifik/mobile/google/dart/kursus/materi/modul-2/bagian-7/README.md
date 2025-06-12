# Final vs Const

Mari kita selami perbedaan antara `final` dan `const` secara mendalam. Kedua kata kunci ini digunakan untuk mendeklarasikan nilai-nilai yang tidak dapat diubah (immutable), namun perbedaan mendasarnya terletak pada _kapan_ nilai tersebut ditetapkan.

---

### 1\. Pendahuluan

Dalam pemrograman, _immutability_ (ketidakmampuan untuk diubah) adalah konsep yang sangat penting untuk menulis kode yang lebih aman, lebih mudah dipahami, dan lebih mudah di-debug. Dart menyediakan dua kata kunci untuk mencapai immutability: `final` dan `const`.

Meskipun keduanya membuat variabel menjadi tidak bisa diubah setelah diinisialisasi, mereka bekerja pada "waktu" yang berbeda:

- **`final`**: Ditetapkan pada **waktu eksekusi (runtime)**.
- **`const`**: Ditetapkan pada **waktu kompilasi (compile-time)**.

Memahami perbedaan ini sangat penting untuk memilih kata kunci yang tepat, terutama dalam konteks optimasi kinerja (khususnya di Flutter) dan penanganan nilai-nilai yang dinamis versus statis.

---

### 2\. `final`

#### Definisi

`final` digunakan untuk mendeklarasikan variabel yang hanya dapat diinisialisasi **satu kali**. Setelah nilai ditetapkan, nilai tersebut tidak dapat diubah lagi.

#### Karakteristik Utama `final`

1.  **Inisialisasi Runtime:** Nilainya ditentukan saat program sedang berjalan (runtime). Ini berarti nilai tersebut bisa berasal dari:
    - Hasil komputasi.
    - Input pengguna.
    - Pengambilan data dari jaringan atau database.
    - `DateTime.now()`.
    - Instansi objek baru (yang dibuat pada runtime).
2.  **Ditugaskan Sekali:** Variabel `final` hanya dapat ditugaskan sekali. Mencoba mengubah nilainya setelah diinisialisasi akan menghasilkan _compile-time error_.
3.  **Bukan Konstan Waktu Kompilasi:** Nilai dari variabel `final` tidak perlu diketahui pada waktu kompilasi.
4.  **Immutability Referensi (Bukan Isi):** Untuk koleksi (seperti `List` atau `Map`) atau objek kustom, `final` berarti referensi ke objek tersebut tidak dapat diubah. **Namun, isi dari objek yang dirujuk _bisa_ diubah** (jika objeknya mutable). Ini adalah poin penting yang sering disalahpahami.

#### Sintaks dan Contoh `final`

```dart
void main() {
  // Contoh 1: Nilai dari input atau hasil komputasi
  final String namaPengguna = "Alice"; // Ditetapkan saat runtime
  // namaPengguna = "Bob"; // ERROR: A final variable can only be set once.

  final int tahunSekarang = DateTime.now().year; // Nilai ini diketahui saat program berjalan
  print("Tahun sekarang: $tahunSekarang");
  // tahunSekarang = 2026; // ERROR

  // Contoh 2: Properti kelas
  // Properti final harus diinisialisasi di konstruktor atau saat deklarasi.
  class Produk {
    final String id;
    final String nama;
    final double harga;

    // Semua properti final diinisialisasi melalui konstruktor
    Produk(this.id, this.nama, this.harga);
  }

  final Produk buku = Produk("B001", "Dasar-Dasar Dart", 75.0);
  print("Produk: ${buku.nama}, Harga: ${buku.harga}");
  // buku.harga = 80.0; // ERROR: Cannot set the field 'harga' because it is final.

  // Contoh 3: Final dengan Koleksi (List/Map) - PENTING!
  final List<String> daftarPekerjaan = [" coding", " menulis", " membaca"];
  print("Daftar pekerjaan awal: $daftarPekerjaan");

  // OK: Bisa mengubah isi dari list karena yang final adalah REFERENSI list, bukan ISINYA.
  daftarPekerjaan.add("olahraga");
  print("Daftar pekerjaan setelah tambah: $daftarPekerjaan"); // Output: [ coding, menulis, membaca, olahraga]

  // ERROR: Tidak bisa menugaskan list baru ke variabel final
  // daftarPekerjaan = ["berkebun", "memasak"]; // ERROR: A final variable can only be set once.

  final Map<String, int> stock = {"pensil": 100, "buku": 50};
  stock["pena"] = 75; // OK: Bisa mengubah isi map
  print("Stock: $stock");
  // stock = {"penghapus": 20}; // ERROR: A final variable can only be set once.
}
```

#### Kapan Menggunakan `final`?

- Ketika Anda memiliki variabel yang nilainya harus ditetapkan sekali dan tidak akan berubah setelah itu, tetapi nilai tersebut tidak diketahui sampai program berjalan.
- Untuk properti kelas yang harus diinisialisasi di konstruktor dan tidak boleh berubah sepanjang masa hidup objek (seperti ID unik, nama pengguna yang ditetapkan saat pendaftaran).
- Ketika Anda menerima data dari sumber eksternal (misalnya, API, file, input pengguna) yang tidak berubah setelah diterima.

---

### 3\. `const`

#### Definisi

`const` digunakan untuk mendeklarasikan variabel yang nilainya adalah **konstanta waktu kompilasi (compile-time constant)**. Ini berarti nilai variabel harus sepenuhnya diketahui **sebelum program dimulai** (pada saat kode Anda dikompilasi).

#### Karakteristik Utama `const`

1.  **Inisialisasi Compile-time:** Nilainya harus sepenuhnya diketahui pada waktu kompilasi. Ini berarti nilai tersebut harus berupa:
    - Literal (misalnya, `10`, `"teks"`, `3.14`, `true`).
    - Ekspresi `const` lain.
    - Kombinasi literal dan ekspresi `const`.
    - Objek yang dibuat dengan konstruktor `const`.
    - `DateTime.utc(2025, 1, 1)` (yang merupakan `const` constructor), bukan `DateTime.now()` (yang runtime).
2.  **Ditugaskan Sekali:** Sama seperti `final`, variabel `const` hanya dapat ditugaskan sekali. Mencoba mengubah nilainya setelah diinisialisasi akan menghasilkan _compile-time error_.
3.  **Immutability Rekursif (Deep Immutability):** Ini adalah perbedaan krusial. Jika sebuah objek (termasuk koleksi seperti `List` atau `Map`) dinyatakan sebagai `const`, maka **seluruh objek tersebut dan semua isinya akan menjadi _immutable_**. Anda tidak bisa mengubah elemen di dalam `const List` atau `const Map`.
4.  **Canonicalization (Optimasi Memori):** Ketika Anda membuat dua objek `const` yang identik, Dart akan mengoptimalkan memori dengan menunjuk kedua referensi ke instance objek yang _sama_ di memori. Ini disebut "canonicalization" atau "intering". Ini adalah alasan utama `const` penting di Flutter untuk _widget_ yang tidak berubah.
5.  **Variabel Top-Level, Statis, atau Lokal:** Bisa digunakan di mana saja.

#### Sintaks dan Contoh `const`

```dart
void main() {
  // Contoh 1: Nilai literal atau ekspresi yang bisa dievaluasi saat kompilasi
  const double PI = 3.14159; // Nilai sudah diketahui saat kompilasi
  const String VERSI_SISTEM = "1.0.0"; // Nilai sudah diketahui saat kompilasi

  print("Nilai PI: $PI");
  print("Versi Sistem: $VERSI_SISTEM");

  // ERROR: DateTime.now() tidak bisa menjadi const karena nilainya berubah pada runtime
  // const DateTime WAKTU_PEMBUATAN = DateTime.now();

  // Contoh 2: const dengan Koleksi - PENTING!
  // Perhatikan bahwa seluruh list menjadi immutable.
  const List<String> hariKerja = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"];
  print("Hari kerja: $hariKerja");

  // ERROR: Tidak bisa mengubah isi dari const list
  // hariKerja.add("Sabtu"); // ERROR: Unsupported operation: Cannot add to an unmodifiable list
  // hariKerja[0] = "Minggu"; // ERROR: Unsupported operation: Cannot set value in unmodifiable list

  // ERROR: Tidak bisa menugaskan list baru
  // hariKerja = ["Sabtu", "Minggu"]; // ERROR: Constant variables can't be assigned a value.

  const Map<String, int> kodeNegara = {"ID": 62, "US": 1};
  // kodeNegara["SG"] = 65; // ERROR: Unsupported operation: Cannot add to unmodifiable map

  // Contoh 3: Constructor `const`
  // Sebuah kelas bisa memiliki constructor `const` jika semua properti-nya `final`
  // dan inisialisasi propertinya adalah compile-time constant.
  class Titik {
    final int x;
    final int y;

    // Constructor harus const agar objek Titik bisa dibuat sebagai const
    const Titik(this.x, this.y);
  }

  const Titik origin = Titik(0, 0); // Objek `origin` adalah compile-time constant
  const Titik otherPoint = Titik(0, 0); // Ini adalah objek yang sama dengan `origin` karena canonicalization
  print(origin == otherPoint); // Output: true (karena objek yang sama di memori)

  final Titik dynamicPoint1 = Titik(1, 1); // Ini adalah final, bukan const
  final Titik dynamicPoint2 = Titik(1, 1); // Ini adalah objek yang berbeda
  print(dynamicPoint1 == dynamicPoint2); // Output: false
}
```

#### Kapan Menggunakan `const`?

- Ketika Anda memiliki nilai yang benar-benar konstan dan tidak akan pernah berubah sepanjang hidup aplikasi (misalnya, konstanta matematika, _API keys_ yang _hardcoded_, string pesan statis, path file statis).
- Untuk objek yang dapat diidentifikasi sebagai _compile-time constant_ dan Anda ingin memanfaatkan optimasi "canonicalization" (terutama penting di Flutter untuk _widget_ yang tidak berubah guna meningkatkan performa rendering).
- Ketika Anda ingin memastikan seluruh struktur data (seperti `List` atau `Map`) benar-benar _immutable_ dan tidak dapat diubah isinya.

---

### 4\. Perbedaan Kunci: `final` vs `const`

| Fitur                | `final`                                                                                    | `const`                                                                                                           |
| :------------------- | :----------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------- |
| **Kapan Ditetapkan** | **Runtime** (saat program berjalan)                                                        | **Compile-time** (sebelum program dimulai)                                                                        |
| **Sumber Nilai**     | Perhitungan, I/O (file, network), input pengguna, `DateTime.now()`, objek `new`            | Hanya literal, ekspresi `const` lain, konstruktor `const`                                                         |
| **Immutability**     | **Dangkal**: Referensi tidak dapat diubah. Isi koleksi/objek _bisa_ diubah (jika mutable). | **Dalam (Rekursif)**: Seluruh objek dan isinya (jika objek dibuat dengan `const` constructor) tidak dapat diubah. |
| **Optimasi Memori**  | Tidak ada canonicalization. Setiap kali dibuat, adalah instance baru.                      | **Canonicalization**: Objek yang identik akan menunjuk ke instance memori yang sama.                              |
| **Konstruktor**      | Kelas bisa memiliki properti `final`, tetapi konstruktornya tidak harus `const`.           | Untuk membuat objek `const`, kelas harus memiliki konstruktor `const`.                                            |
| **Contoh Umum**      | `final user = User("ID123");` \<br\> `final waktu = DateTime.now();`                       | `const PI = 3.14;` \<br\> `const daftar = [1, 2, 3];` \<br\> `const Widget MyText("Hello");`                      |

---

### 5\. Aturan Praktis dan Rekomendasi

1.  **Gunakan `const` jika memungkinkan:** Jika suatu nilai bisa menjadi `const`, selalu lebih baik menggunakannya karena memberikan optimasi performa dan jaminan _deep immutability_. Ini adalah aturan jempol di Flutter.
2.  **Gunakan `final` jika `const` tidak memungkinkan:** Jika nilai tidak dapat ditentukan saat kompilasi (misalnya, berasal dari API, input, atau perhitungan runtime), gunakan `final`.
3.  **Pahami _Deep Immutability_ `const`:** Ingat bahwa `const List` atau `const Map` tidak dapat diubah isinya, sementara `final List` atau `final Map` dapat.
4.  **`const` menular:** Jika Anda memiliki ekspresi `const`, semua bagiannya harus `const`. Misalnya, Anda tidak bisa memiliki `const List<DateTime> list = [DateTime.now()];` karena `DateTime.now()` bukan `const`. Anda juga tidak bisa memiliki `const MyClass(myObject)` jika `myObject` bukan `const` atau `MyClass` tidak memiliki konstruktor `const`.

#### Contoh Skema Keputusan

```mermaid
graph TD
    A[Nilai yang Ingin Disimpan Immutable?] --> B{Apakah Nilai Sepenuhnya Diketahui Saat Kompilasi?};
    B -- Ya --> C{Apakah Nilai atau Isinya Juga Harus Sepenuhnya Immutable?};
    C -- Ya --> D[Gunakan `const`];
    C -- Tidak (hanya referensi) --> E[Gunakan `final` (jika objeknya mutable)];
    B -- Tidak --> F[Gunakan `final`];
```

---

### 6\. Ringkasan

`final` dan `const` adalah alat penting untuk manajemen _immutability_ di Dart.

- Pilih **`final`** ketika nilai Anda ditetapkan sekali pada **runtime** dan tidak akan berubah lagi, tetapi mungkin ada perubahan pada _isi_ objek jika itu adalah koleksi atau objek mutable.
- Pilih **`const`** ketika nilai Anda ditetapkan sekali pada **compile-time**, dan Anda ingin seluruh objek (termasuk isinya) menjadi **sepenuhnya _immutable_**, seringkali memanfaatkan optimasi memori.

Memilih yang tepat tidak hanya membuat kode Anda lebih aman tetapi juga dapat memengaruhi performa dan arsitektur aplikasi Anda.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-6/README.md
[selanjutnya]: ../bagian-8/README.md

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
