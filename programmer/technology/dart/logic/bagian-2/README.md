# Membangun Logika Dart — Fase 2: Logika Ekspresi & Aliran Kendali Aman

*Dari kondisi yang benar menjadi kompilator yang ikut menjagamu: ekspresi, null safety, flow analysis, pattern matching, dan exhaustiveness.*

| Atribut | Keterangan |
| --- | --- |
| Level | Beginner → Intermediate |
| Estimasi waktu | 2–3 minggu, ±30–40 jam (teori ±30%, praktik ±70%) |
| Prasyarat | Fase 1 selesai (daftar periksa kelulusan terpenuhi, latihan di-commit) |
| Alat esensial | Dart SDK stabil (rilis stabil per 13 November 2026: 3.14, dirilis 11 November 2026), terminal, `dart analyze`, `dart test`, `dart run --enable-asserts` |
| Batas versi fitur | Pola, `sealed`, record: Dart ≥ 3.0 · promosi field: ≥ 3.2 · wildcard `_` sebagai variabel: ≥ 3.7 · null-aware elements: ≥ 3.8 · dot shorthands: ≥ 3.10 · primary constructors: ≥ 3.13 |
| Komunitas | https://dart.dev/community · tag `dart` di https://stackoverflow.com/questions/tagged/dart · proposal bahasa di https://github.com/dart-lang/language |
| Sertifikasi | Tidak ada sertifikasi resmi khusus; portofolio repositori dengan test dan tabel contoh lebih bernilai |

**Hasil pembelajaran Fase 2** — setelah fase ini kamu mampu:

1. membangun nilai dengan ekspresi (`? :`, `??`, `switch`, `throw`, cascade, collection-if/for) alih-alih variabel setengah-terisi;
2. memperlakukan `null` sebagai bagian dari logika dan memodelkan *ketiadaan* secara sengaja, bukan memaksakannya dengan `!`;
3. memprediksi kapan flow analysis mempromosikan tipe, dan memperbaiki kegagalan promosi dengan benar;
4. membaca dan menulis pola (konstanta, variabel, relasional, logika, cast, null-check, list, map, record, object);
5. memodelkan keputusan sebagai `sealed class`/`enum` agar kompilator membuktikan kelengkapan `switch`;
6. membangun pengurai perintah yang total (menangani semua masukan) dengan inti murni dan lapisan I/O tipis.

---

## Daftar Isi Fase 2

<details>
  <summary>📃 Daftar Isi</summary>

- **0. Audit Kurikulum & Sambungan dari Fase 1**
- **2.1 Pemrograman Berorientasi Ekspresi:** kondisional, switch, throw, cascade, collection-if/for
- **2.2 Null Safety sebagai Logika:** tipe nullable, operator null-aware, `late`, definite assignment
- **2.3 Type Promotion & Flow Analysis** *(TAMBAHAN)*
- **2.4 Pattern Matching I:** anatomi dan pola dasar
- **2.5 Pattern Matching II:** pola struktural dan destrukturisasi
- **2.6 Sealed, Enum, Exhaustiveness, Guard, dan Dominasi**
- **2.7 Studi Kasus Terpadu: Pengurai Perintah CLI** *(TAMBAHAN)*
- **Latihan (tanpa kunci jawaban), Ringkasan, dan Referensi Induk**

</details>

---

## 0. Audit Kurikulum & Sambungan dari Fase 1

1. **Sambungan.** Fase 1 sudah memakai `switch` expression, pola relasional, promosi tipe, dan `sealed` secara sekilas tanpa penjelasan formal. Fase 2 memformalkannya; tidak ada lompatan yang memutus alur.
2. **Peta fase direvisi.** Pada peta usulan Fase 1, null safety dan promosi tipe tidak berdiri sendiri. Audit menemukan bahwa keduanya adalah fondasi logika (bukan sekadar urusan tipe), sehingga dipindahkan ke Fase 2. Fase 8 (statis vs dinamis) kini fokus pada generics, `dynamic`, tipe saat runtime, serta JIT/AOT.
3. **TAMBAHAN:** modul 2.3 (flow analysis dan promosi tipe) dan 2.7 (studi kasus terpadu). Kurikulum lazim melompat dari `if`/`switch` langsung ke `sealed class` tanpa mengajarkan bagaimana kompilator *bernalar* — padahal itulah alasan pola dan exhaustiveness bisa dipercaya.
4. **Catatan versi terkini.** Dart 3.13 (dirilis 12 Agustus 2026) memuat perbaikan atas ketidaksahihan (*unsoundness*) langka pada promosi tipe yang melibatkan fungsi bersarang; ini perubahan *breaking* kecil. Implikasinya dibahas di 2.3: jangan bergantung pada promosi yang melintasi closure yang menulis variabel.
5. **Catatan kecil dari Fase 1.** Dart ≥ 3.6 mendukung pemisah digit pada literal (`1_000_000`). Fase 1 menghindarinya demi kompatibilitas; mulai sekarang boleh dipakai bila batas bawah SDK-mu ≥ 3.6.
6. **Tidak ada koreksi substansial** pada materi Fase 1.

> **Cara memakai dokumen ini** tetap sama: baca, tulis ulang dari ingatan, jalankan, bandingkan. Latihan di akhir tanpa kunci jawaban.

---

## 2.1 Pemrograman Berorientasi Ekspresi

*Motivasi: semakin banyak nilai yang lahir dari satu ekspresi, semakin sedikit tempat bagi bug untuk bersembunyi.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas cara membangun nilai dengan **ekspresi** — `? :`, `??`, ekspresi `switch`, `throw` sebagai ekspresi, cascade `..`, serta collection `if`/`for`/spread/null-aware element — sehingga variabel bisa `final` sejak lahir dan tidak pernah berada dalam keadaan setengah-terisi. Ini fondasi dari semua modul berikutnya: pola, flow analysis, dan exhaustiveness hanya bekerja maksimal pada kode yang berorientasi ekspresi.

### B. Konsep Kunci & Filosofi Mendalam

- **Orientasi ekspresi.** Alih-alih mendeklarasikan `String label;` lalu mengisinya di cabang `if`, tulis `final label = <ekspresi>;`. Variabel `final` yang diisi satu ekspresi tidak bisa lupa terisi di salah satu cabang.
- **Memilih alat:** `a ? b : c` untuk dua jalur sederhana; `a ?? b` untuk cadangan bila `a` null; ekspresi `switch` untuk lebih dari dua jalur atau pola; `if (x case pola)` untuk satu pola; statement `if`/`switch` hanya bila yang dilakukan adalah *aksi*, bukan *nilai*.
- **Ekspresi `switch`:** setiap kasus berbentuk `pola => ekspresi`, dipisah koma, wajib lengkap (exhaustive), dan **tidak boleh mengawali sebuah statement ekspresi** (pakai statement `switch` untuk itu).
- **`throw` adalah ekspresi** bertipe `Never`, sehingga boleh dipakai di tempat nilai: `x ?? (throw StateError('...'))` — mengambil nilai atau gagal keras, tanpa `!`.
- **Cascade** `a..b()..c = 1` menjalankan beberapa operasi pada objek yang sama dan menghasilkan objek itu sendiri; `?..` adalah versi null-aware.
- **Collection literal deklaratif:** `if`, `for`, spread `...` (dan `...?` untuk koleksi yang bisa null), serta *null-aware element* `?x` (Dart ≥ 3.8) yang hanya menyisipkan elemen bila tidak null.
- **Presedensi bukan urutan evaluasi.** Presedensi menentukan *pengelompokan*; operan tetap dievaluasi dari kiri ke kanan. Pada `a() + b() * c()`, urutan pemanggilan tetap `a`, `b`, `c`.
- **Filosofi:** semakin sedikit variabel yang berubah, semakin sedikit state yang harus dilacak (modul 1.2).
- **Dampak desain:** spread `[...a, ...b]` membuat list baru (menyalin O(n)); nyaman, tetapi di jalur panas ukur dulu (Fase 6). Ekspresi `?:` bersarang lebih dari dua tingkat sulit dibaca — pindah ke `switch`.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — dari statement ke ekspresi.**

```dart
// Gaya statement: variabel setengah-terisi; mudah lupa satu cabang.
String labelStok(int stok) {
  String label;
  if (stok <= 0) {
    label = 'Habis';
  } else if (stok < 5) {
    label = 'Menipis';
  } else {
    label = 'Tersedia';
  }
  return label;
}

// Gaya ekspresi: satu nilai, wajib lengkap.
String labelStokEkspresi(int stok) => switch (stok) {
      <= 0 => 'Habis',
      < 5 => 'Menipis',
      _ => 'Tersedia',
    };

void main() {
  assert(labelStokEkspresi(-1) == 'Habis');
  assert(labelStokEkspresi(0) == 'Habis');
  assert(labelStokEkspresi(4) == 'Menipis');
  assert(labelStokEkspresi(5) == 'Tersedia');
  assert(labelStok(5) == labelStokEkspresi(5));
}
```

- `=>` — sintaks fungsi satu-ekspresi: nilai ekspresi di kanan langsung menjadi hasil fungsi.
- `switch (stok) { ... }` — ekspresi `switch`; tiap baris `pola => nilai,`.
- `<= 0` dan `< 5` — pola relasional; kasus diuji dari atas ke bawah, kasus pertama yang cocok menang, sehingga `< 5` otomatis berarti 1 sampai 4.
- `_` — wildcard penampung sisanya; wajib karena kompilator tidak membuktikan kelengkapan rentang numerik.

**Contoh 2 — `throw` sebagai ekspresi.**

```dart
String ambilEnv(Map<String, String> env, String kunci) =>
    env[kunci] ?? (throw StateError('variabel $kunci belum diatur'));

void main() {
  final env = {'MODE': 'prod'};
  assert(ambilEnv(env, 'MODE') == 'prod');
  // ambilEnv(env, 'PORT');  // melempar StateError
}
```

- `env[kunci]` bertipe `String?` karena `Map` bisa tak memuat kunci.
- `?? (throw ...)` — bila kiri null, ekspresi kanan dievaluasi dan melempar; tipe `Never` membuat seluruh ekspresi bertipe `String`. Tanda kurung disarankan agar jelas.

**Contoh 3 — collection deklaratif dan cascade.**

```dart
List<String> menu({required bool admin, String? sponsor}) => [
      'Beranda',
      'Profil',
      if (admin) 'Pengaturan',
      for (final i in [1, 2, 3]) 'Laporan $i',
      ?sponsor,
    ];

void main() {
  final buffer = StringBuffer()
    ..write('Total: ')
    ..write(1500)
    ..writeln(' rupiah');
  print(buffer);
  print(menu(admin: true, sponsor: 'Mitra'));
}
```

- `if (admin) 'Pengaturan'` — elemen masuk hanya bila syarat benar. `for (...) ...` — satu elemen per iterasi.
- `?sponsor` — *null-aware element* (Dart ≥ 3.8): disisipkan hanya bila `sponsor` tidak null; menggantikan `if (sponsor != null) sponsor`.
- `StringBuffer()..write(...)..writeln(...)` — setiap `..` memanggil metode pada buffer yang sama; hasil seluruh ekspresi adalah `StringBuffer` itu.

**Contoh 4 — presedensi bukan urutan evaluasi.**

```dart
int _n = 0;

int langkah(String nama) {
  print('hitung $nama');
  return ++_n;
}

void main() {
  final r = langkah('a') + langkah('b') * langkah('c');
  print(r); // a=1, b=2, c=3 -> 1 + 2 * 3 = 7; cetakan: a, b, c berurutan
}
```

- `*` lebih tinggi dari `+`, jadi dikelompokkan `a + (b * c)`; namun ketiga pemanggilan tetap dijalankan kiri → kanan.
- Pelajaran: jangan menulis ekspresi yang hasilnya bergantung pada urutan efek samping.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// 1) Kondisional bersarang: ringkas, tetapi cepat tak terbaca di atas dua tingkat.
String labelStokTernary(int stok) =>
    stok <= 0 ? 'Habis' : stok < 5 ? 'Menipis' : 'Tersedia';

// 2) Guard clause: bagus bila tiap cabang punya efek atau penjelasan panjang.
String labelStokGuard(int stok) {
  if (stok <= 0) return 'Habis';
  if (stok < 5) return 'Menipis';
  return 'Tersedia';
}
```

| Alat | Pilih bila | Risiko |
| --- | --- | --- |
| `? :` | Dua jalur | Bersarang → sulit dibaca |
| `??` / `??=` | Cadangan bila null / lazy init | Menyembunyikan null yang seharusnya error |
| Ekspresi `switch` | Banyak jalur / pola, wajib lengkap | Tidak untuk blok statement panjang |
| Guard clause | Tiap cabang punya aksi atau komentar | Nilai tersebar di banyak `return` |
| `if` / `switch` statement | Melakukan aksi (efek samping) | Variabel setengah-terisi bila dipakai untuk menghasilkan nilai |
| Cascade `..` | Konfigurasi beruntun satu objek | Salah paham tentang apa yang dikembalikan |

Catatan versi: sejak Dart 3.10, *dot shorthand* memungkinkan menulis `Status s = .running;` bila tipenya jelas dari konteks (setara `Status.running`).

### E. Terminologi Esensial

- **Ekspresi / statement** — menghasilkan nilai / melakukan aksi (modul 1.2). **Orientasi ekspresi** — gaya menyusun program dari ekspresi bernilai.
- **Cascade** — operator `..` yang menjalankan beberapa operasi pada receiver yang sama. **Spread** — `...` menyisipkan isi koleksi lain.
- **Collection if / for** — kendali di dalam literal koleksi. **Null-aware element** — `?x`, sisipkan bila tidak null.
- **Never** — tipe tanpa nilai; hasil `throw` dan fungsi yang tak pernah kembali.
- **Urutan evaluasi** — urutan menghitung operan (kiri → kanan), terpisah dari presedensi.

### F. Visualisasi (ASCII)

```text
Butuh NILAI dari kondisi?
├─ dua jalur sederhana        → a ? b : c
├─ cadangan bila null         → a ?? b
├─ lebih dari dua jalur/pola  → switch expression
├─ satu pola + ikat variabel  → if (x case pola)
└─ yang dilakukan adalah AKSI → if / switch statement
```

```text
 a() + b() * c()

  pengelompokan (presedensi):      urutan eksekusi (evaluasi):
        +                           1. a()
       ├─ a()                       2. b()
       └─ *                         3. c()
          ├─ b()                    4. b * c
          └─ c()                    5. a + (b * c)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 1.2 (ekspresi vs statement, `final`), 1.4 (kondisi), 1.6 (guard clause dan ekspresi `switch`).
