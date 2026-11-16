# Membangun Logika Dart — Fase 5: Logika Kegagalan & Ketahanan

*Dari kode yang hanya bekerja di jalur bahagia menjadi kode yang gagal dengan aman, melaporkan dengan jujur, dan pulih dengan benar.*

| Atribut | Keterangan |
| --- | --- |
| Level | Intermediate → Advanced |
| Estimasi waktu | 3 minggu, ±35–45 jam (teori ±30%, praktik ±70%) |
| Prasyarat | Fase 4 selesai (daftar periksa kelulusan terpenuhi, latihan di-commit) |
| Alat esensial | Dart SDK stabil (per 15 November 2026: **3.14**, dirilis 11 November 2026), `dart:io`, `dart analyze`, `dart test` |
| Batas versi fitur | `sealed`, pola, record: Dart ≥ 3.0 · parameter super: ≥ 2.17 · `Error.throwWithStackTrace`: tersedia di Dart modern (≥ 2.16) |
| Komunitas | https://dart.dev/community · tag `dart` di https://stackoverflow.com/questions/tagged/dart · proposal bahasa di https://github.com/dart-lang/language |
| Sertifikasi | Tidak ada sertifikasi resmi khusus; portofolio repositori dengan test kegagalan (fault injection) lebih bernilai |

**Hasil pembelajaran Fase 5** — setelah fase ini kamu mampu:

1. mengklasifikasikan kegagalan (bug, pelanggaran kontrak, masukan luar, lingkungan, domain, sumber daya) dan memilih respons yang tepat untuk tiap kelas;
2. memakai `try`/`on`/`catch`/`rethrow`/`finally` dan hierarki exception sendiri tanpa menelan bug atau menghilangkan stack trace;
3. memilih antara exception dan hasil-sebagai-data (`Hasil`), serta menerjemahkan keduanya di batas;
4. membebaskan resource dengan benar dan membuat operasi *all-or-nothing*;
5. menangani kegagalan I/O dengan penulisan atomik, penerjemahan galat, dan kode keluar yang bermakna;
6. merancang retry dengan backoff, jitter, dan idempotensi, serta pesan galat dan log yang berguna tanpa membocorkan rahasia.

---

## Daftar Isi Fase 5

<details>
  <summary>📃 Daftar Isi</summary>

---

- **0. Audit Kurikulum & Sambungan dari Fase 4**
- **5.1 Taksonomi Kegagalan:** siapa yang dapat memperbaikinya? *(TAMBAHAN)*
- **5.2 Mekanisme:** `try`, `on`, `catch`, `rethrow`, `finally`, dan exception sendiri
- **5.3 Kegagalan sebagai Data:** `Hasil` vs exception
- **5.4 Resource & Pembersihan:** `finally`, all-or-nothing, idempotensi
- **5.5 Kegagalan I/O dan Dunia Luar:** galat `dart:io`, penulisan atomik, kode keluar
- **5.6 Ketahanan:** retry, backoff, jitter, idempotensi
- **5.7 Pesan Galat, Logging, dan Observabilitas Dasar** *(TAMBAHAN)*
- **5.8 Studi Kasus Terpadu: To-Do v4** *(TAMBAHAN)*
- **Latihan (tanpa kunci jawaban), Ringkasan, dan Referensi Induk**

---

</details>

## 0. Audit Kurikulum & Sambungan dari Fase 4

1. **Sambungan.** Fase 1.5 memperkenalkan tiga lapis kegagalan (`assert`, galat kontrak, exception domain); Fase 2.6 dan 3.5 membangun `sealed` dan *smart constructor*; Fase 4.8 menunda kegagalan I/O secara eksplisit. Fase 5 menuntaskan semuanya: *kegagalan apa yang bisa terjadi, siapa yang menanganinya, dan bagaimana sistem tetap benar sesudahnya.*
2. **Temuan audit.** Kurikulum lazim mengajarkan sintaks `try`/`catch` lalu berhenti. Padahal keputusan yang menentukan mutu adalah *sebelum* sintaks: kegagalan jenis apa ini, dan layakkah ia dipulihkan? Maka ditambahkan **5.1 taksonomi** di depan mekanisme.
3. **TAMBAHAN:** 5.1 (taksonomi), 5.7 (pesan galat dan logging), 5.8 (studi kasus To-Do v4 dengan injeksi kegagalan). Ditunda secara sadar: kegagalan asinkron dan timeout (`Future`, `Stream`, cancel) ke Fase 7, serta kebocoran informasi, path traversal, dan data berbahaya ke Fase 9.
4. **Perbaikan yang dijanjikan dari Fase 4.8.** Penyimpanan berkas di sana memakai `existsSync()` lalu membaca (cek-lalu-pakai) dan menulis langsung; modul 5.5 dan 5.8 menggantinya dengan pola yang benar.
5. **Catatan versi.** Semua exception Dart bersifat *unchecked*: method tidak mendeklarasikan apa yang mungkin dilempar dan kamu tidak wajib menangkapnya; exception yang tak tertangkap menghentikan isolate (praktisnya, program). Dart 3.14 tidak mengubah perilaku ini.
6. **Tidak ada koreksi substansial** pada materi Fase 1–4.

> **Cara memakai dokumen ini** tetap sama: baca, tulis ulang dari ingatan, jalankan, bandingkan. Latihan di akhir tanpa kunci jawaban.

---

## 5.1 Taksonomi Kegagalan: Siapa yang Dapat Memperbaikinya? *(TAMBAHAN)*

*Motivasi: tidak semua kegagalan sama — memperlakukan semuanya sama adalah kegagalan pertama.*

> **Mengapa ditambahkan.** Audit menemukan bahwa pembelajar menulis `catch` sebelum bertanya *kegagalan apa ini*. Akibatnya bug ditelan sebagai "error biasa", dan kegagalan yang wajar dibiarkan menjatuhkan program. Taksonomi ini menjadi dasar keputusan untuk seluruh fase.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini memetakan semua kegagalan ke enam kelas berdasarkan **siapa yang dapat memperbaikinya** dan **apakah dapat dipulihkan di tempat**, lalu memetakan kelas itu ke tipe Dart (`Error` vs `Exception`), tindakan, dan lokasi penanganan. Hasilnya adalah tabel keputusan yang dipakai di semua modul berikutnya.

### B. Konsep Kunci & Filosofi Mendalam

- **Tiga pertanyaan penentu.** (1) *Siapa yang dapat memperbaikinya?* — programmer, pemanggil, pengguna, atau lingkungan. (2) *Dapatkah dipulihkan di tempat ini?* (3) *Bila diulang, mungkinkah berhasil* (transien) atau *pasti gagal lagi* (permanen)?
- **Enam kelas kegagalan:** (a) **bug internal** — invarian dilanggar oleh kodemu sendiri; (b) **pelanggaran kontrak API** — pemanggil melanggar precondition (1.5); (c) **masukan tak valid dari luar** — pengguna atau data eksternal; (d) **kegagalan lingkungan** — berkas hilang, izin ditolak, disk penuh, jaringan putus; (e) **kegagalan domain** — aturan bisnis menolak (saldo tak cukup); (f) **kehabisan sumber daya** — memori habis, stack overflow.
- **`Error` vs `Exception` di Dart.** `Error` menandai *masalah pemrograman* (kelas a, b, dan sebagian f): perbaiki kodenya, jangan ditangkap, dan program yang berhenti adalah respons yang wajar. `Exception` menandai *kondisi runtime yang wajar* (kelas c, d, e): dimaksudkan untuk ditangkap dan ditangani, dan membawa data yang berguna. Pedoman Effective Dart: lempar `Error` hanya untuk galat pemrograman, dan jangan menangkap `Error` secara eksplisit.
- **Dart mengizinkan melempar objek non-null apa pun**, tetapi melempar string atau tipe sembarang menghilangkan semua keuntungan klasifikasi; lempar `Error` atau `Exception` yang sesuai.
- **Cepat gagal di dalam, tahan di tepi.** Di dalam sistem, bug harus *terlihat* (fail-fast) agar cepat diperbaiki. Di tepi sistem (masukan pengguna, I/O, jaringan), sistem harus *tahan*: mendeteksi, melaporkan, dan pulih. Batas keduanya adalah titik parse (3.5).
- **Exception bukan alur kontrol normal.** Melempar dan menggulung stack lebih mahal daripada return biasa, dan membuat jalur kode sulit diikuti. Kegagalan yang *diharapkan dan sering* lebih baik menjadi data (5.3).
- **Filosofi:** kegagalan adalah bagian dari spesifikasi (1.1) — setiap operasi yang menyentuh dunia luar harus menjawab *apa yang terjadi bila gagal*.
- **Dampak desain:** salah mengklasifikasi memiliki dua wajah: menangkap bug sebagai "kegagalan wajar" (menyembunyikan cacat) atau memperlakukan kegagalan wajar sebagai bug (pengguna melihat crash).

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — mengamati kelas tiap kegagalan.**

```dart
import 'dart:io';

String kelas(Object e) => switch (e) {
      Error() => 'Error (bug/kontrak): perbaiki kodenya',
      Exception() => 'Exception (wajar): tangani atau laporkan',
      _ => 'objek lain: hindari melempar tipe ini',
    };

// Hanya untuk DEMO pengamatan: di produksi jangan menangkap Error secara eksplisit.
void coba(String nama, void Function() aksi) {
  try {
    aksi();
  } catch (e) {
    print('$nama -> ${e.runtimeType}: ${kelas(e)}');
  }
}

void main() {
  coba('argumen buruk', () => throw ArgumentError.value(-1, 'n', 'negatif'));
  coba('indeks', () => [1, 2][5]);
  coba('state', () => <int>[].first);
  coba('format', () => int.parse('abc'));
  coba('berkas', () => File('/tidak/ada/berkas.txt').readAsStringSync());
  coba('invarian', () => throw AssertionError('invarian dilanggar'));
}
```

- `switch (e) { Error() => ..., Exception() => ..., _ => ... }` — pola object pada dua tipe dasar; `Error` dan `Exception` memisahkan *bug* dari *kondisi wajar*.
- `[1, 2][5]` melempar `RangeError`; `<int>[].first` melempar `StateError`; keduanya `Error` (pelanggaran kontrak pemanggil).
- `int.parse('abc')` melempar `FormatException` dan membaca berkas yang tak ada melempar subtipe `FileSystemException`; keduanya `Exception` — kondisi wajar dari dunia luar.
- `catch (e)` tanpa `on` di sini sengaja hanya untuk pengamatan; aturan produksi dibahas di 5.2.

**Contoh 2 — tabel keputusan.**

| Kelas | Contoh | Tipe Dart khas | Tindakan | Ditangani di |
| --- | --- | --- | --- | --- |
| Bug internal | Saldo negatif setelah `tarik` | `AssertionError`, `StateError` | Perbaiki kode; fail-fast | Tidak ditangkap; dilaporkan di tingkat atas |
| Pelanggaran kontrak API | `tarik(-5)` | `ArgumentError`, `RangeError` | Perbaiki pemanggil | Tidak ditangkap |
| Masukan tak valid dari luar | Teks umur `abc` | `FormatException` atau `Hasil` | Validasi; beri tahu pengguna | Tepi sistem |
| Kegagalan lingkungan | Berkas hilang, disk penuh | `FileSystemException` (`IOException`) | Retry bila transien; laporkan | Adaptor di tepi |
| Kegagalan domain | Saldo tidak cukup | `Exception` turunan atau `Hasil` | Tampilkan; tawarkan alternatif | Lapisan aplikasi |
| Kehabisan sumber daya | Memori habis, stack overflow | `Error` khusus runtime | Akhiri; jangan ditangkap | Tingkat atas |

### D. Opsi Kode Lain untuk Logika yang Sama

| Cara merepresentasikan kegagalan | Cocok untuk | Kekurangan |
| --- | --- | --- |
| `assert` | Invarian internal, hanya saat pengembangan | Hilang di produksi; bukan untuk masukan luar |
| `Error` (`ArgumentError`, `StateError`, `RangeError`) | Pelanggaran kontrak oleh pemanggil | Tak untuk ditangkap |
| `Exception` turunan sendiri | Kegagalan wajar yang jarang dan harus naik | Tak tertulis di tanda tangan (unchecked) |
| Nilai nullable (`T?`) | *Tidak ada* tanpa alasan penting | Alasan gagal hilang |
| `Hasil<T, G>` sealed (5.3) | Kegagalan yang diharapkan, ditangani dekat, banyak varian | Boilerplate bila dipakai di mana-mana |

### E. Terminologi Esensial

- **Kegagalan transien / permanen** — mungkin berhasil bila diulang / pasti gagal lagi. **Fail-fast** — gagal sedini dan senyaring mungkin. **Resilien (tahan)** — mampu mendeteksi dan pulih.
- **Checked / unchecked exception** — dideklarasikan wajib / tidak wajib ditangani; semua exception Dart unchecked.
- **Batas sistem (boundary)** — tempat data dan efek dari luar masuk. **Pulih (recover)** — mengembalikan sistem ke keadaan sah setelah gagal.

### F. Visualisasi (ASCII)

```text
 Ada yang salah. Siapa yang dapat memperbaikinya?

 ├─ programmer (kodenya salah)             → Error / assert   (fail-fast; jangan ditangkap)
 ├─ pemanggil (melanggar kontrak API)       → ArgumentError / RangeError / StateError
 ├─ pengguna atau data luar                 → validasi → Hasil atau Exception tertentu;
 │                                             pesan yang dapat ditindaklanjuti
 ├─ lingkungan (I/O, jaringan, izin)        → Exception; transien? → retry; permanen? → laporkan / pulih
 ├─ aturan domain menolak                   → Exception turunan atau Hasil
 └─ sumber daya habis                       → Error runtime; akhiri
```

```text
  DI DALAM sistem                      DI TEPI sistem
  ───────────────────                  ──────────────────────────────────
  percaya tipe & kontrak               tidak percaya apa pun
  bug → fail-fast (terlihat)           validasi, tangkap, terjemahkan, pulih
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 1.5 (kontrak dan tiga alat), 2.6 dan 3.5 (sealed dan parse di tepi), 4.8 (kegagalan I/O yang ditunda).
- **Prasyarat bagi:** 5.2–5.8. **Dikembangkan di:** Fase 7 (kegagalan asinkron), Fase 9 (kegagalan sebagai sinyal keamanan), Fase 10 (menguji jalur gagal).

### H. Tips & Praktik Terbaik

- Untuk setiap fungsi yang menyentuh dunia luar, tulis di dokumentasinya apa yang terjadi bila gagal.
- Jangan menangkap sesuatu sebelum bisa menyebut *kelas kegagalan*-nya dan *tindakan pemulihannya*.
- Gunakan tipe yang tepat: `Error` untuk bug/kontrak, `Exception` untuk kondisi wajar.
- Tulis test untuk jalur gagal sama telitinya dengan jalur sukses.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Memperlakukan semua kegagalan sama | Bug ditelan, kegagalan wajar menjatuhkan program | Klasifikasikan dulu |
| Melempar `String` atau tipe sembarang | Tak bisa ditangani secara terarah | Lempar `Error`/`Exception` yang sesuai |
| Memakai exception untuk alur normal | Kode sulit diikuti dan lambat | Jadikan kegagalan wajar sebagai nilai |
| Menangkap `Error` untuk "membuat program tahan" | Bug tersembunyi | Biarkan ia naik; perbaiki penyebabnya |
| Mengasumsikan I/O selalu berhasil | Crash di lingkungan nyata | Tangani sebagai kegagalan lingkungan (5.5) |

### J. Sumber Referensi

- ✔ Error handling di Dart: https://dart.dev/language/error-handling
- ✔ Effective Dart — penggunaan (bagian penanganan galat): https://dart.dev/effective-dart/usage
- API `Exception`: https://api.dart.dev/stable/dart-core/Exception-class.html · API `Error`: https://api.dart.dev/stable/dart-core/Error-class.html
- API `FileSystemException`: https://api.dart.dev/stable/dart-io/FileSystemException-class.html
- Fail-fast (konsep): https://en.wikipedia.org/wiki/Fail-fast\_system

---

## 5.2 Mekanisme: try, on, catch, rethrow, finally, dan Exception Sendiri

*Motivasi: sintaks kegagalan itu singkat — yang menentukan mutu adalah apa yang kamu tangkap, dan apa yang kamu biarkan lewat.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas mekanisme penanganan: `throw`, `try`, klausa `on`, `catch (e, s)`, `rethrow`, `finally`, `Error.throwWithStackTrace`, serta cara merancang hierarki **exception sendiri** (sealed, membawa data dan penyebab). Fokusnya pada *aturan yang mencegah penanganan merusak diagnosis*.

### B. Konsep Kunci & Filosofi Mendalam

- **`throw` adalah ekspresi** (4.1) dan dapat dipakai di mana saja ekspresi diizinkan. Dart mengizinkan melempar objek non-null apa pun; kebiasaan baik adalah hanya `Error`/`Exception`.
- **Klausa `on` memilih tipe; `catch` mengambil objek dan stack trace.** `on FormatException catch (e, s)` menangkap hanya tipe itu, dan `e` serta `s` tersedia. `catch (e)` *tanpa* `on` menangkap **segala sesuatu**, termasuk `Error`.
- **Urutan klausa penting.** Klausa dicocokkan dari atas ke bawah; taruh subtipe sebelum supertipe.
- **`rethrow` menjaga stack trace asli**; `throw e` di dalam `catch` menghasilkan pelemparan baru yang jejaknya dimulai dari titik itu. Gunakan `rethrow` bila hanya menangani sebagian.
- **Menerjemahkan galat tanpa kehilangan jejak.** Bila di batas sistem kamu mengubah exception rendah (mis. `FileSystemException`) menjadi exception domain, gunakan `Error.throwWithStackTrace(galatBaru, stackAsli)` agar diagnosis tetap menunjuk sumber sesungguhnya, dan simpan galat asli sebagai `penyebab`.
- **`finally` selalu berjalan**, setelah klausa `catch` yang cocok; bila tak ada yang cocok, exception diteruskan *setelah* `finally`. **Jangan** menaruh `return`, `break`, atau `throw` di dalam `finally`: ia menimpa dan menelan exception yang sedang berjalan (lint `control_flow_in_finally`).
- **Pedoman Effective Dart:** hindari `catch` tanpa `on`; jangan membuang galat dari `catch` tanpa `on` (minimal catat); lempar `Error` hanya untuk galat pemrograman; jangan menangkap `Error` secara eksplisit; gunakan `rethrow` untuk melempar ulang.
- **Exception sendiri:** `implements Exception`, membawa **data** (bukan hanya string), imutabel (`const`), `toString` informatif, dan dijadikan **hierarki sealed** agar penangannya dapat dibuktikan lengkap (2.6). Sertakan `penyebab` dan, bila relevan, konteks (operasi, jalur).
- **`try` yang sempit.** Bungkus hanya panggilan yang bisa gagal; `try` yang membungkus puluhan baris membuat `on` menangkap kegagalan yang tak kamu maksud.
- **Filosofi:** menangkap berarti *mengklaim tahu cara menanganinya*; bila tidak, biarkan lewat.
- **Dampak desain:** `catch` yang terlalu lebar menyembunyikan bug; `catch` yang terlalu sempit membiarkan kegagalan wajar menjatuhkan program; menghilangkan stack trace membuat diagnosis menebak-nebak.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — exception sealed dengan data dan penyebab, serta penerjemahan di batas.**

```dart
import 'dart:io';

sealed class GagalKonfigurasi implements Exception {
  const GagalKonfigurasi(this.pesan, {this.penyebab});
  final String pesan;
  final Object? penyebab;

  @override
  String toString() =>
      '$runtimeType: $pesan${penyebab == null ? '' : ' (penyebab: $penyebab)'}';
}

class BerkasHilang extends GagalKonfigurasi {
  const BerkasHilang(this.jalur) : super('berkas tidak ditemukan');
  final String jalur;
}

class GagalBaca extends GagalKonfigurasi {
  const GagalBaca(super.pesan, {super.penyebab});
}

String bacaKonfigurasi(String jalur) {
  try {
    return File(jalur).readAsStringSync();
  } on PathNotFoundException {
    throw BerkasHilang(jalur);
  } on FileSystemException catch (e, s) {
    Error.throwWithStackTrace(GagalBaca('gagal membaca $jalur', penyebab: e), s);
  }
}
```

- `sealed class GagalKonfigurasi implements Exception` — satu keluarga galat tertutup; `switch` atasnya lengkap.
- `on PathNotFoundException` *sebelum* `on FileSystemException` — subtipe di atas supertipe, kalau tidak klausa kedua tak pernah tercapai.
- `Error.throwWithStackTrace(galatBaru, s)` — melempar galat domain *dengan* stack trace asli `s`; `e` disimpan sebagai `penyebab`.
- Semua jalur `bacaKonfigurasi` mengembalikan `String` atau melempar; `throwWithStackTrace` bertipe `Never` sehingga analyzer tahu tak ada jalur tanpa nilai.

**Contoh 2 — `rethrow` dan `finally`.**

```dart
void proses() {
  print('buka');
  try {
    throw StateError('rusak');
  } on StateError {
    print('tangkap sebagian');
    rethrow; // jejak asli terjaga
  } finally {
    print('bersihkan'); // selalu berjalan, juga saat rethrow
  }
}

