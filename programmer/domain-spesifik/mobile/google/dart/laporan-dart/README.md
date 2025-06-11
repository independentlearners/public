### Laporan Komprehensif tentang Bahasa Pemrograman Dart

**Pendahuluan**: Prinsip dan Karakteristik Inti DartDart adalah bahasa pemrograman yang dioptimalkan untuk klien, dikembangkan oleh Google, dengan tujuan utama untuk membangun aplikasi berperforma tinggi di berbagai platform. Meskipun seringkali diasosiasikan secara eksklusif dengan pengembangan antarmuka pengguna melalui kerangka kerja Flutter, Dart adalah bahasa serbaguna yang kapabilitasnya melampaui ranah UI. Bahasa ini dirancang untuk mendukung pengembangan aplikasi web, server, desktop, dan command-line, menjadikannya pilihan yang adaptif untuk berbagai kebutuhan pengembangan perangkat lunak.1 Sebagai bahasa open-source, Dart menawarkan fondasi yang kuat untuk inovasi dan kolaborasi dalam komunitas pengembang.Dart memiliki beberapa karakteristik inti yang mendefinisikan arsitektur dan filosofi desainnya:

**Statically Typed**: Setiap variabel dalam Dart memiliki tipe yang harus ditentukan pada waktu kompilasi, dan tipe variabel tersebut tidak dapat diubah selama eksekusi program. Pendekatan ini serupa dengan bahasa-bahasa seperti C, Java, Swift, dan Kotlin, yang mengedepankan keamanan tipe yang ketat.8

**Type Inference**: Meskipun Dart adalah bahasa dengan tipe statis, anotasi tipe bersifat opsional karena Dart memiliki kemampuan untuk menyimpulkan tipe variabel secara otomatis. Sebagai contoh, ketika mendeklarasikan var number = 101, Dart akan secara otomatis menyimpulkan number sebagai tipe int.9 Kombinasi tipe statis dan inferensi tipe ini merupakan keputusan desain yang strategis. Tipe statis berperan penting dalam menangkap berbagai kesalahan terkait tipe pada fase kompilasi, yang sangat krusial untuk pengembangan aplikasi berskala besar dan kompleks, sehingga meminimalkan munculnya kesalahan saat runtime yang sulit didiagnosis. Di sisi lain, inferensi tipe mengurangi boilerplate kode dan mempercepat proses penulisan, memberikan Dart nuansa yang lebih "ringan" layaknya bahasa dinamis selama fase pengembangan. Pendekatan ini berupaya menggabungkan keunggulan dari kedua paradigma, memungkinkan refactoring yang lebih aman dan pemeliharaan kode jangka panjang yang lebih efisien. Kemampuan ini sangat berharga dalam tim pengembangan yang besar atau proyek yang terus berkembang, di mana perubahan pada satu bagian kode lebih mungkin terdeteksi sebagai masalah tipe pada waktu kompilasi daripada menyebabkan kegagalan tak terduga di lingkungan produksi.

**Multi-Paradigma**: Dart mendukung berbagai paradigma pemrograman, termasuk pemrograman berorientasi objek (OOP) dan fungsional.8 Fleksibilitas ini memungkinkan pengembang untuk memilih gaya pengkodean yang paling sesuai dengan kebutuhan proyek atau preferensi pribadi.

**String Expressions**: Dart memungkinkan penyematan nilai dan ekspresi di dalam string menggunakan simbol dolar ($), sebuah fitur yang mirip dengan Kotlin dan Swift. Selain itu, string yang berdekatan atau yang ditempatkan pada baris terpisah dapat digabungkan secara implisit, menyederhanakan konstruksi string yang panjang.8

Salah satu prinsip fundamental Dart adalah bahwa segala sesuatu adalah objek. Ini berarti bahwa setiap elemen yang dapat ditempatkan dalam variabel, termasuk angka, fungsi, dan bahkan nilai null, adalah instansi dari sebuah kelas.9 Semua objek ini, dengan pengecualian null ketika null safety diaktifkan, mewarisi dari kelas Object.9 Desain ini menghasilkan sistem tipe yang sangat konsisten, di mana pengembang tidak perlu mempelajari dua set aturan yang berbeda untuk memanipulasi tipe "primitif" dan "objek kompleks", karena pada dasarnya tidak ada perbedaan fundamental di antara keduanya. Konsistensi ini memungkinkan pemanggilan metode pada angka (misalnya, 10.abs()) atau string (misalnya, "hello".length) seolah-olah mereka adalah objek kelas penuh, yang memang demikian adanya. Hal ini mengurangi ambiguitas dan membuat API lebih seragam dan dapat diprediksi. Konsistensi ini juga secara langsung mendukung fitur-fitur canggih seperti "fungsi sebagai objek kelas pertama", di mana fungsi dapat diteruskan sebagai argumen, ditetapkan ke variabel, atau dikembalikan dari fungsi lain.9 Ini merupakan pilar penting untuk pemrograman fungsional dan pola desain yang fleksibel, serta menyederhanakan implementasi operator dan metode ekstensi karena semua yang dioperasikan adalah objek. Program Dart memulai eksekusi dari fungsi main(), yang sintaksnya sangat mirip dengan fungsi main di bahasa lain seperti C, Swift, atau Kotlin, dan memiliki tipe pengembalian void yang menunjukkan bahwa tidak ada nilai yang dikembalikan.8Sintaks Dasar DartSintaks bahasa pemrograman Dart mengadopsi gaya C, yang membuatnya sangat akrab bagi pengembang yang memiliki pengalaman dengan bahasa-bahasa seperti C, Java, atau JavaScript.8 Struktur ini memfasilitasi kurva pembelajaran yang cepat bagi mereka yang sudah terbiasa dengan konvensi serupa.

### Whitespace, Pernyataan, dan Blok Kode

**Whitespace**: Karakter seperti carriage return, spasi, newline, dan tab diabaikan oleh kompiler Dart selama proses kompilasi. Meskipun demikian, penggunaan whitespace sangat penting untuk memformat kode agar lebih mudah dibaca dan dipahami oleh manusia.15 Penekanan pada penggunaan whitespace untuk keterbacaan, meskipun tidak memengaruhi kompilasi, menggarisbawahi bahwa kode tidak hanya ditujukan untuk mesin, tetapi juga untuk kolaborasi antar pengembang. Hal ini sangat penting dalam pengembangan tim, di mana konsistensi dan kejelasan kode secara langsung memengaruhi produktivitas dan mengurangi waktu yang dibutuhkan untuk memahami basis kode baru.
Pernyataan (Statements): Sebuah pernyataan adalah instruksi fundamental yang mendeklarasikan tipe atau menginstruksikan program untuk melakukan tugas tertentu. Setiap pernyataan dalam Dart harus diakhiri dengan titik koma (;).15 Misalnya, String message = 'Welcome to Dart!'; adalah sebuah pernyataan yang mendeklarasikan variabel string.

**Blok (Blocks)**: Sebuah blok kode adalah urutan nol atau lebih pernyataan yang dikelilingi oleh kurung kurawal ({}).15 Berbeda dengan pernyataan individual, sebuah blok tidak diakhiri dengan titik koma. Blok digunakan untuk mengelompokkan pernyataan, seringkali dalam konteks pernyataan kontrol aliran seperti if/else atau for loop.15

### Pengidentifikasi, Kata Kunci, dan Literal

