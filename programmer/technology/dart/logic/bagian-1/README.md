# Membangun Logika Dart — Fase 1: Fondasi Berpikir Logis

*Dari masalah mentah menjadi program yang benar, aman, dan hemat sumber daya.*

| Atribut | Keterangan |
| --- | --- |
| Level | Foundation — pemula dalam *logika*, bukan dalam sintaks |
| Estimasi waktu | 2–3 minggu, ±25–35 jam (teori ±30%, praktik ±70%) |
| Prasyarat | Dart dasar, OOP, dan fitur lanjutan sudah dikuasai — tidak diulang di sini |
| Alat esensial | Dart SDK stabil (rilis stabil per November 2026: 3.13.x; semua kode di dokumen ini berjalan di Dart ≥ 3.0), terminal, editor pilihan, DartPad (opsional) |
| Komunitas | https://dart.dev/community, tag `dart` di https://stackoverflow.com/questions/tagged/dart, diskusi di organisasi `dart-lang` pada GitHub |
| Sertifikasi | Tidak ada sertifikasi resmi khusus logika Dart; portofolio repositori GitHub dengan catatan yang teruji jauh lebih bernilai |

**Hasil pembelajaran Fase 1** — setelah fase ini kamu mampu:

1. mengubah kalimat masalah menjadi spesifikasi (input, output, batasan, kasus tepi) *sebelum* menulis kode;
2. menelusuri (trace) program secara manual dengan tabel state;
3. menulis dan menyederhanakan kondisi boolean dengan benar, termasuk memahami short-circuit dan presedensi;
4. menegakkan kontrak (precondition, postcondition, invarian) dengan alat Dart yang tepat;
5. memilih struktur sequence/selection/iteration yang paling aman dan jelas, serta memeriksa loop dengan invarian;
6. menjalankan siklus run → error → debug → test secara disiplin dari terminal.

---

## Daftar Isi Fase 1


<details>
  <summary>📃 Fase 1</summary>

- **0. Audit Kurikulum & Peta Fase**
- **1.1 Anatomi Masalah:** dari kalimat ke spesifikasi
- **1.2 Model Mental Komputasi:** state, ekspresi, statement, efek samping
- **1.3 Alat Berpikir:** dekomposisi, abstraksi, pseudocode, trace table
- **1.4 Logika Boolean & Predikat:** tabel kebenaran, De Morgan, short-circuit, presedensi
- **1.5 Kontrak Program:** precondition, postcondition, invarian, `assert` vs error
- **1.6 Tiga Struktur Kendali:** sequence, selection, iteration, invarian loop
- **1.7 Siklus Run–Error–Debug** *(TAMBAHAN)*
- **1.8 Studi Kasus Terpadu: Tarif Parkir** *(TAMBAHAN)*
- **Latihan (tanpa kunci jawaban), Ringkasan, dan Referensi Induk**

</details>


---

## 0. Audit Kurikulum & Peta Fase

**Temuan audit**

1. **Teks kurikulum tidak terbaca.** File yang diunggah hanya berisi instruksi dan persona, tanpa daftar fase/modul. Karena itu peta fase di bawah adalah **usulan kerangka** yang diturunkan dari tujuanmu: logika yang aman, kuat, cepat, logis, hemat resource, best-practice, fleksibel, dinamis maupun statis, dan sadar akan dampak tiap pilihan desain. Jika kurikulum aslimu berbeda, tempel daftarnya dan saya sinkronkan penomoran serta urutannya.
2. **Potensi lompatan.** Kurikulum logika sering langsung melompat ke algoritma dan struktur data. Tanpa *bahasa spesifikasi* (kontrak, invarian, tabel contoh), pembelajar menulis kode yang benar-secara-kebetulan. Maka Fase 1 diperkuat modul 1.1 dan 1.5 sebagai fondasi.
3. **TAMBAHAN (di luar daftar lazim):** modul 1.7 (siklus run–error–debug) dan 1.8 (studi kasus terpadu + latihan). Alasannya: logika yang tidak pernah dijalankan, diamati, dan diperbaiki hanyalah teori.
4. **Prasyarat tidak diulang, tetapi dipakai.** Sintaks `if`, `for`, class, dan generics diasumsikan sudah kamu kuasai; yang dibahas di sini adalah *cara berpikir* di balik pemakaiannya.

**Peta fase usulan**

| Fase | Tema | Pertanyaan inti |
| --- | --- | --- |
| 1 | Fondasi Berpikir Logis | Bagaimana mengubah masalah menjadi program yang terbukti benar? |
| 2 | Logika Ekspresi & Aliran Kendali Aman | Bagaimana kondisi, pattern matching, dan null safety dipakai tanpa celah? |
| 3 | Pemodelan Data & State | Bagaimana membuat keadaan ilegal tidak mungkin direpresentasikan? |
| 4 | Logika di Dalam Fungsi & Class | Di mana logika diletakkan, dan dengan berapa cara ia dipanggil? |
| 5 | Logika Kegagalan & Ketahanan | Bagaimana gagal dengan aman dan pulih dengan benar? |
| 6 | Logika Efisiensi | Bagaimana mengukur dan menekan waktu, memori, dan alokasi? |
| 7 | Logika Asinkron & Konkurensi | Bagaimana bernalar tentang event loop, Future, Stream, dan isolate? |
| 8 | Logika Statis vs Dinamis | Kapan memakai tipe statis, kapan fleksibilitas dinamis, dan apa dampaknya? |
| 9 | Logika Keamanan | Bagaimana memperlakukan input sebagai musuh sampai terbukti sebaliknya? |
| 10 | Verifikasi | Bagaimana test, property-based test, fuzzing, dan benchmark membuktikan klaim? |
| 11 | Arsitektur & Enterprise | Bagaimana logika disusun menjadi modul yang terisolasi dan dapat dirawat? |

> **Cara memakai dokumen ini.** Untuk setiap modul: baca, tutup dokumen, tulis ulang kodenya dari ingatan, jalankan, lalu bandingkan. Latihan di akhir sengaja **tanpa kunci jawaban** — tulis solusimu sendiri, jalankan, dan simpan di repositori untuk ditinjau.

---

## 1.1 Anatomi Masalah: Dari Kalimat ke Spesifikasi

*Motivasi: pemrogram hebat bukan yang mengetik tercepat, melainkan yang paling dulu memahami masalahnya.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini mencakup cara membaca sebuah masalah, menemukan ambiguitasnya, menuliskannya sebagai **spesifikasi** (input, output, batasan, definisi benar), lalu membuat **tabel contoh** termasuk kasus tepi. Ini penting karena sebagian besar bug logika lahir *sebelum* baris kode pertama: dari asumsi yang tidak pernah ditulis. Seluruh fase berikutnya bertumpu pada spesifikasi: kontrak (1.5), test (Fase 10), dan keamanan input (Fase 9) semuanya hanyalah spesifikasi yang ditegakkan.

### B. Konsep Kunci & Filosofi Mendalam

- **Masalah bukan spesifikasi.** Masalah: *tentukan apakah suatu tahun kabisat*. Spesifikasi: tipe dan rentang input yang sah, bentuk output, aturan transformasi yang tepat, serta perilaku pada input aneh (nol, negatif, sangat besar).
- **Lima pertanyaan wajib** sebelum menulis kode: (1) apa input dan rentang sahnya? (2) apa output dan tipenya? (3) apa aturan transformasinya, persisnya? (4) apa yang terjadi di batas dan pada input tak sah? (5) bagaimana saya tahu hasilnya benar (*oracle*)?
- **Kasus tepi** adalah tempat bug berkumpul: kosong, satu elemen, tepat di batas, satu di luar batas, duplikat, nol, negatif, ekstrem besar.
- **Partisi ekuivalensi + nilai batas.** Bagi domain input menjadi kelas yang berperilaku sama, lalu uji satu wakil tiap kelas *dan* nilai di perbatasan antarkelas.
- **Filosofi:** spesifikasi adalah kode tanpa ambiguitas yang dibaca manusia; kode adalah spesifikasi yang dieksekusi mesin. Jika keduanya tak bisa dicocokkan, salah satunya salah.
- **Dampak desain:** ketidakjelasan spesifikasi memaksa keputusan tersirat. Rata-rata dari list kosong: 0, NaN, atau error? Keputusan yang tak ditulis hari ini adalah celah ketahanan dan keamanan besok.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Studi kasus: tahun kabisat.**

*Langkah 1 — tabel spesifikasi:*

| Aspek | Keputusan |
| --- | --- |
| Input | `int tahun` |
| Domain sah | `tahun >= 1` (tahun proleptik: kalender Gregorian diperluas mundur). Penegakannya ditunda ke modul 1.5 |
| Output | `bool` — `true` jika kabisat |
| Aturan | habis dibagi 4, **kecuali** habis dibagi 100, **kecuali** habis dibagi 400 |
| Oracle | tabel contoh di bawah |

*Langkah 2 — tabel contoh (termasuk kasus tepi):*

| tahun | hasil | alasan |
| --- | --- | --- |
| 2000 | ya | habis dibagi 400 |
| 1900 | tidak | habis dibagi 100, bukan 400 |
| 2024 | ya | habis dibagi 4, bukan 100 |
| 2023 | tidak | tidak habis dibagi 4 |
| 2100 | tidak | habis dibagi 100, bukan 400 |

*Langkah 3 — kode:*

```dart
/// Menentukan apakah [tahun] adalah tahun kabisat kalender Gregorian.
///
/// Aturan: habis dibagi 4, KECUALI habis dibagi 100, KECUALI habis dibagi 400.
/// Domain: [tahun] >= 1 (belum ditegakkan; lihat modul 1.5).
bool kabisat(int tahun) {
  return (tahun % 4 == 0 && tahun % 100 != 0) || tahun % 400 == 0;
}

void main() {
  // Tabel contoh = spesifikasi yang dapat dieksekusi.
  assert(kabisat(2000)); // habis dibagi 400            -> ya
  assert(!kabisat(1900)); // habis dibagi 100, bukan 400 -> tidak
  assert(kabisat(2024)); // habis dibagi 4, bukan 100   -> ya
  assert(!kabisat(2023)); // tidak habis dibagi 4        -> tidak
  assert(!kabisat(2100)); // habis dibagi 100, bukan 400 -> tidak
  print('Semua contoh lolos.');
}
```

*Langkah 4 — jalankan (assert harus diaktifkan secara eksplisit):*

```bash
dart run --enable-asserts bin/kabisat.dart
```

**Bedah kode kata demi kata**

- `///` — komentar dokumentasi; dibaca editor (tooltip) dan `dart doc`. Tulis spesifikasi di sini.
- `[tahun]` — dalam komentar dokumentasi, kurung siku menautkan ke identifier.
- `bool` — tipe kembalian: hanya `true` atau `false`.
- `int tahun` — satu parameter posisional bertipe bilangan bulat.
- `%` — operator modulo: sisa pembagian. `tahun % 4 == 0` berarti *habis dibagi 4*.
- `&&` — AND dengan short-circuit; `||` — OR dengan short-circuit. Tanda kurung membuat urutan evaluasi eksplisit.
- `assert(kondisi)` — jika `kondisi` false, melempar `AssertionError`. **Hanya aktif jika diaktifkan** (`--enable-asserts`); tanpa flag itu ia diam. Ini jebakan umum.
- `!kabisat(1900)` — `!` menegasikan hasil pemanggilan.
- `main` — titik masuk program; `print` menulis ke stdout.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Opsi 1 — trik DateTime: hari ke-0 bulan Maret = hari terakhir Februari.
bool kabisatDateTime(int tahun) => DateTime(tahun, 3, 0).day == 29;

// Opsi 2 — switch expression dengan record pattern: urutan keputusan eksplisit.
bool kabisatPola(int tahun) => switch ((tahun % 400, tahun % 100, tahun % 4)) {
      (0, _, _) => true, // kelipatan 400 -> kabisat
      (_, 0, _) => false, // kelipatan 100 (bukan 400) -> bukan
      (_, _, 0) => true, // kelipatan 4 (bukan 100) -> kabisat
      _ => false,
    };
```

| Opsi | Kelebihan | Kekurangan / dampak |
| --- | --- | --- |
| Ekspresi boolean (utama) | Paling ringkas, tanpa alokasi, mudah diaudit | Presedensi harus dijaga dengan tanda kurung |
| `DateTime` | Satu baris | Bergantung pada normalisasi tanggal; maksudnya tidak terbaca; domain tak tervalidasi |
| `switch` + record | Urutan aturan terbaca seperti spesifikasi | Sedikit lebih panjang; membentuk record sementara |

### E. Terminologi Esensial

- **Spesifikasi** — deskripsi presisi tentang apa yang harus dilakukan program (bukan *bagaimana*).
- **Domain input** — himpunan semua input yang sah.
- **Kasus tepi (edge case)** — input di ujung atau di luar kewajaran: kosong, nol, batas.
- **Nilai batas** — nilai tepat di perbatasan antarkelas perilaku (mis. 15 dan 16 menit pada tarif gratis).
- **Partisi ekuivalensi** — pengelompokan input yang diperlakukan sama oleh logika.
- **Oracle** — sumber kebenaran pembanding: tabel contoh, implementasi referensi, atau aturan resmi.
- **Asumsi tersirat** — keputusan yang dibuat tanpa ditulis; sumber utama bug.
- **Proleptik** — memperluas aturan kalender ke masa sebelum aturan itu berlaku.

### F. Visualisasi (ASCII)

```text
 Kalimat masalah
       │
       ▼
