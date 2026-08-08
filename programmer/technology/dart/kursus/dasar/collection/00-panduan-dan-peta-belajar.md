# Peta Belajar: Collection di Dart — Dari Dasar hingga Mahir

> Dokumentasi ini dipecah jadi beberapa file supaya enak di-commit sebagai catatan belajar di repo kamu, dan enak di-scan satu per satu tanpa harus scroll dokumen raksasa.

## Cara Pakai Dokumen Ini

Dua jenis konten di sini punya perlakuan berbeda, dan ini disengaja:

| Jenis file | Isi | Kode di dalamnya |
|---|---|---|
| `01`–`07` | Referensi konsep: apa itu, kapan dipakai, bagaimana cara pakai, kenapa dirancang begitu | Kode kerja penuh — setara dokumentasi resmi, bukan jawaban soal |
| `08` | Tutorial mental progresif | **Tanpa kunci jawaban.** Cuma tantangan, kriteria selesai, dan petunjuk |

Alasannya sederhana: baca API List/Set/Map/Queue dari dokumentasi (termasuk dari sini) itu berbeda dengan menyelesaikan soal. Yang pertama adalah *input* — sah-sah saja langsung dibaca lengkap, sama seperti kamu baca api.dart.dev. Yang kedua adalah *output* — kalau saya isi lengkap, proses rekonstruksi logikanya lewat, dan itu justru bagian paling berharga dari belajar struktur data.

**Alur yang disarankan:** baca konsep di file referensi → tutup file → coba tulis ulang dari memori di editor kamu → jalankan → baru cocokkan. Kalau meleset, itu bagus — di situlah pembelajaran sebenarnya terjadi (*desirable difficulty*, bukan gangguan yang harus dihindari).

## Daftar Isi

1. `01-iterable-dan-iterator.md` — Fondasi semua collection: apa itu Iterable/Iterator, lazy vs eager, generator
2. `02-list.md` — List: growable/fixed-length, operasi, performa
3. `03-set.md` — Set: HashSet, LinkedHashSet, SplayTreeSet, operasi himpunan
4. `04-map.md` — Map: HashMap, LinkedHashMap, SplayTreeMap, MapEntry
5. `05-queue.md` — Queue: ListQueue, DoubleLinkedQueue, FIFO/deque
6. `06-membuat-collection-kustom.md` — Best practice bikin collection sendiri (ListBase, SetBase, MapBase, IterableBase)
7. `07-fitur-bahasa-dan-package-collection.md` — Spread, collection-if/for, generics, `package:collection`, tabel Big-O
8. `08-tutorial-mental-progresif.md` — 5 level latihan dari dasar sampai mahir, tanpa kunci jawaban

## Peta Hierarki Collection di Dart

Ini gambaran besar yang perlu ada di kepala kamu sebelum masuk detail. Semua collection utama punya satu leluhur yang sama: `Iterable<E>`.

```
Iterable<E>  ─── fondasi abstrak (dart:core)
│  Kontrak: punya getter `iterator` yang mengembalikan Iterator<E>
│
├── List<E>                    berurutan, terindeks, boleh duplikat
│     growable (default) atau fixed-length (List.filled tanpa growable:true)
│
├── Set<E>                     unik, tanpa duplikat
│     ├── LinkedHashSet<E>     ← default untuk `{}` dan `Set()` — urutan insersi
│     ├── HashSet<E>           dart:collection — tanpa jaminan urutan, avg O(1)
│     └── SplayTreeSet<E>      dart:collection — selalu terurut, O(log n)
│
└── Queue<E>                   dart:collection — FIFO / deque
      ├── ListQueue<E>         ← default untuk `Queue()` — circular buffer
      └── DoubleLinkedQueue<E> berbasis linked list

Map<K, V>  ─── TIDAK langsung Iterable<V>, tapi .keys/.values/.entries
│              masing-masing mengembalikan Iterable
│
├── LinkedHashMap<K, V>        ← default untuk `{}` dan `Map()` — urutan insersi
├── HashMap<K, V>               dart:collection — tanpa jaminan urutan
└── SplayTreeMap<K, V>          dart:collection — terurut berdasarkan key
```

**Fakta yang sering salah dikira orang** (termasuk beberapa mirror dokumentasi tidak resmi di internet): literal `{}` dan konstruktor tanpa nama `Set()`/`Map()` itu defaultnya **`LinkedHashSet`/`LinkedHashMap`** (insertion-ordered), **bukan** `HashSet`/`HashMap`. Ini terkonfirmasi langsung dari `api.dart.dev` — kalau kamu baca sumber pihak ketiga yang bilang sebaliknya, sumber itu keliru. Detail lengkap ada di file `03` dan `04`.

## Sumber Utama yang Dipakai di Seluruh Dokumen

- Dart API Reference: [api.dart.dev](https://api.dart.dev/) — dokumentasi kelas yang dihasilkan langsung dari source code SDK
- Language Tour — Collections: [dart.dev/language/collections](https://dart.dev/language/collections)
- Tutorial interaktif Iterable (dengan DartPad + hint/solution): [dart.dev/libraries/collections/iterables](https://dart.dev/libraries/collections/iterables)
- Overview `dart:core`: [dart.dev/libraries/dart-core](https://dart.dev/libraries/dart-core)
- Package tambahan resmi: [pub.dev/packages/collection](https://pub.dev/packages/collection)

Dokumentasi ini merefleksikan Dart 3.12.x (rilis stabil terbaru per Mei 2026). Konsep intinya sudah stabil sejak era null-safety (Dart 2.12+), jadi tetap relevan untuk versi-versi berikutnya.

## Template Pernyataan Tujuan (pakai sebelum mulai tiap level di file 08)

Sebelum masuk ke level baru, tulis 1–2 kalimat di catatanmu sendiri:

> Yang ingin saya pahami di level ini: ______________
> Saya tahu sudah paham kalau saya bisa: ______________

Ini memisahkan "belajar syntax" dari "mikir seperti engineer" — dua mode berpikir yang beda dan gampang tercampur kalau tidak dipisah secara sadar.

---

Lanjut ke [01-iterable-dan-iterator.md][1] untuk mulai dari fondasi.

[1]: ./01-iterable-dan-iterator.md
