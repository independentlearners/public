# 07 — Fitur Bahasa, `package:collection`, dan Perbandingan Performa

## Spread, Collection-if, Collection-for — Ini Fitur Bahasa, Bukan Library

Penting dipahami: `...`, `if`, dan `for` di dalam literal collection **di-desugar saat kompilasi**, bukan method yang dipanggil saat runtime seperti `map()`/`where()`. Ini murni cara membangun literal `List`/`Set`/`Map` yang lebih ringkas — hasil akhirnya tetap collection biasa, tidak ada "keajaiban" tambahan.

```dart
var dasar = [1, 2, 3];

// Spread — sisipkan seluruh isi iterable lain
var gabungan = [0, ...dasar, 4]; // [0, 1, 2, 3, 4]

// Spread null-aware — aman kalau sumbernya null
List<int>? mungkinNull;
var aman = [0, ...?mungkinNull, 1]; // [0, 1], tidak error

// Collection-if — sisipkan elemen secara kondisional
bool tampilkanExtra = true;
var kondisional = [1, 2, if (tampilkanExtra) 3]; // [1, 2, 3]

// Collection-for — bangun elemen dari perulangan
var dariLoop = [for (var i = 0; i < 5; i++) i * i]; // [0, 1, 4, 9, 16]

// Ketiganya bisa dikombinasikan dan disarangkan
var kompleks = [
  ...dasar,
  if (tampilkanExtra) for (var i in [10, 20]) i,
];
print(kompleks); // [1, 2, 3, 10, 20]
```

Berlaku sama untuk `Set` dan `Map` literal — lihat contoh Map di file `04`.

