# Membangun Logika Dart — Fase 3: Pemodelan Data & State

*Dari data yang mudah rusak menjadi nilai yang dapat dipercaya: identitas vs nilai, imutabilitas, tipe domain, dan state sebagai transisi.*

| Atribut | Keterangan |
| --- | --- |
| Level | Intermediate |
| Estimasi waktu | 3 minggu, ±35–45 jam (teori ±30%, praktik ±70%) |
| Prasyarat | Fase 2 selesai (daftar periksa kelulusan terpenuhi, latihan di-commit) |
| Alat esensial | Dart SDK stabil (rilis stabil per 13 November 2026: 3.14, dirilis 11 November 2026), `dart analyze`, `dart test`, `package:collection`, `package:meta` |
| Batas versi fitur | Record dan pola: Dart ≥ 3.0 · extension types: ≥ 3.3 · primary constructors: ≥ 3.13 |
| Komunitas | https://dart.dev/community · tag `dart` di https://stackoverflow.com/questions/tagged/dart · proposal bahasa di https://github.com/dart-lang/language |
| Sertifikasi | Tidak ada sertifikasi resmi khusus; portofolio repositori dengan test dan tabel contoh lebih bernilai |

**Hasil pembelajaran Fase 3** — setelah fase ini kamu mampu:

1. membedakan identitas dari nilai, dan menulis `==` serta `hashCode` yang memenuhi kontraknya;
2. merancang tipe imutabel (dangkal maupun dalam) dan memperbaruinya dengan salinan, bukan mutasi;
3. memilih antara record, class, dan extension type untuk sebuah data, beserta alasannya;
4. mengekspos koleksi dengan aman memakai view, snapshot, atau salinan, sesuai prinsip hak akses minimum;
5. membuat keadaan ilegal tak mungkin direpresentasikan dengan `sealed`, `enum`, dan tipe tervalidasi;
6. memodelkan state sebagai fungsi murni `(State, Event) → State` dan menambahkan undo/redo dengan riwayat imutabel.

---

<details>
  <summary>📃 Daftar Isi</summary>

## Daftar Isi Fase 3

- **0. Audit Kurikulum & Sambungan dari Fase 2**
- **3.1 Identitas vs Nilai:** `==`, `identical`, `hashCode`, dan kontraknya
- **3.2 Imutabilitas & `const`:** dangkal vs dalam, konstanta kanonik, pembaruan lewat salinan
- **3.3 Value Object, Record, dan `copyWith`**
- **3.4 Koleksi sebagai Nilai:** kesetaraan, view vs snapshot, hak akses minimum
- **3.5 Membuat Keadaan Ilegal Tak Mungkin Direpresentasikan**
- **3.6 State sebagai Transisi: Reducer dan Riwayat** *(TAMBAHAN)*
- **3.7 Studi Kasus Terpadu: To-Do v2** *(TAMBAHAN)*
- **Latihan (tanpa kunci jawaban), Ringkasan, dan Referensi Induk**

</details>

---

## 0. Audit Kurikulum & Sambungan dari Fase 2

1. **Sambungan.** Fase 1 sudah menyentuh aliasing dan bug `a == b` pada list (modul 1.2 dan latihan 7), Fase 2 membangun `sealed class` dan inti murni. Fase 3 memberi fondasi *mengapa* keduanya bekerja: nilai yang imutabel dengan kesetaraan yang benar. Tidak ada lompatan yang memutus alur.
2. **Peta fase tetap.** Tidak ada perubahan urutan; hanya penegasan bahwa Fase 3 memakai tiga fitur bahasa baru sebagai alat desain: record (3.0), extension types (3.3), dan primary constructors (3.13).
3. **TAMBAHAN:** modul 3.6 (state sebagai transisi dan riwayat) dan 3.7 (studi kasus To-Do v2). Kurikulum lazim berhenti pada *bentuk* data; padahal logika yang aman juga menuntut kejelasan tentang *bagaimana data berubah dari waktu ke waktu*.
4. **Catatan versi terkini.** Primary constructors (stabil di Dart 3.13) memangkas boilerplate deklarasi class, **tetapi tidak membuat `==` dan `hashCode` otomatis**; tim Dart menyebut semantik nilai (data class) sebagai topik yang dieksplorasi terpisah. Jadi kontrak kesetaraan tetap tanggung jawabmu (3.1, 3.3).
5. **Refactor dari Fase 2.** Studi kasus 3.7 mengubah `Item` dari Fase 2.7 agar memakai tipe tervalidasi dan kesetaraan nilai; kamu akan melihat kompilator menunjukkan setiap tempat yang perlu diperbarui.
6. **Tidak ada koreksi substansial** pada materi Fase 2.

> **Cara memakai dokumen ini** tetap sama: baca, tulis ulang dari ingatan, jalankan, bandingkan. Latihan di akhir tanpa kunci jawaban.

---

## 3.1 Identitas vs Nilai

*Motivasi: sebelum bertanya apakah dua benda sama, tanyakan dulu: sama dalam arti apa?*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membedakan **identitas** (apakah dua referensi menunjuk *objek yang sama*) dari **nilai** (apakah isinya *setara*). Kamu belajar kontrak `==` dan `hashCode`, mengapa `Set` dan `Map` bergantung pada keduanya, dan bagaimana kesalahan kecil di sini menghasilkan duplikat gaib, pencarian yang gagal, dan kunci yang "hilang". Ini fondasi seluruh pemodelan data.

### B. Konsep Kunci & Filosofi Mendalam

- **Identitas:** `identical(a, b)` benar bila `a` dan `b` adalah objek yang sama persis. **Nilai:** `a == b` benar bila isinya dianggap setara menurut kelasnya.
- **Bawaan `Object.==` adalah identitas.** Kelas buatanmu, `List`, `Set`, dan `Map` secara bawaan *tidak* setara walau isinya sama. `String` dan angka setara menurut nilai; **record** setara menurut struktur (bentuk dan nilai field-nya sama; urutan field bernama tidak berpengaruh).
- **Kontrak `==`:** (1) *refleksif* — `a == a`; (2) *simetris* — `a == b` berarti `b == a`; (3) *transitif* — `a == b` dan `b == c` berarti `a == c`; (4) *konsisten* — hasil sama selama objek tidak berubah; (5) tidak pernah menganggap `null` setara dengan objek non-null.
- **Kontrak `hashCode`:** bila `a == b` maka `a.hashCode == b.hashCode`. Kebalikannya tidak wajib. `Set` dan `Map` memakai `hashCode` untuk memilih "ember" lalu `==` untuk memastikan; bila salah satunya keliru, objek bisa muncul ganda atau tak ditemukan.
- **Dua lint inti:** `hash_and_equals` (bila menimpa `==`, timpa juga `hashCode`) dan `avoid_equals_and_hash_code_on_mutable_classes` (jangan menimpa keduanya pada kelas yang tidak bertanda `@immutable`). Alasannya: kesetaraan berdasar field yang bisa berubah adalah bom waktu.
- **Kunci yang bermutasi.** Objek yang dimasukkan sebagai kunci `Map` lalu diubah akan terletak di ember yang salah; pencariannya gagal walau entrinya masih ada.
- **Jebakan `double`:** `double.nan == double.nan` bernilai `false`, sehingga kesetaraan field berisi NaN melanggar refleksivitas. Putuskan perilaku NaN di spesifikasi.
- **Subtipe.** Memakai `other is Kopi` dapat membuat `==` tak simetris bila ada subkelas; pemeriksaan `other.runtimeType == runtimeType` menjaga simetri.
- **Filosofi:** kesetaraan adalah keputusan desain, bukan kebetulan implementasi. Tulis di dokumentasi: *dua `X` dianggap sama bila ...*.
- **Dampak desain:** `Set<Kopi>` yang berisi "duplikat" atau `Map` yang mengembalikan `null` untuk kunci yang jelas ada hampir selalu berakar dari kesetaraan yang keliru.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — identitas vs nilai pada tipe bawaan.**

```dart
void main() {
  final a = [1, 2];
  final b = [1, 2];
  print(a == b); // false: List memakai kesetaraan identitas
  print(identical(a, a)); // true

  print('ab' == 'a' + 'b'); // true: String memakai kesetaraan nilai
  print((1, 2) == (1, 2)); // true: record memakai kesetaraan struktural

  const c = [1, 2];
  const d = [1, 2];
  print(identical(c, d)); // true: konstanta kanonik (satu objek untuk nilai sama)
}
```

- `==` pada list membandingkan *objek*, bukan isi; itulah sumber bug `a == b` pada Fase 1.
- Record `(1, 2) == (1, 2)` benar karena bentuk dan nilai field sama.
- `const [1, 2]` yang sama dikanonikalisasi menjadi satu objek, sehingga `identical` benar.

**Contoh 2 — kelas tanpa `==`: duplikat di `Set`.**

```
class Kopi {
  Kopi(this.nama);
  final String nama;
}

void main() {
  final menu = {Kopi('latte'), Kopi('latte')};
  print(menu.length); // 2: dua objek berbeda, walau nama sama
  print(menu.contains(Kopi('latte'))); // false
}
```

**Contoh 3 — kesetaraan nilai yang benar.**

```dart
import 'package:meta/meta.dart';

@immutable
class Kopi {
  const Kopi(this.nama);
  final String nama;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Kopi && other.runtimeType == runtimeType && other.nama == nama;

  @override
  int get hashCode => Object.hash(runtimeType, nama);
}

void main() {
  final menu = {const Kopi('latte'), const Kopi('latte')};
  print(menu.length); // 1
  print(menu.contains(const Kopi('latte'))); // true
}
```

- `@immutable` — anotasi dari `package:meta` (tambahkan dengan `dart pub add meta`) yang menandai kelas imutabel dan menenangkan lint kesetaraan.
- `identical(this, other) ||` — jalan pintas: objek yang sama pasti setara (menjaga refleksivitas).
- `other is Kopi && other.runtimeType == runtimeType && other.nama == nama` — periksa tipe, periksa tipe persis, lalu bandingkan field; promosi tipe (modul 2.3) membuat `other.nama` sah.
- `Object.hash(runtimeType, nama)` — menggabungkan beberapa nilai menjadi satu hash yang konsisten dengan `==`; jangan menjumlahkan hash manual.

**Contoh 4 — kunci yang bermutasi.**

```dart
class Kunci {
  Kunci(this.id);
  int id; // MUTABEL — ini sumber masalah

  @override
  bool operator ==(Object other) => other is Kunci && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

void main() {
  final k = Kunci(1);
  final peta = {k: 'satu'};
  k.id = 2; // mutasi SETELAH dimasukkan sebagai kunci
  print(peta[k]); // umumnya null: hash baru menunjuk ember lain
  print(peta[Kunci(1)]); // umumnya null: kunci tersimpan kini bernilai 2
  print(peta.length); // 1: entri masih ada, tapi tak dapat ditemukan
}
```

- Kedua pencarian gagal untuk alasan berbeda; hasil persisnya bergantung pada implementasi tabel hash, sehingga perilakunya *tidak dapat diandalkan* — itulah inti masalahnya.
- Obatnya: kelas yang memakai `==`/`hashCode` harus imutabel (modul 3.2).

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// 1) Record sebagai kunci: kesetaraan struktural gratis, tanpa boilerplate.
final pesanan = <(String, int), double>{('latte', 2): 45000.0};

