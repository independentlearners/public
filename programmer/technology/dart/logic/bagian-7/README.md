# Membangun Logika Dart — Fase 7: Logika Asinkron & Konkurensi

*Dari kode yang berjalan satu baris demi satu baris menjadi kode yang menunggu, membatalkan, mengalir, dan berbagi kerja tanpa saling merusak.*

| Atribut | Keterangan |
| --- | --- |
| Level | Advanced |
| Estimasi waktu | 3–4 minggu, ±40–50 jam (teori ±30%, praktik ±70%) |
| Prasyarat | Fase 6 selesai (daftar periksa kelulusan terpenuhi, latihan di-commit) |
| Alat esensial | Dart SDK stabil (per 15 November 2026: **3.14**), `dart:async`, `dart:isolate`, `package:async`, `package:pool`, `package:fake_async` (dev), `package:test` |
| Batas versi fitur | `async`/`await`/`Stream`: Dart 2+ · `Isolate.run`: ≥ 2.19 · `.wait` pada record `Future`: ≥ 3.0 · record dan pola: ≥ 3.0 |
| Komunitas | https://dart.dev/community · tag `dart` di https://stackoverflow.com/questions/tagged/dart · proposal bahasa di https://github.com/dart-lang/language |
| Sertifikasi | Tidak ada sertifikasi resmi khusus; portofolio berisi tes asinkron yang deterministik (tanpa tidur nyata) lebih bernilai |

**Hasil pembelajaran Fase 7** — setelah fase ini kamu mampu:

1. menjelaskan model eksekusi Dart (isolate, event loop, antrean microtask dan event) dan memprediksi urutan eksekusi kode asinkron;
2. menulis `async`/`await` yang benar: berurutan vs konkuren, penanganan galat, tanpa future yang terlupa;
3. merancang timeout, pembatalan, dan retry asinkron dengan dependensi waktu yang disuntikkan;
4. memakai `Stream` (single-subscription vs broadcast, `async*`, `await for`, langganan, *backpressure*) untuk pemrosesan bermemori konstan;
5. memakai isolate untuk pekerjaan berat CPU dengan memahami biaya penyalinan pesan dan batas isolate;
6. mengenali kondisi balapan pada titik `await`, mencegahnya, dan menguji kode asinkron secara deterministik.

---

## Daftar Isi Fase 7

<details>
  <summary>📃 Daftar Isi</summary>
 
- **0. Audit Kurikulum & Sambungan dari Fase 6**
- **7.1 Model Eksekusi:** isolate, event loop, microtask vs event
- **7.2 Future & async/await:** berurutan vs konkuren, galat, `Completer`
- **7.3 Kegagalan, Timeout, dan Pembatalan Asinkron**
- **7.4 Stream:** aliran data, langganan, backpressure
- **7.5 Isolate dan Paralelisme**
- **7.6 Kondisi Balapan & Konsistensi pada Titik await** *(TAMBAHAN)*
- **7.7 Menguji Kode Asinkron secara Deterministik** *(TAMBAHAN)*
- **7.8 Studi Kasus Terpadu: To-Do v6** *(TAMBAHAN)*
- **Latihan (tanpa kunci jawaban), Ringkasan, dan Referensi Induk**

</details>

---

## 0. Audit Kurikulum & Sambungan dari Fase 6

1. **Sambungan.** Fase 4.8 dan 5 memakai `Penyimpan` *sinkron* dan retry berbasis `sleep`; 5.6 menunda timeout dan pembatalan ke fase ini; Fase 6 menunda kecepatan lewat konkurensi. Fase 7 menuntaskan semuanya, dan memperlihatkan bahwa kode sinkron yang lama **membekukan seluruh isolate**: tak ada timer, tak ada callback I/O yang dapat berjalan sampai ia selesai.
2. **Temuan audit.** Kurikulum lazim mengajarkan sintaks `async`/`await` tanpa model eksekusi, sehingga pembelajar mengira *asinkron berarti paralel*. Padahal `async`/`await` memberi **konkurensi di satu thread**; paralelisme sungguhan hanya lewat isolate. Maka **7.1 (model eksekusi)** mendahului sintaks apa pun.
3. **Satu klaim penting yang diverifikasi saat penyusunan:** setiap isolate memiliki memori sendiri dan *satu thread* yang menjalankan event loop; tidak ada keadaan bersama antarisolate, sehingga *data race* tingkat memori (mutex, lock) tidak terjadi di Dart. Namun **kondisi balapan logis** tetap terjadi pada titik `await` di dalam satu isolate — inilah alasan modul **7.6**.
4. **TAMBAHAN:** 7.6 (kondisi balapan dan konsistensi), 7.7 (menguji kode asinkron secara deterministik), dan 7.8 (studi kasus To-Do v6 dengan penyimpanan asinkron, serialisasi penulisan, timeout, dan pekerjaan berat di isolate).
5. **Fakta yang diverifikasi.** (a) Event loop memproses antrean event dengan urutan *pertama masuk, pertama keluar*; kode sinkron lebih dulu, lalu seluruh microtask dikosongkan, lalu satu event, dan seterusnya. (b) Pesan antarisolate umumnya *disalin*; objek tak berubah (mis. `String`) dikirim sebagai referensi; `Isolate.exit` mengirim referensi pesan tanpa salinan; `Isolate.run` memakai `Isolate.exit` dan mengakhiri isolate setelah satu pesan. (c) `package:pool` mengelola kumpulan resource terbatas (berguna mengendalikan permintaan I/O konkuren); `package:async` menyediakan `CancelableOperation`, `StreamQueue`, dan `StreamGroup`; `package:fake_async` memungkinkan mengendalikan waktu di tes.
6. **Ditunda secara sadar:** *Zone* tingkat lanjut, FFI, dan kekhasan Flutter.
7. **Tidak ada koreksi substansial** pada materi Fase 1–6; `PenyimpanBerkas` sinkron dari Fase 5 dimigrasikan di 7.8.

> **Cara memakai dokumen ini** tetap sama: baca, tulis ulang dari ingatan, jalankan, bandingkan. Latihan di akhir tanpa kunci jawaban.

---

## 7.1 Model Eksekusi: Isolate, Event Loop, Microtask vs Event

*Motivasi: sebelum kamu menulis await, pahami siapa yang sedang menunggu dan apa yang terjadi selama ia menunggu.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membangun **model mental** eksekusi Dart: isolate dengan satu thread dan event loop, dua antrean (microtask dan event), urutan eksekusi, perbedaan **konkurensi** dan **paralelisme**, serta mengapa kode sinkron yang lama membekukan segalanya. Semua modul berikutnya bertumpu pada model ini.

### B. Konsep Kunci & Filosofi Mendalam

- **Isolate.** Unit eksekusi Dart dengan *memori sendiri*, *satu thread*, dan *event loop sendiri*. Program Dart minimal berisi satu isolate (isolate utama); isolate lain hanya dibuat bila kamu memintanya (7.5). Tak ada keadaan global bersama antarisolate.
- **Event loop.** Pada satu thread, loop mengambil event dari antrean secara *pertama masuk, pertama keluar* dan menjalankan tiap handler **sampai selesai** (*run-to-completion*): kode yang sedang berjalan tak pernah disela oleh event lain. Event berasal dari I/O selesai, timer, pesan isolate, dan masukan.
- **Dua antrean.** *Antrean microtask* berprioritas tinggi; *antrean event* untuk event biasa. Urutannya: jalankan kode sinkron saat ini → kosongkan **seluruh** microtask → ambil **satu** event → kosongkan microtask lagi → dan seterusnya.
- **Penjadwalan.** `Future(...)`, `Future.delayed(...)`, dan `Timer` menaruh pekerjaan di antrean *event*; `scheduleMicrotask` dan `Future.microtask` di antrean *microtask*. Kelanjutan sesudah `await` dijadwalkan lewat penyelesaian Future dan **selalu** menyerahkan kendali ke event loop lebih dulu, walau Future-nya sudah selesai.
- **Konkurensi vs paralelisme.** *Konkurensi*: banyak tugas berjalan bergantian dan saling tumpang-tindih (cocok untuk I/O: sementara satu menunggu, yang lain berjalan). *Paralelisme*: tugas berjalan *serentak* di beberapa inti. `async`/`await` memberi konkurensi di satu thread; paralelisme hanya lewat isolate.
- **Memblokir.** Kode sinkron yang lama (`sleep`, API `*Sync`, loop panjang) menahan thread: selama itu timer tak bisa menyala dan callback I/O tak bisa berjalan. Pada aplikasi interaktif, ini terlihat sebagai pembekuan.
- **Kelaparan (starvation).** Microtask yang terus menjadwalkan microtask baru mencegah event apa pun berjalan; gunakan antrean event untuk pekerjaan yang harus memberi giliran.
- **Menyerahkan giliran.** `await Future(() {})` atau `await Future.delayed(Duration.zero)` memberi event loop kesempatan memproses event lain sebelum melanjutkan — berguna untuk memecah pekerjaan sinkron yang panjang.
- **Filosofi:** tanyakan di setiap baris asinkron: *di titik ini kendali diserahkan; apa saja yang bisa terjadi sebelum aku kembali?*
- **Dampak desain:** salah paham model ini menghasilkan tiga bug klasik: mengira `await` membuat thread baru, membekukan aplikasi dengan kerja sinkron, dan mengandalkan urutan antar-Future yang independen.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — urutan: sinkron, microtask, event.**

```dart
import 'dart:async';

void main() {
  print('1 sinkron');
  scheduleMicrotask(() => print('3 microtask (scheduleMicrotask)'));
  Future(() => print('5 event (Future)'));
  Future.microtask(() => print('4 microtask (Future.microtask)'));
  Timer.run(() => print('6 event (Timer.run)'));
  print('2 sinkron');
}
```

```text
1 sinkron
2 sinkron
3 microtask (scheduleMicrotask)
4 microtask (Future.microtask)
5 event (Future)
6 event (Timer.run)
```

- Semua kode sinkron (`main` sampai selesai) berjalan lebih dulu; baru kemudian microtask dikosongkan *seluruhnya*, lalu event berjalan satu per satu sesuai urutan penjadwalan.
- Microtask berurutan sesuai kapan dijadwalkan (3 sebelum 4), begitu pula event (5 sebelum 6).
- Angka pada pesan hanya menandai urutan yang diharapkan; programnya sendiri tak bergantung pada angka itu.

