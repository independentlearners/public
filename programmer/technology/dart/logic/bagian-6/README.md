# Membangun Logika Dart — Fase 6: Logika Efisiensi

*Dari kode yang terasa cepat menjadi kode yang terbukti cepat: model biaya, pengukuran yang jujur, struktur data yang tepat, dan penghematan sumber daya yang terukur.*

| Atribut | Keterangan |
| --- | --- |
| Level | Advanced |
| Estimasi waktu | 3–4 minggu, ±40–50 jam (teori ±30%, praktik ±70%) |
| Prasyarat | Fase 5 selesai (daftar periksa kelulusan terpenuhi, latihan di-commit) |
| Alat esensial | Dart SDK stabil (per 15 November 2026: **3.14**), `dart:collection`, `dart:typed_data`, `package:collection`, `package:benchmark_harness`, `dart compile exe`, DevTools |
| Batas versi fitur | Generator `sync*`: semua Dart 2+ · record dan pola: ≥ 3.0 · `Iterable.nonNulls`: ≥ 3.0 |
| Komunitas | https://dart.dev/community · tag `dart` di https://stackoverflow.com/questions/tagged/dart · proposal bahasa di https://github.com/dart-lang/language |
| Sertifikasi | Tidak ada sertifikasi resmi khusus; portofolio berisi benchmark yang dapat diulang dan analisis hasilnya lebih bernilai |

**Hasil pembelajaran Fase 6** — setelah fase ini kamu mampu:

1. menganalisis biaya waktu dan ruang sebuah fungsi dengan notasi Big-O, termasuk biaya amortisasi dan kuadratik tersembunyi;
2. mengukur dengan benar (pemanasan, median, anti-eliminasi kode mati, JIT vs AOT) dan membaca profil sebelum mengoptimalkan;
3. memilih struktur data (`List`, `Set`, `Map`, `Queue`, `PriorityQueue`, data bertipe) berdasarkan operasi yang dominan;
4. memakai evaluasi malas, generator, dan pembangunan data yang hemat alokasi;
5. menerapkan memoization berbatas dan teknik algoritmik (hashing, prefix sum, rolling state) dengan trade-off waktu-ruang yang sadar;
6. mengidentifikasi biaya tersembunyi (I/O, startup, footprint) dan membuktikan perbaikan dengan benchmark yang adil.

---

## Daftar Isi Fase 6

<details>
  <summary>📃 Daftar Isi</summary>

- **0. Audit Kurikulum & Sambungan dari Fase 5**
- **6.1 Model Biaya & Big-O Praktis**
- **6.2 Mengukur dengan Benar:** benchmark dan profiling
- **6.3 Memilih Struktur Data**
- **6.4 Iterable Malas, Alokasi, dan Pembangunan Data**
- **6.5 Memoization, Caching, dan Teknik Algoritmik**
- **6.6 Biaya Tersembunyi: I/O, Startup, dan Footprint** *(TAMBAHAN)*
- **6.7 Studi Kasus Terpadu: To-Do v5** *(TAMBAHAN)*
- **Latihan (tanpa kunci jawaban), Ringkasan, dan Referensi Induk**

</details>

---

## 0. Audit Kurikulum & Sambungan dari Fase 5

1. **Sambungan.** Fase 3.2 dan 3.4 sudah menyebut biaya salinan (O(n)) vs view (O(1)); 4.2 menyebut cache memoize yang perlu dibatasi; 5.6 membahas retry yang mengalikan beban. Fase 6 mengubah *terasa cepat* menjadi *terukur dan terbukti*.
2. **Temuan audit.** Kurikulum lazim menyajikan Big-O sebagai tabel hafalan tanpa mengukur, sehingga pembelajar tak tahu kapan konstanta mengalahkan pertumbuhan asimtotik dan tak tahu cara mengukur dengan benar. Maka modul **6.2** (pengukuran, JIT/AOT, eliminasi kode mati) diberi bobot sama dengan teori.
3. **TAMBAHAN:** 6.6 (biaya tersembunyi: I/O, startup, footprint) dan 6.7 (studi kasus To-Do v5 dengan benchmark dan tes kesetaraan).
4. **Fakta yang diverifikasi saat penyusunan.** (a) `List.sort` **tidak dijamin stabil** (objek yang setara boleh muncul dalam urutan apa pun); untuk pengurutan stabil, `IterableExtension.sortedBy` di `package:collection` memakai algoritma stabil sejak versi 1.17.0. (b) `package:benchmark_harness` menyediakan `BenchmarkBase` dengan `setup`, `warmup`, `exercise`, `teardown`, dan `report`; pemanasan minimal sekitar 100 ms dan pengukuran minimal sekitar 2000 ms. (c) Untuk aplikasi baris perintah, DevTools selalu menyediakan debugger dan logging; fitur timeline/memori/performa memerlukan *timeline streams* pada VM. (d) `package:collection` menyediakan `lowerBound`, `binarySearch`, `QueueList`, `BoolList`, dan `PriorityQueue`.
5. **Ditunda secara sadar:** kecepatan lewat konkurensi (isolate) → Fase 7; performa JavaScript/WebAssembly di luar cakupan.
6. **Janji dari Fase 1.6.** `cariPasangan` berbiaya O(n²); modul 6.5 menyajikan versi O(n) dan memperlihatkan bahwa spesifikasi harus menentukan *pasangan mana* yang dikembalikan bila ada banyak jawaban.
7. **Tidak ada koreksi substansial** pada materi Fase 1–5.

> **Cara memakai dokumen ini** tetap sama: baca, tulis ulang dari ingatan, jalankan, bandingkan. Latihan di akhir tanpa kunci jawaban.

---

## 6.1 Model Biaya & Big-O Praktis

*Motivasi: kecepatan yang tak bisa dijelaskan hanyalah keberuntungan yang menunggu data bertambah.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membangun **model biaya**: menghitung berapa banyak langkah dasar yang dilakukan sebuah fungsi sebagai fungsi dari ukuran masukan *n*, dan menyatakannya dengan notasi Big-O. Kamu belajar membedakan kasus terbaik, rata-rata, dan terburuk, memahami biaya **amortisasi**, mengenali **kuadratik tersembunyi**, dan menghitung operasi secara deterministik (bukan waktu) agar bukti pertumbuhan tidak bergantung pada mesin.

### B. Konsep Kunci & Filosofi Mendalam

- **Tiga jenis biaya.** *Waktu* (jumlah langkah), *ruang* (memori tambahan), dan *biaya tersembunyi* (I/O, alokasi, GC; modul 6.6).
- **Ukuran masukan *n*.** Biaya dinyatakan sebagai fungsi *n*: banyaknya elemen, panjang string, atau ukuran data yang relevan. Tentukan dulu *n* itu apa.
- **Big-O (informal).** Mengabaikan konstanta dan suku yang lebih kecil untuk menyatakan *laju pertumbuhan batas atas*. `3n + 7` adalah O(n); `n² + 100n` adalah O(n²). Θ menyatakan batas ketat; Ω batas bawah.
- **Hierarki pertumbuhan:** O(1) < O(log n) < O(n) < O(n log n) < O(n²) < O(n³) < O(2ⁿ) < O(n!). Intuisi: bila *n* digandakan, O(n) naik 2×, O(n²) naik 4×, O(log n) hanya bertambah satu langkah.
- **Terbaik / rata-rata / terburuk.** Kontrak waktu yang dapat diandalkan memakai kasus terburuk. Tabel hash memberi O(1) *rata-rata* tetapi O(n) pada kasus terburuk (banyak tabrakan).
- **Amortisasi.** `List.add` adalah O(1) *teramortisasi*: kadang menyalin seluruh isi saat kapasitas penuh, tetapi total *n* penambahan tetap O(n) karena kapasitas bertambah kali lipat.
- **Menganalisis kode.** Satu loop atas *n* elemen: O(n). Loop bersarang: O(n·m). Loop yang menyempitkan ruang pencarian separuh tiap langkah: O(log n). **Operasi O(n) di dalam loop adalah kuadratik tersembunyi** (mis. `list.contains` di dalam `for`).
- **Konstanta tetap penting.** Pada *n* kecil, algoritma O(n²) berkonstanta kecil dapat mengalahkan O(n log n) berkonstanta besar. Big-O memberi *arah*, pengukuran (6.2) memberi *jawaban*.
- **Ruang vs waktu.** Banyak percepatan menukar memori dengan waktu (tabel pencarian, cache). Tulis kedua biayanya.
- **Filosofi:** pilih *algoritma dan struktur data* yang benar dulu; mikro-optimasi menyusul, dan hanya bila terukur perlu. "Optimasi prematur" bukan larangan mengoptimalkan, melainkan larangan menebak.
- **Dampak desain:** masalah kompleksitas tidak terlihat pada data uji kecil dan baru meledak pada data produksi; analisis dan uji skala sejak awal mencegahnya.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — menghitung operasi (bukan waktu): linear vs biner.**

```dart
class Hitung {
  int perbandingan = 0;
}

int? cariLinear(List<int> data, int target, Hitung h) {
  for (var i = 0; i < data.length; i++) {
    h.perbandingan++;
    if (data[i] == target) return i;
  }
  return null;
}

int? cariBiner(List<int> data, int target, Hitung h) {
  var lo = 0;
  var hi = data.length - 1;
  while (lo <= hi) {
    final mid = lo + (hi - lo) ~/ 2;
    h.perbandingan++;
    if (data[mid] == target) return mid;
    if (data[mid] < target) {
      lo = mid + 1;
    } else {
      hi = mid - 1;
    }
  }
  return null;
}

void main() {
  for (final n in [1000, 2000, 4000, 8000]) {
    final data = List<int>.generate(n, (i) => i * 2); // terurut
    final a = Hitung();
    final b = Hitung();
    cariLinear(data, -1, a); // kasus terburuk: target tidak ada
    cariBiner(data, -1, b);
    print('n=$n linear=${a.perbandingan} biner=${b.perbandingan}');
  }
}
```

```text
n=1000 linear=1000 biner=9
n=2000 linear=2000 biner=10
n=4000 linear=4000 biner=11
n=8000 linear=8000 biner=12
```

- Menghitung perbandingan membuat bukti *deterministik*: hasilnya sama di mesin mana pun.
- Linear naik sebanding *n* (menggandakan *n* menggandakan langkah); biner hanya bertambah satu tiap *n* digandakan — pertumbuhan logaritmik.
- `mid = lo + (hi - lo) ~/ 2` menghindari overflow pada bahasa berbilangan tetap dan tetap benar di sini; tulis dengan sengaja.
- Pencarian biner mensyaratkan data **terurut** (precondition, modul 1.5).

**Contoh 2 — amortisasi: mengapa `add` terasa O(1).**

```dart
/// Simulasi larik dinamis yang menggandakan kapasitas saat penuh.
int hitungSalinan(int n) {
  var kapasitas = 1;
  var ukuran = 0;
  var salinan = 0;
  for (var i = 0; i < n; i++) {
    if (ukuran == kapasitas) {
      salinan += ukuran; // menyalin semua elemen ke larik baru
      kapasitas *= 2;
    }
    ukuran++;
  }
  return salinan;
}

void main() {
  assert(hitungSalinan(1000) < 2 * 1000); // total salinan kurang dari 2n
  assert(hitungSalinan(1000000) < 2 * 1000000);
}
```

- Salinan hanya terjadi pada ukuran 1, 2, 4, 8, ... — jumlahnya selalu kurang dari 2·*n*. Maka rata-rata biaya per `add` adalah konstan: O(1) teramortisasi.
- Ini model *sederhana*; implementasi nyata mungkin memakai faktor pertumbuhan lain, tetapi kesimpulan amortisasinya sama.

**Contoh 3 — kuadratik tersembunyi.**

```dart
// Tampak satu ekspresi, tetapi b.contains adalah O(m): total O(n * m).
List<int> irisanLambat(List<int> a, List<int> b) => a.where(b.contains).toList();

// Set.contains rata-rata O(1): total O(n + m).
List<int> irisanCepat(List<int> a, List<int> b) {
  final s = b.toSet();
  return a.where(s.contains).toList();
}

void main() {
  assert(irisanLambat([1, 2, 3, 4], [3, 4, 5]).toString() == '[3, 4]');
  assert(irisanCepat([1, 2, 3, 4], [3, 4, 5]).toString() == '[3, 4]');
}
```

- `a.where(b.contains)` terbaca seperti satu operasi, tetapi `contains` pada `List` memindai seluruh `b` untuk tiap elemen `a`.
- `b.toSet()` membayar O(m) sekali di muka, lalu tiap pencarian O(1) rata-rata — menukar memori tambahan dengan waktu.
- Kedua fungsi menghasilkan jawaban sama; yang berbeda hanya cara pertumbuhannya (modul 6.2 mengukur selisihnya).

### D. Opsi Kode Lain untuk Logika yang Sama

| Pola kode | Biaya | Catatan |
| --- | --- | --- |
| Satu loop atas *n* | O(n) | Dasar |
| Dua loop bersarang atas *n* | O(n²) | Sering tak terlihat bila salah satunya `contains`, `indexOf`, atau `remove` |
| Loop yang membagi dua | O(log n) | Pencarian biner, pohon seimbang |
| Urutkan lalu pindai | O(n log n) | Sering mengalahkan O(n²) |
| Tabel hash (`Set`/`Map`) | O(n) total, O(1) rata-rata per operasi | Memori tambahan O(n) |

| Pertumbuhan | n = 10 | n = 100 | n = 1000 |
| --- | --- | --- | --- |
| O(log n) | 3 | 7 | 10 |
| O(n) | 10 | 100 | 1.000 |
| O(n log n) | 33 | 664 | 9.966 |
| O(n²) | 100 | 10.000 | 1.000.000 |
| O(2ⁿ) | 1.024 | ≈ 10³⁰ | tak terbayangkan |

### E. Terminologi Esensial

