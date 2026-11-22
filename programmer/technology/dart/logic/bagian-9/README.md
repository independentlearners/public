# Membangun Logika Dart — Fase 9: Arsitektur, Ketahanan & Interoperabilitas

*Logika yang tetap sehat saat skalanya membesar: banyak modul, banyak tim, banyak kegagalan, banyak platform.*

| Atribut | Keterangan |
| --- | --- |
| Level | Expert / Enterprise |
| Estimasi waktu | 5–6 minggu, ±55 jam (teori ±30%, praktik ±70%). Tiga modul inti kurikulum ≈ 38–44 jam; sisanya untuk 9.4 dan latihan |
| Prasyarat | Fase 8 selesai (daftar periksa kelulusan terpenuhi, sembilan latihan di-commit) |
| Alat esensial | Dart SDK stabil (per 20 November 2026: 3.14), `package:meta`, pub workspaces, `package:pool`, `package:logging`, `package:clock`, `package:async`, `package:fake_async` (dev), `package:ffi`, `package:ffigen`, `package:hooks` + `package:code_assets` + `package:native_toolchain_c`, kompiler C (gcc atau clang), valgrind atau ASan untuk sisi native, Rust (`cargo`, opsional), `just` |
| Batas versi fitur | pub workspaces: ≥ 3.6 · build hooks: ≥ 3.10 · link hooks dan tree-shaking berbasis pemakaian: ≥ 3.13 · primary constructors: ≥ 3.13 · makro: dibatalkan (Januari 2025) · augmentations: masih eksperimen |
| Komunitas | https://dart.dev/community · isu dan diskusi hooks dan native: https://github.com/dart-lang/native · tag dart di https://stackoverflow.com/questions/tagged/dart |
| Sertifikasi | Tidak ada sertifikasi resmi khusus; portofolio berupa workspace multi-paket dengan bukti aturan dependensi, uji ketahanan, dan binding native yang teruji lebih bernilai |

**Hasil pembelajaran Fase 9 — setelah fase ini kamu mampu:**

- memisahkan domain, aplikasi, dan infrastruktur dengan port dan adapter, dan membuktikan secara otomatis bahwa panah ketergantungan selalu menuju ke dalam;
- mendesain API publik paket (`lib/src`, `export`, `@internal`, semver, class modifier) dan memakai pub workspaces;
- menjaga konsistensi lintas batas arsitektur: operasi atomik pada port, kunci per sumber daya, dan idempotensi;
- menerapkan retry, timeout, circuit breaker, bulkhead, token bucket, degradasi anggun, log terstruktur, dan metrik, lalu mengujinya dengan waktu virtual dan *fault injection*;
- menghubungkan Dart dengan C dan Rust (FFI, build hooks), JavaScript dan Wasm, serta proses lain, dengan memori native yang aman dan batas kepercayaan yang jelas;
- menulis logika yang konsisten di banyak target (VM, AOT, JS, Wasm) dan menguji perbedaan semantiknya.

## Daftar Isi Fase 9

<details>
  <summary>📃 Daftar Isi</summary>

---

- **0. Audit Kurikulum & Sambungan dari Fase 8**
- **9.1 Arsitektur Modular:** layering, hexagonal, dependency inversion, desain paket, kontrol konkurensi pada port
- **9.2 Pola Ketahanan Sistem**
- **9.3 Interoperabilitas & Lintas-Platform:** FFI, JS/Wasm, build hooks
- **9.4 Studi Kasus Terpadu: To-Do v8, Arsitektur Heksagonal yang Tangguh** *(TAMBAHAN)*
- **Latihan (tanpa kunci jawaban), Ringkasan, dan Referensi Induk**

</details>

## 0. Audit Kurikulum & Sambungan dari Fase 8

**Sambungan.** Fase 8 memberi alat bukti (properti, tes kontrak, mutasi, analisis statis, CI). Fase 9 memakainya untuk menjaga struktur yang lebih besar: tes kontrak menjaga adapter, skrip aturan dependensi menjaga arah panah, uji waktu virtual menjaga pola ketahanan. `Penyimpan` dari 7.8 sudah *port* dalam arti Fase ini; yang baru adalah memisahkannya menjadi paket.

**Lompatan penomoran.** Fase ini dikerjakan atas permintaanmu tepat setelah Fase 8. Fase *Keamanan, Isolasi & Anonimitas* (Fase 7 kurikulum) masih belum dibuat. Rujukan silang lama dibaca begini:

| Rujukan lama (Fase 5–8) | Isi yang dijanjikan | Kini di |
| --- | --- | --- |
| “Fase 11” | arsitektur dan pemisahan paket | Fase 9 ini |
| “Fase 9” | keamanan: jalur aman, TOCTOU, isolasi proses | belum dibuat; nomor menunggu keputusanmu |

Fase 9 ini tidak bergantung pada Keamanan, tetapi batas FFI di 9.3 dan adapter di 9.1 menyentuh batas kepercayaan yang akan diperdalam di sana.

**Temuan audit pada teks kurikulum Fase 9.**

1. **Contoh `LayananPeminjaman.pinjam` rawan pinjaman ganda.** Ia memanggil `cariStatus`, lalu `await`, lalu `simpanStatus`: pola *cek lalu tindak* dengan `await` di tengah (7.6). Dua peminjaman bersamaan atas ISBN yang sama sama-sama membaca `Tersedia`, sama-sama menyimpan status dipinjam, dan salah satu hasilnya hilang tanpa galat. Padahal Latihan 9.2 menuntut “tanpa pinjaman ganda”. Perbaikannya ada di **desain port**: port harus menawarkan operasi atomik (`perbarui`), bukan dua langkah terpisah. Dibuktikan dan diperbaiki di 9.1.
2. **`denganRetry` tidak aman di target web.** Ekspresi `1 << (percobaan - 1)` tidak dibatasi; di web operator geser memotong ke 32 bit (diverifikasi di dokumentasi angka Dart), sehingga untuk `maksPercobaan` besar hasilnya negatif atau berputar dan `rng.nextInt(...)` melempar `RangeError`. Backoff juga tak punya batas atas. Diperbaiki di 9.2 dengan membatasi eksponen dan menambah plafon.
3. **`timeout` tidak membatalkan pekerjaan (7.3).** `kerja().timeout(...)` yang diikuti retry dapat menjalankan percobaan lama dan baru bersamaan. Itu sebabnya kurikulum benar menyebut idempotensi sebagai syarat retry; 9.2 menambahkan penjaga idempotensi sebagai kode, bukan hanya prinsip.
4. **Daftar isi menjanjikan lebih dari kodenya.** 9.2 menyebut circuit breaker, bulkhead, token bucket, degradasi anggun, log terstruktur, dan metrik, tetapi kodenya hanya retry; 9.1 menyebut `@internal`, pengukuran kopling dan kohesi, serta “kapan tidak memakai arsitektur berat” tanpa kode. Semuanya diisi di sini.
5. **Tautan rusak oleh escape markdown.** `https://dart.dev/tools/build\_runner` memuat garis miring terbalik; tautan yang benar adalah https://dart.dev/tools/build\_runner (diverifikasi ada di navigasi dart.dev).
6. **FFI: `IntPtr` untuk `size_t` kurang tepat, dan jalur modern tak disebut.** `dart:ffi` menyediakan tipe `Size` untuk `size_t`, dan pendekatan `@Native` (tanpa `lookupFunction`) kini jalur utama bersama build hooks. Kurikulum hanya menyebut `package:hooks`; yang diverifikasi: build hooks sejak 3.10, link hooks sejak 3.13, paket `hooks`, `code_assets`, dan `native_toolchain_c` ditaruh di `dependencies` (bukan `dev_dependencies`).
7. **Status makro benar, perlu pelengkap.** Terverifikasi: makro dibatalkan Januari 2025 dan “tidak akan dikirim dalam waktu dekat”; yang dijanjikan gantinya adalah augmentations (masih di balik flag eksperimen), perbaikan `build_runner`, dan dukungan data yang lebih baik. Pelengkap: *primary constructors* sudah stabil di 3.13 dan mengurangi boilerplate tanpa generasi kode.
8. **Latihan 9.1: pemeriksaan `grep` kalah kuat dari struktur paket.** Dengan paket terpisah, domain tak dapat mengimpor infrastruktur kecuali dideklarasikan di `pubspec.yaml`. Materi ini menambah skrip aturan dependensi yang memeriksa `pubspec.yaml` *dan* impor, termasuk larangan `dart:io` di domain.
9. **Contoh domain bergantung pada modul bernomor lain.** `StatusBuku` dan `transisi` merujuk Modul 3.1 dan 4.2 kurikulum, yang tak sejajar dengan penomoran materi ini; versi mini yang berdiri sendiri disertakan.
10. **Kriteria memori native perlu dipisah.** “Tidak ada kebocoran (valgrind atau ASan)” paling realistis diverifikasi pada *pustaka native-nya* lewat harness C, sementara sisi Dart diverifikasi dengan penghitung alokasi dan `dispose` yang dites; menjalankan valgrind pada VM Dart utuh sangat bising.

**Fakta yang diverifikasi saat penyusunan (20 November 2026).** (a) Pub workspaces diperkenalkan di Dart 3.6.0; tiap anggota memakai `resolution: workspace` dan SDK minimal `^3.6.0`; `dart pub get` membuat satu `pubspec.lock` dan satu `package_config.json` bersama; `dart pub workspace list` mendaftar anggota; perintah seperti `dart pub add` hanya berlaku pada paket di direktori saat ini (opsi `-C`). (b) Makro dibatalkan Januari 2025; augmentations berstatus eksperimen (flag `augmentations`); primary constructors stabil di 3.13; `native-assets` aktif sejak 3.10. (c) Build hooks sejak 3.10, link hooks dan `recordedUses` sejak 3.13; hook berada di `hook/build.dart` dan `hook/link.dart`, berjalan otomatis pada `dart run`, `dart build`, dan `dart test`, dalam lingkungan semi-hermetik; aset diakses lewat `@Native`. (d) Di web `int` adalah angka JavaScript (presisi 53 bit) dan operator bitwise dan geser memotong operand ke 32 bit; di native `int` adalah bilangan bulat bertanda 64 bit.

**TAMBAHAN:** 9.4, yaitu To-Do v8: memecah To-Do v7 menjadi workspace empat paket, memindahkan ketahanan menjadi *decorator* di batas adapter, dan menjaga semuanya dengan skrip aturan dependensi, tes kontrak, dan uji fault injection.

**Ditunda secara sadar:** wadah DI (`get_it` dan sejenisnya), event sourcing dan CQRS, detail gRPC dan protobuf, arsitektur khusus Flutter (MVVM), OpenTelemetry, `flutter_rust_bridge`, dan detail `jnigen` serta interop Objective-C/Swift.

**Cara memakai dokumen ini** tetap sama: baca, tulis ulang dari ingatan, jalankan, bandingkan. Kode di dokumen ini **belum dijalankan** di lingkungan penyusun (tanpa Dart SDK, kompiler C, dan akses pub.dev); jalankan `dart analyze` dan `dart test`, dan catat setiap selisih. Latihan di akhir tanpa kunci jawaban.

---

## 9.1 Arsitektur Modular: Layering, Hexagonal, Dependency Inversion & Desain Paket

*Motivasi: arsitektur yang baik adalah keputusan yang bisa kamu tunda, dan ubah dengan murah.*

**Struktur pembelajaran (mini daftar isi):** (1) layering dan arah ketergantungan · (2) hexagonal: port dan adapter · (3) injeksi lewat konstruktor dan *composition root* · (4) desain API publik: `lib/src`, `export`, `@internal`, class modifier, semver · (5) pub workspaces · (6) generasi kode: `build_runner`, status makro, *primary constructors* · (7) mengukur kopling dan kohesi · (8) kapan *tidak* memakai arsitektur berat · (9) konsistensi pada port: operasi atomik (hasil audit).

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini menyusun kode menjadi lapisan dan paket dengan batas yang jelas: domain murni di inti, aplikasi (use case) di sekelilingnya, infrastruktur (database, jaringan, berkas) di tepi, dengan ketergantungan selalu mengarah ke dalam. Cakupannya: desain API publik paket, pub workspaces untuk monorepo, aturan dependensi yang diperiksa mesin, trade-off generasi kode, dan satu hal yang sering terlewat: **konsistensi pada batas port**. Perannya: Fase 1–8 menghasilkan logika yang benar dan terbukti; modul ini menjaga agar ia *tetap* benar ketika kode bertambah, tim bertambah, dan teknologi di tepi berganti.

### B. Konsep Kunci & Filosofi Mendalam

- **Arah ketergantungan, bukan jumlah lapisan.** Inti prinsipnya: aturan bisnis (tingkat tinggi) tak boleh bergantung pada database, jaringan, atau berkas (tingkat rendah). Lapisan hanyalah cara menyatakannya: domain di tengah, aplikasi di sekelilingnya, infrastruktur di tepi, dan panah ketergantungan selalu ke dalam.
- **Hexagonal (ports and adapters).** Domain mendefinisikan *port*, yaitu antarmuka yang ia butuhkan; *adapter* di tepi mengimplementasikannya. Ada dua jenis: *port masuk (driving)*, yang dipanggil dunia luar untuk menjalankan use case (CLI, HTTP), dan *port keluar (driven)*, yang dipanggil domain ketika butuh sesuatu (repositori, pengirim notifikasi). Kepemilikan menentukan segalanya: **port dimiliki domain**, bukan pustaka infrastruktur.
- **Dependency inversion.** Karena port milik domain, ketergantungan di kode sumber terbalik: infrastruktur bergantung pada domain, padahal saat runtime alurnya tetap domain memanggil infrastruktur. Manfaatnya: domain dapat diuji tanpa I/O, infrastruktur dapat diganti, dan dampak perubahan teknologi terkunci di tepi.
- **Injeksi lewat konstruktor dan *composition root*.** Ketergantungan diserahkan dari luar lewat konstruktor; satu tempat (biasanya `main`) merakit objek nyata: itulah composition root. Eksplisit dan mudah diuji. Wadah DI dan *service locator* menyembunyikan ketergantungan dan menunda galat ke runtime; untuk aplikasi Dart kecil dan menengah, konstruktor dan fungsi sudah cukup.
- **Port tak harus kelas.** Port boleh berupa antarmuka (`abstract interface class`) atau tipe fungsi (`typedef`). Pilih fungsi untuk satu operasi, antarmuka untuk sekumpulan operasi yang saling terkait.
- **Port adalah kontrak perilaku, termasuk konsistensi.** Antarmuka yang memisahkan `cari` dan `simpan` mengundang pola *cek lalu tindak* dengan `await` di tengah (7.6). Rancang operasi yang atomik di port (`perbarui(kunci, fungsiUbah)`), karena hanya adapter yang tahu cara menjaminnya (kunci, transaksi, *compare-and-set*).
- **API publik paket.** Taruh implementasi di `lib/src/` dan ekspor hanya yang dijanjikan stabil lewat satu berkas `lib/nama_paket.dart` dengan `export ... show ...`. `@internal` (`package:meta`) menandai anggota yang secara teknis publik tetapi bukan untuk pemakai luar paket; analyzer memperingatkan pemakaiannya dari paket lain.
- **Class modifier mengendalikan evolusi API.** `interface`, `base`, `final`, dan `sealed` menentukan apa yang boleh dilakukan pemakai. Menambah anggota abstrak pada `interface class` mematahkan semua yang mengimplementasikannya; `base` atau `final` menutup pintu itu. Pilih modifier sesuai janji yang ingin kamu pegang.
- **Semantic versioning.** MAJOR.MINOR.PATCH: PATCH memperbaiki tanpa mengubah API, MINOR menambah tanpa mematahkan, MAJOR mematahkan. Di pub, `^1.2.3` menerima seri yang kompatibel. Mengubah API yang sudah dirilis jauh lebih mahal daripada mengubah isi `src`.
- **Pub workspaces.** Banyak paket dalam satu repositori berbagi satu resolusi dependensi dan satu `pubspec.lock`, yang juga memperkecil memori analisis. Ia bisa menjadi batas arsitektur: paket yang tak mendeklarasikan sebuah ketergantungan tak dapat mengimpornya.
- **Generasi kode.** Makro dibatalkan; alat realistis adalah `build_runner` dan `source_gen` (misalnya `json_serializable`) dengan harga langkah build, berkas hasil generate, dan debugging yang lebih rumit. Alternatif: tulis tangan dengan pola dan record (3.5), atau *primary constructors* (stabil di 3.13) untuk memangkas boilerplate; augmentations masih eksperimen.
- **Kopling dan kohesi.** Kopling: seberapa banyak sebuah modul bergantung pada modul lain. Kohesi: seberapa erat isi satu modul berkaitan. Metrik sederhana: *afferent coupling* Ca (berapa modul yang bergantung padaku), *efferent coupling* Ce (aku bergantung pada berapa modul), dan *instability* I = Ce / (Ca + Ce), dengan 0 berarti sangat stabil dan 1 sangat tidak stabil. Aturan *stable dependencies*: bergantunglah ke arah yang lebih stabil; domain harus paling stabil.
- **Arsitektur dapat diperiksa mesin.** Aturan dependensi yang hanya ada di diagram akan dilanggar. Skrip kecil di CI yang memeriksa `pubspec.yaml` dan impor mengubah niat arsitektural menjadi bukti (8.2).
- **Sebanding dengan masalahnya.** Mulai sederhana; ekstrak port saat ada dua implementasi atau kebutuhan uji yang nyata (aturan tiga: pada kali ketiga). Tanda arsitektur berlebih: antarmuka dengan satu implementasi abadi, lapisan yang hanya meneruskan panggilan, dan boilerplate yang melebihi logika.
- **Dampak desain.** Domain bergantung langsung pada paket database atau HTTP: tak bisa diuji tanpa I/O dan terkunci pada vendor. Terlalu banyak lapisan untuk aplikasi kecil: indireksi tanpa manfaat. Semua diekspor dari `lib/`: setiap perubahan internal menjadi perubahan yang mematahkan. DI lewat konstruktor: eksplisit tetapi verbose; container DI: menyembunyikan ketergantungan dan menunda galat ke runtime. Generasi kode: mengurangi boilerplate dan galat tulis tangan tetapi menambah langkah build dan kerumitan debugging.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — domain mini, port, dan use case (versi kurikulum).** Bila kamu sudah punya `StatusBuku` dan `transisi` dari materi sebelumnya, pakai milikmu; versi mini ini disertakan agar contoh berdiri sendiri.

```dart
// lib/src/status_buku.dart  (domain: murni, tanpa I/O)
sealed class StatusBuku {
  const StatusBuku();
}

final class Tersedia extends StatusBuku {
  const Tersedia();
}

final class Dipinjam extends StatusBuku {
  const Dipinjam(this.idAnggota, this.tempo);
  final String idAnggota;
  final DateTime tempo;
}

sealed class Aksi {
  const Aksi();
}

final class Meminjam extends Aksi {
  const Meminjam(this.idAnggota, this.tempo);
  final String idAnggota;
  final DateTime tempo;
}

final class Mengembalikan extends Aksi {
  const Mengembalikan();
}

class TransisiTakValid implements Exception {
  const TransisiTakValid(this.dari, this.aksi);
  final StatusBuku dari;
  final Aksi aksi;

  @override
  String toString() =>
      'TransisiTakValid: ${dari.runtimeType} tidak menerima ${aksi.runtimeType}';
}

StatusBuku transisi(StatusBuku sekarang, Aksi aksi) => switch ((sekarang, aksi)) {
      (Tersedia(), Meminjam(:final idAnggota, :final tempo)) => Dipinjam(idAnggota, tempo),
      (Dipinjam(), Mengembalikan()) => const Tersedia(),
      _ => throw TransisiTakValid(sekarang, aksi),
    };
```

```dart
// Versi kurikulum: port dengan dua langkah terpisah
abstract interface class RepositoriBukuNaif {
  Future<StatusBuku?> cariStatus(String isbn);
  Future<void> simpanStatus(String isbn, StatusBuku status);
}

class LayananPeminjamanNaif {
  LayananPeminjamanNaif(this._repo);
  final RepositoriBukuNaif _repo; // bergantung pada port, bukan implementasi

  Future<void> pinjam(String isbn, String idAnggota, DateTime tempo) async {
    final status = await _repo.cariStatus(isbn); // CEK
    final baru = transisi(status ?? const Tersedia(), Meminjam(idAnggota, tempo));
    await _repo.simpanStatus(isbn, baru); // TINDAK: dunia boleh masuk di antara keduanya
  }
}
```

- `sealed class StatusBuku` dan `Aksi` — himpunan keadaan dan aksi tertutup; `switch` atas pasangan `(sekarang, aksi)` diperiksa kelengkapannya oleh kompilator (3.1, 4.2).
- `transisi` murni: tak ada I/O, tak ada waktu sekarang (tempo dikirim dari luar). Pasangan tak valid melempar `TransisiTakValid`, galat domain, bukan galat teknis.
- `RepositoriBukuNaif` adalah *port keluar*, dimiliki domain; `LayananPeminjamanNaif` adalah use case yang hanya mengenal port.
- Catatan penting: `pinjam` memanggil `cariStatus`, lalu `await`, lalu `simpanStatus`. Itu persis pola *cek lalu tindak* dari 7.6. Contoh berikut membuktikan bahayanya.

**Contoh 2 — bukti: dua peminjaman bersamaan sama-sama berhasil.**

```dart
import 'dart:async';

import 'package:test/test.dart';

/// Repositori palsu yang menahan setiap pembacaan di gerbang yang dikendalikan tes.
class RepositoriGerbang implements RepositoriBukuNaif {
  final _data = <String, StatusBuku>{};
  final gerbangBaca = <Completer<void>>[];

  @override
  Future<StatusBuku?> cariStatus(String isbn) async {
    final status = _data[isbn]; // nilai dibaca SEKARANG
    final gerbang = Completer<void>();
    gerbangBaca.add(gerbang);
    await gerbang.future; // tes menahan di sini
    return status;
  }

  @override
  Future<void> simpanStatus(String isbn, StatusBuku status) async => _data[isbn] = status;

  StatusBuku? operator [](String isbn) => _data[isbn];
}

void main() {
  test('versi kurikulum: dua peminjaman bersamaan sama-sama berhasil (bug terbukti)', () async {
    final repo = RepositoriGerbang();
    final layanan = LayananPeminjamanNaif(repo);
    final tempo = DateTime(2026, 12, 1);

    final a = layanan.pinjam('978-0', 'anggota-A', tempo);
    final b = layanan.pinjam('978-0', 'anggota-B', tempo);
    expect(repo.gerbangBaca, hasLength(2)); // keduanya sudah membaca 'Tersedia'

    for (final g in repo.gerbangBaca) {
      g.complete(); // urutan: A lalu B
    }
    await Future.wait([a, b]); // KEDUANYA selesai tanpa galat

    // Hanya satu anggota yang tercatat, padahal dua mengira berhasil meminjam:
    expect(
      repo['978-0'],
      isA<Dipinjam>().having((s) => s.idAnggota, 'idAnggota', 'anggota-B'),
    );
  });
}
```

- `RepositoriGerbang.cariStatus` membaca nilai *lebih dulu*, lalu menahan di `Completer`. Itu meniru latensi I/O sungguhan: antara “membaca” dan “melanjutkan”, dunia berjalan.
- `layanan.pinjam(...)` dipanggil dua kali tanpa `await` di antaranya, jadi kedua pembacaan terjadi sebelum ada penyimpanan: `gerbangBaca` berisi dua gerbang.
- Setelah gerbang dilepas berurutan, keduanya menyimpan: yang terakhir (`anggota-B`) menimpa yang pertama. Tak ada galat, tak ada log; satu pinjaman *hilang diam-diam*. Itu bug yang akan lolos dari setiap tes berurutan.
- `isA<Dipinjam>().having(...)` — matcher bertipe dengan pemeriksaan properti; di sini membuktikan siapa yang menang.
- Pelajaran arsitektural: bug ini tak bisa diperbaiki di use case dengan `if` tambahan, karena pemisahan baca dan tulis *terjadi di desain port*. Perbaikannya harus berada di port.

**Contoh 3 — perbaikan: port yang menawarkan operasi atomik.**

```dart
// Port keluar (milik domain): atomisitas menjadi bagian kontrak
abstract interface class RepositoriBuku {
  Future<StatusBuku?> cariStatus(String isbn);

  /// Membaca status sekarang, menerapkan [ubah], lalu menyimpan hasilnya sebagai SATU unit
  /// atomik per [isbn]: tak ada [perbarui] lain atas ISBN yang sama yang menyela.
  /// Bila [ubah] melempar, tak ada yang disimpan dan galatnya sampai ke pemanggil.
  Future<StatusBuku> perbarui(
    String isbn,
    StatusBuku Function(StatusBuku? sekarang) ubah,
  );
}

class LayananPeminjaman {
  LayananPeminjaman(this._repo);
  final RepositoriBuku _repo;

  Future<void> pinjam(String isbn, String idAnggota, DateTime tempo) async {
    await _repo.perbarui(
      isbn,
      (sekarang) => transisi(sekarang ?? const Tersedia(), Meminjam(idAnggota, tempo)),
    );
  }

  Future<void> kembalikan(String isbn) async {
    await _repo.perbarui(
      isbn,
      (sekarang) => transisi(sekarang ?? const Tersedia(), const Mengembalikan()),
    );
  }
}
```