**Contoh 2 — `await` selalu menyerahkan kendali.**

```dart
Future<void> kerja() async {
  print('A: mulai kerja'); // berjalan SINKRON sampai await pertama
  await null; // Future sudah selesai, tetapi await tetap menyerahkan kendali
  print('C: kelanjutan setelah await');
}

void main() {
  print('1: sebelum');
  kerja();
  print('B: setelah memanggil kerja (kerja belum selesai)');
}
```

```text
1: sebelum
A: mulai kerja
B: setelah memanggil kerja (kerja belum selesai)
C: kelanjutan setelah await
```

- Fungsi `async` berjalan sinkron sampai `await` pertama; di titik itu ia *mengembalikan Future yang belum selesai* ke pemanggil dan menyerahkan kendali.
- Kelanjutan (`C`) baru berjalan setelah kode sinkron pemanggil selesai — walau `await null` sudah "selesai".

**Contoh 3 — kode sinkron yang lama membekukan timer.**

```dart
import 'dart:async';
import 'dart:io';

void main() {
  Timer(const Duration(milliseconds: 10), () => print('timer 10 ms menyala'));
  final awal = DateTime.now();
  sleep(const Duration(milliseconds: 200)); // MEMBLOKIR isolate
  final lama = DateTime.now().difference(awal).inMilliseconds;
  print('selesai tidur (>= 200 ms: ${lama >= 200})');
}
```

```text
selesai tidur (>= 200 ms: true)
timer 10 ms menyala
```

- Timer dijadwalkan untuk 10 ms, tetapi event loop tak dapat memprosesnya selama `main` (sinkron) masih berjalan; ia baru menyala *setelah* `main` selesai.
- Inilah sebabnya `sleep` dan API `*Sync` di aplikasi yang harus tetap responsif adalah masalah; gunakan padanan asinkron (7.2) atau isolate (7.5).

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Menyerahkan giliran ke event loop di tengah pekerjaan sinkron yang panjang:
Future<int> jumlahBesar(List<int> data) async {
  var total = 0;
  for (var i = 0; i < data.length; i++) {
    total += data[i];
    if (i % 100000 == 99999) {
      await Future<void>.delayed(Duration.zero); // beri kesempatan event lain
    }
  }
  return total;
}
```

| Cara menjadwalkan | Antrean | Pakai bila |
| --- | --- | --- |
| `Future(() => ...)` / `Timer.run` | Event | Tugas biasa yang boleh menunggu giliran |
| `Future.delayed(d, ...)` / `Timer` | Event (setelah `d`) | Menunda beberapa waktu |
| `scheduleMicrotask` / `Future.microtask` | Microtask | Pekerjaan kecil yang harus selesai sebelum event berikutnya (jarang) |
| `await Future.delayed(Duration.zero)` | Event | Menyerahkan giliran di tengah pekerjaan panjang |
| `Isolate.run(...)` | Isolate terpisah | Pekerjaan berat CPU yang tak boleh memblokir (7.5) |

### E. Terminologi Esensial

- **Isolate** — unit eksekusi dengan memori dan event loop sendiri. **Event loop** — loop yang memproses antrean event satu per satu.
- **Microtask / event** — pekerjaan prioritas tinggi / pekerjaan biasa. **Run-to-completion** — handler berjalan sampai selesai tanpa disela.
- **Konkurensi / paralelisme** — tumpang-tindih bergantian / berjalan serentak. **Memblokir (blocking)** — menahan thread sehingga event lain tak bisa diproses.

### F. Visualisasi (ASCII)

```text
            ┌───────────────────────────────────────────────────┐
            │                  ISOLATE (satu thread)            │
            │                                                   │
  kode      │   1. jalankan kode sinkron sampai selesai         │
  sinkron ─►│   2. KOSONGKAN antrean microtask  [m1][m2]...     │
            │   3. ambil SATU event             [e1][e2][e3]... │
            │   4. kembali ke langkah 2                         │
            └───────────────────────────────────────────────────┘
   sumber event: I/O selesai · timer · pesan dari isolate lain · masukan
```

```text
  waktu ──►
  main():      ████ sinkron ████│ microtask │ event │ microtask │ event │ ...
  kerja():     ██ A ██ (await ──────────────► C ██)
                          └ menyerahkan kendali; kelanjutan dijadwalkan
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 4.2 (closure sebagai callback), 5.6 (`sleep` pada retry sinkron), 6.6 (I/O dan startup).
- **Prasyarat bagi:** 7.2–7.8. **Dikembangkan di:** Fase 9 (serangan penolakan layanan lewat pemblokiran event loop), Fase 10 (menguji urutan eksekusi), Fase 11 (batas isolate sebagai batas modul).

### H. Tips & Praktik Terbaik

- Bayangkan setiap `await` sebagai titik di mana dunia boleh berubah.
- Hindari `sleep` dan API `*Sync` di jalur yang harus responsif; pakai padanan asinkron.
- Jangan mengandalkan urutan eksekusi antara Future yang independen; ikat urutan dengan `await` atau rantai.
- Pakai microtask hanya bila benar-benar perlu; mayoritas kebutuhan terpenuhi oleh `Future` dan `await`.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mengira `await` membuat thread baru | Harapan paralelisme tak terpenuhi | Ingat: konkurensi satu thread; paralelisme = isolate |
| Kerja berat sinkron di isolate utama | Aplikasi membeku; timer terlambat | Isolate (7.5) atau pecah dengan penyerahan giliran |
| Mengandalkan urutan antar-Future independen | Bug yang muncul sesekali | Ikat urutan dengan `await` |
| `sleep` di kode asinkron | Seluruh isolate terhenti | `await Future.delayed(...)` |
| Rantai microtask tak berujung | Event tak pernah berjalan | Jadwalkan lewat antrean event |

### J. Sumber Referensi

- ✔ Concurrency di Dart (event loop, isolate, pesan): https://dart.dev/language/concurrency
- Asynchronous programming (codelab): https://dart.dev/codelabs/async-await
- API `dart:async`: https://api.dart.dev/stable/dart-async/dart-async-library.html
- Event loop (konsep): https://en.wikipedia.org/wiki/Event\_loop · Concurrency vs parallelism: https://en.wikipedia.org/wiki/Concurrent\_computing

---

## 7.2 Future & async/await: Berurutan vs Konkuren, Galat, Completer

*Motivasi: menunggu bukan berarti diam — menunggu dengan benar berarti mengerjakan hal lain dan tak pernah kehilangan kabar buruk.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas `Future<T>` dan `async`/`await`: tiga keadaan Future, menunggu hasil, **berurutan vs konkuren** (`await` berurutan, `Future.wait`, `.wait` pada record), **penanganan galat**, bahaya **Future yang terlupa** (`unawaited`), jebakan `return` tanpa `await` di dalam `try`, `Completer` untuk menjembatani callback, dan membatasi konkurensi dengan `Pool`.

### B. Konsep Kunci & Filosofi Mendalam

- **`Future<T>`** mewakili hasil yang tersedia *nanti*: belum selesai, selesai dengan nilai, atau selesai dengan galat. Callback `then`, `catchError`, dan `whenComplete` adalah cara lama; `async`/`await` membuatnya terbaca seperti kode sinkron dan memetakan galat ke `try`/`catch`.
- **Fungsi `async`** selalu mengembalikan `Future`; badannya berjalan sinkron sampai `await` pertama (7.1). **`await`** menunggu Future selesai tanpa memblokir isolate: ia menyerahkan kendali, lalu melanjutkan dengan nilainya atau melempar galatnya.
- **Berurutan vs konkuren.** `await a(); await b();` menjumlahkan waktu keduanya. Memulai keduanya dulu (`final fa = a(); final fb = b();`) atau memakai `Future.wait([...])` membuat keduanya berjalan tumpang-tindih sehingga totalnya mendekati yang terlama. Pakai `Future.wait` bila langkahnya *independen*.
- **`Future.wait`** menunggu semua Future; secara bawaan menunggu *seluruhnya* selesai lalu melaporkan galat; `eagerError: true` selesai lebih awal pada galat pertama (yang lain tetap berjalan). Sejak Dart 3, `(f1, f2).wait` pada **record** mengembalikan record hasil dengan tipe masing-masing.
- **Galat Future.** Galat dari Future yang di-`await` ditangkap oleh `try`/`catch` pemanggil. Galat dari Future yang *tidak pernah di-await dan tak ditangani* menjadi **galat asinkron tak tertangani** dan dapat menjatuhkan program.
- **Future yang terlupa.** Memanggil fungsi `async` tanpa `await` membuatnya berjalan tanpa diawasi: galatnya tak tertangkap dan urutannya tak terjamin. Lint `unawaited_futures` menandainya. Bila memang disengaja (*fire-and-forget*), bungkus dengan `unawaited(...)` dan **tetap tangani galatnya**.
- **`return` tanpa `await` di dalam `try`.** `return panggilanAsync();` di dalam `try` mengembalikan Future *tanpa menunggu*, sehingga `catch` di fungsi itu tak menangkap galatnya. Di dalam `try`, tulis `return await panggilanAsync();`.
- **`Completer<T>`** membuat Future yang diselesaikan secara manual (`complete`/`completeError`) — berguna menjembatani API berbasis callback. Hanya boleh diselesaikan **sekali**.
- **Batas konkurensi.** Menjalankan ribuan Future sekaligus dapat menghabiskan koneksi atau deskriptor berkas. `Pool` (`package:pool`) membatasi jumlah pekerjaan yang berjalan bersamaan.
- **`FutureOr<T>`** — nilai `T` *atau* `Future<T>`; dipakai untuk API yang boleh sinkron maupun asinkron.
- **Filosofi:** setiap Future harus *dimiliki*: ada yang menunggunya, atau ada yang sengaja melepaskannya dengan penanganan galat.
- **Dampak desain:** Future terlupa dan galat tak tertangkap adalah sumber bug asinkron paling licin: tampak berjalan di tes, gagal diam-diam di produksi.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — berurutan vs konkuren.**

```dart
Future<String> ambil(String nama, int ms) async {
  await Future<void>.delayed(Duration(milliseconds: ms));
  return nama;
}

Future<void> main() async {
  final jam = Stopwatch()..start();
  final a = await ambil('a', 100);
  final b = await ambil('b', 100); // baru mulai setelah 'a' selesai
  final berurutan = jam.elapsedMilliseconds;

  jam
    ..reset()
    ..start();
  final hasil = await Future.wait([ambil('a', 100), ambil('b', 100)]);
  final konkuren = jam.elapsedMilliseconds;

  print('berurutan >= 200 ms: ${berurutan >= 200}');
  print('konkuren < 200 ms: ${konkuren < 200}');
  print('$a $b $hasil');
}
```