- **Big-O / Θ / Ω** — batas atas / ketat / bawah laju pertumbuhan. **Kompleksitas waktu / ruang** — biaya langkah / memori tambahan.
- **Amortisasi** — biaya rata-rata per operasi pada rangkaian operasi, walau sebagian operasi mahal. **Kasus terburuk / rata-rata** — batas jaminan / perilaku tipikal.
- **Kuadratik tersembunyi** — operasi O(n) di dalam loop yang tampak O(n). **Laju pertumbuhan** — bagaimana biaya naik saat *n* naik.

### F. Visualisasi (ASCII)

```text
 biaya
  ▲
  │                                          ╱  O(n²)
  │                                      ╱
  │                               ╱ ─ ─  O(n log n)
  │                         ╱ ─ ─
  │                   ╱ ─ ─                  O(n)
  │            ╱ ─ ─
  │   ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  O(log n) ≈ hampir datar
  └─────────────────────────────────────────────────► n
```

```text
 for (final x in a) {          ← n kali
   if (b.contains(x)) ...      ← O(m) tiap kali   =>  O(n * m)   (tersembunyi di satu baris)
 }

 final s = b.toSet();          ← O(m) sekali
 for (final x in a) {          ← n kali
   if (s.contains(x)) ...      ← O(1) rata-rata  =>  O(n + m)
 }
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 1.6 (loop dan invarian), 3.4 (biaya view vs snapshot), 4.2 (closure dan memoization).
- **Prasyarat bagi:** 6.2–6.7. **Dikembangkan di:** Fase 7 (biaya konkurensi dan batas paralelisme), Fase 9 (serangan kompleksitas algoritmik: masukan yang memicu kasus terburuk), Fase 10 (uji skala dan benchmark otomatis).

### H. Tips & Praktik Terbaik

- Sebelum menulis loop, tulis dalam komentar: *n itu apa, dan berapa biaya tiap iterasi?*
- Waspadai `contains`, `indexOf`, `remove`, `insert(0, ...)`, dan `length` pada Iterable malas di dalam loop.
- Hitung operasi (bukan waktu) untuk bukti pertumbuhan yang deterministik; pakai waktu untuk keputusan praktis (6.2).
- Catat biaya ruang bersama biaya waktu setiap kali memakai tabel atau cache.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| `contains` pada `List` di dalam loop | Lambat bila data tumbuh | Ubah ke `Set` di muka |
| Menyimpulkan efisiensi dari data uji kecil | Aman di uji, lambat di produksi | Uji pada beberapa ukuran *n* dan lihat pertumbuhannya |
| Mengabaikan konstanta sama sekali | Algoritma "lebih baik" justru lebih lambat di *n* kecil | Ukur pada ukuran data nyata |
| Mengira hash selalu O(1) | Lambat saat banyak tabrakan atau kunci buruk | Pastikan `hashCode` baik (3.1) |
| Mengoptimalkan tanpa tahu bagian terpanas | Usaha besar, hasil kecil | Ukur dan profil dulu (6.2) |

### J. Sumber Referensi

- API `List`: https://api.dart.dev/stable/dart-core/List-class.html · `Set`: https://api.dart.dev/stable/dart-core/Set-class.html · `Map`: https://api.dart.dev/stable/dart-core/Map-class.html
- ✔ Changelog `package:collection` (`lowerBound`, `binarySearch`, `BoolList`, `PriorityQueue`): https://pub.dev/packages/collection/changelog
- Big-O notation: https://en.wikipedia.org/wiki/Big\_O\_notation · Amortized analysis: https://en.wikipedia.org/wiki/Amortized\_analysis · Big-O Cheat Sheet: https://www.bigocheatsheet.com/
- Donald Knuth, *Structured Programming with go to Statements* (konteks "optimasi prematur"): https://dl.acm.org/doi/10.1145/356635.356640

---

## 6.2 Mengukur dengan Benar: Benchmark dan Profiling

*Motivasi: intuisi tentang kecepatan hampir selalu salah di tempat yang paling kamu yakini.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini mengajarkan cara mengukur yang jujur: **benchmark** (membandingkan dua implementasi pada beban yang terkontrol) dan **profiling** (menemukan bagian program yang sungguh memakan waktu). Kamu memakai `Stopwatch`, menulis harness mini dengan pemanasan dan median, memakai `package:benchmark_harness`, memahami jebakan JIT vs AOT dan *dead code elimination*, serta tahu pintu masuk DevTools untuk aplikasi baris perintah.

### B. Konsep Kunci & Filosofi Mendalam

- **Ukur dulu, optimasi kemudian.** Profil menunjukkan bagian terpanas; mengoptimalkan bagian yang hanya 2% dari waktu tak akan mengubah apa pun (hukum Amdahl).
- **Pemanasan (warmup).** Pada eksekusi JIT, beberapa iterasi pertama lebih lambat karena kode belum dioptimalkan; abaikan hasilnya. `benchmark_harness` memanaskan sekitar 100 ms lalu mengukur minimal sekitar 2000 ms.
- **Median, bukan satu angka.** Waktu fluktuatif karena penjadwal OS, GC, dan cache. Ambil banyak sampel dan laporkan **median** (dan sebaran), bukan hasil satu kali jalan.
- **Cegah eliminasi kode mati.** Kompilator boleh membuang perhitungan yang hasilnya tak dipakai. Selalu *gunakan* hasilnya (mis. mengakumulasi ke variabel yang kemudian dicetak) agar pekerjaan benar-benar dilakukan.
- **Noise dari harness.** Memanggil `Stopwatch` terlalu sering atau melalui dispatch virtual di loop sempit menambah derau; untuk pekerjaan sangat kecil, ulangi pekerjaan itu banyak kali di dalam satu pengukuran.
- **JIT vs AOT.** `dart run` memakai JIT (cepat mulai, dioptimalkan saat jalan); `dart compile exe` menghasilkan biner AOT yang lebih mendekati produksi. Ukur di mode yang akan dipakai, dan **jangan** mengukur dengan `--enable-asserts` aktif.
- **Ukuran data nyata.** Benchmark pada data kecil menyesatkan; ukur pada ukuran yang realistis dan pada beberapa ukuran untuk melihat pertumbuhan (6.1).
- **Bandingkan relatif, bukan absolut.** Angka mikrodetik hanya bermakna di mesin dan konfigurasi yang sama; bandingkan dua implementasi di sesi yang sama.
- **Profiling.** `dart run --observe` menjalankan program dengan layanan VM yang dapat dihubungkan DevTools. Untuk aplikasi baris perintah, debugger dan logging selalu tersedia; untuk melihat timeline, memori, dan performa, VM perlu menyalakan *timeline streams* (mis. `--timeline_streams=VM,Isolate,GC`) — periksa dokumentasi DevTools untuk fitur yang tersedia pada tipe aplikasimu.
- **Filosofi:** angka tanpa metode adalah opini; metode tanpa angka adalah tebakan.
- **Dampak desain:** hasil yang bisa diulang dan dijelaskan membuat keputusan optimasi dapat dipertahankan saat review dan saat data berubah.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — harness mini dengan pemanasan dan median.**

```dart
double median(List<double> xs) {
  final s = [...xs]..sort();
  final mid = s.length ~/ 2;
  return s.length.isOdd ? s[mid] : (s[mid - 1] + s[mid]) / 2;
}

/// Median mikrodetik per eksekusi [kerja].
double ukur(
  void Function() kerja, {
  int pemanasan = 3,
  int sampel = 11,
  int ulangi = 1,
}) {
  for (var i = 0; i < pemanasan; i++) {
    kerja(); // hasil pemanasan dibuang
  }
  final hasil = <double>[];
  final jam = Stopwatch();
  for (var s = 0; s < sampel; s++) {
    jam
      ..reset()
      ..start();
    for (var i = 0; i < ulangi; i++) {
      kerja();
    }
    jam.stop();
    hasil.add(jam.elapsedMicroseconds / ulangi);
  }
  return median(hasil);
}

int _sink = 0; // menampung hasil agar pekerjaan tidak dianggap mati

void main() {
  final a = List<int>.generate(2000, (i) => i);
  final b = List<int>.generate(2000, (i) => i * 2);
  final lambat = ukur(() => _sink += irisanLambat(a, b).length);
  final cepat = ukur(() => _sink += irisanCepat(a, b).length);
  print('lambat: ${lambat.toStringAsFixed(0)} us | cepat: ${cepat.toStringAsFixed(0)} us');
  print('sink=$_sink'); // memakai _sink agar tidak dieliminasi
}
```

- `[...xs]..sort()` — salin dulu agar tidak memutasi argumen; `median` untuk jumlah sampel genap dan ganjil.
- `ukur` membuang `pemanasan` eksekusi pertama, lalu mengambil `sampel` pengukuran dan mengembalikan **median**.
- `jam..reset()..start()` — cascade (2.1) pada `Stopwatch`; `ulangi` menjalankan kerja kecil berkali-kali dalam satu pengukuran untuk menekan derau pewaktuan.
- `_sink += ...` — setiap hasil ditampung dan akhirnya dicetak sehingga kompilator tak dapat membuang pekerjaannya.
- Fungsi `irisanLambat` dan `irisanCepat` berasal dari modul 6.1.

**Contoh 2 — `package:benchmark_harness`.**

```bash
dart pub add dev:benchmark_harness
```

```dart
import 'package:benchmark_harness/benchmark_harness.dart';

class IrisanBench extends BenchmarkBase {
  IrisanBench(this.fungsi, String nama) : super(nama);

  final List<int> Function(List<int>, List<int>) fungsi;
  late final List<int> a;
  late final List<int> b;
  int sink = 0;

  @override
  void setup() {
    a = List<int>.generate(2000, (i) => i);
    b = List<int>.generate(2000, (i) => i * 2);
  }

  @override
  void run() {
    sink += fungsi(a, b).length;
  }
}

void main() {
  IrisanBench(irisanLambat, 'irisan lambat').report();
  IrisanBench(irisanCepat, 'irisan cepat').report();
}
```

- `BenchmarkBase` menyediakan siklus `setup` (tak diukur), `warmup`, `exercise` (memanggil `run` berulang), `teardown`, dan `report` yang mencetak skor dalam mikrodetik.
- `setup` menyiapkan data di luar pengukuran; `run` hanya berisi pekerjaan yang diukur dan menampung hasilnya di `sink`.
- Jalankan dengan `dart run` (JIT) dan bandingkan dengan biner AOT di bawah.

**Contoh 3 — mengukur di mode yang tepat, dan profil.**

```bash
# JIT (cepat mulai; bagus untuk pengembangan)
dart run bin/bench.dart

# AOT (mendekati produksi): kompilasi lalu jalankan biner
dart compile exe bin/bench.dart -o bench
./bench

# Profiling: jalankan dengan layanan VM, lalu hubungkan DevTools ke URL yang dicetak
dart run --observe bin/bench.dart
```

- Bandingkan dua implementasi pada mode yang sama; jangan membandingkan JIT dengan AOT.
- `dart run --observe` mencetak URL layanan VM untuk DevTools; ketersediaan tampilan CPU, memori, dan performa bergantung pada tipe aplikasi (lihat dokumentasi).

### D. Opsi Kode Lain untuk Logika yang Sama

| Alat | Kelebihan | Kekurangan |
| --- | --- | --- |
| `Stopwatch` manual | Tanpa dependensi; cepat ditulis | Mudah salah (tanpa pemanasan, satu sampel) |
| Harness mini (median) | Sederhana namun lebih jujur | Dipelihara sendiri |
| `package:benchmark_harness` | Standar resmi; pemanasan dan siklus baku | Skor tunggal; ikuti petunjuk README |
| Paket statistik pihak ketiga (mis. `benchmark_harness_plus`) | Median, sebaran, indikator keandalan | Dependensi tambahan |
| Profiler (DevTools) | Menemukan bagian terpanas tanpa menebak | Perlu pemahaman membaca profil; tak semua tampilan tersedia untuk tiap tipe aplikasi |

### E. Terminologi Esensial

- **Benchmark** — pengukuran terkontrol untuk membandingkan implementasi. **Profiling** — menemukan di mana waktu dan memori dipakai.
- **Warmup** — eksekusi awal yang dibuang. **Median** — nilai tengah sampel, tahan outlier. **Dead code elimination (DCE)** — kompilator membuang perhitungan tak terpakai.
- **JIT / AOT** — kompilasi saat jalan / sebelum jalan. **Sink** — variabel penampung hasil untuk mencegah DCE. **Hukum Amdahl** — percepatan total dibatasi oleh bagian yang tak dipercepat.

### F. Visualisasi (ASCII)

```text
  tulis benar dulu ──► tulis tes kesetaraan (cepat == lambat)
         │
         ▼
  ukur (pemanasan, banyak sampel, median, sink)  ──►  di mode yang akan dipakai (AOT, tanpa asserts)
         │
         ▼
  profil: bagian terpanas?  ──► optimasi di sana  ──► ukur ulang  ──► bandingkan relatif
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 6.1 (kompleksitas sebagai hipotesis yang diuji), 1.7 (`dart run`, `dart compile exe`, `--enable-asserts`), 3.1 (`==` dan `hashCode` memengaruhi biaya hash).
- **Prasyarat bagi:** 6.3–6.7. **Dikembangkan di:** Fase 7 (mengukur konkurensi), Fase 10 (benchmark sebagai bagian CI, regresi performa).

### H. Tips & Praktik Terbaik

- Tulis tes kesetaraan sebelum benchmark: versi cepat yang salah tidak berguna.
- Selalu tampung hasil dalam `sink` dan gunakan; cetak di akhir.
- Jalankan beberapa kali, bandingkan median, dan curigai hasil yang berbeda jauh antarjalan.
- Catat konfigurasi pengukuran (mode, ukuran data, mesin) bersama angkanya.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mengukur satu kali jalan | Hasil acak | Banyak sampel dan median |
| Tanpa pemanasan | Iterasi awal lambat mencemari hasil | Buang beberapa eksekusi pertama |
| Hasil tak dipakai | Waktu mendekati nol (DCE) | Tampung dalam `sink` dan cetak |
| Mengukur dengan `--enable-asserts` | Hasil tak mewakili produksi | Ukur tanpa asserts, idealnya AOT |
| Membandingkan JIT dengan AOT | Kesimpulan keliru | Bandingkan di mode yang sama |
| Data uji terlalu kecil | Konstanta mendominasi; kesimpulan salah di skala nyata | Ukur beberapa ukuran *n* realistis |
| Mengoptimalkan tanpa profil | Usaha pada bagian tak relevan | Profil dulu; optimasi bagian terpanas |