```dart
// Adapter keluar (infrastruktur): jaminan atomisitas ada DI SINI, bukan di use case
class RepositoriMemori implements RepositoriBuku {
  RepositoriMemori({this.jeda});

  /// Simulasi latensi I/O di antara membaca dan menulis (di tes: gerbang).
  final Future<void> Function()? jeda;
  final _data = <String, StatusBuku>{};
  final _kunci = KunciPerKunci<String>(); // dari 7.9, Contoh 4

  @override
  Future<StatusBuku?> cariStatus(String isbn) async => _data[isbn];

  @override
  Future<StatusBuku> perbarui(
    String isbn,
    StatusBuku Function(StatusBuku? sekarang) ubah,
  ) =>
      _kunci.jalankan(isbn, () async {
        final sekarang = _data[isbn];
        await jeda?.call(); // adapter nyata: I/O terjadi di sini
        final baru = ubah(sekarang);
        _data[isbn] = baru;
        return baru;
      });
}
```

```dart
test('port atomik: tepat satu peminjaman berhasil, yang lain ditolak', () async {
  var panggilan = 0;
  final gerbang = Completer<void>();
  final repo = RepositoriMemori(
    jeda: () => panggilan++ == 0 ? gerbang.future : Future<void>.value(),
  );
  final layanan = LayananPeminjaman(repo);
  final tempo = DateTime(2026, 12, 1);

  final hasilA = layanan
      .pinjam('978-0', 'anggota-A', tempo)
      .then<Object?>((_) => null, onError: (Object e) => e);
  final hasilB = layanan
      .pinjam('978-0', 'anggota-B', tempo)
      .then<Object?>((_) => null, onError: (Object e) => e);

  await Future<void>.delayed(Duration.zero); // beri giliran event loop
  expect(panggilan, 1); // B menunggu giliran: belum masuk ke jeda
  gerbang.complete();

  expect(await hasilA, isNull); // A berhasil
  expect(await hasilB, isA<TransisiTakValid>()); // B melihat 'Dipinjam' dan ditolak
  expect(
    await repo.cariStatus('978-0'),
    isA<Dipinjam>().having((s) => s.idAnggota, 'idAnggota', 'anggota-A'),
  );
});
```

- `perbarui(isbn, ubah)` mengubah *bentuk* port: pemanggil menyerahkan fungsi murni `ubah`, adapter yang memutuskan cara membaca-menulis secara atomik. Use case jadi lebih pendek *dan* benar.
- Kontrak ditulis di komentar port: “atomik per ISBN” dan “bila `ubah` melempar, tak ada yang disimpan”. Kontrak perilaku seperti ini harus dites pada **setiap** adapter (tes kontrak, 8.3).
- `KunciPerKunci<String>` (7.9) menyerialkan operasi pada ISBN yang sama tetapi membiarkan ISBN berbeda paralel; adapter berkas atau SQLite memakai mekanisme yang sesuai (kunci, transaksi, atau *compare-and-set* dengan nomor versi).
- `jeda` menyuntikkan latensi I/O ke adapter memori. Tanpa `jeda`, adapter memori sebenarnya sudah atomik (tak ada `await` antara baca dan tulis), tetapi adapter nyata pasti punya jeda, sehingga kontraknya dites dengan jeda.
- Tes: `panggilan++ == 0 ? gerbang.future : Future<void>.value()` menahan hanya `jeda` pertama; setelah giliran event loop, `panggilan` bernilai 1, bukti bahwa B menunggu di antrean kunci. Setelah gerbang dilepas, A menang dan B ditolak dengan `TransisiTakValid`: galat domain yang jelas, bukan data hilang diam-diam.
- `.then<Object?>((_) => null, onError: (Object e) => e)` — mengubah hasil menjadi `null` (sukses) atau objek galatnya, agar kedua hasil dapat diperiksa tanpa `try`.

**Contoh 4 — *composition root* dan adapter masuk.**

```dart
// packages/cli/bin/katalog.dart
// Composition root: SATU-SATUNYA tempat yang mengenal semua implementasi konkret.
import 'dart:io';

import 'package:katalog_domain/katalog_domain.dart';
import 'package:katalog_infrastruktur/katalog_infrastruktur.dart';

Future<void> main(List<String> args) async {
  final repo = RepositoriMemori(); // ganti adapter di sini SAJA (berkas JSONL: Latihan 9.1)
  final layanan = LayananPeminjaman(repo);

  // Adapter masuk: menerjemahkan argumen CLI menjadi pemanggilan use case.
  switch (args) {
    case ['pinjam', final isbn, final anggota]:
      await layanan.pinjam(isbn, anggota, DateTime.now().add(const Duration(days: 14)));
      stdout.writeln('dipinjam: $isbn oleh $anggota');
    case ['kembalikan', final isbn]:
      await layanan.kembalikan(isbn);
      stdout.writeln('dikembalikan: $isbn');
    default:
      stderr.writeln('pemakaian: katalog pinjam <isbn> <anggota> | katalog kembalikan <isbn>');
      exitCode = 64;
  }
}
```

- `main` adalah composition root: ia membuat `RepositoriMemori`, menyerahkannya ke `LayananPeminjaman` lewat konstruktor, dan tak ada kode lain yang melakukan `new` pada adapter. Mengganti adapter berarti mengubah satu baris di sini.
- `switch (args)` dengan pola daftar (`case ['pinjam', final isbn, final anggota]`) memeriksa bentuk argumen sekaligus mengikat nilainya; ini *adapter masuk*: ia hanya menerjemahkan dunia luar menjadi pemanggilan use case.
- `DateTime.now()` boleh di tepi (composition root dan adapter), tidak di domain; domain menerima `tempo` sebagai argumen.
- `exitCode = 64` untuk pemakaian salah mengikuti konvensi `sysexits` (EX\_USAGE), seperti kode keluar di 5.5.

**Contoh 5 — API publik: `lib/src`, `export show`, `@internal`, class modifier.**

```dart
// packages/domain/lib/katalog_domain.dart   (SATU-SATUNYA berkas publik)
export 'src/layanan_peminjaman.dart' show LayananPeminjaman;
export 'src/repositori_buku.dart' show RepositoriBuku;
export 'src/status_buku.dart'
    show StatusBuku, Tersedia, Dipinjam, Aksi, Meminjam, Mengembalikan, TransisiTakValid, transisi;
// Apa pun lain di lib/src/ bebas berubah tanpa mematahkan pemakai.
```

```dart
import 'package:meta/meta.dart';

/// Port: adapter boleh MENGIMPLEMENTASIKAN, tak boleh memperluas.
/// Menambah anggota abstrak = perubahan MAJOR (mematahkan semua implementer).
abstract interface class RepositoriBuku { /* ... */ }

/// Nilai domain: tak boleh diperluas atau diimplementasikan di luar paket.
final class Dipinjam extends StatusBuku { /* ... */ }

/// Tersedia untuk paket saudara dalam monorepo, tetapi BUKAN janji publik.
@internal
Map<String, Object?> kodekanStatus(StatusBuku status) => {/* ... */};
```

| Modifier | Pemakai di luar paket boleh | Cocok untuk |
| --- | --- | --- |
| `abstract interface class` | `implements`, tidak `extends` | Port yang diimplementasikan adapter |
| `abstract base class` | `extends`, tidak `implements` (subkelas harus `base`, `final`, atau `sealed`) | Kelas dasar yang menjaga invarian lewat konstruktor dan state |
| `final class` | Tidak keduanya | Value object dan tipe hasil |
| `sealed class` | Tidak keduanya di luar library; `switch` dicek kelengkapannya | Himpunan keadaan tertutup |

| Perubahan pada paket | Tingkat versi |
| --- | --- |
| Memperbaiki bug tanpa mengubah API | PATCH |
| Menambah fungsi publik atau parameter bernama opsional | MINOR |
| Menambah method dengan implementasi bawaan pada `base class` | MINOR |
| Menambah anggota abstrak pada `interface class` | **MAJOR** (semua implementer pecah) |
| Menghapus atau mengganti nama ekspor | **MAJOR** |
| Mengubah tipe kembalian atau tipe parameter publik | **MAJOR** |

- `export '...' show A, B` — hanya nama yang disebut yang menjadi API publik; menambah ekspor itu keputusan sadar, bukan efek samping.
- Berkas lain di `lib/src/` tetap dapat diimpor lewat `package:katalog_domain/src/...`, tetapi lint `implementation_imports` memperingatkannya; konvensi plus lint inilah yang membuat `src` terasa privat.
- `@internal` — untuk hal yang harus publik secara teknis (agar paket saudara dapat memakainya) tetapi tak boleh dipakai di luar paket/monorepo; analyzer memperingatkan pemakai dari paket yang tak berhak.
- Tabel modifier dan tabel semver adalah *alat memutuskan*: sebelum menambah anggota ke sebuah antarmuka publik, tanyakan siapa yang mengimplementasikannya.

**Contoh 6 — pub workspaces untuk monorepo.**

```text
katalog/
├─ pubspec.yaml                   (akar: workspace)
├─ packages/
│  ├─ domain/          pubspec.yaml   (katalog_domain; hanya SDK dan meta)
│  ├─ infrastruktur/   pubspec.yaml   (katalog_infrastruktur; bergantung pada katalog_domain)
│  └─ cli/             pubspec.yaml   (katalog_cli; bergantung pada keduanya)
└─ tool/cek_arsitektur.dart
```

```yaml
# katalog/pubspec.yaml
name: katalog_workspace
publish_to: none
environment:
  sdk: ^3.14.0
workspace:
  - packages/domain
  - packages/infrastruktur
  - packages/cli
dev_dependencies:
  yaml: any
```

```yaml
# katalog/packages/infrastruktur/pubspec.yaml
name: katalog_infrastruktur
resolution: workspace            # wajib untuk setiap anggota workspace
environment:
  sdk: ^3.14.0                   # minimal ^3.6.0 agar workspaces didukung
dependencies:
  katalog_domain: any            # paket saudara: di-resolve dari workspace, tanpa path:
```

```bash
dart pub get                      # satu resolusi untuk seluruh workspace
dart pub workspace list           # daftar paket anggota
dart pub -C packages/domain add meta     # tambah dependensi ke SATU paket (opsi -C = direktori)
for p in packages/*; do (cd "$p" && dart test); done    # jalankan tes tiap paket
```

- `workspace:` di akar mendaftar anggota; `publish_to: none` di akar karena akar tak diterbitkan. Tiap anggota wajib `resolution: workspace`, dan batas bawah SDK-nya harus mendukung workspaces (3.6).
- Satu `pubspec.lock` dan satu `package_config.json` untuk semua: tak mungkin dua paket anggota memakai versi `meta` yang berbeda tanpa sengaja.
- Ketergantungan antar-anggota cukup ditulis dengan nama (`katalog_domain: any`); pub meng-resolve ke salinan lokal.
- Struktur paket sendiri sudah menjadi batas: `katalog_domain` yang tak mendeklarasikan `katalog_infrastruktur` tak dapat mengimpornya (akan gagal di analisis). Skrip di bawah menambah pemeriksaan eksplisit dan menutup celah `dart:io`.

**Contoh 7 — aturan dependensi yang diperiksa mesin, dan metrik kopling.**

```dart
// tool/cek_arsitektur.dart
import 'dart:io';

import 'package:yaml/yaml.dart';

/// Aturan: tiap paket boleh bergantung pada apa dan tak boleh mengimpor apa.
const aturan = <String, ({Set<String> izinPaket, List<String> larangImpor})>{
  'packages/domain': (
    izinPaket: {'meta'},
    larangImpor: ['katalog_infrastruktur', 'katalog_cli', 'dart:io'],
  ),
  'packages/infrastruktur': (
    izinPaket: {'meta', 'katalog_domain'},
    larangImpor: ['katalog_cli'],
  ),
};

void main() {
  var pelanggaran = 0;

  for (final MapEntry(key: dir, value: aturanPaket) in aturan.entries) {
    // 1) pubspec: hanya ketergantungan yang diizinkan
    final isi = loadYaml(File('$dir/pubspec.yaml').readAsStringSync());
    if (isi case {'dependencies': final Map deps}) {
      for (final nama in deps.keys.cast<String>()) {
        if (!aturanPaket.izinPaket.contains(nama)) {
          stderr.writeln('$dir/pubspec.yaml: ketergantungan tak diizinkan: $nama');
          pelanggaran++;
        }
      }
    }

    // 2) impor: tak boleh mengarah ke yang dilarang
    final berkasDart = Directory('$dir/lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));
    for (final berkas in berkasDart) {
      for (final (i, baris) in berkas.readAsLinesSync().indexed) {
        final cocok = RegExp(r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''').firstMatch(baris);
        if (cocok == null) continue;
        final sasaran = cocok.group(1)!;
        if (aturanPaket.larangImpor.any(sasaran.contains)) {
          stderr.writeln('${berkas.path}:${i + 1}: dilarang mengimpor $sasaran');
          pelanggaran++;
        }
      }
    }
  }

  if (pelanggaran > 0) exit(1);
  stdout.writeln('arsitektur: aturan ketergantungan terpenuhi');
}
```

```dart
// tool/kopling.dart: Ca, Ce, dan instability tiap paket di workspace
import 'dart:io';

import 'package:yaml/yaml.dart';

void main() {
  final paket = <String, Set<String>>{}; // nama paket -> ketergantungannya
  for (final dir in Directory('packages').listSync().whereType<Directory>()) {
    final isi = loadYaml(File('${dir.path}/pubspec.yaml').readAsStringSync());
    if (isi case {'name': final String nama}) {
      final deps = <String>{};
      if (isi case {'dependencies': final Map d}) deps.addAll(d.keys.cast<String>());
      paket[nama] = deps;
    }
  }

  for (final nama in paket.keys) {
    final ce = paket[nama]!.where(paket.containsKey).length; // aku bergantung pada
    final ca = paket.entries.where((e) => e.key != nama && e.value.contains(nama)).length; // bergantung padaku
    final i = ce + ca == 0 ? 0.0 : ce / (ce + ca);
    stdout.writeln('${nama.padRight(24)} Ca=$ca Ce=$ce I=${i.toStringAsFixed(2)}');
  }
}
```

- `aturan` memetakan setiap paket ke dua jenis larangan: ketergantungan di `pubspec.yaml` yang tak diizinkan, dan impor di kode yang tak diizinkan; domain sengaja dilarang menyentuh `dart:io` agar tetap murni dari I/O.
- `for (final MapEntry(key: dir, value: aturanPaket) in aturan.entries)` membongkar entri peta dengan pola; `berkas.readAsLinesSync().indexed` memberi pasangan (nomor baris, isi).
- Ekspresi reguler mencocokkan baris `import` atau `export` dan mengambil URI-nya; pelanggaran dicetak dengan `berkas:baris` agar mudah dilompati dari terminal atau editor.
- Skrip berakhir dengan kode `1` bila ada pelanggaran: tempatkan di `just cek` dan CI (8.2) sehingga aturan arsitektur menjadi bukti yang berjalan di setiap perubahan.
- `kopling.dart` menghitung Ca dan Ce dari `pubspec.yaml`; untuk workspace di atas, hasil yang diharapkan: `katalog_domain` Ca=2, Ce=0, I=0,00 (paling stabil); `katalog_infrastruktur` Ca=1, Ce=1, I=0,50; `katalog_cli` Ca=0, Ce=2, I=1,00. Panah ketergantungan menuju paket dengan I lebih kecil: sehat.

**Contoh 8 — generasi kode atau tulis tangan?**

```bash
dart pub add json_annotation
dart pub add --dev build_runner json_serializable
dart run build_runner build --delete-conflicting-outputs   # sekali jalan
dart run build_runner watch --delete-conflicting-outputs   # terus-menerus saat mengembangkan
```

```dart
// Dengan generator: sedikit tulisan, ada berkas buku.g.dart dan langkah build
import 'package:json_annotation/json_annotation.dart';

part 'buku.g.dart';

@JsonSerializable()
class Buku {
  Buku(this.isbn, this.judul);
  factory Buku.fromJson(Map<String, Object?> json) => _$BukuFromJson(json);

  final String isbn;
  final String judul;

  Map<String, Object?> toJson() => _$BukuToJson(this);
}
```

```dart
// Tulis tangan dengan pola: tanpa build, bentuk salah menjadi FormatException (3.5)
class Buku {
  const Buku(this.isbn, this.judul);
  final String isbn;
  final String judul;

  factory Buku.dariJson(Object? json) => switch (json) {
        {'isbn': final String isbn, 'judul': final String judul} => Buku(isbn, judul),
        _ => throw const FormatException('bentuk Buku tidak dikenali'),
      };

  Map<String, Object?> keJson() => {'isbn': isbn, 'judul': judul};
}
```

- `dart run build_runner build` menghasilkan `buku.g.dart` (`_$BukuFromJson`, `_$BukuToJson`); `--delete-conflicting-outputs` menghapus keluaran lama yang bentrok; `watch` membangun ulang tiap berkas berubah.
- Harga generator: dependensi tambahan, langkah build di CI, berkas hasil generate yang dikomit atau dibangkitkan, dan galat yang lebih sulit dilacak. Manfaatnya muncul bila jumlah tipe besar dan bersarang.
- Versi tulis tangan memakai pola sehingga memeriksa bentuk dan tipe sekaligus dan menolak data salah dengan `FormatException`; untuk beberapa tipe, ini lebih sederhana, tanpa langkah build.
- Aturan praktis: sedikit tipe dan stabil, tulis tangan; banyak tipe bersarang yang sering berubah, generator. Primary constructors (3.13) memangkas sebagian boilerplate konstruktor tanpa generator.

**Contoh 9 — kapan *tidak* memakai arsitektur berat.**

| Gejala | Artinya | Tindakan |
| --- | --- | --- |
| Antarmuka hanya punya satu implementasi dan tak ada kebutuhan uji | Port prematur | Hapus antarmukanya; ekstrak lagi bila ada implementasi kedua |
| Lapisan yang hanya meneruskan panggilan | Indireksi tanpa nilai | Gabungkan lapisannya |
| Boilerplate melebihi logika | Arsitektur lebih besar dari masalah | Sederhanakan; satu paket dan satu folder per lapis sudah cukup |
| Domain butuh diuji tanpa I/O tetapi sulit | Port memang dibutuhkan | Ekstrak port dan adapter sekarang |
| Dua tim menyentuh bagian yang sama dan sering bentrok | Batas paket dibutuhkan | Pisahkan paket dengan API publik yang jelas |

### D. Opsi Kode Lain untuk Logika yang Sama

| Keputusan | Pilihan | Kapan cocok | Catatan |
| --- | --- | --- | --- |
| Gaya arsitektur | Berlapis sederhana (domain, aplikasi, infrastruktur) | Aplikasi kecil dan menengah | Mulai dari sini |
| Gaya arsitektur | Hexagonal (port dan adapter) | Banyak adapter atau kebutuhan uji tanpa I/O | Port dimiliki domain |
| Gaya arsitektur | *Clean architecture* (lingkaran konsentris) | Domain kompleks, tim besar | Banyak lapisan; waspadai boilerplate |
| Gaya arsitektur | *Feature-first* (irisan vertikal per fitur) | Tim dibagi per fitur | Batas lapisan tetap dijaga di dalam tiap fitur |
| Injeksi | Konstruktor (dipilih) | Hampir semua kasus | Eksplisit; mudah diuji |
| Injeksi | Parameter fungsi atau `typedef` | Port berisi satu operasi | Paling ringan |
| Injeksi | *Service locator* (misalnya `get_it`) | Hindari untuk domain | Ketergantungan tersembunyi, galat di runtime |
| Monorepo | Pub workspaces (dipilih) | Banyak paket dalam satu repositori | Satu resolusi dan satu lockfile |
| Monorepo | Dependensi `path:` per paket | Proyek sangat kecil | Resolusi terpisah; mudah tak sinkron |
| Boilerplate model | Tulis tangan dengan pola | Sedikit tipe | Tanpa build |
| Boilerplate model | `build_runner` + `json_serializable` | Banyak tipe bersarang | Langkah build dan berkas hasil generate |
| Boilerplate model | Augmentations | Belum rilis (eksperimen) | Pantau, jangan andalkan |

Alternatif tanpa antarmuka: port sebagai *tipe fungsi*, cocok bila port hanya satu operasi.

```dart
typedef Perbarui = Future<StatusBuku> Function(
  String isbn,
  StatusBuku Function(StatusBuku? sekarang) ubah,
);

class LayananPeminjamanFungsional {
  LayananPeminjamanFungsional({required this.perbarui});
  final Perbarui perbarui;

  Future<void> pinjam(String isbn, String idAnggota, DateTime tempo) async {
    await perbarui(
      isbn,
      (sekarang) => transisi(sekarang ?? const Tersedia(), Meminjam(idAnggota, tempo)),
    );
  }
}

// Komposisi di composition root:
// final layanan = LayananPeminjamanFungsional(perbarui: repo.perbarui);
```

- `typedef Perbarui` menamai bentuk fungsi; layanan hanya mengenal bentuk itu, bukan kelas repositori.
- `perbarui: repo.perbarui` — *tear-off* method menjadi nilai fungsi; tes dapat memberikan fungsi palsu satu baris tanpa membuat kelas `Fake`.
- Pilih antarmuka bila port punya beberapa operasi yang saling terkait (`cariStatus` dan `perbarui`), pilih fungsi bila hanya satu operasi.

### E. Terminologi Esensial

- **Layering** — memisahkan kode menurut tanggung jawab dengan arah ketergantungan yang tetap. **Hexagonal / ports and adapters** — inti bisnis berbicara lewat *port*; *adapter* di tepi menghubungkannya ke dunia nyata.
- **Port masuk (driving)** — antarmuka yang dipakai dunia luar untuk memicu use case. **Port keluar (driven)** — antarmuka yang dibutuhkan domain dari dunia luar. **Adapter** — implementasi konkret sebuah port.
- **Dependency inversion** — modul tingkat tinggi dan rendah sama-sama bergantung pada abstraksi yang dimiliki tingkat tinggi. **Dependency injection** — menyerahkan ketergantungan dari luar. **Composition root** — satu tempat yang merakit objek nyata.
- **API publik** — yang diekspor dan dijanjikan stabil. **`lib/src`** — implementasi yang bebas berubah. **`@internal`** — publik secara teknis tetapi bukan janji bagi pemakai luar.
- **Semantic versioning** — MAJOR.MINOR.PATCH yang menyampaikan tingkat perubahan. **Class modifier** — `interface`, `base`, `final`, `sealed` yang membatasi apa yang boleh dilakukan pemakai terhadap sebuah kelas.
- **Workspace** — banyak paket dalam satu repositori dengan satu resolusi dependensi. **Kopling** — ketergantungan antar-modul. **Kohesi** — keterkaitan isi dalam satu modul. **Ca, Ce, instability** — jumlah yang bergantung padaku, jumlah yang kupakai, dan I = Ce / (Ca + Ce).
- **Operasi atomik** — rangkaian langkah yang tampak sebagai satu kesatuan, tak dapat disela. **Compare-and-set** — menulis hanya bila nilai belum berubah sejak dibaca. **Fitness function arsitektur** — pemeriksaan otomatis atas sifat arsitektur (misalnya aturan dependensi).

### F. Visualisasi (ASCII)

```text
[ CLI / HTTP / UI ] ◄── adapter masuk ──►  ┌──────────────────────────────┐
                                           │  aplikasi (use case)         │
[ SQLite / berkas / API ] ◄─ adapter keluar│   ┌──────────────────────┐   │
                                           │   │  domain (murni)      │   │
                                           │   └──────────────────────┘   │
                                           └──────────────────────────────┘
Aturan emas: panah ketergantungan SELALU menuju ke dalam (ke domain).
Port keluar didefinisikan di dalam; adapter-nya ada di luar dan bergantung pada port itu.
```

```text
   katalog_cli (I = 1,00) ──► katalog_infrastruktur (I = 0,50) ──► katalog_domain (I = 0,00)
          │                                                                ▲
          └────────────────────────────────────────────────────────────────┘
   panah ketergantungan menuju yang lebih stabil; domain paling stabil
```