┌──────────────────────┐
│ 5 pertanyaan wajib   │  input? output? aturan? batas? oracle?
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│ Spesifikasi tertulis │  tabel + doc comment
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│ Tabel contoh + tepi  │  = test yang belum dieksekusi
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│ Kode                 │
└──────────┬───────────┘
           ▼
┌──────────────────────┐      gagal
│ Cocokkan dengan tabel│ ───────────► perbaiki KODE atau SPESIFIKASI
└──────────────────────┘
```

### G. Hubungan dengan Modul Lain

- **Prasyarat bagi:** semua modul. Tanpa spesifikasi, modul berikutnya tidak punya acuan benar/salah.
- **1.5** menegakkan batasan domain di kode; **1.8** memakai alur ini penuh; **Fase 9** memperlakukan domain sebagai batas kepercayaan; **Fase 10** mengotomatiskan tabel contoh menjadi test dan property-based test.

### H. Tips & Praktik Terbaik

- Tulis tabel contoh *sebelum* kode; jika tak bisa menulis contohnya, kamu belum memahami masalahnya.
- Simpan pertanyaan yang belum terjawab sebagai komentar `// TODO(spesifikasi): ...` — jangan ditebak diam-diam.
- Pakai kata ukur (`>= 1`, `<= 24 jam`), bukan kata kira-kira (`sekitar`, `biasanya`).
- Satu fungsi, satu spesifikasi. Jika spesifikasinya memuat kata *dan juga*, pecah fungsinya (lihat 1.3).

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Langsung mengetik kode | Banyak revisi, bug di kasus tepi | Wajib tulis lima pertanyaan + tabel contoh dulu |
| Mengabaikan input kosong/nol | Crash atau NaN di produksi | Selalu isi baris *kosong/nol/negatif* di tabel |
| Hanya menguji contoh "normal" | Lolos di mesinmu, gagal di pengguna | Uji nilai batas dan satu di luarnya |
| Menyimpulkan `assert` lolos padahal belum aktif | Tidak ada pesan apa pun | Jalankan dengan `--enable-asserts` dan pastikan ada contoh yang sengaja gagal |

### J. Sumber Referensi

- ✔ Dokumen Dart tentang error dan `assert`: https://dart.dev/language/error-handling
- ✔ Operator (modulo, logika, presedensi): https://dart.dev/language/operators
- Panduan dokumentasi kode: https://dart.dev/effective-dart/documentation
- API `DateTime`: https://api.dart.dev/stable/dart-core/DateTime-class.html
- Tahun kabisat (aturan Gregorian): https://en.wikipedia.org/wiki/Leap\_year
- Pólya, *How to Solve It*: https://en.wikipedia.org/wiki/How\_to\_Solve\_It

---

## 1.2 Model Mental Komputasi: State, Ekspresi, Statement, dan Efek Samping

*Motivasi: ketika kamu bisa melihat state berubah di kepalamu, bug kehilangan tempat bersembunyi.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membangun model mental yang dipakai di seluruh kurikulum: program adalah rangkaian **perubahan state**. Kamu belajar membedakan **ekspresi** (menghasilkan nilai) dari **statement** (melakukan aksi), mengenali **efek samping**, memahami **determinisme** dan **kemurnian** fungsi, serta **aliasing** (dua nama untuk satu objek). Tanpa model ini, bug misterius — hasil berbeda tiap dijalankan, list yang berubah sendiri — tidak bisa dinalar, hanya ditebak.

### B. Konsep Kunci & Filosofi Mendalam

- **State** adalah kumpulan nilai semua variabel (dan objek yang mereka tunjuk) pada satu saat. Bayangkan foto papan tulis setelah setiap langkah.
- **Transisi.** Tiap statement mengubah foto itu. Program adalah film dari foto-foto tersebut. Menelusuri program berarti menggambar ulang fotonya (modul 1.3).
- **Ekspresi vs statement.** Ekspresi punya nilai: `a + b`, `x ? y : z`, ekspresi `switch`, bahkan `throw`. Statement melakukan sesuatu: `if`, `for`, `return`. Di Dart, penugasan `x = 5` adalah ekspresi yang bernilai 5.
- **Efek samping:** apa pun yang terlihat di luar fungsi — mengubah variabel luar atau argumen, mencetak, membaca file, membaca jam, mengambil angka acak.
- **Determinisme:** input sama menghasilkan output sama. Penyebab nondeterminisme: waktu, acak, I/O, dan urutan eksekusi konkuren.
- **Fungsi murni:** deterministik *dan* tanpa efek samping. Hasilnya mudah dites, di-cache (memoization, Fase 6), dan dijalankan paralel (Fase 7).
- **`final` bukan imutabel.** `final` mengunci *variabel* agar tak bisa di-assign ulang; isi objek yang ditunjuknya tetap bisa berubah. `const` menghasilkan konstanta waktu-kompilasi yang sungguh imutabel.
- **Aliasing:** `b = a` pada objek tidak menyalin objek; keduanya menunjuk satu objek yang sama.
- **Filosofi — functional core, imperative shell:** simpan logika inti dalam fungsi murni, dan dorong efek samping (waktu, I/O, acak) ke lapisan tipis di tepi.
- **Dampak desain:** efek samping yang tersembunyi melahirkan test yang kadang lolos kadang gagal (*flaky*) dan bug yang tak bisa direproduksi.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — state berubah langkah demi langkah.**

```dart
void main() {
  var saldo = 100000; // S0: saldo = 100000
  final biaya = 2500; // S1: + biaya = 2500 (tak bisa di-assign ulang)
  saldo = saldo - biaya; // S2: saldo = 97500
  saldo -= biaya; // S3: saldo = 95000
  print(saldo); // efek samping: menulis 95000 ke stdout
}
```

- `var saldo = 100000;` — deklarasi variabel yang boleh diubah; tipenya disimpulkan `int`.
- `final biaya = 2500;` — variabel yang hanya boleh diisi sekali.
- `saldo = saldo - biaya;` — hitung ruas kanan (ekspresi) lalu simpan ke `saldo` (transisi state).
- `saldo -= biaya;` — singkatan dari `saldo = saldo - biaya`.
- `print(saldo);` — satu-satunya efek samping yang terlihat dari luar program.

**Contoh 2 — aliasing.**

```dart
void main() {
  final a = [1, 2];
  final b = a; // b dan a menunjuk objek list YANG SAMA
  b.add(3);
  print(a); // [1, 2, 3]
  final c = [...a]; // salinan dangkal: objek list BARU
  c.add(4);
  print(a); // [1, 2, 3]  (tidak berubah)
  print(c); // [1, 2, 3, 4]
}
```

- `final b = a;` — menyalin *referensi*, bukan isi. Perhatikan: `final` tidak mencegah `b.add(3)`.
- `[...a]` — operator spread membuat list baru berisi elemen `a` (salinan dangkal).
- Elemen-elemen *di dalam* salinan dangkal tetap dibagi jika berupa objek mutabel.

**Contoh 3 — murni vs tidak murni, dengan injeksi waktu.**

```dart
// Murni: hasil hanya bergantung pada argumen.
String sapaan(int jam) => switch (jam) {
      >= 5 && < 11 => 'Selamat pagi',
      >= 11 && < 15 => 'Selamat siang',
      >= 15 && < 18 => 'Selamat sore',
      _ => 'Selamat malam',
    };

// Tidak murni: membaca jam sistem (input tersembunyi) dan mencetak (efek samping).
void sapaSekarang() => print(sapaan(DateTime.now().hour));

void main() {
  assert(sapaan(5) == 'Selamat pagi');
  assert(sapaan(10) == 'Selamat pagi');
  assert(sapaan(11) == 'Selamat siang');
  assert(sapaan(15) == 'Selamat sore');
  assert(sapaan(18) == 'Selamat malam');
  assert(sapaan(4) == 'Selamat malam');
  sapaSekarang();
}
```

- `switch (jam) { ... }` sebagai **ekspresi**: setiap cabang berbentuk `pola => nilai`, dipisah koma.
- `>= 5 && < 11` — pola relasional digabung dengan AND: jam dari 5 sampai sebelum 11.
- `_` — wildcard: cabang penampung sisanya, sehingga switch lengkap (exhaustive).
- `DateTime.now()` — *input tersembunyi*: hasilnya berbeda tiap dipanggil, sehingga `sapaSekarang` tidak bisa dites secara deterministik. Karena itu logikanya dipisah ke `sapaan(int)` yang murni.

### D. Opsi Kode Lain untuk Logika yang Sama

Menjumlahkan list dengan tiga gaya:

```dart
void main() {
  final data = [3, 1, 4, 1, 5];

  // 1) Imperatif: akumulator yang dimutasi.
  var total = 0;
  for (final x in data) {
    total += x;
  }

  // 2) Deklaratif: fold dengan nilai awal eksplisit; aman untuk list kosong.
  final total2 = data.fold<int>(0, (acc, x) => acc + x);

  // 3) reduce: tanpa nilai awal; MELEMPAR StateError jika list kosong.
  final total3 = data.reduce((a, b) => a + b);

  print('$total $total2 $total3'); // 14 14 14
}
```

| Opsi | Kapan dipilih | Dampak |
| --- | --- | --- |
| `for` + akumulator | Logika bercabang di dalam loop, butuh `break`/`continue` | Paling fleksibel; ada state termutasi |
| `fold` | Mengurangi koleksi ke satu nilai, input mungkin kosong | Aman untuk kosong; closure per elemen |
| `reduce` | Koleksi dijamin tidak kosong | Melempar error saat kosong — pastikan kontraknya |

### E. Terminologi Esensial

- **State** — nilai-nilai yang tersimpan pada suatu saat. **Transisi** — perubahan dari satu state ke state berikutnya.
- **Ekspresi** — potongan kode yang menghasilkan nilai. **Statement** — potongan kode yang melakukan aksi.
- **Efek samping** — perubahan yang terlihat di luar fungsi. **Determinisme** — input sama, output sama.
- **Murni (pure)** — deterministik dan tanpa efek samping. **Referential transparency** — pemanggilan fungsi bisa diganti hasilnya tanpa mengubah perilaku program.
- **Aliasing** — beberapa nama menunjuk objek yang sama. **Salinan dangkal** — menyalin wadah, bukan objek di dalamnya.
- **Mutasi** — mengubah isi objek atau variabel yang sudah ada.

### F. Visualisasi (ASCII)

```text
final a = [1, 2];  final b = a;

  a ──┐
      ├──►  [ 1, 2 ]        satu objek di heap, dua nama
  b ──┘

b.add(3);  final c = [...a];

  a ──┐
      ├──►  [ 1, 2, 3 ]
  b ──┘
  c ─────►  [ 1, 2, 3 ]      objek lain (salinan dangkal)
```

```text
┌──────────────┐   ┌──────────────┐
│  INTI MURNI  │◄──│ TEPI IMPURE  │
│ sapaan(jam)  │   │ DateTime.now │
│ hitung(...)  │──►│ print / file │
└──────────────┘   └──────────────┘
  mudah dites        tipis & sedikit
```

### G. Hubungan dengan Modul Lain

- **Prasyarat bagi:** 1.3 (trace table menggambar state), 1.5 (invarian adalah pernyataan tentang state).
- **Dipakai lagi di:** Fase 3 (imutabilitas dan view vs snapshot pada koleksi), Fase 4 (method sebagai transisi state objek), Fase 6 (kemurnian memungkinkan memoization), Fase 7 (shared mutable state adalah akar race condition).

### H. Tips & Praktik Terbaik

- Default ke `final`; pakai `var` hanya bila variabel memang harus berubah.
- Jangan mengubah list/map yang diterima sebagai argumen kecuali kontrak fungsinya menyatakannya; kembalikan salinan baru.
- Pisahkan *menghitung* dari *melakukan*: fungsi yang menghitung mengembalikan nilai, fungsi di tepi yang mencetak/menyimpan.
- Suntikkan sumber ketidakpastian (waktu, acak) sebagai parameter agar logika bisa dites.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mengira `final` = imutabel | List tetap berubah padahal `final` | Gunakan `List.unmodifiable`/`const`, atau salin sebelum diubah |
| Aliasing tak sengaja | Mengubah salinan ikut mengubah aslinya | Buat salinan eksplisit (`[...a]`, `Map.of`) |
| Fungsi diam-diam membaca waktu/acak | Test kadang lolos, kadang gagal | Jadikan waktu/acak parameter |
| Mengubah parameter list di dalam fungsi | Pemanggil terkejut datanya berubah | Kembalikan list baru atau dokumentasikan mutasi |

### J. Sumber Referensi

- Variabel, `final`, dan `const`: https://dart.dev/language/variables
- ✔ Panduan penggunaan Effective Dart: https://dart.dev/effective-dart/usage
- Fungsi murni: https://en.wikipedia.org/wiki/Pure\_function
- Referential transparency: https://en.wikipedia.org/wiki/Referential\_transparency
- Gary Bernhardt, *Boundaries* (functional core, imperative shell): https://www.destroyallsoftware.com/talks/boundaries

---

## 1.3 Alat Berpikir: Dekomposisi, Abstraksi, Pseudocode, dan Trace Table

