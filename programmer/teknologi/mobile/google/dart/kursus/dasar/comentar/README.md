# 📝 [Comments][0]

Ini adalah fitur fundamental dalam setiap bahasa pemrograman yang mungkin terlihat sederhana, namun sangat krusial untuk kualitas dan pemeliharaan kode yang baik.

<details>
  <summary>📃 Daftar Isi</summary>

---

- [📝 Comments](#-comments)
    - [1. Pendahuluan](#1-pendahuluan)
    - [2. Mengapa Komentar Penting?](#2-mengapa-komentar-penting)
    - [3. Jenis-Jenis Komentar di Dart](#3-jenis-jenis-komentar-di-dart)
      - [a. Komentar Baris Tunggal (`//`)](#a-komentar-baris-tunggal-)
      - [b. Komentar Multi-Baris (`/* ... */`)](#b-komentar-multi-baris---)
      - [c. Komentar Dokumentasi (`///` atau `/** ... */`)](#c-komentar-dokumentasi--atau---)
        - [Markdown dalam Komentar Dokumentasi](#markdown-dalam-komentar-dokumentasi)
        - [Referensi ID dalam Komentar Dokumentasi](#referensi-id-dalam-komentar-dokumentasi)
    - [4. Kapan dan Bagaimana Menggunakan Komentar Secara Efektif?](#4-kapan-dan-bagaimana-menggunakan-komentar-secara-efektif)
      - [a. Apa yang Seharusnya Dikomentari?](#a-apa-yang-seharusnya-dikomentari)
      - [b. Apa yang Seharusnya **Tidak** Dikomentari?](#b-apa-yang-seharusnya-tidak-dikomentari)
      - [c. Komentar yang Baik vs. Komentar Buruk](#c-komentar-yang-baik-vs-komentar-buruk)
    - [5. Ringkasan](#5-ringkasan)
  - [Mewarnai Komenar Dengan Ekstensi](#mewarnai-komenar-dengan-ekstensi)

</details>

---

### 1\. Pendahuluan

Dalam pemrograman, **komentar** adalah bagian dari kode sumber yang diabaikan oleh kompiler (atau interpreter). Artinya, komentar tidak memengaruhi bagaimana program berjalan. Tujuan utama komentar adalah untuk memberikan penjelasan atau catatan bagi manusia yang membaca kode tersebut, baik itu Anda sendiri di masa depan, rekan satu tim, atau bahkan komunitas _open source_.

Di Dart, ada beberapa jenis komentar yang masing-masing memiliki tujuan dan penggunaan spesifik.

---

### 2\. Mengapa Komentar Penting?

Meskipun terlihat seperti detail kecil, komentar memainkan peran besar dalam pengembangan perangkat lunak:

- **Klarifikasi Logika Kompleks**: Menjelaskan mengapa bagian kode tertentu ditulis dengan cara tertentu, terutama untuk algoritma yang rumit atau keputusan desain yang tidak langsung jelas.
- **Dokumentasi Kode**: Memberikan gambaran umum tentang fungsionalitas kelas, metode, atau modul, termasuk parameter yang diharapkan, nilai kembalian, dan efek samping.
- **Pemeliharaan Jangka Panjang**: Kode yang ditulis hari ini mungkin perlu dimodifikasi atau diperbaiki berbulan-bulan atau bertahun-tahun kemudian. Komentar membantu Anda (atau orang lain) untuk cepat memahami kembali konteksnya.
- **Kolaborasi Tim**: Memfasilitasi kerja tim dengan memastikan semua anggota memiliki pemahaman yang sama tentang berbagai bagian _codebase_.
- **Penandaan Sementara**: Digunakan untuk menonaktifkan sementara baris kode (`comment out`) atau menandai area yang memerlukan perhatian (`TODO`, `FIXME`).

---

### 3\. Jenis-Jenis Komentar di Dart

Dart mendukung tiga jenis komentar utama, masing-masing dengan sintaks dan tujuan yang sedikit berbeda:

#### a. Komentar Baris Tunggal (`//`)

Ini adalah jenis komentar yang paling dasar dan paling sering digunakan. Segala sesuatu setelah `//` hingga akhir baris akan dianggap sebagai komentar.

```dart
void main() {
  // Ini adalah komentar satu baris.
  print('Hello Dart!'); // Komentar juga bisa berada di akhir baris kode.

  var name = 'Alice'; // Deklarasi variabel nama
  // Jika kode di bawah ini dinonaktifkan sementara
  // print('Nama: $name');
}
```

**Kapan Digunakan:**

- Untuk komentar singkat yang menjelaskan baris kode tertentu.
- Untuk menonaktifkan sementara baris kode.

#### b. Komentar Multi-Baris (`/* ... */`)

Digunakan untuk menulis komentar yang mencakup beberapa baris. Komentar dimulai dengan `/*` dan diakhiri dengan `*/`.

```dart
void calculateArea(double length, double width) {
  /*
   * Fungsi ini menghitung luas persegi panjang.
   * Parameter:
   * - length: panjang sisi (double)
   * - width: lebar sisi (double)
   * Mengembalikan:
   * - Luas sebagai double.
   */
  double area = length * width;
  print('Luas: $area');
}

void main() {
  /* Ini juga bisa digunakan untuk komentar singkat
   * yang tidak berakhir di akhir baris,
   * meskipun // lebih umum untuk itu. */
  calculateArea(5.0, 3.0);
}
```

**Kapan Digunakan:**

- Untuk blok komentar yang lebih panjang, seperti penjelasan fungsi, bagian dari algoritma, atau _disclaimer_.
- Dapat juga digunakan untuk menonaktifkan blok kode yang lebih besar.

#### c. Komentar Dokumentasi (`///` atau `/** ... */`)

Ini adalah jenis komentar paling kuat di Dart. Komentar dokumentasi digunakan untuk menjelaskan _library_, kelas, _method_, _getter_, _setter_, _field_, _constructor_, atau _typedef_. Komentar ini diproses oleh alat dokumentasi Dart (seperti `dart doc`) untuk menghasilkan halaman web dokumentasi API yang indah.

**Sintaks:**

- Setiap baris dimulai dengan `///` (disarankan, karena lebih rapi).
- Atau dengan blok `/** ... */` (mirip dengan Javadoc).

<!-- end list -->

````dart
/// Represents a customizable user profile.
///
/// This class holds information about a user's name, age, and email.
///
/// Example:
/// ```dart
/// var user = UserProfile('John Doe', 30, 'john.doe@example.com');
/// user.displayInfo();
/// ```
class UserProfile {
  /// The user's full name.
  final String name;

  /// The user's age. Must be a positive integer.
  final int age;

  /// The user's email address. Can be null if not provided.
  final String? email;

  /**
   * Constructs a new [UserProfile] instance.
   *
   * @param name The full name of the user.
   * @param age The age of the user.
   * @param email An optional email address for the user.
   */
  UserProfile(this.name, this.age, this.email);

  /// Displays the user's information to the console.
  ///
  /// This method prints the [name], [age], and [email] if available.
  void displayInfo() {
    print('Name: $name');
    print('Age: $age');
    if (email != null) {
      print('Email: $email');
    }
  }
}

void main() {
  var user = UserProfile('Jane Smith', 25, null);
  user.displayInfo();
}
````

**Kapan Digunakan:**

- Untuk mendokumentasikan API publik (kelas, metode, properti) yang akan digunakan oleh pengembang lain atau oleh Anda sendiri di proyek besar.
- Ketika Anda ingin menghasilkan dokumentasi otomatis untuk proyek Dart Anda.

##### Markdown dalam Komentar Dokumentasi

Komentar dokumentasi mendukung sintaks **Markdown**, yang memungkinkan Anda memformat teks (misalnya, _bold_, _italic_, _lists_, _code blocks_).

- `**bold**`
- `*italic*`
- `[link text](url)`
- `[referensi_kelas]` atau `[methodName]` untuk referensi internal.
- `dart ` untuk blok kode.

##### Referensi ID dalam Komentar Dokumentasi

Anda dapat merujuk ke identifier Dart lain (misalnya nama kelas, metode, atau variabel) dalam komentar dokumentasi dengan mengapitnya dalam kurung siku (`[]`). Alat dokumentasi akan membuat _link_ ke dokumentasi identifier tersebut.

- Lihat contoh `[UserProfile]`, `[name]`, `[age]`, `[email]`, `[displayInfo]` di kode di atas.

---

### 4\. Kapan dan Bagaimana Menggunakan Komentar Secara Efektif?

Komentar yang baik adalah seni. Tujuannya adalah untuk menambah nilai, bukan membuat kode lebih berantakan.

#### a. Apa yang Seharusnya Dikomentari?

- **"Mengapa"**: Alasan di balik keputusan desain atau algoritma tertentu yang tidak langsung jelas dari kodenya.
- **Logika Kompleks**: Bagian kode yang rumit atau cerdas yang mungkin sulit dipahami tanpa konteks tambahan.
- **Efek Samping**: Menjelaskan efek samping (terutama yang tidak jelas) dari sebuah fungsi atau metode.
- **Batasan atau Asumsi**: Jika sebuah fungsi memiliki batasan tertentu pada inputnya atau membuat asumsi tentang lingkungan.
- **TODOs/FIXMEs**: Penanda untuk pekerjaan yang perlu dilakukan di masa mendatang atau bug yang perlu diperbaiki.

#### b. Apa yang Seharusnya **Tidak** Dikomentari?

- **Kode yang Jelas Sendiri**: Jangan mengomentari apa yang sudah jelas dari nama variabel atau struktur kode.
  ```dart
  // BAD: totalPrice = quantity * price; // Hitung total harga
  var totalPrice = quantity * price; // Ini sudah jelas
  ```
- **Pengulangan Kode**: Komentar yang hanya mengulang apa yang sudah tertulis di kode.
- **Kode Mati/Tidak Terpakai**: Hapus saja kode mati, jangan dikomentari.
- **Informasi yang Dapat Dihasilkan Otomatis**: Jangan tulis komentar yang bisa digenerasi dari alat dokumentasi atau sistem kontrol versi.

#### c. Komentar yang Baik vs. Komentar Buruk

- **Komentar Baik**: Menjelaskan _niat_, _alasan_, dan _implikasi_. Singkat, jelas, dan relevan.
  ```dart
  // GOOD: Menggunakan algoritma QuickSort karena performa rata-rata yang lebih baik
  // untuk dataset besar yang tidak diurutkan sebagian.
  ```
- **Komentar Buruk**: Mengulang kode, usang, atau tidak relevan.
  ```dart
  // BAD: i++; // Tambah i dengan 1
  ```

---

### 5\. Ringkasan

**Comments** adalah alat vital dalam pengembangan perangkat lunak untuk meningkatkan keterbacaan, pemahaman, dan pemeliharaan kode. Dart menyediakan tiga jenis utama:

- `//` (Komentar Baris Tunggal): Untuk catatan cepat atau menonaktifkan kode sementara.
- `/* ... */` (Komentar Multi-Baris): Untuk blok penjelasan yang lebih panjang atau menonaktifkan beberapa baris kode.
- `///` atau `/** ... */` (Komentar Dokumentasi): Untuk mendokumentasikan API publik, mendukung Markdown, dan dapat digunakan oleh alat `dart doc` untuk menghasilkan dokumentasi profesional.

Gunakan komentar secara bijak untuk menjelaskan "mengapa" dan bukan hanya "apa" dari kode Anda, sehingga Anda dan rekan tim dapat memahami _codebase_ dengan lebih baik dan membangun aplikasi yang lebih tangguh.

<!-- ```dart
 //, /\* \*/, ///,
``` -->

## Mewarnai Komenar Dengan Ekstensi

Pada dasarnya, komentar tidak memiliki warna, namun kita bisa memberinya warna sesuai yang kita inginkan menggunakan extensi Batter Comment, anda bisa mendownloadnya [disini](https://marketplace.visualstudio.com/items?itemName=aaron-bond.better-comments "ke halaman extensi")

Untuk melihat bagaimana warna dari komentar bekerja, anda bisa masuk kedalam file yang sudah saya sediakan setelah anda menginstal extensinya, apabila ada komentar yang masih tidak memiliki warna itu artinya simbol dari kode komentar tersebut belum diatur

Untuk mengatur atau menambahkan variasi warna atau simbol lainnya, gunakan pengaturan berikut ini dan sesuaikan dengan kebutuhan Anda:

```java
 {
 "tag": [
 "&",
 ],
 "color": "#FF8C00",
 "strikethrough": false,
 "underline": false,
 "backgroundColor": "transparent",
 "bold": false,
 "italic": false,
 "multiline": true
 },
```

Ubah simbol "&" menjadi simbol lainnya, seperti simbol "@" atau simbol lainnya yang Anda inginkan. Sesuaikan juga nilai dari properti "color" dengan kode warna yang Anda inginkan atau hidukkan properti "multiline" menjadi "true" agar komentar bisa ditulis dalam beberapa baris.

- Klik untuk informasi lebih lanjut tentang [Better Comment](https://marketplace.visualstudio.com/items?itemName=aaron-bond.better-comments "marketplace.visualstudio.com")

- Klik untuk informasi lebih lanjut tentang [komentar di Dart](https://dart.dev/guides/language/language-tour#comments "dart.dev")

<!--

# Sintaks Pewarnaan

Dalam penjelasan disini komentar tidak akan memiliki warna karena itu hanya berlaku di kompailer Dart

````dart
/// Berikut adalah contoh komentar berwarna yang dihasilkan oleh eksistensi Better Comment

// ! Berikan spasi setelah tanda seru (!) seperti bagaimana komentar ini ditulis agar komentar bisa berwarna, hal yang sama juga berlaku untuk tanda seru ganda (!!) dan tanda pagar (!#) yang akan menghasilkan komentar dengan warna yang berbeda, seperti contoh di bawah ini:

// ^endregion

 // Todo:

 // * Menggunakan simbol bintang (*)

 // ? Menggunakan simbol tanya (?)

 // ! Menggunakan simbol seru (!)

 // @ Menggunakan simbol at (@)

 // - Menggunakan simbol strip (-)

 // // Menggunakan simbol double slash (//)

 // # Menggunakan simbol pagar (#)

 // $ Menggunakan simbol dollar ($)

 // ^ Menggunakan simbol caret (^)

 // & Menggunakan simbol ampersand (&)

  // ignore: dangling_library_doc_comments
/**-
   ^Untuk menambahkan variasi warna atau simbol lainnya, gunakan pereaturan berikut ini dan sesuaikan dengan kebutuhan Anda:

   ^     {
   ^         "tag": [
   ^             "&",
   ^         ],
   ^         "color": "#FF8C00",
   ^         "strikethrough": false,
   ^         "underline": false,
   ^         "backgroundColor": "transparent",
   ^         "bold": false,
   ^         "italic": false,
   ^         "multiline": true
   ^     },
*/
/*
    ^ Ubah simbol "&" menjadi simbol lainnya, seperti simbol "@" atau simbol lainnya yang Anda inginkan. Sesuaikan juga nilai dari properti "color" dengan kode warna yang Anda inginkan atau hidukkan properti "multiline" menjadi "true" agar komentar bisa ditulis dalam beberapa baris.

    $ Untuk informasi lebih lanjut tentang Better Comment, silahkan kunjungi: https://marketplace.visualstudio.com/items?itemName=aaron-bond.better-comments

    $ Untuk informasi lebih lanjut tentang Dart, silahkan kunjungi: https://dart.dev/

    $ Untuk informasi lebih lanjut tentang Dart SDK, silahkan kunjungi: https://dart.dev/tools/sdk

    $ Untuk informasi lebih lanjut tentang DartPad, silahkan kunjungi: https://dartpad.dev/

    $ Untuk informasi lebih lanjut tentang komentar di Dart, silahkan kunjungi: https://dart.dev/guides/language/language-tour#comments

*/
``` -->

[0]: ../../materi/modul-2/README.md
