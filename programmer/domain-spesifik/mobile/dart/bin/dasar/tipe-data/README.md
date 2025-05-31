# Tipe Data Lengkap dalam Dart

## 1. Built-in Types (Tipe Data Bawaan)

### Numbers

| Tipe Data | Definisi                                           | Kategori | Contoh Penggunaan                                              | Range/Kapasitas                        |
| --------- | -------------------------------------------------- | -------- | -------------------------------------------------------------- | -------------------------------------- |
| int       | Bilangan bulat                                     | Number   | `int age = 25;`                                                | Platform dependent (-2^63 to 2^63 - 1) |
| double    | Bilangan desimal                                   | Number   | `double price = 99.99;`                                        | 64-bit (IEEE 754)                      |
| num       | Tipe numerik umum (parent class dari int & double) | Number   | `num value = 42;`                                              | Bergantung pada turunannya             |
| BigInt    | Bilangan bulat dengan presisi arbitrer             | Number   | `BigInt big = BigInt.parse('123456789012345678901234567890');` | Unlimited precision                    |

### Strings

| Tipe Data    | Definisi                            | Kategori | Contoh Penggunaan                   | Karakteristik  |
| ------------ | ----------------------------------- | -------- | ----------------------------------- | -------------- |
| String       | Rangkaian karakter                  | Text     | `String name = "John";`             | UTF-16 encoded |
| StringBuffer | String yang dapat dimodifikasi      | Text     | `StringBuffer sb = StringBuffer();` | Mutable string |
| StringSink   | Abstract class untuk menulis string | Text     | `StringSink sink;`                  | Interface      |

### Booleans

| Tipe Data | Definisi        | Kategori | Contoh Penggunaan       | Nilai      |
| --------- | --------------- | -------- | ----------------------- | ---------- |
| bool      | Nilai kebenaran | Logical  | `bool isActive = true;` | true/false |

## 2. Collections (Koleksi)

### Lists

| Tipe Data         | Definisi                  | Kategori   | Contoh Penggunaan                | Karakteristik    |
| ----------------- | ------------------------- | ---------- | -------------------------------- | ---------------- |
| List              | Kumpulan nilai berurutan  | Collection | `List<int> numbers = [1, 2, 3];` | Ordered, indexed |
| Fixed-Length List | List dengan panjang tetap | Collection | `List<int>.filled(3, 0);`        | Fixed size       |
| Growable List     | List yang dapat bertambah | Collection | `List<String> names = [];`       | Dynamic size     |

### Sets

| Tipe Data     | Definisi                          | Kategori   | Contoh Penggunaan                                     | Karakteristik             |
| ------------- | --------------------------------- | ---------- | ----------------------------------------------------- | ------------------------- |
| Set           | Kumpulan nilai unik               | Collection | `Set<String> uniqueNames = {};`                       | No duplicates             |
| HashSet       | Implementasi Set berbasis hash    | Collection | `HashSet<int> numbers = HashSet();`                   | Fast lookup               |
| LinkedHashSet | Set dengan urutan insertion       | Collection | `LinkedHashSet<String> orderedSet = LinkedHashSet();` | Maintains insertion order |
| SplayTreeSet  | Set berbasis balanced binary tree | Collection | `SplayTreeSet<int> sortedSet = SplayTreeSet();`       | Sorted elements           |

### Maps

| Tipe Data     | Definisi                          | Kategori   | Contoh Penggunaan                                       | Karakteristik   |
| ------------- | --------------------------------- | ---------- | ------------------------------------------------------- | --------------- |
| Map           | Kumpulan pasangan key-value       | Collection | `Map<String, int> ages = {};`                           | Key-value pairs |
| HashMap       | Implementasi Map berbasis hash    | Collection | `HashMap<String, dynamic> data = HashMap();`            | Fast access     |
| LinkedHashMap | Map dengan urutan insertion       | Collection | `LinkedHashMap<String, int> ordered = LinkedHashMap();` | Maintains order |
| SplayTreeMap  | Map berbasis balanced binary tree | Collection | `SplayTreeMap<String, int> sortedMap = SplayTreeMap();` | Sorted keys     |

### Queues

| Tipe Data         | Definisi                 | Kategori   | Contoh Penggunaan                                   | Karakteristik             |
| ----------------- | ------------------------ | ---------- | --------------------------------------------------- | ------------------------- |
| Queue             | Struktur data FIFO       | Collection | `Queue<String> queue = Queue();`                    | First in, first out       |
| DoubleLinkedQueue | Queue dengan linked list | Collection | `DoubleLinkedQueue<int> dlq = DoubleLinkedQueue();` | Efficient add/remove      |
| ListQueue         | Queue berbasis list      | Collection | `ListQueue<String> lq = ListQueue();`               | List-based implementation |

## 3. Special Types (Tipe Khusus)

### Runes & Symbols