void main() {
  try {
    proses();
  } on StateError {
    print('ditangani di main');
  }
  // Cetakan: buka / tangkap sebagian / bersihkan / ditangani di main
}
```

- `on StateError { ...; rethrow; }` — menangani sebagian lalu meneruskan; `rethrow` hanya sah di dalam klausa `catch`/`on`.
- `finally` berjalan *sebelum* exception sampai ke `main`; urutan cetakannya membuktikan itu.

**Contoh 3 — anti-pola: `return` di dalam `finally`.**

```dart
int salah() {
  try {
    throw StateError('rusak');
  } finally {
    return 42; // MENELAN exception: pemanggil tak pernah tahu ada yang rusak
  }
}
```

- Program mengembalikan `42` seolah semuanya baik. Lint `control_flow_in_finally` menandainya; aktifkan lint itu.

**Contoh 4 — klausa `on` berurutan dan `try` sempit.**

```dart
int? bacaPort(String teks) {
  final bersih = teks.trim(); // di luar try: tak akan gagal
  try {
    return int.parse(bersih); // hanya panggilan yang bisa gagal ada di dalam try
  } on FormatException {
    return null; // keputusan: bukan angka = tidak ada
  }
}
```

- Hanya `int.parse` yang berisiko, jadi hanya itu yang dibungkus; `on FormatException` tidak akan salah menangkap kegagalan dari baris lain.
- Lebih baik lagi, `int.tryParse(bersih)` menyatakan niat yang sama tanpa exception (5.3).

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Tiga bentuk klausa dan artinya:
try {
  kerja();
} on FormatException {
  // tipe tertentu, objek tak dibutuhkan
} on IOException catch (e) {
  // tipe tertentu + objek
} on Exception catch (e, s) {
  // semua Exception + jejak (tanpa Error)
}
// catch (e) { ... }  // menangkap SEGALANYA, termasuk Error: hindari
```

| Bentuk | Menangkap | Pakai bila |
| --- | --- | --- |
| `on T` | Hanya tipe `T` | Tak butuh objek galat |
| `on T catch (e)` | Tipe `T`, objek tersedia | Butuh data galat |
| `on T catch (e, s)` | Tipe `T`, objek dan jejak | Menerjemahkan atau mencatat |
| `on Exception catch (e)` | Semua exception wajar, tanpa `Error` | Penjaga di tepi sistem |
| `catch (e)` tanpa `on` | Segalanya | Hindari; bila terpaksa, catat dan `rethrow` |

### E. Terminologi Esensial

- **Unchecked exception** — tak dideklarasikan di tanda tangan. **Propagasi** — exception naik melewati pemanggil sampai ada yang menangkap.
- **Stack trace** — daftar pemanggilan aktif saat galat terjadi. **Penyebab (cause)** — galat asli yang dibungkus oleh galat baru.
- **`rethrow` / `throw e`** — melempar ulang dengan jejak asli / melempar baru. **Hierarki sealed** — keluarga exception tertutup yang dapat diperiksa kelengkapannya.

### F. Visualisasi (ASCII)

```text
 try ──► (tidak ada throw) ──────────────────────────────► [finally] ──► lanjut
  │
  └─► throw X ──► ada klausa on/catch yang cocok?
                     ├─ ya  ─► badan klausa ─► (rethrow?) ─► [finally] ─► propagasi atau lanjut
                     └─ tidak ───────────────────────────► [finally] ─► propagasi ke pemanggil
```

```text
  FileSystemException ──(batas sistem)──► GagalBaca(penyebab: FileSystemException)
         │                                      │
   stack trace asli ◄───── throwWithStackTrace ───┘   (jejak asli tetap menunjuk sumber)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 5.1 (taksonomi), 1.5 (kontrak), 2.6 (sealed), 4.1 (`throw` sebagai ekspresi dan `Never`).
- **Prasyarat bagi:** 5.3–5.8. **Dikembangkan di:** Fase 7 (galat pada `Future` dan `Stream`), Fase 9 (jangan membocorkan stack trace ke pengguna), Fase 10 (menguji klausa penanganan).

### H. Tips & Praktik Terbaik

- Tangkap tipe paling spesifik yang kamu tahu cara menanganinya; urutkan dari spesifik ke umum.
- Gunakan `rethrow` untuk meneruskan; gunakan `Error.throwWithStackTrace` saat menerjemahkan.
- Jadikan exception domain imutabel dengan data dan penyebab; bentuk teks di tepi, bukan di dalam exception.
- Aktifkan lint `control_flow_in_finally`, `avoid_catches_without_on_clauses`, dan `only_throw_errors` di `analysis_options.yaml`.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| `catch (e) {}` kosong | Bug lenyap tanpa jejak | Tangkap tipe spesifik; catat atau `rethrow` |
| `throw e` alih-alih `rethrow` | Stack trace asli hilang | Pakai `rethrow` |
| Menerjemahkan galat tanpa menyimpan penyebab dan jejak | Diagnosis menebak | `penyebab:` dan `Error.throwWithStackTrace` |
| Subtipe setelah supertipe | Klausa tak pernah tercapai | Urutkan spesifik → umum |
| `return`/`throw` di `finally` | Exception tertelan atau tertimpa | Pindahkan keluar dari `finally` |
| `try` membungkus banyak baris | Menangkap kegagalan yang tak dimaksud | Persempit ke panggilan yang berisiko |
| Exception hanya berisi string | Tak bisa ditangani secara terarah | Tambah field data; bentuk teks di tepi |

### J. Sumber Referensi

- ✔ Error handling di Dart (throw, catch, rethrow, finally): https://dart.dev/language/error-handling
- ✔ Effective Dart — penggunaan (aturan penanganan galat): https://dart.dev/effective-dart/usage
- API `Error.throwWithStackTrace`: https://api.dart.dev/stable/dart-core/Error/throwWithStackTrace.html
- Lint `control_flow_in_finally`: https://dart.dev/tools/linter-rules/control\_flow\_in\_finally
- Lint `avoid_catches_without_on_clauses`: https://dart.dev/tools/linter-rules/avoid\_catches\_without\_on\_clauses
- Lint `only_throw_errors`: https://dart.dev/tools/linter-rules/only\_throw\_errors

---

## 5.3 Kegagalan sebagai Data: Hasil vs Exception

*Motivasi: kegagalan yang tertulis di tipe tak bisa terlupakan oleh pemanggil.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas dua kanal untuk menyampaikan kegagalan: **exception** (jalur kontrol non-lokal, tak tertulis di tanda tangan) dan **hasil sebagai data** (`Hasil<T, G>` sealed yang menjadi bagian dari tipe kembalian). Kamu belajar kapan memakai yang mana, cara menyusun dan merangkai hasil (`petakan`, `rantai`, `lipat`), serta cara menerjemahkan antar kanal di batas sistem.

### B. Konsep Kunci & Filosofi Mendalam

- **Dua kanal.** *Kanal nilai*: fungsi mengembalikan `Hasil` yang berisi sukses atau gagal. *Kanal exception*: kegagalan melompati pemanggil sampai ada yang menangkap.
- **Keunggulan hasil sebagai data.** Kegagalan *tertulis di tipe*; `switch` atas `Hasil` yang sealed wajib lengkap (2.6), sehingga pemanggil tak dapat lupa menangani. Exception tak tertulis di tanda tangan (unchecked), mudah terlewat.
- **Kapan memakai `Hasil`:** kegagalan *diharapkan dan sering*, ditangani *dekat* pemanggil, memiliki *banyak varian bermakna* (validasi, parsing, aturan domain), atau membentuk *pipeline* langkah-langkah.
- **Kapan memakai exception:** kegagalan *langka* atau tak terduga, tak dapat ditangani lokal dan harus naik jauh; pelanggaran kontrak (`Error`); kegagalan lingkungan yang akan diterjemahkan di satu adaptor.
- **Tipe galat yang sealed.** `G` sebaiknya sealed (`GalatUmur`) agar penanganan tiap jenis galat dapat dibuktikan lengkap.
- **Komposisi.** `petakan` mengubah nilai sukses dan membiarkan galat lewat; `rantai` (sering disebut *flatMap*/*andThen*) menjalankan langkah berikutnya yang juga bisa gagal; `lipat` mengubah kedua kemungkinan menjadi satu nilai; `ambilAtau` memberi cadangan. Pola ini dikenal sebagai *railway-oriented programming*.
- **Adaptor di batas.** Fungsi `tangkap` mengubah exception *wajar* dari pustaka menjadi `Gagal` di tepi, **tanpa** menangkap `Error`; kebalikannya mengubah `Gagal` kembali menjadi exception bila pemanggil di atasnya memang memakai exception.
- **Satu konvensi per lapisan.** Inti memakai `Hasil`; tepi menerjemahkan exception pustaka menjadi `Hasil` atau exception domain. Mencampur keduanya tanpa aturan membingungkan pembaca.
- **Biaya.** Alokasi objek kecil dan boilerplate. Bila setiap fungsi mengembalikan `Hasil`, jalur sukses tertutup bungkusan; gunakan hanya pada fungsi yang memang dapat gagal secara wajar. Paket pihak ketiga ada, tetapi 30 baris buatan sendiri sering cukup.
- **Filosofi:** jadikan *kemungkinan gagal* bagian dari *bentuk* fungsi, bukan kejutan di runtime.
- **Dampak desain:** `Hasil` membuat jalur gagal terlihat dan teruji; harganya adalah ketelitian di tiap titik panggil.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — `Hasil<T, G>` sealed dengan operator komposisi.**

```dart
sealed class Hasil<T, G> {
  const Hasil();

  /// Mengubah kedua kemungkinan menjadi satu nilai.
  R lipat<R>({
    required R Function(T nilai) sukses,
    required R Function(G galat) gagal,
  }) =>
      switch (this) {
        Sukses<T, G>(:final nilai) => sukses(nilai),
        Gagal<T, G>(:final galat) => gagal(galat),
      };

  /// Mengubah nilai sukses; galat dibiarkan lewat.
  Hasil<U, G> petakan<U>(U Function(T nilai) ubah) => switch (this) {
        Sukses<T, G>(:final nilai) => Sukses<U, G>(ubah(nilai)),
        Gagal<T, G>(:final galat) => Gagal<U, G>(galat),
      };

  /// Langkah berikutnya yang juga bisa gagal.
  Hasil<U, G> rantai<U>(Hasil<U, G> Function(T nilai) lanjut) => switch (this) {
        Sukses<T, G>(:final nilai) => lanjut(nilai),
        Gagal<T, G>(:final galat) => Gagal<U, G>(galat),
      };

  T ambilAtau(T cadangan) => switch (this) {
        Sukses<T, G>(:final nilai) => nilai,
        Gagal<T, G>() => cadangan,
      };
}

class Sukses<T, G> extends Hasil<T, G> {
  const Sukses(this.nilai);
  final T nilai;
}

class Gagal<T, G> extends Hasil<T, G> {
  const Gagal(this.galat);
  final G galat;
}
```

- `Hasil<T, G>` — dua parameter tipe: `T` untuk nilai sukses, `G` untuk jenis galat.
- `lipat` — satu-satunya tempat yang *wajib* menangani kedua kemungkinan; `switch (this)` lengkap tanpa `_` karena `Hasil` sealed.
- `petakan` dan `rantai` — mengalirkan galat tanpa pemeriksaan manual di tiap langkah; kegagalan pertama menghentikan rangkaian.
- Tipe argumen ditulis eksplisit (`Sukses<U, G>(...)`) agar inferensi tak bergantung konteks.

**Contoh 2 — pipeline validasi dengan galat sealed.**

```dart
sealed class GalatUmur {
  const GalatUmur();
}

class BukanAngka extends GalatUmur {
  const BukanAngka(this.teks);
  final String teks;
}

class DiLuarRentang extends GalatUmur {
  const DiLuarRentang(this.nilai);
  final int nilai;
}

class TerlaluMuda extends GalatUmur {
  const TerlaluMuda(this.nilai);
  final int nilai;
}

Hasil<int, GalatUmur> parseUmur(String teks) {
  final n = int.tryParse(teks.trim());
  if (n == null) return Gagal<int, GalatUmur>(BukanAngka(teks));
  return Sukses<int, GalatUmur>(n);
}

Hasil<int, GalatUmur> periksaRentang(int n) => (n < 0 || n > 150)
    ? Gagal<int, GalatUmur>(DiLuarRentang(n))
    : Sukses<int, GalatUmur>(n);

Hasil<int, GalatUmur> periksaMinimal(int n) =>
    n < 17 ? Gagal<int, GalatUmur>(TerlaluMuda(n)) : Sukses<int, GalatUmur>(n);

Hasil<int, GalatUmur> validasiPendaftar(String teks) =>
    parseUmur(teks).rantai(periksaRentang).rantai(periksaMinimal);

String pesan(GalatUmur g) => switch (g) {
      BukanAngka(:final teks) => 'bukan angka: $teks',
      DiLuarRentang(:final nilai) => 'di luar rentang 0..150: $nilai',
      TerlaluMuda(:final nilai) => 'terlalu muda ($nilai); minimal 17',
    };

void main() {
  String lapor(String teks) => validasiPendaftar(teks).lipat(
        sukses: (n) => 'diterima: $n',
        gagal: pesan,
      );
  assert(lapor('27') == 'diterima: 27');
  assert(lapor('abc') == 'bukan angka: abc');
  assert(lapor('200') == 'di luar rentang 0..150: 200');
  assert(lapor('12') == 'terlalu muda (12); minimal 17');
}
```

- `parseUmur(...).rantai(periksaRentang).rantai(periksaMinimal)` — tiga langkah berurutan; kegagalan pertama menjadi hasil akhir tanpa `if` bersarang.
- `pesan` adalah `switch` lengkap atas `GalatUmur`; menambah `GalatUmur` baru memaksa kamu memperbaruinya (2.6).
- `gagal: pesan` — fungsi dikirim sebagai nilai (tear-off, 4.2).
- `int.tryParse` menggantikan `try`/`catch` untuk kegagalan yang sangat umum.

**Contoh 3 — adaptor di batas: exception → `Hasil`.**

```dart
Hasil<T, Exception> tangkap<T>(T Function() aksi) {
  try {
    return Sukses<T, Exception>(aksi());
  } on Exception catch (e) {
    return Gagal<T, Exception>(e);
  }
}

T ambilAtauLempar<T>(Hasil<T, Exception> h) => switch (h) {
      Sukses<T, Exception>(:final nilai) => nilai,
      Gagal<T, Exception>(:final galat) => throw galat,
    };

void main() {
  final h = tangkap(() => int.parse('x'));
  assert(h is Gagal<int, Exception>);
  assert(h.lipat(
        sukses: (_) => 'ok',
        gagal: (e) => e.runtimeType.toString(),
      ) ==
      'FormatException');
  // tangkap(() => [1][5]) melempar RangeError: Error TIDAK ditangkap (bug harus terlihat).
}
```

- `on Exception catch (e)` — hanya kegagalan wajar yang diubah menjadi data; `Error` tetap naik (5.1).
- `ambilAtauLempar` — jalan balik untuk pemanggil yang memakai exception.
- Adaptor seperti ini ditaruh *di tepi*, memanggil pustaka yang melempar, dan mengubah hasilnya sekali.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Alternatif tanpa operator komposisi: switch langsung di titik panggil.
String lapor2(String teks) => switch (validasiPendaftar(teks)) {
      Sukses(:final nilai) => 'diterima: $nilai',
      Gagal(:final galat) => pesan(galat),
    };
```

| Representasi | Kelebihan | Kekurangan | Pilih bila |
| --- | --- | --- | --- |
| `Hasil<T, G>` sealed | Kegagalan terlihat; penanganan lengkap dibuktikan | Boilerplate; bungkusan di jalur sukses | Kegagalan diharapkan, sering, banyak varian |
| Exception | Jalur sukses bersih; naik jauh otomatis | Tak tertulis di tanda tangan; mudah terlewat | Kegagalan langka atau tak terduga |
| `T?` (null) | Paling sederhana | Alasan gagal hilang | *Tidak ada* tanpa alasan penting |
| Record `(T?, G?)` | Tanpa class | Keadaan ilegal bisa ditulis (keduanya null atau keduanya terisi) | Hindari (3.5) |
| Paket Result pihak ketiga | Operator siap pakai | Dependensi tambahan | Bila tim sudah memakainya |

### E. Terminologi Esensial

- **Hasil (Result)** — tipe sealed berisi sukses atau gagal. **Railway-oriented programming** — merangkai langkah yang bisa gagal sehingga galat pertama memotong jalur.
- **`petakan` (map) / `rantai` (flatMap, andThen) / `lipat` (fold)** — operator komposisi. **Adaptor** — fungsi yang menerjemahkan antar kanal kegagalan.
- **Kanal kegagalan** — nilai kembalian vs exception.

### F. Visualisasi (ASCII)

```text
   parseUmur ──► periksaRentang ──► periksaMinimal ──► Sukses(umur)
       │               │                  │
       ▼               ▼                  ▼
   Gagal(BukanAngka)  Gagal(DiLuarRentang)  Gagal(TerlaluMuda)
       └───────────────┴──────────────────┴────► lipat → pesan untuk pengguna

   Galat pertama MEMOTONG jalur; langkah berikutnya tidak dijalankan.
```

```text
   KANAL NILAI                          KANAL EXCEPTION
   ───────────────────────────          ───────────────────────────────────
   fungsi ──► Hasil(Sukses|Gagal)       fungsi ──✗ throw ─────────► (naik tinggi)
   pemanggil WAJIB memeriksa            pemanggil boleh lupa
   cocok untuk gagal yang WAJAR         cocok untuk gagal yang LANGKA / bug
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 2.6 (sealed dan `switch` lengkap), 3.5 (parse di tepi), 5.1 (taksonomi), 4.2 (tear-off dan fungsi tingkat tinggi).
- **Prasyarat bagi:** 5.5 (adaptor I/O) dan 5.8. **Dikembangkan di:** Fase 7 (hasil dan galat dalam alur asinkron), Fase 8 (generics dan batas tipe), Fase 11 (kontrak galat antar modul).

### H. Tips & Praktik Terbaik

- Pakai `Hasil` pada fungsi yang kegagalannya diharapkan; pakai exception untuk yang langka atau tak dapat dipulihkan di tempat.
- Jadikan tipe galat sealed dan beri data yang cukup untuk menyusun pesan di tepi.
- Terjemahkan exception pustaka menjadi `Hasil` di satu adaptor, jangan di tiap pemanggil.
- Jangan menangkap `Error` di adaptor; hanya `Exception`.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| `Hasil` di setiap fungsi | Kode penuh bungkusan | Pakai hanya pada fungsi yang bisa gagal secara wajar |
| Tipe galat `String` | Penanganan tak terarah | Tipe sealed dengan data |
| Mencampur dua kanal tanpa aturan | Pembaca bingung kegagalan lewat mana | Satu konvensi per lapisan; adaptor di batas |
| Adaptor menangkap `Error` | Bug disamarkan sebagai data | `on Exception` saja |
| Mengabaikan hasil (`parse(x);` tanpa memakai) | Kegagalan tak pernah diperiksa | Aktifkan lint `unused_result` / pakai `lipat` |

### J. Sumber Referensi

- ✔ Class modifiers (`sealed`): https://dart.dev/language/class-modifiers
- ✔ Percabangan dan exhaustiveness: https://dart.dev/language/branches
- Scott Wlaschin, *Railway Oriented Programming*: https://fsharpforfunandprofit.com/rop/
- Algebraic data type: https://en.wikipedia.org/wiki/Algebraic\_data\_type

---

## 5.4 Resource & Pembersihan: finally, All-or-Nothing, Idempotensi

*Motivasi: kegagalan yang paling berbahaya bukan yang membuat program berhenti, melainkan yang diam-diam meninggalkan sesuatu terbuka atau setengah-jadi.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas cara memastikan bahwa **resource** (berkas terbuka, koneksi, kunci) selalu dilepas, bahwa operasi multi-langkah bersifat **all-or-nothing** (atomik), dan bahwa operasi dapat diulang dengan aman (**idempoten**). Kegagalan yang tak dibersihkan bukan sekadar bug: ia menjadi kebocoran lambat, state setengah-jadi, atau data ganda.

### B. Konsep Kunci & Filosofi Mendalam

- **Resource** adalah sesuatu yang harus dilepas: berkas, soket, kunci, timer, subscription (Fase 7), proses. Lupa melepas bukan error sesaat; ia bocor sampai program berakhir.
- **`try`/`finally` memastikan pelepasan**, juga saat exception. Dart tidak punya `using` atau RAII; pola yang lazim adalah **fungsi bracket** (*acquire → use → release*) yang menerima closure (4.2).
- **Pelepasan berurutan terbalik (LIFO).** Resource yang dibuka terakhir dilepas pertama.
- **Galat saat membersihkan tak boleh menutupi galat asli.** Exception yang dilempar dari dalam `finally` *menimpa* exception yang sedang berjalan. Bungkus pembersihan dalam penjaga yang melaporkan, bukan melempar.
- **All-or-nothing (atomik).** Strategi: (1) *validasi dulu, ubah kemudian*; (2) *kerjakan pada salinan lalu tukar* — nilai imutabel (Fase 3) membuat ini murah: state lama tetap utuh sampai penggantian terjadi; (3) untuk berkas, *tulis ke berkas sementara lalu ganti nama* (5.5).
- **Kegagalan parsial pada batch.** Pilih sadar: *berhenti di galat pertama* (fail-fast, semua atau tidak sama sekali) atau *kumpulkan laporan per item* (best-effort), dan tulis keputusan itu di spesifikasi.
- **Idempotensi.** Operasi idempoten dapat dijalankan berkali-kali dengan efek akhir yang sama: *set status = selesai* idempoten; *tambah saldo 100* tidak. Idempotensi adalah prasyarat retry yang aman (5.6); bila operasi alaminya tidak idempoten, beri **kunci idempotensi** agar pengulangan dikenali.
- **Urutan mencatat vs melakukan.** Mencatat kunci idempotensi *setelah* aksi sukses membuat pengulangan setelah kegagalan dimungkinkan; mencatat *sebelum* aksi dapat membuat aksi yang gagal dianggap sudah selesai.
- **Filosofi:** setiap kali memperoleh sesuatu atau mengubah sesuatu, tanyakan: *jika gagal di tengah, apa yang tertinggal?*
- **Dampak desain:** pembersihan yang benar mengubah kegagalan dari bencana menjadi gangguan sementara; tanpa itu kegagalan kecil menumpuk menjadi kerusakan besar.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — fungsi bracket yang melepas resource.**

```dart
import 'dart:io';