**Pengidentifikasi (Identifiers)**: Pengidentifikasi adalah nama yang diberikan kepada berbagai elemen pemrograman seperti variabel, konstanta, dan fungsi. Dalam Dart, pengidentifikasi harus mematuhi aturan tertentu: karakter alfabet (a-z, A-Z) dan garis bawah (\_) dapat muncul di posisi mana pun. Digit (0-9) diizinkan, tetapi tidak boleh menjadi karakter pertama.9 Penting juga untuk dicatat bahwa pengidentifikasi bersifat case-sensitive, yang berarti message dan Message dianggap sebagai pengidentifikasi yang berbeda.15
Kata Kunci (Keywords): Kata kunci adalah pengidentifikasi yang dicadangkan yang memiliki makna khusus bagi kompiler Dart. Oleh karena itu, kata kunci tidak dapat digunakan sebagai nama untuk pengidentifikasi yang ditentukan oleh pengembang.9 Contoh kata kunci Dart meliputi abstract, else, import, static, await, break, class, const, for, if, return, dan void.15
Literal (Literals): Literal merepresentasikan nilai primitif secara langsung dalam program. Contohnya, 10 adalah literal integer.15 Literal string dibuat dengan mengelilingi teks dengan tanda kutip tunggal ('), ganda ("), atau tiga kutip (""").1 Literal string dapat menjadi konstanta waktu kompilasi jika ekspresi yang diinterpolasi di dalamnya juga merupakan konstanta waktu kompilasi yang dievaluasi menjadi nilai null, numerik, string, atau boolean.13

### Komentar

Dart mendukung tiga jenis komentar yang digunakan untuk mendokumentasikan kode dan diabaikan oleh kompiler:

**Komentar satu baris**: Dimulai dengan dua garis miring ke depan `//` dan berlanjut hingga akhir baris.15 Contoh: `String message = 'Welcome to Dart!'; // a greeting message`.

**Komentar blok**: Dimulai dengan /_ dan diakhiri dengan _/. Komentar ini dapat mencakup beberapa baris kode.15
Komentar dokumen (Doc comments): Dimulai dengan tiga garis miring ke depan (///) dan ditempatkan sebelum deklarasi apa pun. Komentar ini digunakan oleh perintah dart doc untuk menghasilkan dokumentasi API yang terstruktur dan mudah dibaca.9 Komentar dokumen yang terintegrasi dengan alat dart doc menunjukkan komitmen Dart terhadap ekosistem yang mendukung dokumentasi internal sebagai bagian integral dari proses pengembangan. Bahasa yang memprioritaskan keterbacaan dan dokumentasi cenderung memiliki ekosistem yang lebih sehat dengan pustaka yang lebih mudah digunakan dan dipelihara, mengurangi "biaya kognitif" bagi pengembang untuk memahami dan berkontribusi pada basis kode yang ada.

Tipe Data BawaanDart menyediakan dukungan bawaan yang komprehensif untuk berbagai tipe data, yang semuanya diperlakukan sebagai objek. Dengan pengecualian Null (terutama dengan fitur null safety yang diaktifkan), semua tipe data ini mewarisi dari kelas Object.1

### Angka (int, double, num, BigInt)

**int**: Merepresentasikan nilai integer (bilangan bulat). Pada platform native, nilai int dapat berkisar dari -2^63^ hingga 2^63^ - 1. Namun, pada platform web, nilai integer direpresentasikan sebagai nilai floating-point 64-bit tanpa bagian pecahan, dengan rentang dari -2^53^ hingga 2^53^ - 1.1

**double**: Digunakan untuk merepresentasikan angka floating-point presisi 64-bit (presisi ganda), yang mematuhi standar IEEE 754.1

**num**: Tipe num berfungsi sebagai supertype dari int dan double. Ini berarti sebuah variabel yang dideklarasikan dengan tipe num dapat menampung baik nilai integer maupun double.1 Tipe ini menyediakan operator aritmatika dasar seperti `+`, `-`, `/`, `*`, serta metode seperti `abs()`, `ceil()`, dan `floor()`.13 Keberadaan num memungkinkan pengembang untuk menulis kode yang lebih generik untuk operasi numerik di mana perbedaan antara integer dan floating-point tidak relevan. Sebagai contoh, sebuah fungsi yang menghitung jarak atau rata-rata dapat menerima num sebagai parameter, menghilangkan kebutuhan untuk melakukan overload fungsi atau pemeriksaan tipe manual untuk int atau double. Hal ini meningkatkan fleksibilitas dan reusabilitas kode. Untuk pustaka yang berurusan dengan komputasi numerik, num memungkinkan API yang lebih bersih dan lebih ekspresif, mengurangi kompleksitas yang terkait dengan penanganan berbagai tipe numerik secara eksplisit, yang pada akhirnya mengarah pada kode yang lebih mudah dipelihara dan lebih sedikit kesalahan terkait tipe.
BigInt: Digunakan untuk merepresentasikan integer yang sangat besar yang melebihi batas kapasitas tipe int.1

### String (String)

Objek String dalam Dart menyimpan urutan unit kode UTF-16.1 String dapat dibuat menggunakan tanda kutip tunggal (') atau ganda (").1
Nilai ekspresi dapat disematkan di dalam string menggunakan sintaks ${expression} atau $identifier.8
String yang berdekatan dapat digabungkan secara implisit, atau menggunakan operator +.8
String multi-baris dapat dibuat dengan menggunakan tiga tanda kutip (''' atau """).13
"Raw" string, yang mengabaikan perlakuan khusus untuk backslash (misalnya, urutan escape), diawali dengan huruf r.13

### Boolean (bool)

Dart memiliki tipe bool untuk nilai boolean, yang hanya memiliki dua objek yang mungkin: true dan false.1
Kedua nilai ini adalah konstanta waktu kompilasi.13
Keamanan tipe Dart mengharuskan pemeriksaan eksplisit untuk nilai dalam pernyataan kondisional, artinya penggunaan nilai non-boolean secara langsung dalam kondisi (misalnya, if (nonbooleanValue)) tidak diizinkan.13

### Koleksi (List, Set, Map)

List (List): Mirip dengan array di banyak bahasa pemrograman lain, List adalah kumpulan objek yang terurut.1 Dart mendukung List dengan ukuran variabel (growable) dan ukuran tetap (fixed-size).1
Set (Set): Kumpulan elemen unik yang tidak terurut.1
Map (Map): Kumpulan pasangan key-value di mana setiap key bersifat unik.1 Key dan value dalam sebuah Map dapat berupa tipe data apa pun.1

### Tipe Khusus (Runes, Symbols, Null)

Runes (Runes): Digunakan untuk mengekspos Unicode code points dari sebuah string. Runes diperlukan untuk memanipulasi karakter Unicode yang berada di luar set karakter ASCII standar, seperti emoji atau karakter dari skrip non-Inggris.1 Namun, untuk bekerja dengan karakter yang dipersepsikan pengguna (yaitu, grapheme clusters Unicode), penggunaan paket characters kini lebih disukai karena menyediakan abstraksi yang lebih tinggi dan lebih mudah digunakan.13 Evolusi dari Runes ke characters menunjukkan bahwa Dart terus beradaptasi untuk menyediakan abstraksi yang lebih baik dan lebih ramah pengembang untuk kebutuhan internasionalisasi. Ini mencerminkan kematangan bahasa dan ekosistemnya, yang berusaha menyediakan alat yang paling tepat dan aman untuk tugas-tugas kompleks seperti manipulasi string Unicode.
Symbols (Symbol): Objek Symbol merepresentasikan operator atau pengidentifikasi yang dideklarasikan dalam program Dart.1 Mereka sangat berguna untuk API yang merujuk pengidentifikasi berdasarkan nama, karena proses minification kode dapat mengubah nama pengidentifikasi tetapi tidak akan mengubah simbol.1 Literal simbol dibuat dengan memberikan awalan # pada pengidentifikasi (misalnya, #radix).13
Null (Null): Nilai null direpresentasikan oleh tipe Null.1 Dengan implementasi sound null safety di Dart, variabel tidak dapat berisi null kecuali secara eksplisit ditandai sebagai nullable dengan menambahkan tanda tanya (?) setelah tipe data (misalnya, int?).10

###

Operator dalam DartDart menyediakan serangkaian operator yang komprehensif, banyak di antaranya familiar bagi pengembang yang berasal dari bahasa seperti C, Swift, atau Kotlin. Operator ini memungkinkan berbagai operasi pada data dan kontrol aliran program.8

### Jenis Operator Umum

Operator Aritmatika: Meliputi + (penjumlahan), - (pengurangan), \* (perkalian), / (pembagian floating-point), ~/ (pembagian integer), dan % (modulus).8
Operator Kesetaraan dan Relasional: Digunakan untuk perbandingan, seperti == (sama dengan), != (tidak sama dengan), > (lebih besar dari), < (lebih kecil dari), >= (lebih besar dari atau sama dengan), dan <= (lebih kecil dari atau sama dengan).8
Operator Increment dan Decrement: ++ (increment) dan -- (decrement), yang dapat digunakan dalam bentuk pre-increment/decrement (misalnya, ++i) atau post-increment/decrement (misalnya, i++).8
Operator Logis: && (AND logis), || (OR logis), dan ! (NOT logis) digunakan untuk menggabungkan atau membalikkan kondisi boolean.8
Operator Bitwise dan Shift: & (AND bitwise), | (OR bitwise), ^ (XOR bitwise), ~ (komplemen bitwise), << (shift kiri), >> (shift kanan), dan >>> (shift kanan tanpa tanda) digunakan untuk manipulasi tingkat bit.9

### Operator Khusus

Operator Uji Tipe: is digunakan untuk menguji apakah suatu objek adalah instansi dari tipe tertentu, is! adalah negasi dari is, dan as digunakan untuk transmisi tipe (type casting).9 Penting untuk menggunakan operator is daripada membandingkan runtimeType untuk pengujian tipe yang lebih stabil dan andal di lingkungan produksi.12
Operator Penugasan: Selain operator penugasan dasar = (penugasan), Dart juga memiliki operator penugasan gabungan seperti +=, -=, \*=, /=, %=, dan ??= (penugasan null-aware).9
Ekspresi Kondisional: Operator ternary condition? expr1 : expr2 adalah ekspresi kondisional yang mengevaluasi expr1 jika condition benar, dan expr2 jika salah.9 Berbeda dengan pernyataan if-else yang tidak memiliki nilai, ekspresi kondisional ini menghasilkan nilai.9
Notasi Cascade (..): Fitur ini memungkinkan pengembang untuk melakukan urutan operasi pada objek yang sama.9 Notasi cascade meningkatkan keterbacaan kode, terutama saat menginisialisasi objek atau mengonfigurasi properti. Daripada menulis object.property1 = value1; object.method1(); object.property2 = value2;, pengembang dapat menulis object..property1 = value1..method1()..property2 = value2;. Pendekatan ini membuat aliran kode lebih linier dan mengurangi pengulangan nama objek, yang pada gilirannya membuat kode lebih mudah dipindai dan dipahami. Selain itu, ini dapat meningkatkan efisiensi dengan menghindari pencarian objek yang berulang. Fitur ini secara implisit mendorong pola desain fluent API atau method chaining, di mana metode mengembalikan objek yang sama untuk memungkinkan panggilan berantai, yang sangat umum dalam pembangunan objek kompleks.
Operator Null-aware: Dart memperkenalkan operator null-aware seperti ?. (akses anggota null-aware), ?? (koalesensi null-aware), dan ??= (penugasan null-aware).17 Operator ini sangat penting dalam konteks null safety Dart, memungkinkan interaksi yang aman dengan variabel yang mungkin berisi null tanpa menyebabkan kesalahan runtime.17 Operator null-aware secara drastis mengurangi frekuensi null dereference errors pada waktu runtime, yang sering disebut sebagai "kesalahan miliaran dolar" dalam pemrograman. Ini mengubah potensi kesalahan runtime menjadi pemeriksaan waktu kompilasi atau perilaku yang dapat diprediksi. Selain itu, operator ini membuat kode lebih ringkas dan mudah dibaca dibandingkan dengan pemeriksaan if (variable!= null) yang berulang. Integrasi operator ini ke dalam bahasa mendorong pergeseran paradigma dari "mengharapkan null dan memeriksa" menjadi "mendeklarasikan nullability dan mengelola dengan aman", yang merupakan bagian dari filosofi sound null safety Dart 16 yang bertujuan untuk menghilangkan seluruh kelas bug yang terkait dengan null pada waktu kompilasi.

Operator Overloading: Dart juga mendukung operator overloading, yang memungkinkan pengembang untuk mendefinisikan ulang perilaku operator untuk tipe kustom mereka, mirip dengan C++ dan Kotlin. Ini adalah fitur yang lebih canggih untuk mengkustomisasi interaksi objek.8

Pernyataan Kontrol AliranPernyataan kontrol aliran dalam Dart adalah mekanisme penting yang mengatur urutan eksekusi program. Mereka memungkinkan aplikasi untuk membuat keputusan berdasarkan kondisi dan mengulang blok kode tertentu, yang merupakan dasar dari logika program yang kompleks.8

### Kondisional (if-else, switch-case)

if dan else: Ini adalah bentuk kontrol aliran yang paling dasar, yang memungkinkan program untuk memutuskan apakah akan mengeksekusi atau melewati bagian tertentu dari kode, bergantung pada kondisi yang terpenuhi selama eksekusi.8 Sintaks if/else di Dart sangat mirip dengan penggunaannya di bahasa-bahasa lain yang berbasis C.8 Pernyataan if else secara spesifik memungkinkan eksekusi satu blok kode jika kondisi yang diberikan bernilai true, dan blok kode alternatif jika kondisi tersebut bernilai false.15
switch dan case: Pernyataan switch mengevaluasi sebuah ekspresi dan membandingkan hasilnya dengan serangkaian nilai yang telah ditentukan dalam klausa case.9 Dalam Dart, klausa case yang tidak kosong secara otomatis akan keluar dari pernyataan switch setelah eksekusinya selesai, sehingga tidak memerlukan pernyataan break eksplisit.10 Untuk skenario di mana tidak ada klausa case yang cocok dengan nilai ekspresi, klausa default atau pola wildcard \_ dapat digunakan untuk menangani kasus tersebut.10 Menariknya, kasus kosong akan "jatuh" ke kasus berikutnya, memungkinkan beberapa kasus untuk berbagi satu blok kode yang sama. Untuk perilaku jatuh yang tidak berurutan, pernyataan continue yang dikombinasikan dengan label dapat digunakan.10

### Perulangan (for, while, do-while)

for Loops: Digunakan untuk perulangan yang mengulang kode sebanyak jumlah kali yang telah ditentukan.8 Dart menyediakan dua bentuk utama: bentuk for loop yang mirip C (dengan inisialisasi, kondisi perulangan, dan tindakan iterasi) dan for-in loop yang dirancang untuk iterasi atas koleksi objek.8
while dan do-while: Kedua jenis perulangan ini mengulang blok kode berdasarkan kondisi tertentu.8 Perbedaan fundamentalnya terletak pada waktu pemeriksaan kondisi: while loop memeriksa kondisi di awal blok kode (sehingga disebut pretest loop), sedangkan do-while loop memeriksa kondisi setelah blok kode dieksekusi (dikenal sebagai posttest loop). Implikasi dari do-while adalah bahwa blok kode di dalamnya dijamin akan berjalan setidaknya satu kali, terlepas dari kondisi awalnya.8

### Kontrol Perulangan (break, continue)

break: Pernyataan break digunakan untuk menghentikan eksekusi perulangan secara tiba-tiba dan melanjutkan aliran program ke pernyataan yang berada tepat setelah badan perulangan.8 Dalam konteks perulangan bersarang, break hanya akan menghentikan perulangan terdalam di mana ia berada, bukan semua perulangan yang bersarang.10
continue: Pernyataan continue memungkinkan program untuk melewatkan sisa kode di dalam iterasi perulangan saat ini dan segera melanjutkan ke iterasi berikutnya.8 Mirip dengan break, dalam perulangan bersarang, continue hanya memengaruhi perulangan terdalam.10
Labels: Dart memungkinkan penggunaan label bersama dengan pernyataan break dan continue. Label memberikan kemampuan untuk secara spesifik mengontrol perulangan mana yang akan terpengaruh, terutama dalam struktur perulangan bersarang yang kompleks.10

### Pernyataan assert

Pernyataan assert adalah alat yang dirancang khusus untuk fase pengembangan. Ini digunakan untuk mengganggu eksekusi normal program jika suatu kondisi boolean yang diberikan mengevaluasi menjadi false.9
Sintaks dasarnya adalah assert(<condition>, <optionalMessage>);, di mana pesan opsional dapat ditambahkan untuk memberikan konteks lebih lanjut jika assertion gagal.10
Jika kondisi bernilai true, assertion berhasil dan eksekusi berlanjut. Namun, jika kondisi bernilai false, AssertionError akan dilemparkan.20
Penting untuk dicatat bahwa pernyataan assert sepenuhnya diabaikan dalam kode produksi, dan argumennya tidak dievaluasi. Hal ini memastikan bahwa tidak ada dampak kinerja pada aplikasi yang di-deploy.20 Desain assert yang hanya aktif dalam mode pengembangan menunjukkan filosofi Dart untuk menyediakan alat bantu pengembang yang kuat tanpa mengorbankan kinerja aplikasi di lingkungan produksi. Hal ini memungkinkan pengembang untuk menambahkan banyak pemeriksaan validasi dan prasyarat ke kode mereka selama pengembangan untuk menangkap bug sedini mungkin, tanpa khawatir akan overhead kinerja saat aplikasi di-deploy. Ini juga mendorong praktik "fail fast" di mana masalah teridentifikasi dan dihentikan sesegera mungkin selama pengembangan, mencegah bug yang lebih parah muncul di kemudian hari dalam siklus pengembangan.

Fungsi: Definisi dan PenggunaanFungsi dalam Dart adalah blok kode yang terorganisir, dirancang untuk melakukan tugas tertentu. Mereka mengambil input, melakukan komputasi spesifik, dan menghasilkan output, mempromosikan modularitas dan reusabilitas kode.21

### Struktur Fungsi dan Nilai Kembali

Sebuah fungsi dalam Dart didefinisikan dengan menentukan tipe pengembaliannya (atau void jika tidak ada nilai yang dikembalikan), nama fungsi, daftar parameter yang diapit tanda kurung, dan badan fungsi yang diapit kurung kurawal.8 Fungsi yang tidak secara eksplisit mengembalikan nilai memiliki tipe pengembalian void.8
Untuk fungsi yang hanya terdiri dari satu ekspresi, Dart menyediakan sintaks => (panah) yang ringkas, di mana => expr adalah cara singkat untuk menulis { return expr; }.10
Dart juga memungkinkan fungsi untuk mengembalikan beberapa nilai dengan mengagregasi nilai-nilai tersebut ke dalam sebuah record.14

### Parameter (Positional, Named, Opsional, Nilai Default)

Parameter Positional Wajib: Ini adalah parameter yang harus disediakan dalam urutan yang benar saat memanggil fungsi.14
Parameter Bernama (Named Parameters): Parameter ini bersifat opsional secara default, kecuali jika secara eksplisit ditandai dengan kata kunci required.14 Saat mendefinisikan fungsi, parameter bernama diapit dalam kurung kurawal ({param1, param2, }).14 Ketika memanggil fungsi, argumen bernama ditentukan menggunakan format paramName: value.14 Dart memungkinkan argumen bernama untuk ditempatkan di mana saja dalam daftar argumen, tidak harus setelah argumen posisional.14 Fleksibilitas ini memungkinkan pengembang untuk mendesain API fungsi yang sangat jelas dan ekspresif. Parameter posisional cocok untuk argumen yang urutannya penting dan selalu ada, sementara parameter bernama sangat efektif untuk argumen opsional yang fungsinya jelas dari namanya, yang meningkatkan keterbacaan panggilan fungsi dan mengurangi kesalahan karena urutan. Untuk pengembang pustaka, ini berarti mereka dapat membuat API yang intuitif dan mudah digunakan, dan memfasilitasi evolusi API yang lebih mudah karena penambahan parameter bernama baru tidak akan merusak panggilan fungsi yang ada.
Parameter Positional Opsional: Parameter ini ditandai dengan mengapitnya dalam kurung siku (``).14
Nilai Default: Untuk parameter bernama atau opsional, nilai default dapat ditentukan menggunakan operator =, dan nilai yang ditentukan harus berupa konstanta waktu kompilasi.14 Jika tidak ada nilai default yang diberikan dan parameter tidak ditandai required, tipenya harus nullable.14

### Fungsi Anonim (Lambda, Closure)

Dart memungkinkan pembuatan fungsi tanpa nama, yang dikenal sebagai anonymous functions, lambdas, atau closures.9
Struktur fungsi anonim mirip dengan fungsi bernama, dengan parameter opsional dan blok kode. Mereka sering digunakan dengan metode seperti map atau forEach untuk operasi ringkas pada koleksi.14
Jika fungsi anonim hanya berisi satu ekspresi, ia juga dapat disingkat menggunakan notasi panah.14

### Fungsi sebagai Objek Kelas Pertama

Dart adalah bahasa berorientasi objek sejati, yang berarti bahkan fungsi pun adalah objek dan memiliki tipe Function.9
Status ini memungkinkan fungsi untuk diperlakukan seperti objek lainnya: mereka dapat ditetapkan ke variabel, diteruskan sebagai argumen ke fungsi lain, dan dikembalikan dari fungsi lain.9 Status fungsi sebagai objek kelas pertama adalah pilar untuk pemrograman fungsional, memungkinkan pola desain seperti higher-order functions (fungsi yang mengambil atau mengembalikan fungsi) dan callback. Ini sangat kuat untuk operasi pada koleksi (misalnya, list.forEach(printElement)) dan untuk pemrograman asinkron.
Cakupan Leksikal (Lexical Scope): Dart adalah bahasa dengan cakupan leksikal, yang berarti lingkup variabel ditentukan oleh tata letak kode. Fungsi bersarang dapat mengakses variabel dari cakupan penampungnya, hingga ke tingkat teratas.9
Closure Leksikal (Lexical Closures): Sebuah closure adalah objek fungsi yang dapat mengakses variabel dari cakupan leksikalnya bahkan ketika fungsi tersebut dieksekusi di luar cakupan tersebut.9 Closures memungkinkan fungsi untuk "mengingat" lingkungannya, yang sangat berguna untuk membuat fungsi yang disesuaikan atau untuk mengelola keadaan dalam pola fungsional. Kemampuan ini memungkinkan pengembang untuk membuat abstraksi tingkat tinggi yang menangani perilaku, bukan hanya data, yang dapat mengurangi duplikasi kode, meningkatkan reusabilitas, dan membuat kode lebih mudah dipahami pada tingkat konseptual yang lebih tinggi.
Tear-offs: Ketika pengembang merujuk pada fungsi, metode, atau konstruktor bernama tanpa tanda kurung, Dart secara otomatis membuat tear-off. Ini adalah closure yang mengambil parameter yang sama dengan fungsi asli dan memanggilnya saat dipanggil, menyediakan cara ringkas untuk membuat closure yang secara langsung memanggil fungsi bernama yang sudah ada.14

Pemrograman Berorientasi Objek (OOP) di DartDart adalah bahasa berorientasi objek yang kuat, mengintegrasikan konsep kelas dan mixin-based inheritance. Dalam Dart, setiap objek adalah instansi dari sebuah kelas, dan semua kelas, dengan pengecualian Null, mewarisi dari Object.9

### Kelas dan Objek

Kelas: Berfungsi sebagai cetak biru atau templat untuk membuat objek.11
Objek: Merupakan instansi konkret dari kelas. Objek memiliki anggota yang terdiri dari fungsi (disebut metode) dan data (disebut variabel instansi).11
Anggota objek diakses menggunakan operator titik (.). Sebagai contoh, p.y mengakses variabel instansi y dari objek p, dan p.distanceTo(Point(4, 4)) memanggil metode distanceTo pada objek p.12 Operator ?. (akses anggota null-aware) dapat digunakan untuk menghindari pengecualian jika operan kiri adalah null.12

### Konstruktor

Konstruktor adalah metode khusus yang digunakan untuk membuat dan menginisialisasi objek.9
Nama konstruktor dapat berupa ClassName (misalnya, Point()) atau ClassName.identifier (misalnya, Point.fromJson()).12
Penggunaan kata kunci new saat memanggil konstruktor bersifat opsional.12
Konstruktor Konstan: Beberapa kelas menyediakan konstruktor konstan. Dengan menggunakan kata kunci const sebelum nama konstruktor (misalnya, const ImmutablePoint(2, 2)), objek yang dibuat akan menjadi konstanta waktu kompilasi.12 Sebuah properti menarik dari konstruktor konstan adalah bahwa dua konstanta waktu kompilasi yang identik akan menghasilkan instansi kanonik tunggal, yang berarti mereka akan merujuk pada objek yang sama dalam memori.12

### Inheritansi dan Mixin

Inheritansi: Dart menggunakan model mixin-based inheritance.11 Setiap kelas dalam Dart (kecuali kelas teratas Object?) memiliki tepat satu superclass.12 Kata kunci extends digunakan untuk mengimplementasikan hubungan inheritansi, memungkinkan sebuah kelas untuk mewarisi properti dan metode dari superclass-nya.11
Mixin: Mixin adalah mekanisme yang kuat untuk menggunakan kembali kode kelas di berbagai hierarki kelas, memperluas fungsionalitas tanpa menggunakan inheritansi tradisional.9 Mixin didefinisikan menggunakan kata kunci mixin (misalnya, mixin LoggingMixin).11 Untuk menggunakan mixin dalam sebuah kelas, kata kunci with digunakan (misalnya, class Calculator with LoggingMixin).11 Urutan mixin yang diterapkan penting; jika dua mixin menyediakan metode atau properti dengan nama yang sama, yang pertama dideklarasikan akan memiliki prioritas.11 Klausa on opsional dapat digunakan untuk membatasi tipe kelas yang dapat menggunakan mixin tertentu.11 Mixin mengatasi masalah yang terkait dengan inheritansi berganda (misalnya, masalah diamond) sambil tetap memungkinkan reusabilitas kode yang kuat. Mereka memungkinkan kelas untuk "meminjam" atau "mencampur" perilaku dari beberapa sumber tanpa harus menjadi bagian dari hierarki inheritansi yang ketat. Ini adalah bentuk komposisi yang kuat, memungkinkan pengembang untuk membangun kelas dengan fungsionalitas yang kaya dari komponen yang dapat digunakan kembali secara horizontal. Pendekatan ini meningkatkan fleksibilitas desain arsitektur aplikasi, mempromosikan modularitas dan "pemisahan kekhawatiran" yang lebih baik, yang pada akhirnya mengarah pada kode yang lebih mudah dipelihara dan diperluas.

### Enkapsulasi (Getter, Setter, Anggota Privat)

Enkapsulasi adalah konsep membundel data dan metode yang beroperasi pada data tersebut dalam satu unit, yaitu kelas.11
Dart memiliki pendekatan yang unik untuk visibilitas anggota. Berbeda dengan bahasa seperti Java yang menggunakan kata kunci public, protected, dan private, Dart menggunakan konvensi garis bawah (_) sebagai awalan untuk menandai anggota sebagai privat untuk pustakanya.9 Keputusan desain ini mengalihkan fokus enkapsulasi dari tingkat kelas ke tingkat pustaka, menyederhanakan sintaksis dan mengurangi boilerplate. Ini mendorong pengembang untuk memikirkan modularitas dalam hal pustaka (file Dart), yang merupakan unit penyebaran dan organisasi utama. Anggota yang diawali dengan _ secara otomatis bersifat privat untuk file tersebut, mempromosikan desain yang lebih bersih di mana detail implementasi internal disembunyikan secara default. Pendekatan ini dapat memengaruhi bagaimana arsitektur proyek Dart dirancang, mendorong pengembang untuk mengelompokkan fungsionalitas terkait dalam pustaka yang sama untuk berbagi anggota privat, sementara API publik diekspos tanpa awalan. Hal ini membuat pemeliharaan lebih mudah karena perubahan pada anggota privat tidak akan memengaruhi kode di luar pustaka yang sama, mengurangi risiko efek samping yang tidak terduga.
Variabel instansi secara otomatis menghasilkan metode getter implisit. Variabel instansi non-final dan late final tanpa inisialisasi juga menghasilkan metode setter implisit.12

### Abstraksi dan Antarmuka Implisit

Abstraksi: Berfokus pada penyembunyian detail implementasi yang kompleks dan hanya mengekspos fitur yang diperlukan dari sebuah objek.9 Dalam Dart, abstraksi dicapai melalui kelas dan metode abstrak.9
Antarmuka Implisit: Setiap kelas secara implisit mendefinisikan sebuah antarmuka yang mencakup semua anggota instansi kelas dan antarmuka apa pun yang diimplementasikannya.9 Sebuah kelas dapat implement satu atau lebih antarmuka dengan mendeklarasikannya dalam klausa implements dan kemudian menyediakan API yang diperlukan oleh antarmuka tersebut. Ini memungkinkan sebuah kelas untuk mendukung API kelas lain tanpa harus mewarisi implementasinya.12

### Polimorfisme

Polimorfisme adalah kemampuan objek dari berbagai tipe untuk diperlakukan sebagai objek dari tipe umum.11 Dart mendukung polimorfisme melalui method overriding dan penggunaan antarmuka implisit, memungkinkan objek yang berbeda untuk merespons panggilan metode yang sama dengan cara mereka sendiri.11

### Metode Ekstensi (Extension Methods)

Metode ekstensi adalah fitur yang memungkinkan pengembang untuk menambahkan fungsionalitas baru ke kelas yang sudah ada tanpa memodifikasi kode sumber aslinya atau membuat subclass.9 Fitur ini sangat berguna untuk memperluas perilaku tipe yang tidak dimiliki atau tidak dapat dimodifikasi oleh pengembang. Metode ekstensi dideklarasikan menggunakan kata kunci extension diikuti dengan nama ekstensi dan kata kunci on yang menentukan tipe yang akan diperluas.11

### Anggota Statis (Class Variables and Methods)

Kata kunci static digunakan untuk mengimplementasikan variabel dan metode yang bersifat class-wide, yang berarti mereka terkait dengan kelas itu sendiri daripada instansi tertentu dari kelas tersebut.9
Variabel Statis: Berguna untuk menyimpan keadaan atau konstanta yang berlaku di seluruh kelas.12 Variabel statis tidak diinisialisasi sampai mereka pertama kali digunakan.12
Metode Statis: Metode statis tidak beroperasi pada instansi objek, sehingga mereka tidak dapat mengakses this.12 Namun, mereka dapat mengakses variabel statis dan dipanggil langsung pada kelas (misalnya, Point.distanceBetween(a, b);).12

Pemrograman AsinkronPemrograman asinkron dalam Dart merupakan pilar penting untuk membangun aplikasi yang responsif dan efisien. Ini melibatkan penggunaan objek Future dan Stream, bersama dengan kata kunci async dan await, untuk menangani operasi yang mungkin memakan waktu, seperti operasi I/O atau permintaan jaringan.9

### Memahami Future

Future (dengan huruf kapital 'F') adalah sebuah kelas yang merepresentasikan hasil dari komputasi asinkron.23
Sebuah Future dapat berada dalam dua keadaan: uncompleted (ketika operasi asinkron belum selesai) atau completed (setelah operasi selesai).24
Ketika selesai, Future dapat menghasilkan nilai (jika operasi berhasil) atau kesalahan (jika operasi gagal).24 Jika sebuah Future tidak menghasilkan nilai yang berguna, tipenya adalah Future<void>.24
Karakteristik kunci dari Future adalah bahwa ia tidak memblokir komputasi; sebaliknya, ia segera kembali dengan objek Future yang akan "selesai" dengan hasilnya nanti.25
API Future tingkat rendah memungkinkan pendaftaran callback secara manual menggunakan metode .then() untuk menangani nilai yang berhasil dan .catchError() untuk menangani kesalahan.25

### Kata Kunci async dan await

Kata kunci async dan await menyediakan cara deklaratif untuk mendefinisikan fungsi asinkron dan menggunakan hasilnya, membuat kode asinkron terlihat sangat mirip dengan kode sinkron.10
Untuk menggunakan kata kunci await, kode harus berada di dalam fungsi yang ditandai sebagai async.23
Sebuah fungsi yang ditandai dengan async secara otomatis akan mengembalikan objek Future.23
Ketika ekspresi await ditemui, eksekusi fungsi async dijeda sampai ekspresi await tersebut selesai. Namun, penting untuk dipahami bahwa program secara keseluruhan tidak diblokir; operasi lain dapat terus berjalan.23 Ini adalah inti dari bagaimana Dart mencapai responsivitas dan efisiensi pada satu thread eksekusi. Daripada memblokir seluruh thread saat menunggu operasi I/O yang lambat (misalnya, permintaan jaringan, pembacaan file), Dart menggunakan event loop untuk menjeda fungsi async yang sedang menunggu dan beralih ke tugas lain. Setelah operasi I/O selesai, fungsi yang dijeda akan dilanjutkan. Ini memaksimalkan penggunaan CPU pada satu core dan sangat penting untuk aplikasi yang responsif (misalnya, server yang menangani banyak permintaan secara bersamaan atau aplikasi desktop yang tidak boleh freeze). Dengan async/await sebagai syntactic sugar di atas Future dan Stream, Dart menyederhanakan pemrograman konkurensi yang kompleks. Pengembang dapat menulis kode yang secara logis berurutan, tetapi secara fundamental asinkron, tanpa harus secara manual mengelola callback bersarang (callback hell) atau berurusan dengan thread dan lock tingkat rendah yang rawan bug.
Blok try, catch, dan finally dapat digunakan untuk menangani kesalahan dan melakukan pembersihan dalam kode yang menggunakan await, mirip dengan penanganan kesalahan sinkron.10

### Menangani Stream

Stream merepresentasikan urutan nilai atau kesalahan yang dihasilkan dari waktu ke waktu.9
Stream dapat ditangani menggunakan perulangan await for, yang memungkinkan iterasi asinkron atas nilai-nilai yang dipancarkan oleh stream.23 Perulangan await for akan menunggu stream menghasilkan nilai, lalu mengeksekusi badan perulangan dengan variabel yang diatur ke nilai tersebut, dan mengulang langkah-langkah ini sampai stream ditutup.23
Alternatifnya, stream dapat ditangani dengan berlangganan menggunakan metode .listen().23
Metode seperti skip(), take(), where(), dan transform() tersedia untuk memanipulasi data stream.23

### Penanganan Kesalahan dalam Kode Asinkron

Kesalahan yang terjadi dalam Future dapat ditangani dengan menggunakan blok try-catch dalam fungsi async.20
Menggunakan metode .catchError() dengan API Future tingkat rendah dapat menangani kesalahan yang berasal dari seluruh rantai then().25
Metode whenComplete() adalah ekuivalen asinkron dari blok finally dalam pemrograman sinkron. Callback yang didaftarkan dalam whenComplete() akan dieksekusi terlepas dari apakah Future berhasil diselesaikan dengan nilai atau gagal dengan kesalahan.28 Ini sangat berguna untuk operasi pembersihan yang harus terjadi tanpa memandang hasil Future.
Penting untuk mendaftarkan error handler sedini mungkin dalam rantai Future untuk mencegah kesalahan yang tidak tertangani menyebar dan menyebabkan kegagalan aplikasi yang tidak terduga.28 Kerentanan terhadap kesalahan asinkron yang tidak tertangani dapat menyebabkan kegagalan aplikasi yang tidak terduga dan sulit di-debug di lingkungan produksi. Rekomendasi untuk mendaftarkan error handler lebih awal dan menggunakan Future.sync() menunjukkan bahwa Dart mendorong praktik terbaik untuk memastikan bahwa semua jalur kesalahan ditangani secara konsisten, terlepas dari apakah kesalahan itu sinkron atau asinkron. Ini adalah aspek kritis dari membangun aplikasi yang tangguh.
Future.sync() dapat digunakan untuk memastikan bahwa semua kesalahan, baik yang bersifat sinkron maupun asinkron, dipancarkan sebagai kesalahan Future. Ini membuat strategi penanganan kesalahan lebih konsisten dan dapat diprediksi.28

Penanganan Kesalahan dan DebuggingDart menyediakan mekanisme yang kuat untuk penanganan kesalahan, yang penting untuk membangun aplikasi yang tangguh dan mudah di-debug. Ini mencakup penggunaan pengecualian untuk menangani kejadian tak terduga dan pernyataan assert untuk validasi selama pengembangan.9

### Pengecualian (throw, catch, finally)

Pengecualian: Dalam Dart, pengecualian adalah kesalahan yang menunjukkan bahwa sesuatu yang tidak terduga telah terjadi selama eksekusi program. Jika sebuah pengecualian tidak ditangkap, isolate yang memunculkan pengecualian tersebut akan ditangguhkan, dan biasanya isolate beserta programnya akan dihentikan.20
Berbeda dengan Java, semua pengecualian Dart adalah pengecualian yang tidak dicentang (unchecked exceptions). Ini berarti metode tidak secara eksplisit mendeklarasikan pengecualian yang mungkin mereka lemparkan, dan pengembang tidak diwajibkan untuk menangkap pengecualian apa pun.20 Keputusan desain ini memberikan fleksibilitas yang lebih besar kepada pengembang, memungkinkan mereka untuk fokus pada logika bisnis tanpa dibebani oleh penanganan pengecualian yang wajib untuk setiap panggilan fungsi. Namun, hal ini juga menempatkan tanggung jawab yang lebih besar pada pengembang untuk secara proaktif mengidentifikasi dan menangani jalur kesalahan yang kritis, karena kompiler tidak akan memaksa mereka.
Dart menyediakan tipe Exception dan Error sebagai dasar untuk pengecualian, serta banyak subtype yang telah ditentukan. Pengembang juga memiliki kemampuan untuk mendefinisikan pengecualian kustom mereka sendiri.20
Penting untuk dicatat bahwa program Dart dapat melempar objek non-null apa pun sebagai pengecualian, tidak hanya objek Exception dan Error.20
throw: Kata kunci throw digunakan untuk mengangkat atau melempar pengecualian.10 Karena melempar pengecualian adalah sebuah ekspresi, ia dapat digunakan dalam pernyataan => atau di mana pun ekspresi diizinkan.20
catch: Mekanisme catch digunakan untuk menangani pengecualian, mencegahnya menyebar lebih jauh dan menghentikan program (kecuali jika secara eksplisit dilempar ulang dengan rethrow).10 Pengembang dapat menentukan beberapa klausa catch untuk menangani berbagai tipe pengecualian; klausa catch pertama yang cocok dengan tipe objek yang dilempar akan menangani pengecualian tersebut.20 Klausa on digunakan ketika pengembang perlu menentukan tipe pengecualian yang akan ditangkap, sedangkan klausa catch digunakan ketika handler memerlukan akses ke objek pengecualian itu sendiri dan stack trace.20 Kata kunci rethrow digunakan untuk menangani sebagian pengecualian sambil tetap membiarkannya menyebar ke caller berikutnya.20
finally: Klausa finally memastikan bahwa blok kode tertentu akan selalu dieksekusi, terlepas dari apakah pengecualian dilemparkan atau ditangkap.9 Jika tidak ada klausa catch yang cocok dengan pengecualian, pengecualian akan tetap disebarkan setelah klausa finally berjalan. Jika ada klausa catch yang cocok, klausa finally akan berjalan setelah klausa catch tersebut selesai.20

### Pernyataan assert (Ringkasan)

Seperti yang telah dibahas sebelumnya, pernyataan assert adalah alat pengembangan yang digunakan untuk mengganggu eksekusi normal jika kondisi boolean bernilai false.9 Sintaksnya adalah assert(<condition>, <optionalMessage>);.20 Jika kondisi true, assertion berhasil; jika false, AssertionError dilemparkan.20 Pernyataan ini diabaikan dalam kode produksi, sehingga tidak ada dampak kinerja.20

Konkurensi dengan IsolatesDart mencapai konkurensi dan paralelisme menggunakan isolates, yang merupakan unit komputasi independen. Setiap isolate memiliki memori terisolasi sendiri dan menjalankan event loop tunggal.2

### Model Isolate dan Pengiriman Pesan

Semua kode Dart berjalan dalam isolates, dimulai dari isolate utama secara default, dan dapat diperluas ke isolates tambahan yang dibuat secara eksplisit.2
Isolates mirip dengan thread di bahasa lain, tetapi perbedaan krusialnya adalah bahwa isolates memiliki memori terisolasi sendiri dan tidak berbagi keadaan secara langsung.2
Komunikasi antar isolates hanya dapat dilakukan melalui pengiriman pesan menggunakan objek Port (yaitu, ReceivePort dan SendPort).2 Ketika pesan "diteruskan" antar isolates, mereka umumnya disalin dari isolate pengirim ke isolate penerima. Ini berarti bahwa nilai apa pun yang diteruskan ke isolate, bahkan jika dimutasi di isolate tersebut, tidak akan mengubah nilai di isolate asli.30 Pengecualian untuk perilaku penyalinan ini adalah objek immutable (misalnya, String atau bytes yang tidak dapat dimodifikasi), di mana referensi dapat dikirim alih-alih salinan untuk meningkatkan kinerja sambil tetap mempertahankan perilaku model Aktor.30
Model ini adalah implementasi dari Model Aktor (Actor Model), yang secara intrinsik mencegah kompleksitas konkurensi seperti mutex atau lock dan data races yang umum terjadi pada model shared-memory.2 Desain ini secara fundamental mengatasi salah satu masalah paling sulit dalam pemrograman konkurensi: data races pada keadaan mutable yang dibagikan. Dengan secara ketat mengisolasi memori antar isolates dan memaksa komunikasi melalui penyalinan pesan, Dart menghilangkan kebutuhan akan lock dan mutex yang kompleks, yang merupakan sumber umum bug dan deadlock di bahasa lain. Hal ini secara signifikan menyederhanakan penulisan kode konkurensi yang aman dan membebaskan pengembang dari beban manajemen memori bersama yang rumit. Model ini mendukung skalabilitas aplikasi dengan memungkinkan komputasi memanfaatkan core prosesor yang berbeda tanpa memperkenalkan bug sinkronisasi yang sulit dilacak, dan meningkatkan ketahanan aplikasi karena kegagalan satu isolate tidak memengaruhi yang lain.

### Kasus Penggunaan dan Keterbatasan

Kasus Penggunaan Umum: Isolates terutama digunakan untuk mengoffload komputasi yang memakan waktu yang dapat menyebabkan "UI jank" atau ketidakresponsifan antarmuka pengguna (misalnya, membaca data dari database lokal, mengurai file JSON besar, memproses atau mengompresi file media, menerapkan pemfilteran ke daftar kompleks).29 Dengan memindahkan komputasi ini ke isolate pembantu, lingkungan runtime dapat menjalankan komputasi secara bersamaan dengan pekerjaan isolate UI utama, memanfaatkan perangkat multi-core.30
Isolate Jangka Pendek (Isolate.run() / compute): Ini adalah cara paling sederhana untuk mengoffload proses ke isolate terpisah. Metode Isolate.run() secara abstrak menangani pembuatan isolate baru, meneruskan fungsi callback untuk memulai komputasi, mengembalikan nilai dari komputasi yang selesai, dan segera mematikan isolate setelahnya.29 Isolate.run() adalah contoh bagaimana Dart menyediakan abstraksi tingkat tinggi untuk menyederhanakan penggunaan fitur konkurensi yang kompleks. Untuk kasus penggunaan umum seperti mengurai file besar atau melakukan komputasi intensif CPU yang hanya perlu dilakukan sekali, Isolate.run() mengurangi boilerplate yang terkait dengan manajemen port dan isolate secara manual. Ini membuat kekuatan isolates dapat diakses oleh pengembang dengan kurva pembelajaran yang minimal, memungkinkan mereka untuk dengan mudah mengoptimalkan kinerja aplikasi tanpa harus menjadi ahli dalam model konkurensi tingkat rendah.
Isolate Berstate, Jangka Panjang (Isolate.spawn()): Untuk komputasi berulang atau yang perlu mengembalikan banyak nilai dari waktu ke waktu, isolate jangka panjang dapat menawarkan kinerja yang lebih baik dengan menghindari overhead spawning berulang.29 Ini dicapai dengan menggunakan API tingkat rendah seperti Isolate.spawn(), ReceivePort, dan SendPort.29
Keterbatasan Isolates: Penting untuk memahami bahwa isolates Dart tidak berperilaku identik dengan thread di bahasa lain.

Memori Terisolasi: Isolates memiliki bidang global sendiri, memastikan bahwa objek mutable dalam satu isolate hanya dapat diakses oleh isolate tunggal tersebut.29 Jika variabel global mutable (misalnya, configuration) ada, ia disalin sebagai bidang global baru di isolate yang di-spawn. Mutasi apa pun pada variabel ini di isolate yang di-spawn tidak akan memengaruhi variabel asli di isolate utama, bahkan jika objek tersebut diteruskan sebagai pesan.
Dukungan Platform Web: Platform web Dart, termasuk Flutter web, tidak mendukung isolates.29 Untuk menargetkan web, metode compute dapat digunakan; ia menjalankan komputasi pada main thread di web, tetapi membuat thread baru di perangkat mobile.30
Tidak Ada Akses rootBundle atau Metode dart:ui: Semua tugas UI dan kerangka kerja Flutter terikat pada isolate utama. Akibatnya, isolates yang di-spawn tidak dapat mengakses aset menggunakan rootBundle atau melakukan pekerjaan terkait widget atau UI apa pun.30
Pesan Plugin Terbatas: Meskipun platform channel isolate latar belakang memungkinkan isolates untuk mengirim pesan ke platform host (misalnya, Android atau iOS) dan menerima respons, mereka tidak dapat menerima pesan yang tidak diminta (unsolicited messages) dari platform host.30

Pustaka Standar DartDart memiliki serangkaian pustaka inti yang kaya dan menyediakan fungsionalitas esensial untuk banyak tugas pemrograman sehari-hari. Pustaka-pustaka ini dikategorikan berdasarkan platform yang mereka dukung: multi-platform, native, dan web.22
Ikhtisar Pustaka Utama
Pembagian pustaka berdasarkan platform menunjukkan desain modular yang disengaja. Ini memungkinkan Dart untuk menyediakan API yang dioptimalkan untuk lingkungan tertentu (misalnya, I/O sistem file untuk native, API DOM untuk web) tanpa membebani platform lain dengan fungsionalitas yang tidak relevan. Ini juga berarti bahwa pengembang dapat menulis kode yang portable menggunakan pustaka multi-platform dan kemudian menambahkan logika spesifik platform menggunakan pustaka yang ditargetkan, yang merupakan pendekatan yang efisien untuk pengembangan lintas platform di luar Flutter. Strategi ini juga memungkinkan ekosistem Dart untuk berkembang secara terpisah untuk setiap platform.
Berikut adalah tabel yang merangkum pustaka inti Dart dan fungsinya:Tabel: Pustaka Inti Dart dan Fungsinya
PustakaDeskripsi Fungsi UtamaPlatform yang Didukungdart:coreTipe bawaan, koleksi, fungsionalitas intiMulti-platform 22dart:asyncPemrograman asinkron (Future, Stream)Multi-platform 31dart:mathKonstanta & fungsi matematika, generator angka acakMulti-platform 22dart:convertEncoder & decoder (JSON, UTF-8)Multi-platform 22dart:typed_dataDaftar data berukuran tetap (mis. integer 8-byte)Multi-platform 22dart:developerInteraksi alat pengembang (debugger, inspector)Native JIT, JS development compiler 31dart:ioDukungan I/O (file, soket, HTTP)Native (non-web) 22dart:isolatePemrograman konkuren (isolates)Native 31dart:ffiAntarmuka fungsi asing (API C native)Native 31dart:js_interopInterop dengan API web (menggantikan dart:html)Web 7

### Mengimpor dan Membuat Pustaka Kustom

Mengimpor Pustaka: Untuk membuat komponen dalam pustaka tersedia untuk kode, kata kunci import digunakan.22 URI pustaka bawaan Dart menggunakan skema dart:, sementara pustaka lain dapat menggunakan jalur sistem file atau skema package: (yang umum untuk pustaka dari manajer paket pub).22
Impor Selektif: Pengembang dapat secara selektif mengimpor bagian-bagian tertentu dari pustaka menggunakan kata kunci show (untuk hanya mengimpor komponen yang ditentukan) atau hide (untuk mengimpor semua kecuali yang ditentukan).22
Prefix Pustaka: Jika ada konflik pengidentifikasi dari dua pustaka yang diimpor (misalnya, dua fungsi dengan nama yang sama), kata kunci as dapat digunakan untuk menentukan prefix untuk salah satu atau kedua pustaka, menghindari tabrakan nama.22
Membuat Pustaka Kustom: Dart memungkinkan pengembang untuk membuat pustaka kustom mereka sendiri. Proses ini melibatkan deklarasi pustaka secara eksplisit menggunakan pernyataan library dan kemudian mengasosiasikannya dengan file Dart lain melalui pernyataan import.22

Manajemen Paket Dart (Pub)pub adalah manajer paket resmi untuk Dart, yang berfungsi untuk mendapatkan dan mengelola paket (kumpulan pustaka dan alat) yang dibagikan dalam ekosistem Dart.32

### pubspec.yaml dan Dependensi

pubspec.yaml: Ini adalah file metadata yang terletak di direktori teratas aplikasi Dart. File ini mencantumkan dependensi paket yang dibutuhkan oleh proyek serta metadata lainnya, seperti nomor versi.32 Minimal, file pubspec.yaml hanya perlu mencantumkan nama paket.32
Dependensi: Paket yang dibutuhkan dapat di-host di situs pub.dev, dimuat dari sistem file lokal, atau diambil dari repositori Git.32 pub secara cerdas mengelola dependensi versi, memastikan bahwa versi paket yang diunduh kompatibel satu sama lain dan juga dengan versi SDK Dart yang digunakan.32 Perintah dart pub add dapat digunakan untuk menambahkan dependensi baru ke pubspec.yaml tanpa perlu mengedit file secara manual.32

### Perintah dart pub

dart pub get: Perintah ini mengidentifikasi semua paket yang bergantung pada aplikasi dan menempatkannya di cache sistem pusat.32 Jika dependensi adalah paket yang dipublikasikan, pub akan mengunduhnya dari pub.dev. Untuk dependensi Git, pub akan mengkloning repositori Git.32 Perintah ini juga secara otomatis menyertakan dependensi transitif (yaitu, dependensi dari dependensi Anda).32 pub kemudian membuat file package_config.json yang memetakan setiap nama paket yang diandalkan aplikasi ke lokasi paket yang sesuai di cache sistem.32
dart pub upgrade: Perintah ini memperbarui dependensi ke versi terbaru yang tersedia yang kompatibel dengan batasan versi yang ditentukan dalam pubspec.yaml dan meregenerasi lockfile.32 Pengembang juga dapat memilih untuk meng-upgrade hanya satu dependensi tertentu dengan menentukan namanya.32
dart pub search: Digunakan untuk menelusuri koleksi paket yang tersedia di pub.dev.33
dart pub outdated: Mengidentifikasi paket yang sudah usang yang mungkin memerlukan pengeditan pubspec.yaml untuk mengizinkan versi yang lebih baru.32
dart pub publish: Digunakan oleh pengembang untuk mempublikasikan paket mereka ke komunitas melalui pub.dev.33

### File pubspec.lock

File pubspec.lock dibuat secara otomatis oleh pub dan disimpan di samping pubspec.yaml.32
File ini mencantumkan versi pasti dari semua dependensi (baik langsung maupun transitif) yang digunakan oleh paket.32
Untuk paket aplikasi, file pubspec.lock harus di-commit ke kontrol sumber.32 Ini adalah fitur kritis untuk memastikan build yang dapat direproduksi dan lingkungan pengembangan yang stabil. Tanpa lockfile, dart pub get mungkin mengunduh versi dependensi yang lebih baru (jika pubspec.yaml menggunakan batasan versi yang longgar seperti ^), yang dapat menyebabkan bug yang tidak terduga atau perilaku yang tidak konsisten antar lingkungan (pengembang yang berbeda, CI/CD, produksi). Dengan mengunci versi, pubspec.lock menjamin bahwa setiap build akan menggunakan dependensi yang sama persis, yang sangat penting untuk debugging, pengujian, dan penyebaran yang andal. Hal ini mengurangi risiko "works on my machine" bug dan memfasilitasi kolaborasi tim yang lebih mulus, serta meningkatkan kepercayaan pada proses deployment karena lingkungan produksi akan mencerminkan lingkungan pengembangan dan pengujian dengan tepat.

Alat Pengembangan Dart (CLI)Alat dart (bin/dart) berfungsi sebagai antarmuka baris perintah utama untuk Dart SDK. Alat ini tersedia bagi pengembang terlepas dari apakah mereka mengunduh Dart SDK secara eksplisit atau hanya Flutter SDK.5 Konsolidasi semua alat pengembangan utama di bawah satu perintah dart adalah keputusan desain yang sangat berorientasi pada pengembang. Ini menyederhanakan alur kerja, mengurangi cognitive load untuk mengingat berbagai nama perintah, dan menciptakan pengalaman yang lebih konsisten. Ini menunjukkan bahwa Dart bertujuan untuk menyediakan ekosistem pengembangan yang terpadu dan efisien, dari pembuatan proyek hingga pengujian dan penyebaran, yang pada gilirannya berkontribusi pada peningkatan produktivitas pengembang dan memfasilitasi otomatisasi tugas-tugas pengembangan dalam skrip CI/CD.
Antarmuka Baris Perintah dart
Berikut adalah daftar perintah CLI dart utama dan fungsinya:
Tabel: Perintah CLI dart Utama
PerintahDeskripsiContoh PenggunaananalyzeMenganalisis kode sumber Dart proyek.dart analyze lib/ 5compileMengompilasi Dart ke berbagai format (mis. exe untuk eksekusi native). Menggantikan dart2js dan dart2native.dart compile exe bin/main.dart 5createMembuat proyek Dart baru.dart create my_app 5docMenghasilkan dokumentasi referensi API. Menggantikan dartdoc.dart doc lib/ 5fixMenerapkan perbaikan otomatis ke kode sumber Dart.dart fix lib/main.dart 5formatMemformat kode sumber Dart untuk memastikan gaya yang konsisten.dart format lib/ 5infoMengeluarkan informasi diagnostik terkait alat Dart.dart info 5pubBekerja dengan paket (mis. get, upgrade). Menggantikan perintah pub mandiri.dart pub get 5runMenjalankan program Dart. Ini adalah cara yang disukai untuk menjalankan program Dart.dart run bin/script.dart 5testMenjalankan tes dalam paket. Menggantikan pub run test.dart test test/unit_test.dart 5

### I/O Standar (stdin, stdout, stderr)

Untuk menulis aplikasi command-line di Dart, pengembang terutama menggunakan pustaka dart:io untuk operasi input/output.6
stdout (Standard Output): Digunakan untuk menulis output reguler ke konsol.6 Metode stdout.write() dan stdout.writeln() digunakan untuk mencetak objek, mengubahnya menjadi string.6
stderr (Standard Error): Digunakan khusus untuk menulis pesan kesalahan ke konsol. Meskipun outputnya muncul di konsol, ia terpisah dari stdout dan dapat dialihkan.6
stdin (Standard Input): Biasanya membaca data secara sinkron dari keyboard, tetapi juga dapat membaca secara asinkron atau menerima input yang di-pipe dari program lain.6 Metode stdin.readLineSync() membaca satu baris teks, memblokir eksekusi hingga input diterima.6

### Parsing Argumen Baris Perintah

package:args menyediakan dukungan yang kuat untuk mengurai argumen baris perintah menjadi opsi, flag, dan nilai tambahan.6
Kelas ArgParser digunakan untuk mendefinisikan argumen yang diharapkan, sedangkan objek ArgResults menyimpan hasil setelah penguraian argumen.6

Kompilasi dan VM DartArsitektur kompiler Dart dirancang untuk mendukung berbagai metode eksekusi kode di berbagai platform, termasuk lingkungan native (untuk desktop dan mobile) dan web.2

### Arsitektur Dart VM

Dart Virtual Machine (VM) menyediakan lingkungan eksekusi yang dikenal sebagai "isolated Dart universe".2 Lingkungan ini memiliki beberapa properti kunci:

Heap: Dikelola oleh garbage collector yang mengontrol alokasi memori untuk setiap item yang ditetapkan oleh kode yang berjalan.2
Isolate: Unit komputasi independen dalam Dart VM yang memungkinkan eksekusi konkuren dan paralel.2 Isolates dalam grup yang sama berbagi heap yang sama dan program Dart yang sama. Untuk berkomunikasi, isolates harus mengirim pesan melalui port karena mereka tidak dapat secara langsung berbagi keadaan mutable.2
Mutator Thread: Sebuah thread yang menjalankan program Dart menggunakan API C publik dari mesin virtual. Sebuah isolate hanya dapat memiliki satu mutator thread yang terhubung padanya pada satu waktu.2

Common Front-End (CFE), yang dikembangkan dalam Dart, bertanggung jawab untuk mengubah kode sumber menjadi Kernel AST (Abstract Syntax Tree), yang kemudian dieksekusi oleh mesin virtual.2

Mode Operasi Dart VM (JIT, AOT)Dart VM memiliki dua mode operasi utama yang menentukan bagaimana kode dikompilasi dan dieksekusi:

JIT (Just-In-Time) mode: Dalam mode JIT, Dart VM dapat secara dinamis mengimpor kode sumber Dart, menguraikannya, dan segera mengompilasinya menjadi kode mesin native yang dapat dieksekusi.2

Keunggulan: Mode JIT memungkinkan siklus pengembangan dan pengujian yang lebih cepat karena pengembang dapat melihat perubahan kode secara instan tanpa harus me-restart seluruh aplikasi (fitur hot reload).34 Ini juga meningkatkan pengalaman debugging dan mendukung rekompilasi inkremental, di mana hanya kode yang dibutuhkan yang dikompilasi.2
Penggunaan: Mode JIT adalah mode default untuk pengembangan/debug dan ideal untuk pengembang yang sedang dalam proses menulis dan menguji aplikasi mereka.34 Namun, mode ini tidak direkomendasikan untuk proses produksi karena overhead kompilasi runtime.2

AOT (Ahead-Of-Time) mode: Dalam mode AOT, kode dikompilasi sepenuhnya sebelum aplikasi dieksekusi.2 Dart VM dalam mode AOT tidak mendukung pemuatan dinamis, penguraian, atau perakitan kode sumber Dart; ia hanya dapat mengimpor dan menjalankan kode mesin yang telah dikompilasi sebelumnya.2

Keunggulan: Kode yang dikompilasi AOT berjalan lebih cepat karena menghilangkan overhead kompilasi runtime.34 Ini menghasilkan kinerja aplikasi yang lebih baik, ukuran aplikasi yang lebih kecil, dan manfaat keamanan karena kode native lebih sulit untuk direkayasa balik.34
Penggunaan: Mode AOT ideal untuk menyebarkan aplikasi ke produksi, memberikan pengalaman pengguna yang mulus, cepat, dan andal.34 Ini digunakan dalam mode profile (untuk profiling kinerja) dan mode release (untuk versi final aplikasi).34 Karena memerlukan kompilasi ulang seluruh kode dari awal, mode AOT tidak cocok untuk fase pengembangan.2

Kolaborasi JIT dan AOT: Kombinasi JIT dan AOT menawarkan yang terbaik dari kedua dunia: JIT mempercepat iterasi selama pengembangan dengan fitur seperti hot reload, sementara AOT memastikan aplikasi dioptimalkan untuk kinerja, ukuran, dan keamanan selama penyebaran.35

Pengembangan Sisi Server dengan DartDart telah memperluas kapabilitasnya secara signifikan ke ranah pengembangan sisi server, menawarkan berbagai kerangka kerja dan teknologi yang memungkinkan pengembang membangun backend yang efisien dan skalabel.

### Kerangka Kerja dan Teknologi

Shelf: Ini adalah kerangka kerja web yang minimal, modular, dan adaptif untuk Dart, yang dikelola oleh tim Flutter. Shelf dirancang untuk dapat diperluas, dengan aplikasi yang dibangun dari urutan handler dan middleware. Handler memproses permintaan dan mengembalikan respons, sementara middleware membungkus handler untuk menambahkan fungsionalitas tambahan.3 Shelf memiliki ekosistem plugin yang kaya, termasuk shelf_router (untuk perutean), shelf_static (untuk melayani file statis), shelf_web_socket (untuk WebSockets), dan shelf_hotreload (untuk hot reload di sisi server).3
DartFrog: Dibangun oleh Very Good Ventures, DartFrog adalah kerangka kerja yang membungkus shelf dan mengintegrasikan mason (alat untuk membuat dan mengonsumsi templat kode yang dapat digunakan kembali). DartFrog berfokus pada pengoptimalan proses pembangunan backend yang mengagregasi, mengkomposisikan, dan menormalisasi data dari berbagai sumber.3 Fitur-fiturnya meliputi injeksi dependensi bawaan, hot reload, dukungan file statis dan WebSocket, integrasi DevTools dan plugin VS Code, serta dukungan Docker.3
Alfred: Dirancang sebagai kerangka kerja yang sederhana dan mudah digunakan, Alfred memungkinkan pengembang untuk berkonsentrasi pada logika aplikasi tanpa boilerplate yang berlebihan. Ia dikenal dengan sintaksnya yang mirip express.js, yang familiar bagi pengembang dengan latar belakang Node.js.3 Alfred menawarkan perutean sederhana dengan parameter rute dan body parsing, middleware untuk otentikasi dan penanganan kesalahan, penyajian file statis, unggah/unduh file, dukungan WebSocket, dan dukungan multiple Isolates.3
gRPC Dart: Ini adalah implementasi Dart dari gRPC, sebuah kerangka kerja RPC (Remote Procedure Call) berkinerja tinggi yang dioptimalkan untuk transfer data yang efisien, dengan fokus pada mobile dan HTTP/2. gRPC Dart dibangun dan dikelola oleh tim Dart.3
Kerangka Kerja Lain: Ekosistem Dart sisi server juga mencakup kerangka kerja seperti Conduit (kelanjutan dari Aqueduct, fokus pada REST API), Angel3 (fork dari Angel yang diarsipkan, mendukung null safety), Dartness (terinspirasi oleh Spring Boot dan Nest.js), dan Pharaoh (kerangka kerja lain yang terinspirasi Express.js yang kompatibel dengan middleware shelf).3

Contoh Implementasi REST API (CRUD)Pengembangan sisi server di Dart seringkali melibatkan pembangunan API RESTful untuk operasi CRUD (Create, Read, Update, Delete). Menggunakan kerangka kerja seperti Shelf, proses ini dapat diilustrasikan dengan sumber daya Users.4

Konfigurasi Router: Sebuah instansi Router digunakan untuk mengelola dan mengarahkan permintaan HTTP ke handler yang berbeda berdasarkan pola URL.4
Request Handlers: Fungsi-fungsi ini memproses permintaan HTTP yang masuk dan mengembalikan respons.4 Contohnya termasuk getUsers (mengambil daftar pengguna), getUserById (mengambil pengguna tunggal berdasarkan ID), addUser (membuat pengguna baru), updateUser (memodifikasi pengguna yang ada), dan deleteUser (menghapus pengguna).4
Middleware: Shelf memungkinkan penggunaan middleware untuk mencegat dan memproses permintaan dan respons, misalnya, untuk logging permintaan masuk.4
Fungsi Utama Server: Fungsi main menginisialisasi server, mengikat handler ke alamat IP dan port tertentu, dan memulai mendengarkan permintaan.4

Melayani HTML dari Backend DartSelain API RESTful, backend Dart juga dapat melayani konten HTML secara langsung. Ini melibatkan pendefinisian konten HTML sebagai variabel string dan kemudian membuat handler rute yang mengembalikan respons dengan header Content-Type yang disetel ke text/html.4

Pengembangan Web Tanpa FlutterMeskipun Dart seringkali diasosiasikan erat dengan Flutter, ada opsi yang berkembang untuk pengembangan web menggunakan Dart secara independen. Ini memungkinkan pengembang untuk memanfaatkan kekuatan Dart untuk aplikasi web tanpa ketergantungan pada kerangka kerja UI Flutter.

package:web Menggantikan dart:html

package:web adalah solusi jangka panjang yang dirancang untuk menggantikan pustaka dart:html dan pustaka web Dart SDK lainnya sebagai solusi interoperabilitas web.7 Pustaka ini menyediakan akses ke API browser, memungkinkan aplikasi Dart untuk berinteraksi dengan web dan memanipulasi objek serta elemen dalam DOM (Document Object Model).7
Pengembangan package:web mengatasi beberapa masalah dengan pustaka web Dart yang ada:

Kompatibilitas Wasm: package:web dibangun di atas dart:js_interop, yang mendukung kompilasi ke WebAssembly (Wasm), sebuah target yang tidak didukung oleh pustaka web Dart inti yang lebih lama seperti dart:html dan dart:svg.7
Modernitas: package:web menggunakan Web IDL (Interface Definition Language) untuk secara otomatis menghasilkan anggota interop dan tipe interop untuk setiap deklarasi dalam IDL. Pendekatan ini menghasilkan API yang lebih ringkas, mudah dipahami, konsisten, dan mampu tetap up-to-date dengan perkembangan web di masa depan.7
Versioning: Karena package:web adalah sebuah paket, ia dapat di-versioning lebih mudah daripada pustaka inti seperti dart:html, sehingga menghindari breaking changes pada kode pengguna seiring evolusinya. Ini juga membuat kode lebih terbuka untuk kontribusi.7

Proses Migrasi: Migrasi dari dart:html ke package:web melibatkan perubahan impor, penambahan dependensi web ke pubspec.yaml, penyesuaian nama simbol (banyak yang diselaraskan dengan nama Web IDL asli), penanganan perbedaan dalam uji tipe dan tanda tangan tipe, serta pembaruan impor kondisional (dart.library.html diganti dengan dart.library.js_interop).7

### Kerangka Kerja Alternatif

Jaspr: Ini adalah salah satu kerangka kerja yang memungkinkan pengembangan web menggunakan Dart secara independen dari Flutter. Jaspr dirancang dengan pendekatan yang mirip dengan Flutter tetapi menghasilkan HTML, CSS, dan JavaScript, menjadikannya cocok untuk aplikasi web.36
Penulisan Ulang Besar Dukungan Web: Dart sedang dalam proses meluncurkan penulisan ulang besar-besaran dukungan web-nya. Secara historis, dukungan web Dart digambarkan sebagai "canggung dan aneh." Namun, penulisan ulang yang akan datang bertujuan untuk memungkinkan pengembang menggunakan API Web yang sama persis yang sudah mereka kenal, tetapi dengan manfaat tambahan dari keamanan tipe Dart. Dukungan web baru ini diharapkan memberikan jaminan keamanan tipe yang jauh lebih baik daripada yang ditawarkan TypeScript.36

### Kesimpulan

Dart adalah bahasa pemrograman yang dirancang dengan cermat untuk berbagai kebutuhan pengembangan, melampaui asosiasinya yang kuat dengan Flutter. Analisis menunjukkan bahwa Dart adalah bahasa yang berorientasi objek dengan sistem tipe statis yang kuat namun fleksibel, didukung oleh inferensi tipe yang mengurangi boilerplate kode. Prinsip "segala sesuatu adalah objek" menciptakan konsistensi fundamental yang menyederhanakan API dan memungkinkan fitur-fitur canggih seperti fungsi kelas pertama.Pendekatan unik Dart terhadap enkapsulasi, yang berbasis pada visibilitas pustaka melalui konvensi garis bawah (\_), mempromosikan modularitas yang bersih dan menyederhanakan pemeliharaan kode dalam konteks organisasi file. Selain itu, penggunaan mixin-based inheritance memberikan fleksibilitas desain yang signifikan, memungkinkan reusabilitas kode horizontal dan mengatasi keterbatasan model inheritansi tradisional.Dalam hal konkurensi, model isolate Dart adalah fitur yang menonjol. Dengan memisahkan memori antar isolate dan mengandalkan pengiriman pesan, Dart secara intrinsik mencegah data races dan menyederhanakan penulisan kode konkuren yang aman. Abstraksi seperti Isolate.run() lebih lanjut membuat konkurensi dapat diakses oleh pengembang, mendorong praktik terbaik untuk kinerja aplikasi yang responsif.Ekosistem Dart diperkaya oleh pustaka standar yang komprehensif, dikategorikan berdasarkan dukungan multi-platform, native, dan web, yang mencerminkan strategi modular yang disengaja. Manajer paket pub dengan pubspec.lock-nya memastikan reproduksibilitas build dan stabilitas lingkungan pengembangan, yang sangat penting untuk kolaborasi tim dan penyebaran yang andal.Terakhir, alat command-line Dart yang terintegrasi (seperti dart analyze, compile, run, test) menyediakan alur kerja pengembangan yang efisien dan terpadu. Fitur seperti assert yang hanya aktif dalam mode pengembangan menunjukkan komitmen Dart untuk menyediakan alat debugging yang kuat tanpa mengorbankan kinerja produksi.Secara keseluruhan, Dart adalah bahasa yang tangguh dan serbaguna, cocok tidak hanya untuk pengembangan UI tetapi juga untuk membangun aplikasi sisi server, command-line, dan web yang efisien, aman, dan mudah dipelihara. Desainnya yang berorientasi pada pengembang, dikombinasikan dengan ekosistem alat yang kuat, memposisikan Dart sebagai pilihan yang menarik untuk berbagai proyek perangkat lunak.

**[Kembali][1]**

[1]:../README.md