```text
berurutan >= 200 ms: true
konkuren < 200 ms: true
a b [a, b]
```

- Dua `await` berurutan menjumlahkan waktu (≈200 ms); `Future.wait` memulai keduanya sekaligus sehingga totalnya ≈100 ms.
- Hasil `Future.wait` berurutan sesuai urutan *daftar*, bukan urutan selesai.
- Contoh berbasis waktu nyata ini ilustratif; modul 7.7 menunjukkan cara mengujinya tanpa menunggu.

**Contoh 2 — record `.wait` dan galat yang tertangkap.**

```dart
import 'dart:async';

Future<int> gagal() async {
  await Future<void>.delayed(const Duration(milliseconds: 10));
  throw const FormatException('rusak');
}

Future<void> main() async {
  final (x, y) = await (ambil('x', 50), Future.value(42)).wait;
  print('$x $y'); // x 42  (tipe tiap elemen terjaga: String dan int)

  try {
    await gagal();
  } on FormatException catch (e) {
    print('tertangkap: ${e.message}');
  }

  // Fire-and-forget yang DISENGAJA, dengan penanganan galat:
  unawaited(gagal().catchError((Object e) => 0));
}
```

- `(f1, f2).wait` memulai keduanya dan mengembalikan record hasil dengan tipe masing-masing.
- `try { await gagal(); } on FormatException` — galat Future ditangkap seperti galat biasa.
- `unawaited(...)` menyatakan niat melepas Future; `catchError` memastikan galatnya tak menjadi galat tak tertangani.

**Contoh 3 — `return` tanpa `await` di dalam `try`.**

```dart
Future<int> salah() async {
  try {
    return gagal(); // Future dikembalikan tanpa ditunggu: catch di bawah TIDAK menangkap
  } on FormatException {
    return -1;
  }
}

Future<int> benar() async {
  try {
    return await gagal(); // await di dalam try: galat tertangkap di sini
  } on FormatException {
    return -1;
  }
}

Future<void> main() async {
  print(await benar()); // -1
  try {
    await salah();
  } on FormatException {
    print('galat lolos dari catch di dalam salah()');
  }
}
```

- Pada `salah`, tidak ada exception yang dilempar *di dalam* `try` — hanya sebuah Future yang akan gagal nanti — sehingga `catch` tak pernah jalan.
- Pada `benar`, `await` membuat galat dilempar di dalam `try`, dan `catch` menangkapnya.

**Contoh 4 — `Completer` menjembatani callback.**

```dart
import 'dart:async';

Future<String> setelah(Duration d, String nilai) {
  final c = Completer<String>();
  Timer(d, () => c.complete(nilai)); // API berbasis callback
  return c.future;
}

Future<void> main() async {
  print(await setelah(const Duration(milliseconds: 20), 'data')); // data
}
```

- `Completer` memiliki `future` yang kamu kembalikan, dan kamu menyelesaikannya kapan pun callback datang.
- Menyelesaikan dua kali melempar `StateError`; pastikan setiap jalur menyelesaikannya tepat sekali.

**Contoh 5 — membatasi konkurensi dengan `Pool`.**

```bash
dart pub add pool
```

```dart
import 'package:pool/pool.dart';

Future<List<String>> ambilSemua(List<String> id, {int maksKonkuren = 3}) async {
  final pool = Pool(maksKonkuren);
  try {
    return await Future.wait(
      id.map((i) => pool.withResource(() => ambil(i, 50))),
    );
  } finally {
    await pool.close();
  }
}
```

- `Pool(3)` mengizinkan paling banyak tiga pekerjaan berjalan sekaligus; sisanya menunggu giliran.
- `withResource` memberi dan mengembalikan "slot" otomatis, walau pekerjaan gagal; `pool.close()` di `finally` (5.4) melepas pool.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Gaya callback (then): setara, tetapi lebih sulit dibaca dan ditangani galatnya.
Future<int> viaThen() => ambil('x', 10)
    .then((s) => s.length)
    .catchError((Object e) => -1);

// whenComplete: setara finally untuk Future.
Future<void> dengan(Future<void> kerja) =>
    kerja.whenComplete(() => print('bersihkan'));
```

| Kebutuhan | Bentuk | Catatan |
| --- | --- | --- |
| Langkah bergantung hasil sebelumnya | `await` berurutan | Waktu dijumlahkan |
| Langkah independen | `Future.wait` atau `(f1, f2).wait` | Waktu ≈ yang terlama |
| Banyak pekerjaan, sumber daya terbatas | `Pool.withResource` | Batas konkurensi |
| Menjembatani callback | `Completer` | Selesaikan tepat sekali |
| Pembersihan setelah Future | `try/finally` dengan `await`, atau `whenComplete` | Tetap di jalur gagal |
| Melepas Future sengaja | `unawaited(f.catchError(...))` | Tanpa penanganan galat = bug |

### E. Terminologi Esensial

- **Future** — hasil yang tersedia nanti. **`async`/`await`** — sintaks untuk menulis dan menunggu Future. **`Completer`** — Future yang diselesaikan manual.
- **Fire-and-forget** — memulai pekerjaan tanpa menunggu. **Galat asinkron tak tertangani** — galat Future tanpa penanganan. **`FutureOr<T>`** — `T` atau `Future<T>`.
- **Pool** — pembatas jumlah pekerjaan konkuren. **Eager error** — selesai segera pada galat pertama.

### F. Visualisasi (ASCII)

```text
  berurutan:   |── ambil a (100) ──||── ambil b (100) ──|      total ≈ 200 ms
  konkuren:    |── ambil a (100) ──|
               |── ambil b (100) ──|                           total ≈ 100 ms
```

```text
  try {
    return gagal();        ← mengembalikan Future yang BELUM selesai; keluar dari try
  } on FormatException {   ← tak pernah jalan; galat muncul belakangan di pemanggil
    ...
  }

  try {
    return await gagal();  ← menunggu DI DALAM try; galat dilempar di sini
  } on FormatException { ... }
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 7.1 (model eksekusi), 5.2 dan 5.4 (galat, `finally`, pembersihan), 4.2 (closure dan tear-off), 3.3 dan 2.5 (record dan pola untuk `.wait`).
- **Prasyarat bagi:** 7.3–7.8. **Dikembangkan di:** Fase 9 (batas konkurensi sebagai pertahanan), Fase 10 (menguji Future).

### H. Tips & Praktik Terbaik

- Aktifkan lint `unawaited_futures`; setiap Future harus di-`await` atau sengaja dilepas dengan `unawaited` dan penanganan galat.
- Mulai pekerjaan independen bersamaan (`Future.wait`), tetapi batasi dengan `Pool` bila jumlahnya besar.
- Di dalam `try`, tulis `return await`.
- Beri nama dan tipe pada Future yang kamu simpan (`final Future<int> hasil`) agar niat menunggunya jelas.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Lupa `await` | Galat tak tertangkap; urutan tak terjamin | Lint `unawaited_futures`; `await` |
| `await` berurutan untuk langkah independen | Lebih lambat dari perlu | `Future.wait` |
| Ribuan Future sekaligus | Kehabisan koneksi atau deskriptor | `Pool` |
| `return f()` tanpa `await` di dalam `try` | `catch` tak menangkap galat | `return await f()` |
| Menyelesaikan `Completer` dua kali | `StateError` | Pastikan tepat sekali |
| `unawaited` tanpa penanganan galat | Galat tak tertangani di produksi | Tambahkan `catchError` atau penanganan |

### J. Sumber Referensi

- ✔ Concurrency di Dart: https://dart.dev/language/concurrency
- Asynchronous programming (codelab): https://dart.dev/codelabs/async-await · Futures dan penanganan galat: https://dart.dev/libraries/async/futures-error-handling
- Lint `unawaited_futures`: https://dart.dev/tools/linter-rules/unawaited\_futures
- API `Future`: https://api.dart.dev/stable/dart-async/Future-class.html · `Completer`: https://api.dart.dev/stable/dart-async/Completer-class.html
- ✔ Paket `pool` (mengelola kumpulan resource terbatas): https://pub.dev/packages/pool

---

## 7.3 Kegagalan, Timeout, dan Pembatalan Asinkron

*Motivasi: menunggu tanpa batas adalah janji yang tak akan ditepati — dan membatalkan tanpa membersihkan adalah utang yang tak terlihat.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas tiga hal yang sering dilupakan pada kode asinkron: **timeout** (berapa lama kita bersedia menunggu), **pembatalan** (menghentikan pekerjaan yang tak lagi diperlukan), dan **kegagalan** (galat yang menjalar lewat Future dan bagaimana menjaganya tetap terlihat). Kamu menulis token pembatalan, memakai `CancelableOperation`, membuat retry asinkron dengan dependensi waktu yang disuntikkan (melanjutkan 5.6), dan memasang penjaga terakhir untuk galat tak tertangani.

### B. Konsep Kunci & Filosofi Mendalam