### J. Sumber Referensi

- ✔ Dart DevTools (aplikasi baris perintah, `dart run --observe`, timeline streams): https://dart.dev/tools/dart-devtools
- Paket `benchmark_harness`: https://pub.dev/packages/benchmark\_harness · ✔ sumber `BenchmarkBase`: https://dart.googlesource.com/tools.git/+/03f2c205/pkgs/benchmark\_harness/lib/src/benchmark\_base.dart
- ✔ Paket `benchmark_harness_plus` (median, sebaran): https://pub.dev/packages/benchmark\_harness\_plus
- Vyacheslav Egorov, *Microbenchmarking Dart* (bagian 1): https://mrale.ph/blog/2021/01/21/microbenchmarking-dart-part-1.html
- `dart compile`: https://dart.dev/tools/dart-compile · Hukum Amdahl: https://en.wikipedia.org/wiki/Amdahl%27s\_law

---

## 6.3 Memilih Struktur Data

*Motivasi: struktur data yang tepat membuat algoritma yang sulit menjadi satu baris.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini mengajarkan cara memilih struktur data dari **operasi yang paling sering dilakukan**: `List`, `Set`, `Map`, `Queue`, `PriorityQueue`, pohon terurut (`SplayTreeMap`), dan data bertipe (`Uint8List`, `BoolList`). Kamu juga belajar pengurutan (dan sifat tak-stabilnya), pencarian biner, serta jebakan memilih struktur yang membuat operasi dominan menjadi kuadratik.

### B. Konsep Kunci & Filosofi Mendalam

- **Mulai dari pertanyaan, bukan dari struktur.** Operasi apa yang paling sering? Apakah *urutan* penting? Apakah *duplikat* diizinkan? Apakah ada *kunci*? Berapa *ukuran* data? Pilih struktur yang membuat operasi dominan murah.
- **`List`:** akses indeks O(1); `add` di akhir O(1) teramortisasi; `insert`/`removeAt` di depan atau tengah O(n); `contains`/`indexOf` O(n). Elemen tersusun berurutan di memori sehingga iterasi ramah cache.
- **`Set` dan `Map` literal** secara bawaan adalah `LinkedHashSet`/`LinkedHashMap`: operasi O(1) *rata-rata*, urutan iterasi = urutan penyisipan. `HashSet`/`HashMap` tidak menjamin urutan. Kualitas `==` dan `hashCode` kunci menentukan kinerja nyata (3.1).
- **`SplayTreeSet`/`SplayTreeMap`:** terurut menurut pembanding; operasi O(log n) (teramortisasi). Pilih bila butuh iterasi terurut atau pencarian terdekat tanpa mengurutkan ulang.
- **`Queue`** (bawaan `ListQueue`): `add`/`removeFirst`/`removeLast`/`addFirst` O(1) di kedua ujung; tanpa pencarian cepat. `QueueList` dari `package:collection` mengimplementasikan `Queue` *dan* `List`.
- **`PriorityQueue`** (`package:collection`): `add` dan `removeFirst` O(log n), elemen prioritas teratas O(1); tanpa `contains` cepat. Cocok untuk *top-k*, penjadwalan, dan algoritma graf.
- **Data bertipe (`dart:typed_data`):** `Uint8List`, `Int32List`, `Float64List` menyimpan angka secara padat tanpa objek per elemen; ukurannya tetap. Waspada: nilai di luar rentang *membungkus* secara diam-diam (`Uint8List` menyimpan 300 sebagai 44). `BoolList` (`package:collection`) menyimpan boolean hemat ruang.
- **Pengurutan.** `List.sort` memutasi list di tempat, O(n log n), dan **tidak dijamin stabil**: objek yang setara boleh muncul dalam urutan apa pun. Untuk hasil stabil dan tanpa mutasi, pakai `sortedBy` (`package:collection`).
- **Pencarian biner.** Pada list *terurut*, `binarySearch` dan `lowerBound` (`package:collection`) mencari O(log n); `lowerBound` memberi indeks pertama yang ≥ nilai, juga posisi sisip yang menjaga keterurutan.
- **Salinan itu biaya.** `toList()`, `toSet()`, dan spread `[...x]` menyalin O(n); jangan memanggilnya di dalam loop tanpa alasan.
- **Filosofi:** struktur data adalah *kontrak biaya*. Memilihnya berarti menulis operasi mana yang kamu janjikan murah.
- **Dampak desain:** memakai `List` sebagai antrean (`removeAt(0)`), atau `List.contains` sebagai himpunan, mengubah masalah linear menjadi kuadratik tanpa satu baris pun terlihat salah.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — antrean: `removeAt(0)` vs `Queue`.**

```dart
import 'dart:collection';

int prosesDenganList(int n) {
  final antrean = List<int>.generate(n, (i) => i);
  var total = 0;
  while (antrean.isNotEmpty) {
    total += antrean.removeAt(0); // O(n): menggeser semua elemen sisa
  }
  return total;
}

int prosesDenganQueue(int n) {
  final antrean = Queue<int>()..addAll(List<int>.generate(n, (i) => i));
  var total = 0;
  while (antrean.isNotEmpty) {
    total += antrean.removeFirst(); // O(1)
  }
  return total;
}

void main() {
  assert(prosesDenganList(1000) == prosesDenganQueue(1000));
}
```

- Keduanya menghasilkan jumlah yang sama; perbedaannya total O(n²) vs O(n) karena `removeAt(0)` menggeser seluruh sisa elemen tiap kali.
- `Queue<int>()` secara bawaan membuat `ListQueue`; `addAll` mengisinya dari list.
- Ukur selisihnya dengan harness 6.2 pada *n* yang makin besar.

**Contoh 2 — mengelompokkan dengan `Map` dalam satu lintasan.**

```dart
Map<String, List<String>> kelompokkan(Iterable<String> kata) {
  final peta = <String, List<String>>{};
  for (final k in kata) {
    if (k.isEmpty) continue;
    peta.putIfAbsent(k[0].toLowerCase(), () => []).add(k);
  }
  return peta;
}

void main() {
  final g = kelompokkan(['apel', 'Alpukat', 'jeruk', 'jambu', 'kiwi']);
  assert(g['a']!.length == 2 && g['j']!.length == 2 && g['k']!.length == 1);
}
```

- `putIfAbsent(kunci, () => [])` membuat list hanya bila kunci belum ada, lalu `.add(k)` menambahkan — satu lintasan O(n) untuk seluruh pengelompokan.
- Alternatifnya, memindai seluruh data per huruf, O(n × jumlah huruf).
- `g['a']!` di `main` hanya untuk contoh uji yang kita jamin kuncinya ada; di kode inti, tangani `null` (2.2).

**Contoh 3 — *top-k* dengan `PriorityQueue` berukuran k.**

```dart
import 'package:collection/collection.dart';

List<int> terkecil(Iterable<int> data, int k) {
  final heap = PriorityQueue<int>((a, b) => b.compareTo(a)); // max-heap: yang terbesar di atas
  for (final x in data) {
    heap.add(x);
    if (heap.length > k) heap.removeFirst(); // buang yang terbesar; heap tetap berukuran k
  }
  return heap.toList()..sort();
}

void main() {
  assert(terkecil([5, 1, 9, 3, 7], 3).toString() == '[1, 3, 5]');
}
```

- Heap menyimpan hanya *k* elemen: waktu O(n log k) dan memori O(k), dibanding mengurutkan seluruh data O(n log n) dengan memori O(n).
- Pembanding dibalik `(a, b) => b.compareTo(a)` membuat elemen *terbesar* berada di puncak sehingga `removeFirst` membuang yang terbesar.
- Berguna terutama bila *n* sangat besar dan *k* kecil, atau data datang sebagai aliran.

**Contoh 4 — algoritma + data padat: saringan bilangan prima.**

```dart
import 'dart:typed_data';

List<int> bilanganPrima(int batas) {
  if (batas < 2) return const [];
  final komposit = Uint8List(batas + 1); // 0 = belum dicoret; satu byte per elemen
  final prima = <int>[];
  for (var i = 2; i <= batas; i++) {
    if (komposit[i] == 0) {
      prima.add(i);
      for (var j = i * i; j <= batas; j += i) {
        komposit[j] = 1;
      }
    }
  }
  return prima;
}

void main() {
  assert(bilanganPrima(30).toString() == '[2, 3, 5, 7, 11, 13, 17, 19, 23, 29]');
}
```

- Saringan Eratosthenes berbiaya sekitar O(n log log n), jauh lebih murah daripada menguji tiap bilangan dengan pembagian.
- `Uint8List` memakai satu byte per penanda, jauh lebih padat daripada `List<bool>` atau `List<int>` berisi objek.
- Penanda hanya 0 atau 1 sehingga tak ada risiko pembungkusan nilai.

**Contoh 5 — pengurutan stabil dan pencarian biner.**

```dart
import 'package:collection/collection.dart';

void main() {
  final kata = ['pir', 'apel', 'kiwi', 'ara', 'jeruk'];
  final menurutPanjang = kata.sortedBy((k) => k.length); // stabil; tidak memutasi `kata`
  assert(menurutPanjang.toString() == '[pir, ara, apel, kiwi, jeruk]');

  final terurut = [10, 20, 20, 30, 40];
  assert(lowerBound(terurut, 20) == 1); // indeks pertama yang >= 20
  assert(lowerBound(terurut, 25) == 3); // posisi sisip yang menjaga keterurutan
  assert(binarySearch(terurut, 30) == 3);
  assert(binarySearch(terurut, 35) == -1); // tidak ada
}
```

- `sortedBy` mempertahankan urutan awal untuk kunci yang sama (`pir` sebelum `ara`; `apel` sebelum `kiwi`) — sifat yang tak dijamin oleh `List.sort`.
- `lowerBound` hanya benar pada list yang *sudah terurut* (precondition, modul 1.5).
- `binarySearch` mengembalikan `-1` bila tak ditemukan.

### D. Opsi Kode Lain untuk Logika yang Sama

| Struktur | Akses/cari | Tambah | Hapus awal | `contains` | Urutan iterasi |
| --- | --- | --- | --- | --- | --- |
| `List` | indeks O(1) | akhir O(1) amortisasi; depan O(n) | O(n) | O(n) | indeks |
| `Queue` (`ListQueue`) | ujung O(1) | kedua ujung O(1) | O(1) | O(n) | urutan antrean |
| `Set`/`Map` (bawaan `LinkedHash*`) | O(1) rata-rata | O(1) rata-rata | O(1) rata-rata | O(1) rata-rata | urutan penyisipan |
| `HashSet`/`HashMap` | O(1) rata-rata | O(1) rata-rata | O(1) rata-rata | O(1) rata-rata | tak dijamin |
| `SplayTreeSet`/`SplayTreeMap` | O(log n) | O(log n) | O(log n) | O(log n) | terurut |
| `PriorityQueue` | teratas O(1) | O(log n) | `removeFirst` O(log n) | O(n) | tak dijamin (prioritas di puncak) |
| `Uint8List` dll. | indeks O(1) | ukuran tetap | — | O(n) | indeks |

### E. Terminologi Esensial

- **Operasi dominan** — operasi yang paling sering atau paling mahal dalam beban kerja. **Struktur terurut** — menjaga urutan menurut pembanding (pohon).
- **Heap / priority queue** — struktur yang cepat memberi elemen berprioritas teratas. **Stabil** — elemen setara mempertahankan urutan asal.
- **Data bertipe** — larik numerik padat tanpa objek per elemen. **Pembungkusan nilai (wraparound)** — nilai di luar rentang dipotong secara modulo.
- **Lower bound** — indeks pertama dengan nilai ≥ target pada list terurut.

### F. Visualisasi (ASCII)

```text
 Operasi dominan apa?
 ├─ akses/ubah menurut indeks, iterasi berurutan      → List
 ├─ cek keanggotaan / deduplikasi                      → Set
 ├─ cari menurut kunci                                  → Map
 ├─ ambil dari depan, tambah di belakang                → Queue
 ├─ selalu ambil yang 'terbaik' / top-k                 → PriorityQueue
 ├─ iterasi terurut + sisip dinamis                     → SplayTreeSet / SplayTreeMap
 ├─ jutaan angka kecil / penanda                        → Uint8List / Int32List / BoolList
 └─ data statis terurut, banyak pencarian               → List terurut + binarySearch / lowerBound
```

