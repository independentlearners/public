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

---

- **0. Audit Kurikulum & Sambungan dari Fase 6**
- **7.1 Model Eksekusi:** isolate, event loop, microtask vs event
- **7.2 Future & async/await:** berurutan vs konkuren, galat, `Completer`
- **7.3 Kegagalan, Timeout, dan Pembatalan Asinkron**
- **7.4 Stream:** aliran data, langganan, backpressure
- **7.5 Isolate dan Paralelisme**
- **7.6 Kondisi Balapan & Konsistensi pada Titik await** *(TAMBAHAN)*
- **7.7 Menguji Kode Asinkron secara Deterministik** *(TAMBAHAN)*
- **7.8 Studi Kasus Terpadu: To-Do v6** *(TAMBAHAN)*
- **7.9 Pelengkap Kurikulum: Operator Stream, Kunci per Sumber Daya, Kolam Isolate & Pengawasan** *(TAMBAHAN)*
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

> **Audit akhir (18 November 2026).** Dokumen ini sebelumnya berhenti di referensi Modul 7.6; Modul 7.7, 7.8, Latihan, Ringkasan, dan Referensi Induk kini dilengkapi. *Pemetaan:* seri materi memakai penomorannya sendiri; Fase 7 ini setara Fase 5 kurikulum (Modul 5.1–5.4), sedangkan Fase 6 materi menggabungkan Modul 2.1, sebagian 2.2 (memoization), dan Fase 6 kurikulum. *Celah kurikulum 5.2–5.4 yang ditutup:* operator stream dan debounce/throttle, lint `cancel_subscriptions` dan `close_sinks`, kunci per sumber daya, kolam isolate, pengawasan `onExit` dan `onError`, serta isolate bukan sandbox: semuanya kini ada di Modul 7.9. *Versi:* Dart 3.14 dirilis 11 November 2026, sedangkan kurikulum v1.0 (10 November) masih menyebut 3.13.7; contoh Fase 7 memakai fitur Dart 3.0 ke atas. *Belum diaudit:* isi Fase 1–4 materi (termasuk apakah Modul 2.2–2.3 kurikulum, rekursi dan graf, sudah tercakup).

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

## 7.7 Menguji Kode Asinkron secara Deterministik (TAMBAHAN)

*Motivasi: tes yang baik tidak menunggu dunia — ia memegang jam dan pintunya sendiri.*

> **Mengapa ditambahkan.** Modul 7.1–7.6 menjanjikan perilaku yang hanya dapat dibuktikan bila kita mengendalikan urutan dan waktu: balapan (7.6) tak pernah muncul pada tes berurutan, dan timeout (7.3) tak boleh dites dengan tidur nyata. Kurikulum asli menaruh tes asinkron di Modul 8.1; di seri materi ini pengujian berada di Fase 10. Tanpa fondasi ini sekarang, pembelajar menulis `Future.delayed` nyata di tes: lambat, rapuh (*flaky*), dan sering lulus karena kebetulan.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini mengajarkan cara membuktikan perilaku asinkron **tanpa waktu nyata dan tanpa keberuntungan**: (1) waktu virtual dengan `fake_async`; (2) “gerbang” `Completer` untuk memaksa urutan penyelesaian tertentu; (3) matcher dan `StreamQueue` untuk stream; (4) fake I/O terprogram; (5) tes pembatalan dan pemeriksaan timer yang tertinggal; (6) cara menguji isolate tanpa menjadikan tes bergantung pada penjadwal sistem operasi. Paket dev yang dipakai: `test` dan `fake_async` (yang membawa `clock`).

### B. Konsep Kunci & Filosofi Mendalam

- **Empat sumber ketidakdeterministikan.** Waktu nyata (timer, `DateTime.now()`), urutan selesainya I/O, keacakan, dan penjadwalan antar-isolate. Tes deterministik berarti keempatnya disuntikkan atau dikendalikan. Di Fase 5 kita sudah menyuntikkan tidur, jam, dan acak; kini kita juga mengendalikan *kapan* sebuah operasi selesai.
- **Tes asinkron di `package:test`.** Fungsi tes boleh `async`; runner menunggu `Future`-nya dan menghentikan tes yang melewati batas waktu. Pakai `await expectLater(...)` agar urutan penantian eksplisit.
- **Waktu virtual (`fakeAsync`).** Menjalankan callback dalam Zone yang memalsukan `Timer` dan microtask; waktu hanya maju saat kamu memanggil `elapse`. `flushMicrotasks()` menguras microtask tanpa memajukan waktu; `flushTimers()` menjalankan semua timer sampai habis. Di dalamnya `Future.delayed`, `Timer`, `Stream.periodic`, dan `Future.timeout` mengikuti jam palsu.
- **Aturan emas `fakeAsync`.** Callback-nya **sinkron**: tak ada `await` di dalamnya. Amati hasil `Future` lewat `.then` ke sebuah variabel, majukan waktu dengan `elapse`, lalu `expect`. `Future` yang dibuat *sebelum* masuk `fakeAsync` tidak ikut zonanya, dan I/O nyata (berkas, soket) tidak akan selesai di dalamnya karena event I/O sungguhan tidak digerakkan oleh jam palsu.
- **Jam dinding.** `DateTime.now()` *tidak* dipalsukan. Logika yang butuh “sekarang” memakai `clock.now()` dari `package:clock` (di dalam `fakeAsync`, `clock` global ikut maju) atau menerima jam sebagai parameter.
- **Gerbang `Completer`.** Untuk memaksa interleaving tertentu, jadikan titik `await` sebuah fungsi yang disuntikkan; tes memegang `Completer` dan menyelesaikannya kapan ia mau. Urutan penyelesaian *adalah* urutan eksekusi. Balapan dari 7.6 menjadi bukti yang dapat diulang, bukan kebetulan.
- **Membuktikan sesuatu *tidak* terjadi.** Bahwa pekerjaan dibatalkan dibuktikan dengan menguras jam lalu memeriksa tak ada yang tersisa: `nonPeriodicTimerCount`, `periodicTimerCount`, dan `microtaskCount` pada objek `FakeAsync` semuanya nol.
- **Stream.** `emitsInOrder` untuk urutan, `emitsDone` untuk penutupan, `emitsError` untuk galat; `StreamQueue` (`package:async`) untuk menarik event satu per satu.
- **Isolate.** `fakeAsync` tak dapat memalsukan isolate lain (zona dan thread berbeda). Pisahkan **logika murni** (dites langsung: sinkron, cepat, deterministik) dari **pembungkus isolate** (satu-dua tes integrasi tipis dengan isolate nyata, ber-timeout, tanpa asumsi waktu).
- **Larangan.** `sleep`, `Future.delayed` nyata untuk “menunggu cukup lama”, `DateTime.now()` di dalam logika, dan mengandalkan urutan dua `Future` independen.
- **Filosofi:** tes asinkron yang lulus karena keberuntungan lebih buruk daripada tidak ada tes, karena ia memberi rasa aman palsu.
- **Dampak desain:** kode yang mudah dites secara deterministik hampir selalu lebih baik: waktu, urutan, dan sumber kegagalan menjadi parameter yang eksplisit.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — dari tes lambat ke waktu virtual.** Fungsi yang diuji (varian asinkron dari `ulangi` di 5.6):

```dart
import 'dart:async';

Future<void> _tidurNyata(Duration d) => Future<void>.delayed(d);

Future<T> ulangiAsinkron<T>(
  Future<T> Function() kerja, {
  int maksPercobaan = 4,
  Duration dasar = const Duration(milliseconds: 100),
  bool Function(Object galat)? bisaDiulang,
  Future<void> Function(Duration) tidur = _tidurNyata,
}) async {
  for (var percobaan = 1;; percobaan++) {
    try {
      return await kerja();
    } on Object catch (galat) {
      final ulang = bisaDiulang?.call(galat) ?? true;
      if (!ulang || percobaan >= maksPercobaan) rethrow;
      await tidur(dasar * (1 << (percobaan - 1))); // 100, 200, 400 ms ...
    }
  }
}
```

- `Future<T> ulangiAsinkron<T>(...) async` — fungsi generik; `T` adalah tipe hasil `kerja`; `async` membungkus hasil atau galat menjadi `Future`.
- `for (var percobaan = 1;; percobaan++)` — loop tanpa syarat berhenti bernomor; keluar hanya lewat `return` atau `rethrow`.
- `return await kerja();` — `await` di dalam `try` wajib agar galat dari `kerja` tertangkap di sini (jebakan `return` tanpa `await`, 7.2).
- `on Object catch (galat)` — menangkap semua yang dapat dilempar, secara eksplisit (`on Object`) agar niatnya jelas dan lint `avoid_catches_without_on_clauses` puas; keputusan mengulang diambil setelahnya.
- `bisaDiulang?.call(galat) ?? true` — predikat opsional; tanpa predikat semua galat dianggap layak diulang (di kode nyata batasi ke yang transien, 5.6).
- `rethrow` — meneruskan galat asli beserta stack trace utuh bila tak layak diulang atau jatah habis.
- `await tidur(dasar * (1 << (percobaan - 1)))` — backoff eksponensial: `1 << n` menggeser bit sehingga menghasilkan 1, 2, 4, …; `Duration * int` menghasilkan `Duration`.
- `tidur = _tidurNyata` — penunda disuntikkan, bawaannya `Future.delayed`; di dalam `fakeAsync` `Future.delayed` otomatis mengikuti jam palsu.

Anti-pola — tes yang menunggu waktu nyata:

```dart
test('mengulang sampai berhasil (LAMBAT)', () async {
  var panggilan = 0;
  final hasil = await ulangiAsinkron(() async {
    if (++panggilan < 3) throw StateError('gagal');
    return 'ok';
  });
  expect(hasil, 'ok');
}); // menunggu 100 + 200 ms NYATA; dikali ratusan tes = menit, dan rapuh di CI yang sibuk
```

Versi deterministik dengan waktu virtual:

```dart
import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';

void main() {
  test('backoff tepat: 100 ms lalu 200 ms (waktu virtual)', () {
    fakeAsync((async) {
      var panggilan = 0;
      String? hasil;

      unawaited(ulangiAsinkron(() async {
        if (++panggilan < 3) throw StateError('gagal');
        return 'ok';
      }).then((v) => hasil = v));

      async.flushMicrotasks(); // percobaan 1 gagal; kini menunggu 100 ms
      expect(panggilan, 1);
      async.elapse(const Duration(milliseconds: 99));
      expect(panggilan, 1); // belum waktunya
      async.elapse(const Duration(milliseconds: 1));
      expect(panggilan, 2); // tepat di 100 ms
      async.elapse(const Duration(milliseconds: 200));
      expect(hasil, 'ok');
      expect(panggilan, 3);
      expect(async.nonPeriodicTimerCount, 0); // tak ada timer tertinggal
    });
  });
}
```

- `fakeAsync((async) { ... })` — fungsi tingkat atas dari `package:fake_async`; menjalankan isi dalam Zone berjam palsu; `async` adalah pengendali waktu.
- `unawaited(... .then((v) => hasil = v))` — `Future` tak di-`await` karena callback sinkron; hasilnya ditangkap ke variabel `hasil`; `unawaited` menandai bahwa itu disengaja (lint `unawaited_futures`).
- `async.flushMicrotasks()` — menjalankan lanjutan yang tertunda tanpa memajukan waktu: percobaan pertama gagal dan timer 100 ms terpasang.
- `async.elapse(Duration)` — memajukan jam palsu, menyalakan timer yang jatuh tempo, dan menguras microtask setelah tiap timer.
- Pasangan `99 ms` / `1 ms` membuktikan *batas tepat*, sesuatu yang mustahil secara andal dengan waktu nyata.
- `nonPeriodicTimerCount` — jumlah timer sekali-jalan yang belum menyala atau dibatalkan; nol berarti bersih.

**Contoh 2 — gerbang `Completer`: balapan 7.6 menjadi bukti yang dapat diulang.** Jadikan titik `await` sebagai fungsi yang disuntikkan:

```dart
import 'dart:async';

import 'package:test/test.dart';

class RekeningBuruk {
  RekeningBuruk(this._validasi);
  final Future<void> Function() _validasi; // titik await yang dikendalikan tes
  int saldo = 100;

  Future<void> tarik(int jumlah) async {
    if (saldo >= jumlah) { // CEK
      await _validasi();   // dunia boleh masuk di sini
      saldo -= jumlah;     // TINDAK
    }
  }
}

class RekeningAman {
  RekeningAman(this._validasi);
  final Future<void> Function() _validasi;
  int saldo = 100;

  Future<bool> tarik(int jumlah) async {
    await _validasi();           // kerja asinkron DULU
    if (saldo < jumlah) return false;
    saldo -= jumlah;             // cek dan tindak tanpa await di antaranya
    return true;
  }
}

void main() {
  test('bug terbukti: dua penarikan lolos cek bersamaan', () async {
    final gerbang = [Completer<void>(), Completer<void>()];
    var n = 0;
    final r = RekeningBuruk(() => gerbang[n++].future);

    final a = r.tarik(80); // lolos cek, berhenti di gerbang[0]
    final b = r.tarik(80); // lolos cek (saldo masih 100), berhenti di gerbang[1]
    gerbang[0].complete();
    gerbang[1].complete();
    await Future.wait([a, b]);

    expect(r.saldo, -60); // invarian saldo >= 0 rusak
  });

  test('RekeningAman: semua urutan selesai menjaga invarian', () async {
    for (final urutan in [[0, 1], [1, 0]]) {
      final gerbang = [Completer<void>(), Completer<void>()];
      var n = 0;
      final r = RekeningAman(() => gerbang[n++].future);

      final hasil = [r.tarik(80), r.tarik(80)];
      for (final i in urutan) {
        gerbang[i].complete(); // urutan selesai = urutan lanjutan berjalan
      }
      final selesai = await Future.wait(hasil);

      expect(selesai.where((b) => b), hasLength(1)); // tepat satu berhasil
      expect(r.saldo, 20);
    }
  });
}
```