// 2) Perbandingan NaN-aman untuk field double.
bool samaDouble(double a, double b) => a == b || (a.isNaN && b.isNaN);
```

| Pendekatan | Kelebihan | Kekurangan |
| --- | --- | --- |
| Tulis `==` + `hashCode` sendiri | Kontrol penuh, tanpa dependensi | Boilerplate; mudah lupa field baru |
| Record | Kesetaraan dan `hashCode` otomatis | Tak ada nama tipe, validasi, atau method (3.3) |
| Paket pihak ketiga (mis. `equatable`) atau generator kode | Mengurangi boilerplate | Dependensi tambahan; belum menjadi fitur bahasa |
| Bergantung pada identitas bawaan | Tak perlu kode | Duplikat gaib dan pencarian gagal |

### E. Terminologi Esensial

- **Identitas / nilai** — objek yang sama / isi yang setara. **Kesetaraan struktural** — setara bila bentuk dan field-nya setara (record).
- **Kontrak `==`** — refleksif, simetris, transitif, konsisten. **Kontrak `hashCode`** — objek setara harus berhash sama.
- **Tabel hash / ember (bucket)** — struktur di balik `Set` dan `Map`. **Kanonikal** — satu objek untuk semua nilai konstan yang sama.
- **Imutabel** — tidak berubah setelah dibuat. **Kolisi hash** — dua objek berbeda berhash sama (wajar, ditangani oleh `==`).

### F. Visualisasi (ASCII)

```text
 IDENTITAS (identical)                NILAI (==)

  a ──► [objek #1]                    a ──► [ 1, 2 ]
  b ──► [objek #1]   → identik        b ──► [ 1, 2 ]   → setara jika kelas MENENTUKANNYA

  a ──► [ 1, 2 ]
  b ──► [ 1, 2 ]     → bukan identik, dan List TIDAK setara (a == b adalah false)
```

```text
 Set / Map mencari objek x:

   x.hashCode ──► ember ke-n ──► bandingkan x == tiap isi ember ──► ketemu / tidak

   hashCode salah  → ember salah → tidak ketemu (padahal ada)
   == salah        → ember benar → tak dianggap sama (duplikat)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 1.2 (aliasing, list tak setara), 2.5 (record dan pola), 1.5 (kontrak).
- **Prasyarat bagi:** 3.2–3.4 (nilai imutabel dan koleksi) dan 3.7. **Dikembangkan di:** Fase 6 (biaya hash dan pencarian), Fase 10 (property-based test untuk hukum kesetaraan).

### H. Tips & Praktik Terbaik

- Aktifkan lint `hash_and_equals` dan `avoid_equals_and_hash_code_on_mutable_classes` di `analysis_options.yaml` (modul 1.7).
- Tulis test hukum kesetaraan: refleksif, simetris, transitif, dan `hashCode` sama untuk objek setara.
- Gunakan `Object.hash` dan `Object.hashAll`; hindari rumus hash buatan sendiri.
- Dokumentasikan arti kesetaraan di doc comment kelasmu.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Menimpa `==` tanpa `hashCode` | `Set`/`Map` berperilaku ganjil | Selalu timpa keduanya (lint `hash_and_equals`) |
| `==` pada kelas yang field-nya bisa berubah | Kunci `Map` hilang | Jadikan kelas imutabel dan beri `@immutable` |
| Membandingkan list dengan `==` | Selalu `false` untuk list berbeda | Pakai `ListEquality` (3.4) atau record |
| Lupa field baru di `==`/`hashCode` | Dua objek berbeda dianggap sama | Test kesetaraan per field; pertimbangkan generator |
| `other is X` tanpa pemeriksaan tipe persis pada kelas yang bisa diwarisi | `==` tidak simetris | Tambahkan `other.runtimeType == runtimeType` atau tutup warisan dengan `final class` |

### J. Sumber Referensi

- ✔ Record dan kesetaraan struktural: https://dart.dev/language/records
- ✔ Lint `hash_and_equals`: https://dart.dev/tools/linter-rules/hash\_and\_equals
- ✔ Lint `avoid_equals_and_hash_code_on_mutable_classes`: https://dart.dev/lints/avoid\_equals\_and\_hash\_code\_on\_mutable\_classes
- Effective Dart — desain: https://dart.dev/effective-dart/design
- API `Object.hash`: https://api.dart.dev/stable/dart-core/Object/hash.html · API `identical`: https://api.dart.dev/stable/dart-core/identical.html
- Paket `meta` (`@immutable`): https://pub.dev/packages/meta
- Relasi ekuivalensi (dasar matematis kontrak `==`): https://en.wikipedia.org/wiki/Equivalence\_relation

---

## 3.2 Imutabilitas & `const`

*Motivasi: apa yang tidak bisa berubah tidak bisa mengejutkanmu.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas cara membuat data yang **tidak berubah setelah dibuat** — dengan `final`, `const`, kelas imutabel, dan pembaruan lewat salinan. Kamu membedakan imutabilitas *dangkal* dari *dalam*, memahami konstanta kanonik, serta menimbang biaya salinan. Imutabilitas adalah syarat bagi kesetaraan yang aman (3.1), promosi tipe (2.3), dan, kelak, keamanan konkurensi (Fase 7).

### B. Konsep Kunci & Filosofi Mendalam

- **`final`:** variabel yang hanya boleh diisi sekali. **`const`:** nilai konstanta yang diketahui saat kompilasi, *dalam* imutabel, dan dikanonikalisasi. `final` tidak melindungi *isi* objek yang ditunjuknya.
- **Konstruktor `const`** mensyaratkan semua field `final`; objek yang dibuat dengan `const` bersifat kanonik dan tidak menghabiskan alokasi saat runtime.
- **Dangkal vs dalam.** Kelas dengan field `final List<String>` hanya imutabel *dangkal*: referensinya terkunci, isinya tidak. Imutabilitas *dalam* menuntut seluruh pohon objek tak berubah.
- **Pembaruan lewat salinan:** alih-alih mengubah, buat objek baru dengan perubahan itu (`geser` mengembalikan `Titik` baru). Pemanggil yang memegang objek lama tidak terpengaruh — tak ada aliasing yang mengejutkan.
- **Salinan defensif:** bila konstruktor menerima koleksi dari luar, salin (dan bekukan) agar pemanggil tak bisa mengubahnya diam-diam dari luar.
- **Keuntungan:** mudah dinalar (modul 1.2), aman dibagi antar bagian program dan antar isolate, kesetaraan stabil, mudah di-cache, mudah diuji. **Biaya:** salinan menambah alokasi; mitigasi: bagikan bagian yang tak berubah (*structural sharing*), pertimbangkan struktur data persisten, dan ukur dulu (Fase 6).
- **Filosofi:** jadikan *mutasi sebagai pengecualian yang disengaja*, bukan bawaan.
- **Dampak desain:** objek imutabel menghilangkan seluruh kelas bug (aliasing, kunci bermutasi, urutan pembaruan), dengan harga yang bisa diukur dan biasanya kecil.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — `final` vs `const`, dan apa yang tidak mereka lindungi.**

```dart
void main() {
  final waktu = DateTime.now(); // final: ditentukan saat runtime, sekali
  const lima = Duration(minutes: 5); // const: diketahui saat kompilasi
  // const c = DateTime.now();       // galat: bukan konstanta waktu-kompilasi

  final daftar = [1, 2];
  daftar.add(3); // OK: final tidak melindungi ISI objek
  // daftar = [];     // galat: variabel final tak bisa di-assign ulang

  const tetap = [1, 2];
  // tetap.add(3);   // melempar error saat runtime: list konstan tak bisa diubah
  print('$waktu $lima $daftar $tetap');
}
```

- `DateTime.now()` baru diketahui saat jalan, sehingga hanya cocok untuk `final`.
- Menambah elemen ke list `final` berhasil karena yang terkunci adalah *variabel*, bukan *isi list*.

**Contoh 2 — kelas imutabel dengan konstruktor `const` dan pembaruan lewat salinan.**

```dart
import 'package:meta/meta.dart';

@immutable
class Titik {
  const Titik(this.x, this.y);
  final int x;
  final int y;

  /// Mengembalikan Titik BARU; objek ini tidak berubah.
  Titik geser(int dx, int dy) => Titik(x + dx, y + dy);

  @override
  bool operator ==(Object other) =>
      other is Titik && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}

void main() {
  const a = Titik(1, 2);
  const b = Titik(1, 2);
  print(identical(a, b)); // true: konstanta kanonik
  final c = a.geser(1, 1);
  print('${a.x},${a.y} -> ${c.x},${c.y}'); // 1,2 -> 2,3  (a tak berubah)
}
```

- `const Titik(this.x, this.y)` — konstruktor `const`; semua field `final`.
- `geser` tidak mengubah `this`; ia membangun `Titik` baru — bentuk umum "pembaruan lewat salinan".
- `const a` dan `const b` bernilai sama sehingga menjadi satu objek.

**Contoh 3 — imutabilitas dangkal dan salinan defensif.**

```dart
import 'package:meta/meta.dart';

@immutable
class KeranjangDangkal {
  const KeranjangDangkal(this.barang); // field final, tetapi List-nya mutabel
  final List<String> barang;
}

class KeranjangAman {
  KeranjangAman(Iterable<String> barang) : barang = List.unmodifiable(barang);
  final List<String> barang; // snapshot beku: tak bisa diubah, tak terhubung ke sumber
}

void main() {
  final sumber = ['apel'];
  final d = KeranjangDangkal(sumber);
  final a = KeranjangAman(sumber);
  sumber.add('jeruk');
  print(d.barang); // [apel, jeruk] <- aliasing: berubah dari luar!
  print(a.barang); // [apel]       <- aman
}
```

- `KeranjangDangkal`: label `@immutable` menyesatkan karena list di dalamnya tetap bisa diubah lewat referensi lain.
- `List.unmodifiable(barang)` — membuat salinan yang tidak bisa dimodifikasi; perubahan pada `sumber` setelahnya tidak memengaruhinya. Konstruktor ini tidak bisa `const` karena menyalin saat runtime.

### D. Opsi Kode Lain untuk Logika yang Sama

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Koleksi konstan seluruhnya diketahui saat kompilasi | `const [1, 2, 3]` | Dalam imutabel, tanpa alokasi runtime |
| Koleksi dari luar harus dibekukan | `List.unmodifiable(x)` | Snapshot O(n); independen dari sumber |
| Ingin tampilan baca-saja yang mengikuti sumber | `UnmodifiableListView(x)` | View O(1); berubah bila sumber berubah (3.4) |
| Pembaruan sering pada koleksi besar | Struktur data persisten pihak ketiga (mis. `built_collection`) | Menambah dependensi; ukur dulu |
| Nilai tunggal kecil | Record `(a, b)` | Imutabel otomatis, kesetaraan struktural |

### E. Terminologi Esensial

- **Imutabel dangkal / dalam** — hanya referensi terkunci / seluruh pohon objek terkunci. **Konstanta kanonik** — satu objek untuk semua `const` bernilai sama.
- **Salinan defensif** — menyalin masukan agar pihak luar tak bisa mengubah state internal. **Structural sharing** — bagian yang tak berubah dibagi antara versi lama dan baru.
- **Struktur data persisten** — struktur imutabel yang efisien untuk pembaruan lewat berbagi struktur.

### F. Visualisasi (ASCII)

```text
  makin terkunci ──────────────────────────────────────────────►

  var x        final x            final x + kelas imutabel      const x
  (boleh ubah  (variabel          (isi tak bisa berubah:        (konstanta kompilasi,
   semuanya)    terkunci,          semua field final,            dalam imutabel,
                isi mungkin        koleksi dibekukan)            kanonik)
                berubah)
```

```text
  imutabel DANGKAL                       imutabel DALAM

  Keranjang ──► final barang ──► [ 'apel' ]   Keranjang ──► [ 'apel' ]  (salinan beku)
                      ▲                                       ✗ tak ada referensi lain
  sumber ─────────────┘  (bisa mengubah isi!)                 yang bisa mengubah isinya
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 3.1 (kesetaraan aman butuh imutabilitas), 1.2 (aliasing, `final` vs `const`), 2.3 (stabilitas dan promosi tipe).
- **Prasyarat bagi:** 3.3–3.6. **Dikembangkan di:** Fase 6 (biaya salinan, `const` tanpa alokasi, struktur persisten), Fase 7 (data imutabel aman dikirim antar isolate).

### H. Tips & Praktik Terbaik

- Mulai dari `final` untuk semua variabel dan field; ganti ke `var` hanya bila ada alasan terukur.
- Bila konstruktor menerima koleksi, salin dan bekukan; jangan menyimpan referensi mentah dari luar.
- Beri `@immutable` pada kelas nilai dan tulis `const` pada konstruktornya agar instans dapat dikanonikalisasi.
- Ukur sebelum menyimpulkan bahwa salinan terlalu mahal; mayoritas masalah performa ada di tempat lain.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mengira `final List` itu imutabel | Isi berubah dari luar | `List.unmodifiable` atau `const` |
| `@immutable` pada kelas berisi koleksi mutabel | Label menyesatkan; aliasing | Bekukan koleksi di konstruktor |
| Mengubah argumen koleksi di dalam fungsi | Pemanggil terkejut datanya berubah | Kembalikan koleksi baru |
| `const` pada objek yang berisi nilai runtime | Galat kompilasi | Gunakan `final` |
| Salinan berulang di loop panas | Alokasi berlebih | Ukur; susun ulang (Fase 6) |

### J. Sumber Referensi

- Variabel, `final`, `const`: https://dart.dev/language/variables
- Konstruktor (`const`): https://dart.dev/language/constructors
- ✔ Lint `avoid_equals_and_hash_code_on_mutable_classes` (konteks `@immutable`): https://dart.dev/lints/avoid\_equals\_and\_hash\_code\_on\_mutable\_classes
- API `List.unmodifiable`: https://api.dart.dev/stable/dart-core/List/List.unmodifiable.html
- Paket `built_collection`: https://pub.dev/packages/built\_collection
- Struktur data persisten: https://en.wikipedia.org/wiki/Persistent\_data\_structure

---

## 3.3 Value Object, Record, dan `copyWith`

*Motivasi: data yang baik punya bentuk yang jelas dan perubahan yang disengaja.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas **value object** — objek yang didefinisikan oleh *nilai* field-nya, bukan identitasnya — dan tiga cara merepresentasikannya: **record**, **class**, dan (di 3.5) **extension type**. Kamu juga belajar pola `copyWith` untuk pembaruan sebagian, jebakan field nullable di dalamnya, serta bagaimana *primary constructors* (Dart 3.13) mengurangi boilerplate deklarasi.

### B. Konsep Kunci & Filosofi Mendalam

- **Value object:** imutabel, setara menurut nilai (3.1), dan membawa invarian. Ia menjawab *apa nilainya*, bukan *siapa objeknya*.
- **Record:** tipe agregat anonim, imutabel, dan terpisah dari deklarasi kelas. Fieldnya diakses lewat getter `$1`, `$2` (posisional) atau nama (bernama). Record **otomatis** punya `==` dan `hashCode` struktural sehingga layak menjadi kunci `Map` atau elemen `Set`.
- **Tipe record bersifat struktural.** `typedef` pada record hanyalah *alias*: dua alias dengan bentuk sama adalah tipe yang sama dan dapat saling tertukar tanpa peringatan. Bila makna berbeda penting (titik vs ukuran), pakai class atau extension type.
- **Class:** memberi nama domain, tempat invarian (validasi di konstruktor), method, dan kontrol visibilitas — dengan harga boilerplate untuk `==`, `hashCode`, dan salinan.
- **Memilih:** record untuk data sementara, hasil ganda, atau kunci; class untuk konsep domain yang bernama, berinvarian, atau berperilaku.
- **`copyWith`:** membuat salinan dengan sebagian field diganti. **Jebakan:** pada field nullable, `email ?? this.email` tidak dapat membedakan *tidak diberikan* dari *sengaja dikosongkan (null)*. Solusi: bungkus parameter dengan fungsi (`String? Function()?`), pakai nilai penjaga (*sentinel*), atau tipe `Opsi<T>` sealed.
- **Primary constructors (Dart ≥ 3.13):** menulis daftar parameter langsung di kepala kelas, mis. `class const Titik(final int x, final int y);`, yang sekaligus mendeklarasikan field dan konstruktor. Ini hanya gula sintaks: **tidak** menambah semantik nilai, jadi `==` dan `hashCode` tetap kamu tulis sendiri.
- **Invarian sejak lahir:** value object sebaiknya menolak nilai ilegal di konstruktornya; 3.5 memperdalam ini.
- **Dampak desain:** record memangkas kode untuk kebutuhan kecil tetapi membuka risiko tertukarnya makna; class menambah kode tetapi menuliskan maksud dan kontrak.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — record sebagai kunci, dan jebakan alias.**

```dart
typedef Sel = (int baris, int kolom);
typedef Titik2D = (int x, int y);
typedef Ukuran = (int lebar, int tinggi);

void geser(Titik2D t) {}

void main() {
  final papan = <Sel, String>{(0, 0): 'X', (1, 1): 'O'};
  print(papan[(0, 0)]); // X: record sebagai kunci Map (kesetaraan struktural)

  final Ukuran u = (3, 4);
  geser(u); // lolos kompilasi: Titik2D dan Ukuran sama-sama (int, int)
}
```

- `(int baris, int kolom)` — nama pada field posisional hanya dokumentasi; tidak memengaruhi tipe.
- `<Sel, String>{(0, 0): 'X'}` — kunci berupa record; pencarian `papan[(0, 0)]` berhasil karena record `(0, 0)` setara dengan record kunci.
- `geser(u)` — lolos walau maknanya salah: alias tidak membedakan. Inilah alasan memakai class atau extension type untuk konsep yang berbeda makna.

**Contoh 2 — `copyWith` dan jebakan field nullable.**

```dart
import 'package:meta/meta.dart';

@immutable
class Profil {
  const Profil({required this.nama, this.email});
  final String nama;
  final String? email;

  // NAIF: tidak bisa mengosongkan email.
  Profil copyWithNaif({String? nama, String? email}) =>
      Profil(nama: nama ?? this.nama, email: email ?? this.email);

  // BENAR: field nullable dibungkus fungsi; null-nya BERMAKNA (mengosongkan).
  Profil copyWith({String? nama, String? Function()? email}) => Profil(
        nama: nama ?? this.nama,
        email: email != null ? email() : this.email,
      );

  @override
  bool operator ==(Object other) =>
      other is Profil && other.nama == nama && other.email == email;

  @override
  int get hashCode => Object.hash(nama, email);
}

void main() {
  const p = Profil(nama: 'Ani', email: 'ani@example.com');
  print(p.copyWithNaif(email: null).email); // ani@example.com  <- BUG: tak terhapus
  print(p.copyWith(email: () => null).email); // null            <- benar
  print(p.copyWith(nama: 'Ana').email); // ani@example.com  <- email tak disentuh
}
```

- `String? Function()? email` — parameter opsional berupa *fungsi yang mengembalikan `String?`*. Tidak diberikan = `null` (biarkan); diberikan `() => null` = kosongkan; diberikan `() => 'x'` = ganti.
- `email != null ? email() : this.email` — setelah pemeriksaan `null`, parameter terpromosi sehingga boleh dipanggil.
- Pola yang sama dipakai di studi kasus bila ada field opsional.

**Contoh 3 — primary constructor (Dart ≥ 3.13).**

```dart
import 'package:meta/meta.dart';

// Membutuhkan batas bawah SDK ^3.13.0 di pubspec.yaml.
@immutable
class const TitikP(final int x, final int y) {
  @override
  bool operator ==(Object other) =>
      other is TitikP && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}

void main() {
  const a = TitikP(1, 2);
  const b = TitikP(1, 2);
  print(a == b); // true: berkat == yang kita tulis, BUKAN dari primary constructor
}
```

- `class const TitikP(final int x, final int y)` — kepala kelas sekaligus mendeklarasikan konstruktor `const` dan dua field `final`.
- Badan kelas hanya berisi `==` dan `hashCode`: primary constructor tidak menghasilkannya; semantik nilai tetap tanggung jawabmu.
- Untuk validasi, badan konstruktor ditulis di dalam kelas dengan bentuk `this : assert(...) { ... }` (lihat dokumentasi primary constructors).

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Peta (Map) tak bertipe: fleksibel, tetapi tanpa jaminan apa pun.
final profilMap = <String, Object?>{'nama': 'Ani', 'email': null};

// Record bernama untuk data kecil dan sementara:
({String nama, String? email}) profilRec = (nama: 'Ani', email: null);
```

| Pilihan | Kelebihan | Kekurangan | Pilih bila |
| --- | --- | --- | --- |
| Record | Tanpa boilerplate; `==`/`hashCode` otomatis; kunci Map | Tanpa nama domain, validasi, method; alias saling tertukar | Hasil ganda, data sementara, kunci |
| Class imutabel | Nama domain, invarian, method | Boilerplate `==`/`hashCode`/`copyWith` | Konsep domain yang berinvarian atau berperilaku |
| Class + primary constructor (≥ 3.13) | Deklarasi ringkas | Tetap tanpa semantik nilai otomatis | Kelas data sederhana pada SDK ≥ 3.13 |
| `Map<String, Object?>` | Fleksibel, cocok untuk data eksternal mentah | Tanpa tipe; kesalahan ketik kunci terdeteksi saat runtime | Hanya di tepi sistem (parsing); jangan di inti |
| Extension type (3.5) | Tanpa biaya runtime; tipe domain tervalidasi | Terhapus saat runtime (`is`/`as` tak membedakan) | Membungkus satu nilai (ID, uang, judul) |

### E. Terminologi Esensial

- **Value object** — objek berdasar nilai, imutabel. **Record** — agregat anonim imutabel dengan tipe struktural. **Alias (`typedef`)** — nama lain untuk tipe yang sama.
- **Boolean trap / makna tertukar** — dua konsep dengan bentuk sama yang saling dipakai keliru. **Sentinel** — nilai penjaga yang menandai keadaan khusus.
- **Primary constructor** — konstruktor yang dideklarasikan di kepala kelas. **Invarian** — pernyataan yang selalu benar tentang objek.

### F. Visualisasi (ASCII)

```text
 Butuh nama domain, validasi, atau method?
  ├─ ya  → class (value object)   atau   extension type (3.5) bila membungkus satu nilai
  └─ tidak → hanya mengelompokkan data sementara / hasil ganda / kunci Map?
              ├─ ya  → record
              └─ tidak → class
```

```text
 copyWith pada field nullable:

   p.copyWith(email: null)          →  email ?? this.email     →  email LAMA tetap (bug)
   p.copyWith(email: () => null)    →  email != null ? email() : ...  →  null (benar)
   p.copyWith()                     →  email == null           →  email LAMA tetap (benar)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 3.1 (kesetaraan), 3.2 (imutabilitas), 2.5 (pola record dan object).
- **Prasyarat bagi:** 3.5 (tipe domain tervalidasi) dan 3.7. **Dikembangkan di:** Fase 4 (konstruktor named dan factory, method pada class), Fase 5 (hasil dan kegagalan sebagai record atau sealed), Fase 9 (parsing `Map` eksternal menjadi tipe aman).

### H. Tips & Praktik Terbaik

- Mulailah dengan record untuk data sementara; naik ke class begitu ada nama domain, invarian, atau method.
- Beri tes untuk `copyWith`: pastikan tiap field dapat diganti *dan* dapat dibiarkan (termasuk dikosongkan bila nullable).
- Hindari `Map<String, Object?>` di dalam inti logika; ubah menjadi tipe bernama di tepi sistem.
- Jangan beranggapan primary constructor memberi `==`; tetap tulis atau hasilkan kesetaraan secara sadar.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| `copyWith` dengan `x ?? this.x` pada field nullable | Tak bisa mengosongkan field | Pembungkus fungsi, sentinel, atau `Opsi<T>` |
| Memakai alias record untuk konsep berbeda | Titik dan ukuran saling tertukar tanpa galat | Ganti dengan class atau extension type |
| Lupa memperbarui `==`/`hashCode`/`copyWith` saat menambah field | Bug halus, objek berbeda dianggap sama | Test kesetaraan dan salinan per field |
| Mengira primary constructor memberi semantik nilai | Dua objek berisi sama tak setara | Tulis `==` dan `hashCode` sendiri |
| `Map<String, Object?>` merembes ke inti | Salah ketik kunci muncul saat runtime | Parse sekali di tepi menjadi tipe bernama |

### J. Sumber Referensi

- ✔ Record (tipe struktural, kesetaraan, alias): https://dart.dev/language/records
- ✔ Primary constructors: https://dart.dev/language/primary-constructors
- ✔ Pengumuman Dart 3.13: https://dart.dev/blog/announcing-dart-3-13
- ✔ Primary constructors di Dart (latar desain): https://dart.dev/blog/bringing-primary-constructors-to-dart
- Konstruktor: https://dart.dev/language/constructors
- Effective Dart — desain: https://dart.dev/effective-dart/design

---

## 3.4 Koleksi sebagai Nilai

*Motivasi: koleksi yang bocor adalah pintu belakang yang kamu kunci di pintu depan.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini menangani koleksi (`List`, `Set`, `Map`) sebagai bagian dari model nilai: cara membandingkan isinya (**kesetaraan dalam**), cara mengekspos koleksi internal tanpa membuka pintu mutasi (**view**, **snapshot**, atau salinan), dan cara memakai koleksi sebagai kunci. Ia menerapkan *prinsip hak akses minimum* pada data: berikan pihak lain hanya kemampuan yang mereka butuhkan.

### B. Konsep Kunci & Filosofi Mendalam

- **Kesetaraan koleksi bawaan adalah identitas** (3.1). Untuk membandingkan isi, gunakan `ListEquality`, `SetEquality`, `MapEquality`, `UnorderedIterableEquality`, atau `DeepCollectionEquality` dari `package:collection`. Setiap `Equality` juga menyediakan `hash` yang konsisten untuk dipakai di `hashCode`.
- **Urutan bermakna pada list, tidak pada set.** `SetEquality` menganggap `{1, 2}` dan `{2, 1}` setara; `ListEquality` tidak menganggap `[1, 2]` dan `[2, 1]` setara. Literal `{}` secara bawaan menjaga urutan penyisipan (`LinkedHashSet`/`LinkedHashMap`), tetapi jangan menjadikan urutan itu bagian dari kontrak kecuali kamu menuliskannya.
- **View vs snapshot.** `UnmodifiableListView(sumber)` adalah **tampilan hidup** baca-saja: ia mengikuti perubahan `sumber`, biaya pembuatan O(1). `List.unmodifiable(sumber)` adalah **salinan beku**: independen dari `sumber`, biaya O(n). Prinsip yang sama berlaku untuk `Set` dan `Map`.
- **Hak akses minimum.** Jangan mengembalikan list mutabel internal dari getter. Pilih: view (pembaca perlu data terkini, hemat), snapshot (pembaca perlu nilai stabil pada satu titik waktu), atau cukup tipe `Iterable` (membatasi API, meski bisa di-*cast* — bukan jaminan).
- **Koleksi sebagai kunci.** List dan set mutabel buruk sebagai kunci (identitas, dan bisa bermutasi). Pakai record, atau bungkus nilai dalam tipe dengan kesetaraan yang benar.
- **Filosofi:** koleksi internal adalah *detail implementasi*; yang diekspos adalah *kemampuan* tertentu atasnya.
- **Dampak desain:** view murah tetapi menularkan perubahan sumber ke pembaca; snapshot mahal tetapi stabil. Pilih berdasarkan kebutuhan pembaca, bukan kebiasaan.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — kesetaraan dalam dengan `package:collection`.**

```dart
import 'package:collection/collection.dart';

void main() {
  final a = [1, 2, 3];
  final b = [1, 2, 3];
  print(a == b); // false: identitas
  print(const ListEquality<int>().equals(a, b)); // true: isi sama, urutan sama
  print(const SetEquality<int>().equals({1, 2}, {2, 1})); // true: urutan tak penting

  final dalam1 = {'x': [1, 2]};
  final dalam2 = {'x': [1, 2]};
  print(const DeepCollectionEquality().equals(dalam1, dalam2)); // true: perbandingan bersarang
}
```

- Tambahkan paket dengan `dart pub add collection`.
- `const ListEquality<int>()` — objek pembanding; `equals(a, b)` membandingkan elemen satu per satu.
- `DeepCollectionEquality` menelusuri koleksi bersarang (list di dalam map).

**Contoh 2 — view vs snapshot.**

```dart
import 'dart:collection';

void main() {
  final sumber = [1, 2, 3];
  final view = UnmodifiableListView(sumber); // tampilan hidup
  final snap = List<int>.unmodifiable(sumber); // salinan beku

  sumber.add(4);
  print(view.length); // 4: view mengikuti sumber
  print(snap.length); // 3: snapshot tidak berubah

  // view.add(5);     // melempar UnsupportedError
  // snap.add(5);     // melempar UnsupportedError
}
```

- Keduanya tak bisa diubah *lewat dirinya sendiri*, tetapi hanya snapshot yang kebal terhadap perubahan *sumber*.
- Itulah mengapa "read-only" dan "imutabel" bukan kata yang sama.

**Contoh 3 — mengekspos koleksi dengan hak akses minimum.**

```dart
import 'dart:collection';

class Perpustakaan {
  final List<String> _buku = [];

  /// View hidup: murah (O(1)), selalu mutakhir, tak bisa diubah pembaca.
  UnmodifiableListView<String> get buku => UnmodifiableListView(_buku);

  /// Snapshot: stabil pada saat dipanggil, biaya O(n).
  List<String> get salinanBuku => List.unmodifiable(_buku);

  void tambah(String judul) => _buku.add(judul);
}

void main() {
  final p = Perpustakaan();
  final lihat = p.buku;
  final foto = p.salinanBuku;
  p.tambah('Dart');
  print(lihat.length); // 1: view melihat perubahan
  print(foto.length); // 0: foto diambil sebelum tambah
}
```

- `_buku` privat dan mutabel — satu-satunya pintu mutasi adalah `tambah`, tempat invarian dapat dijaga.
- Getter `buku` dan `salinanBuku` mengekspos *kemampuan* yang berbeda atas data yang sama.

**Contoh 4 — record sebagai kunci menggantikan list.**

```dart
void main() {
  final kunjungan = <(int, int), int>{};
  for (final sel in [(1, 2), (3, 4), (1, 2)]) {
    kunjungan[sel] = (kunjungan[sel] ?? 0) + 1;
  }
  print(kunjungan); // {(1, 2): 2, (3, 4): 1}
}
```

- Bila kunci berupa `List<int>`, tiga entri berbeda tercipta (identitas); dengan record, `(1, 2)` yang sama bergabung.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Tipe Iterable: membatasi API, tetapi bukan jaminan (bisa di-cast).
Iterable<String> get bukuIterable => _buku;

// Peta/himpunan dengan kesetaraan khusus (package:collection):
// final peta = EqualityMap<List<int>, String>(const ListEquality<int>());
```

| Bentuk ekspos | Biaya | Stabil terhadap perubahan sumber? | Pilih bila |
| --- | --- | --- | --- |
| `UnmodifiableListView` (view) | O(1) | Tidak (mengikuti sumber) | Pembaca perlu data terkini dan hemat |
| `List.unmodifiable` (snapshot) | O(n) | Ya | Pembaca perlu nilai stabil pada satu titik waktu |
| `Iterable<T>` | O(1) | Tidak | Cukup untuk iterasi; bukan jaminan keamanan |
| Salinan mutabel (`[...x]`) | O(n) | Ya | Pembaca butuh mengubah salinannya sendiri |
| `const` koleksi | 0 | Ya | Seluruh isi diketahui saat kompilasi |

### E. Terminologi Esensial

- **Kesetaraan dalam (deep equality)** — membandingkan isi koleksi secara rekursif. **View** — tampilan yang mengikuti sumber. **Snapshot** — salinan pada satu titik waktu.
- **Prinsip hak akses minimum** — memberi hanya kemampuan yang diperlukan. **Salinan defensif** — menyalin agar pihak luar tak bisa memutasi state internal.
- **`LinkedHashMap` / `LinkedHashSet`** — implementasi bawaan literal `{}` yang menjaga urutan penyisipan.

### F. Visualisasi (ASCII)

```text
   sumber (List mutabel, privat)
      │
      ├──► UnmodifiableListView  ── view hidup ──►  pembaca A   (melihat perubahan sumber)
      │
      └──► List.unmodifiable     ── salinan beku ─►  pembaca B   (tak terpengaruh sumber)
```

```text
   sumber.add(4)

   view :  [1,2,3] ──► [1,2,3,4]      (mengikuti)
   snap :  [1,2,3] ──► [1,2,3]        (beku)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 3.1 (identitas vs nilai), 3.2 (imutabilitas dan salinan defensif), 1.2 (aliasing).
- **Prasyarat bagi:** 3.6 (riwayat state) dan 3.7. **Dikembangkan di:** Fase 6 (biaya O(1) vs O(n), pemilihan koleksi), Fase 11 (batas modul dan API yang tak membocorkan state internal).

### H. Tips & Praktik Terbaik

- Simpan koleksi internal sebagai field privat; ekspos kemampuan, bukan koleksinya.
- Tulis di dokumentasi apakah getter mengembalikan view atau snapshot; pembaca berhak tahu.
- Bandingkan koleksi dengan `Equality` yang tepat; hindari `==` pada list dan map.
- Pakai record atau tipe nilai sebagai kunci; jangan pernah memakai koleksi mutabel sebagai kunci.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mengembalikan list internal langsung | Pemanggil mengubah state objek dari luar | View, snapshot, atau salinan |
| Mengira `UnmodifiableListView` itu imutabel | Isi berubah karena sumber berubah | Pakai `List.unmodifiable` bila butuh snapshot |
| Memakai `==` pada list/map | Selalu `false` | `ListEquality`, `MapEquality`, `DeepCollectionEquality` |
| `SetEquality` untuk data berurutan | Urutan diabaikan | Pakai `ListEquality` bila urutan bermakna |
| `List` sebagai kunci `Map` | Entri ganda atau kunci hilang | Record atau tipe nilai dengan kesetaraan benar |
| Snapshot di loop panas | Alokasi O(n) berulang | Ukur; pertimbangkan view atau susun ulang |

### J. Sumber Referensi

- Pustaka `package:collection` (kesetaraan, view): https://pub.dev/documentation/collection/latest/collection/collection-library.html
- `dart:collection`: https://api.dart.dev/stable/dart-collection/dart-collection-library.html
- API `List.unmodifiable`: https://api.dart.dev/stable/dart-core/List/List.unmodifiable.html
- Koleksi di dart.dev: https://dart.dev/language/collections
- Prinsip hak akses minimum: https://en.wikipedia.org/wiki/Principle\_of\_least\_privilege

---

## 3.5 Membuat Keadaan Ilegal Tak Mungkin Direpresentasikan

*Motivasi: desain terbaik bukan yang menolak data buruk, melainkan yang tak punya tempat untuknya.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini mengajarkan strategi desain inti: memodelkan data sehingga **kombinasi yang salah tidak dapat dituliskan sama sekali**. Alatnya: `sealed`/`enum` (menggantikan tumpukan flag), konstruktor dan *smart constructor* yang memvalidasi, **extension type** sebagai tipe domain tanpa biaya runtime, dan *typestate* (tipe berbeda untuk tahap berbeda). Prinsipnya: *parse, don't validate* — ubah data mentah menjadi tipe tervalidasi sekali di tepi, lalu percayai tipe itu di dalam.

### B. Konsep Kunci & Filosofi Mendalam

- **Ledakan kombinasi flag.** Tiga variabel (`memuat`, `galat`, `data`) menghasilkan banyak kombinasi (mis. memuat *dan* galat *dan* data sekaligus), padahal hanya tiga keadaan yang bermakna. Setiap kombinasi ilegal adalah bug yang menunggu, dan tiap kode yang membaca harus mengingat aturan tak tertulis.
- **Gunakan tipe jumlah (sum type).** `sealed class` dengan varian yang masing-masing membawa data *miliknya sendiri* membuat hanya keadaan sah yang bisa dibuat (modul 2.6).
- **Smart constructor.** Konstruktor privat + fungsi pembuat yang memvalidasi dan mengembalikan `T?` atau `Hasil<T>`. Objek yang sudah ada *pasti* sah.
- **Extension type (Dart ≥ 3.3).** Membungkus satu tipe (tipe representasi) menjadi tipe baru yang tak dapat tertukar di waktu kompilasi, dengan **biaya runtime nol**: pada saat jalan ia *terhapus* menjadi tipe representasi, dan pemanggilan method diselesaikan secara statis. Dengan tidak memakai `implements`, API tipe representasi tersembunyi.
- **Peringatan penting:** karena terhapus saat runtime, `x is Judul` dan `x as Judul` tidak dapat membedakan `Judul` dari `String` biasa. Jangan jadikan `is`/`as` sebagai pengganti validasi; sah-nya sebuah `Judul` dijaga *hanya* oleh konstruktor yang memvalidasi dan tidak dapat dipanggil dari luar.
- **Typestate.** Tahap yang berbeda direpresentasikan sebagai tipe berbeda (`Draf`, `Dibayar`); fungsi yang butuh pesanan terbayar menerima `Dibayar`, sehingga *mengirim pesanan yang belum dibayar* menjadi galat kompilasi.
- **Filosofi:** pindahkan pemeriksaan dari *runtime* ke *waktu kompilasi* sejauh mungkin, dan ke *batas sistem* sisanya.
- **Dampak desain:** tipe domain menghilangkan kelas bug tertukarnya argumen (mis. `kirim(userId, orderId)`) dan memusatkan validasi di satu tempat; harganya adalah sedikit lebih banyak tipe — dan tipe itulah dokumentasi yang selalu benar.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — dari tumpukan flag ke `sealed`.**

```dart
// BURUK: tiga variabel -> banyak kombinasi, hanya tiga yang bermakna.
class StateBuruk {
  bool memuat = false;
  String? galat;
  List<String>? data;
}

// BAIK: hanya tiga keadaan yang mungkin, masing-masing membawa datanya sendiri.
sealed class Muatan {
  const Muatan();
}

class Memuat extends Muatan {
  const Memuat();
}

class Berhasil extends Muatan {
  const Berhasil(this.data);
  final List<String> data;
}

class Galat extends Muatan {
  const Galat(this.pesan);
  final String pesan;
}

String tampil(Muatan m) => switch (m) {
      Memuat() => 'memuat...',
      Berhasil(:final data) => '${data.length} item',
      Galat(:final pesan) => 'galat: $pesan',
    };
```

- Pada `StateBuruk`, `memuat = true` dan `galat = 'x'` sekaligus *bisa ditulis*, dan tak ada yang melarang.
- Pada `Muatan`, `Galat` tidak punya `data` dan `Berhasil` tidak punya `pesan`; kombinasi tak bermakna tidak bisa dibuat. `tampil` lengkap tanpa `_` (modul 2.6).

**Contoh 2 — extension type tervalidasi (Dart ≥ 3.3).**

```dart
extension type const Judul._(String _teks) {
  /// Mengembalikan null bila [teks] kosong setelah dipangkas.
  static Judul? coba(String teks) {
    final t = teks.trim();
    return t.isEmpty ? null : Judul._(t);
  }

  /// Untuk kode yang yakin masukannya sah; melempar bila tidak.
  factory Judul.dari(String teks) =>
      coba(teks) ??
      (throw ArgumentError.value(teks, 'teks', 'judul tidak boleh kosong'));

  String get teks => _teks;
}

void main() {
  final j = Judul.coba('  beli roti  ');
  print(j?.teks); // beli roti
  print(Judul.coba('   ')); // null
  // Judul._('x');  // dari file lain: galat kompilasi (konstruktor privat)
}
```

- `extension type const Judul._(String _teks)` — mendeklarasikan tipe `Judul` dengan *representasi* `String`; konstruktor utamanya privat (`._`), sehingga pihak luar tidak bisa melewati validasi.
- `static Judul? coba(...)` — *smart constructor*: memangkas spasi dan mengembalikan `null` bila kosong. Pemanggil dipaksa menangani `null` (modul 2.2).
- `factory Judul.dari(...)` — jalur yang melempar `ArgumentError` untuk kasus yang dijamin sah oleh pemanggil (mis. di test).
- Tidak memakai `implements String`: `Judul` bukan `String` bagi kompilator, sehingga fungsi yang meminta `Judul` menolak `String` mentah.

**Contoh 3 — typestate sederhana.**

```dart
class Draf {
  const Draf(this.item);
  final List<String> item;

  Dibayar bayar(int jumlah) => Dibayar(item, jumlah);
}

class Dibayar {
  const Dibayar(this.item, this.jumlahBayar);
  final List<String> item;
  final int jumlahBayar;
}

/// Hanya pesanan yang SUDAH dibayar yang boleh dikirim.
String kirim(Dibayar pesanan) => 'mengirim ${pesanan.item.length} barang';

void main() {
  const draf = Draf(['roti']);
  // kirim(draf);              // galat kompilasi: Draf bukan Dibayar
  print(kirim(draf.bayar(15000))); // satu-satunya jalan menuju Dibayar
}
```

- `Draf` tidak punya `jumlahBayar`; `kirim` hanya menerima `Dibayar`. Aturan bisnis "kirim setelah bayar" menjadi *aturan tipe*, bukan komentar.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// 1) Validasi saat runtime di konstruktor: sederhana, tetapi objek ilegal baru ditolak saat dibuat.
class Persen {
  Persen(this.nilai) {
    if (nilai < 0 || nilai > 100) {
      throw RangeError.range(nilai, 0, 100, 'nilai');
    }
  }
  final int nilai;
}

// 2) typedef: hanya alias, TANPA keamanan tipe.
typedef UserId = String;
```

| Pendekatan | Keamanan | Biaya runtime | Pilih bila |
| --- | --- | --- | --- |
| `sealed` / `enum` | Kompilator membuktikan kelengkapan | Objek biasa | Beberapa keadaan dengan data berbeda |
| Extension type tervalidasi | Tipe berbeda di kompilasi; sah lewat konstruktor | Nol (terhapus) | Membungkus satu nilai: ID, uang, judul, email |
| Class pembungkus | Tipe berbeda dan terlihat saat runtime | Satu alokasi per nilai | Perlu pemeriksaan tipe saat runtime atau banyak field |
| Validasi runtime di konstruktor | Ditolak saat dibuat | Pemeriksaan tiap pembuatan | Aturan yang tak dapat diekspresikan oleh tipe |
| `typedef` | Tidak ada | Nol | Hanya untuk memperpendek nama tipe |

### E. Terminologi Esensial

- **Keadaan ilegal tak terepresentasikan** — desain di mana kombinasi salah tak dapat ditulis. **Sum type** — tipe pilihan satu-dari-banyak.
- **Smart constructor** — fungsi pembuat yang memvalidasi dan menjaga invarian. **Parse, don't validate** — ubah data mentah jadi tipe sah sekali, di tepi.
- **Extension type** — tipe tanpa biaya runtime yang membungkus tipe representasi dan terhapus saat runtime. **Tipe representasi** — tipe yang dibungkus.
- **Typestate** — tahap objek dikodekan dalam tipe. **Penghapusan tipe (erasure)** — informasi tipe hilang saat runtime.

### F. Visualisasi (ASCII)

```text
 STATE BURUK: 3 variabel                     STATE BAIK: sealed class

  memuat  galat   data                       Muatan
  ──────  ─────   ────                       ├── Memuat
  false   null    null     (kosong?)         ├── Berhasil(data)
  true    null    null     (memuat)          └── Galat(pesan)
  false   'x'     null     (galat)
  true    'x'     [..]     (??? ilegal)       → 3 keadaan, semuanya bermakna
  ...banyak kombinasi lain...
```

```text
  data mentah ──► Judul.coba(...) ──┬──► null          → ditolak di TEPI
  (String)        (smart ctor)      └──► Judul sah     → dipercaya di DALAM

  di dalam sistem:   fungsi(Judul j)  ← tak perlu validasi ulang; tipe adalah buktinya
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 2.6 (sealed dan exhaustiveness), 2.2 (null), 1.5 (kontrak dan invarian), 3.3 (value object).
- **Prasyarat bagi:** 3.7 (studi kasus). **Dikembangkan di:** Fase 5 (smart constructor yang mengembalikan `Hasil`), Fase 8 (generics, tipe dan penghapusan saat runtime), Fase 9 (parse di batas kepercayaan), Fase 11 (tipe domain sebagai bahasa modul).

### H. Tips & Praktik Terbaik

- Setiap kali menulis flag boolean kedua pada kelas yang sama, tanyakan: *kombinasi mana yang ilegal?* Bila ada, ganti dengan sealed.
- Pakai tipe domain untuk ID, uang, satuan, dan teks bermakna khusus; jangan pakai `String`/`int` telanjang di API publik.
- Validasi di tepi (parsing), percayai tipe di dalam; jangan memvalidasi ulang di setiap fungsi.
- Untuk extension type, jangan memakai `implements` kecuali kamu memang ingin membuka seluruh API tipe representasi.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mengandalkan `is`/`as` pada extension type | Pemeriksaan selalu lolos untuk representasi apa pun | Jaga validitas lewat konstruktor privat dan smart constructor |
| Konstruktor utama extension type publik | Pihak luar membuat nilai tak tervalidasi | Jadikan konstruktor utama privat (`._`) |
| `typedef` dikira tipe baru | Tertukar tanpa galat | Pakai extension type atau class |
| Menumpuk flag boolean | Kombinasi ilegal diam-diam | Ganti dengan `sealed` atau `enum` |
| Validasi berulang di banyak fungsi | Inkonsisten dan lambat | Parse sekali di tepi menjadi tipe sah |
| `implements String` tanpa pikir panjang | Tipe domain bisa dipakai sebagai String biasa | Hapus `implements` agar tipe benar-benar terpisah |

### J. Sumber Referensi

- Extension types: https://dart.dev/language/extension-types
- ✔ Dart 3.3 (extension types, zero-cost wrapper): https://dart.dev/blog/new-in-dart-3-3-extension-types-javascript-interop-and-more
- ✔ Class modifiers (`sealed`): https://dart.dev/language/class-modifiers
- ✔ Percabangan dan exhaustiveness: https://dart.dev/language/branches
- Alexis King, *Parse, don't validate*: https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/
- Yaron Minsky, *Make illegal states unrepresentable*: https://blog.janestreet.com/effective-ml-revisited/

---

## 3.6 State sebagai Transisi: Reducer dan Riwayat *(TAMBAHAN)*

*Motivasi: state yang bisa diputar ulang adalah state yang bisa dipercaya.*

> **Mengapa ditambahkan.** Audit menemukan bahwa pembahasan imutabilitas biasanya berhenti pada *bentuk* data. Padahal manfaat terbesarnya baru terasa ketika kamu memodelkan *perubahan*: state lama tetap ada, sehingga undo, redo, replay, dan pengujian menjadi nyaris gratis.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini memodelkan perubahan state sebagai **fungsi murni** `(State, Peristiwa) → State` (reducer), mengubah *peristiwa* menjadi `sealed class`, dan menyusun **riwayat** imutabel yang mendukung undo dan redo dengan batas memori. Hasilnya adalah pola yang dipakai ulang di studi kasus 3.7 dan di arsitektur Fase 11.

### B. Konsep Kunci & Filosofi Mendalam

- **Reducer:** fungsi murni yang menerima state saat ini dan satu peristiwa, lalu mengembalikan state *baru*. Tanpa efek samping, tanpa mutasi (modul 1.2). Karena murni, hasilnya deterministik dan mudah dites.
- **Peristiwa sebagai `sealed class`.** Setiap jenis peristiwa adalah varian; `switch` di reducer lengkap tanpa `_` sehingga menambah peristiwa baru langsung menandai semua tempat yang perlu diubah (modul 2.6).
- **Replay.** State akhir = `fold` dari semua peristiwa terhadap state awal. Menyimpan daftar peristiwa berarti dapat membangun ulang state di titik waktu mana pun — gagasan di balik *event sourcing*.
- **Riwayat imutabel.** Tiga bagian: `lampau` (state sebelumnya), `kini`, dan `depan` (state yang dibatalkan, siap diulang). Setiap operasi mengembalikan `Riwayat` baru; yang lama tak berubah.
- **Cabang redo dibuang.** Melakukan perubahan baru setelah undo menghapus `depan`; masa depan lama tak lagi relevan.
- **Batas memori.** Riwayat tanpa batas adalah kebocoran memori yang tertunda. Pangkas `lampau` ke `batas` entri terakhir; `batas` adalah keputusan desain yang tertulis.
- **Biaya.** Menyalin list pada tiap langkah adalah O(n); item di dalamnya dibagi (tidak disalin) antar versi karena imutabel. Struktur data persisten dapat menurunkan biaya itu bila terukur perlu (Fase 6).
- **Filosofi:** ubah *state* menjadi *nilai* yang bisa dikoleksi, dibandingkan, dan diputar; maka waktu menjadi dimensi yang dapat dijelajahi, bukan bug yang harus dihindari.
- **Dampak desain:** undo/redo bukan fitur tambahan yang ditempelkan, melainkan akibat langsung dari desain imutabel — sambil tetap membatasi memori.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — reducer dan replay.**

```dart
sealed class Aksi {
  const Aksi();
}

class Naik extends Aksi {
  const Naik(this.langkah);
  final int langkah;
}

class Turun extends Aksi {
  const Turun(this.langkah);
  final int langkah;
}

class Atur extends Aksi {
  const Atur(this.nilai);
  final int nilai;
}

/// Murni: tidak mengubah apa pun, hanya mengembalikan state baru.
int reduksi(int state, Aksi aksi) => switch (aksi) {
      Naik(:final langkah) => state + langkah,
      Turun(:final langkah) => state - langkah,
      Atur(:final nilai) => nilai,
    };

void main() {
  const aksi = <Aksi>[Naik(5), Turun(2), Atur(10), Naik(1)];
  final akhir = aksi.fold<int>(0, reduksi);
  print(akhir); // 11
}
```

- `reduksi(int state, Aksi aksi)` — bentuk baku reducer: dua masukan, satu keluaran, tanpa efek samping.
- `switch` atas `sealed` tanpa `_` — tambah `class Kali extends Aksi` dan program tak dikompilasi sampai `reduksi` ditambah.
- `aksi.fold<int>(0, reduksi)` — *replay*: terapkan semua peristiwa berurutan mulai dari state awal `0`. Hasil: 0 → 5 → 3 → 10 → 11.

**Contoh 2 — riwayat imutabel dengan undo, redo, dan batas.**

```dart
class Riwayat<T> {
  Riwayat._(this._lampau, this.kini, this._depan, this.batas);

  factory Riwayat.mulai(T awal, {int batas = 50}) {
    if (batas < 1) {
      throw ArgumentError.value(batas, 'batas', 'harus >= 1');
    }
    return Riwayat._(<T>[], awal, <T>[], batas);
  }

  final List<T> _lampau; // terlama -> terbaru; tidak pernah dimutasi
  final T kini;
  final List<T> _depan; // terdekat -> terjauh; tidak pernah dimutasi
  final int batas;

  bool get bisaUndo => _lampau.isNotEmpty;
  bool get bisaRedo => _depan.isNotEmpty;

  /// Menjadikan [baru] state saat ini; cabang redo dibuang.
  Riwayat<T> ubah(T baru) {
    final lampau = [..._lampau, kini];
    final dipangkas =
        lampau.length > batas ? lampau.sublist(lampau.length - batas) : lampau;
    return Riwayat._(dipangkas, baru, <T>[], batas);
  }

  Riwayat<T> undo() {
    if (!bisaUndo) return this;
    return Riwayat._(
      _lampau.sublist(0, _lampau.length - 1),
      _lampau.last,
      [kini, ..._depan],
      batas,
    );
  }

  Riwayat<T> redo() {
    if (!bisaRedo) return this;
    return Riwayat._(
      [..._lampau, kini],
      _depan.first,
      _depan.sublist(1),
      batas,
    );
  }
}

void main() {
  var r = Riwayat.mulai(0);
  r = r.ubah(1).ubah(2).ubah(3);
  assert(r.kini == 3);
  r = r.undo().undo();
  assert(r.kini == 1 && r.bisaRedo);
  r = r.redo();
  assert(r.kini == 2);
  r = r.ubah(99); // cabang baru: redo dibuang
  assert(!r.bisaRedo && r.undo().kini == 2);

  var b = Riwayat.mulai(0, batas: 2);
  for (var i = 1; i <= 5; i++) {
    b = b.ubah(i);
  }
  b = b.undo().undo().undo(); // hanya dua undo yang tersedia
  assert(b.kini == 3);
}
```

- Konstruktor privat `Riwayat._` + `factory Riwayat.mulai` — hanya satu jalan membuat riwayat awal, dengan validasi `batas >= 1` (modul 1.5).
- `_lampau` dan `_depan` adalah list yang *tidak pernah dimutasi*; setiap operasi membuat list baru dengan spread, sehingga objek `Riwayat` lama tetap valid (imutabel).
- `ubah`: menambah `kini` ke `lampau`, memangkas ke `batas` terakhir, mengosongkan `depan`.
- `undo`: memindahkan elemen terakhir `lampau` menjadi `kini`, dan `kini` lama menjadi awal `depan`. `redo` sebaliknya.
- `if (!bisaUndo) return this;` — operasi yang tak berlaku mengembalikan objek yang sama (total, tanpa error).
- Pengujian terakhir membuktikan batas: dengan `batas: 2`, setelah lima perubahan hanya dua langkah mundur yang tersedia.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Command pattern: tiap perintah tahu cara membalikkan dirinya.
abstract interface class Perintah {
  void jalankan();
  void balikkan();
}
```

| Pendekatan | Kelebihan | Kekurangan |
| --- | --- | --- |
| Snapshot imutabel (`Riwayat`) | Undo/redo sederhana dan pasti benar; mudah dites | Memori O(jumlah langkah × ukuran perubahan); butuh `batas` |
| Command + operasi balik | Hemat memori | Setiap perintah harus punya balikan yang benar; mudah ada bug |
| Event log + replay | Jejak audit lengkap; bisa membangun ulang state kapan saja | Replay dari awal bisa mahal; perlu *snapshot* berkala |
| State mutabel biasa | Paling sedikit kode | Tak ada undo; aliasing dan urutan pembaruan rawan bug |

### E. Terminologi Esensial

- **Reducer** — fungsi murni `(state, peristiwa) → state`. **Peristiwa / aksi** — fakta bahwa sesuatu terjadi, dimodelkan sebagai varian sealed.
- **Replay** — membangun ulang state dengan menerapkan peristiwa berurutan. **Event sourcing** — menyimpan peristiwa sebagai sumber kebenaran.
- **Undo / redo** — membatalkan / mengulang perubahan. **Riwayat (history)** — struktur lampau-kini-depan.
- **Structural sharing** — versi baru membagi bagian yang tak berubah dengan versi lama.

### F. Visualisasi (ASCII)

```text
  lampau (undo)            kini        depan (redo)
  ┌──────────────────┐   ┌─────┐   ┌──────────────────┐
  │ s0 │ s1 │ s2     │   │ s3  │   │ s4 │ s5          │
  └──────────────────┘   └─────┘   └──────────────────┘

  undo()      : kini ← s2 ; depan ← [s3, s4, s5]
  redo()      : kini ← s4 ; lampau ← [..., s3]
  ubah(s6)    : lampau ← [..., s3] ; kini ← s6 ; depan ← []   (cabang redo dibuang)
  batas = 2   : lampau selalu dipangkas ke 2 elemen terakhir
```

```text
  state_0 ──aksi_1──► state_1 ──aksi_2──► state_2 ──aksi_3──► state_3
            reduksi              reduksi              reduksi

  state_n = aksi.fold(state_0, reduksi)       ← replay deterministik
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 3.2 (imutabilitas dan salinan), 3.4 (koleksi sebagai nilai), 2.6 (peristiwa sealed dan `switch` lengkap), 1.2 (fungsi murni).
- **Prasyarat bagi:** 3.7. **Dikembangkan di:** Fase 6 (biaya salinan, struktur persisten), Fase 7 (aliran peristiwa asinkron), Fase 11 (arsitektur berbasis peristiwa).

### H. Tips & Praktik Terbaik

- Jadikan reducer murni dan lengkap; semua efek samping (I/O, waktu) dikerjakan di luar reducer.
- Tentukan `batas` riwayat secara eksplisit berdasarkan ukuran state dan memori yang tersedia.
- Tes reducer dengan `fold` atas urutan peristiwa dan bandingkan dengan state yang diharapkan.
- Simpan peristiwa bila kamu butuh jejak audit; simpan snapshot berkala bila replay dari awal terlalu mahal.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mengubah state di dalam reducer | Undo menghasilkan state yang rusak (aliasing) | Selalu kembalikan nilai baru; jangan memutasi argumen |
| Riwayat tanpa batas | Memori terus bertambah | Terapkan `batas` dan pangkas `lampau` |
| Tidak membuang `depan` saat ada perubahan baru | Redo menghidupkan masa depan yang tak konsisten | `ubah` mengosongkan `depan` |
| Efek samping di reducer | Replay menghasilkan hasil berbeda | Pindahkan efek ke lapisan tepi |
| `_` pada `switch` peristiwa | Peristiwa baru jatuh ke default | Hapus `_`; biarkan kompilator memaksa pembaruan |

### J. Sumber Referensi

- ✔ Percabangan dan exhaustiveness: https://dart.dev/language/branches
- ✔ Class modifiers (`sealed`): https://dart.dev/language/class-modifiers
- Event sourcing (Martin Fowler): https://martinfowler.com/eaaDev/EventSourcing.html
- Struktur data persisten: https://en.wikipedia.org/wiki/Persistent\_data\_structure
- Command pattern: https://en.wikipedia.org/wiki/Command\_pattern

---

## 3.7 Studi Kasus Terpadu: To-Do v2 *(TAMBAHAN)*

*Motivasi: kamu tak sedang menambah fitur; kamu sedang menunjukkan bahwa desain yang benar membuat fitur baru terasa seperti kebetulan.*

> **Mengapa ditambahkan.** Fase 3 paling mudah dipahami lewat *refactor* sesuatu yang sudah kamu kenal. Kita memperluas to-do dari Fase 2.7 dengan tiga perubahan: judul sebagai tipe tervalidasi (`Judul`), `Item` sebagai value object dengan kesetaraan nilai, dan perintah `batal`/`ulang` berkat riwayat imutabel (3.6). Perhatikan seberapa banyak yang *dipandu kompilator*.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Langkah & kode · D Variasi · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Kamu memperbarui `lib/todo.dart` dari Fase 2.7: (1) `Judul` extension type yang menolak judul kosong, (2) `Item` bernilai (`==`, `hashCode`), (3) `Perintah` bertambah `Batal` dan `Ulang`, (4) `jalankan` bekerja pada `Riwayat<List<Item>>`. Shell I/O di `bin/` nyaris tak berubah — buktinya bahwa inti murni dan tepi tipis itu berguna.

### B. Konsep Kunci & Filosofi Mendalam

- **Parse, don't validate di tepi.** Pengurai mengubah teks mentah menjadi `Judul` yang sah *sekali*; `Perintah.Tambah` membawa `Judul`, bukan `String`. `jalankan` tak perlu memvalidasi ulang — tipe adalah buktinya (3.5).
- **Imutabel + kesetaraan nilai.** `Item` menjadi value object: dua `Item` dengan judul dan status sama adalah setara, dan `hashCode` konsisten (3.1, 3.3).
- **Undo/redo = akibat desain.** Karena `daftar` tak pernah dimutasi, setiap versi lama tetap utuh; `Riwayat` hanya menyimpannya (3.6).
- **Refactor dipandu kompilator.** Mengubah `Item.judul` dari `String` menjadi `Judul` menimbulkan galat kompilasi di setiap tempat yang membuat `Item` dari string mentah; menambah `Batal` dan `Ulang` ke `Perintah` yang sealed menimbulkan galat di setiap `switch` yang belum menanganinya.
- **Fungsi tetap total.** `jalankan` untuk `Batal`/`Ulang` yang tak berlaku mengembalikan pesan, bukan exception.
- **Dampak desain:** fitur baru (undo/redo) mengubah satu fungsi dan satu class baru, bukan seluruh aplikasi; kontrak tiap lapisan tetap utuh.

### C. Langkah, Sintaks, dan Kode

**Langkah 1 — tipe domain `Judul` dan value object `Item`.**

```dart
import 'package:meta/meta.dart';

extension type const Judul._(String _teks) {
  static Judul? coba(String teks) {
    final t = teks.trim();
    return t.isEmpty ? null : Judul._(t);
  }

  factory Judul.dari(String teks) =>
      coba(teks) ??
      (throw ArgumentError.value(teks, 'teks', 'judul tidak boleh kosong'));

  String get teks => _teks;
}

@immutable
class Item {
  const Item(this.judul, {this.selesai = false});
  final Judul judul;
  final bool selesai;

  Item tandaiSelesai() => Item(judul, selesai: true);

  @override
  bool operator ==(Object other) =>
      other is Item && other.judul.teks == judul.teks && other.selesai == selesai;

  @override
  int get hashCode => Object.hash(judul.teks, selesai);
}
```

- `Item(this.judul, ...)` kini menerima `Judul`; memanggil `Item('roti')` dengan `String` mentah tak lagi dikompilasi.
- `==` dan `hashCode` memakai `judul.teks` (sebuah `String`) dan `selesai`; keduanya memakai himpunan field yang sama (kontrak 3.1).
- `@immutable` dan semua field `final`: aman dijadikan elemen `Set` atau kunci `Map`.

**Langkah 2 — perintah baru dan pengurai (perubahan dari Fase 2.7).**

```dart
sealed class Perintah {
  const Perintah();
}

class Tambah extends Perintah {
  const Tambah(this.judul);
  final Judul judul; // sebelumnya String
}

class Selesai extends Perintah {
  const Selesai(this.nomor);
  final int nomor;
}

class Hapus extends Perintah {
  const Hapus(this.nomor);
  final int nomor;
}

class Tampilkan extends Perintah {
  const Tampilkan();
}

class Bantuan extends Perintah {
  const Bantuan();
}

class Batal extends Perintah {
  const Batal();
}

class Ulang extends Perintah {
  const Ulang();
}

// (sealed class Urai, UraiBerhasil, UraiGagal, dan _uraiNomor tidak berubah dari Fase 2.7)

Urai uraiPerintah(List<String> args) => switch (args) {
      [] || ['bantuan'] => const UraiBerhasil(Bantuan()),
      ['daftar'] => const UraiBerhasil(Tampilkan()),
      ['batal'] => const UraiBerhasil(Batal()),
      ['ulang'] => const UraiBerhasil(Ulang()),
      ['daftar' || 'bantuan' || 'batal' || 'ulang', ...] =>
        const UraiGagal('perintah ini tidak menerima argumen'),
      ['tambah'] => const UraiGagal('pemakaian: tambah <judul>'),
      ['tambah', ...final kata] => _uraiTambah(kata),
      ['selesai', final teks] => _uraiNomor(teks, Selesai.new),
      ['hapus', final teks] => _uraiNomor(teks, Hapus.new),
      ['selesai' || 'hapus', ...] =>
        const UraiGagal('pemakaian: selesai atau hapus diikuti <nomor>'),
      _ => UraiGagal('perintah tidak dikenal: ${args.first}'),
    };

Urai _uraiTambah(List<String> kata) {
  final judul = Judul.coba(kata.join(' '));
  if (judul == null) return const UraiGagal('judul tidak boleh kosong');
  return UraiBerhasil(Tambah(judul));
}
```

- `Tambah.judul` bertipe `Judul`: pengurai menjadi *satu-satunya* tempat teks mentah diubah menjadi judul yang sah.
- `_uraiTambah`: guard clause dengan `null` — setelah baris `if`, `judul` terpromosi menjadi `Judul` (modul 2.3).
- Menambah `Batal` dan `Ulang` ke sealed class membuat setiap `switch` atas `Perintah` yang belum diperbarui gagal dikompilasi — itulah jaring pengaman yang kita bangun di 2.6.

**Langkah 3 — eksekutor atas riwayat (menggantikan `jalankan` dari Fase 2.7).**

```dart
const _bantuan = <String>[
  'pemakaian:',
  '  tambah <judul>    menambah tugas',
  '  selesai <nomor>   menandai tugas selesai',
  '  hapus <nomor>     menghapus tugas',
  '  daftar            menampilkan semua tugas',
  '  batal             membatalkan perubahan terakhir',
  '  ulang             mengulang perubahan yang dibatalkan',
];

List<String> _format(List<Item> daftar) {
  if (daftar.isEmpty) return const ['(kosong)'];
  return [
    for (var i = 0; i < daftar.length; i++)
      '${i + 1}. [${daftar[i].selesai ? 'x' : ' '}] ${daftar[i].judul.teks}',
  ];
}

/// Murni. Mengembalikan riwayat baru dan baris keluaran.
(Riwayat<List<Item>>, List<String>) jalankan(
  Riwayat<List<Item>> r,
  Perintah perintah,
) {
  final daftar = r.kini;
  return switch (perintah) {
    Bantuan() => (r, _bantuan),
    Tampilkan() => (r, _format(daftar)),
    Batal() when !r.bisaUndo => (r, ['tidak ada yang dibatalkan']),
    Batal() => (r.undo(), ['dibatalkan']),
    Ulang() when !r.bisaRedo => (r, ['tidak ada yang diulang']),
    Ulang() => (r.redo(), ['diulang']),
    Tambah(:final judul) => (
        r.ubah([...daftar, Item(judul)]),
        ['ditambah: ${judul.teks}'],
      ),
    Selesai(:final nomor) when nomor < 1 || nomor > daftar.length =>
      (r, ['nomor $nomor tidak ada']),
    Selesai(:final nomor) => (
        r.ubah([
          for (var i = 0; i < daftar.length; i++)
            if (i == nomor - 1) daftar[i].tandaiSelesai() else daftar[i],
        ]),
        ['selesai: nomor $nomor'],
      ),
    Hapus(:final nomor) when nomor < 1 || nomor > daftar.length =>
      (r, ['nomor $nomor tidak ada']),
    Hapus(:final nomor) => (
        r.ubah([...daftar.sublist(0, nomor - 1), ...daftar.sublist(nomor)]),
        ['dihapus: nomor $nomor'],
      ),
  };
}
```

- `Riwayat<List<Item>>` — state adalah `List<Item>`; `r.kini` dibaca, tidak pernah dimutasi.
- `Batal() when !r.bisaUndo` dan `Batal()` — pasangan kasus ber-guard dan tanpa guard, sehingga kelengkapan terbukti dan operasi tak berlaku menghasilkan pesan.
- `r.ubah([...daftar, Item(judul)])` — state baru berupa list baru; versi lama tetap di `lampau`.
- Item di dalam list dibagi antar versi (tidak disalin) karena imutabel; hanya list pembungkusnya yang dibuat ulang.

**Langkah 4 — shell tipis (`bin/logika_fase3.dart`).**

```dart
import 'dart:io';

import 'package:logika_fase3/todo.dart';

void main() {
  var riwayat = Riwayat<List<Item>>.mulai(<Item>[]);
  while (true) {
    stdout.write('todo> ');
    final baris = stdin.readLineSync();
    if (baris == null) break; // akhir masukan (Ctrl-D)
    final token = baris.split(' ').where((t) => t.isNotEmpty).toList();
    switch (uraiPerintah(token)) {
      case UraiGagal(:final alasan):
        stderr.writeln('galat: $alasan');
      case UraiBerhasil(:final perintah):
        final (baru, keluaran) = jalankan(riwayat, perintah);
        riwayat = baru;
        keluaran.forEach(stdout.writeln);
    }
  }
}
```

```text
todo> tambah beli roti
ditambah: beli roti
todo> tambah kirim laporan
ditambah: kirim laporan
todo> selesai 1
selesai: nomor 1
todo> hapus 2
dihapus: nomor 2
todo> daftar
1. [x] beli roti
todo> batal
dibatalkan
todo> daftar
1. [x] beli roti
2. [ ] kirim laporan
todo> batal
dibatalkan
todo> daftar
1. [ ] beli roti
2. [ ] kirim laporan
todo> ulang
diulang
todo> daftar
1. [x] beli roti
2. [ ] kirim laporan
```

- Perbedaan dari Fase 2.7 hanya di dua baris: `var riwayat = Riwayat<List<Item>>.mulai(...)` dan memperlakukan hasil `jalankan` sebagai riwayat baru. Tepi tetap satu-satunya yang punya variabel yang berubah.

**Langkah 5 — test (`test/todo_test.dart`).**

```dart
import 'package:logika_fase3/todo.dart';
import 'package:test/test.dart';

void main() {
  group('Judul', () {
    test('memangkas spasi dan menolak kosong', () {
      expect(Judul.coba('  roti  ')?.teks, 'roti');
      expect(Judul.coba('   '), isNull);
    });
    test('dari() melempar ArgumentError untuk judul kosong', () {
      expect(() => Judul.dari(' '), throwsArgumentError);
    });
  });

  group('Item bernilai', () {
    test('kesetaraan nilai dan hashCode konsisten', () {
      final a = Item(Judul.dari('roti'));
      final b = Item(Judul.dari('roti'));
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect({a, b}.length, 1);
      expect(a.tandaiSelesai() == a, isFalse);
    });
  });

  group('riwayat', () {
    test('undo dan redo mengembalikan state persis', () {
      var r = Riwayat<List<Item>>.mulai(<Item>[]);
      (r, _) = jalankan(r, Tambah(Judul.dari('roti')));
      (r, _) = jalankan(r, const Selesai(1));
      expect(r.kini.single.selesai, isTrue);
      (r, _) = jalankan(r, const Batal());
      expect(r.kini.single.selesai, isFalse);
      (r, _) = jalankan(r, const Ulang());
      expect(r.kini.single.selesai, isTrue);
    });

    test('perubahan baru setelah undo membuang cabang redo', () {
      var r = Riwayat<List<Item>>.mulai(<Item>[]);
      (r, _) = jalankan(r, Tambah(Judul.dari('a')));
      (r, _) = jalankan(r, const Batal());
      (r, _) = jalankan(r, Tambah(Judul.dari('b')));
      expect(r.bisaRedo, isFalse);
      final (_, keluaran) = jalankan(r, const Ulang());
      expect(keluaran.single, 'tidak ada yang diulang');
    });

    test('operasi tak berlaku tidak mengubah apa pun', () {
      final awal = Riwayat<List<Item>>.mulai(<Item>[]);
      for (final p in const <Perintah>[Batal(), Ulang(), Selesai(1), Hapus(1)]) {
        final (r, keluaran) = jalankan(awal, p);
        expect(r.kini, isEmpty);
        expect(keluaran, hasLength(1));
      }
    });
  });
}
```

```bash
dart test
```

- `Judul.dari('roti')` — jalur yang melempar, nyaman untuk test karena kita tahu masukannya sah.
- `expect({a, b}.length, 1)` — membuktikan bahwa kesetaraan nilai dan `hashCode` bekerja bersama di `Set`.
- `(r, _) = jalankan(...)` — pola penugasan yang membuang keluaran teks; `r` diperbarui ke riwayat baru.
- Test ketiga mengulang pelajaran 2.7: fungsi inti tetap *total* untuk masukan tak berlaku.

### D. Variasi Kode untuk Logika yang Sama

```dart
// Alternatif 1: simpan DAFTAR PERISTIWA saja, bangun state dengan replay.
List<Item> bangunUlang(List<Perintah> peristiwa) {
  var r = Riwayat<List<Item>>.mulai(<Item>[]);
  for (final p in peristiwa) {
    (r, _) = jalankan(r, p);
  }
  return r.kini;
}
```

| Pendekatan | Kelebihan | Kekurangan |
| --- | --- | --- |
| Riwayat snapshot (utama) | Undo/redo sederhana dan pasti benar | Memori bertambah per langkah; butuh batas |
| Simpan peristiwa + replay | Jejak audit; bisa memutar ulang | Replay dari awal mahal tanpa snapshot berkala |
| Command + operasi balik | Hemat memori | Setiap perintah butuh balikan yang benar |
| `Item` sebagai record `(Judul, bool)` | Tanpa boilerplate kesetaraan | Tak ada method; makna bisa tertukar (3.3) |

### E. Terminologi Esensial

- **Tipe tervalidasi** — tipe yang hanya dapat dibuat lewat jalur yang menjaga invarian. **Refactor dipandu kompilator** — kompilator menunjukkan setiap tempat yang perlu diubah.
- **Total** — terdefinisi untuk semua masukan bertipe benar. **Replay** — membangun state dengan menerapkan peristiwa berurutan.
- **Value object** — objek berdasar nilai dan imutabel. **Parse, don't validate** — ubah data mentah jadi tipe sah sekali di tepi.

### F. Visualisasi (ASCII)

```text
   teks mentah ──► uraiPerintah ──► Perintah (membawa Judul sah)
                         │
                         ▼
   jalankan(Riwayat, Perintah) ──► (Riwayat baru, baris keluaran)     ← murni
                         │
                         ▼
               shell: cetak, simpan riwayat baru                      ← tepi tipis
```

```text
   Fase 2.7                      Fase 3.7  (perubahan)
   ──────────────────────────    ──────────────────────────────────────────
   Item(String judul)            Item(Judul judul)           ← tipe sah
   jalankan(List<Item>, ...)     jalankan(Riwayat<List<Item>>, ...)
   Perintah: 5 varian            Perintah: 7 varian (+ Batal, Ulang)
   (tak ada undo)                undo/redo = akibat imutabilitas + riwayat
```

### G. Hubungan dengan Modul Lain

- **Memakai:** seluruh Fase 3 (3.1 kesetaraan, 3.2 imutabilitas, 3.3 value object, 3.4 koleksi, 3.5 tipe tervalidasi, 3.6 riwayat) serta Fase 2 (sealed, pola, null safety) dan Fase 1 (kontrak, test).
- **Dikembangkan di:** Fase 4 (memindahkan `jalankan` dan `Riwayat` ke class dengan method), Fase 5 (persistensi dan kegagalan I/O), Fase 6 (biaya riwayat, struktur persisten), Fase 10 (property-based: `undo` setelah `ubah` mengembalikan state awal).

### H. Tips & Praktik Terbaik

- Setiap kali menambah fitur, tanyakan lebih dulu: *tipe apa yang membuat kesalahan fitur ini mustahil ditulis?*
- Biarkan galat kompilasi memandu refactor; jangan menekannya dengan `as` atau `!`.
- Tulis test properti manual: setelah `ubah`, `undo` mengembalikan state sebelumnya; `redo` setelah `undo` mengembalikan state sesudahnya.
- Tentukan `batas` riwayat sebagai keputusan tertulis, bukan angka ajaib.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Memvalidasi judul di `jalankan` dan di pengurai | Aturan ganda yang bisa saling bertentangan | Validasi sekali di pengurai; `jalankan` percaya pada tipe `Judul` |
| `Item` dengan field `String judul` | Judul kosong lolos | Ganti ke `Judul`; ikuti galat kompilasi |
| Mutasi `daftar` langsung | Undo mengembalikan state rusak | Selalu buat list baru dengan spread |
| Riwayat tanpa batas | Memori terus bertambah | Terapkan `batas` |
| `==` pada `Item` tanpa `hashCode` | `Set` dan `Map` berperilaku ganjil | Selalu timpa keduanya (lint `hash_and_equals`) |
| Mengandalkan `is Judul` | Selalu lolos untuk `String` mana pun | Jaga validitas lewat konstruktor privat |

### J. Sumber Referensi

- Extension types: https://dart.dev/language/extension-types
- ✔ Pola dan use case: https://dart.dev/language/patterns
- ✔ Class modifiers (`sealed`): https://dart.dev/language/class-modifiers
- ✔ Pengujian di Dart: https://dart.dev/tools/testing
- ✔ Lint `hash_and_equals`: https://dart.dev/tools/linter-rules/hash\_and\_equals
- Event sourcing: https://martinfowler.com/eaaDev/EventSourcing.html

---

## Latihan Fase 3 (sengaja tanpa kunci jawaban)

Kerjakan sendiri, jalankan dengan `--enable-asserts`, lalu commit dengan struktur `fase-3/latihan-N/` berisi `README.md` (spesifikasi + tabel contoh), `lib/`, dan `test/`.

1. **\[3.1\]** Tulis kelas `Uang` (jumlah `int`, kode mata uang `String`) **tanpa** `==`. Tunjukkan tiga bug yang muncul (duplikat di `Set`, `contains` gagal, lookup `Map` gagal). Perbaiki dengan `==`/`hashCode`, lalu tulis test untuk hukum kesetaraan: refleksif, simetris, transitif, konsisten, dan `hashCode` sama untuk objek setara.
2. **\[3.2\]** Ambil kelas mutabel dengan setter bertebaran (mis. `Pesanan`), ubah menjadi imutabel dengan `copyWith`. Hitung berapa tempat di pemanggil yang harus berubah, dan catat dua situasi di mana versi imutabel justru lebih mahal atau lebih rumit.
3. **\[3.3\]** Buat `Profil.copyWith` yang dapat mengosongkan field nullable dengan tiga cara: pembungkus fungsi, nilai penjaga (sentinel), dan tipe `Opsi<T>` sealed. Bandingkan keterbacaan pemanggil, keamanan tipe, dan jumlah kode.
4. **\[3.4\]** Buktikan lewat program perbedaan `UnmodifiableListView` dan `List.unmodifiable` (ubah sumber, amati keduanya). Rancang satu kelas yang mengekspos koleksi dengan tiga cara (view, snapshot, `Iterable`), tulis tabel biaya (O(1) vs O(n)), dan jelaskan kapan memilih masing-masing.
5. **\[3.5\]** Ambil model dengan empat flag boolean. Hitung seluruh kombinasinya dan tandai yang ilegal. Ubah menjadi `sealed class`, lalu catat berapa `switch` yang dipaksa kompilator untuk berubah dan kombinasi apa yang kini mustahil ditulis.
6. **\[3.5\]** Buat extension type `Email` dan `Rupiah` (satuan sen) dengan validasi. Tunjukkan bahwa `Rupiah` dan `Dolar` tak dapat tertukar saat kompilasi. Lalu uji sendiri apa yang terjadi pada `is` dan `as` saat runtime, dan tulis kesimpulanmu tentang batas keamanan yang diberikan extension type.
7. **\[3.6\]** Tulis reducer untuk keranjang belanja (tambah, hapus, ubah jumlah, kosongkan) dengan peristiwa `sealed`. Tulis test replay (`fold` peristiwa menghasilkan state akhir), lalu tambahkan undo/redo dengan `Riwayat` dan atur `batas`. Jelaskan secara kualitatif apa yang terjadi pada memori bila `batas` sangat besar.
8. **\[3.7\]** Tambahkan ke To-Do v2: tipe `Nomor` tervalidasi (menggantikan `int` mentah), perintah `ubah <nomor> <judul baru>`, dan `batas` riwayat sebagai opsi. Catat setiap titik di mana kompilator memandu perubahan, dan setiap titik di mana kamu harus berpikir sendiri.

---

## Ringkasan Fase 3 & Daftar Periksa Kelulusan

| Modul | Satu kalimat inti |
| --- | --- |
| 3.1 | Bedakan identitas dari nilai; `==` dan `hashCode` adalah kontrak, bukan kebiasaan. |
| 3.2 | Imutabilitas membuang kelas bug aliasing dan kunci bermutasi; waspadai imutabilitas yang hanya dangkal. |
| 3.3 | Record untuk data kecil dan kunci, class untuk konsep bernama dan berinvarian; `copyWith` butuh perhatian pada field nullable. |
| 3.4 | Ekspos kemampuan atas koleksi, bukan koleksinya: view, snapshot, atau salinan sesuai kebutuhan pembaca. |
| 3.5 | Buat keadaan ilegal mustahil ditulis dengan `sealed`, tipe tervalidasi, dan typestate; parse sekali di tepi. |
| 3.6 | State adalah nilai: reducer murni, replay deterministik, riwayat imutabel dengan batas memori. |
| 3.7 | Refactor yang dipandu kompilator: tipe baru dan varian baru menunjukkan sendiri semua yang harus berubah. |

**Daftar periksa kelulusan** (jawab tanpa membuka dokumen):

- [ ] Aku bisa menjelaskan beda identitas dan nilai, serta menulis `==` dan `hashCode` yang memenuhi kontrak untuk sebuah kelas.
- [ ] Aku bisa mendemonstrasikan bug kunci `Map` yang bermutasi dan menjelaskan mengapa kelas bernilai harus imutabel.
- [ ] Aku bisa membedakan imutabel dangkal dari dalam, dan menunjukkan salinan defensif pada konstruktor yang menerima koleksi.
- [ ] Aku bisa memilih antara record, class, dan extension type untuk sebuah data, serta menjelaskan jebakan alias `typedef` pada record.
- [ ] Aku bisa menulis `copyWith` yang dapat mengosongkan field nullable, dan menjelaskan mengapa `x ?? this.x` gagal.
- [ ] Aku bisa menjelaskan perbedaan view dan snapshot pada koleksi, serta kapan memilih masing-masing.
- [ ] Aku bisa mengubah tumpukan flag boolean menjadi `sealed class` dan menjelaskan kombinasi ilegal yang kini mustahil.
- [ ] Aku bisa menjelaskan mengapa `is`/`as` tidak dapat dijadikan pengaman pada extension type.
- [ ] Aku bisa menulis reducer murni dan riwayat undo/redo dengan batas memori.
- [ ] Delapan latihan sudah di-commit dengan tabel contoh dan test.

**Pratinjau Fase 4 — Logika di Dalam Fungsi & Class.** Di mana logika diletakkan dan dengan berapa cara ia dipanggil: fungsi tingkat atas, method, static, extension, mixin, kelas yang dapat dipanggil (`call`), closure, dan *tear-off*; konstruktor generatif, bernama, factory, dan redirecting; parameter posisional, bernama, dan opsional; method chaining dan cascade; menjaga invarian objek lewat enkapsulasi; komposisi vs pewarisan; serta injeksi dependensi sederhana. Prasyaratnya adalah daftar periksa di atas terpenuhi.

---

## Referensi Induk Fase 3

> **Catatan verifikasi.** Tanda ✔ berarti halaman tersebut dibuka dan diverifikasi lewat pencarian saat dokumen ini disusun (13 November 2026); beberapa di antaranya dibuka melalui cermin resmi `dart.cn` dengan jalur yang sama. Tautan tanpa tanda adalah halaman resmi atau baku yang stabil, tetapi belum diverifikasi ulang; bila ada yang berpindah, cari judulnya di dart.dev.

**Dokumentasi resmi Dart**

- ✔ Record: https://dart.dev/language/records
- ✔ Primary constructors: https://dart.dev/language/primary-constructors · ✔ Pengumuman Dart 3.13: https://dart.dev/blog/announcing-dart-3-13 · ✔ Latar desain: https://dart.dev/blog/bringing-primary-constructors-to-dart
- ✔ Dart 3.3 dan extension types: https://dart.dev/blog/new-in-dart-3-3-extension-types-javascript-interop-and-more · Extension types: https://dart.dev/language/extension-types
- ✔ Lint `hash_and_equals`: https://dart.dev/tools/linter-rules/hash\_and\_equals · ✔ Lint `avoid_equals_and_hash_code_on_mutable_classes`: https://dart.dev/lints/avoid\_equals\_and\_hash\_code\_on\_mutable\_classes
- ✔ Class modifiers: https://dart.dev/language/class-modifiers · ✔ Percabangan: https://dart.dev/language/branches · ✔ Pola: https://dart.dev/language/patterns · ✔ Pengujian: https://dart.dev/tools/testing
- Konstruktor: https://dart.dev/language/constructors · Variabel: https://dart.dev/language/variables · Koleksi: https://dart.dev/language/collections · Effective Dart (desain): https://dart.dev/effective-dart/design
- API: https://api.dart.dev/stable/dart-core/Object/hash.html · https://api.dart.dev/stable/dart-core/identical.html · https://api.dart.dev/stable/dart-core/List/List.unmodifiable.html
- Paket: https://pub.dev/packages/meta · https://pub.dev/documentation/collection/latest/collection/collection-library.html · https://pub.dev/packages/built\_collection

**Konsep dan teori**

- Relasi ekuivalensi: https://en.wikipedia.org/wiki/Equivalence\_relation · Struktur data persisten: https://en.wikipedia.org/wiki/Persistent\_data\_structure · Prinsip hak akses minimum: https://en.wikipedia.org/wiki/Principle\_of\_least\_privilege
- Alexis King, *Parse, don't validate*: https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/
- Yaron Minsky, *Make illegal states unrepresentable*: https://blog.janestreet.com/effective-ml-revisited/
- Event sourcing: https://martinfowler.com/eaaDev/EventSourcing.html · Command pattern: https://en.wikipedia.org/wiki/Command\_pattern

**Buku bacaan lanjutan (tanpa tautan)**

- S. Wlaschin, *Domain Modeling Made Functional* — tipe jumlah, tipe domain, dan pemodelan tanpa keadaan ilegal.
- J. Bloch, *Effective Java* (bab tentang `equals`, `hashCode`, dan imutabilitas) — kontrak kesetaraan yang berlaku lintas bahasa.
- M. Kleppmann, *Designing Data-Intensive Applications* (bagian tentang event log) — gagasan di balik riwayat dan replay.

---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

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