Sumber: [Language Tour — Collections](https://dart.dev/language/collections)

## Generics dalam Collection

`List<E>`, `Set<E>`, `Map<K, V>` semuanya generic — tipe elemen ditentukan saat instansiasi (atau diinferensi dari konteks).

```dart
var angka = [1, 2, 3];           // diinferensi: List<int>
var campuran = [1, 'dua', 3.0];  // diinferensi: List<Object>

// Eksplisit lebih baik saat inferensi bisa ambigu atau kamu ingin API yang jelas
List<num> daftarNum = [1, 2.5, 3];
```

**Perangkap variance**: `List<int>` bukan subtipe dari `List<num>` secara implisit dalam artian "aman ditulis" — Dart memakai *runtime type check* untuk sebagian kasus ini (unsound covariance untuk kompatibilitas dengan Java/C#-style generics). Praktiknya:

```dart
List<int> daftarInt = [1, 2, 3];
List<num> daftarNum = daftarInt; // diizinkan, covariant
daftarNum.add(2.5);              // ERROR runtime: 2.5 bukan int!
```

Ini bukan alasan untuk takut pada generics, cuma alasan untuk sadar bahwa tipe statis `List<num>` tidak menjamin semua elemen benar-benar bisa jadi `num` sembarangan kalau list itu aslinya `List<int>` di balik layar.

## `package:collection` — Perkakas Tambahan Resmi dari Tim Dart

`dart:collection` (bawaan SDK) dan `package:collection` (paket terpisah, tapi tetap dikelola resmi oleh tim Dart) adalah dua hal berbeda — yang kedua **harus ditambahkan manual** ke `pubspec.yaml`:

```yaml
dependencies:
  collection: ^1.19.0
```

Lalu:

```dart
import 'package:collection/collection.dart';
```

### Masalah yang Diselesaikan: Collection Tidak Punya Equality Struktural Bawaan

```dart
void main() {
  var a = [1, 2, 3];
  var b = [1, 2, 3];
  print(a == b); // false! Beda instance walau isinya identik — ini BUKAN bug
}
```

Ini sesuai desain — `==` bawaan untuk List/Set/Map memeriksa identitas objek, bukan isi. `package:collection` menyediakan pembanding struktural:

```dart
import 'package:collection/collection.dart';

void main() {
  var a = [1, 2, 3];
  var b = [1, 2, 3];
  print(const ListEquality().equals(a, b)); // true — bandingkan ISI

  var peta1 = {'x': 1, 'y': 2};
  var peta2 = {'x': 1, 'y': 2};
  print(const MapEquality().equals(peta1, peta2)); // true
}
```

### `PriorityQueue` — Antrean Prioritas (Heap)

Tidak ada di `dart:collection`, tapi tersedia di `package:collection`:

```dart
import 'package:collection/collection.dart';

void main() {
  var pq = PriorityQueue<int>(); // min-heap: elemen terkecil keluar duluan
  pq.addAll([5, 1, 8, 2]);
  print(pq.removeFirst()); // 1
  print(pq.removeFirst()); // 2
}
```

### Ekstensi Praktis: `firstWhereOrNull`, `groupBy`

```dart
import 'package:collection/collection.dart';

void main() {
  var angka = [1, 2, 3];

  // firstWhere bawaan HARUS diberi orElse, atau throw kalau tidak ketemu.
  // firstWhereOrNull dari package:collection mengembalikan null dengan aman.
  print(angka.firstWhereOrNull((n) => n > 10)); // null, bukan exception

  var kata = ['apel', 'anggur', 'jeruk', 'jambu'];
  var kelompok = groupBy(kata, (String k) => k[0]);
  print(kelompok); // {a: [apel, anggur], j: [jeruk, jambu]}
}
```

Sumber: [package:collection — pub.dev](https://pub.dev/packages/collection)

## Tabel Perbandingan Performa (Big-O) — Rangkuman Lintas Semua Tipe

Ini tabel yang paling sering kamu butuhkan saat memutuskan struktur data mana yang dipakai. Simpan sebagai referensi cepat.

| Operasi | `List` | `LinkedHashSet`/`HashSet` | `SplayTreeSet` | `LinkedHashMap`/`HashMap` (by key) | `SplayTreeMap` (by key) | `ListQueue` |
|---|---|---|---|---|---|---|
| Akses by index | O(1) | – | – | – | – | – |
| Tambah (umum) | O(1) amortized (di akhir) | O(1) avg | O(log n) | O(1) avg | O(log n) | O(1) amortized (kedua ujung) |
| Cari / `contains` | O(n) | O(1) avg | O(log n) | O(1) avg | O(log n) | O(n) |
| Hapus (by value/key) | O(n) | O(1) avg | O(log n) | O(1) avg | O(log n) | O(1) di ujung, O(n) di tengah |
| Urutan iterasi | Index | Insersi (Linked) / tak dijamin (Hash) | Terurut | Insersi (Linked) / tak dijamin (Hash) | Terurut by key | Insersi (FIFO) |

## Panduan Cepat Memilih Struktur

Alur pertanyaan singkat yang bisa kamu jalankan tiap kali mendesain:

1. **Butuh akses berdasarkan posisi/index, dan duplikat itu valid?** → `List`
2. **Butuh keunikan otomatis, tidak peduli key-value?** → `Set` (pilih `LinkedHashSet` default, `HashSet` kalau urutan benar-benar tidak relevan, `SplayTreeSet` kalau butuh selalu terurut)
3. **Butuh pasangan key → value?** → `Map` (pilih `LinkedHashMap` default, `HashMap`/`SplayTreeMap` sesuai kebutuhan urutan)
4. **Butuh tambah/hapus efisien di KEDUA ujung (FIFO/deque/stack)?** → `Queue` (`ListQueue` sebagai default)
5. **Tidak satu pun di atas cukup — butuh perilaku/invariant khusus?** → Bangun collection kustom (file `06`)

## Refleksi Sebelum Lanjut

- Kenapa `[0, ...dasar, 4]` tidak dianggap "method call" seperti `dasar.map(...)`, walau sama-sama menghasilkan collection baru?
- Kalau kamu perlu bandingkan dua `List<Map<String, dynamic>>` untuk kesamaan isi, kenapa `==` bawaan tidak cukup, dan apa yang kamu pakai sebagai gantinya?
- Dari tabel Big-O, operasi apa yang membuatmu langsung tahu "ini seharusnya bukan List" begitu melihatnya di kode?

Lanjut ke `08-tutorial-mental-progresif.md` — bagian latihan tanpa kunci jawaban.