- **Prasyarat bagi:** 2.2–2.6 (null-aware, pola, exhaustiveness). **Dikembangkan di:** Fase 3 (nilai imutabel dan record), Fase 6 (biaya alokasi spread dan closure).

### H. Tips & Praktik Terbaik

- Jadikan `final x = <ekspresi>;` sebagai bentuk bawaan; pakai `var x;` tanpa nilai awal hanya bila benar-benar perlu.
- Bila ekspresi `?:` memerlukan tanda kurung agar terbaca, ubah menjadi `switch` atau fungsi bernama.
- Gunakan `?x` dan collection-if untuk membangun koleksi; hindari `add` berulang pada list yang sedang dibangun.
- Jangan menaruh efek samping di dalam ekspresi yang urutannya penting.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| `String label;` lalu cabang `if` yang kurang satu | Galat kompilasi atau nilai kosong | Ganti dengan ekspresi `switch` lengkap |
| Ekspresi `switch` di awal statement | Galat sintaks | Pakai statement `switch`, atau bungkus dalam `final x = switch ...` |
| Lupa `...?` pada spread koleksi nullable | Galat tipe atau crash null | Tulis `...?daftar` |
| Mengira presedensi = urutan evaluasi | Hasil bergantung urutan efek samping | Pisahkan langkah ber-efek ke variabel `final` sendiri |
| `?:` bersarang tiga tingkat | Salah baca saat review | Pindah ke `switch` atau guard clause |

### J. Sumber Referensi

- ✔ Percabangan (`if`, `switch`, ekspresi `switch`): https://dart.dev/language/branches
- ✔ Operator (`??`, `??=`, cascade, presedensi): https://dart.dev/language/operators
- Koleksi (spread, collection if/for): https://dart.dev/language/collections
- ✔ Riwayat fitur per rilis (null-aware elements 3.8, dot shorthands 3.10): https://dart.dev/changelog
- Panduan gaya Effective Dart: https://dart.dev/effective-dart/style

---

## 2.2 Null Safety sebagai Logika

*Motivasi: null bukan musuh — ia hanyalah kemungkinan yang belum kamu tulis di kontrakmu.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini memperlakukan tipe nullable (`T?`) sebagai bagian dari **logika**, bukan sekadar aturan tipe: operator `?.`, `?[]`, `??`, `??=`, `!`, hierarki tipe (`Object?`, `Object`, `Null`, `Never`), `late`, dan *definite assignment*. Kamu belajar memodelkan *ketiadaan* secara sengaja dan menolak null di tepi sistem, sehingga di dalam sistem kontrak non-null dijaga oleh kompilator.

### B. Konsep Kunci & Filosofi Mendalam

- **`T?` = himpunan nilai `T` ditambah `null`.** `T` dan `Null` keduanya subtipe `T?`. Kompilator memaksamu menangani kemungkinan *tidak ada* sebelum memakai nilainya — kontrak (modul 1.5) yang ditegakkan oleh tipe.
- **Hierarki tipe:** `Object?` di puncak; `Object` = semua tipe non-null; `Null` = tipe dari satu nilai, `null`; `Never` = tipe tanpa nilai (subtipe semua tipe), hasil `throw` dan fungsi yang tak pernah kembali.
- **Operator:** `?.` (akses aman; bila receiver null, *seluruh rantai* berhenti dan hasilnya null — *null-shorting*), `?[]` (indeks aman), `??` (cadangan), `??=` (isi bila null), `!` (menegaskan non-null; melempar error runtime bila ternyata null), `?..` (cascade aman), `...?` (spread aman), `?x` (elemen aman).
- **Prinsip:** tolak null di tepi, jaga non-null di dalam. Modelkan *ketiadaan* dengan `null` yang disengaja; jangan memakai nilai sentinel (`-1`, string kosong) yang menyamar sebagai data.
- **`late`:** janji bahwa variabel akan diisi sebelum dibaca. `late final x = hitungMahal();` adalah inisialisasi malas (dihitung saat pertama dipakai, hemat resource bila mungkin tak terpakai); membaca sebelum terisi melempar `LateInitializationError`.
- **Definite assignment:** kompilator melacak apakah variabel lokal non-nullable *pasti* sudah terisi di setiap jalur sebelum dibaca.
- **`Map[kunci]` selalu `V?`:** `null` berarti *tidak ada* — atau *ada dengan nilai null* bila `V` sendiri nullable. Pakai `containsKey` bila bedanya penting.
- **Dampak desain:** `!` yang tersebar adalah kontrak tersembunyi yang akan meledak di produksi. Sebaliknya, rantai `?.` yang berlebihan dapat menelan kegagalan: hasil `null` lolos jauh dari sumbernya sehingga bug sulit dilacak (bertentangan dengan *fail-fast*, modul 1.5).

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — rantai null-aware dan null-shorting.**

```dart
class Alamat {
  Alamat(this.kota);
  final String? kota;
}

class Pengguna {
  Pengguna(this.nama, {this.alamat});
  final String nama;
  final Alamat? alamat;
}

String kotaAtauDefault(Pengguna? p) => p?.alamat?.kota ?? 'Tidak diketahui';

void main() {
  assert(kotaAtauDefault(null) == 'Tidak diketahui');
  assert(kotaAtauDefault(Pengguna('Ani')) == 'Tidak diketahui');
  assert(kotaAtauDefault(Pengguna('Budi', alamat: Alamat('Malang'))) == 'Malang');
}
```

- `p?.alamat?.kota` — bila `p` null, sisa rantai tidak dievaluasi dan hasilnya `null`; bila `alamat` null, `kota` tidak diakses.
- `?? 'Tidak diketahui'` — cadangan untuk seluruh rantai. Keputusan *apa arti null di sini* ditulis eksplisit, bukan tersirat.

**Contoh 2 — `??=` dan inisialisasi malas.**

```dart
class Konfigurasi {
  Map<String, String>? _cache;

  Map<String, String> get nilai => _cache ??= _muat();

  Map<String, String> _muat() {
    print('memuat...');
    return {'mode': 'prod'};
  }
}

void main() {
  final k = Konfigurasi();
  print(k.nilai['mode']); // cetak: memuat... lalu prod
  print(k.nilai['mode']); // cetak: prod (tanpa memuat ulang)
}
```

- `_cache ??= _muat()` — bila `_cache` null, panggil `_muat()` dan simpan; ekspresi ini menghasilkan nilai non-null sehingga cocok sebagai hasil getter.
- Ini *memoization* sederhana: biaya pemuatan dibayar sekali (Fase 6).

**Contoh 3 — menolak null di tepi, memakai non-null di dalam.**

```dart
int panjangNama(String? nama) {
  if (nama == null) {
    throw ArgumentError.notNull('nama');
  }
  return nama.length; // nama dipromosikan menjadi String (modul 2.3)
}
```

- `ArgumentError.notNull('nama')` — pelanggaran kontrak API yang pesannya jelas.
- Setelah pemeriksaan, `nama.length` aman tanpa `!`; kompilator tahu jalur null sudah keluar.

**Contoh 4 — `Map` dan arti null.**

```dart
void main() {
  final stok = <String, int>{'apel': 3};
  final a = stok['apel']; // int?  -> 3
  final b = stok['jeruk']; // int?  -> null (tidak ada)
  final c = stok['jeruk'] ?? 0; // keputusan: tidak ada = 0
  print('$a $b $c');

  if (stok case {'apel': final n}) {
    print('apel: $n'); // n bertipe int (bukan int?)
  }
}
```

- Pola map `{'apel': final n}` mencocokkan *hanya bila kunci ada*, lalu mengikat `n` bertipe `int` — jauh lebih jelas daripada `stok['apel']!`.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Beberapa cara menangani String? nama — masing-masing membawa KEPUTUSAN berbeda.
int v1(String? nama) => nama!.length; // crash jika null; pesan error kabur
int v2(String? nama) => nama?.length ?? 0; // null dianggap panjang 0 (apa itu benar?)
int v3(String? nama) => switch (nama) {
      null => throw ArgumentError.notNull('nama'),
      String s => s.length,
    };
int v4(String? nama) {
  if (nama case final s?) return s.length; // pola null-check
  throw ArgumentError.notNull('nama');
}

// Inisialisasi malas dengan late final (alternatif untuk ??= pada field):
class Layanan {
  late final Map<String, String> peta = _bangun();
  Map<String, String> _bangun() => {'a': '1'};
}
```

| Opsi | Arti null | Kapan |
| --- | --- | --- |
| `nama!` | Mustahil terjadi (janji) | Hanya bila invarian benar-benar menjamin; sebaiknya dihindari |
| `?.` + `??` | Null punya nilai pengganti yang sah | Nilai bawaan memang bagian dari spesifikasi |
| `switch`/pola | Null adalah kasus tersendiri | Perilaku null berbeda dan harus eksplisit |
| `ArgumentError.notNull` | Pelanggaran kontrak | Parameter wajib terisi |
| `late final` | Baru terisi nanti | Inisialisasi malas; tidak bisa di-reset |

### E. Terminologi Esensial

- **Nullable / non-nullable** — tipe yang boleh / tidak boleh bernilai null. **Null-shorting** — rantai berhenti begitu ada receiver null.
- **Null-aware operator** — keluarga operator `?.`, `??`, `??=`, `?[]`, `...?`, `?..`. **Null assertion** — `!`.
- **Tipe atas / bawah (top / bottom type)** — `Object?` / `Never`. **Sentinel** — nilai khusus yang dipakai sebagai pengganti ketiadaan (hindari).
- **`late`** — penunda inisialisasi; **definite assignment** — bukti bahwa variabel pasti terisi sebelum dibaca.

### F. Visualisasi (ASCII)

```text
Object?                         (puncak: segala nilai, termasuk null)
├── Object                      (semua tipe NON-null: int, String, List, ...)
│     ├── int, String, ...
│     └── ...
└── Null                        (tipe dari satu-satunya nilai: null)

Never                           (dasar: subtipe SEMUA tipe; tak punya nilai)
```

```text
 p?.alamat?.kota ?? 'Tidak diketahui'

 p == null ?─ya─► seluruh rantai null ─┐
    │tidak                              ├─► ?? → 'Tidak diketahui'
    ▼                                   │
 p.alamat == null ?─ya─► null ──────────┤
    │tidak                              │
    ▼                                   │
 alamat.kota (String?) ─ null? ─ya──────┘
    │tidak
    └─► nilai kota
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 1.5 (kontrak: `ArgumentError`), 1.4 (kondisi dan short-circuit), 2.1 (`??` dan `throw` sebagai ekspresi).
- **Prasyarat bagi:** 2.3 (promosi tipe), 2.4–2.5 (pola null-check dan null-assert). **Dikembangkan di:** Fase 3 (memodelkan keadaan opsional dengan tipe, bukan null), Fase 5 (null vs kegagalan).

### H. Tips & Praktik Terbaik

- Setiap `!` adalah klaim yang harus bisa kamu buktikan; bila tidak, ganti dengan pemeriksaan eksplisit atau pola.
- Putuskan di spesifikasi apa arti `null` untuk tiap parameter dan hasil (*tidak ada*, *belum diisi*, atau *tidak berlaku*).
- Jangan mengembalikan `null` untuk menandai *error*; null berarti *tidak ada*. Kegagalan memakai exception atau tipe hasil (Fase 5).
- Pakai `late` hanya bila inisialisasi memang harus ditunda; jangan sebagai cara membungkam kompilator.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| `map[kunci]!` di mana-mana | Crash saat kunci tak ada | Pola map, `containsKey`, atau `??` dengan keputusan eksplisit |
| Sentinel (`-1`, string kosong) sebagai ketiadaan | Data palsu lolos validasi | Pakai tipe nullable atau tipe yang lebih tepat |
| Rantai `?.` yang menelan kegagalan | Hasil null muncul jauh dari sebabnya | Validasi di tepi, jangan sembarang mem-null-kan |
| `late` dibaca sebelum diisi | `LateInitializationError` | Inisialisasi di deklarasi atau konstruktor; pertimbangkan `final` |
| `Map<String, int?>` lalu `map[k] == null` | Tak bisa membedakan *tak ada* dan *ada tapi null* | Gunakan `containsKey` |