*Motivasi: masalah besar hanyalah masalah kecil yang belum kamu belah.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Empat alat berpikir: **dekomposisi** (membelah masalah), **abstraksi** (menyembunyikan detail di balik nama dan kontrak), **pseudocode** (rencana dalam bahasa netral), dan **trace table** (menjalankan program di atas kertas). Alat-alat ini memungkinkan kamu menemukan bug *sebelum* program dijalankan, dan membuat kode terbaca sebagai cerita yang berurutan. Semua fase berikutnya memakainya setiap kali sebuah algoritma terasa membingungkan.

### B. Konsep Kunci & Filosofi Mendalam

- **Dekomposisi top-down (stepwise refinement).** Mulai dari satu kalimat besar, belah menjadi langkah, belah lagi, sampai tiap bagian kecil dan jelas. Berhenti ketika sebuah bagian dapat ditulis sebagai satu fungsi dengan satu spesifikasi (modul 1.1).
- **Abstraksi.** Nama + kontrak menggantikan detail. Pemanggil cukup tahu *apa* yang dilakukan, bukan *bagaimana*.
- **Kohesi dan kopling.** Kohesi tinggi: satu fungsi, satu tujuan. Kopling rendah: fungsi tidak bergantung pada detail internal fungsi lain.
- **Pseudocode.** Bahasa antara yang bebas sintaks; dipakai untuk memeriksa *logika* terpisah dari urusan bahasa pemrograman. Konvensi: `←` untuk penugasan, kata kunci huruf besar.
- **Trace table.** Kolom = variabel, baris = langkah. Kamu mengeksekusi program sejujur mesin, tanpa melompati langkah.
- **Filosofi:** berpikir sekali di atas kertas itu murah; menemukan kesalahan yang sama di produksi itu mahal.
- **Dampak desain:** fungsi kecil yang murni dapat dites per potong. Namun abstraksi yang prematur menambah lapisan tanpa manfaat; abstraksikan setelah pola benar-benar berulang.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — FPB (algoritma Euclid): pseudocode → trace → kode.**

Spesifikasi: `fpb(a, b)` mengembalikan faktor persekutuan terbesar dari dua bilangan bulat tak negatif. Domain: `a >= 0`, `b >= 0`. Kasus tepi: `fpb(a, 0) = a`, `fpb(0, 0) = 0`.

```text
FUNGSI fpb(a, b):
    SELAMA b ≠ 0:
        sisa ← a mod b
        a ← b
        b ← sisa
    KEMBALIKAN a
```

Trace table untuk `fpb(48, 18)`:

| langkah | a | b | sisa = a % b |
| --- | --- | --- | --- |
| awal | 48 | 18 | — |
| 1 | 18 | 12 | 12 |
| 2 | 12 | 6 | 6 |
| 3 | 6 | 0 | 0 |

Loop berhenti karena `b == 0`; hasil `a = 6`.

```dart
int fpb(int a, int b) {
  while (b != 0) {
    final sisa = a % b;
    a = b;
    b = sisa;
  }
  return a;
}

void main() {
  assert(fpb(48, 18) == 6);
  assert(fpb(7, 0) == 7);
  assert(fpb(0, 0) == 0);
  assert(fpb(17, 5) == 1);
  print(fpb(48, 18)); // 6
}
```

- `while (b != 0)` — ulangi selama pembagi belum nol; syarat berhenti dijamin karena `sisa < b` sehingga `b` selalu mengecil.
- `final sisa = a % b;` — sisa pembagian disimpan sementara; `final` karena tidak diubah setelahnya.
- `a = b; b = sisa;` — menggeser pasangan bilangan. Dart mengizinkan parameter di-assign ulang, tetapi menimpa input asli menyulitkan pembacaan; pada fungsi yang lebih panjang, salin ke variabel lokal.
- `return a;` — nilai akhir `a` adalah FPB.

**Contoh 2 — dekomposisi: total bayar belanja.**

```dart
int subtotal(List<int> harga) {
  var jumlah = 0;
  for (final h in harga) {
    jumlah += h;
  }
  return jumlah;
}

int potongan(int nilai, {required int persen}) => nilai * persen ~/ 100;

int pajak(int dasar, {required int persen}) => dasar * persen ~/ 100;

int totalBayar(List<int> harga, {int persenDiskon = 0, int persenPajak = 11}) {
  final sub = subtotal(harga);
  final dasar = sub - potongan(sub, persen: persenDiskon);
  return dasar + pajak(dasar, persen: persenPajak);
}

void main() {
  assert(totalBayar([10000, 20000]) == 33300);
  assert(totalBayar([10000, 20000], persenDiskon: 10) == 29970);
  print(totalBayar([10000, 20000], persenDiskon: 10)); // 29970
}
```

- `{required int persen}` — parameter bernama wajib: pemanggil menulis `persen: 10`, sehingga angka tidak membingungkan.
- `{int persenDiskon = 0, int persenPajak = 11}` — parameter bernama opsional dengan nilai bawaan (11 hanyalah contoh; sesuaikan dengan aturan pajak yang berlaku).
- `nilai * persen ~/ 100` — `*` dan `~/` setingkat dan dievaluasi dari kiri: `(nilai * persen) ~/ 100`. `~/` adalah pembagian bulat yang **memotong** pecahan: itu *keputusan pembulatan* yang harus tertulis di spesifikasi.
- Uang disimpan sebagai `int` (satuan terkecil), bukan `double`, agar bebas galat pecahan biner.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// FPB rekursif: kedalaman rekursi O(log n) pada Euclid, jadi aman di sini.
// Dart tidak melakukan optimasi tail-call; untuk rekursi dalam gunakan loop.
int fpbRekursif(int a, int b) => b == 0 ? a : fpbRekursif(b, a % b);

// FPB bawaan: int.gcd menangani bilangan negatif dan mengembalikan hasil non-negatif.
int fpbBawaan(int a, int b) => a.gcd(b);
```

| Opsi | Kapan dipilih | Dampak |
| --- | --- | --- |
| Loop `while` | Bawaan; tanpa risiko stack | Memutasi parameter lokal |
| Rekursif | Saat definisi matematis rekursif memperjelas maksud | Risiko stack overflow jika kedalaman tak terbatas |
| `int.gcd` | Produksi: tak perlu menulis ulang yang sudah teruji | Tidak mengajarkan algoritmanya |

Untuk *menggambar* rencana: pseudocode cocok untuk logika berurutan; flowchart cocok untuk percabangan padat; trace table cocok untuk memeriksa loop.

### E. Terminologi Esensial

- **Algoritma** — urutan langkah terbatas yang pasti menyelesaikan masalah. **Pseudocode** — penulisan algoritma tanpa terikat sintaks.
- **Dekomposisi** — membelah masalah. **Stepwise refinement** — memperhalus rencana sedikit demi sedikit.
- **Abstraksi** — menyembunyikan detail di balik antarmuka. **Kohesi** — keterkaitan isi satu unit. **Kopling** — keterikatan antarunit.
- **Dry run / trace** — mengeksekusi program secara manual. **Trace table** — tabelnya.
- **Tail call** — pemanggilan fungsi sebagai langkah terakhir; sebagian bahasa mengoptimalkannya, Dart tidak menjaminnya.

### F. Visualisasi (ASCII)

```text
totalBayar
├── subtotal(harga)        → jumlahkan semua harga
├── potongan(sub, persen)  → hitung diskon
└── pajak(dasar, persen)   → hitung pajak atas harga setelah diskon
```

```text
      ┌──────────────┐
      │  mulai       │
      └──────┬───────┘
             ▼
      ┌──────────────┐   tidak   ┌──────────────┐
 ┌───►│  b ≠ 0 ?     ├──────────►│ kembalikan a │
 │    └──────┬───────┘           └──────────────┘
 │           │ ya
 │           ▼
 │    sisa ← a mod b ;  a ← b ;  b ← sisa
 └───────────┘
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 1.1 (tiap fungsi punya spesifikasi) dan 1.2 (trace table menggambar state).
- **Prasyarat bagi:** 1.5 (kontrak per fungsi kecil) dan 1.6 (trace untuk memeriksa invarian loop). Dipakai lagi di Fase 4 (fungsi → method) dan Fase 10 (satu unit test per fungsi kecil).

### H. Tips & Praktik Terbaik

- Tulis pseudocode atau trace sebelum kode untuk setiap loop yang tidak sepele.
- Nama fungsi = kata kerja yang menjelaskan hasil; jika nama sulit dibuat, fungsinya melakukan terlalu banyak hal.
- Tentukan kebijakan pembulatan sebagai keputusan tertulis, bukan efek samping dari `~/`.
- Pakai fungsi pustaka yang sudah teruji (`gcd`, `sort`) di produksi; tulis sendiri hanya untuk belajar atau bila ada alasan terukur.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Menelusuri "di kepala" tanpa menulis | Melewatkan langkah, yakin padahal salah | Selalu gambar tabel; satu baris per iterasi |
| Fungsi mengerjakan banyak hal | Nama berisi "dan", sulit dites | Belah menjadi beberapa fungsi bertujuan tunggal |
| Abstraksi terlalu dini | Banyak lapisan, sedikit makna | Tunggu pola muncul minimal tiga kali |
| Memakai `double` untuk uang | Selisih 0.01 yang misterius | Simpan dalam `int` satuan terkecil |

### J. Sumber Referensi

- Fungsi dan parameter bernama: https://dart.dev/language/functions
- API `int.gcd`: https://api.dart.dev/stable/dart-core/int/gcd.html
- Algoritma Euclid: https://en.wikipedia.org/wiki/Euclidean\_algorithm
- Pseudocode: https://en.wikipedia.org/wiki/Pseudocode
- ✔ Operator `~/` dan presedensi: https://dart.dev/language/operators

---

## 1.4 Logika Boolean & Predikat

*Motivasi: setiap keputusan program hanyalah pertanyaan ya-atau-tidak yang dirumuskan dengan teliti.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini mencakup proposisi dan predikat, operator logika, tabel kebenaran, hukum De Morgan, short-circuit, presedensi, nilai tiga-keadaan (`bool?`), serta seni menamai dan menyederhanakan kondisi. Kondisi yang salah adalah sumber bug logika nomor satu; pada sistem keamanan, satu kondisi otorisasi yang keliru adalah celah.

### B. Konsep Kunci & Filosofi Mendalam

- **Proposisi:** pernyataan yang bernilai benar atau salah. **Predikat:** proposisi yang memuat variabel, mis. `umur >= 17`.
- **Operator:** AND `&&`, OR `||`, NOT `!`, XOR `^`. Tabel kebenaran memetakan semua kombinasi input ke output; untuk *n* variabel ada 2ⁿ baris — cara paling jujur untuk membuktikan dua kondisi setara.
- **Hukum De Morgan:** `!(A && B) == (!A || !B)` dan `!(A || B) == (!A && !B)`. Berguna untuk membalik kondisi tanpa mengubah makna. Hukum lain: absorpsi `A || (A && B) == A`.
- **Short-circuit:** `&&` berhenti pada operand kiri yang `false`; `||` berhenti pada operand kiri yang `true`. Dua akibat penting: (1) *urutan operand penting* — operand kiri bisa menjadi penjaga (cek null sebelum akses); (2) *hemat kerja* — taruh pengecekan murah dan paling sering menentukan di kiri. Pada `bool`, operator `&`, `|`, `^` **tidak** short-circuit.
- **Presedensi (tinggi → rendah):** `!`, relasional (`<  <=  >  >=`), kesamaan (`==  !=`), `&&`, `||`, `??`, `? :`, penugasan. Operator relasional tidak asosiatif: `17 <= x <= 60` adalah galat sintaks.
- **Tiga keadaan:** `bool?` bernilai `true`, `false`, atau `null`. Putuskan secara eksplisit apa arti `null`.
- **Filosofi:** satu kondisi = satu gagasan, dan gagasan itu diberi nama. Kondisi yang bisa dibaca sebagai kalimat bahasa manusia mudah diaudit.
- **Dampak desain:** kondisi bernama menurunkan bug dan mempermudah audit keamanan; urutan operand yang tepat menghemat CPU dan mencegah crash null.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — menghasilkan tabel kebenaran dengan program.**

```dart
String _k(bool v) => v.toString().padRight(7);

void main() {
  print('A      B      A&&B   A||B   A^B');
  for (final a in [false, true]) {
    for (final b in [false, true]) {
      print('${_k(a)}${_k(b)}${_k(a && b)}${_k(a || b)}${a ^ b}');
    }
  }
}
```

```text
A      B      A&&B   A||B   A^B
false  false  false  false  false
false  true   false  true   true
true   false  false  true   true
true   true   true   true   false
```

- `_k` — fungsi pembantu privat (awalan `_`); `padRight(7)` menambahkan spasi agar kolom rapi.
- `for (final a in [false, true])` — dua loop bersarang menghasilkan semua 4 kombinasi.
- `'${...}'` — interpolasi: ekspresi di dalam `${}` dihitung lalu disisipkan ke string.

**Contoh 2 — membuktikan De Morgan secara menyeluruh (exhaustive).**

```dart
void main() {
  for (final a in [false, true]) {
    for (final b in [false, true]) {
      final hukum1 = !(a && b) == (!a || !b);
      final hukum2 = !(a || b) == (!a && !b);
      if (!hukum1 || !hukum2) {
        throw StateError('De Morgan gagal untuk a=$a, b=$b');
      }
    }
  }
  print('De Morgan terbukti untuk semua 4 kombinasi.');
}
```

- `!(a && b) == (!a || !b)` — sisi kiri dan kanan dibandingkan dengan `==`; hasilnya `true` bila setara.
- `throw StateError(...)` — dipakai di sini sebagai penanda bahwa asumsi inti program runtuh (bukan `assert`, agar tetap aktif tanpa flag).