T denganBerkas<T>(
  String jalur,
  T Function(RandomAccessFile berkas) pakai, {
  FileMode mode = FileMode.read,
}) {
  final f = File(jalur).openSync(mode: mode);
  try {
    return pakai(f);
  } finally {
    f.closeSync(); // selalu dilepas, juga bila pakai(f) melempar
  }
}

void main() {
  final dir = Directory.systemTemp.createTempSync('uji_');
  try {
    final jalur = '${dir.path}/a.txt';
    File(jalur).writeAsStringSync('A');
    final byte = denganBerkas(jalur, (f) => f.readByteSync());
    assert(byte == 65); // kode ASCII 'A'
  } finally {
    dir.deleteSync(recursive: true); // membersihkan direktori sementara
  }
}
```

- `denganBerkas` mengurung seluruh siklus *buka → pakai → tutup*; pemanggil tak perlu mengingat `close`.
- `finally` menutup berkas untuk jalur sukses maupun gagal.
- Di `main`, direktori sementara pun dibersihkan dengan `try`/`finally` — kebiasaan yang sama pada tiap resource.

**Contoh 2 — galat pembersihan yang menimpa galat asli, dan penjaganya.**

```dart
// ANTI-POLA: galat di finally MENIMPA galat asli.
void menimpa() {
  try {
    throw StateError('galat asli');
  } finally {
    throw StateError('galat saat membersihkan'); // galat asli hilang
  }
}

abstract interface class Sumber {
  void tutup();
}

/// Membersihkan tanpa menimpa; kegagalan pembersihan hanya DILAPORKAN.
void bersihkanAman(
  void Function() bersihkan,
  void Function(Object galat, StackTrace jejak) lapor,
) {
  try {
    bersihkan();
  } on Exception catch (e, s) {
    lapor(e, s);
  }
}

T pakaiSumber<T>(
  Sumber s,
  T Function(Sumber) pakai,
  void Function(Object, StackTrace) lapor,
) {
  try {
    return pakai(s);
  } finally {
    bersihkanAman(s.tutup, lapor); // galat asli tetap sampai ke pemanggil
  }
}
```

- `menimpa` membuktikan bahaya: pemanggil hanya melihat galat kedua dan kehilangan penyebab sesungguhnya.
- `bersihkanAman` menangkap `Exception` dari pembersihan dan melapornya lewat callback (di studi kasus: logger).
- `s.tutup` — tear-off method terikat pada `s` (4.2).

**Contoh 3 — all-or-nothing lewat salinan dan tukar.**

```dart
class Keranjang {
  List<int> _harga = const [];
  List<int> get harga => List.unmodifiable(_harga);

  /// Semua atau tidak sama sekali: bila ada satu harga tidak sah, state tak berubah.
  void tambahSemua(List<int> baru) {
    final kandidat = [..._harga, ...baru]; // kerja pada SALINAN
    for (final h in kandidat) {
      if (h <= 0) {
        throw ArgumentError.value(h, 'harga', 'harus positif');
      }
    }
    _harga = kandidat; // tukar HANYA setelah semua lolos
  }
}

void main() {
  final k = Keranjang()..tambahSemua([100, 200]);
  try {
    k.tambahSemua([300, -1]);
  } on ArgumentError {
    // diabaikan untuk demo
  }
  assert(k.harga.length == 2); // 300 TIDAK ikut masuk
}
```

- `kandidat` dibangun dengan spread dari state lama; state lama tidak disentuh sampai validasi selesai.
- Pola ini sama dengan `_riwayat = baru` di To-Do: *ganti* hanya setelah semua langkah berhasil.

**Contoh 4 — kegagalan parsial pada batch, dan idempotensi dengan kunci.**

```dart
(List<int> berhasil, List<String> gagal) prosesBatch(List<String> masukan) {
  final berhasil = <int>[];
  final gagal = <String>[];
  for (final m in masukan) {
    final n = int.tryParse(m);
    if (n == null) {
      gagal.add(m);
    } else {
      berhasil.add(n);
    }
  }
  return (berhasil, gagal);
}

class PemrosesSekali {
  final Set<String> _sudah = {};

  /// Menjalankan [aksi] paling banyak sekali per [kunci]; false bila sudah pernah.
  bool jalankan(String kunci, void Function() aksi) {
    if (_sudah.contains(kunci)) return false;
    aksi(); // bila melempar, kunci belum tercatat: aman diulang
    _sudah.add(kunci);
    return true;
  }
}

void main() {
  final (ok, buruk) = prosesBatch(['1', 'x', '3']);
  assert(ok.length == 2 && buruk.single == 'x');

  var kirim = 0;
  final p = PemrosesSekali();
  p.jalankan('pesanan-7', () => kirim++);
  p.jalankan('pesanan-7', () => kirim++); // diulang: dilewati
  assert(kirim == 1);
}
```

- `prosesBatch` memilih *best-effort*: semua masukan diproses dan laporan gagal dikumpulkan; keputusan itu ditulis di spesifikasi.
- `PemrosesSekali` mengenali pengulangan lewat kunci; kunci dicatat *setelah* `aksi()` sukses sehingga kegagalan di tengah tetap dapat diulang.
- Catatan: bila `aksi` berhasil sebagian lalu melempar, kunci belum tercatat tetapi sebagian efek sudah terjadi — itulah mengapa `aksi` sendiri idealnya atomik.

### D. Opsi Kode Lain untuk Logika yang Sama

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Menjamin pelepasan satu resource | `try`/`finally` langsung | Sederhana; mudah lupa di banyak tempat |
| Menjamin pelepasan di banyak tempat | Fungsi bracket (`denganBerkas`) | Satu tempat menjamin; pemanggil bersih |
| Banyak resource | Fungsi bracket bersarang; lepas LIFO | Tiap pelepasan dalam penjaga `bersihkanAman` |
| All-or-nothing in-memory | Salin lalu tukar | Murah bila data imutabel |
| All-or-nothing berkas | Berkas sementara + ganti nama (5.5) | Bergantung perilaku sistem berkas |
| Batch | Fail-fast (berhenti pertama) atau best-effort (kumpulkan) | Tulis pilihannya di spesifikasi |

| Operasi | Idempoten? | Catatan |
| --- | --- | --- |
| `status = 'selesai'` | Ya | Hasil akhir sama walau diulang |
| `hapus(id)` | Ya (efek akhir) | Pengulangan tak mengubah keadaan akhir |
| `saldo += 100` | Tidak | Perlu kunci idempotensi bila di-retry |
| Kirim email | Tidak | Tandai terkirim dengan kunci |
| Tambah item ke daftar | Tidak | Hindari retry buta |

### E. Terminologi Esensial

- **Resource** — sesuatu yang harus dilepas. **Fungsi bracket** — fungsi yang membungkus acquire-use-release. **LIFO** — yang terakhir dibuka dilepas pertama.
- **Atomik / all-or-nothing** — seluruh langkah berhasil atau tak satu pun berefek. **Idempoten** — pengulangan tak mengubah hasil akhir. **Kunci idempotensi** — penanda untuk mengenali pengulangan.
- **Kegagalan parsial** — sebagian pekerjaan berhasil, sebagian gagal. **Best-effort** — kerjakan sebanyak mungkin dan laporkan sisanya.

### F. Visualisasi (ASCII)

```text
   acquire ──► try { use } ──► finally { release }
                  │                    ▲
                  └─ throw ────────────┘     (release SELALU berjalan)

   Buka A, buka B, pakai, lepas B, lepas A     (urutan terbalik: LIFO)
```

```text
   state lama ──► salin ──► ubah salinan ──► valid semua? ─ya─► TUKAR (state baru)
       ▲                                        │tidak
       └────────────────────────────────────────┘  (state lama utuh; galat dilaporkan)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 5.2 (`finally`), 4.2 (fungsi bracket sebagai fungsi tingkat tinggi), 3.2 (imutabilitas untuk salin-lalu-tukar), 5.1 (taksonomi).
- **Prasyarat bagi:** 5.5 (penulisan atomik berkas), 5.6 (retry perlu idempotensi), 5.8. **Dikembangkan di:** Fase 7 (membatalkan subscription, menutup `Stream`), Fase 9 (kunci dan berkas sementara yang aman).

### H. Tips & Praktik Terbaik

- Untuk setiap `open`/`acquire`, tulis pasangan `close`/`release` di fungsi bracket yang sama.
- Jaga pembersihan agar tidak melempar; laporkan kegagalannya.
- Validasi seluruh masukan sebelum mengubah state; ubah hanya lewat salin-lalu-tukar bila operasinya multi-langkah.
- Tulis di spesifikasi apakah batch bersifat fail-fast atau best-effort, dan apakah operasinya idempoten.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Lupa menutup resource saat exception | Kebocoran bertahap | `try`/`finally` atau fungsi bracket |
| `throw` di dalam `finally` | Galat asli hilang | `bersihkanAman` yang hanya melapor |
| Mengubah state sebelum validasi lengkap | State setengah-jadi | Kerjakan pada salinan; tukar di akhir |
| Retry operasi non-idempoten | Duplikasi (dua email, dua pembayaran) | Kunci idempotensi atau jangan di-retry |
| Mencatat kunci idempotensi sebelum aksi | Aksi yang gagal dianggap selesai | Catat setelah sukses |
| Batch berhenti diam-diam di tengah | Sebagian data hilang tanpa tanda | Putuskan fail-fast vs best-effort dan laporkan |

### J. Sumber Referensi

- ✔ Error handling dan `finally`: https://dart.dev/language/error-handling
- API `RandomAccessFile`: https://api.dart.dev/stable/dart-io/RandomAccessFile-class.html
- API `Directory.createTempSync`: https://api.dart.dev/stable/dart-io/Directory/createTempSync.html
- Idempotence: https://en.wikipedia.org/wiki/Idempotence
- Atomicity (ACID): https://en.wikipedia.org/wiki/Atomicity\_(database\_systems)

---

## 5.3 Kegagalan sebagai Data: Hasil vs Exception

*Motivasi: kegagalan yang tertulis di tipe tak bisa dilupakan oleh siapa pun — termasuk dirimu enam bulan lagi.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membandingkan dua kanal kegagalan: **exception** (kontrol non-lokal, tak tertulis di tanda tangan) dan **hasil sebagai data** (`Hasil<T, G>` sealed, tertulis di tipe). Kamu membangun `Hasil` dengan operasi komposisi (`petakan`, `rantai`, `lipat`, `ambilAtau`), menerjemahkan exception menjadi hasil di batas sistem, dan belajar kapan memilih yang mana.

### B. Konsep Kunci & Filosofi Mendalam

- **Dua kanal.** Exception bergerak lewat *jalur kontrol* (naik melewati pemanggil); hasil bergerak lewat *jalur nilai kembalian*. Karena semua exception Dart unchecked, tanda tangan fungsi tidak memberi tahu pemanggil bahwa ia bisa gagal. `Hasil` memindahkan fakta itu ke dalam tipe.
- **Hasil memaksa penanganan.** Dengan `sealed class` (2.6), `switch` atas `Hasil` wajib mencakup `Sukses` dan `Gagal`; nilai tak dapat diambil tanpa melewati kasus gagal. Bila tipe galat `G` juga sealed, *jenis* kegagalan pun wajib ditangani lengkap.
- **Kapan memilih `Hasil`:** kegagalan *diharapkan dan sering* (validasi, parsing, aturan domain), ditangani *dekat* pemanggil, memiliki *beberapa varian bermakna*, atau alurnya disusun sebagai pipeline.
- **Kapan memilih exception:** kegagalan *langka dan tak terduga*, tak dapat ditangani di dekat pemanggil dan harus naik jauh, atau pelanggaran kontrak (`Error`, 5.1).
- **Komposisi.** `petakan` mengubah nilai sukses dan membiarkan kegagalan lewat; `rantai` (sering disebut *flatMap*) menyambung langkah yang sendirinya bisa gagal; `lipat` mengubah kedua kemungkinan menjadi satu jenis nilai; `ambilAtau` memberi nilai cadangan. Gagal pertama menghentikan rantai (*railway*).
- **Batas sistem.** Pustaka melempar exception; inti memakai `Hasil`. Sebuah adaptor tipis `tangkap` menerjemahkan exception menjadi `Gagal` di tepi (5.5). Jangan menangkap `Error` di adaptor.
- **Satu konvensi per lapisan.** Mencampur gaya di lapisan yang sama membuat pembaca tak tahu apa yang harus ditangkap dan apa yang harus dicocokkan.
- **Biaya.** `Hasil` mengalokasikan objek kecil dan menambah boilerplate; bila *setiap* fungsi mengembalikannya, jalur sukses tertutup upacara. Pakai di fungsi yang memang punya kegagalan wajar. Nilai `null` tetap cocok untuk *tidak ada* tanpa alasan penting.
- **Filosofi:** jadikan jalur gagal *warga kelas satu* di tipe, bukan kejutan di runtime.
- **Dampak desain:** hasil menaikkan kejujuran API dan memudahkan tes (tak perlu `throwsA`), tetapi menuntut disiplin menjaga satu konvensi dan menerjemahkan di batas.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — `Hasil<T, G>` sealed dengan operasi komposisi.**

```dart
sealed class Hasil<T, G> {
  const Hasil();

  /// Mengubah kedua kemungkinan menjadi satu jenis nilai.
  R lipat<R>({
    required R Function(T nilai) sukses,
    required R Function(G galat) gagal,
  }) =>
      switch (this) {
        Sukses<T, G>(:final nilai) => sukses(nilai),
        Gagal<T, G>(:final galat) => gagal(galat),
      };

  /// Mengubah nilai sukses; kegagalan lewat tanpa berubah.
  Hasil<U, G> petakan<U>(U Function(T nilai) f) => switch (this) {
        Sukses<T, G>(:final nilai) => Sukses(f(nilai)),
        Gagal<T, G>(:final galat) => Gagal(galat),
      };

  /// Menyambung langkah yang sendirinya dapat gagal.
  Hasil<U, G> rantai<U>(Hasil<U, G> Function(T nilai) f) => switch (this) {
        Sukses<T, G>(:final nilai) => f(nilai),
        Gagal<T, G>(:final galat) => Gagal(galat),
      };

  T ambilAtau(T cadangan) => switch (this) {
        Sukses<T, G>(:final nilai) => nilai,
        Gagal<T, G>() => cadangan,
      };
}

class Sukses<T, G> extends Hasil<T, G> {
  const Sukses(this.nilai);
  final T nilai;
}

class Gagal<T, G> extends Hasil<T, G> {
  const Gagal(this.galat);
  final G galat;
}
```

- `Hasil<T, G>` — dua parameter tipe: `T` untuk nilai sukses, `G` untuk tipe galat.
- `switch (this)` di dalam class sealed — kelengkapan diperiksa kompilator; tak ada `_`.
- `lipat` menerima dua fungsi bernama `required`: pemanggil *wajib* menyediakan kedua jalur.
- `petakan` dan `rantai` meneruskan `Gagal` apa adanya sehingga satu kegagalan menghentikan seluruh rangkaian.

**Contoh 2 — tipe galat sealed, sehingga jenis kegagalan wajib ditangani lengkap.**

```dart
sealed class GalatUmur {
  const GalatUmur();
}

class BukanAngka extends GalatUmur {
  const BukanAngka(this.teks);
  final String teks;
}

class DiLuarRentang extends GalatUmur {
  const DiLuarRentang(this.nilai);
  final int nilai;
}

class BelumDewasa extends GalatUmur {
  const BelumDewasa(this.umur);
  final int umur;
}

Hasil<int, GalatUmur> parseUmur(String teks) {
  final n = int.tryParse(teks.trim());
  if (n == null) return Gagal(BukanAngka(teks));
  if (n < 0 || n > 150) return Gagal(DiLuarRentang(n));
  return Sukses(n);
}

Hasil<int, GalatUmur> wajibDewasa(int umur) =>
    umur >= 18 ? Sukses(umur) : Gagal(BelumDewasa(umur));

String pesan(GalatUmur g) => switch (g) {
      BukanAngka(:final teks) => 'bukan angka: $teks',
      DiLuarRentang(:final nilai) => 'di luar rentang 0..150: $nilai',
      BelumDewasa(:final umur) => 'belum dewasa: $umur',
    };
```

- `int.tryParse` mengembalikan `null` untuk teks yang bukan angka — kegagalan yang diharapkan, jadi tak ada exception.
- Menambah varian `GalatUmur` baru langsung membuat `pesan` gagal dikompilasi sampai ditangani.
- Guard clause (modul 1.6) tetap dipakai di dalam fungsi; yang berubah hanya *apa yang dikembalikan*.

**Contoh 3 — komposisi: pipeline tanpa satu pun `try`.**

```dart
Hasil<int, GalatUmur> daftar(String teks) =>
    parseUmur(teks).rantai(wajibDewasa);

void main() {
  assert(parseUmur('27').petakan((u) => u + 1).ambilAtau(0) == 28);
  assert(parseUmur('abc').petakan((u) => u + 1).ambilAtau(0) == 0);

  String laporan(String teks) =>
      daftar(teks).lipat(sukses: (u) => 'terdaftar, umur $u', gagal: pesan);

  assert(laporan('20') == 'terdaftar, umur 20');
  assert(laporan('15') == 'belum dewasa: 15');
  assert(laporan('x') == 'bukan angka: x');
  assert(laporan('200') == 'di luar rentang 0..150: 200');
}
```

- `parseUmur(teks).rantai(wajibDewasa)` — langkah kedua hanya berjalan bila langkah pertama sukses; kegagalan pertama menentukan hasil akhir.
- `lipat(sukses: ..., gagal: pesan)` — `gagal: pesan` adalah *tear-off* fungsi `String Function(GalatUmur)` (4.2).
- Empat masukan, empat hasil yang berbeda, satu pipeline.

**Contoh 4 — adaptor di batas: exception menjadi `Hasil`.**

```dart
Hasil<T, Exception> tangkap<T>(T Function() aksi) {
  try {
    return Sukses(aksi());
  } on Exception catch (e) {
    return Gagal(e); // Error TIDAK ditangkap: bug harus tetap terlihat
  }
}

void main() {
  final ok = tangkap(() => int.parse('42'));
  final gagal = tangkap(() => int.parse('abc'));
  assert(ok is Sukses<int, Exception>);
  assert(gagal is Gagal<int, Exception>);
  assert(gagal.lipat(sukses: (_) => '', gagal: (e) => e.runtimeType.toString()) == 'FormatException');
}
```

- `on Exception` — hanya kegagalan wajar yang diterjemahkan; `Error` melewati adaptor, sesuai taksonomi 5.1.
- Ini jembatan: pustaka yang melempar exception tetap dapat dipakai oleh inti yang berbicara `Hasil`.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// 1) Nullable: paling sederhana, tetapi alasan gagal hilang.
int? umurAtauNull(String teks) => int.tryParse(teks.trim());

// 2) Exception: ringkas untuk jalur sukses; kegagalan tak tertulis di tipe.
int umurLempar(String teks) =>
    int.tryParse(teks.trim()) ?? (throw FormatException('bukan angka', teks));

// 3) Record (T?, G?): HINDARI - dua nullable memungkinkan kombinasi ilegal (3.5).
(int?, String?) umurRecord(String teks) => (int.tryParse(teks), null);
```

| Pendekatan | Alasan gagal terlihat di tipe? | Pemanggil dipaksa menangani? | Pilih bila |
| --- | --- | --- | --- |
| `T?` | Tidak (hanya *ada/tidak*) | Ya (null safety) | Tidak ada tanpa alasan penting |
| Exception | Tidak | Tidak | Kegagalan langka dan tak terduga; `Error` |
| `Hasil<T, G>` sealed | Ya | Ya (exhaustive) | Kegagalan wajar, sering, dengan beberapa varian |
| Record `(T?, G?)` | Parsial | Tidak | Hindari |
| Paket Result pihak ketiga | Ya | Ya | Bila ingin API siap pakai; menulis sendiri ±30 baris sering cukup |

### E. Terminologi Esensial

- **Hasil / Result / Either** — tipe jumlah yang berisi sukses atau gagal. **Railway-oriented** — rangkaian langkah yang berhenti di kegagalan pertama.
- **`petakan` (map) / `rantai` (flatMap, andThen) / `lipat` (fold)** — transformasi nilai / penyambungan langkah yang bisa gagal / pengubahan dua kemungkinan menjadi satu.
- **Adaptor batas** — fungsi yang menerjemahkan exception menjadi hasil. **Kegagalan wajar** — kegagalan yang diharapkan dalam operasi normal.

### F. Visualisasi (ASCII)

```text
  parseUmur ──► wajibDewasa ──► petakan ──► lipat
      │             │             │          │
   Sukses ────────► Sukses ──────► Sukses ───► teks sukses
      │             │
   Gagal ─────────► (dilewati) ──► (dilewati) ──► teks galat      ← satu jalur gagal tunggal
```

```text
  Pustaka melempar Exception ──► tangkap() ──► Hasil ──► inti memakai switch/lipat
          (tepi)                  (adaptor)            (di dalam: tanpa try)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 5.1 (taksonomi), 2.6 (sealed dan exhaustiveness), 3.5 (parse di tepi), 4.2 (tear-off), 1.6 (guard clause).
- **Prasyarat bagi:** 5.5 (adaptor I/O) dan 5.8 (studi kasus). **Dikembangkan di:** Fase 7 (hasil asinkron), Fase 9 (menolak masukan berbahaya sebagai `Gagal`), Fase 10 (test tanpa `throwsA`).

### H. Tips & Praktik Terbaik