### J. Sumber Referensi

- Null safety (ikhtisar): https://dart.dev/null-safety
- Memahami null safety (hierarki tipe, `late`, flow analysis): https://dart.dev/null-safety/understanding-null-safety
- ✔ Operator null-aware: https://dart.dev/language/operators
- Variabel dan `late`: https://dart.dev/language/variables
- API `Null`: https://api.dart.dev/stable/dart-core/Null-class.html · API `Never`: https://api.dart.dev/stable/dart-core/Never-class.html
- Tony Hoare, *Null References: The Billion Dollar Mistake*: https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare/

---

## 2.3 Type Promotion & Flow Analysis *(TAMBAHAN)*

*Motivasi: ketika kamu tahu apa yang dibuktikan kompilator, kamu berhenti melawannya dan mulai memakainya.*

> **Mengapa ditambahkan.** Audit menemukan bahwa pembelajar sering memakai `!` atau `as` karena promosi tipe "tidak bekerja", padahal penyebabnya hampir selalu terbaca. Modul ini mengajarkan cara kompilator bernalar, agar pola (2.4–2.5) dan exhaustiveness (2.6) terasa wajar.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini menjelaskan **flow analysis**: cara kompilator melacak fakta di setiap titik kode — apakah variabel pasti tidak null, bertipe lebih spesifik, sudah pasti terisi, atau apakah kode bisa dijangkau. Dari situ lahir **promosi tipe** (*type promotion*): setelah sebuah pemeriksaan, variabel diperlakukan sebagai tipe yang lebih sempit tanpa `!` maupun `as`. Memahami syarat dan penghalangnya membuat kamu menulis kode yang pembuktiannya bisa diikuti kompilator.

### B. Konsep Kunci & Filosofi Mendalam

- **Flow analysis** melacak fakta per titik kode: *non-null?*, *subtipe apa?*, *pasti terisi?*, *terjangkau?* Fakta itu diperbarui oleh pemeriksaan (`== null`, `is`, pola) dan oleh penugasan.
- **Promosi tipe** terjadi ketika flow analysis dapat memastikan bahwa variabel bertipe `T` sebenarnya menunjuk objek subtipe `S`, dan bahwa nilainya **tidak akan berubah** dari titik itu. Kasus khusus: `T?` dipromosikan ke `T` setelah pemeriksaan null.
- **Pemeriksaan yang memicu promosi:** `if (x == null) return;` (jalur null keluar), `if (x != null)`, `if (x is T)`, serta pola seperti `if (x case final v?)`.
- **Penghalang promosi pada variabel lokal** (daftar resmi alasan kegagalan): ditulis ulang setelah promosi; ditulis pada iterasi loop sebelumnya; di `catch` setelah kemungkinan penulisan di `try`; ketidakcocokan subtipe; penulisan yang ditangkap fungsi lokal; penulisan di luar closure/fungsi saat ini.
- **Promosi properti (field)** baru ada sejak Dart 3.2 dan hanya untuk field yang **`final`, privat, bukan `external`**, dan tidak ada getter atau field non-final lain **dengan nama sama di library yang sama**. Field publik tidak dipromosikan karena library lain bisa menimpanya dengan getter yang tak stabil. `this` tidak dapat dipromosikan.
- **Obat umum:** salin nilainya ke variabel lokal `final`, lalu periksa salinan itu; atau pakai pola `if (x case final v?)`. `!` atau `as` adalah pilihan terakhir.
- **Keterjangkauan (reachability):** setelah `return`, `throw`, atau pemanggilan fungsi bertipe `Never`, kode berikutnya tak terjangkau; flow analysis memakainya untuk membuktikan bahwa cabang tertentu tidak pernah sampai ke titik berikutnya.
- **Definite assignment:** `final String x;` boleh dideklarasikan tanpa nilai bila di *setiap jalur* yang sampai ke pemakaian, `x` pasti diisi tepat sekali.
- **Catatan versi:** Dart 3.13 memperbaiki ketidaksahihan langka pada promosi tipe yang melibatkan fungsi bersarang (perubahan *breaking* kecil). Pelajarannya: jangan mengandalkan promosi yang bertahan melintasi closure yang bisa menulis variabel itu.
- **Filosofi:** *stabilitas adalah syarat pembuktian*. Semakin imutabel variabel dan field-mu (modul 1.2), semakin banyak yang bisa dibuktikan kompilator, dan semakin sedikit `!` yang kamu perlukan.
- **Dampak desain:** kode yang terpromosi tidak memerlukan pemeriksaan runtime tambahan; `!` justru menambah pemeriksaan runtime sekaligus titik crash.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — promosi pada variabel lokal dan parameter.**

```dart
int hitung(int? a, Object b) {
  if (a == null) return 0; // sesudah baris ini a bertipe int
  var total = a; // aman tanpa !
  if (b is String) {
    total += b.length; // di dalam blok ini b bertipe String
  }
  return total;
}

void main() {
  assert(hitung(null, 'x') == 0);
  assert(hitung(2, 'abc') == 5);
  assert(hitung(2, 99) == 2);
}
```

- `if (a == null) return 0;` — jalur null berakhir di sini; fakta *a bukan null* berlaku untuk sisa fungsi (selama `a` tak ditulis ulang).
- `b is String` — di dalam blok `if`, `b` diperlakukan sebagai `String`; di luarnya kembali `Object`.

**Contoh 2 — promosi field (Dart ≥ 3.2) dan salinan lokal.**

```dart
class Sesi {
  Sesi(this._token, this.pemilik);

  final String? _token; // final + privat: dapat dipromosikan
  final String? pemilik; // final tetapi PUBLIK: tidak dapat dipromosikan

  int panjangToken() {
    if (_token == null) return 0;
    return _token.length; // OK: _token dipromosikan menjadi String
  }

  int panjangPemilik() {
    final p = pemilik; // salin ke variabel lokal: stabil
    return p == null ? 0 : p.length;
  }

  int panjangPemilikPola() {
    if (pemilik case final p?) return p.length; // pola mengikat salinan lokal
    return 0;
  }
}
```

- `_token` memenuhi syarat: `final`, privat, tak ada nama bentrok di library ini.
- `pemilik` publik: library lain boleh `extends Sesi` dan menimpanya dengan getter yang tiap dibaca berbeda, sehingga promosi tidak sahih.
- `final p = pemilik;` — variabel lokal tak bisa ditulis oleh pihak lain, sehingga promosi sahih.
- Pola `case final p?` mengikat `p` bertipe `String` hanya bila tidak null.

**Contoh 3 — definite assignment dan keterjangkauan.**

```dart
String kategori(int umur) {
  final String hasil; // belum terisi
  if (umur < 0) {
    throw ArgumentError.value(umur, 'umur', 'tidak boleh negatif');
  } else if (umur < 18) {
    hasil = 'anak';
  } else {
    hasil = 'dewasa';
  }
  return hasil; // aman: setiap jalur yang sampai di sini sudah mengisi hasil
}
```

- `final String hasil;` — deklarasi tanpa nilai awal; boleh diisi tepat sekali.
- Cabang `throw` tak pernah mencapai `return`, sehingga tak perlu mengisi `hasil` di sana. Bila ada cabang yang lupa mengisi, kompilator menolak.

**Contoh 4 — apa yang menggagalkan promosi (bentuk umum).**

```dart
void contoh(String? s) {
  if (s == null) return;
  print(s.length); // OK di sini

  void ubah() {
    s = null; // fungsi lokal MENULIS s
  }
  // print(s.length); // analyzer menolak: s tidak lagi bisa dipromosikan (write captured)
  ubah();

  for (var i = 0; i < 3; i++) {
    // s = null;       // bila baris ini aktif, s.length di bawah gagal: ditulis di iterasi sebelumnya
    // print(s.length);
  }
}
```

- Dua situasi ini adalah dua dari alasan resmi kegagalan promosi. Pesan analyzer menyebut alasan persisnya, dan halaman dokumentasi "Fixing type promotion failures" memuat solusi tiap alasan.
- Pelajaran praktis: jangan menulis ulang variabel yang sudah diperiksa, dan hindari menulis variabel dari dalam closure.

### D. Opsi Kode Lain untuk Logika yang Sama

| Situasi | Solusi disarankan | Alternatif (kurang disarankan) |
| --- | --- | --- |
| Field publik nullable | `final x = this.x;` lalu periksa `x` | `this.x!` |
| Field non-final nullable | Jadikan `final` bila bisa; atau salinan lokal | `!` |
| Getter (bukan field) | Simpan hasil getter ke variabel lokal | Memanggil getter dua kali (nilai bisa berbeda) |
| Variabel ditulis di loop atau closure | Ubah desain: jangan tulis ulang; pakai variabel baru | `!` |
| `this` pada extension `on int?` | `final self = this;` lalu periksa `self` | `this!` |
| Satu pemeriksaan sekaligus ikat | `if (x case final v?)` | `if (x != null)` lalu `x!` |

### E. Terminologi Esensial

- **Flow analysis** — analisis aliran yang melacak fakta per titik kode. **Promosi tipe** — penyempitan tipe berdasarkan fakta tersebut.
- **Stabil** — nilainya dijamin tidak berubah antara pemeriksaan dan pemakaian. **Penghalang promosi** — sebab promosi tidak sahih.
- **Definite assignment** — bukti variabel pasti terisi. **Reachability** — apakah suatu titik kode dapat dicapai.
- **Dead code** — kode yang tak pernah tercapai (diperingatkan analyzer). **Unsound** — sistem yang bisa menyimpulkan hal yang salah; sistem tipe Dart dirancang sound.

### F. Visualisasi (ASCII)

```text
void f(String? s) {
  // fakta:  s : String?
  if (s == null) return;          ── jalur null BERAKHIR
  // fakta:  s : String            (hanya jalur non-null yang sampai di sini)
  print(s.length);
}
```

```text
 Apakah promosi berlaku?

  x variabel lokal / parameter?
  ├─ ya  → tidak ditulis di antara cek dan pakai, tak ditulis closure, tak ditulis loop?
  │         ├─ ya  → DIPROMOSIKAN
  │         └─ tidak → gagal (lihat alasan resmi)
  └─ tidak (properti) → final, privat, bukan external, tanpa bentrok nama, Dart ≥ 3.2?
            ├─ ya  → DIPROMOSIKAN
            └─ tidak → salin ke variabel lokal
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 2.2 (tipe nullable), 1.2 (imutabilitas sebagai stabilitas), 1.6 (guard clause menghasilkan promosi).
- **Prasyarat bagi:** 2.4–2.6 (pola null-check dan exhaustiveness memakai prinsip yang sama). **Dikembangkan di:** Fase 3 (field `final` dan privat sebagai desain), Fase 8 (tipe statis dan jaminan soundness).

### H. Tips & Praktik Terbaik

- Jadikan field `final` dan privat sedapat mungkin; itu membuat promosi bekerja *dan* membuat objek lebih mudah dinalar.
- Gunakan guard clause (`if (x == null) return ...;`) untuk mendapatkan promosi pada seluruh sisa fungsi.
- Bila promosi gagal, baca alasan di pesan analyzer dan di halaman dokumentasi alasan promosi; jangan langsung memakai `!`.
- Naikkan batas bawah SDK di `pubspec.yaml` ke ≥ 3.2 bila ingin mengandalkan promosi field.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mengira field publik `final` dipromosikan | Galat "refers to a getter / couldn't be promoted" | Salin ke variabel lokal |
| SDK constraint di bawah 3.2 | Promosi field tak bekerja | Naikkan batas bawah SDK |
| Menulis ulang variabel setelah diperiksa | Promosi hilang | Pakai variabel baru atau susun ulang logika |
| Menulis variabel dari dalam closure | Promosi hilang setelah deklarasi closure | Hindari; kembalikan nilai dari fungsi |
| `!` setelah pemeriksaan null | Redundan dan memberi rasa aman palsu | Hapus `!`; andalkan promosi |
| Memanggil getter dua kali (`if (g != null) g.x`) | Nilai bisa berbeda antar panggilan | Simpan hasil getter ke variabel lokal |

### J. Sumber Referensi

- ✔ Fixing type promotion failures (semua alasan dan solusinya): https://dart.dev/tools/non-promotion-reasons
- Memahami null safety (bagian flow analysis): https://dart.dev/null-safety/understanding-null-safety
- ✔ Changelog (rilis 3.13, perubahan promosi tipe): https://dart.dev/changelog
- ✔ Isu SDK terkait perubahan promosi di 3.13: https://github.com/dart-lang/sdk/issues/62889
- ✔ Pengumuman Dart 3.13: https://dart.dev/blog/announcing-dart-3-13
- Flow-sensitive typing: https://en.wikipedia.org/wiki/Flow-sensitive\_typing

---

## 2.4 Pattern Matching I: Anatomi dan Pola Dasar

*Motivasi: pola mengubah "periksa lalu ambil" menjadi satu kalimat deklaratif — dan kompilator ikut memeriksanya.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas **pola** (*pattern*): kategori sintaks yang menggambarkan *bentuk* sebuah nilai. Pola dapat **mencocokkan** (match), **membongkar** (destructure), dan **mengikat** (bind) variabel sekaligus. Modul ini mencakup tempat pola boleh muncul, perbedaan *refutable* vs *irrefutable*, serta pola dasar: konstanta, variabel, wildcard, relasional, logika, cast, null-check, null-assert, dan pola berkurung. Pola struktural (list, map, record, object) dibahas di 2.5.

### B. Konsep Kunci & Filosofi Mendalam

- **Pola = bentuk.** Pola mewakili *bentuk* himpunan nilai. Bila nilai cocok dengan bentuk itu, pola dapat mengambil bagian dari nilai tersebut dan mengikatnya ke variabel baru.
- **Tempat pola muncul:** deklarasi variabel (`var (a, b) = ...`), penugasan (`(a, b) = (b, a)`), `switch` (statement dan ekspresi), `if-case`, loop `for`/`for-in`, dan collection `if case`.
- **Refutable vs irrefutable.** Pola *refutable* bisa gagal cocok dan hanya muncul di konteks yang menyediakan jalan keluar (kasus `case` dan `if-case`: bila gagal, lanjut ke kasus berikutnya). Pola *irrefutable* dipakai di deklarasi dan penugasan: kegagalan cocok di sana adalah **error runtime**.
- **Pola dasar:**
  - *Konstanta:* literal, konstanta bernama, `const Titik(0, 0)`; ekspresi kompleks harus dibungkus `const (1 + 2)`.
  - *Variabel:* `var x`, `final x`, atau bertipe `int x` (yang terakhir **menguji tipe**).
  - *Wildcard:* `_` mencocokkan apa pun dan membuangnya; `int _` menguji tipe tanpa mengikat.
  - *Relasional:* `< <= > >= == !=` terhadap konstanta.
  - *Logika:* `a || b` dan `a && b`.
  - *Cast:* `p as T`, melempar bila tipe salah. *Null-check:* `p?`, gagal cocok bila null. *Null-assert:* `p!`, melempar bila null.
  - *Berkurung:* `(p)` untuk mengatur presedensi.
- **Presedensi pola** (rendah → tinggi): logical-or, logical-and, relasional, lalu cast/null-check/null-assert sebagai satu tingkat, dan pola primer (konstanta, variabel, wildcard, koleksi, record, object) tertinggi.
- **Identifier punya dua wajah:** di konteks `case`, identifier yang merujuk konstanta menjadi pola konstanta; di deklarasi, ia menjadi pola variabel.
- **Logical-or dan variabel:** bila kedua sisi `||` mengikat variabel, kedua sisi harus mengikat himpunan nama dan tipe yang sama.
- **Urutan kasus bermakna:** kasus pertama yang cocok menang.
- **Filosofi:** deklaratif lebih mudah diaudit daripada rantai `is` dan cast; kompilator ikut memeriksa kelengkapan (2.6).
- **Dampak desain:** pola menggantikan boilerplate pengecekan tipe dan cast yang rawan salah urutan; namun pola yang terlalu cerdik merusak keterbacaan — utamakan kejelasan.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — `switch` dengan pola dasar.**

```dart
String klasifikasi(Object? nilai) => switch (nilai) {
      null => 'kosong',
      int n when n < 0 => 'bilangan bulat negatif: $n',
      int n => 'bilangan bulat: $n',
      double d => 'pecahan: $d',
      String s when s.isEmpty => 'teks kosong',
      String s => 'teks sepanjang ${s.length}',
      bool b => b ? 'ya' : 'tidak',
      _ => 'tipe lain: ${nilai.runtimeType}',
    };