- **Galat menjalar lewat Future.** Galat dari Future yang di-`await` muncul sebagai exception di pemanggil. Galat dari Future yang tak ditunggu dan tak ditangani menjadi *galat tak tertangani* di zone saat ini dan dapat menghentikan isolate; karena itu setiap Future harus dimiliki (7.2).
- **`timeout` bukan pembatalan.** `future.timeout(durasi)` mengembalikan Future baru yang gagal dengan `TimeoutException` (atau menjalankan `onTimeout`) bila Future asal belum selesai tepat waktu, tetapi **pekerjaan di baliknya terus berjalan**; hasilnya hanya diabaikan. Sumber daya yang dipakai tetap terpakai sampai selesai.
- **Dart tidak punya pembatalan Future bawaan.** Pembatalan harus dirancang: (1) **token pembatalan** yang diperiksa pekerjaan di titik-titik aman (*cooperative cancellation*); (2) **`CancelableOperation`** (`package:async`) yang membungkus Future dan menyediakan `cancel()`; (3) membatalkan **langganan Stream** (7.4); (4) membunuh **isolate** (7.5).
- **Pembatalan kooperatif.** Pekerjaan memeriksa token *sebelum tiap langkah*, melempar `PembatalanException` (galat wajar, bukan bug) dan membersihkan lewat `finally`. Tanpa titik pemeriksaan, pekerjaan tak dapat dihentikan.
- **Pembatalan harus membersihkan.** Menghentikan di tengah operasi berarti resource yang terbuka harus dilepas dan state setengah-jadi harus dibatalkan (5.4). `CancelableOperation.fromFuture(..., onCancel: ...)` memberi tempat untuk itu.
- **Strategi timeout.** Pasang timeout di *batas* operasi (bukan di setiap langkah kecil), pilih nilai berdasarkan pengukuran, dan pertimbangkan *deadline mutlak* yang diteruskan ke bawah agar timeout per langkah tidak menumpuk melebihi anggaran total.
- **Retry asinkron.** Aturannya sama dengan 5.6 (hanya transien, batas percobaan, backoff, jitter, idempotensi), tetapi menunggu memakai `Future.delayed` yang *disuntikkan* agar tes tidak menunggu waktu nyata. `TimeoutException` adalah `Exception` dan dapat dinilai oleh predikat `bisaDiulang`.
- **Penjaga terakhir.** `runZonedGuarded(body, onError)` menangkap galat asinkron yang lolos dari seluruh penanganan: catat dengan jejak, atur `exitCode`, dan berhenti (5.8).
- **Filosofi:** setiap pekerjaan yang dimulai harus punya akhir yang dirancang: selesai, gagal, kedaluwarsa, atau dibatalkan — dan masing-masing membersihkan.
- **Dampak desain:** timeout tanpa pembatalan menumpuk pekerjaan yatim di latar; pembatalan tanpa pembersihan membocorkan resource; keduanya sulit ditemukan karena tak ada error yang tampak.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — timeout tidak membatalkan.**

```dart
import 'dart:async';

Future<String> lambat() async {
  await Future<void>.delayed(const Duration(milliseconds: 300));
  print('lambat() tetap selesai dikerjakan');
  return 'hasil';
}

Future<void> main() async {
  try {
    await lambat().timeout(const Duration(milliseconds: 50));
  } on TimeoutException catch (e) {
    print('timeout setelah ${e.duration?.inMilliseconds} ms');
  }

  // Dengan nilai cadangan alih-alih galat:
  final nilai = await lambat().timeout(
    const Duration(milliseconds: 50),
    onTimeout: () => 'cadangan',
  );
  print(nilai); // cadangan

  await Future<void>.delayed(const Duration(milliseconds: 400)); // beri waktu pekerjaan latar
}
```

```text
timeout setelah 50 ms
cadangan
lambat() tetap selesai dikerjakan
lambat() tetap selesai dikerjakan
```

- Kedua panggilan `lambat()` *tetap berjalan sampai selesai* walaupun pemanggil sudah menyerah (dua cetakan di akhir) — `timeout` hanya berhenti menunggu.
- `onTimeout` mengganti galat dengan nilai cadangan; tanpanya dilempar `TimeoutException`.

**Contoh 2 — pembatalan kooperatif dengan token.**

```dart
import 'dart:async';

class PembatalanException implements Exception {
  const PembatalanException();
  @override
  String toString() => 'PembatalanException: operasi dibatalkan';
}

class TokenBatal {
  bool _batal = false;
  bool get dibatalkan => _batal;
  void batalkan() => _batal = true;

  void periksa() {
    if (_batal) throw const PembatalanException();
  }
}

Future<int> prosesBanyak(List<int> data, TokenBatal token) async {
  var total = 0;
  for (final x in data) {
    token.periksa(); // titik pembatalan: sebelum tiap langkah
    total += x;
    await Future<void>.delayed(const Duration(milliseconds: 10)); // titik penyerahan giliran
  }
  return total;
}

Future<void> main() async {
  final token = TokenBatal();
  final kerja = prosesBanyak(List<int>.generate(100, (i) => i), token);
  Timer(const Duration(milliseconds: 35), token.batalkan);
  try {
    await kerja;
  } on PembatalanException {
    print('dibatalkan dengan rapi');
  }
}
```

- `periksa()` dipanggil sebelum tiap langkah; saat token dibatalkan, pekerjaan berhenti di titik aman berikutnya dan melempar galat wajar.
- Pembatalan bersifat *kooperatif*: tanpa titik pemeriksaan di dalam pekerjaan, token tak berpengaruh.
- `token.batalkan` dikirim sebagai *tear-off* ke `Timer` (4.2).

**Contoh 3 — `CancelableOperation` dari `package:async`.**

```bash
dart pub add async
```

```dart
import 'dart:async';

import 'package:async/async.dart';

Future<void> main() async {
  var dibersihkan = false;
  final op = CancelableOperation.fromFuture(
    Future<String>.delayed(const Duration(milliseconds: 200), () => 'selesai'),
    onCancel: () => dibersihkan = true,
  );
  Timer(const Duration(milliseconds: 20), op.cancel);
  final hasil = await op.valueOrCancellation('dibatalkan');
  print('$hasil dibersihkan=$dibersihkan'); // dibatalkan dibersihkan=true
}
```

- `cancel()` menandai operasi batal dan memanggil `onCancel` — tempat melepas resource atau menghentikan pekerjaan yang dapat dihentikan.
- `valueOrCancellation('dibatalkan')` mengembalikan hasil bila selesai, atau nilai pembatalan bila dibatalkan.
- Future yang dibungkus *tidak otomatis berhenti*; `CancelableOperation` hanya berhenti meneruskan hasilnya. Penghentian nyata tetap tanggung jawab `onCancel`.

**Contoh 4 — retry asinkron dengan penantian yang disuntikkan.**

```dart
import 'dart:async';
import 'dart:math';

Future<void> _tungguNyata(Duration d) => Future<void>.delayed(d);

Future<T> ulangiAsinkron<T>(
  Future<T> Function() aksi, {
  required bool Function(Object galat) bisaDiulang,
  int maksPercobaan = 4,
  Duration jedaAwal = const Duration(milliseconds: 100),
  Duration jedaMaks = const Duration(seconds: 5),
  Future<void> Function(Duration jeda) tunggu = _tungguNyata,
  Random? acak,
}) async {
  if (maksPercobaan < 1) {
    throw ArgumentError.value(maksPercobaan, 'maksPercobaan', 'harus >= 1');
  }
  final r = acak ?? Random();
  var jeda = jedaAwal;
  for (var percobaan = 1;; percobaan++) {
    try {
      return await aksi(); // await DI DALAM try: galat tertangkap di sini
    } on Exception catch (e) {
      if (percobaan >= maksPercobaan || !bisaDiulang(e)) rethrow;
      await tunggu(Duration(milliseconds: r.nextInt(jeda.inMilliseconds + 1)));
      jeda = jeda * 2 > jedaMaks ? jedaMaks : jeda * 2;
    }
  }
}

Future<void> main() async {
  var panggilan = 0;
  final jedaTercatat = <Duration>[];
  final hasil = await ulangiAsinkron<int>(
    () async {
      panggilan++;
      if (panggilan < 3) throw TimeoutException('lambat');
      return 42;
    },
    bisaDiulang: (e) => e is TimeoutException,
    tunggu: (d) async => jedaTercatat.add(d), // tanpa menunggu nyata
    acak: Random(1),
  );
  print('$hasil setelah $panggilan percobaan, ${jedaTercatat.length} jeda'); // 42 setelah 3 percobaan, 2 jeda
}
```

- Strukturnya sama dengan `ulangi` (5.6), tetapi `aksi` dan `tunggu` bertipe `Future`, dan `return await aksi()` berada *di dalam* `try` agar galatnya tertangkap.
- `tunggu` yang disuntikkan membuat tes berjalan seketika dan dapat memeriksa jedanya (7.7 melanjutkan dengan `fake_async`).
- `TimeoutException` bertipe `Exception`, sehingga predikat `bisaDiulang` dapat menganggapnya transien.

**Contoh 5 — penjaga terakhir untuk galat asinkron tak tertangani.**

```dart
import 'dart:async';
import 'dart:io';

void main() {
  runZonedGuarded(() {
    unawaited(Future<void>.delayed(Duration.zero, () => throw StateError('bug asinkron')));
  }, (galat, jejak) {
    stderr.writeln('galat tak tertangani: $galat');
    stderr.writeln(jejak);
    exitCode = 70; // EX_SOFTWARE (5.5)
  });
}
```

- `runZonedGuarded` menjalankan `body` dalam zone yang menangkap galat asinkron yang tak ditangani siapa pun.
- Seperti penjaga terakhir di 5.8: catat dengan jejak, atur `exitCode`, dan jangan mencoba melanjutkan.

### D. Opsi Kode Lain untuk Logika yang Sama

| Kebutuhan | Mekanisme | Menghentikan pekerjaan? | Catatan |
| --- | --- | --- | --- |
| Berhenti menunggu | `future.timeout(...)` | **Tidak** | Hasil diabaikan; pekerjaan lanjut |
| Membatalkan pekerjaan sendiri | Token kooperatif | Ya, di titik pemeriksaan | Perlu titik-titik aman |
| Membatalkan pembungkus Future | `CancelableOperation` | Hanya lewat `onCancel` | Meneruskan hasil dihentikan |
| Membatalkan aliran | `StreamSubscription.cancel()` | Ya (7.4) | Produsen dapat membersihkan di `onCancel` |
| Membatalkan pekerjaan berat | Membunuh isolate (7.5) | Ya, paksa | Resource di isolate itu hilang bersamanya |

### E. Terminologi Esensial

- **Timeout** — batas waktu menunggu. **Pembatalan kooperatif** — pekerjaan memeriksa token dan berhenti sendiri. **Deadline** — batas waktu mutlak untuk seluruh operasi.
- **Galat asinkron tak tertangani** — galat Future tanpa penanganan yang diteruskan ke zone. **Zone** — konteks eksekusi yang dapat mencegat galat dan penjadwalan.
- **Pekerjaan yatim** — pekerjaan yang masih berjalan padahal tak ada yang menunggu hasilnya.

### F. Visualisasi (ASCII)

```text
  waktu ──►
  pemanggil :  |── menunggu ──| timeout! (TimeoutException)  ... lanjut
  pekerjaan :  |───────────── tetap berjalan sampai selesai ──────────────|   ← YATIM bila tak dibatalkan

  dengan pembatalan kooperatif:
  pemanggil :  |── menunggu ──| batalkan() ... 
  pekerjaan :  |── langkah ──|✓periksa|── langkah ──|✓periksa → PembatalanException → finally membersihkan
```