```text
   naif (cek lalu tindak):
     A:  baca ───────────────────► tulis(A)
     B:        baca ─────────────────────────► tulis(B)      menimpa A diam-diam

   atomik (perbarui, antre per kunci):
     A:  [ baca ─ ubah ─ tulis ]
     B:                          [ baca ─ ubah (ditolak: sudah Dipinjam) ]
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 7.6 dan 7.9 (balapan, antrean, kunci per sumber daya), 7.8 (`Penyimpan` sebagai port), 8.1 sampai 8.3 (tes kontrak, mutasi, skrip dan CI), 3.5 (parse di tepi), serta 5.4 (pembersihan sumber daya).
- **Prasyarat bagi:** 9.2 (pola ketahanan dipasang sebagai *decorator* di batas adapter) dan 9.4 (workspace To-Do v8).
- **Dikembangkan di:** Fase Keamanan (adapter adalah batas kepercayaan; skrip aturan dependensi menjaga domain dari I/O) dan proyek akhir kurikulum (arsitektur sebagai bagian portofolio).

### H. Tips & Praktik Terbaik

- Mulai sederhana. Ekstrak port saat ada dua implementasi atau kebutuhan uji nyata; jangan membuat antarmuka “untuk jaga-jaga”.
- Rancang port dari sudut pandang domain (apa yang domain butuhkan), bukan dari sudut pandang basis data (apa yang tersedia).
- Masukkan jaminan konsistensi (atomisitas, idempotensi) ke dalam kontrak port, tulis di komentar, dan tes pada setiap adapter.
- Satu composition root; jangan membuat adapter di tengah kode aplikasi.
- Ekspor sesedikit mungkin; menambah ekspor mudah, menariknya mahal.
- Pilih class modifier sengaja: tutup yang tak perlu dibuka (`final`, `sealed`), buka hanya port.
- Jadikan aturan dependensi bukti otomatis di `just cek` dan CI; diagram yang tak diperiksa mesin akan dilanggar.
- Hitung Ca, Ce, dan I secara berkala; bila domain mulai memiliki Ce > 0, tanyakan apa yang bocor.
- Tulis keputusan arsitektur penting sebagai catatan singkat (ADR, lihat 9.4) agar alasannya tak hilang.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Port dengan `cari` dan `simpan` terpisah untuk data yang bisa disela | Pinjaman ganda, pembaruan hilang diam-diam | Operasi atomik pada port (`perbarui`) dan tes kontrak dengan jeda |
| Domain mengimpor paket database, HTTP, atau `dart:io` | Tak bisa diuji tanpa I/O; terkunci vendor | Port di domain, adapter di infrastruktur; skrip aturan dependensi |
| Antarmuka dengan satu implementasi abadi | Boilerplate tanpa manfaat | Hapus; ekstrak lagi bila perlu |
| Semua diekspor dari `lib/` | Setiap perubahan internal mematahkan pemakai | `export show` pada satu berkas publik; pakai `lib/src` |
| Menambah anggota abstrak pada `interface class` di MINOR | Semua implementer pecah | Itu MAJOR; atau beri implementasi bawaan di `base class` |
| Service locator atau container DI untuk domain | Ketergantungan tersembunyi; galat di runtime | Injeksi konstruktor dan composition root |
| Adapter dibuat di dalam use case | Tak bisa diganti atau diuji | Serahkan lewat konstruktor |
| Aturan arsitektur hanya di diagram | Dilanggar diam-diam | `tool/cek_arsitektur.dart` di CI |
| Generasi kode untuk dua atau tiga tipe | Langkah build tanpa nilai | Tulis tangan dengan pola |
| `workspace` tanpa `resolution: workspace` di anggota | Resolusi gagal atau paket tak dikenali | Setiap anggota wajib `resolution: workspace` |

### J. Sumber Referensi

- ✔ Pub workspaces: https://dart.dev/to/pub-workspaces · https://dart.dev/tools/pub/workspaces
- Paket: https://dart.dev/tools/pub/create-packages · https://dart.dev/tools/pub/package-layout · https://dart.dev/tools/pub/versioning · ✔ Class modifier untuk pemelihara API: https://dart.dev/language/class-modifiers-for-apis · https://dart.dev/language/class-modifiers
- ✔ Makro dibatalkan: https://dart.dev/go/macros · https://medium.com/dartlang/an-update-on-dart-macros-data-serialization-06d3037d4f12 · ✔ `build_runner`: https://dart.dev/tools/build\_runner · ✔ Primary constructors: https://dart.dev/language/primary-constructors · ✔ Rilis Dart 3.13: https://dart.dev/blog/announcing-dart-3-13
- `package:meta`: https://pub.dev/packages/meta · Lint: https://dart.dev/tools/linter-rules/implementation\_imports
- Konsep: Alistair Cockburn, *Hexagonal Architecture*: https://alistair.cockburn.us/hexagonal-architecture/ · https://en.wikipedia.org/wiki/Dependency\_inversion\_principle · Robert C. Martin, *The Clean Architecture*: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html · Mark Seemann, *Composition Root*: https://blog.ploeh.dk/2011/07/28/CompositionRoot/ · https://en.wikipedia.org/wiki/Coupling\_(computer\_programming) · https://semver.org/
- Buku: R. C. Martin, *Clean Architecture* · E. Evans, *Domain-Driven Design* · N. Ford, R. Parsons, dan P. Kua, *Building Evolutionary Architectures* (fitness function arsitektur).

---

## 9.2 Pola Ketahanan Sistem

*Motivasi: sistem yang tangguh tidak menghindari kegagalan; ia merencanakannya.*

**Struktur pembelajaran (mini daftar isi):** (1) kegagalan sebagai kondisi normal · (2) idempotensi dan kunci idempotensi · (3) retry, backoff, jitter · (4) timeout berlapis dan deadline · (5) circuit breaker · (6) bulkhead dan *load shedding* · (7) rate limiting: token bucket · (8) degradasi anggun · (9) log terstruktur dan metrik · (10) menguji ketahanan: *fault injection* dan waktu virtual.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini merancang logika yang tetap berfungsi dan pulih ketika dunia tidak ideal: retry dengan backoff dan jitter, timeout berlapis, circuit breaker, bulkhead, idempotensi, rate limiting, degradasi anggun, serta observabilitas dasar (log terstruktur dan metrik). Setiap pola diberi kode yang dapat dites dengan waktu virtual dan acak ber-seed (Fase 7 dan 8). Perannya: 9.1 membuat batas antarmodul; modul ini mengatur *apa yang terjadi di batas itu ketika sisi seberang gagal, lambat, atau penuh*.

### B. Konsep Kunci & Filosofi Mendalam

- **Kegagalan adalah kondisi normal.** Dalam sistem yang bergantung pada jaringan, disk, atau layanan lain, kegagalan bukan pengecualian. Pola ketahanan menjaga agar satu kegagalan kecil tak menjadi kegagalan berantai. Langkah pertama selalu *mengelompokkan* kegagalan: **transien** (layak dicoba ulang: timeout, koneksi putus sesaat), **permanen** (jangan diulang: izin ditolak, data tak valid), dan **galat domain** (aturan bisnis menolak: bukan masalah infrastruktur dan tak boleh memicu retry atau membuka breaker).
- **Idempotensi.** Operasi idempoten bila diulang menghasilkan keadaan akhir yang sama seperti sekali. Retry hanya aman pada operasi idempoten. Untuk operasi yang tak alami idempoten (meminjam, menagih) gunakan **kunci idempotensi**: klien mengirim kunci unik per niat; penerima menyimpan hasil per kunci dan menjawab ulang dengan hasil yang sama tanpa mengulang efeknya, termasuk bila dua permintaan berkunci sama tiba bersamaan.
- **Retry dengan backoff dan jitter.** Jeda antar-percobaan berlipat ganda (*backoff eksponensial*) dan diacak (*jitter*) agar ribuan klien tak mengulang serentak (*thundering herd*). *Full jitter*: jeda diambil acak dari 0 sampai plafon eksponensial. Selalu beri **plafon** (batas atas jeda), **batas jumlah percobaan**, dan batasi eksponen agar tak meluap (di web operator geser memotong ke 32 bit; temuan audit 2).
- **Retry hanya di satu lapisan.** Bila tiga lapisan masing-masing mencoba tiga kali, satu permintaan menjadi 27 panggilan ke dependensi yang sedang sakit (*retry amplification*). Tetapkan satu pemilik retry per jalur panggilan, dan pertimbangkan *retry budget* (batas rasio retry terhadap total panggilan).
- **Timeout adalah wajib, tetapi bukan pembatalan.** Tanpa timeout, satu dependensi lambat menahan seluruh sistem. Namun `Future.timeout` hanya berhenti *menunggu*; pekerjaan di bawahnya terus berjalan (7.3), jadi setelah timeout hasil operasi *tak pasti* dan percobaan ulang dapat berjalan bersamaan dengan yang lama. Itulah mengapa retry bergantung pada idempotensi. Bedakan *timeout per percobaan* dari *deadline* total, dan pastikan timeout bagian dalam lebih kecil daripada bagian luar.
- **Circuit breaker.** Berhenti memanggil dependensi yang sedang rusak, agar ia sempat pulih dan agar kita gagal cepat. Tiga keadaan: *tertutup* (panggilan lewat; kegagalan beruntun dihitung), *terbuka* (semua ditolak cepat sampai waktu tunggu habis), *setengah terbuka* (beberapa panggilan uji; sukses menutup, gagal membuka lagi). Hitung hanya kegagalan **sistem**, bukan galat domain; kalibrasi ambang dengan data, bukan perasaan.
- **Bulkhead dan *load shedding*.** Batasi konkurensi per dependensi (sekat terpisah) agar kegagalan atau kelambatan satu tak menghabiskan semua sumber daya. Beri antrean *terbatas*; bila penuh, **tolak segera** (*shed load*) lebih baik daripada antre tanpa batas yang menghabiskan memori dan membuat semua permintaan lambat.
- **Rate limiting.** *Token bucket*: ember berkapasitas tertentu terisi stabil; tiap permintaan mengambil token; kosong berarti ditolak atau ditunda. Kapasitas mengizinkan lonjakan sesaat (*burst*), laju isi membatasi rata-rata. Alternatif: *leaky bucket*, jendela tetap, jendela geser. Ia melindungi sistem dari kelebihan beban dan dari klien jahat.
- **Susunan pola menentukan perilaku.** Urutan lazim dari luar ke dalam: pembatas laju dan bulkhead (pintu masuk), circuit breaker, retry, timeout, panggilan. Breaker di luar retry hanya melihat kegagalan akhir (sebuah panggilan = satu kegagalan); breaker di dalam retry menghitung setiap percobaan dan membuka lebih cepat. Pilih sadar dan tulis alasannya.
- **Degradasi anggun.** Saat dependensi gagal, berikan sesuatu yang lebih baik daripada galat: hasil lama dari cache dengan penanda “basi”, hasil sebagian, atau fitur dimatikan. Pemakai harus tahu bahwa ia menerima versi turun mutu; jalur fallback diuji sama seriusnya dengan jalur utama.
- **Observabilitas.** Sistem yang tak terlihat tak bisa dioperasikan. *Log terstruktur* (kolom konsisten, bukan prosa), *metrik* (penghitung, ukuran, histogram), dan *jejak* (rangkaian satu permintaan). Jaga jumlah nilai label agar metrik tak meledak, sertakan *correlation id* agar satu permintaan dapat dilacak, dan **jangan pernah mencatat rahasia**.
- **Ketahanan harus bisa dites secara deterministik.** Waktu (`clock`, `fake_async`), acak (seed), dan tidur disuntikkan (Fase 5 dan 7). *Fault injection*, yaitu adapter pembungkus yang sengaja gagal, lambat, atau menggantung, membuktikan pola benar-benar bekerja, bukan hanya terlihat benar.
- **Dampak desain.** Retry tanpa backoff dan jitter: badai ulang yang memperparah gangguan. Retry pada operasi non-idempoten: efek ganda (pinjaman ganda, tagihan ganda). Tanpa timeout: antrean menumpuk, memori habis, kegagalan berantai. Breaker terlalu sensitif: memutus layanan sehat; terlalu longgar: tak melindungi. Pool bersama untuk semua dependensi: satu yang lambat memonopoli sumber daya. Log tak terstruktur: sulit dicari; log berisi rahasia: kebocoran.

### C. Sintaks Dasar & Contoh Inti Implementasi

Tambahkan `dart pub add clock pool logging` dan `dart pub add --dev fake_async test`. Semua tes memakai waktu virtual dan acak ber-seed (7.7, 8.1).

**Contoh 1 — `denganRetry` yang diperbaiki: eksponen dibatasi, plafon, deadline-ready, dan dapat diamati.**

```dart
import 'dart:async';
import 'dart:math';

/// Retry dengan backoff eksponensial + full jitter. Hanya untuk operasi IDEMPOTEN.
/// Catatan: timeout tidak membatalkan percobaan yang lambat (7.3); karena itu idempotensi wajib.
Future<T> denganRetry<T>(
  Future<T> Function() kerja, {
  int maksPercobaan = 4,
  Duration dasar = const Duration(milliseconds: 100),
  Duration batasAtas = const Duration(seconds: 5),
  Duration timeout = const Duration(seconds: 2),
  bool Function(Object galat)? layakDiulang,
  Random? acak,
  void Function(int percobaan, Object galat, Duration jeda)? padaUlang,
}) async {
  final rng = acak ?? Random();
  for (var percobaan = 1;; percobaan++) {
    try {
      return await kerja().timeout(timeout); // timeout di SETIAP percobaan
    } on Object catch (galat) {
      final bisaUlang = layakDiulang?.call(galat) ?? galat is TimeoutException;
      if (!bisaUlang || percobaan >= maksPercobaan) rethrow;

      final eksponen = min(percobaan - 1, 20); // cegah luapan dan geser 32-bit di web
      final plafon = min(
        dasar.inMilliseconds * (1 << eksponen),
        batasAtas.inMilliseconds,
      );
      final jeda = Duration(milliseconds: rng.nextInt(plafon + 1)); // full jitter
      padaUlang?.call(percobaan, galat, jeda);
      await Future<void>.delayed(jeda);
    }
  }
}
```

```dart
import 'dart:async';
import 'dart:math';

import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';

void main() {
  test('jeda tak pernah melebihi plafon eksponensial dan batas atas', () {
    fakeAsync((async) {
      final jeda = <Duration>[];
      Object? galat;

      unawaited(
        denganRetry<void>(
          () => Future<void>.error(TimeoutException('lambat')),
          maksPercobaan: 6,
          dasar: const Duration(milliseconds: 100),
          batasAtas: const Duration(milliseconds: 500),
          acak: Random(7),
          padaUlang: (p, g, j) => jeda.add(j),
        ).then((_) {}, onError: (Object e) {
          galat = e;
        }),
      );

      async.elapse(const Duration(seconds: 30));

      expect(jeda, hasLength(5)); // 6 percobaan berarti 5 kali menunggu
      const plafon = [100, 200, 400, 500, 500]; // 100 * 2^n, dibatasi 500
      for (final (i, j) in jeda.indexed) {
        expect(j.inMilliseconds, lessThanOrEqualTo(plafon[i]), reason: 'percobaan ${i + 1}');
      }
      expect(galat, isA<TimeoutException>());
    });
  });
}
```

- `min(percobaan - 1, 20)` — membatasi eksponen; `1 << 20` aman di semua target, sedangkan `1 << 31` negatif dan `1 << 32` kembali ke 1 di web, yang membuat `nextInt` melempar `RangeError` pada percobaan besar (temuan audit 2).
- `min(dasar * 2^eksponen, batasAtas)` — plafon backoff: jeda tak pernah melebihi lima detik secara bawaan, berapa pun jumlah percobaan.
- `rng.nextInt(plafon + 1)` — *full jitter*: jeda diambil acak dari 0 sampai plafon, sehingga klien yang gagal serentak tersebar waktunya.
- `padaUlang` — *hook* pengamatan: dipanggil sebelum menunggu; dipakai untuk log terstruktur dan metrik (Contoh 7) dan memudahkan tes memeriksa jeda tanpa menebak.
- `acak: Random(7)` — acak ber-seed membuat tes deterministik; di produksi diberi `Random()` bawaan (atau `Random.secure()` bila jitter tak boleh dapat ditebak).
- Tes: `Future<void>.error(TimeoutException(...))` di dalam `fakeAsync` mensimulasikan layanan yang selalu timeout; enam percobaan menghasilkan lima jeda dan semuanya di bawah plafon masing-masing; galat terakhir diteruskan.

**Contoh 2 — penjaga idempotensi: kunci per niat, duplikat bersamaan digabung.**

```dart
import 'dart:async';

import 'package:clock/clock.dart';

/// Menjalankan [kerja] paling banyak SEKALI per kunci selama [umur].
/// Duplikat (termasuk yang tiba saat kerja masih berjalan) menerima hasil yang sama.
/// Kegagalan TIDAK disimpan: permintaan ulang dengan kunci sama boleh mencoba lagi.
class PenjagaIdempoten<T> {
  PenjagaIdempoten({this.umur = const Duration(minutes: 10)});

  final Duration umur;
  final _hasil = <String, (DateTime, Future<T>)>{};

  Future<T> jalankan(String kunci, Future<T> Function() kerja) {
    final sekarang = clock.now();
    _hasil.removeWhere((_, nilai) => sekarang.difference(nilai.$1) > umur);

    final ada = _hasil[kunci];
    if (ada != null) return ada.$2; // duplikat: hasil atau kerja yang sama

    final f = kerja();
    _hasil[kunci] = (sekarang, f);
    unawaited(
      f.then<void>((_) {}, onError: (Object _) {
        if (identical(_hasil[kunci]?.$2, f)) _hasil.remove(kunci); // gagal: jangan simpan
      }),
    );
    return f;
  }
}
```

```dart
test('duplikat digabung, gagal tak disimpan, kedaluwarsa menjalankan ulang', () {
  fakeAsync((async) {
    final penjaga = PenjagaIdempoten<int>(umur: const Duration(minutes: 1));
    final hasil = <int>[];
    var jalan = 0;
    final gerbang = Completer<int>();

    unawaited(penjaga.jalankan('k1', () {
      jalan++;
      return gerbang.future;
    }).then(hasil.add));
    unawaited(penjaga.jalankan('k1', () {
      jalan++;
      return gerbang.future;
    }).then(hasil.add));
    expect(jalan, 1); // duplikat tak menjalankan kerja lagi
    gerbang.complete(42);
    async.flushMicrotasks();
    expect(hasil, [42, 42]); // keduanya menerima hasil yang sama

    unawaited(penjaga.jalankan('k1', () {
      jalan++;
      return Future.value(0);
    }).then(hasil.add));
    async.flushMicrotasks();
    expect(jalan, 1); // dijawab dari penyimpanan
    expect(hasil, [42, 42, 42]);

    async.elapse(const Duration(minutes: 2)); // kedaluwarsa
    unawaited(penjaga.jalankan('k1', () {
      jalan++;
      return Future.value(7);
    }).then(hasil.add));
    async.flushMicrotasks();
    expect(jalan, 2);
    expect(hasil.last, 7);

    Object? galat;
    unawaited(penjaga.jalankan('k2', () {
      jalan++;
      return Future<int>.error(StateError('x'));
    }).then((_) {}, onError: (Object e) {
      galat = e;
    }));
    async.flushMicrotasks();
    expect(galat, isA<StateError>());
    unawaited(penjaga.jalankan('k2', () {
      jalan++;
      return Future.value(1);
    }).then(hasil.add));
    async.flushMicrotasks();
    expect(jalan, 4); // k2 dicoba lagi karena kegagalan tak disimpan
  });
});
```

- `Map<String, (DateTime, Future<T>)>` — peta dari kunci ke *record* berisi waktu pencatatan dan `Future` hasil; yang disimpan adalah `Future` itu sendiri, jadi duplikat yang tiba **saat kerja masih berjalan** ikut menunggu hasil yang sama, bukan memulai kerja baru.
- `removeWhere(...)` membuang kunci yang melewati `umur` setiap kali dipanggil, sehingga peta tak membesar selamanya; waktu dibaca dari `clock.now()` agar dapat dikendalikan tes (8.1).
- Kegagalan *tidak* disimpan: `onError` menghapus entri hanya bila entri itu masih `f` yang sama (`identical`), sehingga klien boleh mencoba lagi dengan kunci yang sama; menyimpan kegagalan akan membuat satu galat sesaat menjadi permanen.
- Klien membuat kunci per *niat* (misalnya UUID per klik “pinjam”) dan mengirim ulang kunci yang sama saat retry; penjaga inilah yang membuat retry di 9.2 aman untuk operasi seperti meminjam.
- Catatan batas: penjaga dalam memori hanya berlaku untuk satu proses; untuk banyak instans, simpan kunci di penyimpanan bersama (dan gunakan operasi atomik, 9.1).

**Contoh 3 — circuit breaker dengan tiga keadaan.**

```dart
import 'package:clock/clock.dart';

enum KeadaanSirkuit { tertutup, terbuka, setengahTerbuka }

class SirkuitTerbuka implements Exception {
  const SirkuitTerbuka();

  @override
  String toString() => 'SirkuitTerbuka: panggilan ditolak, dependensi sedang dilindungi';
}

class CircuitBreaker {
  CircuitBreaker({
    this.ambangGagal = 5,
    this.waktuTunggu = const Duration(seconds: 30),
    this.percobaanSetengah = 1,
    this.hitungSebagaiGagal,
    this.padaPerubahan,
  });

  final int ambangGagal;
  final Duration waktuTunggu;
  final int percobaanSetengah;

  /// Hanya kegagalan SISTEM yang dihitung; galat domain jangan (bawaan: semua dihitung).
  final bool Function(Object galat)? hitungSebagaiGagal;
  final void Function(KeadaanSirkuit dari, KeadaanSirkuit ke)? padaPerubahan;

  KeadaanSirkuit _keadaan = KeadaanSirkuit.tertutup;
  int _gagalBeruntun = 0;
  int _probeBerjalan = 0;
  DateTime? _dibukaPada;

  KeadaanSirkuit get keadaan => _keadaan;

  Future<T> jalankan<T>(Future<T> Function() kerja) async {
    final probe = _izinkan(); // melempar SirkuitTerbuka bila ditolak
    try {
      final hasil = await kerja();
      _catatSukses(probe);
      return hasil;
    } on Object catch (galat) {
      if (hitungSebagaiGagal?.call(galat) ?? true) {
        _catatGagal(probe);
      } else {
        _catatSukses(probe); // galat domain: dependensi menjawab dengan sehat
      }
      rethrow;
    } finally {
      if (probe) _probeBerjalan--;
    }
  }

  /// Mengembalikan true bila panggilan ini adalah probe pada keadaan setengah terbuka.
  bool _izinkan() {
    if (_keadaan == KeadaanSirkuit.terbuka) {
      if (clock.now().difference(_dibukaPada!) < waktuTunggu) {
        throw const SirkuitTerbuka();
      }
      _ubah(KeadaanSirkuit.setengahTerbuka);
    }
    if (_keadaan == KeadaanSirkuit.setengahTerbuka) {
      if (_probeBerjalan >= percobaanSetengah) throw const SirkuitTerbuka();
      _probeBerjalan++;
      return true;
    }
    return false;
  }

  void _catatSukses(bool probe) {
    _gagalBeruntun = 0;
    if (probe && _keadaan == KeadaanSirkuit.setengahTerbuka) {
      _ubah(KeadaanSirkuit.tertutup);
    }
  }

  void _catatGagal(bool probe) {
    if (probe) {
      if (_keadaan == KeadaanSirkuit.setengahTerbuka) _buka();
      return;
    }
    _gagalBeruntun++;
    if (_keadaan == KeadaanSirkuit.tertutup && _gagalBeruntun >= ambangGagal) _buka();
  }

  void _buka() {
    _dibukaPada = clock.now();
    _ubah(KeadaanSirkuit.terbuka);
  }

  void _ubah(KeadaanSirkuit ke) {
    final dari = _keadaan;
    if (dari == ke) return;
    _keadaan = ke;
    if (ke == KeadaanSirkuit.tertutup) _gagalBeruntun = 0;
    padaPerubahan?.call(dari, ke);
  }
}
```

```dart
test('siklus: tertutup, terbuka, setengah terbuka, terbuka lagi, tertutup', () {
  fakeAsync((async) {
    final perubahan = <String>[];
    final cb = CircuitBreaker(
      ambangGagal: 3,
      waktuTunggu: const Duration(seconds: 10),
      padaPerubahan: (dari, ke) => perubahan.add('${dari.name}->${ke.name}'),
    );
    var sehat = false;

    Object? cobaPanggil() {
      Object? galat;
      unawaited(
        cb.jalankan(() async {
          if (!sehat) throw StateError('layanan mati');
          return 1;
        }).then((_) {}, onError: (Object e) {
          galat = e;
        }),
      );
      async.flushMicrotasks();
      return galat;
    }

    for (var i = 0; i < 3; i++) {
      expect(cobaPanggil(), isA<StateError>());
    }
    expect(cb.keadaan, KeadaanSirkuit.terbuka);
    expect(cobaPanggil(), isA<SirkuitTerbuka>()); // gagal cepat; kerja tak dipanggil

    async.elapse(const Duration(seconds: 10));
    expect(cobaPanggil(), isA<StateError>()); // probe gagal: kembali terbuka
    expect(cb.keadaan, KeadaanSirkuit.terbuka);

    async.elapse(const Duration(seconds: 10));
    sehat = true;
    expect(cobaPanggil(), isNull); // probe sukses: tertutup
    expect(cb.keadaan, KeadaanSirkuit.tertutup);

    expect(perubahan, [
      'tertutup->terbuka',
      'terbuka->setengahTerbuka',
      'setengahTerbuka->terbuka',
      'terbuka->setengahTerbuka',
      'setengahTerbuka->tertutup',
    ]);
  });
});