void main() {
  assert(klasifikasi(null) == 'kosong');
  assert(klasifikasi(-3) == 'bilangan bulat negatif: -3');
  assert(klasifikasi(7) == 'bilangan bulat: 7');
  assert(klasifikasi(2.5) == 'pecahan: 2.5');
  assert(klasifikasi('') == 'teks kosong');
  assert(klasifikasi('abc') == 'teks sepanjang 3');
  assert(klasifikasi(true) == 'ya');
  assert(klasifikasi(<int>[]).startsWith('tipe lain'));
}
```

- `null =>` — pola konstanta `null`. `int n =>` — pola variabel bertipe: cocok bila nilai adalah `int`, lalu mengikat `n` bertipe `int`.
- `when n < 0` — *guard*: syarat tambahan; bila salah, kompilator lanjut ke kasus berikutnya.
- Urutan penting: `int n when n < 0` harus sebelum `int n`; kasus umum diletakkan setelah kasus khusus.
- `_` — penampung sisa (wajib karena `Object?` tidak enumerable).

**Contoh 2 — pola relasional dan logika; mengapa `_` tetap perlu.**

```dart
String suhu(num c) => switch (c) {
      < 0 => 'beku',
      >= 0 && < 25 => 'sejuk',
      >= 25 && < 35 => 'hangat',
      >= 35 => 'panas',
      _ => 'tidak valid', // contoh nyata: NaN
    };

void main() {
  assert(suhu(-1) == 'beku');
  assert(suhu(0) == 'sejuk');
  assert(suhu(24.9) == 'sejuk');
  assert(suhu(25) == 'hangat');
  assert(suhu(35) == 'panas');
  assert(suhu(double.nan) == 'tidak valid');
}
```

- `>= 0 && < 25` — pola logical-and dari dua pola relasional; tiap sisi dibandingkan dengan `c`.
- Kompilator tidak membuktikan kelengkapan rentang numerik, dan `double.nan` membuat semua perbandingan bernilai `false`; jadi `_` bukan formalitas, ia menangkap kasus yang tak terpikir.

**Contoh 3 — deklarasi, penugasan, cast, dan null-check.**

```dart
void main() {
  var a = 1;
  var b = 2;
  (a, b) = (b, a); // pola penugasan: tukar tanpa variabel sementara
  print('$a $b'); // 2 1

  String? teks = 'halo';
  if (teks case final t?) {
    print(t.toUpperCase()); // t bertipe String (bukan String?)
  }

  (num, Object) rec = (1, 's');
  var (i as int, s as String) = rec; // pola cast: melempar bila tipe salah
  print('$i $s');
}
```

- `(a, b) = (b, a)` — sisi kanan dihitung dulu menjadi record, lalu didestrukturisasi ke `a` dan `b`; tak ada nilai yang tertimpa sebelum dibaca.
- `case final t?` — pola null-check: bila `teks` tidak null, `t` terikat dengan tipe non-nullable.
- `i as int` — cast di tengah destrukturisasi; salah tipe berarti error runtime (konteks irrefutable).

**Contoh 4 — logical-or dengan variabel, dan konstanta.**

```dart
bool akhirPekan(String hari) => switch (hari) {
      'sabtu' || 'minggu' => true,
      _ => false,
    };

String? sisiBukanNol(List<int> p) => switch (p) {
      [int x, 0] || [0, int x] => 'salah satu nol, lainnya $x',
      _ => null,
    };

void main() {
  assert(akhirPekan('sabtu'));
  assert(!akhirPekan('senin'));
  assert(sisiBukanNol([3, 0]) == 'salah satu nol, lainnya 3');
  assert(sisiBukanNol([0, 4]) == 'salah satu nol, lainnya 4');
  assert(sisiBukanNol([1, 2]) == null);
}
```

- `'sabtu' || 'minggu'` — dua pola konstanta berbagi satu hasil.
- `[int x, 0] || [0, int x]` — kedua sisi mengikat `x` dengan nama dan tipe yang sama (aturan logical-or).

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Sebelum pola: rantai is + promosi; mudah salah urutan dan lupa kasus.
String klasifikasiLama(Object? nilai) {
  if (nilai == null) return 'kosong';
  if (nilai is int) {
    return nilai < 0 ? 'bilangan bulat negatif: $nilai' : 'bilangan bulat: $nilai';
  }
  if (nilai is double) return 'pecahan: $nilai';
  if (nilai is String) {
    return nilai.isEmpty ? 'teks kosong' : 'teks sepanjang ${nilai.length}';
  }
  if (nilai is bool) return nilai ? 'ya' : 'tidak';
  return 'tipe lain: ${nilai.runtimeType}';
}
```

| Gaya | Kelebihan | Kekurangan |
| --- | --- | --- |
| Rantai `is` + `return` | Dikenal luas; bekerja di semua versi Dart | Panjang; kelengkapan tak diperiksa kompilator |
| `switch` + pola | Deklaratif; kelengkapan diperiksa; guard mudah | Butuh Dart ≥ 3.0; pola rumit sulit dibaca |
| `if-case` | Satu pola dengan pengikatan variabel | Hanya satu pola; banyak pola → `switch` |
| `as` / `!` | Singkat | Melempar error runtime; jarang pilihan terbaik |

### E. Terminologi Esensial

- **Pola (pattern)** — kategori sintaks yang menggambarkan bentuk nilai. **Destrukturisasi** — membongkar nilai dan mengikat bagian-bagiannya.
- **Refutable / irrefutable** — dapat / tidak dapat gagal cocok (di konteks irrefutable, gagal = error runtime).
- **Guard (`when`)** — syarat tambahan pada sebuah kasus. **Wildcard** — `_`. **Subpattern** — pola di dalam pola.
- **Pola konstanta / variabel / relasional / logika / cast / null-check / null-assert** — jenis-jenis pola dasar.
- **Dominasi** — kasus yang tak pernah tercapai karena kasus sebelumnya sudah menutupi semua nilainya (dibahas di 2.6).

### F. Visualisasi (ASCII)

```text
 nilai ─► [pola 1] ─ cocok? ─ya─► ikat variabel ─► guard (when)? ─ya─► JALANKAN BADAN
                │ tidak                                   │ tidak
                ▼                                         ▼
            [pola 2] ─ ...                          coba kasus berikutnya
                │
                ▼
               ... ─► tak ada yang cocok? → (wajib ada _ / kelengkapan, 2.6)
```

```text
 PRESEDENSI POLA
 rendah   a || b                  (logical-or)
          a && b                  (logical-and)
          < <= > >= == !=         (relasional)
          p as T    p?    p!      (cast, null-check, null-assert: satu tingkat)
 tinggi   konstanta · var x · _ · ( ) · [ ] · { } · (a, b) · Tipe(...)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 2.1 (ekspresi `switch`), 2.2 (null-check, null-assert), 2.3 (pola mengikat variabel yang terpromosi), 1.4 (relasional dan logika).
- **Prasyarat bagi:** 2.5 (pola struktural) dan 2.6 (exhaustiveness). **Dikembangkan di:** Fase 8 (tipe dan cast saat runtime) dan Fase 9 (menolak bentuk data yang salah dengan pola).

### H. Tips & Praktik Terbaik

- Tulis kasus dari yang paling khusus ke yang paling umum; guard menaikkan kekhususan.
- Pakai `int _` (pola berbentuk tipe tanpa pengikatan) bila hanya menguji tipe.
- Jangan memakai `_` pada `switch` atas `enum` atau `sealed` bila bisa dihindari (modul 2.6).
- Pindahkan pola yang panjang ke fungsi bernama; pola tidak harus semua inline.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Lupa `_` pada tipe tak berhingga | Galat "switch tidak lengkap" | Tambah `_` dengan perilaku yang sengaja dipilih |
| Kasus umum di atas kasus khusus | Kasus khusus tak pernah jalan | Urutkan dari khusus ke umum; tes nilai batas |
| Variabel berbeda di kedua sisi `\|\|` | Galat kompilasi | Samakan nama dan tipe di kedua sisi |
| Menyangka `var x` menguji tipe | Selalu cocok | Tulis `int x` bila ingin menguji tipe |
| Ekspresi kompleks di pola konstanta | Galat sintaks | Bungkus dengan `const (...)` |
| Pola di deklarasi gagal cocok | Error runtime | Pakai `if-case` atau `switch` bila bentuk bisa salah |

### J. Sumber Referensi

- ✔ Pola (tempat, destrukturisasi, use case): https://dart.dev/language/patterns
- ✔ Jenis-jenis pola dan presedensinya: https://dart.dev/language/pattern-types
- ✔ Percabangan, `if-case`, guard, exhaustiveness: https://dart.dev/language/branches
- Spesifikasi pola (referensi lanjutan): https://github.com/dart-lang/language/tree/main/accepted/3.0/patterns
- Pattern matching (konsep umum): https://en.wikipedia.org/wiki/Pattern\_matching

---

## 2.5 Pattern Matching II: Pola Struktural dan Destrukturisasi

*Motivasi: data dunia nyata berbentuk list, map, dan record — belajarlah memeriksa bentuknya dalam satu kalimat.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas pola yang membongkar struktur: **list**, **map**, **record**, dan **object**, beserta *rest element*, destrukturisasi di deklarasi, penugasan, dan `for-in`, serta pemakaian praktis: validasi data bergaya JSON, mengembalikan banyak nilai, dan pemodelan keluarga tipe. Inilah kemampuan yang membuat kode validasi data panjang menjadi satu pola deklaratif.

### B. Konsep Kunci & Filosofi Mendalam

- **Pola list** `[a, b]` mencocokkan list berpanjang **tepat** itu, kecuali ada *rest element*: `[pertama, ..., terakhir]`, `[kepala, ...var sisa]`. Elemen dapat berupa pola apa pun (bersarang).
- **Pola map** `{'kunci': pola}` mencocokkan map yang memuat kunci tersebut dan nilainya cocok dengan sub-pola. Kunci harus konstanta. Pola map **tidak** mewajibkan seluruh isi map cocok — kunci lain diabaikan. Bila kunci tak ada, pola tidak cocok; pada konteks yang tak boleh gagal (deklarasi), dokumentasi menyebut hasilnya error runtime (`StateError`).
- **Pola record** harus cocok dengan **seluruh bentuk** record: jumlah dan nama field harus sama. Bentuk: `(a, b)`, `(x: p, y: q)`, dan singkatan `(:var x, :var y)` yang mengikat variabel bernama sama dengan field.
- **Pola object** `Tipe(prop: pola)` menguji **tipe**, lalu mencocokkan sub-pola pada **getter** objek itu. Tidak perlu menyebut semua properti. Singkatan: `Titik(:final x, :final y)`.
- **Destrukturisasi** juga bekerja di deklarasi (`var (a, b) = f()`), penugasan (`(a, b) = (b, a)`), dan `for-in` (`for (final MapEntry(:key, value: n) in m.entries)`).
- **Prinsip:** validasi bentuk dan ekstraksi data dilakukan **dalam satu langkah**; bentuk yang salah otomatis tidak cocok (fail-safe). Cocok untuk data eksternal yang tak tepercaya (Fase 9).
- **Gaya tipe data aljabar:** pola object + `sealed class` (2.6) membuat keluarga tipe berperilaku berbeda per anggota, dengan kelengkapan diperiksa kompilator.
- **Dampak desain:** pola struktural mengganti rantai `is`/cast/indeks yang rawan salah dengan ungkapan yang bisa dibaca sebagai kalimat; namun pola yang terlalu dalam membuat pesan kegagalan kurang informatif — ketika perlu menjelaskan *mengapa* gagal, pecah menjadi langkah-langkah.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — validasi struktur data dalam satu pola.**

```dart
String? salam(Object? json) {
  if (json case {'user': [String nama, int umur]} when umur >= 0) {
    return 'Halo $nama ($umur tahun)';
  }
  return null;
}

