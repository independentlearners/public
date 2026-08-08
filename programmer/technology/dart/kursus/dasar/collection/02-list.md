# 02 — List

## Apa Itu

`List<E>` adalah `Iterable<E>` yang **terurut** dan **terindeks** — setiap elemen punya posisi integer (`0` sampai `length - 1`), dan boleh ada duplikat. Ini adalah struktur data "array" versi Dart.

Sumber: [List class — api.dart.dev](https://api.dart.dev/dart-core/List-class.html)

## Growable vs Fixed-Length

Ini pembeda paling mendasar yang wajib kamu tahu di kepala sebelum menulis kode List apa pun.

```dart
// GROWABLE — bisa nambah/kurang elemen, default kalau pakai literal
var growable = [1, 2, 3];
growable.add(4); // OK

// FIXED-LENGTH — panjang tetap begitu dibuat
var tetap = List.filled(3, 0); // [0, 0, 0], growable: false secara default
tetap[0] = 99;  // OK, ubah ISI boleh
tetap.add(4);   // ERROR runtime: UnsupportedError
```

| Cara membuat | Growable? | Catatan |
|---|---|---|
| `[1, 2, 3]` (literal) | Ya | Paling umum dipakai |
| `List.filled(n, isi)` | **Tidak** (default) | Tambahkan `growable: true` kalau perlu bisa nambah elemen |
| `List.filled(n, isi, growable: true)` | Ya | |
| `List.generate(n, (i) => ...)` | Ya (default) | Isi dihitung dari fungsi berdasarkan index |
| `List<int>.empty(growable: true)` | Ya | List kosong eksplisit |
| `List.from(iterable)` | Ya (default) | Terima `Iterable<dynamic>`, ada pengecekan tipe saat runtime |
| `List.of(iterable)` | Ya (default) | Versi type-safe dari `List.from`, dicek saat compile-time |
| `List.unmodifiable(iterable)` | Tidak, permanen | Snapshot immutable — lihat bagian di bawah |

```dart
var kuadrat = List.generate(5, (i) => i * i);
print(kuadrat); // [0, 1, 4, 9, 16]

// List.from vs List.of
List<num> angkaCampur = [1, 2.5, 3];
var lewatFrom = List<int>.from(angkaCampur.whereType<int>()); // aman, filter dulu
var lewatOf = List<int>.of([1, 2, 3]);                        // type-checked saat compile
```

**Kapan pakai fixed-length**: saat kamu tahu pasti ukurannya tidak akan berubah dan ingin API memberi sinyal itu secara eksplisit (mencegah bug "lupa kalau list ini seharusnya tidak bertambah").

## `List.unmodifiable` vs `UnmodifiableListView` — Snapshot vs View

Ini pola yang sama seperti `UnmodifiableSetView` yang sudah kamu kenal — cuma versi List-nya. Bedanya krusial:

```dart
import 'dart:collection';

void main() {
  var asli = [1, 2, 3];

  // SNAPSHOT: salinan independen, perubahan pada `asli` TIDAK terlihat di sini
  var snapshot = List.unmodifiable(asli);
  asli.add(4);
  print(snapshot); // [1, 2, 3] — tetap, tidak ikut berubah

  // VIEW: jendela hidup ke `asli`, perubahan pada `asli` LANGSUNG terlihat di sini
  var view = UnmodifiableListView(asli);
  asli.add(5);
  print(view); // [1, 2, 3, 4, 5] — ikut berubah, karena cuma "kaca jendela"

  // Keduanya sama-sama menolak modifikasi lewat dirinya sendiri:
  // view.add(6); // ERROR runtime: UnsupportedError
}
```

Pilih **snapshot** (`List.unmodifiable`) saat kamu ingin memutus hubungan total dengan sumber data. Pilih **view** (`UnmodifiableListView`) saat kamu ingin mengekspos data internal secara read-only tapi tetap sinkron — pola umum untuk enkapsulasi: field privat yang mutable di dalam, getter publik yang immutable di luar.

Sumber: [List.unmodifiable — api.dart.dev](https://api.dart.dev/dart-core/List/List.unmodifiable.html), [UnmodifiableListView — api.dart.dev](https://api.dart.dev/dart-collection/UnmodifiableListView-class.html)

## Operasi CRUD

```dart
var buah = ['apel', 'jeruk'];

// Create/tambah
buah.add('mangga');                    // ['apel', 'jeruk', 'mangga']
buah.addAll(['pisang', 'anggur']);     // tambah banyak sekaligus
buah.insert(1, 'nanas');               // sisip di index tertentu
buah.insertAll(0, ['durian', 'salak']); // sisip banyak di index tertentu

// Read/cari
print(buah.indexOf('jeruk'));          // posisi pertama ditemukan, -1 kalau tidak ada
print(buah.lastIndexOf('jeruk'));      // posisi terakhir ditemukan
print(buah.contains('mangga'));        // true/false

// Update
buah[0] = 'kelengkeng';                // ganti berdasarkan index

// Delete
buah.remove('mangga');                 // hapus KEMUNCULAN PERTAMA yang cocok
buah.removeAt(0);                      // hapus berdasarkan index
buah.removeLast();                     // hapus elemen terakhir — O(1)
buah.removeWhere((b) => b.length > 6); // hapus semua yang cocok kondisi
buah.retainWhere((b) => b.length > 6); // kebalikan removeWhere: SIMPAN yang cocok
buah.clear();                          // kosongkan total
```

## Sorting

```dart
var angka = [5, 2, 8, 1, 9];
angka.sort(); // ascending, mengurutkan IN-PLACE (mengubah list asal)
print(angka); // [1, 2, 5, 8, 9]

// Comparator kustom: descending
angka.sort((a, b) => b.compareTo(a));
print(angka); // [9, 8, 5, 2, 1]

// Sorting object kustom — dua cara
class Pegawai {
  final String nama;
  final int gaji;
  Pegawai(this.nama, this.gaji);
  @override
  String toString() => '$nama:$gaji';
}

var pegawai = [Pegawai('Budi', 5000000), Pegawai('Ani', 7000000)];

// Cara 1: comparator eksplisit di sort()
pegawai.sort((a, b) => a.gaji.compareTo(b.gaji));

// Cara 2: implementasikan Comparable<Pegawai> di class-nya sendiri,
// baru bisa panggil pegawai.sort() tanpa argumen
```

## `sublist` dan Spread

```dart
var asal = [0, 1, 2, 3, 4, 5];
print(asal.sublist(2));      // [2, 3, 4, 5] — dari index 2 sampai akhir
print(asal.sublist(2, 4));   // [2, 3] — dari index 2 sampai SEBELUM index 4

// Spread operator untuk menyusun list baru dari list lain
var gabungan = [-1, ...asal, 99];
print(gabungan); // [-1, 0, 1, 2, 3, 4, 5, 99]

// Null-aware spread: aman kalau sumbernya null
List<int>? mungkinNull;
var aman = [0, ...?mungkinNull, 1]; // [0, 1] — tidak error walau mungkinNull == null
```

## List Multi-Dimensi

```dart
// Matriks 3x3, cara paling aman: List.generate per baris (hindari alias antar baris)
var matriks = List.generate(3, (_) => List.filled(3, 0));
matriks[1][2] = 7;
print(matriks); // [[0, 0, 0], [0, 0, 7], [0, 0, 0]]
```

**Perangkap umum**: `List.filled(3, List.filled(3, 0))` akan membuat 3 baris yang **semuanya menunjuk ke objek List yang sama** (aliasing) — mengubah satu baris mengubah semuanya. Selalu pakai `List.generate` untuk struktur bersarang agar tiap baris jadi objek independen.

## Karakteristik Performa (Big-O)

| Operasi | Kompleksitas | Kenapa |
|---|---|---|
| Akses via index (`list[i]`) | O(1) | Array-backed, alamat memori dihitung langsung |
| `add()` di akhir | O(1) amortized | Kadang perlu realokasi buffer, tapi rata-rata konstan |
| `insert()`/`remove()` di tengah/awal | O(n) | Elemen setelahnya harus digeser |
| `removeLast()` | O(1) | Tidak perlu geser apa pun |
| `contains()`/`indexOf()` | O(n) | Harus cek satu-satu, tidak ada struktur pencarian cepat |
| `length` | O(1) | Disimpan sebagai properti, bukan dihitung ulang |

**Implikasi praktis**: kalau kamu sering `removeAt(0)` atau `insert(0, ...)` dalam loop besar, itu sinyal kuat kamu butuh `Queue` (lihat file `05`), bukan `List`.

## Perangkap Umum

```dart
// 1. ConcurrentModificationError — memodifikasi list SAAT sedang di-iterate
var angka = [1, 2, 3, 4];
for (var n in angka) {
  if (n == 2) angka.remove(n); // ERROR saat runtime
}
// Solusi: iterate salinannya, atau pakai removeWhere
angka.removeWhere((n) => n == 2); // aman

// 2. Fixed-length list tidak bisa nambah elemen
var tetap = List.filled(2, 0);
// tetap.add(1); // ERROR: UnsupportedError
```

## Refleksi Sebelum Lanjut

- Kapan kamu memilih `List.unmodifiable` dibanding `UnmodifiableListView`?
- Kenapa `List.filled(3, List.filled(3, 0))` adalah jebakan, sementara `List.generate(3, (_) => List.filled(3, 0))` aman?
- Operasi List apa yang membuatmu harus mempertimbangkan `Queue` sebagai gantinya?

Lanjut ke [03-set.md][1].

[1]: ./03-set.md