- Jadikan tipe galat `sealed` sehingga penanganan jenis kegagalan terbukti lengkap.
- Terjemahkan exception menjadi `Hasil` di batas, bukan di tengah logika.
- Beri tiap varian galat data yang cukup untuk membuat pesan di tepi (teks, nilai, jalur).
- Pakai `Hasil` hanya pada fungsi yang memang punya kegagalan wajar; jalur sukses murni tak perlu pembungkus.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mencampur exception dan `Hasil` di lapisan yang sama | Pembaca bingung apa yang harus ditangkap | Satu konvensi per lapisan; terjemahkan di batas |
| Menangkap `Error` di adaptor | Bug berubah menjadi `Gagal` | `on Exception` saja |
| Tipe galat `String` | Penanganan terarah mustahil | Pakai tipe galat sealed dengan data |
| `Hasil` di setiap fungsi | Jalur sukses penuh boilerplate | Terapkan hanya pada operasi yang bisa gagal wajar |
| Mengambil nilai dengan cast alih-alih `switch`/`lipat` | Melempar saat gagal | Gunakan `lipat`, `ambilAtau`, atau `switch` lengkap |

### J. Sumber Referensi

- ✔ Error handling di Dart: https://dart.dev/language/error-handling
- ✔ Percabangan dan exhaustiveness: https://dart.dev/language/branches · ✔ Class modifiers (`sealed`): https://dart.dev/language/class-modifiers
- Scott Wlaschin, *Railway Oriented Programming*: https://fsharpforfunandprofit.com/rop/
- Algebraic data type: https://en.wikipedia.org/wiki/Algebraic\_data\_type

---

## 5.4 Resource & Pembersihan: finally, All-or-Nothing, Idempotensi

*Motivasi: kegagalan terburuk bukan yang meledak keras, melainkan yang diam-diam meninggalkan kekacauan.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas apa yang terjadi *setelah* sesuatu gagal: **resource** (berkas terbuka, lock, soket) harus dilepas; operasi multi-langkah harus *all-or-nothing* agar tak meninggalkan state setengah-jadi; operasi sebaiknya **idempoten** agar dapat diulang dengan aman; dan kegagalan pada *item* batch harus dilaporkan tanpa membatalkan segalanya bila memang itu kebijakannya.

### B. Konsep Kunci & Filosofi Mendalam

- **Resource** adalah apa pun yang harus dilepas: berkas, soket, lock, timer, langganan (Fase 7). Resource yang bocor adalah kegagalan yang tertunda — sering baru terasa saat sistem sudah lama berjalan.
- **`try/finally` menjamin pelepasan.** Dart tidak punya `using` atau RAII; polanya adalah **fungsi bracket**: *acquire → pakai → release* dibungkus fungsi tingkat tinggi yang menerima closure (4.2), sehingga pelepasan tak dapat terlupa oleh pemanggil.
- **Urutan pelepasan terbalik (LIFO).** Resource yang dibuka terakhir dilepas pertama, mencerminkan ketergantungan antarresource.
- **Pelepasan tak boleh menutupi galat asli.** Bila `finally` melempar exception baru, galat asli hilang. Bungkus pelepasan dalam penanganannya sendiri dan *laporkan*, jangan timpa.
- **All-or-nothing.** Kerjakan operasi pada *salinan* atau *kandidat*, validasi semuanya, lalu **tukar** state sekaligus. Dengan data imutabel (Fase 3) ini hampir gratis: state lama tetap utuh sampai tukar berhasil.
- **Idempotensi.** Operasi idempoten dapat dijalankan berkali-kali dengan efek sama seperti sekali (`setStatus(id, selesai)`); non-idempoten (`tambahSaldo(id, 10)`) berbahaya bila diulang. Idempotensi adalah prasyarat retry yang aman (5.6).
- **Kegagalan parsial pada batch.** Pilih kebijakan secara sadar: *berhenti di kegagalan pertama* (fail-fast, atomik) atau *terus dan laporkan per item* (best-effort). Laporkan hasilnya sebagai data (record atau `Hasil` per item).
- **Filosofi:** setiap `acquire` harus punya `release` yang dijamin, dan setiap perubahan state harus punya jalan mundur yang pasti.
- **Dampak desain:** tanpa fungsi bracket, kebocoran muncul di jalur gagal yang jarang diuji; tanpa all-or-nothing, kegagalan di tengah menghasilkan state yang tak seorang pun pernah rancang.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — fungsi bracket untuk berkas.**

```dart
import 'dart:io';

T denganBerkas<T>(
  String jalur,
  T Function(RandomAccessFile berkas) pakai, {
  FileMode mode = FileMode.read,
}) {
  final berkas = File(jalur).openSync(mode: mode);
  try {
    return pakai(berkas);
  } finally {
    berkas.closeSync(); // dijamin, walau pakai() melempar
  }
}

void main() {
  final dir = Directory.systemTemp.createTempSync('uji_');
  try {
    final jalur = '${dir.path}/a.txt';
    File(jalur).writeAsStringSync('A');
    final pertama = denganBerkas(jalur, (f) => f.readByteSync());
    assert(pertama == 65); // kode ASCII 'A'
  } finally {
    dir.deleteSync(recursive: true);
  }
}
```

- `openSync(mode: ...)` membuka berkas dan mengembalikan `RandomAccessFile`; `closeSync()` melepasnya.
- `try { return pakai(berkas); } finally { berkas.closeSync(); }` — `finally` berjalan juga saat `pakai` melempar atau saat `return` terjadi.
- Pemanggil hanya menulis logika pemakaian; tak mungkin lupa menutup.
- Di `main`, direktori sementara juga dibersihkan lewat `finally` — pola yang sama.

**Contoh 2 — pelepasan tidak boleh menimpa galat asli.**

```dart
abstract interface class Pegangan {
  void gunakan();
  void tutup();
}

void bersihkanAman(
  void Function() bersihkan,
  void Function(Object galat, StackTrace jejak) lapor,
) {
  try {
    bersihkan();
  } on Exception catch (e, s) {
    lapor(e, s); // dilaporkan, TIDAK dilempar: galat asli tetap yang terlihat
  }
}

void pakaiPegangan(Pegangan p, void Function(Object, StackTrace) lapor) {
  try {
    p.gunakan();
  } finally {
    bersihkanAman(p.tutup, lapor);
  }
}

class PeganganPalsu implements Pegangan {
  final catatan = <String>[];

  @override
  void gunakan() {
    catatan.add('gunakan');
    throw StateError('galat asli');
  }

  @override
  void tutup() {
    catatan.add('tutup');
    throw const FileSystemException('galat saat menutup');
  }
}

void main() {
  final p = PeganganPalsu();
  final dilaporkan = <Object>[];
  try {
    pakaiPegangan(p, (e, s) => dilaporkan.add(e));
  } on StateError catch (e) {
    assert(e.message == 'galat asli'); // tidak tertimpa
  }
  assert(p.catatan.join(',') == 'gunakan,tutup' && dilaporkan.length == 1);
}
```

- Tanpa `bersihkanAman`, `tutup()` yang melempar di dalam `finally` akan *menimpa* `StateError('galat asli')`.
- `bersihkanAman` hanya menangkap `Exception`: kegagalan lingkungan saat menutup dilaporkan; bug (`Error`) saat menutup tetap naik.
- `p.tutup` dikirim sebagai *tear-off* (4.2).

**Contoh 3 — all-or-nothing dengan kandidat dan tukar.**

```dart
class KeranjangHarga {
  List<int> _harga = const [];

  List<int> get harga => List.unmodifiable(_harga);

  void tambahSemua(List<int> baru) {
    final kandidat = [..._harga, ...baru]; // kerja pada salinan
    for (final h in kandidat) {
      if (h <= 0) throw ArgumentError.value(h, 'harga', 'harus positif');
    }
    _harga = kandidat; // tukar HANYA setelah semua valid
  }
}

void main() {
  final k = KeranjangHarga()..tambahSemua([100, 200]);
  try {
    k.tambahSemua([300, -1]); // satu item tidak valid
  } on ArgumentError {
    // state tidak berubah sama sekali
  }
  assert(k.harga.toString() == '[100, 200]');
}
```

- `kandidat` adalah list baru; `_harga` tidak tersentuh sampai semua elemen lolos validasi.
- Bila validasi gagal di tengah, tak ada state setengah-jadi: `300` tidak sempat masuk.

**Contoh 4 — kegagalan parsial pada batch: laporan sebagai data.**

```dart
(List<int> berhasil, List<String> gagal) prosesBatch(List<String> masukan) {
  final berhasil = <int>[];
  final gagal = <String>[];
  for (final m in masukan) {
    final n = int.tryParse(m);
    if (n == null) {
      gagal.add(m);
    } else {
      berhasil.add(n);
    }
  }
  return (berhasil, gagal);
}

void main() {
  final (ok, buruk) = prosesBatch(['1', 'x', '3']);
  assert(ok.length == 2 && buruk.single == 'x');
}
```

- Kebijakan di sini *best-effort*: terus walau ada yang gagal, dan melaporkan keduanya. Kebijakan atomik akan membuang semuanya bila satu gagal; keputusan itu harus tertulis di spesifikasi.

### D. Opsi Kode Lain untuk Logika yang Sama

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Menjamin pelepasan | Fungsi bracket (`denganX`) | Pemanggil tak bisa lupa; paling disarankan |
| Menjamin pelepasan satu kali | `try/finally` langsung | Sederhana; mudah terlupa di tempat lain |
| Beberapa resource | Fungsi bracket bersarang (LIFO alami) | Pastikan pelepasan pertama yang gagal tak mencegah pelepasan kedua |
| Operasi multi-langkah | Kandidat + tukar | Mengandalkan data imutabel |
| Batch | Atomik (berhenti pada gagal pertama) atau best-effort (laporan per item) | Pilih sadar dan dokumentasikan |

| Operasi | Idempoten? | Alasan |
| --- | --- | --- |
| `set(kunci, nilai)` | Ya | Hasil akhir sama berapa kali pun |
| `hapus(id)` bila tak ada dianggap sukses | Ya | Keadaan akhir sama |
| `tambahSaldo(id, 10)` | Tidak | Setiap pengulangan menambah lagi |
| `tambah(item)` tanpa kunci unik | Tidak | Menghasilkan duplikat |
| `tambah(item)` dengan kunci unik (set semantik) | Ya | Pengulangan tak mengubah |

### E. Terminologi Esensial

- **Resource leak** — resource tak dilepas. **Fungsi bracket** — membungkus acquire/pakai/release. **LIFO** — terakhir masuk, pertama keluar.
- **All-or-nothing (atomicity)** — seluruh operasi berhasil atau tak berefek sama sekali. **Kandidat** — salinan kerja yang ditukar bila valid.
- **Idempoten** — pengulangan tak mengubah hasil akhir. **Best-effort** — terus dan laporkan kegagalan per item.

### F. Visualisasi (ASCII)

```text
  buka A ──► buka B ──► pakai(A, B)
                              │ (sukses atau gagal)
                              ▼
                         tutup B ──► tutup A        ← LIFO, selalu dijalankan (finally)
```

```text
  state lama ──► kandidat = salinan + perubahan ──► validasi seluruhnya?
       │                                              ├─ gagal → buang kandidat; state lama UTUH
       └──────────────────────────────────────────────┴─ sukses → tukar: state = kandidat
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 4.2 (closure, fungsi bracket, tear-off), 3.2 (imutabilitas sebagai dasar tukar), 5.2 (`finally`), 5.1 (hanya `Exception` yang dilaporkan).
- **Prasyarat bagi:** 5.5 (penulisan atomik berkas), 5.6 (retry butuh idempotensi), 5.8 (studi kasus). **Dikembangkan di:** Fase 7 (pelepasan langganan, timer, dan isolate), Fase 10 (menguji pembersihan di jalur gagal).

### H. Tips & Praktik Terbaik

- Bungkus setiap pasangan acquire/release dalam satu fungsi bracket; jangan menyebar `close()` di pemanggil.
- Jangan biarkan kegagalan saat membersihkan menutupi galat asli; laporkan dan lanjutkan.
- Rancang operasi agar *validasi lebih dulu, perubahan kemudian*, atau agar bekerja pada kandidat yang ditukar.
- Tulis test dengan resource palsu yang gagal saat ditutup untuk membuktikan pembersihan dan urutan LIFO.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Lupa menutup di jalur gagal | Kebocoran handle setelah lama berjalan | Fungsi bracket dengan `finally` |
| `finally` yang melempar menimpa galat asli | Diagnosis menunjuk galat pembersihan, bukan sebabnya | `bersihkanAman` dan laporkan |
| Mengubah state sebelum semua validasi lulus | State setengah-jadi saat gagal | Kandidat + tukar |
| Retry operasi non-idempoten | Duplikasi atau saldo ganda | Jadikan idempoten atau jangan di-retry |
| Menelan kegagalan item batch diam-diam | Data hilang tanpa tanda | Laporkan hasil per item |

### J. Sumber Referensi

- ✔ Error handling di Dart (`finally`): https://dart.dev/language/error-handling
- API `RandomAccessFile`: https://api.dart.dev/stable/dart-io/RandomAccessFile-class.html
- API `File.openSync`: https://api.dart.dev/stable/dart-io/File/openSync.html
- Idempotence: https://en.wikipedia.org/wiki/Idempotence
- Atomicity (ACID): https://en.wikipedia.org/wiki/Atomicity\_(database\_systems)

---

## 5.5 Kegagalan I/O dan Dunia Luar

*Motivasi: dunia luar tidak berutang apa pun pada programmu — berkas bisa hilang, disk bisa penuh, dan listrik bisa mati kapan saja.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas kegagalan lingkungan pada I/O berkas: jenis galat `dart:io`, mengapa *melakukan lalu menangani* lebih aman daripada *memeriksa lalu melakukan*, penerjemahan galat di batas, **penulisan atomik** (berkas sementara lalu ganti nama), penanganan **data rusak**, dan **kode keluar** yang bermakna untuk program terminal. Ia memperbaiki hal-hal yang sengaja ditunda di Fase 4.8.

### B. Konsep Kunci & Filosofi Mendalam

- **Kegagalan I/O adalah kelas *lingkungan*** (5.1): berkas tak ada, izin ditolak, disk penuh, jalur ternyata direktori, berkas terkunci. Semuanya dapat terjadi pada program yang kodenya benar.
- **Galat `dart:io`.** `IOException` adalah penanda untuk galat I/O; `FileSystemException` membawa `message`, `path`, dan `osError`; `PathNotFoundException` adalah subtipe untuk *jalur tidak ada*; `OSError` memuat `errorCode` dan pesan dari sistem operasi — **kodenya spesifik platform**, jadi jangan bergantung padanya di banyak tempat; kurung di satu adaptor yang terdokumentasi.
- **EAFP vs LBYL.** *Easier to Ask Forgiveness than Permission*: lakukan operasinya dan tangani kegagalan. *Look Before You Leap*: periksa dulu (`existsSync()`), lalu lakukan. LBYL rawan **cek-lalu-pakai (TOCTOU)**: keadaan dapat berubah di antara pemeriksaan dan pemakaian, sehingga kegagalan tetap harus ditangani. Pakai `existsSync()` hanya untuk petunjuk, bukan untuk keputusan.
- **Terjemahkan di batas.** Adaptor (`PenyimpanBerkas`) mengubah `FileSystemException` menjadi galat domain (`GagalBaca`, `GagalTulis`) *dengan penyebab dan stack trace asli* (5.2); inti tak perlu tahu tentang `dart:io`.
- **Penulisan atomik.** Tulis ke berkas sementara di **direktori yang sama** dengan `flush: true`, lalu `renameSync` ke tujuan. Kegagalan terburuk adalah sisa berkas sementara, sementara dokumen lama tetap utuh. Catatan: `flush` meminta data ditulis ke penyimpanan, tetapi ketahanan terhadap mati listrik bergantung pada sistem berkas; atomisitas rename terjadi dalam satu sistem berkas; dan menimpa berkas yang sudah ada lewat rename berperilaku berbeda di Windows (sebagian pustaka menghapus tujuan lalu rename, yang melemahkan atomisitas) — uji di platform targetmu.
- **Data rusak.** Berkas bisa terpotong, berisi JSON tak valid, atau bytes UTF-8 tak sah. Baca dengan decoder yang toleran (`Utf8Codec(allowMalformed: true)`) lalu **validasi saat dekode** (parse, don't validate). **Jangan menimpa data rusak diam-diam**: cadangkan dulu, lalu mulai dari default *dengan peringatan*, atau berhenti dengan kode keluar `65`.
- **Format berversi.** Simpan field `versi` agar migrasi dimungkinkan, dan tolak versi tak dikenal secara eksplisit.
- **Kode keluar.** Konvensi `sysexits`: `0` sukses; `64` pemakaian salah; `65` data rusak; `66` masukan tak ada; `70` bug internal; `73` tak dapat membuat berkas keluaran; `74` galat I/O; `75` gagal sementara. Setel `exitCode` dan biarkan `main` selesai; `exit(n)` menghentikan proses *seketika*, tanpa menjalankan blok `finally` yang tertunda.
- **Filosofi:** I/O adalah *negosiasi* dengan dunia yang tak kamu kendalikan; rancang agar kegagalan tertata, bukan mengejutkan.
- **Dampak desain:** adaptor yang menerjemahkan membuat inti bebas dari `dart:io` dan mudah diuji dengan fake; penulisan atomik membuat "mati di tengah menulis" tidak merusak data.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — galat domain dan pembacaan EAFP.**

```dart
import 'dart:convert';
import 'dart:io';

sealed class GagalSimpan implements Exception {
  const GagalSimpan(this.jalur, this.penyebab);
  final String jalur;
  final Object? penyebab;

  @override
  String toString() => '$runtimeType($jalur, penyebab: $penyebab)';
}

class GagalBaca extends GagalSimpan {
  const GagalBaca(super.jalur, super.penyebab);
}

class GagalTulis extends GagalSimpan {
  const GagalTulis(super.jalur, super.penyebab);
}

/// Mengembalikan null bila berkas belum ada (keadaan wajar).
String? bacaTeks(String jalur) {
  try {
    return File(jalur).readAsStringSync(
      encoding: const Utf8Codec(allowMalformed: true),
    );
  } on PathNotFoundException {
    return null;
  } on FileSystemException catch (e, s) {
    Error.throwWithStackTrace(GagalBaca(jalur, e), s);
  }
}
```

- Tidak ada `existsSync()`: kita *membaca* dan menangani `PathNotFoundException`. Tak ada celah antara "cek" dan "pakai".
- `on PathNotFoundException` sebelum `on FileSystemException` — subtipe lebih dulu; "tidak ada" dianggap keadaan wajar (`null`), kegagalan lain diterjemahkan.
- `Utf8Codec(allowMalformed: true)` — byte tak sah diganti karakter pengganti sehingga kerusakan terdeteksi pada tahap dekode data, bukan sebagai kegagalan baca.
- `Error.throwWithStackTrace(GagalBaca(jalur, e), s)` — galat domain dengan penyebab dan jejak asli.

**Contoh 2 — penulisan atomik.**

```dart
void tulisAtomik(String jalur, String isi) {
  final sementara = File('$jalur.tmp');
  try {
    sementara.writeAsStringSync(isi, flush: true);
    sementara.renameSync(jalur);
  } on FileSystemException catch (e, s) {
    try {
      if (sementara.existsSync()) sementara.deleteSync();
    } on FileSystemException {
      // pembersihan gagal tak boleh menutupi galat asli (modul 5.4)
    }
    Error.throwWithStackTrace(GagalTulis(jalur, e), s);
  }
}

void main() {
  final dir = Directory.systemTemp.createTempSync('simpan_');
  try {
    final jalur = '${dir.path}/data.txt';
    assert(bacaTeks(jalur) == null); // belum ada: wajar
    tulisAtomik(jalur, 'halo');
    assert(bacaTeks(jalur) == 'halo');
    tulisAtomik(jalur, 'dunia');
    assert(bacaTeks(jalur) == 'dunia');
    assert(!File('$jalur.tmp').existsSync()); // tak ada sisa sementara

    var gagal = false;
    try {
      tulisAtomik('${dir.path}/tidak/ada/data.txt', 'x'); // direktori tak ada
    } on GagalTulis {
      gagal = true;
    }
    assert(gagal);
  } finally {
    dir.deleteSync(recursive: true);
  }
}
```

- `writeAsStringSync(isi, flush: true)` — menulis ke `data.txt.tmp` dan meminta data dituntaskan ke penyimpanan sebelum langkah berikutnya.
- `renameSync(jalur)` — mengganti tujuan; dalam satu sistem berkas, pembaca melihat berkas lama utuh atau berkas baru utuh, tidak setengah-setengah.
- Jalur gagal: sisa `.tmp` dihapus *bila bisa*, kegagalan penghapusan ditelan dengan sadar, dan galat asli diterjemahkan menjadi `GagalTulis`.
- `'$jalur.tmp'` — interpolasi `$jalur` diikuti teks `.tmp`.

**Contoh 3 — kode keluar sebagai enum, dan penerjemahan di `main`.**

```dart
import 'dart:io';

enum KodeKeluar {
  sukses(0),
  pemakaian(64), // EX_USAGE: argumen salah
  dataRusak(65), // EX_DATAERR
  tidakAdaMasukan(66), // EX_NOINPUT
  bugInternal(70), // EX_SOFTWARE
  gagalIo(74), // EX_IOERR
  sementara(75); // EX_TEMPFAIL

  const KodeKeluar(this.nilai);
  final int nilai;
}

// Simulasi aplikasi yang gagal menulis.
void jalankanAplikasi(List<String> args) =>
    throw const GagalTulis('data.txt', 'simulasi');