```text
  hidup sebuah pekerjaan asinkron:

   mulai ──► berjalan ──┬──► selesai (nilai)
                        ├──► gagal (galat)           → semuanya HARUS membersihkan resource
                        ├──► kedaluwarsa (timeout)
                        └──► dibatalkan
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 7.2 (Future dan galat), 5.4 dan 5.6 (pembersihan, retry), 5.8 (penjaga terakhir), 4.7 (injeksi fungsi).
- **Prasyarat bagi:** 7.4–7.8. **Dikembangkan di:** Fase 9 (timeout sebagai pertahanan terhadap penolakan layanan), Fase 10 (menguji timeout dan pembatalan tanpa menunggu).

### H. Tips & Praktik Terbaik

- Setiap operasi yang menunggu dunia luar harus punya timeout; setiap pekerjaan yang dapat dibatalkan harus membersihkan.
- Jangan menyamakan `timeout` dengan pembatalan; rancang cara menghentikan pekerjaan di baliknya.
- Suntikkan fungsi menunggu agar retry dan timeout dapat diuji tanpa tidur nyata.
- Pasang satu penjaga terakhir di `main` (`runZonedGuarded`) untuk galat asinkron yang lolos.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mengira `timeout` menghentikan pekerjaan | Pekerjaan yatim menumpuk | Rancang pembatalan (token/`CancelableOperation`) |
| Pembatalan tanpa titik pemeriksaan | `batalkan()` tak berpengaruh | Periksa token sebelum tiap langkah |
| Membatalkan tanpa `finally` | Resource bocor | Bersihkan di `finally` atau `onCancel` |
| Timeout di setiap langkah kecil | Total melebihi anggaran | Timeout di batas operasi atau deadline mutlak |
| Retry asinkron memakai `Future.delayed` nyata di tes | Tes lambat dan flaky | Suntikkan fungsi tunggu |
| `return f()` tanpa `await` di dalam `try` pada retry | Galat tak tertangkap; retry tak pernah jalan | `return await f()` |

### J. Sumber Referensi

- Futures dan penanganan galat: https://dart.dev/libraries/async/futures-error-handling
- API `Future.timeout`: https://api.dart.dev/stable/dart-async/Future/timeout.html · `TimeoutException`: https://api.dart.dev/stable/dart-async/TimeoutException-class.html
- API `runZonedGuarded`: https://api.dart.dev/stable/dart-async/runZonedGuarded.html
- ✔ Paket `async` (`CancelableOperation`, `StreamQueue`, `StreamGroup`): https://pub.dev/packages/async
- AWS Builders' Library, *Timeouts, retries, and backoff with jitter*: https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/

---

## 7.4 Stream: Aliran Data, Langganan, Backpressure

*Motivasi: data yang tak muat di memori tetap bisa diolah — asalkan kamu memperlakukannya sebagai aliran, bukan tumpukan.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas `Stream<T>`: deretan *event* asinkron (data, galat, selesai). Kamu belajar perbedaan **single-subscription** dan **broadcast**, cara membuatnya (`async*`, `StreamController`, `File.openRead`), cara mengonsumsinya (`await for`, `listen`, `StreamSubscription`), **backpressure**, pembatalan langganan, serta pemrosesan berkas besar dengan memori konstan. Stream adalah padanan asinkron dari `Iterable` (6.4).

### B. Konsep Kunci & Filosofi Mendalam

- **Tiga jenis event:** *data*, *galat*, dan *selesai* (done). Sebuah stream dapat menghasilkan banyak data dan galat, lalu selesai satu kali.
- **Single-subscription (bawaan)** hanya boleh didengarkan *satu kali*; event ditahan (di-buffer) sampai ada pendengar; mendengarkan lagi melempar `StateError`. **Broadcast** boleh punya banyak pendengar dan *tidak* menahan event: event yang terjadi saat tak ada pendengar **hilang**.
- **Cara membuat:** `Stream.fromIterable`, `Stream.periodic`, fungsi **generator `async*`** dengan `yield`, `StreamController`, dan sumber bawaan seperti `File.openRead()` dan `stdin`.
- **Cara mengonsumsi:** `await for (final x in stream)` (urutan, galat menjadi exception, langganan otomatis dibatalkan saat keluar); `listen(...)` mengembalikan `StreamSubscription` (dapat `pause`, `resume`, `cancel`); metode ringkas seperti `first`, `toList`, `fold`, `forEach`, serta transformasi `map`, `where`, `take`, `asyncMap`.
- **Backpressure (tarik, bukan dorong).** Dengan `await for` pada generator `async*`, produsen hanya berjalan *saat konsumen meminta*: selama badan loop konsumen belum selesai, generator tertahan di `yield`. Inilah yang membuat pemrosesan berkas besar dapat berjalan dengan memori konstan. `StreamController` biasa justru *menampung* event bila pendengar lambat atau dijeda: tanpa penanganan `onPause`/`onResume`, buffer-nya tumbuh tanpa batas.
- **Galat pada `listen` vs `await for`.** Di `await for`, galat dilempar dan loop berakhir. Di `listen`, galat diteruskan ke `onError`; bila tak disediakan, galat menjadi tak tertangani. Bawaan `cancelOnError` adalah `false`.
- **Siklus hidup dan resource.** Langganan yang tak dibatalkan menahan sumber (berkas terbuka, timer, soket). Batalkan di `finally`, atau andalkan `await for` yang membatalkan otomatis; `StreamController` perlu `close()` dan `onCancel` untuk membersihkan.
- **Dingin vs panas.** Stream single-subscription umumnya *dingin*: produksi baru dimulai saat didengarkan. Broadcast bersifat *panas*: produksi berjalan terlepas dari ada tidaknya pendengar.
- **Gaya tarik dengan `StreamQueue`** (`package:async`): mengambil event satu per satu (`next`, `peek`) dari stream, berguna untuk pengurai berurutan; `StreamGroup` menggabungkan banyak stream.
- **Filosofi:** perlakukan data besar sebagai aliran yang melewati program, bukan koleksi yang berdiam di dalamnya.
- **Dampak desain:** salah memilih jenis stream (broadcast yang kehilangan event, single yang didengarkan dua kali) dan lupa membatalkan langganan adalah dua bug Stream yang paling sering.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — `async*` dan `await for`.**

```dart
Stream<int> hitungMundur(int dari) async* {
  for (var i = dari; i > 0; i--) {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    yield i;
  }
}

Future<void> main() async {
  final hasil = <int>[];
  await for (final n in hitungMundur(3)) {
    hasil.add(n);
  }
  print(hasil); // [3, 2, 1]
}
```

- `async*` menandai fungsi generator asinkron; `yield` mengeluarkan satu event.
- `await for` mengonsumsi satu event per iterasi dan berakhir saat stream selesai; galat menjadi exception yang dapat ditangkap `try`/`catch`.

**Contoh 2 — backpressure: produsen mengikuti kecepatan konsumen.**

```dart
Stream<int> produsen() async* {
  for (var i = 1; i <= 3; i++) {
    print('produksi $i');
    yield i;
  }
}

Future<void> main() async {
  await for (final x in produsen()) {
    print('  konsumsi $x (lambat)');
    await Future<void>.delayed(const Duration(milliseconds: 30));
  }
}
```

```text
produksi 1
  konsumsi 1 (lambat)
produksi 2
  konsumsi 2 (lambat)
produksi 3
  konsumsi 3 (lambat)
```

- Produsen tidak berlari mendahului: setiap `yield` menunggu sampai konsumen meminta event berikutnya. Itulah *backpressure* alami.
- Bila konsumen lambat, tak ada tumpukan event di memori.

**Contoh 3 — berkas besar dengan memori konstan.**

```dart
import 'dart:convert';
import 'dart:io';

Future<int> hitungBaris(String jalur, String kata) async {
  var cocok = 0;
  final baris = File(jalur)
      .openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter());
  await for (final b in baris) {
    if (b.contains(kata)) cocok++;
  }
  return cocok;
}

Future<void> main() async {
  final dir = Directory.systemTemp.createTempSync('uji_');
  try {
    final jalur = '${dir.path}/data.txt';
    File(jalur).writeAsStringSync('apel\nbuah apel\njeruk\n');
    print(await hitungBaris(jalur, 'apel')); // 2
  } finally {
    dir.deleteSync(recursive: true);
  }
}
```

- `openRead()` membaca berkas dalam potongan; `utf8.decoder` mengubah byte menjadi teks; `LineSplitter` memotong menjadi baris — seluruh rantai bersifat aliran.
- Memori yang dipakai tidak bergantung pada ukuran berkas, dibanding `readAsLinesSync()` yang memuat semuanya (6.6).
- Direktori sementara dibersihkan lewat `finally` (5.4).

**Contoh 4 — single-subscription vs broadcast.**

```dart
import 'dart:async';

Future<void> main() async {
  final c = StreamController<int>(); // single-subscription
  c.add(1); // ditahan sampai ada pendengar
  c.add(2);
  final hasil = <int>[];
  final sub = c.stream.listen(hasil.add);
  c.add(3);
  await c.close();
  await sub.asFuture<void>();
  print(hasil); // [1, 2, 3]

  final b = StreamController<int>.broadcast();
  b.add(10); // tak ada pendengar: event HILANG
  final lihat = <int>[];
  b.stream.listen(lihat.add);
  b.add(11);
  await b.close();
  await Future<void>.delayed(Duration.zero);
  print(lihat); // [11]
}
```

- Pada stream single-subscription, `1` dan `2` ditahan lalu dikirim begitu ada pendengar; hasilnya `[1, 2, 3]`.
- Pada broadcast, `10` dikirim saat tak ada pendengar sehingga hilang; pendengar hanya menerima `11`.
- `sub.asFuture<void>()` mengembalikan Future yang selesai saat stream selesai.

**Contoh 5 — membatalkan langganan dan membersihkan.**

```dart
import 'dart:async';