- `_validasi` adalah *titik suntik*: di produksi ia validasi eksternal sungguhan; di tes ia mengembalikan `future` milik `Completer` yang dipegang tes.
- `gerbang[n++].future` — panggilan pertama mendapat gerbang 0, panggilan kedua gerbang 1; `n++` memberi urutan tetap.
- `a` dan `b` dibuat tanpa `await` di antaranya sehingga keduanya melewati `if (saldo >= jumlah)` sebelum salah satunya mengurangi: persis penyelipan 7.6.
- `complete()` menjadwalkan lanjutan sebagai microtask berurutan; maka urutan pemanggilan `complete` menentukan siapa berjalan lebih dulu, tanpa tidur nyata.
- Tes kedua menelusuri **kedua permutasi** (`[0, 1]` dan `[1, 0]`) dan menegaskan sifat yang berlaku di semua urutan (tepat satu berhasil, saldo 20), bukan satu skenario kebetulan.

**Contoh 3 — menguji stream: dua cara.**

```dart
import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';

Stream<int> hitungMundur(int dari) async* {
  for (var i = dari; i > 0; i--) {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield i;
  }
}

void main() {
  test('hitungMundur: 3, 2, 1 lalu selesai (tanpa menunggu 3 detik)', () {
    fakeAsync((async) {
      final hasil = <int>[];
      var selesai = false;
      hitungMundur(3).listen(hasil.add, onDone: () => selesai = true);

      async.elapse(const Duration(seconds: 1));
      expect(hasil, [3]);
      async.elapse(const Duration(seconds: 2));
      async.flushMicrotasks();
      expect(hasil, [3, 2, 1]);
      expect(selesai, isTrue);
    });
  });

  test('matcher stream: urutan dan penutupan', () async {
    final kontrol = StreamController<int>();
    final menunggu = expectLater(kontrol.stream, emitsInOrder([1, 2, emitsDone]));
    kontrol
      ..add(1)
      ..add(2);
    await kontrol.close();
    await menunggu;
  });
}
```

- Tes pertama memakai waktu virtual karena stream bergantung pada `Future.delayed`; `listen(hasil.add, onDone: ...)` mengumpulkan event ke list dan menandai penutupan.
- `elapse(1 s)` menghasilkan `3`; `elapse(2 s)` menghasilkan `2` dan `1`; `flushMicrotasks()` memastikan event penutupan yang dijadwalkan ikut terkuras sebelum `expect`.
- Tes kedua tak butuh jam: `expectLater(stream, emitsInOrder([...]))` memasang ekspektasi *sebelum* event dikirim dan mengembalikan `Future` yang kita `await` di akhir.
- `emitsDone` adalah matcher untuk “stream ditutup”; menaruhnya di akhir daftar membuktikan tak ada event ekstra sebelum penutupan.
- `kontrol..add(1)..add(2)` — operator kaskade `..` memanggil `add` dua kali pada objek yang sama.

**Contoh 4 — timeout dan pembatalan tanpa menunggu, lalu memeriksa timer yang tersisa.**

```dart
import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';

Future<String> ambilDenganBatas(Future<String> Function() ambil, Duration batas) =>
    ambil().timeout(batas); // timeout TIDAK membatalkan pekerjaan di bawahnya (7.3)

class Debouncer {
  Debouncer(this.jeda);
  final Duration jeda;
  Timer? _timer;

  void jalankan(void Function() aksi) {
    _timer?.cancel(); // jadwal lama dibatalkan
    _timer = Timer(jeda, aksi);
  }
}

void main() {
  test('timeout melempar TimeoutException tepat pada batasnya', () {
    fakeAsync((async) {
      final lambat = Completer<String>(); // tak pernah selesai
      Object? galat;
      unawaited(
        ambilDenganBatas(() => lambat.future, const Duration(seconds: 2)).then(
          (_) {},
          onError: (Object e) {
            galat = e;
          },
        ),
      );

      async.elapse(const Duration(milliseconds: 1999));
      expect(galat, isNull);
      async.elapse(const Duration(milliseconds: 1));
      expect(galat, isA<TimeoutException>());
      expect(async.nonPeriodicTimerCount, 0); // timer timeout sudah dibereskan
    });
  });

  test('Debouncer hanya menjalankan aksi terakhir', () {
    fakeAsync((async) {
      final d = Debouncer(const Duration(milliseconds: 300));
      final dipanggil = <int>[];

      d.jalankan(() => dipanggil.add(1));
      async.elapse(const Duration(milliseconds: 200));
      d.jalankan(() => dipanggil.add(2)); // menggeser jadwal ke t = 500 ms
      async.elapse(const Duration(milliseconds: 299));
      expect(dipanggil, isEmpty);
      async.elapse(const Duration(milliseconds: 1));
      expect(dipanggil, [2]); // aksi 1 tak pernah jalan
      expect(async.nonPeriodicTimerCount, 0);
    });
  });
}
```

- `ambil().timeout(batas)` — jika `Future` belum selesai pada `batas`, hasilnya gagal dengan `TimeoutException`; pekerjaan aslinya tetap berjalan (itu sebabnya pembatalan sungguhan butuh kerja sama, 7.3).
- `Completer<String>()` yang tak pernah diselesaikan menggantikan “server yang lambat” tanpa jaringan sama sekali.
- `onError: (Object e) { galat = e; }` — penangkap galat lewat `then`; badan berkurung kurawal dipakai agar tipe kembaliannya jelas (`void`).
- Pasangan `1999 ms` / `1 ms` membuktikan batas persis dua detik dan bahwa galat *belum* ada sebelumnya.
- `Debouncer` memakai `Timer` dan `Timer.cancel()`: setiap panggilan baru membatalkan jadwal lama. Tes membuktikan aksi 1 tak pernah berjalan dan tak ada timer tersisa.
- `isA<TimeoutException>()` — matcher tipe dari `package:test`.

**Contoh 5 — menguji isolate: pisahkan logika murni dari pembungkusnya.**

```dart
import 'dart:isolate';

import 'package:test/test.dart';

int jumlahKuadrat(List<int> xs) => xs.fold(0, (a, x) => a + x * x);

Future<int> jumlahKuadratDiIsolate(List<int> xs) =>
    Isolate.run(() => jumlahKuadrat(xs));

void main() {
  test('logika murni: sinkron, cepat, deterministik', () {
    expect(jumlahKuadrat([1, 2, 3]), 14);
    expect(jumlahKuadrat([]), 0);
  });

  test('pembungkus isolate: satu tes integrasi tanpa asumsi waktu', () async {
    expect(await jumlahKuadratDiIsolate([1, 2, 3]), 14);
  }, timeout: const Timeout(Duration(seconds: 10)));
}
```

- `jumlahKuadrat` adalah fungsi murni: seluruh kebenaran logika diuji di sini, tanpa isolate.
- `Isolate.run(() => jumlahKuadrat(xs))` — pembungkus tipis; hanya `xs` yang tertangkap dan disalin ke isolate lain (7.5).
- Tes integrasi hanya membuktikan bahwa pembungkus “tersambung” dan hasilnya kembali; ia tidak menebak berapa lama isolate berjalan.
- `timeout: const Timeout(Duration(seconds: 10))` — jaring pengaman per tes: bila isolate menggantung, tes gagal dalam 10 detik, bukan menunggu batas bawaan.

### D. Opsi Kode Lain untuk Logika yang Sama

| Teknik | Mengendalikan | Kapan cocok | Risiko |
| --- | --- | --- | --- |
| Tidur nyata (`Future.delayed` di tes) | — | Hampir tak pernah | Lambat, rapuh, dan lulus karena kebetulan |
| `fakeAsync` | Waktu dan microtask | Timer, backoff, timeout, debounce, `Stream.periodic` | Callback sinkron; tak mengendalikan I/O nyata atau isolate; `DateTime.now()` tak dipalsukan |
| Menyuntikkan penunda atau jam | Waktu | Kode yang bisa menerima parameter; tanpa Zone | Mengubah API; harus diteruskan ke bawah |
| Gerbang `Completer` | Urutan penyelesaian | Bukti interleaving dan balapan | Butuh titik suntik di desain |
| Matcher stream (`emitsInOrder`) | Urutan event | Stream dengan sumber terkontrol | Tak mengendalikan waktu |
| `StreamQueue` | Penarikan event bertahap | Tes yang berinteraksi di tengah aliran | Wajib `cancel()` agar tak bocor |
| Tes properti (Fase 10) | Banyak urutan acak | Menemukan interleaving yang tak terpikirkan | Butuh generator dan seed tercetak |

Alternatif tanpa Zone — suntikkan penunda dan rekam jeda yang diminta:

```dart
test('jeda yang diminta: 100 lalu 200 ms (penunda palsu)', () async {
  var panggilan = 0;
  final jeda = <Duration>[];

  final hasil = await ulangiAsinkron(
    () async {
      if (++panggilan < 3) throw StateError('gagal');
      return 'ok';
    },
    tidur: (d) async => jeda.add(d), // tidak menunggu; hanya mencatat
  );

  expect(hasil, 'ok');
  expect(jeda, [
    const Duration(milliseconds: 100),
    const Duration(milliseconds: 200),
  ]);
});
```

- `tidur: (d) async => jeda.add(d)` — penunda palsu yang langsung selesai dan mencatat argumennya; tes tetap `async` biasa tanpa Zone khusus.
- Pilih ini bila kode sudah menerima penunda (seperti di 5.6); pilih `fakeAsync` bila kamu menguji kode yang memakai `Future.delayed` atau `Timer` secara langsung.

### E. Terminologi Esensial

- **Deterministik** — hasil ditentukan sepenuhnya oleh masukan, bukan oleh waktu atau keberuntungan. **Tes rapuh (flaky)** — kadang lulus, kadang gagal tanpa perubahan kode.
- **Waktu virtual** — jam palsu yang maju hanya atas perintah tes (`elapse`). **Zone** — lingkup eksekusi yang dapat mengubah perilaku timer dan microtask di dalamnya.
- **Gerbang (gate)** — `Completer` yang dipegang tes untuk menahan dan melepas sebuah operasi pada saat yang dipilih.
- **Interleaving** — urutan selang-seling langkah-langkah dari beberapa operasi konkuren.
- **Fake terprogram** — implementasi palsu yang berperilaku sesuai skrip (gagal sekian kali, menahan, dsb.). **Fault injection** — menyuntikkan kegagalan secara sengaja (5.8).
- **Matcher asinkron** — matcher yang menunggu hasil (`completion`, `emitsInOrder`, `throwsA`) dan dipasangkan dengan `expectLater`.
- **Kebocoran timer** — timer yang masih terjadwal setelah pekerjaan seharusnya selesai atau dibatalkan.

### F. Visualisasi (ASCII)

```text
 WAKTU NYATA (anti-pola)                    WAKTU VIRTUAL (fakeAsync)
 ───────────────────────                    ─────────────────────────
 tes ─► Future.delayed(100 ms)              tes ─► async.elapse(100 ms)
        OS benar-benar menunggu                    jam palsu maju 100 ms
        total = jumlah semua jeda                  timer jatuh tempo menyala
        hasil bergantung beban mesin               microtask dikuras
                                                   total ≈ 0 ms nyata; hasil sama tiap kali
```

```text
 r.tarik(80) ─► [cek lolos] ─► await gerbang[0] ─┐
 r.tarik(80) ─► [cek lolos] ─► await gerbang[1] ─┤   tes memegang kedua gerbang
                                                 │
   urutan [0, 1]:  complete(0) ─► A lanjut ─► complete(1) ─► B lanjut
   urutan [1, 0]:  complete(1) ─► B lanjut ─► complete(0) ─► A lanjut

   urutan complete = urutan lanjutan (antrean microtask masuk-pertama-keluar-pertama)
   ─► tes dapat menelusuri SEMUA permutasi dan menegaskan sifat yang selalu benar
```

