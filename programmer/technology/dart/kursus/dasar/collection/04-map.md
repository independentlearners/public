# 04 — Map

## Apa Itu

`Map<K, V>` menyimpan pasangan key-value, di mana tiap key unik. Berbeda dari List/Set/Queue, `Map` **tidak** meng-extend `Iterable` secara langsung — tapi tiga getter-nya (`.keys`, `.values`, `.entries`) masing-masing mengembalikan `Iterable`, jadi kamu tetap bisa memakai seluruh perangkat `map`/`where`/`fold` di atasnya lewat salah satu getter itu.

Sumber: [Map class — api.dart.dev](https://api.dart.dev/dart-core/Map-class.html)

## Tiga Implementasi Konkret

| Implementasi | Urutan iterasi (berdasar key) | Kompleksitas rata-rata | Kapan dipakai |
|---|---|---|---|
| `LinkedHashMap` | Sesuai urutan insersi key | O(1) | **Default** untuk `{}` dan `Map()` |
| `HashMap` | Tidak dijamin | O(1) | Urutan sama sekali tidak penting |
| `SplayTreeMap` | Selalu terurut naik | O(log n) | Butuh iterasi key dalam urutan terurut |

Sama seperti Set, ini terverifikasi langsung dari sumber resmi: *"Creates a Map instance with the default implementation, LinkedHashMap. This constructor is equivalent to the non-const map literal `<K,V>{}`."*

```dart
import 'dart:collection';

void main() {
  var nilai = {'Ani': 90, 'Budi': 85, 'Citra': 95};
  print(nilai.runtimeType); // LinkedHashMap<String, int>

  var takTerurut = HashMap<String, int>()..addAll(nilai);
  // Urutan iterasi takTerurut tidak dijamin sama dengan urutan insersi

  var terurut = SplayTreeMap<String, int>()..addAll(nilai);
  print(terurut.keys.toList()); // [Ani, Budi, Citra] — terurut alfabetis otomatis
}
```

Sumber: [LinkedHashMap — api.dart.dev](https://api.dart.dev/dart-collection/LinkedHashMap-class.html), [HashMap — api.dart.dev](https://api.dart.dev/dart-collection/HashMap-class.html), [SplayTreeMap — api.dart.dev](https://api.dart.dev/dart-collection/SplayTreeMap-class.html)

## `UnmodifiableMapView` — Ringkasan Pola yang Sama

```dart
import 'dart:collection';

var asli = {'a': 1, 'b': 2};
var view = UnmodifiableMapView(asli);
asli['c'] = 3;
print(view); // {a: 1, b: 2, c: 3} — ikut berubah (view, bukan salinan)

var snapshot = Map.unmodifiable(asli);
asli['d'] = 4;
print(snapshot); // {a: 1, b: 2, c: 3} — tidak ikut berubah lagi
```

Sumber: [UnmodifiableMapView — api.dart.dev](https://api.dart.dev/dart-collection/UnmodifiableMapView-class.html)

## Operasi Dasar

```dart
var stok = <String, int>{'apel': 10, 'jeruk': 5};

// Akses & ubah
print(stok['apel']);      // 10
print(stok['mangga']);    // null — key tidak ada, TIDAK error
stok['mangga'] = 3;       // tambah/timpa key baru

// putIfAbsent — hanya isi kalau key belum ada (berguna untuk cache/memoization)
stok.putIfAbsent('apel', () => 999); // tidak berubah, 'apel' sudah ada
stok.putIfAbsent('pisang', () => 7); // ditambahkan, karena belum ada

// update — ubah value berdasarkan value lama, dengan fallback kalau key belum ada
stok.update('apel', (v) => v + 1, ifAbsent: () => 1); // apel jadi 11
stok.updateAll((key, v) => v * 2); // kalikan semua value dengan 2

// Hapus
stok.remove('jeruk');
stok.removeWhere((k, v) => v < 5);

// Cek keberadaan
print(stok.containsKey('apel'));   // true
print(stok.containsValue(999));    // false
```

## Iterasi

```dart
var nilai = {'Ani': 90, 'Budi': 85};

// forEach — paling langsung untuk efek samping
nilai.forEach((nama, skor) => print('$nama: $skor'));

// keys / values / entries — masing-masing Iterable
print(nilai.keys.toList());   // [Ani, Budi]
print(nilai.values.toList()); // [90, 85]

for (var entry in nilai.entries) {
  print('${entry.key} -> ${entry.value}');
}

// map() — transformasi Map jadi Map baru (bukan List seperti Iterable.map!)
var dipetakan = nilai.map((k, v) => MapEntry(k.toUpperCase(), v + 5));
print(dipetakan); // {ANI: 95, BUDI: 90}
```

**Catatan penting**: `Map.map()` beda dari `Iterable.map()` — yang pertama mengembalikan `Map` baru (karena butuh MapEntry baru untuk tiap pasangan), yang kedua mengembalikan `Iterable`. Jangan tertukar hanya karena nama method-nya sama.

Sumber: [MapEntry — api.dart.dev](https://api.dart.dev/dart-core/MapEntry-class.html)

## Literal, Spread, Collection-if/for

```dart
var dasar = {'a': 1, 'b': 2};
bool sertakanC = true;

var gabungan = {
  ...dasar,
  if (sertakanC) 'c': 3,
  for (var i in [1, 2, 3]) 'item$i': i,
};
print(gabungan); // {a: 1, b: 2, c: 3, item1: 1, item2: 2, item3: 3}
```

## Equality Key — Aturan Sama Seperti Set

Key custom butuh `==` dan `hashCode` yang konsisten, persis seperti elemen di Set (lihat file `03` untuk contoh lengkap). Ini masuk akal karena secara internal, `HashMap`/`LinkedHashMap` menggunakan struktur hash-table yang sama prinsipnya dengan `HashSet`/`LinkedHashSet` — bedanya cuma tiap slot menyimpan pasangan key-value, bukan elemen tunggal.

## Kapan Pakai Implementasi Mana

- **`LinkedHashMap`** (default): pilihan aman untuk hampir semua kasus umum — kamu dapat urutan insersi yang predictable tanpa biaya tambahan berarti.
- **`HashMap`**: kalau kamu benar-benar tidak peduli urutan dan ingin sedikit lebih hemat, misalnya menghitung frekuensi kata dalam teks besar di mana urutan hasil akan diurutkan ulang nanti.
- **`SplayTreeMap`**: kalau kamu butuh iterasi key selalu dalam urutan terurut — contoh: leaderboard yang selalu ingin dibaca dari skor tertinggi ke terendah tanpa perlu sort ulang setiap kali dibaca.

## Refleksi Sebelum Lanjut

- Kenapa `Map.map()` mengembalikan `Map`, sedangkan `Iterable.map()` mengembalikan `Iterable`?
- Kapan kamu memilih `putIfAbsent` dibanding cek manual `if (!map.containsKey(k))`?
- Kalau key Map-mu adalah object custom dan kamu lupa override `hashCode`, apa gejala bug yang akan muncul?

Lanjut ke [05-queue.md][1].

[1]: ./05-queue.md