test('galat domain tidak membuka sirkuit', () {
  fakeAsync((async) {
    final cb = CircuitBreaker(
      ambangGagal: 2,
      hitungSebagaiGagal: (e) => e is! ArgumentError, // ArgumentError = galat domain
    );
    for (var i = 0; i < 10; i++) {
      unawaited(cb.jalankan<void>(() async => throw ArgumentError('ditolak aturan')).then((_) {}, onError: (Object _) {}));
      async.flushMicrotasks();
    }
    expect(cb.keadaan, KeadaanSirkuit.tertutup);
  });
});
```

- Tiga keadaan disimpan di `_keadaan`; `_gagalBeruntun` menghitung kegagalan berturut-turut saat tertutup; `_dibukaPada` mencatat kapan dibuka untuk menghitung `waktuTunggu`.
- `_izinkan()` memutuskan sebelum kerja dijalankan: saat terbuka dan belum lewat `waktuTunggu`, ia melempar `SirkuitTerbuka` **tanpa memanggil `kerja`** (gagal cepat); setelah lewat, ia berpindah ke setengah terbuka dan hanya mengizinkan `percobaanSetengah` panggilan uji (*probe*).
- Probe yang sukses menutup sirkuit; probe yang gagal membukanya lagi dan mengulang `waktuTunggu`. Hanya probe yang boleh menutup sirkuit, supaya panggilan lama yang kebetulan selesai tak menutupnya keliru.
- `hitungSebagaiGagal` memisahkan kegagalan sistem dari galat domain; tanpa pemisahan, aturan bisnis yang menolak banyak permintaan dapat membuka sirkuit padahal dependensi sehat (tes kedua).
- `padaPerubahan` memberi *hook* untuk log dan metrik; tes memakainya untuk membuktikan urutan transisi yang tepat, termasuk lima peristiwa pada skenario lengkap.
- Waktu dibaca dari `clock.now()`: di dalam `fakeAsync`, `elapse(10 s)` memajukan jam sehingga `waktuTunggu` terlampaui tanpa menunggu 10 detik sungguhan.

**Contoh 4 — bulkhead dengan antrean terbatas (*load shedding*).**

```dart
import 'dart:async';
import 'dart:collection';

class BulkheadPenuh implements Exception {
  const BulkheadPenuh();

  @override
  String toString() => 'BulkheadPenuh: antrean penuh, permintaan ditolak (load shedding)';
}

/// Semafor dengan antrean terbatas: paling banyak [maksBersamaan] berjalan,
/// paling banyak [maksAntre] menunggu, sisanya DITOLAK segera.
class Bulkhead {
  Bulkhead({required this.maksBersamaan, required this.maksAntre});

  final int maksBersamaan;
  final int maksAntre;
  int _aktif = 0;
  final _antrean = Queue<Completer<void>>();

  Future<T> jalankan<T>(Future<T> Function() kerja) async {
    if (_aktif >= maksBersamaan) {
      if (_antrean.length >= maksAntre) throw const BulkheadPenuh();
      final giliran = Completer<void>();
      _antrean.add(giliran);
      await giliran.future; // slot diserahkan langsung; _aktif tak berubah
    } else {
      _aktif++;
    }
    try {
      return await kerja();
    } finally {
      if (_antrean.isNotEmpty) {
        _antrean.removeFirst().complete(); // serahkan slot ke penunggu berikutnya
      } else {
        _aktif--;
      }
    }
  }
}
```

```dart
test('bulkhead: satu berjalan, satu antre, sisanya ditolak segera', () async {
  final b = Bulkhead(maksBersamaan: 1, maksAntre: 1);
  final gerbang = Completer<void>();
  final log = <String>[];

  final a = b.jalankan(() async {
    log.add('A');
    await gerbang.future;
  });
  final bb = b.jalankan(() async => log.add('B')); // masuk antrean

  await expectLater(b.jalankan(() async => log.add('C')), throwsA(isA<BulkheadPenuh>()));

  gerbang.complete();
  await Future.wait([a, bb]);
  expect(log, ['A', 'B']); // C tak pernah dijalankan
});
```

- `_aktif` menghitung kerja yang sedang memegang slot; `_antrean` berisi `Completer` penunggu. Bila slot bebas, kerja langsung jalan; bila penuh dan antrean masih muat, ia menunggu gilirannya; bila antrean juga penuh, `BulkheadPenuh` dilempar **segera**: itulah *load shedding*.
- Saat sebuah kerja selesai (`finally`, termasuk saat gagal), slotnya diserahkan langsung ke penunggu pertama tanpa mengurangi `_aktif`, sehingga tak ada celah tempat pendatang baru menyerobot.
- Satu `Bulkhead` per dependensi: dependensi yang lambat hanya menghabiskan slotnya sendiri, tak slot dependensi lain. Antrean terbatas mencegah memori habis dan kelambatan yang menjalar ke semua permintaan.
- Tes memakai gerbang `Completer` (7.7): A memegang slot, B antre, C ditolak seketika, lalu setelah gerbang dibuka B berjalan.
- Alternatif: `Pool` dari `package:pool` (7.6) membatasi konkurensi tetapi antreannya tak terbatas; bulkhead di atas menambah batas antrean.

**Contoh 5 — rate limiting dengan token bucket.**

```dart
import 'dart:math';

import 'package:clock/clock.dart';

class TokenBucket {
  TokenBucket({required this.kapasitas, required this.isiPerDetik})
      : _token = kapasitas.toDouble(),
        _terakhir = clock.now();

  final int kapasitas; // lonjakan (burst) maksimum
  final double isiPerDetik; // laju rata-rata yang diizinkan
  double _token;
  DateTime _terakhir;

  /// Mengambil [biaya] token bila tersedia; false bila ditolak.
  bool coba([int biaya = 1]) {
    _isiUlang();
    if (_token < biaya) return false;
    _token -= biaya;
    return true;
  }

  void _isiUlang() {
    final sekarang = clock.now();
    final detik = sekarang.difference(_terakhir).inMicroseconds / 1e6;
    _token = min(kapasitas.toDouble(), _token + detik * isiPerDetik);
    _terakhir = sekarang;
  }
}
```

```dart
test('token bucket: lonjakan sebatas kapasitas, lalu mengikuti laju isi', () {
  fakeAsync((async) {
    final bucket = TokenBucket(kapasitas: 3, isiPerDetik: 1);

    expect([bucket.coba(), bucket.coba(), bucket.coba()], [true, true, true]); // lonjakan 3
    expect(bucket.coba(), isFalse); // ember kosong

    async.elapse(const Duration(seconds: 1));
    expect(bucket.coba(), isTrue); // terisi 1 token
    expect(bucket.coba(), isFalse);

    async.elapse(const Duration(seconds: 60)); // lama menganggur: tetap terbatas kapasitas
    expect([bucket.coba(), bucket.coba(), bucket.coba(), bucket.coba()], [true, true, true, false]);
  });
});
```

- Ember berisi `kapasitas` token pada awalnya; tiap permintaan mengambil token; token terisi sebesar `isiPerDetik` × waktu berlalu, tak pernah melebihi `kapasitas`. Kapasitas mengizinkan lonjakan sesaat; laju isi membatasi rata-rata jangka panjang.
- Isi ulang dihitung *malas* saat `coba` dipanggil (selisih waktu), bukan dengan timer, sehingga tak ada timer yang perlu dibersihkan dan mudah dites dengan waktu virtual.
- `inMicroseconds / 1e6` memberi detik pecahan; pecahan token terakumulasi sehingga laju rendah (misalnya 0,5 per detik) tetap tepat.
- Tes: tiga permintaan pertama lolos (kapasitas), keempat ditolak; setelah satu detik satu token kembali; setelah satu menit menganggur ember tetap berhenti di kapasitas 3.
- Untuk menolak dengan petunjuk, hitung `tungguHingga(biaya)` dari kekurangan token dibagi `isiPerDetik`, dan kirim sebagai nilai *retry-after* ke klien.

**Contoh 6 — degradasi anggun: fallback ke data lama dengan penanda.**

```dart
import 'dart:async';
import 'dart:math';

import 'package:clock/clock.dart';
import 'package:logging/logging.dart';

class GagalSementara implements Exception {
  const GagalSementara();
}

class HasilIsbn {
  const HasilIsbn(this.judul, {this.basi = false});
  final String judul;
  final bool basi; // true: data lama dari cache karena layanan gagal

  HasilIsbn tandaiBasi() => HasilIsbn(judul, basi: true);
}

abstract interface class LayananIsbn {
  Future<HasilIsbn> cari(String isbn);
}

class PencarianIsbn {
  PencarianIsbn(
    this._layanan, {
    required CircuitBreaker breaker,
    Random? acak,
    this.umurMaksBasi = const Duration(hours: 24),
  })  : _breaker = breaker,
        _acak = acak;

  final LayananIsbn _layanan;
  final CircuitBreaker _breaker;
  final Random? _acak;
  final Duration umurMaksBasi;
  final _cache = <String, (DateTime, HasilIsbn)>{};
  final _log = Logger('katalog.isbn');

  Future<HasilIsbn> cari(String isbn) async {
    try {
      final hasil = await _breaker.jalankan(
        () => denganRetry(
          () => _layanan.cari(isbn),
          layakDiulang: (e) => e is TimeoutException || e is GagalSementara,
          acak: _acak,
        ),
      );
      _cache[isbn] = (clock.now(), hasil);
      return hasil;
    } on Object catch (galat) {
      final lama = _cache[isbn];
      if (lama != null && clock.now().difference(lama.$1) <= umurMaksBasi) {
        _log.warning({'event': 'fallback_cache', 'isbn': isbn, 'galat': galat.runtimeType.toString()});
        return lama.$2.tandaiBasi(); // degradasi: lebih baik daripada galat, tetapi diberi tanda
      }
      rethrow; // tak ada data lama yang layak: galat sampai ke pemanggil
    }
  }
}
```

```dart
class LayananIsbnFake implements LayananIsbn {
  LayananIsbnFake(this.hidup);
  final bool Function() hidup;

  @override
  Future<HasilIsbn> cari(String isbn) async {
    if (!hidup()) throw const GagalSementara();
    return HasilIsbn('Judul $isbn');
  }
}

test('degradasi anggun: data lama bertanda basi saat layanan gagal', () {
  fakeAsync((async) {
    var hidup = true;
    final pencarian = PencarianIsbn(
      LayananIsbnFake(() => hidup),
      breaker: CircuitBreaker(),
      acak: Random(1),
    );
    HasilIsbn? h1, h2;
    Object? galat;

    unawaited(pencarian.cari('978-0').then((h) => h1 = h));
    async.flushMicrotasks();
    expect(h1?.basi, isFalse);

    hidup = false;
    unawaited(pencarian.cari('978-0').then((h) => h2 = h));
    async.elapse(const Duration(minutes: 1)); // semua retry dan jeda lewat
    expect(h2?.basi, isTrue); // fallback ke cache
    expect(h2?.judul, h1?.judul);

    unawaited(pencarian.cari('978-9').then((_) {}, onError: (Object e) {
      galat = e;
    }));
    async.elapse(const Duration(minutes: 1));
    expect(galat, isA<GagalSementara>()); // tak ada cache: galat sampai ke pemanggil
  });
});
```

- `PencarianIsbn` menyusun tiga pola: breaker di luar, `denganRetry` di dalam, dan cache sebagai jalur turun mutu. Hanya `TimeoutException` dan `GagalSementara` yang dianggap layak diulang.
- `HasilIsbn.basi` — **penanda** bahwa pemakai menerima data lama; degradasi tanpa penanda adalah kebohongan.
- `umurMaksBasi` membatasi kelayakan data lama (24 jam): data yang terlalu tua lebih baik ditolak daripada disajikan.
- Galat tetap dilempar bila tak ada cache yang layak; fallback tak menyembunyikan kegagalan yang tak dapat dikompensasi.
- Tes menutup tiga jalur: sukses (mengisi cache), gagal dengan cache (fallback bertanda), dan gagal tanpa cache (galat). Jalur fallback diuji sama serius dengan jalur utama.

**Contoh 7 — log terstruktur dan metrik dasar.**

```dart
import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';

/// Mencatat setiap LogRecord sebagai satu baris JSON (JSON Lines).
void pasangLogTerstruktur({Level level = Level.INFO, IOSink? keluaran}) {
  final sink = keluaran ?? stderr;
  Logger.root.level = level;
  Logger.root.onRecord.listen((r) {
    final isi = switch (r.object) {
      final Map<Object?, Object?> m => {for (final e in m.entries) '${e.key}': e.value},
      _ => <String, Object?>{'pesan': r.message},
    };
    sink.writeln(jsonEncode({
      'waktu': r.time.toUtc().toIso8601String(),
      'tingkat': r.level.name,
      'logger': r.loggerName,
      ...isi,
      if (r.error != null) 'galat': r.error.toString(),
      if (r.stackTrace != null) 'jejak': r.stackTrace.toString(),
    }));
  });
}

final _log = Logger('katalog.ketahanan');

// Pemakaian di hook retry (Contoh 1):
// padaUlang: (p, g, j) => _log.warning({
//   'event': 'retry', 'percobaan': p, 'galat': g.runtimeType.toString(), 'jeda_ms': j.inMilliseconds,
// }),

/// Menyamarkan nilai bidang yang berpotensi rahasia sebelum dicatat.
Map<String, Object?> redaksi(
  Map<String, Object?> data, {
  Set<String> rahasia = const {'sandi', 'token', 'kunci_api'},
}) =>
    {for (final e in data.entries) e.key: rahasia.contains(e.key) ? '***' : e.value};
```

```dart
class Metrik {
  final _penghitung = <String, int>{};

  void tambah(String nama, [int jumlah = 1]) =>
      _penghitung.update(nama, (v) => v + jumlah, ifAbsent: () => jumlah);

  Map<String, int> get salinan => Map.unmodifiable(_penghitung);
}

class Histogram {
  Histogram(this.batasMs) : _hitungan = List.filled(batasMs.length + 1, 0);

  final List<int> batasMs; // naik, misalnya [10, 50, 100, 500]
  final List<int> _hitungan; // satu ember per batas, ditambah satu ember "di atas semua"

  void catat(Duration d) {
    final ms = d.inMilliseconds;
    var i = 0;
    while (i < batasMs.length && ms > batasMs[i]) {
      i++;
    }
    _hitungan[i]++;
  }

  Map<String, int> get ringkasan => {
        for (var i = 0; i < batasMs.length; i++) '<=${batasMs[i]}ms': _hitungan[i],
        '>${batasMs.last}ms': _hitungan.last,
      };
}
```

```dart
test('histogram menempatkan durasi pada ember yang benar; redaksi menyamarkan rahasia', () {
  final h = Histogram([10, 50, 100, 500])
    ..catat(const Duration(milliseconds: 5))
    ..catat(const Duration(milliseconds: 10))
    ..catat(const Duration(milliseconds: 11))
    ..catat(const Duration(milliseconds: 600));
  expect(h.ringkasan, {'<=10ms': 2, '<=50ms': 1, '<=100ms': 0, '<=500ms': 0, '>500ms': 1});

  expect(redaksi({'isbn': '978-0', 'token': 'rahasia123'}), {'isbn': '978-0', 'token': '***'});
});
```

- `Logger('katalog.ketahanan')` dari `package:logging`; **pesan boleh berupa objek apa pun**, dan `LogRecord.object` menyimpannya apa adanya. Di sini peristiwa dicatat sebagai peta `{event: ..., ...}` lalu diserialisasi sebagai satu baris JSON: bentuk yang mudah dicari, disaring, dan diagregasi (*JSON Lines*).
- `switch (r.object)` dengan pola `final Map<Object?, Object?> m` menerima peta apa pun; selain peta, pesan teks dibungkus ke `{'pesan': ...}`; `...isi` menyebarkan isi ke objek JSON akhir.
- `redaksi` menyamarkan nilai bidang rahasia *sebelum* ditulis; mencatat rahasia ke log adalah kebocoran (Fase Keamanan). Sertakan *correlation id* sebagai bidang tetap (misalnya `'korelasi': id`) agar satu permintaan dapat dilacak lintas log.
- `Metrik` adalah penghitung bernama (misalnya `retry_total`, `fallback_total`, `sirkuit_dibuka_total`); `Histogram` mengelompokkan durasi ke ember sehingga kita melihat *sebaran*, bukan hanya rata-rata. Batas ember inklusif (`<=`) dan ada satu ember untuk semua yang melebihi batas terakhir.
- Jaga jumlah nilai berbeda pada label (kardinalitas): ID pengguna atau ISBN sebagai nama metrik meledakkan jumlah deret; masukkan hal itu ke log, bukan ke metrik.

**Contoh 8 — *fault injection* dan susunan semua pola.**

```dart
import 'dart:async';
import 'dart:math';

/// Pembungkus yang SENGAJA gagal atau lambat, untuk membuktikan ketahanan (deterministik via seed).
class LayananIsbnNakal implements LayananIsbn {
  LayananIsbnNakal(
    this._dalam, {
    this.peluangGagal = 0.3,
    this.peluangLambat = 0.1,
    this.tundaLambat = const Duration(seconds: 5),
    Random? acak,
  }) : _acak = acak ?? Random();

  final LayananIsbn _dalam;
  final double peluangGagal;
  final double peluangLambat;
  final Duration tundaLambat;
  final Random _acak;

  @override
  Future<HasilIsbn> cari(String isbn) async {
    if (_acak.nextDouble() < peluangLambat) await Future<void>.delayed(tundaLambat);
    if (_acak.nextDouble() < peluangGagal) throw const GagalSementara();
    return _dalam.cari(isbn);
  }
}

class TerlaluBanyakPermintaan implements Exception {
  const TerlaluBanyakPermintaan();
}

class CariTangguh {
  CariTangguh(this._layanan)
      : _limiter = TokenBucket(kapasitas: 20, isiPerDetik: 10),
        _bulkhead = Bulkhead(maksBersamaan: 8, maksAntre: 32),
        _breaker = CircuitBreaker(
          ambangGagal: 5,
          waktuTunggu: const Duration(seconds: 30),
          hitungSebagaiGagal: (e) => e is TimeoutException || e is GagalSementara,
        );

  final LayananIsbn _layanan;
  final TokenBucket _limiter;
  final Bulkhead _bulkhead;
  final CircuitBreaker _breaker;

  Future<HasilIsbn> cari(String isbn) async {
    if (!_limiter.coba()) throw const TerlaluBanyakPermintaan(); // 1. pintu masuk: laju
    return _bulkhead.jalankan(() => //                         2. batasi konkurensi + antre terbatas
        _breaker.jalankan(() => //                             3. gagal cepat bila dependensi sakit
            denganRetry(() => //                               4. retry (+ 5. timeout tiap percobaan)
                _layanan.cari(isbn),
                layakDiulang: (e) => e is TimeoutException || e is GagalSementara,
                timeout: const Duration(seconds: 2))));
  }
}
```

- `LayananIsbnNakal` membungkus layanan sungguhan dan, dengan peluang tertentu, menambah kelambatan atau melempar `GagalSementara`; dengan `Random` ber-seed dan waktu virtual, perilaku buruk menjadi *dapat diulang*. Inilah cara membuktikan pola ketahanan bekerja, bukan sekadar terbaca benar.
- Susunan dari luar ke dalam: (1) token bucket menolak kelebihan laju sebelum sumber daya apa pun terpakai; (2) bulkhead membatasi konkurensi dan antrean; (3) breaker menolak cepat bila dependensi sedang dilindungi; (4) retry; (5) timeout per percobaan. Breaker di luar retry berarti satu panggilan yang gagal setelah semua percobaan dihitung sebagai satu kegagalan.
- Hitung batas waktu terburuk: empat percobaan dengan timeout dua detik plus jeda hingga 0,7 detik kira-kira 8,7 detik. Bila pemakai tak boleh menunggu selama itu, tambahkan *deadline* total dan batalkan percobaan berikutnya ketika sisa waktu habis.
- Hanya satu lapisan yang melakukan retry (`denganRetry`); jangan menambah retry di klien HTTP, di repositori, *dan* di sini, atau satu permintaan menjadi puluhan panggilan.

### D. Opsi Kode Lain untuk Logika yang Sama

| Pola | Pilihan | Perilaku | Catatan |
| --- | --- | --- | --- |
| Jeda retry | Tetap | Jeda sama tiap percobaan | Sederhana; klien serentak tetap bertabrakan |
| Jeda retry | Eksponensial | 100, 200, 400 ms … | Mengurangi tekanan; tanpa jitter klien tetap serempak |
| Jeda retry | Eksponensial + *full jitter* (dipilih) | Acak 0 sampai plafon | Penyebaran terbaik pada banyak klien |
| Jeda retry | *Decorrelated jitter* | Acak dari dasar sampai 3x jeda sebelumnya | Alternatif populer; tanpa hitungan percobaan |
| Batas waktu | Per percobaan (dipilih) | Tiap percobaan punya batas sendiri | Total waktu bisa lebih besar dari satu batas |
| Batas waktu | *Deadline* total | Satu batas untuk seluruh operasi | Perlu menyusutkan timeout percobaan sisa |
| Breaker | Hitung kegagalan beruntun (dipilih) | Sederhana | Satu keberhasilan menghapus riwayat |
| Breaker | Laju galat pada jendela geser | Lebih stabil pada lalu lintas tinggi | Butuh penyimpanan jendela |
| Pembatas laju | Token bucket (dipilih) | Lonjakan sebatas kapasitas, rata-rata terjaga | Paling lazim |
| Pembatas laju | Leaky bucket | Keluaran dihaluskan pada laju tetap | Menunda, bukan menolak |
| Pembatas laju | Jendela tetap atau geser | Hitung permintaan per interval | Jendela tetap membiarkan lonjakan di perbatasan |
| Pustaka | Kode sendiri seperti di atas | Kendali penuh, mudah dites | Anda memelihara |
| Pustaka | `package:retry` | Retry siap pakai | Hanya retry; breaker dan bulkhead tetap sendiri |

Alternatif jeda: *decorrelated jitter*.

```dart
import 'dart:math';

/// Jeda berikutnya = acak antara [dasar] dan 3 kali jeda sebelumnya, dibatasi [batasAtas].
Duration jedaDekorelasi(
  Duration terakhir,
  Duration dasar,
  Duration batasAtas,
  Random rng,
) {
  final bawah = dasar.inMilliseconds;
  final atas = min(batasAtas.inMilliseconds, terakhir.inMilliseconds * 3);
  return Duration(milliseconds: bawah + rng.nextInt(max(1, atas - bawah + 1)));
}
```

- Jeda pertama dimulai dari `terakhir = dasar`; tiap jeda baru bergantung pada jeda sebelumnya, bukan pada jumlah percobaan, sehingga tak ada eksponen yang perlu dibatasi.
- Batas atas dijaga oleh `min(batasAtas, terakhir * 3)`; `max(1, ...)` mencegah argumen `nextInt` nol bila batas atas lebih kecil dari dasar.
- Pilih *full jitter* (Contoh 1) bila ingin kode paling sederhana dan mudah dites; pilih *decorrelated jitter* bila ingin menghindari ketergantungan pada hitungan percobaan.

### E. Terminologi Esensial

- **Transien / permanen / galat domain** — kegagalan sesaat yang layak diulang; kegagalan yang tak akan sembuh dengan diulang; penolakan oleh aturan bisnis yang bukan masalah infrastruktur.
- **Idempoten** — diulang tak mengubah hasil akhir. **Kunci idempotensi** — pengenal niat yang membuat penerima menjawab ulang tanpa mengulang efek. **At-least-once / at-most-once** — jaminan pengiriman paling sedikit sekali atau paling banyak sekali; efek *tepat sekali* dicapai dengan at-least-once ditambah idempotensi.
- **Backoff eksponensial, jitter, *thundering herd*** — jeda berlipat; keacakan pada jeda; lonjakan serempak yang menjatuhkan layanan yang sedang pulih. **Retry amplification** — retry bertingkat yang menggandakan beban.
- **Timeout / deadline** — batas waktu per percobaan atau per operasi keseluruhan. **Circuit breaker** — pemutus yang menolak panggilan ke dependensi yang terus gagal, dengan keadaan tertutup, terbuka, setengah terbuka. **Probe** — panggilan uji pada keadaan setengah terbuka.
- **Bulkhead / *load shedding*** — sekat sumber daya per dependensi; menolak permintaan segera saat penuh daripada antre tanpa batas. **Token bucket** — pembatas laju berbasis ember token.
- **Degradasi anggun (*graceful degradation*)** — turun mutu secara terkendali saat gagal. **Fail fast** — gagal segera, tanpa menunggu.
- **Observabilitas / log terstruktur / metrik / histogram / *correlation id*** — kemampuan memahami sistem dari keluarannya; log berupa data berkolom; ukuran numerik agregat; sebaran nilai per ember; pengenal yang mengikat semua catatan satu permintaan.
- **Fault injection** — menyuntikkan kegagalan secara sengaja untuk membuktikan ketahanan.

### F. Visualisasi (ASCII)

```text
panggil ─► [timeout] ─► gagal? ─► layak diulang? ─ya─► tunggu rand(0 .. min(plafon, dasar * 2^n)) ─► ulangi
                                       └─ tidak / jatah habis ─► rethrow

circuit breaker:   TERTUTUP ──(gagal beruntun ≥ ambang)──► TERBUKA ──(waktu tunggu)──► SETENGAH TERBUKA
                      ▲                                                                  │
                      └──────────────────── probe sukses ◄───────────────────────────────┤
                                              probe gagal ──────► kembali TERBUKA ◄──────┘
```

```text
 permintaan ─► [token bucket] ─► [bulkhead + antre] ─► [circuit breaker] ─► [retry + timeout] ─► dependensi
                tolak: terlalu       tolak: penuh         tolak: terbuka        gagal setelah N percobaan
                banyak permintaan
                  └────────── setiap penolakan dan perubahan keadaan: log terstruktur + metrik ──────────┘