void main(List<String> args) {
  try {
    jalankanAplikasi(args);
  } on GagalSimpan catch (e) {
    stderr.writeln('galat penyimpanan: ${e.jalur}');
    exitCode = KodeKeluar.gagalIo.nilai; // biarkan main selesai; jangan exit() mendadak
  }
}
```

- `enum KodeKeluar` dengan nilai angka: nama bermakna di kode, angka baku di proses.
- `exitCode = ...` — menetapkan kode keluar proses; `main` selesai normal sehingga blok `finally` di bawahnya berjalan.
- Pola ini menjadikan terminal tahu *jenis* kegagalan (berguna untuk skrip shell dan CI).

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// LBYL: tampak aman, tetapi ada celah antara cek dan pakai.
String? bacaLbyl(String jalur) {
  final f = File(jalur);
  if (!f.existsSync()) return null; // berkas bisa hilang tepat setelah baris ini
  return f.readAsStringSync(); // tetap bisa melempar
}
```

| Pendekatan | Kelebihan | Kekurangan |
| --- | --- | --- |
| EAFP (lakukan, tangani) | Tanpa celah TOCTOU; satu tempat penanganan | Perlu `on` yang tepat |
| LBYL (`existsSync` dulu) | Terbaca intuitif; berguna untuk petunjuk | Celah cek-lalu-pakai; tetap perlu `try` |
| Tulis langsung ke tujuan | Paling sederhana | Mati di tengah menulis merusak berkas |
| Berkas sementara + rename | Dokumen lama tetap utuh bila gagal | Sisa `.tmp`; perilaku rename beda per platform |
| API asinkron (`readAsString`) | Tak memblokir isolate | Perlu `Future` (Fase 7) |
| `package:file` (sistem berkas memori) | Test I/O tanpa disk nyata | Dependensi tambahan |

### E. Terminologi Esensial

- **TOCTOU** — *time-of-check to time-of-use*: celah antara pemeriksaan dan pemakaian. **EAFP / LBYL** — lakukan lalu tangani / periksa lalu lakukan.
- **Penulisan atomik** — berkas berubah sepenuhnya atau tidak sama sekali. **Berkas sementara** — tempat menulis sebelum diganti nama.
- **`OSError` / `errorCode`** — galat dari sistem operasi, spesifik platform. **Kode keluar** — angka status proses (0 = sukses). **`sysexits`** — konvensi kode keluar dari BSD.

### F. Visualisasi (ASCII)

```text
   tulis data.txt.tmp (flush) ──► rename ke data.txt

   gagal sebelum rename  →  data.txt LAMA utuh, sisa .tmp (dibersihkan bila bisa)
   gagal saat rename     →  data.txt LAMA utuh (rename tidak setengah-jadi dalam satu sistem berkas)
   sukses                →  data.txt BARU utuh
```

```text
   FileSystemException (dart:io)
          │  adaptor PenyimpanBerkas  (terjemahkan; simpan penyebab + jejak)
          ▼
   GagalBaca / GagalTulis  (galat domain; inti tak tahu dart:io)
          │  main (tepi)
          ▼
   pesan untuk pengguna (stderr)  +  exitCode = KodeKeluar.gagalIo  (74)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 5.1 (kegagalan lingkungan), 5.2 (menerjemahkan dengan penyebab dan jejak), 5.4 (pembersihan tak menutupi galat asli), 4.8 (antarmuka `Penyimpan`).
- **Prasyarat bagi:** 5.8 (To-Do v4). **Dikembangkan di:** Fase 7 (I/O asinkron), Fase 9 (jalur berkas tak tepercaya, izin berkas, berkas sementara yang aman), Fase 10 (menguji dengan injeksi kegagalan).

### H. Tips & Praktik Terbaik

- Lakukan operasinya dan tangani kegagalannya; gunakan `existsSync()` hanya untuk petunjuk.
- Terjemahkan galat `dart:io` di satu adaptor; jangan biarkan `FileSystemException` merembes ke inti.
- Tulis ke berkas sementara di direktori yang sama, lalu ganti nama; bersihkan sisa bila gagal.
- Jangan pernah menimpa data yang gagal didekode tanpa mencadangkannya dan memberi tahu pengguna.
- Pilih kode keluar yang bermakna; setel `exitCode` alih-alih `exit()` mendadak.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| `existsSync()` lalu baca tanpa `try` | Crash saat berkas lenyap di antaranya | EAFP: baca dan tangani |
| Menulis langsung ke berkas tujuan | Berkas terpotong bila proses mati | Tulis sementara + rename |
| Bergantung pada `osError.errorCode` di banyak tempat | Kode tak portabel | Konsentrasikan di satu adaptor; pakai subtipe bila ada |
| Menimpa data rusak dengan data kosong | Data pengguna hilang selamanya | Cadangkan dulu; beri peringatan |
| Menelan `GagalTulis` | Pengguna mengira data tersimpan | Laporkan dan pertahankan state lama |
| `exit(1)` di tengah program | `finally` tertunda tak berjalan | Setel `exitCode`; biarkan `main` selesai |
| Semua kegagalan memakai kode keluar 1 | Skrip tak bisa membedakan penyebab | Pakai konvensi `sysexits` |

### J. Sumber Referensi

- API `FileSystemException`: https://api.dart.dev/stable/dart-io/FileSystemException-class.html · API `PathNotFoundException`: https://api.dart.dev/stable/dart-io/PathNotFoundException-class.html
- API `OSError`: https://api.dart.dev/stable/dart-io/OSError-class.html · API `exitCode`: https://api.dart.dev/stable/dart-io/exitCode.html · API `exit`: https://api.dart.dev/stable/dart-io/exit.html
- API `File.writeAsStringSync`: https://api.dart.dev/stable/dart-io/File/writeAsStringSync.html · API `File.renameSync`: https://api.dart.dev/stable/dart-io/File/renameSync.html
- Konvensi kode keluar `sysexits`: https://man.freebsd.org/cgi/man.cgi?query=sysexits
- TOCTOU: https://en.wikipedia.org/wiki/Time-of-check\_to\_time-of-use
- Paket `file`: https://pub.dev/packages/file

---

## 5.6 Ketahanan: Retry, Backoff, Jitter, dan Idempotensi

*Motivasi: ketahanan bukan berarti tidak pernah gagal, melainkan gagal dengan cara yang bisa dipulihkan.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas cara mengulang operasi yang gagal **tanpa memperburuk keadaan**: membedakan kegagalan *transien* dari *permanen*, **backoff eksponensial** dengan **jitter**, batas jumlah percobaan, serta syarat **idempotensi** (5.4). Dibahas juga cara membuat retry *dapat diuji tanpa menunggu* dengan menyuntikkan fungsi tidur dan sumber acak (4.7).

### B. Konsep Kunci & Filosofi Mendalam

- **Transien vs permanen.** Transien: mungkin berhasil bila diulang (berkas terkunci sesaat, jaringan putus sebentar, kode `75`). Permanen: pasti gagal lagi (izin ditolak, format salah). **Mengulang kegagalan permanen hanya membuang waktu dan menambah beban.**
- **Hanya `Exception`, tidak `Error`.** Bug (`Error`) tidak boleh diulang; retry yang menangkap `Error` menyembunyikan cacat kode (5.1).
- **Backoff eksponensial.** Jeda antar percobaan digandakan tiap kali (100 ms, 200 ms, 400 ms, ...) dengan batas maksimum, agar sistem yang sedang kewalahan diberi waktu pulih.
- **Jitter.** Menambah keacakan pada jeda (mis. tidur acak antara 0 dan jeda saat ini) sehingga banyak klien yang gagal bersamaan tidak mencoba ulang serempak (*thundering herd*).
- **Batas.** Selalu tetapkan jumlah percobaan maksimum, dan bila perlu *tenggat total*. Retry tanpa batas adalah kegagalan yang berpura-pura sabar.
- **Idempotensi sebagai syarat.** Retry operasi non-idempoten dapat menggandakan efek (dua pembayaran). Pastikan operasinya idempoten atau beri kunci idempotensi (5.4).
- **Retry hanya di satu lapisan.** Bila tiga lapisan masing-masing mencoba tiga kali, satu kegagalan menjadi sembilan (atau dua puluh tujuh) percobaan ke lapisan paling bawah. Tetapkan satu pemilik retry.
- **Testabilitas lewat injeksi.** Terima `tidur` (fungsi) dan `Random` sebagai parameter sehingga test berjalan seketika dan deterministik; bawaannya memakai `sleep` nyata.
- **Circuit breaker (konsep).** Setelah banyak kegagalan beruntun, berhenti mencoba sesaat dan gagal cepat; mencegah membanjiri layanan yang sedang rusak. Dibahas lebih lanjut di Fase 7 dan 11.
- **Timeout.** Operasi sinkron tak dapat diinterupsi; timeout dan pembatalan yang sebenarnya memerlukan `Future` (Fase 7).
- **Filosofi:** retry adalah *taruhan terukur* bahwa kegagalan sementara; kamu harus tahu taruhanmu (batas, jeda, idempotensi).
- **Dampak desain:** retry tanpa backoff dapat menjadi serangan terhadap layanan sendiri; retry tanpa idempotensi menciptakan data ganda; retry tanpa klasifikasi menyamarkan bug.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — `ulangi` dengan backoff, jitter, dan injeksi.**

```dart
import 'dart:io';
import 'dart:math';

void _tidurNyata(Duration d) => sleep(d);

T ulangi<T>(
  T Function() aksi, {
  required bool Function(Object galat) bisaDiulang,
  int maksPercobaan = 4,
  Duration jedaAwal = const Duration(milliseconds: 100),
  Duration jedaMaks = const Duration(seconds: 5),
  void Function(Duration) tidur = _tidurNyata,
  Random? acak,
}) {
  if (maksPercobaan < 1) {
    throw ArgumentError.value(maksPercobaan, 'maksPercobaan', 'harus >= 1');
  }
  final r = acak ?? Random();
  var jeda = jedaAwal;
  for (var percobaan = 1;; percobaan++) {
    try {
      return aksi();
    } on Exception catch (e) {
      if (percobaan >= maksPercobaan || !bisaDiulang(e)) rethrow;
      tidur(Duration(milliseconds: r.nextInt(jeda.inMilliseconds + 1))); // jitter
      final dua = jeda * 2;
      jeda = dua > jedaMaks ? jedaMaks : dua; // backoff eksponensial dengan batas
    }
  }
}
```

- `bisaDiulang` — predikat yang memutuskan transien atau permanen; pemanggil yang tahu domain-nya.
- `on Exception catch (e)` — hanya kegagalan wajar yang dipertimbangkan; `Error` (bug) langsung naik tanpa diulang.
- `if (percobaan >= maksPercobaan || !bisaDiulang(e)) rethrow;` — percobaan habis atau galat permanen: lempar ulang dengan jejak asli.
- `r.nextInt(jeda.inMilliseconds + 1)` — jitter *penuh*: tidur acak antara 0 dan jeda saat ini.
- `tidur` dan `acak` — titik injeksi; di test diganti agar tak ada penantian nyata.
- `for (var percobaan = 1;; percobaan++)` — loop tanpa syarat berhenti; keluarnya hanya lewat `return` atau `rethrow`.

**Contoh 2 — menguji retry tanpa menunggu.**

```dart
void main() {
  // Transien: gagal dua kali, berhasil pada percobaan ketiga.
  var panggilan = 0;
  final tidurLog = <Duration>[];
  final hasil = ulangi<int>(
    () {
      panggilan++;
      if (panggilan < 3) throw const FileSystemException('terkunci');
      return 42;
    },
    bisaDiulang: (e) => e is FileSystemException,
    tidur: tidurLog.add,
    acak: Random(1),
  );
  assert(hasil == 42 && panggilan == 3 && tidurLog.length == 2);

  // Permanen: tidak diulang sama sekali.
  var coba1 = 0;
  var tertangkap1 = false;
  try {
    ulangi<void>(
      () {
        coba1++;
        throw const FormatException('permanen');
      },
      bisaDiulang: (e) => e is FileSystemException,
      tidur: (_) {},
    );
  } on FormatException {
    tertangkap1 = true;
  }
  assert(tertangkap1 && coba1 == 1);

  // Bug (Error): tidak pernah diulang, apa pun predikatnya.
  var coba2 = 0;
  var tertangkap2 = false;
  try {
    ulangi<void>(
      () {
        coba2++;
        throw StateError('bug');
      },
      bisaDiulang: (_) => true,
      tidur: (_) {},
    );
  } on StateError {
    tertangkap2 = true;
  }
  assert(tertangkap2 && coba2 == 1);
}
```

- `tidur: tidurLog.add` — tear-off `List.add` sebagai fungsi tidur palsu: mencatat jeda tanpa menunggu.
- Tiga skenario: transien berhasil setelah dua kali gagal; permanen langsung dilempar; `StateError` (bug) tidak diulang walau predikat selalu `true`.
- Pengujian ini berjalan dalam milidetik karena tidak ada `sleep` nyata.

**Contoh 3 — jadwal jeda dan batas.**

| Percobaan yang gagal | Batas atas jeda sebelum percobaan berikutnya | Catatan |
| --- | --- | --- |
| 1 | 0–100 ms | Jeda acak penuh (jitter) |
| 2 | 0–200 ms | Digandakan |
| 3 | 0–400 ms | Digandakan |
| 4 (bila `maksPercobaan` > 4) | 0–800 ms | Dan seterusnya sampai `jedaMaks` |
| Setelah `maksPercobaan` | — | Galat terakhir dilempar ke pemanggil |

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Retry tanpa backoff dan tanpa batas — ANTI-POLA:
T ulangiBuruk<T>(T Function() aksi) {
  while (true) {
    try {
      return aksi();
    } catch (_) {
      // mengulang selamanya, menangkap Error juga, tanpa jeda
    }
  }
}
```

| Pendekatan | Kelebihan | Kekurangan |
| --- | --- | --- |
| Tanpa retry | Sederhana; gagal cepat | Kegagalan transien jadi kegagalan permanen bagi pengguna |
| Retry tetap (jeda sama) | Mudah dipahami | Banyak klien mengulang serempak; tak memberi waktu pulih |
| Backoff eksponensial + jitter | Memberi waktu pulih; menyebar beban | Perlu batas dan parameter |
| Circuit breaker | Melindungi layanan yang rusak | Lebih kompleks; perlu state |
| Antrian dan proses ulang (di luar program) | Tahan terhadap mati proses | Infrastruktur tambahan |

### E. Terminologi Esensial

- **Transien / permanen** — mungkin berhasil bila diulang / pasti gagal lagi. **Backoff eksponensial** — jeda berlipat tiap percobaan. **Jitter** — keacakan pada jeda.
- **Thundering herd** — banyak klien mencoba ulang serempak. **Idempoten** — pengulangan tak mengubah hasil akhir. **Circuit breaker** — berhenti mencoba sementara setelah kegagalan beruntun.
- **Titik injeksi** — parameter yang memungkinkan test mengganti perilaku (tidur, acak).

### F. Visualisasi (ASCII)

```text
   percobaan 1 ── gagal ── tidur U(0,100ms) ──► percobaan 2 ── gagal ── tidur U(0,200ms) ──► ...
                                                                         │
   berhasil ◄─────────────────────────────────────────────────────────────┤
   permanen / Error / percobaan habis ──► LEMPAR (rethrow, jejak asli)
```

```text
   Perlu retry?
    ├─ galat adalah Error (bug)?          → TIDAK (perbaiki kode)
    ├─ galat permanen (izin, format)?     → TIDAK (laporkan)
    ├─ operasi idempoten (atau berkunci)? → tidak → JANGAN retry buta
    └─ transien + idempoten               → retry dengan backoff + jitter + batas
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 5.1 (transien vs permanen), 5.4 (idempotensi), 4.2 dan 4.7 (fungsi sebagai parameter untuk injeksi), 1.2 (waktu dan acak sebagai input tersembunyi).
- **Prasyarat bagi:** 5.8. **Dikembangkan di:** Fase 7 (timeout dan pembatalan asinkron, `Future.delayed`), Fase 10 (menguji dengan injeksi kegagalan), Fase 11 (kebijakan retry di batas modul).

### H. Tips & Praktik Terbaik

- Tentukan satu lapisan sebagai pemilik retry; lapisan lain meneruskan kegagalan.
- Selalu beri batas percobaan dan batas jeda; tulis angkanya sebagai konstanta bernama.
- Suntikkan `tidur` dan `Random` agar test cepat dan deterministik.
- Catat tiap percobaan ulang (5.7) agar kegagalan beruntun terlihat di log.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Retry tanpa batas | Program menggantung | `maksPercobaan` dan tenggat total |
| Retry tanpa jeda | Membanjiri sistem yang sedang pulih | Backoff + jitter |
| Mengulang kegagalan permanen | Waktu terbuang, log penuh | Predikat `bisaDiulang` yang tepat |
| Mengulang operasi non-idempoten | Efek ganda | Kunci idempotensi atau jangan di-retry |
| Menangkap `Error` di retry | Bug tersembunyi | `on Exception` saja |
| Retry di banyak lapisan | Percobaan berlipat ganda | Satu pemilik retry |
| Tidur nyata di test | Test lambat dan rapuh | Injeksi fungsi `tidur` |

### J. Sumber Referensi

- Marc Brooker, *Timeouts, retries, and backoff with jitter* (AWS Builders' Library): https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/
- Martin Fowler, *Circuit Breaker*: https://martinfowler.com/bliki/CircuitBreaker.html
- Exponential backoff: https://en.wikipedia.org/wiki/Exponential\_backoff
- API `sleep` (`dart:io`): https://api.dart.dev/stable/dart-io/sleep.html · API `Random` (`dart:math`): https://api.dart.dev/stable/dart-math/Random-class.html

---

## 5.5 Kegagalan I/O dan Dunia Luar: Galat dart:io, Penulisan Atomik, Kode Keluar

*Motivasi: dunia luar tidak pernah berjanji akan bekerja — kodemu harus berjanji akan tetap benar saat ia gagal.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini menangani kegagalan dari dunia luar lewat `dart:io`: jenis exception (`FileSystemException`, `PathNotFoundException`, `OSError`), prinsip **coba-lalu-tangani** dibanding **cek-lalu-pakai**, penulisan berkas yang **atomik** (tulis ke berkas sementara lalu `rename`), penerjemahan galat ke tipe domain di batas, **data rusak**, dan **kode keluar** proses yang bermakna untuk alat berbasis terminal. Modul ini melunasi janji dari Fase 4.8.

### B. Konsep Kunci & Filosofi Mendalam

- **Hierarki galat I/O.** `IOException` adalah penanda untuk kegagalan I/O. `FileSystemException` membawa `message`, `path`, dan `osError`; `PathNotFoundException` adalah subtipenya untuk jalur yang tak ada. `OSError` membawa kode galat sistem operasi (`errorCode`) yang **bergantung platform**: jangan membuat logika bercabang pada angka mentah bila ada subtipe yang lebih spesifik.
- **Cek-lalu-pakai itu rapuh (TOCTOU).** `if (File(x).existsSync()) baca(x)` memiliki celah waktu: berkas bisa lenyap atau berubah di antara dua baris. Cara yang benar adalah **mencoba lalu menangani** (EAFP, *easier to ask forgiveness than permission*): panggil operasi dan tangkap `PathNotFoundException`.
- **Kegagalan I/O adalah kegagalan lingkungan** (5.1): berkas hilang, izin ditolak, disk penuh, jalur ternyata direktori. Sebagian wajar (berkas belum ada pada pemakaian pertama), sebagian harus dilaporkan.
- **Terjemahkan di batas.** Adaptor penyimpanan mengubah `FileSystemException` menjadi galat domain (`GagalBaca`, `GagalTulis`) dengan `Error.throwWithStackTrace` (5.2). Lapisan di atasnya tidak perlu tahu bahwa ada `dart:io`.
- **Penulisan atomik.** Menulis langsung ke berkas tujuan berisiko menghasilkan berkas terpotong bila proses mati di tengah. Pola aman: tulis ke berkas sementara *di direktori yang sama* dengan `flush: true`, lalu **`rename`** menimpa tujuan. Kasus terburuknya: sisa berkas `.tmp` di samping dokumen asli yang masih utuh. Catatan: perilaku `rename` yang menimpa berkas yang sudah ada dapat berbeda antarplatform (terutama Windows), dan `flush` memberi jaminan keawetan terbatas; untuk data kritis, pelajari jaminan sistem berkas yang kamu pakai.
- **Data rusak** adalah keniscayaan (berkas terpotong, diedit tangan, versi lama). Jangan mengira data dari disk selalu sah (parse, don't validate, 3.5). Kebijakan yang jujur: *cadangkan salinan rusak, mulai dari keadaan aman, dan beri tahu pengguna* — bukan menimpa diam-diam.
- **Teks tak valid.** Membaca berkas sebagai UTF-8 yang rusak dapat melempar `FormatException`; membaca dengan `allowMalformed` menggantikan byte rusak dengan karakter pengganti sehingga kerusakan terdeteksi pada tahap dekode, di satu tempat.
- **Kode keluar proses.** Alat terminal harus memberi tahu pemanggilnya apakah berhasil: 0 berarti sukses; angka lain menandai jenis kegagalan. Konvensi `sysexits` memberi angka lazim: 64 (salah pemakaian), 65 (data salah), 66 (tak ada masukan), 70 (galat perangkat lunak internal), 74 (galat I/O), 75 (kegagalan sementara). Atur `exitCode` dan biarkan `main` selesai; memanggil `exit()` menghentikan proses seketika tanpa menjalankan blok `finally` dan dapat menghilangkan data.
- **Filosofi:** operasi I/O adalah *pertanyaan kepada dunia*, bukan perintah yang pasti dikabulkan; tulis kode yang siap dengan jawaban "tidak".
- **Dampak desain:** penerjemahan di batas membuat inti dapat dites tanpa disk (4.8); penulisan atomik menukar sedikit kerumitan dengan menghilangkan satu kelas kerusakan data.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — galat domain penyimpanan dan pembacaan EAFP.**

```dart
import 'dart:convert';
import 'dart:io';