**Contoh 3 — short-circuit dan efek samping.**

```dart
bool mahal() {
  print('  mahal() dipanggil');
  return true;
}

bool murah() {
  print('  murah() dipanggil');
  return false;
}

bool namaValid(String? nama) => nama != null && nama.isNotEmpty;

void main() {
  print('murah() && mahal():');
  final r1 = murah() && mahal(); // mahal() TIDAK dipanggil
  print('  hasil: $r1');

  print('murah() & mahal():');
  final r2 = murah() & mahal(); // operator & TIDAK short-circuit
  print('  hasil: $r2');

  assert(!namaValid(null));
  assert(!namaValid(''));
  assert(namaValid('Ani'));
}
```

- `nama != null && nama.isNotEmpty` — jika `nama` null, bagian kanan tidak pernah dievaluasi, sehingga tidak ada akses ke objek null. Setelah `nama != null`, Dart juga *mempromosikan* tipe `String?` menjadi `String` di sisi kanan.
- Menaruh efek samping (cetak, ubah state) di dalam kondisi membuat perilaku bergantung pada short-circuit; hindari.

**Contoh 4 — memberi nama pada predikat (deny-first).**

```dart
bool bolehDaftar({
  required int umur,
  required bool punyaKtp,
  required bool punyaPaspor,
  required bool masukDaftarHitam,
}) {
  if (masukDaftarHitam) return false; // tolak lebih dulu (fail-safe default)
  final usiaValid = umur >= 17 && umur <= 60;
  final punyaIdentitas = punyaKtp || punyaPaspor;
  return usiaValid && punyaIdentitas;
}
```

- Tiga baris bernama (`usiaValid`, `punyaIdentitas`) menggantikan satu kondisi panjang; tiap baris dapat dites dan dibaca sebagai kalimat.
- Cek penolakan didahulukan: jika ada keraguan, sistem menolak — prinsip *fail-safe defaults*.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Rentang dengan pola relasional (Dart 3):
bool usiaValidPola(int umur) => switch (umur) { >= 17 && <= 60 => true, _ => false };

// Rentang dengan clamp: nilai tetap sama bila sudah berada di dalam rentang.
bool usiaValidClamp(int umur) => umur.clamp(17, 60) == umur;

// Menangani bool? (tiga keadaan):
void contoh(bool? setuju) {
  final a = setuju == true; // null dianggap false
  final b = setuju ?? false; // null dianggap false
  final c = switch (setuju) {
    true => 'ya',
    false => 'tidak',
    null => 'belum menjawab', // wajib ditulis: switch harus lengkap
  };
  print('$a $b $c');
}
```

| Opsi | Kelebihan | Kekurangan |
| --- | --- | --- |
| `x >= a && x <= b` | Paling umum dan jelas | Mengulang `x` dua kali |
| `switch` + pola | Satu pernyataan; mudah menambah rentang lain | Sedikit lebih verbos untuk rentang tunggal |
| `clamp` | Ringkas | Maksud kurang terbaca; hasil bertipe `num` |
| `== true` pada `bool?` | Eksplisit tentang `null` | Hanya pantas untuk `bool?`, bukan `bool` biasa |

### E. Terminologi Esensial

- **Proposisi / predikat** — pernyataan benar-salah / pernyataan berparameter. **Konjungsi** = AND, **disjungsi** = OR, **negasi** = NOT, **XOR** = benar bila tepat satu operand benar.
- **Tautologi** — selalu benar. **Kontradiksi** — selalu salah. **Tabel kebenaran** — daftar semua kombinasi input dan hasilnya.
- **Short-circuit evaluation** — evaluasi dihentikan begitu hasil sudah pasti. **Promosi tipe** — Dart menyempitkan `String?` menjadi `String` setelah pemeriksaan null.
- **Fail-safe default** — bila ragu, tolak; akses diberikan hanya bila dibuktikan sah.

### F. Visualisasi (ASCII)

```text
 a || b && c      dibaca sebagai:  a || (b && c)

        ||
        ├─ a
        └─ &&
           ├─ b
           └─ c
```

```text
 tinggi   !                    (negasi)
    │     <  <=  >  >=        (relasional)
    │     ==  !=              (kesamaan)
    │     &&
    │     ||
    │     ??
    ▼     ? :                  (kondisional)
 rendah   =                    (penugasan)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 1.1 (kondisi adalah aturan dari spesifikasi) dan 1.2 (short-circuit sebagai efek samping yang dikendalikan).
- **Prasyarat bagi:** 1.5 (precondition adalah predikat) dan 1.6 (kondisi loop dan cabang). **Dikembangkan di:** Fase 2 (pattern matching, exhaustiveness, null safety) dan Fase 9 (kondisi otorisasi).

### H. Tips & Praktik Terbaik

- Beri nama pada kondisi yang lebih dari dua operator; tulis sisanya dalam bentuk positif (`isConnected`, bukan `isNotDisconnected`).
- Bandingkan dua ekspresi boolean dengan tabel kebenaran, bukan dengan firasat.
- Beri tanda kurung ketika mencampur `&&` dan `||` meskipun presedensinya sudah benar: kejelasan lebih murah daripada ketelitian pembaca.
- Letakkan pemeriksaan null atau pemeriksaan murah di kiri.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| `if (x == true)` pada `bool` biasa | Kode bertele-tele; ditandai pedoman Effective Dart | Tulis `if (x)` atau `if (!x)` |
| Memakai `&` atau `\|` alih-alih `&&`/`\|\|` | Sisi kanan tetap dievaluasi; crash null | Pakai operator short-circuit untuk logika boolean |
| Menyamakan `double` dengan `==` | `0.1 + 0.2 == 0.3` bernilai `false` | Bandingkan dengan toleransi atau pakai `int` satuan terkecil |
| Negasi bertumpuk | Salah baca arti kondisi | Terapkan De Morgan, ganti dengan nama positif |
| Mengabaikan `null` pada `bool?` | Cabang tak terduga | Putuskan arti `null` dengan `?? false` atau `switch` lengkap |

### J. Sumber Referensi

- ✔ Operator dan presedensi: https://dart.dev/language/operators
- ✔ Percabangan, pola, dan guard `when`: https://dart.dev/language/branches
- ✔ Panduan penggunaan (bool, null): https://dart.dev/effective-dart/usage
- Hukum De Morgan: https://en.wikipedia.org/wiki/De\_Morgan%27s\_laws
- Short-circuit evaluation: https://en.wikipedia.org/wiki/Short-circuit\_evaluation
- Saltzer & Schroeder, prinsip *fail-safe defaults*: https://en.wikipedia.org/wiki/The\_Protection\_of\_Information\_in\_Computer\_Systems

---

## 1.5 Kontrak Program: Precondition, Postcondition, Invarian

*Motivasi: kode yang kuat tidak pernah berasumsi — ia menuntut, menjamin, dan menjaga.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini mencakup cara menuliskan dan menegakkan **kontrak**: apa yang harus benar sebelum fungsi berjalan (**precondition**), apa yang dijamin sesudahnya (**postcondition**), dan apa yang selalu benar sepanjang hidup objek atau loop (**invarian**). Kamu juga belajar memilih alat penegak yang tepat di Dart: tipe, `assert`, `ArgumentError`/`RangeError`/`StateError`, dan `Exception`. Pemilihan yang keliru bisa berarti pemeriksaan keamanan yang lenyap di produksi.

### B. Konsep Kunci & Filosofi Mendalam

- **Kontrak antara pemanggil dan fungsi.** Pemanggil wajib memenuhi precondition; fungsi wajib menjamin postcondition. Bila precondition dilanggar, kesalahan ada di *pemanggil*; bila postcondition gagal, kesalahan ada di *fungsi*.
- **Hoare triple** `{P} C {Q}`: jika `P` benar sebelum `C` dan `C` selesai, maka `Q` benar sesudahnya. Contoh: `{x >= 0}  y = x + 1  {y >= 1}`.
- **Invarian:** pernyataan yang benar sebelum dan sesudah setiap operasi publik (invarian kelas), atau di awal tiap iterasi (invarian loop, modul 1.6).
- **Fail-fast:** gagal sedini dan sekeras mungkin dekat sumber masalah, bukan membiarkan data rusak mengalir jauh.
- **Tiga jenis kegagalan, tiga alat:**
  - bug internal yang *tidak boleh terjadi* → `assert` (hanya aktif saat pengembangan);
  - pemanggil melanggar kontrak API → `ArgumentError`, `RangeError`, `StateError` (selalu aktif; ini *Error*, bukan untuk ditangkap);
  - kegagalan wajar dari dunia luar atau domain → `Exception` (ditangkap dan ditangani).
- **Tipe sebagai kontrak gratis.** `int` non-nullable sudah menjanjikan *bukan null*; `Duration` menjanjikan satuan waktu yang jelas dan mencegah kebingungan detik vs menit (Fase 3 memperdalam).
- **Filosofi:** kontrak adalah dokumentasi yang dieksekusi. Kontrak yang hanya hidup di kepala pembuatnya akan dilanggar oleh orang berikutnya.
- **Dampak desain:** `assert` tidak dievaluasi di produksi, sehingga pemeriksaan mahal (mis. verifikasi urutan O(n)) bebas biaya di sana — tetapi justru karena itu `assert` **tidak boleh** dipakai untuk memvalidasi input dari luar.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — menegakkan precondition (melanjutkan `kabisat` dari modul 1.1).**

```dart
bool kabisat(int tahun) {
  if (tahun < 1) {
    throw ArgumentError.value(tahun, 'tahun', 'harus >= 1 (tahun proleptik)');
  }
  return (tahun % 4 == 0 && tahun % 100 != 0) || tahun % 400 == 0;
}
```

- `if (tahun < 1)` — memeriksa precondition di awal (*guard clause*).
- `throw` — melempar objek kesalahan; di Dart `throw` adalah ekspresi.
- `ArgumentError.value(nilai, nama, pesan)` — konstruktor yang menyertakan nilai yang salah, nama parameter, dan penjelasan sehingga pesan error informatif.

**Contoh 2 — tiga lapis kegagalan pada satu class.**

```dart
class SaldoTidakCukup implements Exception {
  SaldoTidakCukup(this.dibutuhkan, this.tersedia);
  final int dibutuhkan;
  final int tersedia;

  @override
  String toString() => 'SaldoTidakCukup: butuh $dibutuhkan, tersedia $tersedia';
}

class Rekening {
  Rekening(int saldoAwal) : _saldo = saldoAwal {
    if (saldoAwal < 0) {
      throw ArgumentError.value(saldoAwal, 'saldoAwal', 'tidak boleh negatif');
    }
  }

  int _saldo;
  int get saldo => _saldo;

  void tarik(int jumlah) {
    if (jumlah <= 0) {
      throw ArgumentError.value(jumlah, 'jumlah', 'harus positif'); // pemanggil melanggar kontrak
    }
    if (jumlah > _saldo) {
      throw SaldoTidakCukup(jumlah, _saldo); // kegagalan domain yang wajar
    }
    _saldo -= jumlah;
    assert(_saldo >= 0, 'invarian dilanggar: saldo negatif'); // bug internal
  }
}

void main() {
  final r = Rekening(100000);
  r.tarik(30000);
  print(r.saldo); // 70000
  try {
    r.tarik(500000);
  } on SaldoTidakCukup catch (e) {
    print('Ditolak: $e'); // Ditolak: SaldoTidakCukup: butuh 500000, tersedia 70000
  }
  // r.tarik(-5);  // ArgumentError = bug pemanggil: JANGAN ditangkap, perbaiki kodenya.
}
```

- `implements Exception` — menandai kelas sebagai pengecualian domain yang wajar ditangkap.
- `Rekening(int saldoAwal) : _saldo = saldoAwal { ... }` — *initializer list* mengisi field sebelum badan konstruktor; validasi dilakukan di badan.
- `int get saldo => _saldo;` — getter: pembaca bisa melihat, tetapi tidak bisa menulis langsung; ini menjaga **invarian kelas** (saldo tak pernah negatif) karena semua perubahan lewat `tarik`.
- `on SaldoTidakCukup catch (e)` — hanya menangkap tipe spesifik; tipe lain (termasuk `ArgumentError`) lolos ke atas. Pedoman Effective Dart: jangan menangkap `Error` secara eksplisit.

**Contoh 3 — postcondition yang mahal tetapi gratis di produksi.**

```dart
bool _terurut(List<int> data) {
  for (var i = 1; i < data.length; i++) {
    if (data[i - 1] > data[i]) return false;
  }
  return true;
}

List<int> urutkan(List<int> data) {
  final hasil = [...data]..sort();
  assert(hasil.length == data.length, 'jumlah elemen berubah');
  assert(_terurut(hasil), 'hasil tidak terurut');
  return hasil;
}
```

- `[...data]..sort()` — salin dulu (agar tidak memutasi argumen, modul 1.2), lalu `..sort()` (cascade) mengurutkan salinan dan tetap mengembalikan list tersebut.
- Dua `assert` menyatakan postcondition: jumlah elemen sama dan hasil terurut. Di produksi keduanya tidak dievaluasi, jadi loop O(n) di `_terurut` tidak membebani.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// 1) assert di initializer list: ringan; hanya pemeriksaan saat pengembangan.
class Titik {
  Titik(this.x, this.y) : assert(x >= 0 && y >= 0, 'koordinat harus non-negatif');
  final int x;
  final int y;
}