```text
 Apa yang dikendalikan, dan dengan apa?
   waktu ........... fakeAsync.elapse  atau  penunda/jam yang disuntikkan
   urutan selesai .. gerbang Completer
   kegagalan ....... fake terprogram (5.8)
   keacakan ........ seed tetap
   isolate ......... logika murni dites langsung; pembungkus dites tipis dan ber-timeout
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 7.1 (microtask dan event menjelaskan mengapa `flushMicrotasks` dan `elapse` ada), 7.2 (`Completer`), 7.3 (timeout dan pembatalan), 7.4 (stream), 7.5 (isolate), 7.6 (balapan yang kini dibuktikan), serta 5.6 dan 5.8 (penunda yang disuntikkan, fake terprogram, *fault injection*).
- **Dikembangkan di:** 7.8 (To-Do v6 diuji dengan seluruh teknik ini), 7.9 (debounce dan throttle diuji dengan waktu virtual), Fase 10 (tes properti untuk interleaving, uji mutasi, mendeteksi dan mengisolasi tes rapuh di CI), dan Fase 11 (fake untuk adaptor di batas arsitektur).

### H. Tips & Praktik Terbaik

- Mulai dari pertanyaan “apa yang membuat tes ini tak deterministik?” lalu kendalikan *persis itu*: waktu, urutan, kegagalan, atau acak.
- Untuk setiap tes balapan, lakukan **uji mutasi manual**: hapus perbaikannya (misalnya antrean) dan pastikan tes memang gagal. Tes yang tak pernah bisa gagal tidak membuktikan apa pun.
- Tegaskan **sifat** yang berlaku di semua urutan (saldo tak pernah negatif, tepat satu berhasil), bukan hanya satu skenario.
- Beri tiap tes asinkron yang menyentuh isolate atau I/O nyata `timeout:` pendek agar tes menggantung gagal cepat.
- Setelah menguras jam, periksa `nonPeriodicTimerCount` dan `periodicTimerCount`: ini cara termurah menemukan timer yang bocor.
- Untuk memberi satu giliran event loop di tes biasa (bukan `fakeAsync`), `await Future<void>.delayed(Duration.zero)` cukup; itu bukan tidur, melainkan “biarkan antrean berjalan sekali”.
- Tutup semua `StreamQueue`, `StreamController`, dan langganan di `addTearDown` agar tes tak meninggalkan sisa (lihat 7.9 untuk lint terkait).

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| `await` di dalam callback `fakeAsync` | Tes macet atau kondisi tak terduga | Jaga callback sinkron; tangkap hasil lewat `.then`, majukan dengan `elapse` |
| Lupa `flushMicrotasks` atau `elapse` sebelum `expect` | Nilai masih awal; tes gagal “misterius” | Kuras dulu; lanjutan `await` baru berjalan setelahnya |
| Memakai `DateTime.now()` di logika | Waktu tak mengikuti jam palsu | `clock.now()` dari `package:clock` atau jam sebagai parameter |
| Membuat `Future` sebelum masuk `fakeAsync` | Timer-nya nyata; tak terkendali | Buat semua objek yang diuji *di dalam* callback |
| I/O nyata (berkas, soket) di dalam `fakeAsync` | Tak pernah selesai | Ganti dengan fake; uji I/O nyata di tes biasa |
| `expect(future, ...)` tanpa menunggu | Tes selesai sebelum ekspektasi terpenuhi | `await expectLater(...)` |
| Tes balapan yang hanya mencoba satu urutan | Lulus walau bug masih ada | Telusuri semua permutasi dengan gerbang; lakukan uji mutasi |
| Menguji isolate dengan `fakeAsync` | Tak berpengaruh pada isolate lain | Pisahkan logika murni; tes integrasi tipis ber-timeout |
| Tes tanpa `timeout` yang menyentuh isolate | Macet sampai batas bawaan runner | Tambahkan `timeout: const Timeout(...)` |
| Timer tertinggal setelah pembatalan | Kebocoran dan efek tak terduga di tes berikutnya | Periksa `nonPeriodicTimerCount == 0` setelah menguras jam |

### J. Sumber Referensi

- ✔ Changelog `fake_async` (`fakeAsync()`, `elapse`, `flushMicrotasks`, `flushTimers`, integrasi `clock`): https://pub.dev/packages/fake\_async/changelog
- Paket `fake_async`: https://pub.dev/packages/fake\_async · Paket `clock`: https://pub.dev/packages/clock
- Paket `test`: https://pub.dev/packages/test · Pengujian di Dart: https://dart.dev/tools/testing
- Paket `async` (`StreamQueue`): https://pub.dev/packages/async · API `Completer`: https://api.dart.dev/stable/dart-async/Completer-class.html
- Martin Fowler, *Eradicating Non-Determinism in Tests*: https://martinfowler.com/articles/nonDeterminism.html

---

## 7.8 Studi Kasus Terpadu: To-Do v6 (TAMBAHAN)

*Motivasi: asinkron yang matang bukan yang paling cepat, melainkan yang urutannya dapat dibuktikan.*

> **Mengapa ditambahkan.** Fase 7 paling jelas bila diterapkan pada kode yang sudah kamu kenal. Mengubah penyimpanan v5 menjadi asinkron memunculkan hampir semua masalah modul ini sekaligus: (1) di antara menghitung dan mengomit kini ada `await`, sehingga dua perintah bersamaan dapat saling menimpa (7.6); (2) penulisan bisa menggantung, sehingga perlu timeout yang jujur tentang hasil yang tak pasti (7.3); (3) pekerjaan berat dipindah ke isolate dengan mengirim hanya yang perlu (7.5); (4) shell membaca stdin sebagai stream dengan *backpressure* (7.4); dan (5) semuanya dibuktikan dengan waktu virtual dan gerbang (7.7).

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Langkah & kode · D Variasi · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Kamu memperbarui `lib/todo.dart` dari Fase 6.7: (1) `Penyimpan` menjadi asinkron, dan `PenyimpanBerkas` memakai `dart:io` asinkron dengan nama berkas sementara yang unik serta *pagar* generasi; (2) `AplikasiTodo.muat` dan `proses` menjadi `Future`, dan `proses` diserialkan oleh `Antrean`; (3) `ulangiAsinkron` dari 7.7 dipakai dengan timeout per percobaan; (4) `bersihkan` untuk data besar dihitung di `Isolate.run`; (5) shell memakai `await for` di atas stdin; (6) tes memakai waktu virtual dan gerbang. `Perintah`, `Urai`, `Item`, `Judul`, `Riwayat`, `jalankan`, `cari`, `tanpaDuplikat` dan `tanpaDuplikatLambat`, serta seluruh helper kegagalan 5.5–5.7 **tidak berubah**: bukti bahwa inti murni tak terganggu oleh asinkron. Tambahkan `fake_async` ke `dev_dependencies`.

### B. Konsep Kunci & Filosofi Mendalam

- **Asinkron menyentuh tepi, bukan inti.** `jalankan` tetap fungsi murni sinkron; yang berubah hanya `Penyimpan` dan koordinator `AplikasiTodo`.
- **Setiap `await` adalah tempat dunia boleh masuk (7.6).** v5 aman karena sinkron. v6 menaruh `await` di antara menghitung `baru` dari `_riwayat` dan mengomit `_riwayat = baru`: dua perintah bersamaan akan sama-sama berangkat dari riwayat lama dan salah satunya hilang (*lost update*). Solusinya menyerialkan seluruh `proses` lewat antrean, sehingga cek, hitung, simpan, dan komit tak pernah berselang-seling.
- **Komit setelah persisten tetap berlaku (5.8).** `_riwayat = baru` hanya setelah penyimpanan berhasil; bedanya kini ada `await` sebelum baris itu.
- **Timeout bukan pembatalan (7.3).** Setelah `TimeoutException`, penulisan di bawahnya masih berjalan dan hasilnya tak pasti. Tiga pengaman: (a) penulisan selalu *snapshot penuh*, jadi idempoten dan aman diulang; (b) nama berkas sementara unik dan *pagar generasi*: penulisan lama yang terlambat tak boleh menimpa yang lebih baru; (c) kebijakan eksplisit: timeout dianggap transien (diulang), dan bila jatah habis perubahan dibatalkan di memori dan dilaporkan “terlalu lama”.
- **Batas yang jujur.** Pagar mempersempit, tetapi tidak menutup sepenuhnya, celah antara pemeriksaan pagar dan `rename` yang sudah berjalan di sistem operasi. Jaminan penuh membutuhkan nomor urut di dalam berkas yang diperiksa pembaca (Latihan 7.8). Menuliskan batas ini adalah bagian dari desain yang baik.
- **Isolate: kirim hanya yang perlu.** Isolate menerima `List<String>` judul dan mengembalikan `List<int>` indeks; item *asli* dirakit kembali di isolate utama. Itu menjaga identitas objek dan berbagi struktur pada `Riwayat`, dan menghindari menyalin seluruh daftar.
- **Ambang berdasarkan pengukuran (6.2).** Di bawah ambang ukuran data, biaya spawn dan salin lebih besar daripada biaya hitung; angka bawaan di kode adalah titik awal ilustratif, bukan kebenaran.
- **Closure isolate dibuat di fungsi tingkat atas** agar hanya menangkap data yang dimaksud (jebakan 7.5).
- **Shell dengan *backpressure*.** `await for` + `await app.proses(...)` membuat baris berikutnya tak ditarik sebelum perintah sekarang selesai.
- **Penjaga terakhir untuk galat asinkron.** `runZonedGuarded` menangkap galat tak tertangani yang lolos, mencatatnya dengan jejak, dan mengakhiri dengan kode 70 (5.8, 7.3).
- **Dampak desain:** karena inti murni dan antrean memusatkan urutan, seluruh keamanan konkurensi terletak pada satu kelas kecil yang bisa dibuktikan oleh tes.

### C. Langkah, Sintaks, dan Kode

**Langkah 1 — kebijakan semua jalur (tambahan terhadap tabel 5.8).**

| Jalur | Kondisi atau kegagalan | Keputusan | Ke pengguna | Kode keluar |
| --- | --- | --- | --- | --- |
| Muat: berkas belum ada | — | Daftar kosong | — | 0 |
| Muat: `GagalBaca` | Izin atau I/O | Naik ke shell | Pesan `untukPengguna` | 74 |
| Muat: data rusak | `FormatException` | Cadangkan, mulai kosong | Peringatan | 0 |
| Proses: dua perintah bersamaan | — | Diantre; berjalan satu per satu | — | — |
| Proses: `GagalTulis` transien | Berkas terkunci dll. | Ulangi dengan backoff | — | — |
| Proses: penulisan melewati batas waktu | `TimeoutException` | Dianggap transien (hasil tak pasti; snapshot penuh idempoten) lalu ulangi | — | — |
| Proses: permanen atau jatah habis | `GagalTulis` | Batalkan perubahan, log galat | `gagal menyimpan; perubahan dibatalkan` | 0 |
| Proses: jatah habis karena timeout | `TimeoutException` | Batalkan perubahan, log galat | `penyimpanan terlalu lama; perubahan dibatalkan` | 0 |
| Bersihkan pada data besar | — | Dihitung di isolate | — | — |
| Galat lolos (bug, termasuk dari isolate) | `Error`, `RemoteError` | Catat dengan jejak, akhiri | — | 70 |

**Langkah 2 — antarmuka asinkron dan penyimpan.**

```dart
import 'dart:async';
import 'dart:io';
import 'dart:isolate';

abstract interface class Penyimpan {
  Future<String?> baca();
  Future<void> tulis(String isi);
  Future<void> cadangkan(String isi);
}

class PenyimpanBerkas implements Penyimpan {
  PenyimpanBerkas(this.jalur);
  final String jalur;
  int _generasi = 0; // pagar: penulisan lama tak boleh menimpa yang baru
  int _urut = 0; // pembeda nama berkas sementara

  @override
  Future<String?> baca() async {
    try {
      return await File(jalur).readAsString();
    } on PathNotFoundException {
      return null; // berkas belum ada: bukan galat
    } on FileSystemException catch (e) {
      throw GagalBaca(jalur, e);
    }
  }

  @override
  Future<void> tulis(String isi) {
    final saya = ++_generasi; // dicatat SEKARANG, sinkron, saat dipanggil
    return _tulisAtomik(jalur, isi, masihTerbaru: () => saya == _generasi);
  }

  @override
  Future<void> cadangkan(String isi) => _tulisAtomik('$jalur.rusak', isi);

  Future<void> _tulisAtomik(
    String tujuan,
    String isi, {
    bool Function()? masihTerbaru,
  }) async {
    final sementara = File('$tujuan.${_urut++}.tmp');
    try {
      await sementara.writeAsString(isi, flush: true);
      if (masihTerbaru != null && !masihTerbaru()) {
        await _hapusDiam(sementara); // ada penulisan lebih baru: jangan timpa dengan data lama
        return;
      }
      await sementara.rename(tujuan);
    } on FileSystemException catch (e) {
      await _hapusDiam(sementara);
      throw GagalTulis(tujuan, e);
    }
  }
}

Future<void> _hapusDiam(File f) async {
  try {
    await f.delete();
  } on FileSystemException {
    // sudah tak ada: tak apa
  }
}

class PenyimpanMemori implements Penyimpan {
  PenyimpanMemori([this._isi]);
  String? _isi;
  String? cadangan;

  @override
  Future<String?> baca() async => _isi;

  @override
  Future<void> tulis(String isi) async => _isi = isi;

  @override
  Future<void> cadangkan(String isi) async => cadangan = isi;
}
```

- `abstract interface class Penyimpan` — tiga operasi kini mengembalikan `Future`; kompilator menolak semua implementasi lama sampai diperbarui (perubahan yang dipandu kompilator, seperti 5.8).
- `File(jalur).readAsString()` — membaca berkas secara asinkron; `PathNotFoundException` (subtipe `FileSystemException`) berarti berkas belum ada, jadi `null`; galat I/O lain diterjemahkan menjadi `GagalBaca` di adaptor (5.5).
- `final saya = ++_generasi;` — mencatat nomor generasi *saat `tulis` dipanggil*, sebelum ada `await`; itulah “tiket” penulisan ini.
- `masihTerbaru: () => saya == _generasi` — pemeriksaan terakhir sebelum `rename`: bila ada `tulis` yang lebih baru, penulisan lama membuang berkas sementaranya dan berhenti.
- `'$tujuan.${_urut++}.tmp'` — nama berkas sementara unik per penulisan, supaya penulisan yang tertinggal tak berebut berkas yang sama dengan penulisan berikutnya.
- `writeAsString(isi, flush: true)` lalu `rename(tujuan)` — tulis ke berkas sementara, pastikan data terdorong ke penyimpanan, kemudian ganti secara atomik (5.5).
- `_hapusDiam` menelan galat “berkas sudah tak ada” dengan komentar alasan, bukan blok kosong tanpa penjelasan.
- `PenyimpanMemori` kini `async`; `=> _isi = isi` valid pada `Future<void>` karena nilai ekspresinya diabaikan.

**Langkah 3 — antrean dan koordinator `AplikasiTodo` yang asinkron.**

```dart
/// Antrean minimal setara 7.6: kerja dijalankan SATU PER SATU, berurutan.
class Antrean {
  Future<void> _ekor = Future<void>.value();

  Future<T> jalankan<T>(Future<T> Function() kerja) {
    final hasil = _ekor.then((_) => kerja());
    // Galat satu kerja tidak boleh menghentikan antrean untuk kerja berikutnya.
    _ekor = hasil.then((_) {}, onError: (Object _) {});
    return hasil;
  }
}

typedef HasilMuat = ({AplikasiTodo aplikasi, List<String> peringatan});