```

```text
   isi stabil (isiPerDetik) ─►  ┌───────────────┐
                                │ ember (K token)│ ─► tiap permintaan mengambil token
                                └───────────────┘     kosong ⇒ tolak atau tunda
   lama menganggur ⇒ ember penuh (lonjakan sebatas K), bukan tak terbatas
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 5.6 dan 5.8 (gagasan retry dan klasifikasi galat), 7.3 (timeout bukan pembatalan), 7.6 dan 7.9 (antrean, `Pool`, kunci), 7.7 dan 8.1 (waktu virtual, acak ber-seed, *fault injection*), 8.3 (tes kontrak adapter), serta 9.1 (batas adapter tempat pola dipasang).
- **Prasyarat bagi:** 9.4 (To-Do v8 memasang ketahanan sebagai *decorator* di batas adapter).
- **Dikembangkan di:** Fase Keamanan (rate limiting sebagai pertahanan, log tanpa rahasia, gagal dengan aman) dan proyek akhir (laporan uji beban dan ketahanan).

### H. Tips & Praktik Terbaik

- Klasifikasikan galat *sebelum* mengulang; hanya yang transien diulang, galat domain tidak pernah.
- Pasang retry di **satu** lapisan per jalur panggilan; jangan menumpuk retry di klien, repositori, dan layanan sekaligus.
- Selalu beri batas: jumlah percobaan, plafon jeda, timeout per percobaan, dan bila perlu deadline total.
- Anggap hasil setelah timeout *tak pasti*; rancang operasi idempoten atau beri kunci idempotensi sebelum menambahkan retry.
- Hitung hanya kegagalan sistem pada breaker; kalibrasi `ambangGagal` dan `waktuTunggu` dari data latensi dan galat, bukan perasaan.
- Beri antrean bulkhead batas; tolak lebih awal lebih baik daripada gagal terlambat.
- Setiap jalur turun mutu harus bertanda dan teruji; degradasi tanpa penanda menipu pemakai.
- Catat setiap keputusan ketahanan (retry, sirkuit terbuka, fallback, penolakan) sebagai log terstruktur dan metrik, dan redaksi rahasia.
- Uji dengan *fault injection* ber-seed dan waktu virtual; ketahanan yang tak pernah diuji dengan kegagalan hanyalah harapan.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Retry tanpa jitter dan plafon | Badai ulang; jeda tak terbatas atau `RangeError` di web | *Full jitter*, plafon, eksponen dibatasi |
| Retry pada operasi non-idempoten | Efek ganda | Kunci idempotensi; operasi atomik di port |
| Retry di banyak lapisan | Satu permintaan menjadi puluhan panggilan | Satu pemilik retry per jalur |
| Tanpa timeout | Antrean menumpuk; kegagalan berantai | Timeout per percobaan dan deadline total |
| Menganggap timeout sama dengan pembatalan | Dua percobaan berjalan bersamaan | Idempotensi dan pagar (7.8) |
| Breaker menghitung galat domain | Memutus layanan yang sehat | `hitungSebagaiGagal` hanya untuk kegagalan sistem |
| Probe boleh banyak sekaligus | Dependensi yang pulih terhantam lagi | Batasi `percobaanSetengah` |
| Antrean bulkhead tak terbatas | Memori habis; semua permintaan lambat | `maksAntre` dan tolak segera |
| Fallback tanpa penanda | Pemakai mengira data segar | Tandai data basi |
| Log berisi rahasia atau label berkardinalitas tinggi | Kebocoran; metrik meledak | `redaksi`; pindahkan identitas ke log |
| Tes ketahanan memakai waktu nyata | Lambat dan rapuh | `fakeAsync`, `clock`, acak ber-seed |

### J. Sumber Referensi

- AWS: *Exponential Backoff and Jitter*: https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/ · *Timeouts, retries, and backoff with jitter*: https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/
- Pola (Azure Architecture Center): Retry https://learn.microsoft.com/en-us/azure/architecture/patterns/retry · Circuit Breaker https://learn.microsoft.com/en-us/azure/architecture/patterns/circuit-breaker · Bulkhead https://learn.microsoft.com/en-us/azure/architecture/patterns/bulkhead · Rate Limiting https://learn.microsoft.com/en-us/azure/architecture/patterns/rate-limiting-pattern
- Martin Fowler, *CircuitBreaker*: https://martinfowler.com/bliki/CircuitBreaker.html · Token bucket: https://en.wikipedia.org/wiki/Token\_bucket · Idempotence: https://en.wikipedia.org/wiki/Idempotence · Stripe, *Idempotent requests*: https://stripe.com/docs/api/idempotent\_requests
- Google SRE: https://sre.google/sre-book/handling-overload/ · https://sre.google/sre-book/addressing-cascading-failures/
- Dart: `Future.timeout` https://api.dart.dev/dart-async/Future/timeout.html · ✔ `package:pool` https://pub.dev/packages/pool · `package:logging` https://pub.dev/packages/logging · ✔ `package:async` https://pub.dev/packages/async · `package:clock` https://pub.dev/packages/clock · ✔ `fake_async` https://pub.dev/packages/fake\_async/changelog · `package:retry` https://pub.dev/packages/retry
- Buku: M. Nygard, *Release It!* (pola stabilitas: timeout, breaker, bulkhead); B. Beyer dkk., *Site Reliability Engineering*.

---

## 9.3 Interoperabilitas & Lintas-Platform: FFI, JS/Wasm, Build Hooks

*Motivasi: kekuatan sebuah bahasa terlihat saat ia berani berbicara dengan bahasa lain tanpa kehilangan kendali.*

**Struktur pembelajaran (mini daftar isi):** (1) peta interop: FFI, build hooks, JS, proses terpisah · (2) `dart:ffi`: tipe native, `lookupFunction` dan `@Native` · (3) memori native: `Arena`, `Finalizer`, `NativeFinalizer`, `dispose` · (4) callback dan struct · (5) `ffigen` dan `jnigen` · (6) build hooks dan aset native · (7) Rust dan C++ lewat ABI C · (8) `dart:js_interop` dan `package:web` · (9) Wasm dan perbedaan semantik antar target · (10) import bersyarat dan adapter platform · (11) alternatif tanpa FFI: proses terpisah dan protokol.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini menghubungkan logika Dart dengan dunia lain: pustaka C dan Rust lewat FFI, JavaScript dan Wasm di web, dan bahasa lain lewat proses atau protokol. Ia juga mengajarkan cara menulis logika yang berperilaku konsisten di banyak target kompilasi (VM, AOT, JS, Wasm), termasuk perbedaan semantik antar target. Perannya: 9.1 menaruh dunia luar di balik port; modul ini membahas *seberapa dalam dan seberapa aman* adapter itu boleh menyentuh dunia luar, dengan pengakuan jujur bahwa memori native mengembalikan risiko yang dihapus oleh Dart.

### B. Konsep Kunci & Filosofi Mendalam

- **Peta interop.** Lima jalur: (1) **FFI** untuk memanggil pustaka C secara langsung; (2) **build hooks** untuk membangun atau membundel kode native bersama paket; (3) **interop JS** untuk web; (4) **proses terpisah** (stdio atau socket); (5) **protokol** (protobuf, gRPC, JSON). Pilih menurut kebutuhan: kecepatan, isolasi crash dan hak akses, portabilitas, dan kerumitan.
- **FFI memetakan tanda tangan C ke tipe Dart.** Dua bentuk: `lookupFunction` mencari simbol saat runtime dari `DynamicLibrary`; `@Native` mendeklarasikan fungsi `external` yang terikat ke aset native (jalur modern, bersama build hooks). Sisi lain (Rust, C++, Zig) harus mengekspos **ABI C** (`extern "C"`).
- **Tipe native.** `Int32`, `Int64`, `Double`, `Pointer<T>`, `Void`, `Utf8` (dari `package:ffi`), serta tipe bergantung platform: `Int` (C `int`), `Long`, dan `Size` (C `size_t`). Memakai `Size` untuk `size_t` lebih tepat daripada `IntPtr`, karena ukuran `size_t` dijamin sesuai ABI platform.
- **GC Dart tidak mengelola memori native.** Aturan emas kepemilikan: *yang mengalokasikan, membebaskan*. Alat: `malloc` dan `calloc` (`package:ffi`), `Arena` dan `using` (pembebasan massal pada akhir lingkup), `Finalizer` dan `NativeFinalizer` (jaring pengaman saat objek dikoleksi GC, **tidak deterministik**), dan `dispose` eksplisit (deterministik). Untuk sumber daya yang bernilai, gunakan `dispose` atau `Arena` sebagai jalur utama dan finalizer sebagai cadangan.
- **Jangan bocorkan `Pointer` ke API publik.** Bungkus pemilik memori native dalam kelas Dart yang aman: menyembunyikan pointer, memeriksa rentang, menolak pemakaian setelah `dispose`, dan melepas lewat `Finalizable` + `NativeFinalizer`.
- **Batas FFI adalah batas kepercayaan (Fase Keamanan).** Kesalahan memori di sisi native (*use-after-free*, *buffer overflow*) kembali menjadi risiko, dan dapat merusak seluruh proses. Perlakukan data dari native sebagai tak tepercaya: periksa panjang dan rentang. Waspadai `asTypedList` yang membuat *tampilan* atas memori native: setelah memori dibebaskan, tampilan itu menggantung; salin keluar sebelum membebaskan.
- **Callback dan thread.** Fungsi Dart yang dipanggil dari native (misalnya pembanding `qsort`) dibuat dengan `NativeCallable`: `isolateLocal` untuk pemanggilan sinkron pada thread isolate yang sama, `listener` untuk pemanggilan dari thread mana pun (asinkron, tanpa nilai kembali). Callback harus dilepas (`close`) setelah selesai.
- **Biaya.** Panggilan FFI murah tetapi tidak gratis, dan marshalling data (string, daftar) mahal. Untuk jalur panas kecil, Dart murni sering lebih cepat; ukur dulu (6.2). FFI layak bila ada pustaka native yang matang atau komputasi sangat berat.
- **Binding otomatis.** `ffigen` menghasilkan binding Dart dari header C; `jnigen` dari Java dan Kotlin. Mengurangi galat tulis tangan, tetapi header, ABI, dan binding harus tetap sinkron (hasilkan ulang saat header berubah).
- **Build hooks (Dart ≥ 3.10).** Sebuah paket memuat `hook/build.dart` yang dijalankan toolchain pada `dart run`, `dart build`, dan `dart test`: ia mengompilasi (`native_toolchain_c` dengan `CBuilder`) atau membundel pustaka native dan mendaftarkannya sebagai `CodeAsset`; `@Native` menemukan aset itu lewat identitasnya. Hook berjalan dalam lingkungan semi-hermetik, dan paket `hooks`, `code_assets`, `native_toolchain_c` dipasang di `dependencies`. Sejak 3.13 ada *link hooks* dan pencatatan pemakaian (`recordedUses`) untuk membuang aset yang tak terpakai (tree-shaking).
- **Interop JS.** `dart:js_interop` dan `package:web` adalah jembatan *bertipe* ke JavaScript dan DOM untuk target web: tipe `JSAny`, `JSObject`, `JSString`, anotasi `@JS()` pada deklarasi `external`, *extension type* sebagai pembungkus bertipe, dan konversi eksplisit `.toJS` dan `.toDart`.
- **Wasm.** `dart compile wasm` menghasilkan WebAssembly; semantiknya tidak identik dengan target lain. Logika lintas-platform harus diuji pada setiap target yang dituju.
- **Semantik angka berbeda per target.** Di native `int` adalah bilangan bulat bertanda 64 bit. Di web `int` adalah angka JavaScript: presisi bilangan bulat aman hanya 53 bit, dan operator bitwise serta geser memotong operand ke 32 bit; kompiler web menolak literal bulat di luar rentang yang dapat direpresentasikan. Untuk 64 bit ketat gunakan `package:fixnum` (`Int64`) atau `BigInt`.
- **Import bersyarat.** `export 'a.dart' if (dart.library.io) 'b.dart' if (dart.library.js_interop) 'c.dart'` memilih implementasi sesuai kemampuan platform. Letakkan di *adapter tepi* (9.1) supaya logika platform tak mencemari domain.
- **Alternatif tanpa FFI.** Proses terpisah (stdio JSON Lines, socket) dan protokol (protobuf atau gRPC). Kelebihannya: crash dan hak akses terisolasi, bahasa bebas; kekurangannya: latensi, serialisasi, dan siklus hidup proses yang harus dikelola.
- **Dampak desain.** FFI untuk jalur panas yang kecil: overhead dan kerumitan melebihi manfaat. Memori native tak dibebaskan: kebocoran yang tak terlihat GC. Mempercayai data dari native tanpa validasi: kerusakan memori menjalar. Mengasumsikan logika identik di semua target: bug khusus web lolos. Import bersyarat tersebar di mana-mana: logika platform bocor ke domain.

### C. Sintaks Dasar & Contoh Inti Implementasi

Semua contoh FFI di bagian ini memakai libc dan hanya berlaku di Linux dan macOS (di Windows libc berbeda). Tambahkan `dart pub add ffi`.

**Contoh 1 — memanggil `strlen` milik libc.**

```dart
import 'dart:ffi';

import 'package:ffi/ffi.dart';

typedef _StrlenC = Size Function(Pointer<Utf8>); // size_t di sisi C menjadi Size
typedef _StrlenDart = int Function(Pointer<Utf8>);

int panjangC(String s) {
  final libc = DynamicLibrary.process(); // simbol libc dari proses yang berjalan
  final strlen = libc.lookupFunction<_StrlenC, _StrlenDart>('strlen');
  return using((Arena arena) {
    final p = s.toNativeUtf8(allocator: arena); // alokasi native di dalam arena
    return strlen(p); // arena membebaskan p begitu blok ini selesai
  });
}
```

```dart
@TestOn('linux || mac-os')
library;

import 'package:test/test.dart';

void main() {
  test('panjangC menghitung byte UTF-8, bukan jumlah karakter', () {
    expect(panjangC('halo'), 4);
    expect(panjangC('é'), 2); // satu karakter, dua byte UTF-8
    expect(panjangC(''), 0);
  });
}
```

- `typedef _StrlenC` menyatakan tanda tangan di sisi C (tipe native: `Size` untuk `size_t`, `Pointer<Utf8>` untuk `const char*`); `typedef _StrlenDart` adalah padanannya di sisi Dart (`int`, `Pointer<Utf8>`). Dua `typedef` itulah “kamus penerjemah” antara dua dunia.
- `DynamicLibrary.process()` membuka simbol yang sudah ada di proses (libc sudah dimuat); untuk pustaka sendiri gunakan `DynamicLibrary.open('libkalkulator.so')`.
- `lookupFunction<_StrlenC, _StrlenDart>('strlen')` mencari simbol bernama `strlen` dan mengembalikannya sebagai fungsi Dart; bila simbol tak ada, ia melempar saat dipanggil, jadi periksa nama dengan teliti.
- `using((arena) { ... })` (dari `package:ffi`) membuat `Arena` yang membebaskan semua alokasi di dalamnya ketika blok selesai, termasuk bila ada exception: pembersihan memori native yang aman tanpa `try/finally` manual.
- `s.toNativeUtf8(allocator: arena)` menyalin string ke memori native berakhiran NUL; `strlen` menghitung byte hingga NUL pertama, sehingga `'é'` bernilai 2. String yang memuat karakter NUL di tengah akan terpotong di sisi C.
- Bentuk `@Native` (tanpa `lookupFunction`) dibahas bersama build hooks di Contoh 5.

**Contoh 2 — callback Dart dari C dan memori native yang dikelola `Arena`: `qsort`.**

```dart
import 'dart:ffi';

import 'package:ffi/ffi.dart';

typedef _BandingC = Int Function(Pointer<Void>, Pointer<Void>); // int (*)(const void*, const void*)
typedef _QsortC = Void Function(Pointer<Void>, Size, Size, Pointer<NativeFunction<_BandingC>>);
typedef _QsortDart = void Function(Pointer<Void>, int, int, Pointer<NativeFunction<_BandingC>>);

int _bandingkan(Pointer<Void> a, Pointer<Void> b) {
  final x = a.cast<Int32>().value;
  final y = b.cast<Int32>().value;
  return x < y ? -1 : (x > y ? 1 : 0); // jangan x - y: meluap pada nilai ekstrem
}

List<int> urutkanDiC(List<int> data) {
  if (data.isEmpty) return const [];
  final qsort = DynamicLibrary.process().lookupFunction<_QsortC, _QsortDart>('qsort');

  return using((Arena arena) {
    final buf = arena<Int32>(data.length); // alokasi native untuk data.length elemen Int32
    buf.asTypedList(data.length).setAll(0, data);

    final cb = NativeCallable<_BandingC>.isolateLocal(_bandingkan, exceptionalReturn: 0);
    try {
      qsort(buf.cast(), data.length, sizeOf<Int32>(), cb.nativeFunction);
    } finally {
      cb.close(); // lepaskan callback
    }
    return buf.asTypedList(data.length).toList(); // SALIN keluar sebelum arena dibebaskan
  });
}
```

```dart
test('qsort native mengurutkan Int32 lewat callback Dart, termasuk nilai ekstrem', () {
  expect(
    urutkanDiC([5, -1, 3, 3, 0, 2147483647, -2147483648]),
    [-2147483648, -1, 0, 3, 3, 5, 2147483647],
  );
  expect(urutkanDiC([]), isEmpty);
});
```

- Tanda tangan `qsort` di C adalah `void qsort(void* base, size_t nmemb, size_t size, int (*compar)(const void*, const void*))`; `typedef` di atas menerjemahkannya ke tipe native (`Pointer<Void>`, `Size`, `Int`, pointer ke fungsi).
- `arena<Int32>(n)` mengalokasikan `n` elemen `Int32` native yang dibebaskan arena; `asTypedList(n)` membuat *tampilan* `Int32List` atas memori itu, dipakai untuk menyalin data masuk dan keluar.
- `NativeCallable<_BandingC>.isolateLocal(_bandingkan, exceptionalReturn: 0)` membungkus fungsi Dart menjadi pointer fungsi C; `isolateLocal` berarti dipanggil sinkron pada thread isolate yang sama (cocok untuk `qsort`, yang memanggilnya selama `qsort` berjalan); `exceptionalReturn` adalah nilai kembalian bila callback melempar exception.
- `cb.close()` di `finally` — callback adalah sumber daya; melepaskannya mencegah kebocoran dan mencegah isolate tertahan hidup.
- Pembanding memakai perbandingan, bukan pengurangan: `x - y` meluap pada pasangan seperti `2147483647` dan `-2147483648`, bug klasik yang dijaga tes nilai ekstrem.
- Data **disalin keluar** (`toList()`) *sebelum* arena dibebaskan; mengembalikan `asTypedList` langsung akan menghasilkan tampilan menggantung (use-after-free).
- Penjaga `if (data.isEmpty) return const [];` menghindari alokasi nol byte, yang perilakunya bergantung platform.

**Contoh 3 — pembungkus aman untuk memori native: `dispose` deterministik, finalizer sebagai cadangan.**

```dart
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

final class BufferNative implements Finalizable {
  BufferNative(int panjang)
      : _panjang = panjang,
        _ptr = malloc<Uint8>(panjang) {
    _penjaga.attach(this, _ptr.cast(), detach: this); // cadangan bila dispose terlupa
  }

  static final _penjaga = NativeFinalizer(malloc.nativeFree);

  final int _panjang;
  final Pointer<Uint8> _ptr;
  bool _bebas = false;

  /// Tampilan atas memori native; JANGAN disimpan melewati dispose().
  Uint8List get data {
    if (_bebas) throw StateError('BufferNative sudah dibebaskan');
    return _ptr.asTypedList(_panjang);
  }

  /// Salinan yang aman disimpan; tak terpengaruh dispose().
  Uint8List salin() => Uint8List.fromList(data);

  void dispose() {
    if (_bebas) return; // idempoten
    _bebas = true;
    _penjaga.detach(this); // finalizer tak perlu lagi
    malloc.free(_ptr);
  }
}
```

```dart
test('BufferNative: valid sebelum dispose, ditolak sesudahnya, dispose idempoten', () {
  final b = BufferNative(4);
  b.data.setAll(0, [1, 2, 3, 4]);
  final salinan = b.salin();
  expect(b.data, [1, 2, 3, 4]);

  b.dispose();
  expect(() => b.data, throwsStateError);
  expect(salinan, [1, 2, 3, 4]); // salinan tetap utuh
  b.dispose(); // aman dipanggil dua kali
});
```

- `implements Finalizable` menandai objek yang kelangsungannya bergantung pada sumber daya native, sehingga kompilator menjaga agar objek tak dikoleksi terlalu dini selama masih dipakai oleh kode yang membutuhkannya.
- `NativeFinalizer(malloc.nativeFree)` — pelepas bawaan: saat objek dikoleksi GC, fungsi C `free` dipanggil pada pointer yang dilampirkan; `attach(this, _ptr.cast(), detach: this)` mendaftarkannya dan `detach` memungkinkan pembatalan.
- Finalizer **bukan** jalur utama: kapan GC berjalan tak dapat diprediksi, sehingga sumber daya langka (berkas, soket, memori besar) harus dilepas dengan `dispose` eksplisit. Finalizer hanya jaring pengaman agar kebocoran tak permanen.
- `dispose` idempoten dan men-`detach` finalizer sebelum `free`, supaya tak terjadi pembebasan ganda (*double free*).
- Getter `data` menolak pemakaian setelah `dispose` dengan `StateError`; `salin()` memberi cara aman menyimpan isi. Pointer mentah tak pernah keluar dari kelas: API publik hanya `Uint8List`.

**Contoh 4 — binding otomatis dengan `ffigen`.**

```yaml
# ffigen.yaml
name: KalkulatorBindings
description: Binding untuk kalkulator.h
output: 'lib/src/kalkulator_bindings.dart'
headers:
  entry-points:
    - 'src/kalkulator.h'
  include-directives:
    - '**kalkulator.h'
```

```bash
dart pub add --dev ffigen
dart run ffigen --config ffigen.yaml
```

```dart
// Pemakaian binding yang dihasilkan (nama kelas mengikuti `name:` pada konfigurasi)
import 'dart:ffi';

import 'src/kalkulator_bindings.dart';

int tambahNative(int a, int b) {
  final lib = KalkulatorBindings(DynamicLibrary.open('libkalkulator.so'));
  return lib.tambah(a, b);
}
```

- `entry-points` menunjuk header yang dibaca; `include-directives` membatasi hanya deklarasi dari header itu yang dibuatkan binding (bukan seluruh header sistem yang ikut ter-include).
- `dart run ffigen` membaca header dan menghasilkan kelas dengan metode untuk tiap fungsi serta tipe struct dan enum; hasilnya berkas Dart yang di-commit atau dibangkitkan di CI.
- Binding bukan sihir: header, pustaka `.so`, dan berkas hasil generate harus tetap sinkron; hasilkan ulang setiap header berubah dan jangan edit berkas hasil generate dengan tangan.
- Versi `ffigen` yang lebih baru juga dapat menghasilkan binding berbasis `@Native` agar cocok dengan build hooks; baca dokumentasi `ffigen` untuk opsinya. `jnigen` bekerja serupa untuk Java dan Kotlin.

**Contoh 5 — build hooks dan `@Native`: paket yang membawa kode C-nya sendiri.**

```text
kalkulator_native/
├─ pubspec.yaml
├─ hook/build.dart               (dijalankan toolchain Dart saat build)
├─ src/kalkulator_native.h
├─ src/kalkulator_native.c
├─ lib/kalkulator_native.dart    (deklarasi @Native)
└─ test/kalkulator_native_test.dart
```

```bash
dart pub add hooks code_assets native_toolchain_c   # masuk dependencies, bukan dev_dependencies
```

```dart
// hook/build.dart  (pola dari dokumentasi hooks; periksa tanda tangan pada versi paketmu)
import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) return; // hook ini hanya menghasilkan aset kode
    final builder = CBuilder.library(
      name: 'kalkulator_native',
      assetName: 'kalkulator_native.dart', // identitas aset: package:kalkulator_native/kalkulator_native.dart
      sources: ['src/kalkulator_native.c'],
    );
    await builder.run(input: input, output: output);
  });
}
```

```c
// src/kalkulator_native.h
#include <stdint.h>
int32_t tambah(int32_t a, int32_t b);
```

```c
// src/kalkulator_native.c
#include "kalkulator_native.h"

int32_t tambah(int32_t a, int32_t b) {
  // Aritmetika unsigned: luapan terdefinisi (membungkus), bukan perilaku tak terdefinisi C.
  return (int32_t)((uint32_t)a + (uint32_t)b);
}
```

```dart
// lib/kalkulator_native.dart
import 'dart:ffi';

/// Aset diikat lewat identitas pustaka ini (package:kalkulator_native/kalkulator_native.dart).
@Native<Int32 Function(Int32, Int32)>()
external int tambah(int a, int b);
```

```dart
// test/kalkulator_native_test.dart
import 'package:kalkulator_native/kalkulator_native.dart';
import 'package:test/test.dart';

void main() {
  test('tambah native', () {
    expect(tambah(24, 18), 42);
    expect(tambah(2147483647, 1), -2147483648); // membungkus pada 32 bit
  });
}
```

```bash
dart test      # hook dijalankan otomatis: C dikompilasi, aset didaftarkan, lalu tes berjalan
```

