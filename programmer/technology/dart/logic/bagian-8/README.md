# Membangun Logika Dart — Fase 8: Kualitas & Verifikasi

*Dari kode yang kamu yakini benar menjadi kode yang kamu buktikan benar: lewat uji, properti, analisis statis, kontrak, dan bukti yang berjalan otomatis di setiap perubahan.*

| Atribut | Keterangan |
| --- | --- |
| Level | Advanced → Expert |
| Estimasi waktu | 3–4 minggu, ±40 jam (teori ±30%, praktik ±70%). Dua modul inti kurikulum ≈ 22–26 jam; sisanya untuk 8.3, 8.4, dan latihan |
| Prasyarat | Fase 7 selesai (daftar periksa kelulusan terpenuhi, sembilan latihan di-commit) |
| Alat esensial | Dart SDK stabil (per 20 November 2026: 3.14), `package:test`, `package:kiri_check` (dev), `package:fake_async` (dev), `package:clock`, `package:mocktail` (dev), `package:test_descriptor` (dev), `package:coverage`, `package:lints`, `package:meta`, `lcov` (`genhtml`), `just`, serta `mutation_test` atau `dart_mutant` (opsional) |
| Batas versi fitur | record dan pola: ≥ 3.0 · cakupan cabang: Dart VM ≥ 2.17 · `dart test --coverage-path`: `package:test` versi baru (periksa dengan `dart test --help`) |
| Komunitas | https://dart.dev/community · isu dan diskusi `package:test`: https://github.com/dart-lang/test · tag dart di https://stackoverflow.com/questions/tagged/dart |
| Sertifikasi | Tidak ada sertifikasi resmi khusus; repositori dengan CI hijau, tes properti, dan laporan mutasi lebih bernilai sebagai portofolio |

**Hasil pembelajaran Fase 8 — setelah fase ini kamu mampu:**

- merancang strategi pengujian berlapis (piramida) dan memilih jenis tes yang tepat: tabel, properti, fuzz, integrasi;
- menulis properti dengan generator, shrinking, dan seed yang dicatat, serta menghindari properti hampa;
- membuat tes deterministik: waktu disuntikkan (`clock`, `fake_async`), I/O dibungkus antarmuka, dan memilih fake sebelum mock;
- menguji batas sistem (berkas, proses, CLI) dan memakai tes golden dengan benar;
- menyalakan analisis statis ketat dan kontrak (`throw` vs `assert`, anotasi `meta`) sebagai bukti yang berjalan di setiap perubahan;
- mengukur cakupan (baris dan cabang) dengan benar, menilai kualitas tes lewat mutasi, lalu merangkai semuanya ke CI.

## Daftar Isi Fase 8

<details>
  <summary>📃 Daftar Isi</summary>

- **0. Audit Kurikulum & Sambungan dari Fase 7**
- **8.1 Strategi Pengujian:** piramida, tabel, properti, fuzz, deterministik
- **8.2 Analisis Statis sebagai Bukti Ringan, Kontrak & Cakupan**
- **8.3 Menguji Batas Sistem: Berkas, Proses, CLI** *(TAMBAHAN)*
- **8.4 Studi Kasus Terpadu: To-Do v7, Verifikasi Berlapis** *(TAMBAHAN)*
- **Latihan (tanpa kunci jawaban), Ringkasan, dan Referensi Induk**

---

</details>

## 0. Audit Kurikulum & Sambungan dari Fase 7

**Sambungan.** Sejak Fase 5 kamu sudah menulis tes tabel, oracle lambat (6.7), fake terprogram (5.8), waktu virtual dan gerbang (7.7), serta uji mutasi manual (7.8). Fase 8 menyistematiskan semuanya dan menambah yang belum ada: properti dengan generator dan shrinking, fuzz, analisis statis ketat, kontrak, cakupan cabang, mutasi terukur, dan CI.

**Lompatan penomoran.** Fase ini dikerjakan tepat setelah Fase 7 materi (Asinkron), atas permintaanmu. Artinya Fase *Keamanan, Isolasi & Anonimitas* (Fase 7 kurikulum) belum dibuat. Fase 8 tidak bergantung padanya; fuzz di 8.1 hanya menyentuh batas input, dan Fase Keamanan nanti memperdalamnya. Rujukan silang di dokumen sebelumnya perlu dibaca begini sampai kamu memutuskan penomoran akhir:

| Rujukan lama (Fase 5–7) | Isi yang dijanjikan | Kini di |
| --- | --- | --- |
| “Fase 10” | menguji Future, timeout, isolate; tes properti; mutasi; benchmark di CI | Fase 8 ini (8.1–8.4) |
| “Fase 9” | keamanan: jalur aman, TOCTOU, isolasi proses | belum dibuat |
| “Fase 11” | arsitektur dan pemisahan paket | belum dibuat |

Dokumen Fase 1–7 tidak saya ubah tanpa persetujuanmu.

**Temuan audit pada teks kurikulum Fase 8.**

1. **Tautan rusak oleh escape markdown.** Referensi memuat `kiri\_check` dan `fake\_async` dengan garis miring terbalik. Tautan yang benar memakai garis bawah polos: https://pub.dev/packages/kiri\_check dan https://pub.dev/packages/fake\_async.
2. **Nama bentrok.** Contoh 8.2 memakai `Antrean<T>`, padahal `Antrean` sudah berarti antrean serialisasi di Modul 7.6 dan 7.8. Di sini diganti `AntreanTerbatas<T>`.
3. **Alur cakupan.** Alur dua langkah di 8.2 (`dart test --coverage=coverage` lalu `format_coverage`) masih berlaku, tetapi kini ada jalur lebih ringkas: `dart test --coverage-path=coverage/lcov.info`, atau `coverage:test_with_coverage`.
4. **Kriteria yang tak terpenuhi oleh perintahnya.** Latihan 8.2 menuntut “cakupan cabang minimal 90%”, sedangkan perintah yang dicantumkan hanya mengumpulkan cakupan **baris**. Cakupan cabang membutuhkan `--branch-coverage` (VM ≥ 2.17), misalnya pada `coverage:test_with_coverage`. Tanpa itu angka cabang tidak ada.
5. **“Property-based” yang belum sepenuhnya.** Contoh 8.1 adalah perulangan acak manual: bagus untuk memahami prinsip, tetapi tanpa generator terstruktur dan tanpa shrinking. Modul ini menambah `kiri_check` (1.3.x).
6. **Daftar isi menjanjikan topik tanpa kode:** fuzzing, tes asinkron dan stream, waktu terkendali, `mocktail`, anotasi `meta`, memilih lint, dan CI. Semuanya diisi di sini.
7. **Kriteria mutasi 8.1 perlu aturan tambahan.** “Minimal lima mutasi manual tertangkap” menyesatkan bila sebagian mutan ternyata **setara** (perilakunya identik dan memang tak bisa dibedakan tes). Mutan setara dicatat dan dikecualikan dari hitungan.
8. **Rincian waktu.** 12–14 jam + 10–12 jam = 22–26 jam, sedangkan header fase menyebut ≈ 30 jam; selisihnya diasumsikan untuk latihan.
9. **`assert` perlu satu pelengkap.** Klaim kurikulum benar (aktif hanya dengan `--enable-asserts`, tidak ada di build rilis). Pelengkap penting: `dart test` menjalankan tes dengan assert **aktif**, sedangkan `dart run` tanpa flag tidak. Maka `assert` menjadi oracle tambahan di tes tetapi tidak melindungi apa pun di produksi (lihat tes kenari di 8.2).

**Fakta yang diverifikasi saat penyusunan (20 November 2026).** (a) `kiri_check` 1.3.x terintegrasi dengan `package:test`: `property(...)` membungkus tes, `forAll(arbitrary, blok, {maxExamples, seed, ...})` menghasilkan input, kegagalan di-*shrink*, ada `integer`, `float`, `string`, `list`, `combine2`–`combine8`, `collect`, dan tes stateful lewat `runBehavior`. (b) `dart --enable-asserts` mengaktifkan assert pada VM mandiri; `dart test` berjalan dengan assert aktif. (c) `package:coverage`: `collect_coverage` dan `format_coverage`, skrip `test_with_coverage`, serta `--function-coverage` dan `--branch-coverage`; komentar `// coverage:ignore-line`, `ignore-start`, `ignore-end`, `ignore-file` bersama `--check-ignore`. (d) `package:test`: `--test-randomize-ordering-seed` (angka atau `random`), `--total-shards` dan `--shard-index`, `--reporter` termasuk `github`, serta `--coverage-path` untuk keluaran LCOV langsung. (e) Alat mutasi: `mutation_test` (`dart pub add --dev mutation_test`, `dart run mutation_test`, dapat memakai `--coverage coverage/lcov.info`) dan `dart_mutant` yang lebih baru. (f) Dart 3.14 dirilis 11 November 2026.

**TAMBAHAN:** 8.3 (menguji batas sistem: berkas, proses, CLI, tes golden) karena kurikulum hanya membahas logika murni dan waktu, padahal To-Do v6 berbatasan dengan berkas dan terminal; dan 8.4 (To-Do v7: memetakan setiap klaim ke alat bukti, lalu merangkai properti, fuzz, analisis statis, cakupan, mutasi, dan CI).

**Ditunda secara sadar:** plugin analyzer dan `custom_lint`, tes widget Flutter, fuzzing berbasis cakupan (belum ada mesin yang saya verifikasi matang untuk Dart), dan verifikasi formal.

**Cara memakai dokumen ini** tetap sama: baca, tulis ulang dari ingatan, jalankan, bandingkan. Kode di dokumen ini **belum dijalankan** di lingkungan penyusun (tanpa Dart SDK); jalankan `dart analyze` dan `dart test`, dan catat setiap selisih sebagai bahan perbaikan. Latihan di akhir tanpa kunci jawaban.

---

## 8.1 Strategi Pengujian: Piramida, Tabel, Properti, Fuzz & Deterministik

*Motivasi: tes tidak membuktikan kebenaran — ia membuat kesalahanmu sulit bersembunyi.*

**Struktur pembelajaran (mini daftar isi):** (1) piramida pengujian · (2) `package:test`: `group`, `setUp`, `expect`, matcher · (3) tes berbasis tabel · (4) properti, generator, shrinking, dan seed · (5) waktu terkendali: `clock`, `fake_async` · (6) fake vs mock · (7) fuzzing terkontrol · (8) tes asinkron dan stream · (9) menjaga tes cepat dan stabil.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini mengajarkan cara merancang pengujian yang menemukan bug sungguhan: tes unit berbasis tabel, *property-based testing* (sifat yang berlaku untuk ribuan input acak), fuzzing terkontrol, dan membuat kode asinkron atau berbasis waktu dapat diuji secara deterministik. Perannya di kurikulum: Fase 1–7 membuat banyak klaim (invarian, urutan, ketahanan); modul ini memberi seperangkat alat untuk *membuktikan* klaim itu secara berulang, bukan sekali lewat percobaan manual.

### B. Konsep Kunci & Filosofi Mendalam

- **Tes hanya bisa menyangkal.** Tes yang lulus tidak membuktikan tak ada bug; tes yang gagal membuktikan ada. Tujuan pengujian bukan kepastian, melainkan menaikkan kepercayaan dengan biaya efisien. Pertanyaan yang tepat bukan “berapa banyak tes?”, melainkan “bug jenis apa yang *tidak mungkin lolos* dari rangkaian tes ini?”.
- **Masalah oracle.** Setiap tes butuh cara mengetahui jawaban yang benar. Jenis oracle: contoh pilihan manusia (tes unit), implementasi referensi yang lambat tetapi jelas (oracle 6.7), sifat yang selalu berlaku (properti), relasi antar-keluaran (metamorfik), dan model sederhana yang disandingkan dengan sistem (berbasis model).
- **Katalog properti.** (1) *bolak-balik*: `dekode(kodekan(x))` kembali ke `x`; (2) *idempoten*: `bersihkan(bersihkan(x))` sama dengan `bersihkan(x)`; (3) *invarian*: ukuran tak pernah melebihi kapasitas; (4) *oracle*: hasil versi cepat sama dengan versi lambat yang jelas; (5) *metamorfik*: menggandakan masukan menggandakan keluaran, atau mengacak urutan masukan tak mengubah himpunan keluaran; (6) *sulit dihitung, mudah diperiksa*: hasil pengurutan terurut dan merupakan permutasi masukan.
- **Generator menentukan kualitas.** Distribusi input menentukan apa yang tersentuh. Properti tanpa kasus tepi (nol, negatif, kosong, sangat besar) kehilangan separuh nilainya. Awas properti **hampa**: bila prasyarat menyaring hampir semua input, tes lulus tanpa memeriksa apa pun; amati distribusinya (fungsi `collect` pada `kiri_check`).
- **Shrinking.** Setelah menemukan input gagal yang besar, pustaka mencoba input yang lebih sederhana yang tetap gagal, sampai contoh minimal. Itu mengubah “gagal pada daftar 63 elemen acak” menjadi “gagal pada `[0, 0]`”.
- **Determinisme.** Dijalankan ulang dengan masukan sama, hasilnya harus sama: seed acak dicatat; waktu disuntikkan (`package:clock`, `fake_async`; lihat 7.7); I/O dibungkus antarmuka yang bisa diganti.
- **Test double.** *Dummy* (pengisi argumen), *stub* (jawaban terprogram), *fake* (implementasi sederhana yang benar-benar bekerja), *spy* (merekam panggilan), *mock* (memverifikasi panggilan). Dahulukan **fake** dan objek nyata yang murah; mock hanya untuk memverifikasi *interaksi* di batas (misalnya notifikasi terkirim tepat sekali), karena mock berlebihan membuat tes memverifikasi mock itu sendiri.
- **Fuzzing.** Melempar input acak atau rusak ke pemroses (parser, dekoder) untuk mencari crash. Kontrak yang diuji sederhana: *hanya galat yang dijanjikan yang boleh keluar* (misalnya `FormatException`); tak boleh ada `RangeError`, `StateError`, atau loop tak berujung. Fuzz tanpa panduan cakupan itu murah dan tetap menemukan bug di batas.
- **Uji perilaku, bukan implementasi.** Tes yang mengunci nama method privat atau urutan pemanggilan internal pecah setiap refaktor. Tes yang baik hanya runtuh ketika *perilaku yang dijanjikan* berubah.
- **Stabil dan cepat.** Tes yang kadang gagal (*flaky*) merusak kepercayaan; penyebab umum: waktu nyata, urutan eksekusi, keadaan bersama, jaringan, dan acak yang tak dicatat. Urutan acak (`--test-randomize-ordering-seed=random`) membongkar ketergantungan antar-tes. Pisahkan tes cepat (unit, properti) dari yang lambat (integrasi) dengan tag.
- **Dampak desain.** Hanya tes contoh: kombinasi tak terpikirkan lolos. Tes bergantung jam atau jaringan nyata: *flaky*. Mock berlebihan: yang diverifikasi adalah mock. Seed tak dicatat: kegagalan tak bisa direproduksi. Cakupan baris 100%: bukan jaminan, karena mengukur apa yang *dijalankan*, bukan apa yang *diverifikasi*.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — fondasi `package:test`: `group`, `setUp`, `expect`, matcher.** Unit yang diuji, antrean berkapasitas (nama `AntreanTerbatas` agar tak bentrok dengan `Antrean` serialisasi di Fase 7):

```dart
import 'dart:collection';

class AntreanTerbatas<T> {
  AntreanTerbatas(this.kapasitas) {
    if (kapasitas <= 0) {
      throw ArgumentError.value(kapasitas, 'kapasitas', 'harus > 0');
    }
  }

  final int kapasitas;
  final _isi = ListQueue<T>();

  int get panjang => _isi.length;
  bool get kosong => _isi.isEmpty;
  bool get penuh => _isi.length >= kapasitas;

  void masuk(T x) {
    if (penuh) throw StateError('antrean penuh');
    _isi.addLast(x);
  }

  T keluar() {
    if (kosong) throw StateError('antrean kosong');
    return _isi.removeFirst();
  }
}
```

```dart
import 'package:test/test.dart';

void main() {
  group('AntreanTerbatas', () {
    late AntreanTerbatas<int> antrean;

    setUp(() {
      antrean = AntreanTerbatas<int>(2); // objek BARU untuk tiap tes: tak ada keadaan bersama
    });

    test('keluar mengikuti urutan masuk (FIFO)', () {
      antrean
        ..masuk(1)
        ..masuk(2);
      expect(antrean.keluar(), 1);
      expect(antrean.keluar(), 2);
      expect(antrean.kosong, isTrue);
    });

    test('masuk saat penuh melempar StateError dan tak mengubah isi', () {
      antrean
        ..masuk(1)
        ..masuk(2);
      expect(antrean.penuh, isTrue);
      expect(() => antrean.masuk(3), throwsStateError);
      expect(antrean.panjang, 2, reason: 'percobaan yang gagal tak boleh mengubah isi');
    });

    test('keluar saat kosong melempar StateError', () {
      expect(antrean.keluar, throwsStateError);
    });

    test('kapasitas tak valid ditolak', () {
      expect(() => AntreanTerbatas<int>(0), throwsA(isA<ArgumentError>()));
    });
  });
}
```

```bash
dart test                                   # semua tes di test/
dart test test/antrean_test.dart            # satu berkas
dart test -n 'FIFO'                         # hanya tes yang namanya cocok
dart test --test-randomize-ordering-seed=random   # acak urutan: membongkar ketergantungan antar-tes
```

- `group(deskripsi, () { ... })` — mengelompokkan tes; deskripsi grup ditambahkan di depan nama tiap tes sehingga laporan terbaca sebagai kalimat.
- `late AntreanTerbatas<int> antrean;` + `setUp(() { antrean = ...; })` — `setUp` berjalan sebelum **setiap** tes di grup, jadi tiap tes mendapat objek segar; `late` berjanji variabel terisi sebelum dipakai.
- `expect(aktual, matcher, reason: ...)` — pernyataan utama; `matcher` menggambarkan harapan (`isTrue`, `equals`, `throwsStateError`); `reason` muncul di pesan gagal.
- `expect(() => antrean.masuk(3), throwsStateError)` — membungkus panggilan dalam fungsi agar matcher yang memanggilnya dan menangkap galatnya; tanpa pembungkus galat akan lolos ke tes dan menggagalkannya.
- `expect(antrean.keluar, throwsStateError)` — melewatkan *tear-off* method tanpa tanda kurung; matcher yang memanggilnya.
- `throwsA(isA<ArgumentError>())` — matcher untuk tipe galat tertentu; `isA<T>()` memeriksa tipe.
- Matcher yang paling sering dipakai: `equals`, `isTrue`/`isFalse`, `isNull`/`isNotNull`, `isEmpty`/`hasLength(n)`, `contains`, `orderedEquals`, `unorderedEquals`, `closeTo(nilai, delta)`, `greaterThan`, `isA<T>()`, `throwsA(...)`, `allOf(...)`, `anyOf(...)`, `isNot(...)`.
- Opsi `-n` mencocokkan nama tes; `--test-randomize-ordering-seed=random` mengacak urutan dan mencetak seed supaya urutan yang memunculkan kegagalan bisa diulang.

**Contoh 2 — tes berbasis tabel: data terpisah dari logika uji.**

```dart
double konversi(double nilai, double faktor) {
  if (!faktor.isFinite || faktor <= 0) {
    throw ArgumentError.value(faktor, 'faktor', 'harus berhingga dan > 0');
  }
  return nilai * faktor;
}
```

```dart
import 'package:test/test.dart';

void main() {
  group('konversi: nilai valid', () {
    final kasus = <({String nama, double nilai, double faktor, double harapan})>[
      (nama: 'km ke m', nilai: 5, faktor: 1000, harapan: 5000),
      (nama: 'nol tetap nol', nilai: 0, faktor: 1000, harapan: 0),
      (nama: 'negatif', nilai: -2, faktor: 100, harapan: -200),
      (nama: 'pecahan kecil', nilai: 0.001, faktor: 1000, harapan: 1),
      (nama: 'sangat besar', nilai: 1e300, faktor: 10, harapan: 1e301),
    ];

    for (final k in kasus) {
      test(k.nama, () {
        expect(
          konversi(k.nilai, k.faktor),
          closeTo(k.harapan, k.harapan.abs() * 1e-12 + 1e-12),
        );
      });
    }
  });

  group('konversi: faktor tak valid', () {
    for (final faktor in [0.0, -1.0, double.nan, double.infinity]) {
      test('faktor $faktor ditolak', () {
        expect(() => konversi(1, faktor), throwsArgumentError);
      });
    }
  });
}
```

- `<({String nama, double nilai, double faktor, double harapan})>[...]` — daftar *record bernama*: tiap baris tabel punya nama kolom yang terbaca; literal `5` otomatis menjadi `5.0` karena tipe elemen sudah `double`.
- `for (final k in kasus) { test(k.nama, ...) }` — satu logika uji, banyak tes terdaftar; tiap baris muncul sebagai tes sendiri di laporan, sehingga baris yang gagal langsung terlihat namanya.
- `closeTo(harapan, delta)` — perbandingan bilangan desimal dengan toleransi; delta relatif (`harapan.abs() * 1e-12`) ditambah batas mutlak kecil agar `0` tidak menuntut ketepatan sempurna. Jangan membandingkan `double` dengan `equals` kecuali memang bit-identik.
- Kelompok kedua memasukkan nilai tak valid, termasuk `NaN` dan tak hingga: *kasus tepi dimasukkan ke tabel*, bukan diingat-ingat.
- Nama dinamis `'faktor $faktor ditolak'` memastikan setiap baris punya nama unik dan informatif.

