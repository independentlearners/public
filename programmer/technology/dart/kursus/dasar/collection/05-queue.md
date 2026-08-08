# 05 — Queue

## Apa Itu

`Queue<E>` (dari `dart:collection`, bukan `dart:core`) adalah `Iterable<E>` yang dioptimalkan untuk operasi di **kedua ujung** koleksi: tambah/hapus di depan atau di belakang, keduanya efisien. Ini beda mendasar dari List, yang cuma efisien di satu ujung (akhir).

```dart
import 'dart:collection';
```

Sumber: [Queue class — api.dart.dev](https://api.dart.dev/dart-collection/Queue-class.html)

## Dua Implementasi Konkret

| Implementasi | Struktur internal | Kapan dipakai |
|---|---|---|
| `ListQueue` | Circular buffer (array melingkar) | **Default** untuk `Queue()` — pilihan default yang tepat untuk hampir semua kasus |
| `DoubleLinkedQueue` | Linked list dua arah | Kasus khusus, locality memori kurang penting dibanding fleksibilitas struktur |

Terverifikasi langsung dari dokumentasi resmi (contoh di halaman `Queue`): `Queue<int>()` menghasilkan instance `ListQueue` secara default.

```dart
import 'dart:collection';

void main() {
  var antrean = Queue<int>(); // ListQueue secara default
  print(antrean.runtimeType); // ListQueue<int>

  antrean.addLast(1);
  antrean.addLast(2);
  antrean.addFirst(0);
  print(antrean); // {0, 1, 2}

  print(antrean.removeFirst()); // 0 — FIFO: yang masuk duluan, keluar duluan
  print(antrean.removeLast());  // 2 — juga bisa dipakai sebagai stack (LIFO) dari sisi lain
  print(antrean);                // {1}
}
```

`ListQueue` disebut sebagai "cyclic buffer" di dokumentasi resminya — menjamin operasi *peek* dan *remove* dalam waktu konstan, serta *add* dalam waktu amortized konstan. Cocok dipakai baik sebagai queue maupun stack.

```dart
import 'dart:collection';

void main() {
  var dq = DoubleLinkedQueue<String>();
  dq.addLast('tengah');
  dq.addFirst('awal');
  dq.addLast('akhir');
  print(dq); // {awal, tengah, akhir}
}
```

Sumber: [ListQueue — api.dart.dev](https://api.dart.dev/dart-collection/ListQueue-class.html), [DoubleLinkedQueue — api.dart.dev](https://api.dart.dev/dart-collection/DoubleLinkedQueue-class.html)

## Kenapa Bukan List Saja?

```dart
var list = <int>[1, 2, 3, 4, 5];
list.removeAt(0); // O(n) — SEMUA elemen sisanya harus digeser satu posisi ke kiri
list.insert(0, 0); // O(n) — sama, semua elemen harus digeser ke kanan dulu
```

Dibanding:

```dart
var queue = Queue<int>()..addAll([1, 2, 3, 4, 5]);
queue.removeFirst(); // O(1) — tidak ada penggeseran sama sekali
queue.addFirst(0);   // O(1) amortized
```

Kalau polamu adalah "sering-sering menambah/menghapus di awal," itu sinyal kuat kamu salah pilih struktur kalau masih pakai List.

## Contoh Praktik: BFS (Breadth-First Search)

Queue adalah tulang punggung algoritma BFS — ini contoh nyata kenapa struktur data yang tepat penting, bukan sekadar teori:

```dart
import 'dart:collection';

Map<String, List<String>> graf = {
  'A': ['B', 'C'],
  'B': ['A', 'D'],
  'C': ['A', 'D'],
  'D': ['B', 'C', 'E'],
  'E': ['D'],
};

List<String> bfs(String mulai) {
  var dikunjungi = <String>{mulai};
  var urutan = <String>[];
  var antrean = Queue<String>()..add(mulai);

  while (antrean.isNotEmpty) {
    var simpul = antrean.removeFirst();
    urutan.add(simpul);
    for (var tetangga in graf[simpul] ?? []) {
      if (dikunjungi.add(tetangga)) { // add() mengembalikan false kalau sudah ada
        antrean.add(tetangga);
      }
    }
  }
  return urutan;
}

void main() {
  print(bfs('A')); // [A, B, C, D, E]
}
```

Perhatikan trik kecil: `dikunjungi.add(tetangga)` dipakai langsung sebagai kondisi `if` — `Set.add()` mengembalikan `bool` (`true` kalau elemen baru ditambahkan, `false` kalau sudah ada sebelumnya). Ini menggabungkan "cek dan tandai" jadi satu operasi atomik, pola yang umum dipakai di algoritma graf.

## Perbandingan Performa Dua Implementasi

| Operasi | `ListQueue` | `DoubleLinkedQueue` |
|---|---|---|
| `addFirst`/`addLast` | O(1) amortized | O(1) |
| `removeFirst`/`removeLast` | O(1) | O(1) |
| `elementAt(i)` (akses tengah) | O(1) | O(n) |
| Locality memori (cache-friendly) | Baik — data bersebelahan | Kurang — tiap elemen node terpisah |

**Rekomendasi praktis**: pakai `ListQueue` (default) kecuali kamu punya alasan spesifik untuk `DoubleLinkedQueue`. Untuk sebagian besar kasus FIFO/deque umum, `ListQueue` lebih unggul dari sisi performa dan locality memori.

## Refleksi Sebelum Lanjut

- Kenapa `queue.removeFirst()` bisa O(1) padahal secara konsep elemen lain "harus geser posisi"? (petunjuk: circular buffer tidak benar-benar menggeser data secara fisik)
- Pada BFS di atas, apa yang terjadi kalau kamu ganti `Queue` dengan `List` biasa dan pakai `removeAt(0)`? Kapan bedanya baru terasa signifikan?
- Kapan kamu akan memilih `DoubleLinkedQueue` dibanding `ListQueue`?

Lanjut ke [06-membuat-collection-kustom.md][1].

[1]: ./06-membuat-collection-kustom.md