- `hook/build.dart` adalah program Dart biasa yang dipanggil toolchain; `build(args, (input, output) async { ... })` memberi `input` (konfigurasi, nama paket) dan `output` (tempat mendaftarkan aset). Hook berjalan otomatis pada `dart run`, `dart build`, dan `dart test`; tak ada langkah manual.
- `CBuilder.library(name:, assetName:, sources:)` memakai kompiler C di mesin (gcc atau clang) untuk membangun pustaka dinamis dan mendaftarkannya sebagai *aset kode* dengan identitas `assetName`.
- `@Native<Int32 Function(Int32, Int32)>() external int tambah(int a, int b);` — deklarasi `external` yang diikat ke aset yang identitasnya sama dengan URI pustaka ini (asal `assetName` selaras). Tak ada `DynamicLibrary` dan `lookupFunction`; pemuatan dan pencarian simbol ditangani toolchain.
- Tipe di `@Native<...>` mengikuti C (`Int32`), sedangkan deklarasi Dart memakai `int`. Argumen `int` yang melebihi rentang tipe native dipotong tanpa peringatan; validasi rentang di tepi (Contoh 3, “batas kepercayaan”).
- C: penjumlahan `int32_t` bertanda yang meluap adalah perilaku tak terdefinisi; mengonversi ke `uint32_t` dulu membuat luapan terdefinisi (membungkus), sehingga hasil `tambah(2147483647, 1)` pasti `-2147483648`.
- Tambahan sejak Dart 3.13: *link hooks* (`hook/link.dart`) dan pencatatan pemakaian (`recordedUses`) untuk membuang aset yang tak terpakai (tree-shaking) pada build rilis. Hook berjalan di lingkungan semi-hermetik dan tak boleh memiliki dependensi melingkar antar-paket.

**Contoh 6 — Rust lewat ABI C.**

```toml
# kalkulator/Cargo.toml
[package]
name = "kalkulator"
version = "0.1.0"
edition = "2021"

[lib]
crate-type = ["cdylib"]   # pustaka dinamis berantarmuka C

[profile.release]
panic = "abort"           # panic tak boleh melintasi batas FFI
```

```rust
// kalkulator/src/lib.rs
#[no_mangle]
pub extern "C" fn tambah(a: i32, b: i32) -> i32 {
    a.wrapping_add(b)
}
```

```bash
cargo build --release        # menghasilkan target/release/libkalkulator.so (Linux)
```

```dart
import 'dart:ffi';
import 'dart:io';

String _namaPustaka() => switch (Platform.operatingSystem) {
      'linux' || 'android' => 'libkalkulator.so',
      'macos' || 'ios' => 'libkalkulator.dylib',
      'windows' => 'kalkulator.dll',
      _ => throw UnsupportedError('platform tak didukung: ${Platform.operatingSystem}'),
    };

typedef _TambahC = Int32 Function(Int32, Int32);
typedef _TambahDart = int Function(int, int);

final _tambah = DynamicLibrary.open('target/release/${_namaPustaka()}')
    .lookupFunction<_TambahC, _TambahDart>('tambah');

int tambahRust(int a, int b) => _tambah(a, b);
```

- `crate-type = ["cdylib"]` membangun pustaka dinamis yang mengekspos simbol berantarmuka C; `#[no_mangle]` mempertahankan nama simbol `tambah` agar dapat dicari; `extern "C"` memakai konvensi pemanggilan C. (Pada Rust edisi 2024 atributnya ditulis `#[unsafe(no_mangle)]`.)
- `a.wrapping_add(b)` menetapkan perilaku luapan secara eksplisit; Rust sendiri akan panic pada luapan di mode debug, dan *panic yang melintasi batas FFI adalah perilaku tak terdefinisi*. Karena itu `panic = "abort"` di profil rilis, atau bungkus fungsi ekspor dengan `std::panic::catch_unwind` dan kembalikan kode galat.
- `switch` ekspresi memilih nama berkas pustaka menurut platform; `UnsupportedError` untuk platform yang belum didukung lebih baik daripada gagal membingungkan saat `open`.
- Untuk paket yang dibagikan, jalur `target/release/...` ganti dengan aset yang dibundel lewat build hooks (Contoh 5); memuat berdasarkan jalur relatif hanya cocok untuk percobaan lokal.
- Pola sehat untuk API yang lebih kaya: sisi native mengembalikan kode galat (bukan exception), memiliki fungsi `alokasi`/`bebaskan` berpasangan untuk apa pun yang dikembalikan, dan sisi Dart membungkusnya seperti `BufferNative` (Contoh 3).

**Contoh 7 — interop JavaScript untuk web.**

```dart
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

@JS('console.log')
external void _konsolLog(JSAny? pesan);

void main() {
  // Dart memanggil DOM dan JS (bertipe)
  web.document.querySelector('#hasil')?.textContent = 'halo dari Dart';
  _konsolLog('Dart ke JS'.toJS);

  // Dart mengekspos fungsi ke JS
  globalContext.setProperty(
    'dartGandakan'.toJS,
    ((JSNumber n) => (n.toDartInt * 2).toJS).toJS,
  );
}
```

- `@JS('console.log') external void _konsolLog(JSAny? pesan);` — deklarasi statis atas fungsi JavaScript; `external` berarti badannya disediakan JavaScript; parameternya bertipe JS (`JSAny?`), bukan tipe Dart.
- `web.document.querySelector(...)?.textContent = ...` — `package:web` menyediakan tipe DOM yang bertipe dan mengikuti spesifikasi web; null-aware karena elemen mungkin tak ada.
- `'...'.toJS` dan `(...).toJS` — konversi *eksplisit* dari nilai Dart ke tipe JS; arah sebaliknya `.toDart` atau `.toDartInt`. Konversi yang eksplisit membuat biaya dan batas terlihat.
- `globalContext.setProperty('dartGandakan'.toJS, fungsi.toJS)` (dari `dart:js_interop_unsafe`) memasang fungsi Dart sebagai properti global JavaScript sehingga skrip lain dapat memanggil `dartGandakan(21)`; fungsi yang diekspor harus memakai tipe JS pada parameter dan kembaliannya.
- Kode ini hanya dapat dikompilasi untuk web (JS atau Wasm); jangan mengimpornya dari domain (Contoh 9 menaruhnya di adapter tepi).

**Contoh 8 — perbedaan semantik antar target, dijadikan tes.**

```dart
import 'dart:math' as math;

import 'package:test/test.dart';

void main() {
  test('2^53 + 1 berbeda dari 2^53 pada target native', () {
    final dua53 = math.pow(2, 53).toInt(); // dihitung saat runtime
    expect(dua53 + 1 == dua53, isFalse);
  }, testOn: 'vm');

  test('2^53 + 1 sama dengan 2^53 pada target web (JS)', () {
    final dua53 = math.pow(2, 53).toInt();
    expect(dua53 + 1 == dua53, isTrue); // presisi bulat aman hanya 53 bit
  }, testOn: 'js');

  test('operator bitwise memakai 64 bit pada native', () {
    final dua32 = int.parse('4294967296'); // 2^32, dibaca saat runtime
    expect(dua32 | 0, 4294967296);
  }, testOn: 'vm');

  test('operator bitwise memotong ke 32 bit pada web (JS)', () {
    final dua32 = int.parse('4294967296');
    expect(dua32 | 0, 0); // operand dipotong ke 32 bit
  }, testOn: 'js');
}
```

```bash
dart test -p vm,chrome      # jalankan di native dan di Chrome; tiap tes memilih targetnya lewat testOn
```

- `testOn: 'vm'` dan `testOn: 'js'` memilih platform tempat sebuah tes berjalan; pasangan tes ini *mendokumentasikan* perbedaan sebagai fakta yang dijaga CI, bukan kejutan produksi.
- Nilai dihitung atau dibaca saat runtime (`math.pow`, `int.parse`) supaya bukan konstanta waktu kompilasi; di web, literal bulat di luar rentang yang dapat direpresentasikan bahkan ditolak kompiler.
- Aturan untuk logika lintas-platform: hindari operasi bitwise dan geser di atas 32 bit, jangan berasumsi bahwa penjumlahan di atas 2^53 eksak, dan gunakan `BigInt` atau `Int64` dari `package:fixnum` bila 64 bit ketat dibutuhkan. Jalankan semua tes domain pada setiap target yang dituju.
- Untuk Wasm, jalankan juga tes pada kompiler Wasm (lihat `dart test --help` untuk opsi kompiler); jangan menganggap perilakunya sama dengan JS.

**Contoh 9 — import bersyarat dan adapter platform di tepi.**

```dart
// lib/src/penyimpanan_stub.dart: dipakai bila tak ada platform yang dikenali
import 'penyimpan.dart';

Penyimpan buatPenyimpan() => throw UnsupportedError('platform tak didukung');
```

```dart
// lib/src/penyimpanan_io.dart: VM dan AOT
import 'penyimpan.dart';
import 'penyimpan_berkas.dart';

Penyimpan buatPenyimpan() => PenyimpanBerkas('todo.json');
```

```dart
// lib/src/penyimpanan_web.dart: JS dan Wasm
import 'package:web/web.dart' as web;

import 'penyimpan.dart';

class PenyimpananWeb implements Penyimpan {
  static const _kunci = 'todo.json';

  @override
  Future<String?> baca() async => web.window.localStorage.getItem(_kunci);

  @override
  Future<void> tulis(String isi) async => web.window.localStorage.setItem(_kunci, isi);

  @override
  Future<void> cadangkan(String isi) async =>
      web.window.localStorage.setItem('$_kunci.rusak', isi);
}

Penyimpan buatPenyimpan() => PenyimpananWeb();
```

```dart
// lib/penyimpanan.dart: satu-satunya pintu; domain hanya melihat buatPenyimpan()
export 'src/penyimpanan_stub.dart'
    if (dart.library.io) 'src/penyimpanan_io.dart'
    if (dart.library.js_interop) 'src/penyimpanan_web.dart';
```

```dart
test('di VM, buatPenyimpan menghasilkan PenyimpanBerkas', () {
  expect(buatPenyimpan(), isA<PenyimpanBerkas>());
}, testOn: 'vm');
```

- Tiga berkas implementasi menyediakan fungsi `buatPenyimpan()` yang *bentuknya identik*; berkas ekspor memilih satu pada waktu kompilasi menurut pustaka yang tersedia: `dart.library.io` ada di VM dan AOT, `dart.library.js_interop` ada di JS dan Wasm.
- Urutan syarat penting: yang pertama cocok menang; stub adalah bawaan bila tak ada yang cocok.
- Antarmuka `Penyimpan` (port) netral platform; hanya adapter yang mengimpor `dart:io` atau `package:web`. Domain dan aplikasi tak pernah mengimpor berkas platform itu (diperiksa skrip aturan dependensi, 9.1).
- `localStorage` hanya contoh penyimpanan web yang sederhana (sinkron, terbatas ukuran); adapter nyata dapat memakai IndexedDB. Karena port asinkron, penggantian itu tak mengubah kode di atasnya.
- Tes kontrak (8.3) dijalankan pada setiap adapter di platformnya masing-masing, sehingga perilaku antar-platform tetap setara.

**Contoh 10 — alternatif tanpa FFI: proses terpisah dengan protokol JSON Lines.**

```dart
import 'dart:convert';
import 'dart:io';

Future<int> jumlahKuadratDiProsesLain(String exe, List<int> data) async {
  final p = await Process.start(exe, const []);
  try {
    final keluar = p.stdout.transform(utf8.decoder).join();
    final galat = p.stderr.transform(utf8.decoder).join(); // konsumsi stderr juga (8.3)

    p.stdin.writeln(jsonEncode({'versi': 1, 'op': 'jumlah_kuadrat', 'data': data}));
    await p.stdin.close();

    final kode = await p.exitCode.timeout(const Duration(seconds: 10));
    if (kode != 0) throw StateError('pekerja gagal (kode $kode): ${await galat}');

    if (jsonDecode(await keluar) case {'hasil': final int hasil}) return hasil;
    throw const FormatException('balasan pekerja tidak dikenali');
  } finally {
    p.kill(); // tak ada proses yatim bila timeout atau galat
  }
}
```

- Protokolnya sederhana dan dapat dites: satu baris JSON berisi `versi`, `op`, dan `data` ke stdin; satu JSON balasan di stdout; kode keluar menyatakan sukses atau gagal; stderr untuk diagnosis.
- Bidang `versi` menyiapkan evolusi protokol tanpa mematahkan pekerja lama; balasan diperiksa bentuknya dengan pola dan salah bentuk menjadi `FormatException` (3.5).
- Kelebihan terhadap FFI: crash pekerja tak mematikan aplikasi, pekerja dapat ditulis dalam bahasa apa pun, dan hak aksesnya dapat dibatasi terpisah (Fase Keamanan). Kekurangan: latensi pemulaan proses, serialisasi, dan siklus hidup proses yang harus dikelola (timeout, `kill`, konsumsi stdout dan stderr).
- Untuk lalu lintas besar atau dua arah, pakai socket atau protobuf/gRPC dengan skema yang diversi; untuk batch jarang, stdio seperti ini sudah cukup.

### D. Opsi Kode Lain untuk Logika yang Sama

| Kebutuhan | Pilihan | Kapan cocok | Catatan |
| --- | --- | --- | --- |
| Memanggil kode native | FFI + build hooks + `@Native` (dipilih untuk paket baru) | Paket yang membawa kode native sendiri | Build otomatis; aset ikut paket |
| Memanggil kode native | FFI manual (`DynamicLibrary` + `lookupFunction`) | Pustaka sistem yang sudah ada (libc, libsqlite) | Jalur pustaka dan nama simbol ditangani sendiri |
| Memanggil kode native | `ffigen` | Banyak fungsi dan struct di header | Hasilkan ulang saat header berubah |
| Memanggil Java atau Kotlin | `jnigen` | Android dan JVM | Binding otomatis |
| Web | `dart:js_interop` + `package:web` | Berbicara dengan JS dan DOM | Bertipe; konversi eksplisit |
| Bahasa lain tanpa FFI | Proses terpisah (stdio atau socket) | Isolasi crash dan hak akses, bahasa bebas | Latensi dan siklus hidup proses |
| Bahasa lain tanpa FFI | Protobuf atau gRPC | Skema yang diversi, banyak klien | Alat tambahan |
| Memori native | `Arena` / `using` | Alokasi berumur satu blok | Deterministik dan paling sederhana |
| Memori native | Kelas pembungkus + `dispose` | Sumber daya berumur panjang | Tambahkan `NativeFinalizer` sebagai jaring pengaman |
| Memori native | `calloc` / `free` manual | Hindari kecuali terpaksa | Mudah bocor atau bebas ganda |
| Beda platform | Import bersyarat (Contoh 9) | Banyak titik yang bergantung platform | Bentuk fungsi di semua berkas harus identik |
| Beda platform | Satu composition root per target | Dua target (VM dan web) | Tanpa import bersyarat; eksplisit |

Alternatif tanpa import bersyarat: tiap target punya *composition root* sendiri yang memilih adapter.

```dart
// bin/todo.dart   (entri VM)
Future<void> main(List<String> args) =>
    jalankanAplikasi(penyimpan: PenyimpanBerkas('todo.json'), args: args);

// web/main.dart   (entri web)
Future<void> main() =>
    jalankanAplikasi(penyimpan: PenyimpananWeb(), args: const []);
```

- `jalankanAplikasi` berada di paket aplikasi dan hanya mengenal port `Penyimpan`; setiap entri target merakit adapter yang sesuai.
- Tak ada `if (dart.library...)` sama sekali: pemilihan platform sepenuhnya eksplisit di dua berkas kecil. Pilih ini bila hanya dua atau tiga target; pilih import bersyarat bila titik yang berbeda platform banyak dan tersebar.

### E. Terminologi Esensial

- **FFI (*foreign function interface*)** — mekanisme memanggil fungsi bahasa lain (umumnya C) dari Dart. **ABI** — kesepakatan biner tentang cara fungsi dipanggil dan data disusun; ABI C adalah “bahasa umum” antar-bahasa. **Binding** — kode perekat yang memetakan fungsi dan tipe native ke tipe Dart.
- **`@Native`** — anotasi pada deklarasi `external` yang mengikat fungsi Dart ke simbol native lewat aset. **`lookupFunction`** — mencari simbol di `DynamicLibrary` saat runtime. **`DynamicLibrary`** — pustaka dinamis yang dimuat proses.
- **`Arena` / `using`** — pengelola alokasi native yang membebaskan semuanya saat blok selesai. **`Finalizer` / `NativeFinalizer`** — callback yang dijalankan saat objek dikoleksi GC; tidak deterministik. **`Finalizable`** — penanda objek yang bergantung pada sumber daya native.
- **`NativeCallable`** — pembungkus fungsi Dart menjadi pointer fungsi C. **`isolateLocal` / `listener`** — callback sinkron pada thread isolate yang sama / dari thread mana pun, asinkron.
- **Build hook** — program Dart (`hook/build.dart`) yang dijalankan toolchain untuk membangun atau membundel aset native. **Code asset** — pustaka native yang didaftarkan hook. **Link hook** — hook yang menyaring aset saat tahap tautan (tree-shaking).
- **Interop JS** — jembatan bertipe antara Dart dan JavaScript. **Wasm** — format biner portabel yang dijalankan browser. **Import bersyarat** — `export ... if (dart.library.io)` yang memilih berkas menurut kemampuan platform.
- **Use-after-free / double free / buffer overflow** — pemakaian memori setelah dibebaskan / pembebasan dua kali / menulis di luar batas buffer. **Batas kepercayaan** — garis tempat data dari luar harus divalidasi.

### F. Visualisasi (ASCII)

```text
Dart (aman, GC)  ──FFI──►  [ batas kepercayaan ]  ──► C / Rust (memori manual, ABI C)
                                    ▲
              validasi + Arena / dispose / Finalizer + uji di sisi native

Satu kode, banyak target:   VM  |  AOT  |  JS  |  Wasm
                            uji di tiap target yang dituju (int, bitwise, I/O berbeda)
```

```text
alokasi (malloc / arena) ─► pakai (tampilan asTypedList) ─► SALIN keluar ─► bebaskan (arena atau dispose)
                                                                            │
               pakai tampilan SESUDAH bebas = use-after-free ◄──────────────┘ (dilarang)
               finalizer = jaring pengaman saat dispose terlupa (tidak deterministik)
```

```text
dart run / dart test / dart build
   └─► hook/build.dart ─► CBuilder (gcc atau clang) ─► CodeAsset (id = package:x/x.dart)
                                                          └─► @Native external int tambah(...) ─► panggilan native
```

```text
   int di native : 64 bit bertanda          int di web : angka JS (presisi bulat 53 bit)
   bitwise 64 bit                            bitwise dan geser: operand dipotong 32 bit
   ► logika angka lintas-platform diuji di setiap target; pakai BigInt atau Int64 bila perlu
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 9.1 (adapter di tepi, composition root, skrip aturan dependensi), 9.2 (timeout, breaker, dan retry untuk pekerja eksternal), 8.1 dan 8.3 (fuzz di batas, tes kontrak, tes proses), 6.2 (mengukur sebelum memilih FFI), 7.5 (isolate, `SendPort`), serta 3.5 (parse di tepi).
- **Prasyarat bagi:** 9.4 (adapter dan batas di workspace To-Do v8) dan proyek akhir kurikulum.
- **Dikembangkan di:** Fase Keamanan (batas kepercayaan FFI, keamanan memori, sandbox dan hak akses proses, rantai pasok kode native).

### H. Tips & Praktik Terbaik

- Ukur sebelum memilih FFI (6.2); catat keputusan “FFI atau Dart murni” dengan angka pengukuran, bukan perasaan.
- Pegang aturan kepemilikan: yang mengalokasikan, membebaskan; tulis di komentar siapa pemilik tiap pointer.
- Pakai `Arena` untuk alokasi berumur pendek, kelas pembungkus dengan `dispose` untuk yang berumur panjang, dan finalizer hanya sebagai jaring pengaman.
- Jangan menyimpan `asTypedList` melewati pembebasan; salin keluar. Jangan bocorkan `Pointer` ke API publik.
- Perlakukan semua yang kembali dari native sebagai tak tepercaya: periksa panjang, rentang, dan kode galat.
- Pastikan panic atau exception di sisi native tak melintasi batas FFI (Rust: `panic = "abort"` atau `catch_unwind`; C++: tangkap semua exception).
- Uji sisi native sendiri dengan harness C dan ASan atau valgrind; uji sisi Dart dengan tes `dispose` dan penghitung alokasi. Jangan menjalankan valgrind pada VM Dart utuh dan berharap hasil yang jernih.
- Jalankan tes domain di semua target (`dart test -p vm,chrome`) dan jadikan perbedaan semantik tes yang dinamai.
- Taruh semua kode yang bergantung platform di adapter tepi; domain tak pernah mengimpor `dart:ffi`, `dart:io`, atau `package:web`.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| `IntPtr` untuk `size_t` atau `int` C yang salah ukuran | Nilai rusak pada platform tertentu | Pakai `Size`, `Int`, `Long` sesuai tanda tangan C |
| Memori native tak dibebaskan | Kebocoran yang tak terlihat GC | `Arena`, `dispose`, dan `NativeFinalizer` |
| Menyimpan `asTypedList` setelah `free` | *Use-after-free* | Salin keluar sebelum membebaskan |
| `dispose` dua kali | *Double free* | `dispose` idempoten dan `detach` finalizer |
| Callback tak di-`close` | Isolate tertahan hidup; kebocoran | `try/finally` dengan `close()` |
| Panic atau exception native melintasi FFI | Perilaku tak terdefinisi, proses mati | `panic = "abort"`, `catch_unwind`, kode galat |
| `x - y` pada pembanding | Luapan pada nilai ekstrem | Bandingkan, jangan kurangkan |
| Mengasumsikan `int` sama di semua target | Bug khusus web | Tes per target; `BigInt` atau `Int64` |
| Bitwise 64 bit pada kode lintas-platform | Hasil salah di web | Hindari di atas 32 bit |
| Import bersyarat tersebar | Logika platform bocor ke domain | Kumpulkan di adapter tepi; atau composition root per target |
| Jalur pustaka native relatif dan tetap | Gagal di mesin lain | Bundel aset lewat build hooks |
| Protokol proses tanpa versi dan tanpa timeout | Macet atau rusak saat berubah | Bidang `versi`, `timeout`, `kill`, konsumsi stdout dan stderr |

### J. Sumber Referensi

- Interop: https://dart.dev/interop · C interop: https://dart.dev/interop/c-interop · JS interop: https://dart.dev/interop/js-interop · Dart dan Wasm: https://dart.dev/web/wasm · `dart:ffi`: https://api.dart.dev/dart-ffi/dart-ffi-library.html
- ✔ Build hooks: https://dart.dev/tools/hooks · ✔ Angka di Dart (web dan native): https://dart.dev/resources/language/number-representation · Repositori hooks dan native: https://github.com/dart-lang/native
- Paket: `ffi` https://pub.dev/packages/ffi · `ffigen` https://pub.dev/packages/ffigen · `jnigen` https://pub.dev/packages/jnigen · `hooks` https://pub.dev/packages/hooks · `code_assets` https://pub.dev/packages/code\_assets · `native_toolchain_c` https://pub.dev/packages/native\_toolchain\_c · `web` https://pub.dev/packages/web · `fixnum` https://pub.dev/packages/fixnum
- Import bersyarat: https://dart.dev/language/libraries
- Rust: https://doc.rust-lang.org/nomicon/ffi.html · https://doc.rust-lang.org/std/panic/fn.catch\_unwind.html
- Alat memori native: https://valgrind.org/ · https://github.com/google/sanitizers/wiki/AddressSanitizer

---

## 9.4 Studi Kasus Terpadu: To-Do v8, Arsitektur Heksagonal yang Tangguh (TAMBAHAN)

*Motivasi: arsitektur baru terasa nyata saat kamu memindahkan kode yang sudah jalan tanpa merusaknya.*

> **Mengapa ditambahkan.** Fase 9 paling jelas bila diterapkan pada kode yang sudah kamu kenal. To-Do v8 **tidak menambah fitur**: ia memecah To-Do v7 menjadi workspace empat paket, mengubah `Penyimpan` menjadi port yang dimiliki domain, memindahkan retry, timeout, dan circuit breaker dari koordinator menjadi *decorator* di batas adapter, lalu menjaga semuanya dengan skrip aturan dependensi, tes kontrak (8.3), dan uji *fault injection*. Memecah paket juga membongkar kebocoran yang tak terlihat selama semua kode ada dalam satu berkas: `dart:io` ternyata merembes ke inti lewat `transienIo` dan `FileSystemException`.

**Struktur pembelajaran (mini daftar isi):** (1) keputusan: apa pindah ke mana · (2) struktur workspace dan pubspec · (3) port dan galat domain tanpa `dart:io` · (4) decorator ketahanan di infrastruktur · (5) composition root · (6) tes: aturan dependensi, kontrak, ketahanan · (7) catatan keputusan arsitektur (ADR) · (8) definisi “selesai”.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Langkah & kode · D Variasi · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Kamu mengubah proyek `logika_fase8` (To-Do v7) menjadi workspace `todo_workspace` dengan empat paket: `todo_ketahanan` (utilitas ketahanan generik), `todo_inti` (domain, aplikasi, dan port), `todo_infra` (adapter: berkas, log, dan decorator ketahanan), dan `todo_cli` (shell dan *composition root*). Perilaku yang terlihat pengguna tidak berubah; semua tes 7.8 dan 8.x tetap lulus setelah penyesuaian tanda tangan yang tercatat di bawah. Yang berubah adalah **letak tanggung jawab** dan **bukti** bahwa panah ketergantungan menuju ke dalam.

### B. Konsep Kunci & Filosofi Mendalam

- **Pemisahan paket adalah alat deteksi.** Selama semua kode berada dalam satu paket, kebocoran (`dart:io` di domain) tak terlihat. Begitu dipisah dan aturannya dicek mesin, kebocoran muncul sebagai kesalahan kompilasi atau pelanggaran aturan, dan harus diperbaiki di desain, bukan ditambal.
- **Port memiliki bahasa kegagalannya sendiri.** Domain tak boleh tahu `FileSystemException`. Port `Penyimpan` menyatakan kegagalannya dengan `GagalSimpan` yang membawa `transien` (layak dicoba lagi). Adapter yang tahu cara menerjemahkan galat teknis menjadi `transien` benar atau salah; lapisan ketahanan hanya membaca bendera itu.
- **Ketahanan adalah kebijakan di batas, bukan logika bisnis.** `AplikasiTodo` hanya berkata “tulis snapshot ini”; mau diulang berapa kali, dengan timeout berapa lama, dan kapan berhenti memanggil adalah urusan adapter yang dirakit di composition root. Decorator `PenyimpanTangguh` membungkus *adapter apa pun* tanpa mengubahnya.
- **Idempotensi membuat retry aman di sini.** Setiap `tulis` membawa snapshot penuh, sehingga mengulangnya aman (7.8).
- **Batas yang jujur: penulisan zombie.** Karena timeout tidak membatalkan pekerjaan, penulisan lambat yang tertinggal dapat mendarat belakangan; bila di antaranya sudah ada penulisan yang lebih baru, snapshot lama dapat menimpanya. `PenyimpanBerkas` melindungi diri dengan pagar generasi (7.8), tetapi decorator tak dapat melakukannya untuk adapter lain karena pagar harus di *sisi penyimpan*. Solusi umum: menambahkan nomor versi ke kontrak port (*compare-and-set*), diberikan sebagai latihan.
- **Satu composition root.** Hanya `todo_cli/bin/todo.dart` yang mengenal semua implementasi dan merakit rantai: `PenyimpanBerkas` → `PenyimpanTangguh` → `AplikasiTodo`.
- **Keputusan dicatat.** Alasan sebuah keputusan arsitektur hilang lebih cepat daripada kodenya. Catatan keputusan singkat (ADR) menyimpan konteks, keputusan, konsekuensi, dan alternatif yang ditolak.
- **Dampak desain.** Domain yang masih mengimpor `dart:io`: tak bisa diuji murni dan terkunci pada platform. Retry di koordinator: setiap adapter baru mengulang kerja yang sama. Decorator yang menelan galat domain: menyembunyikan penolakan aturan bisnis. Pagar yang hanya di satu adapter: adapter lain tetap rentan terhadap penulisan zombie.

### C. Langkah, Sintaks, dan Kode

**Langkah 1 — keputusan: apa pindah ke mana.**

| Komponen v7 | Pindah ke | Alasan |
| --- | --- | --- |
| `Item`, `Judul`, `Perintah`, `Urai*`, `Riwayat`, `jalankan`, `kodekan`, `dekode`, `tanpaDuplikat` | `todo_inti` (domain) | Murni, tanpa I/O |
| `Penyimpan` (port), hierarki `GagalSimpan` | `todo_inti` | Port dimiliki domain; galat dikenal domain |
| `AplikasiTodo`, `Antrean` dipakai di sini, `bersihkan` di isolate | `todo_inti` (aplikasi) | Use case; `dart:isolate` bukan I/O |
| `Antrean`, `denganRetry`, `CircuitBreaker` | `todo_ketahanan` | Generik, tanpa I/O, dapat dites dengan waktu virtual |
| `PenyimpanBerkas`, `transienIo`, `pencatatLogging`, `pasangLogTerstruktur` | `todo_infra` | Menyentuh `dart:io` dan paket log |
| `PenyimpanTangguh` | `todo_infra` | Decorator ketahanan di batas adapter |
| `PenyimpanMemori` | `todo_inti/lib/testing.dart` | Fake yang dibagikan untuk tes konsumen |
| Shell, `KodeKeluar`, `untukPengguna`, `main` | `todo_cli` | Presentasi dan composition root |

Perubahan tanda tangan yang perlu diikuti di tes lama: (1) `GagalBaca(jalur, penyebab)` dan `GagalTulis(jalur, penyebab)` menjadi `GagalTulis(sumber, penyebab: ..., transien: ...)` (parameter bernama); (2) `AplikasiTodo.muat` tak lagi menerima `tidur` dan `batasTulis`; (3) retry dan timeout tak ada lagi di `AplikasiTodo`, tes retry dan timeout dari 7.8 berpindah ke tes `PenyimpanTangguh`.

**Langkah 2 — struktur workspace dan pubspec.**

```text
todo_workspace/
├─ pubspec.yaml                  (akar: workspace)
├─ tool/cek_arsitektur.dart      (dari 9.1, dengan aturan baru)
├─ justfile
└─ packages/
   ├─ ketahanan/  (todo_ketahanan: clock)
   ├─ inti/       (todo_inti: meta, todo_ketahanan)
   ├─ infra/      (todo_infra: todo_inti, todo_ketahanan, logging)
   └─ cli/        (todo_cli: todo_inti, todo_infra, todo_ketahanan)