**Contoh 3 — properti dengan seed yang dicatat (perulangan manual).**

```dart
import 'dart:io';
import 'dart:math';

import 'package:test/test.dart';

/// Seed dari lingkungan (SEED=...) atau baru; selalu dicatat agar kegagalan bisa diulang.
int ambilSeed() =>
    int.tryParse(Platform.environment['SEED'] ?? '') ??
    DateTime.now().microsecondsSinceEpoch & 0x7fffffff;

void properti(
  String nama,
  void Function(Random acak) badan, {
  int putaran = 1000,
}) {
  test(nama, () {
    final seed = ambilSeed();
    printOnFailure('seed=$seed  (ulangi: SEED=$seed dart test)');
    final acak = Random(seed);
    for (var i = 0; i < putaran; i++) {
      badan(acak);
    }
  });
}

void main() {
  properti('bolak-balik mendekati identitas', (acak) {
    final nilai = (acak.nextDouble() - 0.5) * 1e6;
    final faktor = acak.nextDouble() * 999 + 0.001;
    final balik = konversi(konversi(nilai, faktor), 1 / faktor);
    expect(
      balik,
      closeTo(nilai, nilai.abs() * 1e-9 + 1e-9),
      reason: 'nilai=$nilai faktor=$faktor',
    );
  }, putaran: 10000);
}
```

- `Platform.environment['SEED']` — membaca variabel lingkungan; kegagalan di CI dapat diulang lokal dengan `SEED=123456 dart test`.
- `DateTime.now().microsecondsSinceEpoch & 0x7fffffff` — seed baru bila tak diberikan; operasi `&` memotongnya ke 31 bit supaya tetap bilangan bulat kecil yang mudah disalin.
- `printOnFailure(...)` — mencetak pesan **hanya bila tes gagal**, jadi laporan sukses tetap bersih tetapi kegagalan selalu membawa seed.
- `Random(seed)` — generator acak yang deterministik untuk seed yang sama; semua nilai input berasal darinya.
- `reason: 'nilai=$nilai faktor=$faktor'` — masukan yang menyebabkan gagal ikut tercetak; tanpa ini kamu hanya tahu “ada yang gagal”.
- Keterbatasan jujur: sebaran nilai seragam (kasus tepi seperti `0`, nilai sangat kecil, dan sangat besar jarang muncul) dan tak ada *shrinking*. Contoh berikutnya memakai pustaka yang menanganinya.

**Contoh 4 — properti sungguhan dengan `kiri_check`: generator, shrinking, seed.** Tambahkan `dart pub add dev:kiri_check`.

```dart
import 'package:kiri_check/kiri_check.dart';
import 'package:test/test.dart';

void main() {
  final nilaiAcak = float(min: -1e6, max: 1e6, nan: false, infinity: false);
  final faktorAcak = float(min: 0.001, max: 1000, nan: false, infinity: false);

  property('bolak-balik mendekati identitas', () {
    forAll(
      combine2(nilaiAcak, faktorAcak),
      (pasangan) {
        final (nilai, faktor) = pasangan;
        final balik = konversi(konversi(nilai, faktor), 1 / faktor);
        expect(balik, closeTo(nilai, nilai.abs() * 1e-9 + 1e-9));
      },
      maxExamples: 10000,
    );
  });

  property('transitivitas: A ke B ke C sama dengan A ke C', () {
    forAll(combine3(nilaiAcak, faktorAcak, faktorAcak), (t) {
      final (nilai, f1, f2) = t;
      final langsung = konversi(nilai, f1 * f2);
      final berantai = konversi(konversi(nilai, f1), f2);
      expect(berantai, closeTo(langsung, langsung.abs() * 1e-9 + 1e-9));
    });
  });

  property('monotonik untuk faktor positif', () {
    forAll(combine3(nilaiAcak, nilaiAcak, faktorAcak), (t) {
      final (a, b, faktor) = t;
      final (kecil, besar) = a <= b ? (a, b) : (b, a);
      expect(konversi(kecil, faktor), lessThanOrEqualTo(konversi(besar, faktor)));
    });
  });

  property('lihat sebaran masukan dengan collect', () {
    forAll(nilaiAcak, (n) {
      collect(n.isNegative ? 'negatif' : 'non-negatif');
    });
  });
}
```

Implementasi sengaja salah, untuk melihat shrinking bekerja:

```dart
// Membuang pecahan pada nilai besar: bug yang tak tertangkap contoh "ramah".
double konversiBug(double nilai, double faktor) =>
    nilai.abs() > 1000 ? (nilai ~/ 1) * faktor : nilai * faktor;
```

- `import 'package:kiri_check/kiri_check.dart'` — menyediakan `property`, `forAll`, dan generator (disebut *arbitrary*); terintegrasi dengan `package:test`, sehingga dijalankan oleh `dart test` yang sama.
- `float(min:, max:, nan: false, infinity: false)` — generator `double` dalam rentang tertentu; `NaN` dan tak hingga dimatikan karena `konversi` memang menolak faktor tak valid (kasus itu sudah ada di tabel, Contoh 2).
- `combine2(a, b)` / `combine3(a, b, c)` — menggabungkan beberapa generator menjadi satu yang menghasilkan *record* `(x, y)` atau `(x, y, z)`; di blok, `final (nilai, faktor) = pasangan;` membongkar record itu.
- `property(deskripsi, () { ... })` — pembungkus `test` dari `package:test`: menerima argumen yang sama (`timeout`, `tags`, `skip`, dan lain-lain).
- `forAll(arbitrary, blok, {maxExamples, seed, ...})` — menjalankan `blok` untuk banyak input; `maxExamples: 10000` menaikkan jumlah contoh, dan `seed: 42` (parameter bernama yang sama) mengunci urutan input agar kegagalan dapat diulang.
- Properti kedua dan ketiga adalah *relasi metamorfik*: tak perlu tahu hasil benar, hanya hubungan antar-hasil (berantai sama dengan langsung; naik masukan tak menurunkan keluaran untuk faktor positif; perkalian IEEE bersifat monotonik).
- Ganti `konversi` dengan `konversiBug` pada properti pertama dan jalankan: pustaka akan menyusutkan input gagal menuju contoh yang jauh lebih sederhana di sekitar batas 1000. Catat contoh minimal yang kamu dapat; itu bahan Latihan 8.1.
- `collect(nilai)` — mencatat kategori dari setiap data uji supaya sebaran masukan dapat diperiksa (baca dokumentasinya untuk cara melihat laporannya); gunanya mendeteksi properti hampa.

**Contoh 5 — tes berbasis model: bandingkan sistem dengan model yang jelas pada urutan operasi acak.** Memakai `properti(...)` dari Contoh 3 dan `AntreanTerbatas` dari Contoh 1.

```dart
properti('AntreanTerbatas setara model List pada urutan operasi acak', (acak) {
  final kapasitas = 1 + acak.nextInt(5);
  final nyata = AntreanTerbatas<int>(kapasitas);
  final model = <int>[]; // model: List biasa dengan aturan yang jelas

  for (var langkah = 0; langkah < 50; langkah++) {
    if (acak.nextBool()) {
      final x = acak.nextInt(100);
      if (model.length >= kapasitas) {
        expect(() => nyata.masuk(x), throwsStateError);
      } else {
        nyata.masuk(x);
        model.add(x);
      }
    } else {
      if (model.isEmpty) {
        expect(nyata.keluar, throwsStateError);
      } else {
        expect(nyata.keluar(), model.removeAt(0));
      }
    }
    final konteks = 'langkah $langkah, kapasitas $kapasitas';
    expect(nyata.panjang, model.length, reason: konteks);
    expect(nyata.penuh, model.length >= kapasitas, reason: konteks);
    expect(nyata.kosong, model.isEmpty, reason: konteks);
  }
}, putaran: 2000);
```

- `final model = <int>[]` — model referensi yang begitu sederhana sehingga hampir pasti benar; sistem sungguhan dibuktikan *setara* dengannya.
- Setiap putaran memilih kapasitas dan 50 operasi acak (`masuk` atau `keluar`); tiap operasi dijalankan pada model dan sistem, lalu keadaan keduanya dibandingkan.
- `expect(nyata.keluar(), model.removeAt(0))` — argumen dievaluasi dari kiri ke kanan: sistem mengeluarkan elemen, model mengeluarkan elemen pertamanya, lalu keduanya dibandingkan.
- Operasi yang *seharusnya gagal* (masuk saat penuh, keluar saat kosong) juga dibandingkan: model menentukan kapan galat wajib muncul.
- `kiri_check` punya mesin tes stateful sendiri (`runBehavior`, impor `package:kiri_check/stateful_test.dart`) yang menghasilkan dan menyusutkan urutan perintah; versi manual ini memperlihatkan idenya.

**Contoh 6 — fuzzing terkontrol dan tes bolak-balik pada `dekode` To-Do.** Memakai `properti(...)` dari Contoh 3, `kodekan` dan `dekode` dari proyek To-Do (7.8), dan `buatData` dari 6.7.

```dart
import 'dart:math';

import 'package:logika_fase7/todo.dart';
import 'package:test/test.dart';

import '../tool/data.dart'; // buatData() dari 6.7

/// Merusak sebuah masukan valid sedikit demi sedikit (ubah, hapus, sisipkan satu unit kode).
String mutasi(String sumber, Random acak) {
  if (sumber.isEmpty) return String.fromCharCode(acak.nextInt(0x250));
  final unit = sumber.codeUnits.toList();
  final jumlah = 1 + acak.nextInt(4);
  for (var i = 0; i < jumlah; i++) {
    switch (acak.nextInt(3)) {
      case 0:
        unit[acak.nextInt(unit.length)] = acak.nextInt(0x250);
      case 1:
        if (unit.length > 1) unit.removeAt(acak.nextInt(unit.length));
      default:
        unit.insert(acak.nextInt(unit.length + 1), acak.nextInt(0x250));
    }
  }
  return String.fromCharCodes(unit);
}

void main() {
  properti('fuzz dekode: hanya FormatException yang boleh keluar', (acak) {
    final awal = kodekan(buatData(1 + acak.nextInt(20), ragam: 5, benih: acak.nextInt(1000)));
    final rusak = mutasi(awal, acak);
    try {
      dekode(rusak); // boleh sukses: mutasi kadang tetap valid
    } on FormatException {
      // galat yang dijanjikan: sah
    } on Object catch (e, s) {
      fail('galat tak terduga ${e.runtimeType}: $e\nmasukan: $rusak\n$s');
    }
  }, putaran: 5000);

  properti('fuzz dekode: teks acak murni', (acak) {
    final teks = String.fromCharCodes(
      List.generate(acak.nextInt(200), (_) => acak.nextInt(0x250)),
    );
    try {
      dekode(teks);
    } on FormatException {
      // sah
    } on Object catch (e, s) {
      fail('galat tak terduga ${e.runtimeType}: $e\nmasukan: $teks\n$s');
    }
  }, putaran: 5000);

  properti('bolak-balik: kodekan(dekode(s)) sama dengan s', (acak) {
    final s = kodekan(
      buatData(acak.nextInt(40), ragam: 1 + acak.nextInt(10), benih: acak.nextInt(10000)),
    );
    expect(kodekan(dekode(s)), s, reason: 'masukan: $s');
  });
}
```

- `sumber.codeUnits.toList()` — salinan unit kode yang dapat diubah; mutasi bekerja di tingkat unit kode, jadi menghasilkan teks yang kadang bahkan bukan JSON atau bukan teks yang valid.
- `switch (acak.nextInt(3))` — memilih salah satu dari tiga mutasi; sejak Dart 3 setiap `case` otomatis berhenti, tanpa `break`.
- `try { dekode(rusak); } on FormatException { } on Object catch (e, s) { fail(...) }` — inti fuzz: **sukses boleh, `FormatException` boleh, apa pun selain itu adalah bug**; `fail` menggagalkan tes dan membawa jenis galat, pesan, masukan pemicu, dan jejaknya.
- Jika `dekode` memakai *cast* (`as`) pada hasil `jsonDecode`, fuzz seperti ini lazim menemukan `TypeError`. Perbaikannya: periksa bentuk dengan pola (`switch` atau `if case`) dan lempar `FormatException` untuk bentuk yang salah, seperti prinsip “parse, jangan validasi” (3.5).
- Properti terakhir memakai `kodekan` sebagai penghasil data valid dan menegaskan *kanonikalitas*: mengodekan ulang hasil dekode menghasilkan teks yang sama. Ini tak perlu kesetaraan `Item`, hanya perbandingan `String`.
- Seed dicatat oleh `properti(...)` lewat `printOnFailure`, jadi crash yang ditemukan fuzz dapat diulang persis dengan `SEED=... dart test`.

**Contoh 7 — waktu terkendali: `package:clock` dan `fake_async`.**

```dart
import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';

/// Logika yang butuh "sekarang" memakai clock.now(), bukan DateTime.now().
bool terlambat(DateTime batas) => clock.now().isAfter(batas);

class Sesi {
  Sesi({this.umur = const Duration(minutes: 30)}) : _mulai = clock.now();
  final Duration umur;
  final DateTime _mulai;

  bool get kedaluwarsa => clock.now().difference(_mulai) >= umur;
}

void main() {
  test('terlambat: waktu dibekukan', () {
    withClock(Clock.fixed(DateTime(2026, 11, 19, 12)), () {
      expect(terlambat(DateTime(2026, 11, 19, 11)), isTrue);
      expect(terlambat(DateTime(2026, 11, 19, 13)), isFalse);
    });
  });

  test('Sesi kedaluwarsa tepat pada 30 menit (waktu virtual)', () {
    fakeAsync((async) {
      final sesi = Sesi();
      async.elapse(const Duration(minutes: 29, seconds: 59));
      expect(sesi.kedaluwarsa, isFalse);
      async.elapse(const Duration(seconds: 1));
      expect(sesi.kedaluwarsa, isTrue);
    });
  });
}
```

- `clock.now()` — jam global dari `package:clock` yang berperilaku seperti `DateTime.now()` di produksi, tetapi dapat diganti di tes; `DateTime.now()` langsung tak bisa dikendalikan.
- `withClock(Clock.fixed(waktu), () { ... })` — menjalankan blok dengan jam yang dibekukan pada `waktu`; setelah blok selesai jam kembali normal.
- Di dalam `fakeAsync`, `clock` ikut maju bersama `elapse` (integrasi bawaan `fake_async`), sehingga `Sesi` dapat diuji batas tepatnya tanpa menunggu 30 menit.
- Alternatif tanpa dependensi tambahan: menerima `DateTime Function() sekarang` sebagai parameter (bawaan `DateTime.now`) dan menggantinya di tes. Pilih ini bila kamu ingin API yang eksplisit.

**Contoh 8 — fake dulu, mock bila interaksinya sendiri adalah syaratnya.**

```dart
abstract interface class Pengirim {
  Future<void> kirim(String pesan);
}

class Pengingat {
  Pengingat(this._pengirim);
  final Pengirim _pengirim;

  /// Mengirim satu ringkasan; mengembalikan jumlah tugas terlambat.
  Future<int> ingatkan(List<String> terlambat) async {
    if (terlambat.isEmpty) return 0;
    await _pengirim.kirim('Terlambat: ${terlambat.join(', ')}');
    return terlambat.length;
  }
}

/// Fake: implementasi sederhana yang benar-benar bekerja.
class PengirimFake implements Pengirim {
  final terkirim = <String>[];

  @override
  Future<void> kirim(String pesan) async => terkirim.add(pesan);
}
```

```dart
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class PengirimMock extends Mock implements Pengirim {}

void main() {
  test('mengirim satu ringkasan (fake: periksa HASIL)', () async {
    final fake = PengirimFake();
    final jumlah = await Pengingat(fake).ingatkan(['roti', 'susu']);
    expect(jumlah, 2);
    expect(fake.terkirim, ['Terlambat: roti, susu']);
  });

  test('tak menghubungi pengirim bila tak ada yang terlambat (mock: periksa INTERAKSI)', () async {
    final mock = PengirimMock();
    expect(await Pengingat(mock).ingatkan([]), 0);
    verifyZeroInteractions(mock);
  });

  test('mengirim tepat sekali dengan pesan yang benar (mock)', () async {
    final mock = PengirimMock();
    when(() => mock.kirim('Terlambat: roti')).thenAnswer((_) async {});
    await Pengingat(mock).ingatkan(['roti']);
    verify(() => mock.kirim('Terlambat: roti')).called(1);
    verifyNoMoreInteractions(mock);
  });

  test('galat dari pengirim diteruskan ke pemanggil (stub galat)', () async {
    final mock = PengirimMock();
    when(() => mock.kirim('Terlambat: roti')).thenThrow(StateError('jaringan putus'));
    await expectLater(Pengingat(mock).ingatkan(['roti']), throwsStateError);
  });
}
```

- `abstract interface class Pengirim` — batas yang dapat diganti; `Pengingat` bergantung pada antarmuka, bukan pada layanan nyata (inversi ketergantungan, Fase 4).
- `PengirimFake` menyimpan pesan ke daftar: tes memeriksa *hasil akhir* (apa yang terkirim), bukan bagaimana cara memanggilnya, sehingga tetap lulus walau implementasi `Pengingat` direfaktor.
- `class PengirimMock extends Mock implements Pengirim {}` — mock dari `package:mocktail`, tanpa generator kode; `Mock` merekam semua panggilan.
- `when(() => mock.kirim(...)).thenAnswer((_) async {})` — mengatur jawaban untuk panggilan dengan argumen persis itu; untuk method `Future`, `thenAnswer` mengembalikan `Future`.
- `verify(() => ...).called(1)` — memastikan panggilan terjadi tepat sekali; `verifyZeroInteractions` dan `verifyNoMoreInteractions` menegaskan tak ada panggilan lain.
- `thenThrow(...)` — mensimulasikan kegagalan pengirim; di sini galat dilempar saat `kirim` dipanggil di dalam fungsi `async`, jadi muncul sebagai kegagalan `Future` yang ditangkap `throwsStateError`.
- Aturan praktis: bila yang kamu periksa adalah *keadaan akhir*, pakai fake; bila syaratnya adalah *interaksi itu sendiri* (tepat sekali, tidak sama sekali, urutan), pakai mock. Mock di semua tempat membuat tes pecah saat refaktor.

**Contoh 9 — tes asinkron dan stream (ringkas; dasarnya di 7.7).**

```dart
import 'package:async/async.dart';
import 'package:test/test.dart';

void main() {
  test('Future: completion dan galat', () async {
    await expectLater(Future.value(3), completion(equals(3)));
    await expectLater(Future<int>.error(StateError('x')), throwsStateError);
  });

  test('Stream: urutan, penutupan, dan galat', () async {
    final s = Stream.fromIterable([1, 2]).asyncMap((x) async => x * 10);
    await expectLater(s, emitsInOrder([10, 20, emitsDone]));

    final g = Stream<int>.error(StateError('x'));
    await expectLater(g, emitsError(isA<StateError>()));
  });

  test('StreamQueue: tarik satu per satu', () async {
    final antrean = StreamQueue(Stream.fromIterable([1, 2, 3]));
    addTearDown(antrean.cancel);
    expect(await antrean.next, 1);
    expect(await antrean.peek, 2);
    expect(await antrean.take(2), [2, 3]);
    expect(await antrean.hasNext, isFalse);
  });
}
```

- `await expectLater(future, matcher)` — selalu di-`await` agar tes menunggu dan urutan jelas; `completion(...)` mencocokkan *hasil* `Future`, `throwsStateError` mencocokkan *galat*-nya.
- `emitsInOrder([...])`, `emitsDone`, `emitsError(matcher)` — matcher stream untuk urutan event, penutupan, dan galat.
- `StreamQueue` (`package:async`) — membungkus stream agar dapat ditarik bertahap: `next` mengambil satu, `peek` mengintip tanpa mengambil, `take(n)` mengambil beberapa, `hasNext` memeriksa sisa.
- `addTearDown(antrean.cancel)` — mendaftarkan pembersihan yang berjalan setelah tes selesai, sehingga langganan tak bocor walau tes gagal di tengah.

**Contoh 10 — menjaga tes cepat dan stabil: tag, konfigurasi, acak, sharding.**

```yaml
# dart_test.yaml
tags:
  lambat:
    timeout: 3x      # tes bertanda 'lambat' mendapat batas waktu 3x lipat
  integrasi: {}      # tag harus dideklarasikan agar salah ketik terdeteksi
concurrency: 4       # jumlah berkas tes yang berjalan paralel
```

```dart
@Tags(['lambat', 'integrasi'])
library;

import 'package:test/test.dart';

void main() {
  test('alur lengkap dengan berkas nyata', () {
    // ... tes yang memang butuh waktu atau sumber daya nyata
  });
}
```