```text
   List.removeAt(0)              Queue.removeFirst()
   [a b c d e]                    head → a b c d e ← tail
    ↓ geser semua  O(n)           lepas head       O(1)
   [b c d e]                      head → b c d e ← tail
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 6.1 (biaya operasi), 3.1 (hash dan kesetaraan), 3.4 (koleksi sebagai nilai), 1.6 (loop dan binary search).
- **Prasyarat bagi:** 6.4–6.7. **Dikembangkan di:** Fase 7 (struktur data untuk aliran dan antrean tugas), Fase 11 (memilih struktur pada batas modul).

### H. Tips & Praktik Terbaik

- Tulis operasi dominan di komentar sebelum memilih struktur; pilih yang membuatnya murah.
- Gunakan `Set` untuk keanggotaan dan `Map` untuk pencarian; jangan memindai `List` berulang kali.
- Gunakan `Queue` untuk antrean, bukan `List.removeAt(0)`.
- Gunakan `sortedBy` bila urutan stabil penting; ingat `List.sort` memutasi dan tak stabil.
- Pakai data bertipe untuk volume besar angka kecil, dan pahami rentang nilainya.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| `List` sebagai antrean | Kuadratik tersembunyi | `Queue` |
| `List.contains` di dalam loop | Lambat saat data tumbuh | Ubah ke `Set` di muka |
| Mengandalkan stabilitas `List.sort` | Urutan sama-nilai berubah antar-platform/versi | `sortedBy` atau tambahkan kunci pembeda |
| `lowerBound` pada list tak terurut | Hasil tak bermakna | Pastikan precondition terurut (assert) |
| `Uint8List` diisi nilai besar | Nilai membungkus diam-diam | Validasi rentang atau pilih tipe lebih lebar |
| `List` sebagai kunci `Map` | Entri ganda (identitas) | Record atau tipe nilai (3.4) |
| `toList()`/spread di dalam loop | Alokasi O(n) berulang | Hitung sekali di luar loop |

### J. Sumber Referensi

- ✔ Changelog `package:collection` (`QueueList`, `BoolList`, `sortedBy` stabil, `lowerBound`): https://pub.dev/packages/collection/changelog
- `Queue`/`ListQueue`/`SplayTreeMap`: https://api.dart.dev/stable/dart-collection/dart-collection-library.html
- `dart:typed_data`: https://api.dart.dev/stable/dart-typed\_data/dart-typed\_data-library.html
- `PriorityQueue`: https://pub.dev/documentation/collection/latest/collection/PriorityQueue-class.html
- Saringan Eratosthenes: https://en.wikipedia.org/wiki/Sieve\_of\_Eratosthenes · Binary heap: https://en.wikipedia.org/wiki/Binary\_heap

---

## 6.4 Iterable Malas, Alokasi, dan Pembangunan Data

*Motivasi: pekerjaan paling murah adalah pekerjaan yang tidak pernah kamu lakukan.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas **evaluasi malas** pada `Iterable` (`map`, `where`, `take`, ...), kapan *materialisasi* (`toList`, `length`) memicu pekerjaan, **generator** `sync*` untuk urutan tak terbatas, serta cara membangun data dengan **alokasi minimal**: `StringBuffer`, alokasi awal, dan menghindari salinan antara. Tujuannya mengurangi pekerjaan dan tekanan GC tanpa mengorbankan kejelasan.

### B. Konsep Kunci & Filosofi Mendalam

- **`Iterable` malas.** `map`, `where`, `skip`, `take`, dan `expand` mengembalikan *tampilan* yang menghitung elemen hanya saat diiterasi; membuat pipeline tidak melakukan pekerjaan apa pun sampai ada yang meminta nilainya.
- **Materialisasi memicu pekerjaan.** `toList()`, `toSet()`, `length` (pada iterable bukan list), `fold`, `join`, dan `forEach` mengiterasi penuh. **Setiap iterasi menghitung ulang** pipeline dari awal — dua kali iterasi berarti dua kali pekerjaan dan dua kali efek samping.
- **Berhenti lebih awal.** `first`, `firstWhere`, `any`, `every`, `take`, dan `contains` berhenti begitu jawaban pasti; rangkai dengan sumber malas agar pekerjaan sisanya tak pernah dilakukan.
- **Tampilan malas mengikuti sumbernya.** Iterable hasil `map` atas sebuah list membaca list itu saat diiterasi, bukan saat dibuat; bila list diubah sesudahnya, hasilnya ikut berubah (dan mengubah list *selama* iterasi melempar `ConcurrentModificationError`).
- **Generator `sync*`.** Fungsi yang menghasilkan `Iterable` dengan `yield`, dihitung malas per elemen. Cocok untuk urutan tak terbatas (Fibonacci) yang dikonsumsi sebagian lewat `take`/`firstWhere`.
- **Kapan sebaiknya materialisasi.** Bila hasil dipakai berkali-kali, atau sumbernya akan berubah, atau perlu akses indeks: `toList()` sekali dan gunakan hasilnya. Hindari `toList()` di *tengah* pipeline.
- **Alokasi.** Setiap objek baru (list antara, closure yang menangkap variabel, record, string baru) menambah pekerjaan alokasi dan tekanan GC. Kurangi salinan yang tak perlu, tetapi jangan mengorbankan kejelasan tanpa ukuran (6.2).
- **Membangun string.** String imutabel; `hasil += bagian` di dalam loop membuat string baru tiap iterasi dan dapat berbiaya kuadratik pada kasus terburuk. Idiomnya `StringBuffer` atau `join`.
- **Alokasi awal.** `List.filled` dan `List.generate` (dengan `growable: false` bila ukuran tetap) menghindari pertumbuhan berulang dan, untuk list tak-bertumbuh, sedikit lebih hemat.
- **`const`** membagikan satu instans konstan (3.2): tanpa alokasi saat runtime.
- **Filosofi:** tunda pekerjaan sampai terbukti diperlukan, dan lakukan sekali.
- **Dampak desain:** pipeline malas yang diiterasi berkali-kali, atau berisi efek samping, menghasilkan perilaku mengejutkan; materialisasi terlalu awal membuang keuntungan malas.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — malas vs materialisasi: menghitung pekerjaan nyata.**

```dart
void main() {
  var panggilan = 0;
  final ganjil = [1, 2, 3, 4, 5, 6].where((x) {
    panggilan++;
    return x.isOdd;
  });
  assert(panggilan == 0); // malas: belum ada pekerjaan

  final pertama = ganjil.first; // berhenti di elemen ganjil pertama
  assert(pertama == 1 && panggilan == 1);

  panggilan = 0;
  final jumlah = ganjil.length; // iterasi penuh
  assert(jumlah == 3 && panggilan == 6);

  panggilan = 0;
  final semua = ganjil.toList(); // iterasi penuh LAGI
  assert(semua.length == 3 && panggilan == 6);

  panggilan = 0;
  assert(semua.length == 3 && semua.contains(5) && panggilan == 0); // memakai hasil: tanpa predikat
}
```

- `where` tidak memanggil predikat sampai ada yang mengiterasi.
- `first` berhenti begitu menemukan elemen pertama; `length` dan `toList()` masing-masing mengiterasi penuh (6 pemanggilan) — *setiap kali*.
- Setelah `toList()`, memakai `semua` tidak memanggil predikat lagi: materialisasi sekali membayar pekerjaan sekali.

**Contoh 2 — tampilan malas mengikuti sumber.**

```dart
void main() {
  final sumber = [1, 2, 3];
  final dobel = sumber.map((x) => x * 2); // belum dihitung
  sumber.add(4);
  assert(dobel.toList().toString() == '[2, 4, 6, 8]'); // memuat elemen yang ditambahkan SESUDAH dibuat

  final beku = sumber.map((x) => x * 2).toList(); // materialisasi: foto saat ini
  sumber.add(5);
  assert(beku.length == 4); // tidak berubah
}
```

- Iterable malas adalah *tampilan*, bukan hasil; bila butuh nilai pada saat tertentu, materialisasikan (bandingkan view vs snapshot, 3.4).

**Contoh 3 — generator `sync*` untuk urutan tak terbatas.**

```dart
Iterable<int> fibonacci() sync* {
  var a = 0;
  var b = 1;
  while (true) {
    yield a;
    (a, b) = (b, a + b);
  }
}

void main() {
  assert(fibonacci().take(10).toList().toString() == '[0, 1, 1, 2, 3, 5, 8, 13, 21, 34]');
  assert(fibonacci().firstWhere((x) => x > 1000) == 1597);
}
```

- `sync*` + `yield` menghasilkan urutan secara malas; loop `while (true)` aman karena konsumen yang memutuskan kapan berhenti.
- `(a, b) = (b, a + b)` — penugasan pola (2.4) menukar tanpa variabel sementara.
- `take(10)` dan `firstWhere` hanya menghitung elemen yang dibutuhkan; tak ada daftar 1.000 angka yang pernah dibuat.

**Contoh 4 — membangun string dan list dengan hemat alokasi.**

```dart
String gabungLambat(List<String> bagian) {
  var hasil = '';
  for (final b in bagian) {
    hasil += b; // membuat String baru tiap iterasi
  }
  return hasil;
}

String gabungCepat(List<String> bagian) {
  final buf = StringBuffer();
  for (final b in bagian) {
    buf.write(b);
  }
  return buf.toString();
}

void main() {
  final bagian = List<String>.generate(1000, (i) => 'x$i');
  assert(gabungLambat(bagian) == gabungCepat(bagian));
  assert(gabungCepat(bagian) == bagian.join()); // idiom paling singkat

  // Ukuran diketahui: alokasi sekali, tak bertumbuh.
  final kuadrat = List<int>.generate(1000, (i) => i * i, growable: false);
  assert(kuadrat.last == 999 * 999);
}
```

- `StringBuffer.write` menambah ke penyangga internal; `toString()` membuat string akhir sekali.
- `join()` pada list string sudah melakukan itu untukmu.
- `List.generate(..., growable: false)` membuat list berukuran tetap; tak ada pertumbuhan atau salinan.

### D. Opsi Kode Lain untuk Logika yang Sama

| Kebutuhan | Bentuk malas | Bentuk eager | Pilih bila |
| --- | --- | --- | --- |
| Ambil beberapa elemen pertama dari sumber besar | `sumber.where(...).take(k)` | `sumber.where(...).toList().sublist(0, k)` | Malas: berhenti dini, tanpa list antara |
| Dipakai berkali-kali | — | `toList()` sekali | Eager: bayar sekali |
| Perlu indeks atau `length` murah | — | `toList()` | Eager |
| Urutan tak terbatas | `sync*` | Tak mungkin | Malas |
| Hasil harus stabil terhadap perubahan sumber | — | `toList()` (snapshot) | Eager |
| Efek samping per elemen | `for` | `for` | Gunakan loop, bukan pipeline malas |

### E. Terminologi Esensial

- **Evaluasi malas (lazy)** — menunda perhitungan sampai nilainya diminta. **Materialisasi** — memaksa pembentukan hasil konkret (`toList`).
- **Generator** — fungsi `sync*` yang menghasilkan elemen dengan `yield`. **Tampilan (view)** — objek yang membaca sumber saat diiterasi.
- **Tekanan GC** — banyaknya objek sementara yang harus dibersihkan penata sampah. **Alokasi awal** — menyiapkan ukuran sekali di depan.

### F. Visualisasi (ASCII)

```text
  sumber ─► where ─► map ─► take(3) ─► toList()          ← pekerjaan baru dimulai di sini
    1        ✓        ✓                                   (pull: konsumen menarik elemen satu per satu)
    2        ✗
    3        ✓        ✓
    4        ✗
    5        ✓        ✓   ← 3 elemen terkumpul: BERHENTI (sisa sumber tak disentuh)
```

```text
  eager :  sumber ─► [list antara 1] ─► [list antara 2] ─► hasil     (banyak alokasi, pekerjaan penuh)
  lazy  :  sumber ─► ─────────── satu lintasan ─────────────► hasil  (berhenti dini bila bisa)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 6.1 (biaya iterasi), 3.4 (view vs snapshot), 2.1 (ekspresi, spread), 4.2 (closure).
- **Prasyarat bagi:** 6.5–6.7. **Dikembangkan di:** Fase 7 (`Stream` sebagai padanan asinkron `Iterable`; `async*`), Fase 10 (menguji pipeline malas).

### H. Tips & Praktik Terbaik

- Jangan menaruh efek samping di dalam `map`/`where`; pakai `for` untuk efek.
- Materialisasikan sekali dengan `toList()` bila hasil dipakai lebih dari satu kali.
- Pakai `take`/`firstWhere`/`any` agar pipeline berhenti dini.
- Bangun string dengan `StringBuffer` atau `join`; gunakan `List.generate`/`filled` bila ukuran diketahui.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mengiterasi pipeline malas berkali-kali | Pekerjaan dan efek samping berulang | `toList()` sekali |
| `length` pada iterable malas | Iterasi penuh tersembunyi | Materialisasi atau hitung sambil iterasi |
| Efek samping di `map` yang tak pernah dikonsumsi | Efek tidak pernah terjadi | Gunakan `for` |
| Mengira hasil `map` adalah foto saat itu | Hasil berubah bersama sumber | `toList()` sebagai snapshot |
| Mengubah sumber saat diiterasi | `ConcurrentModificationError` | Iterasi atas salinan atau kumpulkan perubahan |
| `+=` pada string di loop panjang | Lambat dan boros alokasi | `StringBuffer` atau `join` |
| `toList()` di tengah pipeline | Alokasi antara tak perlu | Satukan menjadi satu pipeline |

### J. Sumber Referensi

- Iterable dan koleksi: https://dart.dev/libraries/dart-core · API `Iterable`: https://api.dart.dev/stable/dart-core/Iterable-class.html
- Generator (`sync*`, `async*`): https://dart.dev/language/functions#generators
- API `StringBuffer`: https://api.dart.dev/stable/dart-core/StringBuffer-class.html · API `List.generate`: https://api.dart.dev/stable/dart-core/List/List.generate.html
- ✔ Effective Dart — penggunaan (koleksi, string): https://dart.dev/effective-dart/usage

---

## 6.5 Memoization, Caching, dan Teknik Algoritmik

*Motivasi: algoritma yang lebih cerdas mengalahkan perangkat keras yang lebih cepat — dan hampir selalu lebih murah.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas cara menukar **ruang dengan waktu** secara sadar dan terbatas: **memoization** (menyimpan hasil fungsi murni), **cache berbatas** (LRU), **pemrograman dinamis** (top-down vs bottom-up, *rolling state*), serta teknik algoritmik yang mengubah O(n²) menjadi O(n): **hashing** (pasangan penjumlahan), **prefix sum**, dan **Kadane**. Setiap teknik datang dengan syarat kebenarannya.

### B. Konsep Kunci & Filosofi Mendalam