class AplikasiTodo {
  AplikasiTodo._(
    this._penyimpan,
    this._riwayat,
    this._tidur,
    this._catat,
    this._batasTulis,
    this._ambangIsolate,
  );

  final Penyimpan _penyimpan;
  Riwayat<List<Item>> _riwayat;
  final Future<void> Function(Duration) _tidur;
  final Pencatat _catat;
  final Duration _batasTulis;
  final int _ambangIsolate;
  final _antrean = Antrean();

  static Future<HasilMuat> muat(
    Penyimpan penyimpan, {
    int batas = 50,
    Duration batasTulis = const Duration(seconds: 2),
    int ambangIsolate = 20000,
    Future<void> Function(Duration) tidur = _tidurNyata,
    Pencatat catat = pencatatStderr,
  }) async {
    final peringatan = <String>[];
    var awal = <Item>[];
    final isi = await penyimpan.baca(); // GagalBaca dibiarkan naik
    if (isi != null) {
      try {
        awal = dekode(isi);
      } on FormatException catch (e) {
        await penyimpan.cadangkan(isi);
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
        batasTulis,
        ambangIsolate,
      ),
      peringatan: peringatan,
    );
  }

  /// Snapshot daftar saat ini (tak dapat diubah).
  List<Item> get daftar => List.unmodifiable(_riwayat.kini);

  /// Perintah diproses SATU PER SATU, walau dipanggil bersamaan.
  Future<List<String>> proses(Perintah perintah) =>
      _antrean.jalankan(() => _prosesSerial(perintah));

  /// Menunggu semua perintah yang sudah diantre selesai (panggil sebelum keluar).
  Future<void> tutup() => _antrean.jalankan(() async {});

  Future<List<String>> _prosesSerial(Perintah perintah) async {
    final (baru, keluaran) = await _hitung(_riwayat, perintah);
    if (identical(baru, _riwayat)) return keluaran; // tak ada perubahan: tak menulis

    try {
      await ulangiAsinkron<void>(
        () => _penyimpan.tulis(kodekan(baru.kini)).timeout(_batasTulis),
        bisaDiulang: (e) =>
            e is TimeoutException ||
            (e is GagalTulis && transienIo(e.penyebab ?? e)),
        tidur: _tidur,
      );
    } on GagalTulis catch (e, s) {
      _catat(Tingkat.galat, 'gagal menyimpan', galat: e, jejak: s);
      return const ['gagal menyimpan; perubahan dibatalkan'];
    } on TimeoutException catch (e, s) {
      _catat(Tingkat.galat, 'penyimpanan melewati batas waktu', galat: e, jejak: s);
      return const ['penyimpanan terlalu lama; perubahan dibatalkan'];
    }
    _riwayat = baru; // komit di memori HANYA setelah penyimpanan berhasil
    return keluaran;
  }

  Future<(Riwayat<List<Item>>, List<String>)> _hitung(
    Riwayat<List<Item>> r,
    Perintah perintah,
  ) async {
    if (perintah is Bersihkan && r.kini.length >= _ambangIsolate) {
      return _terapkanBersih(r, await _tanpaDuplikatDiIsolate(r.kini));
    }
    return jalankan(r, perintah);
  }
}

// Refaktor kecil dari v5: pemisahan menghitung dan menerapkan hasil bersih.
(Riwayat<List<Item>>, List<String>) _terapkanBersih(
  Riwayat<List<Item>> r,
  List<Item> bersih,
) {
  final dibuang = r.kini.length - bersih.length;
  if (dibuang == 0) return (r, const ['tidak ada duplikat']);
  return (r.ubah(bersih), ['dibuang: $dibuang duplikat']);
}
// Di jalankan(...) versi sinkron: Bersihkan() => _terapkanBersih(r, tanpaDuplikat(r.kini)),

List<int> _indeksTanpaDuplikat(List<String> judul) {
  final terlihat = <String>{};
  return [
    for (var i = 0; i < judul.length; i++)
      if (terlihat.add(judul[i])) i,
  ];
}

Future<List<Item>> _tanpaDuplikatDiIsolate(List<Item> daftar) async {
  final judul = [for (final item in daftar) item.judul.teks]; // hanya String yang dikirim
  final indeks = await Isolate.run(() => _indeksTanpaDuplikat(judul));
  return [for (final i in indeks) daftar[i]]; // item ASLI dipertahankan
}
```

- `Antrean._ekor` — `Future` yang selesai ketika kerja terakhir selesai; setiap `jalankan` menyambung `kerja` di belakangnya, sehingga urutannya terjamin.
- `hasil.then((_) {}, onError: (Object _) {})` — ekor menelan galat agar satu kerja yang gagal tidak membuat seluruh antrean macet; galat tetap sampai ke pemanggil lewat `hasil`.
- `static Future<HasilMuat> muat(...) async` — pembuatan kini asinkron karena `baca` dan `cadangkan` asinkron; konstruktor privat tetap satu-satunya jalan (4.4).
- `proses` hanya membungkus `_prosesSerial` dengan antrean: seluruh urutan *hitung → simpan → komit* menjadi satu unit tak terpotong.
- `tutup()` memasukkan kerja kosong ke antrean; ia selesai setelah semua kerja sebelumnya, jadi cocok dipanggil sebelum proses keluar.
- `.timeout(_batasTulis)` pada setiap percobaan; `bisaDiulang` memperlakukan `TimeoutException` dan `GagalTulis` transien sebagai layak diulang. Aman karena `tulis` selalu membawa snapshot penuh yang sama.
- Dua blok `on ... catch` menerjemahkan akhir kegagalan menjadi data (pesan) dan log; keduanya tidak mengubah `_riwayat`.
- `perintah is Bersihkan && r.kini.length >= _ambangIsolate` — hanya data besar yang pantas biaya isolate; selebihnya `jalankan` sinkron tanpa perubahan.
- `Isolate.run(() => _indeksTanpaDuplikat(judul))` — closure di fungsi tingkat atas hanya menangkap `judul`; yang kembali hanya `List<int>`.
- `[for (final i in indeks) daftar[i]]` — merakit hasil dari item asli di isolate utama sehingga identitas dan berbagi struktur riwayat terjaga.

**Langkah 4 — shell asinkron dengan *backpressure* dan penjaga terakhir (`bin/logika_fase7.dart`).**

```dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logika_fase7/todo.dart';

Future<AplikasiTodo?> bukaAplikasi(String jalur) async {
  try {
    final (:aplikasi, :peringatan) =
        await AplikasiTodo.muat(PenyimpanBerkas(jalur));
    peringatan.forEach(stderr.writeln);
    return aplikasi;
  } on GagalSimpan catch (e, s) {
    stderr.writeln(untukPengguna(e));
    pencatatStderr(Tingkat.galat, 'gagal membuka aplikasi', galat: e, jejak: s);
    exitCode = KodeKeluar.gagalIo.nilai;
    return null;
  }
}

Future<void> jalankanShell(AplikasiTodo app) async {
  final baris = stdin.transform(utf8.decoder).transform(const LineSplitter());
  stdout.write('todo> ');
  await for (final teks in baris) {
    final token = teks.split(' ').where((t) => t.isNotEmpty).toList();
    switch (uraiPerintah(token)) {
      case UraiGagal(:final alasan):
        stderr.writeln('galat: $alasan');
      case UraiBerhasil(:final perintah):
        (await app.proses(perintah)).forEach(stdout.writeln);
    }
    stdout.write('todo> ');
  }
}

void main(List<String> args) {
  unawaited(runZonedGuarded(() async {
    final app = await bukaAplikasi(args.isNotEmpty ? args.first : 'todo.json');
    if (app != null) {
      await jalankanShell(app);
      await app.tutup(); // kuras antrean sebelum proses berakhir
    }
  }, (e, s) {
    // Penjaga TERAKHIR untuk galat asinkron yang lolos: catat, lalu akhiri.
    pencatatStderr(Tingkat.galat, 'galat internal (bug)', galat: e, jejak: s);
    exitCode = KodeKeluar.bugInternal.nilai;
  }));
}
```

```text
$ dart run
todo> tambah beli roti
ditambah: beli roti
todo> tambah beli susu
ditambah: beli susu
todo> cari roti
1. beli roti
todo> bersihkan
tidak ada duplikat
todo>
```

- `stdin.transform(utf8.decoder).transform(const LineSplitter())` — mengubah aliran byte dari terminal menjadi aliran baris teks (7.4).
- `await for (final teks in baris)` + `await app.proses(perintah)` di dalam badan: langganan dijeda selama perintah berjalan, sehingga baris berikutnya tak ditarik lebih dulu (*backpressure* alami).
- `final (:aplikasi, :peringatan) = await ...` — destrukturisasi record bernama dari hasil `Future` (2.5).
- Galat `GagalSimpan` tetap diterjemahkan satu kali di `bukaAplikasi` (pesan pengguna, log lengkap, kode 74).
- `runZonedGuarded(body, onError)` — menjalankan `body` dalam zona yang menangkap galat asinkron yang tak tertangani; handler-nya adalah satu-satunya “penjaga terakhir” dan hanya melaporkan lalu mengakhiri dengan kode 70.
- `unawaited(...)` — `main` tak perlu menunggu; proses hidup selama masih ada langganan atau pekerjaan.
- `await app.tutup()` setelah shell selesai memastikan penulisan terakhir yang masih antre tak terpotong saat keluar.

**Langkah 5 — tes: waktu virtual, gerbang, isolate, dan berkas nyata (`test/todo_async_test.dart`).**

```dart
import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:fake_async/fake_async.dart';
import 'package:logika_fase7/todo.dart';
import 'package:test/test.dart';

import '../tool/data.dart'; // buatData() dari 6.7

class PenyimpanSkrip implements Penyimpan {
  PenyimpanSkrip({
    this.isi,
    Iterable<Object?> skripTulis = const [],
    this.tahanTulis = false,
  }) : _skripTulis = Queue.of(skripTulis);

  String? isi;
  String? cadangan;
  final bool tahanTulis; // true: tulis() tak pernah selesai (menguji timeout)
  // null = sukses; Completer = tahan sampai diselesaikan tes; lainnya = penyebab galat
  final Queue<Object?> _skripTulis;
  int percobaanTulis = 0;
  final tulisanBerhasil = <String>[];

  @override
  Future<String?> baca() async => isi;

  @override
  Future<void> tulis(String s) async {
    percobaanTulis++;
    if (tahanTulis) await Completer<void>().future;
    final langkah = _skripTulis.isEmpty ? null : _skripTulis.removeFirst();
    switch (langkah) {
      case null:
        break;
      case Completer<void> gerbang:
        await gerbang.future;
      default:
        throw GagalTulis('virtual', langkah);
    }
    tulisanBerhasil.add(s);
    isi = s;
  }

  @override
  Future<void> cadangkan(String s) async => cadangan = s;
}

void diam(Tingkat t, String pesan, {Object? galat, StackTrace? jejak}) {}

/// Satu giliran event loop (bukan tidur): biarkan antrean microtask dan timer 0 ms berjalan.
Future<void> kuras() => Future<void>.delayed(Duration.zero);