```bash
dart test -x lambat                              # jalur cepat harian: kecualikan yang lambat
dart test -t integrasi                           # hanya yang bertag integrasi
dart test --test-randomize-ordering-seed=random  # acak urutan, seed dicetak untuk mengulang
dart test --total-shards 4 --shard-index 0       # CI: bagi suite menjadi 4, jalankan pecahan 0
dart test --reporter=expanded                    # satu baris per tes (cocok untuk log CI)
```

- `@Tags([...])` + `library;` — anotasi di atas berkas menandai seluruh tes di dalamnya; `library;` tanpa nama adalah sintaks Dart 3 untuk anotasi tingkat berkas.
- `dart_test.yaml` — berkas konfigurasi runner; `tags:` mendeklarasikan tag beserta pengaturannya (misalnya pengali batas waktu `3x`), dan `concurrency` mengatur paralelisme antar-berkas.
- `-x lambat` / `-t integrasi` — opsi `--exclude-tags` dan `--tags`: jalankan jalur cepat setiap menyimpan, jalur lengkap di CI.
- `--test-randomize-ordering-seed=random` — mengacak urutan tes; bila ada tes yang bergantung pada urutan, ia akan gagal sesekali, dan seed yang tercetak memungkinkan mengulangnya.
- `--total-shards` dan `--shard-index` — membagi suite ke beberapa pekerja CI yang berjalan paralel.
- Anggaran waktu yang wajar: jalur cepat (unit dan properti) selesai dalam hitungan detik; bila lebih lama, tes menjadi sesuatu yang dihindari.

### D. Opsi Kode Lain untuk Logika yang Sama

| Jenis tes | Menjawab pertanyaan | Biaya | Kelemahan |
| --- | --- | --- | --- |
| Contoh atau tabel | “Apakah kasus yang saya pikirkan benar?” | Rendah | Hanya kasus yang terpikirkan |
| Properti | “Apakah sifat ini berlaku untuk input sembarang?” | Sedang | Butuh merumuskan sifat; properti hampa bila generator buruk |
| Berbasis model | “Apakah sistem setara model sederhana pada urutan operasi acak?” | Sedang | Model harus benar-benar sederhana |
| Diferensial (oracle lambat) | “Apakah versi cepat sama dengan versi jelas?” | Rendah | Butuh implementasi referensi |
| Fuzz | “Apakah ada input rusak yang membuat crash?” | Rendah | Tak mengarah ke cabang tertentu |
| Golden/snapshot (8.3) | “Apakah keluaran teks tetap sama?” | Rendah | Mudah menyetujui perubahan tanpa membaca |
| Integrasi atau end-to-end | “Apakah bagian-bagian bekerja bersama?” | Tinggi | Lambat dan rawan flaky |
| Mutasi (8.2) | “Apakah tes saya benar-benar mendeteksi perubahan?” | Tinggi | Lambat; ada mutan setara |

| Kebutuhan | Pilihan | Catatan |
| --- | --- | --- |
| Pustaka properti | `kiri_check` | Terintegrasi dengan `package:test`, shrinking, tes stateful |
| Pustaka properti | `dartproptest` | Alternatif yang masih muda (seri 0.2.x, rilis akhir 2025); mendukung shrinking dan tes stateful |
| Pustaka properti | Perulangan manual | Tanpa dependensi; tanpa shrinking (Contoh 3) |
| Mengendalikan waktu | `clock` + `withClock` | Untuk logika yang membaca “sekarang” |
| Mengendalikan waktu | `fakeAsync` | Untuk timer, `Future.delayed`, dan stream berbasis waktu |
| Mengendalikan waktu | Parameter `DateTime Function()` | Eksplisit; tanpa dependensi |
| Test double | Fake, stub, spy, mock | Dahulukan fake |

Alternatif pustaka properti, contoh jaminan sederhana dengan `dartproptest`:

```dart
import 'package:dartproptest/dartproptest.dart';

void main() {
  forAll(
    (int a, int b) => a + b == b + a,
    [Gen.interval(0, 100), Gen.interval(0, 100)],
  );
}
```

- `Gen.interval(0, 100)` — generator bilangan bulat dalam rentang; daftar generator diberikan sesuai urutan parameter fungsi properti. Fungsi properti mengembalikan `bool`; bila `false`, pustaka mencari contoh minimal.
- Pilih `kiri_check` bila ingin properti menyatu dengan `group` dan `test` biasa; pilih `dartproptest` bila gaya fungsi-yang-mengembalikan-bool lebih cocok. Keduanya relatif baru, jadi kunci versi di `pubspec.yaml` dan baca catatan rilis sebelum memperbarui.

### E. Terminologi Esensial

- **Tes unit** — uji atas potongan kecil logika secara terisolasi. **Tes berbasis tabel** — satu logika uji, banyak baris data masukan dan harapan.
- **Oracle** — cara mengetahui jawaban yang benar bagi sebuah tes. **Properti** — pernyataan yang harus benar untuk semua input dalam suatu ranah. **Arbitrary/generator** — komponen yang menghasilkan data uji acak (dan menyusutkannya).
- **Shrinking** — menyusutkan input gagal yang besar menjadi contoh sekecil mungkin yang tetap gagal. **Properti hampa (vacuous)** — properti yang lulus karena hampir tak ada input yang memenuhi prasyaratnya.
- **Relasi metamorfik** — hubungan antar-keluaran dari beberapa masukan terkait (misalnya berantai sama dengan langsung). **Tes berbasis model** — membandingkan sistem dengan model sederhana pada urutan operasi acak.
- **Fake, stub, spy, mock, dummy** — jenis test double, dari implementasi sederhana yang bekerja hingga objek yang memverifikasi panggilan.
- **Flaky test** — kadang lulus, kadang gagal tanpa perubahan kode. **Determinisme** — masukan sama selalu memberi hasil sama.
- **Fuzzing** — melempar input acak atau rusak untuk memicu crash dan perilaku tak terduga. **Shard** — pecahan suite tes yang dijalankan terpisah. **Tag** — label pada tes untuk memilih atau mengecualikannya.

### F. Visualisasi (ASCII)

```text
   ▲ biaya, lambat                               ▲ jumlah
   │   integrasi / end-to-end    (sedikit)       │
   │   komponen + fake I/O       (sedang)        │
   │   unit + properti + model   (banyak)        │
   └───────────────────────────────────────────────
   makin ke bawah: makin murah, makin sering dijalankan, makin deterministik
```

```text
   seed ──► generator ──► input 1 ... input N ──► properti(input)
                                                    │
                                      lulus semua ──┴──► OK (kepercayaan naik, bukan bukti)
                                                    │
                                            gagal ──┴──► shrink: coba input lebih kecil yang tetap gagal
                                                           │
                                                           ▼
                                      contoh MINIMAL + seed ──► jadikan tes contoh permanen (regresi)
```

```text
   Yang saya periksa adalah ...
     ├── keadaan atau hasil akhir ..................... FAKE (atau objek nyata yang murah)
     ├── interaksi itu sendiri (berapa kali, urutan) .. MOCK (verify)
     ├── jawaban tertentu agar alur bisa lanjut ....... STUB
     └── sekadar pengisi argumen ...................... DUMMY
```

```text
   masukan valid ──► mutasi (ubah / hapus / sisip) ──► dekode()
                                                         ├─ sukses ............... sah
                                                         ├─ FormatException ...... sah
                                                         └─ galat lain / macet ... BUG ──► simpan sebagai tes regresi
```

### G. Hubungan dengan Modul Lain

- **Memakai:** Fase 1 (spesifikasi dan invarian menjadi properti), 6.7 (oracle lambat dan `buatData`), 5.8 (fake terprogram dan *fault injection*), 7.7 (waktu virtual dan gerbang), 7.9 (lint dan disiplin siklus hidup), serta 3.5 (parse di tepi: kontrak yang diuji fuzz).
- **Prasyarat bagi:** 8.2 (mutasi menilai kualitas tes dari modul ini), 8.3 (batas sistem), dan 8.4 (To-Do v7).
- **Dikembangkan di:** Fase Keamanan (fuzzing masukan tak tepercaya dan batas ukuran) serta Fase arsitektur (fake untuk adaptor di batas modul).

### H. Tips & Praktik Terbaik

- Tulis tes dengan pola *Arrange–Act–Assert* dan satu alasan untuk gagal; nama tes menyatakan perilaku, bukan nama method.
- Mulai dari contoh (tabel), lalu tanyakan “sifat apa yang berlaku di semua contoh ini?” dan jadikan itu properti. Katalog di B adalah daftar pertanyaan pemicu.
- Setelah properti menemukan kegagalan, **jadikan contoh minimalnya tes contoh permanen**; properti mencari, tes contoh menjaga.
- Selalu cetak seed; di CI, ulangi kegagalan dengan seed yang sama sebelum menebak penyebabnya.
- Periksa sebaran generator. Properti tanpa nol, negatif, kosong, dan nilai ekstrem hanya setengah properti.
- Bandingkan `double` dengan `closeTo` memakai toleransi relatif; jangan `equals` kecuali memang identik bit demi bit.
- Dahulukan fake; sediakan satu fake per batas (penyimpanan, pengirim, jam), dan pakai ulang di seluruh tes.
- Perlakukan tes *flaky* sebagai bug berprioritas: temukan akarnya (waktu, urutan, keadaan bersama), jangan sekadar mengulang atau mengabaikannya.
- Jalankan tes dengan urutan acak secara berkala untuk membongkar ketergantungan tersembunyi antar-tes.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Hanya tes contoh | Bug pada kombinasi tak terpikirkan lolos | Tambahkan properti, model, dan fuzz pada logika inti |
| Generator seragam tanpa kasus tepi | Properti lulus, bug di tepi lolos | Pakai generator dengan batas dan nilai khusus; periksa `collect` |
| Prasyarat properti terlalu ketat | Tes lulus tanpa memeriksa apa pun | Bangun input valid lewat generator, bukan menyaringnya |
| Seed tak dicatat | Kegagalan tak bisa diulang | `printOnFailure` seed; terima `SEED` dari lingkungan |
| `equals` pada `double` | Tes gagal karena galat pembulatan | `closeTo` dengan toleransi relatif |
| Mock di mana-mana | Tes pecah setiap refaktor; yang diverifikasi adalah mock | Fake untuk hasil; mock hanya untuk interaksi di batas |
| Tes bergantung pada `DateTime.now()` atau jaringan | *Flaky* | `clock`, `fakeAsync`, fake I/O |
| Tes saling bergantung lewat keadaan bersama | Lulus sendiri, gagal bersama atau bila diacak | `setUp` membuat objek baru; jalankan dengan urutan acak |
| Properti yang mengulang implementasi | Selalu lulus, termasuk saat salah | Gunakan relasi atau oracle yang independen |
| Fuzz tanpa kontrak yang jelas | Tak tahu apa yang dianggap gagal | Tetapkan: hanya galat yang dijanjikan yang boleh keluar |
| Mengejar cakupan baris 100% | Tes tanpa asersi | Nilai tes dengan mutasi (8.2) |

### J. Sumber Referensi

- ✔ `package:test`: https://pub.dev/packages/test · `dart test`: https://dart.dev/tools/dart-test · Pengujian di Dart: https://dart.dev/tools/testing
- ✔ `kiri_check` (paket, API, panduan awal, repositori): https://pub.dev/packages/kiri\_check · https://pub.dev/documentation/kiri\_check/latest/kiri\_check · https://szktty.github.io/kiri-check/quickstart.html · https://github.com/szktty/kiri-check
- ✔ `dartproptest`: https://pub.dev/documentation/dartproptest/latest
- ✔ `fake_async`: https://pub.dev/packages/fake\_async/changelog · `clock`: https://pub.dev/packages/clock · `mocktail`: https://pub.dev/packages/mocktail · ✔ `async` (`StreamQueue`): https://pub.dev/packages/async
- Konsep: https://en.wikipedia.org/wiki/QuickCheck · https://en.wikipedia.org/wiki/Test\_oracle · https://en.wikipedia.org/wiki/Metamorphic\_testing · https://en.wikipedia.org/wiki/Fuzzing · https://en.wikipedia.org/wiki/Test\_double
- Martin Fowler, *The Practical Test Pyramid*/*TestPyramid*: https://martinfowler.com/bliki/TestPyramid.html · *Mocks Aren't Stubs*: https://martinfowler.com/articles/mocksArentStubs.html · *Eradicating Non-Determinism in Tests*: https://martinfowler.com/articles/nonDeterminism.html
- Hypothesis (gagasan generator dan shrinking, bukan Dart): https://hypothesis.readthedocs.io/en/latest/
- Buku: F. Hebert, *Property-Based Testing with PropEr, Erlang, and Elixir* (dirujuk dokumentasi `kiri_check` sebagai pengantar); J. Hughes, *How to Specify It!* (makalah tentang merumuskan properti).

---

## 8.2 Analisis Statis sebagai Bukti Ringan, Kontrak & Cakupan

*Motivasi: bukti termurah adalah yang berjalan sendiri setiap kali kamu menyimpan.*

**Struktur pembelajaran (mini daftar isi):** (1) `dart analyze` dan `--fatal-infos` · (2) mode strict · (3) memilih dan mengurasi lint · (4) `dart fix` · (5) *design by contract*: `throw` vs `assert` · (6) anotasi `package:meta` dan tipe sebagai bukti · (7) cakupan: baris, fungsi, cabang · (8) mutation testing · (9) CI sederhana.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini memakai analyzer, lint, dan mode ketat sebagai “bukti ringan” yang berjalan setiap kode berubah; menerapkan *design by contract* (prakondisi, pascakondisi, invarian) dengan `throw`, `assert`, dan tipe; serta mengukur cakupan tes dan menilai kualitas tes itu sendiri lewat mutasi. Perannya: 8.1 menulis tes; modul ini menjawab dua pertanyaan lanjutan: *apa saja yang bisa ditolak otomatis sebelum satu tes pun berjalan*, dan *seberapa bisa dipercaya tes yang kita punya*.

### B. Konsep Kunci & Filosofi Mendalam

- **Tangga bukti statis.** Tipe, lalu null safety, lalu peringatan analyzer, lalu lint, lalu mode strict. Setiap anak tangga menolak satu kelas bug **tanpa menjalankan kode**. Itu bukti termurah: berjalan dalam hitungan detik, di setiap perubahan, tanpa data uji.
- **Anatomi `analysis_options.yaml`.** `include` memuat paket aturan dasar; `analyzer: language:` menyalakan mode strict; `analyzer: errors:` mengubah tingkat keparahan suatu aturan; `analyzer: exclude:` mengecualikan berkas buatan; `linter: rules:` menyalakan lint tambahan. `dart analyze --fatal-infos` (dan `--fatal-warnings`) membuat temuan tingkat info atau peringatan menggagalkan perintah, sehingga CI benar-benar menolak.
- **Mode strict menutup `dynamic` yang diam-diam.** `strict-casts` melarang cast implisit dari `dynamic`; `strict-inference` melarang inferensi yang jatuh ke `dynamic` tanpa diketahui; `strict-raw-types` melarang tipe generik mentah (misalnya `List` tanpa argumen tipe). Hasilnya: tipe benar-benar menjadi bukti.
- **Mengurasi lint.** Mulai dari `package:lints/recommended.yaml` (bawaan `dart create`). Tambahkan lint **per kelas bug** yang ingin ditolak, bukan semuanya sekaligus. Terlalu sedikit: bug yang bisa ditolak otomatis lolos. Terlalu banyak tanpa kurasi: noise dan `// ignore:` menumpuk. Perlakukan setiap `ignore` sebagai utang yang tercatat dan berisi alasan.
- **`dart fix`.** Menerapkan perbaikan otomatis dari analyzer dan lint; selalu `--dry-run` dulu, baca diff, baru `--apply`.
- **Design by contract.** Fungsi dirancang dengan janji eksplisit: *prakondisi* (yang wajib benar dari pemanggil), *pascakondisi* (yang dijamin fungsi), *invarian* (yang selalu benar untuk objek). Aturan penempatan: validasi masukan dari luar batas memakai `throw` karena harus hidup di build rilis; invarian dan pascakondisi internal memakai `assert` karena hanya untuk menangkap bug programmer saat pengembangan.
- **`assert` hanya aktif bila diaktifkan.** Pada VM mandiri ia aktif dengan `--enable-asserts`; di build rilis ia tidak ada. `dart test` menjalankan tes dengan assert aktif, jadi di tes `assert` menjadi oracle tambahan, tetapi di produksi ia tak melindungi apa pun. Konsekuensi: **jangan** menaruh validasi masukan atau efek samping di dalam `assert`.
- **Jenis galat membawa makna.** `ArgumentError` (argumen salah), `StateError` (keadaan objek tak sesuai operasi), `RangeError` (indeks atau nilai di luar rentang), `UnsupportedError`. `Error` menandai bug programmer; `Exception` menandai kondisi yang dapat dipulihkan (Fase 5).
- **Pindahkan kontrak dari runtime ke compile time.** Tipe non-nullable, konstruktor privat, tipe sealed, dan *extension type* membuat keadaan tak valid tak dapat dibuat. Kontrak yang ditegakkan kompilator lebih kuat daripada `throw`.
- **Anotasi `package:meta`** (`@immutable`, `@useResult`, `@visibleForTesting`, `@mustCallSuper`, `@internal`, `@protected`, `@sealed`, `@nonVirtual`) membuat analyzer menegakkan niat desain. Ia hanya aturan analisis, bukan pemeriksaan saat runtime.
- **Cakupan mengukur apa yang dijalankan, bukan yang diverifikasi.** Ada tiga jenis: baris, fungsi, dan cabang. Tes tanpa `expect` tetap menaikkan cakupan. Maka cakupan berguna sebagai *detektor celah* (kode yang tak pernah disentuh tes), bukan sebagai target. Cakupan cabang lebih jujur daripada baris, tetapi hanya tersedia bila diaktifkan (`--branch-coverage`).
- **Mutation testing menguji tes itu sendiri.** Kode diubah sedikit (mutan), lalu tes dijalankan; mutan yang menyebabkan tes gagal “terbunuh”, yang tidak adalah “selamat”. Selamat berarti ada perilaku yang tak dijaga tes, atau mutan itu *setara* (perilakunya identik, tak mungkin dibedakan). Operator umum: `<` menjadi `<=`, `+` menjadi `-`, `&&` menjadi `||`, hapus pemanggilan, ubah konstanta, negasi kondisi.
- **Mutasi itu mahal; tempatkan dengan cerdas.** Jalankan manual pada logika inti, otomatis hanya pada berkas yang berubah, atau terjadwal (malam), bukan di setiap commit.
- **CI sebagai urutan dari murah ke mahal.** Format, lalu analisis, lalu tes, lalu cakupan, lalu mutasi berkala. Gagal cepat. Perintah lokal dan CI harus sama persis (satu perintah), supaya “di mesin saya lulus” berarti “di CI lulus”.
- **Dampak desain.** `assert` untuk validasi input: hilang di rilis, input jahat lolos. Lint terlalu sedikit atau terlalu banyak: bug lolos atau noise. Mengejar angka cakupan: tes tanpa asersi. `dynamic`, `!`, dan cast eksplisit berserakan: bukti statis hilang, jadi tiap pemakaian harus bisa dijustifikasi. Tanpa CI: semua bukti bergantung pada disiplin manual.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — `analysis_options.yaml` yang ketat dan terkurasi.** Tambahkan paket aturan dasar: `dart pub add --dev lints`.

```yaml
include: package:lints/recommended.yaml

analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
  errors:
    unawaited_futures: error   # naikkan lint penting menjadi error
    todo: ignore               # komentar TODO bukan temuan
  exclude:
    - build/**
    - '**/*.g.dart'

linter:
  rules:
    - unawaited_futures
    - discarded_futures
    - only_throw_errors
    - avoid_dynamic_calls
    - avoid_catches_without_on_clauses
    - cancel_subscriptions
    - close_sinks
    - prefer_final_locals
    - prefer_const_constructors
    - unnecessary_await_in_return
    # - public_member_api_docs   # nyalakan untuk pustaka publik
