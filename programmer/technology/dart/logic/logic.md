# Membangun Logika Dart — Kurikulum dari Fondasi hingga Expert/Enterprise

*Versi 1.0 · 10 November 2026 · Target Dart 3.13+ · Bahasa Indonesia (istilah teknis tetap Inggris) · Fokus: logika, bukan sintaks*

## 1. Ringkasan Eksekutif & Filosofi

Kurikulum ini tidak mengajarkan Dart. Ia mengajarkan **cara memutuskan dan merancang logika** dengan Dart. Prasyaratnya: dasar, OOP, dan materi advance sudah Anda kuasai. Di sini semua itu dipakai untuk satu tujuan: membangun logika yang **benar, aman, kuat, cepat, hemat sumber daya, dan mudah dirawat**, lalu memahami **apa dampaknya** ketika sebuah keputusan desain diambil dari sisi A, bukan sisi B.

**Enam sumbu penilaian logika** (dipakai di bagian *Dampak Desain* setiap modul):

1. **Kebenaran**: hasil sesuai maksud untuk semua input yang sah.
2. **Keamanan**: input hostile tidak bisa merusak, membocorkan, atau menguasai sistem.
3. **Ketahanan**: tetap berperilaku terukur saat gagal (timeout, data rusak, sumber daya habis).
4. **Kecepatan**: waktu eksekusi tumbuh wajar terhadap ukuran data.
5. **Efisiensi sumber daya**: memori, CPU, I/O, dan bandwidth dipakai seperlunya.
6. **Keterawatan**: orang lain (atau Anda enam bulan lagi) bisa memahami dan mengubahnya dengan aman.

Tidak ada desain yang menang di keenam sumbu sekaligus. Keahlian berarti tahu sumbu mana yang Anda korbankan, dan sadar akibatnya.

**Lima prinsip kerja** (selaras dengan lingkungan terminal-sentris dan keyboard-first):

- **Kontrol**: tahu persis apa yang terjadi; ukur, jangan menebak.
- **Isolasi**: batasi radius kerusakan (scope sempit, isolate, proses, sandbox OS).
- **Modularitas**: satu tanggung jawab, antarmuka kecil, ketergantungan eksplisit.
- **Abstraksi seperlunya**: abstraksi yang tidak mengurangi kompleksitas hanyalah beban.
- **Keadaan ilegal tak terwakili**: biarkan sistem tipe dan compiler yang menolak kesalahan.

**Dua proyek benang merah** dipakai di semua fase agar konsep saling menyambung (boleh diganti domain lain yang setara):

- `konversi_satuan`: logika angka, parsing, galat, presisi, ekstensibilitas.
- `katalog_perpustakaan`: logika state di dalam class, aturan bisnis, konkurensi, persistensi.

## 2. Cara Memakai Kurikulum Ini

Setiap modul memakai struktur tetap: **Level & Estimasi → 1 Deskripsi Konkret → 2 Konsep Dasar & Filosofi (+ Dampak Desain) → 3 Implementasi Inti → 4 Terminologi Kunci → 5 Daftar Isi → 6 Sumber Referensi → 7 Visualisasi → Latihan**.

- **Latihan tanpa kunci jawaban.** Yang diberikan adalah *kriteria penerimaan* (test yang harus hijau), bukan solusi. Kesulitan produktif adalah bagian dari metode.
- **Visualisasi** memakai diagram ASCII agar bisa dibaca di terminal dan disalin ke catatan Markdown. Untuk konsep yang rumit, bagian ini juga menyebut gambar apa yang sebaiknya Anda gambar sendiri.
- **Versi.** Semua contoh berasumsi `sdk: ^3.13.0`. Beberapa contoh memakai *primary constructors* (stabil sejak Dart 3.13); bila SDK Anda lebih lama, tulis ulang dengan constructor klasik, perilakunya identik.
- **Tautan.** Tautan dart.dev diambil dari navigasi situs resmi per 10 November 2026. Tautan paket pub.dev dan repositori sebaiknya dicek ulang sebelum dipakai karena paket bisa berubah atau dihentikan.

## 3. Prasyarat & Uji Kesiapan

**Prasyarat wajib:** materi Dart dasar, OOP, dan advance sudah selesai; nyaman memakai terminal, `git`, dan editor tanpa GUI berat.