void main() {
  assert(salam({'user': ['Lily', 13]}) == 'Halo Lily (13 tahun)');
  assert(salam({'user': ['Lily']}) == null); // panjang list salah
  assert(salam({'user': ['Lily', -1]}) == null); // guard menolak
  assert(salam({'x': 1}) == null); // kunci tak ada
  assert(salam('bukan map') == null); // tipe salah
}
```

- `{'user': [String nama, int umur]}` — pola map dengan satu kunci; nilainya harus berupa list dua elemen: elemen pertama `String`, kedua `int`; keduanya sekaligus diikat ke `nama` dan `umur`.
- `when umur >= 0` — guard pada `if-case`; bila salah, seluruh pola dianggap tidak cocok.
- Satu ekspresi menggantikan lima pemeriksaan (map? kunci ada? list? panjang 2? tipe elemen?).

**Contoh 2 — mengembalikan banyak nilai dengan record.**

```dart
(int, int) bagiBersisa(int a, int b) => (a ~/ b, a % b);

({int hasil, int sisa}) bagiBernama(int a, int b) =>
    (hasil: a ~/ b, sisa: a % b);

void main() {
  final (q, r) = bagiBersisa(17, 5);
  print('$q sisa $r'); // 3 sisa 2

  final (:hasil, :sisa) = bagiBernama(17, 5);
  print('$hasil sisa $sisa'); // 3 sisa 2
}
```

- `(int, int)` — tipe record posisional; `({int hasil, int sisa})` — record dengan field bernama.
- `final (q, r) = ...` — pola record di deklarasi: dua variabel `final` lahir dari satu pemanggilan.
- `(:hasil, :sisa)` — singkatan: variabel `hasil` dan `sisa` diambil dari field bernama yang sama.
- Catatan kontrak (1.5): `bagiBersisa(x, 0)` melempar error karena pembagian nol; precondition `b != 0` tetap harus ditegakkan.

**Contoh 3 — pola list untuk argumen perintah, dan rest element.**

```dart
String arahan(List<String> args) => switch (args) {
      ['versi'] => 'v1.0',
      ['tambah', String nama] => 'menambah $nama',
      ['hapus', String nama, ...] => 'menghapus $nama',
      [String perintah, ...] => 'perintah tidak dikenal: $perintah',
      _ => 'bantuan', // hanya list kosong yang sampai ke sini
    };

void main() {
  assert(arahan([]) == 'bantuan');
  assert(arahan(['versi']) == 'v1.0');
  assert(arahan(['tambah', 'roti']) == 'menambah roti');
  assert(arahan(['hapus', 'roti', '-f']) == 'menghapus roti');
  assert(arahan(['aneh']) == 'perintah tidak dikenal: aneh');
  assert(arahan(['tambah']) == 'perintah tidak dikenal: tambah'); // argumen kurang!

  final [pertama, ..., terakhir] = [1, 2, 3, 4];
  final [kepala, ...ekor] = [1, 2, 3];
  print('$pertama $terakhir $kepala $ekor'); // 1 4 1 [2, 3]
}
```

- `['tambah', String nama]` — list tepat dua elemen; yang pertama harus string `'tambah'`.
- `['hapus', String nama, ...]` — `...` (rest) berarti *boleh ada elemen tambahan*, tanpa diikat.
- `[String perintah, ...]` — menangkap semua list tak kosong sisanya; `_` hanya menyisakan list kosong.
- Perhatikan baris `['tambah']`: pesan *perintah tidak dikenal* menyesatkan — itulah kelemahan pola umum di akhir; studi kasus 2.7 memperbaikinya.
- `final [pertama, ..., terakhir] = ...` — destrukturisasi di deklarasi memerlukan list sedikitnya dua elemen; bila tidak, error runtime.

**Contoh 4 — pola object dan destrukturisasi `for-in`.**

```dart
class Titik {
  const Titik(this.x, this.y);
  final int x;
  final int y;
}

String posisi(Titik t) => switch (t) {
      Titik(x: 0, y: 0) => 'pusat',
      Titik(x: 0) => 'pada sumbu-y',
      Titik(y: 0) => 'pada sumbu-x',
      Titik(:final x, :final y) when x == y => 'pada diagonal',
      _ => 'bebas',
    };

void main() {
  assert(posisi(const Titik(0, 0)) == 'pusat');
  assert(posisi(const Titik(0, 5)) == 'pada sumbu-y');
  assert(posisi(const Titik(3, 0)) == 'pada sumbu-x');
  assert(posisi(const Titik(2, 2)) == 'pada diagonal');
  assert(posisi(const Titik(1, 2)) == 'bebas');

  final hist = {'a': 3, 'b': 1};
  for (final MapEntry(:key, value: jumlah) in hist.entries) {
    print('$key muncul $jumlah kali');
  }
}
```

- `Titik(x: 0, y: 0)` — memeriksa tipe `Titik`, lalu getter `x` dan `y` dicocokkan dengan konstanta `0`.
- `Titik(:final x, :final y)` — singkatan: variabel `x` dan `y` diikat dari getter bernama sama.
- `MapEntry(:key, value: jumlah)` — membongkar pasangan kunci-nilai; `value: jumlah` mengganti nama variabel.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Sebelum pola: validasi manual yang panjang dan rawan salah.
String? salamLama(Object? json) {
  if (json is Map<String, Object?> && json['user'] is List<Object?>) {
    final user = json['user'] as List<Object?>;
    if (user.length == 2 && user[0] is String && user[1] is int && (user[1] as int) >= 0) {
      return 'Halo ${user[0]} (${user[1]} tahun)';
    }
  }
  return null;
}
```

| Gaya | Kelebihan | Kekurangan |
| --- | --- | --- |
| Pola map + list | Singkat, deklaratif, kegagalan otomatis | Pesan gagal tidak menjelaskan sebabnya |
| Pemeriksaan manual (`is`, `as`, indeks) | Bisa memberi pesan galat spesifik per langkah | Panjang; mudah ada `as` yang melempar |
| Kelas model + `fromJson` | Tipe kuat, mudah diuji | Lebih banyak kode (Fase 3) |
| `if-case` vs `switch` | `if-case` untuk satu bentuk | Banyak bentuk → `switch` |

### E. Terminologi Esensial

- **Pola list / map / record / object** — pola yang membongkar koleksi, pasangan kunci-nilai, record, dan instance kelas. **Rest element** — `...` yang menampung sisa elemen list.
- **Record** — nilai gabungan beberapa field tanpa deklarasi kelas. **Getter** — properti baca; pola object memakainya. **Singkatan `:nama`** — mengikat variabel bernama sama dengan field/getter.
- **Tipe data aljabar (ADT)** — tipe yang dibangun dari gabungan (*sum*) dan perkalian (*product*) tipe lain.

### F. Visualisasi (ASCII)

```text
 json ─► Map?      ─ tidak ─┐
          │ ya              │
          ▼                 │
   punya kunci 'user'? ─ tidak ─┤
          │ ya              │
          ▼                 ├──► TIDAK COCOK  → lanjut / null
   nilainya List?   ─ tidak ─┤
          │ ya              │
          ▼                 │
   panjang == 2?    ─ tidak ─┤
          │ ya              │
          ▼                 │
   [0] is String && [1] is int? ─ tidak ─┘
          │ ya
          ▼
   ikat  nama, umur  ──► guard (when umur >= 0)? ──► JALANKAN
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 2.4 (pola dasar), 2.2 (null-check pada elemen), 1.3 (dekomposisi: pola memecah data).
- **Prasyarat bagi:** 2.6 (pola object + sealed) dan 2.7 (pengurai perintah). **Dikembangkan di:** Fase 3 (record vs class), Fase 5 (hasil kegagalan sebagai record/sealed), Fase 9 (validasi input tak tepercaya).

### H. Tips & Praktik Terbaik

- Taruh pola yang paling spesifik lebih dulu; pola umum seperti `[String perintah, ...]` di akhir.
- Gunakan `...` hanya bila memang ada elemen yang diizinkan berlebih; tanpa itu panjang harus tepat.
- Pakai record bernama untuk hasil lebih dari dua nilai agar tak tertukar urutannya.
- Ketika perlu pesan galat yang menjelaskan sebab, validasi bertahap dengan pola kecil lebih informatif daripada satu pola raksasa.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mengira pola list mencocokkan list lebih panjang | `['tambah', x]` tidak cocok pada tiga elemen | Tambah `...` bila elemen berlebih diperbolehkan |
| Mengira pola record boleh sebagian | Tidak cocok bila ada field tambahan | Record harus cocok seluruh bentuknya; pola object yang boleh sebagian |
| Kunci pola map bukan konstanta | Galat kompilasi | Gunakan literal atau konstanta bernama |
| Destrukturisasi deklarasi pada data yang bisa salah | Error runtime | Pakai `if-case` atau `switch` untuk data yang bentuknya tak pasti |
| Pola umum di atas pola khusus | Pola khusus tak pernah tercapai | Urutkan dari spesifik ke umum |
| Pola raksasa tanpa pesan gagal | Sulit melacak mengapa data ditolak | Pecah validasi dan beri alasan per langkah |

### J. Sumber Referensi

- ✔ Pola dan use case (JSON, multiple return, destrukturisasi): https://dart.dev/language/patterns
- ✔ Jenis pola (list, map, record, object, rest): https://dart.dev/language/pattern-types
- Record: https://dart.dev/language/records
- ✔ Percabangan dan `if-case`: https://dart.dev/language/branches
- Algebraic data type: https://en.wikipedia.org/wiki/Algebraic\_data\_type

---

## 2.6 Sealed, Enum, Exhaustiveness, Guard, dan Dominasi

*Motivasi: desain terbaik adalah yang membuat kesalahan menjadi galat kompilasi, bukan laporan pengguna.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas cara memodelkan keputusan sebagai himpunan varian yang **tertutup** — `enum` dan `sealed class` — sehingga kompilator membuktikan bahwa setiap `switch` menangani semua kemungkinan (**exhaustiveness**). Termasuk di sini: guard `when`, urutan kasus, **dominasi** (kasus yang tak mungkin tercapai), serta kapan memilih `sealed`, `enum`, `final`, atau polimorfisme biasa. Inilah inti dari *membuat keadaan ilegal tidak mungkin direpresentasikan*, yang dikembangkan di Fase 3.

### B. Konsep Kunci & Filosofi Mendalam

- **Tipe jumlah (sum type) vs tipe hasil kali (product type).** Record/class = *semua* field ada sekaligus (product). `sealed class` dengan beberapa subtipe = *salah satu* dari varian (sum).
- **`sealed class`:** semua subtipe langsung **harus berada di library yang sama**; kelas sealed otomatis abstrak; subtipe tidak harus sealed. Karena semua subtipe diketahui, kompilator memperingatkan bila `switch` melewatkan salah satunya.
- **`enum`:** himpunan nilai tetap yang enumerable; enum yang disempurnakan dapat memiliki field dan method.
- **Exhaustiveness:** galat kompilasi bila ada kemungkinan nilai yang tidak cocok dengan kasus mana pun. Untuk `bool`, `enum`, tipe `sealed`, tipe nullable, serta record dan list dari tipe-tipe itu, kompilator menghitung kelengkapan; `_` atau `default` membuat `switch` pada tipe apa pun menjadi lengkap.
- **Jaring pengaman.** Menambah varian baru pada `sealed class` atau `enum` langsung menandai *setiap* `switch` yang perlu diperbarui — refactoring yang dipandu kompilator. Menulis `_` pada `switch` seperti itu **mematikan jaring pengaman** dan menelan varian baru secara diam-diam.
- **Guard `when`:** syarat tambahan pada kasus; bila bernilai false, eksekusi lanjut ke kasus berikutnya. Kasus ber-guard dapat gagal, sehingga **tidak dihitung** untuk membuktikan kelengkapan; sediakan kasus tanpa guard untuk menutup nilainya.
- **Dominasi.** Kasus yang seluruh nilainya sudah tercakup kasus di atasnya tak pernah tercapai; analyzer memberi peringatan *unreachable switch case* untuk kasus berbasis tipe. Untuk rentang numerik, jangan mengandalkan peringatan — uji nilai batas.
- **Masalah ekspresi (expression problem).** `sealed` + `switch` membuat *menambah operasi* mudah (tulis fungsi baru) dan *menambah varian* dipandu kompilator; polimorfisme berbasis method membuat *menambah varian* mudah dan *menambah operasi* menyentuh banyak kelas. Pilih sesuai sumbu perubahan yang paling sering.
- **Memilih pemodel:** `enum` untuk konstanta tanpa data berbeda; `sealed` untuk varian yang membawa data berbeda; `final class` bila *tidak* ingin exhaustiveness dan ingin bebas menambah subtipe nanti; kelas biasa dengan method bila perilaku mengikuti objek.
- **Dampak desain:** model tertutup + `switch` lengkap memindahkan bug dari runtime ke waktu kompilasi; harganya adalah perubahan yang lebih menyebar saat varian ditambah — dan itu memang disengaja.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — `sealed class` dan `switch` lengkap tanpa `_`.**

```dart
import 'dart:math' as math;