```

```bash
dart analyze                    # tampilkan semua temuan
dart analyze --fatal-infos      # temuan tingkat info pun membuat perintah gagal (untuk CI)
dart fix --dry-run              # lihat perbaikan otomatis yang tersedia, belum mengubah apa pun
dart fix --apply                # terapkan perbaikan otomatis
dart format --set-exit-if-changed .   # gagal bila ada berkas yang belum terformat
```

- `include: package:lints/recommended.yaml` — mewarisi aturan dasar yang dikurasi tim Dart (`dart create` memakainya secara bawaan); paket `core.yaml` adalah versi minimal.
- `analyzer: language: strict-casts / strict-inference / strict-raw-types` — tiga mode yang menutup celah `dynamic`: cast implisit dari `dynamic`, inferensi yang jatuh ke `dynamic`, dan tipe generik mentah.
- `analyzer: errors: unawaited_futures: error` — mengubah tingkat keparahan lint tertentu; `todo: ignore` menonaktifkan temuan untuk komentar TODO.
- `analyzer: exclude:` — pola berkas yang tak dianalisis (hasil build dan kode yang dibangkitkan).
- `linter: rules:` — daftar lint tambahan yang dinyalakan; setiap baris adalah keputusan sadar menolak satu kelas bug (tabel di bawah).
- `dart analyze --fatal-infos` — di CI temuan info pun menggagalkan; tanpa ini, info menumpuk tanpa ada yang membaca.
- `dart fix --dry-run` dahulu, lalu `--apply`: perubahan otomatis tetap harus kamu baca diff-nya.

| Lint | Kelas bug yang ditolak | Perbaikan |
| --- | --- | --- |
| `unawaited_futures` | `Future` terlupa: galat tertelan, urutan salah (7.2) | `await`, atau `unawaited(...)` dengan alasan |
| `discarded_futures` | Fungsi sinkron memanggil fungsi `async` lalu membuang `Future`-nya | Jadikan pemanggil `async`, atau `unawaited` dengan alasan |
| `only_throw_errors` | `throw 'teks'`: tak bisa ditangkap per tipe, tanpa jejak | Lempar `Error` atau `Exception` |
| `avoid_dynamic_calls` | Pemanggilan pada `dynamic` menyembunyikan kesalahan tipe sampai runtime | Beri tipe, atau parse dengan pola |
| `avoid_catches_without_on_clauses` | `catch (e)` menelan semuanya | `on TipeSpesifik catch (e)` |
| `cancel_subscriptions`, `close_sinks` | Kebocoran langganan dan sink (7.9) | Batalkan dan tutup |
| `prefer_final_locals` | Variabel lokal berubah tanpa disengaja | `final` |
| `prefer_const_constructors` | Alokasi berulang objek yang tak berubah | `const` |

**Contoh 2 — satu fungsi, lima temuan, lalu perbaikannya.**

```dart
import 'dart:convert';

// SEBELUM
Future<int> panjangJudul(Penyimpan p, String isi) async {
  p.tulis(isi); // unawaited_futures
  try {
    final data = jsonDecode(isi);
    return data['judul'].length; // avoid_dynamic_calls; strict-casts: dynamic ke int
  } catch (e) { // avoid_catches_without_on_clauses
    throw 'gagal: $e'; // only_throw_errors
  }
}
```

```dart
import 'dart:convert';

// SESUDAH
Future<int> panjangJudul(Penyimpan p, String isi) async {
  await p.tulis(isi);

  final Object? data;
  try {
    data = jsonDecode(isi);
  } on FormatException catch (e) {
    throw StateError('gagal membaca: ${e.message}');
  }

  if (data case {'judul': final String judul}) return judul.length;
  throw StateError('bentuk data tidak dikenali');
}
```

- `p.tulis(isi);` tanpa `await` — `Future` dibuang; galat penulisan tak pernah terlihat. Perbaikan: `await`.
- `data['judul'].length` pada `dynamic` — kompilator tak bisa memeriksa apa pun; salah ketik atau tipe berbeda baru meledak saat runtime. Perbaikan: pola `if (data case {'judul': final String judul})` memeriksa bentuk *dan* tipe sekaligus.
- `catch (e)` tanpa `on` — menelan semua galat, termasuk bug. Perbaikan: hanya tangkap `FormatException` dari `jsonDecode`.
- `throw 'gagal: $e'` — melempar `String`; tak ada jejak, tak bisa ditangkap per tipe. Perbaikan: lempar `StateError` (atau galat domain).
- `final Object? data;` yang diisi di dalam `try` dan `catch`-nya selalu melempar — analisis aliran menjamin `data` terisi sebelum dipakai.

**Contoh 3 — kontrak: prakondisi, pascakondisi, invarian.**

```dart
import 'dart:collection';

import 'package:meta/meta.dart';

/// Antrean FIFO berkapasitas tetap.
///
/// Kontrak:
/// - prakondisi konstruktor: kapasitas > 0 (ArgumentError)
/// - prakondisi masuk: antrean tidak penuh (StateError)
/// - prakondisi keluar: antrean tidak kosong (StateError)
/// - pascakondisi: masuk menambah panjang 1; keluar mengurangi 1
/// - invarian: 0 <= panjang <= kapasitas
class AntreanTerbatas<T> {
  AntreanTerbatas(this.kapasitas) {
    if (kapasitas <= 0) {
      // validasi masukan: HARUS tetap ada di build rilis, jadi throw, bukan assert
      throw ArgumentError.value(kapasitas, 'kapasitas', 'harus > 0');
    }
  }

  final int kapasitas;
  final _isi = ListQueue<T>();

  int get panjang => _isi.length;
  bool get kosong => _isi.isEmpty;
  bool get penuh => _isi.length >= kapasitas;
  bool get _invarianTerjaga => panjang >= 0 && panjang <= kapasitas;

  void masuk(T x) {
    if (penuh) throw StateError('antrean penuh');
    final sebelum = panjang;
    _isi.addLast(x);
    assert(panjang == sebelum + 1, 'pascakondisi masuk rusak');
    assert(_invarianTerjaga, 'invarian rusak setelah masuk');
  }

  @useResult
  T keluar() {
    if (kosong) throw StateError('antrean kosong');
    final sebelum = panjang;
    final x = _isi.removeFirst();
    assert(panjang == sebelum - 1, 'pascakondisi keluar rusak');
    assert(_invarianTerjaga, 'invarian rusak setelah keluar');
    return x;
  }
}
```

```dart
import 'package:test/test.dart';

void main() {
  test('assert aktif di tes (kenari)', () {
    var aktif = false;
    // Satu-satunya tempat efek samping dalam assert diizinkan: mendeteksi assert itu sendiri.
    assert(() {
      aktif = true;
      return true;
    }());
    expect(aktif, isTrue, reason: 'jalankan dengan dart test: assert aktif secara bawaan');
  });
}
```

- `ArgumentError.value(kapasitas, 'kapasitas', 'harus > 0')` — galat standar untuk argumen yang salah, membawa nilai, nama, dan alasan. Ini *prakondisi dari pemanggil*: pemanggil yang salah, bukan bug di dalam kelas.
- `StateError` pada `masuk` dan `keluar` — prakondisi keadaan: operasi tak valid pada keadaan saat ini. Keduanya `throw`, sehingga tetap berlaku di produksi.
- `assert(panjang == sebelum + 1, ...)` — pascakondisi: jaminan yang diberikan method; bila kelasnya salah ditulis, tes (assert aktif) langsung memergokinya.
- `assert(_invarianTerjaga, ...)` — invarian objek diperiksa setiap kali keadaan berubah; getter privat menamai invarian sehingga terbaca sebagai spesifikasi.
- `@useResult` pada `keluar` — analyzer memperingatkan bila nilai kembaliannya dibuang (`antrean.keluar();` tanpa memakai hasil adalah bug: elemen hilang).
- Tes kenari memastikan assert benar-benar aktif di lingkunganmu: tanpa itu, asersi kontrak bisa diam-diam tak berjalan (misalnya bila tes dijalankan lewat perintah yang mematikan assert). Pola `assert(() { ...; return true; }())` adalah idiom baku mendeteksi assert; efek samping di dalam `assert` selain ini dilarang.

**Contoh 4 — anotasi `package:meta`: niat desain yang ditegakkan analyzer.** `dart pub add meta`.

```dart
import 'package:meta/meta.dart';

@immutable
final class Uang {
  const Uang(this.sen);
  final int sen;

  /// Hasil WAJIB dipakai: `a.tambah(b);` tanpa memakai hasil adalah bug.
  @useResult
  Uang tambah(Uang lain) => Uang(sen + lain.sen);
}

abstract class Pekerja {
  @mustCallSuper
  void mulai() {
    // inisialisasi dasar yang wajib dijalankan semua subkelas
  }
}

class PekerjaCepat extends Pekerja {
  @override
  void mulai() {
    super.mulai(); // tanpa baris ini analyzer memperingatkan
    // ... inisialisasi khusus
  }
}

@visibleForTesting
int hitungInternal(List<int> xs) => xs.length; // dipakai tes; analyzer menandai pemakaian dari kode lain
```

- `@immutable` — analyzer memeriksa bahwa semua field kelas dan turunannya `final`; ketidakberubahan (3.2) ditegakkan, bukan sekadar niat.
- `@useResult` — menandai bahwa membuang hasil adalah kesalahan; cocok untuk fungsi murni dan operasi yang mengembalikan nilai penting.
- `@mustCallSuper` — subkelas yang meng-override tapi lupa `super.mulai()` mendapat peringatan.
- `@visibleForTesting` — membuka sesuatu untuk tes tanpa menjadikannya API publik; pemakaian dari kode produksi lain ditandai.
- Lainnya: `@internal` (hanya untuk dalam paket), `@protected` (hanya subkelas), `@sealed` dan `@nonVirtual` (cegah override), `@factory`, `@literal`. Semuanya aturan analisis; tak ada pemeriksaan saat runtime.

**Contoh 5 — tipe sebagai bukti: pindahkan kontrak ke compile time.**

```dart
extension type const Kapasitas._(int nilai) {
  factory Kapasitas(int nilai) {
    if (nilai <= 0) {
      throw ArgumentError.value(nilai, 'kapasitas', 'harus > 0');
    }
    return Kapasitas._(nilai);
  }
}

class AntreanTerbatas<T> {
  AntreanTerbatas(Kapasitas kapasitas) : kapasitas = kapasitas.nilai;
  final int kapasitas;
  // ... sisanya sama; prakondisi kapasitas > 0 tak perlu diperiksa lagi di sini
}

// Pemakaian:
final antrean = AntreanTerbatas<int>(Kapasitas(2));
```

- `extension type const Kapasitas._(int nilai)` — tipe baru di atas `int` tanpa biaya runtime; konstruktor utamanya privat (`_`) sehingga tak ada kode di luar berkas ini yang bisa membuat `Kapasitas` tanpa lewat pemeriksaan.
- `factory Kapasitas(int nilai)` — satu-satunya pintu publik: memeriksa dan menolak nilai tak valid. Setelah objek `Kapasitas` ada, ia *pasti* valid.
- `AntreanTerbatas(Kapasitas kapasitas)` — konstruktor tak lagi perlu memeriksa; tanda tangannya sendiri menyatakan prakondisi. Ini prinsip “parse, jangan validasi” (3.5) yang diterapkan pada kontrak.
- Pertukarannya: pemanggil kini harus membuat `Kapasitas`; sebagai gantinya kesalahan terdeteksi di titik pembuatan, dekat sumbernya, dan tak mungkin ada `AntreanTerbatas` dengan kapasitas tak valid.

**Contoh 6 — cakupan: tiga jalur perintah, cabang yang benar-benar terukur, dan gerbang ambang.**

```bash
# Jalur A (paling ringkas): LCOV langsung dari runner tes
dart test --coverage-path=coverage/lcov.info

# Jalur B: skrip resmi package:coverage; satu-satunya jalur di sini yang menyalakan CABANG dan FUNGSI
dart pub global activate coverage
dart pub global run coverage:test_with_coverage --branch-coverage --function-coverage

# Jalur C: dua langkah (alur di kurikulum) -- hanya cakupan BARIS
dart test --coverage=coverage
dart pub global run coverage:format_coverage \
  --packages=.dart_tool/package_config.json --report-on=lib --lcov \
  -i coverage -o coverage/lcov.info

# Laporan HTML (paket lcov; di Arch: sudo pacman -S lcov)
genhtml coverage/lcov.info -o coverage/html
```

```dart
// tool/cek_cakupan.dart
import 'dart:io';

/// Memeriksa ambang cakupan dari berkas LCOV.
/// Pemakaian: dart run tool/cek_cakupan.dart [lcov.info] [ambangBaris] [ambangCabang]
void main(List<String> args) {
  final berkas = args.isNotEmpty ? args[0] : 'coverage/lcov.info';
  final ambangBaris = args.length > 1 ? double.parse(args[1]) : 90.0;
  final ambangCabang = args.length > 2 ? double.parse(args[2]) : 90.0;

  var lf = 0, lh = 0, brf = 0, brh = 0;
  for (final teks in File(berkas).readAsLinesSync()) {
    if (teks.startsWith('LF:')) lf += int.parse(teks.substring(3));
    if (teks.startsWith('LH:')) lh += int.parse(teks.substring(3));
    if (teks.startsWith('BRF:')) brf += int.parse(teks.substring(4));
    if (teks.startsWith('BRH:')) brh += int.parse(teks.substring(4));
  }

  double persen(int kena, int total) => total == 0 ? 0 : kena * 100 / total;
  final pBaris = persen(lh, lf);
  final pCabang = persen(brh, brf);
  stdout
    ..writeln('baris : ${pBaris.toStringAsFixed(1)}%  ($lh/$lf)')
    ..writeln('cabang: ${pCabang.toStringAsFixed(1)}%  ($brh/$brf)');

  if (brf == 0) {
    stderr.writeln('tak ada data cabang: jalankan dengan --branch-coverage (Jalur B)');
    exit(2);
  }
  if (pBaris < ambangBaris || pCabang < ambangCabang) {
    stderr.writeln('di bawah ambang (baris $ambangBaris%, cabang $ambangCabang%)');
    exit(1);
  }
}
```

```dart
// Mengecualikan kode yang memang tak layak diukur (pakai --check-ignore pada format_coverage)
void cetakBantuan() { // coverage:ignore-line
  print('...');
}

// coverage:ignore-start
void cabangPlatformLain() {
  // ...
}
// coverage:ignore-end
```

- Jalur A memanfaatkan runner tes untuk menulis LCOV langsung; cukup untuk cakupan baris. Verifikasi bahwa SDK-mu mendukungnya dengan `dart test --help`.
- Jalur B memakai `test_with_coverage`, yang menjalankan tes dan menghasilkan `coverage/coverage.json` dan `coverage/lcov.info`; `--branch-coverage` dan `--function-coverage` menambah data cabang dan fungsi (cabang butuh Dart VM ≥ 2.17).
- Jalur C adalah alur kurikulum: `--coverage=coverage` menulis data mentah per berkas tes, lalu `format_coverage` mengubahnya menjadi LCOV; `--report-on=lib` membatasi laporan pada `lib/`.
- Format LCOV: `SF:` nama berkas, `DA:baris,jumlahEksekusi`, `LF`/`LH` baris ditemukan/terkena, `BRDA:` data cabang, `BRF`/`BRH` cabang ditemukan/terkena, `FNF`/`FNH` fungsi ditemukan/terkena, `end_of_record` penutup rekaman.
- Skrip `cek_cakupan.dart` menjumlahkan semua rekaman dan menghitung persen; **kode keluar 2** bila data cabang tak ada (sehingga Latihan “cabang ≥ 90%” tak bisa lulus secara diam-diam hanya karena angkanya nol atau tak terukur), **kode keluar 1** bila di bawah ambang.
- `double persen(int kena, int total) => total == 0 ? 0 : ...` — fungsi lokal yang menghindari pembagian dengan nol.
- Komentar `coverage:ignore-line`, `ignore-start`, `ignore-end`, dan `ignore-file` hanya dihormati bila `format_coverage` dijalankan dengan `--check-ignore`; pakai hemat dan selalu dengan alasan, karena mengabaikan baris berarti menyembunyikan celah.

**Contoh 7 — mutation testing: protokol manual, lalu alat otomatis.** Protokol manual pada `AntreanTerbatas` (Contoh 3):

| # | Mutan (satu perubahan kecil) | Prediksi: harus ditangkap oleh | Hasil (isi sendiri) |
| --- | --- | --- | --- |
| 1 | `penuh`: `>=` menjadi `>` | Tes “masuk saat penuh melempar StateError” |  |
| 2 | Konstruktor: `kapasitas <= 0` menjadi `kapasitas < 0` | Tes “kapasitas tak valid ditolak” |  |
| 3 | `keluar`: `removeFirst()` menjadi `removeLast()` | Tes FIFO dan tes berbasis model |  |
| 4 | Hapus baris `if (penuh) throw StateError(...)` di `masuk` | Tes “masuk saat penuh” dan model |  |
| 5 | `masuk`: tambah `_isi.addLast(x)` kedua kali | `assert` pascakondisi dan model |  |
| 6 | `kosong`: `_isi.isEmpty` menjadi `_isi.length == 0` | **Tak ada** (mutan setara) |  |
| 7 | Ganti teks pesan `'antrean penuh'` menjadi `'penuh'` | **Tak ada** bila pesan bukan bagian kontrak |  |

```bash
# Alat otomatis 1: mutation_test (aturan berbasis regex/XML; laporan HTML atau markdown)
dart pub add --dev mutation_test
dart run mutation_test                                   # mutasi lib/*.dart; uji dengan `dart test`
dart pub global run coverage:test_with_coverage          # data cakupan untuk mempercepat
dart run mutation_test --coverage coverage/lcov.info     # hanya mutasi baris yang tercakup tes
dart run mutation_test $(git diff --name-only HEAD~1 | grep '^lib/.*\.dart$')   # inkremental: hanya berkas yang berubah
dart run mutation_test --help                            # semua opsi (format laporan -f, keluaran -o, dll.)

# Alat otomatis 2: dart_mutant (mutan dari pohon sintaks; yang tak bisa dikompilasi dibuang sebelum tes)
dart pub global activate dart_mutant
dart_mutant --help
```

- Cara membaca tabel: untuk tiap mutan, terapkan perubahannya, jalankan `dart test`, lalu isi kolom hasil dengan *terbunuh* (ada tes gagal; sebutkan yang mana) atau *selamat*. Kembalikan kodenya sebelum mutan berikutnya.
- Mutan #6 **setara**: `isEmpty` dan `length == 0` selalu memberi hasil sama untuk `ListQueue`; tak ada tes yang mungkin membedakannya. Mutan setara dicatat dan *dikecualikan* dari hitungan skor, bukan “diperbaiki” dengan tes yang dipaksakan.
- Mutan #7 selamat secara sah bila pesan galat bukan janji kontrak; bila pesan memang bagian kontrak (misalnya ditampilkan ke pengguna), tambahkan tes yang memeriksanya.
- **Skor mutasi** = mutan terbunuh dibagi (total dikurangi setara). Mutan selamat yang bukan setara adalah daftar kerja: tiap satunya menunjuk perilaku yang tak dijaga tes.
- `--coverage coverage/lcov.info` mempercepat `mutation_test` dengan hanya mengubah baris yang memang dijalankan tes; baris yang tak tercakup pasti menghasilkan mutan selamat sehingga tak perlu diuji. Menjalankan mutasi pada seluruh kode dapat memakan waktu berjam-jam; karena itu jalur inkremental dan terjadwal.

**Contoh 8 — CI: satu perintah lokal yang sama dengan CI.**

```make
# justfile  (sudo pacman -S just)
default: cek

format:
    dart format --set-exit-if-changed .

analisis:
    dart analyze --fatal-infos

uji:
    dart test --test-randomize-ordering-seed=random

cakupan:
    dart pub global run coverage:test_with_coverage --branch-coverage
    dart run tool/cek_cakupan.dart coverage/lcov.info 90 90

cek: format analisis uji cakupan
```

```yaml
# .github/workflows/ci.yml
name: ci
on: [push, pull_request]

jobs:
  verifikasi:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4          # pakai versi mayor terbaru yang tersedia
      - uses: dart-lang/setup-dart@v1
        with:
          sdk: stable
      - run: dart pub get
      - run: dart format --output=none --set-exit-if-changed .
      - run: dart analyze --fatal-infos
      - run: dart test --reporter=github --test-randomize-ordering-seed=random
      - run: dart pub global activate coverage
      - run: dart pub global run coverage:test_with_coverage --branch-coverage
      - run: dart run tool/cek_cakupan.dart coverage/lcov.info 90 90
```

```yaml
# .github/workflows/mutasi.yml  (terjadwal, bukan di setiap commit)
name: mutasi
on:
  schedule:
    - cron: '0 2 * * *'
  workflow_dispatch:

jobs:
  mutasi:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dart-lang/setup-dart@v1
      - run: dart pub get
      - run: dart run mutation_test
