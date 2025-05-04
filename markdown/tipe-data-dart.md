# Tipe Data dalam Dart

## 1. Built-in Types (Tipe Data Bawaan)

### Numbers
| Tipe Data | Definisi | Kategori | Contoh Penggunaan | Range/Kapasitas |
|-----------|----------|----------|-------------------|-----------------|
| int | Bilangan bulat | Number | `int age = 25;` | Platform dependent (-2^63 to 2^63 - 1) |
| double | Bilangan desimal | Number | `double price = 99.99;` | 64-bit (IEEE 754) |
| num | Tipe numerik umum (parent class dari int & double) | Number | `num value = 42;` | Bergantung pada turunannya |

### Strings
| Tipe Data | Definisi | Kategori | Contoh Penggunaan | Karakteristik |
|-----------|----------|----------|-------------------|---------------|
| String | Rangkaian karakter | Text | `String name = "John";` | UTF-16 encoded |
| StringBuffer | String yang dapat dimodifikasi | Text | `StringBuffer sb = StringBuffer();` | Mutable string |

### Booleans
| Tipe Data | Definisi | Kategori | Contoh Penggunaan | Nilai |
|-----------|----------|----------|-------------------|-------|
| bool | Nilai kebenaran | Logical | `bool isActive = true;` | true/false |

## 2. Collections (Koleksi)

### Lists
| Tipe Data | Definisi | Kategori | Contoh Penggunaan | Karakteristik |
|-----------|----------|----------|-------------------|---------------|
| List | Kumpulan nilai berurutan | Collection | `List<int> numbers = [1, 2, 3];` | Ordered, indexed |
| Fixed-Length List | List dengan panjang tetap | Collection | `List<int>.filled(3, 0);` | Fixed size |
| Growable List | List yang dapat bertambah | Collection | `List<String> names = [];` | Dynamic size |

### Sets
| Tipe Data | Definisi | Kategori | Contoh Penggunaan | Karakteristik |
|-----------|----------|----------|-------------------|---------------|
| Set | Kumpulan nilai unik | Collection | `Set<String> uniqueNames = {};` | No duplicates |
| HashSet | Implementasi Set berbasis hash | Collection | `HashSet<int> numbers = HashSet();` | Fast lookup |

### Maps
| Tipe Data | Definisi | Kategori | Contoh Penggunaan | Karakteristik |
|-----------|----------|----------|-------------------|---------------|
| Map | Kumpulan pasangan key-value | Collection | `Map<String, int> ages = {};` | Key-value pairs |
| HashMap | Implementasi Map berbasis hash | Collection | `HashMap<String, dynamic> data = HashMap();` | Fast access |
| LinkedHashMap | Map dengan urutan insertion | Collection | `LinkedHashMap<String, int> ordered = LinkedHashMap();` | Maintains order |

## 3. Special Types (Tipe Khusus)

### Runes & Symbols
| Tipe Data | Definisi | Kategori | Contoh Penggunaan | Karakteristik |
|-----------|----------|----------|-------------------|---------------|
| Runes | Unicode code points | Special | `Runes input = Runes('Hello');` | Unicode support |
| Symbol | Identifier yang tidak dapat diubah | Special | `Symbol lib = Symbol('foo');` | Immutable |

### Dynamic & Void
| Tipe Data | Definisi | Kategori | Contoh Penggunaan | Karakteristik |
|-----------|----------|----------|-------------------|---------------|
| dynamic | Tipe data dinamis | Special | `dynamic value = 42;` | Can change type |
| void | Tidak mengembalikan nilai | Special | `void main() {}` | No return value |
| Object | Parent class dari semua object | Special | `Object item = "anything";` | Base type |

## 4. Nullable Types (Dart 2.12+)

| Tipe Data | Definisi | Kategori | Contoh Penggunaan | Karakteristik |
|-----------|----------|----------|-------------------|---------------|
| Nullable | Tipe yang dapat bernilai null | Special | `String? name;` | Can be null |
| Non-nullable | Tipe yang tidak dapat null | Special | `String name = "John";` | Cannot be null |

## 5. Future & Stream Types (Asynchronous)

| Tipe Data | Definisi | Kategori | Contoh Penggunaan | Karakteristik |
|-----------|----------|----------|-------------------|---------------|
| Future | Nilai yang tersedia di masa depan | Async | `Future<String> getData()` | Single value |
| Stream | Sequence of asynchronous events | Async | `Stream<int> countStream()` | Multiple values |

## 6. Generic Types

| Tipe Data | Definisi | Kategori | Contoh Penggunaan | Karakteristik |
|-----------|----------|----------|-------------------|---------------|
| Generic | Tipe parametrik | Special | `class Box<T> {}` | Type-safe |
| Bounded Generic | Generic dengan batasan tipe | Special | `class NumberBox<T extends num> {}` | Constrained |
> Claude AI, By Anthropic