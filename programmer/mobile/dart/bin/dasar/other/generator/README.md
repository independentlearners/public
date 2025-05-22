Di Dart, satu-satunya mekanisme bawaan untuk “menghasilkan” nilai (termasuk `String`) secara tak terbatas—alias lazy sequence generator—adalah lewat **generator functions**. Generator functions ini menggunakan empat kata kunci:

- `sync*`
  Menandai fungsi yang mengembalikan `Iterable<T>` secara sinkron.
- `async*`
  Menandai fungsi yang mengembalikan `Stream<T>` secara asinkron.
- `yield`
  Mengeluarkan satu nilai ke iterable/stream pada generator sinkron/asinkron.
- `yield*`
  Mendelegasikan semua nilai dari iterable/stream lain (alias “flattening”).

Total ada **empat** kata kunci khusus untuk generator di atas.

> Contoh sederhana generator `String` acak tak terbatas:
>
> ```dart
> import 'dart:math';
>
> Iterable<String> randomStrings({int length = 8}) sync* {
>   final rnd = Random();
>   const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
>   while (true) {
>     yield List.generate(length, (_) => chars[rnd.nextInt(chars.length)])
>         .join();
>   }
> }
>
> void main() {
>   for (var s in randomStrings()) {
>     print(s); // terus-terusan tanpa henti
>   }
> }
> ```
>
> Jika ingin asinkron (misalnya tertunda tiap detik):
>
> ```dart
> Stream<String> randomStringsStream({int length = 8}) async* {
>   final rnd = Random();
>   const chars = 'abcdef…xyz0123456789';
>   while (true) {
>     await Future.delayed(Duration(seconds: 1));
>     yield String.fromCharCodes(
>       Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length)))
>     );
>   }
> }
> ```

Semua keyword Dart **berbahasa Inggris**, tidak ada keyword resmi dalam Bahasa Indonesia. Semua reserved words di Dart (seperti `class`, `if`, `while`, dll.) menggunakan kata-kata Inggris saja. Berikut penjelasan lebih mendalam tentang **generator functions** di Dart beserta contoh kode dari dokumentasi resmi dan referensi tambahan:

## 1. Tipe Generator di Dart

Dart mendukung dua jenis generator function:

1. **Synchronous generator (`sync*`)**

   - Mengembalikan objek `Iterable<T>`.
   - Di­eksekusi secara sinkron saat kode memintanya (lazily). ([dart.dev][1])

2. **Asynchronous generator (`async*`)**

   - Mengembalikan objek `Stream<T>`.
   - Menghasilkan nilai secara asinkron, otomatis menunggu subscriber sebelum menghasilkan event, dan menghormati _pause_ pada stream. ([dart.dev][2])

---

## 2. Empat Keyword Utama

| Keyword  | Fungsi                                                                         | Contoh Singkat                    |
| -------- | ------------------------------------------------------------------------------ | --------------------------------- |
| `sync*`  | Menandai fungsi sebagai synchronous generator.                                 | `Iterable<int> f() sync* { ... }` |
| `async*` | Menandai fungsi sebagai asynchronous generator.                                | `Stream<int> f() async* { ... }`  |
| `yield`  | Menghasilkan satu nilai ke `Iterable` atau `Stream` tanpa menghentikan fungsi. | `yield value;`                    |
| `yield*` | Mendelegasikan semua nilai dari generator/iterable lain (_flattening_).        | `yield* otherIterable;`           |

---

## 3. Contoh Kode dari Dokumentasi Resmi

### 3.1. Synchronous Generator

```dart
Iterable<int> naturalsTo(int n) sync* {
  int k = 0;
  while (k < n) {
    yield k++;
  }
}
```

> Fungsi di atas menghasilkan bilangan 0 hingga _n–1_ secara lazy saat diiterasi. ([dart.dev][1])

### 3.2. Asynchronous Generator

```dart
Stream<int> asynchronousNaturalsTo(int n) async* {
  int k = 0;
  while (k < n) {
    yield k++;
  }
}
```