void main() {
  group('waktu virtual', () {
    test('transien: backoff 100 ms lalu 200 ms', () {
      fakeAsync((async) {
        final p = PenyimpanSkrip(skripTulis: [
          const FileSystemException('terkunci'),
          const FileSystemException('terkunci'),
        ]);
        late AplikasiTodo app;
        unawaited(AplikasiTodo.muat(p, catat: diam).then((h) => app = h.aplikasi));
        async.flushMicrotasks();

        List<String>? keluaran;
        unawaited(app.proses(Tambah(Judul.dari('roti'))).then((k) => keluaran = k));

        async.flushMicrotasks();
        expect(p.percobaanTulis, 1); // gagal; menunggu 100 ms
        async.elapse(const Duration(milliseconds: 100));
        expect(p.percobaanTulis, 2); // gagal; menunggu 200 ms
        async.elapse(const Duration(milliseconds: 200));
        expect(p.percobaanTulis, 3);
        expect(keluaran, ['ditambah: roti']);
        expect(app.daftar, hasLength(1));
      });
    });

    test('penulisan menggantung: tiap percobaan kena timeout, lalu dibatalkan', () {
      fakeAsync((async) {
        final p = PenyimpanSkrip(tahanTulis: true);
        late AplikasiTodo app;
        unawaited(
          AplikasiTodo.muat(p, batasTulis: const Duration(seconds: 1), catat: diam)
              .then((h) => app = h.aplikasi),
        );
        async.flushMicrotasks();

        List<String>? keluaran;
        unawaited(app.proses(Tambah(Judul.dari('roti'))).then((k) => keluaran = k));

        // 4 percobaan x 1 s  +  jeda 0,1 + 0,2 + 0,4 s  =  4,7 s
        async.elapse(const Duration(seconds: 5));
        expect(p.percobaanTulis, 4);
        expect(keluaran, ['penyimpanan terlalu lama; perubahan dibatalkan']);
        expect(app.daftar, isEmpty); // memori TIDAK berubah
        expect(async.nonPeriodicTimerCount, 0);
      });
    });
  });

  group('urutan dan isolate', () {
    test('dua perintah bersamaan tidak saling menimpa (antrean)', () async {
      final gerbang = Completer<void>();
      final p = PenyimpanSkrip(skripTulis: [gerbang]); // tulis pertama ditahan
      final app = (await AplikasiTodo.muat(p, catat: diam)).aplikasi;

      final a = app.proses(Tambah(Judul.dari('roti')));
      final b = app.proses(Tambah(Judul.dari('susu')));

      await kuras();
      expect(p.percobaanTulis, 1); // b belum mulai: menunggu giliran
      gerbang.complete();
      await Future.wait([a, b]);

      expect(app.daftar.map((i) => i.judul.teks), ['roti', 'susu']);
      expect(p.tulisanBerhasil, hasLength(2));
      expect(dekode(p.isi!).map((i) => i.judul.teks), ['roti', 'susu']); // disk = memori
    });

    test('bersihkan di isolate identik dengan oracle', () async {
      final data = buatData(60, ragam: 20, benih: 3);
      final p = PenyimpanMemori(kodekan(data));
      final app =
          (await AplikasiTodo.muat(p, ambangIsolate: 10, catat: diam)).aplikasi;

      await app.proses(const Bersihkan());

      final harapan = tanpaDuplikatLambat(data).map((i) => i.judul.teks);
      expect(app.daftar.map((i) => i.judul.teks), harapan);
    }, timeout: const Timeout(Duration(seconds: 10)));
  });

  group('PenyimpanBerkas (berkas nyata)', () {
    test('penulisan lama tak menimpa yang baru; tak ada sisa .tmp', () async {
      final dir = Directory.systemTemp.createTempSync('uji_');
      addTearDown(() => dir.deleteSync(recursive: true));
      final s = PenyimpanBerkas('${dir.path}/todo.json');

      await Future.wait([s.tulis('lama'), s.tulis('baru')]);

      expect(await s.baca(), 'baru');
      expect(dir.listSync().map((e) => e.path.split('/').last), ['todo.json']);
    });
  });
}
```

```bash
dart test
```

- `PenyimpanSkrip` adalah *fake terprogram* versi asinkron (5.8): satu antrean skrip menentukan nasib tiap `tulis` — sukses (`null`), ditahan oleh gerbang (`Completer`), atau gagal dengan penyebab tertentu; `tahanTulis` membuat `tulis` menggantung selamanya.
- `case Completer<void> gerbang:` — pola tipe dengan nama; `await gerbang.future` menahan penulisan sampai tes melepaskannya; `default` melempar `GagalTulis` dengan penyebab dari skrip.
- Tes 1 (waktu virtual): `flushMicrotasks` menjalankan percobaan pertama; `elapse(100 ms)` memicu percobaan kedua; `elapse(200 ms)` memicu yang ketiga. Tak ada tidur nyata, dan `AplikasiTodo` memakai `Future.delayed` bawaan yang mengikuti jam palsu.
- Tes 2 (timeout): dengan batas 1 detik, percobaan dimulai pada 0; 1,1; 2,3; dan 3,7 detik dan masing-masing kena timeout; setelah percobaan keempat perubahan dibatalkan di 4,7 detik, memori tetap kosong, dan tak ada timer tersisa.
- Tes 3 (antrean): tulis pertama ditahan di gerbang; setelah `kuras()` hanya satu percobaan tulis yang pernah dimulai, bukti bahwa perintah kedua *menunggu*; setelah gerbang dibuka, kedua item ada di memori **dan** di penyimpan.
- Tes 4 (isolate): `ambangIsolate: 10` memaksa jalur isolate pada data 60 item berduplikat; hasilnya dibandingkan dengan oracle `tanpaDuplikatLambat` dari 6.7.
- Tes 5 (berkas nyata): dua `tulis` bersamaan; pagar membuat yang lama menyerah, hasil akhirnya `baru`, dan direktori hanya berisi `todo.json`.
- Uji mutasi (wajib): hapus `_antrean.jalankan` dari `proses` dan pastikan Tes 3 gagal; hapus pemeriksaan `masihTerbaru` dan pastikan Tes 5 gagal.

### D. Variasi Kode untuk Logika yang Sama

| Keputusan | Pilihan | Kelebihan | Kekurangan |
| --- | --- | --- | --- |
| Serialisasi | `Antrean` (dipilih) | Sederhana, tanpa dependensi, galat terisolasi | Satu antrean untuk semua perintah |
| Serialisasi | `Pool(1).withResource` | Satu baris; paket terawat | Dependensi tambahan |
| Serialisasi | Optimistik: simpan nomor versi, ulangi bila berubah | Tak ada penantian di jalur normal | Logika ulang; sulit dengan efek samping |
| Serialisasi | Aktor: satu isolate pemilik tunggal state | Isolasi kuat | Biaya pesan; kompleks untuk aplikasi sekecil ini |
| Timeout | Per percobaan (dipilih) | Satu percobaan menggantung tak menghabiskan seluruh jatah | Total waktu bisa melebihi satu batas |
| Timeout | Batas total (*deadline*) | Waktu maksimum jelas bagi pengguna | Perlu memotong percobaan terakhir |
| Bersihkan | `Isolate.run` per perintah (dipilih) | Sederhana; tak ada state | Biaya spawn tiap kali |
| Bersihkan | Pekerja berumur panjang (7.9) | Biaya spawn sekali | Perlu protokol pesan dan pengawasan |

```dart
import 'package:pool/pool.dart';

final _kunci = Pool(1); // satu slot = mutex

Future<List<String>> proses(Perintah perintah) =>
    _kunci.withResource(() => _prosesSerial(perintah));
```

- Hasilnya setara dengan `Antrean` untuk kebutuhan ini; pilih `Antrean` bila ingin nol dependensi, `Pool` bila kamu juga ingin membatasi konkurensi untuk hal lain (7.6).

### E. Terminologi Esensial

- **Lost update** — dua operasi berangkat dari keadaan yang sama dan salah satu hasilnya hilang. **Serialisasi** — memaksa operasi berjalan satu per satu.
- **Hasil tak pasti (*unknown outcome*)** — setelah timeout kita tak tahu apakah operasi akhirnya berhasil. **Idempoten** — mengulang tak mengubah hasil akhir; di sini karena selalu menulis snapshot penuh.
- **Pagar (*fencing*) generasi** — nomor urut yang dibawa tiap operasi agar yang lebih lama tak menimpa yang lebih baru.
- **Kerja zombie** — pekerjaan yang masih berjalan setelah pemanggilnya menyerah (timeout).
- **Ambang** — ukuran data tempat memindahkan kerja ke isolate mulai menguntungkan; ditentukan dari pengukuran.
- **Penjaga terakhir asinkron** — handler `runZonedGuarded` untuk galat tak tertangani.

### F. Visualisasi (ASCII)

```text
   proses(perintah)
      │
      ▼
   Antrean ── satu per satu ──►  _prosesSerial
                                   │
                    _hitung ◄──────┤  Bersihkan besar? ─ ya ─► Isolate.run(indeks)
                       │           │                          (kirim String, terima int)
                 (baru, keluaran)  │
                       │           ▼
                       ├─ tak berubah ─► kembalikan keluaran
                       └─ ulangiAsinkron( tulis(snapshot).timeout )
                              ├─ sukses ─► _riwayat = baru
                              └─ gagal / timeout habis ─► batalkan + log + pesan
```

```text
   batasTulis = 1 s, maksPercobaan = 4, backoff 0,1 / 0,2 / 0,4 s

   t=0       1.0  1.1       2.1  2.3       3.3  3.7       4.7
   ├─ #1 ────┤jeda├─ #2 ────┤jeda├─ #3 ────┤jeda├─ #4 ────┤
   timeout   0,1 s  timeout  0,2 s  timeout  0,4 s  timeout ─► dibatalkan
```

### G. Hubungan dengan Modul Lain

- **Memakai:** seluruh Fase 7 (7.1 hingga 7.7), Fase 6.7 (`cari`, `tanpaDuplikat`, oracle, `buatData`), Fase 5 (`GagalSimpan`, `transienIo`, penulisan atomik, pesan dan log, kode keluar), Fase 4 (antarmuka dan injeksi), serta Fase 3 (riwayat).
- **Dikembangkan di:** Fase 9 (nama berkas sementara yang dapat ditebak, izin berkas, dan TOCTOU pada `rename`), Fase 10 (tes properti untuk interleaving, *fuzzing* berkas, benchmark sebagai bagian CI), Fase 11 (memisahkan paket penyimpanan beserta antarmukanya).

### H. Tips & Praktik Terbaik

- Tulis tabel kebijakan jalur *sebelum* kode dan jadikan tiap barisnya satu tes (kebiasaan 5.8, kini dengan baris timeout dan konkurensi).
- Pusatkan urutan di satu tempat (antrean). Jangan menebar kunci di banyak tempat.
- Jangan percaya timeout sebagai pembatalan; rancang operasi agar aman diulang (idempoten) dan agar yang terlambat tak merusak yang baru (pagar).
- Pindahkan ke isolate hanya setelah mengukur; kirim sesedikit mungkin dan terima ringkasan (indeks), bukan salinan data.
- Buat closure isolate di fungsi tingkat atas; periksa apa yang ia tangkap.
- Lakukan uji mutasi pada setiap tes konkurensi: hapus pengamannya dan lihat tes gagal.
- Tulis batas desainmu terang-terangan (celah pagar, kerja zombie) agar pembaca berikutnya tahu apa yang *tidak* dijamin.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Menghitung baru di luar antrean lalu `await` sebelum komit | Perubahan hilang saat dua perintah bersamaan | Seluruh `proses` di dalam antrean |
| Menyerah pada timeout tanpa memikirkan hasil tak pasti | Memori dan disk berbeda | Snapshot penuh idempoten, ulangi, lalu batalkan di memori bila jatah habis |
| Berkas sementara bernama tetap | Penulisan yang tertinggal merusak yang baru | Nama unik per penulisan + pagar generasi |
| Menangkap daftar besar di closure `Isolate.run` | Salinan besar dan lambat | Kirim hanya data yang perlu dari fungsi tingkat atas |
| Mengirim item ke isolate lalu memakai salinannya | Identitas dan berbagi struktur hilang; tes kesetaraan gagal | Kirim kunci, terima indeks, rakit dari item asli |
| Memakai ambang isolate tanpa mengukur | Isolate lebih lambat dari tanpa isolate | Ukur (6.2) dan tentukan ambang dari data |
| Keluar tanpa menguras antrean | Perintah terakhir tak tersimpan | `await app.tutup()` sebelum selesai |
| Memakai `await` di dalam `fakeAsync` | Tes macet | Callback sinkron; `.then` dan `elapse` (7.7) |
| Tes konkurensi tanpa uji mutasi | Tes lulus walau pengaman dihapus | Hapus pengaman; tes harus gagal |

### J. Sumber Referensi

- ✔ Concurrency di Dart: https://dart.dev/language/concurrency
- `Isolate.run`: https://api.dart.dev/stable/dart-isolate/Isolate/run.html · `runZonedGuarded`: https://api.dart.dev/stable/dart-async/runZonedGuarded.html
- `File`: https://api.dart.dev/stable/dart-io/File-class.html · `File.rename`: https://api.dart.dev/stable/dart-io/File/rename.html · `LineSplitter`: https://api.dart.dev/stable/dart-convert/LineSplitter-class.html
- ✔ Paket `pool`: https://pub.dev/packages/pool · ✔ Changelog `fake_async`: https://pub.dev/packages/fake\_async/changelog
- Race condition: https://en.wikipedia.org/wiki/Race\_condition · Idempotence: https://en.wikipedia.org/wiki/Idempotence
- Martin Kleppmann, *How to do distributed locking* (token pagar/fencing): https://martin.kleppmann.com/2016/02/08/how-to-do-distributed-locking.html

---

## 7.9 Pelengkap Kurikulum: Operator Stream, Kunci per Sumber Daya, Kolam Isolate & Pengawasan (TAMBAHAN)

*Motivasi: kemahiran terlihat pada hal kecil yang diperiksa dua kali — langganan yang dibatalkan, kunci yang dilepas, pekerja yang diawasi.*

> **Mengapa ditambahkan.** Audit akhir terhadap Modul 5.2–5.4 kurikulum menemukan butir yang belum dibahas 7.1–7.8: (5.2) *transformer*, debounce, throttle, serta lint `cancel_subscriptions` dan `close_sinks`; (5.3) kunci per sumber daya (7.6 hanya membahas satu antrean dan `Pool`); (5.4) kolam pekerja, pengawasan lewat `onExit` dan `onError`, dan fakta bahwa isolate **bukan sandbox**. Modul ini menutup semuanya agar Fase 7 setara kurikulum, tanpa mengulang apa yang sudah ada (`StreamQueue` di 7.4 dan 7.7, `Timer.cancel` di 7.7, `Pool` di 7.6).

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Empat topik ringkas yang saling melengkapi: (1) **operator stream**: `StreamTransformer`, `debounce`, `throttle`, dan `switchMap` dari `package:stream_transform`; (2) **disiplin siklus hidup**: lint `cancel_subscriptions` dan `close_sinks` serta pola pemilik tunggal; (3) **kunci per sumber daya**: operasi pada kunci yang sama berurutan, pada kunci berbeda paralel; (4) **kolam isolate dan pengawasan**: `Pool` + `Isolate.run`, pekerja berumur panjang yang diawasi, pembatalan komputasi sungguhan, dan batas isolate sebagai isolasi memori, bukan isolasi hak.

### B. Konsep Kunci & Filosofi Mendalam

- **Operator stream adalah fungsi dari stream ke stream.** Bawaan: `map`, `where`, `asyncMap`, `expand`, `transform`. `StreamTransformer.fromHandlers` membuat transformer sendiri dengan tiga penangan (data, galat, selesai). Paket `stream_transform` menambah operator berbentuk *extension method* seperti `debounce`, `throttle`, `switchMap`, `asyncMapSample`, dan `takeUntil`.
- **Debounce vs throttle.** *Debounce* menunggu hening selama durasi tertentu lalu meneruskan nilai **terakhir** (cocok untuk kotak pencarian). *Throttle* meneruskan nilai **pertama**, lalu menahan sisanya selama durasi (cocok untuk tombol atau gulir). *`switchMap`* beralih ke pekerjaan terbaru dan meninggalkan yang lama (cocok agar hasil pencarian basi tak menimpa yang baru). Semuanya dibangun dari `Timer`, sehingga dites dengan waktu virtual (7.7).
- **Operator pembatas laju membuang data.** Pastikan kehilangan itu memang dapat diterima; untuk data yang tak boleh hilang gunakan *backpressure* (7.4), bukan debounce atau throttle.
- **Langganan dan controller adalah resource.** `StreamSubscription` harus di-`cancel()`, `StreamController` harus di-`close()`. Lint `cancel_subscriptions` dan `close_sinks` menandai yang terlewat. Keduanya heuristik: tidak sempurna, jadi pola yang benar tetap *pemilik tunggal* dengan metode pelepasan eksplisit, `try/finally`, atau `addTearDown` di tes.
- **Kunci per sumber daya.** Satu kunci global menyerialkan hal yang sebenarnya independen. Antrean *per kunci* (misalnya per ISBN atau per rekening) menjaga operasi pada sumber daya yang sama tetap berurutan sambil membiarkan sumber daya berbeda berjalan paralel. Entri kunci yang sudah menganggur harus dibersihkan agar peta tak bocor.
- **Mengunci dua kunci sekaligus berbahaya.** Dua operasi yang masing-masing menahan satu kunci dan menunggu yang lain akan *deadlock*. Aturan baku: ambil kunci dalam urutan tetap (misalnya urut abjad). Untuk membatasi total konkurensi lintas kunci, pasangkan dengan `Pool(n)` (7.6).
- **Dua bentuk kolam isolate.** (a) *Slot*: `Pool(n)` membatasi jumlah `Isolate.run` yang berjalan serentak; sederhana, tahan crash (tiap tugas terisolasi), tetapi membayar biaya spawn per tugas. (b) *Pekerja berumur panjang*: biaya spawn sekali dan dapat menyimpan state, tetapi butuh protokol pesan sealed (7.5), *backpressure*, dan pengawasan. Mulailah dari slot; naik ke pekerja hanya bila pengukuran (6.2) membenarkannya.
- **Pengawasan.** `Isolate.spawn` menerima `onError` (menerima daftar dua string: deskripsi galat dan jejak) dan `onExit` (menerima satu pesan, bawaannya `null`, setelah isolate berakhir). Dengan `errorsAreFatal: true` (bawaan) galat tak tertangani mengakhiri isolate. Kebijakan yang sehat: laporkan sebagai kegagalan terkendali, jangan biarkan program menggantung, dan bila memulai ulang, batasi jumlahnya dengan backoff.
- **`Isolate.run(...).timeout(...)` hanya menghentikan penantian, bukan komputasinya.** Untuk komputasi yang bisa lepas kendali gunakan `Isolate.spawn` dan `Isolate.kill`.
- **Isolate bukan sandbox.** Ia memisahkan *memori*, bukan *hak akses*: kode di isolate punya hak yang sama dengan seluruh proses (berkas, jaringan, variabel lingkungan). Memproses data tak tepercaya di isolate melindungi dari crash dan loop tak berujung, tetapi tidak dari efek samping. Isolasi hak membutuhkan proses OS terpisah dengan hak minimum (Fase 9).
- **Dampak desain:** operator, kunci, dan pengawasan adalah cara membuat konkurensi *terlihat dan terkendali*, bukan sekadar berjalan.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — `debounce` dan `throttle` dengan waktu virtual.**

```dart
import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:test/test.dart';