```

```bash
#!/bin/sh
# .git/hooks/pre-push  (chmod +x): hentikan push bila bukti dasar gagal
exec just cek
```

- `justfile`: setiap resep adalah satu langkah bukti; `cek` menjalankan semuanya berurutan dari yang murah ke mahal (`format` lalu `analisis` lalu `uji` lalu `cakupan`) dan berhenti di kegagalan pertama. Baris di bawah nama resep harus diberi indentasi.
- `dart format --set-exit-if-changed .` (lokal) dan `--output=none --set-exit-if-changed` (CI) — gagal bila ada berkas belum terformat tanpa mengubahnya; keduanya bentuk yang sama untuk dua konteks.
- `dart-lang/setup-dart@v1` — action resmi yang memasang Dart SDK di runner; `sdk: stable` memilih rilis stabil. Untuk keterulangan, kunci versi tertentu bila build harus identik.
- `--reporter=github` — format keluaran tes yang dirender GitHub Actions sebagai anotasi pada baris kegagalan.
- `--test-randomize-ordering-seed=random` di CI — urutan acak setiap run; seed dicetak sehingga kegagalan yang bergantung urutan dapat diulang lokal.
- Workflow `mutasi` terjadwal (`cron`) dan dapat dipicu manual (`workflow_dispatch`); mutasi tak dijalankan di setiap commit karena mahal.
- `pre-push` memastikan hal yang sama yang akan dijalankan CI sudah lulus sebelum kode meninggalkan mesinmu. Hook lokal bisa dilewati; CI tetap penjaga yang tak bisa dilewati.

### D. Opsi Kode Lain untuk Logika yang Sama

| Keputusan | Pilihan | Kapan cocok | Catatan |
| --- | --- | --- | --- |
| Paket aturan lint | `lints/core.yaml` | Proyek yang baru mulai menerapkan lint | Minimal; tambahkan bertahap |
| Paket aturan lint | `lints/recommended.yaml` | Titik awal yang wajar | Bawaan `dart create` |
| Paket aturan lint | `flutter_lints` | Proyek Flutter | Menambah aturan khusus Flutter |
| Paket aturan lint | Paket pihak ketiga yang ketat (misalnya `very_good_analysis`) | Tim yang menginginkan standar sangat ketat | Periksa pemeliharaan dan sesuaikan; hati-hati noise |
| Menjaga kontrak | `throw` | Masukan dari luar batas | Hidup di rilis |
| Menjaga kontrak | `assert` | Pascakondisi dan invarian internal | Hanya pengembangan dan tes; tanpa efek samping |
| Menjaga kontrak | Tipe (extension type, sealed, konstruktor privat) | Keadaan tak valid yang bisa dibuat mustahil | Terkuat; ditegakkan kompilator |
| Menjalankan pemeriksaan | `justfile` | CLI-sentris, banyak resep | Satu biner kecil; mudah dibaca |
| Menjalankan pemeriksaan | Skrip shell (`tool/cek.sh`) | Tanpa dependensi tambahan | Cukup untuk proyek kecil |
| Menjalankan pemeriksaan | Langsung di CI saja | Tidak disarankan | Pengembang tak bisa mengulang secara lokal |

Alternatif tanpa `just`: satu skrip shell yang sama persis dengan CI.

```bash
#!/usr/bin/env bash
# tool/cek.sh
set -euo pipefail

dart format --set-exit-if-changed .
dart analyze --fatal-infos
dart test --test-randomize-ordering-seed=random
dart pub global run coverage:test_with_coverage --branch-coverage
dart run tool/cek_cakupan.dart coverage/lcov.info 90 90
```

- `set -euo pipefail` — berhenti pada perintah pertama yang gagal (`-e`), melarang variabel tak terdefinisi (`-u`), dan menganggap kegagalan di tengah pipa sebagai kegagalan (`pipefail`); tanpa ini skrip bisa lanjut setelah langkah yang gagal dan memberi rasa aman palsu.
- Pilih `justfile` bila kamu memakai banyak resep dan ingin `just --list`; pilih skrip bila ingin nol dependensi. Yang tak boleh dilakukan: membiarkan perintah CI dan lokal berbeda.

### E. Terminologi Esensial

- **Analisis statis** — pemeriksaan kode tanpa menjalankannya (`dart analyze`). **Lint** — aturan opsional yang menandai pola rawan bug atau gaya buruk. **Mode strict** — pengaturan analyzer yang menutup celah `dynamic`.
- **`dart fix`** — penerap perbaikan otomatis dari analyzer. **Tingkat keparahan** — error, warning, atau info; `--fatal-infos` menjadikan info menggagalkan perintah.
- **Design by contract** — merancang dengan janji eksplisit. **Prakondisi** — yang wajib benar dari pemanggil. **Pascakondisi** — yang dijamin fungsi setelah selesai. **Invarian** — yang selalu benar bagi objek.
- **`assert`** — pemeriksaan yang hanya berjalan bila diaktifkan dan tak ada di build rilis. **Extension type** — tipe tanpa biaya runtime di atas tipe lain, dipakai untuk mengunci keadaan valid.
- **Anotasi `meta`** — penanda (`@immutable`, `@useResult`, dan lain-lain) yang ditegakkan analyzer.
- **Cakupan baris, fungsi, cabang** — proporsi baris, fungsi, atau cabang keputusan yang dieksekusi tes. **LCOV** — format teks standar data cakupan.
- **Mutan** — salinan kode dengan satu perubahan kecil. **Terbunuh/selamat** — tes mendeteksi perubahan itu atau tidak. **Mutan setara** — mutan yang perilakunya identik, mustahil dibedakan tes. **Skor mutasi** — terbunuh dibagi (total dikurangi setara).
- **CI (continuous integration)** — otomatisasi yang menjalankan pemeriksaan di setiap perubahan. **Gerbang kualitas (quality gate)** — ambang yang jika tak terpenuhi menggagalkan build. **Git hook** — skrip lokal yang dijalankan git pada peristiwa tertentu (misalnya sebelum push).

### F. Visualisasi (ASCII)

```text
   commit ─► format ─► analyze (strict + lint) ─► test ─► coverage ─► (mutasi berkala)
               │                │                  │
            gagal?           gagal?              gagal?   ─► perbaiki sebelum lanjut
   Bukti makin kuat ke kanan; biaya tiap pemeriksaan juga makin mahal ke kanan.
```

```text
   tipe ─► null safety ─► peringatan analyzer ─► lint ─► mode strict
    │          │                 │                │          │
    └──────────┴─────────────────┴────────────────┴──────────┘
        tiap anak tangga menolak satu kelas bug TANPA menjalankan kode
```

```text
   Apa yang saya jaga?
     ├── masukan dari LUAR batas (pengguna, berkas, jaringan) ─► THROW atau parse ke tipe (hidup di rilis)
     ├── janji ANTAR-bagian internal (pascakondisi, invarian) ─► ASSERT (pengembangan dan tes saja)
     └── keadaan yang bisa dibuat TAK MUNGKIN ──────────────────► TIPE (extension type, sealed, ctor privat)
```

```text
   kode ─► ubah SATU hal ─► dart test ─┬─ ada yang gagal ... mutan TERBUNUH (tes baik)
                                       └─ semua lulus ..... mutan SELAMAT
                                                              ├─ setara? ya ─► catat, kecualikan dari skor
                                                              └─ tidak ──────► tambah tes ─► ulangi
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 8.1 (tes yang dinilai oleh mutasi dan cakupan), Fase 5 (jenis galat dan kapan melempar), Fase 3 (tipe sebagai bukti, parse di tepi), 7.2 dan 7.9 (lint `unawaited_futures`, `cancel_subscriptions`, `close_sinks`).
- **Prasyarat bagi:** 8.3 (tes batas sistem ikut dalam cakupan dan gerbang CI) dan 8.4 (To-Do v7 merangkai semuanya).
- **Dikembangkan di:** Fase Keamanan (analisis statis sebagai tembok pertama; `avoid_dynamic_calls` untuk masukan tak tepercaya) dan Fase arsitektur (`@internal` dan `@visibleForTesting` sebagai penjaga batas paket).

### H. Tips & Praktik Terbaik

- Nyalakan mode strict sejak awal proyek; menambahkannya belakangan menghasilkan ratusan temuan sekaligus.
- Tambahkan lint satu per satu, tiap kali setelah memahami kelas bug yang ditolaknya; hapus dari daftar bila terbukti hanya noise.
- Setiap `// ignore:` harus ditulis dengan alasan dan, bila bersifat sementara, dengan penanda untuk dihapus. Hitung jumlah `ignore` secara berkala sebagai indikator utang.
- Pakai `throw` untuk masukan dari luar dan `assert` untuk janji internal; jangan pernah menaruh efek samping atau validasi masukan di dalam `assert`.
- Utamakan tipe: bila suatu keadaan tak valid bisa dibuat mustahil lewat tipe, itu lebih baik daripada memeriksanya di runtime.
- Perlakukan cakupan sebagai peta lubang, bukan nilai. Bacalah daftar baris dan cabang yang tak tersentuh, lalu tanya mengapa tak ada tes yang mencapainya.
- Wajibkan data cabang pada gerbang CI (kode keluar khusus bila tak ada), agar ambang tak lulus secara kebetulan.
- Jalankan mutasi pada logika inti dan pada berkas yang berubah; catat mutan setara agar tak dihitung ulang.
- Jaga agar `just cek` (atau `tool/cek.sh`) cukup cepat untuk dijalankan sebelum setiap push; bila terlalu lambat, pecah menjadi jalur cepat dan jalur penuh.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| `assert` untuk validasi masukan | Hilang di rilis; masukan jahat lolos | `throw` untuk masukan; `assert` hanya untuk invarian internal |
| Efek samping di dalam `assert` | Perilaku berbeda antara tes dan produksi | Jaga `assert` bebas efek samping (kecuali tes kenari) |
| Menyalakan semua lint tanpa kurasi | Noise; `ignore` menumpuk | Tambahkan per kelas bug; tinjau berkala |
| `// ignore:` tanpa alasan | Utang tak terlihat | Selalu beri alasan; hitung secara berkala |
| Cakupan cabang diminta tanpa `--branch-coverage` | Angka nol atau tak ada | Jalur B dan gerbang yang gagal bila data cabang tak ada |
| Mengejar angka cakupan | Tes tanpa asersi | Nilai tes dengan mutasi |
| Menghitung mutan setara sebagai “selamat” | Skor menyesatkan dan tes dipaksakan | Catat dan kecualikan mutan setara |
| Menjalankan mutasi di setiap commit | CI sangat lambat | Inkremental pada berkas berubah, atau terjadwal |
| Perintah CI berbeda dari lokal | “Di mesin saya lulus” | Satu perintah (`just cek`) dipakai di keduanya |
| `dynamic`, `!`, cast eksplisit berserakan | Bukti statis hilang | Justifikasi tiap pemakaian; ganti dengan pola dan tipe |
| Mengaktifkan `dart fix --apply` tanpa membaca diff | Perubahan tak dimengerti ikut masuk | `--dry-run` dahulu, tinjau diff |

### J. Sumber Referensi

- Analisis statis: https://dart.dev/tools/analysis · Aturan lint: https://dart.dev/tools/linter-rules · https://dart.dev/tools/linter-rules/unawaited\_futures · https://dart.dev/tools/linter-rules/discarded\_futures · https://dart.dev/tools/linter-rules/only\_throw\_errors · https://dart.dev/tools/linter-rules/avoid\_dynamic\_calls · https://dart.dev/tools/linter-rules/avoid\_catches\_without\_on\_clauses
- Perintah: https://dart.dev/tools/dart-analyze · https://dart.dev/tools/dart-fix · https://dart.dev/tools/dart-format · https://dart.dev/tools/dart-test
- Paket: https://pub.dev/packages/lints · https://pub.dev/packages/meta · Extension types: https://dart.dev/language/extension-types · `assert` di Dart: https://dart.dev/language/error-handling#assert
- ✔ Cakupan: https://pub.dev/documentation/coverage/ · https://pub.dev/packages/coverage · ✔ `--coverage-path` dan `--coverage` pada `package:test`: https://pub.dev/documentation/test · ✔ LCOV: https://github.com/linux-test-project/lcov
- ✔ Mutasi: https://pub.dev/packages/mutation\_test · https://pub.dev/documentation/mutation\_test/latest/ · https://pub.dev/packages/dart\_mutant
- CI dan alat: https://github.com/dart-lang/setup-dart · https://github.com/casey/just
- Konsep: https://en.wikipedia.org/wiki/Design\_by\_contract · https://en.wikipedia.org/wiki/Mutation\_testing
- Buku dan makalah: B. Meyer, *Object-Oriented Software Construction* (design by contract); G. Petrović dan M. Ivanković, *State of Mutation Testing at Google* (mutasi di industri).

---

## 8.3 Menguji Batas Sistem: Berkas, Proses, CLI (TAMBAHAN)

*Motivasi: di batas itulah dunia nyata menyentuh kodemu — di sanalah tes paling jujur.*

> **Mengapa ditambahkan.** Modul 8.1 dan 8.2 membahas logika murni, waktu, dan analisis statis. Padahal To-Do v6 berbatasan dengan berkas (`PenyimpanBerkas`) dan terminal (shell dan kode keluar), dan bug yang paling mahal tinggal di batas: izin berkas, penulisan atomik, EOF pada stdin, kode keluar, dan pengodean teks. Kurikulum tidak membahas cara mengujinya; modul ini menutup celah itu.

**Struktur pembelajaran (mini daftar isi):** (1) peta batas: logika murni vs adaptor tipis · (2) tes kontrak: fake dan nyata lulus tes yang sama · (3) direktori sementara yang terisolasi · (4) tes proses dan CLI: stdin, stdout, stderr, kode keluar · (5) tes golden · (6) filesystem dalam memori sebagai opsi · (7) jebakan flaky di batas.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini mengajarkan cara menguji bagian program yang bersentuhan langsung dengan dunia luar: berkas, proses, dan antarmuka baris perintah. Cakupannya: tes kontrak yang menjaga fake tetap jujur, direktori sementara yang terisolasi per tes, tes proses dengan stdin dan kode keluar, tes golden untuk keluaran teks, serta kapan memakai filesystem dalam memori. Perannya: logika murni sudah dibuktikan di 8.1; di sini kita membuktikan bahwa lapisan tipis di tepinya benar-benar sambung dengan sistem sungguhan.

### B. Konsep Kunci & Filosofi Mendalam

- **Peta batas.** Program yang sehat punya inti murni yang besar dan adaptor tipis di tepi (berkas, jaringan, terminal, jam). Inti diuji murah dan deterministik (8.1). Adaptor diuji sedikit tetapi *nyata*, karena justru di sanalah asumsi tentang sistem operasi bisa salah.
- **Tiga lapis uji batas.** (a) *Tes kontrak* terhadap fake: menjamin fake berperilaku sama dengan yang nyata. (b) *Integrasi dengan sumber daya nyata yang terisolasi*, misalnya direktori sementara. (c) *End-to-end pada tingkat proses*, yaitu menjalankan program sungguhan dan memeriksa keluaran dan kode keluarnya.
- **Fake bisa berbohong.** Fake yang menyimpang dari perilaku nyata membuat semua tes yang memakainya lulus palsu. Obatnya adalah **tes kontrak**: satu rangkaian tes ditulis terhadap antarmuka dan dijalankan pada *setiap* implementasi (fake dan nyata). Bila keduanya lulus, fake boleh dipercaya.
- **Isolasi sumber daya.** Setiap tes memakai direktori sementara yang unik dan dibersihkan lewat `addTearDown`. Jangan menulis ke direktori kerja, jangan berbagi berkas antar-tes, dan jangan bergantung pada urutan; itu sumber utama tes *flaky* di batas.
- **Filesystem dalam memori.** `package:file` menyediakan `FileSystem` yang dapat diganti, termasuk versi dalam memori yang cepat dan deterministik. Syaratnya kode menerima `FileSystem` sebagai dependensi. Batasnya: ia tidak meniru semua perilaku OS (izin, symlink, atomisitas `rename`), jadi tetap sisakan beberapa tes dengan berkas nyata.
- **Tes proses adalah tes terakhir dan paling mahal.** Menjalankan program lewat `Process.start` memeriksa hal yang tak terjangkau tes lain: argumen, stdin sampai EOF, stdout dan stderr terpisah, dan **kode keluar sebagai kontrak publik** CLI.
- **Tiga jebakan proses.** (1) *Buffer penuh*: bila stdout atau stderr proses anak tak dibaca, buffer pipa dapat penuh dan anak macet menunggu; konsumsi keduanya. (2) *EOF*: shell yang membaca stdin baru berhenti bila stdin ditutup; tes harus memanggil `stdin.close()`. (3) *Proses yatim*: bila tes gagal atau habis waktu di tengah, proses anak harus dibunuh (`addTearDown`).
- **Biaya kompilasi.** `dart run` per tes mengompilasi ulang setiap kali; kompilasi sekali di `setUpAll` (`dart compile exe`) lalu jalankan biner berkali-kali.
- **Tes golden (approval).** Keluaran teks yang disetujui disimpan di berkas; tes membandingkan keluaran aktual dengannya. Kekuatannya: cocok untuk keluaran panjang (bantuan, laporan). Kelemahannya: mudah menyetujui perubahan tanpa membaca. Aturan: perubahan golden harus tampil sebagai diff yang ditinjau, nilai tak stabil (waktu, jalur absolut, urutan tak terjamin) dinormalkan atau dihindari, dan golden bukan pengganti asersi yang spesifik.
- **Kode keluar adalah janji.** Tabel kode keluar (0, 70, 74, dan seterusnya) di 5.5 dan 7.8 diperlakukan seperti API: tiap baris punya tes.
- **Batas waktu dan lingkungan.** Tes proses wajib punya `timeout`; jalankan di direktori sementara; jangan bergantung pada locale, jam, atau variabel lingkungan pengguna.
- **Dampak desain.** Hanya fake tanpa tes kontrak: fake menyimpang dan semua tes lulus palsu. Tes yang menulis ke direktori bersama: saling mengganggu dan *flaky*. Proses anak tak dikonsumsi keluarannya: tes macet. Golden yang diperbarui tanpa dibaca: regresi disahkan.

### C. Sintaks Dasar & Contoh Inti Implementasi

Semua contoh memakai proyek To-Do dari 7.8 (`package:logika_fase7`).

**Contoh 1 — berkas nyata di direktori sementara yang terisolasi.**

```dart
// test/helper.dart
import 'dart:io';

import 'package:test/test.dart';

/// Direktori sementara unik untuk SATU tes; dibersihkan otomatis setelah tes selesai.
Directory direktoriSementara() {
  final dir = Directory.systemTemp.createTempSync('uji_');
  addTearDown(() => dir.deleteSync(recursive: true));
  return dir;
}
```

```dart
// test/penyimpan_berkas_test.dart
@TestOn('posix')
library;

import 'dart:io';

import 'package:logika_fase7/todo.dart';
import 'package:test/test.dart';

import 'helper.dart';

bool get _sayaRoot => Process.runSync('id', ['-u']).stdout.toString().trim() == '0';

void main() {
  test('baca berkas yang belum ada mengembalikan null', () async {
    final p = PenyimpanBerkas('${direktoriSementara().path}/todo.json');
    expect(await p.baca(), isNull);
  });

  test('tulis lalu baca; tak ada sisa berkas sementara', () async {
    final dir = direktoriSementara();
    final p = PenyimpanBerkas('${dir.path}/todo.json');

    await p.tulis('[]');

    expect(await p.baca(), '[]');
    final nama = dir.listSync().map((e) => e.path.split('/').last).toList();
    expect(nama, ['todo.json']);
  });

  test('direktori tak dapat ditulis: GagalTulis, bukan galat mentah', () async {
    final dir = direktoriSementara();
    Process.runSync('chmod', ['500', dir.path]); // hanya baca dan eksekusi
    addTearDown(() => Process.runSync('chmod', ['700', dir.path])); // agar dapat dihapus

    final p = PenyimpanBerkas('${dir.path}/todo.json');
    await expectLater(p.tulis('[]'), throwsA(isA<GagalTulis>()));
  }, skip: _sayaRoot ? 'root mengabaikan izin berkas' : null);
}
```

- `Directory.systemTemp.createTempSync('uji_')` — membuat direktori baru dengan nama unik di lokasi sementara sistem; tiap tes mendapat miliknya sendiri, jadi tak ada tes yang melihat sisa tes lain.
- `addTearDown(() => dir.deleteSync(recursive: true))` — pembersihan didaftarkan di titik pembuatan sehingga selalu berjalan, bahkan bila tes gagal di tengah.
- `@TestOn('posix')` + `library;` — berkas ini hanya dijalankan di platform POSIX (Linux, macOS) karena memakai `chmod` dan `id`; di platform lain ia dilewati, bukan gagal.
- `dir.listSync().map(...)` lalu `expect(nama, ['todo.json'])` — membuktikan penulisan atomik (7.8) tak meninggalkan berkas `.tmp`; ini jenis sifat yang hanya terlihat pada sistem berkas nyata.
- `chmod 500` membuat direktori tak dapat ditulis; `PenyimpanBerkas.tulis` harus menerjemahkannya menjadi `GagalTulis` (galat domain, 5.5), bukan membiarkan `FileSystemException` mentah lolos.
- `skip: _sayaRoot ? '...' : null` — bila tes dijalankan sebagai root (umum di kontainer CI), izin berkas tak berlaku dan tes ini tak bermakna; mengabaikannya *dengan alasan yang tampil di laporan* lebih baik daripada membiarkannya gagal membingungkan.
- Urutan `addTearDown` adalah terbalik: pemulihan izin (`700`) didaftarkan terakhir sehingga berjalan lebih dulu, baru direktori dihapus.

**Contoh 2 — tes kontrak: fake dan nyata harus lulus tes yang sama.**

```dart
// test/kontrak_penyimpan.dart
import 'package:logika_fase7/todo.dart';
import 'package:test/test.dart';

void ujiKontrakPenyimpan(String nama, Penyimpan Function() buat) {
  group('kontrak Penyimpan: $nama', () {
    late Penyimpan p;
    setUp(() => p = buat());

    test('awalnya kosong: baca() mengembalikan null', () async {
      expect(await p.baca(), isNull);
    });

    test('tulis lalu baca mengembalikan isi yang sama', () async {
      await p.tulis('{"a":1}');
      expect(await p.baca(), '{"a":1}');
    });

    test('tulis berikutnya menggantikan yang lama', () async {
      await p.tulis('lama');
      await p.tulis('baru');
      expect(await p.baca(), 'baru');
    });

    test('cadangkan tidak mengubah isi utama', () async {
      await p.tulis('utama');
      await p.cadangkan('rusak');
      expect(await p.baca(), 'utama');
    });
  });
}
```