```

```yaml
# todo_workspace/pubspec.yaml
name: todo_workspace
publish_to: none
environment:
  sdk: ^3.14.0
workspace:
  - packages/ketahanan
  - packages/inti
  - packages/infra
  - packages/cli
dev_dependencies:
  yaml: any
```

```yaml
# packages/inti/pubspec.yaml  (anggota lain serupa; hanya dependensinya berbeda)
name: todo_inti
resolution: workspace
environment:
  sdk: ^3.14.0
dependencies:
  todo_ketahanan: any   # paket saudara: di-resolve dari workspace
```

```bash
dart pub get
dart pub workspace list
dart pub -C packages/ketahanan add clock
dart pub -C packages/ketahanan add --dev fake_async test
dart pub -C packages/inti add meta
dart pub -C packages/inti add --dev test kiri_check fake_async
dart pub -C packages/infra add meta logging
dart pub -C packages/infra add --dev test fake_async
```

- Akar hanya mendaftar anggota dan memuat alat bersama (`yaml` untuk skrip aturan); tiap anggota wajib `resolution: workspace`.
- Ketergantungan antar-anggota ditulis dengan nama dan `any`; pub meng-resolve dari workspace. Ketergantungan ke pub.dev ditambahkan dengan `dart pub -C <paket> add` agar hanya paket yang bersangkutan yang berubah.
- Dengan daftar dependensi di atas, `todo_inti` *secara struktural* tak dapat mengimpor `todo_infra` atau `todo_cli`: keduanya tak ada di `pubspec.yaml`-nya. Larangan `dart:io` tetap harus diperiksa skrip (Langkah 6), karena `dart:io` adalah SDK dan selalu tersedia.

**Langkah 3 — port dan galat domain tanpa `dart:io`; koordinator yang lebih sederhana.**

```dart
// packages/inti/lib/src/penyimpan.dart
abstract interface class Penyimpan {
  Future<String?> baca();
  Future<void> tulis(String isi);
  Future<void> cadangkan(String isi);
}

/// Kegagalan penyimpanan dalam bahasa DOMAIN. Adapter menerjemahkan galat teknisnya ke sini.
sealed class GagalSimpan implements Exception {
  const GagalSimpan(this.sumber, {this.penyebab, this.transien = false});

  final String sumber; // jalur, URL, atau nama sumber (bukan tipe teknis)
  final Object? penyebab; // galat asli, untuk log dan klasifikasi pesan
  final bool transien; // dinilai ADAPTER: layak dicoba lagi?

  @override
  String toString() => '$runtimeType($sumber, transien: $transien, penyebab: $penyebab)';
}

final class GagalBaca extends GagalSimpan {
  const GagalBaca(super.sumber, {super.penyebab, super.transien});
}

final class GagalTulis extends GagalSimpan {
  const GagalTulis(super.sumber, {super.penyebab, super.transien});
}
```

```dart
// packages/inti/lib/src/aplikasi_todo.dart  (hanya bagian yang berubah dari 7.8)
import 'dart:async';

import 'package:todo_ketahanan/todo_ketahanan.dart';

void _diam(Tingkat t, String pesan, {Object? galat, StackTrace? jejak}) {}

class AplikasiTodo {
  // ... konstruktor privat, field, daftar, proses, tutup, _hitung: sama seperti 7.8 ...

  static Future<HasilMuat> muat(
    Penyimpan penyimpan, {
    int batas = 50,
    int ambangIsolate = 20000,
    Pencatat catat = _diam, // bawaan membungkam; composition root menyuntikkan yang nyata
  }) async {
    // ... isi sama seperti 7.8 (baca, dekode, cadangkan data rusak) ...
  }

  Future<List<String>> _prosesSerial(Perintah perintah) async {
    final (baru, keluaran) = await _hitung(_riwayat, perintah);
    if (identical(baru, _riwayat)) return keluaran; // tak ada perubahan: tak menulis

    try {
      // Retry, timeout, dan circuit breaker adalah urusan ADAPTER, bukan koordinator.
      await _penyimpan.tulis(kodekan(baru.kini));
    } on GagalSimpan catch (e, s) {
      _catat(Tingkat.galat, 'gagal menyimpan', galat: e, jejak: s);
      return [
        switch (e.penyebab) {
          TimeoutException() => 'penyimpanan terlalu lama; perubahan dibatalkan',
          SirkuitTerbuka() => 'penyimpanan sedang dilindungi; coba lagi nanti; perubahan dibatalkan',
          _ => 'gagal menyimpan; perubahan dibatalkan',
        },
      ];
    }
    _riwayat = baru; // komit di memori HANYA setelah penyimpanan berhasil
    return keluaran;
  }
}
```

- `GagalSimpan` kini `sealed` dengan dua subtipe; `transien` adalah **penilaian adapter** yang tahu arti galat teknisnya (kunci berkas, koneksi putus). Domain dan lapisan ketahanan hanya membaca bendera itu dan tak pernah melihat `FileSystemException`.
- `penyebab` tetap disimpan untuk log dan untuk memilih pesan pengguna, tetapi bertipe `Object?`: domain tak bergantung pada tipe teknis tertentu. Dua pengecualian disengaja: `TimeoutException` (milik `dart:async`, bukan I/O) dan `SirkuitTerbuka` (milik `todo_ketahanan`, yang boleh dipakai inti).
- Default `catat = _diam` menggantikan `pencatatStderr` dari 7.8: pencatat yang menulis ke `stderr` memakai `dart:io`, jadi *kebocoran kedua* yang terbongkar oleh pemisahan paket. Inti kini hanya menerima fungsi pencatat; yang nyata disuntikkan dari luar.
- `_prosesSerial` menyusut: tak ada `ulangiAsinkron`, `.timeout`, `bisaDiulang`, atau `tidur`; ia hanya menerjemahkan `GagalSimpan` menjadi pesan. Pesan untuk timeout tetap sama dengan 7.8, sehingga tes perilaku lama tetap berlaku.
- Pola `switch (e.penyebab) { TimeoutException() => ..., SirkuitTerbuka() => ..., _ => ... }` memeriksa tipe penyebab tanpa `is` berantai.

**Langkah 4 — decorator ketahanan di infrastruktur.**

```dart
// packages/infra/lib/src/penyimpan_tangguh.dart
import 'dart:async';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:todo_inti/todo_inti.dart';
import 'package:todo_ketahanan/todo_ketahanan.dart';

/// Membungkus Penyimpan APA PUN dengan retry, timeout per percobaan, dan circuit breaker.
/// Aman diulang karena setiap tulis() membawa snapshot penuh (idempoten, 7.8).
final class PenyimpanTangguh implements Penyimpan {
  PenyimpanTangguh(
    this._dalam, {
    required this.breaker,
    this.timeout = const Duration(seconds: 2),
    this.maksPercobaan = 4,
    Random? acak,
    Logger? log,
  })  : _acak = acak,
        _log = log ?? Logger('todo.penyimpanan');

  final Penyimpan _dalam;
  final CircuitBreaker breaker;
  final Duration timeout;
  final int maksPercobaan;
  final Random? _acak;
  final Logger _log;

  @override
  Future<String?> baca() => _lindungi(
        'baca',
        _dalam.baca,
        (e) => GagalBaca('penyimpanan', penyebab: e, transien: true),
      );

  @override
  Future<void> tulis(String isi) => _lindungi(
        'tulis',
        () => _dalam.tulis(isi),
        (e) => GagalTulis('penyimpanan', penyebab: e, transien: true),
      );

  @override
  Future<void> cadangkan(String isi) => _lindungi(
        'cadangkan',
        () => _dalam.cadangkan(isi),
        (e) => GagalTulis('penyimpanan', penyebab: e, transien: true),
      );

  Future<T> _lindungi<T>(
    String operasi,
    Future<T> Function() kerja,
    GagalSimpan Function(Object galat) bungkus,
  ) async {
    try {
      return await breaker.jalankan(
        () => denganRetry(
          kerja,
          maksPercobaan: maksPercobaan,
          timeout: timeout,
          acak: _acak,
          layakDiulang: (e) => e is TimeoutException || (e is GagalSimpan && e.transien),
          padaUlang: (percobaan, galat, jeda) => _log.warning({
            'event': 'retry',
            'operasi': operasi,
            'percobaan': percobaan,
            'galat': galat.runtimeType.toString(),
            'jeda_ms': jeda.inMilliseconds,
          }),
        ),
      );
    } on GagalSimpan {
      rethrow; // sudah galat domain: teruskan apa adanya
    } on Object catch (e) {
      throw bungkus(e); // TimeoutException, SirkuitTerbuka, dan lain-lain menjadi galat domain
    }
  }
}
```

- `PenyimpanTangguh implements Penyimpan`: ia *adalah* sebuah penyimpan, sehingga composition root dapat menyisipkannya di mana pun `Penyimpan` dibutuhkan; `AplikasiTodo` tak tahu bahwa ketahanan ada. Itulah pola *decorator*.
- Susunan: `breaker.jalankan(() => denganRetry(...))`. Breaker di luar retry berarti satu panggilan yang gagal setelah semua percobaan dihitung sebagai *satu* kegagalan; breaker membuka setelah beberapa panggilan gagal total, bukan setelah beberapa percobaan.
- `layakDiulang` membaca bendera `e.transien` yang dinilai adapter dan `TimeoutException`; galat permanen (izin ditolak) tidak diulang dan diteruskan seketika.
- `on GagalSimpan { rethrow; }` meneruskan galat domain apa adanya (misalnya kegagalan permanen); `on Object catch (e) { throw bungkus(e); }` menerjemahkan sisanya (timeout, sirkuit terbuka) menjadi `GagalBaca` atau `GagalTulis` dengan `penyebab` asli, sehingga `AplikasiTodo` hanya perlu menangani satu keluarga galat.
- `padaUlang` menulis log terstruktur (9.2, Contoh 7); semua keputusan retry terlihat tanpa menyentuh logika bisnis.
- Catatan jujur: timeout tidak membatalkan penulisan yang lambat. Karena tiap `tulis` membawa snapshot penuh, mengulang aman; tetapi penulisan zombie yang mendarat belakangan dapat menimpa penulisan yang lebih baru bila tak ada pagar di sisi penyimpan. `PenyimpanBerkas` punya pagar (7.8); adapter lain butuh nomor versi pada kontrak (Latihan 9.4).

**Langkah 5 — adapter infrastruktur dan composition root.**

```dart
// packages/infra/lib/src/penyimpan_berkas.dart  (perubahan terhadap 7.8: galat dinilai `transien`)
@override
Future<String?> baca() async {
  try {
    return await File(jalur).readAsString();
  } on PathNotFoundException {
    return null;
  } on FileSystemException catch (e) {
    throw GagalBaca(jalur, penyebab: e, transien: transienIo(e));
  }
}

// di dalam _tulisAtomik:
} on FileSystemException catch (e) {
  await _hapusDiam(sementara);
  throw GagalTulis(tujuan, penyebab: e, transien: transienIo(e));
}
```

```dart
// packages/infra/lib/src/pencatat.dart
import 'package:logging/logging.dart';
import 'package:todo_inti/todo_inti.dart';
import 'package:todo_ketahanan/todo_ketahanan.dart';

/// Menjembatani Pencatat milik inti ke package:logging (log terstruktur, 9.2).
void pencatatLogging(Tingkat tingkat, String pesan, {Object? galat, StackTrace? jejak}) {
  final level = tingkat == Tingkat.galat
      ? Level.SEVERE
      : tingkat == Tingkat.peringatan
          ? Level.WARNING
          : Level.INFO;
  Logger('todo.aplikasi').log(level, {'event': 'aplikasi', 'pesan': pesan}, galat, jejak);
}

void catatSirkuit(KeadaanSirkuit dari, KeadaanSirkuit ke) =>
    Logger('todo.breaker').warning({'event': 'sirkuit', 'dari': dari.name, 'ke': ke.name});
```

```dart
// packages/cli/bin/todo.dart  (perakitan; shell, runZonedGuarded, dan kode keluar dari 7.8 dipindahkan apa adanya)
import 'dart:async';
import 'dart:io';

import 'package:todo_infra/todo_infra.dart';
import 'package:todo_inti/todo_inti.dart';
import 'package:todo_ketahanan/todo_ketahanan.dart';

Future<AplikasiTodo?> bukaAplikasi(Penyimpan penyimpan) async {
  try {
    final (:aplikasi, :peringatan) =
        await AplikasiTodo.muat(penyimpan, catat: pencatatLogging);
    peringatan.forEach(stderr.writeln);
    return aplikasi;
  } on GagalSimpan catch (e) {
    stderr.writeln(untukPengguna(e));
    exitCode = KodeKeluar.gagalIo.nilai;
    return null;
  }
}

void main(List<String> args) {
  pasangLogTerstruktur(); // infra: JSON Lines ke stderr
  final jalur = args.isNotEmpty ? args.first : 'todo.json';

  // COMPOSITION ROOT: satu-satunya tempat yang mengenal semua implementasi.
  final breaker = CircuitBreaker(
    ambangGagal: 5,
    waktuTunggu: const Duration(seconds: 30),
    hitungSebagaiGagal: (e) => e is TimeoutException || (e is GagalSimpan && e.transien),
    padaPerubahan: catatSirkuit,
  );
  final penyimpan = PenyimpanTangguh(PenyimpanBerkas(jalur), breaker: breaker);

  unawaited(runZonedGuarded(() async {
    final app = await bukaAplikasi(penyimpan);
    if (app != null) {
      await jalankanShell(app); // dari 7.8
      await app.tutup();
    }
  }, (e, s) {
    pencatatLogging(Tingkat.galat, 'galat internal (bug)', galat: e, jejak: s);
    exitCode = KodeKeluar.bugInternal.nilai;
  }));
}
```

- `PenyimpanBerkas` tetap di infrastruktur dan sekarang menerjemahkan `FileSystemException` menjadi `GagalBaca` atau `GagalTulis` dengan `transien: transienIo(e)`: pengetahuan tentang arti galat I/O ada *di sana*, bukan di domain atau di decorator.
- `pencatatLogging` memetakan `Pencatat` milik inti ke `package:logging`; hanya anggota `Tingkat` yang sudah pasti ada yang dipakai (`galat`, `peringatan`, lainnya dianggap info).
- Composition root merakit rantai `PenyimpanBerkas` → `PenyimpanTangguh` → `AplikasiTodo`; mengganti penyimpan (misalnya menambah adapter web atau jaringan) hanya mengubah baris ini. `hitungSebagaiGagal` memastikan hanya kegagalan sistem yang membuka sirkuit.
- Shell, `KodeKeluar`, dan `untukPengguna` tinggal di `todo_cli`: itu lapisan presentasi, dan hanya di sanalah `exitCode` dan `stderr` dipakai.

**Langkah 6 — tes: aturan dependensi, kontrak, dan ketahanan.**

```dart
// tool/cek_arsitektur.dart  (skrip dari 9.1, Contoh 7; hanya peta aturannya yang berganti)
const aturan = <String, ({Set<String> izinPaket, List<String> larangImpor})>{
  'packages/ketahanan': (
    izinPaket: {'clock'},
    larangImpor: ['todo_inti', 'todo_infra', 'todo_cli', 'dart:io'],
  ),
  'packages/inti': (
    izinPaket: {'meta', 'todo_ketahanan'},
    larangImpor: ['todo_infra', 'todo_cli', 'dart:io'],
  ),
  'packages/infra': (
    izinPaket: {'meta', 'logging', 'todo_inti', 'todo_ketahanan'},
    larangImpor: ['todo_cli'],
  ),
};
```

```text
# Bentuk keluaran yang diharapkan bila skrip dijalankan SEBELUM Langkah 3-5 (nama berkas bergantung pemecahanmu):
packages/inti/lib/src/penyimpan_berkas.dart:2: dilarang mengimpor dart:io
packages/inti/lib/src/pencatat.dart:1: dilarang mengimpor dart:io
# Setelah refaktor:
arsitektur: aturan dependensi terpenuhi
```

```dart
// packages/infra/test/kontrak_test.dart  (tes kontrak dari 8.3 dijalankan pada setiap adapter)
import 'package:test/test.dart';
import 'package:todo_infra/todo_infra.dart';
import 'package:todo_inti/testing.dart';
import 'package:todo_ketahanan/todo_ketahanan.dart';

import 'helper.dart'; // direktoriSementara(), dari 8.3
import 'kontrak_penyimpan.dart'; // ujiKontrakPenyimpan(), dari 8.3

void main() {
  ujiKontrakPenyimpan('memori', PenyimpanMemori.new);
  ujiKontrakPenyimpan('berkas', () => PenyimpanBerkas('${direktoriSementara().path}/todo.json'));
  ujiKontrakPenyimpan(
    'tangguh(memori)',
    () => PenyimpanTangguh(PenyimpanMemori(), breaker: CircuitBreaker()),
  );
}
```

```dart
// packages/infra/test/tangguh_test.dart
import 'dart:async';
import 'dart:math';

import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';
import 'package:todo_infra/todo_infra.dart';
import 'package:todo_inti/testing.dart';
import 'package:todo_inti/todo_inti.dart';
import 'package:todo_ketahanan/todo_ketahanan.dart';

import 'helper.dart'; // diam, judulDari (dari 8.4)

/// Pembungkus yang SENGAJA gagal (transien) dengan peluang tertentu; peluang dapat diubah saat tes.
class PenyimpanNakal implements Penyimpan {
  PenyimpanNakal(this._dalam, {this.peluangGagal = 0.0, Random? acak})
      : _acak = acak ?? Random();

  final Penyimpan _dalam;
  final Random _acak;
  double peluangGagal;
  int panggilan = 0;

  Future<T> _nakal<T>(Future<T> Function() kerja) async {
    panggilan++;
    if (_acak.nextDouble() < peluangGagal) throw const GagalTulis('virtual', transien: true);
    return kerja();
  }

  @override
  Future<String?> baca() => _nakal(_dalam.baca);

  @override
  Future<void> tulis(String isi) => _nakal(() => _dalam.tulis(isi));

  @override
  Future<void> cadangkan(String isi) => _nakal(() => _dalam.cadangkan(isi));
}

/// Penulisan pertama sangat lambat (5 detik); selebihnya segera.
class PenyimpanLambatSekali implements Penyimpan {
  final mendarat = <String>[];
  String? isi;
  int _tulisanMasuk = 0;

  @override
  Future<String?> baca() async => isi;

  @override
  Future<void> tulis(String s) async {
    final nomor = ++_tulisanMasuk;
    if (nomor == 1) await Future<void>.delayed(const Duration(seconds: 5));
    isi = s;
    mendarat.add(s);
  }

  @override
  Future<void> cadangkan(String s) async {}
}