void main() {
  test('debounce: hanya nilai terakhir setelah hening 300 ms', () {
    fakeAsync((async) {
      final kontrol = StreamController<String>();
      final diterima = <String>[];
      final langganan = kontrol.stream
          .debounce(const Duration(milliseconds: 300))
          .listen(diterima.add);

      kontrol.add('a');
      async.elapse(const Duration(milliseconds: 100));
      kontrol.add('ab');
      async.elapse(const Duration(milliseconds: 100));
      kontrol.add('abc');
      async.elapse(const Duration(milliseconds: 299));
      expect(diterima, isEmpty); // belum hening 300 ms
      async.elapse(const Duration(milliseconds: 1));
      expect(diterima, ['abc']);

      unawaited(langganan.cancel());
      unawaited(kontrol.close());
    });
  });

  test('throttle: nilai pertama lolos, sisanya ditahan 300 ms', () {
    fakeAsync((async) {
      final kontrol = StreamController<int>();
      final diterima = <int>[];
      final langganan = kontrol.stream
          .throttle(const Duration(milliseconds: 300))
          .listen(diterima.add);

      kontrol.add(1); // lolos
      async.elapse(const Duration(milliseconds: 100));
      kontrol.add(2); // dibuang: masih dalam jendela
      async.elapse(const Duration(milliseconds: 100));
      kontrol.add(3); // dibuang
      async.elapse(const Duration(milliseconds: 150)); // t = 350 ms: jendela lewat
      kontrol.add(4); // lolos
      async.elapse(const Duration(milliseconds: 1));
      expect(diterima, [1, 4]);

      unawaited(langganan.cancel());
      unawaited(kontrol.close());
    });
  });
}
```

- `import 'package:stream_transform/stream_transform.dart'` — menambahkan operator sebagai *extension method* pada `Stream`; tambahkan `stream_transform` ke `dependencies`.
- `.debounce(const Duration(milliseconds: 300))` — setiap nilai baru mengulang hitungan; nilai diteruskan hanya setelah 300 ms tanpa nilai baru.
- Pasangan `299 ms` / `1 ms` membuktikan batas tepat, seperti di 7.7; `'a'` dan `'ab'` tak pernah sampai ke hilir.
- `.throttle(...)` — nilai pertama diteruskan segera, lalu nilai berikutnya dalam jendela 300 ms dibuang; setelah jendela lewat, nilai `4` lolos. Hasil `[1, 4]` menunjukkan `2` dan `3` hilang *dengan sengaja*.
- `langganan.cancel()` dan `kontrol.close()` — melepas resource di akhir tes, sesuai disiplin B.

**Contoh 2 — `StreamTransformer.fromHandlers` buatan sendiri.**

```dart
import 'dart:async';

final hanyaGenap = StreamTransformer<int, String>.fromHandlers(
  handleData: (angka, sink) {
    if (angka.isEven) sink.add('genap: $angka');
  },
  handleError: (galat, jejak, sink) => sink.addError(galat, jejak),
  handleDone: (sink) {
    sink.add('selesai');
    sink.close(); // penangan custom WAJIB menutup sink sendiri
  },
);

Future<void> main() async {
  final hasil = await Stream.fromIterable([1, 2, 3, 4]).transform(hanyaGenap).toList();
  print(hasil); // [genap: 2, genap: 4, selesai]
}
```

- `StreamTransformer<int, String>` — masuk `int`, keluar `String`; dua tipe generik menjelaskan perubahan tipe aliran.
- `handleData` dipanggil per nilai masuk dan memutuskan apa yang dikeluarkan lewat `sink.add`; di sini ia menyaring (hanya genap) sekaligus mengubah tipe.
- `handleError` meneruskan galat apa adanya beserta jejaknya; di sinilah galat dapat diterjemahkan atau ditelan secara sadar.
- `handleDone` menambahkan penanda `selesai` lalu **wajib** `sink.close()`; jika lupa, stream hilir tak pernah selesai.
- `.transform(hanyaGenap)` — menerapkan transformer pada stream; dapat dirantai dengan operator lain.

**Contoh 3 — lint untuk siklus hidup, dan pola pemilik tunggal.**

```yaml
# analysis_options.yaml
linter:
  rules:
    - cancel_subscriptions
    - close_sinks
    - unawaited_futures
```

```dart
import 'dart:async';

// BURUK: langganan dan controller tak pernah dilepas
void buruk(Stream<int> aliran) {
  final langganan = aliran.listen(print); // cancel_subscriptions
  final kontrol = StreamController<int>(); // close_sinks
}

// BAIK: pemilik tunggal dengan metode pelepasan eksplisit
class Pemantau {
  Pemantau(Stream<int> aliran) {
    _langganan = aliran.listen(_terima);
  }

  late final StreamSubscription<int> _langganan;
  final _keluar = StreamController<int>();

  Stream<int> get hasil => _keluar.stream;

  void _terima(int nilai) => _keluar.add(nilai * 2);

  Future<void> tutup() async {
    await _langganan.cancel();
    await _keluar.close();
  }
}
```

- `linter: rules:` — mengaktifkan aturan tambahan di `analysis_options.yaml`; `dart analyze` kemudian menandai pelanggarannya.
- `cancel_subscriptions` — menandai `StreamSubscription` yang tak pernah dibatalkan; `close_sinks` — menandai `Sink` atau `StreamController` yang tak pernah ditutup.
- `Pemantau` mengumpulkan kedua resource dalam satu pemilik dan menyediakan `tutup()`; siapa pun yang membuat `Pemantau` bertanggung jawab memanggilnya (pola bracket 5.4).
- `late final StreamSubscription<int> _langganan` — diinisialisasi di badan konstruktor tepat sekali; `final` menjaga agar tak ditimpa tanpa sengaja.
- Lint hanya membantu: ia tak melihat pelepasan yang terjadi di tempat lain. Tes dengan `addTearDown` dan peninjauan tetap diperlukan.

**Contoh 4 — kunci per sumber daya: kunci sama berurutan, kunci berbeda paralel.**

```dart
import 'dart:async';

import 'package:test/test.dart';

class KunciPerKunci<K> {
  final _ekor = <K, Future<void>>{};

  Future<T> jalankan<T>(K kunci, Future<T> Function() kerja) {
    final sebelumnya = _ekor[kunci] ?? Future<void>.value();
    final hasil = sebelumnya.then((_) => kerja());
    final ekorBaru = hasil.then((_) {}, onError: (Object _) {});
    _ekor[kunci] = ekorBaru;
    // Bersihkan entri bila tak ada yang antre lagi, agar peta tak membesar selamanya.
    unawaited(ekorBaru.then((_) {
      if (identical(_ekor[kunci], ekorBaru)) _ekor.remove(kunci);
    }));
    return hasil;
  }
}

/// Dua kunci sekaligus: ambil dalam URUTAN TETAP agar tak terjadi deadlock.
Future<T> denganDuaKunci<T>(
  KunciPerKunci<String> kunci,
  String a,
  String b,
  Future<T> Function() kerja,
) {
  if (a == b) return kunci.jalankan(a, kerja); // kunci yang sama dua kali = deadlock diri sendiri
  final urut = [a, b]..sort();
  return kunci.jalankan(urut[0], () => kunci.jalankan(urut[1], kerja));
}

void main() {
  test('kunci berbeda berjalan paralel; kunci sama berurutan', () async {
    final k = KunciPerKunci<String>();
    final log = <String>[];
    final gerbangA = Completer<void>();

    final a1 = k.jalankan('A', () async {
      log.add('A1 mulai');
      await gerbangA.future;
      log.add('A1 selesai');
    });
    final a2 = k.jalankan('A', () async => log.add('A2'));
    final b1 = k.jalankan('B', () async => log.add('B1'));

    await b1; // B tidak menunggu A
    expect(log, ['A1 mulai', 'B1']);
    gerbangA.complete();
    await Future.wait([a1, a2]);
    expect(log, ['A1 mulai', 'B1', 'A1 selesai', 'A2']);
  });
}
```

- `_ekor` — peta dari kunci ke “ekor” antrean kunci itu; tiap kunci punya rantai kerja sendiri.
- `_ekor[kunci] ?? Future<void>.value()` — kunci baru dimulai dari `Future` yang sudah selesai; kunci lama menyambung di belakang kerja terakhirnya.
- `ekorBaru` menelan galat seperti `Antrean` di 7.8, sehingga satu kerja yang gagal tak menyumbat kunci itu.
- Blok `unawaited(ekorBaru.then(...))` membersihkan entri hanya bila `ekorBaru` masih ekor terakhir (`identical`); bila sudah ada kerja yang diantre sesudahnya, entri dibiarkan.
- `denganDuaKunci` mengurutkan kunci (`..sort()`) sebelum mengambil keduanya, dan menangani `a == b` secara khusus karena mengunci kunci yang sama bersarang akan menunggu dirinya sendiri.
- Tes: `A1` ditahan gerbang; `A2` (kunci sama) menunggu, sedangkan `B1` (kunci berbeda) selesai lebih dulu: bukti paralelisme antar-kunci dan urutan dalam kunci.

**Contoh 5 — kolam bentuk slot: `Pool` + `Isolate.run`.**

```dart
import 'dart:io' show Platform;
import 'dart:isolate';

import 'package:pool/pool.dart';

class KolamHitung {
  KolamHitung([int? pekerja]) : _slot = Pool(pekerja ?? Platform.numberOfProcessors);
  final Pool _slot;

  /// Menjalankan [kerja] di isolate sendiri; paling banyak N berjalan serentak.
  Future<R> jalankan<R>(R Function() kerja) =>
      _slot.withResource(() => Isolate.run(kerja));

  Future<void> tutup() => _slot.close();
}

Future<List<int>> kuadratkanBatch(KolamHitung kolam, List<List<int>> potongan) =>
    Future.wait([
      for (final p in potongan)
        kolam.jalankan(() => p.fold<int>(0, (a, x) => a + x * x)),
    ]);
```

- `Pool(n)` dari `package:pool` — membatasi sumber daya yang dipakai serentak menjadi `n`; `Platform.numberOfProcessors` memberi titik awal yang masuk akal untuk kerja yang terikat CPU.
- `withResource(() => ...)` — mengambil satu slot, menjalankan kerja, dan *selalu* melepas slot walau kerja gagal.
- `Isolate.run(kerja)` — setiap tugas berjalan di isolate sendiri; bila ia crash, hanya tugas itu yang gagal dan galatnya muncul di pemanggil (pengawasan gratis).
- `kuadratkanBatch` membagi data menjadi potongan dan menjalankan semuanya lewat kolam; `Future.wait` menggabungkan hasil dengan urutan yang sama dengan input.
- Ukur percepatan untuk N = 1, 2, 4, 8 (Latihan 7.5); kurva tak linear karena biaya salin, jumlah inti, dan tekanan memori.

**Contoh 6 — pengawasan pekerja: galat dan keluar dilaporkan, program tak menggantung.**

```dart
import 'dart:async';
import 'dart:isolate';