**Uji kesiapan** (jawab tanpa membuka dokumentasi; bila dua butir atau lebih gagal, perkuat dulu dari [tur bahasa Dart](https://dart.dev/language)):

1. Jelaskan beda `final`, `const`, dan `late`, serta kapan masing-masing salah dipakai.
2. Jelaskan sound null safety dan peran `?`, `?.`, `??`, `!`.
3. Tulis class dengan constructor generative, factory, dan named, plus getter, setter, dan anggota `static`.
4. Jelaskan beda `extends`, `implements`, dan `with`.
5. Jelaskan `Future`, `async`/`await`, dan apa yang terjadi ketika `await` tercapai.
6. Pakai `List`, `Set`, `Map`, dan operasi `Iterable` (`map`, `where`, `fold`).
7. Pakai record, pattern, dan `sealed` pada level dasar.
8. Jalankan `dart create`, `dart run`, `dart test`, dan `git` penuh di terminal.

**Untuk pembelajar non-IT:** kurikulum ini sengaja tidak mengulang dasar Dart. Selesaikan dulu tur bahasa di atas; setelah itu setiap modul di sini dijelaskan dengan analogi sehari-hari dan istilahnya dirinci di bagian *Terminologi Kunci*.

## 4. Peta Jalan: Fase, Level & Estimasi Waktu

Asumsi beban 10 jam per minggu, total **±42 minggu (≈ 420 jam)**. Jalur cepat untuk yang sudah berpengalaman: kerjakan latihan akhir Fase 1 dan 2 sebagai *test-out*; bila lulus, lompati.

- **Fase 1 — Fondasi Berpikir Komputasional** · Pemula → Menengah · 4 minggu: spesifikasi, invarian, aliran kontrol, logika di dalam class, semantik data.
- **Fase 2 — Algoritma & Struktur Data Idiomatik** · Menengah · 4 minggu: kompleksitas, koleksi, rekursi, DP, graf.
- **Fase 3 — Pemodelan Domain & Logika Berbasis Tipe** · Menengah → Mahir · 4 minggu: sealed, pattern, record, null safety, error sebagai bagian logika.
- **Fase 4 — Komposisi Fungsional & Manajemen State** · Mahir · 3 minggu: evaluasi malas, imutabilitas, mesin keadaan.
- **Fase 5 — Asinkron & Konkurensi** · Mahir · 5 minggu: event loop, stream, race condition, isolate.
- **Fase 6 — Performa & Efisiensi Sumber Daya** · Mahir · 4 minggu: VM, AOT/JIT, pengukuran, alokasi, caching.
- **Fase 7 — Keamanan, Isolasi & Anonimitas** · Mahir → Expert · 4 minggu: ancaman, kriptografi, rantai pasok, sandbox.
- **Fase 8 — Kualitas & Verifikasi** · Mahir → Expert · 3 minggu: pengujian, analisis statis, kontrak.
- **Fase 9 — Arsitektur, Ketahanan & Interoperabilitas** · Expert/Enterprise · 5 minggu: modul, hexagonal, pola ketahanan, FFI/JS/Wasm.
- **Fase 10 — Capstone & Penguasaan** · Expert · 6 minggu: proyek puncak dan evaluasi diri.

## 5. Alat Esensial (Lab Terminal-Sentris)

- **Dart SDK ≥ 3.13.** Dokumentasi resmi merefleksikan Dart 3.13.7 (halaman yang diperiksa diperbarui 28 September 2026); seri 3.14 terpantau masih di channel beta/dev, jadi cek ulang halaman rilis sebelum memilih versi. Instal dari [dart.dev/get-dart](https://dart.dev/get-dart) dan kunci versinya di `pubspec.yaml`.
- **Editor modal + LSP** (helix/neovim): server bahasa sudah ada di SDK (`dart language-server`). Di helix, cek dukungan dengan `hx --health dart`.
- **Loop umpan balik cepat:** dua pane tmux, satu editor, satu `watchexec -e dart -- dart test` (atau `entr`).
- **Analisis & format:** `dart analyze --fatal-infos`, `dart format .`, `dart fix --apply`.
- **Ukur:** `package:benchmark_harness`, `hyperfine`, `/usr/bin/time -v`, dan `dart devtools`.
- **Isolasi OS:** `bwrap` (bubblewrap) dan `systemd-run --user --scope` untuk membatasi proses (Fase 7).
- **Privasi:** `dart --disable-telemetry` mematikan pelaporan telemetri Dart CLI.

```bash
dart create -t package konversi_satuan && cd konversi_satuan
dart pub add dev:test dev:lints
dart --disable-telemetry
watchexec -e dart -- dart test        # pane kedua: loop TDD
```

Mulai dari `analysis_options.yaml` yang ketat sejak hari pertama:

```yaml
include: package:lints/recommended.yaml
analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
linter:
  rules:
    - avoid_dynamic_calls
    - unawaited_futures
    - discarded_futures
    - cancel_subscriptions
    - close_sinks
    - only_throw_errors
    - avoid_catches_without_on_clauses
    - avoid_slow_async_io
    - avoid_js_rounded_ints
    - prefer_final_locals
```

Referensi: [Customizing static analysis](https://dart.dev/tools/analysis) · [Linter rules](https://dart.dev/tools/linter-rules) · [dart CLI](https://dart.dev/tools/dart-tool) · [Dart DevTools](https://dart.dev/tools/dart-devtools).

## 6. Metode Belajar Berbasis Psikologi Pembelajaran

Logika tidak dibangun dengan membaca, melainkan dengan **memutuskan, salah, dan memperbaiki**. Protokol tujuh langkah ini berlaku untuk setiap modul:

1. **Pernyataan tujuan (3 kalimat) sebelum mulai:** “Setelah modul ini saya bisa memutuskan \_\_\_ karena \_\_\_; saya tahu berhasil jika \_\_\_.” Ini memisahkan *belajar sintaks* dari *berpikir sebagai engineer*.
2. **Dokumentasi resmi dulu** (generation effect): baca, tutup, lalu tulis ulang konsepnya dengan kata sendiri.
3. **Prediksi sebelum menjalankan:** tulis hasil yang Anda harapkan. Selisih prediksi dan kenyataan adalah bahan belajar paling murni.
4. **Siklus Run → Error → Debug yang eksplisit:** tulis kode manual, jalankan, lalu catat setiap galat di *Jurnal Galat* (gejala, hipotesis, eksperimen, akar masalah, pelajaran). Minta bantuan AI hanya setelah hipotesis tertulis.
5. **Rekonstruksi tanpa melihat** (retrieval practice): satu hari kemudian, bangun ulang inti modul dari nol.
6. **Dorong ke GitHub dan review dengan konteks penuh:** commit catatan Markdown, kode, dan test. Saat review, buka konteks lengkap (tujuan, batasan, alternatif yang ditolak) agar masukan menyentuh arsitektur dan logika, bukan sekadar sintaks.
7. **Pengulangan berjarak:** jadwalkan ulang *tantangan* (bukan hafalan) pada H+3, H+7, H+21, dan H+60.

Catatan psikologis yang menjaga kualitas belajar:

- **Kesulitan produktif (desirable difficulty):** latihan sengaja tanpa kunci jawaban; beri diri 25 menit usaha sebelum mencari bantuan.
- **Interleaving:** setiap minggu sisipkan satu latihan dari fase sebelumnya agar ingatan tidak menguap.
- **Bias konfirmasi saat debugging:** tulis hipotesis yang *bisa dibuktikan salah* dan ubah satu variabel per eksperimen.
- **Beban kognitif:** maksimal dua konsep baru per sesi; blok fokus 50 menit lalu jeda 10 menit; tidur cukup adalah bagian dari kurikulum.
- **Disiplin:** jadwal tetap tanpa tawar-menawar dengan diri sendiri. Ukuran kemajuan adalah *keputusan desain yang bisa Anda pertahankan*, bukan jumlah halaman yang dibaca.

## [Fase 1 — Fondasi Berpikir Komputasional (Foundation)][1]

**Level:** Pemula → Menengah · **Estimasi:** 4 minggu (≈ 40 jam) · **Tujuan fase:** berpikir dari masalah → spesifikasi → invarian → kode; menaruh logika di tempat yang tepat; mengenali jebakan semantik data.

### Modul 1.1 — Dekomposisi Masalah, Spesifikasi & Invarian

**Level:** Pemula · **Estimasi:** 8–10 jam

**1. Deskripsi Konkret.** Mengubah masalah yang samar (“konversi satuan”) menjadi spesifikasi yang bisa diuji: input, output, prakondisi, pascakondisi, dan invarian. Lalu memecahnya menjadi fungsi kecil yang masing-masing bisa dijelaskan dalam satu kalimat.

**2. Konsep Dasar & Filosofi.** Kode adalah *bukti* bahwa Anda memahami masalah, jadi spesifikasi ditulis lebih dulu. *Prakondisi* adalah janji pemanggil (“faktor > 0”); *pascakondisi* adalah janji fungsi (“konversi balik mendekati nilai awal”); *invarian* adalah kalimat yang selalu benar sepanjang hidup sebuah objek atau loop. Dekomposisi berhenti ketika tiap potongan hanya punya satu alasan untuk berubah.

**Dampak Desain:**

- Spesifikasi dilewati → bug “benar secara sintaks, salah secara maksud” baru ketahuan di produksi (biaya tertinggi).
- Prakondisi dicek di setiap lapisan → kode berulang dan lebih lambat; dicek sekali di batas sistem (Modul 7.1) → cepat dan jelas tanggung jawabnya.
- Fungsi terlalu besar → tidak bisa diuji sebagian; terlalu banyak yang terlalu kecil → logika tercecer dan sulit ditelusuri.

**3. Implementasi Inti.**

```dart
/// Prakondisi  : [faktor] finite dan > 0.
/// Pascakondisi: hasil = nilai * faktor; konversi balik mendekati nilai awal.
/// Invarian    : hasil bukan NaN untuk nilai finite.
double konversi(double nilai, {required double faktor}) {
  if (!faktor.isFinite || faktor <= 0) {
    throw ArgumentError.value(faktor, 'faktor', 'harus finite dan > 0');
  }
  return nilai * faktor;
}

void main() {
  const meterPerKm = 1000.0;
  final m = konversi(5, faktor: meterPerKm);
  final km = konversi(m, faktor: 1 / meterPerKm);
  print('$m m -> $km km'); // 5000.0 m -> 5.0 km
}
```

Validasi memakai `throw`, bukan `assert`: `assert` hanya aktif pada mode tertentu (dibahas di Modul 8.2).

**4. Terminologi Kunci.**

- **Spesifikasi:** deskripsi tepat tentang *apa* yang harus dilakukan program, bukan *bagaimana*.
- **Prakondisi / pascakondisi:** syarat sebelum fungsi dipanggil / jaminan setelah selesai. Seperti perjanjian sewa: penyewa menjaga kondisi, pemilik menjamin fasilitas.
- **Invarian:** pernyataan yang tidak boleh pernah salah (misal “stok tidak negatif”).
- **Dekomposisi:** memecah masalah besar menjadi bagian kecil yang bisa dipahami sendiri-sendiri.
- **Kasus tepi (edge case):** nilai di batas atau tak lazim: 0, kosong, maksimum, negatif, `NaN`.
- **Kriteria penerimaan:** daftar uji yang, bila semuanya lulus, berarti pekerjaan dianggap selesai.

**5. Daftar Isi.** Dari masalah ke spesifikasi · Prakondisi dan pascakondisi · Invarian objek dan loop · Strategi dekomposisi · Tabel kasus tepi · Menulis test sebelum kode.

**6. Sumber Referensi.**

- Effective Dart: Design — https://dart.dev/effective-dart/design
- Error handling (bahasa Dart) — https://dart.dev/language/error-handling
- `ArgumentError` — https://api.dart.dev/dart-core/ArgumentError-class.html
- `package:test` — https://pub.dev/packages/test

**7. Visualisasi.**

```text
Masalah samar
   |
   v
Spesifikasi (prakondisi, pascakondisi, invarian)
   |
   v
Kriteria penerimaan = TEST (merah dulu)
   |
   v
Kode minimal (hijau) --> refaktor --> ulangi
```

**Latihan (tanpa kunci jawaban).** Tulis spesifikasi lima baris dan minimal delapan test kasus tepi untuk `konversi_satuan` (0, negatif, `NaN`, `infinity`, faktor 0, nilai sangat besar) *sebelum* menulis implementasi. *Kriteria penerimaan:* semua test merah lebih dulu, lalu hijau tanpa mengubah test.

### Modul 1.2 — Logika Boolean, Aliran Kontrol & Guard Clause

**Level:** Pemula · **Estimasi:** 8–10 jam

**1. Deskripsi Konkret.** Menyusun keputusan (`if`, `switch`, ekspresi boolean) agar jelas, *total* (semua kemungkinan tertangani), dan murah dieksekusi.

**2. Konsep Dasar & Filosofi.** Dart hanya menerima `bool` sungguhan pada kondisi, tanpa “truthiness”, sehingga niat harus eksplisit. Evaluasi hubung-singkat (`&&`, `||`) menjadikan *urutan* kondisi bagian dari logika: pengecekan yang murah dan yang melindungi (misal `isNotEmpty`) ditaruh lebih dulu. *Guard clause* menolak kasus buruk di awal sehingga jalur utama tidak bersarang. `switch` expression pada enum atau sealed class menjadi *total function*: compiler menolak kasus yang terlupa. Hindari *boolean blindness*: argumen `true`/`false` tanpa nama tidak menjelaskan maksud, jadi pakai enum atau parameter bernama.

**Dampak Desain:**

- Bersarang dalam → jalur sulit ditelusuri dan test sulit menjangkau semua cabang.
- `else` terakhir yang “menampung semua” → kasus baru diam-diam jatuh ke jalur yang salah; `switch` yang exhaustive membuat compiler yang protes.
- Urutan kondisi salah → crash (`first` pada list kosong) atau kerja mahal yang sia-sia.

**3. Implementasi Inti.**

```dart
enum KategoriAnggota { reguler, mahasiswa, staf }

/// Total function: setiap (kategori, hari) punya jawaban terdefinisi.
int totalDenda(KategoriAnggota kategori, {required int hariTerlambat}) {
  if (hariTerlambat < 0) throw RangeError.value(hariTerlambat, 'hariTerlambat');
  if (hariTerlambat == 0) return 0; // guard: kasus tersering keluar lebih awal

  final tarifPerHari = switch (kategori) {
    KategoriAnggota.reguler => 1000,
    KategoriAnggota.mahasiswa => 500,
    KategoriAnggota.staf => 0,
  };
  return tarifPerHari * hariTerlambat;
}
```

Tambahkan satu nilai enum baru (misal `lansia`) dan compiler langsung menandai `switch` yang belum lengkap.

**4. Terminologi Kunci.**

- **Boolean:** nilai benar/salah (`true`/`false`). Dart tidak menganggap angka atau teks sebagai “benar”.
- **Short-circuit (hubung-singkat):** `a && b` tidak mengevaluasi `b` bila `a` sudah salah, seperti satpam yang berhenti memeriksa begitu ID terbukti tidak valid.
- **Guard clause:** pengecekan di awal yang langsung keluar bila syarat tidak terpenuhi.
- **Total function:** fungsi yang punya hasil untuk setiap input yang mungkin.
- **Exhaustive:** setiap kemungkinan nilai atau tipe tertangani, diverifikasi compiler.
- **Hukum De Morgan:** `!(a && b)` ekuivalen dengan `!a || !b`; berguna untuk menyederhanakan kondisi.
- **Kompleksitas siklomatik:** jumlah jalur independen dalam kode; makin tinggi, makin banyak test yang dibutuhkan.

**5. Daftar Isi.** Ekspresi boolean dan De Morgan · Short-circuit dan urutan kondisi · Guard clause dan early return · Switch expression dan exhaustiveness · Menghindari boolean blindness · Menghitung jalur eksekusi.

**6. Sumber Referensi.**

- Branches (`if`, `switch`, `if-case`) — https://dart.dev/language/branches
- Operators — https://dart.dev/language/operators
- Effective Dart: Usage — https://dart.dev/effective-dart/usage
- Linter rules — https://dart.dev/tools/linter-rules

**7. Visualisasi.**

```text
masuk
 |-- hari < 0 ? ------------> RangeError      (guard 1)
 |-- hari == 0 ? -----------> 0               (guard 2)
 '-- switch(kategori)
       |-- reguler ---------> 1000 * hari
       |-- mahasiswa -------> 500 * hari
       '-- staf ------------> 0
```

**Latihan (tanpa kunci jawaban).** Tulis sendiri fungsi keputusan bersarang empat tingkat dari aturan denda berjenjang, refaktor menjadi guard clause, lalu buktikan perilaku identik dengan test tabel berisi minimal 12 baris. *Kriteria penerimaan:* semua cabang tercakup test (Modul 8.2 menunjukkan cara mengukurnya).

### Modul 1.3 — Logika di Dalam Class: Tempat Menaruh & Jalur Memanggil

**Level:** Pemula → Menengah · **Estimasi:** 10–12 jam

**1. Deskripsi Konkret.** Memetakan dengan jelas *di mana* sebuah logika sebaiknya ditulis (constructor, method, getter, factory, static, fungsi top-level, extension) dan *lewat jalur mana* ia dipanggil (instance, static, tear-off, callback, `call()`, operator, event). Lalu menelusurinya dengan `StackTrace.current` dan debugger sampai logika di dalam class berhenti terasa “ajaib”.

**2. Konsep Dasar & Filosofi.** Class adalah *pemilik state sekaligus aturan yang menjaga state itu*. Pertanyaan penentu tempat: “Apakah logika ini butuh state objek? Apakah ia menjaga invarian objek?” Bila ya, taruh di method, getter, atau constructor. Bila hanya mengubah input menjadi output tanpa state, jadikan fungsi murni (top-level atau `static`). Untuk setiap logika Anda harus bisa menjawab tiga hal: **siapa pemilik datanya**, **siapa yang boleh mengubahnya**, dan **siapa yang memanggilnya serta kapan**. Menggambar *call graph* (peta siapa-memanggil-siapa) adalah keterampilan inti di sini.

**Dampak Desain:**

- Logika penjaga invarian ditaruh di luar class → siapa pun bisa melanggarnya dan state invalid lolos.
- Semua logika ditumpuk di satu class “serba bisa” → sulit diuji dan berubah dengan banyak alasan.
- `static` atau top-level untuk logika yang butuh state → state global tersembunyi, test saling mengganggu.
- Method yang bergantung pada urutan pemanggilan → bug temporal (“harus panggil `init()` dulu”).

**3. Implementasi Inti.**

```dart
class Pinjaman(
  final String isbn,
  final String idAnggota,
  final DateTime jatuhTempo,
) {
  DateTime? _dikembalikanPada; // state privat: hanya class ini yang boleh mengubah

  // getter: turunan state, tanpa efek samping
  bool get sudahKembali => _dikembalikanPada != null;

  // method: mengubah state sambil menjaga invarian
  void kembalikan(DateTime pada) {
    if (sudahKembali) throw StateError('Pinjaman sudah dikembalikan');
    _dikembalikanPada = pada;
  }

  int hariTerlambat(DateTime sekarang) {
    final akhir = _dikembalikanPada ?? sekarang;
    final selisih = akhir.difference(jatuhTempo).inDays;
    return selisih > 0 ? selisih : 0;
  }

  // factory: jalur pembuatan alternatif dengan aturan sendiri
  factory Pinjaman.standar(String isbn, String idAnggota, DateTime mulai) =>
      Pinjaman(isbn, idAnggota, mulai.add(const Duration(days: 14)));

  // static: tidak menyentuh state objek
  static final _pola = RegExp(r'^\d{13}$');
  static bool isbnValid(String s) => _pola.hasMatch(s);
}

void main() {
  final p = Pinjaman.standar('9786020333175', 'A-01', DateTime.utc(2026, 11, 1));
  p.kembalikan(DateTime.utc(2026, 11, 20));         // 1) method instance
  final f = p.hariTerlambat;                        // 2) tear-off: method sebagai nilai
  print(f(DateTime.utc(2026, 11, 30)));             // 3) 5 (sudah kembali, parameter tak dipakai)
  print(Pinjaman.isbnValid('9786020333175'));       // 4) static lewat nama class -> true
  print([p].map((x) => x.sudahKembali).toList());   // 5) callback dipanggil Iterable -> [true]
}
```

Untuk melihat siapa yang memanggil sebuah method, sisipkan `print(StackTrace.current);` di dalamnya lalu jalankan. Waktu dihitung dalam UTC agar selisih hari tidak dipengaruhi zona waktu (Modul 1.4).

**4. Terminologi Kunci.**

- **State (keadaan):** data yang berubah selama objek hidup.
- **Invarian kelas:** aturan yang harus tetap benar sebelum dan sesudah setiap method publik selesai.
- **Enkapsulasi:** menyembunyikan state (`_privat`) agar perubahan hanya lewat method yang menjaga aturan.
- **Tear-off:** memperlakukan method sebagai nilai (`p.hariTerlambat` tanpa tanda kurung) agar bisa dipanggil nanti.
- **Callback:** fungsi yang diserahkan agar dipanggil pihak lain pada waktunya (inversion of control).
- **Call graph:** peta siapa memanggil siapa; dasar untuk melacak bug dan menilai ketergantungan.
- **Factory constructor:** constructor yang boleh memilih atau menyiapkan objek dengan aturannya sendiri.
- **Primary constructor:** sintaks ringkas Dart 3.13 yang mendeklarasikan field dan constructor utama di header class.

**5. Daftar Isi.** Pertanyaan penentu tempat logika · Constructor, factory, dan inisialisasi · Method, getter, dan fungsi murni · `static`, top-level, dan extension · Jalur pemanggilan: instance, tear-off, callback, `call()`, operator · Primary constructors dan blok `this :` · Menelusuri call graph (`StackTrace.current`, debugger).

**6. Sumber Referensi.**

- Classes — https://dart.dev/language/classes
- Constructors — https://dart.dev/language/constructors
- Primary constructors (Dart 3.13) — https://dart.dev/language/primary-constructors
- Methods — https://dart.dev/language/methods
- Callable objects — https://dart.dev/language/callable-objects
- Dart DevTools (debugger) — https://dart.dev/tools/dart-devtools

**7. Visualisasi.** Gambar visual yang direkomendasikan: *call graph* hasil gambar tangan untuk tiga skenario. Kerangkanya:

```text
main()
 |-- Pinjaman.standar()  --> Pinjaman(isbn, id, jatuhTempo)   [factory -> constructor utama]
 |-- p.kembalikan()      --> mengubah _dikembalikanPada       [method: mengubah state]
 |-- p.hariTerlambat     --> dibaca sebagai nilai (tear-off)  [dipanggil nanti lewat f(...)]
 |-- Pinjaman.isbnValid  --> tidak menyentuh state objek      [static]
 '-- [p].map(callback)   --> Iterable memanggil callback      [inversion of control]
```

**Latihan (tanpa kunci jawaban).** Tambahkan `perpanjang()` dengan aturan: maksimal dua kali, tidak boleh bila sudah terlambat, tidak boleh setelah dikembalikan. Gambar *call graph* untuk tiga skenario. *Kriteria penerimaan:* test yang mencoba melanggar invarian dari luar class (memperpanjang tiga kali, memperpanjang setelah kembali) semuanya gagal secara terkendali dengan `StateError`.

### Modul 1.4 — Semantik Data yang Menentukan Kebenaran: Angka, Teks & Waktu

**Level:** Menengah · **Estimasi:** 10–12 jam

**1. Deskripsi Konkret.** Menyadari bahwa logika yang benar di atas representasi data yang keliru tetap menghasilkan jawaban salah: `int` 64-bit di VM versus presisi 53-bit di web, perilaku `double` (`0.1 + 0.2`, `NaN`, `-0.0`), teks sebagai unit UTF-16 versus karakter yang dilihat manusia, serta waktu (UTC, zona, DST).

**2. Konsep Dasar & Filosofi.** Setiap tipe data adalah *kontrak sempit* tentang apa yang bisa direpresentasikan. Di VM dan AOT, `int` adalah bilangan bulat 64-bit bertanda; saat dikompilasi ke JavaScript, `int` adalah `double` tanpa pecahan sehingga presisinya hilang di atas 2^53 dan operator bitwise bekerja pada 32-bit. `double` mengikuti IEEE 754: `0.1 + 0.2 != 0.3` dan `NaN != NaN`. `String` adalah urutan unit kode UTF-16, bukan “karakter” yang dilihat manusia (emoji dan huruf beraksen gabungan memakai banyak unit). `DateTime` lokal dipengaruhi zona waktu dan DST sehingga “14 hari” belum tentu 14 × 24 jam.

**Dampak Desain:**

- Uang atau jumlah presisi disimpan sebagai `double` → galat pembulatan menumpuk; simpan dalam satuan terkecil (bilangan bulat) atau rasional.
- Target web diabaikan → ID 64-bit terpotong diam-diam; pilih tipe yang tepat (`BigInt`, `String`) atau jadikan web sebagai batas desain yang eksplisit.
- Panjang teks diukur dengan `.length` → batas “20 karakter” salah untuk emoji; ukur grapheme.
- Waktu disimpan lokal → arti data berbeda di server lain; simpan UTC, tampilkan lokal.

**3. Implementasi Inti.**

```dart
import 'dart:math' as math;
import 'package:characters/characters.dart'; // dart pub add characters

void main() {
  // double: jangan bandingkan dengan ==
  print(0.1 + 0.2 == 0.3);                   // false
  print(((0.1 + 0.2) - 0.3).abs() < 1e-12);  // true  (pakai toleransi)
  print(double.nan == double.nan);           // false (pakai .isNaN)

  // int: 64-bit di VM, presisi 53-bit di web
  print(math.pow(2, 53) + 1);   // VM: 9007199254740993 | web: 9007199254740992
  print(BigInt.from(2).pow(64)); // 18446744073709551616 (aman di semua target)

  // Teks: length menghitung unit UTF-16, bukan karakter manusia
  const keluarga = '\u{1F468}\u200D\u{1F469}\u200D\u{1F467}'; // tampak seperti 1 emoji
  print(keluarga.length);            // 8
  print(keluarga.characters.length); // 1 (grapheme cluster)

  // Waktu: hitung dalam UTC
  print(DateTime.utc(2026, 11, 1).add(const Duration(days: 14))); // 2026-11-15 00:00:00.000Z
}
```

**4. Terminologi Kunci.**

- **IEEE 754:** standar bilangan pecahan biner yang dipakai `double`; sebagian bilangan desimal (misal 0,1) tidak bisa disimpan persis.
- **NaN:** “bukan angka”, hasil operasi tak terdefinisi (misal 0/0); tidak sama dengan apa pun, termasuk dirinya sendiri.
- **Overflow:** hasil melebihi kapasitas tipe; pada `int` native nilainya “berputar” (wrap-around).
- **BigInt:** bilangan bulat tanpa batas ukuran; aman, tetapi lebih lambat dan lebih boros memori.
- **UTF-16 code unit:** potongan 16-bit penyusun `String` Dart; satu “karakter” bisa terdiri dari beberapa potongan.
- **Grapheme cluster:** satuan teks sebagaimana tampak oleh manusia.
- **UTC / DST:** UTC adalah waktu acuan tanpa zona dan tanpa pergeseran musiman; DST (daylight saving time) membuat sehari kadang 23 atau 25 jam.

**5. Daftar Isi.** `int` native versus web · `double` dan toleransi · `BigInt`, `fixnum`, dan satuan terkecil · Teks: UTF-16, runes, grapheme · Waktu: UTC, zona, DST, `Duration` · Lint `avoid_js_rounded_ints`.

**6. Sumber Referensi.**

- Number representation — https://dart.dev/resources/language/number-representation
- Built-in types — https://dart.dev/language/built-in-types
- Lint `avoid_js_rounded_ints` — https://dart.dev/tools/diagnostics/avoid\_js\_rounded\_ints
- `DateTime` — https://api.dart.dev/dart-core/DateTime-class.html
- `package:characters` — https://pub.dev/packages/characters
- `package:fixnum` — https://pub.dev/packages/fixnum

**7. Visualisasi.**

```text
Target      int                      double        operator bitwise
VM / AOT    64-bit bertanda (wrap)   64-bit IEEE   64-bit
Web (JS)    double tanpa pecahan     64-bit IEEE   dipotong ke 32-bit
            (presisi aman <= 2^53)
```

**Latihan (tanpa kunci jawaban).** Implementasikan `konversi_satuan` tanpa `double` untuk faktor yang pasti (km, m, cm) memakai bilangan bulat satuan terkecil atau rasional (`BigInt` pembilang dan penyebut). *Kriteria penerimaan:* konversi bolak-balik *tepat* (bukan sekadar hampir) untuk 10.000 nilai acak dengan seed tetap; lulus pada `dart test` di VM (platform web opsional: `dart test -p chrome`).

## [Fase 2 — Algoritma & Struktur Data Idiomatik][2]

**Level:** Menengah · **Estimasi:** 4 minggu (≈ 40 jam) · **Tujuan fase:** memilih struktur data dan algoritma berdasarkan biaya yang terukur, bukan kebiasaan.

### Modul 2.1 — Kompleksitas & Memilih Koleksi

**Level:** Menengah · **Estimasi:** 12–14 jam

**1. Deskripsi Konkret.** Menaksir biaya waktu dan memori sebuah logika (notasi Big-O, amortisasi), lalu memilih `List`, `Set`, `Map`, `Queue`, `SplayTreeMap`, atau `PriorityQueue` berdasarkan operasi yang paling sering dilakukan.

**2. Konsep Dasar & Filosofi.** Pilihan koleksi adalah keputusan logika, bukan kosmetik. `List` unggul untuk akses indeks dan iterasi berurutan, tetapi `contains` memeriksa elemen satu per satu (O(n)). `Set` dan `Map` memakai hash sehingga pencarian rata-rata O(1), dengan syarat `==` dan `hashCode` konsisten dan kunci tidak berubah setelah dimasukkan. `SplayTreeMap` menjaga kunci terurut (O(log n) teramortisasi). `PriorityQueue` mengambil elemen terprioritas tanpa mengurutkan seluruh data. Literal `{}` menghasilkan `LinkedHashMap` atau `LinkedHashSet` yang mengingat urutan sisip.

**Dampak Desain:**

- `List.contains` di dalam loop → O(n²) tersembunyi; ganti dengan `Set` yang dibangun sekali.
- Objek sebagai kunci tanpa `==`/`hashCode` yang benar → pencarian gagal diam-diam; kunci yang bermutasi → entri seolah “hilang”.
- `List.sort` tidak dijamin stabil → urutan elemen berkunci sama bisa berubah; gunakan `mergeSort` dari `package:collection` bila stabilitas penting.
- Hash lebih cepat tetapi tidak terurut; pohon terurut tetapi lebih lambat per operasi: pilih berdasarkan kebutuhan urutan.

**3. Implementasi Inti.**

```dart
import 'dart:collection';
import 'package:collection/collection.dart';

void main() {
  final isbnList = List.generate(100000, (i) => 'ISBN-$i');
  final isbnSet = isbnList.toSet();

  print(isbnList.contains('ISBN-99999')); // O(n): memeriksa berurutan
  print(isbnSet.contains('ISBN-99999'));  // O(1) rata-rata: lewat hash

  // Terurut: SplayTreeMap menjaga kunci tetap berurutan
  final jatuhTempo = SplayTreeMap<DateTime, String>()
    ..[DateTime.utc(2026, 11, 20)] = 'B-02'
    ..[DateTime.utc(2026, 11, 15)] = 'A-01';
  print(jatuhTempo.firstKey()); // 2026-11-15 00:00:00.000Z

  // Prioritas: ambil yang paling mendesak tanpa mengurutkan semuanya
  final antrean = PriorityQueue<int>((a, b) => a.compareTo(b))..addAll([5, 1, 3]);
  print(antrean.removeFirst()); // 1
}
```

**4. Terminologi Kunci.**

- **Big-O:** cara menyatakan bagaimana biaya tumbuh seiring ukuran data (O(1) tetap, O(log n) naik lambat, O(n) sebanding, O(n²) cepat membengkak).
- **Amortisasi:** biaya rata-rata per operasi dalam rentetan panjang, meski sesekali ada operasi mahal (misal `List` melipatgandakan kapasitas).
- **Hash / `hashCode`:** angka ringkasan sebuah objek yang dipakai `Set` dan `Map` untuk melompat langsung ke lokasi penyimpanan.
- **Kontrak `==`/`hashCode`:** dua objek yang sama menurut `==` wajib punya `hashCode` sama.
- **Sort stabil:** elemen berkunci sama mempertahankan urutan semula.
- **Heap:** struktur pohon yang elemen teratasnya selalu yang berprioritas tertinggi; dasar `PriorityQueue`.

**5. Daftar Isi.** Big-O dan amortisasi · `List` vs `Set` vs `Map` · Kontrak `==`/`hashCode` dan kunci mutabel · `SplayTreeMap`, `Queue`, `PriorityQueue` · Stabilitas sort · Memilih berdasarkan operasi dominan.

**6. Sumber Referensi.**

- Collections — https://dart.dev/language/collections
- Iterable collections — https://dart.dev/libraries/collections/iterables
- `dart:collection` — https://api.dart.dev/dart-collection
- `package:collection` — https://pub.dev/packages/collection

**7. Visualisasi.**

```text
Operasi dominan?          Pilihan               Biaya tipikal
cari berdasarkan kunci    Map / Set (hash)      O(1) rata-rata
urut berdasarkan kunci    SplayTreeMap / Set    O(log n)
ambil terkecil/terbesar   PriorityQueue         O(log n) per ambil
antre FIFO                Queue (ListQueue)     O(1) di ujung
akses indeks              List                  O(1)
```

**Latihan (tanpa kunci jawaban).** Bangun indeks `katalog_perpustakaan` (cari berdasarkan ISBN, daftar terurut menurut jatuh tempo, 10 pinjaman paling terlambat) dengan koleksi berbeda untuk tiap kueri. *Kriteria penerimaan:* ukur tiga pilihan koleksi untuk 100.000 data dan tulis satu paragraf yang menjelaskan selisihnya dengan angka (teknik ukur ada di Modul 6.2).

### Modul 2.2 — Rekursi, Iterasi, Memoization & Pemrograman Dinamis

**Level:** Menengah · **Estimasi:** 12–14 jam

**1. Deskripsi Konkret.** Memecah masalah menjadi submasalah yang berulang, lalu memilih antara rekursi, iterasi dengan stack eksplisit, memoization, dan tabel DP, sambil menjaga kedalaman stack dan memori.

**2. Konsep Dasar & Filosofi.** Rekursi mengungkapkan struktur masalah dengan jelas, tetapi setiap panggilan memakai ruang stack, dan Dart tidak melakukan optimasi tail call; rekursi yang terlalu dalam berakhir `StackOverflowError`. Bila submasalah yang sama dihitung berulang, simpan hasilnya (*memoization*, top-down) atau isi tabel dari kasus terkecil (*DP*, bottom-up). DP bottom-up sering membuka ruang optimasi memori karena hanya baris sebelumnya yang dibutuhkan.

**Dampak Desain:**

- Rekursi naif pada submasalah tumpang-tindih → waktu eksponensial; memoization menurunkannya menjadi polinomial dengan harga memori.
- Memoization rekursif lewat `Map.putIfAbsent` yang memodifikasi map yang sama di dalam callback dapat memicu `ConcurrentModificationError`; pakai pola cek-simpan eksplisit dan uji di SDK Anda.
- Rekursi dalam → crash; ubah ke iterasi dengan `List` sebagai stack.
- DP tabel penuh (n × m) → memori O(n·m); dua baris → O(m) dengan hasil sama.

**3. Implementasi Inti.**

```dart
import 'dart:math' as math;

/// Jarak Levenshtein (pencarian nama satuan yang toleran typo).
/// DP dua baris: waktu O(n*m), memori O(m), bukan tabel penuh.
int jarakEdit(String a, String b) {
  var sebelum = List<int>.generate(b.length + 1, (j) => j);
  for (var i = 1; i <= a.length; i++) {
    final kini = List<int>.filled(b.length + 1, 0);
    kini[0] = i;
    for (var j = 1; j <= b.length; j++) {
      final biaya = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
      kini[j] = math.min(
        math.min(sebelum[j] + 1, kini[j - 1] + 1),
        sebelum[j - 1] + biaya,
      );
    }
    sebelum = kini;
  }
  return sebelum[b.length];
}

/// Memoization eksplisit: cek, hitung, simpan (hindari putIfAbsent rekursif).
BigInt fib(int n, [Map<int, BigInt>? memo]) {
  final m = memo ?? <int, BigInt>{};
  if (n < 2) return BigInt.from(n);
  final hit = m[n];
  if (hit != null) return hit;
  return m[n] = fib(n - 1, m) + fib(n - 2, m);
}

void main() {
  print(jarakEdit('kilometre', 'kilometer')); // 2
  print(fib(90));                             // 2880067194370816120
}
```

**4. Terminologi Kunci.**

- **Rekursi:** fungsi yang memanggil dirinya sendiri untuk submasalah yang lebih kecil.
- **Stack (tumpukan panggilan):** area memori yang mencatat fungsi-fungsi yang sedang berjalan; ukurannya terbatas.
- **Tail call optimization:** teknik sebagian bahasa yang membuat rekursi ekor tidak memakai stack baru; **tidak tersedia di Dart**.
- **Memoization:** menyimpan hasil pemanggilan fungsi agar tidak dihitung ulang untuk argumen yang sama.
- **Pemrograman dinamis (DP):** menyelesaikan masalah dengan menyusun hasil submasalah dari kecil ke besar dan menyimpannya.
- **Submasalah tumpang-tindih:** submasalah yang sama muncul berulang kali dalam pohon rekursi.

**5. Daftar Isi.** Rekursi dan pohon panggilan · Kedalaman stack dan `StackOverflowError` · Iterasi dengan stack eksplisit · Memoization top-down · DP bottom-up dan optimasi memori · Menimbang waktu versus memori.

**6. Sumber Referensi.**

- Functions — https://dart.dev/language/functions
- Loops — https://dart.dev/language/loops
- `Map` — https://api.dart.dev/dart-core/Map-class.html
- `StackOverflowError` — https://api.dart.dev/dart-core/StackOverflowError-class.html

**7. Visualisasi.**

```text
fib(5) tanpa memo
  fib(5)
   |-- fib(4)
   |    |-- fib(3)
   |    |    |-- fib(2)
   |    |    '-- fib(1)
   |    '-- fib(2)
   '-- fib(3)          <- dihitung ulang dari nol
        |-- fib(2)
        '-- fib(1)

Dengan memo: fib(3) kedua langsung diambil dari tabel (tiap n dihitung sekali).
```

**Latihan (tanpa kunci jawaban).** Tulis tiga solusi (rekursi naif, memoization, DP dua baris) untuk menghitung banyaknya cara membayar denda sebesar N rupiah dengan pecahan 500, 1.000, dan 2.000. *Kriteria penerimaan:* ketiganya memberi jawaban identik untuk N sampai 20.000; ukur waktu dan memori ketiganya, lalu tulis kapan masing-masing layak dipakai.

### Modul 2.3 — Graf, Pencarian & Penjadwalan

**Level:** Menengah → Mahir · **Estimasi:** 12–14 jam

**1. Deskripsi Konkret.** Memodelkan hubungan (satuan yang bisa saling dikonversi, tugas yang saling bergantung) sebagai graf, lalu mencari jalur, memeriksa siklus, dan menentukan urutan eksekusi yang valid.

**2. Konsep Dasar & Filosofi.** Banyak masalah “rumit” sebenarnya graf: simpul (entitas) dan sisi (hubungan). *BFS* menemukan jalur dengan sisi paling sedikit; *DFS* cocok untuk eksplorasi dan deteksi siklus; *Dijkstra* (dengan `PriorityQueue`) menemukan jalur berbiaya terkecil bila bobot tidak negatif; *topological sort* menentukan urutan yang menghormati ketergantungan sekaligus mendeteksi siklus. Representasi graf (daftar ketetanggaan versus matriks) menentukan biaya memori dan kecepatan kueri.

**Dampak Desain:**

- Daftar ketetanggaan → hemat memori untuk graf jarang (sparse); matriks → cek sisi O(1) tetapi memori O(V²).
- Lupa mencatat simpul yang sudah dikunjungi → loop tak berujung pada graf bersiklus.
- BFS dipakai untuk graf berbobot → jalur “terpendek” menurut jumlah sisi, bukan biaya; pakai Dijkstra.
- Ketergantungan melingkar tidak dideteksi → proses menggantung; topological sort melaporkannya sejak awal.

**3. Implementasi Inti.**

```dart
import 'dart:collection';

/// BFS: jalur dengan sisi paling sedikit antar satuan, atau null bila tak terhubung.
List<String>? jalurKonversi(
  Map<String, List<String>> graf,
  String dari,
  String ke,
) {
  final induk = <String, String?>{dari: null}; // sekaligus penanda sudah dikunjungi
  final antre = Queue<String>()..add(dari);
  while (antre.isNotEmpty) {
    final kini = antre.removeFirst();
    if (kini == ke) {
      final hasil = <String>[];
      for (String? n = ke; n != null; n = induk[n]) {
        hasil.add(n);
      }
      return hasil.reversed.toList();
    }
    for (final tetangga in graf[kini] ?? const <String>[]) {
      if (induk.containsKey(tetangga)) continue;
      induk[tetangga] = kini;
      antre.add(tetangga);
    }
  }
  return null;
}

void main() {
  final graf = {
    'km': ['m'],
    'm': ['cm', 'mil'],
    'cm': ['mm'],
  };
  print(jalurKonversi(graf, 'km', 'mm')); // [km, m, cm, mm]
}
```

**4. Terminologi Kunci.**

- **Graf:** kumpulan simpul (titik) yang dihubungkan sisi (garis); bisa berarah atau tak berarah.
- **BFS (breadth-first search):** menjelajah lapis demi lapis dari titik awal; menemukan jalur dengan sisi paling sedikit.
- **DFS (depth-first search):** menjelajah sedalam mungkin lebih dulu, baru mundur; cocok untuk deteksi siklus.
- **Dijkstra:** algoritma jalur berbiaya terkecil pada graf berbobot non-negatif.
- **Topological sort:** urutan simpul sehingga tiap simpul muncul setelah semua prasyaratnya; hanya ada bila tidak ada siklus.
- **Siklus:** jalur yang kembali ke titik awalnya; pada ketergantungan berarti kebuntuan logika.
- **Sparse / dense:** graf dengan sedikit / banyak sisi dibanding jumlah simpul.

**5. Daftar Isi.** Memodelkan masalah sebagai graf · Daftar ketetanggaan vs matriks · BFS dan rekonstruksi jalur · DFS dan deteksi siklus · Dijkstra dengan `PriorityQueue` · Topological sort (algoritma Kahn).

**6. Sumber Referensi.**

- `dart:collection` (`Queue`) — https://api.dart.dev/dart-collection
- `package:collection` (`PriorityQueue`) — https://pub.dev/packages/collection
- Collections — https://dart.dev/language/collections

**7. Visualisasi.**

```text
km --> m --> cm --> mm
       '--> mil

BFS dari km:  lapis 0: km | lapis 1: m | lapis 2: cm, mil | lapis 3: mm
Jalur ditemukan lewat peta induk: mm <- cm <- m <- km  => [km, m, cm, mm]
```

**Latihan (tanpa kunci jawaban).** Tambahkan faktor konversi sebagai bobot sisi pada `konversi_satuan`, lalu hitung faktor total sepanjang jalur. Implementasikan juga deteksi definisi satuan yang saling melingkar (A didefinisikan lewat B, B lewat A) dengan topological sort. *Kriteria penerimaan:* satuan yang tak terhubung mengembalikan galat yang informatif, siklus ditolak saat pendaftaran satuan, dan konversi bolak-balik konsisten untuk semua pasangan terhubung.

## [Fase 3 — Pemodelan Domain & Logika Berbasis Tipe][3]

**Level:** Menengah → Mahir · **Estimasi:** 4 minggu (≈ 40 jam) · **Tujuan fase:** memindahkan sebanyak mungkin pemeriksaan kebenaran dari runtime ke compile time.

### Modul 3.1 — Keadaan Ilegal Tak Terwakili: Sealed, Pattern & Record

**Level:** Menengah → Mahir · **Estimasi:** 12–14 jam

**1. Deskripsi Konkret.** Memodelkan domain dengan hierarki `sealed`, `switch` exhaustive, pattern, dan record sehingga kombinasi data yang tidak masuk akal tidak bisa dibuat sama sekali, dan setiap kasus baru memaksa compiler memprotes semua tempat yang belum menanganinya.

**2. Konsep Dasar & Filosofi.** Daripada satu class dengan banyak field nullable dan flag (`dipinjam`, `idAnggota?`, `jatuhTempo?`) yang bisa tidak konsisten, modelkan setiap keadaan sebagai tipe sendiri yang memuat *hanya* data yang relevan. `sealed` membatasi subtipe pada satu library sehingga compiler tahu daftar lengkapnya; `switch` atas tipe sealed wajib mencakup semuanya. Record (`(a, b)`) memberi nilai majemuk ringan dengan kesetaraan struktural; pattern membongkar dan memvalidasi sekaligus.

**Dampak Desain:**

- Satu class + flag + field nullable → kombinasi ilegal (dipinjam tetapi tanpa peminjam) bisa lolos dan harus dicek manual di banyak tempat.
- Sealed + switch exhaustive → menambah keadaan baru menimbulkan galat kompilasi di semua pemakai (aman, tetapi perubahan merambat).
- Case wildcard `_` di switch → menghilangkan jaminan exhaustive untuk keadaan masa depan; pakai hanya bila memang disengaja.
- Hierarki terbuka (non-sealed) → fleksibel bagi ekstensi pihak ketiga, tetapi compiler tidak bisa menjamin kelengkapan.

**3. Implementasi Inti.**

```dart
sealed class StatusBuku {}

final class Tersedia extends StatusBuku {}

final class Dipinjam extends StatusBuku {
  Dipinjam(this.idAnggota, this.jatuhTempo);
  final String idAnggota;
  final DateTime jatuhTempo;
}

final class Dipesan extends StatusBuku {
  Dipesan(this.idAnggota);
  final String idAnggota;
}

String deskripsi(StatusBuku s, DateTime sekarang) => switch (s) {
      Tersedia() => 'Tersedia di rak',
      Dipinjam(:final jatuhTempo) when sekarang.isAfter(jatuhTempo) =>
        'Terlambat sejak $jatuhTempo',
      Dipinjam(:final idAnggota) => 'Dipinjam oleh $idAnggota',
      Dipesan(:final idAnggota) => 'Dipesan oleh $idAnggota',
    };

// Record: nilai majemuk tanpa class; kesetaraan struktural otomatis
({int hari, bool terlambat}) analisis(DateTime tempo, DateTime kini) {
  final selisih = kini.difference(tempo).inDays;
  return (hari: selisih, terlambat: selisih > 0);
}
```

**4. Terminologi Kunci.**

- **Sealed class:** class yang subtipenya hanya boleh ada di library yang sama sehingga compiler mengetahui daftar lengkapnya.
- **Exhaustiveness:** jaminan compiler bahwa `switch` menangani semua kemungkinan.
- **ADT (algebraic data type):** gaya pemodelan data sebagai “salah satu dari beberapa bentuk”, tiap bentuk membawa datanya sendiri.
- **Record:** nilai majemuk ringan tanpa class, misal `(x: 1, y: 2)`, dengan kesetaraan berdasarkan isi.
- **Pattern / destructuring:** memeriksa bentuk nilai sekaligus mengambil bagian-bagiannya ke variabel.
- **Guard (`when`):** syarat tambahan pada sebuah case pattern.
- **Illegal state:** kombinasi data yang mustahil di dunia nyata namun mungkin dibuat di kode.

**5. Daftar Isi.** Masalah flag dan field nullable · `sealed` dan class modifiers · `switch` expression dan exhaustiveness · Object, record, list, dan map pattern · Guard dan wildcard: untung-rugi · Record sebagai nilai majemuk · Memvalidasi JSON dengan pattern.

**6. Sumber Referensi.**

- Patterns — https://dart.dev/language/patterns
- Pattern types — https://dart.dev/language/pattern-types
- Records — https://dart.dev/language/records
- Class modifiers — https://dart.dev/language/class-modifiers
- Branches (`switch`, `if-case`) — https://dart.dev/language/branches

**7. Visualisasi.**

```text
StatusBuku (sealed)
 |-- Tersedia
 |-- Dipinjam(idAnggota, jatuhTempo)
 '-- Dipesan(idAnggota)

switch (s) -> compiler memeriksa: ketiga subtipe tertangani?
              Jika tidak: GALAT KOMPILASI (bukan bug runtime)
```

**Latihan (tanpa kunci jawaban).** Rancang ulang `Buku` yang semula memakai tiga field nullable dan satu flag menjadi hierarki sealed, lalu tambahkan keadaan `Hilang`. *Kriteria penerimaan:* tidak ada field nullable di model; penambahan `Hilang` memicu galat kompilasi di setiap `switch` yang belum menanganinya (tunjukkan galatnya, lalu perbaiki).

### Modul 3.2 — Sistem Tipe sebagai Alat Bukti: Null Safety, Generik & Extension Types

**Level:** Mahir · **Estimasi:** 12–14 jam

**1. Deskripsi Konkret.** Memakai sistem tipe Dart (sound null safety, flow analysis, generik, extension types) untuk membuktikan sifat program saat kompilasi, termasuk mencegah pencampuran satuan yang berbeda.

**2. Konsep Dasar & Filosofi.** *Sound* berarti: bila program lolos analisis, nilai bertipe non-nullable tidak pernah `null` saat runtime. *Flow analysis* mempromosikan tipe setelah pengecekan (`if (x != null)`), tetapi hanya untuk variabel yang tidak berubah di antara pengecekan dan pemakaian; field publik yang dapat berubah tidak dipromosikan. `late` dan `!` memindahkan pembuktian dari compiler ke runtime. Generik memungkinkan satu logika untuk banyak tipe, dan `T extends Comparable<T>` menyatakan syaratnya. *Extension type* membungkus tipe yang sudah ada tanpa biaya runtime sehingga `Meter` dan `Detik` tidak bisa tertukar walau keduanya `double`.

**Dampak Desain:**

- `!` dan `late` bertebaran → compiler berhenti membantu; kesalahan muncul sebagai crash runtime.
- Menyalin field ke variabel lokal sebelum mengecek → promosi tipe bekerja; mengandalkan field langsung → tidak.
- `dynamic` → semua pengecekan ditunda ke runtime dan tooling menjadi buta; `Object?` memaksa pengecekan eksplisit.
- Extension type → keamanan tipe tanpa alokasi objek tambahan, tetapi tidak memeriksa nilai: validasi tetap tugas Anda.

**3. Implementasi Inti.**

```dart
class Profil {
  String? alias; // field yang bisa berubah: tidak dipromosikan

  int panjangAlias() {
    final a = alias; // salin ke variabel lokal
    if (a == null) return 0;
    return a.length; // a berstatus String (non-null) di sini
  }
}

extension type const Meter(double nilai) {
  Meter operator +(Meter lain) => Meter(nilai + lain.nilai);
}

extension type const Detik(double nilai) {}

void main() {
  final panjang = Meter(3) + Meter(4);
  print(panjang.nilai); // 7.0
  // Meter(3) + Detik(4); // galat kompilasi: Detik bukan Meter
}
```

**4. Terminologi Kunci.**

- **Sound null safety:** jaminan bahwa tipe non-nullable tidak pernah berisi `null` bila program lolos analisis.
- **Flow analysis / type promotion:** compiler menyempitkan tipe sebuah variabel setelah pengecekan, misal dari `String?` menjadi `String`.
- **`late`:** janji bahwa variabel akan diisi sebelum dibaca; bila ingkar, terjadi galat runtime.
- **Generik:** logika yang diparameterisasi tipe, seperti `List<T>`.
- **Variance / `covariant`:** aturan apakah `List<Kucing>` boleh dipakai sebagai `List<Hewan>`; Dart memperlakukan generik secara kovarian dan menutup celahnya dengan pengecekan runtime.
- **Reified generics:** informasi tipe generik tetap ada saat runtime (`is List<int>` bisa diuji).
- **Extension type:** pembungkus tipe zero-cost yang menciptakan tipe baru pada compile time.

**5. Daftar Isi.** Sound null safety · Flow analysis dan kegagalan promosi · `late`, `!`, dan harganya · Generik, batas tipe, dan variance · `dynamic` vs `Object?` · Extension types sebagai tipe baru zero-cost.

**6. Sumber Referensi.**

- Sound null safety — https://dart.dev/null-safety
- Understanding null safety — https://dart.dev/null-safety/understanding-null-safety
- Fixing type promotion failures — https://dart.dev/tools/non-promotion-reasons
- Generics — https://dart.dev/language/generics
- Type system — https://dart.dev/language/type-system
- Extension types — https://dart.dev/language/extension-types

**7. Visualisasi.**

```text
String? a --[ if (a == null) return ]--> String a      (dipromosikan)
field.alias --[ bisa berubah di antara cek dan pakai ]--> TIDAK dipromosikan

Meter(3) + Meter(4)  -> OK        Meter(3) + Detik(4) -> GALAT KOMPILASI
(saat runtime keduanya hanyalah double: tanpa alokasi tambahan)
```

**Latihan (tanpa kunci jawaban).** Ganti semua `double` pada `konversi_satuan` menjadi extension type per dimensi (`Panjang`, `Massa`, `Waktu`) sehingga konversi antardimensi tidak bisa dikompilasi. *Kriteria penerimaan:* tidak ada `dynamic` dan tidak ada `!` di kode domain; satu contoh yang sengaja salah tampil sebagai komentar beserta pesan galat kompilasinya; semua test lama tetap hijau.

### Modul 3.3 — Penanganan Kesalahan sebagai Bagian dari Logika

**Level:** Mahir · **Estimasi:** 10–12 jam

**1. Deskripsi Konkret.** Merancang bagaimana kegagalan direpresentasikan, dipropagasi, dan ditangani: kapan melempar exception, kapan mengembalikan hasil bertipe (`Hasil<T>`), dan kapan membiarkan program berhenti.

**2. Konsep Dasar & Filosofi.** Dart membedakan `Exception` (kegagalan yang bisa diantisipasi dan ditangani: input buruk, jaringan putus) dari `Error` (bug pemrograman, misal `ArgumentError` atau `StateError`). Pedoman Effective Dart: lempar `Error` hanya untuk kesalahan programatik dan jangan menangkapnya secara eksplisit. Gunakan `on TipeSpesifik` agar tidak menelan kesalahan lain, `rethrow` untuk mempertahankan stack trace, dan `finally` untuk pembersihan. Untuk kegagalan yang *diharapkan* sebagai bagian dari domain, tipe hasil sealed membuat pemanggil *wajib* menanganinya karena compiler memeriksa exhaustiveness. Prinsipnya: gagal keras dan dini di batas, atau gagal terkendali dengan pesan yang bermakna; jangan pernah gagal diam-diam.

**Dampak Desain:**

- `catch (e)` tanpa `on` → menelan bug (`Error`) bersama kegagalan yang wajar; gunakan `on` spesifik.
- Exception untuk alur normal (misal “tidak ketemu”) → lambat dan tersembunyi dari tanda tangan fungsi; tipe hasil membuat kemungkinan gagal terlihat.
- Tipe hasil di mana-mana → verbose, tetapi pemanggil tidak bisa lupa menangani; pakai di batas domain, bukan di setiap fungsi kecil.
- Pesan galat memuat data sensitif → kebocoran lewat log; sanitasi (Modul 7.1).
- `assert` untuk validasi input → hilang pada build rilis; gunakan `throw` untuk validasi sungguhan.

**3. Implementasi Inti.**

```dart
sealed class Hasil<T> {}

final class Ok<T> extends Hasil<T> {
  Ok(this.nilai);
  final T nilai;
}

final class Gagal<T> extends Hasil<T> {
  Gagal(this.pesan);
  final String pesan;
}

Hasil<double> parseKuantitas(String masukan) {
  final bagian = masukan.trim().split(RegExp(r'\s+'));
  if (bagian.length != 2) return Gagal('format: <angka> <satuan>');
  final angka = double.tryParse(bagian[0]);
  if (angka == null || !angka.isFinite) {
    return Gagal('angka tidak valid: ${bagian[0]}');
  }
  return Ok(angka);
}

void main() {
  switch (parseKuantitas('5 km')) {
    case Ok(:final nilai):
      print('nilai = $nilai'); // nilai = 5.0
    case Gagal(:final pesan):
      print('galat: $pesan');
  }
}
```

**4. Terminologi Kunci.**

- **Exception:** kegagalan yang bisa diantisipasi dan ditangani pemanggil (misal `FormatException`).
- **Error:** tanda bug pemrograman yang seharusnya diperbaiki, bukan ditangkap (misal `StateError`).
- **Stack trace:** jejak rantai pemanggilan saat galat terjadi; kunci untuk menemukan sumber masalah.
- **`rethrow`:** melempar ulang galat yang tertangkap tanpa merusak stack trace aslinya.
- **Fail-fast:** berhenti segera saat kondisi tak valid terdeteksi agar kerusakan tidak menjalar.
- **Result type:** tipe yang membungkus “sukses atau gagal” sehingga kegagalan menjadi bagian dari tanda tangan fungsi.
- **Error boundary:** titik di sistem tempat galat dikumpulkan, dicatat, dan diterjemahkan (misal menjadi kode keluar CLI).

**5. Daftar Isi.** Exception vs Error · `try`/`on`/`catch`/`finally`/`rethrow` · Stack trace dan `Error.throwWithStackTrace` · Tipe hasil sealed (`Hasil<T>`) · Gagal dini vs gagal terkendali · Kode keluar dan error boundary pada CLI · `assert` vs `throw`.

**6. Sumber Referensi.**

- Error handling — https://dart.dev/language/error-handling
- Futures and error handling — https://dart.dev/libraries/async/futures-error-handling
- Effective Dart: Usage (bagian Error handling) — https://dart.dev/effective-dart/usage
- `Error` — https://api.dart.dev/dart-core/Error-class.html
- `Exception` — https://api.dart.dev/dart-core/Exception-class.html

**7. Visualisasi.**

```text
input mentah --> [PARSE di batas] --> Ok(nilai)   --> logika domain (tanpa cek berulang)
                       |
                       '--> Gagal(pesan) --> error boundary --> log + pesan ramah + exit code

bug programatik (Error) --> jangan ditangkap: biarkan crash dengan stack trace yang jelas
```

**Latihan (tanpa kunci jawaban).** Tambahkan `parseKuantitas` ke `konversi_satuan` dengan tiga jenis kegagalan berbeda (format, angka, satuan tak dikenal) sebagai subtipe sealed `Gagal`, lalu buat CLI-nya mengembalikan kode keluar berbeda per jenis. *Kriteria penerimaan:* tidak ada `catch` tanpa `on`; setiap jenis kegagalan punya test; `switch` atas hasil exhaustive tanpa wildcard.

## [Fase 4 — Komposisi Fungsional & Manajemen State][4]

**Level:** Mahir · **Estimasi:** 3 minggu (≈ 30 jam) · **Tujuan fase:** menyusun logika dari potongan murni yang bisa dikomposisi, dan mengelola perubahan state secara eksplisit.

### Modul 4.1 — Fungsi Murni, Komposisi & Evaluasi Malas

**Level:** Mahir · **Estimasi:** 12–14 jam

**1. Deskripsi Konkret.** Menyusun logika dari fungsi murni dan closure yang bisa dikomposisi, serta memahami kapan `Iterable` (`map`, `where`, `sync*`) dievaluasi malas dan apa akibatnya bagi efek samping, kinerja, dan kebenaran.

**2. Konsep Dasar & Filosofi.** Fungsi murni selalu memberi hasil sama untuk argumen sama dan tidak menyentuh dunia luar, sehingga mudah diuji, di-cache, dan diparalelkan. Fungsi adalah nilai: bisa dikirim, disimpan, dan dikomposisi. `Iterable.map` dan `where` bersifat *malas*: tidak ada yang dihitung sampai Anda menelusurinya, dan *setiap* penelusuran mengevaluasi ulang dari awal. Evaluasi malas menghemat memori dan memungkinkan berhenti dini (`take`, `firstWhere`), tetapi menyembunyikan kapan efek samping terjadi.

**Dampak Desain:**

- Pipeline malas yang ditelusuri berkali-kali → kerja dan efek samping berulang; materialisasi sekali dengan `toList()` bila hasilnya dipakai ulang.
- `toList()` terlalu dini pada data besar → memori melonjak; biarkan malas bila hanya dikonsumsi sekali.
- Efek samping di dalam `map`/`where` → urutan dan jumlah eksekusinya bergantung pada cara iterasi; pisahkan transformasi murni dari efek samping.
- Closure yang menangkap variabel mutabel → perilaku berubah diam-diam saat variabel berubah; tangkap nilai yang tak berubah (`final`).

**3. Implementasi Inti.**

```dart
void main() {
  var panggilan = 0;
  final kuadrat = [1, 2, 3].map((x) {
    panggilan++;
    return x * x;
  }); // MALAS: belum ada yang dihitung

  print(panggilan);        // 0
  print(kuadrat.toList()); // [1, 4, 9]  -> 3 panggilan
  print(kuadrat.toList()); // [1, 4, 9]  -> 3 panggilan LAGI
  print(panggilan);        // 6, bukan 3: tiap penelusuran mengevaluasi ulang

  final tetap = kuadrat.toList(growable: false); // materialisasi sekali
  print(tetap.fold<int>(0, (a, b) => a + b));    // 14
}

/// Generator malas: nilai dihasilkan hanya saat diminta.
Iterable<int> kelipatan(int n) sync* {
  for (var i = n;; i += n) {
    yield i;
  }
}
// kelipatan(7).take(3).toList() -> [7, 14, 21]
```

**4. Terminologi Kunci.**

- **Fungsi murni:** fungsi yang hasilnya hanya bergantung pada argumen dan tidak punya efek samping.
- **Efek samping:** perubahan di luar fungsi: menulis file, mengubah variabel global, mencetak, memanggil jaringan.
- **Closure:** fungsi yang “mengingat” variabel di sekitarnya saat dibuat.
- **Fungsi tingkat tinggi:** fungsi yang menerima atau mengembalikan fungsi lain (`map`, `where`, `fold`).
- **Evaluasi malas (lazy):** menunda perhitungan sampai hasilnya benar-benar diminta.
- **Materialisasi:** memaksa hasil malas menjadi koleksi nyata (`toList`, `toSet`).
- **Generator (`sync*`):** fungsi yang menghasilkan urutan nilai satu per satu lewat `yield`.

**5. Daftar Isi.** Fungsi murni dan referential transparency · Closure dan tangkapan variabel · Fungsi tingkat tinggi dan komposisi · `Iterable` malas vs `List` · `sync*` dan generator · Kapan materialisasi · Memisahkan transformasi dari efek samping.

**6. Sumber Referensi.**

- Functions — https://dart.dev/language/functions
- Iterable collections — https://dart.dev/libraries/collections/iterables
- `Iterable` — https://api.dart.dev/dart-core/Iterable-class.html
- Typedefs — https://dart.dev/language/typedefs

**7. Visualisasi.**

```text
[1,2,3] --map(kuadrat)--> (belum dihitung) --toList()--> hitung 3x --> [1,4,9]
                                 |
                                 '--toList() lagi--> hitung 3x lagi (tidak di-cache!)

Materialisasi sekali: toList() -> simpan -> pakai berkali-kali
```

**Latihan (tanpa kunci jawaban).** Tulis pipeline malas yang membaca jutaan baris data pengukuran, menyaring yang valid, mengonversi satuan, dan mengambil 100 hasil pertama yang melewati ambang. *Kriteria penerimaan:* memori tetap datar (ukur dengan teknik Modul 6.2); bukti dengan penghitung bahwa pembacaan berhenti begitu 100 hasil terkumpul; fungsi konversi murni dan punya test tanpa I/O.

### Modul 4.2 — Imutabilitas, Value Semantics & Mesin Keadaan

**Level:** Mahir · **Estimasi:** 12–14 jam

**1. Deskripsi Konkret.** Mengelola perubahan dengan eksplisit: objek tak berubah (immutable) dengan kesetaraan berdasarkan nilai, perubahan lewat salinan, dan transisi state dimodelkan sebagai mesin keadaan murni `(state, peristiwa) → state baru`.

**2. Konsep Dasar & Filosofi.** Data yang tidak bisa berubah tidak bisa dirusak pihak lain, aman dibagi antar-isolate, dan mudah dinalar. *Value semantics* berarti dua objek dianggap sama bila isinya sama (`==` dan `hashCode` di-override, atau pakai record). Perubahan dilakukan dengan membuat salinan (`copyWith`). *Mesin keadaan* memetakan setiap pasangan (state, peristiwa) ke state berikutnya atau menolaknya, sehingga aturan bisnis berada di satu tempat yang mudah diuji dengan tabel. Bedakan *view* dan *snapshot*: `UnmodifiableListView` adalah jendela read-only yang tetap mengikuti perubahan sumbernya, sedangkan `List.unmodifiable` adalah salinan beku.

**Dampak Desain:**

- Mutabel dan dibagi luas → perubahan di satu tempat merusak asumsi di tempat lain (aliasing bug).
- Imutabel + salinan → alokasi lebih banyak untuk struktur besar; salin hanya bagian yang berubah atau pakai struktur berbagi (persisten).
- Wildcard `_` pada transisi → keadaan baru tidak memicu peringatan compiler; daftarkan transisi secara eksplisit bila ingin jaminan kelengkapan.
- Transisi tersebar di banyak method → aturan sulit diaudit; satu fungsi transisi murni bisa diuji dengan tabel.

**3. Implementasi Inti** (memakai `StatusBuku` dari Modul 3.1).

```dart
sealed class Peristiwa {}

final class Meminjam extends Peristiwa {
  Meminjam(this.idAnggota, this.jatuhTempo);
  final String idAnggota;
  final DateTime jatuhTempo;
}

final class Mengembalikan extends Peristiwa {}

/// Fungsi murni: (state, peristiwa) -> state baru. Transisi ilegal ditolak.
StatusBuku transisi(StatusBuku s, Peristiwa p) => switch ((s, p)) {
      (Tersedia(), Meminjam(:final idAnggota, :final jatuhTempo)) =>
        Dipinjam(idAnggota, jatuhTempo),
      (Dipinjam(), Mengembalikan()) => Tersedia(),
      _ => throw StateError('Transisi tidak diizinkan: $s + $p'),
    };
```

**4. Terminologi Kunci.**

- **Imutabel (immutable):** objek yang tidak bisa diubah setelah dibuat.
- **Value semantics:** kesetaraan berdasarkan isi, bukan alamat memori.
- **Aliasing:** dua variabel menunjuk objek yang sama sehingga perubahan lewat satu terlihat di yang lain.
- **`copyWith`:** pola membuat salinan dengan sebagian field diganti.
- **Mesin keadaan (state machine):** model berisi sekumpulan keadaan dan aturan perpindahan antarkeadaan akibat peristiwa.
- **View vs snapshot:** jendela hidup ke data asal vs salinan beku pada satu waktu.
- **Transisi:** perpindahan dari satu keadaan ke keadaan lain.

**5. Daftar Isi.** Imutabilitas dan `final`/`const` · Kesetaraan nilai: `==`, `hashCode`, record · `copyWith` dan struktur berbagi · `UnmodifiableListView` vs `List.unmodifiable` · Mesin keadaan dengan sealed + switch · Pengujian berbasis tabel transisi · Event sourcing versi ringan.

**6. Sumber Referensi.**

- Classes — https://dart.dev/language/classes
- Records — https://dart.dev/language/records
- Enums — https://dart.dev/language/enums
- `dart:collection` — https://api.dart.dev/dart-collection
- Effective Dart: Design — https://dart.dev/effective-dart/design

**7. Visualisasi.**

```text
            Meminjam(id, tempo)              Mengembalikan
Tersedia ------------------------> Dipinjam ----------------> Tersedia

Pasangan (state, peristiwa) lain --> StateError (ditolak)
```

**Latihan (tanpa kunci jawaban).** Lengkapi mesin keadaan `katalog_perpustakaan` dengan `Memesan`, `Membatalkan`, dan `Hilang`, lalu buat tabel transisi sebagai test (semua pasangan state × peristiwa, yang ilegal ditandai). *Kriteria penerimaan:* semua pasangan tercakup test; menambah peristiwa baru tanpa menambah baris test membuat test gagal (pakai daftar semua peristiwa).

## [Fase 5 — Asinkron & Konkurensi][5]

**Level:** Mahir · **Estimasi:** 5 minggu (≈ 50 jam) · **Tujuan fase:** menalar urutan eksekusi, menghindari race condition dan kebocoran sumber daya, serta memakai paralelisme dengan benar.

### Modul 5.1 — Event Loop, Microtask & Semantik Future

**Level:** Mahir · **Estimasi:** 10–12 jam

**1. Deskripsi Konkret.** Memahami bagaimana satu isolate menjalankan kode: antrean microtask, antrean event, kapan `async` berhenti dan melanjutkan, serta arti `Future` yang sudah berjalan sebelum di-`await`.

**2. Konsep Dasar & Filosofi.** Setiap isolate punya satu thread dan satu event loop. Kode sinkron berjalan sampai selesai; lalu seluruh *microtask* dikuras; baru satu *event* diproses, lalu microtask dikuras lagi, dan seterusnya. Fungsi `async` berjalan **sinkron** sampai `await` pertama; setelah itu kelanjutannya dijadwalkan lewat loop. `Future` bersifat *eager*: kerjanya dimulai saat dibuat, bukan saat di-`await`. `await` tidak membuat thread baru; ia hanya menyerahkan kendali ke event loop. Kode sinkron yang lama (CPU-bound atau I/O sinkron) memblokir *semuanya*.

**Dampak Desain:**

- Kerja berat sinkron di isolate utama → seluruh event (timer, I/O, UI) tertahan; pindahkan ke isolate (Modul 5.4).
- `Future` dibuat tetapi tidak di-`await` (fire-and-forget) → galatnya tidak tertangani dan bisa menjatuhkan program; tandai sengaja dengan `unawaited` dan tangani galat.
- `await` berurutan untuk kerja independen → total waktu dijumlahkan; `Future.wait` atau record `(f1, f2).wait` menjalankannya bersamaan dalam satu isolate (cocok untuk I/O).
- Mengandalkan urutan antar-event yang tidak dijamin → bug yang muncul hanya kadang-kadang.

**3. Implementasi Inti.**

```dart
import 'dart:async';

Future<void> kerja() async {
  print('2: sinkron sampai await pertama');
  await Future<void>.delayed(Duration.zero);
  print('7: lanjutan dari event loop');
}

void main() {
  print('1: sinkron');
  Future(() => print('6: event'));
  scheduleMicrotask(() => print('4: microtask'));
  Future.microtask(() => print('5: microtask'));
  unawaited(kerja());
  print('3: sinkron lagi (kerja() sudah kembali)');
}
// Urutan keluaran: 1, 2, 3, 4, 5, 6, 7
```

**4. Terminologi Kunci.**

- **Event loop:** pengulang yang mengambil satu tugas dari antrean lalu menjalankannya sampai selesai, terus-menerus.
- **Microtask queue:** antrean tugas kecil berprioritas tinggi yang dikuras habis sebelum event berikutnya.
- **Event queue:** antrean peristiwa luar (timer, I/O, pesan) yang diproses satu per satu.
- **Future:** wadah untuk hasil yang akan tersedia kelak (nilai atau galat).
- **Eager:** dimulai segera saat dibuat, tidak menunggu ada yang meminta hasilnya.
- **`unawaited`:** penanda bahwa sebuah Future sengaja tidak ditunggu.
- **Memblokir (blocking):** kode yang menahan event loop sehingga tugas lain tak bisa berjalan.

**5. Daftar Isi.** Isolate, thread, dan event loop · Microtask vs event · Anatomi fungsi `async` · `Future`, `Completer`, `then` vs `await` · `Future.wait`, record `.wait`, `timeout` · Galat tak tertangani dan `Zone` · Kode sinkron yang memblokir.

**6. Sumber Referensi.**

- Concurrency in Dart — https://dart.dev/language/concurrency
- Asynchronous programming — https://dart.dev/language/async
- Async tutorial — https://dart.dev/libraries/async/async-await
- `dart:async` — https://api.dart.dev/dart-async
- `Future` — https://api.dart.dev/dart-async/Future-class.html

**7. Visualisasi.** Gambar yang direkomendasikan: dua antrean sebagai dua jalur dengan panah giliran.

```text
main() sinkron --> kuras SEMUA microtask --> 1 event --> kuras microtask --> 1 event ...
   (1, 2, 3)            (4, 5)                (6)             (7)
```

**Latihan (tanpa kunci jawaban).** Tulis prediksi urutan keluaran untuk sepuluh potongan kode campuran (`Future`, `scheduleMicrotask`, `await`, `Timer`, `then`), jalankan, lalu jelaskan setiap selisih. *Kriteria penerimaan:* minimal sembilan dari sepuluh prediksi benar; yang salah punya entri Jurnal Galat berisi akar masalahnya.

### Modul 5.2 — Stream, Backpressure & Orkestrasi

**Level:** Mahir · **Estimasi:** 12–14 jam

**1. Deskripsi Konkret.** Mengolah urutan data yang tiba seiring waktu (baris file, pesan jaringan, peristiwa) dengan `Stream`: kapan memakai single-subscription atau broadcast, bagaimana konsumen mengatur laju (backpressure), dan bagaimana langganan dihentikan agar tidak bocor.

**2. Konsep Dasar & Filosofi.** `Future` memberi *satu* hasil kelak; `Stream` memberi *banyak*. Stream biasa (single-subscription) hanya boleh didengarkan sekali dan menahan data sampai ada pendengar; stream *broadcast* boleh punya banyak pendengar tetapi tidak menyimpan data untuk yang terlambat. Pada `await for` dan generator `async*`, konsumen *menarik* data sesuai kemampuannya: `yield` menunggu sampai konsumen siap, sehingga memori tetap konstan (backpressure alami). Sebaliknya `listen` dengan handler lambat pada sumber cepat membuat data menumpuk di buffer. Setiap `StreamSubscription` dan `StreamController` adalah sumber daya yang harus dibatalkan atau ditutup.

**Dampak Desain:**

- `listen` dengan handler lambat pada sumber cepat → buffer tumbuh tanpa batas; pakai `await for` atau `pause()`/`resume()`.
- Langganan atau controller tidak ditutup → kebocoran memori dan callback hantu (aktifkan lint `cancel_subscriptions` dan `close_sinks`).
- Broadcast untuk data yang tidak boleh hilang → pendengar yang terlambat kehilangan peristiwa; pakai single-subscription atau simpan state terpisah.
- Membaca seluruh file dengan `readAsString` → memori sebanding ukuran file; streaming baris demi baris menjaga memori datar.

**3. Implementasi Inti.**

```dart
import 'dart:convert';
import 'dart:io';

/// Membaca file besar baris demi baris: memori konstan, bukan seluruh file.
Stream<int> panjangBarisBermakna(String path) async* {
  final baris = File(path)
      .openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter());
  await for (final b in baris) {
    if (b.trim().isNotEmpty) yield b.length; // yield menunggu konsumen siap
  }
}

Future<void> main(List<String> args) async {
  var total = 0;
  await for (final panjang in panjangBarisBermakna(args.first)) {
    total += panjang;
  }
  print('total karakter: $total');
}
```

Siklus hidup sumber daya pada `StreamController`:

```dart
// import 'dart:async';
Future<void> contoh() async {
  final ctrl = StreamController<int>(onCancel: () => print('dibersihkan'));
  final sub = ctrl.stream.listen(print);
  ctrl.add(1);
  await sub.cancel(); // wajib: lepaskan sumber daya
  await ctrl.close();
}
```

**4. Terminologi Kunci.**

- **Stream:** aliran nilai yang tiba berurutan seiring waktu (berbeda dari `Future` yang hanya satu hasil).
- **Single-subscription:** stream yang hanya boleh didengarkan satu kali dan menahan data sampai ada pendengar.
- **Broadcast:** stream yang boleh didengarkan banyak pihak; data yang lewat tanpa pendengar hilang.
- **Backpressure:** mekanisme agar penerima yang lambat bisa memperlambat pengirim, bukan kebanjiran.
- **Subscription:** “langganan” aktif pada sebuah stream; harus dibatalkan bila tidak dipakai lagi.
- **`async*` / `yield`:** fungsi generator asinkron yang mengeluarkan nilai satu per satu ke stream.
- **Buffer:** penampung sementara data yang sudah tiba tetapi belum diproses.

**5. Daftar Isi.** `Future` vs `Stream` · Single-subscription vs broadcast · `await for` dan `async*` · `StreamController` dan siklus hidupnya · `pause`/`resume` dan backpressure · Transformer, `StreamQueue`, debounce/throttle · Membatalkan langganan dan lint terkait.

**6. Sumber Referensi.**

- Using streams — https://dart.dev/libraries/async/using-streams
- Creating streams — https://dart.dev/libraries/async/creating-streams
- `Stream` — https://api.dart.dev/dart-async/Stream-class.html
- `package:async` (`StreamQueue`) — https://pub.dev/packages/async
- `package:stream_transform` — https://pub.dev/packages/stream\_transform

**7. Visualisasi.**

```text
sumber cepat ---> [ buffer ] ---> konsumen lambat    (listen: buffer MEMBENGKAK)

sumber ---> yield <---(menarik)--- await for         (backpressure alami: memori datar)
```

**Latihan (tanpa kunci jawaban).** Buat stream yang membaca log berukuran 1 GB (boleh file sintetis), menghitung agregat per jam, dan menulis ringkasan tanpa pernah memuat seluruh file. *Kriteria penerimaan:* memori puncak (`/usr/bin/time -v`) tidak bertambah saat ukuran file dilipatgandakan; semua langganan dan controller ditutup (lint `cancel_subscriptions` dan `close_sinks` bersih).

### Modul 5.3 — Race Condition Asinkron, Pembatalan & Batas Konkurensi

**Level:** Mahir → Expert · **Estimasi:** 12–14 jam

**1. Deskripsi Konkret.** Mengenali bahwa kode asinkron satu thread tetap bisa mengalami race condition (giliran lain masuk di setiap `await`), lalu menjaganya dengan kunci atau antrean, membatasi jumlah pekerjaan bersamaan, memberi batas waktu, dan membatalkan kerja yang tak lagi diperlukan.

**2. Konsep Dasar & Filosofi.** Tidak ada data race pada memori bersama di dalam satu isolate, tetapi ada *logic race*: pola *cek lalu bertindak* yang disela `await` bisa memakai cek yang sudah basi karena fungsi lain berjalan di sela itu. Solusinya: buat bagian kritis tidak bisa diselipi (serialisasi lewat antrean atau mutex), atau buat operasinya atomik (satu langkah sinkron). `Future.timeout` hanya berhenti *menunggu*; kerja di belakangnya tetap berjalan kecuali ada mekanisme pembatalan. Dart tidak punya pembatalan `Future` bawaan; polanya adalah token atau flag yang diperiksa oleh kerja, `CancelableOperation` dari `package:async`, atau pembatalan `StreamSubscription` dan `Timer`. Isolate menghilangkan data race antar-thread, tetapi tidak menghapus logic race pada aliran pesan.

**Dampak Desain:**

- Cek-lalu-bertindak tanpa serialisasi → invarian rusak (stok negatif, pinjaman ganda).
- Mutex global → benar tetapi serial, throughput turun; kunci per sumber daya (per ISBN) menjaga paralelisme.
- Fan-out tanpa batas (`Future.wait` untuk 100.000 tugas) → kehabisan memori atau koneksi; batasi dengan pool (`package:pool`).
- Timeout tanpa pembatalan → kerja zombie menumpuk dan terus memakai sumber daya.
- Kunci yang tidak dilepas saat galat → deadlock; pastikan rantai tetap berjalan walau kerja gagal.

**3. Implementasi Inti.**

```dart
import 'dart:async';

final stok = {'A': 1};
Future<void> jeda() => Future<void>.delayed(const Duration(milliseconds: 5));

/// Antrean sederhana: kerja dijalankan satu per satu sesuai urutan kedatangan.
class Kunci {
  Future<void> _ekor = Future.value();

  Future<T> jalankan<T>(Future<T> Function() kerja) {
    final hasil = _ekor.then((_) => kerja());
    _ekor = hasil.then<void>((_) {}, onError: (Object _) {}); // rantai tak pernah putus
    return hasil;
  }
}

Future<bool> pinjam(String isbn) async {
  if (stok[isbn]! > 0) {          // 1) cek
    await jeda();                 // 2) di sini giliran lain bisa masuk!
    stok[isbn] = stok[isbn]! - 1; // 3) bertindak berdasarkan cek yang sudah basi
    return true;
  }
  return false;
}

Future<void> main() async {
  print(await Future.wait([pinjam('A'), pinjam('A')])); // [true, true] -> stok -1 (rusak)

  stok['A'] = 1;
  final kunci = Kunci();
  print(await Future.wait([
    kunci.jalankan(() => pinjam('A')),
    kunci.jalankan(() => pinjam('A')),
  ])); // [true, false] -> invarian terjaga
}
```

**4. Terminologi Kunci.**

- **Race condition:** hasil yang bergantung pada urutan kejadian yang tidak terkendali.
- **Data race vs logic race:** data race = dua thread menyentuh memori yang sama bersamaan; logic race = urutan logika terselip di antara `await`, tanpa perlu thread kedua.
- **Check-then-act (TOCTOU):** mengecek kondisi lalu bertindak, padahal kondisi bisa berubah di antaranya.
- **Mutex / kunci:** mekanisme agar hanya satu pekerjaan memasuki bagian kritis pada satu waktu.
- **Bagian kritis (critical section):** potongan logika yang tidak boleh diselipi pekerjaan lain.
- **Pool:** pembatas jumlah pekerjaan yang berjalan bersamaan.
- **Pembatalan kooperatif:** kerja diberi tahu agar berhenti dan secara sukarela memeriksa tanda berhenti.

**5. Daftar Isi.** Logic race pada kode `async` · Cek-lalu-bertindak dan atomisitas · Mutex/antrean dan kunci per sumber daya · Membatasi konkurensi dengan `package:pool` · `timeout` vs pembatalan sungguhan · `CancelableOperation`, `Timer.cancel`, `StreamSubscription.cancel` · `Zone` dan `runZonedGuarded` untuk galat tak tertangani.

**6. Sumber Referensi.**

- Concurrency in Dart (catatan tentang race condition) — https://dart.dev/language/concurrency
- `package:async` — https://pub.dev/packages/async
- `package:pool` — https://pub.dev/packages/pool
- `Zone` — https://api.dart.dev/dart-async/Zone-class.html
- `Future` (termasuk `timeout`) — https://api.dart.dev/dart-async/Future-class.html

**7. Visualisasi.**

```text
Tanpa kunci:                           Dengan kunci:
 A: cek(1) ... await ... kurangi        A: cek(1) -> await -> kurangi -> selesai
 B:    cek(1) ... await ... kurangi     B:                               cek(0) -> tolak
 => stok -1 (invarian rusak)            => stok 0 (invarian terjaga)
```

**Latihan (tanpa kunci jawaban).** Tambahkan operasi `pinjam` ke `katalog_perpustakaan` dengan kunci *per ISBN* (bukan global), batas 5 pekerjaan bersamaan, dan timeout 2 detik yang benar-benar membatalkan kerja. *Kriteria penerimaan:* test dengan 1.000 permintaan acak (seed tetap) pada 10 ISBN tidak pernah menghasilkan stok negatif atau pinjaman ganda; permintaan ke ISBN berbeda tetap berjalan paralel (buktikan dengan pengukuran waktu).

### Modul 5.4 — Isolate: Paralelisme Tanpa Memori Bersama

**Level:** Mahir → Expert · **Estimasi:** 12–14 jam

**1. Deskripsi Konkret.** Memindahkan kerja CPU-bound ke isolate lain dengan `Isolate.run` dan `Isolate.spawn`, merancang protokol pesan yang aman, menangani kegagalan worker, dan memahami batas isolate (bukan sandbox keamanan).

**2. Konsep Dasar & Filosofi.** Isolate adalah unit eksekusi dengan memori dan event loop sendiri; isolate tidak berbagi objek, hanya berkomunikasi lewat pesan (model aktor). Pesan lewat `SendPort.send` disalin, sedangkan `Isolate.exit` memindahkan data hasil tanpa menyalin sehingga cocok untuk menutup pekerjaan besar; `Isolate.run` memakainya. Biaya memulai isolate dan menyalin pesan itu nyata: paralelisme layak bila kerjanya *jauh lebih mahal* daripada biaya tersebut. Isolate memberi isolasi memori dan kegagalan *di dalam satu proses*; ia bukan batas keamanan (kode berbahaya di dalam isolate tetap berada dalam proses OS yang sama dengan hak yang sama). Pembatasan hak butuh proses terpisah atau sandbox OS (Modul 7.3).

**Dampak Desain:**

- Kerja kecil per isolate → biaya spawn dan salin pesan melebihi manfaat; kelompokkan menjadi potongan besar atau pakai worker berumur panjang.
- Closure yang menangkap objek besar → seluruhnya disalin ke isolate baru; kirim hanya data yang diperlukan.
- Objek yang memegang sumber daya native (misal `ReceivePort`, `Pointer`, `DynamicLibrary`) → tidak dapat dikirim dan memicu galat runtime; rancang pesan dari tipe sederhana (angka, string, list, map, record, `TransferableTypedData`).
- Worker crash tanpa pengawas → permintaan menggantung; pasang listener galat dan `onExit`, atau bungkus hasil dalam tipe hasil.
- Menganggap isolate = sandbox → eskalasi hak tetap mungkin; isolasi OS diperlukan untuk kode yang tidak tepercaya.

**3. Implementasi Inti.**

```dart
import 'dart:isolate';

/// CPU-bound: layak dipindah ke isolate lain agar event loop utama tetap lancar.
int hitungBerat(int n) {
  var jumlah = 0;
  for (var i = 0; i < n; i++) {
    jumlah += i % 7;
  }
  return jumlah;
}

Future<void> main() async {
  // Isolate.run: salin apa yang ditangkap closure, jalankan, kembalikan hasil via Isolate.exit
  final hasil = await Isolate.run(() => hitungBerat(200000000));
  print(hasil);

  // Beberapa potongan sekaligus: tiap isolate bisa bekerja di inti CPU berbeda
  final potongan = await Future.wait([
    Isolate.run(() => hitungBerat(100000000)),
    Isolate.run(() => hitungBerat(100000000)),
  ]);
  print(potongan);
}
```

**4. Terminologi Kunci.**

- **Isolate:** “pulau” eksekusi Dart dengan memori dan event loop sendiri; tidak berbagi objek dengan isolate lain.
- **Model aktor:** gaya konkurensi tempat entitas independen berkomunikasi hanya lewat pesan.
- **`SendPort` / `ReceivePort`:** pintu kirim dan pintu terima pesan antar-isolate.
- **Penyalinan pesan:** isi pesan disalin saat dikirim sehingga perubahan di satu sisi tidak terlihat di sisi lain.
- **`Isolate.exit`:** mengakhiri isolate sambil memindahkan hasilnya tanpa menyalin.
- **CPU-bound vs I/O-bound:** tugas yang dibatasi kecepatan hitung vs tugas yang lebih sering menunggu disk atau jaringan; hanya yang pertama diuntungkan oleh isolate.
- **Worker pool:** sekumpulan isolate berumur panjang yang menerima tugas bergiliran.

**5. Daftar Isi.** Model aktor dan memori terpisah · `Isolate.run` vs `Isolate.spawn` · `SendPort`/`ReceivePort` dan protokol pesan sealed · Tipe yang dapat dikirim dan `TransferableTypedData` · Worker pool dan pembagian beban · Penanganan galat, `onExit`, dan pengawasan · Batas isolate: bukan sandbox.

**6. Sumber Referensi.**

- Isolates — https://dart.dev/language/isolates
- Concurrency in Dart — https://dart.dev/language/concurrency
- `dart:isolate` — https://api.dart.dev/dart-isolate
- `Isolate` — https://api.dart.dev/dart-isolate/Isolate-class.html
- `SendPort` — https://api.dart.dev/dart-isolate/SendPort-class.html

**7. Visualisasi.**

```text
isolate utama                      isolate worker
+--------------------+  pesan     +--------------------+
| memori sendiri     | ---------> | memori sendiri     |
| event loop sendiri | <--------- | event loop sendiri |
+--------------------+  hasil     +--------------------+
      (tidak ada objek yang dibagi; semuanya lewat port)
```

**Latihan (tanpa kunci jawaban).** Paralelkan konversi batch `konversi_satuan` (jutaan nilai) ke N isolate dan bandingkan dengan versi satu isolate. *Kriteria penerimaan:* ukur percepatan untuk N = 1, 2, 4, 8 dan jelaskan mengapa kurvanya tidak linear (biaya salin, jumlah inti, tekanan memori); worker yang crash dilaporkan sebagai kegagalan terkendali tanpa menggantungkan program.

## [Fase 6 — Performa & Efisiensi Sumber Daya][6]

**Level:** Mahir · **Estimasi:** 4 minggu (≈ 40 jam) · **Tujuan fase:** mengganti tebakan dengan pengukuran, dan memahami apa yang sebenarnya dilakukan mesin saat logika Anda berjalan.

### Modul 6.1 — Mesin di Balik Layar: Dart VM, JIT/AOT & Garbage Collector

**Level:** Mahir → Expert · **Estimasi:** 10–12 jam

**1. Deskripsi Konkret.** Membangun model mental tentang bagaimana kode Dart dikompilasi dan dijalankan (JIT versus AOT, kernel, snapshot), bagaimana garbage collector bekerja, dan apa implikasinya bagi waktu mulai, kinerja puncak, dan pemakaian memori.

**2. Konsep Dasar & Filosofi.** `dart run` memakai VM dengan JIT: cepat dimulai dan cocok untuk pengembangan, tetapi kode perlu “pemanasan” sebelum mencapai kecepatan puncak. `dart compile exe` menghasilkan kode mesin AOT: waktu mulai cepat dan kinerja lebih mudah diprediksi, tanpa compiler JIT di runtime. Dokumentasi `dart compile` mencatat bahwa JIT dapat mengungguli AOT pada kinerja puncak bila data latihannya baik (`jit-snapshot`). Memori dikelola garbage collector generasional: objek baru dialokasikan di ruang muda dan dibersihkan dengan murah; yang bertahan dipindah ke ruang tua yang dibersihkan lebih jarang tetapi lebih mahal. Konsekuensinya: banyak objek *berumur pendek* itu murah, sedangkan *menahan* objek terlalu lama (cache tak terbatas, closure yang menangkap data besar) itu mahal dan memicu pembersihan berat.

**Dampak Desain:**

- Mengukur dengan `dart run` (JIT) lalu merilis AOT → angka tidak mewakili produksi; ukur pada mode yang dirilis.
- AOT untuk alat CLI kecil → waktu mulai dan memori lebih baik tanpa SDK terpasang, dengan harga ukuran biner dan tanpa optimasi dinamis saat runtime.
- Cache atau koleksi global tak terbatas → objek menumpuk di ruang tua, GC makin sering dan berat; beri batas dan kebijakan buang (Modul 6.3).
- Banyak objek kecil berumur sangat singkat di jalur panas → biaya alokasi dan GC kecil tetapi nyata; ukur sebelum mengoptimasi.

**3. Implementasi Inti.**

```bash
# JIT (pengembangan): cepat dimulai, butuh pemanasan
dart run bin/main.dart

# AOT: biner mandiri, kinerja lebih mudah diprediksi
dart compile exe bin/main.dart -o build/app

# Lintas-target (target OS yang didukung hanya Linux)
dart compile exe --target-os=linux --target-arch=x64 bin/main.dart -o build/app-x64

# JIT snapshot: bisa unggul di puncak bila data latihan baik (jalankan: dart run bin/main.jit)
dart compile jit-snapshot bin/main.dart

# Ukur waktu dan puncak memori (RSS) proses sebenarnya (GNU time, paket `time` di Arch)
/usr/bin/time -v ./build/app 2>&1 | grep -E 'Elapsed|Maximum resident'
```

**4. Terminologi Kunci.**

- **VM (virtual machine):** program yang menjalankan kode Dart; mengelola memori dan eksekusi.
- **JIT (just-in-time):** kompilasi ke kode mesin saat program berjalan, memakai data perilaku nyata untuk optimasi.
- **AOT (ahead-of-time):** kompilasi ke kode mesin sebelum program dijalankan; hasilnya biner mandiri.
- **Kernel / snapshot:** representasi program antara, dan hasil “pembekuan” kondisi program agar dimuat lebih cepat.
- **Garbage collector (GC):** bagian runtime yang membersihkan objek yang tak lagi dipakai.
- **Generasional:** strategi GC yang memisahkan objek muda (dibersihkan sering, murah) dari objek tua (jarang, mahal).
- **RSS (resident set size):** memori fisik yang benar-benar dipakai proses saat ini.
- **Tree shaking:** pembuangan kode yang tidak dipakai saat kompilasi untuk memperkecil keluaran.

**5. Daftar Isi.** Jalur kompilasi: source → kernel → JIT/AOT · `dart compile` (exe, aot-snapshot, jit-snapshot, kernel, js, wasm) · Waktu mulai vs kinerja puncak · Alokasi dan GC generasional · Dampak ke desain: umur objek dan retensi · `dartaotruntime` dan snapshot · Batas lintas-target.

**6. Sumber Referensi.**

- `dart compile` — https://dart.dev/tools/dart-compile
- Dart overview (platform dan runtime) — https://dart.dev/overview
- Introduction to Dart VM (Vyacheslav Egorov) — https://mrale.ph/dartvm
- Dokumen VM resmi di repositori SDK — https://github.com/dart-lang/sdk/blob/main/runtime/docs/index.md
- `dartaotruntime` — https://dart.dev/tools/dartaotruntime

**7. Visualisasi.**

```text
sumber .dart --> front-end --> kernel (.dill)
                                  |
               +------------------+------------------+
               |                                     |
          JIT (dart run)                        AOT (compile exe)
   interpretasi -> optimasi saat jalan      kode mesin sebelum jalan
   mulai cepat, butuh pemanasan             mulai cepat, tanpa JIT di runtime

Heap: [ruang muda: alokasi murah, GC sering] --bertahan--> [ruang tua: GC jarang, mahal]
```

**Latihan (tanpa kunci jawaban).** Jalankan satu program uji yang sama (misal batch `konversi_satuan`) lewat `dart run`, `compile exe`, dan `jit-snapshot`; catat waktu mulai, waktu total, dan RSS puncak. *Kriteria penerimaan:* tabel hasil tiga mode dengan 10 kali ulangan masing-masing (rata-rata dan sebaran), plus satu paragraf yang menjelaskan *mengapa* angkanya berbeda.

### Modul 6.2 — Pengukuran Ilmiah: Benchmark, Profiling & Memori

**Level:** Mahir → Expert · **Estimasi:** 10–12 jam

**1. Deskripsi Konkret.** Mengukur kecepatan dan memori dengan benar: menulis benchmark yang tidak menipu, memprofil CPU dan memori dengan DevTools, dan mengambil keputusan optimasi dari data, bukan firasat.

**2. Konsep Dasar & Filosofi.** Optimasi tanpa pengukuran adalah tebakan; optimasi dengan pengukuran yang salah adalah tebakan yang percaya diri. Prinsipnya: (1) ukur kondisi *yang dirilis* (AOT), bukan mode pengembangan; (2) ulangi dan laporkan sebaran, bukan satu angka; (3) ubah *satu* variabel per eksperimen; (4) pastikan hasil benchmark dipakai agar compiler tidak membuang kerjanya; (5) mulai dari profil untuk menemukan *hot path* sebelum menyentuh kode; (6) algoritma dan struktur data (Fase 2) biasanya jauh lebih berpengaruh daripada mikro-optimasi. `package:benchmark_harness` menjalankan `run()` berulang dan melaporkan waktu rata-rata; DevTools menampilkan profil CPU dan snapshot memori.

**Dampak Desain:**

- Benchmark mikro di JIT tanpa pemanasan → angka mencerminkan fase warm-up, bukan kinerja stabil.
- Hasil tidak dipakai → compiler bisa menghapus pekerjaan (dead-code elimination) sehingga “secepat kilat” palsu.
- Mengoptimasi tanpa profil → waktu habis pada bagian yang hanya 2% dari total.
- Membandingkan di mesin yang sibuk → noise menutupi selisih; ulangi dan pakai median.
- Optimasi yang merusak keterbacaan → keterawatan turun; terima hanya bila peningkatannya terukur dan berarti.

**3. Implementasi Inti.**

```dart
import 'package:benchmark_harness/benchmark_harness.dart';

class CariDiList extends BenchmarkBase {
  CariDiList() : super('contains@List');
  late List<int> data;
  int ditemukan = 0; // pakai hasilnya agar kerja tidak dieliminasi

  @override
  void setup() => data = List<int>.generate(10000, (i) => i);

  @override
  void run() {
    if (data.contains(9999)) ditemukan++;
  }
}

void main() => CariDiList().report();
```

```bash
dart run benchmark_harness:bench --flavor aot --target benchmark/cari_di_list.dart
dart run --observe bin/main.dart       # lalu buka DevTools: profil CPU dan memori
hyperfine --warmup 3 './build/app --input data.csv'
```

**4. Terminologi Kunci.**

- **Benchmark:** pengukuran terkontrol terhadap kinerja suatu potongan kode.
- **Warm-up (pemanasan):** fase awal sebelum JIT mengoptimasi kode; ukuran di fase ini menyesatkan.
- **Profiling:** merekam di mana waktu CPU atau memori sebenarnya dipakai.
- **Hot path:** bagian kode yang paling sering atau paling lama dieksekusi.
- **Dead-code elimination:** compiler membuang kode yang hasilnya tidak dipakai.
- **Median / persentil:** ukuran tengah dan ekor sebaran; lebih tahan terhadap lonjakan acak dibanding rata-rata.
- **Heap snapshot:** potret isi memori pada satu saat untuk mencari objek yang menumpuk.

**5. Daftar Isi.** Prinsip pengukuran yang benar · `benchmark_harness` dan flavor AOT/JIT · Menghindari dead-code elimination · Profil CPU di DevTools · Memori: snapshot, alokasi, dan kebocoran · `hyperfine` dan `/usr/bin/time -v` untuk ukuran end-to-end · Membaca dan melaporkan sebaran.

**6. Sumber Referensi.**

- `package:benchmark_harness` — https://pub.dev/packages/benchmark\_harness
- Dart DevTools — https://dart.dev/tools/dart-devtools
- `dart:developer` — https://api.dart.dev/dart-developer
- `dart run` — https://dart.dev/tools/dart-run

**7. Visualisasi.**

```text
hipotesis --> ukur BASELINE (AOT, n kali) --> profil (cari hot path)
   ^                                               |
   |                                               v
   '-- ulangi <-- ukur lagi (1 perubahan) <-- ubah SATU hal
```

**Latihan (tanpa kunci jawaban).** Ambil pipeline `katalog_perpustakaan` (pencarian + sortir + agregasi), profil dengan DevTools, temukan tiga hot path teratas, dan perbaiki satu per satu. *Kriteria penerimaan:* laporan sebelum/sesudah untuk tiap perubahan lengkap dengan sebaran (min, median, p95), dan satu perubahan yang *ditolak* karena peningkatannya tak berarti atau merusak keterbacaan.

### Modul 6.3 — Tata Letak Data, Alokasi, Caching & Streaming

**Level:** Mahir → Expert · **Estimasi:** 12–14 jam

**1. Deskripsi Konkret.** Mengurangi biaya memori dan CPU lewat pilihan representasi data (typed data seperti `Uint8List`, `StringBuffer`, objek `const`), pengelolaan umur objek (cache berbatas, referensi lemah), dan pemrosesan streaming/zero-copy, tanpa mengorbankan kejelasan.

**2. Konsep Dasar & Filosofi.** Biaya sebuah logika sering ditentukan oleh *bagaimana data disusun*, bukan oleh rumus algoritmanya. `List<int>` menyimpan elemen sebagai nilai bertag atau objek, sedangkan `Uint8List` menyimpan byte mentah berurutan: jauh lebih hemat dan ramah cache CPU untuk data biner. Menyambung `String` berulang di dalam loop membuat banyak objek perantara; `StringBuffer` mengumpulkan lalu membangun sekali. Objek `const` dikanonikalisasi (satu instans dipakai bersama). View seperti `Uint8List.sublistView` memotong data tanpa menyalin. Cache mempercepat tetapi menahan memori: tanpa batas dan kebijakan buang, ia menjadi kebocoran yang sah. Prinsipnya: *proses sambil mengalir (stream), simpan seperlunya, buang dengan aturan*.

**Dampak Desain:**

- `List<int>` untuk data biner besar → memori berlipat dan cache CPU kurang efisien; `Uint8List` (atau `Int32List`, `Float64List`) lebih padat.
- `s += x` dalam loop panjang → alokasi string perantara berulang; pakai `StringBuffer` (lint `use_string_buffers`).
- Cache tanpa batas → pertumbuhan memori tanpa henti; beri kapasitas (LRU) dan/atau TTL.
- Objek besar yang tertahan closure atau variabel global tanpa sengaja → tidak pernah dibebaskan; periksa dengan heap snapshot.
- Menyalin potongan data (`sublist`) di jalur panas → alokasi dan salinan berulang; pakai view (`sublistView`) bila data tidak berubah.

**3. Implementasi Inti.**

```dart
import 'dart:collection';
import 'dart:typed_data';

/// Cache LRU: LinkedHashMap mengingat urutan sisip, jadi hapus-lalu-sisip = baru dipakai.
class CacheLru<K, V extends Object> {
  CacheLru(this.kapasitas) {
    if (kapasitas <= 0) throw ArgumentError.value(kapasitas, 'kapasitas');
  }

  final int kapasitas;
  final _isi = LinkedHashMap<K, V>();

  V? ambil(K kunci) {
    final nilai = _isi.remove(kunci);
    if (nilai == null) return null;
    _isi[kunci] = nilai; // pindahkan ke posisi paling baru
    return nilai;
  }

  void simpan(K kunci, V nilai) {
    _isi.remove(kunci);
    _isi[kunci] = nilai;
    if (_isi.length > kapasitas) _isi.remove(_isi.keys.first); // buang yang terlama
  }
}

void main() {
  final bytes = Uint8List(1 << 20);                   // 1 MiB, 1 byte per elemen
  final kepala = Uint8List.sublistView(bytes, 0, 16); // view: tanpa menyalin
  kepala[0] = 42;
  print(bytes[0]);                                    // 42 (berbagi memori yang sama)

  final buf = StringBuffer();
  for (var i = 0; i < 3; i++) {
    buf.write('baris $i\n');                          // bukan s += ... di dalam loop
  }
  print(buf.toString().trimRight());
}
```

**4. Terminologi Kunci.**

- **Alokasi:** meminta ruang memori untuk objek baru; murah di Dart, tetapi tiap objek akhirnya menjadi pekerjaan bagi GC.
- **Typed data:** daftar angka bertipe tetap (`Uint8List`, `Float64List`) yang disimpan padat di memori.
- **View (tampilan):** objek yang menunjuk bagian dari data yang sudah ada tanpa menyalinnya.
- **Kanonikalisasi (`const`):** instans `const` yang sama dipakai bersama alih-alih dibuat berulang.
- **LRU (least recently used):** kebijakan cache yang membuang entri yang paling lama tidak dipakai.
- **TTL (time to live):** umur maksimum entri cache sebelum dianggap basi.
- **Zero-copy:** memproses atau memindahkan data tanpa menyalinnya.
- **Referensi lemah (`WeakReference`):** penunjuk yang tidak mencegah objek dibersihkan GC.

**5. Daftar Isi.** Tata letak data: `List` vs typed data · `StringBuffer` dan alokasi string · `const` dan kanonikalisasi · View dan zero-copy · Cache LRU/TTL dan batas memori · `WeakReference`, `Expando`, `Finalizer` (dan batasnya) · Pola kebocoran umum (closure, global, langganan) · Streaming file besar.

**6. Sumber Referensi.**

- `dart:typed_data` — https://api.dart.dev/dart-typed\_data
- `StringBuffer` — https://api.dart.dev/dart-core/StringBuffer-class.html
- `LinkedHashMap` — https://api.dart.dev/dart-collection/LinkedHashMap-class.html
- `WeakReference` — https://api.dart.dev/dart-core/WeakReference-class.html
- Daftar lint (termasuk `use_string_buffers`) — https://dart.dev/tools/linter-rules

**7. Visualisasi.**

```text
List<int> (elemen = nilai bertag/objek)        Uint8List (byte mentah berurutan)
[ref][ref][ref][ref] ... boros, tersebar       [b][b][b][b] ... padat, ramah cache

bytes:  |----------------- 1 MiB -----------------|
kepala: |-- 16 byte --|   (view: menunjuk ke bytes yang sama, tanpa salinan)
```

**Latihan (tanpa kunci jawaban).** Tambahkan cache LRU berkapasitas 1.000 dengan TTL pada pencarian `katalog_perpustakaan`, lalu ukur hit rate dan memori untuk beban akses berdistribusi Zipf (sebagian kecil kunci sangat sering diakses). *Kriteria penerimaan:* memori puncak stabil saat jumlah kunci unik dinaikkan 100×; laporan hit rate untuk tiga kapasitas berbeda dan satu kalimat keputusan kapasitas beserta alasannya.

## [Fase 7 — Keamanan, Isolasi & Anonimitas][7]

**Level:** Mahir → Expert · **Estimasi:** 4 minggu (≈ 40 jam) · **Tujuan fase:** merancang logika yang tetap benar ketika inputnya bermusuhan, rahasianya terjaga, dan radius kerusakannya terbatas.

### Modul 7.1 — Pemodelan Ancaman, Validasi di Batas & Serangan Logika Umum

**Level:** Mahir → Expert · **Estimasi:** 12–14 jam

**1. Deskripsi Konkret.** Menentukan *siapa bisa menyerang apa lewat mana*, memvalidasi semua input di batas sistem, dan menutup kelas serangan logika yang umum: path traversal, injeksi perintah, deserialisasi tak terbatas, ReDoS, dan kebocoran informasi lewat pesan galat.

**2. Konsep Dasar & Filosofi.** Mulai dari *batas kepercayaan*: setiap data yang melintasi batas (jaringan, file, argumen CLI, variabel lingkungan, bahkan output proses lain) dianggap tidak tepercaya sampai diparse. Prinsip *parse, don’t validate*: ubah input mentah menjadi tipe domain yang sah di satu pintu, sehingga kode di dalamnya tidak perlu curiga lagi. Pakai *allow-list* (yang diizinkan) alih-alih deny-list (yang dilarang), dan tetapkan *batas* ukuran, kedalaman, jumlah, dan waktu untuk setiap input. Jangan menyusun perintah shell atau kueri dari string input; kirim argumen terstruktur. Pesan galat untuk pemanggil harus minim detail; rincian teknis hanya untuk log internal. STRIDE (Spoofing, Tampering, Repudiation, Information disclosure, Denial of service, Elevation of privilege) membantu memeriksa ancaman secara sistematis.

**Dampak Desain:**

- Validasi tersebar di dalam logika → ada jalur yang terlewat; satu pintu parse membuat aturan tunggal dan teruji.
- Deny-list → penyerang selalu menemukan varian yang belum dilarang; allow-list lebih ketat tetapi menuntut pemeliharaan saat format sah bertambah.
- Tanpa batas ukuran atau kedalaman pada JSON, regex, atau upload → satu input kecil yang jahat dapat menghabiskan CPU atau memori (DoS).
- Regex dengan kuantifier bersarang pada input tak tepercaya → ReDoS (mesin RegExp Dart berbasis backtracking); sederhanakan pola dan batasi panjang input.
- Eksekusi lewat shell (`runInShell: true`) dengan string rakitan → injeksi perintah; argumen terstruktur menutup kelas serangan ini.
- Pesan galat terlalu rinci → membocorkan path, versi, atau struktur internal.

**3. Implementasi Inti.**

```dart
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p; // dart pub add path

/// Menolak path yang keluar dari akar (../, path absolut, dst).
/// Catatan: canonicalize bersifat leksikal; symlink butuh pemeriksaan tambahan.
File berkasAman(String akar, String masukan) {
  final akarKanonik = p.canonicalize(akar);
  final target = p.canonicalize(p.join(akarKanonik, masukan));
  if (!p.isWithin(akarKanonik, target)) {
    throw ArgumentError.value(masukan, 'masukan', 'di luar direktori yang diizinkan');
  }
  return File(target);
}

/// Tanpa shell: setiap elemen argumen diteruskan apa adanya, tidak ditafsirkan.
Future<ProcessResult> hashBerkas(File f) => Process.run('sha256sum', [f.path]);

/// Batas ukuran SEBELUM mem-parse: tolak input raksasa sejak awal.
Object? parseJsonAman(String teks, {int maksPanjang = 65536}) {
  if (teks.length > maksPanjang) throw const FormatException('input terlalu besar');
  return jsonDecode(teks);
}
```

**4. Terminologi Kunci.**

- **Batas kepercayaan (trust boundary):** garis tempat data berpindah dari pihak yang tidak kita kendalikan ke dalam sistem kita.
- **Parse, don’t validate:** mengubah input mentah menjadi tipe yang hanya bisa mewakili nilai sah, alih-alih mengecek berulang.
- **Allow-list / deny-list:** daftar yang diizinkan / daftar yang dilarang; yang pertama jauh lebih aman.
- **Path traversal:** trik memakai `../` agar program membaca atau menulis di luar folder yang seharusnya.
- **Injeksi perintah:** menyisipkan perintah ke dalam string yang dieksekusi oleh shell.
- **ReDoS:** serangan yang memicu regex bekerja eksponensial dengan input khusus hingga CPU habis.
- **DoS (denial of service):** membuat layanan tak bisa dipakai dengan menghabiskan sumber dayanya.
- **STRIDE:** daftar periksa enam kategori ancaman untuk pemodelan ancaman.

**5. Daftar Isi.** Batas kepercayaan dan permukaan serangan · STRIDE · Parse, don’t validate · Allow-list, batas ukuran/kedalaman/waktu · Path traversal dan symlink · `Process.run` tanpa shell · JSON/regex: DoS dan ReDoS · Galat dan log tanpa kebocoran.

**6. Sumber Referensi.**

- Dart security (filosofi dan praktik) — https://dart.dev/security
- `Process` (`dart:io`) — https://api.dart.dev/dart-io/Process-class.html
- `package:path` — https://pub.dev/packages/path
- `dart:convert` — https://dart.dev/libraries/dart-convert
- OWASP Top 10 — https://owasp.org/www-project-top-ten/

**7. Visualisasi.**

```text
[internet/file/argv/env] --(tidak tepercaya)--> | PARSE + BATAS | --> tipe domain sah --> logika inti
                                                |  allow-list    |
                                                |  ukuran/waktu  |
                                  ditolak <-----+----------------+
```

**Latihan (tanpa kunci jawaban).** Buat daftar ancaman STRIDE satu halaman untuk fitur “ekspor laporan ke file” di `katalog_perpustakaan`, lalu implementasikan pertahanannya (path aman, batas ukuran, tanpa shell). *Kriteria penerimaan:* test serangan berisi minimal 10 input jahat (`../../etc/passwd`, path absolut, nama file sangat panjang, JSON berkedalaman ekstrem, dan sebagainya) yang semuanya ditolak dengan galat terkendali tanpa membocorkan path internal.

### Modul 7.2 — Kriptografi Aman & Penanganan Rahasia

**Level:** Expert · **Estimasi:** 12–14 jam

**1. Deskripsi Konkret.** Memakai primitif kriptografi dengan benar lewat pustaka teruji (bukan buatan sendiri): acak aman, hash, HMAC, enkripsi terautentikasi, turunan kunci dari kata sandi, serta menangani rahasia (kunci, token, kata sandi) sepanjang hidupnya di memori, log, dan konfigurasi.

**2. Konsep Dasar & Filosofi.** Aturan pertama kriptografi: jangan merancang algoritma sendiri dan jangan merakit primitif sendiri bila ada pustaka yang diaudit. `Random()` bukan acak aman; token, kunci, dan nonce harus berasal dari `Random.secure()`. Kata sandi *tidak boleh* di-hash dengan hash cepat (SHA-256 polos); pakai fungsi turunan kunci yang sengaja lambat dan berbiaya memori (Argon2id, scrypt, atau PBKDF2 beriterasi tinggi). Enkripsi harus *terautentikasi* (AEAD seperti AES-GCM atau ChaCha20-Poly1305) agar kerusakan atau manipulasi terdeteksi. Perbandingan rahasia (token, MAC) harus *waktu-konstan* agar tidak bocor lewat selisih waktu. Rahasia tidak boleh masuk repositori, log, pesan galat, atau argumen proses yang terlihat di `ps`. `String` Dart tidak dapat dihapus dari memori secara andal; simpan rahasia di `Uint8List` dan timpa setelah dipakai sebagai upaya terbaik (tanpa jaminan penuh).

**Dampak Desain:**

- Merancang atau merakit kripto sendiri → celah halus yang tak terlihat saat uji fungsional; pakai pustaka teruji dan konfigurasi bawaan yang aman.
- `Random()` untuk token → dapat ditebak; `Random.secure()` memakai sumber acak sistem operasi dengan biaya sedikit lebih besar.
- Hash cepat untuk kata sandi → bocoran basis data dapat dibobol massal; KDF lambat menaikkan biaya serangan (dan biaya Anda, jadi kalibrasi).
- Perbandingan `==` pada token atau MAC → kebocoran waktu; pakai perbandingan waktu-konstan.
- Rahasia di `--dart-define` atau `String.fromEnvironment` → tertanam di biner dan dapat diekstrak; ambil rahasia saat runtime dari sumber terkontrol.
- Rahasia di log atau galat → bocor ke sistem pemantauan; saring (redact) di pintu log.

**3. Implementasi Inti.**

```dart
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart'; // dart pub add crypto

/// Token acak aman (CSPRNG): 32 byte = 256 bit entropi.
String tokenAcak([int panjangByte = 32]) {
  final acak = Random.secure();
  final data = Uint8List.fromList(
    List.generate(panjangByte, (_) => acak.nextInt(256)),
  );
  return base64Url.encode(data).replaceAll('=', '');
}

/// MAC: membuktikan keaslian dan keutuhan pesan (bukan kerahasiaan).
List<int> tandatangani(List<int> kunci, List<int> pesan) =>
    Hmac(sha256, kunci).convert(pesan).bytes;

/// Perbandingan waktu-konstan (upaya terbaik di level Dart).
bool samaKonstan(List<int> a, List<int> b) {
  var beda = a.length ^ b.length;
  for (var i = 0; i < a.length && i < b.length; i++) {
    beda |= a[i] ^ b[i];
  }
  return beda == 0;
}

/// Timpa rahasia setelah dipakai (upaya terbaik; GC mungkin sempat menyalin).
void hapusRahasia(Uint8List rahasia) => rahasia.fillRange(0, rahasia.length, 0);
```

VM dan compiler tidak menjamin sifat waktu-konstan; untuk jaminan lebih kuat, pakai fungsi dari pustaka kripto yang diaudit atau pustaka native yang diaudit lewat FFI (misal libsodium).

**4. Terminologi Kunci.**

- **CSPRNG:** generator angka acak yang aman secara kriptografi (`Random.secure()`), tidak bisa ditebak.
- **Entropi:** ukuran ketidakpastian atau keacakan; 256 bit berarti 2^256 kemungkinan.
- **Hash:** sidik jari satu arah dari data; tidak cocok untuk kata sandi bila cepat dihitung.
- **HMAC:** hash berkunci yang membuktikan pesan asli dan tidak diubah.
- **KDF (key derivation function):** fungsi lambat yang menurunkan kunci dari kata sandi (Argon2id, scrypt, PBKDF2).
- **AEAD:** enkripsi yang sekaligus menjamin kerahasiaan dan keaslian (AES-GCM, ChaCha20-Poly1305).
- **Nonce:** angka sekali pakai yang tidak boleh berulang untuk kunci yang sama.
- **Waktu-konstan:** perbandingan yang lamanya tidak bergantung pada isi data sehingga tidak membocorkan informasi.

**5. Daftar Isi.** Jangan buat kripto sendiri · Acak aman: `Random.secure()` · Hash vs HMAC vs KDF · Enkripsi AEAD dan nonce · Perbandingan waktu-konstan · Siklus hidup rahasia: simpan, pakai, hapus · Rahasia di konfigurasi, argumen proses, dan log · Batas jaminan di Dart (GC, `String` imutabel).

**6. Sumber Referensi.**

- `Random.secure` — https://api.dart.dev/dart-math/Random/Random.secure.html
- `package:crypto` — https://pub.dev/packages/crypto
- `package:cryptography` — https://pub.dev/packages/cryptography
- OWASP Cryptographic Storage Cheat Sheet — https://cheatsheetseries.owasp.org/cheatsheets/Cryptographic\_Storage\_Cheat\_Sheet.html
- OWASP Password Storage Cheat Sheet — https://cheatsheetseries.owasp.org/cheatsheets/Password\_Storage\_Cheat\_Sheet.html

**7. Visualisasi.**

```text
kata sandi --> [KDF lambat + salt]    --> kunci/hash tersimpan      (bukan SHA-256 polos)
pesan      --> [AEAD + nonce unik]    --> sandi + tag keaslian      (rusak/dimanipulasi = ditolak)
token      <-- [Random.secure()]                                    (bukan Random())
```

**Latihan (tanpa kunci jawaban).** Bangun brankas CLI kecil: menyimpan catatan terenkripsi AEAD dengan kunci turunan kata sandi (KDF), format file berversi, dan perbandingan MAC waktu-konstan; kata sandi dibaca tanpa echo dari terminal. *Kriteria penerimaan:* mengubah satu byte file membuat dekripsi ditolak; tidak ada rahasia di log atau `ps`; dua enkripsi isi yang sama menghasilkan sandi berbeda (nonce unik); parameter KDF tercatat di header file agar bisa dinaikkan kelak.

### Modul 7.3 — Rantai Pasok, Isolasi Proses & Anonimitas

**Level:** Expert · **Estimasi:** 10–12 jam

**1. Deskripsi Konkret.** Mengendalikan apa yang masuk ke program (dependensi pub, SDK, CA TLS), membatasi apa yang bisa dilakukan program (sandbox OS, hak minimal), dan mengurangi jejak data yang keluar (telemetri, permintaan jaringan).

**2. Konsep Dasar & Filosofi.** Kode yang tidak Anda tulis tetap *kode Anda* saat berjalan. Dependensi adalah keputusan keamanan: tiap paket menambah permukaan serangan. Praktik dasarnya: commit `pubspec.lock` untuk aplikasi dan biner, jalankan `dart pub get --enforce-lockfile` di CI agar resolusi tidak berubah diam-diam, tinjau `dart pub outdated` dan changelog sebelum menaikkan versi, utamakan paket dengan *verified publisher*, minimalkan jumlah dependensi, dan perhatikan *security advisories* yang ditampilkan pub saat resolusi (pengabaian yang terdokumentasi dilakukan lewat `ignored_advisories` di `pubspec.yaml`). SDK juga bagian dari rantai pasok: dokumentasi resmi dart.dev per November 2026 memuat banner keamanan bahwa Dart 3.13.7 memblokir kunci CA eMudhra yang dikompromikan, contoh nyata mengapa memperbarui SDK adalah bagian dari keamanan logika. Pada level proses, isolate bukan sandbox: batasi hak dengan proses terpisah di bawah `bwrap` atau unit `systemd` (tanpa jaringan, sistem berkas hanya-baca, memori dibatasi). Prinsip *least privilege* berlaku: beri proses hanya apa yang ia butuhkan.

**Dampak Desain:**

- Dependensi longgar tanpa lockfile → build berbeda antar waktu; kompromi di hulu masuk tanpa terlihat.
- Banyak paket kecil → permukaan serangan dan beban audit membesar; tiap dependensi harus memberi nilai nyata (bandingkan dengan menulis 20 baris sendiri).
- Isolate dianggap sandbox → kode dependensi berbahaya tetap punya hak penuh proses; sandbox OS menutup celah ini dengan harga kompleksitas operasional.
- Telemetri aktif secara bawaan → data penggunaan keluar dari mesin; matikan dan verifikasi.
- Pembaruan SDK diabaikan → kerentanan runtime (misal kepercayaan CA) tetap terbuka.

**3. Implementasi Inti.**

```bash
# Rantai pasok
dart pub get --enforce-lockfile   # CI: gagal bila pubspec.lock tidak cocok
dart pub outdated                 # lihat apa yang berubah sebelum menaikkan versi
dart pub deps                     # audit pohon dependensi (siapa membawa siapa)

# Privasi: matikan telemetri Dart CLI
dart --disable-telemetry

# Isolasi proses OS: tanpa jaringan, sistem berkas hanya-baca, /tmp terpisah
bwrap --ro-bind / / --dev /dev --proc /proc --tmpfs /tmp --unshare-net --die-with-parent ./build/app --input data.csv

# Batasi sumber daya via systemd (butuh cgroup v2 dan delegasi controller untuk sesi user)
systemd-run --user --scope -p MemoryMax=256M -p CPUQuota=50% ./build/app
```

Setelah mematikan telemetri, periksa berkas konfigurasi `dart-flutter-telemetry.config`: nilai `reporting=0` berarti pelaporan nonaktif.

**4. Terminologi Kunci.**

- **Rantai pasok perangkat lunak:** semua kode dan alat pihak lain yang ikut masuk ke produk Anda (paket, SDK, compiler, CA).
- **Lockfile (`pubspec.lock`):** catatan versi persis seluruh dependensi sehingga build bisa diulang.
- **Verified publisher:** penerbit paket pub.dev yang kepemilikan domainnya terverifikasi.
- **Security advisory:** pengumuman resmi tentang kerentanan pada paket atau SDK.
- **Sandbox:** lingkungan terbatas yang menahan program agar tidak menyentuh hal di luar izinnya.
- **Least privilege:** memberi program hak sesedikit mungkin yang masih cukup untuk bekerja.
- **Namespace / cgroup:** fitur Linux untuk memisahkan pandangan (jaringan, berkas) dan membatasi sumber daya sebuah proses.
- **Telemetri:** data penggunaan yang dikirim otomatis oleh alat ke pembuatnya.

**5. Daftar Isi.** Dependensi sebagai keputusan keamanan · `pubspec.lock`, `--enforce-lockfile`, `pub outdated`, `pub deps` · Security advisories dan verified publishers · SDK dan trust store TLS · Least privilege dan sandbox (`bwrap`, `systemd-run`) · Telemetri dan jejak jaringan (`PUB_HOSTED_URL`, `PUB_CACHE`, mode offline) · Build yang dapat direproduksi.

**6. Sumber Referensi.**

- Security advisories (pub) — https://dart.dev/go/pub-security-advisories
- Verified publishers — https://dart.dev/tools/pub/verified-publishers
- Pub environment variables — https://dart.dev/tools/pub/environment-variables
- `dart pub get` — https://dart.dev/tools/pub/cmd/pub-get
- Dart security — https://dart.dev/security
- Advisori keamanan repositori SDK — https://github.com/dart-lang/sdk/security/advisories

**7. Visualisasi.**

```text
pubspec.yaml --resolve--> pubspec.lock (versi pasti) --CI: --enforce-lockfile--> build identik
                                |
                         advisory? --> perbaiki / ignored_advisories (alasan tertulis)

proses Dart (hak penuh) --> bwrap/systemd: [tanpa jaringan][FS read-only][memori dibatasi]
```

**Latihan (tanpa kunci jawaban).** Audit proyek `konversi_satuan`: daftar semua dependensi langsung dan transitif, tulis alasan keberadaan tiap dependensi langsung, hapus yang tidak sepadan, lalu jalankan biner AOT di bawah `bwrap` tanpa jaringan. *Kriteria penerimaan:* CI gagal bila `pubspec.lock` berubah tanpa disengaja; biner tetap berfungsi di sandbox dengan sistem berkas hanya-baca; satu halaman keputusan tentang dependensi yang dipertahankan beserta alasannya.

## [Fase 8 — Kualitas & Verifikasi][8]

**Level:** Mahir → Expert · **Estimasi:** 3 minggu (≈ 30 jam) · **Tujuan fase:** membuktikan sebanyak mungkin kebenaran lewat uji otomatis dan analisis statis, bukan lewat keyakinan.

### Modul 8.1 — Strategi Pengujian: Unit, Properti, Fuzz & Deterministik

**Level:** Mahir → Expert · **Estimasi:** 12–14 jam

**1. Deskripsi Konkret.** Merancang pengujian yang menemukan bug sungguhan: test unit berbasis tabel, property-based testing (properti yang berlaku untuk ribuan input acak), fuzzing terkontrol, dan membuat kode asinkron atau berbasis waktu dapat diuji secara deterministik.

**2. Konsep Dasar & Filosofi.** Test bukan bukti kebenaran; ia hanya bisa menunjukkan *adanya* bug. Tujuannya meningkatkan kepercayaan dengan biaya efisien. Test unit memeriksa contoh pilihan manusia; *property-based testing* memeriksa *sifat* yang harus selalu benar (misal konversi bolak-balik mengembalikan nilai awal) pada ribuan input acak, lalu menyusutkan (shrink) kegagalan menjadi contoh minimal. Test yang baik deterministik: seed acak tetap dan dicatat, waktu disuntikkan (`package:clock`, `fake_async`), I/O dibungkus antarmuka yang bisa diganti. Fuzzing melempar input acak atau rusak untuk mencari crash. Hindari test yang menguji implementasi (rapuh) alih-alih perilaku, dan pisahkan test cepat (unit) dari yang lambat (integrasi).

**Dampak Desain:**

- Hanya test contoh → bug pada kombinasi input yang tidak terpikirkan lolos; properti acak menjangkau ruang yang jauh lebih luas.
- Test bergantung pada jam atau jaringan nyata → flaky (kadang gagal tanpa sebab kode); suntikkan waktu dan pakai fake I/O.
- Mock berlebihan → test memverifikasi mock, bukan perilaku; pakai fake sederhana atau objek nyata bila murah.
- Seed acak tidak dicatat → kegagalan tidak bisa direproduksi; selalu cetak seed saat gagal.
- Cakupan baris 100% → bukan jaminan kebenaran; cakupan mengukur apa yang dijalankan, bukan apa yang diverifikasi.

**3. Implementasi Inti.**

```dart
import 'dart:math';
import 'package:test/test.dart';

double konversi(double nilai, double faktor) => nilai * faktor;

void main() {
  // 1) Test berbasis tabel: data terpisah dari logika uji (nilai, faktor, harapan)
  final kasus = <(double, double, double)>[
    (5.0, 1000.0, 5000.0),
    (0.0, 1000.0, 0.0),
    (-2.0, 100.0, -200.0),
  ];
  for (final (nilai, faktor, harapan) in kasus) {
    test('konversi($nilai, $faktor) = $harapan', () {
      expect(konversi(nilai, faktor), closeTo(harapan, 1e-9));
    });
  }

  // 2) Properti dengan seed tetap: konversi bolak-balik kembali ke nilai awal
  test('properti: bolak-balik ~ identitas (seed 42)', () {
    final acak = Random(42);
    for (var i = 0; i < 10000; i++) {
      final nilai = (acak.nextDouble() - 0.5) * 1e6;
      final faktor = acak.nextDouble() * 999 + 0.001;
      final balik = konversi(konversi(nilai, faktor), 1 / faktor);
      expect(
        balik,
        closeTo(nilai, nilai.abs() * 1e-9 + 1e-9),
        reason: 'nilai=$nilai faktor=$faktor',
      );
    }
  });
}
```

**4. Terminologi Kunci.**

- **Test unit:** uji atas potongan kecil logika secara terisolasi.
- **Test berbasis tabel:** satu logika uji dijalankan atas banyak baris data masukan dan keluaran.
- **Property-based testing:** menguji sifat umum dengan input acak dalam jumlah besar.
- **Shrinking:** menyusutkan input gagal yang besar menjadi contoh sekecil mungkin yang tetap gagal.
- **Flaky test:** test yang kadang lulus kadang gagal tanpa perubahan kode.
- **Fake vs mock:** fake = implementasi sederhana yang benar-benar bekerja; mock = objek yang merekam dan memverifikasi panggilan.
- **Fuzzing:** melempar input acak atau rusak untuk memicu crash dan perilaku tak terduga.
- **Determinisme:** dijalankan ulang dengan masukan sama selalu memberi hasil sama.

**5. Daftar Isi.** Piramida pengujian · `package:test`: `group`, `setUp`, `expect`, matcher · Test berbasis tabel · Property-based testing (`kiri_check`) dan seed · Waktu terkendali: `clock`, `fake_async` · Fake vs mock (`mocktail`) · Fuzzing input terkontrol · Test asinkron dan stream · Menjaga test cepat dan stabil.

**6. Sumber Referensi.**

- `package:test` — https://pub.dev/packages/test
- `dart test` — https://dart.dev/tools/dart-test
- `package:kiri_check` (property-based) — https://pub.dev/packages/kiri\_check
- `package:fake_async` — https://pub.dev/packages/fake\_async
- `package:clock` — https://pub.dev/packages/clock
- `package:mocktail` — https://pub.dev/packages/mocktail

**7. Visualisasi.**

```text
integrasi / end-to-end : sedikit, lambat, menyeluruh
komponen + fake I/O    : sedang
unit + properti        : banyak, cepat, deterministik
(makin ke bawah makin murah dijalankan, makin sering dijalankan)
```

**Latihan (tanpa kunci jawaban).** Tulis tiga properti untuk `konversi_satuan` (bolak-balik, transitivitas A→B→C sama dengan A→C, monotonik untuk faktor positif), jalankan dengan 10.000 input acak, lalu lakukan mutasi manual: ubah satu operator pada kode dan pastikan setidaknya satu test gagal. *Kriteria penerimaan:* minimal lima mutasi manual semuanya tertangkap test; seed dicetak saat gagal; tidak ada test yang bergantung pada jam atau jaringan nyata.

### Modul 8.2 — Analisis Statis sebagai Bukti Ringan, Kontrak & Cakupan

**Level:** Mahir → Expert · **Estimasi:** 10–12 jam

**1. Deskripsi Konkret.** Memakai analyzer, lint, dan mode ketat sebagai “bukti ringan” yang berjalan setiap kode berubah; menerapkan *design by contract* (prakondisi, pascakondisi, invarian) dengan `assert`, `throw`, dan tipe; serta mengukur cakupan test dan menilai kualitasnya.

**2. Konsep Dasar & Filosofi.** Analisis statis memeriksa kode tanpa menjalankannya: dari null safety hingga lint seperti `unawaited_futures`, `only_throw_errors`, dan `avoid_dynamic_calls`. Mode `strict-casts`, `strict-inference`, dan `strict-raw-types` menutup celah `dynamic` yang diam-diam. Setiap lint yang dinyalakan adalah satu kelas bug yang ditolak otomatis. `assert` memeriksa invarian *saat pengembangan*: ia hanya aktif bila diaktifkan (misal `dart run --enable-asserts`) dan tidak ada di build rilis, sehingga `assert` bukan alat validasi input. Cakupan (coverage) mengukur baris yang *dijalankan* test, bukan yang *diverifikasi*; test tanpa `expect` tetap menaikkan cakupan. Mutation testing (mengubah kode sedikit dan memastikan ada test yang gagal) menguji kualitas test itu sendiri.

**Dampak Desain:**

- `assert` dipakai untuk validasi input → hilang di build rilis dan input jahat lolos; pakai `throw` untuk validasi, `assert` hanya untuk invarian internal.
- Lint terlalu sedikit → bug yang bisa ditolak otomatis lolos ke runtime; terlalu banyak tanpa kurasi → noise dan `// ignore` menumpuk. Nyalakan bertahap dan perlakukan setiap `ignore` sebagai utang tercatat.
- Mengejar angka cakupan → test tanpa asersi; ukur kualitas dengan mutasi.
- `dynamic`, `!`, dan cast eksplisit berserakan → bukti statis hilang; tiap pemakaian harus bisa dijustifikasi.
- Tanpa CI → semua bukti ini bergantung pada disiplin manual; jalankan analyze, format, dan test di setiap commit.

**3. Implementasi Inti.**

```dart
/// Kontrak: kapasitas > 0 (prakondisi); ukuran <= kapasitas (invarian objek).
class Antrean<T> {
  Antrean(this.kapasitas) {
    // validasi sungguhan: harus tetap ada di build rilis
    if (kapasitas <= 0) throw ArgumentError.value(kapasitas, 'kapasitas');
  }

  final int kapasitas;
  final _isi = <T>[];

  bool get penuh => _isi.length >= kapasitas;

  void masuk(T x) {
    if (penuh) throw StateError('antrean penuh'); // prakondisi method
    _isi.add(x);
    assert(_isi.length <= kapasitas, 'invarian rusak'); // pemeriksaan masa pengembangan
  }
}
```

```bash
dart analyze --fatal-infos
dart fix --dry-run && dart fix --apply
dart test --coverage=coverage
dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib --packages=.dart_tool/package_config.json
genhtml coverage/lcov.info -o coverage/html   # genhtml dari paket lcov
```

**4. Terminologi Kunci.**

- **Analisis statis:** pemeriksaan kode tanpa menjalankannya (dilakukan `dart analyze`).
- **Lint:** aturan opsional yang menandai pola rawan bug atau gaya buruk.
- **Design by contract:** merancang fungsi dan kelas dengan janji eksplisit: prakondisi, pascakondisi, invarian.
- **`assert`:** pemeriksaan yang hanya berjalan bila diaktifkan dan tidak ada di build rilis.
- **Cakupan (coverage):** persentase baris atau cabang yang dieksekusi test.
- **Mutation testing:** mengubah kode kecil-kecil (mutan) untuk memastikan test mendeteksinya.
- **CI (continuous integration):** otomatisasi yang menjalankan pemeriksaan di setiap perubahan kode.
- **`@useResult` / `@visibleForTesting`:** anotasi `package:meta` yang membuat analyzer menegakkan niat desain.

**5. Daftar Isi.** `dart analyze` dan `--fatal-infos` · Mode strict (`strict-casts`, `strict-inference`, `strict-raw-types`) · Memilih dan mengurasi lint · `dart fix` · Design by contract: `throw` vs `assert` · Anotasi `package:meta` · Cakupan dengan `dart test --coverage` · Mutation testing manual · CI sederhana.

**6. Sumber Referensi.**

- Customizing static analysis — https://dart.dev/tools/analysis
- Linter rules — https://dart.dev/tools/linter-rules
- `dart analyze` — https://dart.dev/tools/dart-analyze
- `dart fix` — https://dart.dev/tools/dart-fix
- `package:lints` — https://pub.dev/packages/lints
- `package:meta` — https://pub.dev/packages/meta
- `package:coverage` — https://pub.dev/packages/coverage

**7. Visualisasi.**

```text
commit --> format --> analyze (strict + lint) --> test --> coverage --> (mutasi berkala)
             |               |                     |
          gagal?          gagal?                gagal?   --> perbaiki sebelum lanjut
Bukti makin kuat ke kanan; biaya tiap pemeriksaan juga makin mahal ke kanan.
```

**Latihan (tanpa kunci jawaban).** Nyalakan seluruh mode strict dan 15 lint tambahan pada `katalog_perpustakaan`, perbaiki semua temuan tanpa `// ignore`, lalu lakukan mutasi manual pada 10 baris logika inti. *Kriteria penerimaan:* analyzer bersih dengan `--fatal-infos`; cakupan cabang minimal 90% pada lapisan domain; setiap mutasi tertangkap test (yang lolos dicatat dan ditambal dengan test baru); skrip lokal (`just` atau `make`) menjalankan semua langkah dengan satu perintah.

## [Fase 9 — Arsitektur, Ketahanan & Interoperabilitas (Expert/Enterprise)][9]

**Level:** Expert/Enterprise · **Estimasi:** 5 minggu (≈ 50 jam) · **Tujuan fase:** menyusun logika yang tetap sehat saat skalanya membesar: banyak modul, banyak tim, banyak kegagalan, banyak platform.

### Modul 9.1 — Arsitektur Modular: Layering, Hexagonal, Dependency Inversion & Desain Paket

**Level:** Expert · **Estimasi:** 14–16 jam

**1. Deskripsi Konkret.** Menyusun kode menjadi lapisan dan paket dengan batas yang jelas: domain murni di inti, aplikasi (use case) di sekelilingnya, infrastruktur (database, jaringan, file) di tepi, dengan ketergantungan selalu mengarah ke dalam. Mencakup desain API publik paket, pub workspaces untuk monorepo, dan trade-off generasi kode.

**2. Konsep Dasar & Filosofi.** *Hexagonal architecture* (ports and adapters): logika bisnis tidak tahu apakah datanya berasal dari SQLite, HTTP, atau file; ia hanya bergantung pada *antarmuka (port)* yang ia definisikan sendiri, dan adapter di tepi mengimplementasikannya. Inilah *dependency inversion*: modul tingkat tinggi tidak bergantung pada modul tingkat rendah. Manfaatnya: domain bisa diuji tanpa I/O, infrastruktur bisa diganti, dan dampak perubahan teknologi terkunci di tepi. Pada tingkat paket Dart: letakkan implementasi di `lib/src/` dan ekspor hanya API publik lewat satu berkas `lib/nama_paket.dart`; apa yang tidak diekspor bebas berubah tanpa mematahkan pemakai. *Pub workspaces* memungkinkan banyak paket dalam satu repositori dengan satu resolusi dependensi. Soal generasi kode: tim Dart menghentikan pengerjaan makro (diumumkan awal 2025); alat realistis hari ini adalah `build_runner` dan `source_gen` (misal `json_serializable`), dengan harga waktu build dan berkas hasil generate; pertimbangkan menulis tangan bila jumlahnya kecil.

**Dampak Desain:**

- Domain bergantung langsung pada paket database atau HTTP → tidak bisa diuji tanpa I/O dan terkunci pada vendor; port + adapter memutus ketergantungan itu.
- Terlalu banyak lapisan untuk aplikasi kecil → boilerplate dan indireksi tanpa manfaat; mulai sederhana, ekstrak port saat ada kebutuhan nyata (dua implementasi atau kebutuhan uji).
- Semuanya diekspor dari `lib/` → setiap perubahan internal menjadi perubahan yang mematahkan; batasi API publik.
- Dependency injection lewat konstruktor → eksplisit dan mudah diuji, tetapi verbose; container DI menyembunyikan ketergantungan dan menunda galat ke runtime.
- Generasi kode → mengurangi boilerplate dan galat tulis tangan, tetapi menambah langkah build, berkas hasil generate, dan kerumitan debugging.

**3. Implementasi Inti** (memakai `StatusBuku` dan `transisi` dari Modul 3.1 dan 4.2).

```dart
// ---- domain (inti): tahu aturan bisnis, tidak tahu infrastruktur ----
abstract interface class RepositoriBuku { // PORT: didefinisikan oleh domain
  Future<StatusBuku?> cariStatus(String isbn);
  Future<void> simpanStatus(String isbn, StatusBuku status);
}

class LayananPeminjaman { // use case
  LayananPeminjaman(this._repo);
  final RepositoriBuku _repo; // bergantung pada port, bukan implementasi

  Future<void> pinjam(String isbn, String idAnggota, DateTime tempo) async {
    final status = await _repo.cariStatus(isbn);
    final baru = transisi(status ?? Tersedia(), Meminjam(idAnggota, tempo));
    await _repo.simpanStatus(isbn, baru);
  }
}

// ---- infrastruktur (tepi): adapter yang mengimplementasikan port ----
class RepositoriMemori implements RepositoriBuku { // untuk test; adapter file/SQLite menyusul
  final _data = <String, StatusBuku>{};

  @override
  Future<StatusBuku?> cariStatus(String isbn) async => _data[isbn];

  @override
  Future<void> simpanStatus(String isbn, StatusBuku status) async {
    _data[isbn] = status;
  }
}
```

```yaml
# pubspec.yaml di akar monorepo (pub workspaces, Dart 3.6+)
name: katalog_workspace
publish_to: none
environment:
  sdk: ^3.13.0
workspace:
  - packages/domain
  - packages/infrastruktur
  - packages/cli
# tiap paket anggota memuat:  resolution: workspace
```

**4. Terminologi Kunci.**

- **Layering (berlapis):** memisahkan kode menurut tanggung jawab; ketergantungan hanya mengarah ke satu sisi.
- **Hexagonal architecture / ports and adapters:** inti bisnis di tengah berbicara lewat “port” (antarmuka); “adapter” di tepi menghubungkannya ke dunia nyata.
- **Dependency inversion:** modul tingkat tinggi bergantung pada abstraksi, bukan pada detail modul tingkat rendah.
- **Dependency injection (DI):** menyerahkan ketergantungan dari luar (lewat konstruktor) alih-alih membuatnya sendiri di dalam.
- **API publik vs `lib/src`:** yang diekspor dijanjikan stabil; isi `src` bebas berubah.
- **Semantic versioning:** aturan nomor versi MAJOR.MINOR.PATCH yang menyampaikan tingkat perubahan.
- **Monorepo / workspace:** banyak paket dalam satu repositori yang berbagi satu resolusi dependensi.
- **Code generation:** menghasilkan kode otomatis dari kode atau anotasi (`build_runner`).

**5. Daftar Isi.** Layering dan arah ketergantungan · Hexagonal: port dan adapter · Dependency injection lewat konstruktor · Desain API publik: `lib/src`, `export`, `@internal`, semver · Pub workspaces untuk monorepo · Generasi kode: `build_runner`, `source_gen`, dan status makro · Mengukur kopling dan kohesi · Kapan *tidak* memakai arsitektur berat.

**6. Sumber Referensi.**

- Create packages — https://dart.dev/tools/pub/create-packages
- Package layout conventions — https://dart.dev/tools/pub/package-layout
- Pub workspaces — https://dart.dev/to/pub-workspaces
- Versioning (semver di pub) — https://dart.dev/tools/pub/versioning
- `build_runner` — https://dart.dev/tools/build\_runner
- Pembaruan makro Dart — https://medium.com/dartlang/an-update-on-dart-macros-data-serialization-06d3037d4f12

**7. Visualisasi.**

```text
[ CLI / HTTP / UI ] <-- adapter masuk -->  +------------------------------+
                                           |  aplikasi (use case)         |
[ SQLite / file / API ] <-- adapter keluar |   +----------------------+   |
                                           |   |  domain (murni)      |   |
                                           |   +----------------------+   |
                                           +------------------------------+
Aturan emas: panah ketergantungan SELALU menuju ke dalam (ke domain).
```

**Latihan (tanpa kunci jawaban).** Pisahkan `katalog_perpustakaan` menjadi tiga paket dalam satu workspace (`domain`, `infrastruktur`, `cli`) dengan domain hanya bergantung pada SDK dan `meta`. Sediakan dua adapter repositori (memori dan file JSONL). *Kriteria penerimaan:* seluruh test domain berjalan tanpa menyentuh disk atau jaringan; mengganti adapter tidak mengubah satu baris pun di domain atau aplikasi; skrip `grep` sederhana di CI membuktikan nol impor dari domain ke infrastruktur.

### Modul 9.2 — Pola Ketahanan Sistem

**Level:** Expert/Enterprise · **Estimasi:** 12–14 jam

**1. Deskripsi Konkret.** Merancang logika yang tetap berfungsi dan pulih ketika dunia tidak ideal: retry dengan backoff dan jitter, timeout berlapis, circuit breaker, bulkhead, idempotensi, rate limiting, dan observabilitas dasar (log terstruktur, metrik).

**2. Konsep Dasar & Filosofi.** Kegagalan adalah kondisi normal dalam sistem yang bergantung pada jaringan, disk, atau layanan lain, bukan pengecualian. Pola ketahanan menjaga agar satu kegagalan kecil tidak menjadi kegagalan berantai. *Retry* hanya aman untuk operasi yang *idempoten* (aman diulang) dan harus memakai *backoff eksponensial dengan jitter* agar ribuan klien tidak mengulang serentak (thundering herd). *Timeout* harus ada di setiap panggilan keluar; tanpa itu satu dependensi lambat bisa menahan seluruh sistem. *Circuit breaker* berhenti memanggil dependensi yang sedang rusak agar ia sempat pulih dan agar kita gagal cepat. *Bulkhead* membatasi sumber daya per dependensi (pool terpisah) agar kegagalan satu tidak menghabiskan semuanya. *Rate limiting* (misal token bucket) melindungi sistem dari kelebihan beban, termasuk dari klien jahat. Semuanya membutuhkan *observabilitas*: log terstruktur dan metrik agar perilaku di produksi bisa dilihat.

**Dampak Desain:**

- Retry tanpa backoff dan jitter → badai ulang yang memperparah gangguan; dengan jitter beban tersebar.
- Retry pada operasi non-idempoten → efek ganda (pinjaman ganda, tagihan ganda); pakai kunci idempotensi.
- Tanpa timeout → antrean permintaan menumpuk, memori habis, kegagalan berantai.
- Circuit breaker terlalu sensitif → memutus layanan yang sehat; terlalu longgar → tidak melindungi. Kalibrasi dengan data.
- Pool bersama untuk semua dependensi → satu dependensi lambat memonopoli sumber daya; bulkhead memisahkannya dengan harga utilisasi yang lebih rendah.
- Log tidak terstruktur → sulit dicari dan diagregasi; log berisi rahasia → kebocoran (Modul 7.2).

**3. Implementasi Inti.**

```dart
import 'dart:async';
import 'dart:math';

/// Retry dengan backoff eksponensial + full jitter, hanya untuk galat yang layak diulang.
Future<T> denganRetry<T>(
  Future<T> Function() kerja, {
  int maksPercobaan = 4,
  Duration dasar = const Duration(milliseconds: 100),
  Duration timeout = const Duration(seconds: 2),
  bool Function(Object galat)? layakDiulang,
  Random? acak,
}) async {
  final rng = acak ?? Random();
  for (var percobaan = 1;; percobaan++) {
    try {
      return await kerja().timeout(timeout); // timeout di SETIAP percobaan
    } on Object catch (galat) {
      final bisaUlang = layakDiulang?.call(galat) ?? galat is TimeoutException;
      if (!bisaUlang || percobaan >= maksPercobaan) rethrow;
      final batas = dasar.inMilliseconds * (1 << (percobaan - 1)); // 100, 200, 400, ...
      await Future<void>.delayed(
        Duration(milliseconds: rng.nextInt(batas + 1)), // full jitter
      );
    }
  }
}
```

**4. Terminologi Kunci.**

- **Idempoten:** operasi yang bila diulang menghasilkan keadaan akhir yang sama seperti sekali saja.
- **Backoff eksponensial:** jeda antar-percobaan yang berlipat ganda tiap kegagalan.
- **Jitter:** keacakan pada jeda agar banyak klien tidak mencoba ulang serentak.
- **Thundering herd:** lonjakan permintaan serempak yang menjatuhkan layanan yang sedang pulih.
- **Circuit breaker:** pemutus sirkuit yang menghentikan sementara panggilan ke dependensi yang terus gagal.
- **Bulkhead:** sekat sumber daya per dependensi agar kegagalan tidak menjalar.
- **Token bucket:** algoritma pembatas laju: “token” terisi stabil, tiap permintaan mengonsumsi satu.
- **Observabilitas:** kemampuan memahami kondisi sistem dari log, metrik, dan jejak yang dikeluarkannya.

**5. Daftar Isi.** Kegagalan sebagai kondisi normal · Idempotensi dan kunci idempotensi · Retry, backoff, jitter · Timeout berlapis dan deadline · Circuit breaker dan bulkhead (`package:pool`) · Rate limiting: token bucket · Degradasi anggun (graceful degradation) · Log terstruktur dan metrik dasar (`package:logging`).

**6. Sumber Referensi.**

- `Future` (termasuk `timeout`) — https://api.dart.dev/dart-async/Future-class.html
- `package:pool` — https://pub.dev/packages/pool
- `package:logging` — https://pub.dev/packages/logging
- `package:async` — https://pub.dev/packages/async
- AWS Architecture Blog: Exponential Backoff and Jitter — https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/

**7. Visualisasi.**

```text
panggil --> [timeout] --> gagal? --> layak diulang? --ya--> tunggu rand(0..2^n * dasar) --> ulangi
                                          '--tidak / habis--> rethrow

circuit breaker:  TERTUTUP --(gagal beruntun)--> TERBUKA --(waktu tunggu)--> SETENGAH TERBUKA
                      ^                                                          |
                      '-----------------(percobaan sukses)-----------------------'
```

**Latihan (tanpa kunci jawaban).** Bungkus adapter eksternal `katalog_perpustakaan` (misal layanan pencarian ISBN palsu yang sengaja gagal 30% dan lambat 10%) dengan retry + jitter, timeout, dan circuit breaker; buat operasi `pinjam` idempoten lewat kunci permintaan. *Kriteria penerimaan:* uji beban sintetis 1.000 permintaan menunjukkan tingkat sukses efektif minimal 99% tanpa pinjaman ganda; saat layanan dimatikan total, sistem gagal cepat (circuit terbuka) rata-rata di bawah 50 ms; semua keputusan retry tercatat sebagai log terstruktur tanpa rahasia.

### Modul 9.3 — Interoperabilitas & Lintas-Platform: FFI, JS/Wasm, Build Hooks

**Level:** Expert · **Estimasi:** 12–14 jam

**1. Deskripsi Konkret.** Menghubungkan logika Dart dengan dunia lain (pustaka C/Rust lewat FFI, JavaScript/Wasm di web, bahasa lain lewat proses atau protokol) dan menulis logika yang berperilaku konsisten di banyak target kompilasi (VM, AOT, JS, Wasm), termasuk memahami perbedaan semantik antar target.

**2. Konsep Dasar & Filosofi.** Dart memanggil kode native lewat `dart:ffi` (foreign function interface): Anda memetakan tanda tangan fungsi C ke tipe Dart lalu memanggilnya langsung; sisi lain (Rust, Zig, C++) harus mengekspos ABI C. Memori native tidak dikelola GC Dart: alokasi harus dibebaskan (manual, lewat `Arena` dari `package:ffi`, atau `Finalizer`), dan galat memori (use-after-free, buffer overflow) kembali menjadi risiko, sehingga batas FFI adalah batas kepercayaan (Modul 7.1). `package:ffigen` dan `package:jnigen` menghasilkan binding otomatis; *build hooks* (`package:hooks`) memungkinkan sebuah paket membangun atau membundel aset native saat build. Untuk web: `dart:js_interop` dan `package:web` adalah jembatan bertipe ke JavaScript, dan target web punya semantik berbeda (misal presisi `int` di JS; Wasm punya karakteristik sendiri), sehingga logika lintas-platform harus diuji pada setiap target yang dituju. Import bersyarat (`if (dart.library.io)`) memilih implementasi sesuai platform tanpa mencemari domain.

**Dampak Desain:**

- FFI untuk jalur panas yang kecil → overhead panggilan dan kerumitan melebihi manfaat; pakai bila ada pustaka native yang matang atau komputasi sangat berat, dan ukur dulu (Modul 6.2).
- Memori native tidak dibebaskan → kebocoran yang tidak terlihat oleh GC Dart; gunakan `Arena` atau `Finalizer`, dan uji sisi native dengan valgrind atau ASan.
- Mempercayai data dari native tanpa validasi → kerusakan memori menjalar ke seluruh proses; perlakukan sebagai input tak tepercaya.
- Logika diasumsikan identik di semua target → bug khusus web (presisi `int`, perilaku bitwise) lolos; jalankan test pada setiap target (`dart test -p vm,chrome`).
- Import bersyarat tersebar di mana-mana → logika platform bocor ke domain; kumpulkan di adapter tepi (Modul 9.1).

**3. Implementasi Inti.**

```dart
// FFI: memanggil strlen milik libc tanpa kode native tambahan (Linux/macOS)
import 'dart:ffi';
import 'package:ffi/ffi.dart'; // dart pub add ffi

typedef _StrlenC = IntPtr Function(Pointer<Utf8>); // size_t ~ IntPtr di platform 64-bit umum
typedef _StrlenDart = int Function(Pointer<Utf8>);

int panjangC(String s) {
  final libc = DynamicLibrary.process(); // simbol libc dari proses yang berjalan
  final strlen = libc.lookupFunction<_StrlenC, _StrlenDart>('strlen');
  return using((Arena arena) {
    // Arena membebaskan semua memori native begitu blok selesai
    final p = s.toNativeUtf8(allocator: arena);
    return strlen(p);
  });
}
```

```dart
// penyimpanan.dart: kontrak platform-netral yang dipakai domain
export 'penyimpanan_stub.dart'
    if (dart.library.io) 'penyimpanan_io.dart'
    if (dart.library.js_interop) 'penyimpanan_web.dart';
```

**4. Terminologi Kunci.**

- **FFI (foreign function interface):** mekanisme memanggil fungsi yang ditulis dalam bahasa lain (umumnya C) dari Dart.
- **ABI (application binary interface):** kesepakatan tingkat biner tentang cara fungsi dipanggil dan data disusun; ABI C menjadi “bahasa umum” antar-bahasa.
- **Binding:** kode perekat yang memetakan fungsi dan tipe native ke tipe Dart (bisa dihasilkan `ffigen`).
- **`Arena`:** pengelola alokasi native yang membebaskan semua memori sekaligus saat blok selesai.
- **Build hook:** skrip yang dijalankan toolchain Dart saat build untuk membangun atau membundel aset native bersama paket.
- **Interop JS (`dart:js_interop`):** jembatan bertipe antara Dart dan JavaScript untuk target web.
- **Wasm (WebAssembly):** format biner portabel yang dijalankan browser; salah satu target kompilasi Dart.
- **Import bersyarat:** `import ... if (dart.library.io)` memilih berkas berbeda tergantung kemampuan platform.

**5. Daftar Isi.** `dart:ffi`, `package:ffi`, `Arena`, `Finalizer` · `ffigen` dan `jnigen` (binding otomatis) · Build hooks dan native assets (`package:hooks`) · Rust/C++ lewat ABI C · `dart:js_interop` dan `package:web` · Dart ke Wasm · Perbedaan semantik antar target · Import bersyarat dan adapter platform · Alternatif tanpa FFI: proses terpisah, stdio/socket, protobuf/gRPC.

**6. Sumber Referensi.**

- Interop (ringkasan) — https://dart.dev/interop
- C interop (FFI) — https://dart.dev/interop/c-interop
- Build hooks — https://dart.dev/tools/hooks
- JS interop — https://dart.dev/interop/js-interop
- Dart di web dan Wasm — https://dart.dev/web/wasm
- `package:ffi` — https://pub.dev/packages/ffi
- `package:ffigen` — https://pub.dev/packages/ffigen
- Libraries and imports (import bersyarat) — https://dart.dev/language/libraries

**7. Visualisasi.**

```text
Dart (aman, GC)  --FFI-->  [ batas kepercayaan ]  --> C/Rust (memori manual, ABI C)
                                   ^
              validasi + Arena/Finalizer + uji di sisi native

Satu kode, banyak target:   VM  |  AOT  |  JS  |  Wasm
                            uji di tiap target yang dituju (int, bitwise, I/O berbeda)
```

**Latihan (tanpa kunci jawaban).** Pindahkan satu operasi `konversi_satuan` yang berat (misal parsing massal) ke pustaka C atau Rust kecil dengan ABI C, panggil lewat FFI, lalu bandingkan dengan implementasi Dart murni (ukur dengan Modul 6.2). Sediakan juga adapter penyimpanan dengan import bersyarat untuk VM dan web. *Kriteria penerimaan:* tidak ada kebocoran memori native (diverifikasi valgrind atau ASan di sisi native); keputusan “FFI atau Dart murni” ditulis dengan angka pengukuran; test domain lulus di VM dan di web (`dart test -p vm,chrome`).

## [Fase 10 — Capstone & Penguasaan][10]

**Level:** Expert · **Estimasi:** 6 minggu (≈ 60 jam) · **Tujuan fase:** mengintegrasikan keenam sumbu (kebenaran, keamanan, ketahanan, kecepatan, efisiensi, keterawatan) dalam satu proyek utuh dan mempertahankan keputusan desainnya.

**Pilih satu proyek (atau rancang yang setara).** Setiap proyek wajib memuat: spesifikasi tertulis, model tipe yang menutup keadaan ilegal, test (tabel + properti), pengukuran kinerja AOT, model ancaman satu halaman, dan *Catatan Keputusan Desain* yang menyebut sumbu mana yang dikorbankan dan mengapa.

1. **Interpreter mini** (lexer, parser Pratt, AST sealed, evaluator, galat berlokasi baris). Menguji: sealed dan pattern, rekursi, galat sebagai tipe, batas kedalaman dan ukuran (keamanan), benchmark.
2. **KV store dengan WAL** (write-ahead log, snapshot, kompaksi, LRU/TTL, pemulihan setelah crash). Menguji: invarian, imutabilitas, I/O streaming, ketahanan, konkurensi.
3. **Penjadwal tugas berbasis graf** (topological sort, eksekusi paralel di isolate, retry/backoff, batas sumber daya, pembatalan). Menguji: graf, isolate, race condition, pola ketahanan.
4. **Brankas rahasia CLI** (KDF, AEAD, format berversi, perbandingan waktu-konstan, sandbox `bwrap`). Menguji: kriptografi, manajemen rahasia, isolasi proses, rantai pasok.
5. **TUI Game of Life atau Snake** (loop render di terminal dengan `dart:io`, input mentah, tick deterministik berseed, mesin keadaan). Menguji: state machine, alokasi, determinisme. Untuk TUI, [`package:dart_console`](https://pub.dev/packages/dart_console) bisa membantu.

**Rubrik penerimaan** (tiap butir lulus atau gagal):

- **Kebenaran:** spesifikasi, test tabel, minimal tiga properti; tidak ada `dynamic` atau `!` di domain.
- **Keamanan:** model ancaman, validasi di batas, tidak ada rahasia di log, dependensi diaudit dan lockfile dikunci.
- **Ketahanan:** timeout di setiap I/O keluar, kegagalan terkendali dengan kode keluar bermakna, pemulihan teruji.
- **Kecepatan dan sumber daya:** laporan benchmark AOT (min, median, p95) dan RSS puncak; satu optimasi diterima dan satu ditolak lengkap dengan alasan.
- **Keterawatan:** arsitektur berlapis dengan domain bebas I/O, API publik minimal, README yang menjelaskan keputusan.
- **Kebiasaan belajar:** Jurnal Galat terisi, catatan Markdown per modul di GitHub, dan review dengan konteks penuh.

**Evaluasi diri akhir.** Jelaskan tanpa catatan, dalam 10 menit, kepada orang non-teknis mengapa sebuah logika yang Anda bangun aman dan cepat; lalu jelaskan kepada engineer lain trade-off yang Anda ambil. Bila salah satunya macet, kembali ke modul terkait.

## Lampiran A — Matriks Dampak Desain Lintas Fase

Ringkasan keputusan “jika memilih X, dampaknya Y” yang berulang di seluruh kurikulum:

- **Kebenaran vs Kecepatan:** cek tambahan (validasi, invarian, tipe ketat) menambah sedikit biaya CPU tetapi mengurangi bug; hapus cek demi kecepatan hanya setelah profil membuktikan bagian itu jalur panas.
- **Kecepatan vs Keterawatan:** mikro-optimasi membuat kode lebih sulit dipahami; bungkus dengan test dan komentar *mengapa*.
- **Keamanan vs Kemudahan:** allow-list, sandbox, dan batas ukuran menambah konfigurasi dan gesekan, tetapi mengecilkan radius kerusakan.
- **Ketahanan vs Kompleksitas:** retry, circuit breaker, dan idempotensi menambah bagian yang bergerak; pasang hanya di batas yang memang bisa gagal (jaringan, disk).
- **Fleksibilitas vs Jaminan:** `dynamic`, hierarki terbuka, dan refleksi fleksibel tetapi tanpa jaminan compiler; `sealed` dan tipe ketat lebih kaku tetapi terbukti.
- **Memori vs CPU:** cache dan memoization menghemat CPU dan memakan memori; stream dan evaluasi malas menghemat memori tetapi kadang menghitung ulang.
- **Abstraksi vs Kejelasan:** port, adapter, dan DI memudahkan uji dan penggantian, tetapi menambah indireksi; pakai bila ada alasan nyata.
- **Statis vs Dinamis:** keputusan saat kompilasi (tipe, sealed, `const`) dini dan murah; keputusan saat runtime (refleksi, konfigurasi) fleksibel tetapi mahal diverifikasi.

## Lampiran B — Fleksibilitas & Adaptasi ke Bidang Lain

Kurikulum ini sengaja menahan konteks aplikasi agar prinsipnya bisa dipindahkan:

- **CLI/TUI dan otomasi sistem:** Fase 1–3, 6, 7; proyek 4 dan 5.
- **Server/backend (HTTP, worker):** Fase 5, 7, 9; mulai dari [Dart di server](https://dart.dev/server).
- **Pemrosesan data dan batch:** Fase 2, 4, 5, 6; proyek 2 dan 3.
- **Aplikasi Flutter (UI):** letakkan logika inti (domain dan aplikasi) di paket Dart murni yang diuji tanpa UI; Flutter menjadi adapter. Fase 3, 4, 9.
- **Keamanan dan tooling:** Fase 7 dan 8: pemindai lockfile, pemeriksa konfigurasi, alat analisis statis.
- **Interop dan sistem tertanam:** Fase 6 dan 9 (FFI ke C/Rust).

**Memperluas kurikulum:** tambahkan modul baru dengan template yang sama (7 bagian + Dampak Desain + Latihan tanpa kunci), ganti proyek benang merah dengan domain Anda sendiri, dan pantau [changelog SDK](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md) serta [repositori evolusi bahasa](https://github.com/dart-lang/language) agar fitur baru masuk sebagai modul.

## Lampiran C — Peta Interoperabilitas

- **C/C++/Rust:** `dart:ffi`, `package:ffi`, `package:ffigen` — https://dart.dev/interop/c-interop
- **Java/Kotlin dan Objective-C/Swift:** `package:jnigen`, `package:ffigen` — https://dart.dev/interop/java-interop dan https://dart.dev/interop/objective-c-interop
- **JavaScript/Wasm:** `dart:js_interop`, `package:web` — https://dart.dev/interop/js-interop
- **JSON:** `dart:convert` dan pola sealed untuk validasi — https://dart.dev/libraries/serialization/json
- **Protokol dan layanan:** `package:protobuf`, `package:grpc`, `package:http`, `package:shelf` — https://pub.dev
- **Basis data:** `package:sqlite3` (FFI), `package:postgres` — https://pub.dev

## Lampiran D — Sumber Daya Komunitas

- **Dokumentasi dan API:** https://dart.dev · https://api.dart.dev
- **Spesifikasi bahasa:** https://dart.dev/resources/language/spec
- **Repositori SDK dan issue tracker:** https://github.com/dart-lang/sdk
- **Evolusi bahasa (proposal dan diskusi):** https://github.com/dart-lang/language
- **Paket dan skor kualitas:** https://pub.dev
- **Diskusi komunitas:** Flutter/Dart Discord (tautan resmi dikelola di halaman Chat repositori Flutter: https://github.com/flutter/flutter/blob/main/docs/contributing/Chat.md) · Reddit: https://www.reddit.com/r/dartlang/ · Stack Overflow: https://stackoverflow.com/questions/tagged/dart
- **Latihan terarah:** Exercism track Dart https://exercism.org/tracks/dart · Advent of Code https://adventofcode.com
- **Bacaan mendalam:** Introduction to Dart VM https://mrale.ph/dartvm · Effective Dart https://dart.dev/effective-dart

## Lampiran E — Sertifikasi & Validasi Keahlian

- **Sertifikasi resmi:** pada 10 November 2026 penyusun tidak menemukan sertifikasi Dart resmi dari tim Dart atau Google. Ada sertifikasi pihak ketiga (misal “Certified Dart Professional” dari Vskills) dengan bobot industri yang bervariasi dan umumnya menekankan sintaks atau Flutter, bukan kualitas logika.
- **Validasi yang lebih kuat:** (1) paket yang Anda terbitkan di pub.dev dengan analisis dan test bersih; (2) kontribusi yang di-merge ke proyek dart-lang atau ekosistemnya; (3) benchmark dan model ancaman yang Anda publikasikan; (4) catatan Markdown di GitHub yang memperlihatkan penalaran, bukan hafalan; (5) Exercism dan Advent of Code sebagai bukti ketangkasan algoritmik; (6) program komunitas seperti [Google Developer Experts](https://developers.google.com/community/experts).
- **Pelengkap formal:** bila ingin validasi di sisi keamanan atau sistem, pilih sertifikasi yang diakui industri pada bidang tersebut (administrasi Linux, keamanan aplikasi, kriptografi terapan).

## Lampiran F — Hasil Pembelajaran (Learning Outcomes)

Setelah menyelesaikan kurikulum ini, peserta mampu:

1. Menerjemahkan masalah samar menjadi spesifikasi, invarian, dan kriteria penerimaan yang dapat diuji.
2. Menentukan tempat yang tepat untuk logika di dalam class dan menelusuri jalur pemanggilannya.
3. Memilih struktur data dan algoritma berdasarkan biaya terukur, dan menjelaskan trade-off-nya dengan angka.
4. Memodelkan domain sehingga keadaan ilegal tidak terwakili (sealed, pattern, record, extension types).
5. Merancang penanganan kesalahan (exception atau tipe hasil) dan batas kegagalan dengan sengaja.
6. Menalar urutan eksekusi asinkron, mencegah race condition, mengelola stream dengan backpressure, dan memakai isolate dengan benar.
7. Mengukur kinerja dan memori secara ilmiah (AOT, profil, sebaran) dan mengoptimasi hanya yang terbukti penting.
8. Membangun logika yang aman: model ancaman, validasi di batas, kriptografi dengan pustaka teruji, rantai pasok terkunci, dan isolasi proses OS.
9. Menjaga kualitas dengan test tabel dan properti, analisis statis ketat, kontrak, dan cakupan yang bermakna.
10. Menyusun arsitektur modular dengan ports and adapters, API paket yang stabil, dan pola ketahanan.
11. Menghubungkan Dart dengan dunia native dan web secara aman, serta menulis logika lintas-target yang teruji.
12. Mempertahankan setiap keputusan desain dengan menyebut sumbu mana yang dikorbankan dan mengapa.

## Lampiran G — Catatan Verifikasi & Pemeliharaan

- **Versi:** dokumentasi resmi dart.dev per November 2026 merefleksikan Dart 3.13.7. Primary constructors stabil sejak Dart 3.13, dot shorthands hadir sejak Dart 3.10, dan makro dihentikan oleh tim Dart. Periksa [changelog SDK](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md) sebelum memperbarui contoh, terutama saat Dart 3.14 rilis stabil.
- **Tautan:** tautan dart.dev diambil dari navigasi situs resmi per 10 November 2026; tautan pub.dev, GitHub, dan situs pihak ketiga perlu dicek ulang secara berkala.
- **Contoh kode:** ditulis untuk Dart 3.13+; jalankan `dart analyze` dan `dart test` di proyek Anda sendiri sebelum menganggapnya benar, karena kebiasaan memverifikasi adalah bagian dari kurikulum ini.
- **Pemeliharaan:** tinjau kurikulum tiap rilis Dart besar (tiga bulanan) dan tambahkan modul untuk fitur baru yang mengubah cara logika dirancang.

[1]: ./bagian-1/README.md
[2]: ./bagian-2/README.md
[3]: ./bagian-3/README.md
[4]: ./bagian-4/README.md
[5]: ./bagian-5/README.md
[6]: ./bagian-6/README.md
[7]: ./bagian-7/README.md
[8]: ./bagian-8/README.md
[9]: ./bagian-9/README.md
[10]: ./bagian-10/README.md
[11]: ./bagian-11/README.md
[12]: ./bagian-12/README.md
[13]: ./bagian-13/README.md
[14]: ./bagian-14/README.md
[15]: ./bagian-15/README.md