- **Memoization.** Menyimpan hasil `f(x)` agar pemanggilan berikutnya dengan `x` yang sama tak menghitung ulang. **Syarat mutlak:** `f` murni (1.2) — tak bergantung waktu, acak, atau I/O — dan kunci `x` punya kesetaraan nilai yang benar (3.1).
- **Overlapping subproblems.** Masalah yang memanggil dirinya dengan argumen yang sama berulang (Fibonacci) cocok untuk memoization atau tabel. Fibonacci naif berbiaya eksponensial: jumlah pemanggilannya 2·F(n+1) − 1.
- **Top-down vs bottom-up.** *Top-down*: rekursi + memo. *Bottom-up*: isi tabel dari kasus dasar ke atas. Bottom-up tak memakai stack rekursi (aman dari stack overflow) dan sering memungkinkan **rolling state**: hanya menyimpan dua nilai terakhir sehingga ruang O(1).
- **Cache berbatas.** Memo tanpa batas adalah kebocoran memori yang tertunda. Kebijakan pembuangan **LRU** (*least recently used*) membuang entri yang paling lama tak dipakai. Dengan `LinkedHashMap` (urutan penyisipan), semua operasi O(1): hapus lalu masukkan ulang saat dipakai, dan buang entri pertama bila penuh.
- **Invalidasi.** Cache bisa *basi* bila sumber data berubah. Putuskan kapan entri kedaluwarsa atau dibuang; jangan meng-cache hasil dari fungsi yang tidak murni.
- **Teknik algoritmik yang mengubah kelas biaya.** *Hashing*: simpan apa yang sudah terlihat untuk menjawab "apakah pasangannya ada?" dalam O(1). *Prefix sum*: persiapan O(n) membuat jumlah rentang menjadi O(1). *Kadane*: jumlah subarray maksimum dalam satu lintasan, ruang O(1).
- **Spesifikasi harus menentukan jawaban mana.** Bila ada beberapa pasangan yang sah, versi O(n²) dan O(n) dapat mengembalikan pasangan *berbeda* — keduanya benar. Tulis di spesifikasi apakah yang dicari *sembarang* pasangan, yang pertama menurut indeks, atau semuanya (1.1).
- **Filosofi:** simpan hanya yang terbukti mahal dihitung ulang, beri batas, dan tulis syarat kebenarannya.
- **Dampak desain:** memoization yang salah (fungsi tak murni, kunci buruk, tanpa batas) menghasilkan bug basi dan kebocoran yang jauh lebih sulit ditemukan daripada kelambatan yang mau diatasinya.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — Fibonacci: eksponensial, memo, dan iteratif.**

```dart
int fibLambat(int n) => n < 2 ? n : fibLambat(n - 1) + fibLambat(n - 2);

/// Jumlah pemanggilan yang dilakukan fibLambat(n).
int panggilanFib(int n) =>
    n < 2 ? 1 : 1 + panggilanFib(n - 1) + panggilanFib(n - 2);

int fibMemo(int n, [Map<int, int>? cache]) {
  final c = cache ?? <int, int>{};
  if (n < 2) return n;
  return c[n] ??= fibMemo(n - 1, c) + fibMemo(n - 2, c);
}

int fibIteratif(int n) {
  var a = 0;
  var b = 1;
  for (var i = 0; i < n; i++) {
    (a, b) = (b, a + b);
  }
  return a;
}

void main() {
  assert(fibLambat(20) == 6765);
  assert(panggilanFib(20) == 21891); // sudah ribuan pemanggilan untuk n sekecil 20
  assert(fibMemo(50) == 12586269025);
  assert(fibIteratif(50) == 12586269025);
}
```

- `panggilanFib(20) == 21891`: bukti deterministik bahwa pemanggilan naif tumbuh eksponensial; `n = 50` akan butuh puluhan miliar pemanggilan.
- `c[n] ??= ...` — bila `n` belum ada di cache, hitung dan simpan; pemanggilan berikutnya langsung mengambil. Waktu O(n), ruang O(n).
- `fibIteratif` — hanya dua variabel: waktu O(n), ruang O(1) (rolling state); `(a, b) = (b, a + b)` adalah penugasan pola.

**Contoh 2 — cache LRU berbatas dan memoization berbatas.**

```dart
class CacheLru<K, V extends Object> {
  CacheLru(this.kapasitas) : assert(kapasitas > 0);
  final int kapasitas;
  final _data = <K, V>{}; // LinkedHashMap: urutan penyisipan = urutan pemakaian

  V? ambil(K kunci) {
    final nilai = _data.remove(kunci);
    if (nilai == null) return null;
    _data[kunci] = nilai; // pindahkan ke posisi 'paling baru'
    return nilai;
  }

  void simpan(K kunci, V nilai) {
    _data.remove(kunci);
    _data[kunci] = nilai;
    if (_data.length > kapasitas) {
      _data.remove(_data.keys.first); // buang yang paling lama tak dipakai
    }
  }

  int get ukuran => _data.length;
}

R Function(A) memoLru<A, R extends Object>(
  R Function(A) f, {
  required int kapasitas,
}) {
  final cache = CacheLru<A, R>(kapasitas);
  return (a) {
    final tersimpan = cache.ambil(a);
    if (tersimpan != null) return tersimpan;
    final baru = f(a);
    cache.simpan(a, baru);
    return baru;
  };
}

void main() {
  final c = CacheLru<String, int>(2);
  c.simpan('a', 1);
  c.simpan('b', 2);
  assert(c.ambil('a') == 1); // 'a' kini paling baru
  c.simpan('c', 3); // penuh: 'b' (paling lama tak dipakai) dibuang
  assert(c.ambil('b') == null && c.ambil('a') == 1 && c.ukuran == 2);

  var hitung = 0;
  final kuadrat = memoLru<int, int>((x) {
    hitung++;
    return x * x;
  }, kapasitas: 2);
  assert(kuadrat(3) == 9 && kuadrat(3) == 9 && hitung == 1); // kedua kali dari cache
}
```

- `V extends Object` — nilai tak boleh `null`, sehingga `null` dari `ambil` pasti berarti *tidak ada* (2.2).
- `ambil` memindahkan entri ke posisi terakhir (paling baru); `simpan` membuang entri pertama bila kapasitas terlampaui — semuanya O(1).
- `memoLru` membungkus fungsi murni dengan cache berbatas; memori tak pernah melebihi `kapasitas` entri.

**Contoh 3 — hashing: pasangan penjumlahan O(n), dan jebakan spesifikasi.**

```dart
(int, int)? cariPasanganLambat(List<int> a, int target) {
  for (var i = 0; i < a.length; i++) {
    for (var j = i + 1; j < a.length; j++) {
      if (a[i] + a[j] == target) return (i, j);
    }
  }
  return null;
}

(int, int)? cariPasanganCepat(List<int> a, int target) {
  final terlihat = <int, int>{}; // nilai -> indeks pertama kemunculannya
  for (var j = 0; j < a.length; j++) {
    final i = terlihat[target - a[j]];
    if (i != null) return (i, j);
    terlihat.putIfAbsent(a[j], () => j);
  }
  return null;
}

bool valid(List<int> a, int t, (int, int)? p) =>
    p == null || (p.$1 < p.$2 && a[p.$1] + a[p.$2] == t);

void main() {
  const a = [3, 2, 4, 3];
  final lambat = cariPasanganLambat(a, 6);
  final cepat = cariPasanganCepat(a, 6);
  assert(lambat == (0, 3)); // pasangan pertama menurut indeks kiri
  assert(cepat == (1, 2)); // pasangan pertama selesai menurut indeks kanan
  assert(valid(a, 6, lambat) && valid(a, 6, cepat)); // keduanya SAH, tetapi berbeda
  assert(cariPasanganCepat(a, 100) == null);
}
```

- Versi lambat O(n²) (dari Fase 1.6); versi cepat O(n) dengan O(n) memori tambahan: untuk tiap `a[j]`, tanya "apakah `target - a[j]` sudah pernah terlihat?".
- Hasilnya bisa *berbeda* — `(0, 3)` vs `(1, 2)` — karena spesifikasi tidak menentukan pasangan mana. Tulislah: *sembarang pasangan sah*, atau *pasangan dengan indeks kanan terkecil*.
- `valid` memeriksa *sifat* hasil (bukan nilai persis), cara menguji ketika jawaban tak unik (Fase 10).

**Contoh 4 — prefix sum dan Kadane.**

```dart
import 'dart:math' show max;

class JumlahAwalan {
  JumlahAwalan(List<int> data) : _awalan = _bangun(data);
  final List<int> _awalan; // _awalan[i] = jumlah data[0..i-1]

  static List<int> _bangun(List<int> data) {
    final hasil = List<int>.filled(data.length + 1, 0);
    for (var i = 0; i < data.length; i++) {
      hasil[i + 1] = hasil[i] + data[i];
    }
    return hasil;
  }

  /// Jumlah elemen indeks [dari] sampai sebelum [sampai]: O(1) setelah persiapan O(n).
  int jumlah(int dari, int sampai) {
    RangeError.checkValidRange(dari, sampai, _awalan.length - 1);
    return _awalan[sampai] - _awalan[dari];
  }
}

int maksSubarray(List<int> a) {
  if (a.isEmpty) throw ArgumentError.value(a, 'a', 'tidak boleh kosong');
  var berakhirDi = a.first;
  var terbaik = a.first;
  for (var i = 1; i < a.length; i++) {
    berakhirDi = max(a[i], berakhirDi + a[i]);
    terbaik = max(terbaik, berakhirDi);
  }
  return terbaik;
}

void main() {
  final j = JumlahAwalan([3, 1, 4, 1, 5]);
  assert(j.jumlah(1, 4) == 6); // 1 + 4 + 1
  assert(j.jumlah(0, 5) == 14);
  assert(maksSubarray([-2, 1, -3, 4, -1, 2, 1, -5, 4]) == 6); // 4 + -1 + 2 + 1
}
```

- `JumlahAwalan` membayar O(n) sekali; tiap pertanyaan jumlah rentang kemudian O(1) — cocok untuk banyak pertanyaan atas data tetap.
- `RangeError.checkValidRange` menegakkan precondition rentang (1.5).
- `maksSubarray` menyimpan hanya dua nilai (*rolling state*): O(n) waktu, O(1) ruang, tanpa memeriksa semua subarray O(n²).

### D. Opsi Kode Lain untuk Logika yang Sama

| Teknik | Waktu | Ruang | Syarat | Risiko |
| --- | --- | --- | --- | --- |
| Naif / brute force | O(n²) atau lebih | O(1) | — | Tak skala |
| Memoization | Seperlunya, sering O(n) | O(n) (atau berbatas LRU) | Fungsi murni; kunci bernilai | Kebocoran bila tanpa batas; basi |
| Tabel bottom-up | O(n) | O(n) | Urutan ketergantungan jelas | Boros ruang bila tak dipangkas |
| Rolling state | O(n) | O(1) | Hanya butuh beberapa nilai terakhir | Lebih sulit dibaca |
| Hashing (kamus terlihat) | O(n) | O(n) | Kunci dengan `==`/`hashCode` benar | Hasil bisa berbeda dari versi naif |
| Prefix sum | O(n) persiapan, O(1) per kueri | O(n) | Data tidak berubah | Data berubah membuat tabel basi |
| Urutkan lalu pindai | O(n log n) | O(1)–O(n) | Boleh mengubah urutan | `sort` tak stabil |

### E. Terminologi Esensial

- **Memoization** — menyimpan hasil fungsi murni per masukan. **LRU** — buang yang paling lama tak dipakai. **Invalidasi cache** — menentukan kapan entri basi.
- **Pemrograman dinamis** — menyelesaikan masalah dari submasalah yang tumpang-tindih. **Top-down / bottom-up** — rekursi + memo / tabel dari kasus dasar. **Rolling state** — hanya menyimpan keadaan terakhir yang diperlukan.
- **Prefix sum** — jumlah kumulatif untuk jumlah rentang O(1). **Kadane** — algoritma satu lintasan untuk jumlah subarray maksimum.
- **Sifat (property)** — pernyataan yang harus benar untuk semua hasil sah, dipakai saat jawaban tak unik.

### F. Visualisasi (ASCII)

```text
  fibLambat(5)                           fibMemo(5)

            f5                                    f5
          /    \                                 /  \
        f4      f3                             f4    f3 ← dari cache
       /  \    /  \                           /  \
     f3   f2  f2  f1                        f3   f2 ← dari cache
    / \                                    / \
  f2  f1       ... (f3, f2 dihitung       f2 f1
               berulang kali)

  panggilan: eksponensial                 panggilan: linear (tiap n dihitung sekali)
```

