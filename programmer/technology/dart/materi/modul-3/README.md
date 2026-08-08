# **[Modul 3: Operator & Ekspresi][0]**

Modul ini berfokus pada **Operator dan Ekspresi** dalam Dart. Bayangkan operator sebagai 'kata kerja' dalam bahasa pemrograman. Mereka melakukan tindakan atau perhitungan tertentu pada 'kata benda' atau 'nilai' yang kita sebut **operand**. Sedangkan **ekspresi** adalah kombinasi dari operator dan operand yang menghasilkan sebuah nilai. Mirip seperti sebuah kalimat matematika sederhana, $2 + 3$, di mana $2$ dan $3$ adalah operand, dan $+$ adalah operator, hasilnya adalah $5$.

Mari kita telaah satu per satu, dengan penjelasan dan contoh kode yang bisa Anda coba langsung di [DartPad](https://dartpad.dev/).

---

### 038\. Operator Aritmatika (Arithmetic Operators)

Operator aritmatika adalah operator yang kita gunakan untuk melakukan perhitungan matematika dasar seperti penjumlahan, pengurangan, perkalian, dan pembagian. Ini adalah operator yang paling sering Anda temui dalam kehidupan sehari-hari.

| Operator | Deskripsi       | Contoh                          | Hasil    |
| :------- | :-------------- | :------------------------------ | :------- |
| `+`      | Penjumlahan     | `5 + 3`                         | `8`      |
| `-`      | Pengurangan     | `5 - 3`                         | `2`      |
| `*`      | Perkalian       | `5 * 3`                         | `15`     |
| `/`      | Pembagian       | `5 / 3` (hasil desimal)         | `1.66..` |
| `~/`     | Pembagian Bulat | `5 ~/ 3` (hasil bilangan bulat) | `1`      |
| `%`      | Sisa Pembagian  | `5 % 3`                         | `2`      |

**Contoh Kode:**

```dart
void main() {
  int angka1 = 10; // Mendeklarasikan variabel 'angka1' dengan nilai 10
  int angka2 = 3;  // Mendeklarasikan variabel 'angka2' dengan nilai 3

  // Penjumlahan
  print('Penjumlahan: ${angka1 + angka2}'); // Output: Penjumlahan: 13
  //  ^ Keyword untuk mencetak ke konsol.
  //          ^ String literal (teks biasa).
  //                       ^ Interpolasi string: nilai variabel atau ekspresi diapit ${}.
  //                           ^ Operator penjumlahan.

  // Pengurangan
  print('Pengurangan: ${angka1 - angka2}'); // Output: Pengurangan: 7
  //                           ^ Operator pengurangan.

  // Perkalian
  print('Perkalian: ${angka1 * angka2}'); // Output: Perkalian: 30
  //                           ^ Operator perkalian.

  // Pembagian (hasil desimal/double)
  print('Pembagian (desimal): ${angka1 / angka2}'); // Output: Pembagian (desimal): 3.3333333333333335
  //                             ^ Operator pembagian.

  // Pembagian Bulat (hasil integer)
  print('Pembagian bulat: ${angka1 ~/ angka2}'); // Output: Pembagian bulat: 3
  //                             ^ Operator pembagian bulat (integer division).

  // Sisa Pembagian (Modulo)
  print('Sisa pembagian: ${angka1 % angka2}'); // Output: Sisa pembagian: 1
  //                             ^ Operator modulo.

  // Contoh lain: increment dan decrement
  int counter = 0; // Inisialisasi 'counter' dengan 0
  counter++; // Increment (menambah 1), sekarang counter = 1
  print('Counter setelah increment: $counter'); // Output: Counter setelah increment: 1
  // ^ Operator increment.

  counter--; // Decrement (mengurangi 1), sekarang counter = 0
  print('Counter setelah decrement: $counter'); // Output: Counter setelah decrement: 0
  // ^ Operator decrement.
}
```

**Penjelasan Singkat:**
Sama seperti Anda menghitung harga kurma atau jumlah dinar, operator ini membantu komputer melakukan perhitungan dasar.

---

### 039\. Operator Kesamaan/Relasional (Equality/Relational Operators)

Operator ini digunakan untuk membandingkan dua nilai dan menghasilkan nilai boolean (`true` atau `false`). Nilai `true` berarti "benar" atau "ya", dan `false` berarti "salah" atau "tidak". Mirip seperti Anda membandingkan apakah dua naskah kuno itu sama atau tidak.

| Operator | Deskripsi                         | Contoh   | Hasil   |
| :------- | :-------------------------------- | :------- | :------ |
| `==`     | Sama dengan                       | `5 == 5` | `true`  |
| `!=`     | Tidak sama dengan                 | `5 != 3` | `true`  |
| `>`      | Lebih besar dari                  | `5 > 3`  | `true`  |
| `<`      | Lebih kecil dari                  | `5 < 3`  | `false` |
| `>=`     | Lebih besar dari atau sama dengan | `5 >= 5` | `true`  |
| `<=`     | Lebih kecil dari atau sama dengan | `5 <= 3` | `false` |

**Contoh Kode:**

```dart
void main() {
  int nilaiA = 10; // Variabel 'nilaiA' dengan nilai 10
  int nilaiB = 20; // Variabel 'nilaiB' dengan nilai 20
  int nilaiC = 10; // Variabel 'nilaiC' dengan nilai 10

  // Sama dengan (Equality)
  print('Apakah nilaiA sama dengan nilaiB? ${nilaiA == nilaiB}'); // Output: false
  //                                          ^ Operator sama dengan.
  print('Apakah nilaiA sama dengan nilaiC? ${nilaiA == nilaiC}'); // Output: true

  // Tidak sama dengan (Inequality)
  print('Apakah nilaiA tidak sama dengan nilaiB? ${nilaiA != nilaiB}'); // Output: true
  //                                                 ^ Operator tidak sama dengan.

  // Lebih besar dari (Greater than)
  print('Apakah nilaiA lebih besar dari nilaiB? ${nilaiA > nilaiB}'); // Output: false
  //                                                ^ Operator lebih besar dari.

  // Lebih kecil dari (Less than)
  print('Apakah nilaiA lebih kecil dari nilaiB? ${nilaiA < nilaiB}'); // Output: true
  //                                                ^ Operator lebih kecil dari.

  // Lebih besar dari atau sama dengan (Greater than or equal to)
  print('Apakah nilaiA lebih besar dari atau sama dengan nilaiC? ${nilaiA >= nilaiC}'); // Output: true
  //                                                                 ^ Operator lebih besar dari atau sama dengan.

  // Lebih kecil dari atau sama dengan (Less than or equal to)
  print('Apakah nilaiB lebih kecil dari atau sama dengan nilaiA? ${nilaiB <= nilaiA}'); // Output: false
  //                                                                 ^ Operator lebih kecil dari atau sama dengan.
}
```

**Penjelasan Singkat:**
Ini seperti hakim yang memutuskan apakah dua argumen itu setara, atau apakah satu lebih besar dari yang lain. Hasilnya selalu 'benar' atau 'salah'.

---

### 040\. Operator Logika (Logical Operators)

Operator logika digunakan untuk menggabungkan atau membalikkan ekspresi boolean (hasil `true` atau `false`). Ini penting untuk membuat keputusan yang lebih kompleks dalam program. Ibaratnya, Anda ingin memeriksa apakah seseorang adalah seorang muslim DAN seorang pelajar IT mandiri.

| Operator | Deskripsi   | Contoh            | Hasil   |
| :------- | :---------- | :---------------- | :------ |
| `&&`     | DAN (AND)   | `true && false`   | `false` |
| `\|\|`   | ATAU (OR)   | `true \|\| false` | `true`  |
| `!`      | BUKAN (NOT) | `!true`           | `false` |

**Contoh Kode:**

```dart
void main() {
  bool hujan = true;    // Variabel 'hujan' bernilai true
  bool lapar = false;   // Variabel 'lapar' bernilai false
  bool senang = true;   // Variabel 'senang' bernilai true

  // Operator DAN (&&)
  // Akan menghasilkan true jika kedua kondisi BENAR (true).
  print('Hujan DAN Lapar? ${hujan && lapar}'); // Output: false (karena lapar = false)
  //                                ^ Operator AND.

  // Operator ATAU (||)
  // Akan menghasilkan true jika salah satu kondisi BENAR (true).
  print('Hujan ATAU Lapar? ${hujan || lapar}'); // Output: true (karena hujan = true)
  //                                ^ Operator OR.

  // Operator BUKAN (!)
  // Membalik nilai boolean. Jika true menjadi false, jika false menjadi true.
  print('TIDAK Hujan? ${!hujan}'); // Output: false (karena hujan awalnya true)
  //                    ^ Operator NOT.

  // Kombinasi
  print('Lapar DAN TIDAK Senang? ${lapar && !senang}'); // Output: false
  //             ^ Operator AND.  ^ Operator NOT.
  // (lapar = false, !senang = false, maka false && false = false)
}
```

**Penjelasan Singkat:**
Mirip seperti logika dalam debat atau pengambilan keputusan: "apakah A benar DAN B benar?" atau "apakah A benar ATAU B benar?".

---

### 041\. Operator Penugasan (Assignment Operators)

Operator penugasan digunakan untuk memberikan nilai kepada variabel. Operator dasar adalah `=`, tetapi ada juga bentuk singkat yang menggabungkan operasi aritmatika atau logika dengan penugasan.

| Operator | Deskripsi                    | Contoh    | Setara dengan |
| :------- | :--------------------------- | :-------- | :------------ |
| `=`      | Menetapkan nilai             | `x = 5`   |               |
| `+=`     | Menambah dan menetapkan      | `x += 2`  | `x = x + 2`   |
| `-=`     | Mengurangi dan menetapkan    | `x -= 2`  | `x = x - 2`   |
| `*=`     | Mengalikan dan menetapkan    | `x *= 2`  | `x = x * 2`   |
| `/=`     | Membagi dan menetapkan       | `x /= 2`  | `x = x / 2`   |
| `~/=`    | Membagi bulat dan menetapkan | `x ~/= 2` | `x = x ~/ 2`  |
| `%=`     | Modulo dan menetapkan        | `x %= 2`  | `x = x % 2`   |

**Contoh Kode:**

```dart
void main() {
  int skor = 100; // Inisialisasi 'skor' dengan 100

  // Operator Penugasan Dasar (=)
  int nilaiBaru = skor; // Menetapkan nilai 'skor' ke 'nilaiBaru'
  print('Nilai Baru: $nilaiBaru'); // Output: Nilai Baru: 100
  //                ^ Operator penugasan dasar.

  // Operator Penugasan dengan Penjumlahan (+=)
  skor += 50; // Setara dengan skor = skor + 50;
  print('Skor setelah ditambah: $skor'); // Output: Skor setelah ditambah: 150
  //      ^ Operator penugasan dengan penjumlahan.

  // Operator Penugasan dengan Pengurangan (-=)
  skor -= 20; // Setara dengan skor = skor - 20;
  print('Skor setelah dikurangi: $skor'); // Output: Skor setelah dikurangi: 130
  //      ^ Operator penugasan dengan pengurangan.

  // Operator Penugasan dengan Perkalian (*=)
  skor *= 2; // Setara dengan skor = skor * 2;
  print('Skor setelah dikali: $skor'); // Output: Skor setelah dikali: 260
  //      ^ Operator penugasan dengan perkalian.

  // Operator Penugasan dengan Pembagian (/=)
  double harga = 100.0;
  harga /= 4; // Setara dengan harga = harga / 4;
  print('Harga setelah dibagi: $harga'); // Output: Harga setelah dibagi: 25.0
  //      ^ Operator penugasan dengan pembagian.

  // Operator Penugasan dengan Pembagian Bulat (~/=)
  int koin = 100;
  koin ~/= 3; // Setara dengan koin = koin ~/ 3;
  print('Koin setelah dibagi bulat: $koin'); // Output: Koin setelah dibagi bulat: 33
  //      ^ Operator penugasan dengan pembagian bulat.

  // Operator Penugasan dengan Modulo (%=)
  int sisa = 17;
  sisa %= 5; // Setara dengan sisa = sisa % 5;
  print('Sisa setelah modulo: $sisa'); // Output: Sisa setelah modulo: 2
  //      ^ Operator penugasan dengan modulo.
}
```

**Penjelasan Singkat:**
Ini seperti Anda menyimpan hasil perhitungan ke dalam sebuah wadah. Misalnya, "total hutang adalah total hutang yang sekarang ditambah bunga".

---

### 042\. Ekspresi Kondisional (Conditional Expressions)

Ekspresi kondisional memungkinkan Anda memilih salah satu dari dua nilai berdasarkan suatu kondisi. Ini sangat ringkas untuk situasi `if-else` sederhana.

Ada dua jenis:

1.  **Operator Ternary (`kondisi ? nilai1 : nilai2`)**: Jika `kondisi` `true`, hasilnya adalah `nilai1`. Jika `false`, hasilnya adalah `nilai2`.
2.  **Null-aware `??` (untuk nilai default)**: Ini akan dibahas lebih detail di operator null-aware, tapi intinya adalah memberikan nilai default jika variabel bernilai `null`.

**Contoh Kode:**

```dart
void main() {
  int usia = 18; // Variabel 'usia' dengan nilai 18
  String status;   // Variabel 'status' (akan diisi nanti)

  // Operator Ternary (?:)
  // Sintaks: kondisi ? nilai_jika_true : nilai_jika_false;
  status = (usia >= 17) ? 'Dewasa' : 'Anak-anak';
  //         ^ Kondisi.
  //                       ^ Nilai jika kondisi true.
  //                                       ^ Nilai jika kondisi false.
  print('Status usia: $status'); // Output: Status usia: Dewasa

  // Contoh lain: Memeriksa kelulusan
  int nilaiUjian = 75;
  String hasil = (nilaiUjian >= 70) ? 'Lulus' : 'Tidak Lulus';
  print('Hasil ujian: $hasil'); // Output: Hasil ujian: Lulus

  // Kondisi dengan operator logika
  bool punyaUang = true;
  bool punyaWaktu = false;
  String pergiJalan = (punyaUang && punyaWaktu) ? 'Ayo jalan-jalan!' : 'Tetap di rumah.';
  print(pergiJalan); // Output: Tetap di rumah.
}
```

**Penjelasan Singkat:**
Ini adalah cara cepat untuk mengatakan, "Jika ini benar, lakukan A; jika tidak, lakukan B." Contoh klasik adalah: "Jika seseorang sudah baligh, maka dia dewasa, jika tidak, dia anak-anak."

---

### 043\. Notasi Berantai (Cascade Notation)

Notasi berantai (`..`) memungkinkan Anda melakukan serangkaian operasi pada objek yang sama tanpa perlu berulang kali menyebutkan nama objeknya. Ini membuat kode lebih ringkas dan mudah dibaca, terutama saat Anda ingin mengatur banyak properti atau memanggil beberapa metode pada satu objek. Mirip seperti Anda menuliskan daftar sifat-sifat seorang ilmuwan di selembar kertas, tanpa perlu menulis nama ilmuwan itu berulang-ulang di setiap baris.

**Contoh Kode:**

```dart
class Mahasiswa { // Mendefinisikan sebuah kelas bernama 'Mahasiswa'
  String? nama;    // Properti 'nama'
  int? usia;       // Properti 'usia'
  String? jurusan; // Properti 'jurusan'

  // Metode untuk mencetak detail mahasiswa
  void cetakDetail() {
    print('Nama: $nama, Usia: $usia, Jurusan: $jurusan');
  }
}

void main() {
  // Tanpa Cascade Notation
  var mhs1 = Mahasiswa(); // Membuat objek Mahasiswa
  mhs1.nama = 'Ali';
  mhs1.usia = 20;
  mhs1.jurusan = 'Ilmu Komputer';
  mhs1.cetakDetail(); // Output: Nama: Ali, Usia: 20, Jurusan: Ilmu Komputer

  print('---'); // Pemisah

  // Dengan Cascade Notation (..)
  var mhs2 = Mahasiswa() // Membuat objek Mahasiswa
    ..nama = 'Fatimah'     // Mengatur properti 'nama'
    ..usia = 22           // Mengatur properti 'usia'
    ..jurusan = 'Matematika' // Mengatur properti 'jurusan'
    ..cetakDetail();      // Memanggil metode 'cetakDetail'
  // ^ Operator Cascade. Perhatikan bahwa ini dimulai setelah objek dibuat.
  // Ini mengembalikan objek itu sendiri, memungkinkan Anda untuk "merangkai" panggilan.

  // Output: Nama: Fatimah, Usia: 22, Jurusan: Matematika
}
```

**Penjelasan Singkat:**
Bayangkan Anda sedang melukis. Daripada terus-menerus menulis `cat.aturWarna(hitam); cat.aturTebal(5.0); cat.aturGaya(stroke);`, Anda bisa menulis `cat..aturWarna(hitam)..aturTebal(5.0)..aturGaya(stroke);`. Lebih ringkas, bukan?

---

### 044\. Operator Sadar `null` (Null-aware Operators)

Dalam Dart, ada konsep **Null Safety**, yang berarti variabel harus berisi nilai (tidak boleh `null`) kecuali jika Anda secara eksplisit mengizinkannya untuk bernilai `null` dengan menambahkan `?` setelah tipe data. Operator sadar `null` adalah cara untuk menangani potensi nilai `null` dengan aman dan ringkas. Ini seperti memastikan sebuah wadah tidak kosong sebelum Anda mengambil isinya.

| Operator | Deskripsi                                                                           | Contoh               |
| :------- | :---------------------------------------------------------------------------------- | :------------------- |
| `??`     | Jika ekspresi kiri non-null, gunakan nilai itu; jika tidak, gunakan ekspresi kanan. | `a ?? b`             |
| `??=`    | Tetapkan nilai jika variabel saat ini `null`.                                       | `variabel ??= nilai` |
| `?.`     | Panggilan anggota dengan aman jika bukan `null`.                                    | `objek?.properti`    |
| `!`      | Mengklaim bahwa suatu ekspresi tidak `null`.                                        | `objek!.properti`    |

**Contoh Kode:**

```dart
void main() {
  String? namaPengguna; // Mendeklarasikan variabel 'namaPengguna' yang bisa bernilai null.
  //       ^ Tanda tanya menunjukkan bahwa variabel ini BISA bernilai null (null safety).

  // 1. Operator Null Coalescing (??)
  // Memberikan nilai default jika variabel di sebelah kiri adalah null.
  String namaTampilan = namaPengguna ?? 'Tamu';
  //                     ^ Jika 'namaPengguna' null, gunakan 'Tamu'.
  print('Nama tampilan (awal): $namaTampilan'); // Output: Nama tampilan (awal): Tamu

  namaPengguna = 'Ahmad'; // Sekarang 'namaPengguna' memiliki nilai
  namaTampilan = namaPengguna ?? 'Tamu';
  print('Nama tampilan (setelah diisi): $namaTampilan'); // Output: Nama tampilan (setelah diisi): Ahmad

  print('---');

  // 2. Operator Null Coalescing Assignment (??=)
  // Menetapkan nilai ke variabel HANYA JIKA variabel itu saat ini null.
  int? jumlahPesanan;
  jumlahPesanan ??= 1; // Jika jumlahPesanan null, tetapkan 1.
  print('Jumlah pesanan (pertama): $jumlahPesanan'); // Output: Jumlah pesanan (pertama): 1

  jumlahPesanan ??= 5; // Sekarang jumlahPesanan sudah 1, jadi tidak akan berubah menjadi 5.
  print('Jumlah pesanan (kedua): $jumlahPesanan'); // Output: Jumlah pesanan (kedua): 1

  print('---');

  // 3. Operator Safe Navigation (?. )
  // Memanggil metode atau mengakses properti hanya jika objek bukan null.
  // Jika objek null, seluruh ekspresi akan menghasilkan null.
  String? kalimat; // Variabel string yang bisa null

  // Mencoba mendapatkan panjang kalimat. Jika kalimat null, hasilnya null, bukan error.
  print('Panjang kalimat (null): ${kalimat?.length}'); // Output: Panjang kalimat (null): null
  //                                       ^ Jika 'kalimat' null, ini mengembalikan null.

  kalimat = 'Bismillah';
  print('Panjang kalimat (ada nilai): ${kalimat?.length}'); // Output: Panjang kalimat (ada nilai): 9
  //                                       ^ Sekarang kalimat tidak null, jadi .length dipanggil.

  print('---');

  // 4. Operator Null Assertion (!)
  // Memberitahu Dart bahwa Anda YAKIN ekspresi ini tidak akan null, meskipun tipenya nullable.
  // Gunakan dengan hati-hati! Jika ternyata null, akan ada error (runtime error).
  String? kotaAsal; // Variabel yang bisa null

  // kotaAsal!.length; // Ini akan menghasilkan error karena kotaAsal masih null.

  kotaAsal = 'Makkah'; // Sekarang kotaAsal sudah memiliki nilai
  print('Panjang kota asal: ${kotaAsal!.length}'); // Output: Panjang kota asal: 6
  //                                     ^ Anda mengklaim bahwa kotaAsal tidak null di sini.
  //                                       Jika null, ini akan crash.
}
```

**Penjelasan Singkat:**
Ini adalah penjaga pintu yang cerdas. Dia akan memeriksa apakah ada orang di balik pintu sebelum dia membukanya. Jika tidak ada, dia akan memberikan respons default atau tidak melakukan apa-apa daripada menyebabkan masalah. `!` adalah Anda yang sangat yakin bahwa ada orang di balik pintu dan memaksa pintu dibuka.

---

### 045\. Operator Uji Tipe (Type Test Operators)

Operator uji tipe digunakan untuk memeriksa tipe suatu objek saat runtime (saat program berjalan). Ini berguna untuk memastikan bahwa Anda bekerja dengan tipe data yang benar sebelum melakukan operasi tertentu, mirip seperti Anda memeriksa apakah sebuah buku adalah manuskrip medis atau sejarah sebelum Anda mencoba membacanya sebagai salah satu dari keduanya.

| Operator | Deskripsi                                                            | Contoh            |
| :------- | :------------------------------------------------------------------- | :---------------- |
| `is`     | Mengembalikan `true` jika objek memiliki tipe yang ditentukan.       | `objek is String` |
| `is!`    | Mengembalikan `true` jika objek TIDAK memiliki tipe yang ditentukan. | `objek is! int`   |
| `as`     | Mengubah (casting) objek ke tipe data tertentu.                      | `objek as String` |

**Contoh Kode:**

```dart
class Hewan {
  void bersuara() {
    print('Suara hewan');
  }
}

class Kucing extends Hewan { // Kucing adalah jenis Hewan
  @override
  void bersuara() {
    print('Meong!');
  }

  void mencakar() {
    print('Mencakar...');
  }
}

class Anjing extends Hewan { // Anjing adalah jenis Hewan
  @override
  void bersuara() {
    print('Guk Guk!');
  }

  void menggonggong() {
    print('Menggonggong...');
  }
}

void main() {
  dynamic myObject = Kucing(); // 'myObject' bisa menampung tipe apapun
  // ^ 'dynamic' berarti tipe dapat berubah saat runtime.
  //   Gunakan dengan hati-hati karena mengurangi null safety dan pemeriksaan tipe saat kompilasi.

  // 1. Operator 'is'
  // Memeriksa apakah 'myObject' adalah instance dari tipe 'Kucing'.
  if (myObject is Kucing) {
    print('myObject adalah Kucing!'); // Output: myObject adalah Kucing!
    (myObject as Kucing).mencakar(); // Menggunakan 'as' untuk cast dan memanggil method khusus Kucing.
    // ^ Casting: memberitahu Dart bahwa myObject sekarang dianggap sebagai Kucing.
    // Ini memungkinkan akses ke metode atau properti yang hanya ada di tipe Kucing.
  }
  // else if (myObject is Anjing) { // Contoh lain jika myObject adalah Anjing
  //   print('myObject adalah Anjing!');
  // }

  print('---');

  // 2. Operator 'is!'
  // Memeriksa apakah 'myObject' BUKAN instance dari tipe 'Anjing'.
  if (myObject is! Anjing) {
    print('myObject BUKAN Anjing!'); // Output: myObject BUKAN Anjing!
  }

  print('---');

  // 3. Operator 'as' (Type Cast)
  // Mengubah tipe data objek secara eksplisit.
  // HATI-HATI: Jika cast tidak valid (misal, mencoba meng-cast Kucing ke String),
  // akan terjadi error saat runtime!
  Hewan hewanSaya = Anjing(); // Membuat objek Anjing, tetapi disimpan sebagai tipe Hewan.
  // Karena Anjing adalah Hewan, ini legal.

  // Jika ingin memanggil method 'menggonggong' (yang hanya ada di Anjing),
  // harus di-cast dulu ke Anjing.
  (hewanSaya as Anjing).menggonggong(); // Output: Menggonggong...
  // ^ Memberitahu Dart bahwa 'hewanSaya' (yang bertipe Hewan) sebenarnya adalah 'Anjing'.
  //   Jika 'hewanSaya' bukan Anjing, ini akan menyebabkan error.

  // Contoh cast yang akan error jika dijalankan (karena Kucing bukan String)
  // String namaHewan = myObject as String; // Ini akan error!
}
```

**Penjelasan Singkat:**
Ini seperti Anda adalah seorang pustakawan yang memverifikasi jenis buku. Anda bisa berkata, "Apakah buku ini 'adalah' buku sejarah?" atau "Buku ini 'bukanlah' buku sains." Dan jika Anda yakin, Anda bisa memperlakukannya 'sebagai' buku puisi.

---

### 046\. Operator Bitwise (Bitwise Operators)

Operator bitwise bekerja pada representasi biner dari angka. Mereka memanipulasi bit individual (0 dan 1) dari bilangan bulat. Ini lebih sering digunakan dalam pemrograman tingkat rendah, seperti sistem tertanam atau kriptografi, tetapi penting untuk diketahui. Ibaratnya, ini seperti Anda bekerja dengan huruf hijaiyah satu per satu, bukan kata utuh.

| Operator | Deskripsi                    | Contoh   |
| :------- | :--------------------------- | :------- |
| `&`      | Bitwise AND                  | `a & b`  |
| `\|`     | Bitwise OR                   | `a \| b` |
| `^`      | Bitwise XOR                  | `a ^ b`  |
| `~`      | Bitwise NOT (pelengkap satu) | `~a`     |
| `<<`     | Shift Kiri                   | `a << n` |
| `>>`     | Shift Kanan                  | `a >> n` |

**Contoh Kode:**

```dart
void main() {
  int a = 5;  // Representasi biner: 0101
  int b = 3;  // Representasi biner: 0011

  // 1. Bitwise AND (&)
  // Membandingkan bit per bit. Jika kedua bit 1, hasilnya 1.
  //   0101 (5)
  // & 0011 (3)
  // ------
  //   0001 (1)
  print('a & b: ${a & b}'); // Output: 1

  // 2. Bitwise OR (|)
  // Membandingkan bit per bit. Jika salah satu bit 1, hasilnya 1.
  //   0101 (5)
  // | 0011 (3)
  // ------
  //   0111 (7)
  print('a | b: ${a | b}'); // Output: 7

  // 3. Bitwise XOR (^)
  // Membandingkan bit per bit. Jika bitnya berbeda, hasilnya 1.
  //   0101 (5)
  // ^ 0011 (3)
  // ------
  //   0110 (6)
  print('a ^ b: ${a ^ b}'); // Output: 6

  // 4. Bitwise NOT (~)
  // Membalikkan semua bit. Contoh untuk 32-bit integer:
  // ~0000 0000 0000 0000 0000 0000 0000 0101 (5)
  // menjadi
  // 1111 1111 1111 1111 1111 1111 1111 1010 (-6) dalam representasi two's complement
  print('~a: ${~a}'); // Output: -6 (tergantung representasi integer)

  // 5. Shift Kiri (<<)
  // Menggeser bit ke kiri sejumlah posisi. Mengisi dengan 0 di kanan.
  // Ini setara dengan mengalikan dengan 2 pangkat n.
  // 0101 (5) << 1 -> 1010 (10)
  // 0101 (5) << 2 -> 010100 (20)
  print('a << 1: ${a << 1}'); // Output: 10 (5 * 2^1)
  print('a << 2: ${a << 2}'); // Output: 20 (5 * 2^2)

  // 6. Shift Kanan (>>)
  // Menggeser bit ke kanan sejumlah posisi. Mengisi dengan 0 atau bit tanda di kiri.
  // Ini setara dengan pembagian bulat dengan 2 pangkat n.
  // 0101 (5) >> 1 -> 0010 (2)
  // 0101 (5) >> 2 -> 0001 (1)
  print('a >> 1: ${a >> 1}'); // Output: 2 (5 ~/ 2^1)
  print('a >> 2: ${a >> 2}'); // Output: 1 (5 ~/ 2^2)
}
```

**Penjelasan Singkat:**
Ini adalah operasi yang sangat mendasar, berinteraksi langsung dengan "bahasa" komputer (angka biner). Mirip seperti seorang ahli kaligrafi yang memahami setiap guratan huruf secara terpisah.

---

### 047\. Urutan Operator (Operator Precedence)

Urutan operator menentukan urutan di mana operator dalam ekspresi dievaluasi. Sama seperti dalam matematika ada aturan "Kali Bagi Tambah Kurang" (pemdas/bodmas), dalam pemrograman juga ada urutan prioritas. Operator dengan prioritas lebih tinggi dievaluasi terlebih dahulu. Anda bisa menggunakan tanda kurung `()` untuk mengubah urutan evaluasi.

**Contoh Urutan Prioritas (dari tertinggi ke terendah, beberapa saja):**

1.  Panggilan fungsi/metode, akses anggota (`.`), `[]` (akses list/map), `++`, `--` (postfix)
2.  `!` (NOT), `~` (Bitwise NOT), `++`, `--` (prefix), `as`, `is`, `is!`
3.  `*`, `/`, `~/`, `%` (Perkalian, Pembagian, Modulo)
4.  `+`, `-` (Penjumlahan, Pengurangan)
5.  `<<`, `>>` (Shift Bitwise)
6.  `&` (Bitwise AND)
7.  `^` (Bitwise XOR)
8.  `|` (Bitwise OR)
9.  `>`, `>=`, `<`, `<=` (Relasional)
10. `==`, `!=` (Kesamaan)
11. `&&` (Logika AND)
12. `||` (Logika OR)
13. `??` (Null Coalescing)
14. `?:` (Ternary Conditional)
15. `=`, `*=`, `+=`, dll. (Penugasan)

**Contoh Kode:**

```dart
void main() {
  // Contoh tanpa tanda kurung:
  // Dart akan mengevaluasi perkalian dan pembagian terlebih dahulu
  // sebelum penjumlahan dan pengurangan.
  // (10 * 2) + (5 / 2)
  double hasil1 = 10 + 2 * 5 / 2; // 10 + (2*5) / 2 = 10 + 10 / 2 = 10 + 5 = 15.0
  print('Hasil 1: $hasil1'); // Output: Hasil 1: 15.0

  // Contoh dengan tanda kurung untuk mengubah urutan:
  // Penjumlahan dalam kurung dievaluasi terlebih dahulu.
  // (10 + 2) * 5 / 2 = 12 * 5 / 2 = 60 / 2 = 30.0
  double hasil2 = (10 + 2) * 5 / 2;
  print('Hasil 2: $hasil2'); // Output: Hasil 2: 30.0

  // Contoh dengan operator logika dan relasional
  int a = 5;
  int b = 10;
  int c = 15;

  // Evaluasi: (a < b) && (b < c)
  // (5 < 10) -> true
  // (10 < 15) -> true
  // true && true -> true
  bool kondisi1 = a < b && b < c;
  print('Kondisi 1: $kondisi1'); // Output: Kondisi 1: true

  // Evaluasi: (a > b) || (b == c - 5)
  // (a > b) -> (5 > 10) -> false
  // (b == c - 5) -> (10 == 15 - 5) -> (10 == 10) -> true
  // false || true -> true
  bool kondisi2 = a > b || b == c - 5;
  print('Kondisi 2: $kondisi2'); // Output: Kondisi 2: true

  // Contoh dengan penugasan dan aritmatika
  int x = 10;
  x += 5 * 2; // Evaluasi: x += (5 * 2) -> x += 10 -> x = x + 10 -> x = 10 + 10 = 20
  print('Nilai x: $x'); // Output: Nilai x: 20
}
```

**Penjelasan Singkat:**
Ini seperti tata bahasa dalam bahasa Arab, di mana beberapa harakat memiliki prioritas lebih tinggi dalam mengubah makna suatu kata. Atau dalam matematika, perkalian dan pembagian selalu didahulukan dari penjumlahan dan pengurangan.

---

### 048\. Pembebanan Operator (Operator Overloading)

**Pembebanan operator** adalah kemampuan untuk mendefinisikan ulang atau memberikan perilaku khusus pada operator yang ada (seperti `+`, `-`, `*`, `==`) untuk tipe data yang Anda buat sendiri (kelas). Dengan kata lain, Anda bisa membuat operator `+` bekerja tidak hanya untuk angka, tetapi juga untuk objek `Buku`, misalnya untuk menggabungkan dua buku.

Namun, penting untuk dicatat bahwa **Dart tidak mendukung pembebanan operator secara bebas seperti di beberapa bahasa lain (misalnya C++)**. Dart hanya mengizinkan Anda untuk membebani (overload) **sekumpulan operator yang sudah ditentukan** untuk objek kustom Anda. Operator ini biasanya adalah operator aritmatika, perbandingan, dan beberapa operator lain. Ini untuk menjaga kode tetap konsisten dan mudah diprediksi.

**Contoh Kode:**

```dart
class Vector { // Mendefinisikan kelas Vector
  final int x; // Properti x
  final int y; // Properti y

  const Vector(this.x, this.y); // Constructor untuk inisialisasi x dan y

  // Membebani operator '+' (Operator Overloading for addition)
  // Ini memungkinkan kita menambahkan dua objek Vector menggunakan operator '+'
  Vector operator +(Vector other) {
    // 'other' adalah Vector kedua yang akan ditambahkan.
    // Mengembalikan Vector baru dengan x dan y yang sudah dijumlahkan.
    return Vector(x + other.x, y + other.y);
  }

  // Membebani operator '-' (Operator Overloading for subtraction)
  // Ini memungkinkan kita mengurangi dua objek Vector menggunakan operator '-'
  Vector operator -(Vector other) {
    return Vector(x - other.x, y - other.y);
  }

  // Membebani operator '==' (Operator Overloading for equality)
  // Ini memungkinkan kita membandingkan dua objek Vector menggunakan operator '=='
  // Kita juga perlu membebani hashCode agar objek bekerja dengan benar di Set atau Map.
  @override
  bool operator ==(Object other) {
    // Memastikan 'other' adalah objek Vector dan memiliki properti yang sama.
    return other is Vector && x == other.x && y == other.y;
  }

  @override
  int get hashCode => Object.hash(x, y); // Mendefinisikan hashCode untuk operator ==
}

void main() {
  final v1 = Vector(2, 3); // Membuat objek Vector v1
  final v2 = Vector(1, 4); // Membuat objek Vector v2

  // Menggunakan operator '+' yang sudah dibebani
  final v3 = v1 + v2;
  print('Hasil penjumlahan vector: (${v3.x}, ${v3.y})'); // Output: (3, 7)

  // Menggunakan operator '-' yang sudah dibebani
  final v4 = v1 - v2;
  print('Hasil pengurangan vector: (${v4.x}, ${v4.y})'); // Output: (1, -1)

  // Menggunakan operator '==' yang sudah dibebani
  final v5 = Vector(2, 3);
  print('Apakah v1 sama dengan v2? ${v1 == v2}'); // Output: false
  print('Apakah v1 sama dengan v5? ${v1 == v5}'); // Output: true
}
```

**Penjelasan Singkat:**
Bayangkan Anda memiliki sebuah tim sepak bola. Operator `+` yang biasanya berarti "tambah angka", Anda buat agar untuk tim sepak bola berarti "gabungkan dua tim menjadi satu tim baru". Anda mengubah makna operator untuk tipe data yang Anda buat sendiri.

---

### 049\. Evaluasi Ekspresi (Expression Evaluation)

Ekspresi adalah kombinasi dari nilai, variabel, operator, dan panggilan fungsi yang menghasilkan sebuah nilai. Hampir semua hal yang Anda tulis dalam Dart yang menghasilkan nilai adalah ekspresi. Saat Dart menjalankan kode, ia akan "mengevaluasi" ekspresi tersebut untuk mendapatkan hasilnya.

**Contoh Ekspresi:**

- `10 + 5` (menghasilkan `15`)
- `nama == 'Budi'` (menghasilkan `true` atau `false`)
- `hitungLuas(panjang, lebar)` (menghasilkan nilai luas)
- `a++` (menghasilkan nilai `a` sebelum diincrement, lalu mengincrement `a`)
- `'Halo ' + nama` (menghasilkan string `'Halo [nama]'`)

**Contoh Kode:**

```dart
void main() {
  // Ekspresi aritmatika
  int a = 7;
  int b = 3;
  int hasilJumlah = a + b; // Ekspresi 'a + b' dievaluasi menjadi 10
  print('Hasil jumlah: $hasilJumlah'); // Output: Hasil jumlah: 10

  // Ekspresi relasional
  bool lebihBesar = a > b; // Ekspresi 'a > b' dievaluasi menjadi true
  print('Apakah a lebih besar dari b? $lebihBesar'); // Output: Apakah a lebih besar dari b? true

  // Ekspresi penugasan
  int x = 10;
  x *= 2; // Ekspresi 'x *= 2' dievaluasi dan mengubah nilai x menjadi 20
  print('Nilai x setelah dikalikan: $x'); // Output: Nilai x setelah dikalikan: 20

  // Ekspresi kondisional (ternary operator)
  String status = (x > 15) ? 'Besar' : 'Kecil'; // Ekspresi (x > 15) dievaluasi, lalu memilih string
  print('Status x: $status'); // Output: Status x: Besar

  // Ekspresi panggilan fungsi/metode
  // Asumsikan ada fungsi ini:
  // int kuadrat(int angka) {
  //   return angka * angka;
  // }
  // int hasilKuadrat = kuadrat(5); // Ekspresi 'kuadrat(5)' dievaluasi menjadi 25
  // print('Hasil kuadrat: $hasilKuadrat');

  // Ekspresi dengan Notasi Berantai
  // Perhatikan bagaimana setiap bagian setelah '..' adalah ekspresi yang dievaluasi
  // pada objek 'siswa' yang sama.
  var siswa = Mahasiswa() // 'new Mahasiswa()' adalah ekspresi yang menghasilkan objek Mahasiswa
    ..nama = 'Umar'        // 'siswa.nama = 'Umar'' adalah ekspresi penugasan
    ..usia = 25
    ..jurusan = 'Sejarah Islam';
  siswa.cetakDetail(); // 'siswa.cetakDetail()' adalah ekspresi panggilan metode
  // Output: Nama: Umar, Usia: 25, Jurusan: Sejarah Islam
}

class Mahasiswa {
  String? nama;
  int? usia;
  String? jurusan;

  void cetakDetail() {
    print('Nama: $nama, Usia: $usia, Jurusan: $jurusan');
  }
}
```

**Penjelasan Singkat:**
Ini adalah proses di mana komputer "memahami" apa yang Anda tulis dan menghitung hasilnya. Setiap baris kode yang menghasilkan sebuah nilai adalah sebuah ekspresi yang akan dievaluasi.

---

### 050\. Ekspresi Kondisional (Conditional Expressions)

Topik ini sudah kita bahas pada poin 042. Ini adalah penekanan ulang karena ekspresi kondisional adalah bagian penting dari operator dan ekspresi.

Ingat kembali:

- **Operator Ternary (`kondisi ? nilai1 : nilai2`)**: Cara singkat untuk menulis `if-else` sederhana.
- **Operator Null-aware (`??`)**: Untuk memberikan nilai default jika ekspresi di sebelah kiri `null`.

**Contoh Kode (ulang):**

```dart
void main() {
  // Operator Ternary (?:)
  int suhu = 28;
  String saranPakaian = (suhu > 25) ? 'Pakai baju tipis' : 'Pakai jaket';
  // Jika suhu lebih dari 25, hasilnya 'Pakai baju tipis', jika tidak, 'Pakai jaket'.
  print('Saran pakaian: $saranPakaian'); // Output: Saran pakaian: Pakai baju tipis

  // Operator Null Coalescing (??)
  String? namaPenulis; // Bisa null
  String namaYangDigunakan = namaPenulis ?? 'Penulis Misterius';
  // Jika namaPenulis null, gunakan 'Penulis Misterius'.
  print('Nama penulis: $namaYangDigunakan'); // Output: Nama penulis: Penulis Misterius

  namaPenulis = 'Ibnu Sina';
  namaYangDigunakan = namaPenulis ?? 'Penulis Misterius';
  print('Nama penulis (setelah diisi): $namaYangDigunakan'); // Output: Nama penulis (setelah diisi): Ibnu Sina
}
```

**Penjelasan Singkat:**
Kemampuan untuk membuat keputusan berdasarkan kondisi, sangat fundamental dalam pemrograman.

---

### **Contoh Utama (Key Examples) yang Disediakan**

Mari kita bedah kembali contoh-contoh yang Anda berikan, dengan penjelasan detail:

#### 1\. **Null Safety: `String? nullableString = null;`**

```dart
String? nullableString = null; // Mendeklarasikan variabel 'nullableString' yang bisa null.
// ^ 'String?' menunjukkan tipe data String yang BISA null.
//   Ini adalah fitur Null Safety di Dart. Tanpa '?', variabel String tidak boleh null.

String nonNullable = 'Dart'; // Mendeklarasikan variabel 'nonNullable' yang tidak boleh null.
// ^ 'String' tanpa '?' berarti variabel ini TIDAK BISA null.

print(nullableString?.length); // Memanggil properti '.length' dengan aman.
//           ^ Operator Safe Navigation (?.):
//             Jika 'nullableString' tidak null, maka panggil '.length' dan kembalikan hasilnya.
//             Jika 'nullableString' null, jangan panggil '.length' dan langsung kembalikan nilai 'null'.
// Output: null (karena nullableString memang null)
```

**Penjelasan:**
Ini menunjukkan bagaimana Dart (dengan fitur Null Safety-nya) membantu kita menghindari kesalahan `null` yang sering terjadi di bahasa pemrograman lain. Operator `?.` adalah alat pengaman yang sangat berguna.

#### 2\. **Notasi Berantai (Cascade Notation): `var paint = Paint()..color = Colors.black;`**

```dart
// Anggap kita punya kelas Paint dengan properti berikut
class Paint {
  Object? color;
  double? strokeWidth;
  Object? style;

  void applySettings() {
    print('Applying paint settings: Color=$color, Width=$strokeWidth, Style=$style');
  }
}

// Untuk contoh ini, Colors.black dan PaintingStyle.stroke adalah placeholder
class Colors {
  static const String black = 'Black';
}
class PaintingStyle {
  static const String stroke = 'Stroke';
}


void main() {
  var paint = Paint() // Membuat objek Paint
    ..color = Colors.black // Mengatur properti 'color' pada objek 'paint'
    ..strokeWidth = 5.0    // Mengatur properti 'strokeWidth' pada objek 'paint'
    ..style = PaintingStyle.stroke // Mengatur properti 'style' pada objek 'paint'
    ..applySettings(); // Memanggil metode 'applySettings' pada objek 'paint'
  // ^ Setiap baris yang diawali dengan '..' beroperasi pada objek 'paint' yang sama.
  // Ini setara dengan:
  // var paint = Paint();
  // paint.color = Colors.black;
  // paint.strokeWidth = 5.0;
  // paint.style = PaintingStyle.stroke;
  // paint.applySettings();
  // Output: Applying paint settings: Color=Black, Width=5.0, Style=Stroke
}
```

**Penjelasan:**
Anda bisa melihat betapa ringkasnya kode menggunakan notasi berantai. Ini sangat umum di Flutter untuk menginisialisasi widget dengan banyak properti.

#### 3\. **Operator Sadar `null` (Null-aware Operators): `String displayName = name ?? 'Guest';`**

```dart
void main() {
  String? name; // Variabel 'name' yang bisa null.

  String displayName = name ?? 'Guest';
  //                     ^ Operator Null Coalescing (??):
  //                       Jika 'name' non-null, 'displayName' akan menjadi nilai 'name'.
  //                       Jika 'name' null, 'displayName' akan menjadi 'Guest'.
  print('Display Name (null): $displayName'); // Output: Display Name (null): Guest

  name = 'Siti'; // Sekarang 'name' memiliki nilai.
  displayName = name ?? 'Guest';
  print('Display Name (non-null): $displayName'); // Output: Display Name (non-null): Siti
}
```

**Penjelasan:**
Ini adalah cara yang sangat umum untuk memberikan nilai default jika suatu variabel yang berpotensi `null` ternyata memang `null`. Sangat praktis untuk menampilkan nama pengguna default atau nilai fallback lainnya.

[0]:../../../README.md