sealed class Bentuk {
  const Bentuk();
}

class Persegi extends Bentuk {
  const Persegi(this.sisi);
  final double sisi;
}

class Lingkaran extends Bentuk {
  const Lingkaran(this.jariJari);
  final double jariJari;
}

class Segitiga extends Bentuk {
  const Segitiga(this.alas, this.tinggi);
  final double alas;
  final double tinggi;
}

double luas(Bentuk b) => switch (b) {
      Persegi(:final sisi) => sisi * sisi,
      Lingkaran(:final jariJari) => math.pi * jariJari * jariJari,
      Segitiga(:final alas, :final tinggi) => alas * tinggi / 2,
    };

void main() {
  assert(luas(const Persegi(2)) == 4.0);
  assert(luas(const Segitiga(3, 4)) == 6.0);
}
```

- `sealed class Bentuk` — kelas dasar tertutup (otomatis abstrak); subtipe langsung hanya boleh ada di file/library ini.
- Tidak ada `_` di `switch`: ketiga subtipe tercakup, sehingga kompilator menerima. Bila kamu menambahkan `class Jajargenjang extends Bentuk`, `luas` langsung gagal dikompilasi sampai kasusnya ditambahkan.
- `const Persegi(2)` — literal `2` otomatis menjadi `2.0` pada konteks `double`.

**Contoh 2 — `enum` dan mesin status dengan record.**

```dart
enum Status { baru, dibayar, dikirim, selesai, batal }

/// Mengembalikan status berikutnya, atau null bila transisi tidak diizinkan.
Status? lanjut(Status sekarang, {required bool sukses}) =>
    switch ((sekarang, sukses)) {
      (Status.baru, true) => Status.dibayar,
      (Status.baru, false) => Status.batal,
      (Status.dibayar, true) => Status.dikirim,
      (Status.dibayar, false) => Status.batal,
      (Status.dikirim, true) => Status.selesai,
      (Status.dikirim, false) => Status.batal,
      (Status.selesai, _) || (Status.batal, _) => null,
    };

void main() {
  assert(lanjut(Status.baru, sukses: true) == Status.dibayar);
  assert(lanjut(Status.dikirim, sukses: false) == Status.batal);
  assert(lanjut(Status.selesai, sukses: true) == null);
}
```

- `switch ((sekarang, sukses))` — dua nilai dibungkus menjadi satu record agar dicocokkan bersamaan.
- Kompilator menghitung kombinasi `Status` × `bool` (10 kemungkinan) dan memastikan semuanya tercakup; hapus satu baris dan program tidak dikompilasi. Kebijakan transisi terbaca langsung sebagai tabel.
- `(Status.selesai, _) || (Status.batal, _)` — dua status akhir berbagi hasil `null`.

**Contoh 3 — `sealed class` generik sebagai hasil operasi.**

```dart
sealed class Hasil<T> {
  const Hasil();
}

class Sukses<T> extends Hasil<T> {
  const Sukses(this.nilai);
  final T nilai;
}

class Gagal<T> extends Hasil<T> {
  const Gagal(this.pesan);
  final String pesan;
}

Hasil<int> parseUmur(String teks) {
  final n = int.tryParse(teks);
  if (n == null) return const Gagal('bukan angka');
  if (n < 0 || n > 150) return const Gagal('di luar rentang 0..150');
  return Sukses(n);
}

String tampil(Hasil<int> h) => switch (h) {
      Sukses(:final nilai) => 'umur = $nilai',
      Gagal(:final pesan) => 'ditolak: $pesan',
    };

void main() {
  assert(tampil(parseUmur('27')) == 'umur = 27');
  assert(tampil(parseUmur('abc')) == 'ditolak: bukan angka');
  assert(tampil(parseUmur('200')) == 'ditolak: di luar rentang 0..150');
}
```

- `Hasil<T>` memaksa pemanggil menangani *dua* kemungkinan; tidak ada cara memakai `nilai` tanpa melewati kasus `Sukses`.
- `int.tryParse` mengembalikan `null` bila teks bukan angka — kegagalan yang wajar dimodelkan sebagai tipe, bukan exception (Fase 5 memperdalam pilihan ini).

**Contoh 4 — urutan kasus dan dominasi.**

```dart
// Benar: dari yang paling khusus ke yang paling umum.
String kategoriUmur(int umur) => switch (umur) {
      < 0 => 'tidak valid',
      < 18 => 'anak',
      < 60 => 'dewasa',
      _ => 'lansia',
    };

// Berbasis tipe: kasus kedua tak pernah tercapai (int adalah num).
String urut(Object o) => switch (o) {
      num _ => 'angka',
      int _ => 'bilangan bulat', // peringatan: unreachable switch case
      _ => 'lain',
    };
```

- Pada `kategoriUmur`, `< 60` otomatis berarti 18 sampai 59 karena kasus-kasus di atasnya sudah mengambil sisanya — urutan *adalah* logika.
- Pada `urut`, `int _` didominasi `num _`; analyzer memberi peringatan. Bila urutan rentang numerik dibalik, peringatan tidak dijamin muncul, sehingga tes nilai batas (modul 1.8) tetap wajib.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// 1) Polimorfisme biasa: perilaku berada DI DALAM tiap kelas.
abstract class BentukOO {
  const BentukOO();
  double luas();
}

class PersegiOO extends BentukOO {
  const PersegiOO(this.sisi);
  final double sisi;
  @override
  double luas() => sisi * sisi;
}

// 2) Enum yang disempurnakan: data dan method melekat pada konstanta.
enum Hari {
  senin(kerja: true),
  sabtu(kerja: false);

  const Hari({required this.kerja});
  final bool kerja;
}
```

Catatan versi: sejak Dart 3.10, `Status s = .baru;` (dot shorthand) boleh menggantikan `Status s = Status.baru;` bila tipe jelas dari konteks.

| Pendekatan | Mudah | Sulit | Pilih bila |
| --- | --- | --- | --- |
| `sealed` + `switch` | Menambah operasi baru; kelengkapan diperiksa | Menambah varian menyentuh semua `switch` | Varian jarang bertambah, operasi sering bertambah |
| Polimorfisme (method di kelas) | Menambah varian baru | Menambah operasi menyentuh semua kelas | Varian sering bertambah, operasi tetap |
| `enum` | Konstanta sederhana, lengkap otomatis | Varian tak bisa membawa data berbeda | Himpunan nilai tetap tanpa data berbeda |
| `final class` + `_` | Bebas menambah subtipe | Tak ada pemeriksaan kelengkapan | Ingin API terbuka untuk ekstensi |

### E. Terminologi Esensial

- **Sealed** — modifier yang menutup himpunan subtipe langsung pada satu library. **Exhaustiveness** — jaminan kompilator bahwa semua kemungkinan tercakup.
- **Sum type / product type** — tipe pilihan satu-dari-banyak / tipe gabungan semua field. **Varian** — satu anggota dari sum type.
- **Guard** — `when kondisi` pada kasus. **Dominasi** — kasus yang tak tercapai karena tertutup kasus di atasnya.
- **Expression problem** — dilema perubahan: menambah varian vs menambah operasi. **Enhanced enum** — enum dengan field dan method.

### F. Visualisasi (ASCII)

```text
sealed class Bentuk            (abstrak, tertutup di satu library)
├── Persegi(sisi)
├── Lingkaran(jariJari)
└── Segitiga(alas, tinggi)

switch (b) { Persegi → ..., Lingkaran → ..., Segitiga → ... }   ← lengkap: DITERIMA
switch (b) { Persegi → ..., Lingkaran → ... }                    ← kurang satu: GALAT KOMPILASI
```

```text
 Menambah varian baru (Jajargenjang):

   sealed class Bentuk ──► + Jajargenjang
            │
            ▼
   setiap switch atas Bentuk ──► galat kompilasi ──► kamu diarahkan ke semua tempat yang perlu diubah
   (bila ada `_`: tidak ada galat → varian baru jatuh ke default secara diam-diam)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 2.4–2.5 (pola object, guard, kelengkapan), 1.6 (ekspresi `switch` lengkap), 2.3 (flow analysis membuktikan cabang).
- **Prasyarat bagi:** 2.7 (studi kasus). **Dikembangkan di:** Fase 3 (membuat keadaan ilegal tak bisa direpresentasikan), Fase 5 (`Hasil` sebagai strategi kegagalan), Fase 11 (batas modul dan API publik yang tertutup).

### H. Tips & Praktik Terbaik

- Pada `switch` atas `enum` atau `sealed`, **jangan** menulis `_` atau `default`; biarkan kompilator memaksa pembaruan saat varian bertambah.
- Bila sebuah kasus harus berguard, siapkan kasus tanpa guard untuk nilai yang sama agar kelengkapan terbukti.
- Letakkan semua subtipe sealed dalam satu file (atau `part`); subtipe di library lain tidak diizinkan.
- Modelkan data dan keputusan sebagai varian dulu; baru pikirkan perilaku. Nama varian mencerminkan istilah domain.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| `_` pada `switch` atas `sealed`/`enum` | Varian baru ditelan diam-diam | Hapus `_`; tangani tiap varian |
| Subtipe di file lain tanpa `part` | Galat: subtipe sealed di luar library | Satukan di satu library atau pakai `part` |
| Lupa `sealed` (hanya `abstract`) | Kelengkapan tidak diperiksa | Tambahkan `sealed` pada kelas dasar |
| Guard dikira menutup kemungkinan | Galat "switch tidak lengkap" | Tambah kasus tanpa guard |
| Urutan kasus salah pada rentang numerik | Kasus tak pernah jalan, tanpa peringatan | Urutkan khusus → umum dan uji nilai batas |
| Memakai `enum` untuk varian yang membawa data berbeda | Field berlebih atau `null` bertebaran | Pindah ke `sealed class` |

### J. Sumber Referensi

- ✔ Class modifiers (`sealed`, `final`, `base`, `interface`): https://dart.dev/language/class-modifiers
- ✔ Class modifiers untuk pengelola API (konteks `sealed`): https://dart.dev/language/class-modifiers-for-apis
- ✔ Percabangan dan exhaustiveness checking: https://dart.dev/language/branches
- ✔ Spesifikasi exhaustiveness: https://github.com/dart-lang/language/blob/master/accepted/3.0/patterns/exhaustiveness.md
- ✔ Spesifikasi sealed types: https://github.com/dart-lang/language/blob/main/accepted/future-releases/sealed-types/feature-specification.md
- Enum: https://dart.dev/language/enums
- Expression problem: https://en.wikipedia.org/wiki/Expression\_problem

---

## 2.7 Studi Kasus Terpadu: Pengurai Perintah CLI *(TAMBAHAN)*

*Motivasi: terminal adalah tempat logika dibuktikan — satu baris masukan, satu keputusan yang tak boleh salah.*

> **Mengapa ditambahkan.** Audit menemukan bahwa pola, sealed class, dan exhaustiveness paling mudah dikuasai bila dipakai bersama pada satu masalah yang akrab. Pengurai perintah CLI memaksa semuanya: pola list, rest element, guard, `sealed`, `switch` lengkap, inti murni, dan lapisan I/O yang tipis.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Langkah & kode · D Variasi · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Kamu membangun aplikasi to-do bergaya REPL di terminal. Inti logikanya berupa dua fungsi murni: `uraiPerintah` (dari `List<String>` ke perintah terstruktur atau alasan gagal) dan `jalankan` (dari daftar tugas lama + perintah ke daftar baru + keluaran). Lapisan I/O di `bin/` hanya membaca baris, memanggil kedua fungsi itu, dan mencetak hasil. Studi kasus ini menyatukan seluruh Fase 2 dengan Fase 1.

### B. Konsep Kunci & Filosofi Mendalam

- **Dua tipe jumlah tertutup:** `Perintah` (apa yang diminta pengguna) dan `Urai` (berhasil atau gagal mengurai). Kegagalan mengurai adalah *data*, bukan exception — masukan pengguna yang salah itu wajar, bukan bug.
- **Fungsi total.** `uraiPerintah` didefinisikan untuk **setiap** `List<String>` dan tidak pernah melempar; kelengkapan dijamin oleh urutan kasus dan penampung `_`.
- **Penalaran antar kasus.** Pada kasus terakhir `_`, daftar pasti tak kosong karena `[]` sudah ditangani di atas; maka `args.first` aman. Urutan kasus *adalah* bagian dari bukti.
- **Inti murni, tepi tipis** (modul 1.2): `jalankan` tidak mencetak dan tidak membaca apa pun; ia mengembalikan daftar baru dan baris keluaran. Shell di `bin/` yang menanggung efek samping.
- **Imutabilitas:** `Item` tidak berubah; memperbarui tugas berarti membuat `Item` baru dan list baru — mudah dites dan bebas aliasing (modul 1.2).
- **Fungsi `jalankan` yang total juga:** nomor di luar rentang tidak melempar; ia mengembalikan pesan, sehingga kontrak (modul 1.5) ditegakkan tanpa crash.
- **Dampak desain:** karena `Perintah` dan `Urai` adalah `sealed`, menambah perintah baru (mis. `ubah`) langsung menandai semua `switch` yang harus diperbarui; karena inti murni, tiap potong dapat dites tanpa terminal.

### C. Langkah, Sintaks, dan Kode

**Langkah 1 — spesifikasi.**

| Aspek | Keputusan |
| --- | --- |
| Perintah | `tambah <judul...>`, `selesai <nomor>`, `hapus <nomor>`, `daftar`, `bantuan` (atau masukan kosong) |
| Nomor | Bilangan bulat `>= 1`, berbasis 1 seperti yang dilihat pengguna |
| Judul | Satu kata atau lebih; kata-kata digabung dengan spasi tunggal |
| Kegagalan | Selalu berupa `UraiGagal` dengan alasan yang menjelaskan pemakaian yang benar |
| Sifat | `uraiPerintah` dan `jalankan` adalah fungsi total dan murni |

**Langkah 2 — tabel contoh (termasuk kasus tepi).**

| Masukan | Hasil |
| --- | --- |
| `[]` atau `['bantuan']` | `Bantuan` |
| `['daftar']` | `Tampilkan` |
| `['daftar', 'x']` | gagal: perintah ini tidak menerima argumen |
| `['tambah']` | gagal: pemakaian: tambah \<judul> |
| `['tambah', 'beli', 'roti']` | `Tambah('beli roti')` |
| `['selesai', '2']` | `Selesai(2)` |
| `['selesai', 'dua']` | gagal: bukan angka: dua |
| `['hapus', '0']` | gagal: nomor harus >= 1 |
| `['hapus', '1', '2']` | gagal: pemakaian (selesai atau hapus diikuti nomor) |
| `['aneh']` | gagal: perintah tidak dikenal: aneh |

**Langkah 3 — model dan pengurai (`lib/todo.dart`).**

```dart
// ---- Model perintah (sum type tertutup) ----
sealed class Perintah {
  const Perintah();
}

