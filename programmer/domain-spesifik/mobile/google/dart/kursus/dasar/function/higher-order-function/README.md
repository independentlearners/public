# Higher Order Function

Untuk menjadikan function didalam function maka parameter wajib di tulis **`Function()`** setelah tipe data return-nya (tipe data pengembalian)

**Higher-Order Functions in Dart: Dari Dasar hingga Mahir**

> _"Functions are first-class citizens in Dart. Once kita menguasai higher-order functions, kita membuka pintu ke gaya pemrograman yang lebih ekspresif dan komposabel._

---

## 1. Apa itu Higher-Order Function (HOF)?

- **Definisi singkat**: Function yang **menerima** function lain sebagai parameter atau **mengembalikan** function sebagai hasil.
- **Kenapa penting?**
  - Mendorong _code reuse_ melalui komposisi.
  - Menyederhanakan pola callback dan event handling.
  - Fondasi paradigma _functional programming_.

## 2. Dasar: Mengirim Function sebagai Parameter

```dart
void executeTwice(void Function() action) {
  action();
  action();
}

void sayHello() {
  print('Hello, world!');
}

void main() {
  executeTwice(sayHello);
}
```

- `executeTwice` adalah HOF karena menerima function `action`.
- Panggil `executeTwice(sayHello)`, hasilnya `Hello, world!` dicetak dua kali.
- JIka fungsi `sayHello()` di berikan argumen maka harus menjadi anonymous function seperti berikut

```dart
void executeTwice(void Function() action) {
  action();
  action();
}

void sayHello(String a) {
  var a = 'Hello, world!';
  print(a);
}

void main() {
  executeTwice(() => sayHello(''));
}
```

## 3. Mengembalikan Function (Function Factory)

```dart
Function makeAdder(int addBy) {
  return (int i) => i + addBy;
}

void main() {
  var add5 = makeAdder(5);
  print(add5(10)); // 15
}
```

- `makeAdder` mengembalikan anonymous function.
- Setiap `add5`, `add10`, dll. menyimpan `addBy` berbeda (_closure_).

## 4. Arrow Functions & Sintaks Ringkas

```dart
List<String> names = ['Alice', 'Bob', 'Charlie'];

var uppercased = names.map((s) => s.toUpperCase());
print(uppercased); // (ALICE, BOB, CHARLIE)
```

- `map`, `where`, `reduce`, dst. semua HOF bawaan di koleksi Dart.
- Arrow syntax `=>` mempersingkat satu expression.

## 5. Closures: State yang Tersimpan

```dart
Function counter() {
  int count = 0;
  return () => ++count;
}

void main() {
  var c = counter();
  print(c()); // 1
  print(c()); // 2
}
```

- Closure menangkap `count` dan menyimpannya di memory.
- Berguna untuk stateful callbacks.

## 6. Penggunaan Lanjutan

### a. Komposisi Function

```dart
t Function<T, R, T>(R Function(T) f, T Function(T) g)
  compose<T, R>(R Function(T) f, T Function(T) g) {
  return (T x) => f(g(x));
}

void main() {
  var toStringFunc = (int x) => 'Value: $x';
  var square = (int x) => x * x;
  var composed = compose(toStringFunc, square);
  print(composed(3)); // "Value: 9"
}
```

### b. Memoization (Caching)

```dart
Function memoize<T, R>(R Function(T) fn) {
  final cache = <T, R>{};
  return (T x) {
    if (!cache.containsKey(x)) cache[x] = fn(x);
    return cache[x]!;
  };
}

// Contoh: faktorial
int factorial(int n) => n <= 1 ? 1 : n * factorial(n - 1);

void main() {
  var memoFact = memoize<int, int>(factorial);
  print(memoFact(10));
}
```

### c. Asynchronous HOF: Callback & Stream

```dart
Future<T> measure<T>(Future<T> Function() f) async {
  final stopwatch = Stopwatch()..start();
  final result = await f();
  stopwatch.stop();
  print('Elapsed: ${stopwatch.elapsedMilliseconds} ms');
  return result;
}

void main() async {
  await measure(() => Future.delayed(Duration(milliseconds: 500), () => 42));
}
```

- HOF bisa juga di konteks `Future` dan `Stream`.

## 7. Praktik di Flutter

- **Builder Functions**: `ListView.builder`, `FutureBuilder`, `StreamBuilder` memanfaatkan HOF untuk _lazy rendering_.
- **Event Handler**: `onPressed: () => doSomething()`.
- **Custom Hooks / Mixins**: membuat HOF untuk reusable logic.

```dart
Widget build(BuildContext context) {
  return StreamBuilder<int>(
    stream: counterStream(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return CircularProgressIndicator();
      return Text('Count: \${snapshot.data}');
    },
  );
}
```

## 8. Kapan & Sejauh Apa Menggunakan HOF?

- **Cocok untuk**:
  - Code yang butuh komposisi logika.
  - Meminimalisir duplikasi.
  - Layering transformasi data (pipeline).
- **Hati-hati**:
  - **Over-engineering**: jangan memaksakan HOF saat fungsi sederhana sudah cukup.
  - **Debugging**: stack trace bisa jadi lebih dalam/abstrak.
  - **Performance**: membuat banyak closure kecil bisa berpengaruh untuk kode kritis performa.

## 9. Tips & Best Practices

1. **Jaga kejelasan**: Jangan bikin HOF berantai terlalu panjang tanpa dokumentasi.
2. **Gunakan typedef** untuk tipe function yang kompleks.
   ```dart
   typedef Predicate<T> = bool Function(T);
   ```
3. **Tes unit** pada HOF dengan berbagai kombinasi function.
4. **Dokumentasikan** ekspektasi input/output function parameter.

---

> Itu tadi gambaran lengkap journey dari dasar hingga mahir menggunakan higher-order functions di Dart. Selamat berkreasi—semoga kode kamu makin modular, expressive, dan, tentu saja, keren! 🚀

#

```dart
void sayHello(String name, String Function(String) filter) {
  String filterName = filter(name);
  print('Hi $filterName');
}

String filterBadWord(name) {
  if (name == 'gila') {
    return '***';
  } else {
    return name;
  }
}

void main() {
  print('\n' * 5);

  sayHello('gila', filterBadWord);

  print('\n' * 5);
}
```

### Contoh Buruk

```dart
fungsi(String nama, String Function(String) filter) {
  var hasil = filter(nama);
  print('Hi $hasil');
}

String filter(String nama) {
  if (nama == 'gila' || nama == 'bodoh' || nama == 'tolol' || nama == 'gila ' 'bodoh') {
    return '****';
  } else {
    return nama;
  }
}

void main() {
  print('\n' * 2);

  fungsi('Dart', filter);
  fungsi('gila', filter);
  fungsi('bodoh', filter);
  fungsi('tolol', filter);

  fungsi('gila bodoh', filter);

  print('\n' * 2);
}
```

Sebaiknya menggunakan regex untuk memfilter lebih dari satu kata

```dart
String pattern = r'\b(gila|bodoh|tolol)\b';
RegExp regex = RegExp(pattern, caseSensitive: false);
```
