# Keyword Khusus Functon atau Method

Rangkuman **seluruh keyword** yang hanya valid di dalam deklarasi atau body fungsi/metode di Dart:

- **`void`**  
  Menandai fungsi tanpa nilai balik.

  ```dart
  void logMsg(String m) { print(m); }
  ```

- **`return`**  
  Menghentikan eksekusi fungsi dan (opsional) mengembalikan nilai.

  ```dart
  int sum(int a, int b) {
    return a + b;
  }
  ```

- **`=>`** (fat arrow)  
  Sintaks singkat untuk single-expression functions atau getters.

  ```dart
  int multiply(int a, int b) => a * b;
  ```

- **`async`** / **`await`**  
  Buat fungsi asynchronous yang mengembalikan `Future<T>`; `await` hanya boleh di dalamnya.

  ```dart
  Future<String> fetch() async {
    var data = await http.get(url);
    return data.body;
  }
  ```

- **`async*`** / **`sync*`** + **`yield`**  
  Generator: `async*` → `Stream<T>`, `sync*` → `Iterable<T>`.

  ```dart
  Stream<int> countToAsync(int n) async* {
    for (var i = 1; i <= n; i++) yield i;
  }
  Iterable<int> countToSync(int n) sync* {
    for (var i = 1; i <= n; i++) yield i;
  }
  ```

- **`operator`**  
  Overload operator di dalam kelas (metode khusus).

  ```dart
  class Vec { Vec operator +(Vec o) => Vec(x+o.x, y+o.y); }
  ```

- **`external`**  
  Deklarasi fungsi/getter/setter yang implementasinya di luar Dart.

  ```dart
  external void nativeLog(String msg);
  ```

- **`get`** / **`set`**  
  Accessor property—secara teknis metode tanpa/bersatu parameter.

  ```dart
  int get x => _x;
  set x(int v) { _x = v; }
  ```

- **`typedef`**  
  Alias tipe fungsi.

  ```dart
  typedef IntToStr = String Function(int);
  ```

- **`covariant`**  
  Memungkinkan override parameter dengan tipe lebih spesifik.

  ```dart
  void setVal(covariant num x) { … }
  ```

- **`rethrow`**  
  Lempar ulang exception di dalam blok `catch`.

  ```dart
  catch (e) {
    log(e);
    rethrow;
  }
  ```

- **`factory`**  
  Constructor khusus yang bisa kembalikan cache atau subtype.

  ```dart
  factory C() => _inst ??= C._();
  ```

- **`native`** _(deprecated)_  
  Versi lama untuk link ke kode native; sekarang digantikan `external`.

Sekarang sudah komplit—kompiler bakal protes kalau kamu pakai di luar konteks fungsi/metode! 🚀