// 2) Fungsi require: SELALU aktif, pesan baru dibangun bila gagal (hemat alokasi).
void require(bool kondisi, String Function() pesan) {
  if (!kondisi) throw ArgumentError(pesan());
}
// pemakaian: require(umur >= 0, () => 'umur negatif: $umur');
```

| Alat | Aktif di produksi? | Pakai untuk |
| --- | --- | --- |
| Tipe (non-nullable, `enum`, `Duration`) | Ya (compile-time) | Kontrak yang bisa dinyatakan oleh sistem tipe |
| `assert` | **Tidak** | Invarian internal, postcondition mahal |
| `ArgumentError` / `RangeError` / `StateError` | Ya | Pelanggaran kontrak API oleh pemanggil |
| `Exception` turunan sendiri | Ya | Kegagalan domain yang wajar dan dapat ditangani |
| Validasi eksplisit + hasil kegagalan | Ya | **Input pengguna / dunia luar** (Fase 5 dan 9) |

### E. Terminologi Esensial

- **Kontrak** — perjanjian antara pemanggil dan fungsi. **Precondition** — syarat sebelum jalan. **Postcondition** — jaminan sesudah jalan. **Invarian** — selalu benar pada titik-titik tertentu.
- **Hoare triple** — notasi `{P} C {Q}` untuk penalaran formal tentang kode. **Fail-fast** — gagal cepat dan keras.
- **`Error`** — kesalahan programmer; **`Exception`** — kegagalan wajar saat runtime. **Unchecked** — Dart tidak memaksa kamu menangkap atau mendeklarasikan pengecualian.
- **`AssertionError`** — dilempar oleh `assert` yang gagal. **Defensive programming** — menulis kode dengan asumsi input bisa salah.

### F. Visualisasi (ASCII)

```text
 Pemanggil ──(memenuhi PRECONDITION)──► Fungsi ──(menjamin POSTCONDITION)──► Pemanggil
                                           │
                       INVARIAN benar sebelum dan sesudah setiap method publik
```

```text
Apa yang salah?
├─ Bug internal (tidak boleh terjadi)          → assert
├─ Pemanggil melanggar kontrak API              → ArgumentError / RangeError / StateError
├─ Dunia luar gagal secara wajar                → Exception (tangkap dan tangani)
└─ Input dari pengguna / jaringan / file        → validasi eksplisit (JANGAN assert)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 1.1 (batasan domain), 1.3 (kontrak per fungsi kecil), 1.4 (precondition adalah predikat).
- **Prasyarat bagi:** 1.6 (invarian loop) dan 1.8 (studi kasus). **Dikembangkan di:** Fase 3 (membuat keadaan ilegal tak bisa direpresentasikan oleh tipe), Fase 5 (strategi penanganan kegagalan), Fase 9 (validasi input sebagai batas kepercayaan), Fase 10 (menguji kontrak).

### H. Tips & Praktik Terbaik

- Tulis precondition dan postcondition di komentar dokumentasi (`///`) *dan* tegakkan di kode.
- Validasi di batas (tepi) sistem; di dalam, percayakan pada tipe dan kontrak agar kode tidak dipenuhi pemeriksaan ganda.
- Sertakan nilai yang salah dalam pesan error; pesan yang tidak memuat data menyulitkan debugging.
- Jaga invarian dengan *enkapsulasi*: field privat, perubahan hanya lewat method yang memeriksa kontrak.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Memakai `assert` untuk memvalidasi input luar | Pemeriksaan hilang di produksi; celah keamanan | Validasi eksplisit yang selalu aktif |
| Efek samping di dalam `assert` (mis. `assert(list.removeLast() != null)`) | Perilaku berbeda antara debug dan produksi | `assert` hanya boleh memuat ekspresi tanpa efek samping |
| `catch (e)` yang menelan semuanya | Bug programmer tersembunyi | Tangkap tipe spesifik; biarkan `Error` mengalir |
| `throw 'pesan string'` | Tidak ada tipe, tidak ada stack trace bermakna | Lempar objek `Exception`/`Error` yang sesuai |
| Memvalidasi terlambat | Data rusak sudah tersimpan | Validasi di titik masuk, sebelum mengubah state |

### J. Sumber Referensi

- ✔ Error handling dan `assert` di Dart: https://dart.dev/language/error-handling
- ✔ Effective Dart — penggunaan (jangan menangkap `Error`): https://dart.dev/effective-dart/usage
- API `ArgumentError`: https://api.dart.dev/stable/dart-core/ArgumentError-class.html
- API `Error`: https://api.dart.dev/stable/dart-core/Error-class.html
- Design by contract: https://en.wikipedia.org/wiki/Design\_by\_contract
- Hoare logic: https://en.wikipedia.org/wiki/Hoare\_logic

---

## 1.6 Tiga Struktur Kendali: Sequence, Selection, Iteration

*Motivasi: setiap algoritma di dunia hanyalah urutan, pilihan, dan pengulangan yang disusun dengan disiplin.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas pemilihan dan penulisan struktur kendali yang **aman dan jelas**: kapan memakai `if`, `switch`, atau ekspresi `switch`; kapan `for`, `for-in`, `while`, atau `do-while`; bagaimana meratakan percabangan bersarang dengan *guard clause*; dan bagaimana membuktikan sebuah loop benar dengan **invarian** dan **terminasi**. Sintaksnya sudah kamu kenal; yang baru adalah *alasan memilih* dan *cara memeriksa*. Modul ini adalah fondasi bagi pattern matching dan exhaustiveness (Fase 2) serta analisis kompleksitas (Fase 6).

### B. Konsep Kunci & Filosofi Mendalam

- **Teorema program terstruktur (Böhm–Jacopini):** setiap algoritma dapat dinyatakan hanya dengan tiga struktur — *sequence* (urutan), *selection* (pilihan), *iteration* (pengulangan). Dijkstra menunjukkan bahwa lompatan bebas (`goto`) merusak kemampuan bernalar tentang program. Dart tidak punya `goto`; label hanya untuk `break`/`continue` pada loop dan `switch`.
- **Sequence:** urutan penting karena tiap statement mengubah state (modul 1.2). Menukar dua baris dapat mengubah makna.
- **Selection di Dart:** `if`/`else`, `? :`, statement `switch`, ekspresi `switch`, dan `if-case`. Pada `switch`, case yang berisi kode **tidak** meneruskan ke case berikutnya (tak perlu `break`); case kosong meneruskan ke berikutnya; ekspresi `switch` mengembalikan nilai dan wajib lengkap. *Exhaustiveness checking* melaporkan galat saat ada kemungkinan nilai yang tak tercakup (untuk `enum`, `bool`, dan `sealed class`).
- **Iteration di Dart:** `for` (butuh indeks), `for-in` (tak butuh indeks), `while` (jumlah iterasi tak diketahui), `do-while` (minimal sekali). `break` menghentikan loop; `continue` melompat ke iterasi berikutnya. Closure di dalam loop `for` menangkap nilai indeks *per-iterasi*, tidak seperti JavaScript klasik.
- **Guard clause + early return:** tangani kasus tak valid atau ekstrem di awal; jalur utama (*happy path*) tetap rata di sisi kiri dan mudah dibaca.
- **Invarian loop:** pernyataan yang benar *sebelum setiap iterasi*. Pembuktian tiga langkah: (1) *inisialisasi* — benar sebelum iterasi pertama; (2) *pemeliharaan* — jika benar sebelum iterasi, tetap benar sesudahnya; (3) *terminasi* — saat loop berhenti, invarian + kondisi berhenti menghasilkan jawaban.
- **Fungsi variant:** besaran bulat non-negatif yang selalu menurun tiap iterasi; membuktikan loop pasti berhenti (pada FPB, nilai `b`).
- **Off-by-one:** salah satu bug paling umum — `<` vs `<=`, indeks berbasis 0. Obat: uji dengan 0, 1, dan 2 elemen.
- **Filosofi:** struktur yang paling sederhana yang benar adalah yang terbaik; kedalaman nesting adalah ukuran beban pikiran pembaca.
- **Dampak desain:** nesting dalam meningkatkan kompleksitas siklomatik dan peluang bug; loop bersarang menaikkan biaya dari O(n) menjadi O(n²) (Fase 6).

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — meratakan percabangan dengan guard clause.**

Sebelum (menjorok dalam):

```dart
String statusPesanan(bool? sudahBayar, int? stok, bool alamatValid) {
  if (sudahBayar != null) {
    if (sudahBayar) {
      if (stok != null && stok > 0) {
        if (alamatValid) {
          return 'DIKIRIM';
        } else {
          return 'ALAMAT_TIDAK_VALID';
        }
      } else {
        return 'STOK_HABIS';
      }
    } else {
      return 'MENUNGGU_PEMBAYARAN';
    }
  } else {
    return 'DATA_TIDAK_LENGKAP';
  }
}
```

Sesudah (rata, urutan = prioritas):

```dart
String statusPesanan(bool? sudahBayar, int? stok, bool alamatValid) {
  if (sudahBayar == null) return 'DATA_TIDAK_LENGKAP';
  if (!sudahBayar) return 'MENUNGGU_PEMBAYARAN';
  if (stok == null || stok <= 0) return 'STOK_HABIS';
  if (!alamatValid) return 'ALAMAT_TIDAK_VALID';
  return 'DIKIRIM';
}
```

- `if (sudahBayar == null) return ...;` — jika `null`, keluar sekarang. Setelah baris ini Dart *mempromosikan* `sudahBayar` dari `bool?` menjadi `bool`, sehingga `!sudahBayar` aman.
- `stok == null || stok <= 0` — short-circuit: `stok <= 0` hanya dievaluasi bila `stok` bukan null.
- **Urutan guard adalah keputusan spesifikasi:** jika dua syarat gagal sekaligus (belum bayar *dan* stok habis), yang diutamakan adalah yang paling atas. Tuliskan prioritas itu di spesifikasi.

**Contoh 2 — ekspresi `switch` yang lengkap pada `enum` dan rentang.**

```dart
enum Hari { senin, selasa, rabu, kamis, jumat, sabtu, minggu }

bool akhirPekan(Hari h) => switch (h) {
      Hari.sabtu || Hari.minggu => true,
      Hari.senin || Hari.selasa || Hari.rabu || Hari.kamis || Hari.jumat => false,
    };

String huruf(int skor) => switch (skor) {
      >= 90 && <= 100 => 'A',
      >= 80 && < 90 => 'B',
      >= 70 && < 80 => 'C',
      >= 60 && < 70 => 'D',
      >= 0 && < 60 => 'E',
      _ => throw RangeError.range(skor, 0, 100, 'skor'),
    };
```

- `Hari.sabtu || Hari.minggu` — pola logika-OR: dua konstanta berbagi satu hasil.
- `akhirPekan` **tanpa `_`**: bila suatu saat `Hari` ditambah nilai baru, kompilator langsung menolak — kamu dipaksa memutuskan perilakunya. Ini keamanan yang kamu dapat gratis.
- `huruf`: rentang ditulis dengan pola relasional; cabang terakhir `_` melempar `RangeError` untuk skor di luar 0–100 — `throw` adalah ekspresi sehingga boleh menjadi isi cabang.

**Contoh 3 — loop dengan invarian: indeks elemen terbesar.**

```dart
/// Mengembalikan indeks elemen terbesar (yang pertama bila ada kembar),
/// atau null bila [data] kosong.
int? indeksTerbesar(List<int> data) {
  if (data.isEmpty) return null; // guard: kasus tepi kosong
  var idx = 0;
  // INVARIAN: sebelum iterasi i, data[idx] adalah maksimum dari data[0..i-1].
  for (var i = 1; i < data.length; i++) {
    if (data[i] > data[idx]) idx = i; // '>' (bukan '>=') menjaga 'yang pertama'
  }
  // TERMINASI: saat i == data.length, invarian berarti data[idx] = maksimum seluruh list.
  return idx;
}

void main() {
  assert(indeksTerbesar([]) == null);
  assert(indeksTerbesar([7]) == 0);
  assert(indeksTerbesar([3, 9, 2]) == 1);
  assert(indeksTerbesar([5, 5, 1]) == 0);
  assert(indeksTerbesar([1, 2, 3]) == 2);
}
```

- Inisialisasi: sebelum `i = 1`, `data[0..0]` hanya berisi `data[0]` dan `idx = 0` → invarian benar.
- Pemeliharaan: jika `data[i]` lebih besar dari `data[idx]`, `idx` pindah ke `i`; jika tidak, `idx` tetap — dalam kedua kasus `data[idx]` adalah maksimum `data[0..i]`.
- Terminasi: `i` naik satu tiap iterasi dan dibatasi `data.length`, jadi pasti berhenti.
- `int?` — tipe kembalian *nullable* membuat kasus kosong menjadi bagian dari tipe; pemanggil dipaksa menanganinya.
- Kasus uji sengaja mencakup 0, 1, dan beberapa elemen, plus elemen kembar.

**Contoh 4 — loop bersarang dan keluar dini dengan `return`.**

```dart
/// Mencari pasangan indeks (i, j), i < j, dengan a[i] + a[j] == target.
(int, int)? cariPasangan(List<int> a, int target) {
  for (var i = 0; i < a.length; i++) {
    for (var j = i + 1; j < a.length; j++) {
      if (a[i] + a[j] == target) return (i, j); // keluar dari KEDUA loop
    }
  }
  return null;
}
```