```text
  LRU, kapasitas 2:

  simpan a, b   →  [a, b]                (kiri = paling lama, kanan = paling baru)
  ambil a       →  [b, a]                (a dipindah ke kanan)
  simpan c      →  [b, a, c] → buang b → [a, c]
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 6.1 (analisis biaya), 6.3 (Map, struktur data), 1.2 (kemurnian sebagai syarat), 3.1 (kunci bernilai), 1.1 dan 1.8 (spesifikasi dan tabel contoh).
- **Prasyarat bagi:** 6.7 (studi kasus). **Dikembangkan di:** Fase 7 (cache bersama antar-isolate dan kondisi balapan), Fase 10 (property-based test untuk jawaban tak unik).

### H. Tips & Praktik Terbaik

- Sebelum memoize, buktikan bahwa fungsinya murni dan bahwa pemanggilan berulang dengan argumen sama memang terjadi.
- Selalu beri batas pada cache; catat kebijakan pembuangan dan alasannya.
- Tulis tes kesetaraan antara versi naif dan versi cepat pada data acak dan kasus tepi, sebelum percaya versi cepat.
- Tulis di spesifikasi jawaban mana yang dikembalikan bila ada banyak jawaban sah.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Memoize fungsi tak murni | Hasil basi atau salah | Hanya memoize fungsi murni |
| Cache tanpa batas | Memori terus bertambah | LRU atau kapasitas tetap |
| Kunci cache berupa `List` | Tak pernah cocok (identitas) | Record atau tipe nilai |
| Menyimpan `null` di cache | `null` ambigu: tak ada atau nilainya null | `V extends Object` atau pembungkus |
| Rekursi sangat dalam (top-down) | Stack overflow | Bottom-up atau iteratif |
| Menganggap hasil cepat dan naif harus identik padahal jawaban tak unik | Tes gagal palsu | Uji *sifat* hasil, bukan nilai persis |
| Prefix sum pada data yang berubah | Jumlah basi | Bangun ulang atau gunakan struktur lain (mis. pohon Fenwick) |

### J. Sumber Referensi

- Memoization: https://en.wikipedia.org/wiki/Memoization · Dynamic programming: https://en.wikipedia.org/wiki/Dynamic\_programming
- Cache replacement (LRU): https://en.wikipedia.org/wiki/Cache\_replacement\_policies · Maximum subarray (Kadane): https://en.wikipedia.org/wiki/Maximum\_subarray\_problem
- Prefix sum: https://en.wikipedia.org/wiki/Prefix\_sum
- API `RangeError.checkValidRange`: https://api.dart.dev/stable/dart-core/RangeError/checkValidRange.html · API `LinkedHashMap`: https://api.dart.dev/stable/dart-collection/LinkedHashMap-class.html
- Jon Bentley, *Programming Pearls* — teknik algoritmik dan analisis biaya.

---

## 6.6 Biaya Tersembunyi: I/O, Startup, dan Footprint *(TAMBAHAN)*

*Motivasi: algoritma tercepat di dunia tak menolong bila program menghabiskan waktunya menunggu disk.*

> **Mengapa ditambahkan.** Audit menemukan bahwa pembahasan efisiensi sering berhenti di CPU dan Big-O, padahal pada alat baris perintah dan aplikasi data, sebagian besar waktu dan memori habis di I/O, startup, dan alokasi. Modul ini mengajarkan mengukur dari luar (end-to-end) dan mengenali biaya yang tak tampak di dalam kode.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini mengalihkan pandangan dari *fungsi* ke *proses utuh*: ke mana waktu sesungguhnya pergi (CPU, I/O, alokasi/GC, startup) dan berapa memori yang dipakai (*footprint*). Kamu belajar mengukur penggunaan memori dengan `ProcessInfo`, mengukur proses dari terminal, menimbang pola I/O (banyak panggilan kecil vs satu besar, tulis ulang penuh vs log tambah), serta memilih antara JIT dan AOT untuk waktu mulai.

### B. Konsep Kunci & Filosofi Mendalam

- **Waktu = CPU + I/O + alokasi/GC + startup.** Optimasi algoritma hanya menolong bagian CPU. Bila 90% waktu ada di I/O, mempercepat CPU dua kali hanya mempercepat total sedikit (hukum Amdahl, 6.2).
- **I/O jauh lebih lambat dari memori.** Banyak panggilan kecil (tiap baris ditulis dan di-*flush*) lebih mahal daripada satu panggilan besar. **Batching** dan **buffering** adalah penghematan terbesar yang paling murah.
- **Pola I/O menentukan skala.** Menulis ulang seluruh berkas pada tiap perubahan (To-Do v4) berbiaya O(n) per operasi; bagus untuk data kecil, bermasalah untuk data besar. Alternatif: *log tambah-saja* (O(1) per operasi) dengan pemadatan sesekali — pertukaran antara kesederhanaan dan skala.
- **Baca penuh vs mengalir.** Memuat seluruh berkas ke memori memakai memori sebanding ukuran berkas; memprosesnya per potongan menjaga memori konstan. (Pemrosesan aliran asinkron dibahas di Fase 7.)
- **Startup.** `dart run` memakai JIT: mulai cepat untuk pengembangan, tetapi ada biaya kompilasi/pemanasan saat jalan. `dart compile exe` menghasilkan biner AOT: tak butuh SDK dan mulai lebih cepat untuk alat baris perintah, dengan ukuran biner lebih besar dan tanpa kompilasi ulang saat jalan.
- **Footprint memori.** `ProcessInfo.currentRss` dan `maxRss` memberi ukuran memori residen proses. Struktur dengan objek per elemen (`List<int>` berisi boxed object bila besar) lebih boros daripada data bertipe (6.3); riwayat dan cache tak berbatas menambah footprint terus-menerus.
- **GC.** Penata sampah Dart bersifat generasional: objek berumur pendek murah dibersihkan, tetapi bukan gratis; alokasi besar-besaran menaikkan frekuensi dan jeda GC. Kurangi alokasi *di jalur panas* (6.4), setelah terukur.
- **Ukur dari luar.** Di terminal: `time` untuk waktu total, `/usr/bin/time -v` (GNU) untuk memori puncak, dan alat benchmark CLI seperti `hyperfine` untuk perbandingan dengan pemanasan dan statistik.
- **Filosofi:** ukur proses yang pengguna alami, bukan hanya fungsi yang kamu banggakan.
- **Dampak desain:** keputusan arsitektural (format berkas, pola I/O, JIT/AOT, batas cache) sering menyumbang lebih besar daripada mikro-optimasi, dan lebih sulit diubah belakangan.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — mengukur memori proses.**

```dart
import 'dart:io';

void main() {
  final awal = ProcessInfo.currentRss;
  final besar = List<int>.generate(2000000, (i) => i);
  final sesudah = ProcessInfo.currentRss;
  final mib = (sesudah - awal) / (1024 * 1024);
  print('tambahan RSS sekitar ${mib.toStringAsFixed(1)} MiB untuk ${besar.length} elemen');
  print('puncak RSS: ${(ProcessInfo.maxRss / (1024 * 1024)).toStringAsFixed(1)} MiB');
}
```

- `ProcessInfo.currentRss` mengembalikan memori residen proses dalam byte; selisih sebelum dan sesudah membangun struktur memberi perkiraan biayanya.
- Angkanya bergantung mesin dan mode eksekusi; yang penting adalah *perbandingan relatif* (mis. `List<int>` vs `Int32List` untuk jumlah elemen yang sama).

**Contoh 2 — batching keluaran.**

```dart
import 'dart:io';

void tulisSatuSatu(List<String> baris) {
  for (final b in baris) {
    stdout.writeln(b); // banyak panggilan kecil
  }
}

void tulisSekaligus(List<String> baris) {
  final buf = StringBuffer();
  for (final b in baris) {
    buf.writeln(b);
  }
  stdout.write(buf); // satu panggilan besar
}
```

- Ukur keduanya dengan keluaran dialihkan agar tak mengukur kecepatan terminal: `dart compile exe ... && ./bench > /dev/null`.
- Selisihnya bergantung pada apakah `stdout` terhubung ke terminal atau pipa; jangan mengasumsikan — ukur.

**Contoh 3 — log tambah-saja vs tulis ulang penuh.**

```dart
import 'dart:io';

// Tulis ulang penuh (tulisAtomik, 5.5): O(n) per perubahan; sederhana dan aman.
// Alternatif: catat PERISTIWA di akhir berkas, O(1) per perubahan; padatkan sesekali.
void tambahPeristiwa(String jalur, String peristiwa) {
  File(jalur).writeAsStringSync(
    '$peristiwa${Platform.lineTerminator}',
    mode: FileMode.append,
    flush: true,
  );
}
```

- Log tambah-saja menukar kesederhanaan dengan skala: pembacaan awal harus memutar ulang peristiwa (3.6), dan perlu *pemadatan* (membangun snapshot baru dan memangkas log).
- Keputusan ini harus dibuat berdasarkan ukuran data nyata dan frekuensi perubahan, bukan firasat.

**Contoh 4 — mengukur dari terminal.**

```bash
# Waktu total dan memori puncak sebuah proses
time ./todo < masukan.txt
/usr/bin/time -v ./todo < masukan.txt   # GNU time: melaporkan Maximum resident set size

# Benchmark end-to-end dengan pemanasan dan statistik (alat pihak ketiga)
hyperfine --warmup 3 './todo < masukan.txt'

# Bandingkan waktu mulai: JIT vs AOT
time dart run bin/logika_fase6.dart < /dev/null
dart compile exe bin/logika_fase6.dart -o todo && time ./todo < /dev/null
```

- `/dev/null` sebagai masukan memisahkan *waktu mulai* dari pekerjaan nyata.
- Bandingkan JIT dan AOT hanya pada beban yang kamu pedulikan: alat satu kali jalan lebih menikmati AOT; proses panjang yang berat CPU bisa berbeda.

### D. Opsi Kode Lain untuk Logika yang Sama

| Keputusan | Opsi A | Opsi B | Pertimbangan |
| --- | --- | --- | --- |
| Simpan keadaan | Tulis ulang penuh (atomik) | Log tambah-saja + pemadatan | A sederhana dan aman untuk data kecil; B skala untuk data besar/sering |
| Membaca berkas besar | Baca penuh | Proses per potongan | A sederhana; B memori konstan |
| Keluaran banyak baris | Satu per satu | Satu panggilan (buffer) | B biasanya lebih murah; ukur |
| Mode eksekusi alat CLI | JIT (`dart run`) | AOT (`dart compile exe`) | AOT untuk distribusi dan waktu mulai; JIT untuk pengembangan |
| Data numerik besar | `List<int>` | `Int32List` / `Float64List` | Data bertipe lebih padat; perhatikan rentang |

### E. Terminologi Esensial

- **Footprint** — memori yang dipakai proses. **RSS** — *resident set size*, memori fisik yang dipegang proses. **Batching / buffering** — menggabungkan banyak operasi kecil menjadi sedikit yang besar.
- **End-to-end** — diukur dari luar, seperti dialami pengguna. **Log tambah-saja (append-only log)** — mencatat perubahan di akhir tanpa menulis ulang.
- **Pemadatan (compaction)** — menggabungkan log menjadi snapshot dan memangkasnya. **GC generasional** — memisahkan objek muda dan tua untuk pembersihan yang efisien.

### F. Visualisasi (ASCII)

```text
  Ke mana waktu pergi? (bentuk umum; ukur milikmu sendiri)

  proses alat CLI kecil:
  [startup ████████][I/O ████████████████][CPU ██][GC ▏]
                     ▲
                     mempercepat CPU dua kali hampir tak terlihat; batching I/O sangat terasa

  proses komputasi berat:
  [startup ▏][I/O █][CPU ████████████████████████][GC ███]
                     ▲
                     algoritma dan alokasi yang penting
```

```text
  tulis ulang penuh                       log tambah-saja
  ────────────────────                    ─────────────────────────────
  tiap ubah:  [seluruh n item]  O(n)      tiap ubah:  + 1 baris   O(1)
  baca awal:  O(n)                        baca awal:  putar ulang log O(log panjang)
                                          sesekali:   pemadatan (snapshot baru + pangkas)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 6.2 (pengukuran dan Amdahl), 6.3–6.4 (struktur dan alokasi), 5.5 (penulisan atomik), 3.6 (riwayat dan replay).
- **Prasyarat bagi:** 6.7 (studi kasus). **Dikembangkan di:** Fase 7 (I/O asinkron dan aliran memori konstan), Fase 11 (keputusan arsitektur penyimpanan).

### H. Tips & Praktik Terbaik

- Ukur proses dari luar sebelum membongkar kode dari dalam.
- Batch operasi I/O; hindari satu panggilan per baris bila jumlahnya besar.
- Catat batas memori yang kamu rancang (batas riwayat, kapasitas cache) dan ukur RSS puncak pada beban terburuk.
- Distribusikan alat CLI sebagai biner AOT bila waktu mulai atau kemudahan pasang penting.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mengoptimalkan CPU padahal waktu ada di I/O | Tak ada perbaikan terukur | Ukur end-to-end; profil |
| Menulis ulang seluruh berkas tiap perubahan pada data besar | Lambat dan boros I/O | Log tambah-saja + pemadatan, atau skema yang lebih cocok |
| Memuat seluruh berkas besar ke memori | Memori meledak | Proses per potongan |
| Cache atau riwayat tanpa batas | Footprint terus tumbuh | Beri batas, ukur RSS puncak |
| Membandingkan JIT dan AOT tanpa menyadarinya | Kesimpulan keliru | Samakan mode saat membandingkan |
| Mengukur dengan keluaran ke terminal | Mengukur kecepatan terminal | Alihkan keluaran ke `/dev/null` |

### J. Sumber Referensi

- ✔ Dart DevTools (memori, timeline untuk aplikasi baris perintah): https://dart.dev/tools/dart-devtools
- API `ProcessInfo`: https://api.dart.dev/stable/dart-io/ProcessInfo-class.html · `dart compile`: https://dart.dev/tools/dart-compile
- `hyperfine`: https://github.com/sharkdp/hyperfine · GNU `time`: https://man7.org/linux/man-pages/man1/time.1.html
- Garbage collection (konsep): https://en.wikipedia.org/wiki/Garbage\_collection\_(computer\_science)

---

## 6.7 Studi Kasus Terpadu: To-Do v5 *(TAMBAHAN)*

*Motivasi: optimasi yang baik terlihat membosankan — satu versi lambat yang benar, satu versi cepat yang terbukti sama, dan angka yang menjelaskan selisihnya.*

> **Mengapa ditambahkan.** Efisiensi paling mudah dipelajari bila diterapkan pada kode yang sudah kamu kenal. To-Do v5 menambah dua fitur dengan sengaja memakai pola biaya yang berbeda: `cari` (pencarian malas dan terbatas) dan `bersihkan` (penghapusan duplikat dalam dua versi: O(n²) sebagai *oracle* kebenaran dan O(n) sebagai versi produksi). Kita membuktikan keduanya sama, lalu mengukur selisihnya.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Langkah & kode · D Variasi · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Kamu memperluas `lib/todo.dart` dari Fase 5.8: (1) fungsi murni `cari`, `tanpaDuplikatLambat`, dan `tanpaDuplikat`; (2) dua varian `Perintah` baru (`Cari`, `Bersihkan`) beserta pengurai dan eksekutornya; (3) skrip benchmark di `tool/`; (4) tes kesetaraan versi cepat dan lambat pada data acak. `Penyimpan`, `AplikasiTodo`, `Riwayat`, dan seluruh penanganan kegagalan **tidak berubah** — bukti bahwa lapisan-lapisan Fase 4–5 benar-benar terpisah.