void _pekerjaRusak(SendPort balas) {
  throw StateError('bug di pekerja'); // galat TAK tertangani di isolate lain
}

class PekerjaMati implements Exception {
  PekerjaMati(this.alasan);
  final String alasan;

  @override
  String toString() => 'PekerjaMati: $alasan';
}

Future<int> jalankanDenganPengawas() async {
  final hasil = ReceivePort();
  final galat = ReceivePort();
  final keluar = ReceivePort();
  final selesai = Completer<int>();

  hasil.listen((pesan) {
    if (pesan is int && !selesai.isCompleted) selesai.complete(pesan);
  });
  galat.listen((pesan) {
    if (pesan case [final String deskripsi, final String _]) {
      if (!selesai.isCompleted) selesai.completeError(PekerjaMati(deskripsi));
    }
  });
  keluar.listen((_) {
    // onExit datang SETELAH isolate berakhir, normal maupun karena galat.
    if (!selesai.isCompleted) {
      selesai.completeError(PekerjaMati('berhenti tanpa hasil'));
    }
  });

  await Isolate.spawn(
    _pekerjaRusak,
    hasil.sendPort,
    onError: galat.sendPort, // menerima [deskripsi, jejak] sebagai dua String
    onExit: keluar.sendPort, // menerima null saat isolate berakhir
  ); // errorsAreFatal bawaannya true: galat tak tertangani mengakhiri isolate

  try {
    return await selesai.future.timeout(const Duration(seconds: 5));
  } finally {
    hasil.close(); // port yang terbuka menahan program agar tak pernah selesai
    galat.close();
    keluar.close();
  }
}
```

- Tiga `ReceivePort`: satu untuk hasil, satu untuk `onError`, satu untuk `onExit`; ketiganya diubah menjadi satu `Completer<int>` sehingga pemanggil hanya melihat sukses atau `PekerjaMati`.
- `if (pesan case [final String deskripsi, final String _])` — pola daftar yang mencocokkan bentuk dua-string dari `onError` tanpa `as`; pesan lain diabaikan.
- `!selesai.isCompleted` — melindungi dari penyelesaian ganda: galat dan keluar biasanya datang berurutan untuk satu kejadian.
- `onExit` adalah jaring pengaman: bila isolate berakhir tanpa mengirim hasil maupun galat, pemanggil tetap mendapat kegagalan terkendali.
- `.timeout(const Duration(seconds: 5))` — batas akhir terakhir bila pekerja macet tanpa mati; ia tidak menghentikan isolate (lihat Contoh 7).
- `finally` menutup ketiga port; lupa menutup port adalah penyebab klasik program Dart yang “tidak mau berhenti” (7.5).
- Kebijakan restart (misalnya maksimum tiga kali dengan backoff) dibangun di atas fungsi ini, bukan di dalamnya (Latihan 7.9).

**Contoh 7 — menghentikan komputasi sungguhan: `spawn` + `kill`.**

```dart
import 'dart:async';
import 'dart:isolate';

void _hitungBerat((SendPort, List<int>) argumen) {
  final (balas, data) = argumen;
  balas.send(data.fold<int>(0, (a, x) => a + x * x));
}

Future<int> hitungDenganBatas(List<int> data, Duration batas) async {
  final terima = ReceivePort();
  final isolate = await Isolate.spawn(_hitungBerat, (terima.sendPort, data));
  try {
    return await terima.cast<int>().first.timeout(batas);
  } finally {
    isolate.kill(priority: Isolate.immediate); // hentikan SUNGGUHAN
    terima.close();
  }
}
```

- `Isolate.spawn(_hitungBerat, (terima.sendPort, data))` — pesan awal berupa *record* berisi port balasan dan data; record yang isinya dapat dikirim juga dapat dikirim.
- `final (balas, data) = argumen;` — destrukturisasi record di pekerja; tipe terjaga tanpa `as`.
- `terima.cast<int>().first.timeout(batas)` — menunggu satu hasil bertipe `int` sampai batas waktu.
- `isolate.kill(priority: Isolate.immediate)` di `finally` — menghentikan isolate segera, baik setelah sukses, galat, maupun timeout. Inilah beda dengan `Isolate.run(...).timeout(...)`, yang hanya berhenti menunggu sementara komputasi berjalan terus.
- Tutup `terima` agar tak ada port menggantung.

### D. Opsi Kode Lain untuk Logika yang Sama

| Kebutuhan | Pilihan | Perilaku | Cocok untuk |
| --- | --- | --- | --- |
| Membatasi laju stream | `debounce` | Nilai terakhir setelah hening | Kotak pencarian, validasi saat mengetik |
| Membatasi laju stream | `throttle` | Nilai pertama, sisanya dibuang selama jendela | Tombol, gulir, pengiriman berkala |
| Membatasi laju stream | `asyncMapSample` | Tidak menumpuk panggilan; membuang nilai selama kerja berjalan | Kerja asinkron yang mahal per nilai |
| Hanya hasil terbaru | `switchMap` | Berpindah ke kerja baru, meninggalkan yang lama | Pencarian; hasil basi tak boleh menimpa yang baru |
| Serialisasi per sumber daya | Antrean global | Semua berurutan | Sumber daya tunggal |
| Serialisasi per sumber daya | `KunciPerKunci` | Berurutan per kunci, paralel antar-kunci | ISBN, rekening, berkas |
| Serialisasi per sumber daya | `Pool(n)` | Maksimum `n` serentak, tanpa urutan | Membatasi beban total |
| Kerja berat | `Pool` + `Isolate.run` (slot) | Spawn per tugas; tahan crash | Tugas sporadis atau independen |
| Kerja berat | Pekerja berumur panjang | Spawn sekali; state dapat dipakai ulang | Kerja berat berkelanjutan, setelah diukur |
| Kerja berat yang bisa lepas kendali | `Isolate.spawn` + `kill` | Dapat dihentikan sungguhan | Komputasi dengan batas waktu keras |

Alternatif untuk “hanya hasil pencarian terbaru”: gabungkan debounce dan `switchMap`.

```dart
import 'package:stream_transform/stream_transform.dart';

Stream<List<String>> hasilPencarian(
  Stream<String> kataKunci,
  Future<List<String>> Function(String) cari,
) =>
    kataKunci
        .debounce(const Duration(milliseconds: 300)) // tunggu pengguna berhenti mengetik
        .switchMap((kata) => Stream.fromFuture(cari(kata))); // abaikan hasil pencarian lama
```

- `debounce` mengurangi jumlah pencarian; `switchMap` memastikan hasil dari kata yang sudah usang tak pernah muncul setelah hasil kata yang lebih baru.
- `Stream.fromFuture(cari(kata))` mengubah satu `Future` menjadi stream satu elemen agar cocok dengan tanda tangan `switchMap`.

### E. Terminologi Esensial

- **Transformer** — objek yang mengubah satu stream menjadi stream lain. **Operator** — fungsi atau *extension method* pada `Stream` yang melakukan hal serupa.
- **Debounce, throttle** — pembatas laju: menunggu hening dan meneruskan yang terakhir, atau meneruskan yang pertama lalu menahan sisanya. **`switchMap`** — beralih ke kerja terbaru.
- **Pemilik tunggal** — satu objek yang bertanggung jawab membuat dan melepas resource. **Lint heuristik** — aturan analisis yang menandai pola umum, bukan jaminan.
- **Kunci per sumber daya (*keyed lock*)** — mutex yang dibedakan menurut kunci. **Deadlock** — dua pihak saling menunggu selamanya; dicegah dengan urutan pengambilan kunci yang tetap.
- **Slot** — satu unit konkurensi pada `Pool`. **Pekerja berumur panjang (*long-lived worker*)** — isolate yang dibiarkan hidup untuk menerima banyak tugas.
- **Pengawasan (*supervision*)** — memantau pekerja dan menanggapi kegagalannya (`onError`, `onExit`, restart terbatas). **Kegagalan terkendali** — kegagalan yang dilaporkan sebagai data atau exception yang dikenal, bukan program yang menggantung.
- **Sandbox** — lingkungan yang membatasi *hak akses* kode di dalamnya; isolate tidak memenuhi definisi ini.

### F. Visualisasi (ASCII)

```text
 t (ms)       0     100    200    300    400    500    600    700   ...  1000
 masukan      a     b      c                                 d
 debounce                                c (500)                    d (1000)
 throttle     a (0)                                           d (700)
              └─ b, c dibuang: masih dalam jendela 300 ms
```

```text
 kunci A:  A1 ──► A2 ──► A3          berurutan
 kunci B:  B1 ──► B2                 berurutan, PARALEL dengan A
 kunci C:  C1

 _ekor = { A: ekor(A3), B: ekor(B2), C: ekor(C1) }
 entri dihapus bila ekornya selesai dan tak ada kerja baru yang diantre
```

```text
 Isolate.spawn(..., onError: P1, onExit: P2)
       │
  pekerja berjalan ──► hasil ──────────► P0 ──► Completer.complete(hasil)
       │ galat tak tertangani
       ├──────────────► [deskripsi, jejak] ─► P1 ──► completeError(PekerjaMati)
       └ berakhir ────► null ───────────────► P2 ──► completeError bila belum selesai

  finally: tutup P0, P1, P2     (port terbuka = program tak pernah selesai)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 7.3 (`CancelableOperation`, `Timer`), 7.4 (`StreamQueue`, *backpressure*, siklus hidup langganan), 7.5 (isolate, port, protokol pesan), 7.6 (antrean dan `Pool`), 7.7 (waktu virtual dan gerbang untuk membuktikan semuanya), serta 5.4 (fungsi bracket untuk pelepasan resource).
- **Dikembangkan di:** Fase 9 (isolasi proses dan hak minimum sebagai pengganti anggapan “isolate = sandbox”; validasi data tak tepercaya), Fase 10 (tes properti untuk `KunciPerKunci` dan *fuzzing* pesan pekerja), Fase 11 (pekerja dan kolam sebagai komponen dengan antarmuka yang jelas).

### H. Tips & Praktik Terbaik

- Aktifkan `cancel_subscriptions`, `close_sinks`, dan `unawaited_futures`, dan jadikan `dart analyze` bersih sebagai syarat CI; lint murah, kebocoran mahal.
- Pilih operator menurut maksudnya: debounce untuk “nilai akhir”, throttle untuk “laju maksimum”, `switchMap` untuk “hanya yang terbaru”.
- Jangan memakai operator pembatas laju untuk data yang tak boleh hilang.
- Ambil beberapa kunci dalam urutan tetap, dan tangani kasus kunci yang sama secara khusus.
- Mulai dari kolam slot (`Pool` + `Isolate.run`); naik ke pekerja berumur panjang hanya setelah diukur (6.2).
- Setiap isolate yang kamu `spawn` harus punya jalur berhenti (`kill` di `finally`) dan jalur melapor (`onError`, `onExit`); tutup semua port.
- Batasi restart pekerja (jumlah dan backoff) agar crash berulang tak menjadi loop tak berujung.
- Perlakukan isolate sebagai isolasi *memori* saja; untuk isolasi hak, pakai proses terpisah dengan hak minimum.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Debounce atau throttle pada data yang tak boleh hilang | Data hilang tanpa jejak | Pakai *backpressure* atau buffer (7.4) |
| Lupa `sink.close()` di `handleDone` | Stream hilir tak pernah selesai | Tutup sink di penangan selesai |
| Langganan tak dibatalkan atau controller tak ditutup | Kebocoran; program tak berhenti | Pemilik tunggal, `tutup()`, lint, `addTearDown` |
| Satu kunci global untuk semua sumber daya | Throughput rendah tanpa alasan | Kunci per sumber daya |
| Dua operasi mengambil dua kunci dalam urutan berbeda | Deadlock | Urutan tetap (misalnya urut abjad) |
| Mengunci kunci yang sama secara bersarang | Menunggu diri sendiri selamanya | Tangani `a == b` secara khusus |
| Entri kunci tak dibersihkan | Peta tumbuh terus | Hapus entri bila ekornya selesai dan tak ada yang baru |
| Mengira `Isolate.run(...).timeout(...)` menghentikan komputasi | CPU tetap terpakai | `Isolate.spawn` + `kill` |
| Port tak ditutup | Program tak pernah selesai | Tutup di `finally` |
| Restart pekerja tanpa batas | Loop crash dan restart | Batas jumlah dan backoff |
| Mengira isolate adalah sandbox | Kode tak tepercaya berhak penuh atas berkas dan jaringan | Proses OS terpisah, hak minimum (Fase 9) |

### J. Sumber Referensi

- ✔ Paket `stream_transform`: https://pub.dev/documentation/stream\_transform/latest/ · ✔ `debounce`: https://pub.dev/documentation/stream\_transform/latest/stream\_transform/RateLimit/debounce.html · ✔ `throttle`: https://pub.dev/documentation/stream\_transform/latest/stream\_transform/RateLimit/throttle.html
- `StreamTransformer.fromHandlers`: https://api.dart.dev/stable/dart-async/StreamTransformer/StreamTransformer.fromHandlers.html
- Lint: https://dart.dev/tools/linter-rules/cancel\_subscriptions · https://dart.dev/tools/linter-rules/close\_sinks
- ✔ Paket `pool`: https://pub.dev/packages/pool · ✔ Concurrency di Dart: https://dart.dev/language/concurrency
- `Isolate.spawn`: https://api.dart.dev/stable/dart-isolate/Isolate/spawn.html · `Isolate.kill`: https://api.dart.dev/stable/dart-isolate/Isolate/kill.html · `RemoteError`: https://api.dart.dev/stable/dart-isolate/RemoteError-class.html
- Deadlock: https://en.wikipedia.org/wiki/Deadlock · Sandbox (konsep): https://en.wikipedia.org/wiki/Sandbox\_(computer\_security)

