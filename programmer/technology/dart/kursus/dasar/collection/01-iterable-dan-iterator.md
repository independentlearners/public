# 01 — Iterable & Iterator: Fondasi Semua Collection

## Apa Itu

`Iterable<E>` adalah kontrak abstrak: "saya representasikan urutan elemen bertipe `E` yang bisa dijelajahi satu per satu." Itu saja. `Iterable` sendiri **tidak tahu** bagaimana elemen-elemennya disimpan — bisa dari array di memori (List), bisa dihitung on-the-fly (`Iterable.generate`), bisa dari hasil transformasi malas (`map`, `where`).

`Iterator<E>` adalah mesin penjelajahnya — objek terpisah yang punya "posisi kursor" saat ini. Kontraknya cuma dua anggota:

```dart
abstract class Iterator<E> {
  bool moveNext();  // pindah ke elemen berikutnya, return false kalau sudah habis
  E get current;    // elemen di posisi kursor sekarang
}
```

**Kenapa ini penting dipahami duluan:** `List`, `Set`, dan `Queue` semuanya adalah `Iterable`. Semua method seperti `.map()`, `.where()`, `.fold()` yang kamu pakai di List/Set sebenarnya didefinisikan di `Iterable`, diwarisi turun. Kalau kamu paham `Iterable`, kamu otomatis paham 80% permukaan API dari List, Set, dan Queue sekaligus — itulah kenapa fondasinya cuma satu.