| Tipe Data | Definisi                           | Kategori | Contoh Penggunaan               | Karakteristik   |
| --------- | ---------------------------------- | -------- | ------------------------------- | --------------- |
| Runes     | Unicode code points                | Special  | `Runes input = Runes('Hello');` | Unicode support |
| Symbol    | Identifier yang tidak dapat diubah | Special  | `Symbol lib = Symbol('foo');`   | Immutable       |

### Dynamic & Object Types

| Tipe Data | Definisi                       | Kategori | Contoh Penggunaan           | Karakteristik   |
| --------- | ------------------------------ | -------- | --------------------------- | --------------- |
| dynamic   | Tipe data dinamis              | Special  | `dynamic value = 42;`       | Can change type |
| void      | Tidak mengembalikan nilai      | Special  | `void main() {}`            | No return value |
| Object    | Parent class dari semua object | Special  | `Object item = "anything";` | Base type       |
| Object?   | Nullable Object                | Special  | `Object? nullable = null;`  | Can be null     |

### Function Types

| Tipe Data | Definisi                       | Kategori | Contoh Penggunaan                              | Karakteristik    |
| --------- | ------------------------------ | -------- | ---------------------------------------------- | ---------------- |
| Function  | Tipe untuk function            | Special  | `Function callback = () => print('Hi');`       | Generic function |
| typedef   | Alias untuk function signature | Special  | `typedef Calculator = int Function(int, int);` | Type alias       |

## 4. Nullable Types (Dart 2.12+)

| Tipe Data    | Definisi                      | Kategori | Contoh Penggunaan                      | Karakteristik  |
| ------------ | ----------------------------- | -------- | -------------------------------------- | -------------- |
| Nullable     | Tipe yang dapat bernilai null | Special  | `String? name;`                        | Can be null    |
| Non-nullable | Tipe yang tidak dapat null    | Special  | `String name = "John";`                | Cannot be null |
| Never        | Tipe yang tidak pernah return | Special  | `Never throwError() => throw 'Error';` | Never returns  |

## 5. Future & Stream Types (Asynchronous)

| Tipe Data          | Definisi                           | Kategori | Contoh Penggunaan                                        | Karakteristik          |
| ------------------ | ---------------------------------- | -------- | -------------------------------------------------------- | ---------------------- |
| Future             | Nilai yang tersedia di masa depan  | Async    | `Future<String> getData()`                               | Single value           |
| Stream             | Sequence of asynchronous events    | Async    | `Stream<int> countStream()`                              | Multiple values        |
| Completer          | Untuk membuat Future secara manual | Async    | `Completer<String> completer = Completer();`             | Manual future creation |
| StreamController   | Untuk membuat Stream secara manual | Async    | `StreamController<int> controller = StreamController();` | Manual stream creation |
| StreamSubscription | Subscription ke Stream             | Async    | `StreamSubscription sub = stream.listen(...);`           | Stream subscription    |

## 6. Generic Types

| Tipe Data             | Definisi                      | Kategori | Contoh Penggunaan                   | Karakteristik |
| --------------------- | ----------------------------- | -------- | ----------------------------------- | ------------- |
| Generic               | Tipe parametrik               | Special  | `class Box<T> {}`                   | Type-safe     |
| Bounded Generic       | Generic dengan batasan tipe   | Special  | `class NumberBox<T extends num> {}` | Constrained   |
| Covariant Generic     | Generic dengan covariance     | Special  | `class Producer<out T> {}`          | Output type   |
| Contravariant Generic | Generic dengan contravariance | Special  | `class Consumer<in T> {}`           | Input type    |

## 7. Record Types (Dart 3.0+)

| Tipe Data    | Definisi                    | Kategori | Contoh Penggunaan                                            | Karakteristik   |
| ------------ | --------------------------- | -------- | ------------------------------------------------------------ | --------------- |
| Record       | Struktur data immutable     | Modern   | `(String, int) person = ('John', 25);`                       | Immutable tuple |
| Named Record | Record dengan field bernama | Modern   | `({String name, int age}) person = (name: 'John', age: 25);` | Named fields    |

## 8. Pattern Types & Sealed Classes (Dart 3.0+)

| Tipe Data       | Definisi                                             | Kategori | Contoh Penggunaan             | Karakteristik               |
| --------------- | ---------------------------------------------------- | -------- | ----------------------------- | --------------------------- |
| Sealed Class    | Class yang hanya bisa di-extend dalam file yang sama | Pattern  | `sealed class Shape {}`       | Exhaustive pattern matching |
| Base Class      | Class yang hanya bisa di-extend, tidak di-implement  | Pattern  | `base class Vehicle {}`       | Inheritance only            |
| Final Class     | Class yang tidak bisa di-extend atau di-implement    | Pattern  | `final class Singleton {}`    | No inheritance              |
| Interface Class | Class yang hanya bisa di-implement                   | Pattern  | `interface class Drawable {}` | Implementation only         |
| Mixin Class     | Class yang bisa dijadikan mixin                      | Pattern  | `mixin class Flyable {}`      | Can be used as mixin        |