class Tambah extends Perintah {
  const Tambah(this.judul);
  final String judul;
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

// ---- Hasil penguraian (sum type tertutup) ----
sealed class Urai {
  const Urai();
}

class UraiBerhasil extends Urai {
  const UraiBerhasil(this.perintah);
  final Perintah perintah;
}

class UraiGagal extends Urai {
  const UraiGagal(this.alasan);
  final String alasan;
}

// ---- Pengurai: dari List<String> ke Urai (total, murni) ----
Urai uraiPerintah(List<String> args) => switch (args) {
      [] || ['bantuan'] => const UraiBerhasil(Bantuan()),
      ['daftar'] => const UraiBerhasil(Tampilkan()),
      ['daftar' || 'bantuan', ...] =>
        const UraiGagal('perintah ini tidak menerima argumen'),
      ['tambah'] => const UraiGagal('pemakaian: tambah <judul>'),
      ['tambah', ...final kata] => UraiBerhasil(Tambah(kata.join(' '))),
      ['selesai', final teks] => _uraiNomor(teks, Selesai.new),
      ['hapus', final teks] => _uraiNomor(teks, Hapus.new),
      ['selesai' || 'hapus', ...] =>
        const UraiGagal('pemakaian: selesai atau hapus diikuti <nomor>'),
      // args pasti tidak kosong di sini: [] sudah ditangani di kasus pertama.
      _ => UraiGagal('perintah tidak dikenal: ${args.first}'),
    };

Urai _uraiNomor(String teks, Perintah Function(int nomor) buat) {
  final nomor = int.tryParse(teks);
  if (nomor == null) return UraiGagal('bukan angka: $teks');
  if (nomor < 1) return const UraiGagal('nomor harus >= 1');
  return UraiBerhasil(buat(nomor));
}
```

**Bedah kode kata demi kata**

- `sealed class Perintah` + lima subkelas — himpunan perintah tertutup; `const` agar instansnya konstanta.
- `[] || ['bantuan']` — logical-or dua pola list; keduanya berarti *bantuan*.
- `['daftar' || 'bantuan', ...]` — elemen pertama salah satu dari dua string, *dengan* elemen tambahan (karena `['daftar']` dan `['bantuan']` murni sudah ditangani di kasus lebih atas).
- `['tambah', ...final kata]` — rest element yang diikat ke `kata` (List\<String>); `['tambah']` tanpa kata sudah ditangani di kasus sebelumnya, jadi di sini `kata` pasti tak kosong.
- `Selesai.new` — *constructor tear-off*: konstruktor sebagai fungsi `Selesai Function(int)`, diteruskan ke `_uraiNomor` sebagai pembuat perintah.
- `if (nomor == null) return ...;` dan `if (nomor < 1) return ...;` — guard clause (modul 1.6); setelahnya `nomor` terpromosi menjadi `int` (modul 2.3).
- `_ => ... ${args.first}` — penampung: urutan di atas menjamin `args` tidak kosong.

**Langkah 4 — model data dan eksekutor murni (lanjutan `lib/todo.dart`).**

```dart
class Item {
  const Item(this.judul, {this.selesai = false});
  final String judul;
  final bool selesai;