```dart
// test/penyimpan_kontrak_test.dart
import 'package:logika_fase7/todo.dart';
import 'package:test/test.dart';

import 'helper.dart';
import 'kontrak_penyimpan.dart';

void main() {
  ujiKontrakPenyimpan('memori', PenyimpanMemori.new);
  ujiKontrakPenyimpan('berkas', () => PenyimpanBerkas('${direktoriSementara().path}/todo.json'));
}
```

- `ujiKontrakPenyimpan(nama, buat)` — fungsi yang mendaftarkan satu rangkaian tes untuk *antarmuka* `Penyimpan`; implementasi yang diuji diberikan lewat pabrik `buat`.
- `setUp(() => p = buat())` — instans baru untuk tiap tes; untuk `PenyimpanBerkas`, pabrik juga membuat direktori sementara baru.
- Empat tes menyatakan *janji antarmuka* (baca kosong, tulis-lalu-baca, tulis menggantikan, cadangan terpisah), bukan detail implementasi mana pun.
- `PenyimpanMemori.new` — *tear-off* konstruktor sebagai pabrik; kedua implementasi lulus tes yang persis sama, itulah bukti fake tidak berbohong.
- Bila suatu hari `PenyimpanMemori` diubah dan menyimpang (misalnya `cadangkan` ikut mengubah isi utama), tes kontrak langsung memergokinya, sebelum tes lain lulus palsu.

**Contoh 3 — tes proses: CLI sungguhan dengan stdin, stdout, stderr, dan kode keluar, plus tes golden.**

```dart
// test/golden.dart
import 'dart:io';

import 'package:test/test.dart';

/// Membandingkan keluaran dengan berkas golden. Perbarui dengan: UPDATE_GOLDEN=1 dart test
void cocokDenganGolden(String nama, String aktual) {
  final berkas = File('test/golden/$nama.txt');
  final normal = '${aktual.replaceAll('\r\n', '\n').trimRight()}\n';

  if (Platform.environment['UPDATE_GOLDEN'] == '1') {
    berkas.createSync(recursive: true);
    berkas.writeAsStringSync(normal);
    return;
  }
  expect(berkas.existsSync(), isTrue, reason: 'golden belum ada: jalankan UPDATE_GOLDEN=1 dart test');
  expect(
    normal,
    berkas.readAsStringSync(),
    reason: 'keluaran berubah; tinjau diff, lalu perbarui golden bila disengaja',
  );
}
```

```dart
// test/cli_test.dart
@Tags(['integrasi', 'lambat'])
@TestOn('vm')
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import 'golden.dart';

late final Directory kerja;
late final String exe;

class HasilProses {
  HasilProses(this.kode, this.keluar, this.galat);
  final int kode;
  final String keluar;
  final String galat;
}

Future<HasilProses> jalankanCli(
  List<String> argumen, {
  List<String> masukan = const [],
}) async {
  final p = await Process.start(exe, argumen, workingDirectory: kerja.path);
  addTearDown(() => p.kill()); // jangan tinggalkan proses yatim bila tes gagal

  // Konsumsi stdout dan stderr SEKARANG: bila tidak, buffer pipa bisa penuh dan proses macet.
  final keluar = p.stdout.transform(utf8.decoder).join();
  final galat = p.stderr.transform(utf8.decoder).join();

  for (final baris in masukan) {
    p.stdin.writeln(baris);
  }
  await p.stdin.close(); // EOF: shell berhenti membaca

  final kode = await p.exitCode.timeout(const Duration(seconds: 10));
  return HasilProses(kode, await keluar, await galat);
}

void main() {
  setUpAll(() async {
    kerja = Directory.systemTemp.createTempSync('cli_');
    exe = '${kerja.path}/todo';
    final hasil = await Process.run(Platform.resolvedExecutable, [
      'compile', 'exe', 'bin/logika_fase7.dart', '-o', exe,
    ]);
    expect(hasil.exitCode, 0, reason: '${hasil.stderr}');
  }, timeout: const Timeout(Duration(minutes: 3)));

  tearDownAll(() => kerja.deleteSync(recursive: true));

  test('sesi normal: tambah dan cari, tersimpan di disk, kode 0', () async {
    final jalur = '${kerja.path}/sesi1.json';
    final r = await jalankanCli([jalur], masukan: ['tambah beli roti', 'cari roti']);

    expect(r.kode, 0);
    expect(r.keluar, contains('ditambah: beli roti'));
    expect(r.keluar, contains('1. beli roti'));
    expect(r.galat, isEmpty);
    expect(File(jalur).readAsStringSync(), contains('beli roti'));
  });

  test('berkas tak bisa dibaca: pesan di stderr dan kode keluar 74', () async {
    final jalur = '${kerja.path}/folder.json';
    Directory(jalur).createSync(); // direktori, bukan berkas: pembacaan gagal

    final r = await jalankanCli([jalur]);

    expect(r.kode, 74);
    expect(r.galat, isNotEmpty);
    expect(r.keluar, isNot(contains('todo>'))); // shell tak sempat dimulai
  });

  test('data rusak: dicadangkan, mulai kosong, tetap kode 0', () async {
    final jalur = '${kerja.path}/rusak.json';
    File(jalur).writeAsStringSync('ini bukan json');

    final r = await jalankanCli([jalur], masukan: ['cari x']);

    expect(r.kode, 0);
    expect(r.galat, contains('data rusak'));
    expect(File('$jalur.rusak').existsSync(), isTrue);
  });

  test('sesi lengkap sesuai golden', () async {
    final r = await jalankanCli(
      ['${kerja.path}/golden.json'],
      masukan: ['tambah beli roti', 'cari roti'],
    );
    expect(r.kode, 0);
    cocokDenganGolden('sesi_dasar', r.keluar);
  });
}
```

```text
# test/golden/sesi_dasar.txt  (dihasilkan sekali dengan UPDATE_GOLDEN=1 dart test, lalu DIBACA dan di-commit)
todo> ditambah: beli roti
todo> 1. beli roti
todo>
```

- `Process.start(exe, argumen, workingDirectory: ...)` — menjalankan biner sebagai proses sungguhan dan mengembalikan akses ke `stdin`, `stdout`, `stderr`, dan `exitCode`; direktori kerja diarahkan ke direktori sementara.
- `addTearDown(() => p.kill())` — bila tes gagal atau habis waktu sebelum proses selesai, proses dibunuh; tanpa ini terbentuk proses yatim.
- `p.stdout.transform(utf8.decoder).join()` dan padanannya untuk `stderr` dipanggil **sebelum** menulis ke stdin: keduanya dikonsumsi sambil proses berjalan sehingga buffer pipa tak pernah penuh.
- `p.stdin.writeln(baris)` lalu `await p.stdin.close()` — mengirim perintah satu per satu lalu EOF, yang membuat `await for` di shell (7.8) berakhir.
- `p.exitCode.timeout(...)` — tak ada tes proses tanpa batas waktu; proses macet menjadi kegagalan cepat.
- `setUpAll` mengompilasi sekali (`dart compile exe`) agar tiap tes hanya menjalankan biner; `Platform.resolvedExecutable` adalah jalur biner `dart` yang sedang menjalankan tes.
- Tes kedua memeriksa **kontrak kode keluar 74** dan bahwa pesan masuk ke stderr, bukan stdout; tes ketiga memeriksa jalur data rusak (peringatan di stderr, salinan `.rusak`, tetap kode 0).
- `@Tags(['integrasi', 'lambat'])` — berkas ini dikecualikan dari jalur cepat harian (`dart test -x lambat`) dan dijalankan penuh di CI.
- `cocokDenganGolden` menormalkan akhir baris (`\r\n` menjadi `\n`) dan spasi di ujung, membandingkan dengan berkas, dan hanya menulis ulang bila `UPDATE_GOLDEN=1`. Isi golden bergantung pada format keluaran proyekmu: hasilkan dengan `UPDATE_GOLDEN=1`, **baca**, baru commit.

*Catatan untuk blok golden di atas:* baris pertamanya (`# test/golden/...`) hanyalah keterangan di dokumen ini, **bukan** bagian isi berkas golden; isi berkas dimulai dari baris `todo> ditambah: beli roti`.

### D. Opsi Kode Lain untuk Logika yang Sama

| Pendekatan | Kapan cocok | Kelebihan | Risiko |
| --- | --- | --- | --- |
| Fake saja | Logika yang hanya butuh antarmuka | Cepat, deterministik | Fake dapat menyimpang tanpa ketahuan |
| Fake + tes kontrak | Setiap batas yang punya fake | Fake terjaga jujur | Perlu memelihara satu rangkaian tes kontrak |
| Direktori sementara nyata | Perilaku OS yang penting (izin, rename, atomisitas) | Menguji kenyataan | Lebih lambat; tak jalan di semua platform |
| `MemoryFileSystem` (`package:file`) | Banyak tes berkas yang cepat dan deterministik | Cepat; tanpa sisa di disk | Tak meniru izin, symlink, atau atomisitas OS |
| `package:test_descriptor` | Memeriksa struktur direktori secara deklaratif | Ringkas dan terbaca | Dependensi tambahan |
| Tes proses | Kontrak CLI: argumen, stdin, kode keluar | Paling mendekati pengguna | Paling lambat; rawan macet bila ceroboh |
| Golden | Keluaran teks panjang | Cepat menulis | Mudah menyetujui tanpa membaca |

Alternatif 1 — `package:file` dengan filesystem dalam memori (kode menerima `FileSystem`):

```dart
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:logika_fase7/todo.dart';

class PenyimpanFs implements Penyimpan {
  PenyimpanFs(this._fs, this.jalur);
  final FileSystem _fs;
  final String jalur;

  @override
  Future<String?> baca() async {
    final berkas = _fs.file(jalur);
    if (!await berkas.exists()) return null;
    return berkas.readAsString();
  }

  @override
  Future<void> tulis(String isi) async {
    final sementara = _fs.file('$jalur.tmp');
    await sementara.writeAsString(isi, flush: true);
    await sementara.rename(jalur);
  }

  @override
  Future<void> cadangkan(String isi) => _fs.file('$jalur.rusak').writeAsString(isi);
}

// Dipakai pada tes kontrak yang sama (Contoh 2):
// ujiKontrakPenyimpan('fs memori', () {
//   final fs = MemoryFileSystem()..directory('/data').createSync(recursive: true);
//   return PenyimpanFs(fs, '/data/todo.json');
// });
```

Alternatif 2 — `package:test_descriptor` untuk memeriksa struktur berkas secara deklaratif:

```dart
import 'package:logika_fase7/todo.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  test('berkas todo ditulis dengan isi persis', () async {
    await d.dir('data').create(); // dibuat di sandbox milik tes ini
    final p = PenyimpanBerkas('${d.sandbox}/data/todo.json');

    await p.tulis('[]');

    await d.dir('data', [d.file('todo.json', '[]')]).validate();
  });
}
```

- `PenyimpanFs` menerima `FileSystem` lewat konstruktor: di produksi diberi `LocalFileSystem()`, di tes diberi `MemoryFileSystem()`; kode yang sama, dunia berbeda. `FileSystem.file(...)`, `exists`, `readAsString`, `writeAsString`, dan `rename` mencerminkan API `dart:io`.
- Pakai `MemoryFileSystem` untuk menjalankan *tes kontrak yang sama* secara cepat; sisakan beberapa tes dengan direktori sementara nyata untuk perilaku yang tak ditiru memori.
- `d.dir(...).create()` dan `.validate()` — membuat dan memeriksa struktur direktori dari deskripsi; `d.sandbox` adalah jalur sandbox sementara milik tes saat ini, dibuat dan dibersihkan otomatis.

### E. Terminologi Esensial

- **Batas (boundary)** — titik tempat program bersentuhan dengan dunia luar: berkas, jaringan, proses, terminal, jam. **Adaptor** — kode tipis yang menerjemahkan antara dunia luar dan inti. **Humble object** — objek di batas yang sengaja dibuat sangat sederhana agar hampir tak perlu diuji.
- **Tes kontrak** — rangkaian tes terhadap antarmuka yang dijalankan pada semua implementasinya. **Fake drift** — fake menyimpang dari perilaku nyata.
- **Direktori sementara** — direktori unik yang dibuat dan dihapus untuk satu tes. **Isolasi** — tes tak saling memengaruhi lewat sumber daya bersama.
- **Proses anak** — program yang dijalankan tes. **EOF (end of file)** — tanda bahwa stdin sudah tak akan menerima data. **Kode keluar** — bilangan yang dikembalikan proses; konvensi `sysexits` (misalnya 70 untuk galat internal, 74 untuk galat I/O) memberi makna baku.
- **Proses yatim (orphan)** — proses anak yang tertinggal hidup setelah pemiliknya selesai. **Deadlock buffer pipa** — proses macet karena buffer keluarannya penuh dan tak ada yang membaca.
- **Tes golden/approval** — membandingkan keluaran dengan berkas yang disetujui. **Normalisasi** — menyeragamkan bagian keluaran yang tak stabil sebelum dibandingkan.

### F. Visualisasi (ASCII)

```text
          ┌───────── inti murni (8.1: tabel, properti, model) ─────────┐
 stdin ─► [shell] ─► uraiPerintah ─► jalankan ─► Riwayat ─► kodekan/dekode
   ▲         │                                        │
   │         │ adaptor tipis                          ▼
 stdout /    │ (8.3: tes proses)                  [Penyimpan]
 stderr /    ▼                                     │   ▲
 kode     kode keluar                    fake ◄─ tes kontrak ─► berkas nyata (direktori sementara)
```

```text
   setUpAll: compile exe SEKALI
   tes ─► Process.start ─┬─ stdout ─► dikonsumsi ─┐
                         ├─ stderr ─► dikonsumsi ─┤─► HasilProses(kode, keluar, galat)
                         └─ stdin  ◄─ tulis baris, lalu close() (EOF)
   exitCode.timeout(10 s)        tearDown: p.kill()
```

```text
   keluaran aktual ─► normalisasi (akhir baris, trimRight) ─► bandingkan dengan test/golden/NAMA.txt
      beda dan UPDATE_GOLDEN bukan 1 ─► GAGAL
      beda dan UPDATE_GOLDEN = 1 ─► tulis ulang ─► BACA diff di git ─► commit
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 7.8 (`Penyimpan`, shell, kode keluar), 5.5 dan 5.8 (galat domain dan tabel kode keluar), 8.1 (fake, tag, determinisme), 8.2 (cakupan dan gerbang CI).
- **Prasyarat bagi:** 8.4 (To-Do v7 memakai tes kontrak, tes proses, dan golden).
- **Dikembangkan di:** Fase Keamanan (izin berkas, symlink, TOCTOU, dan direktori sementara yang aman) serta Fase arsitektur (tes kontrak sebagai penjaga antarmuka antar-paket).

### H. Tips & Praktik Terbaik

- Satu antarmuka, satu rangkaian tes kontrak; tambahkan setiap implementasi baru (fake maupun nyata) ke rangkaian itu.
- Buat direktori sementara dan pendaftaran pembersihannya dalam satu fungsi, agar tak ada tes yang lupa membersihkan.
- Pisahkan tes berkas nyata dengan `@TestOn` dan lewati dengan alasan yang jelas bila kondisinya tak terpenuhi (misalnya `root`), jangan membiarkannya gagal membingungkan.
- Dalam tes proses, selalu: konsumsi stdout dan stderr, tutup stdin, beri `timeout`, dan daftarkan `kill` di `addTearDown`.
- Kompilasi biner sekali per berkas tes, bukan per tes.
- Pisahkan stdout dan stderr dalam asersi; kontrak CLI menyatakan *apa yang ke mana*.
- Perlakukan tabel kode keluar seperti API: satu baris tabel, satu tes.
- Tinjau diff golden seperti meninjau kode; golden yang diperbarui otomatis tanpa dibaca adalah regresi yang disahkan.
- Jaga golden kecil dan fokus; keluaran besar yang berubah sedikit-sedikit membuat orang berhenti membacanya.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Fake tanpa tes kontrak | Semua tes lulus, produksi gagal | Jalankan rangkaian kontrak pada fake dan implementasi nyata |
| Menulis ke direktori kerja atau direktori bersama | Tes saling mengganggu; sisa berkas | Direktori sementara unik per tes + `addTearDown` |
| Tes izin berkas dijalankan sebagai root | Gagal di kontainer CI | `skip` dengan alasan bila root |
| Tidak mengonsumsi stdout atau stderr proses anak | Tes macet | Konsumsi keduanya sejak awal |
| Lupa `stdin.close()` | Shell tak pernah selesai; tes habis waktu | Tutup stdin setelah menulis semua perintah |
| Tes proses tanpa `timeout` dan `kill` | Proses yatim; CI macet | `exitCode.timeout(...)` dan `addTearDown(p.kill)` |
| `dart run` di tiap tes | Suite sangat lambat | `dart compile exe` sekali di `setUpAll` |
| Golden berisi jalur absolut, waktu, atau acak | Gagal di mesin lain | Normalisasi atau keluarkan nilai itu dari keluaran |
| Memperbarui golden tanpa membaca diff | Regresi disahkan | Tinjau diff; commit hanya yang disengaja |
| Hanya tes proses | Lambat dan sulit melacak penyebab | Tes proses sedikit; tes kontrak dan tabel yang banyak |

### J. Sumber Referensi

- `Process` dan `Process.start`: https://api.dart.dev/stable/dart-io/Process-class.html · https://api.dart.dev/stable/dart-io/Process/start.html · `Directory.createTemp`: https://api.dart.dev/stable/dart-io/Directory/createTemp.html · `dart compile`: https://dart.dev/tools/dart-compile
- `package:test` (tag, `@TestOn`, selektor platform): https://pub.dev/packages/test · `package:test_descriptor`: https://pub.dev/packages/test\_descriptor · `package:file`: https://pub.dev/packages/file
- Konsep: Martin Fowler, *ContractTest*: https://martinfowler.com/bliki/ContractTest.html · Humble Object: http://xunitpatterns.com/Humble%20Object.html · Approval testing: https://approvaltests.com/
- Konvensi kode keluar `sysexits`: https://man.freebsd.org/cgi/man.cgi?query=sysexits

---

## 8.4 Studi Kasus Terpadu: To-Do v7, Verifikasi Berlapis (TAMBAHAN)

*Motivasi: kode yang selesai bukan yang sudah ditulis, melainkan yang sudah dibuktikan.*

> **Mengapa ditambahkan.** Fase 8 paling bermakna bila diterapkan pada kode yang sudah kamu kenal. To-Do v7 **tidak menambah fitur**: ia mengambil v6 (7.8) lalu memberinya bukti berlapis. Tiap klaim yang pernah dibuat di Fase 1–7 dipetakan ke alat bukti yang paling murah yang cukup kuat untuk klaim itu: properti untuk logika murni, fuzz untuk pemroses masukan, model untuk urutan perintah, gerbang untuk konkurensi, tes kontrak dan proses untuk batas, analisis statis untuk kelas bug, serta cakupan cabang dan mutasi untuk menilai tesnya sendiri.

**Struktur pembelajaran (mini daftar isi):** (1) peta bukti: klaim ke alat · (2) struktur proyek dan helper bersama · (3) properti untuk `tanpaDuplikat` · (4) tes berbasis model untuk `proses` · (5) fuzz untuk `uraiPerintah` · (6) protokol mutasi untuk logika inti · (7) gerbang kualitas: `just cek` dan CI · (8) definisi “selesai”.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Langkah & kode · D Variasi · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Kamu menyalin proyek `logika_fase7` menjadi `logika_fase8` lalu hanya menambah lapisan bukti: `analysis_options.yaml` ketat, `justfile`, `dart_test.yaml`, struktur `test/` berlapis (domain, aplikasi, batas), helper properti dengan seed yang dicatat, tes properti dan model, tes kontrak, tes proses dan golden, gerbang cakupan cabang, dan laporan mutasi di `README.md`. Kode di `lib/` hanya berubah bila bukti menemukan bug; setiap bug yang ditemukan menjadi tes contoh permanen.

### B. Konsep Kunci & Filosofi Mendalam

- **Biaya bukti mengikuti risiko.** Logika murni yang inti dan banyak berubah mendapat properti dan model; batas sistem mendapat sedikit tes nyata; konkurensi dibuktikan lewat gerbang; kebenaran data dijaga kontrak dan fuzz. Menghabiskan usaha yang sama di semua tempat adalah pemborosan.
- **Peta bukti sebagai matriks keterlacakan.** Tabel kebijakan jalur (5.8 dan 7.8) sudah menyatakan *apa* yang dijanjikan; peta bukti menyatakan *bagaimana tiap janji dibuktikan*. Baris yang tak punya bukti adalah klaim tanpa dasar.
- **Oracle harus independen.** Properti yang menghitung ulang jawabannya dengan algoritma yang sama dengan implementasi akan selalu lulus, termasuk saat salah. Gunakan relasi (subsekuens, idempoten, himpunan sama), oracle lambat yang jelas (6.7), atau model sederhana.
- **Bug yang ditemukan menjadi regresi.** Properti, fuzz, dan mutasi *mencari*; tes contoh *menjaga*. Setiap kegagalan yang ditemukan disusutkan, lalu dijadikan tes contoh permanen dengan nama yang menjelaskan bug-nya.
- **Tes juga diuji.** Cakupan cabang menunjukkan kode yang tak pernah disentuh; mutasi menunjukkan perilaku yang tak dijaga. Keduanya diterapkan pada inti, bukan pada seluruh kode.
- **Jalur cepat dan jalur penuh.** Jalur cepat (unit, properti, model, kontrak dengan fake) selesai dalam hitungan detik dan dijalankan terus-menerus; jalur penuh (proses, berkas nyata, mutasi) berjalan di CI dan terjadwal.
- **Definisi “selesai”.** Fitur tak dianggap selesai ketika kodenya ditulis, tetapi ketika `just cek` hijau, setiap baris tabel kebijakan punya tes, cakupan cabang domain melewati ambang, dan mutan yang selamat sudah dijelaskan.
- **Dampak desain.** Bukti hanya di satu lapis: celah di lapis lain tak terlihat. Properti tanpa oracle independen: lulus palsu. Hasil temuan tidak dijadikan regresi: bug yang sama muncul lagi.

### C. Langkah, Sintaks, dan Kode

**Langkah 1 — peta bukti: klaim, alat, lokasi.**

| # | Klaim | Alat bukti | Lokasi tes | Modul |
| --- | --- | --- | --- | --- |
| 1 | `uraiPerintah` tak pernah melempar untuk token apa pun | Fuzz (token acak) | `test/domain/urai_test.dart` | 8.1 |
| 2 | `kodekan(dekode(s))` sama dengan `s` untuk `s` hasil `kodekan` | Properti bolak-balik | `test/domain/kodekan_test.dart` | 8.1 |
| 3 | `dekode` hanya melempar `FormatException` | Fuzz (mutasi masukan valid) | `test/domain/kodekan_test.dart` | 8.1 |
| 4 | `tanpaDuplikat`: tanpa ganda, tak ada yang hilang, urutan relatif terjaga, idempoten, sama dengan oracle | Properti + oracle lambat | `test/domain/tanpa_duplikat_test.dart` | 8.1, 6.7 |
| 5 | `Riwayat`: batas terjaga dan undo membatalkan ubah | Tes model (Latihan 8.4) | `test/domain/riwayat_test.dart` | 8.1 |
| 6 | Urutan perintah acak pada `AplikasiTodo` setara model daftar, dan disk sama dengan memori | Tes berbasis model | `test/aplikasi/proses_model_test.dart` | 8.1 |
| 7 | Dua perintah bersamaan tak saling menimpa | Gerbang `Completer` | `test/aplikasi/konkurensi_test.dart` | 7.7, 7.8 |
| 8 | Retry dengan backoff dan timeout bekerja tepat | Waktu virtual (`fake_async`) | `test/aplikasi/timeout_test.dart` | 7.7, 7.8 |
| 9 | `PenyimpanBerkas` memenuhi kontrak, pagar bekerja, galat izin diterjemahkan | Tes kontrak + berkas nyata | `test/batas/penyimpan_*_test.dart` | 8.3 |
| 10 | CLI: kode keluar, stdout, dan stderr sesuai tabel | Tes proses + golden | `test/batas/cli_test.dart` | 8.3 |
| 11 | Kelas bug statis (`dynamic`, `Future` terlupa, galat tertelan) ditolak | Analyzer strict + lint | `analysis_options.yaml` | 8.2 |
| 12 | Tes cukup kuat | Cakupan cabang dan mutasi pada inti | `tool/cek_cakupan.dart`, README | 8.2 |

**Langkah 2 — struktur proyek dan helper bersama.**

```bash
cp -r logika_fase7 logika_fase8   # lalu ganti nama paket di pubspec.yaml dan semua import
cd logika_fase8
dart pub add meta
dart pub add --dev lints test kiri_check fake_async clock mocktail test_descriptor coverage
```

```text
logika_fase8/
├─ analysis_options.yaml        (8.2, Contoh 1)
├─ dart_test.yaml               (8.1, Contoh 10)
├─ justfile                     (8.2, Contoh 8)
├─ lib/  bin/                   (kode v6, hanya berubah bila bukti menemukan bug)
├─ tool/
│   ├─ data.dart                (buatData, dari 6.7)
│   └─ cek_cakupan.dart         (8.2, Contoh 6)
└─ test/
    ├─ helper.dart  properti.dart  kontrak_penyimpan.dart  golden.dart
    ├─ domain/      (tanpa_duplikat, kodekan, urai, riwayat)
    ├─ aplikasi/    (proses_model, konkurensi, timeout)
    ├─ batas/       (penyimpan_kontrak, penyimpan_berkas, cli)
    └─ golden/      (sesi_dasar.txt)