Sumber: [Iterable class — api.dart.dev](https://api.dart.dev/dart-core/Iterable-class.html), [Iterator class — api.dart.dev](https://api.dart.dev/dart-core/Iterator-class.html)

## Bagaimana `for-in` Bekerja di Balik Layar

```dart
for (var item in someIterable) {
  print(item);
}
```

Ini gula sintaksis untuk:

```dart
var it = someIterable.iterator;
while (it.moveNext()) {
  var item = it.current;
  print(item);
}
```

Setiap kali kamu memanggil getter `.iterator`, kamu mendapat Iterator **baru** yang mulai dari awal — itu sebabnya kamu bisa loop `for-in` yang sama dua kali secara independen tanpa saling mengganggu posisi kursor.

## Method-Method Kunci di Iterable

| Method | Tipe | Fungsi |
|---|---|---|
| `map(f)` | lazy | Transformasi tiap elemen |
| `where(f)` | lazy | Filter elemen sesuai predikat |
| `expand(f)` | lazy | Map lalu ratakan (flatten) hasil iterable-of-iterable |
| `take(n)` / `takeWhile(f)` | lazy | Ambil n elemen pertama / selama kondisi benar |
| `skip(n)` / `skipWhile(f)` | lazy | Lewati n elemen pertama / selama kondisi benar |
| `forEach(f)` | eager | Jalankan efek samping tiap elemen, tidak mengembalikan apa-apa |
| `fold(init, f)` | eager | Akumulasi ke satu nilai, mulai dari `init` |
| `reduce(f)` | eager | Sama seperti fold tapi nilai awal = elemen pertama (error kalau kosong) |
| `toList()` / `toSet()` | eager | Materialisasi jadi List/Set konkret |
| `any(f)` / `every(f)` | eager | Cek eksistensial / universal |
| `contains(v)` | eager | Cek keanggotaan |
| `firstWhere(f)` / `lastWhere(f)` / `singleWhere(f)` | eager | Cari elemen sesuai kondisi |
| `elementAt(i)` | eager | Ambil elemen ke-i (hati-hati: O(n) kalau bukan List) |
| `join(sep)` | eager | Gabung jadi String |
| `first` / `last` / `single` | eager (getter) | Elemen pertama/terakhir/satu-satunya |
| `isEmpty` / `isNotEmpty` / `length` | eager (getter) | Status dan jumlah elemen |

Sumber lengkap tiap method: [Iterable class — api.dart.dev](https://api.dart.dev/dart-core/Iterable-class.html)

## Lazy vs Eager — Konsep Paling Sering Disalahpahami

Ini bagian yang harus benar-benar masuk mental model kamu, karena salah paham di sini menyebabkan bug performa yang sulit dilacak.

`map`, `where`, `expand`, `take`, `skip` itu **malas (lazy)** — mereka tidak menjalankan apa pun saat dipanggil. Mereka cuma membungkus iterable asal dengan "rencana transformasi" yang baru benar-benar dieksekusi saat ada yang **memaksa iterasi** (lewat `for-in`, `toList()`, `forEach()`, dll).

```dart
void main() {
  var angka = [1, 2, 3, 4, 5];

  print('Sebelum membuat iterable turunan');
  var hasil = angka
      .map((x) {
        print('memproses $x');
        return x * 2;
      })
      .where((x) => x > 4);
  print('Iterable sudah dibuat, tapi belum ada yang diproses');

  print('Sekarang memaksa evaluasi:');
  print(hasil.toList()); // baru di sini "memproses..." muncul
}
```

Output-nya akan menunjukkan bahwa baris `memproses $x` baru tercetak setelah `hasil.toList()` dipanggil — bukan saat `.map().where()` ditulis. Ini penting untuk dua alasan:

1. **Efisiensi**: `angka.map(f).where(g).first` tidak memproses seluruh list — begitu elemen pertama yang lolos `where` ditemukan, iterasi berhenti. Kalau kamu pakai `toList()` di tengah rantai, kamu memaksa materialisasi penuh dan kehilangan keuntungan ini.
2. **Iterable bisa tak-berhingga**: karena lazy, kamu bisa punya `Iterable` yang secara konseptual tak terbatas (misalnya deret bilangan asli) selama kamu tidak memaksa iterasi penuh tanpa batas (`take(n)` dulu sebelum `toList()`).

## `Iterable.generate` — Membuat Iterable dari Fungsi

```dart
// Menghasilkan iterable [0, 1, 4, 9, 16] secara lazy
Iterable<int> kuadrat = Iterable.generate(5, (i) => i * i);
print(kuadrat.toList()); // [0, 1, 4, 9, 16]
```

## Generator Function: `sync*` dan `yield`

Cara paling praktis membuat Iterable kustom tanpa menulis class Iterator manual. Fungsi dengan `sync*` mengembalikan `Iterable<E>`, dan `yield` "mengeluarkan" satu elemen setiap kali dipanggil oleh Iterator konsumen — bukan langsung menjalankan seluruh badan fungsi.

```dart
Iterable<int> bilanganGenapSampai(int batas) sync* {
  for (int i = 0; i <= batas; i += 2) {
    yield i; // eksekusi "berhenti" di sini sampai moveNext() berikutnya dipanggil
  }
}

void main() {
  for (var n in bilanganGenapSampai(10)) {
    print(n); // 0, 2, 4, 6, 8, 10 — dicetak satu-satu, dihitung satu-satu
  }
}
```

`yield*` dipakai untuk mendelegasikan ke Iterable lain di tengah generator:

```dart
Iterable<int> gabungan() sync* {
  yield 0;
  yield* bilanganGenapSampai(4); // menyisipkan seluruh isi iterable lain
  yield 99;
}
// Hasil: 0, 0, 2, 4, 99
```

> Catatan: `async*` (dengan `yield` juga) adalah versi asinkron yang menghasilkan `Stream`, bukan `Iterable` — konsepnya mirip tapi ranahnya berbeda (asynchronous programming), tidak dibahas di sini.

## Membuat Iterable Kustom via `IterableBase`

Kalau kamu mau bikin tipe koleksimu sendiri yang berperilaku seperti Iterable (bisa di-`map`, di-`where`, dipakai di `for-in`), kamu **hanya perlu mengimplementasikan satu anggota**: getter `iterator`. Sisanya — `map`, `where`, `fold`, dll — didapat gratis dari `IterableBase`.

```dart
import 'dart:collection';

/// Iterable kustom: representasikan rentang bilangan bulat [start, end)
class Range extends IterableBase<int> {
  final int start;
  final int end;

  Range(this.start, this.end);

  @override
  Iterator<int> get iterator => _RangeIterator(start, end);
}

class _RangeIterator implements Iterator<int> {
  int _current;
  final int _end;

  _RangeIterator(int start, this._end) : _current = start - 1;

  @override
  bool moveNext() {
    _current++;
    return _current < _end;
  }

  @override
  int get current => _current;
}

void main() {
  var r = Range(1, 6);
  print(r.toList());          // [1, 2, 3, 4, 5] — method ini "gratis" dari IterableBase
  print(r.where((n) => n.isEven).toList()); // [2, 4] — ini juga gratis
}
```

`IterableBase` (extends, single-inheritance) dan `IterableMixin` (mixin, dipakai kalau class-mu sudah extends sesuatu yang lain) melakukan hal yang sama — pilih sesuai apakah kamu masih punya "slot" `extends` yang kosong atau tidak.

Sumber: [IterableBase — api.dart.dev](https://api.dart.dev/dart-collection/IterableBase-class.html), [IterableMixin — api.dart.dev](https://api.dart.dev/dart-collection/IterableMixin-class.html)

## Refleksi Sebelum Lanjut

Sebelum ke file `02`, pastikan kamu bisa jawab tanpa buka dokumentasi:
- Kenapa `list.map(f).where(g)` tidak langsung "memproses" apa pun saat baris itu dieksekusi?
- Apa bedanya `Iterable` dan `Iterator`, secara tanggung jawab masing-masing?
- Kalau kamu extends `IterableBase`, member apa yang WAJIB kamu implementasikan?

Lanjut ke [02-list.md][1].


[1]: ./02-list.md