- `(int, int)?` — record bernilai opsional sebagai tipe kembalian. `return (i, j)` keluar dari seluruh fungsi sehingga tak perlu label `break`.
- `j = i + 1` — mencegah memasangkan elemen dengan dirinya sendiri dan menghindari pasangan ganda.
- Biayanya O(n²); Fase 6 menunjukkan versi O(n) memakai `Map`.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
import 'dart:math' as math;

// 1) Fungsional: reduce + indexOf (dua kali lintasan; reduce melempar StateError bila kosong).
int? indeksTerbesarReduce(List<int> data) =>
    data.isEmpty ? null : data.indexOf(data.reduce(math.max));

// 2) while: ekuivalen dengan for, kendali indeks sepenuhnya manual.
int? indeksTerbesarWhile(List<int> data) {
  if (data.isEmpty) return null;
  var idx = 0;
  var i = 1;
  while (i < data.length) {
    if (data[i] > data[idx]) idx = i;
    i++; // jangan lupa: tanpa baris ini loop tak pernah berhenti
  }
  return idx;
}
```

| Struktur | Pilih bila | Risiko |
| --- | --- | --- |
| `for (var i...)` | Butuh indeks atau langkah khusus | Off-by-one pada batas |
| `for (final x in ...)` | Hanya butuh elemen | Tidak boleh mengubah koleksi saat iterasi |
| `while` | Jumlah iterasi tak diketahui di awal | Lupa memperbarui variabel kondisi → loop tak berhenti |
| `do-while` | Isi harus berjalan minimal sekali | Mudah terlewat bahwa kondisi dicek di akhir |
| `forEach((x) {...})` | Tindakan sederhana per elemen | Tak bisa `break`; `return` hanya keluar dari closure; pedoman menyarankan menghindarinya |
| Ekspresi `switch` | Memetakan nilai ke nilai, wajib lengkap | Tidak untuk rangkaian statement panjang |

### E. Terminologi Esensial

- **Sequence / selection / iteration** — urutan / pilihan / pengulangan. **Struktur terprogram** — gaya yang hanya memakai ketiganya.
- **Guard clause** — pemeriksaan di awal yang keluar lebih dulu. **Happy path** — jalur ketika semua berjalan normal.
- **Fall-through** — eksekusi meluncur ke case berikutnya; Dart hanya mengizinkannya pada case kosong.
- **Exhaustiveness** — jaminan kompilator bahwa semua kemungkinan nilai tercakup.
- **Invarian loop / fungsi variant** — pernyataan yang dijaga tiap iterasi / besaran yang menurun sebagai bukti berhenti.
- **Off-by-one** — salah satu iterasi atau indeks. **Sentinel** — nilai khusus penanda berhenti (hindari; pakai `null`/tipe nullable).
- **Kompleksitas siklomatik** — jumlah jalur independen dalam kode; makin tinggi, makin sulit diuji.

### F. Visualisasi (ASCII)

```text
 SEQUENCE            SELECTION               ITERATION
 ┌───────┐           ┌───────┐               ┌───────┐
 │  S1   │           │ cond? │◄────┐         │ cond? │──tidak──► keluar
 └───┬───┘           └─┬───┬─┘     │         └───┬───┘
     ▼              ya │   │ tidak │          ya │
 ┌───────┐          ┌──▼┐ ┌▼──┐    │         ┌───▼───┐
 │  S2   │          │ A │ │ B │    └─────────│ badan │
 └───────┘          └───┘ └───┘              └───────┘
```

```text
SEBELUM (menjorok dalam)         SESUDAH (jalur utama lurus)
if (A) {                         if (!A) return ...;
  if (B) {                       if (!B) return ...;
    if (C) {                     if (!C) return ...;
      kerja utama                kerja utama
    }
  }
}
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 1.4 (kondisi), 1.5 (guard clause menegakkan precondition; invarian loop adalah invarian), 1.3 (trace table memeriksa loop).
- **Prasyarat bagi:** 1.8 (studi kasus). **Dikembangkan di:** Fase 2 (pattern matching mendalam), Fase 6 (analisis biaya loop), Fase 7 (loop asinkron `await for`), Fase 10 (test batas 0/1/2 elemen).

### H. Tips & Praktik Terbaik

- Batasi kedalaman nesting maksimal 2–3 tingkat; sisanya diratakan dengan guard clause atau dipecah menjadi fungsi.
- Pada `switch` atas `enum`/`sealed class`, **hindari `default`/`_`** agar penambahan varian baru ditangkap kompilator.
- Tulis invarian sebagai komentar di atas loop yang tidak sepele; ia sekaligus bahan `assert` saat debugging.
- Hindari mengubah koleksi yang sedang diiterasi; kumpulkan perubahan lalu terapkan sesudah loop, atau iterasi atas salinan.
- Uji setiap loop dengan 0, 1, dan 2 elemen serta batas-batas tepat.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| `<=` alih-alih `<` pada batas indeks | `RangeError` di iterasi terakhir | Indeks valid: `0` sampai `length - 1`; uji list berukuran 0 dan 1 |
| Lupa memperbarui variabel loop `while` | Program menggantung | Tulis variant (apa yang menurun?) sebelum loop |
| Menambah/menghapus elemen saat `for-in` | `ConcurrentModificationError` | Iterasi atas salinan atau kumpulkan perubahan dulu |
| Mengira `return` dalam `forEach` keluar dari fungsi | Loop terus berjalan | Pakai `for-in` bila butuh keluar dini |
| Urutan guard salah | Status yang salah ketika dua syarat gagal | Tulis prioritas di spesifikasi, tes kombinasi |
| `default` pada `switch` atas `enum` | Varian baru diam-diam jatuh ke default | Hapus `default`; biarkan kompilator memeriksa kelengkapan |

### J. Sumber Referensi

- ✔ Percabangan (`if`, `if-case`, `switch`, guard `when`, exhaustiveness): https://dart.dev/language/branches
- ✔ Loop (`for`, `while`, `break`, `continue`, label): https://dart.dev/language/loops
- ✔ Effective Dart — penggunaan (hindari `forEach` dengan function literal): https://dart.dev/effective-dart/usage
- Pola (patterns): https://dart.dev/language/patterns
- Teorema program terstruktur: https://en.wikipedia.org/wiki/Structured\_program\_theorem
- Dijkstra, *Go To Statement Considered Harmful*: https://dl.acm.org/doi/10.1145/362929.362947
- Invarian loop: https://en.wikipedia.org/wiki/Loop\_invariant
- Kompleksitas siklomatik: https://en.wikipedia.org/wiki/Cyclomatic\_complexity

---

## 1.7 Siklus Run–Error–Debug dan Alat Dasar *(TAMBAHAN)*

*Motivasi: ahli bukan orang yang tak pernah salah, melainkan yang paling cepat belajar dari setiap salah.*

> **Mengapa ditambahkan.** Audit menemukan bahwa kurikulum logika umumnya berhenti pada "tulis kode yang benar", padahal intuisi logika terbentuk dari siklus *menulis → menjalankan → mengamati kegagalan → memperbaiki*. Modul ini membuat siklus itu eksplisit dan disiplin.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini mencakup pembuatan proyek Dart dari terminal, tiga lapis pemeriksaan (analisis statis, eksekusi, test), cara membaca pesan error dan *stack trace*, dan protokol debugging berbasis hipotesis. Ia menjadi "bengkel" untuk semua modul lain: setiap kode di dokumen ini harus kamu jalankan sendiri, dan di sinilah kamu belajar melakukannya dengan benar.

### B. Konsep Kunci & Filosofi Mendalam

- **Umpan balik cepat adalah mesin belajar.** Makin pendek siklus tulis → jalankan → amati → perbaiki, makin cepat intuisi terbentuk.
- **Tiga lapis pemeriksaan**, semakin awal semakin murah: (1) *analisis statis* (`dart analyze`, tanpa menjalankan kode), (2) *eksekusi* (`dart run --enable-asserts`), (3) *test otomatis* (`dart test`).
- **Tiga jenis kesalahan:** *compile-time* (tipe/sintaks; ditangkap analyzer), *runtime* (exception saat jalan), dan *logika* (hasil salah tanpa error apa pun — yang paling berbahaya karena diam).
- **Membaca stack trace:** baris `#0` adalah tempat error dilempar; makin ke bawah makin ke pemanggil. Cari frame pertama yang berada di *kodemu* — di situlah penyelidikan dimulai.
- **Debugging ilmiah:** rumuskan hipotesis, rancang eksperimen terkecil, amati, simpulkan. Mengubah kode secara acak bukan debugging.
- **Pisahkan stdout dan stderr.** Hasil program ke stdout; diagnostik dan pesan error ke stderr. Dengan begitu keluaran dapat di-*pipe* tanpa tercemar pesan debug, dan kode keluar (*exit code*) bukan-nol menandai kegagalan — kebiasaan baik untuk alat berbasis terminal.
- **Dampak desain:** logika murni (modul 1.2) yang ditaruh di `lib/` dan tipis di `bin/` membuat test mudah dan debugging cepat.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — membuat dan menjalankan proyek.**

```bash
dart create -t console logika_fase1
cd logika_fase1
dart pub get
dart run --enable-asserts
```

```text
logika_fase1/                (bentuk umum template console)
├── bin/
│   └── logika_fase1.dart     ← titik masuk: main(), tipis
├── lib/
│   └── logika_fase1.dart     ← logika murni, diimpor oleh bin/ dan test/
├── test/
│   └── logika_fase1_test.dart
├── pubspec.yaml
└── analysis_options.yaml
```

- `dart create -t console NAMA` — membuat kerangka proyek konsol.
- `dart pub get` — mengunduh dependensi di `pubspec.yaml`.
- `dart run --enable-asserts` — menjalankan titik masuk proyek dengan `assert` aktif (tanpa flag, `assert` diam).

**Contoh 2 — perintah harian.**

| Perintah | Fungsi |
| --- | --- |
| `dart format .` | Merapikan seluruh kode sesuai gaya resmi |
| `dart analyze` | Analisis statis: error, warning, lint |
| `dart analyze --fatal-infos` | Menganggap temuan ringan (info) juga sebagai kegagalan — cocok untuk CI |
| `dart fix --apply` | Menerapkan perbaikan otomatis yang aman |
| `dart run --enable-asserts` | Menjalankan dengan `assert` aktif |
| `dart test` | Menjalankan seluruh test di `test/` |
| `dart compile exe bin/logika_fase1.dart -o logika` | Mengompilasi menjadi executable native (build produksi) |

**Contoh 3 — analisis yang lebih ketat.**

```bash
dart pub add --dev lints
```

```yaml
# analysis_options.yaml
include: package:lints/recommended.yaml

analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true

linter:
  rules:
    - prefer_final_locals
    - prefer_const_declarations
    - unawaited_futures
    - avoid_dynamic_calls
```

- `include:` — mewarisi himpunan aturan rekomendasi tim Dart.
- `strict-casts`, `strict-inference`, `strict-raw-types` — mode yang menolak konversi tipe dan inferensi yang longgar; menangkap bug tipe lebih awal.
- `linter: rules:` — daftar aturan lint tambahan (setiap baris diawali tanda hubung, sintaks daftar YAML).

**Contoh 4 — membaca stack trace (bentuk umum, bukan keluaran persis).**

```text
Unhandled exception:
Invalid argument (tahun): harus >= 1 (tahun proleptik): 0
#0      kabisat (file:///proyek/lib/kabisat.dart:3:5)
#1      main (file:///proyek/bin/logika_fase1.dart:6:3)
#2      _delayEntrypointInvocation.<anonymous closure> (dart:isolate-patch/isolate_patch.dart:...)
```

Cara membaca: pesan di atas = *apa* yang salah (nilai `0` untuk `tahun`); `#0` = *di mana* dilempar (`kabisat`, baris 3); `#1` = *siapa yang memanggil* dengan nilai itu (`main`, baris 6). Bug ada di pemanggil karena itu pelanggaran precondition (modul 1.5).

**Contoh 5 — satu sesi debugging utuh.**

```dart
// BUG: hasil salah, tanpa error apa pun.
int jumlahGenap(List<int> data) {
  var total = 0;
  for (var i = 1; i < data.length; i++) {
    if (data[i] % 2 == 0) total += data[i];
  }
  return total;
}
```

| Langkah | Tindakan |
| --- | --- |
| 1. Reproduksi | `jumlahGenap([2, 4, 6])` seharusnya 12, tetapi menghasilkan 10 |
| 2. Perkecil | `jumlahGenap([2])` seharusnya 2, tetapi menghasilkan 0 — kasus terkecil yang salah |
| 3. Hipotesis | Elemen pertama tidak pernah diproses (loop mulai dari `i = 1`) |
| 4. Amati | Tambahkan `stderr.writeln('i=$i total=$total');` di dalam loop; indeks 0 tak pernah muncul |
| 5. Perbaiki | Mulai dari `i = 0`, atau gunakan `for (final x in data)` agar tak ada indeks |
| 6. Cegah | Tambahkan test `jumlahGenap([2])` dan list kosong ke `test/` |

```dart
import 'dart:io';

int jumlahGenap(List<int> data) {
  var total = 0;
  for (final x in data) {
    if (x % 2 == 0) total += x;
  }
  stderr.writeln('debug total=$total'); // hapus setelah selesai
  return total;
}
```

- `import 'dart:io';` — pustaka I/O; menyediakan `stderr`.
- `stderr.writeln(...)` — menulis ke aliran galat, sehingga stdout (hasil program) tetap bersih.
- `for (final x in data)` — menghilangkan kelas bug indeks sama sekali.