---

## Latihan Fase 7 (sengaja tanpa kunci jawaban)

Kerjakan sendiri, lalu commit dengan struktur `fase-7/latihan-N/` berisi `README.md` (spesifikasi, tabel contoh, dan **tabel hasil ukur beserta konfigurasinya** bila ada pengukuran), `lib/`, `tool/`, dan `test/`. Ukur di mode yang tepat (AOT, tanpa `--enable-asserts`), dan untuk tes konkurensi lakukan uji mutasi: hapus pengamannya dan pastikan tes gagal.

1. **\[7.1\]** Tulis prediksi urutan keluaran untuk sepuluh potongan kode campuran (`Future`, `scheduleMicrotask`, `await`, `Timer`, `then`), jalankan, lalu jelaskan setiap selisih. Kriteria penerimaan: minimal sembilan dari sepuluh prediksi benar; yang salah punya entri Jurnal Galat berisi akar masalahnya.
2. **\[7.2\]** Ambil tiga sumber data dengan tiga cara (berurutan, `Future.wait`, record `.wait`) dan ukur total waktunya dengan waktu virtual. Buat dua sumber gagal sekaligus dan jelaskan galat mana yang sampai ke pemanggil dan apa yang hilang. Tulis satu contoh `Future` yang tak di-`await` lalu menelan galat, beserta perbaikannya.
3. **\[7.3\]** Implementasikan `denganBatas` yang benar-benar membatalkan kerja (pembatalan kooperatif) dan tunjukkan *kerja zombie* pada versi yang hanya memakai `timeout`. Buktikan dengan tes waktu virtual bahwa kerja berhenti dan tak ada timer tersisa.
4. **\[7.4\]** Buat stream yang membaca log berukuran 1 GB (boleh berkas sintetis), menghitung agregat per jam, dan menulis ringkasan tanpa pernah memuat seluruh berkas. Kriteria penerimaan: memori puncak (`/usr/bin/time -v`) tidak bertambah saat ukuran berkas dilipatgandakan; semua langganan dan controller ditutup (lint `cancel_subscriptions` dan `close_sinks` bersih).
5. **\[7.5\]** Paralelkan konversi batch `konversi_satuan` (jutaan nilai) ke N isolate dan bandingkan dengan versi satu isolate. Kriteria penerimaan: ukur percepatan untuk N = 1, 2, 4, 8 dan jelaskan mengapa kurvanya tidak linear (biaya salin, jumlah inti, tekanan memori); worker yang crash dilaporkan sebagai kegagalan terkendali tanpa menggantungkan program.
6. **\[7.6\]** Tambahkan operasi `pinjam` ke `katalog_perpustakaan` dengan kunci per ISBN (bukan global), batas lima pekerjaan bersamaan, dan timeout dua detik yang benar-benar membatalkan kerja. Kriteria penerimaan: tes dengan 1.000 permintaan acak (seed tetap) pada 10 ISBN tak pernah menghasilkan stok negatif atau pinjaman ganda; permintaan ke ISBN berbeda tetap berjalan paralel (buktikan dengan waktu virtual atau pengukuran).
7. **\[7.7\]** Untuk `Antrean` (7.8) dan `KunciPerKunci` (7.9), tulis tes dengan gerbang yang menelusuri semua permutasi urutan selesai tiga operasi. Lakukan uji mutasi pada keduanya dan catat hasilnya di `README.md`.
8. **\[7.8\]** Tambahkan nomor urut ke dalam berkas To-Do, dan buat pembaca menolak berkas yang lebih lama dari yang pernah ia lihat; gantikan pagar generasi dengan mekanisme ini. Uji dengan dua penulis bersamaan dan satu penulisan yang sengaja ditahan sampai penulisan berikutnya selesai. Lalu ukur `bersihkan` inline vs isolate untuk beberapa ukuran data dan tentukan ambang dari hasilnya.
9. **\[7.9\]** Tulis `debounce` sendiri dengan `Timer` dan tes waktu virtual yang menyamai perilaku `stream_transform`. Lalu bangun supervisor yang memulai ulang pekerja yang crash paling banyak tiga kali dengan backoff, melaporkan kegagalan terkendali sesudahnya, dan menutup semua port. Buktikan bahwa tak ada program yang menggantung.

---

## Ringkasan Fase 7 & Daftar Periksa Kelulusan

| Modul | Satu kalimat inti |
| --- | --- |
| 7.1 | Satu isolate punya satu thread dan satu event loop; kode sinkron berjalan dulu, lalu microtask dikuras, baru event berikutnya. |
| 7.2 | `async`/`await` mengatur urutan, bukan paralelisme; pilih berurutan atau konkuren dengan sadar, dan jangan biarkan `Future` dan galatnya tak diawasi. |
| 7.3 | Timeout bukan pembatalan; pembatalan sungguhan butuh kerja sama, dan galat tak tertangani butuh satu penjaga terakhir. |
| 7.4 | Stream adalah aliran yang punya siklus hidup dan *backpressure*; tarik sesuai kemampuan, dan lepas langganan serta controller. |
| 7.5 | Isolate memberi paralelisme tanpa memori bersama; harganya salinan dan pesan, jadi kirim sesedikit mungkin. |
| 7.6 | Setiap `await` adalah tempat dunia boleh masuk; cek dan tindak harus tak terpisahkan lewat antrean, kunci, atau batas konkurensi. |
| 7.7 | Tes asinkron yang baik mengendalikan waktu dan urutan sendiri, dan dibuktikan lewat uji mutasi. |
| 7.8 | Asinkron menyentuh tepi, bukan inti; serialisasi, penulisan idempoten, pagar, dan isolate yang hemat kiriman membuat penyimpanan tangguh. |
| 7.9 | Operator pembatas laju, kunci per sumber daya, dan pengawasan isolate membuat konkurensi terlihat dan terkendali; isolate bukan sandbox. |

**Daftar periksa kelulusan** (jawab tanpa membuka dokumen):

- [ ] Aku bisa memprediksi urutan keluaran campuran kode sinkron, microtask, `Future`, dan `Timer`, dan menjelaskan alasannya.
- [ ] Aku bisa menjelaskan mengapa kode sinkron yang berat membekukan seluruh isolate.
- [ ] Aku bisa memilih antara berurutan dan konkuren (`Future.wait`, record `.wait`) dan menjelaskan apa yang terjadi pada galat.
- [ ] Aku bisa menjelaskan mengapa timeout bukan pembatalan dan merancang pembatalan kooperatif.
- [ ] Aku bisa menulis stream dengan `async*`, mengelola langganan dan controller, dan menjelaskan *backpressure*.
- [ ] Aku bisa memproses berkas sangat besar sebagai stream tanpa memuat seluruhnya.
- [ ] Aku bisa menunjukkan balapan cek-lalu-tindak pada titik `await` dan memperbaikinya dengan antrean atau kunci per sumber daya.
- [ ] Aku bisa memilih antara `Isolate.run`, kolam slot, dan pekerja berumur panjang, dan menjelaskan biaya salinan.
- [ ] Aku bisa mengawasi isolate (`onError`, `onExit`), menghentikannya sungguhan, dan menjelaskan mengapa isolate bukan sandbox.
- [ ] Aku bisa menguji kode asinkron secara deterministik (`fakeAsync`, gerbang, matcher stream) dan melakukan uji mutasi.
- [ ] Aku bisa menjelaskan mengapa penulisan idempoten dan pagar dibutuhkan setelah timeout.
- [ ] Sembilan latihan sudah di-commit dengan tabel hasil ukur beserta konfigurasinya.

**Pratinjau fase berikutnya (penomoran perlu dikonfirmasi).** Kurikulum menempatkan *Keamanan, Isolasi & Anonimitas* tepat setelah Asinkron dan Performa: pemodelan ancaman, validasi di batas, dan serangan logika umum; kriptografi aman dan penanganan rahasia; rantai pasok, isolasi proses, dan anonimitas. Modul 5.8 dan beberapa modul Fase 7 sudah merujuknya sebagai **Fase 9**, tetapi tidak ada Fase 8 yang terdefinisi pada berkas yang tersedia. Kandidat pengisi Fase 8 adalah Modul 2.2 dan 2.3 kurikulum (rekursi, iterasi, dan pemrograman dinamis; graf, pencarian, dan penjadwalan) bila ternyata belum tercakup di Fase 1–4. Tetapkan dulu pilihannya sebelum fase berikutnya dibuat. Prasyaratnya adalah daftar periksa di atas terpenuhi.

---

## Referensi Induk Fase 7

> **Catatan verifikasi.** Tanda ✔ berarti halaman tersebut dibuka dan diverifikasi lewat pencarian atau pengambilan halaman saat bagian terkait disusun (Modul 7.1–7.6: 15–16 November 2026; Modul 7.7–7.9: 18 November 2026). Tautan tanpa tanda adalah halaman resmi atau baku yang stabil, tetapi belum diverifikasi ulang; bila ada yang berpindah, cari judulnya di dart.dev, pub.dev, atau dokumentasi API. **Kode di Modul 7.7–7.9 belum dijalankan di lingkungan penyusun** (tanpa Dart SDK): jalankan `dart analyze` dan `dart test`, lalu laporkan setiap selisih agar bisa diperbaiki.

**Dokumentasi resmi Dart dan paket**

- ✔ Concurrency di Dart: https://dart.dev/language/concurrency · Asynchronous programming (codelab): https://dart.dev/codelabs/async-await · Futures dan penanganan galat: https://dart.dev/libraries/async/futures-error-handling
- Menggunakan stream: https://dart.dev/libraries/async/using-streams · Membuat stream: https://dart.dev/libraries/async/creating-streams · ✔ Concurrency dan isolate (Flutter docs): https://docs.flutter.dev/perf/isolates · Pengujian: https://dart.dev/tools/testing
- ✔ Rilis Dart 3.14 (11 November 2026): https://dart.dev/blog/announcing-dart-3-14 · ✔ Ringkasan rilis dart.dev: https://dart.dev/guides/whats-new
- API `dart:async`: https://api.dart.dev/stable/dart-async/dart-async-library.html · https://api.dart.dev/stable/dart-async/Future-class.html · https://api.dart.dev/stable/dart-async/Completer-class.html · https://api.dart.dev/stable/dart-async/Future/timeout.html · https://api.dart.dev/stable/dart-async/TimeoutException-class.html · https://api.dart.dev/stable/dart-async/runZonedGuarded.html · https://api.dart.dev/stable/dart-async/Stream-class.html · https://api.dart.dev/stable/dart-async/StreamController-class.html · https://api.dart.dev/stable/dart-async/StreamSubscription-class.html · https://api.dart.dev/stable/dart-async/StreamTransformer/StreamTransformer.fromHandlers.html
- API `dart:isolate`: https://api.dart.dev/stable/dart-isolate/Isolate-class.html · https://api.dart.dev/stable/dart-isolate/Isolate/run.html · https://api.dart.dev/stable/dart-isolate/Isolate/spawn.html · https://api.dart.dev/stable/dart-isolate/Isolate/kill.html · https://api.dart.dev/stable/dart-isolate/TransferableTypedData-class.html · https://api.dart.dev/stable/dart-isolate/RemoteError-class.html
- `dart:io` dan `dart:convert`: https://api.dart.dev/stable/dart-io/File-class.html · https://api.dart.dev/stable/dart-io/File/openRead.html · https://api.dart.dev/stable/dart-io/File/rename.html · https://api.dart.dev/stable/dart-convert/LineSplitter-class.html
- Lint: https://dart.dev/tools/linter-rules/unawaited\_futures · https://dart.dev/tools/linter-rules/cancel\_subscriptions · https://dart.dev/tools/linter-rules/close\_sinks
- Paket: ✔ https://pub.dev/packages/pool · ✔ https://pub.dev/packages/async · ✔ https://pub.dev/packages/fake\_async/changelog · ✔ https://pub.dev/documentation/stream\_transform/latest/ · https://pub.dev/packages/clock · https://pub.dev/packages/test

**Konsep dan teori**

- Event loop: https://en.wikipedia.org/wiki/Event\_loop · Concurrency vs parallelism: https://en.wikipedia.org/wiki/Concurrent\_computing · Actor model: https://en.wikipedia.org/wiki/Actor\_model
- Race condition: https://en.wikipedia.org/wiki/Race\_condition · Optimistic concurrency control: https://en.wikipedia.org/wiki/Optimistic\_concurrency\_control · Lock/mutex: https://en.wikipedia.org/wiki/Lock\_(computer\_science) · Deadlock: https://en.wikipedia.org/wiki/Deadlock
- Idempotence: https://en.wikipedia.org/wiki/Idempotence · Sandbox (keamanan): https://en.wikipedia.org/wiki/Sandbox\_(computer\_security)
- Martin Kleppmann, *How to do distributed locking* (token pagar): https://martin.kleppmann.com/2016/02/08/how-to-do-distributed-locking.html · Martin Fowler, *Eradicating Non-Determinism in Tests*: https://martinfowler.com/articles/nonDeterminism.html
- Amazon Builders' Library, *Timeouts, retries, and backoff with jitter*: https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/

**Buku bacaan lanjutan (tanpa tautan)**

- B. Goetz dkk., *Java Concurrency in Practice* — model mental tentang balapan, atomisitas, dan pembatasan konkurensi yang berlaku lintas bahasa.
- P. Butcher, *Seven Concurrency Models in Seven Weeks* — perbandingan thread, aktor, dan model lain.
- M. Kleppmann, *Designing Data-Intensive Applications* — konsistensi, idempotensi, dan pagar pada sistem terdistribusi.
- M. Nygard, *Release It!* — pola ketahanan: timeout, bulkhead, circuit breaker.

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

