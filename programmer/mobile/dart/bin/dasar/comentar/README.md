# Komentar

Komentar adalah bagian dari kode yang tidak akan dijalankan oleh program, komentar hanya berfungsi sebagai penanda atau catatan yang bisa membantu programmer dalam memahami kode yang ditulisnya, komentar tidak akan mempengaruhi hasil dari program yang kita buat, komentar hanya akan dilihat oleh programmer yang membuatnya, komentar bisa berupa teks atau kode yang diawali dengan simbol tertentu, di Dart, komentar bisa ditulis dengan beberapa cara, yaitu:

```dart
 //, /\* \*/, ///, //! dan !!
```

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

> Klik untuk informasi lebih lanjut tentang [Better Comment](https://marketplace.visualstudio.com/items?itemName=aaron-bond.better-comments "marketplace.visualstudio.com")

> Klik untuk informasi lebih lanjut tentang [komentar di Dart](https://dart.dev/guides/language/language-tour#comments "dart.dev")

# Kode Saya

```dart
// # Komentar adalah bagian dari kode yang tidak akan dijalankan oleh program, komentar hanya berfungsi sebagai penanda atau catatan yang bisa membantu programmer dalam memahami kode yang ditulisnya, komentar tidak akan mempengaruhi hasil dari program yang kita buat, komentar hanya akan dilihat oleh programmer yang membuatnya, komentar bisa berupa teks atau kode yang diawali dengan simbol tertentu, di Dart, komentar bisa ditulis dengan beberapa cara, yaitu: //, /* */, ///, //! dan !!

// ignore: dangling_library_doc_comments
/// Berikut adalah contoh komentar berwarna yang dihasilkan oleh eksistensi Better Comment

// ! Berikan spasi setelah tanda seru (!) agar komentar bisa berwarna, hal yang sama juga berlaku untuk tanda seru ganda (!!) dan tanda pagar (!#) yang akan menghasilkan komentar dengan warna yang berbeda, seperti contoh di bawah ini:

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
```