void main() {
  test('di bawah kegagalan transien acak, memori selalu sama dengan disk', () {
    fakeAsync((async) {
      final disk = PenyimpanMemori();
      final nakal = PenyimpanNakal(disk, acak: Random(3)); // awalnya sehat
      final penyimpan = PenyimpanTangguh(
        nakal,
        breaker: CircuitBreaker(ambangGagal: 1000), // breaker tak ikut diuji di sini
        maksPercobaan: 6,
        acak: Random(5),
      );
      late AplikasiTodo app;
      unawaited(AplikasiTodo.muat(penyimpan, catat: diam).then((h) => app = h.aplikasi));
      async.flushMicrotasks();

      nakal.peluangGagal = 0.3; // sekarang penyimpan sering gagal
      final pesan = <String>[];
      for (var i = 0; i < 50; i++) {
        unawaited(app.proses(Tambah(Judul.dari('tugas $i'))).then((k) => pesan.add(k.first)));
        async.elapse(const Duration(minutes: 1)); // cukup untuk semua retry dan jeda
      }

      final berhasil = pesan.where((p) => p.startsWith('ditambah')).length;
      final gagal = pesan.where((p) => p.startsWith('gagal')).length;
      expect(berhasil + gagal, 50); // setiap perintah berakhir dengan sukses atau gagal yang dilaporkan
      expect(app.daftar, hasLength(berhasil)); // komit hanya setelah persisten

      String? isiDisk;
      unawaited(disk.baca().then((s) => isiDisk = s));
      async.flushMicrotasks();
      final judulDisk = isiDisk == null ? <String>[] : judulDari(dekode(isiDisk!));
      expect(judulDisk, judulDari(app.daftar)); // disk sama dengan memori
    });
  });

  test('penulisan lambat: timeout lalu retry sukses; yang tertinggal mendarat idempoten', () {
    fakeAsync((async) {
      final lambat = PenyimpanLambatSekali();
      final penyimpan = PenyimpanTangguh(
        lambat,
        breaker: CircuitBreaker(),
        timeout: const Duration(seconds: 2),
        acak: Random(1),
      );
      late AplikasiTodo app;
      unawaited(AplikasiTodo.muat(penyimpan, catat: diam).then((h) => app = h.aplikasi));
      async.flushMicrotasks();

      List<String>? keluaran;
      unawaited(app.proses(Tambah(Judul.dari('roti'))).then((k) => keluaran = k));
      async.elapse(const Duration(seconds: 3)); // percobaan 1 kena timeout (2 s), retry sukses
      expect(keluaran, ['ditambah: roti']);
      expect(lambat.mendarat, hasLength(1)); // baru satu penulisan yang mendarat

      async.elapse(const Duration(seconds: 10)); // penulisan lambat akhirnya mendarat
      expect(lambat.mendarat, hasLength(2));
      expect(lambat.mendarat.toSet(), hasLength(1)); // isinya sama: idempoten, tak merusak
    });
  });

  test('sirkuit terbuka: panggilan ditolak tanpa menyentuh penyimpan, pesan jelas', () {
    fakeAsync((async) {
      final nakal = PenyimpanNakal(PenyimpanMemori());
      final penyimpan = PenyimpanTangguh(
        nakal,
        breaker: CircuitBreaker(
          ambangGagal: 2,
          waktuTunggu: const Duration(seconds: 30),
          hitungSebagaiGagal: (e) => e is TimeoutException || (e is GagalSimpan && e.transien),
        ),
        maksPercobaan: 1, // tanpa retry agar hitungan jelas
      );
      late AplikasiTodo app;
      unawaited(AplikasiTodo.muat(penyimpan, catat: diam).then((h) => app = h.aplikasi));
      async.flushMicrotasks();

      nakal.peluangGagal = 1.0; // penyimpan mati
      final pesan = <String>[];
      for (var i = 0; i < 3; i++) {
        unawaited(app.proses(Tambah(Judul.dari('tugas $i'))).then((k) => pesan.add(k.first)));
        async.flushMicrotasks();
      }

      expect(pesan[0], contains('gagal menyimpan'));
      expect(pesan[1], contains('gagal menyimpan'));
      expect(pesan[2], contains('dilindungi')); // sirkuit terbuka
      expect(nakal.panggilan, 3); // 1 baca + 2 tulis; panggilan ketiga tak menyentuh penyimpan
      expect(app.daftar, isEmpty); // tak ada perubahan yang dikomit
    });
  });
}
```

- Skrip aturan dependensi kini memeriksa tiga paket sekaligus; **jalankan sebelum refaktor** untuk melihat kebocoran (`dart:io` di `inti`) sebagai pelanggaran konkret, lalu setelah Langkah 3–5 ia harus hijau. Memasukkannya ke `just cek` dan CI (8.2) menjadikan aturan arsitektur bukti yang berjalan di setiap perubahan.
- Tes kontrak dari 8.3 dijalankan pada **tiga** penyimpan: fake, berkas nyata, dan `PenyimpanTangguh` yang membungkus fake. Bila decorator mengubah perilaku yang dijanjikan port, tes kontrak langsung memergokinya.
- `PenyimpanNakal` adalah *fault injector* ber-seed: peluang gagalnya dapat diubah di tengah tes (awalnya sehat agar `muat` berhasil, lalu dimatikan atau dibuat sering gagal). Waktu virtual membuat 50 operasi dengan seluruh retry dan jeda selesai tanpa menunggu.
- Tes pertama membuktikan **invarian**, bukan skenario tunggal: apa pun urutan kegagalan acaknya, setiap perintah berakhir sebagai sukses atau kegagalan yang dilaporkan, jumlah item di memori sama dengan jumlah sukses, dan disk sama dengan memori.
- Tes kedua membuktikan bahwa penulisan yang kena timeout lalu diulang tidak merusak hasil: yang tertinggal mendarat belakangan dengan isi yang sama (idempoten). *Jendela bahaya* (ada penulisan lebih baru yang mendarat di antaranya) sengaja tidak diuji di sini; itu Latihan 9.4 tentang nomor versi.
- Tes ketiga membuktikan **gagal cepat**: setelah dua kegagalan sirkuit terbuka, panggilan ketiga ditolak dengan pesan yang jelas dan *tidak* menyentuh penyimpan (`panggilan` tetap 3), sementara memori tak berubah.
- Uji mutasi (8.2): hapus `on GagalSimpan { rethrow; }` atau ubah `e.transien` menjadi `true` pada `layakDiulang`, dan pastikan setidaknya satu tes gagal.

**Langkah 7 — catat keputusannya: ADR.**

```markdown
# ADR-001: Ketahanan sebagai decorator di batas adapter

- Status: diterima (2026-11-20)
- Konteks: AplikasiTodo v7 menanam retry, timeout, dan backoff di koordinator. Setiap adapter baru
  harus mengulang kerja itu, dan domain mengenal TimeoutException dan transienIo (dart:io).
- Keputusan: AplikasiTodo hanya mengenal port Penyimpan dan GagalSimpan(transien). Retry, timeout,
  dan circuit breaker dipasang sebagai decorator PenyimpanTangguh di infrastruktur dan dirakit di
  composition root (todo_cli).
- Konsekuensi:
  - (+) AplikasiTodo lebih sederhana dan tak lagi mengimpor dart:io.
  - (+) Adapter apa pun dapat dibungkus tanpa diubah.
  - (-) Satu lapisan indireksi tambahan.
  - (-) Penulisan zombie setelah timeout tetap butuh pagar di sisi penyimpan
    (PenyimpanBerkas punya; adapter lain perlu nomor versi pada kontrak: lihat latihan).
- Alternatif yang ditolak: retry di setiap adapter (duplikasi); retry di AplikasiTodo (status quo).
```

- Satu berkas pendek per keputusan, bernomor, disimpan di repositori (misalnya `docs/adr/`), tak pernah dihapus: keputusan yang diganti diberi status “digantikan oleh ADR-xxx”.
- Bagian *Konsekuensi* wajib memuat sisi negatif; ADR yang hanya berisi keuntungan adalah iklan, bukan catatan.
- Tulis ADR saat keputusan diambil, bukan sebulan kemudian; yang perlu dicatat adalah *alasan* dan *alternatif yang ditolak*, karena kodenya sendiri sudah memperlihatkan hasilnya.

**Langkah 8 — definisi “selesai” untuk To-Do v8.**

- [ ] `just cek` hijau di mesinmu dan di CI, termasuk `tool/cek_arsitektur.dart`.
- [ ] `todo_inti` tidak mengimpor `dart:io`, `todo_infra`, atau `todo_cli` (dibuktikan skrip, bukan hanya struktur paket).
- [ ] Semua tes 7.8 dan 8.x lulus setelah penyesuaian tanda tangan yang dicatat di Langkah 1.
- [ ] Tes kontrak lulus pada fake, berkas nyata, dan `PenyimpanTangguh`.
- [ ] Tiga tes ketahanan (invarian di bawah kegagalan acak, penulisan lambat, sirkuit terbuka) lulus dengan seed dan waktu virtual.
- [ ] ADR-001 tertulis dengan konsekuensi negatif yang jujur.
- [ ] README memuat diagram paket, aturan dependensi, dan cara menjalankan `just cek`.
- [ ] Mutan yang dikerjakan di 8.4 (ditambah dua mutan baru di `PenyimpanTangguh`) semuanya terbunuh atau tercatat setara.

### D. Variasi Kode untuk Logika yang Sama

| Keputusan | Pilihan | Kelebihan | Kekurangan |
| --- | --- | --- | --- |
| Tempat ketahanan | *Decorator* di batas adapter (dipilih) | Satu tempat; membungkus adapter apa pun | Satu lapisan indireksi |
| Tempat ketahanan | Di dalam setiap adapter | Memanfaatkan pengetahuan adapter | Duplikasi; mudah tak konsisten |
| Tempat ketahanan | Di koordinator (v7) | Sederhana | Domain mengenal timeout dan galat teknis |
| Bentuk kebijakan | Kelas decorator | Eksplisit; mudah dites | Boilerplate per port |
| Bentuk kebijakan | Fungsi kebijakan (`typedef` generik) | Ringkas; mudah ditumpuk atau diganti | Niat kurang bernama |
| Pemisahan | Empat paket dalam workspace (dipilih) | Batas dijaga struktur dan skrip | Overhead berkas dan konfigurasi |
| Pemisahan | Satu paket, tiga folder, plus skrip | Ringan | Batas hanya konvensi dan skrip |

Alternatif: kebijakan sebagai *fungsi*, bukan kelas decorator per port.

```dart
typedef Perlindungan = Future<T> Function<T>(Future<T> Function() kerja);

final class PenyimpanDilindungi implements Penyimpan {
  PenyimpanDilindungi(this._dalam, this._lindungi);
  final Penyimpan _dalam;
  final Perlindungan _lindungi;

  @override
  Future<String?> baca() => _lindungi(_dalam.baca);

  @override
  Future<void> tulis(String isi) => _lindungi(() => _dalam.tulis(isi));

  @override
  Future<void> cadangkan(String isi) => _lindungi(() => _dalam.cadangkan(isi));
}

// Komposisi di composition root: kebijakan adalah FUNGSI yang dapat ditumpuk atau diganti.
Future<T> kebijakan<T>(Future<T> Function() kerja) => breaker.jalankan(
      () => denganRetry(
        kerja,
        layakDiulang: (e) => e is TimeoutException || (e is GagalSimpan && e.transien),
      ),
    );

final penyimpan = PenyimpanDilindungi(PenyimpanBerkas(jalur), kebijakan);
```

- `typedef Perlindungan = Future<T> Function<T>(Future<T> Function() kerja)` — tipe *fungsi generik*: menerima kerja bertipe apa pun dan mengembalikan `Future` bertipe sama, sehingga satu kebijakan melayani `baca` (`String?`) dan `tulis` (`void`).
- Kebijakan kini berupa fungsi biasa; menumpuk dua kebijakan cukup dengan membungkus yang satu di dalam yang lain, tanpa kelas baru. Harga: bagian galat domain (`bungkus` ke `GagalBaca` atau `GagalTulis`) harus diurus di dalam fungsi kebijakan.
- Pilih kelas decorator bila ingin niat yang bernama dan penerjemahan galat yang eksplisit; pilih fungsi kebijakan bila kamu memasang pola yang sama pada banyak port.

### E. Terminologi Esensial

- **Decorator** — objek yang mengimplementasikan antarmuka yang sama dengan objek yang dibungkusnya dan menambah perilaku di sekitarnya. **Composition root** — satu tempat yang merakit semua objek konkret.
- **Kebijakan ketahanan** — kombinasi retry, timeout, dan breaker yang dipasang di batas, terpisah dari logika bisnis. **Galat domain vs galat teknis** — penolakan aturan bisnis vs kegagalan infrastruktur; port hanya membicarakan yang pertama.
- **`transien`** — penilaian adapter bahwa suatu kegagalan layak dicoba lagi. **Penulisan zombie** — penulisan lambat yang masih berjalan setelah pemanggilnya menyerah dan dapat mendarat belakangan. **Pagar (fencing token)** — nomor urut yang membuat penyimpan menolak penulisan yang lebih lama.
- **ADR (*architecture decision record*)** — catatan singkat satu keputusan arsitektur: konteks, keputusan, konsekuensi, alternatif. **Fitness function arsitektur** — pemeriksaan otomatis atas sifat arsitektur (skrip aturan dependensi).

### F. Visualisasi (ASCII)

```text
   todo_cli ───► todo_infra ───► todo_inti ───► todo_ketahanan ───► (clock)
     │              │  │            │
     │              │  └────────────┴───► meta
     │              └──► logging
     └── composition root merakit:  PenyimpanBerkas ─► PenyimpanTangguh ─► AplikasiTodo
   panah selalu menuju ke dalam; todo_inti tidak mengimpor dart:io
```

```text
   AplikasiTodo ──► Penyimpan (port)
                        ▲
                        │ implements
               PenyimpanTangguh  (decorator: breaker ─► retry ─► timeout)
                        │ membungkus
                        ▼
               PenyimpanBerkas  (adapter: dart:io, pagar generasi, transien = transienIo(e))
```

```text
   t=0   tulis#1 ───────── (lambat 5 s) ───────────────────────────────► mendarat (t=5)
   t=2   timeout ─► jeda ─► tulis#2 ─► mendarat (t≈2,1) ─► AplikasiTodo komit
   t=5   tulis#1 mendarat: isi SAMA  ► idempoten, aman
         bila ada tulis#3 yang BERBEDA mendarat di antaranya (t=3): tulis#1 menimpanya ► butuh nomor versi
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 9.1 (port dimiliki domain, composition root, aturan dependensi, workspace), 9.2 (`denganRetry`, `CircuitBreaker`, log terstruktur, *fault injection*), 9.3 (adapter platform bila ingin menambah penyimpan web), 7.8 (kode To-Do v6, pagar generasi), serta 8.1 sampai 8.4 (tes kontrak, mutasi, CI).
- **Dikembangkan di:** Fase Keamanan (adapter sebagai batas kepercayaan, izin berkas, jalur aman, dan penguatan `todo_infra`) dan proyek akhir kurikulum.

### H. Tips & Praktik Terbaik

- Pecah paket *sebelum* menulis aturan, lalu jalankan skrip dan biarkan pelanggaran memandu refaktor; kebocoran yang ditemukan mesin lebih meyakinkan daripada yang ditebak.
- Jangan memindahkan perilaku dan struktur sekaligus: pastikan semua tes lama lulus setelah setiap langkah kecil (salin, pecah, perbaiki impor, lalu ubah tanda tangan).
- Biarkan adapter menilai `transien`; lapisan ketahanan tak boleh menebak arti galat teknis.
- Pasang ketahanan di composition root, bukan di dalam logika; kebijakan berbeda per lingkungan (uji, produksi) menjadi pilihan perakitan.
- Tulis uji ketahanan sebagai invarian, bukan skenario tunggal, dengan seed dan waktu virtual.
- Catat keputusan dan konsekuensi negatifnya sebagai ADR; tinjau ulang saat konteks berubah.
- Akui batas desain terang-terangan (penulisan zombie) dan jadikan latihan, daripada berpura-pura sudah beres.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Memecah paket tanpa skrip aturan | `dart:io` merembes kembali ke inti | `tool/cek_arsitektur.dart` di `just cek` dan CI |
| Domain masih menyimpan `FileSystemException` | Domain terkunci pada platform | `GagalSimpan` dengan `transien`; penerjemahan di adapter |
| Decorator menelan galat domain | Penolakan bisnis hilang atau disalahartikan | `on GagalSimpan { rethrow; }` dan klasifikasi lewat `transien` |
| Breaker menghitung semua galat | Memutus layanan yang sehat | `hitungSebagaiGagal` hanya untuk kegagalan sistem |
| Retry di koordinator dan di decorator | Retry bertingkat | Satu pemilik retry: decorator |
| Menguji ketahanan dengan waktu nyata | Lambat dan rapuh | `fakeAsync`, acak ber-seed, pembungkus nakal |
| Mengabaikan penulisan zombie | Snapshot lama menimpa yang baru pada adapter tanpa pagar | Nomor versi pada kontrak port (latihan) |
| Tanpa ADR | Alasan hilang; keputusan diulang | ADR singkat per keputusan |

### J. Sumber Referensi

- ✔ Pub workspaces: https://dart.dev/tools/pub/workspaces · Michael Nygard, *Documenting Architecture Decisions*: https://www.cognitect.com/blog/2011/11/15/documenting-architecture-decisions · Kumpulan praktik ADR: https://adr.github.io/
- Decorator: https://en.wikipedia.org/wiki/Decorator\_pattern · Martin Kleppmann, token pagar: https://martin.kleppmann.com/2016/02/08/how-to-do-distributed-locking.html
- Rujukan modul sebelumnya: 7.8 (kode To-Do v6 dan pagar generasi), 8.3 (tes kontrak), 9.1 (aturan dependensi dan workspace), 9.2 (pola ketahanan).

---

## Latihan Fase 9 (sengaja tanpa kunci jawaban)

Kerjakan sendiri, lalu commit dengan struktur `fase-9/latihan-N/` berisi `README.md` (spesifikasi, keputusan, tabel hasil ukur beserta konfigurasinya), kode, dan `test/`. Untuk latihan yang memuat angka (latensi, tingkat sukses, percepatan), catat SDK, mode kompilasi (AOT atau JIT), flag, dan mesin; tes unit memakai waktu virtual, pengukuran beban memakai waktu nyata.

1. **\[9.1\]** Pisahkan `katalog_perpustakaan` menjadi tiga paket dalam satu workspace (`domain`, `infrastruktur`, `cli`), dengan domain hanya bergantung pada SDK dan `meta`. Sediakan dua adapter repositori: memori dan berkas JSONL. *Kriteria penerimaan:* seluruh tes domain berjalan tanpa menyentuh disk atau jaringan; mengganti adapter tidak mengubah satu baris pun di domain atau aplikasi; `tool/cek_arsitektur.dart` di CI membuktikan nol impor dari domain ke infrastruktur dan nol `dart:io` di domain (memeriksa `pubspec.yaml` *dan* impor, bukan hanya `grep`).
2. **\[9.1\]** Buktikan dan perbaiki pinjaman ganda: tulis tes gerbang untuk port naif (`cariStatus` lalu `simpanStatus`), ubah port menjadi `perbarui`, implementasikan atomisitas pada adapter berkas JSONL, dan jalankan tes kontrak atomisitas pada kedua adapter. *Kriteria penerimaan:* 1.000 permintaan pinjam acak (seed tetap) pada 10 ISBN tak pernah menghasilkan pinjaman ganda; permintaan untuk ISBN berbeda tetap berjalan paralel (buktikan dengan waktu virtual atau pengukuran).
3. **\[9.1\]** Hitung Ca, Ce, dan *instability* tiap paket di workspace-mu dan tulis ADR untuk satu keputusan batas paket. Lalu sengaja langgar aturan (impor terlarang) dan tunjukkan bahwa CI gagal dengan pesan yang menyebut berkas dan baris.
4. **\[9.2\]** Bungkus adapter eksternal `katalog_perpustakaan` (misalnya layanan pencarian ISBN palsu yang sengaja gagal 30% dan lambat 10%) dengan retry + jitter, timeout, dan circuit breaker; buat operasi `pinjam` idempoten lewat kunci permintaan. *Kriteria penerimaan:* uji beban sintetis 1.000 permintaan menunjukkan tingkat sukses efektif minimal 99% tanpa pinjaman ganda; saat layanan dimatikan total, sistem gagal cepat (sirkuit terbuka) dengan rata-rata di bawah 50 ms (diukur dengan waktu nyata di AOT, konfigurasi dicatat); semua keputusan retry tercatat sebagai log terstruktur tanpa rahasia.
5. **\[9.2\]** Tambahkan bulkhead dan token bucket ke jalur yang sama. Buktikan dengan waktu virtual bahwa lonjakan ditolak segera (*load shedding*), dan catat metrik `retry_total`, `fallback_total`, `sirkuit_dibuka_total` serta histogram latensi yang memperlihatkan sebaran, bukan hanya rata-rata.
6. **\[9.2\]** Ambil `denganRetry` versi kurikulum (tanpa plafon dan tanpa pembatasan eksponen). Tulis tes `maksPercobaan` besar yang gagal pada target web (`dart test -p chrome`) dan lulus pada versi yang diperbaiki, lalu jelaskan penyebabnya (operator geser memotong ke 32 bit di web).
7. **\[9.3\]** Pindahkan satu operasi `konversi_satuan` yang berat (misalnya parsing massal) ke pustaka C atau Rust kecil dengan ABI C, panggil lewat FFI (atau build hooks), dan bandingkan dengan Dart murni (6.2). Sediakan juga adapter penyimpanan dengan import bersyarat untuk VM dan web. *Kriteria penerimaan:* tidak ada kebocoran memori native, diverifikasi dengan ASan atau valgrind pada **pustaka native lewat harness C** dan, di sisi Dart, dengan tes `dispose` dan penghitung alokasi; keputusan “FFI atau Dart murni” ditulis dengan angka pengukuran; tes domain lulus di VM dan di web (`dart test -p vm,chrome`).
8. **\[9.3\]** Bungkus memori native dalam kelas aman (`dispose` dan `NativeFinalizer`) untuk satu API yang mengembalikan buffer. Tulis tes pemakaian setelah `dispose`, `dispose` ganda, dan fuzz panjang masukan (nol, satu, sangat besar, negatif) di batas; tunjukkan bahwa pembanding `qsort` yang salah (`x - y`) gagal pada nilai ekstrem.
9. **\[9.4\]** Lengkapi To-Do v8: tambahkan nomor versi pada kontrak `Penyimpan` (*compare-and-set* atau penolakan versi lama) sehingga penulisan zombie ditolak oleh adapter mana pun. Tulis tes yang membuktikan jendela bahaya (penulisan lambat menimpa penulisan yang lebih baru) sebelum perbaikan dan lulus sesudahnya; perbarui ADR-001 dan buat README “Bukti (v8)” dengan angka nyata beserta konfigurasinya.

---

## Ringkasan Fase 9 & Daftar Periksa Kelulusan

| Modul | Satu kalimat inti |
| --- | --- |
| 9.1 | Arah ketergantungan ke dalam: domain memiliki port, adapter di tepi mengimplementasikannya, aturan dibuktikan mesin, API publik sempit, dan konsistensi (atomisitas) adalah bagian dari kontrak port. |
| 9.2 | Kegagalan adalah kondisi normal: klasifikasikan, ulangi hanya yang transien dan idempoten, beri batas pada semuanya, gagal cepat, turun mutu dengan penanda, dan amati lewat log terstruktur dan metrik. |
| 9.3 | Menghubungkan Dart dengan dunia lain berarti mengelola kepemilikan memori dan batas kepercayaan, memahami perbedaan semantik antar target, dan menaruh semua kode platform di adapter tepi. |
| 9.4 | Memecah paket membongkar kebocoran, memindahkan ketahanan menjadi decorator di batas adapter menyederhanakan koordinator, dan keputusan serta batasnya dicatat jujur. |

**Daftar periksa kelulusan** (jawab tanpa membuka dokumen):

- [ ] Aku bisa menjelaskan arah ketergantungan, port masuk dan keluar, dan mengapa port dimiliki domain.
- [ ] Aku bisa membuktikan secara otomatis bahwa domain tak bergantung pada infrastruktur atau `dart:io`.
- [ ] Aku bisa mendesain API publik paket dengan `lib/src`, `export show`, `@internal`, class modifier, dan semver.
- [ ] Aku bisa menyusun workspace dengan `resolution: workspace` dan menjelaskan manfaatnya.
- [ ] Aku bisa menemukan dan memperbaiki balapan cek-lalu-tindak pada port dengan operasi atomik.
- [ ] Aku bisa menjelaskan kapan generasi kode layak dan apa status makro, augmentations, dan primary constructors.
- [ ] Aku bisa merancang retry dengan backoff, jitter, plafon, dan kunci idempotensi, dan menjelaskan mengapa timeout bukan pembatalan.
- [ ] Aku bisa mengimplementasikan dan menguji circuit breaker, bulkhead, dan token bucket dengan waktu virtual.
- [ ] Aku bisa merancang degradasi anggun yang bertanda dan log terstruktur tanpa rahasia.
- [ ] Aku bisa memanggil C lewat FFI atau build hooks dengan memori native yang aman dan batas kepercayaan yang jelas.
- [ ] Aku bisa menjelaskan perbedaan `int` dan operasi bitwise antara native dan web, dan mengujinya per target.
- [ ] Aku bisa memilih antara import bersyarat, composition root per target, dan proses terpisah.
- [ ] Sembilan latihan sudah di-commit dengan angka nyata beserta konfigurasinya.

**Pratinjau fase berikutnya (penomoran menunggu keputusanmu).** Yang tersisa menurut kurikulum adalah *Keamanan, Isolasi & Anonimitas* (pemodelan ancaman, validasi di batas, dan serangan logika umum; kriptografi aman dan penanganan rahasia; rantai pasok, isolasi proses, dan anonimitas) serta proyek akhir. Fase ini sudah banyak menyentuh bahannya: batas kepercayaan FFI, adapter sebagai pintu masuk data tak tepercaya, log tanpa rahasia, dan rate limiting sebagai pertahanan. Hal yang masih perlu dikonfirmasi: apakah Modul 2.2 dan 2.3 kurikulum (rekursi dan pemrograman dinamis; graf, pencarian, dan penjadwalan) sudah tercakup di Fase 1–4 (yang belum saya audit), dan penomoran akhir fase yang tersisa. Prasyaratnya: daftar periksa di atas terpenuhi.
> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-8/README.md
[selanjutnya]: ../bagian-10/README.md

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