> Menghasilkan event integer 0 hingga _n–1_ secara asinkron. ([dart.dev][1])

### 3.3. Delegasi dengan `yield*`

```dart
Iterable<int> naturalsDownFrom(int n) sync* {
  if (n > 0) {
    yield n;
    yield* naturalsDownFrom(n - 1);
  }
}
```

> Menggunakan `yield*` untuk memanggil kembali dirinya sendiri secara rekursif, meratakan semua hasilnya. ([dart.dev][1])

---

## 4. Perilaku dan Best Practices

1. **Lazy evaluation**

   - Nilai hanya dihasilkan saat dibutuhkan (`for-in` atau `await for` pada `Stream`).

2. **Pause & backpressure** (khusus `async*`)

   - `async*` otomatis menahan eksekusi di `yield` jika subscriber mem-pause stream. ([dart.dev][2])

3. **Tipe yang konsisten**

   - Pastikan jenis nilai yang di-`yield` cocok dengan deklarasi return function; analyzer akan menolak jika tidak cocok (diagnostic `yield_of_invalid_type`). ([dart.dev][3])

4. **Jangan gunakan `return` di generator**

   - Gunakan `yield` alih-alih `return` karena `return` di generator menghasilkan diagnostic `return_in_generator`. ([dart.dev][4])

5. **Delegasi vs flat map**

   - `yield*` untuk menggabungkan generator lain; gunakan `yield` per elemen jika ingin manipulasi.

---

## 5. Contoh Eksplorasi Lain (Random String Generator)

```dart
import 'dart:math';

Iterable<String> randomStrings({int length = 8}) sync* {
  final rnd = Random();
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  while (true) {
    yield List.generate(length, (_) => chars[rnd.nextInt(chars.length)]).join();
  }
}
```

> Membuat _infinite sequence_ string acak, berguna untuk pengujian atau simulasi data. ([Medium][5])

---

## 6. Referensi & Bahan Eksplorasi

1. **Dart Language Tour – Generators**

> _[Dokumen Resmi](https://dart.dev/language/functions#generators "Functions | Generators") ([dart.dev][1])_

2. **Creating Streams in Dart** (pause/backpressure)
   _[https://dart.dev/libraries/async/creating-streams](https://dart.dev/libraries/async/creating-streams)_ ([dart.dev][2])
3. **Medium: Exploring Dart Generators (Deepanshu Rawat)**
   _[https://medium.com/@deepanshurawat125/exploring-dart-generators](https://medium.com/@deepanshurawat125/exploring-dart-generators)..._ ([Medium][5])
4. \*_Medium: What are sync_, async*, yield and yield\*\*\*
   *[https://jelenaaa.medium.com/what-are-sync-async-yield-and-yield-in-dart](https://jelenaaa.medium.com/what-are-sync-async-yield-and-yield-in-dart)...\* ([Medium][6])

---

Dengan pemahaman ini, kamu bisa memanfaatkan generator untuk membangun _lazy sequences_, _infinite streams_, atau tugas-tugas asinkron secara efisien. Tetap eksplorasi dan bereksperimen dengan skenario nyata agar semakin mahir!

[1]: https://dart.dev/language/functions "Functions | Dart"
[2]: https://dart.dev/libraries/async/creating-streams?utm_source=chatgpt.com "Creating streams in Dart"
[3]: https://dart.dev/tools/diagnostics/yield_of_invalid_type?utm_source=chatgpt.com "yield_of_invalid_type - Dart"
[4]: https://dart.dev/tools/diagnostics/return_in_generator?utm_source=chatgpt.com "return_in_generator | Dart"
[5]: https://medium.com/%40deepanshurawat125/exploring-dart-generators-simplifying-iterations-with-sync-and-async-e63eb0f67cb7?utm_source=chatgpt.com "Exploring Dart Generators: Simplifying Iterations with Sync and Async"
[6]: https://jelenaaa.medium.com/what-are-sync-async-yield-and-yield-in-dart-defe57d06381?utm_source=chatgpt.com "What are sync*, async*, yield and yield* in Dart? | by Jelena Lecic"