### B. Konsep Kunci & Filosofi Mendalam

- **Kebenaran lebih dulu; versi lambat sebagai oracle.** Versi O(n²) yang sederhana dan jelas benar menjadi *acuan*; versi O(n) harus menghasilkan keluaran identik pada data acak dan kasus tepi. Cepat tapi salah tak berguna.
- **Spesifikasi `bersihkan`.** Dua item dianggap duplikat bila `judul.teks`-nya sama persis (huruf besar-kecil dibedakan); yang dipertahankan adalah **kemunculan pertama**, dan urutan relatif tak berubah. Tulis keputusan ini sebelum kode (1.1).
- **`cari` malas dan terbatas.** Generator `sync*` menghasilkan kecocokan satu per satu; `take(21)` mengambil satu lebih dari batas tampilan sehingga kita tahu *apakah ada lagi* tanpa memindai sisa data. Biaya terbaik sebanding dengan lokasi kecocokan, bukan ukuran data; kasus terburuk (tak ada yang cocok) tetap O(n).
- **Efek samping terkontrol di `bersihkan`.** `terlihat.add(x)` mengembalikan `true` hanya untuk elemen baru, sehingga dapat dipakai sebagai syarat di collection-if: idiom ringkas yang bergantung pada urutan evaluasi kiri-ke-kanan (2.1). Dokumentasikan agar tak dikira bug.
- **Biaya setiap perintah** (n = jumlah item): `tambah`, `selesai`, `hapus` — O(n) untuk membuat list baru ditambah O(n) menulis berkas (6.6); `daftar` — O(n); `cari` — O(n) terburuk; `bersihkan` — O(n) waktu, O(n) ruang tambahan; `batal`/`ulang` — O(batas) menyalin daftar rujukan riwayat. Ketika *n* mencapai ratusan ribu, tulis ulang berkas penuh adalah leher botol pertama (6.6).
- **Riwayat dan memori.** Tiap `ubah` menambah satu list ke riwayat (item dibagi, list pembungkusnya baru); `batas` membatasi jumlahnya. Footprint terburuk ≈ `batas` × ukuran list; ukur dengan RSS (6.6).
- **Perubahan yang dipandu kompilator.** Menambah `Cari` dan `Bersihkan` ke `Perintah` yang sealed membuat `jalankan` dan `uraiPerintah` gagal dikompilasi sampai ditangani — pola yang sama dengan Fase 3.7.
- **Dampak desain:** karena inti murni, kedua versi `tanpaDuplikat` dapat dites dan diukur berdampingan tanpa menyentuh disk; karena `Perintah` sealed, fitur baru tak mungkin terlupa di salah satu `switch`.

### C. Langkah, Sintaks, dan Kode

**Langkah 1 — spesifikasi dan tabel biaya.**

| Perintah | Perilaku | Biaya waktu | Ruang tambahan |
| --- | --- | --- | --- |
| `cari <kata>` | Menampilkan nomor dan judul yang mengandung kata (tak peduli huruf besar-kecil), maksimal 20, plus catatan bila masih ada | O(n) terburuk; lebih murah bila kecocokan ada di awal | O(20) |
| `bersihkan` | Membuang item dengan `judul.teks` sama; mempertahankan kemunculan pertama; dapat dibatalkan | O(n) | O(n) (Set) |
| `batal`/`ulang` | Sama seperti Fase 3.7 | O(batas) | O(1) |

| Masukan | Hasil |
| --- | --- |
| `['cari']` | gagal: pemakaian: cari \<kata> |
| `['cari', 'rot']` | `Cari('rot')` |
| `['bersihkan']` | `Bersihkan` |
| `['bersihkan', 'x']` | gagal: perintah ini tidak menerima argumen |

**Langkah 2 — fungsi murni: pencarian malas dan dua versi penghapus duplikat.**

```dart
const int _batasCari = 20;

/// Menghasilkan (nomor berbasis 1, item) untuk tiap kecocokan, SECARA MALAS.
Iterable<(int, Item)> cari(List<Item> daftar, String kata) sync* {
  final k = kata.toLowerCase();
  for (var i = 0; i < daftar.length; i++) {
    if (daftar[i].judul.teks.toLowerCase().contains(k)) {
      yield (i + 1, daftar[i]);
    }
  }
}

/// ORACLE O(n^2): sederhana dan jelas benar; dipakai sebagai acuan di tes.
List<Item> tanpaDuplikatLambat(List<Item> daftar) {
  final hasil = <Item>[];
  for (final item in daftar) {
    var ada = false;
    for (final h in hasil) {
      if (h.judul.teks == item.judul.teks) {
        ada = true;
        break;
      }
    }
    if (!ada) hasil.add(item);
  }
  return hasil;
}

/// PRODUKSI O(n): Set judul yang sudah terlihat; kemunculan pertama dipertahankan.
List<Item> tanpaDuplikat(List<Item> daftar) {
  final terlihat = <String>{};
  return [
    for (final item in daftar)
      if (terlihat.add(item.judul.teks)) item, // add() true hanya untuk judul baru
  ];
}
```

- `cari` adalah generator `sync*` (6.4): memindai hanya sejauh konsumen menarik elemen; `yield (i + 1, daftar[i])` menghasilkan record nomor-item.
- `tanpaDuplikatLambat`: untuk tiap item memindai semua item yang sudah dikumpulkan — O(n²) di kasus terburuk, tetapi sepuluh baris yang mudah dibuktikan benar.
- `tanpaDuplikat`: `Set<String>.add` mengembalikan `true` bila elemen belum ada, sehingga satu lintasan cukup; O(n) waktu, O(n) ruang. Keduanya memakai kunci yang sama (`judul.teks`) sehingga spesifikasinya identik.

**Langkah 3 — perintah baru, pengurai, dan eksekutor.**

```dart
class Cari extends Perintah {
  const Cari(this.kata);
  final String kata;
}

class Bersihkan extends Perintah {
  const Bersihkan();
}

Urai uraiPerintah(List<String> args) => switch (args) {
      [] || ['bantuan'] => const UraiBerhasil(Bantuan()),
      ['daftar'] => const UraiBerhasil(Tampilkan()),
      ['batal'] => const UraiBerhasil(Batal()),
      ['ulang'] => const UraiBerhasil(Ulang()),
      ['bersihkan'] => const UraiBerhasil(Bersihkan()),
      ['daftar' || 'bantuan' || 'batal' || 'ulang' || 'bersihkan', ...] =>
        const UraiGagal('perintah ini tidak menerima argumen'),
      ['tambah'] => const UraiGagal('pemakaian: tambah <judul>'),
      ['tambah', ...final kata] => _uraiTambah(kata),
      ['cari'] => const UraiGagal('pemakaian: cari <kata>'),
      ['cari', ...final kata] => UraiBerhasil(Cari(kata.join(' '))),
      ['selesai', final teks] => _uraiNomor(teks, Selesai.new),
      ['hapus', final teks] => _uraiNomor(teks, Hapus.new),
      ['selesai' || 'hapus', ...] =>
        const UraiGagal('pemakaian: selesai atau hapus diikuti <nomor>'),
      _ => UraiGagal('perintah tidak dikenal: ${args.first}'),
    };

List<String> _hasilCari(List<Item> daftar, String kata) {
  // Ambil satu lebih dari batas: cukup untuk tahu apakah masih ada tanpa memindai sisanya.
  final cocok = cari(daftar, kata).take(_batasCari + 1).toList();
  if (cocok.isEmpty) return const ['tidak ada yang cocok'];
  return [
    for (final (nomor, item) in cocok.take(_batasCari))
      '$nomor. ${item.judul.teks}',
    if (cocok.length > _batasCari) '... (ada lagi; persempit kata pencarian)',
  ];
}

(Riwayat<List<Item>>, List<String>) _bersihkan(Riwayat<List<Item>> r) {
  final bersih = tanpaDuplikat(r.kini);
  final dibuang = r.kini.length - bersih.length;
  if (dibuang == 0) return (r, const ['tidak ada duplikat']);
  return (r.ubah(bersih), ['dibuang: $dibuang duplikat']);
}

// Tambahkan dua kasus ke switch di jalankan(...), sebelum penutupnya:
//   Cari(:final kata) => (r, _hasilCari(daftar, kata)),
//   Bersihkan() => _bersihkan(r),
```

- `uraiPerintah` yang baru menambah empat baris; urutan kasus mempertahankan prinsip dari 2.7 (spesifik dulu, penampung belakangan).
- `_hasilCari` memakai `take(_batasCari + 1)`: bila hasil berjumlah 21, kita tahu ada lagi dan menampilkan catatan; bila kurang, seluruhnya sudah tertampil — tanpa memindai sisa data.
- `_bersihkan` mengembalikan `r` yang *sama* bila tak ada yang dibuang (supaya `AplikasiTodo.proses` tak menulis, 5.8) dan `r.ubah(bersih)` bila ada — sehingga `batal` dapat membatalkannya.
- Dua baris komentar di akhir menunjukkan kasus baru pada `switch (perintah)` di `jalankan`; kompilator menolak program sampai keduanya ditambahkan.

**Langkah 4 — benchmark (`tool/bench_v5.dart`).**

```dart
import 'dart:math';

import 'package:logika_fase6/todo.dart';

import 'ukur.dart'; // berisi median() dan ukur() dari modul 6.2

List<Item> buatData(int n, {required int ragam, int benih = 7}) {
  final acak = Random(benih);
  return [
    for (var i = 0; i < n; i++)
      Item(Judul.dari('tugas ${acak.nextInt(ragam)}')),
  ];
}

int _sink = 0;

void main() {
  for (final n in [2000, 4000, 8000, 16000]) {
    final data = buatData(n, ragam: n); // sebagian besar judul unik
    final lambat = ukur(() => _sink += tanpaDuplikatLambat(data).length);
    final cepat = ukur(() => _sink += tanpaDuplikat(data).length);
    final rasio = lambat / cepat;
    print('n=$n lambat=${lambat.toStringAsFixed(0)}us '
        'cepat=${cepat.toStringAsFixed(0)}us rasio=${rasio.toStringAsFixed(1)}x');
  }
  print('sink=$_sink');
}
```

```bash
dart compile exe tool/bench_v5.dart -o bench_v5 && ./bench_v5
```

- `ragam: n` membuat sebagian besar judul unik, sehingga versi lambat benar-benar berbiaya kuadratik; dengan `ragam` kecil, jumlah item unik kecil dan versi lambat tampak linear — pelajaran tentang *memilih data uji yang mewakili kasus terburuk*.
- Harness `ukur` dengan pemanasan dan median dari 6.2; hasil ditampung di `_sink` dan dicetak.
- **Pola yang diharapkan** (bukan angka pasti — bergantung mesin): setiap *n* digandakan, waktu versi lambat naik sekitar 4×, versi cepat sekitar 2×, sehingga `rasio` terus membesar. Itu yang kamu cari: *bentuk pertumbuhan*, bukan angka mutlak.

**Langkah 5 — tes kebenaran dan perilaku (`test/efisiensi_test.dart`).**

```dart
import 'package:logika_fase6/todo.dart';
import 'package:test/test.dart';

import '../tool/data.dart'; // memuat buatData() agar dipakai bersama

void main() {
  group('efisiensi dan kebenaran', () {
    test('versi cepat dan lambat identik pada data acak', () {
      for (var benih = 0; benih < 50; benih++) {
        final data = buatData(200, ragam: 50, benih: benih);
        expect(tanpaDuplikat(data), tanpaDuplikatLambat(data));
      }
    });

    test('mempertahankan kemunculan pertama dan urutan', () {
      final d = [
        Item(Judul.dari('a')),
        Item(Judul.dari('b'), selesai: true),
        Item(Judul.dari('a'), selesai: true),
      ];
      expect(tanpaDuplikat(d), [d[0], d[1]]);
    });

    test('cari bersifat malas dan terbatas', () {
      final data = buatData(100, ragam: 10); // judul tugas 0 sampai tugas 9
      final hasil = cari(data, 'tugas 7').take(3).toList();
      expect(hasil, hasLength(3));
      expect(hasil.every((e) => e.$2.judul.teks == 'tugas 7'), isTrue);
    });

    test('perintah cari dan bersihkan melalui jalankan', () {
      var r = Riwayat<List<Item>>.mulai(<Item>[]);
      for (final j in ['roti', 'susu', 'roti']) {
        (r, _) = jalankan(r, Tambah(Judul.dari(j)));
      }
      final (_, keluaran) = jalankan(r, const Cari('rot'));
      expect(keluaran, ['1. roti', '3. roti']);

      final (r2, info) = jalankan(r, const Bersihkan());
      expect(info.single, 'dibuang: 1 duplikat');
      expect(r2.kini.map((i) => i.judul.teks), ['roti', 'susu']);
      expect(r2.undo().kini, hasLength(3)); // dapat dibatalkan
    });
  });
}
```

- Tes pertama adalah inti: **tes kesetaraan versi cepat vs oracle** pada 50 data acak (benih berbeda) dengan banyak duplikat (`ragam: 50` pada 200 item).
- `buatData` dipindah ke `tool/data.dart` agar dipakai bersama oleh benchmark dan tes.
- Tes terakhir membuktikan perilaku lewat `jalankan` (murni, tanpa disk), termasuk bahwa `bersihkan` dapat dibatalkan.

### D. Variasi Kode untuk Logika yang Sama

```dart
// Alternatif A: deduplikasi dengan LinkedHashMap (kunci judul -> item pertama).
List<Item> tanpaDuplikatMap(List<Item> daftar) {
  final peta = <String, Item>{};
  for (final item in daftar) {
    peta.putIfAbsent(item.judul.teks, () => item);
  }
  return peta.values.toList();
}

// Alternatif B: urutkan lalu pindai. O(n log n); MENGUBAH urutan tampilan, jadi kurang cocok di sini.
```

