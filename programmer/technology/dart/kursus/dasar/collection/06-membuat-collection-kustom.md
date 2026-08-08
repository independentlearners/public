# 06 — Membuat Collection Kustom & Best Practices

## Kenapa Bikin Collection Sendiri

Tiga alasan legitimate untuk tidak sekadar pakai `List`/`Set`/`Map` bawaan:

1. **Enkapsulasi invariant** — kamu ingin memastikan aturan tertentu SELALU dipatuhi (kapasitas maksimum, urutan tertentu, validasi tiap elemen) tanpa bergantung pada disiplin pemanggil kode untuk cek manual setiap kali.
2. **API domain-spesifik** — mengekspos method yang bermakna untuk domainmu (`antrean.layaniBerikutnya()`) alih-alih permukaan generik List/Set/Map yang penuh method yang tidak relevan untuk domain itu.
3. **Perilaku khusus** — struktur yang berperilaku seperti collection standar tapi dengan logic tambahan (logging, eviction otomatis, lazy computation).

Dart menyediakan class dasar (`*Base`) dan mixin (`*Mixin`) di `dart:collection` yang membuat ini jauh lebih murah: kamu cuma perlu mengimplementasikan segelintir anggota "primitif," dan sisanya (puluhan method) didapat gratis.

## Pola Umum: Base Class vs Mixin

- **`XxxBase`** — dipakai dengan `extends`. Pilih ini kalau class-mu belum punya superclass lain.
- **`XxxMixin`** — dipakai dengan `with`. Pilih ini kalau class-mu sudah `extends` sesuatu yang lain dan Dart tidak mengizinkan multiple inheritance biasa (tapi mixin memang dirancang untuk kasus ini).

Keduanya butuh anggota primitif yang sama — bedanya cuma cara "dicolokkan" ke class-mu.

## `IterableBase` / `IterableMixin` — Primitif: `iterator`

Sudah dibahas di file `01` dengan contoh `Range`. Ini yang paling sederhana — cukup satu anggota.