## 9. Extension Types (Dart 3.0+)

| Tipe Data      | Definisi                       | Kategori | Contoh Penggunaan                  | Karakteristik         |
| -------------- | ------------------------------ | -------- | ---------------------------------- | --------------------- |
| Extension Type | Wrapper tanpa overhead runtime | Modern   | `extension type UserId(int id) {}` | Zero-cost abstraction |

## 10. Iterable Types

| Tipe Data | Definisi                                     | Kategori   | Contoh Penggunaan                        | Karakteristik      |
| --------- | -------------------------------------------- | ---------- | ---------------------------------------- | ------------------ |
| Iterable  | Interface untuk koleksi yang bisa di-iterasi | Collection | `Iterable<int> numbers = [1, 2, 3];`     | Abstract iteration |
| Iterator  | Interface untuk iterasi step-by-step         | Collection | `Iterator<String> iter = list.iterator;` | Manual iteration   |

## 11. DateTime & Duration Types

| Tipe Data | Definisi                       | Kategori | Contoh Penggunaan                           | Karakteristik    |
| --------- | ------------------------------ | -------- | ------------------------------------------- | ---------------- |
| DateTime  | Representasi tanggal dan waktu | Time     | `DateTime now = DateTime.now();`            | Date and time    |
| Duration  | Representasi durasi waktu      | Time     | `Duration timeout = Duration(seconds: 30);` | Time span        |
| Stopwatch | Untuk mengukur waktu eksekusi  | Time     | `Stopwatch sw = Stopwatch()..start();`      | Time measurement |

## 12. URI & RegExp Types

| Tipe Data | Definisi                    | Kategori | Contoh Penggunaan                             | Karakteristik      |
| --------- | --------------------------- | -------- | --------------------------------------------- | ------------------ |
| Uri       | Uniform Resource Identifier | Network  | `Uri url = Uri.parse('https://example.com');` | URL/URI handling   |
| RegExp    | Regular Expression          | Text     | `RegExp pattern = RegExp(r'\d+');`            | Pattern matching   |
| Match     | Hasil dari RegExp matching  | Text     | `Match? match = pattern.firstMatch(text);`    | Regex match result |

## 13. Error & Exception Types

| Tipe Data  | Definisi                            | Kategori  | Contoh Penggunaan                               | Karakteristik      |
| ---------- | ----------------------------------- | --------- | ----------------------------------------------- | ------------------ |
| Error      | Base class untuk programming errors | Exception | `Error error = ArgumentError('Invalid');`       | Programming errors |
| Exception  | Base class untuk exceptions         | Exception | `Exception ex = FormatException('Bad format');` | Runtime exceptions |
| StackTrace | Jejak stack saat error              | Exception | `StackTrace trace = StackTrace.current;`        | Error tracing      |

## 14. Type Information Types

| Tipe Data | Definisi                       | Kategori   | Contoh Penggunaan                  | Karakteristik     |
| --------- | ------------------------------ | ---------- | ---------------------------------- | ----------------- |
| Type      | Representasi runtime dari tipe | Reflection | `Type stringType = String;`        | Runtime type info |
| TypedData | Base untuk typed data lists    | Binary     | `Uint8List bytes = Uint8List(10);` | Binary data       |

## 15. Specialized Collections

| Tipe Data   | Definisi                        | Kategori | Contoh Penggunaan                                  | Karakteristik    |
| ----------- | ------------------------------- | -------- | -------------------------------------------------- | ---------------- |
| Uint8List   | List of 8-bit unsigned integers | Binary   | `Uint8List bytes = Uint8List.fromList([1, 2, 3]);` | Byte array       |
| Int32List   | List of 32-bit signed integers  | Binary   | `Int32List numbers = Int32List(5);`                | 32-bit integers  |
| Float64List | List of 64-bit floating point   | Binary   | `Float64List decimals = Float64List(3);`           | 64-bit floats    |
| ByteData    | View of binary data             | Binary   | `ByteData data = ByteData(8);`                     | Binary data view |

**Daftar Isi:**

- **BigInt** untuk bilangan bulat presisi tinggi
- **Queue types** (Queue, DoubleLinkedQueue, ListQueue)
- **Specialized Collections** seperti Uint8List, Int32List, Float64List
- **Record Types** (fitur baru Dart 3.0+)
- **Pattern Types & Sealed Classes** (Dart 3.0+)
- **Extension Types** (Dart 3.0+)
- **DateTime & Duration** untuk handling waktu
- **URI & RegExp** untuk network dan pattern matching
- **Error & Exception types** untuk error handling
- **Binary data types** (TypedData, ByteData)
- **Async types** yang lebih lengkap (Completer, StreamController)
- **Function types** dan typedef
- **Type information types**

> **Catatan**: Panduan ini mencakup semua tipe data utama dalam Dart dari versi klasik hingga Dart 3.0+, termasuk fitur-fitur terbaru seperti Records, Pattern Matching, dan Extension Types.