```

```dart
// test/properti.dart  (helper dari 8.1, Contoh 3, ditambah versi asinkron)
import 'dart:io';
import 'dart:math';

import 'package:test/test.dart';

int ambilSeed() =>
    int.tryParse(Platform.environment['SEED'] ?? '') ??
    DateTime.now().microsecondsSinceEpoch & 0x7fffffff;

void properti(String nama, void Function(Random acak) badan, {int putaran = 1000}) {
  test(nama, () {
    final seed = ambilSeed();
    printOnFailure('seed=$seed  (ulangi: SEED=$seed dart test)');
    final acak = Random(seed);
    for (var i = 0; i < putaran; i++) {
      badan(acak);
    }
  });
}

void propertiAsinkron(
  String nama,
  Future<void> Function(Random acak) badan, {
  int putaran = 200,
}) {
  test(nama, () async {
    final seed = ambilSeed();
    printOnFailure('seed=$seed  (ulangi: SEED=$seed dart test)');
    final acak = Random(seed);
    for (var i = 0; i < putaran; i++) {
      await badan(acak);
    }
  });
}
```

```dart
// test/helper.dart  (tambahan; direktoriSementara() dari 8.3 tetap di sini)
import 'package:logika_fase8/todo.dart';

/// Pencatat yang membungkam log agar keluaran tes bersih.
void diam(Tingkat t, String pesan, {Object? galat, StackTrace? jejak}) {}

List<String> judulDari(List<Item> daftar) => [for (final i in daftar) i.judul.teks];
```

- `cp -r` lalu penggantian nama: v7 adalah *salinan* v6; riwayat git memperlihatkan dengan jelas apa yang ditambahkan oleh fase ini.
- `dart pub add meta` (dependensi, karena anotasi dipakai di `lib/`) dan `dart pub add --dev ...` (alat uji dan analisis).
- Struktur `test/` berlapis mengikuti peta bukti: domain (murni, cepat), aplikasi (koordinator dan konkurensi), batas (berkas dan proses). Pembagian ini memudahkan menjalankan sebagian dan menandai yang lambat.
- `properti` dan `propertiAsinkron` adalah satu-satunya tempat seed dihasilkan dan dicatat; semua tes acak memakainya sehingga tak ada tes yang tak dapat diulang.
- `diam` dan `judulDari` mencegah duplikasi helper di setiap berkas tes.

**Langkah 3 — properti untuk `tanpaDuplikat`: relasi independen, bukan salinan implementasi.**

```dart
// test/domain/tanpa_duplikat_test.dart
import 'package:kiri_check/kiri_check.dart';
import 'package:logika_fase8/todo.dart';
import 'package:test/test.dart';

import '../helper.dart';

// Sesuaikan konstruktor Item dan lokasi tanpaDuplikatLambat dengan milikmu (6.7);
// bila tanpaDuplikatLambat ada di tool/data.dart, tambahkan: import '../../tool/data.dart';
List<Item> daftarDari(List<int> kode) =>
    [for (final k in kode) Item(Judul.dari('tugas $k'))];

bool subsekuens(List<String> kecil, List<String> besar) {
  var i = 0;
  for (final x in besar) {
    if (i < kecil.length && kecil[i] == x) i++;
  }
  return i == kecil.length;
}

void main() {
  final kodeAcak = list(integer(min: 0, max: 15), maxLength: 80);

  group('tanpaDuplikat', () {
    property('tak ada judul ganda pada hasil', () {
      forAll(kodeAcak, (kode) {
        final hasil = judulDari(tanpaDuplikat(daftarDari(kode)));
        expect(hasil.toSet(), hasLength(hasil.length));
      });
    });

    property('tak ada judul yang hilang: himpunan judul sama', () {
      forAll(kodeAcak, (kode) {
        final masuk = judulDari(daftarDari(kode));
        final hasil = judulDari(tanpaDuplikat(daftarDari(kode)));
        expect(hasil.toSet(), masuk.toSet());
      });
    });

    property('urutan relatif terjaga: hasil adalah subsekuens masukan', () {
      forAll(kodeAcak, (kode) {
        final masuk = judulDari(daftarDari(kode));
        final hasil = judulDari(tanpaDuplikat(daftarDari(kode)));
        expect(subsekuens(hasil, masuk), isTrue);
      });
    });

    property('idempoten: dua kali sama dengan sekali', () {
      forAll(kodeAcak, (kode) {
        final sekali = tanpaDuplikat(daftarDari(kode));
        final dua = tanpaDuplikat(sekali);
        expect(judulDari(dua), judulDari(sekali));
      });
    });

    property('sama dengan oracle lambat dari 6.7', () {
      forAll(kodeAcak, (kode) {
        final data = daftarDari(kode);
        expect(judulDari(tanpaDuplikat(data)), judulDari(tanpaDuplikatLambat(data)));
      });
    });
  });
}
```

- `list(integer(min: 0, max: 15), maxLength: 80)` — generator daftar bilangan kecil; rentang sempit (16 nilai) membuat **duplikat sering muncul**, sehingga properti benar-benar menyentuh jalur penghapusan duplikat (generator yang rentangnya lebar akan hampir tak menghasilkan duplikat).
- `daftarDari` membuat `Item` segar di setiap pemanggilan; properti memanggilnya dua kali bila perlu agar tak ada berbagi objek yang tak disengaja.
- Lima properti adalah lima *relasi*: tak ganda, tak ada yang hilang, subsekuens (urutan relatif), idempoten, dan setara oracle. Tak satu pun menghitung ulang hasil dengan algoritma implementasi; itulah ciri oracle independen.
- `subsekuens(kecil, besar)` memeriksa bahwa `kecil` dapat dibentuk dari `besar` dengan membuang elemen tanpa mengubah urutan, menggunakan satu penelusuran.
- Bila suatu properti gagal, `kiri_check` menyusutkan daftar; salin contoh minimalnya menjadi tes contoh bernama (misalnya `test('duplikat berurutan dibuang tepat sekali', ...)`).

**Langkah 4 — tes berbasis model untuk `AplikasiTodo.proses`.**

```dart
// test/aplikasi/proses_model_test.dart
import 'package:logika_fase8/todo.dart';
import 'package:test/test.dart';

import '../helper.dart';
import '../properti.dart';

void main() {
  propertiAsinkron('perintah acak setara model daftar; disk sama dengan memori', (acak) async {
    final penyimpan = PenyimpanMemori();
    final app = (await AplikasiTodo.muat(penyimpan, catat: diam)).aplikasi;
    final model = <String>[]; // model: List<String> dengan aturan yang jelas

    for (var langkah = 0; langkah < 30; langkah++) {
      if (acak.nextInt(4) == 0) {
        await app.proses(const Bersihkan());
        final terlihat = <String>{};
        model.retainWhere(terlihat.add); // model: hanya kemunculan pertama
      } else {
        final judul = 'tugas ${acak.nextInt(6)}';
        await app.proses(Tambah(Judul.dari(judul)));
        model.add(judul);
      }

      final konteks = 'langkah $langkah';
      expect(judulDari(app.daftar), model, reason: konteks);

      final isi = await penyimpan.baca();
      if (isi != null) {
        expect(judulDari(dekode(isi)), model, reason: '$konteks (disk)');
      }
    }
  });
}
```

- `propertiAsinkron(...)` menjalankan badan 200 kali dengan satu seed yang dicatat; tiap putaran memulai aplikasi baru dengan `PenyimpanMemori` kosong.
- Model hanyalah `List<String>`: `Tambah` menambah di akhir, `Bersihkan` mempertahankan kemunculan pertama. Model sederhana inilah *spesifikasi yang dapat dieksekusi*.
- `model.retainWhere(terlihat.add)` — `Set.add` mengembalikan `true` hanya untuk elemen baru, sehingga hanya kemunculan pertama yang dipertahankan; tanpa menulis ulang algoritma implementasi.
- Setelah setiap perintah, dua pemeriksaan: memori (`app.daftar`) dan disk (`dekode(isi)`) harus sama dengan model; ini membuktikan klaim 6 dari peta bukti, termasuk *komit setelah persisten* (7.8).
- `if (isi != null)` — bila belum ada penulisan (misalnya `Bersihkan` pada daftar tanpa duplikat tidak menulis apa pun), penyimpan memang masih kosong.
- Catat: tes ini sengaja berurutan (tiap `proses` di-`await`); kasus bersamaan dibuktikan terpisah oleh tes gerbang di 7.8.

**Langkah 5 — fuzz untuk `uraiPerintah`: masukan apa pun tak boleh membuat crash.**

```dart
// test/domain/urai_test.dart
import 'package:logika_fase8/todo.dart';
import 'package:test/test.dart';

import '../properti.dart';

void main() {
  final kosakata = <String>[
    'tambah', 'cari', 'bersihkan', 'undo', 'selesai', 'hapus',
    '', ' ', '-1', '999999999999999999999', '😀', 'x' * 500,
  ];

  properti('uraiPerintah: token apa pun menghasilkan UraiGagal atau UraiBerhasil', (acak) {
    final token = [
      for (var i = 0, n = acak.nextInt(6); i < n; i++)
        kosakata[acak.nextInt(kosakata.length)],
    ];

    final hasil = uraiPerintah(token); // tidak boleh melempar

    expect(
      hasil,
      anyOf(isA<UraiGagal>(), isA<UraiBerhasil>()),
      reason: 'token: $token',
    );
  }, putaran: 5000);
}
```

- `kosakata` memuat kata perintah asli, string kosong, spasi, angka negatif, angka sangat besar, emoji, dan string panjang: campuran *masukan wajar dan tak wajar* yang paling sering membuat pemroses salah.
- `for (var i = 0, n = acak.nextInt(6); i < n; i++) kosakata[...]` — membangun daftar token berpanjang acak 0–5 dari kosakata itu.
- `uraiPerintah(token)` tanpa `try`: bila ia melempar apa pun, tes gagal dan seed tercatat. Kontraknya (3.5): masukan jelek menjadi `UraiGagal` (data), bukan exception.
- `anyOf(isA<UraiGagal>(), isA<UraiBerhasil>())` — hasil harus salah satu dari dua kemungkinan yang dijanjikan.
- Bila fuzz menemukan crash, perbaiki `uraiPerintah`, lalu tambahkan tes contoh bernama dari masukan pemicunya (misalnya `test('angka di luar rentang int menjadi UraiGagal', ...)`).

**Langkah 6 — protokol mutasi untuk logika inti To-Do.**

| # | Berkas, mutan | Prediksi: harus ditangkap oleh | Hasil (isi sendiri) |
| --- | --- | --- | --- |
| 1 | `_indeksTanpaDuplikat`: `terlihat.add(judul[i])` menjadi `!terlihat.add(judul[i])` | Tes “bersihkan di isolate identik dengan oracle” (7.8) |  |
| 2 | `_indeksTanpaDuplikat`: `i < judul.length` menjadi `i <= judul.length` | Tes isolate yang sama (galat `RangeError`) |  |
| 3 | `_terapkanBersih`: `dibuang == 0` menjadi `dibuang <= 0` | **Tak ada** (mutan setara: `dibuang` tak pernah negatif) |  |
| 4 | `_prosesSerial`: pindahkan `_riwayat = baru` ke sebelum `await ulangiAsinkron(...)` | Tes timeout: `app.daftar` seharusnya kosong |  |
| 5 | `PenyimpanBerkas._tulisAtomik`: hapus blok `if (masihTerbaru != null && !masihTerbaru()) { ... }` | Tes berkas “penulisan lama tak menimpa yang baru” |  |
| 6 | `bisaDiulang`: hapus \`e is TimeoutException |  | \` |
| 7 | `proses`: panggil `_prosesSerial(perintah)` langsung tanpa `_antrean.jalankan` | Tes gerbang “dua perintah bersamaan” |  |
| 8 | `ulangiAsinkron`: `percobaan >= maksPercobaan` menjadi `percobaan > maksPercobaan` | Tes timeout dan transien (jumlah percobaan) |  |

```bash
# Setelah protokol manual, jalankan alat otomatis pada berkas inti dan bandingkan hasilnya
dart pub add --dev mutation_test
dart pub global run coverage:test_with_coverage --branch-coverage
dart run mutation_test --coverage coverage/lcov.info lib/todo.dart
```

```markdown
## Bukti (v7)

| Pemeriksaan | Hasil | Konfigurasi |
| --- | --- | --- |
| `dart analyze --fatal-infos` | bersih | strict-casts, strict-inference, strict-raw-types; 10 lint tambahan |
| Cakupan baris / cabang (`lib/`) | xx% / yy% | `test_with_coverage --branch-coverage`, SDK 3.14 |
| Mutasi inti (terbunuh / (total - setara)) | a / b | 8 mutan manual + `mutation_test` pada `lib/todo.dart` |
| Waktu `just cek` | n detik | mesin dan SDK dicatat |
```

- Setiap baris menunjuk perubahan *satu hal* pada kode yang dibangun di 7.8, plus tes yang *diprediksi* menangkapnya. Prediksi adalah hipotesis; hasilnya kamu isi setelah benar-benar menerapkan mutan dan menjalankan `dart test`.
- Mutan #3 setara: `dibuang` adalah selisih panjang daftar dengan subsetnya sehingga tak pernah negatif; tak ada tes yang bisa membedakan `== 0` dan `<= 0`. Catat sebagai setara, jangan paksa menulis tes.
- Mutan #4 sampai #8 menyentuh *jaminan konkurensi dan ketahanan* dari 7.8; bila ada yang selamat, berarti tes gerbang atau waktu virtual belum cukup tajam dan perlu diperketat.
- Mutan selamat yang sah (bukan setara) menunjuk perilaku yang tak dijaga: tambahkan tes, jalankan ulang mutan itu, pastikan kini terbunuh.
- Berkas README memuat angka sebenarnya beserta konfigurasi pengukurannya (SDK, flag, mesin), seperti kebiasaan pengukuran di Fase 6.

**Langkah 7 — gerbang kualitas: jalur cepat dan jalur penuh.**

```make
# tambahan pada justfile dari 8.2 (Contoh 8)
cepat:
    dart test -x lambat

penuh: format analisis uji cakupan
```

- `just cepat` — jalur harian: tes yang tak bertag `lambat` (properti, model, kontrak dengan fake); target beberapa detik.
- `just penuh` (sama dengan `just cek`) — jalur CI: format, analisis ketat, seluruh tes termasuk proses dan berkas nyata, lalu cakupan dengan gerbang ambang (kode keluar 2 bila data cabang tak ada).
- Workflow terjadwal dari 8.2 menjalankan mutasi pada berkas inti; hasilnya dicatat di README, bukan dijadikan gerbang di setiap commit.

**Langkah 8 — definisi “selesai” untuk To-Do v7.**

- [ ] `just cek` hijau di mesinmu dan di CI.
- [ ] Setiap baris tabel kebijakan (5.8 dan 7.8) punya tes yang namanya menyebut baris itu.
- [ ] `dart analyze --fatal-infos` bersih tanpa `// ignore:` tanpa alasan.
- [ ] Cakupan cabang pada lapisan domain mencapai ambang yang kamu tetapkan di README.
- [ ] Semua mutan selamat sudah ditutup dengan tes atau dicatat sebagai setara.
- [ ] Setiap bug yang ditemukan properti, fuzz, atau mutasi punya tes contoh permanen.
- [ ] Seed tercetak saat gagal; semua tes acak dapat diulang dengan `SEED=...`.
- [ ] Jalur cepat selesai dalam waktu yang kamu tetapkan (misalnya di bawah 10 detik).

### D. Variasi Kode untuk Logika yang Sama

| Keputusan | Pilihan | Kelebihan | Kekurangan |
| --- | --- | --- | --- |
| Tes acak | Helper `properti` manual (dipilih untuk model) | Tanpa dependensi; mudah dibaca; kendali penuh | Tanpa shrinking |
| Tes acak | `kiri_check` | Generator, shrinking, ekosistem | Dependensi; kurva belajar |
| Struktur `test/` | Per lapis (domain, aplikasi, batas) — dipilih | Mudah memilih jalur cepat atau penuh | Fitur tersebar di beberapa folder |
| Struktur `test/` | Per fitur | Semua tes satu fitur berdekatan | Sulit memisahkan yang lambat |
| Cakupan mutasi | Hanya inti, manual | Murah dan paling bermakna | Tidak otomatis |
| Cakupan mutasi | Berkas berubah, otomatis | Terukur dan berulang | Butuh waktu CI |