| Pendekatan | Waktu | Ruang | Mempertahankan urutan? | Catatan |
| --- | --- | --- | --- | --- |
| Bersarang (oracle) | O(n²) | O(n) | Ya | Mudah dibuktikan; untuk tes |
| `Set` terlihat (dipilih) | O(n) | O(n) | Ya | Idiom ringkas; efek samping terkontrol |
| `Map.putIfAbsent` | O(n) | O(n) | Ya (urutan penyisipan) | Lebih eksplisit tentang item yang dipertahankan |
| Urutkan + pindai | O(n log n) | O(1)–O(n) | Tidak | Mengubah urutan; `sort` tak stabil |

| Perintah `cari` | Waktu | Catatan |
| --- | --- | --- |
| Pindai linear malas (dipilih) | O(n) terburuk | Sederhana; cukup untuk puluhan ribu item |
| Indeks kata → daftar indeks | O(1) per kata setelah indeks | Biaya memelihara indeks saat `ubah`, `hapus`, `batal` (Latihan 8) |

### E. Terminologi Esensial

- **Oracle** — implementasi acuan yang jelas benar untuk membandingkan versi yang dioptimalkan. **Tes kesetaraan** — membuktikan dua implementasi menghasilkan keluaran sama pada banyak masukan.
- **Data uji yang mewakili** — data yang memicu kasus yang ingin diukur (banyak unik untuk kasus kuadratik). **Rasio** — perbandingan waktu dua versi; makin besar *n*, makin melebar bila kelas biaya berbeda.
- **Pencarian malas terbatas** — menarik hanya sebanyak yang akan ditampilkan (plus satu untuk mengetahui sisa).

### F. Visualisasi (ASCII)

```text
   n (item)      tanpaDuplikatLambat O(n²)      tanpaDuplikat O(n)
   ────────      ─────────────────────────      ─────────────────────
    2.000        ████                           █
    4.000        ████████████████               ██               (n ×2 → lambat ×4, cepat ×2)
    8.000        ████████████████████████...    ████
   16.000        (jauh lebih lama)              ████████

   (gambaran bentuk pertumbuhan, bukan hasil ukur)
```

```text
   tanpaDuplikatLambat  ──┐
                          ├──► tes: keluaran IDENTIK pada 50 data acak  ──► baru boleh dipakai versi cepat
   tanpaDuplikat        ──┘
          │
          └──► benchmark (n = 2k, 4k, 8k, 16k): ukur bentuk pertumbuhan, bukan angka mutlak
```

### G. Hubungan dengan Modul Lain

- **Memakai:** seluruh Fase 6 (6.1 biaya, 6.2 pengukuran, 6.3 struktur data, 6.4 generator dan pipeline malas, 6.5 teknik algoritmik dan tes kesetaraan, 6.6 biaya tersembunyi), serta Fase 5 (`AplikasiTodo`, penulisan atomik), Fase 3 (riwayat), dan Fase 2 (sealed, pola).
- **Dikembangkan di:** Fase 7 (menjalankan pekerjaan berat di isolate agar antarmuka tak membeku), Fase 10 (property-based test untuk kesetaraan versi cepat dan lambat, dan benchmark sebagai bagian CI), Fase 11 (memisahkan indeks pencarian sebagai modul sendiri).

### H. Tips & Praktik Terbaik

- Mulai dari versi sederhana yang benar; jadikan ia oracle sebelum menulis versi cepat.
- Pilih data uji yang memicu kasus terburuk yang kamu khawatirkan, dan ukur pada beberapa ukuran.
- Perhatikan *bentuk* pertumbuhan (rasio melebar atau tidak), bukan angka mutlak.
- Dokumentasikan biaya tiap perintah di tabel; tabel itu menjadi peta keputusan optimasi berikutnya.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mengoptimalkan tanpa tes kesetaraan | Versi cepat salah diam-diam | Oracle + tes data acak |
| Data uji dengan terlalu banyak duplikat | Versi lambat tampak linear | Pakai data dengan banyak unik untuk kasus kuadratik |
| Menyimpulkan dari satu ukuran *n* | Salah membaca pertumbuhan | Ukur 4 ukuran atau lebih dan bandingkan rasio |
| Menjalankan benchmark di JIT dengan asserts | Angka tak mewakili produksi | AOT tanpa asserts |
| `cari` yang memindai sisa data hanya untuk menghitung | Biaya O(n) tak perlu | `take(batas + 1)` |
| Mengubah urutan saat dedup | Tampilan berubah mengejutkan | Pertahankan urutan; tulis di spesifikasi |
| Lupa bahwa tulis ulang berkas tetap O(n) tiap perubahan | Leher botol baru di data besar | Lihat 6.6: log tambah-saja + pemadatan |

### J. Sumber Referensi

- ✔ Dart DevTools (profiling baris perintah): https://dart.dev/tools/dart-devtools
- ✔ Changelog `package:collection`: https://pub.dev/packages/collection/changelog
- `benchmark_harness`: https://pub.dev/packages/benchmark\_harness · ✔ sumber `BenchmarkBase`: https://dart.googlesource.com/tools.git/+/03f2c205/pkgs/benchmark\_harness/lib/src/benchmark\_base.dart
- Test Oracle (konsep): https://en.wikipedia.org/wiki/Test\_oracle · Differential testing: https://en.wikipedia.org/wiki/Differential\_testing

---

## Latihan Fase 6 (sengaja tanpa kunci jawaban)

Kerjakan sendiri, ukur di mode yang tepat (AOT, tanpa `--enable-asserts`), lalu commit dengan struktur `fase-6/latihan-N/` berisi `README.md` (spesifikasi, tabel contoh, dan **tabel hasil pengukuran beserta konfigurasinya**), `lib/`, `tool/`, dan `test/`.

1. **\[6.1\]** Tulis penghitung operasi untuk tiga algoritma pencari duplikat (loop bersarang, urutkan-lalu-pindai, `Set`). Tabulasikan jumlah operasi untuk *n* = 1.000 sampai 64.000 dan jelaskan bentuk pertumbuhan tiap algoritma tanpa memakai pengukuran waktu.
2. **\[6.2\]** Perbaiki harness 6.2: tambahkan ukuran sebaran (min, maks, rentang antarkuartil), penanda hasil tak stabil, dan `sink`. Ukur `irisanLambat` vs `irisanCepat` pada JIT dan AOT, lalu tulis laporan satu halaman: apa yang berubah antarmode, dan mengapa.
3. **\[6.3\]** Untuk lima beban kerja (antrean tugas, cache LRU, papan peringkat top-k, deduplikasi, pencarian awalan), pilih struktur data dan justifikasi lewat operasi dominan. Buktikan dengan benchmark atas dua struktur alternatif untuk tiap beban.
4. **\[6.4\]** Ubah pipeline eager empat langkah menjadi satu lintasan malas; hitung jumlah pemanggilan predikat sebelum dan sesudah. Tulis satu contoh bug akibat iterable malas berefek samping, dan perbaikannya.
5. **\[6.5\]** Implementasikan `memoLru` dengan statistik (hit/miss) dan kebijakan kedaluwarsa waktu (jam disuntikkan). Uji bahwa memori tak melebihi kapasitas dan entri kedaluwarsa dibuang.
6. **\[6.5\]** Tulis versi O(n) untuk "jumlah subarray dengan jumlah tepat k" (prefix sum + `Map`) dan versi brute-force sebagai oracle. Uji kesetaraan pada data acak dan tulis spesifikasi untuk kasus jawaban tak unik.
7. **\[6.6\]** Ukur footprint (RSS) `List<int>`, `Int32List`, dan `BoolList` untuk lima juta elemen; ukur waktu mulai alat CLI-mu pada JIT vs AOT. Tulis kapan setiap keputusan dibenarkan.
8. **\[6.7\]** Tambahkan ke To-Do v5 indeks pencarian (kata → daftar nomor) yang dijaga konsisten dengan riwayat. Buktikan manfaatnya dengan benchmark dan jelaskan biaya memelihara indeks saat `tambah`, `hapus`, dan `batal`.

---

## Ringkasan Fase 6 & Daftar Periksa Kelulusan

| Modul | Satu kalimat inti |
| --- | --- |
| 6.1 | Hitung biaya dalam *n*; waspadai kuadratik tersembunyi dan pahami amortisasi. |
| 6.2 | Ukur dengan pemanasan, banyak sampel, median, dan `sink`; di mode yang tepat; profil sebelum mengoptimalkan. |
| 6.3 | Pilih struktur dari operasi dominan: `List`, `Set`, `Map`, `Queue`, `PriorityQueue`, data bertipe. |
| 6.4 | Tunda pekerjaan (malas), materialisasi sekali, dan bangun data dengan alokasi minimal. |
| 6.5 | Memoization berbatas dan teknik algoritmik mengubah kelas biaya — dengan syarat kebenaran dan oracle. |
| 6.6 | Waktu dan memori sering habis di I/O, startup, dan alokasi; ukur proses dari luar. |
| 6.7 | Versi lambat yang benar sebagai oracle, versi cepat yang terbukti sama, dan angka yang menjelaskan pertumbuhan. |

**Daftar periksa kelulusan** (jawab tanpa membuka dokumen):

- [ ] Aku bisa menentukan kompleksitas waktu dan ruang sebuah fungsi dan mengenali kuadratik tersembunyi.
- [ ] Aku bisa menjelaskan biaya amortisasi `List.add` dan mengapa `removeAt(0)` mahal.
- [ ] Aku bisa merancang benchmark yang jujur: pemanasan, median, `sink`, mode AOT tanpa asserts.
- [ ] Aku bisa menjelaskan apa yang bisa dan tak bisa dilihat DevTools pada aplikasi baris perintah, dan cara membuka layanan VM.
- [ ] Aku bisa memilih struktur data dari operasi dominan dan menjelaskan trade-off-nya.
- [ ] Aku bisa menjelaskan mengapa `List.sort` tak stabil dan kapan memakai `sortedBy`.
- [ ] Aku bisa menunjukkan perbedaan iterable malas dan materialisasi dengan menghitung pemanggilan predikat.
- [ ] Aku bisa menulis memoization berbatas (LRU) dan menjelaskan syarat kebenarannya.
- [ ] Aku bisa menukar O(n²) dengan O(n) lewat hashing atau prefix sum, dan menguji kesetaraannya dengan oracle.
- [ ] Aku bisa mengukur footprint dan waktu mulai sebuah proses dari terminal.
- [ ] Delapan latihan sudah di-commit dengan tabel hasil ukur beserta konfigurasinya.

**Pratinjau Fase 7 — Logika Asinkron & Konkurensi.** Event loop dan dua antrean (microtask dan event); `Future`, `async`/`await`, dan penanganan galat asinkron; `Stream`, `async*`, dan *backpressure*; `Completer`; timeout dan pembatalan; `Isolate` dan `Isolate.run` untuk pekerjaan berat CPU; komunikasi lewat pesan; serta kondisi balapan yang tetap mungkin terjadi pada titik `await`. Prasyaratnya adalah daftar periksa di atas terpenuhi.

---

## Referensi Induk Fase 6

> **Catatan verifikasi.** Tanda ✔ berarti halaman tersebut dibuka dan diverifikasi lewat pencarian atau pengambilan halaman saat dokumen ini disusun (15 November 2026); beberapa dibuka melalui sumber kode resmi dengan jalur yang sama. Tautan tanpa tanda adalah halaman resmi atau baku yang stabil, tetapi belum diverifikasi ulang; bila ada yang berpindah, cari judulnya di dart.dev, pub.dev, atau dokumentasi API.

**Dokumentasi resmi Dart dan paket**

- ✔ Dart DevTools: https://dart.dev/tools/dart-devtools · `dart compile`: https://dart.dev/tools/dart-compile
- ✔ Changelog `package:collection`: https://pub.dev/packages/collection/changelog · `PriorityQueue`: https://pub.dev/documentation/collection/latest/collection/PriorityQueue-class.html
- `benchmark_harness`: https://pub.dev/packages/benchmark\_harness · ✔ `benchmark_harness_plus`: https://pub.dev/packages/benchmark\_harness\_plus
- API: https://api.dart.dev/stable/dart-core/List-class.html · https://api.dart.dev/stable/dart-core/Iterable-class.html · https://api.dart.dev/stable/dart-core/StringBuffer-class.html · https://api.dart.dev/stable/dart-collection/dart-collection-library.html · https://api.dart.dev/stable/dart-typed\_data/dart-typed\_data-library.html · https://api.dart.dev/stable/dart-io/ProcessInfo-class.html

**Konsep dan teori**

- Big-O: https://en.wikipedia.org/wiki/Big\_O\_notation · Amortized analysis: https://en.wikipedia.org/wiki/Amortized\_analysis · Big-O Cheat Sheet: https://www.bigocheatsheet.com/
- Memoization: https://en.wikipedia.org/wiki/Memoization · Dynamic programming: https://en.wikipedia.org/wiki/Dynamic\_programming · Cache replacement: https://en.wikipedia.org/wiki/Cache\_replacement\_policies
- Vyacheslav Egorov, *Microbenchmarking Dart* (bagian 1): https://mrale.ph/blog/2021/01/21/microbenchmarking-dart-part-1.html · Hukum Amdahl: https://en.wikipedia.org/wiki/Amdahl%27s\_law
- Test oracle: https://en.wikipedia.org/wiki/Test\_oracle · `hyperfine`: https://github.com/sharkdp/hyperfine

**Buku bacaan lanjutan (tanpa tautan)**

- J. Bentley, *Programming Pearls* — teknik algoritmik dan cara berpikir tentang biaya.
- T. Cormen dkk., *Introduction to Algorithms* — fondasi analisis algoritma dan struktur data.
- B. Gregg, *Systems Performance* — mengukur dan menganalisis performa sistem secara menyeluruh.

---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-7/README.md

<!----------------------------------------------------->

[0]: ./README.md
[1]: ./
[2]: ./
[3]: ./
[4]: ./
[5]: ./
[6]: ./
[7]: ./
[8]: ./
[9]: ./
[10]: ./
[11]: ./
[12]: ./
[13]: ./
[14]: ./
[15]: ./
[16]: ./
[17]: ./
[18]: ./