sealed class GagalSimpan implements Exception {
  const GagalSimpan(this.jalur, this.penyebab);
  final String jalur;
  final Object? penyebab;

  @override
  String toString() => '$runtimeType($jalur): $penyebab';
}

class GagalBaca extends GagalSimpan {
  const GagalBaca(super.jalur, super.penyebab);
}

class GagalTulis extends GagalSimpan {
  const GagalTulis(super.jalur, super.penyebab);
}

/// Mengembalikan null bila berkas belum ada (keadaan wajar).
String? bacaTeks(String jalur) {
  try {
    return File(jalur)
        .readAsStringSync(encoding: const Utf8Codec(allowMalformed: true));
  } on PathNotFoundException {
    return null;
  } on FileSystemException catch (e, s) {
    Error.throwWithStackTrace(GagalBaca(jalur, e), s);
  }
}
```

- Tanpa `existsSync()`: kita langsung mencoba membaca dan menangani `PathNotFoundException` — tak ada celah waktu.
- `on PathNotFoundException` sebelum `on FileSystemException`: subtipe lebih dulu.
- `Utf8Codec(allowMalformed: true)` — byte rusak diganti karakter pengganti; kerusakan terdeteksi saat dekode JSON, di satu tempat.
- `GagalSimpan` sealed: lapisan di atas hanya mengenal `GagalBaca` dan `GagalTulis`, tidak mengenal `dart:io`.

**Contoh 2 — penulisan atomik.**

```dart
void tulisAtomik(String jalur, String isi) {
  final sementara = File('$jalur.tmp');
  try {
    sementara.writeAsStringSync(isi, flush: true);
    sementara.renameSync(jalur);
  } on FileSystemException catch (e, s) {
    try {
      if (sementara.existsSync()) sementara.deleteSync();
    } on FileSystemException {
      // pembersihan berkas sementara gagal: jangan menutupi galat asli
    }
    Error.throwWithStackTrace(GagalTulis(jalur, e), s);
  }
}

void main() {
  final dir = Directory.systemTemp.createTempSync('uji_');
  try {
    final jalur = '${dir.path}/todo.json';
    assert(bacaTeks(jalur) == null);
    tulisAtomik(jalur, 'satu');
    tulisAtomik(jalur, 'dua');
    assert(bacaTeks(jalur) == 'dua');
    assert(!File('$jalur.tmp').existsSync());

    var gagal = false;
    try {
      tulisAtomik('${dir.path}/tidak_ada/x.json', 'x');
    } on GagalTulis {
      gagal = true;
    }
    assert(gagal);
  } finally {
    dir.deleteSync(recursive: true);
  }
}
```

- `writeAsStringSync(isi, flush: true)` — memaksa data didorong ke sistem berkas sebelum langkah berikutnya.
- `renameSync(jalur)` — mengganti tujuan sekaligus: pembaca melihat versi lama utuh atau versi baru utuh, bukan setengah-setengah.
- Pembersihan berkas sementara dibungkus penanganannya sendiri agar kegagalan sekunder tak menutupi galat asli (5.4).
- Menulis ke direktori yang tak ada menghasilkan `GagalTulis` — galat domain, bukan `PathNotFoundException` mentah.

**Contoh 3 — kode keluar sebagai enum dan terjemahan di `main`.**

```dart
enum KodeKeluar {
  sukses(0),
  pemakaian(64), // EX_USAGE: argumen salah
  dataRusak(65), // EX_DATAERR: data masukan salah
  tanpaMasukan(66), // EX_NOINPUT: berkas masukan tak ada
  bugInternal(70), // EX_SOFTWARE: galat perangkat lunak internal
  gagalIo(74), // EX_IOERR: galat I/O
  sementara(75); // EX_TEMPFAIL: coba lagi nanti

  const KodeKeluar(this.nilai);
  final int nilai;
}

void main(List<String> args) {
  try {
    jalankanAplikasi(args); // didefinisikan di tempat lain
  } on GagalSimpan catch (e) {
    stderr.writeln('galat penyimpanan pada ${e.jalur}');
    exitCode = KodeKeluar.gagalIo.nilai; // main selesai normal; finally tetap jalan
  }
}
```

- Enum yang disempurnakan memberi nama pada angka ajaib dan satu tempat untuk memeriksanya.
- `exitCode = ...` mengatur status keluar; `main` kembali normal sehingga semua `finally` berjalan. `exit(kode)` akan memotongnya.
- Galat `Error` (bug) yang lolos ke tingkat atas sebaiknya menghasilkan `bugInternal` dan jejak di log (5.7).

**Contoh 4 — keputusan per kegagalan (tabel kebijakan).**

| Kegagalan | Keputusan | Alasan |
| --- | --- | --- |
| Berkas belum ada saat dibaca | `null`, mulai keadaan kosong | Keadaan wajar pada pemakaian pertama |
| Izin ditolak saat membaca | `GagalBaca`, laporkan, kode 74 | Tak dapat dipulihkan otomatis |
| Disk penuh saat menulis | `GagalTulis`, batalkan perubahan, laporkan | State di memori tidak boleh berbeda dari disk |
| Berkas ada tetapi isinya rusak | Cadangkan salinan, mulai kosong, beri peringatan | Jangan menimpa data tanpa jejak |
| Proses mati saat menulis | Tak terjadi berkas terpotong berkat penulisan atomik | Sisa `.tmp` boleh ada |

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Cek-lalu-pakai (LBYL): jangan, rawan celah waktu.
String? bacaRapuh(String jalur) {
  final f = File(jalur);
  if (!f.existsSync()) return null; // berkas bisa lenyap tepat setelah baris ini
  return f.readAsStringSync();
}
```

| Pendekatan | Kelebihan | Kekurangan |
| --- | --- | --- |
| Coba-lalu-tangani (EAFP) | Tanpa celah waktu; satu jalur | Perlu klausa `on` yang tepat |
| Cek-lalu-pakai (LBYL) | Terlihat intuitif | Celah TOCTOU; tetap perlu `try` |
| Tulis langsung ke tujuan | Sederhana | Berkas terpotong bila proses mati |
| Tulis sementara + rename | Pembaca selalu melihat berkas utuh | Perilaku timpa antarplatform; sisa `.tmp` |
| Sistem berkas palsu untuk tes (`package:file`) | Tes cepat tanpa disk nyata | Dependensi tambahan |

### E. Terminologi Esensial

- **TOCTOU** — *time of check to time of use*: keadaan berubah antara pemeriksaan dan pemakaian. **EAFP / LBYL** — coba lalu tangani / lihat dulu sebelum melompat.
- **Penulisan atomik** — hasil akhir adalah versi lama utuh atau versi baru utuh. **`flush`** — mendorong data ke sistem berkas. **`OSError`** — galat dari sistem operasi.
- **Kode keluar (exit code)** — angka status proses. **`sysexits`** — konvensi angka keluar umum (64–78).

### F. Visualisasi (ASCII)

```text
  tulisAtomik(jalur, isi)

   1. tulis  isi ──► jalur.tmp   (flush)          ← berkas tujuan BELUM disentuh
   2. rename jalur.tmp ──► jalur                  ← pergantian sekaligus

   proses mati setelah 1 : jalur lama utuh + sisa jalur.tmp
   proses mati setelah 2 : jalur baru utuh
   (tak pernah: jalur terpotong)
```

```text
  FileSystemException (dart:io)
        │  batas adaptor penyimpanan
        ▼
  GagalBaca / GagalTulis (domain)  ──► lapisan aplikasi  ──► pesan pengguna + kode keluar
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 5.1 (kegagalan lingkungan), 5.2 (terjemahan dengan jejak), 5.4 (pelepasan dan pembersihan tak menutupi galat asli), 3.5 (data dari disk tak tepercaya).
- **Prasyarat bagi:** 5.8 (studi kasus). **Dikembangkan di:** Fase 7 (I/O asinkron), Fase 9 (jalur berkas, izin, dan data berbahaya), Fase 10 (injeksi kegagalan I/O pada tes).

### H. Tips & Praktik Terbaik

- Jangan memakai `existsSync()` sebagai pengaman; tangani exception dari operasi sebenarnya.
- Letakkan berkas sementara di direktori yang sama dengan tujuan agar `rename` tidak lintas-volume.
- Terjemahkan galat di satu adaptor; lapisan atas hanya mengenal galat domain.
- Beri tahu pengguna ketika data rusak ditemukan dan di mana salinan cadangannya; jangan memulihkan diam-diam.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| `existsSync()` sebagai pengaman | Crash langka saat berkas lenyap | EAFP: tangani exception |
| Menulis langsung ke berkas tujuan | Berkas terpotong setelah proses mati | Sementara + `rename` + `flush` |
| Bercabang pada `osError.errorCode` mentah | Perilaku berbeda antarplatform | Gunakan subtipe (`PathNotFoundException`), kode hanya untuk diagnosis |
| Memanggil `exit()` di tengah program | `finally` tak berjalan; data hilang | Atur `exitCode` dan biarkan `main` selesai |
| Menimpa berkas rusak tanpa cadangan | Data pengguna hilang | Cadangkan lalu mulai dari keadaan aman |
| Membocorkan `FileSystemException` ke seluruh aplikasi | Seluruh kode tergantung `dart:io` | Terjemahkan di adaptor |

### J. Sumber Referensi

- API `FileSystemException`: https://api.dart.dev/stable/dart-io/FileSystemException-class.html · `PathNotFoundException`: https://api.dart.dev/stable/dart-io/PathNotFoundException-class.html · `OSError`: https://api.dart.dev/stable/dart-io/OSError-class.html
- API `File.writeAsStringSync` dan `renameSync`: https://api.dart.dev/stable/dart-io/File-class.html
- API `exitCode` dan `exit`: https://api.dart.dev/stable/dart-io/exitCode.html · https://api.dart.dev/stable/dart-io/exit.html
- Konvensi `sysexits`: https://man.freebsd.org/cgi/man.cgi?query=sysexits
- Race condition TOCTOU: https://en.wikipedia.org/wiki/Time-of-check\_to\_time-of-use
- Paket `file` (sistem berkas palsu untuk tes): https://pub.dev/packages/file

---

## 5.6 Ketahanan: Retry, Backoff, Jitter, Idempotensi

*Motivasi: ketahanan bukan mencoba terus-menerus, melainkan tahu kapan mencoba lagi, berapa lama menunggu, dan kapan menyerah.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas **retry** yang benar: hanya untuk kegagalan *transien*, dengan jumlah percobaan terbatas, **backoff eksponensial**, **jitter** acak, dan prasyarat **idempotensi** (5.4). Kamu menulis fungsi `ulangi` yang dapat diuji tanpa menunggu waktu nyata, dengan menyuntikkan fungsi tidur dan generator acak (4.7, 4.8). Konsep *circuit breaker* diperkenalkan secara ringkas.

### B. Konsep Kunci & Filosofi Mendalam

- **Transien vs permanen.** Retry hanya masuk akal bila ulang-coba mungkin berhasil (berkas terkunci sesaat, jaringan putus sebentar, kode `TEMPFAIL`). Mengulang kegagalan permanen (jalur tak ada, data rusak, kontrak dilanggar) hanya membuang waktu dan menunda laporan yang jujur. Karena itu *predikat `bisaDiulang`* adalah bagian wajib dari desain.
- **Parameter retry:** *jumlah percobaan maksimum*, *jeda awal*, *faktor pertumbuhan* (biasanya ×2), *jeda maksimum*, dan, di sistem nyata, *batas total waktu*.
- **Backoff eksponensial.** Jeda tumbuh tiap kegagalan (100 ms, 200 ms, 400 ms, ...) sehingga sistem yang sedang kesulitan diberi ruang bernapas, bukan dihujani percobaan.
- **Jitter.** Menambahkan keacakan pada jeda mencegah banyak klien mencoba ulang serempak (*thundering herd*). Varian *full jitter* tidur selama nilai acak antara 0 dan jeda saat ini.
- **Idempotensi adalah prasyarat.** Mengulang operasi non-idempoten (tambah saldo, kirim email) dapat menggandakan efeknya. Jadikan operasi idempoten (kunci unik, `set` alih-alih `tambah`) atau jangan di-retry (5.4).
- **Retry mengalikan beban.** Tiga percobaan berarti tiga kali pekerjaan saat sistem justru lemah; batasi jumlah dan beri tahu pengguna.
- **Suntikkan waktu dan acak.** Fungsi `ulangi` menerima `tidur` dan `Random` sebagai parameter; tes memakai versi palsu dan berjalan seketika dan deterministik (1.2).
- **Timeout dan pembatalan** pada kode sinkron tidak dapat memotong operasi yang sedang berjalan; mekanisme `Future.timeout`, pembatalan, dan `Stream` dibahas di Fase 7.
- **Circuit breaker (konsep).** Setelah kegagalan beruntun melewati ambang, berhenti mencoba sejenak (*open*), lalu mencoba satu percobaan uji (*half-open*) sebelum kembali normal (*closed*), agar sistem yang rusak tidak terus dipukul.
- **Filosofi:** ketahanan yang baik *terbatas dan jujur*: terbatas dalam percobaan, jujur dalam laporan akhir.
- **Dampak desain:** retry tanpa backoff adalah serangan terhadap dirimu sendiri; retry tanpa idempotensi adalah sumber duplikasi; retry tanpa batas adalah program yang menggantung.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — fungsi `ulangi` dengan backoff, jitter, dan dependensi yang disuntikkan.**

```dart
import 'dart:io';
import 'dart:math';

void _tidurNyata(Duration d) => sleep(d);

T ulangi<T>(
  T Function() aksi, {
  required bool Function(Object galat) bisaDiulang,
  int maksPercobaan = 4,
  Duration jedaAwal = const Duration(milliseconds: 100),
  Duration jedaMaks = const Duration(seconds: 5),
  void Function(Duration jeda) tidur = _tidurNyata,
  Random? acak,
}) {
  if (maksPercobaan < 1) {
    throw ArgumentError.value(maksPercobaan, 'maksPercobaan', 'harus >= 1');
  }
  final r = acak ?? Random();
  var jeda = jedaAwal;
  for (var percobaan = 1;; percobaan++) {
    try {
      return aksi();
    } on Exception catch (e) {
      if (percobaan >= maksPercobaan || !bisaDiulang(e)) rethrow;
      tidur(Duration(milliseconds: r.nextInt(jeda.inMilliseconds + 1))); // full jitter
      jeda = jeda * 2 > jedaMaks ? jedaMaks : jeda * 2;
    }
  }
}
```

- `required bool Function(Object galat) bisaDiulang` — pemanggil *wajib* menyatakan kegagalan mana yang transien; tidak ada nilai bawaan yang berbahaya.
- `on Exception catch (e)` — hanya kegagalan wajar yang dipertimbangkan untuk diulang; `Error` melewatinya (5.1).
- `if (percobaan >= maksPercobaan || !bisaDiulang(e)) rethrow;` — habis jatah atau permanen: lempar galat *terakhir* dengan jejak aslinya.
- `r.nextInt(jeda.inMilliseconds + 1)` — jeda acak antara 0 dan `jeda` (full jitter); `jeda * 2` kemudian dibatasi `jedaMaks`.
- `void Function(Duration) tidur = _tidurNyata` — nilai bawaan berupa tear-off fungsi (konstanta); tes menggantinya dengan versi yang tak menunggu.
- `for (var percobaan = 1;; percobaan++)` — loop tanpa syarat berhenti; fungsi hanya keluar lewat `return` atau `rethrow`.

**Contoh 2 — pengujian tanpa menunggu.**

```dart
void main() {
  var panggilan = 0;
  final jedaTercatat = <Duration>[];

  // Gagal dua kali (transien), lalu berhasil.
  final hasil = ulangi<int>(
    () {
      panggilan++;
      if (panggilan < 3) throw const FileSystemException('terkunci');
      return 42;
    },
    bisaDiulang: (e) => e is FileSystemException,
    tidur: jedaTercatat.add,
    acak: Random(1),
  );
  assert(hasil == 42 && panggilan == 3 && jedaTercatat.length == 2);

  // Kegagalan permanen tidak diulang.
  panggilan = 0;
  try {
    ulangi<int>(
      () {
        panggilan++;
        throw const FormatException('rusak');
      },
      bisaDiulang: (e) => e is FileSystemException,
      tidur: (_) {},
    );
  } on FormatException {
    assert(panggilan == 1);
  }

  // Habis jatah: galat terakhir dilempar setelah maksPercobaan.
  panggilan = 0;
  try {
    ulangi<int>(
      () {
        panggilan++;
        throw const FileSystemException('terkunci');
      },
      bisaDiulang: (_) => true,
      maksPercobaan: 3,
      tidur: (_) {},
    );
  } on FileSystemException {
    assert(panggilan == 3);
  }
}
```

- `tidur: jedaTercatat.add` — tear-off `List.add` sebagai pengganti tidur nyata: tes berjalan seketika *dan* dapat memeriksa berapa kali dan berapa lama program akan tidur.
- `Random(1)` — benih tetap membuat jitter deterministik di tes.
- Tiga skenario membuktikan tiga aturan: berhasil setelah transien, permanen tak diulang, dan jatah terbatas.

**Contoh 3 — predikat `bisaDiulang` untuk I/O.**

```dart
bool transienIo(Object galat) =>
    galat is FileSystemException && galat is! PathNotFoundException;
```

- Jalur yang tak ada adalah kegagalan permanen (mengulang tak mengubahnya); kegagalan I/O lain (berkas terkunci, gangguan sesaat) mungkin transien. Predikat ini tertulis eksplisit dan dapat diuji sendiri.

### D. Opsi Kode Lain untuk Logika yang Sama

| Pendekatan | Kelebihan | Kekurangan |
| --- | --- | --- |
| `ulangi` buatan sendiri | Kontrol penuh; bisa diuji tanpa menunggu | Perlu dipelihara |
| Paket `retry` | Siap pakai, teruji | Dependensi; pastikan mendukung predikat dan injeksi tidur |
| Tanpa retry; laporkan segera | Sederhana dan jujur | Pengguna harus mengulang manual untuk gangguan sesaat |
| Circuit breaker | Melindungi sistem yang sedang rusak | Kompleks; baru perlu pada layanan yang sering dipanggil |

| Jenis kegagalan | Retry? | Alasan |
| --- | --- | --- |
| Berkas terkunci sesaat | Ya, dengan batas | Transien |
| Jaringan putus sebentar | Ya, dengan backoff dan jitter | Transien |
| Jalur tidak ada | Tidak | Permanen |
| Data rusak (`FormatException`) | Tidak | Permanen |
| Pelanggaran kontrak (`ArgumentError`) | Tidak | Bug pemanggil |
| Operasi non-idempoten | Hanya bila dibuat idempoten | Duplikasi efek |

### E. Terminologi Esensial

- **Retry** — mengulang operasi yang gagal. **Backoff eksponensial** — jeda tumbuh kali lipat tiap kegagalan. **Jitter** — keacakan pada jeda. **Thundering herd** — banyak klien mengulang serempak.
- **Transien / permanen** — mungkin berhasil bila diulang / tidak. **Circuit breaker** — pemutus yang menghentikan percobaan saat kegagalan beruntun.
- **Deadline** — batas total waktu seluruh percobaan. **Idempotensi** — pengulangan tak mengubah hasil akhir.

### F. Visualisasi (ASCII)

```text
  percobaan 1 ──gagal(transien)──► tidur rand(0..100ms)
  percobaan 2 ──gagal(transien)──► tidur rand(0..200ms)
  percobaan 3 ──gagal(transien)──► tidur rand(0..400ms)        (jeda dibatasi jedaMaks)
  percobaan 4 ──gagal ───────────► lempar galat TERAKHIR       (habis jatah)

  gagal permanen di percobaan mana pun ──► lempar SEGERA (tanpa tidur)
```

```text
  Circuit breaker (konsep)

  CLOSED ──(gagal beruntun melewati ambang)──► OPEN ──(setelah jeda)──► HALF-OPEN
     ▲                                           ▲                          │
     │                                           └──── gagal ◄──────────────┤
     └────────────── sukses ◄─────────────────────────────────────────────┘
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 5.1 (transien vs permanen), 5.4 (idempotensi), 4.2 dan 4.7 (tear-off dan injeksi fungsi), 1.2 (waktu dan acak sebagai input).
- **Prasyarat bagi:** 5.8 (retry pada penulisan berkas). **Dikembangkan di:** Fase 7 (timeout, pembatalan, retry asinkron), Fase 9 (retry dan serangan penolakan layanan), Fase 10 (menguji jalur retry secara deterministik).

### H. Tips & Praktik Terbaik

- Selalu pasang batas jumlah percobaan dan jeda maksimum; tidak ada retry tak terbatas.
- Tulis predikat `bisaDiulang` secara eksplisit dan uji; jangan mengulang semuanya.
- Suntikkan `tidur` dan `Random` agar tes cepat dan deterministik.
- Catat setiap percobaan ulang (5.7) dan laporkan galat terakhir bila menyerah.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Retry tanpa backoff | Memperparah gangguan; beban melonjak | Backoff eksponensial + jeda maksimum |
| Retry tanpa jitter | Banyak klien mengulang serempak | Tambahkan jitter |
| Mengulang kegagalan permanen | Waktu terbuang; laporan tertunda | Predikat `bisaDiulang` yang ketat |
| Retry operasi non-idempoten | Duplikasi efek | Jadikan idempoten atau jangan di-retry |
| `sleep` nyata di tes | Tes lambat dan flaky | Suntikkan fungsi tidur palsu |
| Menelan semua percobaan gagal | Tak ada jejak penyebab | Catat tiap percobaan dan lempar galat terakhir |

### J. Sumber Referensi

- API `sleep`: https://api.dart.dev/stable/dart-io/sleep.html · API `Random`: https://api.dart.dev/stable/dart-math/Random-class.html
- Paket `retry`: https://pub.dev/packages/retry
- Amazon Builders' Library, *Timeouts, retries, and backoff with jitter*: https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/
- Martin Fowler, *Circuit Breaker*: https://martinfowler.com/bliki/CircuitBreaker.html
- Idempotence: https://en.wikipedia.org/wiki/Idempotence