### D. Opsi Lain untuk Tujuan yang Sama

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Mengamati nilai | `print` / `stderr.writeln` / `dart:developer` `log()` | `log()` terutama tampil di IDE/DevTools, bukan di terminal biasa |
| Menghentikan eksekusi | Breakpoint di editor, atau `debugger()` dari `dart:developer` | `debugger()` hanya berhenti bila debugger terpasang |
| Debugging dari editor terminal | Server bahasa (`dart language-server`) dan adaptor debug (`dart debug_adapter`) | Memungkinkan Neovim/Helix dan editor lain memakai fitur IDE; cek dokumentasi editor |
| Menjalankan | `dart run` / `dart bin/x.dart` / `dart compile exe` | Build produksi mengabaikan `assert` secara bawaan |
| Memeriksa lebih ketat | `dart analyze --fatal-infos` di skrip lokal atau CI | Mencegah *commit* dengan peringatan tersisa |

### E. Terminologi Esensial

- **Analyzer** — alat analisis statis. **Linter / lint** — aturan gaya dan praktik baik yang diperiksa analyzer.
- **Compile-time / runtime error** — galat sebelum / saat program berjalan. **Logic error** — hasil salah tanpa error.
- **Stack trace** — daftar pemanggilan yang aktif saat error terjadi. **Frame** — satu baris dalam stack trace.
- **stdout / stderr** — aliran keluaran standar / galat standar. **Exit code** — angka status saat proses selesai (0 = sukses).
- **Breakpoint / step over / step into** — titik henti / lewati pemanggilan / masuk ke dalam pemanggilan.
- **Repro (reproduction)** — langkah minimal yang selalu memunculkan bug. **JIT / AOT** — kompilasi saat jalan / sebelum jalan (menghasilkan executable).

### F. Visualisasi (ASCII)

```text
   ┌─────────────► tulis / ubah kode ◄───────────────┐
   │                      │                           │
   │                      ▼                           │
   │        dart format · dart analyze ──► temuan ────┤
   │                      │                           │
   │                      ▼                           │
   │        dart run --enable-asserts ──► error ──► baca stack trace
   │                      │                           │       │
   │                      ▼                           │       ▼
   │                  dart test ──► gagal ──► perkecil ──► hipotesis
   │                      │
   │                    lolos
   │                      ▼
   └──────────────────  commit
```

### G. Hubungan dengan Modul Lain

- **Memakai:** semua modul 1.1–1.6; setiap contoh di dokumen ini dijalankan lewat siklus ini.
- **Prasyarat bagi:** 1.8 (studi kasus dan test). **Dikembangkan di:** Fase 6 (profiling), Fase 7 (debugging kode asinkron), Fase 10 (test otomatis, property-based, fuzzing).

### H. Tips & Praktik Terbaik

- Jalankan `dart analyze` dan `dart format .` sebelum setiap commit; jadikan kebiasaan, atau pasang sebagai *git hook*.
- Satu perubahan per percobaan; jika mengubah tiga hal sekaligus, kamu tak akan tahu mana yang memperbaiki.
- Simpan repro minimal sebagai test; bug yang pernah muncul wajib punya test agar tidak kembali.
- Hapus `print` debugging sebelum commit, atau gantikan dengan logging yang terkendali.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mengabaikan error pertama | Rentetan error turunan membingungkan | Selalu perbaiki dari error paling atas, jalankan ulang |
| Menebak lalu mengubah acak | Bug berpindah tempat, bukan hilang | Tulis hipotesis, ubah satu hal, amati |
| `assert` tak aktif | Tidak ada pemeriksaan sama sekali | Jalankan dengan `--enable-asserts`; sisipkan satu assert yang sengaja gagal untuk memastikan |
| Debug dengan `print` ke stdout pada program yang di-pipe | Keluaran tercemar | Gunakan `stderr` untuk diagnostik |
| Tidak menulis test setelah memperbaiki bug | Bug yang sama kembali | Tambahkan test dari repro minimal |

### J. Sumber Referensi

- ✔ Analisis statis dan `analysis_options.yaml`: https://dart.dev/tools/analysis
- ✔ Pengujian di Dart: https://dart.dev/tools/testing
- ✔ Error handling dan `assert`: https://dart.dev/language/error-handling
- Alat baris perintah `dart`: https://dart.dev/tools/dart-tool
- Paket lints: https://pub.dev/packages/lints
- Paket test: https://pub.dev/packages/test

---

## 1.8 Studi Kasus Terpadu: Tarif Parkir *(TAMBAHAN)*

*Motivasi: logika yang kuat terbukti bukan di kepala, melainkan di tabel contoh yang lolos satu per satu.*

> **Mengapa ditambahkan.** Audit menemukan bahwa pembelajar sering memahami tiap alat secara terpisah tetapi belum pernah memakai semuanya pada satu masalah. Studi kasus ini memaksa alur penuh: spesifikasi → contoh → predikat → kontrak → kendali → test → jalankan dari terminal.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Langkah & kode · D Variasi · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Kamu membangun fungsi `tarifParkir` yang menghitung biaya parkir berdasarkan durasi dan status member, lengkap dengan spesifikasi, tabel contoh, kontrak, implementasi, dan test. Masalahnya sengaja kecil tetapi sarat nilai batas (15/16 menit, 60/61 menit, 7/8 jam, 24 jam) dan keputusan desain (satuan uang, pembulatan, cakupan).

### B. Konsep Kunci & Filosofi Mendalam

- **Cakupan ditulis eksplisit.** Durasi lebih dari 24 jam sengaja *di luar cakupan* dan ditolak dengan `RangeError`. Menolak dengan jelas lebih aman daripada menebak aturan yang belum diputuskan.
- **Uang = `int` satuan terkecil;** pembulatan = ke bawah; keduanya keputusan tertulis (modul 1.3).
- **Waktu bertipe `Duration`,** bukan `int menit`: satuan melekat pada tipe sehingga tak ada kebingungan detik vs menit.
- **Parameter boolean dibuat bernama dan wajib** (`{required bool member}`) agar pemanggilan terbaca: `tarifParkir(d, member: true)`, bukan `tarifParkir(d, true)` (*boolean trap*).
- **Fungsi murni** (modul 1.2): tak membaca jam sistem, tak mencetak; mudah dites.
- **Konstanta bernama** menggantikan angka ajaib; mengubah tarif berarti mengubah satu baris.
- **Dampak desain:** jam yang *dimulai* dihitung dari detik dengan pembulatan ke atas. Memakai `inMinutes` (yang memotong ke bawah) akan membuat durasi 15 menit 59 detik terhitung gratis — bug batas klasik.

### C. Langkah, Sintaks, dan Kode

**Langkah 1 — spesifikasi.**

| Aspek | Keputusan |
| --- | --- |
| Input | `Duration durasi`, `bool member` (bernama, wajib) |
| Output | `int` rupiah |
| Domain | `0 <= durasi <= 24 jam`. Negatif → `ArgumentError`; lebih dari 24 jam → `RangeError` (di luar cakupan Fase 1) |
| Aturan | ≤ 15 menit gratis (inklusif); jam pertama Rp 5.000; tiap jam berikutnya yang *dimulai* Rp 3.000; batas harian Rp 25.000; member membayar 80% dari total setelah batas harian |
| Satuan hitung | Detik; jam dimulai = pembulatan ke atas dari detik / 3600 |
| Pembulatan | Ke bawah (pembagian bulat) |
| Oracle | Tabel contoh di bawah |

**Langkah 2 — tabel contoh (termasuk nilai batas).**

| Durasi | Member | Hasil | Alasan |
| --- | --- | --- | --- |
| 0 menit | tidak | 0 | gratis |
| 15 menit | tidak | 0 | batas gratis, inklusif |
| 15 menit 1 detik | tidak | 5000 | baru lewat gratis: jam pertama |
| 60 menit | tidak | 5000 | masih jam pertama |
| 61 menit | tidak | 8000 | jam kedua dimulai: 5000 + 3000 |
| 7 jam | tidak | 23000 | 5000 + 6 × 3000 |
| 8 jam | tidak | 25000 | 26000 dipangkas batas harian |
| 24 jam | ya | 20000 | 25000 × 80% |
| 61 menit | ya | 6400 | 8000 × 80% |
| −1 detik | — | `ArgumentError` | durasi negatif |
| 24 jam 1 detik | — | `RangeError` | di luar cakupan |

**Langkah 3 — predikat dan batas (modul 1.4).** `durasi.isNegative`, `durasi > _maksimum`, `durasi <= _gratis` — urutan guard menentukan prioritas: validasi domain dulu, baru kasus gratis, baru hitungan.

**Langkah 4 — kode (`lib/parkir.dart`).**

```dart
const int _tarifJamPertama = 5000;
const int _tarifJamBerikutnya = 3000;
const int _batasHarian = 25000;
const int _persenMember = 80; // member membayar 80% (diskon 20%)
const Duration _gratis = Duration(minutes: 15);
const Duration _maksimum = Duration(hours: 24);

/// Jumlah jam yang DIMULAI untuk [detik] > 0 (pembulatan ke atas).
int _jamDimulai(int detik) => (detik + 3599) ~/ 3600;

/// Menghitung tarif parkir dalam rupiah.
///
/// Precondition : 0 <= [durasi] <= 24 jam.
/// Postcondition: 0 <= hasil <= 25000.
/// Melempar [ArgumentError] bila durasi negatif, [RangeError] bila lebih dari 24 jam.
int tarifParkir(Duration durasi, {required bool member}) {
  if (durasi.isNegative) {
    throw ArgumentError.value(durasi, 'durasi', 'tidak boleh negatif');
  }
  if (durasi > _maksimum) {
    throw RangeError('durasi melebihi 24 jam (di luar cakupan): $durasi');
  }
  if (durasi <= _gratis) return 0;

  final jam = _jamDimulai(durasi.inSeconds); // >= 1
  var total = _tarifJamPertama + (jam - 1) * _tarifJamBerikutnya;
  if (total > _batasHarian) total = _batasHarian;
  if (member) total = total * _persenMember ~/ 100;

  assert(total >= 0 && total <= _batasHarian, 'postcondition dilanggar: $total');
  return total;
}
```

**Bedah kode kata demi kata**

- `const int _tarifJamPertama = 5000;` — konstanta waktu-kompilasi tingkat atas; awalan `_` membuatnya privat bagi file/library ini.
- `const Duration _gratis = Duration(minutes: 15);` — `Duration` memiliki konstruktor `const`, sehingga nilainya konstan.
- `(detik + 3599) ~/ 3600` — trik pembulatan ke atas dengan bilangan bulat: menambah `pembagi - 1` sebelum pembagian bulat. Contoh: 3600 detik → 7199 \~/ 3600 = 1; 3601 detik → 7200 \~/ 3600 = 2.
- `{required bool member}` — parameter bernama yang wajib diberikan.
- `durasi.isNegative` — properti `Duration`; `durasi > _maksimum` memakai operator pembanding yang didefinisikan `Duration`.
- `throw ArgumentError.value(...)` dan `throw RangeError(...)` — dua tingkat pelanggaran kontrak (modul 1.5).
- `if (durasi <= _gratis) return 0;` — guard clause untuk kasus gratis (inklusif, jadi `<=`).
- `total * _persenMember ~/ 100` — dievaluasi `(total * 80) ~/ 100`; hasil dipotong ke bawah.
- `assert(...)` — postcondition: hasil selalu di antara 0 dan batas harian; hanya aktif saat pengembangan.

**Langkah 5 — test (`test/parkir_test.dart`).**

```dart
import 'package:logika_fase1/parkir.dart';
import 'package:test/test.dart';

void main() {
  const menit = Duration(minutes: 1);

  group('tarifParkir — nilai batas', () {
    test('0 dan 15 menit gratis', () {
      expect(tarifParkir(Duration.zero, member: false), 0);
      expect(tarifParkir(menit * 15, member: false), 0);
    });
    test('lewat 15 menit masuk jam pertama', () {
      expect(tarifParkir(menit * 15 + const Duration(seconds: 1), member: false), 5000);
      expect(tarifParkir(menit * 60, member: false), 5000);
    });
    test('jam kedua dimulai pada menit ke-61', () {
      expect(tarifParkir(menit * 61, member: false), 8000);
    });
    test('batas harian', () {
      expect(tarifParkir(const Duration(hours: 7), member: false), 23000);
      expect(tarifParkir(const Duration(hours: 8), member: false), 25000);
    });
    test('member membayar 80%', () {
      expect(tarifParkir(const Duration(hours: 24), member: true), 20000);
      expect(tarifParkir(menit * 61, member: true), 6400);
    });
  });

  group('tarifParkir — kontrak', () {
    test('durasi negatif melempar ArgumentError', () {
      expect(
        () => tarifParkir(const Duration(seconds: -1), member: false),
        throwsArgumentError,
      );
    });
    test('lebih dari 24 jam melempar RangeError', () {
      expect(
        () => tarifParkir(const Duration(hours: 24, seconds: 1), member: false),
        throwsRangeError,
      );
    });
  });
}
```

```bash
dart test
# 00:00 +7: All tests passed!
```