Alternatif tes model memakai `kiri_check` agar urutan perintah ikut disusutkan otomatis bila gagal:

```dart
import 'package:kiri_check/kiri_check.dart';
import 'package:logika_fase8/todo.dart';
import 'package:test/test.dart';

import '../helper.dart';

void main() {
  // -1 berarti Bersihkan; 0..5 berarti Tambah 'tugas k'
  final langkahAcak = list(integer(min: -1, max: 5), maxLength: 30);

  property('proses acak setara model (kiri_check, dengan shrinking)', () {
    forAll(langkahAcak, (langkah) async {
      final penyimpan = PenyimpanMemori();
      final app = (await AplikasiTodo.muat(penyimpan, catat: diam)).aplikasi;
      final model = <String>[];

      for (final k in langkah) {
        if (k < 0) {
          await app.proses(const Bersihkan());
          final terlihat = <String>{};
          model.retainWhere(terlihat.add);
        } else {
          await app.proses(Tambah(Judul.dari('tugas $k')));
          model.add('tugas $k');
        }
      }
      expect(judulDari(app.daftar), model);
    });
  });
}
```

- Daftar bilangan menjadi *skrip perintah*: `-1` untuk bersihkan, `0..5` untuk menambah; bila gagal, pustaka menyusutkan skrip menjadi urutan perintah terpendek yang tetap gagal.
- Pastikan versi `kiri_check` yang kamu pakai mendukung blok `async` pada `forAll` (periksa tanda tangan `forAll` di dokumentasi); bila tidak, pakai versi manual `propertiAsinkron` di Langkah 4.
- Pilih versi manual bila ingin nol dependensi dan pengendalian penuh atas seed; pilih `kiri_check` bila shrinking urutan perintah bernilai bagimu.

### E. Terminologi Esensial

- **Matriks keterlacakan** — tabel yang menghubungkan tiap klaim atau persyaratan dengan buktinya (tes, analisis, ukuran). **Peta bukti** — versi ringkasnya di fase ini.
- **Oracle independen** — cara mengetahui jawaban benar yang tak menyalin logika implementasi. **Spesifikasi yang dapat dieksekusi** — model sederhana yang dijalankan berdampingan dengan sistem.
- **Tes regresi** — tes yang menjaga agar bug yang pernah ditemukan tak muncul lagi. **Jalur cepat / jalur penuh** — kumpulan tes yang dijalankan terus-menerus dibanding yang dijalankan di CI.
- **Gerbang kualitas** — ambang yang menggagalkan build bila tak terpenuhi. **Definisi “selesai”** — daftar kriteria yang harus terpenuhi sebelum pekerjaan dianggap rampung.
- **Mutan selamat / terbunuh / setara** — hasil penilaian tes oleh mutasi (8.2). **Verifikasi berlapis** — memakai beberapa jenis bukti yang saling menutup kelemahan.

### F. Visualisasi (ASCII)

```text
   klaim (tabel kebijakan 5.8 / 7.8)
      │
      ├── logika murni ............ properti + oracle + model   (8.1)   ─┐
      ├── pemroses masukan ........ fuzz + kontrak parse         (8.1)    │
      ├── urutan perintah ......... tes berbasis model           (8.1)    │ jalur cepat
      ├── konkurensi & timeout .... gerbang + waktu virtual      (7.7)   ─┘
      ├── batas (berkas, CLI) ..... kontrak + berkas nyata + proses + golden (8.3) ─┐ jalur penuh
      ├── kelas bug statis ........ analyzer strict + lint       (8.2)   ─┘ (CI)
      └── kualitas tes ............ cakupan cabang + mutasi       (8.2)  (terjadwal)
```

```text
   properti / fuzz / mutasi menemukan masalah
          │
          ▼
   susutkan ─► contoh minimal ─► tes contoh BERNAMA (regresi) ─► perbaiki lib/ ─► semua hijau
```

```text
   biaya per tes                        jumlah tes
   ▲                                    │
   │  proses / mutasi (sedikit)         │
   │  berkas nyata / kontrak            │
   │  properti / model (sedang)         │
   │  tabel / unit (banyak)             ▼
```

### G. Hubungan dengan Modul Lain

- **Memakai:** seluruh Fase 8 (8.1 hingga 8.3), Fase 7 (7.7 dan 7.8: gerbang, waktu virtual, kode To-Do v6), 6.7 (oracle dan `buatData`), serta 5.8 (tabel kebijakan jalur).
- **Dikembangkan di:** Fase Keamanan (menambah fuzz masukan tak tepercaya dan tes jalur berkas), Fase arsitektur (tes kontrak sebagai penjaga antarmuka antar-paket), dan proyek akhir kurikulum (portofolio dengan bukti berlapis dan laporan mutasi).

### H. Tips & Praktik Terbaik

- Tulis peta bukti *sebelum* menulis tes; baris yang tak punya alat bukti adalah klaim tanpa dasar.
- Mulai dari mutasi manual pada inti: cepat, murah, dan paling jujur menilai tesmu.
- Setiap temuan menjadi tes contoh bernama; nama tes menjelaskan bug-nya.
- Jaga jalur cepat tetap cepat dengan tag `lambat` dan `integrasi`; jalur penuh boleh lebih lambat tetapi harus ada di CI.
- Catat angka nyata (cakupan, skor mutasi, waktu) beserta konfigurasi di README; angka tanpa konfigurasi tak bisa dibandingkan.
- Jangan menaikkan ambang cakupan hanya karena bisa; naikkan setelah mutasi menunjukkan tes memang menjaga perilaku.
- Bila properti terlalu sering gagal karena generator, perbaiki generator (atau prasyaratnya), bukan melonggarkan properti.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Properti yang menyalin implementasi | Selalu lulus, termasuk saat salah | Pakai relasi independen, oracle lambat, atau model |
| Generator yang rentangnya terlalu lebar | Duplikat dan kasus tepi jarang muncul | Persempit rentang; periksa sebaran dengan `collect` |
| Hasil temuan tidak dijadikan regresi | Bug yang sama muncul lagi | Tes contoh bernama dari contoh minimal |
| Mengabaikan mutan setara dan memaksakan tes | Tes aneh yang tak bermakna | Catat sebagai setara dan kecualikan dari skor |
| Semua tes di satu jalur | Suite lambat sehingga dihindari | Pisahkan jalur cepat dan penuh dengan tag |
| Ambang cakupan tanpa data cabang | Lulus palsu | Gerbang yang gagal bila data cabang tak ada |
| Angka tanpa konfigurasi di README | Tak dapat dibandingkan atau diulang | Catat SDK, flag, dan mesin |
| Mengganti `lib/` tanpa tes pemicu | Perilaku berubah diam-diam | Setiap perubahan `lib/` berasal dari bukti yang gagal |

### J. Sumber Referensi

- ✔ `kiri_check`: https://pub.dev/documentation/kiri\_check/latest/kiri\_check · `mutation_test`: https://pub.dev/packages/mutation\_test · ✔ `package:coverage`: https://pub.dev/documentation/coverage/
- Konsep: Martin Fowler, *SelfTestingCode*: https://martinfowler.com/bliki/SelfTestingCode.html · *TestCoverage*: https://martinfowler.com/bliki/TestCoverage.html · Traceability matrix: https://en.wikipedia.org/wiki/Traceability\_matrix
- Rujukan di modul sebelumnya: 7.7 dan 7.8 untuk gerbang dan waktu virtual; 8.1 hingga 8.3 untuk seluruh alat yang dirangkai di sini.

---

## Latihan Fase 8 (sengaja tanpa kunci jawaban)

Kerjakan sendiri, lalu commit dengan struktur `fase-8/latihan-N/` berisi `README.md` (spesifikasi, tabel hasil ukur beserta konfigurasinya), `lib/`, `tool/`, dan `test/`. Untuk setiap latihan yang memuat angka (cakupan, skor mutasi, waktu), catat SDK, flag, dan mesin.

1. **\[8.1\]** Tulis tiga properti untuk `konversi_satuan` (bolak-balik, transitivitas A ke B ke C sama dengan A ke C, monotonik untuk faktor positif) dengan 10.000 input acak (`kiri_check` atau helper manual). Lalu lakukan mutasi manual: ubah satu operator pada kode dan pastikan setidaknya satu tes gagal. Tukar `konversi` dengan `konversiBug` (8.1, Contoh 4) dan catat contoh minimal hasil shrinking. *Kriteria penerimaan:* minimal lima mutasi manual **non-setara** semuanya tertangkap (mutan setara dicatat dan dikecualikan); seed dicetak saat gagal; tak ada tes yang bergantung pada jam atau jaringan nyata.
2. **\[8.1\]** Tulis tes berbasis model untuk struktur data buatanmu (misalnya cache LRU dari Fase 6 atau `Riwayat`): bandingkan dengan model `List` atau `Map` pada urutan operasi acak. *Kriteria penerimaan:* tanam satu bug sengaja dan buktikan tes menemukannya; urutan yang gagal disusutkan menjadi contoh minimal dan dijadikan tes regresi bernama.
3. **\[8.1\]** Tulis fuzz untuk dua pemroses masukanmu (misalnya parser konversi dan `uraiPerintah`) dengan kontrak “hanya galat yang dijanjikan yang boleh keluar”. *Kriteria penerimaan:* minimal 5.000 masukan per pemroses dengan seed dicatat; setiap temuan menjadi tes contoh permanen.
4. **\[8.1\]** Tulis `Pengirim` dalam versi fake dan versi mock (`mocktail`). Refaktor internal `Pengingat` tanpa mengubah perilakunya dan tunjukkan bahwa tes fake tetap lulus sementara tes mock yang memeriksa urutan panggilan internal pecah. Jelaskan pelajarannya dalam README.
5. **\[8.2\]** Nyalakan seluruh mode strict dan 15 lint tambahan pada `katalog_perpustakaan`, perbaiki semua temuan tanpa `// ignore`, lalu lakukan mutasi manual pada 10 baris logika inti. *Kriteria penerimaan:* analyzer bersih dengan `--fatal-infos`; cakupan **cabang** minimal 90% pada lapisan domain *diukur dengan `--branch-coverage`* (gerbang gagal bila data cabang tak ada); setiap mutasi non-setara tertangkap (yang lolos dicatat lalu ditambal dengan tes baru); skrip lokal (`just` atau shell) menjalankan semua langkah dengan satu perintah.
6. **\[8.2\]** Rumuskan kontrak (prakondisi, pascakondisi, invarian) untuk satu kelas milikmu; tegakkan dengan `throw`, `assert`, dan satu tipe (extension type). Tambahkan tes kenari untuk `assert`, lalu buktikan dengan satu mutan bahwa `assert` pascakondisi menangkap bug yang lolos dari tes contoh biasa.
7. **\[8.3\]** Tulis tes kontrak untuk dua implementasi sebuah antarmuka di proyekmu (fake dan nyata). Ubah fake supaya menyimpang dan tunjukkan tes kontrak menangkapnya. Lalu tulis tes proses untuk CLI-mu: tiga kode keluar berbeda, stdout dan stderr terpisah, dan satu tes golden yang dihasilkan dengan `UPDATE_GOLDEN=1` dan **ditinjau diff-nya** sebelum commit.
8. **\[8.4\]** Lengkapi To-Do v7: tes model untuk `Riwayat` (batas riwayat dan undo), isi tabel mutasi delapan baris beserta hasilnya, dan buat README “Bukti (v7)” dengan angka nyata dan konfigurasinya.
9. **\[8.4\]** Pasang `just cek`, `tool/cek_cakupan.dart`, workflow CI, dan hook `pre-push`. Picu satu kegagalan sengaja pada tiap langkah (format, analisis, tes, cakupan) dan pastikan masing-masing menghentikan alur dengan pesan yang jelas.

---

## Ringkasan Fase 8 & Daftar Periksa Kelulusan

| Modul | Satu kalimat inti |
| --- | --- |
| 8.1 | Tes hanya bisa menyangkal; pilih bukti menurut risiko: tabel untuk contoh, properti untuk sifat, model untuk urutan, fuzz untuk masukan rusak, dan determinisme untuk semuanya. |
| 8.2 | Bukti termurah adalah yang berjalan sendiri: analisis statis ketat, kontrak yang tepat (`throw` untuk luar, `assert` untuk dalam, tipe untuk yang mustahil), cakupan cabang yang benar-benar terukur, dan mutasi untuk menilai tes. |
| 8.3 | Di batas dunia nyata masuk: jaga fake tetap jujur dengan tes kontrak, isolasi sumber daya, dan uji proses dengan stdin, stdout, stderr, serta kode keluar sebagai janji. |
| 8.4 | Verifikasi berlapis memetakan tiap klaim ke alat bukti yang paling murah yang cukup kuat, mengubah temuan menjadi regresi, dan mengunci semuanya dengan satu perintah yang sama di lokal dan CI. |

**Daftar periksa kelulusan** (jawab tanpa membuka dokumen):

- [ ] Aku bisa menjelaskan mengapa tes hanya dapat menyangkal, dan memilih jenis bukti menurut risiko.
- [ ] Aku bisa menulis properti dengan oracle yang independen, membaca sebaran generator, dan menghindari properti hampa.
- [ ] Aku bisa menjelaskan shrinking dan selalu mencatat seed agar kegagalan dapat diulang.
- [ ] Aku bisa membuat tes deterministik: waktu disuntikkan, I/O dibungkus, dan fake dipilih sebelum mock.
- [ ] Aku bisa menulis fuzz dengan kontrak yang jelas dan mengubah temuannya menjadi tes regresi.
- [ ] Aku bisa menyalakan mode strict dan mengurasi lint, dan memperlakukan setiap `ignore` sebagai utang bernalar.
- [ ] Aku bisa menempatkan `throw`, `assert`, dan tipe pada tempat yang tepat dan menjelaskan mengapa `assert` bukan validasi masukan.
- [ ] Aku bisa mengukur cakupan baris dan cabang dengan benar, dan menjelaskan mengapa cakupan bukan jaminan.
- [ ] Aku bisa melakukan mutation testing, membedakan mutan terbunuh, selamat, dan setara, dan menghitung skornya.
- [ ] Aku bisa menulis tes kontrak, tes berkas yang terisolasi, tes proses, dan tes golden yang aman.
- [ ] Aku bisa merangkai format, analisis, tes, cakupan, dan mutasi menjadi satu perintah lokal yang sama dengan CI.
- [ ] Sembilan latihan sudah di-commit dengan angka nyata beserta konfigurasinya.

**Pratinjau fase berikutnya (penomoran menunggu keputusanmu).** Menurut kurikulum, yang tersisa adalah *Keamanan, Isolasi & Anonimitas* (pemodelan ancaman, validasi di batas, dan serangan logika umum; kriptografi aman dan penanganan rahasia; rantai pasok, isolasi proses, dan anonimitas), lalu arsitektur dan proyek akhir. Rujukan di Fase 5–8 menyebut keamanan sebagai “Fase 9” dan arsitektur sebagai “Fase 11”. Hal yang masih perlu dikonfirmasi: apakah Modul 2.2 dan 2.3 kurikulum (rekursi dan pemrograman dinamis; graf, pencarian, dan penjadwalan) sudah tercakup di Fase 1–4, dan penomoran akhir fase-fase yang tersisa. Prasyaratnya: daftar periksa di atas terpenuhi.

---

## Referensi Induk Fase 8

> **Catatan verifikasi.** Tanda ✔ berarti halaman tersebut dibuka dan diverifikasi lewat pencarian atau pengambilan halaman saat Fase 8 disusun (20 November 2026). Tautan tanpa tanda adalah halaman resmi atau baku yang stabil, tetapi belum diverifikasi ulang; bila ada yang berpindah, cari judulnya di dart.dev, pub.dev, atau dokumentasi paketnya. **Kode di Fase 8 belum dijalankan di lingkungan penyusun** (tanpa Dart SDK dan tanpa akses ke pub.dev). Beberapa hal yang bergantung pada milikmu dan perlu diperiksa saat menjalankan: tanda tangan `Item` dan lokasi `tanpaDuplikatLambat` (6.7), apakah `forAll` pada `kiri_check` versimu menerima blok `async`, dukungan `dart test --coverage-path` pada SDK-mu (`dart test --help`), dan format keluaran shell yang menjadi isi golden. Jalankan `dart analyze` dan `dart test`, lalu laporkan setiap selisih agar bisa diperbaiki.

**Dokumentasi resmi Dart dan paket**

- ✔ Rilis Dart 3.14 (11 November 2026): https://dart.dev/blog/announcing-dart-3-14 · ✔ https://dart.dev/guides/whats-new
- Pengujian: https://dart.dev/tools/testing · https://dart.dev/tools/dart-test · ✔ `package:test`: https://pub.dev/documentation/test/latest/ · https://github.com/dart-lang/test
- Analisis statis: https://dart.dev/tools/analysis · https://dart.dev/tools/linter-rules · https://dart.dev/tools/dart-analyze · https://dart.dev/tools/dart-fix · https://dart.dev/tools/dart-format
- Bahasa: `assert`: https://dart.dev/language/error-handling#assert · Extension types: https://dart.dev/language/extension-types · Pola: https://dart.dev/language/patterns · Record: https://dart.dev/language/records
- ✔ `--enable-asserts` (ringkasan praktis, pihak ketiga): https://codewithandrea.com/tips/enable-asserts-flag · ✔ README `benchmark_test` (menyebut `dart test` berjalan dengan assert aktif): https://pub.dev/documentation/benchmark\_test/0.1.2/
- Properti: ✔ `kiri_check` https://pub.dev/packages/kiri\_check · ✔ https://pub.dev/documentation/kiri\_check/latest/kiri\_check · ✔ https://szktty.github.io/kiri-check/quickstart.html · ✔ https://github.com/szktty/kiri-check · ✔ `dartproptest` https://pub.dev/documentation/dartproptest/latest · ✔ https://pub.dev/packages/dartproptest/changelog
- Waktu, double, dan stream: ✔ `fake_async` https://pub.dev/packages/fake\_async/changelog · `clock` https://pub.dev/packages/clock · `mocktail` https://pub.dev/packages/mocktail · ✔ `async` https://pub.dev/packages/async
- Berkas dan batas: `test_descriptor` https://pub.dev/packages/test\_descriptor · `file` https://pub.dev/packages/file · https://api.dart.dev/stable/dart-io/Process-class.html · https://api.dart.dev/stable/dart-io/Directory/createTemp.html · https://dart.dev/tools/dart-compile
- Kualitas: `lints` https://pub.dev/packages/lints · `meta` https://pub.dev/packages/meta · ✔ `coverage` https://pub.dev/documentation/coverage/ · ✔ `mutation_test` https://pub.dev/packages/mutation\_test · https://pub.dev/documentation/mutation\_test/latest/ · ✔ `dart_mutant` https://pub.dev/packages/dart\_mutant · ✔ lcov https://github.com/linux-test-project/lcov
- CI dan alat: https://github.com/dart-lang/setup-dart · https://github.com/casey/just

**Konsep dan teori**

- Properti dan generator: https://en.wikipedia.org/wiki/QuickCheck · https://hypothesis.readthedocs.io/en/latest/ · Fuzzing: https://en.wikipedia.org/wiki/Fuzzing · Test oracle: https://en.wikipedia.org/wiki/Test\_oracle · Metamorphic testing: https://en.wikipedia.org/wiki/Metamorphic\_testing
- Test double dan mock: https://en.wikipedia.org/wiki/Test\_double · https://martinfowler.com/articles/mocksArentStubs.html
- Strategi: https://martinfowler.com/bliki/TestPyramid.html · https://martinfowler.com/bliki/SelfTestingCode.html · https://martinfowler.com/bliki/TestCoverage.html · https://martinfowler.com/articles/nonDeterminism.html
- Batas dan golden: https://martinfowler.com/bliki/ContractTest.html · http://xunitpatterns.com/Humble%20Object.html · https://approvaltests.com/ · Kode keluar `sysexits`: https://man.freebsd.org/cgi/man.cgi?query=sysexits
- Kontrak dan mutasi: https://en.wikipedia.org/wiki/Design\_by\_contract · https://en.wikipedia.org/wiki/Mutation\_testing · Keterlacakan: https://en.wikipedia.org/wiki/Traceability\_matrix

**Buku dan makalah (tanpa tautan)**

- F. Hebert, *Property-Based Testing with PropEr, Erlang, and Elixir* · J. Hughes, *How to Specify It!* (merumuskan properti yang baik).
- V. Khorikov, *Unit Testing Principles, Practices, and Patterns* · S. Freeman dan N. Pryce, *Growing Object-Oriented Software, Guided by Tests* · K. Beck, *Test-Driven Development: By Example*.
- B. Meyer, *Object-Oriented Software Construction* (design by contract) · G. Petrović dan M. Ivanković, *State of Mutation Testing at Google*.

---

*Fase 8 selesai. Fase berikutnya dibuka setelah kamu memberi konfirmasi siap dan menetapkan penomorannya.*
> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-7/README.md
[selanjutnya]: ../bagian-9/README.md

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