---

## 5.7 Pesan Galat, Logging, dan Observabilitas Dasar *(TAMBAHAN)*

*Motivasi: kegagalan yang tak bisa dijelaskan hanya setengah tertangani.*

> **Mengapa ditambahkan.** Audit menemukan bahwa pembelajar menangani kegagalan dengan benar tetapi melaporkannya dengan buruk: pesan yang tak membantu pengguna, log yang tak berguna bagi pengembang, dan rahasia yang bocor ke keduanya. Modul ini memisahkan dua audiens itu.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas **dua audiens** kegagalan: *pengguna* (perlu tahu apa yang terjadi dan apa yang dapat dilakukan) dan *pengembang/operator* (perlu konteks lengkap untuk mendiagnosis). Kamu belajar membuat pesan yang dapat ditindaklanjuti, membentuk teks di tepi dari data galat, mengabstraksikan **logging** sebagai dependensi yang disuntikkan, dan menyamarkan rahasia. Kode keluar (5.5) adalah bentuk observabilitas paling dasar untuk alat terminal.

### B. Konsep Kunci & Filosofi Mendalam

- **Dua audiens, dua artefak.** *Pesan untuk pengguna:* singkat, tanpa jargon, menyebut **apa** yang gagal, **mengapa** (bila diketahui dan aman), dan **apa yang dapat dilakukan**. *Log untuk pengembang:* **konteks lengkap** — operasi, parameter relevan, galat penyebab, stack trace, waktu.
- **Pesan yang baik** konsisten dan stabil (dapat dicari dengan `grep`), tidak menyalahkan pengguna, dan tidak menyarankan hal yang mustahil.
- **Galat membawa data; teks dibentuk di tepi.** Exception berisi *field* (jalur, nilai, jenis); lapisan presentasi mengubahnya menjadi kalimat. Dengan begitu pesan mudah diuji dan diterjemahkan, dan penanganan terarah tidak bergantung pada pencocokan teks.
- **Jangan membocorkan.** Stack trace, jalur internal, isi kueri, token, dan kata sandi tidak boleh sampai ke pengguna akhir, dan rahasia tidak boleh masuk log. Pada alat lokal yang dijalankan pemiliknya, menyebut jalur berkas yang ia pilih wajar; pada layanan jaringan, jangan (Fase 9). Samarkan rahasia bila harus dirujuk (misal hanya empat karakter terakhir).
- **Logging sebagai dependensi.** Logika inti murni tidak mencetak (1.2). Pencatat disuntikkan sebagai fungsi atau antarmuka (4.7, 4.8), sehingga tes dapat menangkapnya dan produksi dapat menggantinya. Pustaka `package:logging` menyediakan tingkat dan hierarki pencatat bila dibutuhkan.
- **Tingkat log.** `debug` (rinci untuk pengembang), `info` (peristiwa normal penting), `peringatan` (keadaan tak biasa tetapi dapat dilewati), `galat` (operasi gagal). Stack trace cukup dicatat pada tingkat `galat`.
- **stdout untuk hasil, stderr untuk diagnostik** (1.7): hasil program tetap bersih untuk di-*pipe*.
- **Jangan mencatat di loop panas** atau dengan string mahal yang dibentuk walau tingkat log dimatikan; hitung pesan hanya bila perlu.
- **Observabilitas dasar:** kode keluar, hitungan kejadian penting (jumlah retry, jumlah kegagalan), dan korelasi (identitas operasi) membuat perilaku sistem dapat dipahami dari luar.
- **Filosofi:** laporkan kegagalan sehingga *orang yang tepat* dapat bertindak dengan *informasi yang tepat* — dan tidak ada yang lain.
- **Dampak desain:** pesan yang hanya berupa string dalam exception menyulitkan penanganan terarah dan terjemahan; log tanpa konteks tak berguna; rahasia di log menjadi kebocoran yang bertahan lama.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — pesan untuk pengguna dibentuk di tepi dari data galat.**

```dart
// GagalBaca dan GagalTulis berasal dari modul 5.5.
String untukPengguna(Object galat) => switch (galat) {
      GagalTulis() =>
        'Tidak dapat menyimpan perubahan. Periksa izin dan ruang disk, lalu coba lagi.',
      GagalBaca() => 'Tidak dapat membaca berkas daftar. Periksa izin berkasnya.',
      _ => 'Terjadi kesalahan tak terduga. Rincian dicatat di log.',
    };

void main() {
  final pesan = untukPengguna(GagalTulis('/rumah/jon/rahasia/todo.json', 'disk penuh'));
  assert(pesan.contains('menyimpan'));
  assert(!pesan.contains('/rumah')); // jalur internal tidak bocor ke pengguna
  assert(!pesan.contains('disk penuh')); // detail teknis masuk log, bukan pesan
}
```

- Pola object `GagalTulis()` mencocokkan *tipe* galat; teks dibentuk di sini, bukan di dalam exception.
- Pesan menyebut *apa* (tak dapat menyimpan) dan *apa yang dapat dilakukan* (periksa izin dan ruang disk).
- `_` menangkap segala hal lain dengan pesan netral; rincian pergi ke log.

**Contoh 2 — pencatat sebagai dependensi yang disuntikkan.**

```dart
import 'dart:io';

enum Tingkat { debug, info, peringatan, galat }

typedef Pencatat = void Function(
  Tingkat tingkat,
  String pesan, {
  Object? galat,
  StackTrace? jejak,
});

void pencatatStderr(
  Tingkat tingkat,
  String pesan, {
  Object? galat,
  StackTrace? jejak,
}) {
  final baris = StringBuffer('[${tingkat.name}] $pesan');
  if (galat != null) baris.write(' | $galat');
  stderr.writeln(baris);
  if (jejak != null && tingkat == Tingkat.galat) stderr.writeln(jejak);
}

void main() {
  final catatan = <String>[];
  void palsu(Tingkat t, String pesan, {Object? galat, StackTrace? jejak}) =>
      catatan.add('${t.name}:$pesan');

  final Pencatat catat = palsu;
  catat(Tingkat.info, 'mulai');
  catat(Tingkat.galat, 'gagal', galat: StateError('x'));
  assert(catatan.join(',') == 'info:mulai,galat:gagal');
}
```

- `typedef Pencatat = void Function(Tingkat, String, {Object? galat, StackTrace? jejak})` — tanda tangan pencatat sebagai tipe; parameter bernama `galat` dan `jejak` opsional.
- `pencatatStderr` menulis ke stderr, dan hanya mencetak stack trace pada tingkat `galat`.
- Tes memakai fungsi lokal `palsu` yang menampung pesan; inti tak perlu tahu ke mana log pergi.

**Contoh 3 — menyamarkan rahasia.**

```dart
String samarkan(String rahasia) {
  if (rahasia.length <= 4) return '****';
  final sisa = rahasia.substring(rahasia.length - 4);
  return '${'*' * (rahasia.length - 4)}$sisa';
}

void main() {
  assert(samarkan('abcdef123456') == '********3456');
  assert(samarkan('abc') == '****');
}
```

- Hanya empat karakter terakhir yang terlihat, cukup untuk mengenali token tanpa mengungkapkannya; rahasia yang pendek disembunyikan seluruhnya.
- Aturan yang lebih kuat: jangan mencatat rahasia sama sekali; samarkan hanya bila harus dirujuk.

### D. Opsi Kode Lain untuk Logika yang Sama

| Mekanisme | Cocok untuk | Catatan |
| --- | --- | --- |
| `print` | Eksperimen cepat | Ke stdout; mencemari keluaran program |
| `stderr.writeln` | Diagnostik alat terminal | Sederhana; tanpa tingkat |
| `dart:developer` `log()` | Integrasi IDE/DevTools | Terutama terlihat di perangkat pengembangan |
| `package:logging` | Tingkat, hierarki pencatat, penangan khusus | Dependensi resmi; cocok untuk aplikasi lebih besar |
| Pencatat yang disuntikkan (`Pencatat`) | Inti murni dan tes | Perlu diteruskan; paling mudah diuji |

### E. Terminologi Esensial

- **Pesan pengguna / log** — kalimat untuk orang awam / catatan teknis untuk pengembang. **Tingkat log** — debug, info, peringatan, galat.
- **Observabilitas** — kemampuan memahami keadaan sistem dari luar. **Korelasi** — penanda yang menghubungkan beberapa catatan untuk satu operasi.
- **Kebocoran informasi** — rincian sensitif sampai ke pihak yang tak berhak. **Menyamarkan (redaction)** — menyembunyikan sebagian nilai sensitif.

### F. Visualisasi (ASCII)

```text
   kegagalan terjadi (data lengkap: jalur, penyebab, jejak)
         │
         ├──► LOG  (pengembang): operasi, konteks, galat penyebab, jejak     → stderr / berkas
         │
         └──► PESAN (pengguna):  apa gagal + apa yang dapat dilakukan        → antarmuka
                                 (tanpa jejak, tanpa jalur internal, tanpa rahasia)
```

```text
  inti murni ──(menerima Pencatat sebagai parameter)──► memanggil catat(...)
                                                          │
                              produksi: pencatatStderr ◄──┤
                              tes:      pencatat palsu  ◄─┘
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 5.1 (siapa yang perlu tahu), 5.2 (galat membawa data dan penyebab), 5.5 (kode keluar), 4.7 dan 4.8 (injeksi fungsi dan antarmuka).
- **Prasyarat bagi:** 5.8 (studi kasus). **Dikembangkan di:** Fase 9 (kebocoran informasi dan log yang aman), Fase 10 (menguji log dan pesan), Fase 11 (observabilitas lintas modul).

### H. Tips & Praktik Terbaik

- Tulis pesan pengguna sebagai *apa + tindakan*; simpan penjelasan teknis di log.
- Bentuk teks di satu tempat (`untukPengguna`); galat hanya membawa data.
- Suntikkan pencatat; jangan memanggil `print` di logika inti.
- Tulis test bahwa pesan pengguna tidak memuat jalur absolut atau stack trace; tulis test bahwa log memuat konteks yang diperlukan.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Menampilkan stack trace ke pengguna | Pengguna bingung; informasi internal bocor | Tampilkan pesan ringkas; jejak ke log |
| Pesan hanya `Error` atau `Terjadi kesalahan` | Tak dapat ditindaklanjuti | Sebut apa gagal dan apa yang dapat dilakukan |
| Rahasia di log | Kebocoran bertahan lama | Jangan catat; atau samarkan |
| Teks dibentuk di dalam exception | Sulit diuji dan diterjemahkan | Exception membawa data; teks di tepi |
| `print` di logika inti | Tak bisa diuji; mencemari stdout | Pencatat yang disuntikkan, stderr untuk diagnostik |
| Log tanpa konteks | Tak dapat mendiagnosis | Sertakan operasi, parameter relevan, galat penyebab |

### J. Sumber Referensi

- Paket `logging`: https://pub.dev/packages/logging
- API `stderr`: https://api.dart.dev/stable/dart-io/stderr.html · API `log` (`dart:developer`): https://api.dart.dev/stable/dart-developer/log.html
- ✔ Effective Dart — penggunaan: https://dart.dev/effective-dart/usage
- OWASP, *Logging Cheat Sheet*: https://cheatsheetseries.owasp.org/cheatsheets/Logging\_Cheat\_Sheet.html

---

## 5.8 Studi Kasus Terpadu: To-Do v4 *(TAMBAHAN)*

*Motivasi: sistem yang tangguh bukan yang tak pernah gagal, melainkan yang selalu tahu apa yang harus dilakukan ketika gagal.*

> **Mengapa ditambahkan.** Fase 5 paling jelas dilihat ketika kegagalan *disuntikkan sengaja*. To-Do v4 memperkuat penyimpanan dari Fase 4.8: penulisan atomik, penerjemahan galat, retry hanya untuk kegagalan transien, perubahan yang dibatalkan bila tak tersimpan, data rusak dicadangkan, pesan dan log yang terpisah, dan kode keluar bermakna — semuanya dibuktikan oleh tes dengan penyimpan palsu yang gagal sesuai skenario.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Langkah & kode · D Variasi · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Kamu memperbarui `lib/todo.dart` dari Fase 4.8: (1) antarmuka `Penyimpan` bertambah satu operasi (`cadangkan`), (2) `PenyimpanBerkas` memakai `bacaTeks` dan `tulisAtomik` (5.5), (3) `AplikasiTodo` memuat dengan kebijakan data rusak, menyimpan dengan retry, dan **hanya mengomit state di memori setelah penyimpanan berhasil**, (4) shell menerjemahkan galat menjadi pesan, log, dan kode keluar. `Perintah`, `Urai`, `Item`, `Judul`, `Riwayat`, dan `jalankan` **tidak berubah**. Letakkan semua helper dari 5.5–5.7 (`GagalSimpan`, `bacaTeks`, `tulisAtomik`, `ulangi`, `transienIo`, `Tingkat`, `Pencatat`, `pencatatStderr`, `KodeKeluar`, `untukPengguna`) dalam satu library yang sama.

### B. Konsep Kunci & Filosofi Mendalam

- **Komit setelah persisten.** `proses` menghitung riwayat baru, menyimpannya, dan baru kemudian menggantinya di memori. Bila penyimpanan gagal, memori dan disk tidak pernah berbeda (all-or-nothing, 5.4).
- **Retry hanya untuk yang transien.** Penulisan diulang dengan `ulangi` hanya bila `GagalTulis` berpenyebab transien (`transienIo`); penyebab permanen (jalur tak ada, izin) langsung dilaporkan.
- **Data rusak ditangani, tidak ditelan.** `dekode` melempar `FormatException`; `muat` mencadangkan teks rusak, memulai dari daftar kosong, dan *memberi peringatan*. Kebijakan ini dipilih agar pengguna tak kehilangan jejak datanya.
- **Kegagalan baca tak dapat dipulihkan di sini.** `GagalBaca` dibiarkan naik ke shell, yang menerjemahkannya ke pesan, log, dan kode keluar 74.
- **Injeksi untuk menguji kegagalan.** Penyimpan, fungsi tidur, dan pencatat semuanya disuntikkan. Tes memakai `PenyimpanSkrip` yang gagal sebanyak yang kita tentukan — *fault injection* — tanpa menyentuh disk dan tanpa menunggu.
- **Perubahan antarmuka yang dipandu kompilator.** Menambah `cadangkan` ke `Penyimpan` memaksa kompilator menolak semua implementasi (termasuk fake) sampai diperbarui — keuntungan antarmuka eksplisit dan `abstract interface class`.
- **Penjaga terakhir.** Di `main`, satu `catch` terakhir menangkap bug yang lolos, mencatatnya dengan jejak, dan mengakhiri dengan kode 70. Itu pengecualian sah dari aturan *jangan menangkap `Error`*: ia tidak mencoba melanjutkan, hanya melaporkan dan berhenti.
- **Dampak desain:** karena inti tidak berubah, seluruh ketahanan terletak pada ±120 baris di tepi dan koordinator; jalur gagal dapat diuji sama mudahnya dengan jalur sukses.

### C. Langkah, Sintaks, dan Kode

**Langkah 1 — kebijakan semua jalur kegagalan.**

| Jalur | Kegagalan | Keputusan | Ke pengguna | Kode keluar |
| --- | --- | --- | --- | --- |
| Muat: berkas belum ada | — | Daftar kosong | — | 0 |
| Muat: `GagalBaca` | Izin atau I/O | Naik ke shell | Pesan `untukPengguna` | 74 |
| Muat: data rusak | `FormatException` | Cadangkan, mulai kosong, peringatan, log | Peringatan | 0 (sesi lanjut) |
| Proses: `GagalTulis` transien | Berkas terkunci dll. | Retry sampai habis jatah | — | — |
| Proses: `GagalTulis` permanen atau jatah habis | Izin, jalur hilang | Batalkan perubahan, log galat | `gagal menyimpan; perubahan dibatalkan` | 0 (sesi lanjut) |
| Bug internal | `Error` | Catat dengan jejak, akhiri | — | 70 |

**Langkah 2 — antarmuka dan penyimpan.**

```dart
import 'dart:io';

abstract interface class Penyimpan {
  String? baca();
  void tulis(String isi);
  void cadangkan(String isi);
}

class PenyimpanBerkas implements Penyimpan {
  PenyimpanBerkas(this.jalur);
  final String jalur;

  @override
  String? baca() => bacaTeks(jalur);

  @override
  void tulis(String isi) => tulisAtomik(jalur, isi);

  @override
  void cadangkan(String isi) => tulisAtomik('$jalur.rusak', isi);
}

class PenyimpanMemori implements Penyimpan {
  PenyimpanMemori([this._isi]);
  String? _isi;
  String? cadangan;

  @override
  String? baca() => _isi;

  @override
  void tulis(String isi) => _isi = isi;

  @override
  void cadangkan(String isi) => cadangan = isi;
}
```

- `PenyimpanBerkas` kini hanya merangkai `bacaTeks` dan `tulisAtomik` dari 5.5; tak ada lagi `existsSync` dan penulisan langsung.
- `cadangkan` menulis salinan data rusak ke `jalur.rusak` secara atomik juga.
- `PenyimpanMemori` mengimplementasi operasi baru — kompilator memaksanya.

**Langkah 3 — koordinator `AplikasiTodo` yang tangguh.**

```dart
typedef HasilMuat = ({AplikasiTodo aplikasi, List<String> peringatan});

class AplikasiTodo {
  AplikasiTodo._(this._penyimpan, this._riwayat, this._tidur, this._catat);

  final Penyimpan _penyimpan;
  Riwayat<List<Item>> _riwayat;
  final void Function(Duration) _tidur;
  final Pencatat _catat;

  static HasilMuat muat(
    Penyimpan penyimpan, {
    int batas = 50,
    void Function(Duration) tidur = _tidurNyata,
    Pencatat catat = pencatatStderr,
  }) {
    final peringatan = <String>[];
    var awal = <Item>[];
    final isi = penyimpan.baca(); // GagalBaca dibiarkan naik
    if (isi != null) {
      try {
        awal = dekode(isi);
      } on FormatException catch (e) {
        penyimpan.cadangkan(isi);
        peringatan.add(
          'data rusak (${e.message}); salinan dicadangkan; memulai dengan daftar kosong',
        );
        catat(Tingkat.peringatan, 'data todo rusak', galat: e);
      }
    }
    return (
      aplikasi: AplikasiTodo._(
        penyimpan,
        Riwayat<List<Item>>.mulai(awal, batas: batas),
        tidur,
        catat,
      ),
      peringatan: peringatan,
    );
  }

  /// Snapshot daftar saat ini (tak dapat diubah).
  List<Item> get daftar => List.unmodifiable(_riwayat.kini);

  List<String> proses(Perintah perintah) {
    final (baru, keluaran) = jalankan(_riwayat, perintah);
    if (identical(baru, _riwayat)) return keluaran; // tak ada perubahan: tak menulis

    try {
      ulangi<void>(
        () => _penyimpan.tulis(kodekan(baru.kini)),
        bisaDiulang: (e) => e is GagalTulis && transienIo(e.penyebab ?? e),
        tidur: _tidur,
      );
    } on GagalTulis catch (e, s) {
      _catat(Tingkat.galat, 'gagal menyimpan', galat: e, jejak: s);
      return const ['gagal menyimpan; perubahan dibatalkan'];
    }
    _riwayat = baru; // komit di memori HANYA setelah penyimpanan berhasil
    return keluaran;
  }
}
```

- Konstruktor privat `AplikasiTodo._` + factory statis `muat`: satu-satunya jalan membuat aplikasi adalah lewat kebijakan pemuatan (4.4, invarian terjaga).
- `HasilMuat` adalah *typedef record* bernama: pemanggil mendapat `aplikasi` dan `peringatan` tanpa class tambahan (3.3).
- `on FormatException catch (e)` — hanya data rusak yang ditangani; `GagalBaca` dari `penyimpan.baca()` ada di luar `try` dan sengaja naik.
- `bisaDiulang: (e) => e is GagalTulis && transienIo(e.penyebab ?? e)` — retry hanya bila penyebab aslinya transien; penyebab tanpa nilai memakai galat itu sendiri.
- `_riwayat = baru` *setelah* `ulangi` sukses: bila `ulangi` melempar `GagalTulis`, state memori tidak berubah.
- Pada kegagalan, pesan dikembalikan sebagai data (`const [...]`), log mencatat jejaknya, dan sesi dapat lanjut.

**Langkah 4 — shell: terjemahkan galat menjadi pesan, log, dan kode keluar (`bin/logika_fase5.dart`).**

```dart
import 'dart:io';

import 'package:logika_fase5/todo.dart';

AplikasiTodo? bukaAplikasi(String jalur) {
  try {
    final (:aplikasi, :peringatan) = AplikasiTodo.muat(PenyimpanBerkas(jalur));
    peringatan.forEach(stderr.writeln);
    return aplikasi;
  } on GagalSimpan catch (e, s) {
    stderr.writeln(untukPengguna(e));
    pencatatStderr(Tingkat.galat, 'gagal membuka aplikasi', galat: e, jejak: s);
    exitCode = KodeKeluar.gagalIo.nilai;
    return null;
  }
}

void jalankanShell(AplikasiTodo app) {
  while (true) {
    stdout.write('todo> ');
    final baris = stdin.readLineSync();
    if (baris == null) break; // akhir masukan (Ctrl-D)
    final token = baris.split(' ').where((t) => t.isNotEmpty).toList();
    switch (uraiPerintah(token)) {
      case UraiGagal(:final alasan):
        stderr.writeln('galat: $alasan');
      case UraiBerhasil(:final perintah):
        app.proses(perintah).forEach(stdout.writeln);
    }
  }
}

