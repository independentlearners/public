# 03 — Set

## Apa Itu

`Set<E>` adalah `Iterable<E>` dengan satu jaminan tambahan: **setiap elemen unik**. Menambahkan elemen yang sudah ada tidak melakukan apa-apa (tidak error, cuma diabaikan). Urutan iterasi bergantung implementasi konkretnya — ini beda dari List yang urutannya selalu sesuai posisi insersi/index.

Sumber: [Set class — api.dart.dev](https://api.dart.dev/dart-core/Set-class.html)

## Tiga Implementasi Konkret

| Implementasi | Urutan iterasi | Kompleksitas rata-rata | Kapan dipakai |
|---|---|---|---|
| `LinkedHashSet` | Sesuai urutan insersi | O(1) | **Default** untuk `{}` dan `Set()` — pilihan aman kalau tidak yakin |
| `HashSet` | Tidak dijamin | O(1) | Sedikit lebih hemat memori/cepat kalau urutan sama sekali tidak penting |
| `SplayTreeSet` | Selalu terurut | O(log n) | Butuh iterasi dalam urutan terurut terus-menerus |

**Fakta yang terverifikasi langsung dari api.dart.dev** (koreksi untuk sumber tidak resmi yang beredar di internet): literal `{1, 2, 3}` dan `Set()` **defaultnya `LinkedHashSet`**, bukan `HashSet`. Dikutip langsung dari dokumentasi resmi: *"The default Set implementation, LinkedHashSet, considers objects indistinguishable if they are equal with regard to `Object.==` and `Object.hashCode`."*

```dart
import 'dart:collection';

void main() {
  // Default: LinkedHashSet — urutan insersi terjaga
  var planet = {'Merkurius', 'Venus', 'Bumi'};
  print(planet.runtimeType); // LinkedHashSet<String>

  // HashSet eksplisit — urutan TIDAK dijamin
  var hashSet = HashSet<int>()..addAll([5, 1, 3, 2]);
  print(hashSet); // urutan tidak pasti, tapi stabil selama tidak diubah

  // SplayTreeSet — selalu terurut naik
  var terurut = SplayTreeSet<int>()..addAll([5, 1, 3, 2]);
  print(terurut); // {1, 2, 3, 5} — selalu begini urutannya

  // SplayTreeSet dengan compare function kustom (untuk tipe yang bukan Comparable,
  // atau untuk mengubah arah urutan)
  var descending = SplayTreeSet<int>((a, b) => b.compareTo(a))..addAll([5, 1, 3]);
  print(descending); // {5, 3, 1}
}
```

Sumber: [LinkedHashSet — api.dart.dev](https://api.dart.dev/dart-collection/LinkedHashSet-class.html), [HashSet — api.dart.dev](https://api.dart.dev/dart-collection/HashSet-class.html), [SplayTreeSet — api.dart.dev](https://api.dart.dev/dart-collection/SplayTreeSet-class.html)

## `UnmodifiableSetView` — Snapshot vs View (Ringkasan)

Kamu sudah kenal ini: `UnmodifiableSetView` membungkus Set yang ada jadi jendela baca-saja yang **hidup dan tersinkron** — bukan salinan. Untuk salinan independen yang immutable permanen, pakai konstruktor `Set.unmodifiable(iterable)`.

```dart
import 'dart:collection';

var asli = {1, 2, 3};
var view = UnmodifiableSetView(asli);
asli.add(4);
print(view); // {1, 2, 3, 4} — ikut berubah, karena view, bukan salinan

var snapshot = Set.unmodifiable(asli);
asli.add(5);
print(snapshot); // {1, 2, 3, 4} — tidak ikut berubah lagi setelah snapshot diambil
```

Sumber: [UnmodifiableSetView — api.dart.dev](https://api.dart.dev/dart-collection/UnmodifiableSetView-class.html), [Set.unmodifiable — api.dart.dev](https://api.dart.dev/dart-core/Set-class.html)

## Operasi Himpunan (Set Theory)

Ini yang membedakan Set dari List secara fungsional — operasi matematis himpunan built-in:

```dart
var genap = {2, 4, 6, 8};
var kelipatan3 = {3, 6, 9};

print(genap.union(kelipatan3));        // {2, 4, 6, 8, 3, 9} — gabungan
print(genap.intersection(kelipatan3)); // {6} — irisan, ada di keduanya
print(genap.difference(kelipatan3));   // {2, 4, 8} — di genap TAPI TIDAK di kelipatan3
```

## Operasi Lain

```dart
var s = {1, 2, 3};

s.add(4);              // {1, 2, 3, 4}
s.add(2);               // tidak berubah — 2 sudah ada, diabaikan diam-diam
s.addAll({5, 6});       // tambah banyak
s.remove(1);            // hapus satu elemen
s.removeAll({2, 3});    // hapus banyak sekaligus
s.retainAll({4, 5});    // simpan HANYA yang ada di argumen, buang sisanya
print(s.contains(4));   // true — O(1) rata-rata, jauh lebih cepat dari List.contains
print(s.containsAll({4, 5})); // true
```

## Kenapa Equality dan hashCode Sangat Penting di Set

Set menentukan "apakah dua objek dianggap sama" lewat `operator==` dan `hashCode`. Kalau objek custom-mu tidak meng-override keduanya, Dart pakai identity default (dua objek dianggap sama HANYA kalau referensinya persis sama) — hasilnya sering tidak sesuai ekspektasi:

```dart
class Titik {
  final int x, y;
  Titik(this.x, this.y);
  // TANPA override == dan hashCode
}

void main() {
  var s = <Titik>{};
  s.add(Titik(1, 2));
  s.add(Titik(1, 2)); // "sama" secara nilai, tapi objek BEDA di memori
  print(s.length); // 2 — bukan 1! Set menganggap keduanya berbeda
}
```

Perbaikannya:

```dart
class Titik {
  final int x, y;
  Titik(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      other is Titik && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}

void main() {
  var s = <Titik>{};
  s.add(Titik(1, 2));
  s.add(Titik(1, 2)); // sekarang dianggap duplikat
  print(s.length); // 1 — sesuai ekspektasi
}
```

**Aturan besi**: kalau kamu override `==`, kamu WAJIB override `hashCode` juga dengan cara yang konsisten (dua objek yang `==` harus punya `hashCode` yang sama) — kalau tidak, Set/Map berbasis hash akan berperilaku aneh dan tidak konsisten.

## Kapan Set, Kapan List

Gunakan **Set** kalau:
- Kamu butuh keunikan dijamin secara otomatis
- Kamu sering melakukan `contains()` pada koleksi besar — O(1) vs O(n) di List signifikan untuk data besar
- Urutan elemen tidak penting (atau cukup urutan insersi via `LinkedHashSet`)

Gunakan **List** kalau:
- Duplikat itu valid dan bermakna
- Kamu butuh akses berdasarkan posisi/index
- Urutan eksplisit (bisa diurutkan ulang, dibalik, dll.) adalah bagian dari makna data

## Refleksi Sebelum Lanjut

- Kalau kamu tidak peduli urutan sama sekali dan performa jadi prioritas mutlak, kenapa `HashSet` bisa sedikit lebih unggul dari `LinkedHashSet`?
- Apa akibatnya kalau kamu override `==` tapi lupa override `hashCode`?
- Bagaimana kamu membedakan butuh `SplayTreeSet` vs cukup `sort()` hasil `.toList()` dari Set biasa?

Lanjut ke [04-map.md][1].

[1]: ./04-map.md