Future<void> main() async {
  final c = StreamController<int>(
    onCancel: () => print('langganan dibatalkan: bersihkan resource'),
  );
  final sub = c.stream.listen((x) => print('terima $x'));
  c.add(1);
  await Future<void>.delayed(Duration.zero);
  await sub.cancel(); // memicu onCancel pada produsen
  await c.close();
}
```

```text
terima 1
langganan dibatalkan: bersihkan resource
```

- `onCancel` pada `StreamController` adalah tempat produsen melepas sumbernya (timer, berkas, soket) saat pendengar pergi.
- Pada `await for`, `break` atau exception otomatis membatalkan langganan.

### D. Opsi Kode Lain untuk Logika yang Sama

| Kebutuhan | Pilihan | Catatan |
| --- | --- | --- |
| Urutan nilai asinkron, satu konsumen | Stream single-subscription (`async*`) | Dingin; backpressure alami |
| Beberapa pendengar, event "siaran" | `StreamController.broadcast()` | Event tanpa pendengar hilang |
| Satu hasil, bukan urutan | `Future` | Lebih sederhana |
| Data sudah di memori | `Iterable` | Tak perlu asinkron |
| Mengurai aliran event berurutan | `StreamQueue` | Gaya tarik: `next`, `peek` |
| Menggabungkan beberapa aliran | `StreamGroup.merge` | `package:async` |
| Sumber terputus-putus dan harus dibatalkan | Stream + `onCancel` | Bersihkan resource |

```dart
// Transformasi malas ala Iterable, tetapi asinkron:
Stream<int> kuadratGenap(Stream<int> sumber) =>
    sumber.where((x) => x.isEven).asyncMap((x) async => x * x);
```

### E. Terminologi Esensial

- **Stream** — deretan event asinkron (data, galat, selesai). **Single-subscription / broadcast** — satu pendengar dan menahan event / banyak pendengar tanpa menahan.
- **`async*` / `yield`** — fungsi generator asinkron / mengeluarkan satu event. **`StreamSubscription`** — langganan yang dapat dijeda dan dibatalkan.
- **Backpressure** — konsumen mengatur kecepatan produsen. **Dingin / panas** — produksi dimulai saat didengarkan / berjalan terus.

### F. Visualisasi (ASCII)

```text
   produsen ──► event ──► event ──► event ──► done
                 │          │
                 ▼          ▼
   konsumen:  await for (final x in stream) { ... }     ← tarik: berikutnya diminta setelah badan selesai

   (async* tertahan di yield sampai konsumen meminta lagi)
```

```text
   single-subscription                 broadcast
   ───────────────────                 ───────────────────────
   event ─► [buffer] ─► 1 pendengar    event ─► pendengar A
   (ditahan sampai didengar)                  ─► pendengar B
                                       (tak ada pendengar: event HILANG)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 6.4 (Iterable malas dan `sync*`), 6.6 (memori konstan), 7.2 dan 7.3 (Future, pembatalan), 5.4 (pembersihan resource).
- **Prasyarat bagi:** 7.5 (stream hasil dari isolate), 7.8 (studi kasus). **Dikembangkan di:** Fase 9 (batas ukuran masukan pada aliran), Fase 10 (menguji stream), Fase 11 (aliran sebagai antarmuka antarmodul).

### H. Tips & Praktik Terbaik

- Pilih `await for` bila memungkinkan: backpressure dan pembatalan otomatis.
- Gunakan broadcast hanya untuk event siaran yang boleh terlewat; untuk data yang tak boleh hilang, pakai single-subscription.
- Batalkan setiap langganan yang kamu `listen` (di `finally` atau saat objek dibuang); beri `onCancel` pada produsen yang memegang resource.
- Olah berkas besar dengan `openRead().transform(...)`, bukan `readAsString`/`readAsLines`.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mendengarkan stream single-subscription dua kali | `StateError: Stream has already been listened to` | Satu pendengar, atau gunakan broadcast bila memang siaran |
| Event hilang pada broadcast | Pendengar terlambat tak menerima apa-apa | Mulai mendengarkan sebelum event dikirim, atau pakai single-subscription |
| Lupa membatalkan langganan | Resource bocor; callback terus berjalan | `cancel()` di `finally`; `onCancel` di produsen |
| `StreamController` yang menampung tanpa batas | Memori tumbuh bila pendengar lambat | Hormati `onPause`/`onResume` atau pakai generator `async*` |
| Galat pada `listen` tanpa `onError` | Galat tak tertangani | Sediakan `onError`, atau pakai `await for` dengan `try`/`catch` |
| `await for` pada aliran tak terbatas tanpa kondisi berhenti | Program tak pernah selesai | `take`, `break`, atau batalkan langganan |

### J. Sumber Referensi

- Menggunakan stream: https://dart.dev/libraries/async/using-streams · Membuat stream: https://dart.dev/libraries/async/creating-streams
- API `Stream`: https://api.dart.dev/stable/dart-async/Stream-class.html · `StreamController`: https://api.dart.dev/stable/dart-async/StreamController-class.html · `StreamSubscription`: https://api.dart.dev/stable/dart-async/StreamSubscription-class.html
- `File.openRead` dan `LineSplitter`: https://api.dart.dev/stable/dart-io/File/openRead.html · https://api.dart.dev/stable/dart-convert/LineSplitter-class.html
- ✔ Paket `async` (`StreamQueue`, `StreamGroup`): https://pub.dev/packages/async

---

## 7.5 Isolate dan Paralelisme

*Motivasi: bila satu jalur tak cukup, bangun jalur kedua — dan terimalah bahwa keduanya hanya boleh bertukar pesan, bukan memori.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas **isolate** sebagai satu-satunya jalan menuju **paralelisme** sungguhan di Dart: `Isolate.run` untuk pekerjaan berat sekali jalan, isolate berumur panjang dengan `Isolate.spawn`, `ReceivePort`, dan `SendPort`, protokol pesan bertipe, biaya penyalinan, penanganan galat, dan kapan isolate *tidak* layak dipakai. Pekerjaan I/O tak butuh isolate (sudah asinkron); yang butuh isolate adalah pekerjaan yang menghabiskan CPU.

### B. Konsep Kunci & Filosofi Mendalam

- **Memori terpisah.** Setiap isolate memiliki heap, event loop, dan thread sendiri; tak ada keadaan bersama. Konsekuensinya: tak ada *data race* tingkat memori dan tak perlu mutex di dalam Dart, tetapi data harus *dikirim* untuk berpindah.
- **Pesan lewat port.** Isolate berkomunikasi dengan mengirim pesan melalui `SendPort` yang terhubung ke `ReceivePort` milik isolate penerima. Pada umumnya pesan **disalin** ke heap penerima; objek yang tak dapat berubah (mis. `String`) dapat dibagikan sebagai referensi; dan **`Isolate.exit`** mengirim pesan terakhir tanpa menyalinnya (referensi diserahkan) lalu mengakhiri isolate.
- **`Isolate.run(komputasi)`** (Dart ≥ 2.19): membuat isolate, menjalankan fungsi, mengembalikan hasilnya sebagai `Future`, lalu mengakhiri isolate; hasil dikirim lewat `Isolate.exit` sehingga tanpa salinan. Galat yang dilempar komputasi diteruskan ke Future pemanggil (bila objek galat tak dapat dikirim, ia dibungkus `RemoteError`).
- **Penangkapan closure = penyalinan.** Variabel yang ditangkap closure dikirim ke isolate baru, jadi data besar yang tertangkap *disalin*. Perubahan yang dilakukan di isolate lain **tidak** terlihat di isolate asal, begitu pula sebaliknya.
- **Yang dapat dikirim.** Sebagian besar objek (angka, string, list, map, set, record, data bertipe, instance kelas biasa) dapat dikirim; objek yang membungkus resource native seperti soket atau berkas terbuka dan `ReceivePort` biasa tidak dapat. Variabel global dan field `static` **tidak dibagikan**: tiap isolate memiliki salinannya sendiri.
- **Biaya.** Membuat isolate dan menyalin pesan itu nyata. Isolate layak bila pekerjaannya cukup berat (lebih dari kira-kira puluhan milidetik CPU) dibanding biaya pembuatan dan penyalinan; ukur dulu (6.2). Jangan membuat isolate per tugas kecil.
- **Isolate berumur panjang.** Untuk beban berulang, `Isolate.spawn` + dua port membentuk *pekerja*: pemilik mengirim permintaan, pekerja membalas. Rancang protokolnya sebagai **tipe jumlah sealed** (2.6) dan beri setiap permintaan alamat balasan. Tutup port dan hentikan isolate saat selesai; port yang terbuka menahan isolate (dan program) tetap hidup.
- **Jumlah isolate ≈ jumlah inti.** Lebih banyak isolate CPU-bound daripada inti tak mempercepat; `Platform.numberOfProcessors` memberi patokan.
- **Batas pesan = batas kepercayaan.** Pesan masuk bertipe longgar; periksa dan ubah menjadi tipe yang sah (parse di tepi, 3.5) alih-alih meng-`as`.
- **Filosofi:** paralelisme tanpa memori bersama menukar kemudahan berbagi dengan keamanan: yang tak dibagikan tak dapat berbalapan.
- **Dampak desain:** isolate memisahkan pekerjaan berat dari event loop utama sehingga aplikasi tetap responsif, dengan harga penyalinan dan kerumitan protokol pesan.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — `Isolate.run` menjaga event loop tetap bebas.**

```dart
import 'dart:async';
import 'dart:isolate';

int fibBerat(int n) => n < 2 ? n : fibBerat(n - 1) + fibBerat(n - 2);

Future<void> main() async {
  var tik = 0;
  final timer = Timer.periodic(const Duration(milliseconds: 20), (_) => tik++);

  fibBerat(33); // sinkron: event loop terblokir; timer tak sempat menyala
  print('tik setelah kerja sinkron: $tik'); // 0

  final hasil = await Isolate.run(() => fibBerat(36)); // di isolate lain
  print('hasil=$hasil; timer tetap berdetak: ${tik > 0}'); // hasil=14930352; true
  timer.cancel();
}
```

- Pada pemanggilan sinkron, timer tidak dapat berjalan karena event loop tak sempat memproses apa pun (7.1).
- `Isolate.run(() => ...)` menjalankan komputasi di isolate lain; isolate utama bebas memproses timer selama menunggu.
- Nilai `fibBerat(36)` adalah 14930352; bagian `tik > 0` bergantung pada pekerjaan cukup lama agar timer sempat menyala.

**Contoh 2 — memori tidak dibagikan: salinan, bukan referensi.**

```dart
import 'dart:isolate';

Future<void> main() async {
  final data = [1, 2, 3];
  final panjangDiIsolate = await Isolate.run(() {
    data.add(4); // mengubah SALINAN di isolate lain
    return data.length;
  });
  print('$panjangDiIsolate ${data.length}'); // 4 3
}
```