void main(List<String> args) {
  try {
    final app = bukaAplikasi(args.isNotEmpty ? args.first : 'todo.json');
    if (app != null) jalankanShell(app);
    // ignore: avoid_catches_without_on_clauses
  } catch (e, s) {
    // Penjaga TERAKHIR: bug yang lolos dicatat, lalu proses diakhiri (tidak dilanjutkan).
    pencatatStderr(Tingkat.galat, 'galat internal (bug)', galat: e, jejak: s);
    exitCode = KodeKeluar.bugInternal.nilai;
  }
}
```

```text
$ dart run
todo> tambah beli roti
ditambah: beli roti
todo> daftar
1. [ ] beli roti
todo> batal
dibatalkan

$ echo 'bukan json' > todo.json && dart run
data rusak (...); salinan dicadangkan; memulai dengan daftar kosong
todo>
```

- `final (:aplikasi, :peringatan) = ...` — destrukturisasi record bernama (2.5); peringatan dicetak ke stderr.
- Galat `GagalSimpan` diterjemahkan sekali di `bukaAplikasi`: pesan pengguna (tanpa jejak), log lengkap (dengan jejak), dan kode keluar 74.
- `catch (e, s)` di `main` adalah satu-satunya tempat `catch` tanpa `on`, diberi komentar alasan dan `ignore` eksplisit; ia melaporkan dan berhenti.
- Setelah `main` selesai normal, proses keluar dengan `exitCode` yang diatur — semua `finally` sudah berjalan.

**Langkah 5 — test dengan penyimpan yang gagal sesuai skenario (`test/todo_test.dart`).**

```dart
import 'dart:io';

import 'package:logika_fase5/todo.dart';
import 'package:test/test.dart';

class PenyimpanSkrip implements Penyimpan {
  PenyimpanSkrip({
    this.isi,
    this.gagalTulisSebanyak = 0,
    this.penyebabTulis = const FileSystemException('terkunci'),
    this.gagalBaca = false,
  });

  String? isi;
  String? cadangan;
  int gagalTulisSebanyak;
  final Object penyebabTulis;
  final bool gagalBaca;
  int percobaanTulis = 0;
  int tulisanBerhasil = 0;

  @override
  String? baca() =>
      gagalBaca ? throw const GagalBaca('virtual', 'simulasi') : isi;

  @override
  void tulis(String s) {
    percobaanTulis++;
    if (gagalTulisSebanyak > 0) {
      gagalTulisSebanyak--;
      throw GagalTulis('virtual', penyebabTulis);
    }
    tulisanBerhasil++;
    isi = s;
  }

  @override
  void cadangkan(String s) => cadangan = s;
}

void diam(Tingkat t, String pesan, {Object? galat, StackTrace? jejak}) {}

void main() {
  group('penyimpanan tangguh', () {
    test('kegagalan transien diulang lalu berhasil', () {
      final p = PenyimpanSkrip(gagalTulisSebanyak: 2);
      final tidur = <Duration>[];
      final app = AplikasiTodo.muat(p, tidur: tidur.add, catat: diam).aplikasi;

      final keluaran = app.proses(Tambah(Judul.dari('roti')));
      expect(keluaran.single, 'ditambah: roti');
      expect(tidur, hasLength(2));
      expect(p.tulisanBerhasil, 1);
      expect(app.daftar, hasLength(1));
    });

    test('kegagalan permanen tidak diulang dan perubahan dibatalkan', () {
      final p = PenyimpanSkrip(
        gagalTulisSebanyak: 99,
        penyebabTulis: 'izin ditolak',
      );
      final app =
          AplikasiTodo.muat(p, tidur: (_) {}, catat: diam).aplikasi;

      final keluaran = app.proses(Tambah(Judul.dari('roti')));
      expect(keluaran.single, contains('perubahan dibatalkan'));
      expect(app.daftar, isEmpty); // state memori TIDAK berubah
      expect(p.percobaanTulis, 1); // permanen: tidak diulang
    });

    test('transien terus-menerus: habis jatah lalu dibatalkan', () {
      final p = PenyimpanSkrip(gagalTulisSebanyak: 99);
      final app =
          AplikasiTodo.muat(p, tidur: (_) {}, catat: diam).aplikasi;

      app.proses(Tambah(Judul.dari('roti')));
      expect(app.daftar, isEmpty);
      expect(p.percobaanTulis, 4); // maksPercobaan bawaan
    });

    test('data rusak dicadangkan dan sesi mulai kosong', () {
      final p = PenyimpanSkrip(isi: 'bukan json');
      final (:aplikasi, :peringatan) =
          AplikasiTodo.muat(p, tidur: (_) {}, catat: diam);
      expect(peringatan.single, contains('rusak'));
      expect(p.cadangan, 'bukan json');
      expect(aplikasi.daftar, isEmpty);
    });

    test('kegagalan baca naik sebagai GagalBaca', () {
      expect(
        () => AplikasiTodo.muat(PenyimpanSkrip(gagalBaca: true), catat: diam),
        throwsA(isA<GagalBaca>()),
      );
    });

    test('tidak menulis bila tidak ada perubahan', () {
      final p = PenyimpanSkrip();
      final app = AplikasiTodo.muat(p, tidur: (_) {}, catat: diam).aplikasi;
      app.proses(const Tampilkan());
      app.proses(const Batal()); // tidak ada yang dibatalkan
      expect(p.percobaanTulis, 0);
    });
  });

  group('PenyimpanBerkas (berkas nyata)', () {
    test('tulis lalu baca; berkas hilang menghasilkan null', () {
      final dir = Directory.systemTemp.createTempSync('uji_');
      addTearDown(() => dir.deleteSync(recursive: true));
      final s = PenyimpanBerkas('${dir.path}/todo.json');

      expect(s.baca(), isNull);
      s.tulis('[]');
      expect(s.baca(), '[]');
      expect(File('${dir.path}/todo.json.tmp').existsSync(), isFalse);
    });

    test('menulis ke direktori yang tak ada melempar GagalTulis', () {
      final s = PenyimpanBerkas('/tidak/ada/direktori/todo.json');
      expect(() => s.tulis('[]'), throwsA(isA<GagalTulis>()));
    });
  });
}
```

```bash
dart test
```

- `PenyimpanSkrip` adalah *fake yang dapat diprogram*: ia gagal menulis sebanyak `gagalTulisSebanyak` kali dengan penyebab yang bisa kita pilih — transien (`FileSystemException`) atau permanen (string biasa).
- `tidur: tidur.add` dan `tidur: (_) {}` — waktu tidur nyata tak pernah dipakai; tes berjalan seketika dan dapat menghitung berapa kali program akan tidur.
- Setiap tes membuktikan satu baris dari tabel kebijakan di Langkah 1.
- `addTearDown` membersihkan direktori sementara walau tes gagal — fungsi bracket (5.4) dalam bentuk tes.

### D. Variasi Kode untuk Logika yang Sama

| Kebijakan untuk data rusak | Kelebihan | Kekurangan |
| --- | --- | --- |
| Berhenti dengan galat (*fail-closed*) | Paling aman; tak ada keputusan otomatis | Pengguna tak dapat memakai aplikasi sampai memperbaiki manual |
| Cadangkan, mulai kosong, peringatkan (dipilih) | Aplikasi tetap dapat dipakai; data tak hilang | Daftar tampak kosong; pengguna harus memulihkan dari cadangan |
| Menimpa diam-diam | Paling sederhana | Data pengguna hilang tanpa jejak: **jangan** |

```dart
// Alternatif untuk retry: pemanggil memutuskan, bukan koordinator.
List<String> prosesTanpaRetry(Perintah perintah) {
  final (baru, keluaran) = jalankan(_riwayat, perintah);
  if (identical(baru, _riwayat)) return keluaran;
  _penyimpan.tulis(kodekan(baru.kini)); // GagalTulis naik ke pemanggil
  _riwayat = baru;
  return keluaran;
}
```

- Menaruh retry di koordinator menyederhanakan pemanggil tetapi menyembunyikan kebijakan; menaruhnya di pemanggil lebih fleksibel tetapi berulang. Pilih satu dan tuliskan.

### E. Terminologi Esensial

- **Fault injection** — menyuntikkan kegagalan secara sengaja di tes. **Fake terprogram** — implementasi palsu yang berperilaku sesuai skrip.
- **Komit setelah persisten** — mengubah state di memori hanya setelah penyimpanan berhasil. **Penjaga terakhir (last-resort handler)** — penangkap paling luar untuk bug yang lolos.
- **Fail-closed** — gagal ke keadaan aman yang menolak. **Peringatan (warning)** — keadaan tak biasa yang diteruskan dengan pemberitahuan.

### F. Visualisasi (ASCII)

```text
   proses(perintah)
      │
      ├─ jalankan (murni) ──► (riwayat baru, keluaran)
      │        tak berubah? ─── ya ──► kembalikan keluaran (tanpa menulis)
      │
      ├─ ulangi( tulis(kodekan(baru)) )   ← hanya penyebab transien diulang
      │        │
      │        ├─ sukses ──► _riwayat = baru ──► kembalikan keluaran
      │        └─ GagalTulis ──► log galat ──► 'gagal menyimpan; perubahan dibatalkan'
      │                                         (state memori tak berubah)
```

```text
   bin/ (tepi) ──► bukaAplikasi ──► AplikasiTodo.muat ──► Penyimpan.baca / dekode
      │                │                    │
      │                │ GagalSimpan        │ FormatException → cadangkan + peringatan
      │                ▼                    ▼
      │         pesan pengguna + log + exit 74       sesi mulai kosong
      │
      └─ catch terakhir (bug/Error) ──► log + jejak + exit 70
```

### G. Hubungan dengan Modul Lain

- **Memakai:** seluruh Fase 5 (5.1 taksonomi, 5.2 mekanisme, 5.3 `Hasil`, 5.4 all-or-nothing dan pembersihan, 5.5 I/O dan kode keluar, 5.6 retry, 5.7 pesan dan log), serta Fase 4 (antarmuka, injeksi) dan Fase 3 (riwayat, snapshot).
- **Dikembangkan di:** Fase 7 (penyimpanan asinkron dan timeout), Fase 9 (jalur berkas yang aman, pencegahan penulisan ke lokasi tak sah), Fase 10 (menguji kegagalan secara sistematis: fault injection, fuzzing berkas), Fase 11 (memisahkan paket penyimpanan dan antarmukanya).

### H. Tips & Praktik Terbaik

- Tulis tabel kebijakan *sebelum* kode, dan jadikan tiap baris sebuah test.
- Komit state di memori hanya setelah efek eksternal berhasil.
- Suntikkan semua sumber kegagalan dan ketidakpastian (penyimpanan, tidur, acak, pencatat) agar jalur gagal dapat dijalankan sesuka hati.
- Pertahankan satu penjaga terakhir di tingkat atas; di tempat lain, tangkap hanya yang dapat kamu tangani.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mengubah state memori sebelum menyimpan | Memori dan disk berbeda setelah kegagalan | Komit setelah persisten |
| Retry semua `GagalTulis` | Mengulang kegagalan permanen | Predikat `transienIo` pada penyebab |
| Menimpa data rusak tanpa cadangan | Data pengguna hilang | Cadangkan lalu mulai kosong dengan peringatan |
| Menangkap `Error` di banyak tempat | Bug tersembunyi | Satu penjaga terakhir di `main` |
| Menguji kegagalan dengan disk nyata | Tes lambat dan flaky | Fake terprogram dan injeksi |
| `exit()` di tengah penanganan | `finally` tak berjalan | Atur `exitCode`, biarkan `main` selesai |
| Pesan pengguna berisi jejak atau jalur internal | Kebocoran dan kebingungan | `untukPengguna` terpisah dari log |

### J. Sumber Referensi

- ✔ Error handling di Dart: https://dart.dev/language/error-handling
- ✔ Effective Dart — penggunaan: https://dart.dev/effective-dart/usage
- ✔ Pengujian di Dart: https://dart.dev/tools/testing
- API `exitCode`: https://api.dart.dev/stable/dart-io/exitCode.html
- Fault injection: https://en.wikipedia.org/wiki/Fault\_injection
- Lint `avoid_catches_without_on_clauses`: https://dart.dev/tools/linter-rules/avoid\_catches\_without\_on\_clauses

---

## Latihan Fase 5 (sengaja tanpa kunci jawaban)

Kerjakan sendiri, jalankan dengan `--enable-asserts`, lalu commit dengan struktur `fase-5/latihan-N/` berisi `README.md` (spesifikasi + tabel contoh), `lib/`, dan `test/`.

1. **\[5.1\]** Kumpulkan sepuluh kegagalan nyata (dari Dart, dari proyekmu, atau dari pengalaman: `int.parse`, `list.first` pada list kosong, membaca berkas, jaringan putus, saldo tak cukup, dan seterusnya). Klasifikasikan tiap kasus ke enam kelas, sebut tipe Dart-nya, tindakannya, dan di mana ia ditangani. Pilih satu kasus abu-abu dan pertahankan klasifikasimu dalam satu paragraf.
2. **\[5.2\]** Bangun hierarki exception sealed untuk modul konfigurasi, dengan `penyebab` dan penerjemahan memakai `Error.throwWithStackTrace`. Tulis test yang membuktikan bahwa stack trace asli terjaga. Lalu, tanpa menyalin, amati sendiri apa bedanya `rethrow` dengan `throw e` pada stack trace, dan tulis kesimpulanmu.
3. **\[5.3\]** Tulis `Hasil<T, G>` dari nol beserta `petakan`, `rantai`, `lipat`, dan `ambilAtau`. Susun pipeline validasi tiga langkah (parse → rentang → aturan bisnis) dengan tipe galat sealed. Bandingkan dengan versi berbasis exception dari sisi keterbacaan dan kepastian bahwa semua jenis kegagalan ditangani.
4. **\[5.4\]** Tulis `denganBerkas` dan versi `denganDuaBerkas` yang melepas resource secara LIFO, bahkan bila pelepasan pertama gagal. Uji dengan resource palsu yang mencatat urutan buka dan tutup, dan yang gagal saat ditutup; buktikan galat asli tidak tertimpa.
5. **\[5.5\]** Ubah penyimpanan agar memakai format berversi (`versi` + `data`). Tolak versi tak dikenal dengan galat sealed dan rancang migrasi dari v1 ke v2. Uji dengan berkas buatan: kosong, terpotong, UTF-8 rusak, versi masa depan.
6. **\[5.6\]** Perluas `ulangi` dengan batas total waktu (deadline; jam disuntikkan) dan agregasi semua galat percobaan. Uji tanpa tidur nyata. Tulis satu paragraf: kapan retry berbahaya, dan apa syarat idempotensi untuk operasi yang kamu pilih.
7. **\[5.7\]** Rancang pesan galat untuk enam kegagalan To-Do. Tiap pesan menyebut apa, mengapa (bila aman), dan apa yang dapat dilakukan; pisahkan versi pengguna dan versi log. Tulis test bahwa pesan pengguna tidak memuat jalur absolut ataupun stack trace, dan bahwa log memuat konteks yang dibutuhkan.
8. **\[5.8\]** Tambahkan ke To-Do v4 perintah `pulihkan` yang memuat dari berkas `.rusak` bila isinya valid. Buat tabel semua jalur kegagalan baru (baca, tulis, cadang, dekode) dengan keputusan, pesan pengguna, dan kode keluar masing-masing, lalu tulis test untuk setiap baris.

---

## Ringkasan Fase 5 & Daftar Periksa Kelulusan

| Modul | Satu kalimat inti |
| --- | --- |
| 5.1 | Klasifikasikan kegagalan dulu: siapa yang dapat memperbaikinya, dan dapatkah dipulihkan di tempat. |
| 5.2 | Tangkap yang spesifik, `rethrow` untuk meneruskan, `throwWithStackTrace` untuk menerjemahkan, jangan `return` di `finally`. |
| 5.3 | Kegagalan wajar dan sering sebagai data (`Hasil` sealed); exception untuk yang langka dan bug; terjemahkan di batas. |
| 5.4 | Lepaskan resource lewat fungsi bracket; operasi all-or-nothing lewat kandidat dan tukar; idempotensi sebagai prasyarat retry. |
| 5.5 | Coba-lalu-tangani, tulis atomik, terjemahkan galat I/O di adaptor, dan beri kode keluar yang bermakna. |
| 5.6 | Retry hanya untuk transien, dengan batas, backoff, jitter, dan idempotensi; suntikkan tidur dan acak. |
| 5.7 | Dua audiens, dua artefak: pesan untuk pengguna dan log untuk pengembang; jangan bocorkan rahasia. |
| 5.8 | Komit setelah persisten, retry yang selektif, data rusak dicadangkan, penjaga terakhir, dan fault injection di tes. |

**Daftar periksa kelulusan** (jawab tanpa membuka dokumen):

- [ ] Aku bisa mengklasifikasikan sebuah kegagalan ke enam kelas dan menyebut tindakan serta tempat penanganannya.
- [ ] Aku bisa menjelaskan beda `Error` dan `Exception`, mengapa `catch` tanpa `on` berbahaya, dan kapan satu-satunya `catch` terakhir sah.
- [ ] Aku bisa menjelaskan beda `rethrow` dan `throw e`, serta kapan memakai `Error.throwWithStackTrace`.
- [ ] Aku bisa menjelaskan mengapa `return` atau `throw` di dalam `finally` berbahaya.
- [ ] Aku bisa menulis `Hasil` sealed dengan `petakan` dan `rantai`, dan menentukan kapan `Hasil` lebih baik daripada exception.
- [ ] Aku bisa menulis fungsi bracket yang menjamin pelepasan resource tanpa menimpa galat asli.
- [ ] Aku bisa menjelaskan mengapa cek-lalu-pakai rapuh (TOCTOU), dan menulis penulisan atomik dengan berkas sementara dan `rename`.
- [ ] Aku bisa merancang retry dengan batas, backoff, jitter, dan predikat transien, serta menjelaskan peran idempotensi.
- [ ] Aku bisa menulis pesan galat untuk pengguna dan log untuk pengembang secara terpisah, tanpa membocorkan rahasia.
- [ ] Aku bisa menguji jalur gagal dengan fake terprogram (fault injection), tanpa disk nyata dan tanpa menunggu.
- [ ] Delapan latihan sudah di-commit dengan tabel contoh dan test.

**Pratinjau Fase 6 — Logika Efisiensi.** Model biaya dan notasi Big-O secara praktis; mengukur dengan benar (`Stopwatch`, benchmark yang adil, profiling dengan DevTools); memilih struktur data (`List`, `Set`, `Map`, `Queue`, urutan penyisipan pada `LinkedHashMap`); evaluasi malas (`Iterable`) vs eager; alokasi, tekanan GC, dan `const`; membangun string dan koleksi secara efisien; memoization dengan batas; serta pertukaran waktu vs ruang. Prasyaratnya adalah daftar periksa di atas terpenuhi.

---

## Referensi Induk Fase 5

> **Catatan verifikasi.** Tanda ✔ berarti halaman tersebut dibuka dan diverifikasi lewat pencarian atau pengambilan halaman saat dokumen ini disusun (15 November 2026); beberapa dibuka melalui cermin resmi `dart.cn` atau sumber kode dengan jalur yang sama. Tautan tanpa tanda adalah halaman resmi atau baku yang stabil, tetapi belum diverifikasi ulang; bila ada yang berpindah, cari judulnya di dart.dev atau di dokumentasi API.

**Dokumentasi resmi Dart**

- ✔ Error handling: https://dart.dev/language/error-handling · ✔ Effective Dart (penggunaan): https://dart.dev/effective-dart/usage · ✔ Pengujian: https://dart.dev/tools/testing
- API: https://api.dart.dev/stable/dart-core/Exception-class.html · https://api.dart.dev/stable/dart-core/Error-class.html · https://api.dart.dev/stable/dart-core/Error/throwWithStackTrace.html
- `dart:io`: https://api.dart.dev/stable/dart-io/FileSystemException-class.html · https://api.dart.dev/stable/dart-io/PathNotFoundException-class.html · https://api.dart.dev/stable/dart-io/OSError-class.html · https://api.dart.dev/stable/dart-io/exitCode.html · https://api.dart.dev/stable/dart-io/exit.html · https://api.dart.dev/stable/dart-io/sleep.html
- Lint: https://dart.dev/tools/linter-rules/control\_flow\_in\_finally · https://dart.dev/tools/linter-rules/avoid\_catches\_without\_on\_clauses · https://dart.dev/tools/linter-rules/only\_throw\_errors
- Paket: https://pub.dev/packages/logging · https://pub.dev/packages/retry · https://pub.dev/packages/file

**Konsep dan teori**

- Fail-fast: https://en.wikipedia.org/wiki/Fail-fast\_system · TOCTOU: https://en.wikipedia.org/wiki/Time-of-check\_to\_time-of-use · Idempotence: https://en.wikipedia.org/wiki/Idempotence · Fault injection: https://en.wikipedia.org/wiki/Fault\_injection
- Railway Oriented Programming: https://fsharpforfunandprofit.com/rop/ · Circuit Breaker: https://martinfowler.com/bliki/CircuitBreaker.html
- Amazon Builders' Library, *Timeouts, retries, and backoff with jitter*: https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/
- `sysexits`: https://man.freebsd.org/cgi/man.cgi?query=sysexits · OWASP Logging Cheat Sheet: https://cheatsheetseries.owasp.org/cheatsheets/Logging\_Cheat\_Sheet.html

**Buku bacaan lanjutan (tanpa tautan)**

- M. Nygard, *Release It!* — pola ketahanan: timeout, retry, circuit breaker, bulkhead.
- J. Bloch, *Effective Java* (bab tentang exception) — kapan memakai checked/unchecked dan menjaga kejelasan galat; prinsipnya berlaku lintas bahasa.
- S. Wlaschin, *Domain Modeling Made Functional* — memodelkan kegagalan sebagai bagian dari domain.

---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

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