  Item tandaiSelesai() => Item(judul, selesai: true);
}

const _bantuan = <String>[
  'pemakaian:',
  '  tambah <judul>    menambah tugas',
  '  selesai <nomor>   menandai tugas selesai',
  '  hapus <nomor>     menghapus tugas',
  '  daftar            menampilkan semua tugas',
];

List<String> _format(List<Item> daftar) {
  if (daftar.isEmpty) return const ['(kosong)'];
  return [
    for (var i = 0; i < daftar.length; i++)
      '${i + 1}. [${daftar[i].selesai ? 'x' : ' '}] ${daftar[i].judul}',
  ];
}

/// Menerapkan [perintah] pada [daftar]. Murni: tidak mencetak, tidak membaca apa pun.
/// Mengembalikan daftar baru dan baris keluaran.
(List<Item>, List<String>) jalankan(List<Item> daftar, Perintah perintah) =>
    switch (perintah) {
      Bantuan() => (daftar, _bantuan),
      Tampilkan() => (daftar, _format(daftar)),
      Tambah(:final judul) => ([...daftar, Item(judul)], ['ditambah: $judul']),
      Selesai(:final nomor) when nomor < 1 || nomor > daftar.length =>
        (daftar, ['nomor $nomor tidak ada']),
      Selesai(:final nomor) => (
          [
            for (var i = 0; i < daftar.length; i++)
              if (i == nomor - 1) daftar[i].tandaiSelesai() else daftar[i],
          ],
          ['selesai: nomor $nomor'],
        ),
      Hapus(:final nomor) when nomor < 1 || nomor > daftar.length =>
        (daftar, ['nomor $nomor tidak ada']),
      Hapus(:final nomor) => (
          [...daftar.sublist(0, nomor - 1), ...daftar.sublist(nomor)],
          ['dihapus: nomor $nomor'],
        ),
    };
```

- `(List<Item>, List<String>)` — tipe record sebagai hasil ganda: daftar baru dan baris keluaran.
- `switch (perintah)` tanpa `_` — `Perintah` sealed dan kelima subtipe tercakup; `Selesai` dan `Hapus` masing-masing punya kasus ber-guard *dan* kasus tanpa guard, sehingga kelengkapan terbukti.
- `when nomor < 1 || nomor > daftar.length` — guard penjaga rentang: `jalankan` total walau dipanggil langsung dengan nomor tak sah.
- `[...daftar, Item(judul)]` — spread membuat list baru; list lama tak berubah.
- `for (...) if (...) a else b` — collection-for dan collection-if dengan `else` menyusun list baru tanpa mutasi.
- `[...daftar.sublist(0, nomor - 1), ...daftar.sublist(nomor)]` — membuang elemen ke-`nomor` (berbasis 1) dengan menggabungkan dua potongan; aman karena guard memastikan `1 <= nomor <= length`.

**Langkah 5 — lapisan I/O tipis (`bin/logika_fase2.dart`).**

```dart
import 'dart:io';

import 'package:logika_fase2/todo.dart';

void main() {
  var daftar = <Item>[];
  while (true) {
    stdout.write('todo> ');
    final baris = stdin.readLineSync();
    if (baris == null) break; // akhir masukan (Ctrl-D)
    final token = baris.split(' ').where((t) => t.isNotEmpty).toList();
    switch (uraiPerintah(token)) {
      case UraiGagal(:final alasan):
        stderr.writeln('galat: $alasan');
      case UraiBerhasil(:final perintah):
        final (baru, keluaran) = jalankan(daftar, perintah);
        daftar = baru;
        keluaran.forEach(stdout.writeln);
    }
  }
}
```

```text
$ dart run --enable-asserts
todo> tambah beli roti
ditambah: beli roti
todo> tambah kirim laporan
ditambah: kirim laporan
todo> selesai 1
selesai: nomor 1
todo> daftar
1. [x] beli roti
2. [ ] kirim laporan
todo> hapus 5
nomor 5 tidak ada
todo> hapus abc
galat: bukan angka: abc
```

- `stdin.readLineSync()` — membaca satu baris; `null` berarti akhir masukan. Guard `if (baris == null) break;` mempromosikan `baris` menjadi `String`.
- `switch` *statement* atas `Urai` sealed: kedua kasus wajib ada; `case UraiGagal(:final alasan):` adalah pola object dengan singkatan.
- `stderr.writeln` — galat ke stderr (modul 1.7); hasil normal ke stdout.
- Satu-satunya `var` yang berubah adalah `daftar`, dan hanya di tepi.

**Langkah 6 — test (`test/todo_test.dart`).**

```dart
import 'package:logika_fase2/todo.dart';
import 'package:test/test.dart';

String? alasanGagal(List<String> args) => switch (uraiPerintah(args)) {
      UraiGagal(:final alasan) => alasan,
      UraiBerhasil() => null,
    };

void main() {
  group('uraiPerintah', () {
    test('perintah tanpa argumen berhasil', () {
      expect(alasanGagal([]), isNull);
      expect(alasanGagal(['bantuan']), isNull);
      expect(alasanGagal(['daftar']), isNull);
    });
    test('argumen salah ditolak dengan alasan tepat', () {
      expect(alasanGagal(['daftar', 'x']), 'perintah ini tidak menerima argumen');
      expect(alasanGagal(['tambah']), 'pemakaian: tambah <judul>');
      expect(alasanGagal(['hapus', '1', '2']), contains('pemakaian'));
    });
    test('nomor harus angka dan >= 1', () {
      expect(alasanGagal(['selesai', 'dua']), 'bukan angka: dua');
      expect(alasanGagal(['hapus', '0']), 'nomor harus >= 1');
    });
    test('perintah tak dikenal', () {
      expect(alasanGagal(['aneh']), 'perintah tidak dikenal: aneh');
    });
    test('tambah dengan beberapa kata digabung', () {
      if (uraiPerintah(['tambah', 'beli', 'roti'])
          case UraiBerhasil(perintah: Tambah(:final judul))) {
        expect(judul, 'beli roti');
      } else {
        fail('seharusnya UraiBerhasil(Tambah)');
      }
    });
  });

  group('jalankan', () {
    test('tambah, selesai, lalu hapus', () {
      var daftar = <Item>[];
      (daftar, _) = jalankan(daftar, const Tambah('roti'));
      expect(daftar.single.selesai, isFalse);
      (daftar, _) = jalankan(daftar, const Selesai(1));
      expect(daftar.single.selesai, isTrue);
      (daftar, _) = jalankan(daftar, const Hapus(1));
      expect(daftar, isEmpty);
    });
    test('nomor di luar daftar tidak mengubah apa pun', () {
      final awal = [const Item('a')];
      for (final p in const <Perintah>[Selesai(0), Selesai(2), Hapus(0), Hapus(2)]) {
        final (daftar, keluaran) = jalankan(awal, p);
        expect(daftar, awal);
        expect(keluaran.single, contains('tidak ada'));
      }
    });
  });
}
```

```bash
dart test
```

- `alasanGagal` — pembantu test yang memakai `switch` sealed untuk mengekstrak alasan atau `null`.
- `if (... case UraiBerhasil(perintah: Tambah(:final judul)))` — pola object bersarang: memeriksa dua tingkat tipe sekaligus lalu mengikat `judul`.
- `(daftar, _) = jalankan(...)` — pola penugasan: `daftar` diperbarui, bagian keluaran dibuang dengan wildcard.
- Tes `jalankan` dengan `Selesai(0)` dan `Hapus(0)` membuktikan bahwa guard rentang bekerja walau pengurai tak pernah menghasilkan nomor tersebut.

### D. Variasi Kode untuk Logika yang Sama

```dart
// 1) Pengurai berbasis exception: kegagalan dilempar, shell yang menangkap.
Perintah uraiLempar(List<String> args) {
  switch (args) {
    case ['tambah', ...final kata] when kata.isNotEmpty:
      return Tambah(kata.join(' '));
    case _:
      throw FormatException('perintah tidak dikenal', args);
  }
}
```

| Pendekatan | Kelebihan | Kekurangan / dampak |
| --- | --- | --- |
| `Urai` sealed (utama) | Kegagalan wajar adalah data; pemanggil dipaksa menangani | Sedikit lebih banyak kode |
| Exception (`FormatException`) | Ringkas untuk alur sukses | Alur kegagalan tersembunyi; mudah lupa `catch` |
| Mengembalikan `null` | Paling sederhana | Alasan gagal hilang; pengguna tak tahu apa yang salah |
| `package:args` | Standar untuk CLI sungguhan: opsi, flag, bantuan otomatis | Bukan latihan logika; dipakai setelah logika dikuasai |

Catatan versi: Dart 3.13 menambahkan *primary constructors* yang memangkas boilerplate deklarasi kelas data seperti `Tambah` dan `Selesai`; kode di sini memakai sintaks klasik agar berjalan di Dart ≥ 3.0.

### E. Terminologi Esensial

- **REPL** — loop baca-evaluasi-cetak. **Token** — potongan masukan setelah dipisah spasi. **Constructor tear-off** — konstruktor yang diperlakukan sebagai fungsi (`Selesai.new`).
- **Fungsi total** — terdefinisi dan tidak melempar untuk setiap masukan bertipe benar. **Inti murni / tepi impure** — logika tanpa efek samping di tengah; I/O di pinggir.
- **Hasil sebagai data** — kegagalan yang wajar dimodelkan sebagai nilai (`UraiGagal`), bukan exception.
- **Exit code / stderr** — status proses dan aliran galat (modul 1.7).

### F. Visualisasi (ASCII)

```text
   stdin ──► baris ──► split ──► List<String>
                                    │
                                    ▼
                            uraiPerintah  (murni, total)
                       ┌────────────┴────────────┐
                       ▼                         ▼
                  UraiGagal(alasan)       UraiBerhasil(perintah)
                       │                         │
                       ▼                         ▼
                 stderr: galat            jalankan(daftar, perintah)  (murni)
                                                 │
                                    (daftar baru, baris keluaran)
                                                 │
                                                 ▼
                                      stdout  +  state di shell
```

```text
lib/todo.dart   ← inti murni: Perintah, Urai, uraiPerintah, Item, jalankan   (dites)
bin/...dart     ← tepi: stdin/stdout/stderr, satu-satunya state yang berubah (tipis)
test/...dart    ← bukti: tabel contoh + nilai batas + kontrak
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 2.1 (ekspresi dan `switch`), 2.2–2.3 (null-aware dan promosi), 2.4–2.5 (pola list dan object), 2.6 (sealed dan exhaustiveness), serta seluruh Fase 1 (spesifikasi, kontrak, guard clause, test, siklus run–error–debug).
- **Dikembangkan di:** Fase 3 (`Item` sebagai nilai dengan kesetaraan dan `copyWith`), Fase 5 (persistensi dan kegagalan I/O), Fase 9 (pengurai sebagai batas kepercayaan untuk masukan tak tepercaya), Fase 10 (property-based test: `uraiPerintah` tak pernah melempar untuk `List<String>` apa pun).

### H. Tips & Praktik Terbaik

- Mulailah dari model tertutup (`Perintah`, `Urai`), baru tulis fungsi; bentuk datanya menentukan bentuk logikanya.
- Tulis alasan gagal yang menyebut *cara memakai yang benar*, bukan sekadar *salah*.
- Letakkan kasus paling khusus di atas; periksa dengan tabel contoh bahwa tak ada kasus yang tertutup kasus di atasnya.
- Jaga agar fungsi inti tetap total; hal yang bisa gagal secara wajar menjadi nilai kembalian, bukan exception.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Pola umum `[String p, ...]` di atas pola khusus | Pesan gagal menyesatkan (`['tambah']` dianggap tak dikenal) | Taruh pola khusus lebih dulu |
| `args.first` tanpa menjamin tak kosong | `StateError` pada masukan kosong | Tangani `[]` lebih dulu dan jelaskan alasannya di komentar |
| Mengubah `daftar` di dalam `jalankan` | Aliasing dan test saling mengganggu | Selalu kembalikan list baru |
| Menaruh `print` di inti | Tak bisa dites tanpa menangkap keluaran | Kembalikan baris keluaran; cetak di tepi |
| Menambah perintah tanpa memperbarui `switch` | Galat kompilasi | Itu fitur: ikuti galat sampai semua `switch` terperbarui |
| Nomor berbasis 0 vs 1 tertukar | Item yang salah terhapus | Tulis di spesifikasi; uji nilai batas 1 dan `length` |

### J. Sumber Referensi

- ✔ Pola dan use case: https://dart.dev/language/patterns
- ✔ Percabangan dan exhaustiveness: https://dart.dev/language/branches
- ✔ Class modifiers (`sealed`): https://dart.dev/language/class-modifiers
- ✔ Pengujian di Dart: https://dart.dev/tools/testing
- Paket `args` untuk CLI: https://pub.dev/packages/args
- API `stdin` dan `stdout` (`dart:io`): https://api.dart.dev/stable/dart-io/dart-io-library.html

---

## Latihan Fase 2 (sengaja tanpa kunci jawaban)

Kerjakan sendiri, jalankan dengan `--enable-asserts`, lalu commit dengan struktur `fase-2/latihan-N/` berisi `README.md` (spesifikasi + tabel contoh), `lib/`, dan `test/`.

1. **\[2.1\]** Pilih tiga fungsi lamamu yang memakai pola `var x; if ... x = ...`. Ubah menjadi ekspresi `final`; bandingkan jumlah baris dan jumlah variabel yang bisa berubah. Catat satu kasus di mana gaya statement justru lebih jelas, dan mengapa.
2. **\[2.2\]** Rancang model `Profil` dengan beberapa field opsional. Tulis `tampilkanKota` dengan empat cara (`?.` + `??`, promosi lewat guard clause, `switch`, dan `!`). Tulis tabel: apa arti `null` di tiap field, dan masukan mana yang membuat versi `!` crash.
3. **\[2.3\]** Kumpulkan lima kasus promosi yang gagal (field publik, field non-final, getter, closure yang menulis, loop). Catat pesan analyzer, penyebab menurut dokumentasi, dan perbaikan yang kamu pilih. Uji juga dengan SDK constraint di bawah 3.2.
4. **\[2.4\]** Tulis `klasifikasi(Object?)` dengan minimal sepuluh kasus. Ubah urutan kasusnya dan temukan dua bug dominasi; tulis test yang menjebak keduanya. Jelaskan mengapa `_` tetap diperlukan pada rentang numerik.
5. **\[2.5\]** Validasi konfigurasi `{ 'server': {'host': String, 'port': int}, 'tags': [String, ...] }` hanya dengan pola. Buat delapan masukan salah dan jelaskan untuk tiap masukan: pola mana yang gagal. Lalu tulis versi bertahap yang memberi pesan alasan.
6. **\[2.6\]** Modelkan `Ekspresi` sebagai `sealed class` (angka, tambah, kali, bagi). Tulis evaluator dan pencetak (printer). Tambahkan varian `Negatif`, lalu catat semua galat kompilasi yang muncul. Tangani pembagian nol dengan `Hasil` sealed — bukan exception.
7. **\[2.7\]** Tambahkan perintah `ubah <nomor> <judul baru>` ke CLI to-do. Mulai dari spesifikasi dan tabel contoh; catat bagian kode mana yang dipaksa kompilator untuk berubah, dan bagian mana yang tidak perlu disentuh.
8. **\[Integrasi\]** Tambahkan penyimpanan sederhana (baca dan tulis file) **hanya di lapisan tepi**; inti tetap murni. Tulis pernyataan satu paragraf: apa yang terjadi bila file rusak atau tak ada? (Jawabannya dikembangkan di Fase 5 dan 9.)

---

## Ringkasan Fase 2 & Daftar Periksa Kelulusan

| Modul | Satu kalimat inti |
| --- | --- |
| 2.1 | Bangun nilai dengan ekspresi agar variabel bisa `final` sejak lahir. |
| 2.2 | Null adalah bagian logika: tolak di tepi, jaga non-null di dalam, hindari `!` yang tak terbukti. |
| 2.3 | Kompilator membuktikan promosi hanya bila nilai stabil; desain `final` dan privat memperluas pembuktiannya. |
| 2.4 | Pola menggambarkan bentuk nilai: cocokkan, bongkar, dan ikat dalam satu kalimat. |
| 2.5 | Pola list, map, record, dan object menyatukan validasi bentuk dan ekstraksi data. |
| 2.6 | `sealed` + `switch` lengkap memindahkan bug dari runtime ke waktu kompilasi; jangan matikan dengan `_`. |
| 2.7 | Inti murni dan total, tepi tipis, kegagalan wajar sebagai data. |

**Daftar periksa kelulusan** (jawab tanpa membuka dokumen):

- [ ] Aku bisa mengubah blok `var x; if ...` menjadi ekspresi `final` dan menjelaskan manfaatnya.
- [ ] Aku bisa menjelaskan beda `?.`, `??`, `??=`, `!`, `...?`, dan `?x`, serta kapan `!` dapat dibenarkan.
- [ ] Aku bisa memprediksi apakah promosi tipe terjadi pada variabel lokal, field privat final, dan field publik — dan memperbaiki yang gagal.
- [ ] Aku bisa menyebut minimal delapan jenis pola dan membedakan konteks refutable dari irrefutable.
- [ ] Aku bisa menulis pola list, map, record, dan object untuk memvalidasi data bersarang.
- [ ] Aku bisa menjelaskan mengapa `_` pada `switch` atas `sealed` atau `enum` menghilangkan jaring pengaman, dan kapan `_` tetap wajib.
- [ ] Aku bisa menjelaskan mengapa kasus ber-guard tidak menutup kelengkapan, dan bagaimana dominasi memengaruhi urutan kasus.
- [ ] Delapan latihan sudah di-commit dengan tabel contoh dan test.

**Pratinjau Fase 3 — Pemodelan Data & State.** Kesetaraan nilai vs identitas (`==` dan `hashCode`), imutabilitas dan `const`, record vs class, `copyWith`, view vs snapshot pada koleksi, serta *extension types* sebagai pembungkus tanpa biaya untuk tipe domain (mis. `Rupiah`) — semuanya demi satu tujuan: membuat keadaan ilegal tak mungkin direpresentasikan. Prasyaratnya adalah daftar periksa di atas terpenuhi.

---

## Referensi Induk Fase 2

> **Catatan verifikasi.** Tanda ✔ berarti halaman tersebut dibuka dan diverifikasi lewat pencarian saat dokumen ini disusun (13 November 2026). Tautan tanpa tanda adalah halaman resmi atau baku yang stabil, tetapi belum diverifikasi ulang; bila ada yang berpindah, cari judulnya di dart.dev.

**Dokumentasi resmi Dart**

- ✔ Pola: https://dart.dev/language/patterns · ✔ Jenis pola: https://dart.dev/language/pattern-types
- ✔ Percabangan: https://dart.dev/language/branches · ✔ Operator: https://dart.dev/language/operators
- ✔ Class modifiers: https://dart.dev/language/class-modifiers · ✔ untuk pengelola API: https://dart.dev/language/class-modifiers-for-apis
- ✔ Fixing type promotion failures: https://dart.dev/tools/non-promotion-reasons
- ✔ Changelog: https://dart.dev/changelog · ✔ Pengumuman Dart 3.13: https://dart.dev/blog/announcing-dart-3-13
- ✔ Pengujian: https://dart.dev/tools/testing
- Null safety: https://dart.dev/null-safety · Memahami null safety: https://dart.dev/null-safety/understanding-null-safety
- Record: https://dart.dev/language/records · Enum: https://dart.dev/language/enums · Koleksi: https://dart.dev/language/collections · Variabel: https://dart.dev/language/variables
- Evolusi bahasa: https://dart.dev/resources/language/evolution

**Spesifikasi dan diskusi desain**

- ✔ Exhaustiveness: https://github.com/dart-lang/language/blob/master/accepted/3.0/patterns/exhaustiveness.md
- ✔ Sealed types: https://github.com/dart-lang/language/blob/main/accepted/future-releases/sealed-types/feature-specification.md
- ✔ Isu perubahan promosi tipe di 3.13: https://github.com/dart-lang/sdk/issues/62889

**Konsep dan teori**

- Pattern matching: https://en.wikipedia.org/wiki/Pattern\_matching · Algebraic data type: https://en.wikipedia.org/wiki/Algebraic\_data\_type
- Expression problem: https://en.wikipedia.org/wiki/Expression\_problem · Flow-sensitive typing: https://en.wikipedia.org/wiki/Flow-sensitive\_typing
- Tony Hoare, *Null References: The Billion Dollar Mistake*: https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare/

**Buku bacaan lanjutan (tanpa tautan)**

- R. Nystrom, *Crafting Interpreters* — pohon sintaks, pola, dan evaluator yang dibangun dari nol.
- S. Wlaschin, *Domain Modeling Made Functional* — memodelkan domain dengan tipe jumlah dan hasil kali.

---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

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

