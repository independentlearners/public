# QML

<details>
  <summary>JavaScript dalam QML Qt 6</summary>

# Kurikulum JavaScript dalam QML Qt 6 — Dasar hingga Expert

Kurikulum ini dirancang khusus untuk memahami, membaca, menulis, menganalisis, men-debug, dan mengembangkan seluruh logika JavaScript yang digunakan di dalam lingkungan QML Qt 6.

Batas pembelajaran: ini bukan kurikulum JavaScript umum. Kita tidak akan mempelajari JavaScript untuk browser, Node.js, frontend web, atau pengembangan aplikasi web. Kita hanya mempelajari bagian bahasa JavaScript, objek, API, mekanisme eksekusi, dan integrasi yang benar-benar relevan dengan QML.

Ada satu prinsip penting: JavaScript dalam QML bukan bahasa pemrograman yang sepenuhnya berbeda, tetapi JavaScript yang dijalankan dalam lingkungan QML dengan aturan, objek bawaan, batasan, dan integrasi khusus dari Qt. Karena itu, kita perlu memahami dua hal sekaligus:

1. Sintaks dan perilaku JavaScript yang memang digunakan oleh QML.
2. Cara Qt QML menjalankan, membatasi, dan menghubungkan JavaScript dengan objek serta sistem deklaratif QML.

Kurikulum ini disusun agar setelah menyelesaikannya, kode JavaScript dalam dokumen QML, file `.js`, signal handler, property binding, komponen, dan integrasi C++ tidak lagi menjadi bagian yang membingungkan ketika mempelajari QML.

## 1. Identitas dan batas teknis JavaScript dalam QML

| Aspek          | Penjelasan                                                                                                          |
| -------------- | ------------------------------------------------------------------------------------------------------------------- |
| Nama           | JavaScript in QML / QML JavaScript Environment                                                                      |
| Platform       | Qt 6 — Qt QML                                                                                                       |
| Mesin eksekusi | JavaScript engine yang disediakan Qt QML                                                                            |
| Standar bahasa | Berbasis ECMAScript; dokumentasi Qt 6.10 menyebut implementasi ECMAScript edisi ke-7 dengan sejumlah fitur tambahan |
| Fungsi utama   | Logika UI, perhitungan, manipulasi data, event handling, interaksi objek QML                                        |
| Lokasi kode    | Inline di `.qml`, file `.js`, dan ECMAScript module `.mjs` yang didukung                                            |
| Integrasi      | QML Object Model, Qt APIs, dan objek C++ yang diekspos ke QML                                                       |
| Implementasi   | Qt ditulis terutama dalam C++; mesin JavaScript dan lapisan QML merupakan bagian dari ekosistem Qt                  |