- `import 'package:logika_fase1/parkir.dart';` — mengimpor dari `lib/` memakai nama paket di `pubspec.yaml` (sesuaikan bila namamu berbeda).
- `group` / `test` — pengelompokan dan satu kasus uji; nama test menjelaskan *perilaku*, bukan nama fungsi.
- `expect(aktual, diharapkan)` — membandingkan; bila tak sama, test gagal dengan pesan rinci.
- `expect(() => ..., throwsArgumentError)` — fungsi dibungkus closure agar pelemparannya dapat ditangkap oleh matcher.
- `menit * 15` — `Duration * num` valid; `15 * menit` **tidak** valid (kiri `int`).

### D. Variasi Kode untuk Logika yang Sama

```dart
import 'dart:math' as math;

// Varian ringkas: min() menggantikan if pemangkasan; ekspresi ?: untuk member.
// (validasi domain sama seperti versi utama)
int tarifParkirRingkas(Duration durasi, {required bool member}) {
  if (durasi <= _gratis) return 0;
  final jam = _jamDimulai(durasi.inSeconds);
  final dasar = math.min(_batasHarian, _tarifJamPertama + (jam - 1) * _tarifJamBerikutnya);
  return member ? dasar * _persenMember ~/ 100 : dasar;
}
```

| Varian | Kelebihan | Kekurangan / dampak |
| --- | --- | --- |
| Utama (guard + `if`) | Setiap keputusan terpisah dan mudah dilacak | Sedikit lebih panjang |
| `math.min` + `?:` | Ringkas | Menggabungkan beberapa keputusan dalam satu baris |
| Tarif sebagai *data* (class kebijakan) | Aturan berubah tanpa menyentuh logika | Lebih banyak struktur; dibahas di Fase 3–4 |
| `double` untuk uang | Terlihat natural | Galat pecahan biner; **hindari** |

### E. Terminologi Esensial

- **Boolean trap** — parameter `bool` posisional yang membuat pemanggilan tak terbaca. **Angka ajaib (magic number)** — literal tanpa nama.
- **Konstanta bernama** — nilai tetap yang diberi nama. **Analisis nilai batas** — menguji tepat di perbatasan kelas.
- **Pembulatan ke atas (ceil) dengan bilangan bulat** — `(a + b - 1) ~/ b`. **Pemotongan (truncation)** — `~/` membuang pecahan.
- **Regresi** — fungsi yang dulu benar menjadi salah setelah perubahan; test mencegahnya. **Di luar cakupan (out of scope)** — sengaja ditolak, bukan diabaikan.

### F. Visualisasi (ASCII)

```text
tarifParkir(durasi, member)
   │
   ├─ durasi < 0 ?            ──► ArgumentError   (pelanggaran kontrak)
   ├─ durasi > 24 jam ?       ──► RangeError      (di luar cakupan)
   ├─ durasi ≤ 15 menit ?     ──► return 0
   │
   ├─ jam   = ceil(detik / 3600)
   ├─ total = 5000 + (jam − 1) × 3000
   ├─ total = min(total, 25000)
   ├─ member ?  total × 80 ÷ 100
   └─ assert(0 ≤ total ≤ 25000) ──► return total
```

```text
durasi (menit):  0 ─ 15 ──────── 60 ──────── 120 ─────── 180 ... 420 ───── 480 ... 1440
tarif (rupiah):  │ 0 │   5000    │   8000    │   11000   │ ... │  23000  │  25000 (batas)
                 gratis  jam ke-1    jam ke-2    jam ke-3         jam ke-7   jam ke-8 dst.
```

### G. Hubungan dengan Modul Lain

- **Memakai seluruh Fase 1:** 1.1 (spesifikasi dan tabel), 1.2 (murni, imutabel), 1.3 (dekomposisi `_jamDimulai`), 1.4 (predikat batas), 1.5 (kontrak), 1.6 (guard clause), 1.7 (test dan analisis dari terminal).
- **Dikembangkan di:** Fase 2 (jenis kendaraan dengan `sealed class` dan exhaustiveness), Fase 3 (tipe `Rupiah` dan kebijakan tarif sebagai data), Fase 4 (kebijakan sebagai class), Fase 10 (property-based: tarif tak pernah menurun saat durasi naik; tarif ≤ batas harian; member ≤ non-member).

### H. Tips & Praktik Terbaik

- Tulis tabel contoh *sebelum* kode, lalu jadikan baris-barisnya sebagai test; setiap bug yang ditemukan kemudian menambah satu baris.
- Selalu uji pasangan nilai batas (15 menit vs 15 menit 1 detik; 60 vs 61 menit; 7 vs 8 jam).
- Bila ingin membedakan `ArgumentError` murni dari `RangeError` di test, ingat bahwa `RangeError` adalah turunan `ArgumentError`; matcher `throwsArgumentError` menerima keduanya. Gunakan `throwsA(isA<ArgumentError>().having((e) => e is RangeError, 'adalah RangeError', isFalse))` bila perlu ketat.
- Jangan menambah aturan baru tanpa memperbarui spesifikasi dan tabel contoh terlebih dahulu.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Memakai `durasi.inMinutes <= 15` | 15 menit 59 detik terhitung gratis | Bandingkan `Duration` langsung atau hitung dari detik |
| `15 * menit` | Galat kompilasi | Tulis `menit * 15` |
| Menghitung jam dengan `~/ 3600` tanpa pembulatan ke atas | 61 menit dihitung 1 jam | Pakai `(detik + 3599) ~/ 3600` |
| Menyimpan uang sebagai `double` | Selisih sen yang misterius | `int` satuan terkecil + kebijakan pembulatan tertulis |
| Lupa menjalankan dengan `--enable-asserts` | Postcondition tak pernah diperiksa | Jalankan juga lewat `dart test`; assert aktif di sana |

### J. Sumber Referensi

- ✔ Pengujian di Dart: https://dart.dev/tools/testing
- ✔ Operator: https://dart.dev/language/operators
- API `Duration`: https://api.dart.dev/stable/dart-core/Duration-class.html
- Paket test: https://pub.dev/packages/test
- ✔ Error handling dan `assert`: https://dart.dev/language/error-handling

---

## Latihan Fase 1 (sengaja tanpa kunci jawaban)

Kerjakan sendiri, jalankan, lalu commit dengan struktur `fase-1/latihan-N/` berisi `README.md` (spesifikasi + tabel contoh), `lib/`, dan `test/`. Setelah itu kirim untuk ditinjau; pada tahap tinjauan, konteks lengkap boleh dibuka.

1. **\[1.1\]** Tulis spesifikasi `apakahPalindrom(String)`: lima pertanyaan, minimal 10 contoh (huruf besar/kecil, spasi, tanda baca, string kosong, satu karakter, karakter non-ASCII), putuskan setiap ambiguitas, baru tulis kode.
2. **\[1.2\]** Buat dua versi `tambahPajak(List<int> harga)`: satu memutasi argumen, satu mengembalikan list baru. Tulis program yang memperlihatkan akibat berbeda bagi pemanggil.
3. **\[1.3\]** Buat trace table manual `fpb(1071, 462)` dan `fpb(0, 5)`, lalu cocokkan dengan `int.gcd`.
4. **\[1.4\]** Enumerasi 8 kombinasi tiga variabel untuk membuktikan `A && (B || C)` setara `(A && B) || (A && C)`. Cari satu pasang kondisi yang *tampak* setara tetapi tidak, dan buktikan dengan tabel.
5. **\[1.5\]** Tambahkan kontrak lengkap (precondition, postcondition, `assert` internal) pada `median(List<int>)`: putuskan perilaku untuk list kosong dan berukuran genap, dokumentasikan, dan tulis satu test per klausul.
6. **\[1.6\]** Binary search: tulis spesifikasi dan invarian, lalu implementasi. Sengaja buat tiga varian off-by-one yang salah dan temukan input terkecil (0, 1, atau 2 elemen) yang memperlihatkan tiap bug.
7. **\[1.7\]** Debug potongan berikut dengan protokol enam langkah; catat hipotesis untuk setiap bug yang kamu temukan:

```dart
double rataRata(List<int> nilai) {
  assert(nilai.isNotEmpty);
  var total = 0;
  for (var i = 0; i <= nilai.length; i++) {
    total += nilai[i];
  }
  return total / nilai.length;
}

bool sama(List<int> a, List<int> b) => a == b;
```

8. **\[1.8\]** Perluas tarif parkir: durasi lebih dari 24 jam dihitung per hari penuh ditambah sisa. Tulis dulu pertanyaan klarifikasi, tabel contoh baru, dan kontrak baru; baru kode dan test. Bonus: tambahkan jenis kendaraan (motor/mobil) dan catat bagian kode mana yang *terpaksa* berubah — itu bahan Fase 2 dan 3.

---

## Ringkasan Fase 1 & Daftar Periksa Kelulusan

| Modul | Satu kalimat inti |
| --- | --- |
| 1.1 | Pahami dan tulis spesifikasi serta tabel contoh sebelum kode. |
| 1.2 | Program adalah rangkaian perubahan state; dorong efek samping ke tepi, jaga inti tetap murni. |
| 1.3 | Belah masalah, beri nama, rencanakan dengan pseudocode, periksa dengan trace table. |
| 1.4 | Kondisi adalah gagasan yang diberi nama; buktikan kesetaraan dengan tabel kebenaran. |
| 1.5 | Kontrak menuntut, menjamin, dan menjaga; pilih alat penegak sesuai jenis kegagalan. |
| 1.6 | Sequence, selection, iteration — dengan guard clause, exhaustiveness, dan invarian loop. |
| 1.7 | Perpendek siklus run → error → debug; amati, jangan menebak. |
| 1.8 | Semua alat bekerja bersama pada satu masalah nyata dengan nilai batas. |

**Daftar periksa kelulusan** (jawab tanpa membuka dokumen):

- [ ] Aku bisa menulis lima pertanyaan spesifikasi dan tabel contoh untuk masalah baru dalam 10 menit.
- [ ] Aku bisa menjelaskan beda `final`, `const`, dan imutabilitas sebenarnya, serta menunjukkan aliasing dengan contoh.
- [ ] Aku bisa membuat trace table untuk loop sembarang dan menemukan bug off-by-one dengannya.
- [ ] Aku bisa membuktikan dua kondisi boolean setara dengan tabel kebenaran, dan menjelaskan short-circuit.
- [ ] Aku tahu kapan memakai `assert`, `ArgumentError`, `StateError`, dan `Exception` — dan mengapa input pengguna tidak divalidasi dengan `assert`.
- [ ] Aku bisa menulis invarian untuk sebuah loop dan menunjukkan loop itu berhenti.
- [ ] Aku menjalankan `dart analyze`, `dart format`, dan `dart test` sebagai kebiasaan, serta menjalankan program dengan `--enable-asserts`.
- [ ] Delapan latihan sudah di-commit beserta test dan tabel contoh.

**Pratinjau Fase 2 — Logika Ekspresi & Aliran Kendali Aman.** Pattern matching mendalam (pola record, objek, list, map), `sealed class` dan exhaustiveness sebagai jaring pengaman desain, null safety sebagai logika (promosi tipe, operator null-aware), serta ekspresi vs statement tingkat lanjut. Prasyaratnya adalah daftar periksa di atas terpenuhi.

---

## Referensi Induk Fase 1

> **Catatan verifikasi.** Tanda ✔ berarti halaman tersebut dibuka dan diverifikasi lewat pencarian saat dokumen ini disusun (12 November 2026). Tautan tanpa tanda adalah halaman resmi atau baku yang stabil, tetapi belum diverifikasi ulang; bila ada yang berpindah, cari judulnya di dart.dev.

**Dokumentasi resmi Dart**

- ✔ Percabangan: https://dart.dev/language/branches
- ✔ Loop: https://dart.dev/language/loops
- ✔ Operator: https://dart.dev/language/operators
- ✔ Error handling dan `assert`: https://dart.dev/language/error-handling
- ✔ Effective Dart: https://dart.dev/effective-dart (juga `/design` dan `/usage`)
- ✔ Analisis statis: https://dart.dev/tools/analysis
- ✔ Pengujian: https://dart.dev/tools/testing
- Variabel: https://dart.dev/language/variables · Fungsi: https://dart.dev/language/functions · Pola: https://dart.dev/language/patterns
- Spesifikasi bahasa Dart: https://spec.dart.dev · Evolusi bahasa: https://github.com/dart-lang/language · DartPad: https://dartpad.dev
- Paket: https://pub.dev/packages/test · https://pub.dev/packages/lints

**Konsep dan teori**

- Teorema program terstruktur: https://en.wikipedia.org/wiki/Structured\_program\_theorem
- Design by contract: https://en.wikipedia.org/wiki/Design\_by\_contract · Hoare logic: https://en.wikipedia.org/wiki/Hoare\_logic
- Loop invariant: https://en.wikipedia.org/wiki/Loop\_invariant · De Morgan: https://en.wikipedia.org/wiki/De\_Morgan%27s\_laws
- Dijkstra, *Go To Statement Considered Harmful*: https://dl.acm.org/doi/10.1145/362929.362947

**Buku bacaan lanjutan (tanpa tautan)**

- G. Pólya, *How to Solve It* — berpikir sistematis tentang masalah.
- B. Meyer, *Object-Oriented Software Construction* — design by contract.
- D. Gries, *The Science of Programming* — penalaran dengan invarian.
- A. Hunt & D. Thomas, *The Pragmatic Programmer* — praktik rekayasa sehari-hari.
- S. McConnell, *Code Complete* — kualitas kode dan pengujian.

---

*Fase 1 selesai. Fase 2 dibuka setelah kamu memberi konfirmasi siap dan, bila ada, menempelkan kurikulum aslimu agar penomoran disinkronkan.*
---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

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