- `data` yang ditangkap closure *disalin* ke isolate baru; `add(4)` hanya memengaruhi salinan itu.
- List asli di isolate utama tetap berisi tiga elemen. Perubahan harus dikirim *kembali* sebagai hasil bila diperlukan.

**Contoh 3 — galat diteruskan ke pemanggil.**

```dart
import 'dart:isolate';

Future<void> main() async {
  try {
    await Isolate.run(() => throw const FormatException('rusak di isolate lain'));
  } on FormatException catch (e) {
    print('tertangkap di pemanggil: ${e.message}');
  }
}
```

- Galat yang dilempar di dalam komputasi muncul sebagai exception dari `await Isolate.run(...)`, sehingga penanganan galat 5.2 tetap berlaku.
- Objek galat harus dapat dikirim; galat biasa seperti `FormatException` aman.

**Contoh 4 — pekerja berumur panjang dengan protokol sealed.**

```dart
import 'dart:isolate';

sealed class Permintaan {
  const Permintaan();
}

class Hitung extends Permintaan {
  const Hitung(this.n, this.balas);
  final int n;
  final SendPort balas;
}

class Berhenti extends Permintaan {
  const Berhenti();
}

void _pekerja(SendPort kePemilik) {
  final masuk = ReceivePort();
  kePemilik.send(masuk.sendPort); // serahkan alamat kotak surat pekerja
  masuk.listen((pesan) {
    if (pesan is! Permintaan) return; // pesan tak dikenal diabaikan
    switch (pesan) {
      case Hitung(:final n, :final balas):
        balas.send(fibBerat(n));
      case Berhenti():
        masuk.close(); // tanpa port terbuka, isolate berakhir
    }
  });
}

Future<void> main() async {
  final dariPekerja = ReceivePort();
  await Isolate.spawn(_pekerja, dariPekerja.sendPort);
  final alamat = await dariPekerja.first;
  if (alamat is! SendPort) throw StateError('pekerja tidak mengirim alamat');

  Future<int> hitungDiPekerja(int n) async {
    final balasan = ReceivePort();
    alamat.send(Hitung(n, balasan.sendPort));
    final hasil = await balasan.first;
    if (hasil is int) return hasil;
    throw StateError('balasan tak terduga: $hasil');
  }

  print(await hitungDiPekerja(30)); // 832040
  print(await hitungDiPekerja(20)); // 6765
  alamat.send(const Berhenti());
}
```

- Langkah awal (*handshake*): pekerja mengirim `SendPort`-nya ke pemilik, sehingga pemilik tahu ke mana mengirim permintaan.
- Tiap `Hitung` membawa `SendPort` balasan; ini pola *request/response* antarisolate.
- `pesan is! Permintaan` lalu `switch` atas tipe sealed: kelengkapan diperiksa kompilator (2.6); balasan di sisi pemilik diperiksa dengan `is int`, bukan `as` (batas kepercayaan).
- `masuk.close()` menutup port; tanpa port terbuka, isolate pekerja berakhir dan program bisa selesai.

### D. Opsi Kode Lain untuk Logika yang Sama

| Kebutuhan | Pilihan | Catatan |
| --- | --- | --- |
| Satu pekerjaan berat sekali jalan | `Isolate.run` | Paling sederhana; hasil tanpa salinan |
| Beban berulang dengan state di pekerja | `Isolate.spawn` + port | Protokol pesan sealed; kelola siklus hidup |
| Pekerjaan I/O | `async`/`await` biasa | Tak perlu isolate |
| Banyak pekerjaan berat paralel | Beberapa `Isolate.run` (≤ jumlah inti) | Ukur; jangan melebihi inti |
| Data biner sangat besar | `TransferableTypedData` | Memindahkan data tanpa salinan |
| Pekerjaan yang harus dihentikan paksa | `Isolate.kill` | Resource isolate itu hilang bersamanya |

| Aspek | `Future`/`async` | `Isolate` |
| --- | --- | --- |
| Memori | Dibagikan (satu isolate) | Terpisah; pesan disalin |
| Paralelisme | Tidak (konkurensi saja) | Ya |
| Biaya awal | Hampir nol | Nyata (pembuatan + penyalinan) |
| Cocok untuk | I/O, menunggu | CPU berat |

### E. Terminologi Esensial

- **Isolate** — unit eksekusi bermemori terpisah. **`SendPort` / `ReceivePort`** — ujung kirim / terima pesan. **Handshake** — pertukaran alamat awal.
- **Penyalinan pesan** — data dikloning ke heap penerima. **`Isolate.exit`** — mengakhiri isolate sambil menyerahkan pesan tanpa salinan.
- **Request/response** — permintaan dengan alamat balasan. **Pekerja (worker)** — isolate berumur panjang yang melayani permintaan.

### F. Visualisasi (ASCII)

```text
  ISOLATE UTAMA                                    ISOLATE PEKERJA
  (heap A, event loop A)                           (heap B, event loop B)

  Hitung(30, balasPort) ──── salin ────────────►  masuk.listen(...)
                                                    fibBerat(30)   ← CPU berat di sini
  ◄───────── 832040 ──────── balas.send ────────

  tak ada memori bersama: yang berpindah hanyalah PESAN
```

```text
  Isolate.run(f):
    utama ──(salin closure + data tertangkap)──► isolate baru: f()
    utama ◄──(Isolate.exit: hasil TANPA salinan)── isolate baru berakhir
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 7.1 (event loop dan pemblokiran), 7.2 dan 7.4 (Future dan Stream untuk menerima hasil), 2.6 (protokol sealed), 3.5 (parse di batas), 6.2 (mengukur biaya).
- **Prasyarat bagi:** 7.6 dan 7.8. **Dikembangkan di:** Fase 9 (isolate sebagai batas isolasi; data tak tepercaya diproses di isolate terpisah), Fase 10 (menguji isolate), Fase 11 (isolate sebagai batas modul).

### H. Tips & Praktik Terbaik

- Pakai isolate hanya untuk pekerjaan CPU yang terukur berat; I/O cukup asinkron.
- Perkecil data yang tertangkap atau dikirim; kirim hanya yang diperlukan.
- Rancang protokol pesan sebagai tipe sealed dengan alamat balasan; periksa pesan masuk, jangan meng-`as`.
- Pastikan setiap `ReceivePort` ditutup dan setiap isolate berumur panjang punya jalur berhenti.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Isolate untuk tugas sangat kecil | Lebih lambat dari sinkron | Ukur; pakai bila pekerjaan jauh melebihi biaya |
| Menangkap data besar di closure | Penyalinan mahal | Kirim hanya yang perlu; pertimbangkan `TransferableTypedData` |
| Mengharap perubahan terlihat di isolate lain | Data tak berubah | Kirim hasil kembali sebagai pesan |
| Mengirim objek tak dapat dikirim | Galat saat mengirim | Ubah ke data murni (angka, string, list, record) |
| Lupa menutup port | Program tak pernah selesai | `ReceivePort.close()` dan hentikan isolate |
| Mengandalkan variabel global bersama | Tiap isolate punya salinan sendiri | Kirim lewat pesan |
| Terlalu banyak isolate CPU-bound | Tak ada percepatan | Batasi sekitar jumlah inti |

### J. Sumber Referensi

- ✔ Concurrency di Dart (isolate, pesan, `Isolate.run`, `Isolate.exit`): https://dart.dev/language/concurrency
- ✔ Concurrency dan isolate (Flutter docs): https://docs.flutter.dev/perf/isolates
- API `Isolate`: https://api.dart.dev/stable/dart-isolate/Isolate-class.html · `Isolate.run`: https://api.dart.dev/stable/dart-isolate/Isolate/run.html
- API `ReceivePort`/`SendPort`: https://api.dart.dev/stable/dart-isolate/dart-isolate-library.html · `TransferableTypedData`: https://api.dart.dev/stable/dart-isolate/TransferableTypedData-class.html
- Actor model (konsep): https://en.wikipedia.org/wiki/Actor\_model

---

## 7.6 Kondisi Balapan & Konsistensi pada Titik await *(TAMBAHAN)*

*Motivasi: tak ada thread lain yang bisa menyelamu — tetapi setiap await adalah pintu tempat dunia bisa masuk.*

> **Mengapa ditambahkan.** Audit menemukan pembelajar yang lega mengetahui bahwa Dart tak punya *data race* lalu menyimpulkan bahwa Dart tak punya *bug balapan*. Padahal kondisi balapan *logis* di titik `await` sangat mungkin terjadi pada kode asinkron biasa, dan melanggar invarian yang kita jaga susah payah (1.5, 4.3).

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini menunjukkan bagaimana **balapan logis** terjadi dalam *satu* isolate: dua operasi asinkron yang saling menyelip di titik `await` dan merusak state bersama. Kamu belajar mengenali pola **cek-lalu-tindak** (*check-then-act*) dan **baca-ubah-tulis** (*lost update*), dan memperbaikinya dengan bagian kritis tanpa `await`, **mutex asinkron** (`Pool(1)` atau antrean), **kontrol konkurensi optimistik** (versi), atau memindahkan state ke satu pemilik (aktor).

### B. Konsep Kunci & Filosofi Mendalam

- **Titik `await` = titik penyelipan.** Kode di antara dua `await` berjalan *tanpa disela* (run-to-completion, 7.1), tetapi di setiap `await` kendali kembali ke event loop dan kode lain dapat berjalan serta mengubah state bersama sebelum kelanjutan dilanjutkan.
- **Cek-lalu-tindak.** `if (saldo >= jumlah) { await ...; saldo -= jumlah; }`: saat kelanjutan berjalan, `saldo` mungkin sudah berubah oleh operasi lain yang juga lolos pemeriksaan. Pemeriksaan dan tindakan tak lagi atomik.
- **Baca-ubah-tulis.** Membaca state, menunggu, lalu menulis nilai turunan dari bacaan lama menimpa perubahan orang lain (*lost update*).
- **Reentrancy.** Fungsi `async` yang dipanggil lagi sebelum pemanggilan pertamanya selesai (mis. perintah yang dikirim dua kali berdekatan) berperilaku seperti dua pekerjaan yang berbalapan pada state yang sama.
- **Prinsip dasar:** *jaga invarian di dalam bagian sinkron.* Bagian kode tanpa `await` bersifat atomik terhadap isolate yang sama.
- **Teknik pencegahan.** (1) **Bagian kritis sinkron**: lakukan kerja asinkron *lebih dulu*, lalu cek dan ubah state tanpa `await` di antaranya. (2) **Serialisasi**: jalankan operasi atas state yang sama satu per satu lewat antrean atau mutex (`Pool(1)`). (3) **Optimistik (versi)**: catat versi, kerjakan secara asinkron, lalu *komit hanya bila versi tak berubah*; bila berubah, ulangi atau tolak. (4) **Pemilik tunggal (aktor)**: semua perubahan state lewat satu antrean pesan ke satu isolate/objek. (5) **Idempotensi** (5.4) agar pengulangan aman.
- **Mutex bukan obat serbaguna.** Serialisasi mengorbankan paralelisme dan dapat *deadlock* bila sebuah tugas yang berada di dalam antrean menunggu tugas lain di antrean yang sama.
- **Filosofi:** tulis kode asinkron seolah tiap `await` mengganti seluruh dunia — apa saja asumsimu yang masih berlaku setelahnya?
- **Dampak desain:** balapan logis tidak muncul di tes berurutan dan sering baru terlihat di produksi saat beban naik; ia harus dicegah oleh desain, bukan ditemukan oleh keberuntungan.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — bug: cek-lalu-tindak melintasi `await`.**

```dart
class RekeningBuruk {
  int saldo = 100;