Sumber utama: dokumentasi resmi [JavaScript Host Environment](https://doc.qt.io/qt-6.10/qtqml-javascript-hostenvironment.html?utm_source=chatgpt.com) dan [Integrating QML and JavaScript](https://doc.qt.io/qt-6.10/qtqml-javascript-topic.html?utm_source=chatgpt.com).

### Apa yang tidak perlu dipelajari?

Kurikulum ini sengaja tidak memasukkan topik yang tidak menjadi bagian dari kebutuhan JavaScript dalam QML:

- DOM, `document`, `window`, dan manipulasi elemen HTML.
- CSSOM dan browser rendering.
- React, Vue, Angular, dan framework frontend.
- Node.js, npm, Express, dan backend JavaScript.
- Browser event API seperti `addEventListener()` sebagai mekanisme utama UI.
- Web Storage seperti `localStorage` dan `sessionStorage`.
- Service Worker, Web Worker, dan browser-specific API.
- Build tools JavaScript web seperti Vite dan Webpack.

Namun, beberapa konsep JavaScript umum tetap wajib dipahami karena memang digunakan di QML: variabel, tipe data, fungsi, objek, array, kondisi, perulangan, scope, closure, dan error handling.

### Perbedaan penting yang wajib dipahami

| Konsep             | JavaScript browser                           | JavaScript QML                                         |
| ------------------ | -------------------------------------------- | ------------------------------------------------------ |
| Global UI object   | `window`                                     | Tidak tersedia sebagai objek browser                   |
| DOM                | Tersedia                                     | Tidak tersedia                                         |
| UI event           | DOM event                                    | Signal dan signal handler QML                          |
| UI state           | Biasanya dikelola melalui framework atau DOM | QML properties dan object state                        |
| Reactive update    | Bergantung pada framework                    | Property binding bawaan QML                            |
| Timer              | Browser timer API                            | QML `Timer`                                            |
| HTTP               | `fetch()` dan XHR                            | API Qt Network atau `XMLHttpRequest` yang didukung QML |
| UI component       | HTML element/framework                       | QML object dan component                               |
| Module             | ECMAScript modules                           | QML imports, JavaScript resources, dan `.mjs`          |
| Native integration | Bergantung pada browser API                  | QObject, Qt meta-object, dan C++                       |

Jangan menyamakan lingkungan browser dengan QML. Dokumentasi Qt secara eksplisit menjelaskan bahwa host environment QML berbeda dari browser maupun Node.js.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://doc.qt.io\&sz=32)

Qt 6.10.3+2



## 2. Struktur kurikulum

20 fase · 100+ kelompok materi · estimasi 12–18 minggu dengan 2–4 jam belajar per hari

| Tahap | Fokus                                         | Tingkat         |
| ----- | --------------------------------------------- | --------------- |
| 0     | Orientasi JavaScript QML                      | Fondasi         |
| 1     | Sintaks JavaScript yang digunakan QML         | Pemula          |
| 2     | Variabel, tipe data, dan konversi             | Pemula          |
| 3     | Operator dan ekspresi                         | Pemula          |
| 4     | Kondisi dan perulangan                        | Pemula          |
| 5     | Fungsi dan pemanggilan fungsi                 | Pemula–Menengah |
| 6     | Array dan manipulasi koleksi                  | Menengah        |
| 7     | Object dan manipulasi data                    | Menengah        |
| 8     | Scope, closure, dan resolusi nama             | Menengah        |
| 9     | JavaScript di dalam dokumen QML               | Menengah        |
| 10    | QML global object dan API JavaScript          | Menengah        |
| 11    | Property binding dan ekspresi deklaratif      | Menengah–Lanjut |
| 12    | Signal, handler, dan event-driven logic       | Menengah–Lanjut |
| 13    | JavaScript resources dan modularisasi         | Lanjut          |
| 14    | QML data types dan konversi nilai             | Lanjut          |
| 15    | Asynchronous dan pemrosesan berbasis event    | Lanjut          |
| 16    | Interaksi JavaScript dengan Qt dan C++        | Lanjut–Expert   |
| 17    | Object lifecycle dan memory management        | Expert          |
| 18    | Debugging, analisis, dan optimasi             | Expert          |
| 19    | Arsitektur dan rekayasa logika JavaScript QML | Expert          |

Setiap fase di bawah menjelaskan tujuan, materi, sintaks yang harus dikenali, dan hasil kompetensi yang harus dicapai.

## Fase 0 — Orientasi JavaScript dalam lingkungan QML

Tujuan: memahami di mana JavaScript berada, bagaimana kode dijalankan, dan apa hubungannya dengan QML.

Materi:

1. Identitas JavaScript dalam Qt QML.
2. Hubungan ECMAScript, JavaScript engine, Qt QML, dan QML language.
3. Perbedaan JavaScript inline dan JavaScript resource.
4. Perbedaan kode deklaratif QML dengan kode imperatif JavaScript.
5. Bagian dokumen QML yang menerima ekspresi JavaScript.
6. Bagian dokumen QML yang menerima deklarasi fungsi JavaScript.
7. Perbedaan `.qml`, `.js`, dan `.mjs`.
8. Cara JavaScript mengakses QML object.
9. Cara QML memanggil fungsi JavaScript.
10. Cara JavaScript membaca dan mengubah QML property.
11. Perbedaan JavaScript dalam QML dengan JavaScript browser.
12. Perbedaan JavaScript dalam QML dengan JavaScript Node.js.

Contoh struktur:

```
import QtQuick

Item {
    id: root

    property int counter: 0

    function increment() {
        counter += 1
    }

    Component.onCompleted: {
        increment()
        console.log(counter)
    }
}
```

Pahami setiap bagian:

- `Item`: tipe objek QML.
- `id`: identitas objek dalam scope QML.
- `property int`: deklarasi property bertipe integer.
- `function`: deklarasi fungsi JavaScript pada objek QML.
- `counter += 1`: operasi JavaScript yang mengubah property QML.
- `Component.onCompleted`: signal handler yang dijalankan setelah komponen selesai dibuat.
- `console.log()`: fungsi logging dari lingkungan JavaScript QML.

Kompetensi akhir: dapat membedakan kode QML dan JavaScript, serta mengetahui bagian mana yang sedang dibaca ketika menemukan kode campuran.

Referensi: [JavaScript Expressions in QML Documents](https://doc.qt.io/qt-6.10/qtqml-javascript-expressions.html?utm_source=chatgpt.com).

## Fase 1 — Sintaks JavaScript yang berlaku dalam QML

Tujuan: dapat membaca seluruh bentuk sintaks dasar JavaScript yang lazim ditemukan dalam kode QML.

Materi:

1. Statement dan expression.
2. Statement terminator `;`.
3. Code block `{}`.
4. Komentar satu baris `//`.
5. Komentar banyak baris `/* ... */`.
6. Identifier dan aturan penamaan.
7. Keyword dan reserved words.
8. Case sensitivity.
9. Literal dan nilai literal.
10. Parentheses dan grouping.
11. Operator precedence.
12. Associativity.
13. Semicolon behavior dan automatic semicolon insertion.
14. Nested expression.
15. Nested function call.
16. Object literal dan array literal.
17. Destructuring syntax.
18. Spread syntax.
19. Template literal.
20. Conditional expression.

Contoh:

```
const result = (10 + 5) * 2;

const message = `Total: ${result}`;

const settings = {
    enabled: true,
    volume: 80
};

const { enabled, volume } = settings;
```

Istilah yang harus dikuasai:

| Istilah          | Makna                                              |
| ---------------- | -------------------------------------------------- |
| Statement        | Instruksi yang dijalankan                          |
| Expression       | Ekspresi yang menghasilkan nilai                   |
| Literal          | Nilai yang ditulis secara langsung                 |
| Identifier       | Nama variabel, fungsi, atau property               |
| Scope            | Wilayah tempat identifier dapat diakses            |
| Block            | Sekumpulan statement di dalam `{}`                 |
| Destructuring    | Mengambil nilai dari array/object ke variabel      |
| Spread           | Mengembangkan elemen iterable atau property object |
| Template literal | String yang mendukung interpolasi ekspresi         |

Kompetensi akhir: mampu membaca sintaks JavaScript tanpa harus menebak fungsi tanda baca, struktur blok, atau susunan ekspresi.

## Fase 2 — Variabel, tipe data, dan konversi nilai

Tujuan: memahami bagaimana JavaScript menyimpan dan memperlakukan nilai ketika bekerja dengan property dan object QML.

### 2.1 Deklarasi variabel

- `var`.
- `let`.
- `const`.
- Perbedaan function scope dan block scope.
- Reassignment.
- Redeclaration.
- Variable initialization.
- Temporal Dead Zone secara konseptual.
- Mengapa variabel harus dideklarasikan secara eksplisit dalam QML.

Contoh:

```
let count = 10;
count = 20;

const maximum = 100;
```

Catatan penting: `const` mencegah binding variabel diarahkan ulang, tetapi tidak otomatis membuat isi object atau array menjadi immutable.

### 2.2 Primitive data types

- Number.
- String.
- Boolean.
- `null`.
- `undefined`.
- Symbol dan BigInt sebagai konsep yang perlu dikenali, bukan prioritas penggunaan.
- Perbedaan nilai primitive dan object.

### 2.3 Number dan operasi numerik

- Integer dan floating-point.
- Bilangan negatif.
- Decimal.
- `NaN`.
- `Infinity`.
- `-Infinity`.
- Pembulatan.
- Presisi floating-point.
- Pembagian dan modulo.
- Konversi numerik.

Contoh:

```
const width = 1920;
const ratio = width / 2;
const remainder = 10 % 3;
```

### 2.4 String

- String literal.
- Single quote dan double quote.
- Template literal.
- String interpolation.
- Concatenation.
- Escape characters.
- String length.
- Character access.
- `includes()`.
- `startsWith()`.
- `endsWith()`.
- `indexOf()`.
- `slice()`.
- `substring()`.
- `replace()`.
- `split()`.
- `trim()`.
- `toUpperCase()`.
- `toLowerCase()`.

### 2.5 Boolean dan truthiness

- `true` dan `false`.
- Truthy values.
- Falsy values.
- Boolean conversion.
- Logical evaluation.
- Short-circuit evaluation.

### 2.6 Null dan undefined

- Perbedaan `null` dan `undefined`.
- Property yang belum diinisialisasi.
- Property yang tidak ditemukan.
- Pemeriksaan keberadaan nilai.
- Default value.
- Nullish coalescing `??`.
- Optional chaining `?.`.

### 2.7 Type conversion

- Implicit conversion.
- Explicit conversion.
- `Number()`.
- `String()`.
- `Boolean()`.
- `parseInt()`.
- `parseFloat()`.
- `typeof`.
- `instanceof`.
- Perbandingan nilai dengan tipe berbeda.

### 2.8 Konversi JavaScript dan QML

- JavaScript `number` dengan QML `int` dan `real`.
- JavaScript `string` dengan QML `string`.
- JavaScript `boolean` dengan QML `bool`.
- JavaScript `Date` dengan QML `date`.
- Konversi `QVariant`.
- Nilai `undefined` dan `null` dalam interaksi QML.
- Dampak konversi terhadap fungsi dan property.

Kompetensi akhir: dapat memahami tipe nilai, melakukan konversi yang tepat, dan menghindari bug akibat perbedaan tipe.

Referensi: [Data Type Conversion Between QML and C++](https://doc.qt.io/qt-6/qtqml-cppintegration-data.html?utm_source=chatgpt.com).

## Fase 3 — Operator dan ekspresi

Tujuan: memahami seluruh operasi yang digunakan untuk menghitung, membandingkan, menggabungkan, dan mengendalikan nilai.

Materi:

1. Arithmetic operators: `+`, `-`, `*`, `/`, `%`, `**`.
2. Assignment operators: `=`, `+=`, `-=`, `*=`, `/=`.
3. Comparison operators: `==`, `===`, `!=`, `!==`, `>`, `<`, `>=`, `<=`.
4. Logical operators: `&&`, `||`, `!`.
5. Nullish coalescing: `??`.
6. Optional chaining: `?.`.
7. Conditional operator: `?:`.
8. Unary operators.
9. Increment dan decrement: `++`, `--`.
10. String concatenation.
11. `typeof`.
12. `instanceof`.
13. Operator precedence.
14. Short-circuit evaluation.
15. Assignment dalam ekspresi.
16. Perbedaan equality dan strict equality.
17. Ekspresi bersarang.
18. Evaluasi ekspresi yang menghasilkan nilai.
19. Efek samping dalam ekspresi.
20. Ekspresi yang digunakan dalam QML property binding.

Contoh:

```
Item {
    property int widthValue: 500
    property int heightValue: 300

    property bool isLandscape:
        widthValue > heightValue

    property string orientation:
        isLandscape ? "Landscape" : "Portrait"
}
```

Kompetensi akhir: mampu membaca ekspresi kompleks dan memahami urutan evaluasinya.

## Fase 4 — Kondisi dan perulangan

Tujuan: menguasai alur eksekusi logika yang digunakan untuk memproses data dan menentukan perilaku UI.

### 4.1 Conditional statements

- `if`.
- `else`.
- `else if`.
- Nested `if`.
- Conditional operator `?:`.
- `switch`.
- `case`.
- `break`.
- `default`.

### 4.2 Looping

- `for`.
- `while`.
- `do...while`.
- `for...of`.
- `for...in`.
- Nested loop.
- Infinite loop.
- Loop termination.

### 4.3 Flow control

- `break`.
- `continue`.
- `return`.
- `throw`.
- Early return.
- Guard clause.
- Nested control flow.

### 4.4 Penggunaan dalam QML

- Memilih tampilan berdasarkan nilai property.
- Memproses daftar item.
- Memvalidasi input.
- Menentukan kondisi visibilitas.
- Menghitung jumlah elemen.
- Memproses konfigurasi.
- Mengendalikan state komponen.
- Menghindari loop yang menghambat UI.

Contoh:

```
function getStatus(value) {
    if (value >= 80)
        return "High";

    if (value >= 40)
        return "Medium";

    return "Low";
}
```

Kompetensi akhir: mampu membuat dan membaca logika bercabang maupun perulangan tanpa kebingungan.

## Fase 5 — Fungsi JavaScript dalam QML

Tujuan: memahami fungsi sebagai unit utama logika, pemrosesan, dan komunikasi antarbagian kode.

### 5.1 Function fundamentals

- Function declaration.
- Function expression.
- Arrow function.
- Anonymous function.
- Function invocation.
- Function call.
- Function parameters.
- Arguments.
- Return value.
- Default parameters.
- Rest parameters.
- Parameter passing.
- Function composition.
- Nested function.

### 5.2 Function behavior

- Local variable.
- Function scope.
- Lexical scope.
- Closure.
- Recursive function.
- Callback function.
- Higher-order function.
- Pure function.
- Impure function.
- Side effect.
- Function reference.
- Function execution context.

### 5.3 Fungsi khusus di QML

- Fungsi yang dideklarasikan di dalam objek QML.
- Fungsi yang dipanggil melalui `id`.
- Fungsi yang mengakses property objek pemiliknya.
- Fungsi yang mengakses objek lain melalui `id`.
- Fungsi yang dipanggil dari signal handler.
- Fungsi yang dipanggil dari file `.js`.
- Fungsi yang mengembalikan nilai untuk property.
- Fungsi yang mengubah property.
- Fungsi yang menerima objek QML sebagai parameter.
- Fungsi yang menerima dan mengembalikan data QML.
- Perbedaan fungsi JavaScript biasa dengan method QObject.

Contoh:

```
Item {
    id: root

    property int volume: 50

    function setVolume(value) {
        volume = Math.max(0, Math.min(value, 100));
    }

    Component.onCompleted: {
        setVolume(75);
    }
}
```

### 5.4 Function design

- Pemisahan fungsi berdasarkan tanggung jawab.
- Fungsi kecil dan terfokus.
- Validasi parameter.
- Penanganan nilai kosong.
- Pengembalian data terstruktur.
- Penghindaran duplikasi.
- Penghindaran efek samping yang tidak diperlukan.
- Pemisahan logika perhitungan dan manipulasi UI.

Kompetensi akhir: mampu membaca fungsi JavaScript yang kompleks, memahami sumber data dan hasilnya, serta menyusun fungsi reusable untuk QML.

## Fase 6 — Array dan manipulasi koleksi

Tujuan: memahami pemrosesan daftar data yang sering digunakan untuk model, menu, daftar aplikasi, konfigurasi, dan informasi UI.

### 6.1 Array fundamentals

- Array declaration.
- Array literal.
- Array indexing.
- Array length.
- Nested array.
- Array of objects.
- Multidimensional array.
- Empty array.
- Sparse array secara konseptual.

### 6.2 Array operations

- `push()`.
- `pop()`.
- `shift()`.
- `unshift()`.
- `splice()`.
- `slice()`.
- `concat()`.
- `join()`.
- `includes()`.
- `indexOf()`.
- `find()`.
- `findIndex()`.
- `filter()`.
- `map()`.
- `forEach()`.
- `some()`.
- `every()`.
- `reduce()`.
- `sort()`.
- `reverse()`.

### 6.3 Iteration

- Iterasi menggunakan `for`.
- Iterasi menggunakan `for...of`.
- Iterasi menggunakan `forEach()`.
- Iterasi dengan callback.
- Index dan element.
- Iterasi array objek.
- Nested iteration.

### 6.4 Transformasi data

- Menyaring daftar.
- Mengubah format data.
- Mengurutkan daftar.
- Menggabungkan daftar.
- Menghapus duplikasi.
- Menghitung total.
- Mengelompokkan data.
- Mencari elemen berdasarkan property.
- Membuat salinan array.
- Menghindari mutasi data yang tidak disengaja.

Contoh:

```
const applications = [
    { name: "Terminal", running: true },
    { name: "Editor", running: false },
    { name: "Browser", running: true }
];

const runningApps = applications.filter(
    app => app.running
);

const appNames = runningApps.map(
    app => app.name
);
```

### 6.5 Array dalam QML

- Array JavaScript sebagai property value.
- Array yang disimpan dalam `var` property.
- Array sebagai parameter fungsi.
- Array sebagai return value.
- Array untuk menghasilkan data model.
- Perubahan array dan reaktivitas QML.
- Perbedaan JavaScript Array dengan QML `list<T>`.
- Perbedaan JavaScript Array dengan `QVariantList`.
- Array-like object hasil konversi dari C++.

Kompetensi akhir: dapat memproses koleksi data untuk UI dan memahami batasan reaktivitas ketika array dimodifikasi.

## Fase 7 — Object dan manipulasi data

Tujuan: memahami struktur object yang menjadi dasar representasi data dan konfigurasi dalam JavaScript QML.

### 7.1 Object fundamentals

- Object literal.
- Property.
- Key dan value.
- Property access menggunakan dot notation.
- Property access menggunakan bracket notation.
- Nested object.
- Object method.
- Computed property name.
- Object destructuring.
- Object spread.

### 7.2 Object operations

- Membaca property.
- Menambahkan property.
- Mengubah property.
- Menghapus property.
- Memeriksa property.
- Mengambil keys.
- Mengambil values.
- Mengambil entries.
- Menggabungkan object.
- Menyalin object.
- Shallow copy.
- Deep copy sebagai konsep.
- Object reference.
- Object mutation.

### 7.3 Built-in object yang perlu dikenali

- `Object`.
- `Array`.
- `String`.
- `Number`.
- `Boolean`.
- `Math`.
- `Date`.
- `JSON`.
- `RegExp`.
- `Error`.
- `Map` dan `Set` sebagai konsep serta fitur yang harus diverifikasi terhadap versi Qt yang dipakai.

### 7.4 JSON

- Pengertian JSON.
- JSON object dan JavaScript object.
- `JSON.parse()`.
- `JSON.stringify()`.
- Validasi JSON.
- Error saat parsing.
- Struktur konfigurasi.
- Penyimpanan data konfigurasi.
- Perbedaan data JSON dan object QML.

Contoh:

```
const config = {
    theme: "dark",
    opacity: 0.95,
    panel: {
        visible: true,
        position: "top"
    }
};

const serialized = JSON.stringify(config);
const restored = JSON.parse(serialized);
```

### 7.5 Object dalam QML

- Membuat object JavaScript.
- Menggunakan object sebagai `var` property.
- Mengirim object ke fungsi.
- Mengembalikan object dari fungsi.
- Mengakses property object dari QML.
- Menggunakan object sebagai data komponen.
- Perbedaan object JavaScript dan QML object.
- Perbedaan object JavaScript dan QObject.
- Referensi object QML dari JavaScript.

Kompetensi akhir: mampu membaca dan membangun struktur data yang digunakan oleh komponen QML.

## Fase 8 — Scope, closure, dan resolusi nama

Tujuan: memahami bagaimana JavaScript menemukan variabel, fungsi, dan property ketika kode berada dalam hierarki objek QML.

Ini merupakan fase penting. Banyak kesalahan QML bukan disebabkan sintaks yang salah, melainkan karena identifier tidak ditemukan atau mengarah ke objek yang berbeda dari yang dimaksud.

### 8.1 JavaScript scope

- Global scope.
- Function scope.
- Block scope.
- Lexical scope.
- Local variable.
- Outer scope.
- Scope chain.
- Variable shadowing.
- Name collision.
- Closure.
- Hoisting.
- Temporal Dead Zone.

### 8.2 QML scope

- Document scope.
- Object scope.
- Component scope.
- ID scope.
- Context properties.
- Imported namespaces.
- JavaScript resource scope.
- QML global object.
- Scope extension.
- Identifier resolution.
- Property shadowing.

### 8.3 Resolusi nama

- Bagaimana QML mencari identifier.
- Prioritas nama lokal.
- Akses terhadap property objek.
- Akses melalui `id`.
- Konflik nama variabel dengan property.
- Konflik nama antarobjek.
- Konflik nama dengan global object.
- Akses identifier dari file JavaScript.
- Perbedaan scope script biasa dan shared library.

### 8.4 `this` dan konteks pemanggilan

- Arti `this` dalam fungsi JavaScript.
- Perbedaan regular function dan arrow function.
- `this` dalam callback.
- `this` dalam event handler.
- Konteks objek QML.
- Penggunaan `this` secara aman.
- Mengapa `id` sering lebih jelas daripada mengandalkan `this`.

Contoh:

```
Item {
    id: root

    property int count: 0

    function increment() {
        count += 1;
    }

    Item {
        id: child

        function report() {
            console.log(root.count);
        }
    }
}
```

Kompetensi akhir: dapat menelusuri asal identifier dan menjelaskan mengapa suatu variabel atau property dapat atau tidak dapat diakses.

Referensi: [Scope and Naming Resolution](https://doc.qt.io/qt-6/qtqml-documents-scope.html?utm_source=chatgpt.com).

## Fase 9 — JavaScript di dalam dokumen QML

Tujuan: menguasai semua lokasi dan bentuk penggunaan JavaScript dalam file `.qml`.

Materi:

1. JavaScript dalam property binding.
2. JavaScript dalam property initialization.
3. JavaScript dalam function declaration.
4. JavaScript dalam signal handler.
5. JavaScript dalam inline component.
6. JavaScript dalam `Component.onCompleted`.
7. JavaScript dalam `Component.onDestruction`.
8. JavaScript dalam `Binding`.
9. JavaScript dalam `State`.
10. JavaScript dalam `Transition`.
11. JavaScript dalam `Behavior`.
12. JavaScript dalam `Timer` handler.
13. JavaScript dalam `Connections`.
14. JavaScript dalam `Instantiator` dan model-related handler.
15. JavaScript dalam callback komponen.
16. JavaScript dalam fungsi yang dipanggil oleh komponen lain.
17. JavaScript yang menggunakan `id`.
18. JavaScript yang mengakses property objek.
19. JavaScript yang mengakses attached properties.
20. JavaScript yang menggunakan enum QML.
21. JavaScript dalam ekspresi conditional.
22. JavaScript dalam ekspresi nested.
23. Perbedaan deklarasi dan pemanggilan fungsi.
24. Perbedaan property value dan property binding.

Contoh:

```
import QtQuick

Rectangle {
    id: root

    property bool active: false
    color: active ? "green" : "gray"

    function toggle() {
        active = !active;
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.toggle()
    }
}
```

Pahami bahwa `color: active ? ...` merupakan ekspresi JavaScript yang digunakan sebagai property binding QML, sedangkan `onClicked` merupakan handler untuk signal.

Kompetensi akhir: mampu membaca kode JavaScript yang ditempatkan di berbagai bagian dokumen QML dan memahami konteks eksekusinya.

## Fase 10 — QML global object dan API JavaScript

Tujuan: mengenal objek serta fungsi yang disediakan oleh Qt untuk digunakan dari JavaScript.

### 10.1 Global objects

- `Qt`.
- `console`.
- `print()`.
- `gc()`.
- `qsTr()`.
- `qsTranslate()`.
- `qsTrId()`.
- Fungsi dan macro translasi yang tersedia di lingkungan QML.

### 10.2 Qt object

Pelajari fungsi dan property yang disediakan objek `Qt`, termasuk:

- Pembuatan nilai QML seperti `Qt.point()`, `Qt.size()`, `Qt.rect()`, dan `Qt.vector3d()`.
- `Qt.binding()`.
- `Qt.createComponent()`.
- `Qt.createQmlObject()`.
- `Qt.callLater()`.
- `Qt.openUrlExternally()`.
- Fungsi warna dan konversi terkait.
- Fungsi informasi aplikasi dan platform yang tersedia pada versi Qt yang digunakan.

Jangan hanya menghafal nama API. Untuk setiap API, pelajari tujuan, parameter, tipe return, efek samping, batasan, dan contoh penggunaan.

### 10.3 Console API

- `console.log()`.
- `console.info()`.
- `console.warn()`.
- `console.error()`.
- `console.debug()`.
- `console.trace()` apabila tersedia.
- Penggunaan logging untuk menelusuri alur program.
- Membaca pesan warning dan error QML.

### 10.4 Built-in JavaScript API yang digunakan

- `Math`.
- `JSON`.
- `Date`.
- `Object`.
- `Array`.
- `String`.
- `Number`.
- `RegExp`.
- `Error`.
- `Promise` jika digunakan oleh fitur yang didukung pada versi Qt sasaran.

### 10.5 API khusus lingkungan QML

- `XMLHttpRequest`.
- `DOMException`.
- Fitur tambahan pada prototype `String`.
- Fitur tambahan pada prototype `Date` dan `Number`.
- Perilaku `instanceof` untuk QML types.
- Perbedaan API global QML dengan browser API.

Kompetensi akhir: mampu mengenali API bawaan QML dan mengetahui kapan menggunakan API Qt dibandingkan built-in JavaScript.

Referensi: [QML Global Object](https://doc.qt.io/qt-6/qtqml-javascript-qmlglobalobject.html?utm_source=chatgpt.com) dan [JavaScript Host Environment](https://doc.qt.io/qt-6.10/qtqml-javascript-hostenvironment.html?utm_source=chatgpt.com).

## Fase 11 — Property binding dan ekspresi deklaratif

Tujuan: memahami interaksi terpenting antara JavaScript dan sistem reaktivitas QML.

Property binding bukan sekadar ekspresi JavaScript biasa. QML engine mengawasi dependency dari ekspresi binding dan mengevaluasinya kembali ketika dependency berubah.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://doc.qt.io\&sz=32)

Qt 6.12.0+1



### 11.1 Binding fundamentals

- Property assignment.
- Property initialization.
- Property binding.
- Binding expression.
- Binding dependency.
- Dependency tracking.
- Binding evaluation.
- Binding reevaluation.
- Binding lifetime.
- Binding removal.
- Binding restoration.

### 11.2 Dependency tracking

- Membaca property sebagai dependency.
- Dependency langsung.
- Dependency tidak langsung.
- Nested property dependency.
- Dependency dalam fungsi.
- Dependency dari objek lain.
- Dependency yang berubah.
- Dependency yang tidak terdeteksi karena pola akses tertentu.

### 11.3 JavaScript dalam binding

- Arithmetic expression.
- Conditional expression.
- Function call.
- Array access.
- Object property access.
- Ternary expression.
- Logical expression.
- Multiple dependencies.
- Nested expressions.
- Penggunaan fungsi helper.

### 11.4 Imperative assignment versus binding

- Binding deklaratif.
- Assignment imperatif.
- Perbedaan `property: expression` dan `property = value`.
- Bagaimana assignment dapat menggantikan binding.
- Cara mempertahankan binding.
- `Qt.binding()`.
- Binding melalui `Binding` type.
- Binding yang bergantung pada kondisi.

### 11.5 Binding pitfalls

- Binding loop.
- Binding hilang.
- Binding yang tidak dievaluasi ulang sesuai harapan.
- Efek samping di dalam binding.
- Pemanggilan fungsi yang mengubah state.
- Ekspresi mahal.
- Ketergantungan tersembunyi.
- Binding yang terlalu kompleks.

### 11.6 Desain binding

- Binding sederhana.
- Binding berantai.
- Pemisahan ekspresi kompleks.
- Menggunakan property perantara.
- Memisahkan kalkulasi dari perubahan state.
- Menghindari imperative logic yang tidak perlu.

Contoh:

```
Item {
    id: root

    property int screenWidth: 1200
    property int panelWidth: screenWidth * 0.25

    property bool compact:
        screenWidth < 800

    property int effectiveWidth:
        compact ? 80 : panelWidth
}
```

Kompetensi akhir: mampu menjelaskan kapan suatu binding dievaluasi, apa dependency-nya, mengapa binding terputus, dan bagaimana memperbaikinya.

Referensi: [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html?utm_source=chatgpt.com).

## Fase 12 — Signal, handler, dan event-driven JavaScript

Tujuan: memahami bagaimana JavaScript bereaksi terhadap peristiwa dalam sistem objek QML.

### 12.1 Signal fundamentals

- Pengertian signal.
- Signal declaration.
- Signal emission.
- Signal parameters.
- Signal handler.
- Handler naming convention.
- Signal connection.
- Signal-to-function connection.

### 12.2 Signal handler

- `onClicked`.
- `onPressed`.
- `onReleased`.
- `onTriggered`.
- `onCompleted`.
- `onDestruction`.
- Handler dengan parameter.
- Handler tanpa parameter.
- Handler dengan blok JavaScript.
- Memanggil fungsi dari handler.

### 12.3 Connections

- `Connections` type.
- `target`.
- Signal handler pada `Connections`.
- `ignoreUnknownSignals`.
- Hubungan signal dengan object yang tidak berada dalam hierarki langsung.
- Menghubungkan dan memisahkan komunikasi antarobjek.

### 12.4 Event-driven logic

- Event source.
- Event handler.
- Callback.
- State transition.
- Event sequencing.
- Event propagation sebagai konsep pembeda dari DOM.
- Re-entrancy.
- Multiple signal listeners.
- Event-driven architecture.

### 12.5 Attached dan lifecycle signals

- `Component.onCompleted`.
- `Component.onDestruction`.
- `Timer.onTriggered`.
- Signal dari Qt Quick Controls.
- Signal dari model dan delegate.
- Signal dari custom QML component.

### 12.6 Desain komunikasi

- Signal untuk pemberitahuan.
- Function untuk permintaan tindakan.
- Property untuk state.
- Signal untuk loose coupling.
- Menghindari ketergantungan antarobjek yang berlebihan.

Kompetensi akhir: mampu membaca jalur komunikasi antarobjek dan memahami bagaimana interaksi pengguna memicu logika JavaScript.

## Fase 13 — JavaScript resources dan modularisasi

Tujuan: memahami cara memisahkan logika JavaScript dari dokumen QML agar kode dapat dikelola dan digunakan kembali.

### 13.1 JavaScript resource

- Pengertian JavaScript resource.
- File `.js`.
- File `.mjs`.
- Inline JavaScript.
- Code-behind resource.
- Shared JavaScript library.
- Stateless library.
- Stateful resource.

### 13.2 Import JavaScript

- `import "file.js" as Logic`.
- Namespace qualifier.
- Pemanggilan fungsi melalui qualifier.
- Relative URL.
- Absolute URL.
- Import JavaScript dari QML.
- Import JavaScript dari JavaScript.
- Import QML module dari JavaScript.
- ECMAScript module import dan export.
- Perbedaan `.import` dan `import` ECMAScript.
- Penggunaan `.mjs` dalam QML.

### 13.3 JavaScript pragmas

- `.pragma library`.
- Dampak shared library.
- Shared state.
- Stateless library.
- Perbedaan import biasa dan shared library.
- Pengaruh import terhadap scope.
- Batasan penggunaan global variable.

### 13.4 Resource architecture

- Pemisahan UI dan logic.
- Utility functions.
- Data transformation modules.
- Configuration modules.
- Validation modules.
- Reusable business logic.
- Modul yang bergantung pada QML.
- Modul JavaScript yang independen dari objek QML.
- Dependency organization.
- Circular dependency sebagai masalah desain.

### 13.5 Lifecycle dan instance isolation

- Satu resource untuk banyak komponen.
- Isolasi state setiap instance.
- Shared state antar-instance.
- Kapan menggunakan `.pragma library`.
- Kapan menghindari shared mutable state.
- Pengaruh instance component terhadap state JavaScript.

Contoh:

```
import QtQuick
import "MathUtils.js" as MathUtils

Item {
    property int result: MathUtils.add(10, 20)
}
```

```
// MathUtils.js

function add(a, b) {
    return a + b;
}
```

Kompetensi akhir: mampu menentukan apakah logika sebaiknya ditulis inline, dipisahkan menjadi `.js`, atau dibuat sebagai modul `.mjs`.

Referensi: [Importing JavaScript Resources in QML](https://doc.qt.io/qt-6/qtqml-javascript-imports.html?utm_source=chatgpt.com) dan [Defining JavaScript Resources in QML](https://doc.qt.io/qt-6.8/qtqml-javascript-resources.html?utm_source=chatgpt.com).

## Fase 14 — QML data types dan konversi nilai

Tujuan: memahami bagaimana JavaScript berinteraksi dengan sistem tipe QML dan tipe data Qt.

Materi:

1. JavaScript primitive dan QML value types.
2. QML `int`, `real`, `bool`, dan `string`.
3. QML `url`.
4. QML `color`.
5. QML `date`.
6. QML `point`, `size`, dan `rect`.
7. QML vector types.
8. QML `var`.
9. QML `list<T>`.
10. JavaScript Array.
11. JavaScript Object.
12. QML object reference.
13. QObject reference.
14. QVariant.
15. QVariantList.
16. QVariantMap.
17. QDateTime dan JavaScript Date.
18. QByteArray dan ArrayBuffer.
19. Konversi parameter fungsi.
20. Konversi nilai return.
21. Perbedaan nilai JavaScript dan nilai QML.
22. Perbedaan object JavaScript dan QObject.
23. Mutasi data hasil konversi.
24. Batasan konversi tipe.

Kompetensi akhir: mampu memahami tipe data yang dikirim dan diterima dari QML maupun C++, serta mengetahui risiko konversinya.

Referensi: [Data Type Conversion Between QML and C++](https://doc.qt.io/qt-6/qtqml-cppintegration-data.html?utm_source=chatgpt.com).

## Fase 15 — Asynchronous dan pemrosesan berbasis event

Tujuan: memahami bagaimana kode JavaScript menangani pekerjaan yang tidak langsung menghasilkan hasil, khususnya ketika berhubungan dengan jaringan, resource, dan operasi yang berjalan kemudian.

### 15.1 Dasar asynchronous

- Synchronous execution.
- Asynchronous execution.
- Call stack.
- Event loop secara konseptual.
- Callback.
- Callback nesting.
- Callback error.
- Event-driven execution.
- Urutan eksekusi.

### 15.2 Promise

- Promise.
- Pending.
- Fulfilled.
- Rejected.
- `then()`.
- `catch()`.
- `finally()`.
- Promise chaining.
- Promise error propagation.
- Promise composition.
- `Promise.all()` dan metode lain jika didukung oleh runtime sasaran.

### 15.3 Async dan await

- `async` function.
- `await`.
- Return value.
- Error handling.
- `try...catch`.
- Asynchronous function composition.
- Batasan dukungan `async`/`await` pada versi Qt dan konteks eksekusi yang digunakan.

### 15.4 Timer

- QML `Timer`.
- `interval`.
- `repeat`.
- `running`.
- `triggeredOnStart`.
- `onTriggered`.
- Start, stop, dan restart.
- Timer sebagai mekanisme penjadwalan UI.
- Perbedaan QML Timer dengan browser timer.

### 15.5 Network

- `XMLHttpRequest` yang tersedia dalam QML.
- `open()`.
- `send()`.
- `onreadystatechange`.
- `onload`.
- `onerror`.
- HTTP response.
- Status code.
- JSON response.
- Network error.
- Request lifecycle.

### 15.6 Operasi asynchronous QML

- `Qt.callLater()`.
- `Component` asynchronous loading.
- `Loader`.
- Status loading.
- Resource loading.
- `WorkerScript`.
- Pengiriman pesan antarthread melalui WorkerScript.
- Pembatasan objek yang dapat diakses dari WorkerScript.
- Cancellation dan timeout sebagai persoalan desain.
- Race condition.
- Stale result.
- Penanganan request berulang.

### 15.7 Memilih API asynchronous

| Kebutuhan                      | API yang dipelajari                           |
| ------------------------------ | --------------------------------------------- |
| Menjadwalkan aksi UI           | `Qt.callLater()`                              |
| Menjalankan kode berkala       | QML `Timer`                                   |
| Memuat komponen                | `Component` dan `Loader`                      |
| HTTP sederhana dari JavaScript | `XMLHttpRequest`                              |
| Jaringan aplikasi Qt           | `QNetworkAccessManager` melalui integrasi C++ |
| Pekerjaan terpisah             | `WorkerScript` atau fasilitas threading Qt    |

Kompetensi akhir: mampu memahami urutan eksekusi, mengelola hasil operasi asynchronous, dan mencegah kesalahan akibat operasi yang selesai tidak berurutan.

Catatan: jangan mengasumsikan semua API browser atau semua fitur ECMAScript modern tersedia dalam setiap versi Qt. Periksa versi runtime dan dokumentasi API yang menjadi target.

## Fase 16 — Integrasi JavaScript dengan Qt dan C++

Tujuan: memahami batas antara JavaScript yang berjalan di QML dan objek native yang berasal dari Qt/C++.

Fase ini tidak bertujuan menjadikan peserta ahli C++. Fokusnya adalah memahami bagaimana kode JavaScript QML memanggil dan menerima data dari kode native.

### 16.1 QObject fundamentals

- QObject.
- Object instance.
- Object property.
- Object method.
- Signal dan slot.
- Meta-object system.
- Q_PROPERTY.
- Q_INVOKABLE.
- Q_ENUM.
- QML type registration.
- Object ownership.

### 16.2 JavaScript memanggil C++

- Mengakses QObject dari QML.
- Membaca property C++.
- Mengubah property C++.
- Memanggil method C++.
- Menerima return value.
- Memanggil method dengan parameter.
- Menangani signal C++.
- Memahami enum C++ dari QML.

### 16.3 Data conversion

- `QVariant`.
- `QJSValue`.
- `QVariantList`.
- `QVariantMap`.
- `QString`.
- `QUrl`.
- `QDateTime`.
- `QByteArray`.
- Array dan object JavaScript.
- Konversi dua arah.
- Custom value types.

### 16.4 JavaScript engine

- `QJSEngine`.
- `QJSValue`.
- Evaluasi JavaScript dari C++.
- Pembuatan object JavaScript.
- Pemanggilan fungsi JavaScript dari C++.
- Pertukaran data.
- Error dan exception.
- Engine ownership.
- Perbedaan `QJSEngine` dengan `QQmlEngine`.

### 16.5 Desain integrasi

- Logika UI di QML.
- Logika sistem di C++.
- Business logic.
- Native service.
- API boundary.
- Data contract.
- Pemisahan tanggung jawab.
- Validasi data lintas bahasa.
- Error propagation.

Kompetensi akhir: mampu membaca kode JavaScript yang berkomunikasi dengan objek C++ dan memahami kontrak data yang digunakan.

Referensi: [Data Type Conversion Between QML and C++](https://doc.qt.io/qt-6/qtqml-cppintegration-data.html?utm_source=chatgpt.com) dan dokumentasi [QJSEngine](https://doc.qt.io/qt-6/qjsengine.html?utm_source=chatgpt.com) serta [QJSValue](https://doc.qt.io/qt-6/qjsvalue.html?utm_source=chatgpt.com).

## Fase 17 — Object lifecycle dan memory management

Tujuan: memahami bagaimana object JavaScript dan QML dibuat, digunakan, dan dilepaskan.

Materi:

1. JavaScript object creation.
2. Object references.
3. Reference assignment.
4. Object reachability.
5. Garbage collection.
6. Garbage collection dalam JavaScript engine QML.
7. `gc()`.
8. QObject ownership.
9. Parent-child ownership.
10. QML object lifecycle.
11. Component creation.
12. Dynamic object creation.
13. `Component.createObject()`.
14. `Qt.createQmlObject()`.
15. `destroy()`.
16. Object references yang masih tersimpan.
17. Memory retention.
18. Circular references sebagai konsep.
19. Shared JavaScript state.
20. Resource lifecycle.
21. Perbedaan lifecycle JavaScript object dan QObject.
22. Risiko menyimpan referensi objek yang sudah tidak relevan.

### Perbandingan penting

| Aspek                 | JavaScript object              | QObject                                        |
| --------------------- | ------------------------------ | ---------------------------------------------- |
| Pengelolaan memori    | Garbage collection JavaScript  | Qt object ownership dan mekanisme QObject      |
| Identitas             | Referensi JavaScript           | Identitas objek native                         |
| Lifecycle             | Bergantung pada reachability   | Bergantung pada ownership dan lifecycle native |
| Hubungan parent-child | Tidak otomatis seperti QObject | Memiliki parent-child ownership                |
| Penghapusan           | Dikelola engine                | Dapat dipengaruhi parent dan pemilik objek     |

Kompetensi akhir: dapat memahami risiko penggunaan object reference dan lifecycle ketika JavaScript bekerja dengan objek QML/native.

## Fase 18 — Debugging, analisis, dan optimasi JavaScript QML

Tujuan: dapat menemukan penyebab kesalahan dan meningkatkan kualitas kode JavaScript dalam aplikasi QML.

### 18.1 Error handling

- Syntax error.
- Reference error.
- Type error.
- Range error.
- Runtime error.
- `try`.
- `catch`.
- `finally`.
- `throw`.
- Error object.
- Error propagation.
- Error dalam signal handler.
- Error dalam callback.
- Error dalam file JavaScript.

### 18.2 Debugging

- `console.log()`.
- `console.warn()`.
- `console.error()`.
- Menelusuri pemanggilan fungsi.
- Menelusuri perubahan property.
- Memeriksa nilai parameter.
- Memeriksa return value.
- Mendeteksi identifier yang tidak ditemukan.
- Mendeteksi binding loop.
- Mendeteksi binding yang terputus.
- Menganalisis error pada JavaScript resource.

### 18.3 Qt tooling

- QML debugging.
- Qt Creator debugger.
- QML Profiler.
- `qmllint`.
- `qmlls`.
- `qmlformat`.
- Qt Quick debugging.
- Logging kategori Qt.
- QML warnings.
- Static analysis.

### 18.4 Performance

- Biaya pemanggilan fungsi.
- Ekspresi binding yang mahal.
- Loop besar.
- Array transformation.
- Object creation.
- Repeated calculation.
- Excessive signal handling.
- Excessive property mutation.
- Memory allocation.
- Garbage collection overhead.
- Memisahkan pekerjaan berat dari UI thread.
- Memilih C++ untuk pekerjaan yang lebih tepat dilakukan secara native.

### 18.5 Code quality

- Naming convention.
- Single responsibility.
- Reusable functions.
- Data validation.
- Error boundary.
- Modularization.
- Avoiding hidden side effects.
- Consistent return values.
- Readability.
- Maintainability.
- Testability.

Kompetensi akhir: mampu menganalisis kode JavaScript QML yang bermasalah, mencari sumber error, dan memperbaiki struktur serta performanya.

## Fase 19 — Arsitektur dan rekayasa logika JavaScript QML

Tujuan: mencapai kemampuan merancang sistem logika JavaScript yang dapat digunakan dalam proyek QML berskala besar.

### 19.1 Arsitektur kode

- Inline logic architecture.
- Code-behind architecture.
- JavaScript resource architecture.
- Shared library architecture.
- Stateless utility architecture.
- Stateful module architecture.
- Singleton integration.
- Service-oriented logic.
- Component-oriented logic.
- Data-driven architecture.

### 19.2 Separation of concerns

- UI presentation.
- UI state.
- Data transformation.
- Validation.
- Business logic.
- Native service.
- Configuration.
- Event handling.
- Persistence.
- Network access.

### 19.3 State management

- Local state.
- Shared state.
- Global state.
- Singleton state.
- State ownership.
- State synchronization.
- State mutation.
- State consistency.
- Derived state.
- State transition.
- Avoiding duplicated state.

### 19.4 Reusable logic

- Reusable function.
- Reusable JavaScript module.
- Utility library.
- Validation library.
- Data formatter.
- Configuration parser.
- Component helper.
- Service wrapper.
- Error handler.
- Shared constants.

### 19.5 Advanced QML JavaScript

- QML-specific JavaScript extensions.
- QML type checking.
- Dynamic component creation.
- Dynamic object interaction.
- Runtime type inspection.
- Custom QML types.
- JavaScript and custom C++ types.
- Engine configuration.
- QML engine restrictions.
- Compatibility across Qt 6 versions.

### 19.6 Source code investigation

- Membaca dokumentasi Qt.
- Membaca QML type reference.
- Menelusuri API implementation.
- Memeriksa Qt source code.
- Memahami perubahan API antarversi.
- Membaca release notes.
- Membuat minimal reproducible example.
- Menguji asumsi melalui eksperimen.
- Menulis dokumentasi teknis.
- Melakukan code review.

Kompetensi akhir: mampu merancang, mengorganisasi, menguji, dan memelihara sistem JavaScript QML yang modular, konsisten, dan dapat dikembangkan.

## 3. Materi tambahan yang wajib dipahami lintas fase

Ada beberapa konsep yang tidak cukup dipelajari hanya dalam satu fase. Konsep ini harus dipahami berulang kali karena menjadi dasar membaca kode QML yang kompleks.

| Konsep              | Harus dikuasai sampai tingkat                                   |
| ------------------- | --------------------------------------------------------------- |
| Function            | Bisa menelusuri parameter, scope, pemanggilan, dan return value |
| Object              | Bisa memahami struktur dan referensi object                     |
| Array               | Bisa membaca dan memodifikasi koleksi data                      |
| Scope               | Bisa menentukan asal setiap identifier                          |
| Closure             | Bisa memahami fungsi yang mengakses variabel dari scope luar    |
| Binding             | Bisa mengetahui dependency dan mekanisme evaluasi ulang         |
| Signal handler      | Bisa menelusuri komunikasi dan urutan event                     |
| JavaScript resource | Bisa memahami import, shared state, dan isolasi instance        |
| QML global object   | Bisa mengenali API bawaan Qt                                    |
| Type conversion     | Bisa memahami perpindahan data antara JavaScript, QML, dan C++  |
| Asynchronous        | Bisa memahami urutan operasi yang tidak langsung selesai        |
| Object lifecycle    | Bisa memahami masa hidup object dan referensinya                |
| Debugging           | Bisa menemukan penyebab kesalahan tanpa menebak                 |

## 4. Tools dan lingkungan pembelajaran

Tidak diperlukan lingkungan JavaScript browser maupun Node.js. Gunakan lingkungan Qt 6 secara langsung.

| Tools          | Kegunaan                                               | Status                   |
| -------------- | ------------------------------------------------------ | ------------------------ |
| Qt 6 SDK       | Menyediakan runtime dan library QML                    | Wajib                    |
| Qt Declarative | Modul implementasi QML                                 | Wajib                    |
| Qt Quick       | Membuat aplikasi visual untuk eksperimen               | Wajib                    |
| `qml`          | Menjalankan dokumen QML, jika tersedia dalam instalasi | Wajib untuk workflow CLI |
| `qmllint`      | Menganalisis kesalahan dan kualitas QML                | Wajib                    |
| `qmlls`        | Language Server untuk QML                              | Sangat disarankan        |
| `qmlformat`    | Memformat kode QML                                     | Disarankan               |
| Qt Creator     | Debugging dan profiling                                | Opsional                 |
| Neovim         | Editor dan integrasi LSP                               | Opsional                 |
| Git            | Melacak eksperimen dan perubahan kode                  | Disarankan               |

Catatan implementasi: Qt ditulis terutama menggunakan C++, sedangkan JavaScript yang digunakan di dalam QML dijalankan oleh JavaScript engine Qt. Untuk mengembangkan library JavaScript QML sendiri, cukup kuasai JavaScript yang relevan, QML, struktur modul, dan API Qt. C++ baru diperlukan ketika ingin membuat integrasi native, custom QObject, atau memperluas kemampuan engine dan framework.

### Workflow belajar yang disarankan

```
qml-js-lab/
├── 00-basics/
│   ├── variables.qml
│   ├── expressions.qml
│   └── functions.qml
├── 01-data/
│   ├── arrays.qml
│   ├── objects.qml
│   └── json.qml
├── 02-scope/
│   ├── scope.qml
│   └── closure.qml
├── 03-binding/
│   ├── basic.qml
│   ├── dependencies.qml
│   └── binding-loss.qml
├── 04-signals/
│   ├── handlers.qml
│   └── connections.qml
├── 05-resources/
│   ├── main.qml
│   └── js/
│       ├── utilities.js
│       └── calculations.js
├── 06-async/
│   ├── timer.qml
│   └── network.qml
├── 07-integration/
│   └── native.qml
└── 08-architecture/
    └── main.qml
```

Untuk setiap materi, buat eksperimen kecil yang hanya menguji satu konsep. Jangan langsung membuat aplikasi besar karena kesalahan satu konsep dapat bercampur dengan kesalahan konsep lainnya.

## 5. Urutan kompetensi dan evaluasi

Berikut target yang harus dicapai sebelum melanjutkan ke tahap berikutnya.

| Evaluasi           | Kriteria kelulusan                                                         |
| ------------------ | -------------------------------------------------------------------------- |
| Fondasi sintaks    | Mampu membaca dan menjelaskan kode tanpa bantuan                           |
| Data dan fungsi    | Mampu memproses object, array, dan fungsi                                  |
| Scope              | Mampu menjelaskan asal setiap variabel dan property                        |
| QML integration    | Mampu memahami JavaScript dalam berbagai bagian `.qml`                     |
| Binding            | Mampu menjelaskan dependency dan perubahan binding                         |
| Signal             | Mampu menelusuri event dari sumber hingga handler                          |
| Resources          | Mampu mengorganisasi kode ke beberapa file                                 |
| Asynchronous       | Mampu memahami callback, Promise, dan operasi berbasis event yang didukung |
| Native integration | Mampu membaca interaksi JavaScript dan C++                                 |
| Advanced           | Mampu menganalisis, mengoptimalkan, dan merancang arsitektur               |



Target akhir

&#x20;JavaScript QML Mastery



Pada akhir kurikulum, kamu harus mampu:

1. Membaca kode JavaScript dalam dokumen QML tanpa kebingungan mengenai sintaksnya.
2. Memahami seluruh struktur fungsi, object, array, dan ekspresi.
3. Memahami bagaimana JavaScript mengakses dan memodifikasi objek QML.
4. Memahami sistem scope dan resolusi identifier.
5. Memahami property binding beserta dependency-nya.
6. Memahami signal handler dan event-driven logic.
7. Memahami JavaScript resources dan sistem modularisasi.
8. Mengenali API bawaan Qt yang dapat digunakan dari JavaScript.
9. Memahami asynchronous operation dalam batas kemampuan runtime Qt.
10. Memahami pertukaran data antara JavaScript, QML, dan C++.
11. Menganalisis error, debugging, dan performa.
12. Merancang sistem logika JavaScript QML yang modular.

## 6. Referensi dokumentasi resmi

Berikut dokumentasi yang menjadi sumber utama kurikulum. Prioritaskan dokumentasi Qt 6, bukan dokumentasi Qt 5 atau tutorial JavaScript browser.

Fondasi dan lingkungan JavaScript

- [Integrating QML and JavaScript](https://doc.qt.io/qt-6.10/qtqml-javascript-topic.html?utm_source=chatgpt.com)
- [JavaScript Host Environment](https://doc.qt.io/qt-6.10/qtqml-javascript-hostenvironment.html?utm_source=chatgpt.com)
- [JavaScript Expressions in QML Documents](https://doc.qt.io/qt-6.10/qtqml-javascript-expressions.html?utm_source=chatgpt.com)
- [QML Global Object](https://doc.qt.io/qt-6/qtqml-javascript-qmlglobalobject.html?utm_source=chatgpt.com)
- [Scope and Naming Resolution](https://doc.qt.io/qt-6/qtqml-documents-scope.html?utm_source=chatgpt.com)

Property binding dan sistem QML

- [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html?utm_source=chatgpt.com)
- [The QML Language](https://doc.qt.io/qt-6/qtqml-language-topic.html?utm_source=chatgpt.com)

Modularisasi JavaScript

- [Defining JavaScript Resources in QML](https://doc.qt.io/qt-6.8/qtqml-javascript-resources.html?utm_source=chatgpt.com)
- [Importing JavaScript Resources in QML](https://doc.qt.io/qt-6/qtqml-javascript-imports.html?utm_source=chatgpt.com)
- [Import Statements](https://doc.qt.io/qt-6/qtqml-syntax-imports.html?utm_source=chatgpt.com)

Integrasi native

- [Data Type Conversion Between QML and C++](https://doc.qt.io/qt-6/qtqml-cppintegration-data.html?utm_source=chatgpt.com)
- [QJSEngine](https://doc.qt.io/qt-6/qjsengine.html?utm_source=chatgpt.com)
- [QJSValue](https://doc.qt.io/qt-6/qjsvalue.html?utm_source=chatgpt.com)

Referensi tambahan

- [Qt QML Documentation](https://doc.qt.io/qt-6/qtqml-index.html?utm_source=chatgpt.com)
- [List of JavaScript Objects and Functions](https://doc.qt.io/qt-6/qtqml-javascript-functionlist.html?utm_source=chatgpt.com)
- [Qt QML Tools](https://doc.qt.io/qt-6/qtqml-index.html?utm_source=chatgpt.com#tools)

## 7. Catatan penting mengenai versi Qt 6

Jangan menganggap semua versi Qt 6 memiliki kemampuan JavaScript yang identik. Contohnya:

| Fitur                                               | Dukungan mulai |
| --------------------------------------------------- | -------------- |
| Nullish coalescing `??`                             | Qt 5.15        |
| Optional chaining `?.`                              | Qt 6.2         |
| Numeric literal separators seperti `1_000_000`      | Qt 6.8         |
| Perubahan in-place `QVariantList` property dari QML | Qt 6.5         |
| Perubahan in-place `QVariantMap` property dari QML  | Qt 6.9         |

Selain itu, dokumentasi Qt menjelaskan bahwa runtime QML mempunyai batasan tersendiri terhadap global object dan host environment. Karena itu, jangan menjadikan dokumentasi JavaScript umum sebagai acuan utama untuk menentukan apakah suatu API dapat digunakan dalam QML.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://doc.qt.io\&sz=32)

Qt 6.10.3+2



Rekomendasi urutan pelaksanaan: selesaikan Fase 0–8 sebelum mempelajari JavaScript yang terintegrasi langsung dengan objek QML secara mendalam. Setelah itu, Fase 9–14 menjadi inti penguasaan JavaScript QML. Fase 15–19 membangun kemampuan tingkat lanjut.

Satu hal yang perlu ditegaskan: kurikulum ini tidak mengharuskan kamu menguasai seluruh JavaScript secara universal. Targetnya adalah penguasaan menyeluruh terhadap sintaks, perilaku, API, dan integrasi JavaScript yang relevan dengan Qt QML. Untuk menjaga kurikulum tetap akurat, setiap fitur yang bergantung pada versi harus divalidasi terhadap dokumentasi versi Qt yang benar-benar digunakan.
</details>

---



<details>
  <summary>Mastery Qt 6 — QML & Qt Quick</summary>

# Kurikulum Mastery Qt 6 — QML & Qt Quick

FOUNDATION → INTERMEDIATE → ADVANCED → EXPERT → ENTERPRISE

# Qt 6 QML & Qt Quick Engineering

Tujuan utama: membangun penguasaan mendalam terhadap QML dan Qt Quick, mulai dari fondasi bahasa deklaratif, sistem objek, reaktivitas, rendering grafis, arsitektur komponen, hingga integrasi native, optimasi performa, dan pengembangan framework berskala besar.

Kurikulum ini secara khusus membatasi pembahasan pada ekosistem Qt 6, QML, dan Qt Quick. Tidak ada materi dari framework desktop lain yang dimasukkan sebagai bagian pembelajaran.

# 1. Identitas teknologi dan ruang lingkup

Sebelum memulai, terdapat tiga istilah yang harus dibedakan.

[QT: Cross-platform Software Development](https://images.openai.com/static-rsc-4/fnge3tsEpN2vR6cvyI2tMlqDfLf1fja2DdHySNdMuDsZ64VHagTet1gpy7gFuiU_grT6k251vKS7VlT7uIWvDPnvznUj8TMQHrVLyFu6ub7VrkgGOtwHx5jLEq-XrCQSZyJUSjR84wgRLJXdiKxRg2eB88geYyH3m7eAs8GKwDg?purpose=inline)

Qt

Framework pengembangan aplikasi lintas platform. Qt menyediakan sistem objek, event handling, jaringan, filesystem, multimedia, grafis, dan berbagai fasilitas aplikasi.

[Qt for MCUs 2.6 released](https://images.openai.com/static-rsc-4/32eKNGM9wO6ycRingaPMWGmLs-U74YHf2psl4rg1p6KGB3rUJv1M-VKnoYqoxMeuFZpeXMmyN04OAf9bnYW6lZme4pyDubAqQDk6JVnlfVuV6Do_EXuxbGM16BhQe6nbk9ntZ_F-ilg2q1yM-GcUvVSbDXMH77XQYNrfmEru0UU?purpose=inline)

QML

Bahasa deklaratif untuk mendeskripsikan objek, properti, hubungan antarnilai, hierarki komponen, dan perilaku antarmuka. QML menggunakan sintaks yang menyerupai JSON atau JavaScript, tetapi bukan JSON dan bukan JavaScript biasa.

[Preview a QML file on desktop | Qt Creator Documentation](https://images.openai.com/static-rsc-4/_VT0WApFbLdO8x9AzPXyADQYwyxH4ltv_azwtwc-GMGFkIjiVdrbzqkpnJ5GKsozlBtEs1tod95Gu24CA-YkmBeWZORrF5IT3nhZsIeRdrjDZyTMkQ5zLA-ZxcHm_ucG0siCewuw9K4w5ZSEOiLiseRMj1QoW05coKYylK63fjc?purpose=inline)

Qt Quick

Framework antarmuka grafis berbasis QML. Menyediakan visual items, input handling, animasi, model-view, layout, dan scene graph.

### Hubungan ketiganya

| Teknologi | Tanggung jawab                                           |
| --------- | -------------------------------------------------------- |
| Qt        | Fondasi framework dan layanan aplikasi                   |
| QML       | Bahasa untuk mendeskripsikan objek dan perilakunya       |
| Qt Quick  | Sistem untuk membangun dan merender antarmuka deklaratif |

### Teknologi pembentuk ekosistem

| Teknologi             | Peran                                                           |
| --------------------- | --------------------------------------------------------------- |
| C++                   | Bahasa native utama Qt                                          |
| JavaScript            | Bahasa imperatif yang didukung di lingkungan QML                |
| QML                   | Bahasa deklaratif                                               |
| CMake                 | Sistem konfigurasi dan pembangunan proyek                       |
| Qt Meta-Object System | Infrastruktur introspeksi, properti, sinyal, slot, dan refleksi |
| Qt Quick Scene Graph  | Sistem representasi dan rendering grafis                        |
| Graphics API          | Backend grafis seperti OpenGL, Vulkan, Metal, dan Direct3D      |

Hal penting: QML bukan pengganti C++, dan Qt Quick bukan sekadar kumpulan komponen visual. Ketiganya bekerja dalam satu arsitektur yang memungkinkan deklarasi UI, logika aplikasi, sistem reaktif, dan rendering grafis beroperasi secara terintegrasi.

Referensi dasar:

- [Qt 6 Documentation](https://doc.qt.io/qt-6/?utm_source=chatgpt.com)
- [QML Documentation](https://doc.qt.io/qt-6/qtqml-index.html?utm_source=chatgpt.com)
- [Qt Quick Documentation](https://doc.qt.io/qt-6/qtquick-index.html?utm_source=chatgpt.com)
- [Qt Architecture](https://doc.qt.io/qt-6/qt-intro.html?utm_source=chatgpt.com)

# 2. Peta perjalanan pembelajaran

## Learning Roadmap

1. Fase 0 — Environment & Development Foundation

   Foundation

   Persiapan toolchain, lingkungan, struktur proyek dan workflow.
2. Fase 1 — QML Language Fundamentals

   Foundation

   Sintaks, objek, tipe data, properti dan deklarasi.
3. Fase 2 — JavaScript for QML

   Foundation

   Ekspresi, fungsi, kontrol alur, scope dan modul JavaScript.
4. Fase 3 — QML Object Model & Reactivity

   Intermediate

   Property binding, signal-slot, lifecycle dan sistem objek.
5. Fase 4 — Qt Quick Visual Fundamentals

   Intermediate

   Item, koordinat, geometri, warna, gambar dan input.
6. Fase 5 — Components, Layouts & Styling

   Intermediate

   Reusable components, layout engine dan desain visual.
7. Fase 6 — Interaction, States & Animation

   Intermediate

   Event, gesture, state machine dan animasi.
8. Fase 7 — Models, Views & Data Architecture

   Advanced

   Data model, delegates, repeater dan dynamic data.
9. Fase 8 — QML Modules & Software Architecture

   Advanced

   Module system, imports, namespaces dan dependency management.
10. Fase 9 — Qt Quick Controls & Advanced UI

    Advanced

    Controls, customization, accessibility dan advanced interface.
11. Fase 10 — C++ / QML Interoperability

    Expert

    QObject, properties, registration, models dan native APIs.
12. Fase 11 — Rendering, Graphics & Performance

    Expert

    Scene graph, render loop, GPU, profiling dan optimasi.
13. Fase 12 — Testing, Debugging & Quality Engineering

    Expert

    Automated testing, linting, profiling dan reliability.
14. Fase 13 — Security, Deployment & Enterprise Engineering

    Expert / Enterprise

    Security boundaries, packaging, deployment, maintainability dan distribusi.
15. Fase 14 — Mastery & Independent Framework Engineering

    Mastery

    Membangun sistem komponen, API, plugin architecture dan framework mandiri.

## Estimasi waktu

Estimasi berikut mengasumsikan pembelajaran mandiri sekitar 15–25 jam per minggu. Waktu dapat bertambah apabila C++ dan konsep pemrograman masih benar-benar baru.

| Tahapan            | Estimasi     |
| ------------------ | ------------ |
| Foundation (0–2)   | 4–7 minggu   |
| Intermediate (3–6) | 7–11 minggu  |
| Advanced (7–9)     | 6–10 minggu  |
| Expert (10–12)     | 8–13 minggu  |
| Enterprise (13–14) | 6–10 minggu  |
| Total              | 31–51 minggu |

Ini adalah estimasi penguasaan kompetensi, bukan jaminan bahwa seluruh materi akan dikuasai hanya dengan menyelesaikan waktu tersebut.

# 3. Prasyarat pembelajaran

Tidak semua prasyarat harus dikuasai sebelum memulai. Beberapa akan dipelajari secara bertahap.

| Kompetensi                | Status         | Keterangan                                   |
| ------------------------- | -------------- | -------------------------------------------- |
| Penggunaan Linux terminal | Wajib          | Navigasi, filesystem, proses dan environment |
| Dasar pemrograman         | Wajib          | Variabel, fungsi, kondisi, perulangan        |
| OOP                       | Bertahap       | Class, object, inheritance, encapsulation    |
| JavaScript                | Bertahap       | Dasar hingga intermediate                    |
| C++                       | Untuk fase 10+ | QObject, memory, template, concurrency       |
| Matematika dasar          | Wajib          | Koordinat, persentase, geometri              |
| Graphics programming      | Opsional awal  | Diperlukan pada fase rendering lanjutan      |
| CMake                     | Bertahap       | Dibutuhkan dalam pembangunan proyek          |

## 3.1 Penyesuaian terhadap kemampuan bahasa pemrograman

Jangan mencampur semua bahasa sekaligus.

Urutan yang direkomendasikan:

1. QML sebagai bahasa utama yang dipelajari.
2. JavaScript sebagai bahasa pendamping untuk logika QML.
3. C++ ketika mulai memahami batas kemampuan QML dan membutuhkan native integration.
4. GLSL ketika memasuki pengembangan shader dan rendering khusus.

Lua dan Bash tidak perlu dijadikan prasyarat QML. Keduanya dapat tetap digunakan sebagai alat bantu otomatisasi, konfigurasi lingkungan, dan workflow pengembangan.

# 4. Alat esensial dan lingkungan pengembangan

Lingkungan yang digunakan sebaiknya mendukung pengembangan sepenuhnya melalui terminal. IDE grafis bukan persyaratan untuk menguasai QML.

## 4.1 Toolchain utama

[File:Qt logo 2016.svg - Wikimedia Commons](https://images.openai.com/static-rsc-4/kSwJpWhubwAHI5eO8y376pDK8AhbdhpxMmetZvKhySBBAOnqPXyQLC47-lhq99Ol_TqD_w0r6OzrqPENwFDpjnO9PGD6WfM-MxGRgX7mjSkFDmzcKM2uUhQ-uXLs49Zst83fF060eFOSVj3EQEZ20BfginWPibZIt7jKpY6vRn4?purpose=inline)

Qt 6 SDK

Menyediakan library, QML engine, Qt Quick, Qt Quick Controls, dan tool pengembangan.

[Qt installation documentation](https://doc.qt.io/qt-6/get-and-install-qt.html?utm_source=chatgpt.com)

[File:CMake logo.svg - Wikimedia Commons](https://images.openai.com/static-rsc-4/xUEqZe4gQMrwn_1uC0RB5GYc2TBCGT1hec1nqG4hnTApAVKUygI8LTxFXCrdCAYRvVtjRKgCRQ0UfK7dJOtH0NSpEQw5sMlqkkyRMrRkXNTo5FatXAW8MV9m0Zd1nh5ykD-pF6PJE0B7nPRRr9Vhg9KF-nMQwDi1OAfnC18D94o?purpose=inline)

CMake

Mengelola konfigurasi proyek, dependency, target executable, library dan QML module.

[CMake documentation](https://cmake.org/documentation/?utm_source=chatgpt.com)

[GitHub - ninja-build/ninja: a small build system with a focus on speed · GitHub](https://images.openai.com/static-rsc-4/hTjQ1J2aDHyXqw3H4lJgmBifcAHyNU1lV2JZam5vVWcV3VnlTb3BsWzeleyJRfAUwKNVWxKFNyNSorgO5oFGNK7HDShNjlLI-2OXbI8TaQ_GMs0bPRQoflPEdJ6oLy6FXvn3gkUjWGcKSQVorpwKxbeuzmegenG3LBdMg0qayAo?purpose=inline)

Ninja

Build backend yang ringan dan cepat.

[Ninja manual](https://ninja-build.org/manual.html?utm_source=chatgpt.com)

[Neovim Logo PNG Vector (SVG) Free Download](https://images.openai.com/static-rsc-4/gleIAvIc_JqLkRG0GKkSPpgmdFjX6Qa8y1ZW3-J70nMB9rstd50hoBr0EVZOekc_aOAOp3w48DJTLbHVbgCeq52SDebMTUG3TMl_MorufgP9lKD3SJwbz6q5DEP2v7nsa6s3dtNNj7jv1oaxKiQXaMyygvlU1TZS_rAsKIVgO3w?purpose=inline)

Neovim

Editor utama untuk QML, C++, CMake, dan JavaScript.

[Neovim documentation](https://neovim.io/doc/user/?utm_source=chatgpt.com)

## 4.2 Tool yang perlu dikuasai

| Tool               | Fungsi                                                                |
| ------------------ | --------------------------------------------------------------------- |
| `qml`              | Menjalankan aplikasi atau dokumen QML                                 |
| `qmlscene`         | Tool untuk menampilkan dokumen QML pada instalasi yang menyediakannya |
| `qmllint`          | Analisis kesalahan dan pola buruk QML                                 |
| `qmlformat`        | Memformat kode QML                                                    |
| `qmlcachegen`      | Menghasilkan cache kompilasi QML                                      |
| `qmltyperegistrar` | Menghasilkan informasi registrasi tipe QML dari metadata C++          |
| `qmltestrunner`    | Menjalankan pengujian QML                                             |
| `qmlls`            | QML Language Server                                                   |
| `qmlprofiler`      | Komponen tooling profiling QML, umumnya diakses melalui Qt Creator    |
| `cmake`            | Konfigurasi build                                                     |
| `ninja`            | Eksekusi build                                                        |
| `gdb`              | Debugging aplikasi native                                             |
| `g++`              | Compiler C++                                                          |

Ketersediaan nama executable tertentu bergantung pada versi dan paket Qt yang dipasang. Pelajari fungsi tool, kemudian verifikasi nama executable melalui `command -v` dan `--help`.

## 4.3 Rekomendasi instalasi Arch Linux

```
sudo pacman -Syu

sudo pacman -S --needed \
    qt6-base \
    qt6-declarative \
    qt6-tools \
    qt6-shadertools \
    cmake \
    ninja \
    gcc \
    gdb \
    git \
    pkgconf \
    python
```

Paket tambahan yang dapat dipertimbangkan:

```
sudo pacman -S --needed \
    qt6-5compat \
    qt6-multimedia \
    qt6-svg \
    qt6-imageformats \
    qt6-wayland
```

Paket tambahan tersebut bukan seluruhnya prasyarat Qt Quick. Pasang berdasarkan kebutuhan modul yang dipelajari.

Verifikasi:

```
qmake6 --version
cmake --version
ninja --version
g++ --version
```

Untuk memeriksa komponen Qt:

```
pacman -Q | grep '^qt6-'
```

Perhatikan bahwa `qmake6` hanya dipakai di sini sebagai salah satu cara memeriksa instalasi Qt; jalur build yang diprioritaskan dalam kurikulum ini adalah CMake.

## 4.4 Workflow pengembangan

```

# Membuat direktori proyek
mkdir -p ~/Development/qt-learning
cd ~/Development/qt-learning

# Konfigurasi
cmake -S . -B build -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug

# Build
cmake --build build

# Menjalankan aplikasi
./build/myapp

# Pemeriksaan QML
qmllint .

# Format QML
qmlformat -i Main.qml

```

# 5. Kurikulum inti

## FASE 0 — Environment & Development Foundation



Foundation

&#x20;Estimasi: 1–2 minggu



Tujuan: memahami lingkungan kerja, bagaimana Qt diinstal, bagaimana proyek dibangun, dan bagaimana QML dijalankan.

### Modul 0.1 — Qt Ecosystem & Development Environment

Deskripsi konkret

Mengenali komponen Qt 6, perbedaan Qt Core, Qt Qml, Qt Quick, Qt Quick Controls, dan bagaimana semua komponen tersebut saling berhubungan.

Konsep dan filosofi

Qt menggunakan arsitektur modular. Artinya, aplikasi tidak harus menggunakan seluruh kemampuan Qt sekaligus.

Contohnya:

- Qt Core untuk fasilitas dasar aplikasi.
- Qt Qml untuk QML engine dan sistem bahasa.
- Qt Quick untuk UI deklaratif.
- Qt Quick Controls untuk kontrol antarmuka.
- Qt Network untuk komunikasi jaringan.

Contoh pemeriksaan:

```
pkg-config --list-all | grep -i qt6
```

Terminologi:

- SDK: kumpulan perangkat pengembangan.
- Runtime: komponen yang diperlukan ketika aplikasi dijalankan.
- Library: kode yang dapat digunakan kembali.
- Framework: kumpulan library beserta struktur dan aturan penggunaannya.
- Module: bagian fungsional yang dapat digunakan secara terpisah.

Daftar isi:

1. Sejarah dan evolusi Qt.
2. Qt 5 versus Qt 6.
3. Qt Framework architecture.
4. Qt Core, Qml, Quick dan Controls.
5. SDK, runtime, library dan module.
6. Static versus shared libraries.
7. Qt licensing overview.
8. Instalasi dan verifikasi lingkungan.
9. Environment variables.
10. Qt platform plugins.

Referensi:

- [Qt Introduction](https://doc.qt.io/qt-6/qt-intro.html?utm_source=chatgpt.com)
- [Qt Modules](https://doc.qt.io/qt-6/qtmodules.html?utm_source=chatgpt.com)
- [Getting Started](https://doc.qt.io/qt-6/get-and-install-qt.html?utm_source=chatgpt.com)

### Modul 0.2 — Project Structure & Build Fundamentals

Deskripsi konkret

Mempelajari bagaimana proyek Qt disusun dan bagaimana source code berubah menjadi aplikasi yang dapat dieksekusi.

Konsep dan filosofi

Source code bukan aplikasi yang langsung dapat dijalankan. Ada tahapan konfigurasi, generasi build, kompilasi, linking, dan packaging.

Qt 6 modern menggunakan CMake sebagai jalur utama.

Contoh struktur:

```
hello-qt/
├── CMakeLists.txt
├── main.cpp
└── Main.qml
```

Contoh `CMakeLists.txt`:

```
cmake_minimum_required(VERSION 3.16)

project(HelloQt LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(hello
    main.cpp
)

qt_add_qml_module(hello
    URI Hello
    VERSION 1.0
    QML_FILES
        Main.qml
)

target_link_libraries(hello
    PRIVATE Qt6::Quick
)
```

Contoh `Main.qml`:

```
import QtQuick

Window {
    visible: true
    width: 800
    height: 600

    Text {
        anchors.centerIn: parent
        text: "Hello Qt 6"
    }
}
```

Terminologi:

- Source: kode sumber.
- Build system: sistem yang mengatur pembangunan aplikasi.
- Compiler: penerjemah kode menjadi bentuk yang dapat dieksekusi.
- Linker: penghubung objek hasil kompilasi dengan library.
- Target: executable atau library yang dibangun.
- Generator: pembentuk file build berdasarkan konfigurasi proyek.

Daftar isi:

1. Struktur proyek Qt.
2. CMakeLists.txt.
3. `find_package`.
4. `qt_standard_project_setup`.
5. `qt_add_executable`.
6. `qt_add_qml_module`.
7. Target dan linking.
8. Build directory.
9. Debug dan release build.
10. Build dependency.
11. Resource embedding.
12. Instalasi dan build reproducibility.

Referensi:

- [Building a QML Application](https://doc.qt.io/qt-6/cmake-build-qml-application.html?utm_source=chatgpt.com)
- [CMake Integration for QML](https://doc.qt.io/qt-6/qtqml-cmake-integration.html?utm_source=chatgpt.com)
- [CMake Tutorial](https://cmake.org/cmake/help/latest/guide/tutorial/index.html?utm_source=chatgpt.com)

Visualisasi direkomendasikan: diagram alur `Source → CMake → Ninja → Compiler → Linker → Executable`.

## FASE 1 — QML Language Fundamentals



Foundation

&#x20;Estimasi: 2–3 minggu



Ini merupakan fondasi paling penting. Jangan melanjutkan terlalu cepat sebelum memahami bagaimana QML mendeskripsikan objek.

### Modul 1.1 — QML Language Structure & Syntax

Deskripsi konkret

Memahami bentuk dasar dokumen QML, struktur deklarasi objek, blok properti, nested objects, dan aturan penulisan.

Konsep dan filosofi

QML adalah bahasa deklaratif.

Dalam pemrograman imperatif, kita umumnya memberikan instruksi tentang bagaimana sesuatu harus dikerjakan.

Dalam pemrograman deklaratif, kita mendeskripsikan keadaan atau hubungan yang diinginkan.

Contoh:

```
Rectangle {
    width: 300
    height: 200
    color: "red"
}
```

Deklarasi tersebut menyatakan bahwa objek yang dibuat merupakan Rectangle dengan ukuran dan warna tertentu.

Bandingkan:

```
let width = 300
let height = 200
let color = "red"
```

Contoh kedua hanya membuat variabel JavaScript. Ia belum mendeskripsikan objek visual Qt Quick.

Terminologi:

- Declarative: mendeskripsikan hasil atau keadaan.
- Imperative: mendeskripsikan langkah-langkah tindakan.
- Object declaration: deklarasi objek.
- Object hierarchy: hubungan induk dan anak antarobjek.
- Root object: objek utama dalam sebuah dokumen QML.
- Nested object: objek yang berada di dalam deklarasi objek lain.

Daftar isi:

1. Struktur dokumen `.qml`.
2. Import statements.
3. Root object.
4. Object declaration.
5. Nested objects.
6. Property declarations.
7. Property assignments.
8. Object hierarchy.
9. Comments.
10. Syntax rules.
11. Case sensitivity.
12. QML coding conventions.

Referensi:

- [Structure of a QML Document](https://doc.qt.io/qt-6/qtqml-documents-structure.html?utm_source=chatgpt.com)
- [QML Syntax](https://doc.qt.io/qt-6/qtqml-syntax-basics.html?utm_source=chatgpt.com)
- [QML Coding Conventions](https://doc.qt.io/qt-6/qml-codingconventions.html?utm_source=chatgpt.com)

### Modul 1.2 — QML Types & Basic Data Types

Deskripsi konkret

Mempelajari seluruh jenis data yang dapat digunakan untuk mendefinisikan properti dan nilai objek.

Konsep dan filosofi

Setiap properti mempunyai tipe data tertentu. Tipe data menentukan nilai apa yang dapat disimpan dan operasi apa yang relevan untuk nilai tersebut.

Contoh:

```
Item {
    property int count: 10
    property real opacityValue: 0.5
    property bool enabled: true
    property string title: "Dashboard"

    property color background: "black"
    property url iconPath: "icons/home.svg"
}
```

Terminologi:

- Primitive type: tipe data dasar.
- Strong typing: pembatasan tipe nilai.
- Type conversion: konversi tipe.
- Enumeration: kumpulan nilai bernama.
- Variant: tipe yang dapat merepresentasikan berbagai nilai.

Daftar isi:

1. `int`.
2. `real`.
3. `double`.
4. `bool`.
5. `string`.
6. `color`.
7. `url`.
8. `date`.
9. `time`.
10. `rect`.
11. `point`.
12. `size`.
13. `vector2d`, `vector3d`, `vector4d`.
14. `var`.
15. `list<T>`.
16. Enumerations.
17. Null dan undefined.
18. Type conversion.
19. Type annotations.
20. Value types dan object types.

Referensi:

- [QML Basic Types](https://doc.qt.io/qt-6/qtqml-typesystem-basictypes.html?utm_source=chatgpt.com)
- [QML Type System](https://doc.qt.io/qt-6/qtqml-typesystem-topic.html?utm_source=chatgpt.com)

### Modul 1.3 — Properties, IDs & Object Attributes

Deskripsi konkret

Memahami bagaimana setiap objek mempunyai identitas dan atribut yang dapat digunakan untuk mengontrol perilakunya.

Konsep dan filosofi

Properti merupakan salah satu pusat dari QML. Objek tidak hanya mempunyai tampilan, tetapi juga menyimpan keadaan yang dapat dibaca dan diubah.

Contoh:

```
Rectangle {
    id: panel

    width: 400
    height: 200
    color: "black"

    property string panelTitle: "Terminal"
    property bool active: true
}
```

`id` merupakan identifier internal dalam dokumen QML, bukan properti biasa dan bukan pengganti `objectName`.

Terminologi:

- Property: atribut objek.
- `id`: identifier objek dalam dokumen.
- `objectName`: nama objek yang dapat diakses melalui mekanisme QObject.
- Property alias: properti yang meneruskan akses ke properti lain.
- Read-only property: properti yang tidak dapat ditulis dari QML.
- Default property: properti yang menerima objek anak tanpa nama properti eksplisit.

Daftar isi:

1. Built-in properties.
2. Custom properties.
3. `property`.
4. `readonly property`.
5. `required property`.
6. `property alias`.
7. Object IDs.
8. Object names.
9. Default properties.
10. Grouped properties.
11. Attached properties.
12. Enumeration attributes.
13. Property visibility.
14. Property initialization.
15. Property access.

Contoh alias:

```
Item {
    id: root

    Rectangle {
        id: background
        color: "black"
    }

    property alias backgroundColor: background.color
}
```

Referensi:

- [QML Object Attributes](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html?utm_source=chatgpt.com)
- [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html?utm_source=chatgpt.com)

### Modul 1.4 — Object Types & Component Fundamentals

Deskripsi konkret

Memahami bagaimana dokumen QML dapat menjadi tipe objek baru yang bisa digunakan kembali.

Konsep dan filosofi

Satu file QML pada dasarnya dapat mendefinisikan sebuah reusable object type.

Contoh:

`Panel.qml`

```
import QtQuick

Rectangle {
    width: 300
    height: 150
    radius: 8
    color: "#202020"
}
```

`Main.qml`

```
import QtQuick

Window {
    visible: true

    Panel {
        x: 20
        y: 20
    }
}
```

Di sini `Panel` dapat digunakan seperti tipe objek lainnya.

Terminologi:

- Component: definisi objek yang dapat diinstansiasi.
- Instance: objek yang dibuat dari definisi tipe.
- Reusability: kemampuan menggunakan kembali komponen.
- Encapsulation: pembatasan detail internal.
- Composition: membangun objek dari komponen lain.

Daftar isi:

1. QML documents as types.
2. Component instances.
3. Reusable components.
4. Component inheritance.
5. Component composition.
6. Component boundaries.
7. Public interface.
8. Private implementation.
9. Component scope.
10. Naming conventions.
11. Component organization.

Referensi:

- [QML Object Types](https://doc.qt.io/qt-6/qtqml-typesystem-objecttypes.html?utm_source=chatgpt.com)
- [QML Components](https://doc.qt.io/qt-6/qml-qtqml-component.html?utm_source=chatgpt.com)

## FASE 2 — JavaScript for QML



Foundation

&#x20;Estimasi: 2–3 minggu



QML menyediakan lingkungan JavaScript untuk ekspresi, fungsi, event handler, dan operasi tertentu.

Tujuannya bukan menjadikan seluruh aplikasi sebagai JavaScript, tetapi memahami batas antara deklarasi QML dan logika imperatif.

### Modul 2.1 — JavaScript Core Language

Deskripsi konkret

Menguasai dasar JavaScript yang relevan dengan lingkungan QML.

Konsep dan filosofi

QML menggunakan JavaScript sebagai bahasa ekspresi dan logika imperatif. Namun, JavaScript di dalam QML berjalan dalam lingkungan yang dikelola QML engine dan tidak identik dengan browser.

Contoh:

```
Item {
    property int count: 0

    function increment() {
        count += 1
    }
}
```

Daftar isi:

1. Variables: `let`, `const`, `var`.
2. Primitive values.
3. Strings.
4. Numbers.
5. Boolean.
6. Arrays.
7. Objects.
8. Operators.
9. Conditions.
10. Loops.
11. Functions.
12. Parameters.
13. Return values.
14. Scope.
15. Closures.
16. Destructuring.
17. Array methods.
18. Object methods.
19. Error handling.
20. Strict mode dan batasan runtime.

Terminologi:

- Scope: wilayah tempat identifier dapat diakses.
- Closure: fungsi yang mempertahankan akses terhadap lexical environment.
- Expression: ekspresi yang menghasilkan nilai.
- Statement: instruksi yang menjalankan suatu tindakan.
- Runtime: lingkungan eksekusi kode.

Referensi:

- [JavaScript Expressions in QML](https://doc.qt.io/qt-6/qtqml-javascript-expressions.html?utm_source=chatgpt.com)
- [ECMAScript Documentation](https://tc39.es/ecma262/?utm_source=chatgpt.com)

### Modul 2.2 — JavaScript Expressions in QML

Deskripsi konkret

Mempelajari bagaimana ekspresi JavaScript digunakan di dalam properti QML.

Contoh:

```
Rectangle {
    width: parent.width / 2
    height: width * 0.5

    color: width > 200 ? "green" : "red"
}
```

Konsep dan filosofi

Ekspresi dalam properti dapat menjadi bagian dari sistem reaktif QML. Perubahan dependency dapat memicu evaluasi ulang.

Tidak semua ekspresi memiliki karakteristik yang sama. Ekspresi properti yang bergantung pada nilai lain dapat membentuk property binding, sedangkan operasi imperatif biasa tidak otomatis membentuk binding.

Daftar isi:

1. Arithmetic expressions.
2. Logical expressions.
3. Comparison operators.
4. Ternary operators.
5. String interpolation.
6. Object expressions.
7. Property references.
8. Function calls.
9. Binding expressions.
10. Expression evaluation.
11. Side effects.
12. Binding preservation.

Referensi:

- [JavaScript Expressions](https://doc.qt.io/qt-6/qtqml-javascript-expressions.html?utm_source=chatgpt.com)
- [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html?utm_source=chatgpt.com)

### Modul 2.3 — JavaScript Modules & Libraries

Deskripsi konkret

Memisahkan logika JavaScript dari dokumen visual.

Contoh:

`MathUtils.js`

```
.pragma library

function clamp(value, minimum, maximum) {
    return Math.max(
        minimum,
        Math.min(value, maximum)
    )
}
```

Penggunaan:

```
import "MathUtils.js" as MathUtils

Item {
    property real normalizedValue:
        MathUtils.clamp(150, 0, 100)
}
```

Konsep dan filosofi

Pemisahan kode memungkinkan satu fungsi digunakan oleh banyak komponen tanpa menduplikasi implementasinya.

Daftar isi:

1. JavaScript file imports.
2. `.pragma library`.
3. `.import`.
4. `.pragma ComponentBehavior`.
5. JavaScript resources.
6. Module namespaces.
7. Shared state.
8. Function libraries.
9. Pure functions.
10. Dependency management.

Terminologi:

- Library: kumpulan fungsi yang dapat digunakan kembali.
- Namespace: ruang nama untuk mengelompokkan identifier.
- Pure function: fungsi yang tidak mengubah state eksternal dan menghasilkan output berdasarkan input.
- Shared state: keadaan yang digunakan bersama beberapa bagian aplikasi.

Referensi:

- [QML JavaScript Resources](https://doc.qt.io/qt-6/qtqml-javascript-resources.html?utm_source=chatgpt.com)
- [QML Import Statements](https://doc.qt.io/qt-6/qtqml-syntax-imports.html?utm_source=chatgpt.com)

### Modul 2.4 — QML and JavaScript Execution Boundaries

Deskripsi konkret

Memahami batas antara JavaScript yang berjalan dalam QML engine dan fitur JavaScript yang tersedia pada browser atau Node.js.

Konsep dan filosofi

QML bukan browser. API seperti `document`, `window` browser, `localStorage`, dan Node.js `process` tidak otomatis tersedia.

Pelajari juga keterbatasan operasi sinkron yang berat dan bagaimana pekerjaan asinkron sebaiknya ditangani melalui API Qt yang sesuai.

Daftar isi:

1. QML JavaScript engine.
2. Global objects.
3. Available JavaScript APIs.
4. Unsupported browser APIs.
5. Unsupported Node.js APIs.
6. JavaScript garbage collection.
7. Script execution.
8. Asynchronous operations.
9. Promise support.
10. QML JavaScript restrictions.
11. Engine ownership.
12. Script performance.

Referensi:

- [QML JavaScript Environment](https://doc.qt.io/qt-6/qtqml-javascript-topic.html?utm_source=chatgpt.com)
- [QML JavaScript Expressions](https://doc.qt.io/qt-6/qtqml-javascript-expressions.html?utm_source=chatgpt.com)

## FASE 3 — QML Object Model & Reactivity



Intermediate

&#x20;Estimasi: 2–3 minggu



Ini merupakan fase transisi dari sekadar memahami sintaks menuju memahami bagaimana QML bekerja sebagai sebuah sistem objek reaktif.

### Modul 3.1 — Property Binding System

Deskripsi konkret

Memahami sistem hubungan antarnilai properti.

Konsep dan filosofi

Property binding adalah mekanisme yang membuat sebuah properti mengikuti hasil ekspresi yang bergantung pada properti lain.

Contoh:

```
Item {
    width: 800

    Rectangle {
        width: parent.width / 2
    }
}
```

Jika ukuran induk berubah, ukuran Rectangle akan dihitung ulang.

Hal yang sangat penting adalah memahami perbedaan antara binding dan assignment imperatif.

```
Rectangle {
    width: parent.width / 2

    function resize() {
        width = 300
    }
}
```

Assignment imperatif tersebut dapat menggantikan binding yang sebelumnya terpasang.

Daftar isi:

1. Reactive programming.
2. Property dependencies.
3. Binding expressions.
4. Binding evaluation.
5. Binding updates.
6. Binding loops.
7. Binding removal.
8. `Qt.binding()`.
9. Imperative assignments.
10. Binding debugging.
11. Binding performance.
12. Binding best practices.

Terminologi:

- Reactive system: sistem yang bereaksi terhadap perubahan data.
- Dependency graph: hubungan ketergantungan antarproperti.
- Binding loop: kondisi ketika properti saling bergantung secara melingkar.
- Evaluation: proses menghitung hasil ekspresi.

Referensi:

- [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html?utm_source=chatgpt.com)
- [Debugging Property Bindings](https://doc.qt.io/qt-6/qtqml-debugging.html?utm_source=chatgpt.com)

### Modul 3.2 — Signals & Slots

Deskripsi konkret

Mempelajari komunikasi antarkomponen melalui event dan notifikasi.

Konsep dan filosofi

Sebuah objek tidak harus mengetahui seluruh detail objek lain untuk memberi tahu bahwa suatu peristiwa telah terjadi.

Signal menjadi mekanisme komunikasi yang mengurangi ketergantungan langsung antarobjek.

Contoh:

```
Item {
    id: root

    signal messageSent(string message)

    function sendMessage() {
        messageSent("Hello")
    }

    Component.onCompleted: {
        messageSent.connect(function(message) {
            console.log(message)
        })

        sendMessage()
    }
}
```

Daftar isi:

1. Signal declaration.
2. Signal parameters.
3. Signal emission.
4. Signal handlers.
5. `onClicked`.
6. Custom signal handlers.
7. Signal connections.
8. `Connections`.
9. Signal forwarding.
10. Signal disconnection.
11. Signal-to-signal communication.
12. Signal and slot architecture.

Terminologi:

- Signal: pemberitahuan bahwa suatu kejadian berlangsung.
- Slot: fungsi atau mekanisme penerima signal dalam sistem Qt.
- Signal handler: fungsi penanganan signal.
- Event-driven: arsitektur yang merespons kejadian.
- Loose coupling: hubungan antarkomponen yang tidak terlalu bergantung satu sama lain.

Referensi:

- [Signals and Handlers](https://doc.qt.io/qt-6/qtqml-syntax-signals.html?utm_source=chatgpt.com)
- [Connections](https://doc.qt.io/qt-6/qml-qtqml-connections.html?utm_source=chatgpt.com)

### Modul 3.3 — QML Object Lifecycle

Deskripsi konkret

Memahami bagaimana objek dibuat, diinisialisasi, ditampilkan, diubah, dan dihancurkan.

Konsep dan filosofi

Objek QML memiliki lifecycle. Tidak semua objek dibuat pada waktu aplikasi dimulai. Ada objek yang dibuat ketika dibutuhkan dan dihancurkan ketika tidak lagi diperlukan.

Contoh:

```
Item {
    Component.onCompleted: {
        console.log("Object created")
    }

    Component.onDestruction: {
        console.log("Object destroyed")
    }
}
```

Daftar isi:

1. Object construction.
2. Property initialization.
3. Component completion.
4. `Component.onCompleted`.
5. `Component.onDestruction`.
6. Object ownership.
7. Parent-child relationships.
8. Dynamic creation.
9. Dynamic destruction.
10. Object garbage collection.
11. Deferred initialization.
12. Lifecycle debugging.

Referensi:

- [QML Object Attributes](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html?utm_source=chatgpt.com)
- [Component Lifecycle](https://doc.qt.io/qt-6/qml-qtqml-component.html?utm_source=chatgpt.com)

### Modul 3.4 — Context, Scope & Component Boundaries

Deskripsi konkret

Memahami bagaimana identifier, properti, objek, dan data dapat diakses dari berbagai bagian dokumen QML.

Konsep dan filosofi

QML memiliki aturan scope dan context yang memengaruhi bagaimana sebuah nama diinterpretasikan.

Sistem ini sangat penting untuk mencegah konflik identifier, akses properti yang ambigu, dan kesalahan arsitektur.

Daftar isi:

1. Lexical scope.
2. Object scope.
3. Component scope.
4. ID visibility.
5. Parent context.
6. Creation context.
7. Context properties.
8. Context objects.
9. Context hierarchy.
10. Qualified property access.
11. Required properties.
12. Scope debugging.

Referensi:

- [QML Scope and Naming Resolution](https://doc.qt.io/qt-6/qtqml-documents-scope.html?utm_source=chatgpt.com)
- [QML Context and Scope](https://doc.qt.io/qt-6/qtqml-cppintegration-contextproperties.html?utm_source=chatgpt.com)

## FASE 4 — Qt Quick Visual Fundamentals



Intermediate

&#x20;Estimasi: 2–3 minggu



Pada fase ini, fokus berpindah dari bahasa menuju sistem visual.

### Modul 4.1 — Qt Quick Item System

Deskripsi konkret

Memahami objek visual dasar yang menjadi fondasi seluruh antarmuka Qt Quick.

Konsep dan filosofi

`Item` merupakan tipe dasar untuk sebagian besar objek visual Qt Quick.

Ia menyediakan geometri, transformasi, opacity, visibility, dan hubungan parent-child.

Contoh:

```
import QtQuick

Window {
    visible: true
    width: 800
    height: 600

    Item {
        width: 400
        height: 300

        Rectangle {
            anchors.fill: parent
            color: "#222222"
        }
    }
}
```

Daftar isi:

1. `Item`.
2. `Rectangle`.
3. `Window`.
4. `Text`.
5. `Image`.
6. `BorderImage`.
7. `AnimatedImage`.
8. `Canvas`.
9. `ShaderEffect`.
10. Parent-child visual hierarchy.
11. Visual stacking.
12. Visibility.
13. Opacity.
14. Clipping.
15. Z ordering.

Terminologi:

- Visual item: objek yang berpartisipasi dalam tampilan grafis.
- Parent: objek induk.
- Child: objek anak.
- Z-order: urutan kedalaman penggambaran.
- Clipping: pembatasan area penggambaran.
- Opacity: tingkat transparansi.

Referensi:

- [Qt Quick Overview](https://doc.qt.io/qt-6/qtquick-index.html?utm_source=chatgpt.com)
- [Item](https://doc.qt.io/qt-6/qml-qtquick-item.html?utm_source=chatgpt.com)
- [Rectangle](https://doc.qt.io/qt-6/qml-qtquick-rectangle.html?utm_source=chatgpt.com)

### Modul 4.2 — Geometry & Coordinate Systems

Deskripsi konkret

Mempelajari posisi, ukuran, koordinat, transformasi dan hubungan geometri antarobjek.

Konsep dan filosofi

Qt Quick menggunakan sistem koordinat lokal untuk objek visual. Posisi sebuah child umumnya ditentukan relatif terhadap sistem koordinat parent.

Contoh:

```
Rectangle {
    width: 500
    height: 300

    Rectangle {
        x: 50
        y: 40
        width: 100
        height: 100
        color: "red"
    }
}
```

Daftar isi:

1. X/Y coordinates.
2. Width and height.
3. Local coordinate systems.
4. Parent coordinate systems.
5. Anchors.
6. Margins.
7. Center alignment.
8. Scale.
9. Rotation.
10. Transform origin.
11. Transformations.
12. Mapping coordinates.
13. Geometry calculations.
14. High-DPI scaling.
15. Device-independent pixels.

Referensi:

- [Positioning](https://doc.qt.io/qt-6/qtquick-positioning-topic.html?utm_source=chatgpt.com)
- [Anchors](https://doc.qt.io/qt-6/qtquick-positioning-anchors.html?utm_source=chatgpt.com)
- [Item API](https://doc.qt.io/qt-6/qml-qtquick-item.html?utm_source=chatgpt.com)

### Modul 4.3 — Colors, Images, Fonts & Visual Resources

Deskripsi konkret

Memahami bagaimana elemen grafis dan resource visual digunakan dalam aplikasi.

Konsep dan filosofi

Resource visual tidak hanya berkaitan dengan tampilan. Format gambar, resolusi, ukuran file, font, dan strategi pemuatan memengaruhi kualitas serta performa.

Contoh:

```
Image {
    source: "assets/icons/home.png"
    width: 64
    height: 64
    fillMode: Image.PreserveAspectFit
}
```

Daftar isi:

1. Color values.
2. Hexadecimal colors.
3. RGBA.
4. Gradients.
5. Image loading.
6. Image providers.
7. Image fill modes.
8. SVG resources.
9. Font loading.
10. Font families.
11. Font weights.
12. Text rendering.
13. Resource aliases.
14. Resource URLs.
15. Qt Resource System.
16. Asset optimization.

Referensi:

- [Image](https://doc.qt.io/qt-6/qml-qtquick-image.html?utm_source=chatgpt.com)
- [Text](https://doc.qt.io/qt-6/qml-qtquick-text.html?utm_source=chatgpt.com)
- [Gradients](https://doc.qt.io/qt-6/qtquick-gradient.html?utm_source=chatgpt.com)
- [Qt Resource System](https://doc.qt.io/qt-6/resources.html?utm_source=chatgpt.com)

### Modul 4.4 — Input Events & Hit Testing

Deskripsi konkret

Mempelajari bagaimana objek visual menerima input dari pengguna.

Konsep dan filosofi

Antarmuka tidak hanya menampilkan elemen. Ia harus mampu mendeteksi interaksi dan menentukan objek yang menerima input.

Contoh:

```
Rectangle {
    width: 200
    height: 100
    color: "blue"

    MouseArea {
        anchors.fill: parent

        onClicked: {
            console.log("Clicked")
        }
    }
}
```

Daftar isi:

1. Mouse events.
2. Keyboard events.
3. Focus.
4. Focus scopes.
5. Tab navigation.
6. Hit testing.
7. Pointer events.
8. MouseArea.
9. HoverHandler.
10. TapHandler.
11. DragHandler.
12. WheelHandler.
13. Multi-touch.
14. Event propagation.
15. Input acceptance.
16. Input priority.

Referensi:

- [Qt Quick Input](https://doc.qt.io/qt-6/qtquick-input-topic.html?utm_source=chatgpt.com)
- [MouseArea](https://doc.qt.io/qt-6/qml-qtquick-mousearea.html?utm_source=chatgpt.com)
- [Input Handlers](https://doc.qt.io/qt-6/qtquickhandlers-index.html?utm_source=chatgpt.com)

## FASE 5 — Components, Layouts & Styling



Intermediate

&#x20;Estimasi: 2 minggu



### Modul 5.1 — Component Architecture

Deskripsi konkret

Membangun antarmuka menggunakan komponen independen yang memiliki tanggung jawab jelas.

Konsep dan filosofi

Komponen yang baik memiliki kontrak penggunaan yang jelas. Pengguna komponen seharusnya tidak perlu mengetahui detail internal implementasinya.

Contoh:

```
// Card.qml
import QtQuick

Rectangle {
    required property string title

    width: 250
    height: 120
    radius: 8

    Text {
        anchors.centerIn: parent
        text: parent.title
    }
}
```

Daftar isi:

1. Component decomposition.
2. Reusable components.
3. Required properties.
4. Public properties.
5. Private implementation.
6. Component contracts.
7. Composition.
8. Component inheritance.
9. Default properties.
10. Property aliases.
11. Slots menggunakan `default property` dan `Component`.
12. Component testing.
13. Component documentation.

Referensi:

- [QML Components](https://doc.qt.io/qt-6/qtqml-typesystem-components.html?utm_source=chatgpt.com)
- [QML Object Types](https://doc.qt.io/qt-6/qtqml-typesystem-objecttypes.html?utm_source=chatgpt.com)

### Modul 5.2 — Positioners & Layout Management

Deskripsi konkret

Mengatur posisi dan ukuran elemen secara otomatis tanpa menghitung seluruh koordinat secara manual.

Konsep dan filosofi

Positioner dan Layout mempunyai tujuan berbeda.

Positioner mengatur susunan objek berdasarkan aturan posisi. Layout mengelola ruang dan ukuran komponen berdasarkan kebijakan layout.

Contoh positioner:

```
Row {
    spacing: 10

    Rectangle { width: 80; height: 80 }
    Rectangle { width: 80; height: 80 }
    Rectangle { width: 80; height: 80 }
}
```

Contoh layout:

```
import QtQuick
import QtQuick.Layouts

RowLayout {
    spacing: 10

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 80
    }

    Rectangle {
        Layout.preferredWidth: 120
        Layout.preferredHeight: 80
    }
}
```

Daftar isi:

1. Row.
2. Column.
3. Grid.
4. Flow.
5. RowLayout.
6. ColumnLayout.
7. GridLayout.
8. Layout attached properties.
9. Spacing.
10. Margins.
11. Alignment.
12. Fill width/height.
13. Preferred dimensions.
14. Minimum and maximum dimensions.
15. Responsive layouts.
16. Nested layouts.
17. Layout performance.
18. Positioner versus Layout.

Referensi:

- [Qt Quick Positioners](https://doc.qt.io/qt-6/qtquick-positioning-topic.html?utm_source=chatgpt.com)
- [Qt Quick Layouts](https://doc.qt.io/qt-6/qtquicklayouts-index.html?utm_source=chatgpt.com)

### Modul 5.3 — Styling & Visual Design Architecture

Deskripsi konkret

Membangun sistem tampilan konsisten yang dapat digunakan oleh banyak komponen.

Konsep dan filosofi

Styling yang baik tidak menyimpan seluruh keputusan desain secara terpisah pada setiap objek. Gunakan token desain, tema, dan komponen visual bersama.

Contoh:

```
// Theme.qml
pragma Singleton
import QtQuick

QtObject {
    readonly property color background: "#111111"
    readonly property color surface: "#202020"
    readonly property color foreground: "#ffffff"
    readonly property color accent: "#80cbc4"

    readonly property int radius: 8
    readonly property int spacing: 12
}
```

Daftar isi:

1. Design tokens.
2. Color systems.
3. Typography systems.
4. Spacing systems.
5. Border systems.
6. Elevation and shadows.
7. Themes.
8. Light and dark modes.
9. Singleton-based theme.
10. Reusable style components.
11. Style inheritance limitations.
12. Runtime theme switching.
13. Design consistency.
14. Component visual contracts.

Referensi:

- [QML Singletons](https://doc.qt.io/qt-6/qml-singleton.html?utm_source=chatgpt.com)
- [Qt Quick Controls Styling](https://doc.qt.io/qt-6/qtquickcontrols-styles.html?utm_source=chatgpt.com)

## FASE 6 — Interaction, States & Animation



Intermediate

&#x20;Estimasi: 2–3 minggu



### Modul 6.1 — State Management

Deskripsi konkret

Mengelola keadaan objek ketika aplikasi mengalami perubahan kondisi.

Konsep dan filosofi

State menggambarkan kondisi sebuah objek. State yang berbeda dapat menghasilkan perubahan properti, posisi, ukuran, atau tampilan.

Contoh:

```
Rectangle {
    id: panel

    width: 200
    height: 100
    color: "blue"

    states: [
        State {
            name: "expanded"

            PropertyChanges {
                panel.width: 400
                panel.height: 200
                panel.color: "green"
            }
        }
    ]

    MouseArea {
        anchors.fill: parent
        onClicked: {
            panel.state =
                panel.state === "expanded"
                ? ""
                : "expanded"
        }
    }
}
```

Daftar isi:

1. Object state.
2. Default state.
3. State definitions.
4. State transitions.
5. PropertyChanges.
6. State groups.
7. State selection.
8. State restoration.
9. State conflicts.
10. State machines.
11. State-driven UI.
12. State debugging.

Referensi:

\- [Qt Quick States](https://doc.qt.io/qt-6/qtquick-statesanimations-states.html?utm_source=chatgpt.com)

### Modul 6.2 — Animation System

Deskripsi konkret

Mempelajari bagaimana properti berubah secara bertahap dalam rentang waktu tertentu.

Konsep dan filosofi

Animasi adalah interpolasi nilai dari kondisi awal menuju kondisi akhir.

Contoh:

```
Rectangle {
    id: box

    width: 100
    height: 100
    color: "red"

    NumberAnimation on x {
        from: 0
        to: 400
        duration: 1000
        running: true
    }
}
```

Daftar isi:

1. Animation fundamentals.
2. NumberAnimation.
3. ColorAnimation.
4. RotationAnimation.
5. SequentialAnimation.
6. ParallelAnimation.
7. PropertyAnimation.
8. Behavior.
9. Transition.
10. Easing curves.
11. Animation loops.
12. Animation groups.
13. Animation interruption.
14. Animation performance.
15. Frame synchronization.

Terminologi:

- Interpolation: perhitungan nilai antara dua kondisi.
- Easing: kurva pengaturan percepatan dan perlambatan.
- Frame: satu gambar dalam rangkaian rendering.
- Duration: durasi animasi.
- Transition: perubahan antarstate dengan animasi.

Referensi:

- [Qt Quick Animations](https://doc.qt.io/qt-6/qtquick-statesanimations-animations.html?utm_source=chatgpt.com)
- [Animation Types](https://doc.qt.io/qt-6/qtquick-animation-overview.html?utm_source=chatgpt.com)

### Modul 6.3 — Advanced Input & Interaction

Deskripsi konkret

Membuat interaksi yang lebih kompleks daripada klik sederhana.

Daftar isi:

1. Drag and drop.
2. Multi-touch.
3. Gesture recognition.
4. Pointer handlers.
5. Event filtering.
6. Input propagation.
7. Keyboard shortcuts.
8. Focus management.
9. Mouse capture.
10. Wheel interaction.
11. Touchpad gestures.
12. Interaction state.
13. Input latency.

Contoh:

```
Rectangle {
    width: 150
    height: 150

    DragHandler {
        target: parent
    }
}
```

Referensi:

- [Qt Quick Input](https://doc.qt.io/qt-6/qtquick-input-topic.html?utm_source=chatgpt.com)
- [Pointer Handlers](https://doc.qt.io/qt-6/qtquickhandlers-index.html?utm_source=chatgpt.com)

## FASE 7 — Models, Views & Data Architecture



Advanced

&#x20;Estimasi: 2–3 minggu



Fase ini penting untuk membangun antarmuka yang menampilkan data dinamis.

### Modul 7.1 — Models & Data Sources

Deskripsi konkret

Mempelajari bagaimana data direpresentasikan sebelum ditampilkan pada antarmuka.

Konsep dan filosofi

Model bertugas menyediakan data. View bertugas menampilkan data. Delegate bertugas menentukan representasi visual setiap elemen.

Contoh:

```
ListModel {
    id: people

    ListElement {
        name: "Alice"
        age: 24
    }

    ListElement {
        name: "Bob"
        age: 30
    }
}
```

Daftar isi:

1. Data model.
2. ListModel.
3. ListElement.
4. JavaScript arrays.
5. Object models.
6. String models.
7. Dynamic data.
8. Model roles.
9. Model updates.
10. Model notifications.
11. Data ownership.
12. Model-view separation.

Referensi:

- [Qt Quick Models and Views](https://doc.qt.io/qt-6/qtquick-modelviewsdata-modelview.html?utm_source=chatgpt.com)
- [ListModel](https://doc.qt.io/qt-6/qml-qtqml-models-listmodel.html?utm_source=chatgpt.com)

### Modul 7.2 — Views & Delegates

Deskripsi konkret

Membangun daftar, tabel, grid, dan koleksi elemen visual berdasarkan model.

Konsep dan filosofi

View tidak perlu mengetahui bagaimana seluruh data dibuat. Ia hanya membutuhkan model yang menyediakan struktur data yang dapat diakses.

Contoh:

```
ListView {
    width: 300
    height: 400

    model: people

    delegate: Rectangle {
        width: ListView.view.width
        height: 50

        Text {
            anchors.centerIn: parent
            text: model.name
        }
    }
}
```

Daftar isi:

1. ListView.
2. GridView.
3. TableView.
4. Repeater.
5. Delegate.
6. Delegate context.
7. Model roles.
8. Delegate lifecycle.
9. Delegate reuse.
10. View positioning.
11. View transitions.
12. Section headers.
13. Header and footer.
14. Virtualization.
15. View performance.

Terminologi:

- View: komponen yang menampilkan data.
- Delegate: komponen visual untuk setiap entri data.
- Role: nama atribut dalam model.
- Virtualization: membuat elemen visual hanya ketika diperlukan.
- Recycling: menggunakan kembali objek visual yang sudah ada.

Referensi:

- [Qt Quick Views](https://doc.qt.io/qt-6/qtquick-modelviewsdata-modelview.html?utm_source=chatgpt.com)
- [ListView](https://doc.qt.io/qt-6/qml-qtquick-listview.html?utm_source=chatgpt.com)
- [GridView](https://doc.qt.io/qt-6/qml-qtquick-gridview.html?utm_source=chatgpt.com)
- [TableView](https://doc.qt.io/qt-6/qml-qtquick-tableview.html?utm_source=chatgpt.com)
- [Repeater](https://doc.qt.io/qt-6/qml-qtquick-repeater.html?utm_source=chatgpt.com)

### Modul 7.3 — Dynamic Object Creation

Deskripsi konkret

Mempelajari cara membuat dan menghancurkan objek ketika aplikasi sedang berjalan.

Konsep dan filosofi

Tidak seluruh komponen perlu dibuat saat aplikasi pertama kali dimulai. Dynamic creation membantu mengendalikan penggunaan resource dan struktur objek.

Contoh:

```
Component {
    id: dynamicRectangle

    Rectangle {
        width: 100
        height: 100
        color: "red"
    }
}

function createRectangle() {
    const object = dynamicRectangle.createObject(
        parent,
        { x: 100, y: 100 }
    )
}
```

Daftar isi:

1. Component.
2. Component.createObject.
3. Component.incubateObject.
4. Qt.createComponent.
5. Qt.createQmlObject.
6. Dynamic properties.
7. Object ownership.
8. Creation context.
9. Asynchronous incubation.
10. Object destruction.
11. Dynamic component loading.
12. Error handling.

Referensi:

- [Dynamic QML Object Creation](https://doc.qt.io/qt-6/qtqml-javascript-dynamicobjectcreation.html?utm_source=chatgpt.com)
- [Component](https://doc.qt.io/qt-6/qml-qtqml-component.html?utm_source=chatgpt.com)

### Modul 7.4 — Data Transformation & Asynchronous Data

Deskripsi konkret

Mengelola data yang berasal dari proses asynchronous, pemrosesan eksternal, atau sumber yang berubah sewaktu-waktu.

Daftar isi:

1. JavaScript promises.
2. Timers.
3. XMLHttpRequest.
4. Network responses.
5. Data parsing.
6. JSON.
7. Data validation.
8. Loading states.
9. Error states.
10. Cancellation.
11. Asynchronous object creation.
12. Data synchronization.
13. Stale data.
14. Update notifications.

Referensi:

- [QML JavaScript](https://doc.qt.io/qt-6/qtqml-javascript-topic.html?utm_source=chatgpt.com)
- [Qt Network](https://doc.qt.io/qt-6/qtnetwork-index.html?utm_source=chatgpt.com)
- [JSON Support](https://doc.qt.io/qt-6/json.html?utm_source=chatgpt.com)

## FASE 8 — QML Modules & Software Architecture



Advanced

&#x20;Estimasi: 2–3 minggu



Pada fase ini, pembelajaran beralih dari membangun aplikasi kecil menuju menyusun sistem komponen yang dapat dikembangkan dan digunakan kembali.

### Modul 8.1 — QML Module System

Deskripsi konkret

Memahami bagaimana QML mengelompokkan tipe objek dan resource menjadi module yang dapat diimpor.

Konsep dan filosofi

QML module adalah unit logis yang menyediakan kumpulan tipe dan resource dalam namespace tertentu.

Contoh:

```
import QtQuick
import MyCompany.Controls
import MyCompany.Theme
```

Dengan pendekatan ini, aplikasi dapat menggunakan modul internal maupun eksternal.

Daftar isi:

1. QML module concepts.
2. Module URI.
3. Module imports.
4. Import aliases.
5. Versioning.
6. `qmldir`.
7. `qmltypes`.
8. Import paths.
9. Resource paths.
10. Module dependencies.
11. Module discovery.
12. Local imports.
13. Plugin modules.
14. Static modules.
15. Shared modules.

Terminologi:

- URI: identifier unik untuk namespace modul.
- Import path: lokasi pencarian modul.
- Module dependency: ketergantungan satu modul terhadap modul lainnya.
- Type namespace: ruang nama yang menyediakan tipe tertentu.
- Plugin: library yang menyediakan implementasi tambahan yang dapat dimuat sistem.

Referensi:

- [QML Modules](https://doc.qt.io/qt-6/qtqml-modules-topic.html?utm_source=chatgpt.com)
- [Import Statements](https://doc.qt.io/qt-6/qtqml-syntax-imports.html?utm_source=chatgpt.com)
- [QML Module Directory](https://doc.qt.io/qt-6/qtqml-modules-qmldir.html?utm_source=chatgpt.com)

### Modul 8.2 — Advanced QML Component Architecture

Deskripsi konkret

Membangun sistem komponen berskala besar dengan pembagian tanggung jawab yang terukur.

Konsep dan filosofi

Arsitektur yang baik memisahkan:

- Visual representation.
- Application state.
- Business logic.
- Data access.
- Infrastructure.

Contoh struktur:

```
application/
├── CMakeLists.txt
├── src/
│   ├── main.cpp
│   ├── backend/
│   └── services/
├── qml/
│   ├── Main.qml
│   ├── components/
│   ├── layouts/
│   ├── pages/
│   ├── themes/
│   └── models/
├── assets/
└── tests/
```

Daftar isi:

1. Separation of concerns.
2. Modular architecture.
3. Component contracts.
4. Dependency boundaries.
5. Reusable UI libraries.
6. Feature modules.
7. Shared components.
8. Application services.
9. State ownership.
10. Data flow.
11. Event communication.
12. Dependency inversion.
13. Composition over inheritance.
14. Naming and API conventions.
15. Architectural documentation.

Referensi:

- [QML Modules](https://doc.qt.io/qt-6/qtqml-modules-topic.html?utm_source=chatgpt.com)
- [QML Best Practices](https://doc.qt.io/qt-6/qtqml-best-practices.html?utm_source=chatgpt.com)

### Modul 8.3 — CMake & QML Module Engineering

Deskripsi konkret

Menguasai bagaimana proyek Qt 6 modern dibangun dan bagaimana modul internal disusun menggunakan CMake.

Konsep dan filosofi

`qt_add_qml_module()` merupakan API utama untuk mendefinisikan QML module modern.

Ia mengatur banyak pekerjaan yang sebelumnya harus dilakukan secara manual, termasuk registrasi tipe, resource embedding, plugin dan integrasi tooling.

Contoh:

```
qt_add_qml_module(controls
    URI MyCompany.Controls

    QML_FILES
        Button.qml
        Panel.qml
        Card.qml

    RESOURCES
        icons/home.svg
        icons/settings.svg
)
```

Daftar isi:

1. CMake targets.
2. Executable targets.
3. Library targets.
4. `qt_add_qml_module`.
5. `qt_add_executable`.
6. `qt_add_library`.
7. QML source registration.
8. C++ source registration.
9. Resource registration.
10. Module URI.
11. Plugin generation.
12. Type information.
13. Resource prefix.
14. Import paths.
15. Static versus shared module.
16. Build configurations.
17. CMake policies.
18. Build dependency management.

Referensi:

- [CMake Integration for QML](https://doc.qt.io/qt-6/qtqml-cmake-integration.html?utm_source=chatgpt.com)
- [qt_add_qml_module](https://doc.qt.io/qt-6/qt-add-qml-module.html?utm_source=chatgpt.com)
- [Writing QML Modules](https://doc.qt.io/qt-6/qtqml-writing-a-module.html?utm_source=chatgpt.com)

## FASE 9 — Qt Quick Controls & Advanced UI Engineering



Advanced

&#x20;Estimasi: 2–3 minggu



Fase ini berfokus pada komponen antarmuka siap pakai dan bagaimana memodifikasi perilakunya sampai tingkat implementasi internal.

### Modul 9.1 — Qt Quick Controls Fundamentals

Deskripsi konkret

Menguasai komponen antarmuka yang disediakan Qt Quick Controls.

Konsep dan filosofi

Qt Quick menyediakan primitive visual, sedangkan Qt Quick Controls menyediakan komponen UI tingkat lebih tinggi.

Perbedaannya:

- `Rectangle` adalah primitive visual.
- `Button` adalah kontrol antarmuka.
- `TextField` adalah kontrol input teks.
- `Slider` adalah kontrol untuk memilih nilai dalam rentang tertentu.

Contoh:

```
import QtQuick
import QtQuick.Controls

ApplicationWindow {
    visible: true
    width: 800
    height: 600

    Column {
        anchors.centerIn: parent
        spacing: 12

        Button {
            text: "Execute"
            onClicked: console.log("Executed")
        }

        TextField {
            placeholderText: "Enter command"
        }

        Switch {
            text: "Enable service"
        }

        Slider {
            from: 0
            to: 100
        }
    }
}
```

Daftar isi:

1. ApplicationWindow.
2. Button.
3. AbstractButton.
4. ToolButton.
5. CheckBox.
6. RadioButton.
7. Switch.
8. Slider.
9. Dial.
10. SpinBox.
11. TextField.
12. TextArea.
13. ComboBox.
14. Menu.
15. Popup.
16. Dialog.
17. Drawer.
18. ScrollView.
19. ScrollBar.
20. TabBar.
21. StackView.
22. SwipeView.
23. SplitView.
24. ToolTip.
25. BusyIndicator.
26. ProgressBar.

Terminologi:

- Control: komponen antarmuka yang menyediakan perilaku interaktif.
- Abstract control: kelas dasar yang menyediakan perilaku umum untuk kontrol turunannya.
- Popup: komponen yang muncul di atas antarmuka utama.
- Dialog: jendela interaksi yang meminta perhatian atau input pengguna.
- Navigation: mekanisme perpindahan antartampilan.

Referensi:

- [Qt Quick Controls](https://doc.qt.io/qt-6/qtquickcontrols-index.html?utm_source=chatgpt.com)
- [Qt Quick Controls Types](https://doc.qt.io/qt-6/qtquickcontrols-qmlmodule.html?utm_source=chatgpt.com)

### Modul 9.2 — Controls Customization & Styling

Deskripsi konkret

Mengubah tampilan dan perilaku kontrol standar sampai menghasilkan komponen yang memiliki identitas visual sendiri.

Konsep dan filosofi

Salah satu kekuatan Qt Quick Controls adalah pemisahan antara:

1. Control: logika dan perilaku.
2. Delegate: representasi visual.
3. Style: aturan tampilan dan interaksi visual.

Contoh pendekatan custom Button:

```
Button {
    id: control

    text: "Launch"

    background: Rectangle {
        radius: 8

        color: control.down
            ? "#333333"
            : control.hovered
                ? "#555555"
                : "#222222"
    }

    contentItem: Text {
        text: control.text
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
```

Daftar isi:

1. Control customization.
2. Background customization.
3. Content item customization.
4. Indicator customization.
5. Delegate customization.
6. Control properties.
7. Control inheritance.
8. Custom Control.
9. Custom style.
10. Default style.
11. Basic style.
12. Fusion style.
13. Material style.
14. Universal style.
15. Imagine style.
16. Style selection.
17. Runtime style considerations.
18. Palette and theme.
19. Style deployment.
20. Reusable control library.

Referensi:

- [Customizing Qt Quick Controls](https://doc.qt.io/qt-6/qtquickcontrols-customize.html?utm_source=chatgpt.com)
- [Qt Quick Controls Styles](https://doc.qt.io/qt-6/qtquickcontrols-styles.html?utm_source=chatgpt.com)
- [Creating Custom Controls](https://doc.qt.io/qt-6/qtquickcontrols-customize.html?utm_source=chatgpt.com)

### Modul 9.3 — Advanced Navigation & Multi-Window Interfaces

Deskripsi konkret

Membangun antarmuka dengan banyak halaman, navigasi bertingkat, popup, dialog, dan beberapa window.

Konsep dan filosofi

Aplikasi yang kompleks membutuhkan pengelolaan tampilan yang terstruktur. Perpindahan antartampilan sebaiknya tidak dilakukan dengan membuat ulang seluruh aplikasi tanpa kebutuhan.

Daftar isi:

1. ApplicationWindow.
2. Window.
3. DialogWindow.
4. Multiple windows.
5. Window ownership.
6. Window visibility.
7. StackView navigation.
8. Page transitions.
9. Navigation state.
10. Popup positioning.
11. Drawer navigation.
12. Overlay.
13. Modal and non-modal dialogs.
14. Window activation.
15. Window lifecycle.
16. Multi-screen considerations.

Contoh:

```
ApplicationWindow {
    visible: true

    StackView {
        id: navigation

        anchors.fill: parent
        initialItem: "HomePage.qml"
    }

    function openSettings() {
        navigation.push("SettingsPage.qml")
    }
}
```

Referensi:

- [StackView](https://doc.qt.io/qt-6/qml-qtquick-controls-stackview.html?utm_source=chatgpt.com)
- [Window](https://doc.qt.io/qt-6/qml-qtquick-window.html?utm_source=chatgpt.com)
- [ApplicationWindow](https://doc.qt.io/qt-6/qml-qtquick-controls-applicationwindow.html?utm_source=chatgpt.com)

### Modul 9.4 — Accessibility & Internationalization

Deskripsi konkret

Membangun UI yang dapat digunakan melalui berbagai metode input dan oleh pengguna dengan kebutuhan aksesibilitas berbeda.

Konsep dan filosofi

Antarmuka yang dapat digunakan secara visual belum tentu dapat diakses melalui keyboard atau teknologi bantu.

Accessibility harus menjadi bagian dari desain komponen, bukan tambahan terakhir.

Daftar isi:

1. Accessible roles.
2. Accessible names.
3. Accessible descriptions.
4. Accessible properties.
5. Keyboard navigation.
6. Focus order.
7. Screen reader support.
8. Semantic UI.
9. Contrast.
10. Text scaling.
11. Localization.
12. Translation files.
13. Plural forms.
14. Unicode.
15. Right-to-left layouts.
16. International date and number formatting.

Referensi:

- [Qt Accessibility](https://doc.qt.io/qt-6/accessible.html?utm_source=chatgpt.com)
- [Qt Linguist](https://doc.qt.io/qt-6/qtlinguist-index.html?utm_source=chatgpt.com)
- [Internationalization](https://doc.qt.io/qt-6/internationalization.html?utm_source=chatgpt.com)

## FASE 10 — C++ / QML Interoperability



Expert

&#x20;Estimasi: 3–4 minggu



Ini merupakan salah satu fase terpenting untuk mencapai penguasaan Qt secara mendalam.

QML dapat membangun UI tanpa C++, tetapi kemampuan integrasinya dengan C++ membuka akses terhadap sistem native Qt dan berbagai library eksternal.

### Modul 10.1 — C++ Fundamentals for Qt

Deskripsi konkret

Mempelajari bagian C++ yang diperlukan untuk membangun komponen native yang dapat digunakan oleh QML.

Konsep dan filosofi

C++ menyediakan kontrol lebih besar terhadap tipe data, object lifetime, memory management, thread, performa, dan akses library native.

Materi yang perlu dikuasai:

Daftar isi:

1. C++ compilation model.
2. Header and source files.
3. Namespaces.
4. Classes and objects.
5. Constructors and destructors.
6. Access modifiers.
7. Inheritance.
8. Polymorphism.
9. Virtual functions.
10. Pointers.
11. References.
12. Smart pointers.
13. RAII.
14. Const correctness.
15. Templates.
16. STL.
17. Containers.
18. Lambda expressions.
19. Move semantics.
20. Memory management.
21. Exception handling.
22. C++17/C++20 fundamentals.

Terminologi:

- RAII: teknik pengelolaan resource berdasarkan lifetime objek.
- Pointer: variabel yang menyimpan alamat memori.
- Reference: alias untuk objek yang sudah ada.
- Template: mekanisme membuat kode generik berdasarkan tipe.
- STL: Standard Template Library.
- Smart pointer: objek yang mengelola kepemilikan pointer.

Referensi:

- [C++ Documentation](https://en.cppreference.com/w/?utm_source=chatgpt.com)
- [Learn C++](https://www.learncpp.com/?utm_source=chatgpt.com)
- [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines?utm_source=chatgpt.com)

### Modul 10.2 — Qt Object Model & Meta-Object System

Deskripsi konkret

Memahami sistem objek fundamental Qt yang memungkinkan komunikasi dinamis dan integrasi dengan QML.

Konsep dan filosofi

Qt menggunakan Meta-Object System untuk menyediakan informasi tentang kelas, properti, signal, slot, dan metadata objek ketika runtime.

Contoh:

```
#include <QObject>
#include <QString>

class Backend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(
        QString message
        READ message
        NOTIFY messageChanged
    )

public:
    explicit Backend(QObject *parent = nullptr)
        : QObject(parent)
    {
    }

    QString message() const
    {
        return m_message;
    }

signals:
    void messageChanged();

private:
    QString m_message = "Hello from C++";
};
```

Daftar isi:

1. QObject.
2. Q_OBJECT.
3. Meta-object.
4. QMetaObject.
5. QMetaProperty.
6. QMetaMethod.
7. Q_PROPERTY.
8. Q_ENUM.
9. Signals.
10. Slots.
11. Q_INVOKABLE.
12. Dynamic introspection.
13. Object ownership.
14. Parent-child ownership.
15. QObject destruction.
16. QPointer.
17. Property notifications.
18. Meta-type system.
19. MOC.
20. Runtime metadata.

Terminologi:

- QObject: kelas dasar penting dalam object model Qt.
- Meta-object: metadata tentang struktur sebuah kelas.
- MOC: Meta-Object Compiler.
- Introspection: kemampuan memeriksa struktur objek saat runtime.
- `Q_PROPERTY`: macro untuk mendefinisikan properti Qt.
- `Q_INVOKABLE`: macro yang menandai metode agar dapat dipanggil melalui mekanisme meta-object.

Referensi:

- [Qt Object Model](https://doc.qt.io/qt-6/object.html?utm_source=chatgpt.com)
- [Meta-Object System](https://doc.qt.io/qt-6/metaobjects.html?utm_source=chatgpt.com)
- [QObject](https://doc.qt.io/qt-6/qobject.html?utm_source=chatgpt.com)

### Modul 10.3 — Exposing C++ to QML

Deskripsi konkret

Mengekspos objek, fungsi, properti, signal, enum, dan data dari C++ agar dapat digunakan oleh QML.

Konsep dan filosofi

Integrasi harus memiliki batas yang jelas.

QML sebaiknya mengelola presentasi, sedangkan C++ menangani pekerjaan yang membutuhkan kemampuan native, sistem objek Qt, dan integrasi eksternal.

Contoh registrasi modern:

```
#include <QObject>
#include <QtQml/qqmlregistration.h>

class Backend : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(
        int value
        READ value
        NOTIFY valueChanged
    )

public:
    int value() const
    {
        return m_value;
    }

signals:
    void valueChanged();

private:
    int m_value = 42;
};
```

CMake:

```
qt_add_qml_module(myapp
    URI MyApp

    QML_FILES
        Main.qml

    SOURCES
        backend.h
)
```

QML:

```
import QtQuick
import MyApp

Window {
    visible: true

    Backend {
        id: backend
    }

    Text {
        text: backend.value
    }
}
```

Daftar isi:

1. QML type registration.
2. `QML_ELEMENT`.
3. `QML_NAMED_ELEMENT`.
4. `QML_UNCREATABLE`.
5. `QML_ANONYMOUS`.
6. `QML_SINGLETON`.
7. `QML_VALUE_TYPE`.
8. QObject exposure.
9. Properties.
10. Signals.
11. Slots.
12. Q_INVOKABLE.
13. Enumerations.
14. Singleton registration.
15. Value types.
16. Type revisions.
17. QML module registration.
18. C++ ownership.
19. Error handling.
20. C++ API design.

Referensi:

- [C++ and QML Integration](https://doc.qt.io/qt-6/qtqml-cppintegration-overview.html?utm_source=chatgpt.com)
- [Defining QML Types from C++](https://doc.qt.io/qt-6/qtqml-cppintegration-definetypes.html?utm_source=chatgpt.com)
- [Exposing Attributes of C++ Types](https://doc.qt.io/qt-6/qtqml-cppintegration-exposecppattributes.html?utm_source=chatgpt.com)

### Modul 10.4 — QML-to-C++ and C++-to-QML Communication

Deskripsi konkret

Menguasai komunikasi dua arah antara kedua lingkungan.

Konsep dan filosofi

Ada beberapa mekanisme integrasi. Setiap mekanisme mempunyai karakteristik dan tujuan berbeda.

| Mekanisme           | Penggunaan                               |
| ------------------- | ---------------------------------------- |
| Registered QML type | Objek C++ yang diinstansiasi melalui QML |
| Singleton           | Akses terhadap layanan bersama           |
| Context property    | Mengekspos objek melalui context         |
| Q_PROPERTY          | Properti C++ yang dapat diakses QML      |
| Q_INVOKABLE         | Metode yang dapat dipanggil QML          |
| Signals             | Notifikasi perubahan atau kejadian       |
| QAbstractItemModel  | Penyedia data terstruktur                |
| QJSValue            | Pertukaran nilai JavaScript              |

Contoh komunikasi QML ke C++:

```
Backend {
    id: backend
}

Button {
    text: "Execute"

    onClicked: {
        backend.execute()
    }
}
```

Contoh komunikasi C++ ke QML dilakukan melalui signal:

```
signals:
    void statusChanged(QString status);
```

```
Connections {
    target: backend

    function onStatusChanged(status) {
        console.log(status)
    }
}
```

Daftar isi:

1. Registered types.
2. Singleton objects.
3. Context properties.
4. Context objects.
5. Properties.
6. Methods.
7. Signals.
8. Slots.
9. Q_INVOKABLE.
10. QJSValue.
11. QJSManagedValue.
12. QVariant conversion.
13. QMetaType.
14. Object ownership.
15. API boundaries.
16. Thread affinity.
17. Async communication.
18. Error propagation.

Catatan arsitektur: untuk pengembangan modern, prioritaskan registered types dan API yang eksplisit. Context properties mempunyai keterbatasan terkait discoverability dan analisis statis sehingga dokumentasi Qt menyarankan menghindarinya jika terdapat pendekatan yang lebih baik.

Referensi:

- [C++ and QML Integration](https://doc.qt.io/qt-6/qtqml-cppintegration-overview.html?utm_source=chatgpt.com)
- [Context Properties](https://doc.qt.io/qt-6/qtqml-cppintegration-contextproperties.html?utm_source=chatgpt.com)
- [QML Singleton](https://doc.qt.io/qt-6/qml-singleton.html?utm_source=chatgpt.com)

### Modul 10.5 — Advanced Models & Native Data Providers

Deskripsi konkret

Membuat model native yang dapat memberikan data dinamis ke QML.

Konsep dan filosofi

Untuk dataset yang lebih kompleks, C++ dapat menjadi penyedia data dengan implementasi model yang sesuai dengan kebutuhan.

Contoh kerangka:

```
class DeviceModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        NameRole = Qt::UserRole + 1,
        StatusRole
    };

    int rowCount(
        const QModelIndex &parent = {}
    ) const override;

    QVariant data(
        const QModelIndex &index,
        int role
    ) const override;

    QHash<int, QByteArray> roleNames()
        const override;
};
```

Daftar isi:

1. QAbstractItemModel.
2. QAbstractListModel.
3. QAbstractTableModel.
4. QModelIndex.
5. Model roles.
6. Role names.
7. `data()`.
8. `rowCount()`.
9. `columnCount()`.
10. `setData()`.
11. `flags()`.
12. `beginInsertRows()`.
13. `endInsertRows()`.
14. `beginRemoveRows()`.
15. `dataChanged()`.
16. Model notifications.
17. Sorting.
18. Filtering.
19. Proxy models.
20. Thread-safe data updates.

Referensi:

- [Model/View Programming](https://doc.qt.io/qt-6/model-view-programming.html?utm_source=chatgpt.com)
- [QAbstractItemModel](https://doc.qt.io/qt-6/qabstractitemmodel.html?utm_source=chatgpt.com)
- [QAbstractListModel](https://doc.qt.io/qt-6/qabstractlistmodel.html?utm_source=chatgpt.com)

### Modul 10.6 — Native APIs & External Libraries

Deskripsi konkret

Menghubungkan antarmuka QML dengan kemampuan sistem operasi dan library eksternal.

Konsep dan filosofi

QML bukan tempat untuk mengimplementasikan seluruh fungsi sistem. Ia dapat menjadi lapisan antarmuka yang mengakses layanan native melalui API yang dirancang secara eksplisit.

Daftar isi:

1. Qt Core.
2. Qt Network.
3. Qt DBus.
4. Qt Concurrent.
5. Qt Multimedia.
6. Qt SQL.
7. Qt Serial Port.
8. Qt Bluetooth.
9. Qt System APIs.
10. POSIX interoperability.
11. External C++ libraries.
12. C ABI interoperability.
13. Dynamic libraries.
14. Native process execution.
15. Filesystem APIs.
16. IPC fundamentals.
17. Data serialization.
18. API abstraction.
19. Error handling.
20. Resource lifecycle.

Referensi:

- [Qt Core](https://doc.qt.io/qt-6/qtcore-index.html?utm_source=chatgpt.com)
- [Qt Network](https://doc.qt.io/qt-6/qtnetwork-index.html?utm_source=chatgpt.com)
- [Qt D-Bus](https://doc.qt.io/qt-6/qtdbus-index.html?utm_source=chatgpt.com)
- [Qt Concurrent](https://doc.qt.io/qt-6/qtconcurrent-index.html?utm_source=chatgpt.com)
- [Qt SQL](https://doc.qt.io/qt-6/qtsql-index.html?utm_source=chatgpt.com)
- [Qt Multimedia](https://doc.qt.io/qt-6/qtmultimedia-index.html?utm_source=chatgpt.com)

## FASE 11 — Rendering, Graphics & Performance Engineering



Expert

&#x20;Estimasi: 3–4 minggu



Fase ini membawa pembelajaran menuju tingkat internal framework dan rendering engine.

### Modul 11.1 — Qt Quick Scene Graph Architecture

Deskripsi konkret

Memahami bagaimana objek QML visual diterjemahkan menjadi representasi grafis yang akhirnya ditampilkan pada layar.

Konsep dan filosofi

Qt Quick menggunakan scene graph sebagai representasi grafis yang dapat dioptimalkan sebelum dirender.

Scene graph memisahkan struktur objek visual dari pekerjaan rendering grafis.

Alur konseptual:

QML Visual Items

Rectangle, Text, Image, custom items

Qt Quick Scene Graph

Node tree dan visual representation

Renderer

Batching, state changes, draw preparation

Graphics Backend

OpenGL, Vulkan, Metal atau Direct3D

GPU / Display

Daftar isi:

1. Scene graph fundamentals.
2. QSGNode.
3. QSGGeometryNode.
4. QSGTransformNode.
5. QSGOpacityNode.
6. QSGTexture.
7. QSGMaterial.
8. QSGMaterialShader.
9. QQuickItem.
10. `updatePaintNode()`.
11. Scene graph lifecycle.
12. Rendering pipeline.
13. Batching.
14. Draw calls.
15. Graphics state changes.
16. Texture management.
17. Render loop.
18. Basic render loop.
19. Threaded render loop.
20. GUI/render synchronization.

Terminologi:

- Scene graph: struktur data yang merepresentasikan objek grafis.
- GPU: prosesor khusus untuk pemrosesan grafis.
- Draw call: instruksi untuk menggambar objek atau kelompok objek.
- Batching: pengelompokan pekerjaan rendering untuk mengurangi overhead.
- Render loop: siklus yang mengatur proses persiapan dan penggambaran frame.
- Node: unit dalam struktur scene graph.

Referensi:

- [Qt Quick Scene Graph](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph.html?utm_source=chatgpt.com)
- [Scene Graph Default Renderer](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph-renderer.html?utm_source=chatgpt.com)
- [QSGNode](https://doc.qt.io/qt-6/qsgnode.html?utm_source=chatgpt.com)

### Modul 11.2 — Graphics API & Rendering Backend

Deskripsi konkret

Memahami hubungan Qt Quick dengan API grafis yang digunakan untuk menggambar antarmuka.

Konsep dan filosofi

Qt Quick tidak mengharuskan aplikasi menulis kode OpenGL atau Vulkan untuk seluruh elemen UI.

Qt menyediakan abstraction layer sehingga renderer dapat menggunakan backend grafis yang tersedia.

Daftar isi:

1. Graphics API fundamentals.
2. OpenGL.
3. Vulkan.
4. Direct3D.
5. Metal.
6. QRhi.
7. QSGRendererInterface.
8. Graphics contexts.
9. GPU resources.
10. Textures.
11. Buffers.
12. Framebuffers.
13. Synchronization.
14. Graphics memory.
15. Backend selection.
16. Graphics debugging.
17. GPU compatibility.

Terminologi:

- Graphics API: antarmuka untuk mengendalikan perangkat grafis.
- Backend: implementasi di belakang sebuah abstraction.
- Shader: program kecil yang berjalan pada GPU.
- Texture: data gambar yang digunakan dalam rendering.
- Framebuffer: target tempat hasil rendering ditulis.

Referensi:

- [Qt Rendering Hardware Interface](https://doc.qt.io/qt-6/qrhi.html?utm_source=chatgpt.com)
- [Qt Quick Graphics](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph.html?utm_source=chatgpt.com)
- [Vulkan Documentation](https://docs.vulkan.org/?utm_source=chatgpt.com)

### Modul 11.3 — Shader Programming & Visual Effects

Deskripsi konkret

Membuat efek grafis yang tidak cukup direpresentasikan oleh properti visual standar.

Konsep dan filosofi

Shader merupakan program yang dijalankan pada GPU. Shader memungkinkan pengolahan warna, tekstur, pencahayaan, distorsi, dan efek visual lainnya.

Contoh penggunaan QML:

```
ShaderEffect {
    width: 200
    height: 200

    property color tint: "red"

    fragmentShader: "qrc:/shaders/tint.frag.qsb"
}
```

Daftar isi:

1. Shader fundamentals.
2. Vertex shaders.
3. Fragment shaders.
4. GLSL.
5. Shader inputs.
6. Shader uniforms.
7. Textures.
8. UV coordinates.
9. Color manipulation.
10. Blur.
11. Distortion.
12. Masking.
13. Noise.
14. Gradient effects.
15. Multi-pass effects.
16. Shader compilation.
17. QShader.
18. `qsb`.
19. Shader portability.
20. GPU profiling.

Terminologi:

- GLSL: bahasa pemrograman shader yang digunakan dalam ekosistem OpenGL dan berbagai workflow terkait.
- Vertex shader: program untuk memproses vertex.
- Fragment shader: program untuk menghitung warna fragment.
- Uniform: nilai input yang dikirimkan ke shader.
- UV: koordinat tekstur.
- QSB: format shader terkompilasi Qt.

Referensi:

- [ShaderEffect](https://doc.qt.io/qt-6/qml-qtquick-shadereffect.html?utm_source=chatgpt.com)
- [Qt Shader Tools](https://doc.qt.io/qt-6/qtshadertools-index.html?utm_source=chatgpt.com)
- [Qt Shader Baking](https://doc.qt.io/qt-6/qtshadertools-qsb.html?utm_source=chatgpt.com)
- [GLSL Reference](https://registry.khronos.org/OpenGL-Refpages/gl4/?utm_source=chatgpt.com)

### Modul 11.4 — Performance Engineering

Deskripsi konkret

Mendiagnosis dan memperbaiki masalah performa yang berkaitan dengan QML engine, JavaScript, scene graph, rendering, dan penggunaan resource.

Konsep dan filosofi

Performa tidak boleh dinilai hanya berdasarkan seberapa cepat aplikasi terbuka.

Pengukuran harus mencakup:

- Startup time.
- Memory usage.
- CPU usage.
- GPU usage.
- Frame time.
- Frame drops.
- Input latency.
- Resource loading.

Daftar isi:

1. Performance fundamentals.
2. QML binding overhead.
3. Binding loops.
4. JavaScript execution cost.
5. Object creation cost.
6. Object destruction cost.
7. Component loading.
8. Lazy initialization.
9. List virtualization.
10. Delegate recycling.
11. Image caching.
12. Texture memory.
13. Render batching.
14. Shader performance.
15. Thread synchronization.
16. Memory profiling.
17. CPU profiling.
18. GPU profiling.
19. Startup optimization.
20. Performance regression testing.

Referensi:

- [Qt Quick Performance](https://doc.qt.io/qt-6/qtquick-performance.html?utm_source=chatgpt.com)
- [Qt Quick Tools and Utilities](https://doc.qt.io/qt-6/qtquick-tools-and-utilities.html?utm_source=chatgpt.com)
- [QML Profiling](https://doc.qt.io/qt-6/qtquick-profiling.html?utm_source=chatgpt.com)

## FASE 12 — Testing, Debugging & Quality Engineering



Expert

&#x20;Estimasi: 2–3 minggu



### Modul 12.1 — QML Debugging

Deskripsi konkret

Mempelajari cara menemukan kesalahan pada struktur objek, properti, JavaScript, signal, dan komponen visual.

Konsep dan filosofi

Debugging bukan sekadar membaca error. Tujuannya menemukan penyebab utama sebuah masalah.

Daftar isi:

1. Syntax errors.
2. Runtime errors.
3. Import errors.
4. Binding errors.
5. Binding loops.
6. Signal errors.
7. Component loading errors.
8. Object lifecycle errors.
9. JavaScript exceptions.
10. QML logging.
11. `console.log`.
12. `console.warn`.
13. `console.error`.
14. Qt logging categories.
15. QML debugging protocol.
16. Debugger integration.
17. Runtime inspection.

Referensi:

- [QML Debugging](https://doc.qt.io/qt-6/qtqml-debugging.html?utm_source=chatgpt.com)
- [Qt Logging](https://doc.qt.io/qt-6/qloggingcategory.html?utm_source=chatgpt.com)

### Modul 12.2 — Static Analysis & Code Quality

Deskripsi konkret

Membuat workflow pemeriksaan otomatis agar kesalahan ditemukan sebelum aplikasi dijalankan.

Konsep dan filosofi

Semakin besar aplikasi, semakin tidak efisien jika semua masalah harus ditemukan melalui pengujian manual.

Daftar isi:

1. qmllint.
2. QML Language Server.
3. qmlformat.
4. QML type annotations.
5. Type checking.
6. Unqualified access.
7. Deprecated API.
8. Unused imports.
9. Naming conventions.
10. Formatting conventions.
11. Static analysis.
12. C++ static analysis.
13. Build warnings.
14. Compiler diagnostics.
15. Continuous integration.

Contoh:

```
qmllint Main.qml
```

```
qmlformat -i Main.qml
```

Referensi:

- [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html?utm_source=chatgpt.com)
- [QML Tooling](https://doc.qt.io/qt-6/qtquick-tools-and-utilities.html?utm_source=chatgpt.com)
- [QML Language Server](https://doc.qt.io/qt-6/qtqml-tooling-qmlls.html?utm_source=chatgpt.com)

### Modul 12.3 — Unit Testing & Integration Testing

Deskripsi konkret

Menguji perilaku komponen dan interaksi antarbagiannya secara otomatis.

Konsep dan filosofi

Pengujian harus membuktikan bahwa komponen berperilaku sesuai kontraknya, bukan sekadar memastikan aplikasi dapat dibuka.

Contoh:

```
import QtQuick
import QtTest

TestCase {
    name: "MathTests"

    function test_addition() {
        compare(2 + 2, 4)
    }
}
```

Daftar isi:

1. Testing fundamentals.
2. Unit tests.
3. Component tests.
4. Integration tests.
5. Qt Quick Test.
6. TestCase.
7. SignalSpy.
8. Test data.
9. Test setup.
10. Test cleanup.
11. Asynchronous tests.
12. Mouse simulation.
13. Keyboard simulation.
14. Touch simulation.
15. Visual regression.
16. Test isolation.
17. Mock objects.
18. Test coverage.
19. CI testing.
20. Failure analysis.

Referensi:

- [Qt Quick Test](https://doc.qt.io/qt-6/qtquicktest-index.html?utm_source=chatgpt.com)
- [TestCase](https://doc.qt.io/qt-6/qml-qttest-testcase.html?utm_source=chatgpt.com)
- [SignalSpy](https://doc.qt.io/qt-6/qml-qttest-signalspy.html?utm_source=chatgpt.com)

### Modul 12.4 — Profiling & Runtime Diagnostics

Deskripsi konkret

Mengukur aktivitas aplikasi ketika berjalan untuk menemukan bottleneck.

Daftar isi:

1. QML Profiler.
2. CPU profiling.
3. Memory profiling.
4. Binding profiling.
5. JavaScript profiling.
6. Frame rendering.
7. Scene graph diagnostics.
8. Qt logging categories.
9. GammaRay.
10. GDB.
11. Valgrind.
12. AddressSanitizer.
13. UndefinedBehaviorSanitizer.
14. ThreadSanitizer.
15. Performance benchmarks.
16. Regression monitoring.

Referensi:

- [QML Profiling](https://doc.qt.io/qt-6/qtquick-profiling.html?utm_source=chatgpt.com)
- [Qt Quick Tools](https://doc.qt.io/qt-6/qtquick-tools-and-utilities.html?utm_source=chatgpt.com)
- [GDB Documentation](https://sourceware.org/gdb/documentation/?utm_source=chatgpt.com)
- [Valgrind Documentation](https://valgrind.org/docs/manual/?utm_source=chatgpt.com)

## FASE 13 — Security, Deployment & Enterprise Engineering



Expert / Enterprise

&#x20;Estimasi: 3–4 minggu



Fase ini menggabungkan keamanan, isolasi, keandalan dan proses distribusi.

### Modul 13.1 — QML Security Architecture

Deskripsi konkret

Memahami risiko keamanan pada QML engine, JavaScript execution, resource loading, C++ integration, dan komunikasi eksternal.

Konsep dan filosofi

Antarmuka bukan security boundary.

Jika QML dapat memanggil fungsi native yang memiliki hak istimewa, maka kemampuan tersebut harus dibatasi melalui desain API.

Prinsip utamanya adalah least privilege: setiap komponen hanya mendapatkan kemampuan yang memang diperlukan.

Daftar isi:

1. Threat modeling.
2. Attack surface.
3. Trust boundaries.
4. Least privilege.
5. QML engine isolation.
6. JavaScript execution boundaries.
7. Untrusted QML sources.
8. Dynamic component loading.
9. Import path security.
10. Resource URL validation.
11. File access control.
12. Network security.
13. TLS.
14. Certificate validation.
15. IPC security.
16. Native API exposure.
17. Input validation.
18. Path traversal.
19. Dependency security.
20. Supply-chain security.
21. Secrets management.
22. Logging sensitive data.
23. Sandboxing limitations.
24. Secure update strategy.

Contoh prinsip pembatasan API:

Jangan mengekspos API sistem dengan kemampuan tanpa batas:

```
Q_INVOKABLE
void executeArbitraryCommand(QString command);
```

Lebih baik menyediakan API dengan fungsi terbatas dan tervalidasi:

```
Q_INVOKABLE
bool setDisplayBrightness(int value);
```

Contoh tersebut tetap membutuhkan validasi rentang, pemeriksaan otorisasi dan penanganan error pada implementasi C++.

Terminologi:

- Threat model: analisis ancaman terhadap sistem.
- Attack surface: seluruh titik yang dapat menjadi jalur serangan.
- Trust boundary: batas antara komponen dengan tingkat kepercayaan berbeda.
- Least privilege: pemberian hak akses minimum.
- Sandboxing: pembatasan lingkungan eksekusi.
- Supply chain: rantai komponen, library, dan alat yang digunakan untuk menghasilkan aplikasi.

Referensi:

- [Qt Security](https://doc.qt.io/qt-6/security.html?utm_source=chatgpt.com)
- [Qt Network Security](https://doc.qt.io/qt-6/qtnetwork-security.html?utm_source=chatgpt.com)
- [OWASP Secure Coding Practices](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/?utm_source=chatgpt.com)
- [OWASP Threat Modeling](https://owasp.org/www-community/Threat_Modeling?utm_source=chatgpt.com)

### Modul 13.2 — Operating System Integration

Deskripsi konkret

Menghubungkan aplikasi Qt dengan layanan sistem operasi dan memahami konsekuensi keamanan integrasi tersebut.

Konsep dan filosofi

Aplikasi desktop modern sering kali perlu berkomunikasi dengan sistem operasi. Namun, akses sistem harus memiliki pembatasan yang jelas.

Daftar isi:

1. Process management.
2. QProcess.
3. Environment variables.
4. Filesystem permissions.
5. QFile.
6. QDir.
7. QStandardPaths.
8. QSettings.
9. QLockFile.
10. QTemporaryFile.
11. QSaveFile.
12. IPC fundamentals.
13. D-Bus.
14. Unix domain sockets.
15. Local sockets.
16. Named pipes.
17. Shared memory.
18. System services.
19. Permission boundaries.
20. Sandboxing and confinement.

Alternatif API berdasarkan kebutuhan:

| Kebutuhan   | Pilihan Qt            | Alternatif                       |
| ----------- | --------------------- | -------------------------------- |
| File access | QFile                 | POSIX `open/read/write`          |
| Direktori   | QDir                  | POSIX `opendir/readdir`          |
| Process     | QProcess              | POSIX `fork/exec`, `posix_spawn` |
| IPC message | QLocalSocket          | Unix domain sockets              |
| IPC service | Qt D-Bus              | D-Bus C API                      |
| Settings    | QSettings             | TOML, JSON, SQLite               |
| Async tasks | Qt Concurrent         | C++ threads, `std::async`        |
| Networking  | QNetworkAccessManager | POSIX sockets, standalone Asio   |

Alternatif tersebut tidak selalu setara. Pilih berdasarkan kebutuhan portability, event loop, ownership, dan batas keamanan.

Referensi:

- [Qt Core](https://doc.qt.io/qt-6/qtcore-index.html?utm_source=chatgpt.com)
- [QProcess](https://doc.qt.io/qt-6/qprocess.html?utm_source=chatgpt.com)
- [QFile](https://doc.qt.io/qt-6/qfile.html?utm_source=chatgpt.com)
- [Qt D-Bus](https://doc.qt.io/qt-6/qtdbus-index.html?utm_source=chatgpt.com)
- [Qt Local Sockets](https://doc.qt.io/qt-6/qlocalsocket.html?utm_source=chatgpt.com)

### Modul 13.3 — Application Deployment & Packaging

Deskripsi konkret

Mempersiapkan aplikasi agar dapat dipasang, dijalankan, diperbarui, dan didistribusikan.

Konsep dan filosofi

Aplikasi yang berjalan pada mesin pengembang belum tentu dapat dijalankan pada mesin lain.

Deployment harus mempertimbangkan library, QML modules, plugins, resource, graphics backend, dan dependency runtime.

Daftar isi:

1. Application packaging.
2. Qt runtime dependencies.
3. Shared libraries.
4. QML import deployment.
5. Plugin deployment.
6. Resource embedding.
7. Static deployment.
8. Dynamic deployment.
9. CMake install.
10. `qt_generate_deploy_qml_app_script`.
11. Linux deployment.
12. AppImage.
13. Flatpak.
14. Distribution packages.
15. Runtime dependency analysis.
16. Versioning.
17. Release builds.
18. Signing.
19. Update mechanisms.
20. Reproducible builds.

Contoh pemeriksaan dependency:

```
ldd ./build/myapp
```

Referensi:

- [Deploying QML Applications](https://doc.qt.io/qt-6/qtquick-deployment.html?utm_source=chatgpt.com)
- [Qt CMake Deployment](https://doc.qt.io/qt-6/cmake-deployment.html?utm_source=chatgpt.com)
- [Flatpak Documentation](https://docs.flatpak.org/?utm_source=chatgpt.com)
- [AppImage Documentation](https://docs.appimage.org/?utm_source=chatgpt.com)

### Modul 13.4 — Enterprise Software Engineering

Deskripsi konkret

Membangun proses pengembangan yang mampu mempertahankan kualitas proyek ketika jumlah modul, kontributor dan kompleksitas meningkat.

Konsep dan filosofi

Enterprise engineering tidak sekadar berarti aplikasi besar. Fokusnya adalah konsistensi, pemeliharaan, kemampuan pengujian, kontrol perubahan dan keberlanjutan pengembangan.

Daftar isi:

1. Software architecture.
2. Architectural decision records.
3. API versioning.
4. Semantic versioning.
5. Backward compatibility.
6. Module ownership.
7. Dependency governance.
8. Code review.
9. Git workflows.
10. Branch protection.
11. Continuous integration.
12. Continuous delivery.
13. Build reproducibility.
14. Release management.
15. Automated testing.
16. Security scanning.
17. Dependency auditing.
18. Documentation generation.
19. Issue tracking.
20. Technical debt management.
21. Observability.
22. Long-term maintenance.

Referensi:

- [Qt Quality Assurance](https://wiki.qt.io/Quality_Assurance?utm_source=chatgpt.com)
- [Git Documentation](https://git-scm.com/doc?utm_source=chatgpt.com)
- [CMake Documentation](https://cmake.org/documentation/?utm_source=chatgpt.com)
- [Semantic Versioning](https://semver.org/?utm_source=chatgpt.com)

## FASE 14 — Mastery & Independent Framework Engineering



Mastery

&#x20;Estimasi: 3–6 minggu atau lebih



Fase terakhir bukan hanya mempelajari API yang tersedia. Tujuannya adalah mengembangkan kemampuan merancang sistem yang memanfaatkan seluruh pengetahuan sebelumnya.

### Modul 14.1 — Advanced QML Type System Engineering

Deskripsi konkret

Memahami bagaimana mendefinisikan tipe baru yang mempunyai API konsisten, metadata, properti, signal, dan aturan instansiasi.

Konsep dan filosofi

Ketika membuat framework atau library, kita tidak hanya membuat objek. Kita sedang merancang kontrak penggunaan bagi developer lain.

Daftar isi:

1. QML type registration.
2. Object types.
3. Value types.
4. Singleton types.
5. Uncreatable types.
6. Anonymous types.
7. Default properties.
8. Attached properties.
9. Attached signals.
10. Type revisions.
11. Property revisions.
12. Enum exposure.
13. API compatibility.
14. Type metadata.
15. Generated qmltypes.
16. QML type compiler.
17. Module API design.
18. Public and private types.
19. API documentation.
20. Framework extensibility.

Referensi:

- [QML Type System](https://doc.qt.io/qt-6/qtqml-typesystem-topic.html?utm_source=chatgpt.com)
- [Defining QML Types from C++](https://doc.qt.io/qt-6/qtqml-cppintegration-definetypes.html?utm_source=chatgpt.com)
- [QML Type Compiler](https://doc.qt.io/qt-6/qtqml-type-compiler.html?utm_source=chatgpt.com)

### Modul 14.2 — Custom QQuickItem Development

Deskripsi konkret

Membangun objek visual native yang dapat digunakan sebagai tipe QML.

Konsep dan filosofi

Tidak semua kebutuhan visual dapat diselesaikan secara efisien dengan menyusun primitive QML.

Untuk kasus tertentu, membuat custom `QQuickItem` memungkinkan pengendalian perilaku visual dan integrasi rendering yang lebih spesifik.

Contoh kerangka:

```
#include <QQuickItem>
#include <QtQml/qqmlregistration.h>

class CustomItem : public QQuickItem
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit CustomItem(
        QQuickItem *parent = nullptr
    ) : QQuickItem(parent)
    {
        setFlag(ItemHasContents, true);
    }
};
```

Daftar isi:

1. QQuickItem.
2. Custom visual items.
3. Geometry updates.
4. `update()`.
5. `updatePaintNode()`.
6. Scene graph nodes.
7. Node ownership.
8. Texture nodes.
9. Geometry nodes.
10. Material systems.
11. Rendering lifecycle.
12. Thread restrictions.
13. Resource synchronization.
14. Custom rendering.
15. Custom item testing.
16. Performance considerations.

Referensi:

- [QQuickItem](https://doc.qt.io/qt-6/qquickitem.html?utm_source=chatgpt.com)
- [Qt Quick Scene Graph](https://doc.qt.io/qt-6/qtquick-visualcanvas-scenegraph.html?utm_source=chatgpt.com)
- [Scene Graph Custom Rendering](https://doc.qt.io/qt-6/qtquick-scenegraph-customrendernode-example.html?utm_source=chatgpt.com)

### Modul 14.3 — Plugin & Extension Architecture

Deskripsi konkret

Membangun library dan plugin yang dapat menyediakan kemampuan baru kepada aplikasi atau modul lain.

Konsep dan filosofi

Plugin architecture memungkinkan aplikasi diperluas tanpa harus menggabungkan seluruh implementasi ke dalam satu komponen monolitik.

Ada beberapa model ekstensi yang perlu dibedakan:

| Model                     | Tujuan                                  |
| ------------------------- | --------------------------------------- |
| QML module                | Berbagi tipe dan resource QML           |
| QML plugin                | Memuat tipe dan implementasi native     |
| Qt plugin                 | Menyediakan implementasi interface Qt   |
| Dynamic library           | Berbagi implementasi native             |
| Static library            | Menggabungkan implementasi saat linking |
| Application extension API | Kontrak khusus yang dirancang aplikasi  |

Daftar isi:

1. Plugin fundamentals.
2. QML plugins.
3. Qt plugins.
4. QPluginLoader.
5. Q_DECLARE_INTERFACE.
6. Q_INTERFACES.
7. Q_PLUGIN_METADATA.
8. Dynamic loading.
9. Static plugins.
10. Plugin discovery.
11. Plugin metadata.
12. Dependency resolution.
13. Version compatibility.
14. Plugin lifecycle.
15. Failure isolation.
16. Security boundaries.
17. Extension API.
18. Plugin testing.
19. Plugin distribution.
20. Plugin documentation.

Contoh konseptual:

```
class ExtensionInterface
{
public:
    virtual ~ExtensionInterface() = default;

    virtual QString name() const = 0;
};
```

Referensi:

- [Qt Plugins](https://doc.qt.io/qt-6/plugins-howto.html?utm_source=chatgpt.com)
- [QPluginLoader](https://doc.qt.io/qt-6/qpluginloader.html?utm_source=chatgpt.com)
- [QML Modules](https://doc.qt.io/qt-6/qtqml-modules-topic.html?utm_source=chatgpt.com)

### Modul 14.4 — Framework Design & API Engineering

Deskripsi konkret

Membangun framework internal yang dapat dipakai berulang kali untuk menghasilkan aplikasi dengan kemampuan yang konsisten.

Konsep dan filosofi

Framework berbeda dari aplikasi biasa.

Aplikasi menggunakan framework. Framework menyediakan struktur, abstraksi, dan aturan yang digunakan untuk membangun banyak aplikasi.

Prinsip utama:

- Modularity.
- Composition.
- Abstraction.
- Encapsulation.
- Extensibility.
- API stability.
- Dependency control.
- Explicit ownership.

Daftar isi:

1. Framework architecture.
2. Core abstractions.
3. Public APIs.
4. Internal APIs.
5. Extension points.
6. Component registries.
7. Dependency injection.
8. Service abstraction.
9. Plugin contracts.
10. Module boundaries.
11. Configuration architecture.
12. State management.
13. Event architecture.
14. Error handling strategy.
15. Resource management.
16. API stability.
17. Compatibility guarantees.
18. Documentation.
19. Versioning.
20. Framework testing.

Referensi:

- [Qt QML Best Practices](https://doc.qt.io/qt-6/qtqml-best-practices.html?utm_source=chatgpt.com)
- [Qt Object Model](https://doc.qt.io/qt-6/object.html?utm_source=chatgpt.com)
- [QML Modules](https://doc.qt.io/qt-6/qtqml-modules-topic.html?utm_source=chatgpt.com)

### Modul 14.5 — Independent Engineering & Research

Deskripsi konkret

Mengembangkan kemampuan membaca source code, memahami implementasi internal, menganalisis perubahan API, dan membuat keputusan teknologi secara mandiri.

Konsep dan filosofi

Penguasaan tingkat tinggi tidak cukup hanya dengan mengetahui cara memakai API. Developer harus mampu memahami alasan sebuah API dirancang demikian, keterbatasannya, dan alternatif implementasinya.

Daftar isi:

1. Qt source code exploration.
2. Qt Git repository.
3. Reading C++ headers.
4. Reading implementation files.
5. API evolution.
6. Release notes.
7. Deprecation tracking.
8. Internal architecture.
9. Debugging framework behavior.
10. Benchmark design.
11. Experimental development.
12. API prototyping.
13. Performance experiments.
14. Security research.
15. Technical documentation.
16. Upstream contribution.
17. Bug reporting.
18. Patch development.
19. Code review.
20. Independent framework development.

Referensi:

- [Qt Source Code](https://code.qt.io/?utm_source=chatgpt.com)
- [Qt GitHub](https://github.com/qt?utm_source=chatgpt.com)
- [Qt Development Mailing Lists](https://lists.qt-project.org/?utm_source=chatgpt.com)
- [Qt Bug Tracker](https://bugreports.qt.io/?utm_source=chatgpt.com)
- [Qt Contribution Guidelines](https://wiki.qt.io/Qt_Contribution_Guidelines?utm_source=chatgpt.com)

# 6. Interoperabilitas dan teknologi pendukung

Penguasaan QML akan jauh lebih luas jika memahami teknologi yang dapat berkomunikasi dengannya.

Berikut peta integrasi yang perlu dikuasai.

| Teknologi      | Peran                                | Prioritas                 |
| -------------- | ------------------------------------ | ------------------------- |
| C++            | Native backend dan custom types      | Wajib tingkat lanjut      |
| JavaScript     | Logic dan expression QML             | Wajib                     |
| CMake          | Build dan module engineering         | Wajib                     |
| Qt Core        | Sistem dasar Qt                      | Wajib tingkat lanjut      |
| Qt Network     | Komunikasi jaringan                  | Lanjutan                  |
| Qt D-Bus       | IPC pada sistem yang mendukung D-Bus | Lanjutan                  |
| Qt Concurrent  | Pekerjaan paralel                    | Lanjutan                  |
| Qt SQL         | Database                             | Opsional sesuai kebutuhan |
| Qt Multimedia  | Audio dan video                      | Opsional sesuai kebutuhan |
| Qt Serial Port | Komunikasi serial                    | Opsional sesuai kebutuhan |
| Qt Bluetooth   | Bluetooth                            | Opsional sesuai kebutuhan |
| GLSL           | Custom shader                        | Expert                    |
| Vulkan         | Low-level graphics API               | Expert                    |
| OpenGL         | Graphics API                         | Lanjutan                  |
| Python         | Tooling dan otomasi eksternal        | Opsional                  |
| Lua            | Otomasi dan integrasi eksternal      | Opsional                  |

## 6.1 Perbedaan API yang harus dipahami

Jangan menganggap satu API dapat menggantikan API lainnya hanya karena hasil akhirnya terlihat sama.

Contohnya, komunikasi antarkomponen dapat dilakukan dengan beberapa pendekatan:

- QML Signals and Handlers.
- Qt Signals and Slots.
- Q_PROPERTY notification.
- QAbstractItemModel notifications.
- QLocalSocket.
- D-Bus.
- Unix domain sockets.

Perbedaannya terletak pada batas komunikasi, kepemilikan objek, kebutuhan proses, dan mekanisme pertukaran data.

Contoh klasifikasi:

| Kebutuhan                              | API utama                | Alternatif                               |
| -------------------------------------- | ------------------------ | ---------------------------------------- |
| Komunikasi objek dalam satu QML engine | Signals                  | C++ signals/slots                        |
| Property notification                  | Q_PROPERTY + NOTIFY      | QML property binding                     |
| Data collection                        | QAbstractItemModel       | QML ListModel                            |
| Proses eksternal                       | QProcess                 | POSIX process APIs                       |
| IPC antaraplikasi                      | D-Bus                    | Unix sockets                             |
| Data persistent                        | QSettings                | SQLite, JSON                             |
| Network HTTP                           | QNetworkAccessManager    | Standalone Asio, libcurl                 |
| Background computation                 | Qt Concurrent            | std::thread, std::async                  |
| Rendering custom                       | QQuickItem + Scene Graph | ShaderEffect untuk kasus visual tertentu |

Hasil yang diharapkan: mampu menentukan kapan harus menggunakan API QML, kapan menggunakan API C++, dan kapan membutuhkan fasilitas sistem operasi.

# 7. Strategi proyek praktik bertahap

Kurikulum ini tidak cukup dipelajari hanya dengan membaca dokumentasi. Setiap fase harus menghasilkan proyek kecil yang membuktikan bahwa konsepnya sudah dipahami.

Proyek berikut disusun dari tingkat sederhana hingga kompleks.

[Building UI layouts with Qt Quick, QML, and C++ in Qt 6.x | Aksh Singh posted on the topic | LinkedIn](https://images.openai.com/static-rsc-4/ot-X0Tpay6iOZDoOVWOTsJ1XW-_6q9zAyv1vz1fsKQKhqF76MrAhJh8bcJPzxWsOFXf7noxnpsqkuPhwjXtT3O14DDPeWxi4s41VPxK1OpXAFR1KxddtBnKtETxxp0TwKQ2vTnmdlGHOCz1mH9E3Ikdeu3bCaSAhMBHOR30ut88?purpose=inline)

Project 01 — Basic QML Window

Foundation

- Membuat Window.
- Memahami Item dan Rectangle.
- Menggunakan Text, Image, dan properti.
- Mengatur geometri dan warna.

Kriteria: dapat membangun tampilan dasar tanpa menyalin tutorial.

[Preferences – Linear Docs](https://images.openai.com/static-rsc-4/Q6hz8xBs4VVdIPF2ULCG-9HN3lHm6-mFybfCIOvwN9IcoOf1HLV62t90xF9lg5dazXbRCddc0JXE22r8KHyTaAQkMOsonJGe5tkb71IhIFgSg8HorV2QC5mlUca-bnJQ3XIiq7MspMYKdKqZUH8Sxr6LxgwZ0aY6IyI0hIz_H-A?purpose=inline)

Project 02 — Interactive Settings Interface

Foundation

- Button, Slider, Switch.
- Property binding.
- Signal handlers.
- JavaScript functions.
- Component composition.

Kriteria: setiap kontrol mempunyai perilaku yang benar.

[Core Panel Dashboard (Light & Dark) by Iqbal Tahir for Portal Studios on Dribbble](https://images.openai.com/static-rsc-4/TysQmvhUnXJwEcJEVFuxLkGOTcNdr-YQYb3tD2xJkz6ximjZvrgR0LcFwYgeIKX8TVr4bQ9JBYNyWI5gzpiWVQe7zT6j9Xda3ps42FI2ykMRyq7PYdN8KvZFpNEir-5_OCmYoh3eZ_DzGtdWpZGN_hqFiit-SgkoLXEJyWT5TQ8?purpose=inline)

Project 03 — Modular Dashboard

Intermediate

- Reusable components.
- Layout management.
- Themes.
- State management.
- Navigation.

Kriteria: komponen dapat digunakan kembali tanpa duplikasi implementasi.

[Dashboard // Free Templates](https://images.openai.com/static-rsc-4/TLNIlsiCucMIE8y4_lG-vqzCFhVBrjOPQ74PEcsqrw9Jj1Fr5bkwJcdor1HLZ7lkIGh4pN7Ite69vliyQmnvOGFURyq03FmmeC4_Iow9PF1WySqmAKWHrnY_IK8jtawTFikXOS9AsW_1nT50POImSTKLMbLpkGeBqJ3_AhUwv2g?purpose=inline)

Project 04 — Dynamic Data Dashboard

Advanced

- Models and views.
- Dynamic delegates.
- Asynchronous data.
- C++ integration.
- Native data providers.

Kriteria: UI mampu menampilkan dan memperbarui data dinamis.

[AtomGit - 全球开发者的开源社区,开源代码托管平台](https://images.openai.com/static-rsc-4/jUawhtN9exETdAdkmSjk_UOE4fAIJJbFpWGEv25Yd_dw5sdy8fO6e26ERiqD3cm9bkUs_JvBwthbVQ1sbxmsh_qXqTWlHgXPnO62ktjkQsCIzdhJcAiTpNQOBTf5DEPy9kHd3124Kl5kEhX0a7dAWVHB96OTFEKkOkLsmM4EJgI?purpose=inline)

Project 05 — Custom Visual Component Library

Expert

- Custom QML types.
- Custom Controls.
- C++ integration.
- Shader effects.
- Module architecture.

Kriteria: library memiliki API yang terdokumentasi dan dapat digunakan proyek lain.

[Desarrollo de software a medida | Cero Ideas | Cero ideas](https://images.openai.com/static-rsc-4/MOJ3twaqgKkKS1j3OjZ6aW5zOYSUYeJX-SDvYMiJOtJMCVdUazZVvwkrB_xtQg0yf9p9GVk771XuZXuqn2JHvprpbWY8F7kUXOt6VAJU2LfM0-YU79Xaij3HbXAVAj3_dbMijCUCOcOcy0-MIRrDHEXptFNyUlZzKUao8tT60G0?purpose=inline)

Project 06 — Independent Qt UI Framework

Mastery

- Modular architecture.
- Component registry.
- Theme engine.
- Plugin system.
- Configuration API.
- Security boundaries.
- Automated testing.
- Deployment.

Kriteria: developer lain dapat menggunakan framework tanpa perlu memahami seluruh implementasi internalnya.

# 8. Sumber dokumentasi resmi dan komunitas

Dokumentasi resmi harus menjadi sumber utama. Tutorial komunitas berfungsi sebagai pendamping, bukan pengganti dokumentasi API.

## 8.1 Dokumentasi resmi Qt

| Sumber                                                                                              | Kegunaan                |
| --------------------------------------------------------------------------------------------------- | ----------------------- |
| [Qt 6 Documentation](https://doc.qt.io/qt-6/?utm_source=chatgpt.com)                                | Dokumentasi keseluruhan |
| [Qt QML](https://doc.qt.io/qt-6/qtqml-index.html?utm_source=chatgpt.com)                            | Bahasa dan engine QML   |
| [Qt Quick](https://doc.qt.io/qt-6/qtquick-index.html?utm_source=chatgpt.com)                        | Visual system           |
| [Qt Quick Controls](https://doc.qt.io/qt-6/qtquickcontrols-index.html?utm_source=chatgpt.com)       | Komponen UI             |
| [Qt Core](https://doc.qt.io/qt-6/qtcore-index.html?utm_source=chatgpt.com)                          | Fundamental Qt          |
| [C++ Integration](https://doc.qt.io/qt-6/qtqml-cppintegration-overview.html?utm_source=chatgpt.com) | Integrasi native        |
| [Performance](https://doc.qt.io/qt-6/qtquick-performance.html?utm_source=chatgpt.com)               | Optimasi                |
| [Qt Quick Test](https://doc.qt.io/qt-6/qtquicktest-index.html?utm_source=chatgpt.com)               | Pengujian               |

## 8.2 Tutorial dan contoh resmi

- [Qt Examples and Tutorials](https://doc.qt.io/qt-6/qtexamplesandtutorials.html?utm_source=chatgpt.com)
- [Qt QML Examples](https://doc.qt.io/qt-6/qtqml-examples.html?utm_source=chatgpt.com)
- [Qt Quick Examples](https://doc.qt.io/qt-6/qtquick-examples.html?utm_source=chatgpt.com)
- [Qt Quick Controls Examples](https://doc.qt.io/qt-6/qtquickcontrols-examples.html?utm_source=chatgpt.com)
- [Qt QML C++ Integration Examples](https://doc.qt.io/qt-6/qtqml-cppintegration-examples.html?utm_source=chatgpt.com)

## 8.3 Komunitas

[image](https://www.google.com/s2/favicons?domain=https://forum.qt.io\&sz=32)

[Qt Forum](https://forum.qt.io/?utm_source=chatgpt.com)

Forum diskusi resmi komunitas Qt.

[image](https://www.google.com/s2/favicons?domain=https://stackoverflow.com\&sz=32)

[Stack Overflow — Qt](https://stackoverflow.com/questions/tagged/qt?utm_source=chatgpt.com)

Diskusi teknis, debugging dan pemecahan masalah.

[image](https://www.google.com/s2/favicons?domain=https://github.com\&sz=32)

[Qt GitHub Organization](https://github.com/qt?utm_source=chatgpt.com)

Source code, repository dan kontribusi.

[image](https://www.google.com/s2/favicons?domain=https://wiki.qt.io\&sz=32)

[Qt Wiki](https://wiki.qt.io/?utm_source=chatgpt.com)

Artikel dan pengetahuan komunitas Qt.

[image](https://www.google.com/s2/favicons?domain=https://www.kdab.com\&sz=32)

[KDAB](https://www.kdab.com/?utm_source=chatgpt.com)

Artikel teknis tingkat lanjut mengenai C++, Qt, profiling dan arsitektur.

## 8.4 Repository untuk pembelajaran source code

| Repository                                                                        | Fokus                            |
| --------------------------------------------------------------------------------- | -------------------------------- |
| [qtdeclarative](https://github.com/qt/qtdeclarative?utm_source=chatgpt.com)       | QML engine dan Qt Quick          |
| [qtquickcontrols2](https://github.com/qt/qtquickcontrols2?utm_source=chatgpt.com) | Implementasi Qt Quick Controls 2 |
| [qtbase](https://github.com/qt/qtbase?utm_source=chatgpt.com)                     | Fondasi Qt                       |
| [qtshadertools](https://github.com/qt/qtshadertools?utm_source=chatgpt.com)       | Shader tools                     |
| [qttools](https://github.com/qt/qttools?utm_source=chatgpt.com)                   | Berbagai development tools       |

Catatan: beberapa repository merupakan bagian dari implementasi Qt yang lebih luas. Gunakan dokumentasi modul untuk mengetahui struktur source dan dependensinya.

# 9. Sertifikasi dan validasi kompetensi

Penguasaan Qt/QML lebih tepat divalidasi melalui kombinasi proyek, kemampuan membaca source code, pengujian, dan kontribusi.

Tidak perlu menganggap sertifikasi sebagai satu-satunya bukti kompetensi.

| Validasi                       | Target                |
| ------------------------------ | --------------------- |
| QML fundamentals project       | Foundation            |
| Reusable component library     | Intermediate          |
| Modular QML application        | Advanced              |
| Native C++ integration project | Expert                |
| Custom QQuickItem              | Expert                |
| Custom QML module              | Expert                |
| Automated test suite           | Expert                |
| Public framework repository    | Mastery               |
| Upstream Qt contribution       | Advanced professional |

Untuk jalur pelatihan formal, periksa:

- [Qt Training](https://www.qt.io/qt-training?utm_source=chatgpt.com)
- [Qt Professional Services](https://www.qt.io/services?utm_source=chatgpt.com)

Ketersediaan pelatihan, ujian, dan sertifikasi dapat berubah. Verifikasi program yang benar-benar ditawarkan sebelum menjadikannya target.

# 10. Hasil pembelajaran akhir (Learning Outcomes)

Setelah menyelesaikan seluruh fase, peserta seharusnya memiliki kompetensi berikut.

| Kompetensi            | Hasil yang diharapkan                                |
| --------------------- | ---------------------------------------------------- |
| QML Language          | Mampu memahami dan menulis QML secara mandiri        |
| JavaScript            | Mampu mengimplementasikan logika yang diperlukan QML |
| Object Model          | Memahami struktur, lifecycle, scope dan ownership    |
| Reactivity            | Memahami binding dan dependency graph                |
| Qt Quick              | Mampu membangun visual interface                     |
| Component Engineering | Mampu membuat komponen reusable                      |
| Layout Engineering    | Menguasai positioning dan layout system              |
| Animation             | Mampu membangun interaksi dan animasi                |
| Data Architecture     | Menguasai model, view dan delegate                   |
| Module Engineering    | Mampu membuat modul QML                              |
| Controls              | Mampu memodifikasi dan membangun kontrol             |
| C++ Integration       | Mampu mengekspos API native ke QML                   |
| Rendering             | Memahami scene graph dan render pipeline             |
| Shader                | Mampu membangun efek visual GPU                      |
| Performance           | Mampu melakukan profiling dan optimasi               |
| Testing               | Mampu mengembangkan automated test                   |
| Security              | Mampu merancang batas keamanan                       |
| Deployment            | Mampu mendistribusikan aplikasi                      |
| Framework Design      | Mampu membangun library dan framework sendiri        |

# 11. Standar kelulusan setiap fase

Jangan berpindah fase hanya karena sudah membaca seluruh materi.

Gunakan standar berikut.

| Level        | Standar kelulusan                                                                         |
| ------------ | ----------------------------------------------------------------------------------------- |
| Foundation   | Dapat menjelaskan konsep dan menulis implementasi dasar tanpa menyalin                    |
| Intermediate | Dapat menggabungkan beberapa konsep menjadi aplikasi                                      |
| Advanced     | Dapat merancang struktur modular dan menyelesaikan masalah kompleks                       |
| Expert       | Dapat memahami implementasi internal, melakukan debugging mendalam dan membuat API native |
| Enterprise   | Dapat membangun sistem yang aman, teruji, terdokumentasi, dapat diperluas dan dipelihara  |

## Sistem penilaian

Gunakan penilaian 100 poin untuk setiap fase.

| Aspek                         | Bobot |
| ----------------------------- | ----- |
| Pemahaman konsep              | 25    |
| Kemampuan menjelaskan kembali | 15    |
| Implementasi mandiri          | 25    |
| Debugging dan problem solving | 15    |
| Struktur dan kualitas kode    | 10    |
| Dokumentasi dan pengujian     | 10    |
| Total                         | 100   |

Interpretasi:

- 90–100: Sangat menguasai.
- 80–89: Menguasai.
- 70–79: Cukup, perlu penguatan.
- 60–69: Belum stabil.
- Di bawah 60: Perlu mengulang materi inti.

Untuk fase yang belum melibatkan C++, jangan memberikan penalti karena belum menguasai C++ tingkat lanjut. Penilaian harus sesuai kompetensi fase tersebut.

# 12. Rekomendasi strategi belajar

Ada beberapa prinsip yang sebaiknya diterapkan selama mengikuti kurikulum ini.

1\. Dokumentasi sebelum tutorial.

Mulailah dari dokumentasi resmi. Baca bagian Overview, Concepts, Properties, Methods, Signals, dan Examples dari setiap tipe yang dipelajari.

2\. Pahami API sampai tingkat atributnya.

Misalnya ketika mempelajari `Rectangle`, jangan berhenti pada cara membuat kotak. Pelajari:

- Superclass.
- Properties.
- Signals.
- Inherited properties.
- Default values.
- Property types.
- Performance implications.
- Related types.

Lakukan pendekatan serupa pada setiap API penting.

3\. Bedakan QML API dengan C++ API.

Contohnya:

- `ListView` adalah QML type.
- `QQuickItem` adalah C++ class.
- `QAbstractListModel` adalah C++ model class.
- `property alias` adalah fitur bahasa QML.

Memahami perbedaan kategori tersebut sangat penting agar tidak mencampur konsep bahasa, framework, dan implementasi native.

4\. Gunakan pendekatan eksperimen.

Setiap mempelajari satu properti atau API:

1. Baca dokumentasi.
2. Buat contoh terkecil.
3. Ubah satu parameter.
4. Amati hasil.
5. Periksa error.
6. Bandingkan dengan perilaku yang didokumentasikan.
7. Buat kesimpulan sendiri.

5\. Pelajari keterbatasan API, bukan hanya kemampuannya.

Developer yang memahami API secara mendalam mengetahui kapan API tersebut tepat digunakan, kapan tidak, dan alternatif apa yang tersedia.


| Fase | Progres | Kompetensi |
|---|---|---|
| **Fase 0 — Environment & Foundation** | 0/4 | - [ ] Memahami ekosistem Qt 6 <br> - [ ] Memahami SDK dan module <br> - [ ] Menguasai CMake dasar <br> - [ ] Membangun aplikasi QML pertama |
| **Fase 1 — QML Language** | 0/4 | - [ ] Sintaks dan struktur dokumen <br> - [ ] Tipe data dan properti <br> - [ ] Object attributes dan IDs <br> - [ ] Components dan object types |
| **Fase 2 — JavaScript** | 0/4 | - [ ] JavaScript fundamentals <br> - [ ] Expressions dan functions <br> - [ ] JavaScript resources <br> - [ ] Execution boundaries |
| **Fase 10 — C++ Interoperability** | 0/6 | - [ ] C++ fundamentals <br> - [ ] Qt object model <br> - [ ] Exposing C++ to QML <br> - [ ] Two-way communication <br> - [ ] Native data models <br> - [ ] External libraries |
| **Fase 14 — Mastery** | 0/5 | - [ ] Advanced type system <br> - [ ] Custom QQuickItem <br> - [ ] Plugin architecture <br> - [ ] Framework design <br> - [ ] Independent research |

# 14. Kesimpulan akademis

Kurikulum ini sengaja membedakan lima lapisan penguasaan:

1. Language mastery: memahami QML sebagai bahasa deklaratif.
2. Framework mastery: memahami Qt Quick sebagai sistem UI dan rendering.
3. Architecture mastery: memahami bagaimana aplikasi dan modul disusun.
4. Native engineering: memahami C++, Meta-Object System, dan integrasi sistem.
5. Framework engineering: mampu merancang API, plugin, library, dan abstraksi yang dapat digunakan kembali.

Ada satu hal yang sangat penting: menguasai QML tidak sama dengan menguasai seluruh Qt Quick, dan menguasai Qt Quick tidak otomatis berarti menguasai arsitektur internal Qt.

Karena itu, jangan melewatkan fase 3, 8, 10, dan 11. Keempat fase tersebut menjadi fondasi penting untuk memahami bagaimana sistem deklaratif, modularitas, integrasi native, dan rendering bekerja secara mendalam.

Target akhir bukan sekadar mampu membuat tampilan desktop yang bagus, melainkan mampu membaca dokumentasi API, memahami implementasinya, merancang abstraksi sendiri, membuat komponen baru, dan memodifikasi sistem secara mandiri.

Sumber utama yang harus terus digunakan sepanjang pembelajaran adalah [Qt 6 Documentation](https://doc.qt.io/qt-6/?utm_source=chatgpt.com). Dokumentasi tersebut bersifat hidup dan diperbarui mengikuti perkembangan Qt. Saat mempelajari API, selalu periksa versi Qt yang digunakan karena ketersediaan fitur dan perilakunya dapat berbeda antarversi.

</details>

---

<details>
  <summary>Audit Kurikulum</summary>


# Audit Kurikulum Qt 6: JavaScript dalam QML dan Mastery QML & Qt Quick

Laporan audit kurikulum · 4 November 2026

## Ringkasan hasil audit

Dokumen “Mastery QML & Qt Quick” sudah berfungsi sebagai peta jalan yang solid untuk programmer. Dokumen “JavaScript dalam QML” masih berupa indeks topik, belum sumber belajar. Akurasi teknis umumnya baik dan tidak ada kesalahan fatal, tetapi ada beberapa koreksi nyata. Dua persyaratan awal belum terpenuhi: template per-modul yang konsisten (terutama Dokumen 1) dan keterbacaan untuk non-IT. Penilaian subjektif: sekitar 8/10 untuk programmer yang baru di Qt, sekitar 4/10 untuk non-IT.

## Poin kuat

- Batas lingkup Dokumen 1 tegas dan benar. Tabel browser vs QML dan peringatan “jangan samakan dengan browser” sesuai dokumentasi resmi.
- Tabel dukungan fitur per versi akurat. `??` didukung sejak Qt 5.15, `?.` sejak 6.2, dan separator numerik sejak 6.8, di atas basis ECMAScript edisi ke-7. `QVariantList` bisa diubah in-place sejak 6.5 dan `QVariantMap` sejak 6.9.
- Contoh `PropertyChanges { panel.width: 400 }` benar. Bentuk dengan ID memang yang direkomendasikan, sedangkan bentuk `target:` dipertahankan untuk kompatibilitas Qt 5.
- Praktik Qt 6 modern dipakai konsisten: `qt_add_qml_module`, `QML_ELEMENT`, hindari context property, `required property`.
- Struktur kelulusan berbasis proyek, rubrik 100 poin (bobotnya benar berjumlah 100), strategi “dokumentasi dulu, pelajari keterbatasan API”, dan prinsip least privilege di Modul 13.1.

## Area peningkatan

### A. Koreksi akurasi

1. **Modul 2.3:** `.pragma ComponentBehavior` keliru. `.pragma library` adalah direktif file `.js`, sedangkan `pragma ComponentBehavior: Bound` (tanpa titik) adalah pragma dokumen `.qml`. Pisahkan keduanya, dan sebutkan juga `pragma FunctionSignatureBehavior`, yang mengatur perilaku anotasi tipe fungsi.
2. **Modul 1.2:** `time` bukan value type QML. QTime dikonversi menjadi JavaScript `Date`, dan tabel tipe dasar resmi tidak memuat `time`. Tipe yang justru hilang dari daftar adalah `font`, `matrix4x4`, dan `quaternion`.
3. **Modul 9.2:** “Default style” dan “Basic style” dipisah. Di Qt 6 “Default” diganti nama menjadi “Basic”, dan style bawaan di Linux adalah Fusion. Tambahkan juga pemilihan style lewat `QQuickStyle`, argumen `-style`, env `QT_QUICK_CONTROLS_STYLE`, atau `qtquickcontrols2.conf`, serta konsekuensi run-time selection: compiler QML tidak bisa menghasilkan kode C++ untuk binding pada properti kontrol.
4. **Modul 4.2:** `qmlscene` tidak boleh disajikan sebagai alat Qt 6. Di Qt 6 ia sudah deprecated dan mencetak peringatan agar memakai `qml`.
5. **Dokumen 1, Fase 2.2:** BigInt tidak ada di daftar objek global yang didukung engine, sedangkan Symbol dan Promise tercantum. Hapus atau tandai tidak didukung. Untuk object spread (`{...obj}`, Fase 1 dan 7.1): itu fitur ES2018, sedangkan engine berbasis ES7 dan halaman Host Environment hanya menyebut tiga tambahan di atas. Tandai sebagai “uji dulu dengan `qml`”.
6. **Dokumen 1, Fase 8.4 (`this`):** `this` tidak terdefinisi di sebagian besar konteks QML. Hanya di binding, signal handler, dan fungsi yang dideklarasikan di QML ia merujuk ke scope object. Mulai dari aturan ini, bukan dari perbandingan arrow vs regular function ala browser.
7. **Dokumen 1, Fase 15.3 (`async`/`await`):** dokumentasi resmi tidak menyebut dukungannya. Sejauh yang diketahui belum didukung. Jadikan eksperimen pembuktian, bukan materi pokok.
8. **Modul 5.3 (Theme singleton):** contoh tidak lengkap. Di CMake, file harus ditandai `QT_QML_SINGLETON_TYPE TRUE`, kalau tidak singleton tidak terdaftar. Ini jebakan klasik.
9. **Modul 0.2/4.4:** `main.cpp` tidak ditampilkan, dan target `hello` dijalankan sebagai `./build/myapp`. Pembelajar tidak bisa menjalankan contoh pertama. Beri `main.cpp` minimal (`QGuiApplication` + `QQmlApplicationEngine` + `loadFromModule`).
10. **Minor:**
    - Modul 7.3: `function createRectangle()` berada di luar objek, jadi bukan QML valid.
    - Modul 5.1: `parent.title` rapuh, ganti dengan `id: root`.
    - §8.4: repo `qtquickcontrols2` adalah warisan Qt 5, karena sejauh yang diketahui kontrol Qt 6 sudah berada di `qtdeclarative`.
    - Estimasi Foundation tertulis 4–7 minggu, padahal jumlah Fase 0–2 adalah 5–8.

### B. Topik penting yang belum tercakup atau terlalu tipis

- **Runtime dan bootstrap:** `QT_QPA_PLATFORM` (wayland/xcb), `QT_QUICK_BACKEND=software`, `QSG_RHI_BACKEND`, `QSG_INFO`, `QSG_VISUALIZE`, `QML_IMPORT_TRACE`, `QT_LOGGING_RULES`. Ini sangat relevan di Arch dengan WM.
- **Kompilasi QML Qt 6:** `qmlcachegen`, `qmlsc`, `qmltc`, dan anotasi tipe fungsi. Sejak Qt 6.7 anotasi tipe selalu ditegakkan saat fungsi dipanggil, tetapi di kurikulum ia hanya muncul sebagai kata kunci. Tambahkan juga `as` type assertion.
- **Threading:** `QThread`/worker object, thread affinity, `QtConcurrent`/`QFuture`, `WorkerScript`. Saat ini hanya disebut di daftar, tanpa modul.
- **C++ Qt 6 modern:** bindable properties (`QProperty`), `QQmlListProperty`, attached dan extension types (`QML_ATTACHED`, `QML_EXTENDED`, `QML_FOREIGN`), `QQmlParserStatus`, `QQmlComponent` dari sisi C++.
- **Qt Quick:** Shapes, MultiEffect, Particles, Qt Quick Dialogs, persistensi `Settings`. `QtQml.StateMachine` juga perlu dibedakan dari `State` Qt Quick, karena Modul 6.1 menyebut “state machines” tanpa membedakan.
- **Jebakan tipe data dari dokumentasi resmi:** array-like hasil konversi dari C++ tetap mengembalikan `false` pada `Array.isArray()`, konversi `QDate`↔`Date` bergantung pada UTC, dan penomoran bulan JavaScript 0–11 sedangkan Qt 1–12. Masukkan ke Dokumen 1 Fase 2.8, 6.5, dan 14.
- **Dokumen 1:**
  - Sintaks Connections modern `function onX()`, karena bentuk lama `onX:` sudah deprecated.
  - `required property` dan `pragma ComponentBehavior: Bound` untuk delegate (Fase 8/9).
  - Pendaftaran file `.js` di `QML_FILES` agar ikut ter-embed (Fase 13).
- **Keamanan (13.1):**
  - Gerbang baca file lokal oleh XHR (`QML_XHR_ALLOW_FILE_READ`).
  - Injeksi lewat `QML_IMPORT_PATH` dan `QT_PLUGIN_PATH`.
  - `Qt.createQmlObject` atau `Loader` dari URL tak tepercaya sama dengan eksekusi kode.
  - Isolasi proses (bubblewrap/firejail/Flatpak) dan perbedaan model isolasi Wayland vs X11.
- **Tooling dan distribusi:** target CMake `all_qmllint`, konfigurasi `qmlls` untuk Neovim, dan `PKGBUILD` (Arch) yang belum disebut eksplisit.

### C. Kepatuhan terhadap persyaratan per modul

| Persyaratan | Dokumen 2 (Mastery) | Dokumen 1 (JS dalam QML) |
| --- | --- | --- |
| Deskripsi konkret dan konsep mendalam | Baik | Tidak ada. Fase berisi daftar kata kunci tanpa kalimat penjelas (mis. “Function execution context.”) |
| Contoh kode | Belasan modul tanpa contoh (mis. 2.4, 3.4, 7.4, 9.4, 10.1, 10.6, 11.1, 11.2, 12.1, 12.4, 13.4, 14.1, 14.4, 14.5) | Fase 10, 12, 14–19 tanpa kode |
| Terminologi | Kurang dari separuh modul | Hanya Fase 1 |
| Daftar isi | Ada | Berupa poin tanpa struktur |
| Referensi | Ada | Hanya 8 dari 20 fase punya referensi inline |
| Indikasi visual | Hanya 2 (0.2 dan 11.1) | Nol |

Kandidat visual yang paling bernilai: scope chain (Dokumen 1 F8), dependency graph binding (F11), alur signal (F12), event loop (F15), batas JS↔C++ (F16), dan lifecycle objek (F17).

### D. Aksesibilitas bagi non-IT

- Prasyarat “terminal Linux dan dasar pemrograman wajib” (Dokumen 2 §3) bertentangan dengan target non-IT.
- Tidak ada fase orientasi tentang program, compiler, event loop, GUI, path, dan git.
- Jargon muncul sebelum definisi (`QObject`, meta-object, scene graph), tanpa analogi dan tanpa glosarium terpusat.
- Tidak ada latihan atau cek pemahaman per modul.
- Saran: tambahkan Fase 0 “orientasi”, glosarium, dan template modul tetap: Analogi → Contoh minimal → Cara menjalankan → Kesalahan umum → Latihan 15 menit → Cek pemahaman. Untuk eksekusi, ajarkan `qml berkas.qml` sebagai jalur eksperimen satu file sebelum CMake.

### E. Tujuan “menambah fitur di proyek apa pun” dan penguasaan

- Jalur C++ integration, 14.5 (membaca source), dan framework design sudah mengarah ke penguasaan.
- Belum ada metodologi menambah fitur ke codebase asing: membaca arsitektur, menemukan titik ekstensi, reproduksi minimal, patch, uji.
- Proyek 01–06 belum punya spesifikasi dan kriteria penerimaan yang terukur.
- Perlu “peta keputusan” modul Qt lain (Quick 3D, Charts/Graphs, WebEngine, Multimedia, Wayland compositor). Klaim “segala kebutuhan” hanya realistis jika kurikulum mengajarkan cara belajar modul baru.
- Opsional, jika tujuannya UI desktop terminal-centric: capstone berupa komponen shell (bar atau launcher) di Wayland.

### F. Struktur

- Dokumen 1 dan Fase 2 Dokumen 2 tumpang tindih (2–3 minggu vs 12–18 minggu). Jadikan Dokumen 1 sebagai jalur pendalaman Fase 1–3 dengan tabel pemetaan fase.
- Urutan ketergantungan bermasalah di dua tempat. Dokumen 1 Fase 16 butuh C++ yang baru muncul di Dokumen 2 Fase 10. Modul 5.3 butuh CMake dan modul QML yang baru diajarkan di Fase 8.
- Tabel progres hanya mencakup 5 dari 15 fase, dan penomoran bab loncat dari 12 ke 14.

### G. Format dan tautan

- Hapus `?utm_source=chatgpt.com` dari semua tautan.
- Bersihkan artefak ekspor: `[image](...favicon...)`, label “Qt 6.10.3+2” dan “Qt 6.12.0+1”, dan `&#x20;`.
- Gambar Proyek 01–06 di-hotlink dari `images.openai.com`. Isinya thumbnail halaman acak yang tidak relevan dan akan mati. Ganti dengan diagram buatan sendiri (Mermaid atau ASCII).
- Versi tautan tercampur (`qt-6.10`, `qt-6.8`, `qt-6`). Pakai `/qt-6/` tanpa versi atau pin satu versi.
- Modul 9.2 memuat dua referensi dengan URL identik.
- Tiga pola tautan yang diragukan dan perlu dicek manual: `qtqml-debugging.html`, `qtqml-type-compiler.html`, `qtquick-gradient.html`.

## Urutan perbaikan yang disarankan

1. Terapkan koreksi A1–A9.
2. Tetapkan template modul, lalu isi Dokumen 1, mulai Fase 10, 12, dan 14–19.
3. Tambahkan Fase 0 non-IT dan glosarium.
4. Tambahkan modul yang hilang: runtime/bootstrap, kompilasi QML Qt 6, threading, dan metodologi memodifikasi proyek asing.
5. Bersihkan format dan tautan.

## Sumber verifikasi

- [JavaScript Host Environment (Qt 6.10)](https://doc.qt.io/qt-6.10/qtqml-javascript-hostenvironment.html)
- [List of JavaScript Objects and Functions](https://doc.qt.io/qt-6/qtqml-javascript-functionlist.html)
- [Data Type Conversion Between QML and C++](https://doc.qt.io/qt-6/qtqml-cppintegration-data.html)
- [PropertyChanges QML Type](https://doc.qt.io/qt-6/qml-qtquick-propertychanges.html)
- [Changes to Qt Quick Controls (migrasi Qt 6)](https://doc.qt.io/Qt-6/qtquickcontrols-changes-qt6.html)
- [Styling Qt Quick Controls (Qt 6.5)](https://doc.qt.io/qt-6.5/qtquickcontrols-styles.html)
- [Qt Forum: qmlscene issues](https://forum.qt.io/topic/163731/qmlscene-issues/3)

</details>

[Quickshell](./quickshell/quickshell.md)