Sumber: [IterableBase — api.dart.dev](https://api.dart.dev/dart-collection/IterableBase-class.html)

## `ListBase` / `ListMixin` — Primitif: `length`, `length=`, `[]`, `[]=`, `add`

```dart
import 'dart:collection';

/// List yang mencatat setiap perubahan — berguna untuk debugging atau undo-log
class ObservableList<E> extends ListBase<E> {
  final List<E> _internal = [];
  final void Function(String aksi, E? nilai) onChange;

  ObservableList(this.onChange);

  @override
  int get length => _internal.length;

  @override
  set length(int newLength) => _internal.length = newLength;

  @override
  E operator [](int index) => _internal[index];

  @override
  void operator []=(int index, E value) {
    _internal[index] = value;
    onChange('set[$index]', value);
  }

  @override
  void add(E value) {
    _internal.add(value);
    onChange('add', value);
  }
}

void main() {
  var log = <String>[];
  var daftar = ObservableList<String>((aksi, nilai) => log.add('$aksi -> $nilai'));

  daftar.add('pertama');
  daftar.add('kedua');
  daftar[0] = 'diubah';

  print(daftar); // [diubah, kedua]
  print(log);    // [add -> pertama, add -> kedua, set[0] -> diubah]

  // Method lain — removeAt, sort, indexOf, dll — semuanya BEKERJA
  // walau kamu tidak menulis satu baris pun untuk itu. Itu "gratis" dari ListBase.
  daftar.sort();
  print(daftar); // [diubah, kedua] -> terurut alfabetis
}
```

**Catatan penting** (sering jadi sumber bug): implementasi default `add` di `ListMixin` hanya bekerja untuk tipe elemen yang nullable. Untuk tipe non-nullable (kasus paling umum sejak null-safety), `add` **wajib** kamu override sendiri — seperti contoh di atas.

Sumber: [ListBase — api.dart.dev](https://api.dart.dev/dart-collection/ListBase-class.html), [ListMixin — api.dart.dev](https://api.dart.dev/dart-collection/ListMixin.html)

## `SetBase` / `SetMixin` — Primitif: `add`, `contains`, `lookup`, `remove`, `iterator`, `length`, `toSet`

Tujuh anggota — lebih banyak dari List karena Set punya semantik keanggotaan yang lebih kaya (`lookup` misalnya, dipakai untuk mengambil kembali instance elemen yang tersimpan, bukan cuma cek boolean).

```dart
import 'dart:collection';

/// Set string yang tidak peka huruf besar/kecil: "Dart" dan "DART" dianggap sama
class CaseInsensitiveSet extends SetBase<String> {
  final Set<String> _internal = <String>{}; // disimpan sebagai lowercase

  @override
  bool add(String value) => _internal.add(value.toLowerCase());

  @override
  bool contains(Object? element) =>
      element is String && _internal.contains(element.toLowerCase());

  @override
  String? lookup(Object? element) {
    if (element is! String) return null;
    var lower = element.toLowerCase();
    return _internal.contains(lower) ? lower : null;
  }

  @override
  bool remove(Object? value) =>
      value is String && _internal.remove(value.toLowerCase());

  @override
  Iterator<String> get iterator => _internal.iterator;

  @override
  int get length => _internal.length;

  @override
  Set<String> toSet() => CaseInsensitiveSet()..addAll(this);
}

void main() {
  var s = CaseInsensitiveSet();
  s.add('Dart');
  s.add('DART'); // dianggap duplikat dari 'Dart'
  print(s.length);          // 1
  print(s.contains('dart')); // true
}
```

Sumber: [SetBase — api.dart.dev](https://api.dart.dev/dart-collection/SetBase-class.html)

## `MapBase` / `MapMixin` — Primitif: `keys`, `[]`, `[]=`, `remove`, `clear`

```dart
import 'dart:collection';

/// Map yang mengembalikan nilai default alih-alih null untuk key yang belum ada
/// (mirip defaultdict di Python)
class DefaultMap<K, V> extends MapBase<K, V> {
  final Map<K, V> _internal = {};
  final V Function() nilaiDefault;

  DefaultMap(this.nilaiDefault);

  @override
  V operator [](Object? key) => _internal[key] ?? nilaiDefault();

  @override
  void operator []=(K key, V value) => _internal[key] = value;

  @override
  void clear() => _internal.clear();

  @override
  Iterable<K> get keys => _internal.keys;

  @override
  V? remove(Object? key) => _internal.remove(key);
}

void main() {
  var hitungKata = DefaultMap<String, int>(() => 0);

  for (var kata in ['dart', 'flutter', 'dart']) {
    hitungKata[kata] = hitungKata[kata] + 1;
  }

  print(hitungKata['dart']);    // 2
  print(hitungKata['belumAda']); // 0 — bukan null
}
```

Sumber: [MapBase — api.dart.dev](https://api.dart.dev/dart-collection/MapBase-class.html)

## Extend Base Class vs Implement Interface Langsung vs Komposisi

Tiga pendekatan, tiga trade-off:

| Pendekatan | Effort | Kapan dipilih |
|---|---|---|
| `extends XxxBase` / `with XxxMixin` | Rendah — implementasikan segelintir primitif | Default pilihan pertama. Kamu ingin relasi "is-a" penuh dan dapat semua method gratis |
| `implements List/Set/Map` langsung | Sangat tinggi — implementasikan SEMUA method sendiri | Jarang worth it, kecuali kamu punya kebutuhan performa sangat spesifik di hampir semua method sekaligus |
| **Komposisi** (bungkus collection di dalam, ekspos API sendiri) | Sedang — kamu tulis method domain-spesifik secara eksplisit | Kamu **tidak ingin** mengekspos seluruh permukaan API List/Set/Map — cuma sebagian yang relevan untuk domainmu |

Contoh komposisi (bukan "is-a List", tapi "punya List di dalam"):

```dart
/// Bukan extends ListBase — ini class domain-spesifik yang MEMBUNGKUS List,
/// bukan MENJADI List. Pemanggil tidak bisa sembarang panggil .sort() atau
/// .insert() di sini — cuma method yang benar-benar masuk akal untuk domain roster.
class Roster {
  final List<String> _pemain = [];

  void daftarkan(String nama) {
    if (_pemain.contains(nama)) {
      throw ArgumentError('$nama sudah terdaftar');
    }
    _pemain.add(nama);
  }

  void keluarkan(String nama) => _pemain.remove(nama);

  List<String> get pemain => List.unmodifiable(_pemain); // salinan read-only
  int get jumlahPemain => _pemain.length;
}
```

**Prinsip praktis**: kalau kamu ragu, mulai dari komposisi. Ini secara default lebih disiplin — kamu memilih secara sadar method apa saja yang boleh dipanggil orang lain, bukan mewarisi seluruh API generik yang mungkin tidak semuanya masuk akal untuk domainmu. Baru naik ke `extends XxxBase` kalau kamu memang ingin objekmu benar-benar diperlakukan sebagai List/Set/Map oleh kode lain (misalnya supaya bisa dipakai di fungsi yang mengharapkan parameter bertipe `List<E>`).

## Enkapsulasi & Defensive View

Pola yang sudah berulang kali muncul di file `02`–`04`: field koleksi privat yang mutable di dalam, getter publik yang mengekspos versi read-only di luar.

```dart
class Keranjang {
  final List<String> _item = [];

  void tambah(String item) => _item.add(item);

  // Ekspos VIEW read-only, bukan referensi langsung ke _item.
  // Kalau kamu ekspos `_item` langsung, kode luar bisa .add()/.clear() diam-diam
  // tanpa lewat method tambah() — merusak invariant yang mungkin kamu jaga di sana.
  List<String> get item => UnmodifiableListView(_item);
}
```

Ini bukan sekadar gaya — ini mencegah kelas bug tertentu: state internal berubah dari luar tanpa lewat "pintu resmi" yang kamu kontrol.

## Refleksi Sebelum Lanjut

- Kalau kamu extends `ListBase` untuk tipe elemen non-nullable, method apa yang WAJIB kamu override secara eksplisit meskipun secara teori "sudah ada default-nya"?
- Kapan komposisi jelas lebih baik daripada `extends SetBase`, walau secara teknis keduanya sama-sama bisa dipakai?
- Di contoh `Keranjang`, apa yang bisa salah kalau getter `item` mengembalikan `_item` langsung tanpa dibungkus `UnmodifiableListView`?

Lanjut ke [07-fitur-bahasa-dan-package-collection.md][1].

[1]: ./07-fitur-bahasa-dan-package-collection.md