  Future<void> tarik(int jumlah) async {
    if (saldo >= jumlah) { // CEK
      await Future<void>.delayed(const Duration(milliseconds: 10)); // mis. validasi eksternal
      saldo -= jumlah; // TINDAK: saldo mungkin sudah berubah sejak cek
    }
  }
}

Future<void> main() async {
  final r = RekeningBuruk();
  await Future.wait([r.tarik(80), r.tarik(80)]);
  print(r.saldo); // -60  <- invarian saldo >= 0 RUSAK
}
```

- Kedua pemanggilan lolos pemeriksaan (saldo masih 100) sebelum salah satunya mengurangi; hasilnya `100 - 80 - 80 = -60`.
- Tes yang memanggil `tarik` satu per satu *tidak akan* menemukan bug ini.

**Contoh 2 — perbaikan A: kerja asinkron dulu, cek dan tindak tanpa `await`.**

```dart
class RekeningAman {
  int saldo = 100;

  Future<bool> tarik(int jumlah) async {
    await Future<void>.delayed(const Duration(milliseconds: 10)); // kerja asinkron DULU
    if (saldo < jumlah) return false; // cek dan tindak berurutan
    saldo -= jumlah; //   TANPA await di antaranya: atomik
    return true;
  }
}

Future<void> main() async {
  final r = RekeningAman();
  final hasil = await Future.wait([r.tarik(80), r.tarik(80)]);
  print('$hasil ${r.saldo}'); // [true, false] 20
}
```

- Setiap kelanjutan berjalan tanpa disela; yang pertama melihat saldo 100 dan mengurangi, yang kedua melihat saldo 20 dan menolak.
- Perbaikan ini cukup bila kerja asinkron tak bergantung pada hasil pemeriksaan.

**Contoh 3 — perbaikan B: mutex asinkron dengan `Pool(1)`.**

```dart
import 'package:pool/pool.dart';

class RekeningSerial {
  int saldo = 100;
  final _kunci = Pool(1); // satu pekerjaan sekaligus = mutex asinkron

  Future<bool> tarik(int jumlah) => _kunci.withResource(() async {
        if (saldo < jumlah) return false;
        await Future<void>.delayed(const Duration(milliseconds: 10)); // boleh ada await di dalam
        saldo -= jumlah;
        return true;
      });
}
```

- Karena hanya satu `withResource` berjalan pada satu waktu, cek dan tindak tak dapat diselipi operasi lain walau ada `await` di tengahnya.
- Harganya: operasi dieksekusi berurutan, tanpa tumpang-tindih.

**Contoh 4 — antrean sederhana tanpa dependensi.**

```dart
class Antrean {
  Future<void> _ekor = Future<void>.value();

  /// Menjalankan [kerja] setelah semua kerja sebelumnya selesai.
  Future<T> jalankan<T>(Future<T> Function() kerja) {
    final hasil = _ekor.then((_) => kerja());
    _ekor = hasil.then((_) {}, onError: (Object _) {}); // galat satu tugas tak memutus rantai
    return hasil;
  }
}

Future<void> main() async {
  final a = Antrean();
  final urutan = <String>[];
  await Future.wait([
    a.jalankan(() async {
      await Future<void>.delayed(const Duration(milliseconds: 30));
      urutan.add('satu');
    }),
    a.jalankan(() async {
      urutan.add('dua');
    }),
  ]);
  print(urutan); // [satu, dua]  (dua menunggu satu, walau satu lebih lama)
}
```

- `_ekor` adalah ujung rantai: tiap tugas baru disambungkan ke ekor, sehingga berjalan hanya setelah yang sebelumnya selesai.
- Galat satu tugas dikonsumsi di ekor sehingga tugas berikutnya tetap berjalan, tetapi galat tetap diteruskan ke pemanggil lewat `hasil`.

**Contoh 5 — kontrol konkurensi optimistik dengan versi.**

```dart
class Dokumen {
  int versi = 0;
  String isi = '';
}

Future<bool> sunting(Dokumen d, Future<String> Function(String isi) ubahAsinkron) async {
  final versiAwal = d.versi;
  final baru = await ubahAsinkron(d.isi); // kerja asinkron panjang; tanpa kunci
  if (d.versi != versiAwal) return false; // ada perubahan lain: tolak; pemanggil boleh mengulang
  d.isi = baru;
  d.versi++;
  return true;
}
```

- Tak ada kunci selama kerja panjang; konflik dideteksi *saat komit* lewat perbandingan versi.
- Cocok bila konflik jarang dan pengulangan murah; pada konflik sering, serialisasi lebih sederhana.

### D. Opsi Kode Lain untuk Logika yang Sama

| Teknik | Konkurensi | Kapan cocok | Risiko |
| --- | --- | --- | --- |
| Bagian kritis sinkron | Penuh sampai titik komit | Kerja asinkron tak bergantung pada cek | Tak berlaku bila cek harus *setelah* await yang bergantung state |
| Mutex (`Pool(1)`/`Antrean`) | Serial | Operasi atas state yang sama, ada `await` di dalam | Menurunkan throughput; deadlock bila saling menunggu |
| Optimistik (versi) | Tinggi; konflik dideteksi saat komit | Konflik jarang, pengulangan murah | Perlu logika ulang/tolak |
| Aktor (pemilik tunggal) | Serial per pemilik | State besar, banyak operasi | Protokol pesan; latensi |
| Idempotensi | — | Retry/ulang aman | Tak mencegah balapan, hanya memaafkan pengulangan |

### E. Terminologi Esensial

- **Kondisi balapan (race condition)** — hasil bergantung pada urutan penyelipan operasi. **Data race** — akses memori bersama tanpa sinkronisasi (tak ada di Dart antarisolate).
- **Check-then-act / lost update** — cek dan tindak tak atomik / pembaruan tertimpa. **Reentrancy** — fungsi dipanggil lagi sebelum pemanggilan sebelumnya selesai.
- **Mutex** — pengunci yang membatasi satu pekerjaan sekaligus. **Optimistic concurrency control** — komit hanya bila versi tak berubah.
- **Aktor** — pemilik state tunggal yang menerima pesan satu per satu.

### F. Visualisasi (ASCII)

```text
  waktu ──►

  tarik(80) #1:  cek(saldo=100 ✓) ── await ─────────────► saldo -= 80  → 20
  tarik(80) #2:        cek(saldo=100 ✓) ── await ───────► saldo -= 80  → -60  ✗ invarian rusak
                              ▲
                      kedua cek terjadi SEBELUM salah satu mengubah saldo
```

```text
  perbaikan A (cek+tindak tanpa await):     perbaikan B (mutex):
  #1: await ► [cek ✓ → saldo=20]            #1: [cek ✓ ─ await ─ saldo=20]
  #2: await ► [cek ✗ → tolak]               #2:                          [cek ✗ → tolak]   (menunggu #1)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 7.1–7.2 (titik await), 1.5 dan 4.3 (invarian), 5.4 (all-or-nothing dan idempotensi), 3.2 (imutabilitas dan komit setelah), 7.5 (aktor sebagai isolate).
- **Prasyarat bagi:** 7.7 dan 7.8. **Dikembangkan di:** Fase 9 (balapan sebagai kelas kerentanan: TOCTOU, double spend), Fase 10 (menguji interleaving), Fase 11 (pemilik tunggal sebagai pola arsitektur).

### H. Tips & Praktik Terbaik

- Setelah setiap `await`, tanya: asumsi apa tentang state bersama yang kini mungkin salah?
- Jaga invarian di dalam bagian sinkron; lakukan kerja asinkron sebelum cek-dan-ubah.
- Gunakan mutex atau antrean untuk operasi asinkron atas state yang sama; beri nama dan dokumentasikan kunci.
- Tulis tes konkuren yang sengaja menjalankan dua operasi bersamaan (`Future.wait`), bukan hanya berurutan.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Cek dan tindak dipisah oleh `await` | Invarian rusak saat operasi bersamaan | Bagian kritis tanpa `await`, atau mutex |
| Menguji hanya secara berurutan | Bug tak pernah muncul di tes | Tes konkuren dengan `Future.wait` |
| Mengira tak ada balapan karena tak ada thread | Lost update di produksi | Pahami penyelipan di titik `await` |
| Mutex yang dipegang saat menunggu mutex lain | Deadlock | Satu urutan penguncian; hindari tugas bersarang di antrean yang sama |
| Reentrancy tak terjaga (aksi dikirim dua kali) | Efek ganda | Idempotensi atau penolakan saat sedang berjalan |
| Memegang kunci selama pekerjaan sangat lama | Throughput turun | Perpendek bagian kritis; optimistik |

### J. Sumber Referensi

- ✔ Paket `pool` (mengendalikan permintaan konkuren): https://pub.dev/packages/pool
- ✔ Concurrency di Dart: https://dart.dev/language/concurrency
- Race condition: https://en.wikipedia.org/wiki/Race\_condition · Optimistic concurrency control: https://en.wikipedia.org/wiki/Optimistic\_concurrency\_control
- Lock/mutex: https://en.wikipedia.org/wiki/Lock\_(computer\_science) · Actor model: https://en.wikipedia.org/wiki/Actor\_model

---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-6/README.md
[selanjutnya]: ../bagian-8/README.md

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

