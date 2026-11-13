# Membangun Logika Dart — Fase 4: Logika di Dalam Fungsi & Class

*Dari logika yang benar menjadi logika yang diletakkan di tempat yang tepat dan dapat dipanggil dengan cara yang tepat: fungsi, closure, class, konstruktor, mixin, extension, dan injeksi dependensi.*

| Atribut | Keterangan |
| --- | --- |
| Level | Intermediate |
| Estimasi waktu | 3 minggu, ±35–45 jam (teori ±30%, praktik ±70%) |
| Prasyarat | Fase 3 selesai (daftar periksa kelulusan terpenuhi, latihan di-commit) |
| Alat esensial | Dart SDK stabil (rilis stabil per 13 November 2026: **3.14**, dirilis 11 November 2026), `dart analyze`, `dart test`, editor pilihan |
| Batas versi fitur | Parameter super: ≥ 2.17 · class modifiers: ≥ 3.0 · extension types: ≥ 3.3 · parameter bernama privat: ≥ 3.12 · sintaks konstruktor ringkas dan primary constructors: ≥ 3.13 |
| Komunitas | https://dart.dev/community · tag `dart` di https://stackoverflow.com/questions/tagged/dart · proposal bahasa di https://github.com/dart-lang/language |
| Sertifikasi | Tidak ada sertifikasi resmi khusus; portofolio repositori dengan test dan tabel contoh lebih bernilai |

**Hasil pembelajaran Fase 4** — setelah fase ini kamu mampu:

1. merancang tanda tangan fungsi (jenis parameter, nilai bawaan, nilai kembali) sebagai kontrak yang membuat salah-panggil sulit;
2. memakai closure, tear-off, dan fungsi tingkat tinggi dengan sadar akan state tersembunyi dan biayanya;
3. menempatkan logika pada class dengan invarian yang terjaga lewat enkapsulasi, getter, setter, dan operator;
4. memilih jenis konstruktor yang tepat (generatif, bernama, factory, redirecting, `const`, primary) untuk tiap cara membuat objek;
5. memilih antara pewarisan, interface, mixin, komposisi, dan extension untuk membagi perilaku;
6. memetakan satu logika ke banyak bentuk pemanggilan, dan memisahkan logika dari dependensinya lewat injeksi.

---

## Daftar Isi Fase 4

<details>
  <summary>📃 Daftar Isi</summary>

- **0. Audit Kurikulum, Koreksi Versi, & Sambungan dari Fase 3**
- **4.1 Fungsi:** parameter, nilai kembali, kontrak panggilan
- **4.2 Fungsi sebagai Nilai:** closure, tear-off, fungsi tingkat tinggi
- **4.3 Class sebagai Pemilik State:** method, getter, setter, operator, static, invarian
- **4.4 Konstruktor:** dari generatif sampai primary
- **4.5 Berbagi Perilaku:** pewarisan, interface, mixin, komposisi
- **4.6 Extension Method & Callable Object**
- **4.7 Satu Logika, Banyak Cara Memanggil** *(TAMBAHAN)*
- **4.8 Studi Kasus Terpadu: To-Do v3** *(TAMBAHAN)*
- **Latihan (tanpa kunci jawaban), Ringkasan, dan Referensi Induk**

</details>

---

## 0. Audit Kurikulum, Koreksi Versi, & Sambungan dari Fase 3

1. **Koreksi versi (penting).** Dart **3.14 dirilis pada 11 November 2026**, dua hari sebelum dokumen ini disusun. Dokumen Fase 1–3 menyebut 3.13.x sebagai rilis stabil terbaru; itu kini usang dan diperbarui ke 3.14. Rilis 3.14 berfokus pada tooling (`dart migrate`, DartPad baru), WebAssembly, dan interop native — **tidak ada perubahan bahasa** yang memengaruhi kode Fase 1–3.
2. **Fitur bahasa terkini yang relevan.** Parameter bernama privat (`this._x` dipanggil sebagai `x:`) sejak 3.12; sintaks konstruktor ringkas (`new(...)`, `new nama(...)`, `factory nama(...)`) dan primary constructors sejak 3.13. Pada 3.13, menulis `final` di depan parameter fungsi *biasa* menjadi galat kompilasi (sebelumnya hanya lint `avoid_final_parameters`); kode Fase 1–3 tidak menulisnya, sedangkan `final` pada parameter *primary constructor* memang sah.
3. **Sambungan.** Fase 1–3 sudah memakai fungsi, class, konstruktor bernama/factory, `sealed`, dan injeksi waktu sebagai parameter. Fase 4 memformalkan *di mana logika diletakkan* dan *dengan berapa cara ia dipanggil* — persis kesenjangan yang membuat logika di dalam class terasa membingungkan.
4. **TAMBAHAN:** modul 4.7 (satu logika, banyak cara memanggil: matriks bentuk pemanggilan) dan 4.8 (studi kasus To-Do v3 dengan class, interface, dan injeksi dependensi). Kurikulum lazim mengajarkan sintaks tiap bentuk secara terpisah tanpa pernah menyandingkannya.
5. **Di luar cakupan, dicatat.** *this promotion* dan *static extensions* masih berstatus pengembangan menurut peta jalan 3.14; belum dipakai di sini. Pewarisan lanjut dan *generics* berat ditunda ke Fase 8.
6. **Tidak ada koreksi substansial** pada materi Fase 1–3 selain versi di atas.

> **Cara memakai dokumen ini** tetap sama: baca, tulis ulang dari ingatan, jalankan, bandingkan. Latihan di akhir tanpa kunci jawaban.

---

## 4.1 Fungsi: Parameter, Nilai Kembali, Kontrak Panggilan

*Motivasi: tanda tangan fungsi adalah kalimat pertama yang dibaca pemanggil — tulislah seolah itu satu-satunya.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas cara merancang **tanda tangan fungsi** sebagai kontrak antara pemanggil dan fungsi: jenis parameter (posisional, opsional, bernama, `required`), nilai bawaan, nilai kembali (satu nilai, record, `void`, `Never`), fungsi satu ekspresi, tipe fungsi dan `typedef`. Tanda tangan adalah API terkecil; keputusan di sini menentukan apakah panggilan yang keliru bahkan bisa ditulis.

### B. Konsep Kunci & Filosofi Mendalam

- **Jenis parameter.** Sebuah fungsi dapat memiliki sejumlah parameter *posisional wajib*, diikuti **parameter bernama** *atau* **parameter posisional opsional** — tidak keduanya. Parameter bernama ditulis dalam `{}` dan bersifat opsional kecuali diberi `required`; posisional opsional ditulis dalam `[]`.
- **Nilai bawaan.** Berupa konstanta waktu-kompilasi. Tanpa nilai bawaan dan tanpa `required`, tipe parameter harus nullable (nilai bawaannya `null`). `required` boleh digabung dengan tipe nullable: pemanggil *wajib menyebut* parameter itu, walau nilainya `null`.
- **Argumen bernama dapat diletakkan di mana saja** dalam daftar argumen, termasuk sebelum argumen posisional.
- **Prinsip desain:** maksimal dua atau tiga parameter posisional; sisanya bernama. **Boolean selalu bernama** (modul 1.8: *boolean trap*). Parameter yang selalu berpasangan sebaiknya digabung menjadi record atau value object (3.3).
- **Nilai kembali.** Satu nilai; beberapa nilai → record (2.5); aksi tanpa hasil → `void`; fungsi yang tak pernah kembali → `Never` (membuat flow analysis tahu bahwa jalur berhenti, 2.3). Kembalikan tipe paling jujur: nullable berarti *tidak ada* (2.2).
- **Fungsi satu ekspresi** `=> ekspresi` untuk fungsi yang memang hanya satu ekspresi (2.1).
- **Tipe fungsi.** `int Function(String)` adalah tipe; `typedef` memberinya nama. Callback opsional bertipe nullable dipanggil dengan `callback?.call(x)`.
- **Parameter `final`.** Sejak Dart 3.13, `final` di depan parameter fungsi biasa adalah galat kompilasi; jangan menulisnya. (Parameter *primary constructor* memakai `final` untuk mendeklarasikan field — itu hal berbeda, 4.4.)
- **Filosofi:** nama dan tipe parameter adalah dokumentasi yang dikompilasi. Bila pemanggil harus membuka definisi untuk memahami panggilan, tanda tangannya kurang baik.
- **Dampak desain:** parameter bernama membuat urutan tak penting dan penambahan parameter baru tidak merusak pemanggil lama; posisional murni menyulitkan evolusi API.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — boolean trap diganti parameter bernama.**

```dart
// BURUK: apa arti true dan false pada pemanggilan?
void kirimEmailBuruk(String tujuan, bool html, bool prioritas) {}

// BAIK: maksud terbaca di titik panggilan.
void kirimEmail(String tujuan, {bool html = false, bool prioritas = false}) {}

void main() {
  // kirimEmailBuruk('a@b.c', true, false);   // true/false apa?
  kirimEmail('a@b.c', html: true);
}
```

- `{bool html = false, ...}` — parameter bernama dengan nilai bawaan konstanta; pemanggil cukup menyebut yang berbeda dari bawaan.
- `html: true` — maksud tertulis di titik panggilan; urutan antar-parameter bernama tak penting.

**Contoh 2 — semua jenis parameter.**

```dart
String salam(String nama, {String sapaan = 'Halo', required bool formal}) =>
    formal ? '$sapaan, Bapak/Ibu $nama' : '$sapaan, $nama';

String sebut(String a, [String? b, String c = '!']) => '$a${b ?? ''}$c';

void ulang(void Function() aksi, {required int kali}) {
  for (var i = 0; i < kali; i++) {
    aksi();
  }
}

void main() {
  assert(salam('Ani', formal: true) == 'Halo, Bapak/Ibu Ani');
  assert(salam('Ani', sapaan: 'Hai', formal: false) == 'Hai, Ani');
  assert(sebut('x') == 'x!');
  assert(sebut('x', 'y') == 'xy!');
  assert(sebut('x', 'y', '?') == 'xy?');
  ulang(kali: 2, () => print('hai')); // argumen bernama boleh di depan
}
```

- `String nama` — posisional wajib. `{... required bool formal}` — bernama wajib: pemanggil tak bisa lupa.
- `[String? b, String c = '!']` — posisional opsional; `b` nullable karena tanpa nilai bawaan, `c` punya bawaan konstanta.
- `ulang(kali: 2, () => ...)` — argumen bernama ditaruh sebelum argumen posisional; sah.
- Satu fungsi tidak boleh mencampur `{}` dan `[]`.

**Contoh 3 — nilai kembali: record, `Never`, dan tipe fungsi.**

```dart
(int, int) bagiBersisa(int a, int b) => (a ~/ b, a % b);

Never gagal(String pesan) => throw StateError(pesan);

int ambil(Map<String, int> m, String kunci) =>
    m[kunci] ?? gagal('kunci $kunci tidak ada');

typedef Penilai = int Function(String);

int total(List<String> data, Penilai nilai, {void Function(int)? padaSelesai}) {
  var jumlah = 0;
  for (final d in data) {
    jumlah += nilai(d);
  }
  padaSelesai?.call(jumlah);
  return jumlah;
}

void main() {
  final (q, r) = bagiBersisa(17, 5);
  assert(q == 3 && r == 2);
  assert(ambil({'a': 1}, 'a') == 1);
  assert(total(['a', 'bb'], (s) => s.length) == 3);
}
```

- `Never gagal(...)` — tak pernah kembali; `m[kunci] ?? gagal(...)` bertipe `int` karena `Never` cocok dengan tipe apa pun.
- `typedef Penilai = int Function(String);` — memberi nama pada tipe fungsi agar tanda tangan lebih pendek.
- `padaSelesai?.call(jumlah)` — memanggil callback hanya bila tidak null.

**Contoh 4 — `final` pada parameter fungsi biasa.**

```dart
// Galat kompilasi sejak Dart 3.13:
// void cekSandi(final String sandi, final int panjangMinimal) {}

void cekSandi(String sandi, int panjangMinimal) {
  if (sandi.length < panjangMinimal) {
    throw ArgumentError.value(sandi.length, 'sandi', 'terlalu pendek');
  }
}
```

- Bila proyek lama masih menulis `final` di parameter, `dart migrate` (Dart 3.14) dapat menghapusnya otomatis sebagai langkah persiapan.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// 1) Objek opsi: bila parameternya banyak dan saling terkait.
class OpsiEmail {
  const OpsiEmail({this.html = false, this.prioritas = false, this.salinan = const []});
  final bool html;
  final bool prioritas;
  final List<String> salinan;
}

void kirimDenganOpsi(String tujuan, {OpsiEmail opsi = const OpsiEmail()}) {}

// 2) Record sebagai parameter: untuk pasangan yang selalu bersama.
double jarak((double, double) a, (double, double) b) =>
    (a.$1 - b.$1).abs() + (a.$2 - b.$2).abs();
```

| Bentuk | Pilih bila | Risiko |
| --- | --- | --- |
| Posisional wajib | 1–2 parameter yang maknanya jelas dari urutan | Urutan tertukar tanpa galat bila tipenya sama |
| Bernama (opsional/wajib) | Parameter ke-3 dan seterusnya, semua `bool` | Panggilan lebih panjang |
| Posisional opsional `[]` | Satu-dua argumen tambahan yang jarang | Tak bisa dicampur dengan bernama |
| Objek opsi | Banyak parameter saling terkait | Satu class tambahan |
| Record | Pasangan yang selalu bersama | Tanpa nama domain bila maknanya penting |

### E. Terminologi Esensial

- **Tanda tangan (signature)** — nama, parameter, dan tipe kembalian sebuah fungsi. **Parameter / argumen** — variabel dalam definisi / nilai pada panggilan.
- **Posisional / bernama / opsional** — cara pengikatan argumen ke parameter. **Nilai bawaan (default)** — nilai bila argumen tak diberikan.
- **Tipe fungsi** — mis. `int Function(String)`. **`typedef`** — nama alias untuk tipe. **`Never`** — tipe tanpa nilai (modul 2.2).
- **Boolean trap** — parameter `bool` posisional yang membuat panggilan tak terbaca.

### F. Visualisasi (ASCII)

```text
 fungsi( posisional wajib , [ posisional opsional ] )     ← bentuk A
 fungsi( posisional wajib , { bernama, required bernama } ) ← bentuk B

  A dan B TIDAK boleh dicampur dalam satu fungsi.
  bernama: urutan bebas, boleh di mana saja dalam daftar argumen.
```

```text
 Butuh parameter ke-3 atau lebih, atau ada bool?
  ├─ ya  → jadikan BERNAMA
  └─ tidak → posisional cukup

 Beberapa parameter selalu berpasangan?
  ├─ ya, dan bermakna domain → value object / class (3.3)
  └─ ya, hanya pasangan sementara → record
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 1.5 (kontrak), 1.8 (boolean trap), 2.2 (nullable dan `Never`), 2.5 (record sebagai nilai kembali), 3.3 (value object).
- **Prasyarat bagi:** 4.2 (fungsi sebagai nilai), 4.4 (konstruktor memakai aturan parameter yang sama). **Dikembangkan di:** Fase 5 (fungsi yang bisa gagal), Fase 8 (fungsi generik).

### H. Tips & Praktik Terbaik

- Beri nama parameter dengan kata benda yang jelas; beri nama fungsi dengan kata kerja yang menjelaskan hasil.
- Gunakan `required` untuk parameter yang tak punya bawaan yang masuk akal; hindari parameter nullable hanya demi "opsional".
- Batasi jumlah parameter; lebih dari lima biasanya tanda bahwa konsepnya perlu dibungkus.
- Gunakan *trailing comma* agar `dart format` menyusun daftar parameter satu per baris.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Parameter `bool` posisional | Panggilan tak terbaca, urutan tertukar | Jadikan bernama dengan nama bermakna |
| Mencampur `{}` dan `[]` | Galat sintaks | Pilih satu bentuk |
| Bawaan bukan konstanta | Galat kompilasi | Gunakan `null` + isi di badan, atau konstanta |
| Parameter bernama tanpa bawaan dan tidak nullable | Galat kompilasi | Beri bawaan, buat nullable, atau tandai `required` |
| Menulis `final` pada parameter fungsi | Galat kompilasi sejak 3.13 | Hapus `final` |
| Mengembalikan `null` untuk menandai error | Pemanggil lupa memeriksa | Pakai exception atau hasil sealed (Fase 5) |

### J. Sumber Referensi

- ✔ Fungsi (parameter, tear-off, closure, nilai kembali): https://dart.dev/language/functions
- ✔ Pengumuman Dart 3.14 (contoh `dart migrate` dan `final` pada parameter): https://dart.dev/blog/announcing-dart-3-14
- ✔ Typedef: https://dart.dev/language/typedefs
- ✔ Effective Dart — desain: https://dart.dev/effective-dart/design
- Lint `avoid_final_parameters`: https://dart.dev/tools/linter-rules/avoid\_final\_parameters

---

## 4.2 Fungsi sebagai Nilai: Closure, Tear-off, Fungsi Tingkat Tinggi

*Motivasi: ketika perilaku bisa dikirim seperti data, banyak pola yang tadinya butuh class berubah menjadi satu baris.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas fungsi sebagai **objek kelas satu**: disimpan di variabel, dikirim sebagai argumen, dikembalikan dari fungsi lain. Kamu belajar **lexical scope**, **closure** (fungsi yang mengingat variabel dari tempat ia dibuat), **tear-off** (merujuk fungsi, method, atau konstruktor tanpa kurung), dan **fungsi tingkat tinggi** (menerima atau mengembalikan fungsi) seperti `map`, `fold`, strategi injeksi, dan memoization.

### B. Konsep Kunci & Filosofi Mendalam

- **Fungsi adalah objek.** Ia punya tipe fungsi, dapat ditugaskan ke variabel, dikirim, dan dikembalikan. Instance sebuah class pun dapat dipanggil seperti fungsi bila punya method `call` (4.6).
- **Lexical scope.** Cakupan variabel ditentukan oleh tata letak kode: "ikuti kurung kurawal ke luar" untuk melihat variabel mana yang terlihat. Fungsi bersarang melihat variabel dari semua tingkat di atasnya.
- **Closure.** Fungsi yang dapat mengakses variabel di lexical scope-nya walaupun dipakai di luar scope itu. Closure menangkap **variabel**, bukan salinan nilai: bila variabel berubah, closure melihat perubahan itu.
- **Per-iterasi pada loop `for`.** Variabel indeks `for (var i ...)` yang ditangkap closure adalah salinan *per iterasi*, sehingga closure yang dibuat di dalam loop masing-masing melihat `i`-nya sendiri.
- **State tersembunyi.** Closure yang mengubah variabel tertangkap membawa state yang tak terlihat dari luar (counter, cache). Praktis untuk hal kecil; untuk state yang perlu nama, pengujian, atau pemeriksaan, pakai class.
- **Fungsi tingkat tinggi.** `map`, `where`, `fold` menerima fungsi; *strategi* diinjeksikan sebagai parameter fungsi; *decorator* (mis. memoize) membungkus fungsi dan mengembalikan fungsi baru.
- **Tear-off.** Merujuk fungsi, method, atau konstruktor tanpa tanda kurung menghasilkan objek fungsi yang *adalah* itu sendiri, bukan pembungkus. Panduan resmi: bila lambda hanya meneruskan argumen persis yang sama ke fungsi bernama, **pakai tear-off**. Tear-off method terikat pada instance-nya (`p.catat`).
- **Kesetaraan fungsi.** Tear-off fungsi tingkat atas dan method static yang sama setara; tear-off method dari *instance yang sama* setara; dari instance berbeda tidak setara.
- **Filosofi:** kirimkan *apa yang harus dilakukan*, bukan *siapa yang melakukannya* — mengurangi kopling.
- **Dampak desain:** closure mengalokasikan objek dan menangkap konteks; di jalur panas ukur dulu (Fase 6). Memoization menukar memori dengan waktu — dan hanya sahih untuk fungsi murni (1.2).

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — closure dengan state terpisah.**

```dart
int Function() buatPencacah() {
  var n = 0; // variabel yang ditangkap closure
  return () => ++n;
}

void main() {
  final a = buatPencacah();
  final b = buatPencacah();
  print(a()); // 1
  print(a()); // 2
  print(b()); // 1  (b punya n sendiri)
}
```

- `int Function() buatPencacah()` — tipe kembalian adalah fungsi tanpa parameter yang mengembalikan `int`.
- `() => ++n` — fungsi anonim yang menaikkan `n` yang berada di scope luar; `n` tetap hidup selama fungsi itu dipegang.
- Setiap pemanggilan `buatPencacah()` membuat `n` baru, sehingga `a` dan `b` independen.

**Contoh 2 — closure menangkap variabel, bukan nilai.**

```dart
void main() {
  var x = 1;
  final baca = () => x;
  x = 2;
  print(baca()); // 2: closure melihat perubahan variabel

  final fungsi = <void Function()>[];
  for (var i = 0; i < 3; i++) {
    fungsi.add(() => print(i));
  }
  for (final f in fungsi) {
    f(); // 0, 1, 2: tiap iterasi punya i sendiri
  }
}
```

- Pada bagian pertama, `x` diubah *setelah* closure dibuat, tetapi closure membaca nilai terkini.
- Pada bagian kedua, `var i` pada `for` ditangkap *per iterasi*, sehingga hasilnya 0, 1, 2 (bukan 3, 3, 3).

**Contoh 3 — fungsi tingkat tinggi: memoize.**

```dart
R Function(A) memo<A, R>(R Function(A) f) {
  final cache = <A, R>{};
  return (a) => cache.putIfAbsent(a, () => f(a));
}

void main() {
  var panggilan = 0;
  final kuadrat = memo<int, int>((x) {
    panggilan++;
    return x * x;
  });
  print(kuadrat(4)); // 16
  print(kuadrat(4)); // 16 (dari cache)
  print(panggilan); // 1
}
```

- `memo<A, R>(R Function(A) f)` — menerima fungsi dan mengembalikan fungsi baru dengan tanda tangan sama; `cache` hidup di dalam closure.
- `putIfAbsent(a, () => f(a))` — hitung hanya bila kunci belum ada.
- Peringatan: hanya untuk fungsi *murni*; cache tanpa batas adalah kebocoran memori yang tertunda — beri batas bila inputnya tak terbatas.

**Contoh 4 — tear-off fungsi, method, dan konstruktor.**

```dart
class Pencatat {
  final List<String> baris = [];
  void catat(String s) => baris.add(s);
}

void main() {
  final p = Pencatat();
  ['a', 'b'].forEach(p.catat); // tear-off method, terikat pada p

  final panjang = ['x', 'yy'].map((s) => s.length).toList(); // lambda: ada transformasi
  final huruf = [65, 66].map(String.fromCharCode).toList(); // tear-off konstruktor bernama
  final buffer = [1, 2].map(StringBuffer.new).toList(); // tear-off konstruktor tak bernama

  print('${p.baris} $panjang $huruf ${buffer.length}'); // [a, b] [1, 2] [A, B] 2
}
```

- `forEach(p.catat)` — meneruskan method itu sendiri; setara dengan lambda pembungkus tetapi tanpa kebisingan.
- `map((s) => s.length)` — lambda tetap tepat karena ada transformasi (bukan sekadar meneruskan argumen).
- `String.fromCharCode` dan `StringBuffer.new` — tear-off konstruktor.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Pencacah sebagai class: state punya nama, bisa diperiksa dan diuji.
class Pencacah {
  int _n = 0;
  int get nilai => _n;
  int naik() => ++_n;
}

// Fungsi lokal bernama: closure yang punya nama (lebih mudah dibaca di stack trace).
int Function() buatPencacahBernama() {
  var n = 0;
  int naik() => ++n;
  return naik;
}
```

| Pilihan | Pilih bila | Risiko |
| --- | --- | --- |
| Lambda anonim | Transformasi sekali pakai | Sulit dibaca bila panjang; tanpa nama di stack trace |
| Tear-off | Hanya meneruskan argumen ke fungsi/method/konstruktor | Salah paham soal pengikatan instance |
| Fungsi lokal bernama | Closure yang cukup panjang | Tetap menyimpan state tersembunyi |
| Class dengan state | State perlu nama, pemeriksaan, atau banyak operasi | Lebih banyak kode |

### E. Terminologi Esensial

- **Objek kelas satu (first-class)** — dapat disimpan, dikirim, dikembalikan. **Lexical scope** — cakupan variabel ditentukan oleh tata letak kode.
- **Closure** — fungsi beserta lingkungan variabel yang ditangkapnya. **Lambda / fungsi anonim** — fungsi tanpa nama.
- **Fungsi tingkat tinggi** — menerima/mengembalikan fungsi. **Tear-off** — referensi ke fungsi/method/konstruktor tanpa kurung.
- **Memoization** — menyimpan hasil fungsi murni per masukan. **Decorator** — fungsi yang membungkus fungsi lain.

### F. Visualisasi (ASCII)

```text
 buatPencacah() dipanggil

   lingkungan:  n = 0  ◄───────┐
                               │ menunjuk
   fungsi:  () => ++n  ─────────┘     ← dikembalikan; n tetap hidup

   a = buatPencacah()  →  lingkungan A (n_A)
   b = buatPencacah()  →  lingkungan B (n_B)      (saling independen)
```

```text
 for (var i = 0; i < 3; i++) { fungsi.add(() => print(i)); }

   iterasi 0:  i₀ = 0  ← closure₀
   iterasi 1:  i₁ = 1  ← closure₁          tiap iterasi: variabel baru
   iterasi 2:  i₂ = 2  ← closure₂
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 4.1 (tipe fungsi dan parameter), 1.2 (kemurnian dan state), 3.2 (imutabilitas).
- **Prasyarat bagi:** 4.6 (callable object), 4.7 (matriks pemanggilan), 4.8 (injeksi fungsi sebagai dependensi). **Dikembangkan di:** Fase 6 (biaya closure dan memoization), Fase 7 (callback asinkron, `Future`).

### H. Tips & Praktik Terbaik

- Pilih tear-off dibanding lambda pembungkus yang hanya meneruskan argumen.
- Jaga closure tetap pendek; bila perlu nama atau komentar, jadikan fungsi bernama.
- Hindari closure yang mengubah variabel luar secara tersembunyi bila state itu penting bagi logika; jadikan state eksplisit.
- Beri batas pada cache memoize bila domain input tak terbatas.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mengira closure menangkap nilai | Closure membaca nilai terbaru yang tak terduga | Salin ke `final` lokal bila perlu nilai pada saat itu |
| Memoize fungsi yang tidak murni | Hasil basi atau salah | Hanya memoize fungsi murni |
| Cache tanpa batas | Memori terus bertambah | Batasi ukuran atau pakai kebijakan buang |
| Lambda pembungkus yang tak perlu | Kebisingan kode | Pakai tear-off |
| Membandingkan lambda dengan `==` | Selalu tak setara | Bandingkan tear-off atau gunakan objek bernama |
| State penting tersembunyi di closure | Sulit dites dan diperiksa | Pindahkan ke class |

### J. Sumber Referensi

- ✔ Fungsi (lexical scope, closure, tear-off, kesetaraan fungsi): https://dart.dev/language/functions
- ✔ Konstruktor (tear-off konstruktor): https://dart.dev/language/constructors
- Effective Dart — penggunaan: https://dart.dev/effective-dart/usage
- API `Function`: https://api.dart.dev/stable/dart-core/Function-class.html
- Closure (konsep umum): https://en.wikipedia.org/wiki/Closure\_(computer\_programming)

---

## 4.3 Class sebagai Pemilik State: Method, Getter, Setter, Operator, Static, Invarian

*Motivasi: class bukan wadah fungsi — ia adalah penjaga gerbang bagi state yang tak boleh rusak.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini menjawab pertanyaan *kapan logika masuk ke dalam class dan bagaimana ia ditulis di sana*: **method** (perilaku yang butuh state), **getter** dan **setter** (properti terhitung dan tervalidasi), **operator** (untuk tipe nilai), **member static** (milik class, bukan instance), `toString`, serta **enkapsulasi** dan **invarian** objek. Inilah tempat konsep kontrak (1.5), imutabilitas (3.2), dan value object (3.3) bertemu dengan sintaks class.

### B. Konsep Kunci & Filosofi Mendalam

- **Kapan memakai class.** Pakai class bila ada *state yang harus dijaga lewat operasi terbatas* (invarian), bila perlu *polimorfisme*, atau bila objek punya *identitas* yang berubah dari waktu ke waktu. Bila yang ada hanya fungsi murni atas data, cukup fungsi tingkat atas + value object/record.
- **Pedoman desain.** Hindari class yang hanya berisi member static (pakai fungsi tingkat atas), dan hindari class abstrak berisi satu method bila sebuah fungsi sudah cukup (Effective Dart, bagian desain).
- **Privasi di Dart berlaku per library, bukan per class.** Awalan `_` membuat anggota privat bagi *library* (biasanya satu file). Akibatnya, kode lain di file yang sama dapat melihat anggota privat; susun kelas yang saling bergantung dengan sadar akan itu.
- **Method vs getter vs field.** *Field* menyimpan nilai. *Getter* untuk nilai **terhitung**, murah (idealnya O(1)), dan tanpa efek samping. *Method* untuk pekerjaan yang mahal, berefek, atau menerima argumen. *Setter* hanya bila memang ingin sintaks penugasan dengan validasi; bila ada efek atau keterkaitan rumit, method bernama (`ubahX`) lebih jujur.
- **Operator** (`+`, `-`, `*`, `[]`, `==`, ...) dapat didefinisikan ulang; pakai untuk *tipe nilai yang maknanya jelas* (vektor, uang), jangan untuk kenyamanan sesaat.
- **Member static** milik class: tak punya `this`, dipanggil lewat nama class. Konstanta `static const` dan pembuat bernama cocok; *state static yang berubah* adalah state global tersembunyi (modul 1.2) dan menyulitkan test.
- **`toString`.** Timpa agar objek terbaca di log dan test yang gagal; sertakan field yang menentukan identitas logis.
- **Invarian objek** dijaga di dua tempat: konstruktor (objek sah sejak lahir) dan setiap method yang mengubah state. Field privat + akses lewat method adalah mekanismenya; getter read-only (atau view, 3.4) mengekspos tanpa membuka mutasi.
- **Mutabel vs imutabel.** *Entitas* yang berubah dengan identitas tetap (rekening, sesi) boleh mutabel dengan enkapsulasi; *nilai* (titik, uang, vektor) imutabel (3.2).
- **Filosofi:** class adalah *kontrak perilaku di sekitar state*; field publik mutabel hampir selalu berarti kontrak itu bocor.
- **Dampak desain:** getter yang diam-diam mahal menyembunyikan biaya di balik sintaks yang tampak murah; setter yang melakukan terlalu banyak membuat urutan penugasan bermakna.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — entitas bermutasi dengan invarian terjaga.**

```dart
class SaldoTidakCukup implements Exception {
  SaldoTidakCukup(this.diminta, this.tersedia);
  final int diminta;
  final int tersedia;

  @override
  String toString() => 'SaldoTidakCukup(diminta: $diminta, tersedia: $tersedia)';
}

class Rekening {
  Rekening(this.pemilik, {int saldoAwal = 0}) : _saldo = saldoAwal {
    if (saldoAwal < 0) {
      throw ArgumentError.value(saldoAwal, 'saldoAwal', 'tidak boleh negatif');
    }
  }

  final String pemilik;
  int _saldo; // privat: hanya lewat setor dan tarik yang menjaga invarian

  int get saldo => _saldo;
  bool get kosong => _saldo == 0;

  void setor(int jumlah) {
    if (jumlah <= 0) throw ArgumentError.value(jumlah, 'jumlah', 'harus positif');
    _saldo += jumlah;
  }

  void tarik(int jumlah) {
    if (jumlah <= 0) throw ArgumentError.value(jumlah, 'jumlah', 'harus positif');
    if (jumlah > _saldo) throw SaldoTidakCukup(jumlah, _saldo);
    _saldo -= jumlah;
    assert(_saldo >= 0, 'invarian dilanggar: saldo negatif');
  }

  @override
  String toString() => 'Rekening($pemilik, saldo: $_saldo)';
}

void main() {
  final r = Rekening('Ani', saldoAwal: 1000);
  r.setor(500);
  r.tarik(300);
  assert(r.saldo == 1200);
  print(r); // Rekening(Ani, saldo: 1200)
}
```

- `_saldo` privat dan non-final: hanya `setor` dan `tarik` yang boleh mengubahnya, sehingga invarian *saldo tak pernah negatif* ada di satu tempat.
- `int get saldo => _saldo;` — getter read-only: pemanggil bisa membaca tetapi tidak menulis.
- Konstruktor memvalidasi `saldoAwal` di badan; kegagalan kontrak = `ArgumentError`, kegagalan domain = `SaldoTidakCukup` (modul 1.5).
- `toString` memudahkan debugging.

**Contoh 2 — getter untuk nilai terhitung, method untuk pekerjaan.**

```dart
import 'dart:math' as math;

class Lingkaran {
  const Lingkaran(this.jariJari);
  final double jariJari;

  double get luas => math.pi * jariJari * jariJari; // murah, tanpa efek: getter
  double get keliling => 2 * math.pi * jariJari;

  /// Menghasilkan Lingkaran BARU (imutabel); bukan getter karena menerima argumen.
  Lingkaran skala(double faktor) => Lingkaran(jariJari * faktor);
}
```

- `luas` dan `keliling` tidak disimpan sebagai field: menyimpan nilai turunan membuka peluang field tak sinkron dengan `jariJari`.
- `skala` menerima argumen dan mengembalikan objek baru, jadi method (modul 3.2).

**Contoh 3 — operator pada tipe nilai.**

```dart
import 'package:meta/meta.dart';

@immutable
class Vektor {
  const Vektor(this.x, this.y);
  final double x;
  final double y;

  Vektor operator +(Vektor lain) => Vektor(x + lain.x, y + lain.y);
  Vektor operator -(Vektor lain) => Vektor(x - lain.x, y - lain.y);
  Vektor operator *(double faktor) => Vektor(x * faktor, y * faktor);
  Vektor operator -() => Vektor(-x, -y);

  @override
  bool operator ==(Object other) =>
      other is Vektor && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Vektor($x, $y)';
}

void main() {
  const a = Vektor(1, 2);
  const b = Vektor(3, 4);
  assert(a + b == const Vektor(4, 6));
  assert(b - a == const Vektor(2, 2));
  assert(a * 2 == const Vektor(2, 4));
  assert(-a == const Vektor(-1, -2));
}
```

- `operator +(Vektor lain)` — mendefinisikan arti `a + b`; hasilnya objek baru, selaras dengan imutabilitas.
- `operator -()` tanpa parameter — operator unari (`-a`); `operator -(Vektor lain)` — biner (`a - b`).
- `==` dan `hashCode` mengikuti kontrak 3.1.

**Contoh 4 — member static: konstanta bernama dan pembuat.**

```dart
class Suhu {
  const Suhu._(this.celsius);
  factory Suhu.celsius(double c) => Suhu._(c);
  factory Suhu.fahrenheit(double f) => Suhu._((f - 32) * 5 / 9);

  static const Suhu titikBeku = Suhu._(0);
  static const Suhu titikDidih = Suhu._(100);

  final double celsius;
  double get fahrenheit => celsius * 9 / 5 + 32;
}

void main() {
  assert(Suhu.titikDidih.fahrenheit == 212);
  assert(Suhu.fahrenheit(32).celsius == 0);
}
```

- `static const Suhu titikBeku` — konstanta milik class, dipakai `Suhu.titikBeku` tanpa instance.
- Konstruktor privat `Suhu._` + dua factory: pemanggil memilih satuan lewat nama yang jelas, dan semua jalan melewati satu konstruktor utama.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Anti-pola: class yang hanya berisi static. Lebih baik fungsi tingkat atas.
class KonversiBuruk {
  KonversiBuruk._();
  static double kmKeMil(double km) => km * 0.621371;
}

// Lebih baik:
double kmKeMil(double km) => km * 0.621371;
```

| Bentuk | Pilih bila | Risiko |
| --- | --- | --- |
| Fungsi tingkat atas + value object | Logika murni atas data | Kurang cocok bila ada state yang harus dijaga |
| Class mutabel terenkapsulasi | Entitas dengan identitas dan invarian | Aliasing dan urutan pemanggilan |
| Class imutabel | Nilai: titik, uang, vektor | Biaya salinan pada pembaruan sering |
| Getter | Nilai terhitung murah tanpa efek | Biaya tersembunyi bila berat |
| Method | Pekerjaan mahal, berefek, atau berargumen | Sintaks lebih panjang |
| `static` | Konstanta dan pembuat bernama | State static yang berubah = global tersembunyi |

### E. Terminologi Esensial

- **Enkapsulasi** — menyembunyikan state di balik operasi yang menjaga invarian. **Invarian** — pernyataan yang selalu benar tentang objek.
- **Getter / setter** — properti baca / tulis yang dihitung. **Overloading operator** — mendefinisikan arti operator untuk tipe sendiri.
- **Member instance / static** — milik objek / milik class. **Privasi per library** — `_` berlaku untuk seluruh library, bukan per class.
- **Entitas / value object** — objek berdasar identitas / berdasar nilai.

### F. Visualisasi (ASCII)

```text
          pemanggil
              │  setor(500) · tarik(300) · saldo  (satu-satunya pintu)
              ▼
   ┌─────────────────────────────────┐
   │  Rekening                       │
   │   ├─ pemilik   (final, publik)  │
   │   ├─ _saldo    (privat) ◄───────┼── hanya diubah di sini
   │   └─ invarian: _saldo >= 0      │      (dijaga di tiap method pengubah)
   └─────────────────────────────────┘
```

```text
 Apakah ini perlu class?
  ├─ ada state yang harus dijaga lewat operasi terbatas?   ─ ya ─► class (entitas)
  ├─ ini nilai (setara bila isinya sama)?                  ─ ya ─► class imutabel / record
  ├─ hanya fungsi murni atas data?                          ─ ya ─► fungsi tingkat atas
  └─ hanya kumpulan konstanta/pembuat?                      ─ ya ─► static const / factory
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 1.5 (kontrak dan invarian), 3.1–3.3 (kesetaraan, imutabilitas, value object), 3.4 (view untuk mengekspos koleksi).
- **Prasyarat bagi:** 4.4 (konstruktor), 4.5 (pewarisan dan komposisi), 4.8 (studi kasus). **Dikembangkan di:** Fase 5 (kegagalan dan pemulihan pada method), Fase 11 (batas modul dan visibilitas library).

### H. Tips & Praktik Terbaik

- Mulai dari field privat dan `final`; buka akses hanya bila ada alasan, dan lewat method yang menjaga invarian.
- Jadikan getter murni dan murah; bila mahal, ubah menjadi method agar biayanya terlihat.
- Hindari setter yang berefek samping kompleks; pakai method bernama dengan kontrak yang jelas.
- Tulis `toString` untuk setiap kelas yang akan muncul di log atau pesan test.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Field publik mutabel | Invarian dilanggar dari mana pun | Privatkan; ekspos lewat getter dan method |
| Getter yang mahal atau berefek | Biaya dan perilaku tak terduga | Jadikan method |
| Menyimpan nilai turunan sebagai field | Field tak sinkron dengan sumbernya | Hitung lewat getter |
| Kelas berisi hanya static | Boilerplate dan namespace tiruan | Fungsi tingkat atas |
| Mengandalkan privasi per class | Kode lain di file sama mengakses anggota privat | Pisahkan file/library atau terima konsekuensinya |
| State static yang berubah | Test saling mengganggu | Injeksikan dependensi (4.7) |

### J. Sumber Referensi

- Class: https://dart.dev/language/classes
- Method (getter, setter, operator, static, abstract): https://dart.dev/language/methods
- ✔ Effective Dart — desain: https://dart.dev/effective-dart/design
- ✔ Konstruktor: https://dart.dev/language/constructors
- Dart keywords dan modifier: https://dart.dev/language/keywords

---

## 4.4 Konstruktor: dari Generatif sampai Primary

*Motivasi: konstruktor adalah pintu masuk — objek yang lahir sah tidak perlu diperiksa lagi seumur hidupnya.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini memetakan *semua* cara membuat objek di Dart: konstruktor **generatif** (default, bernama, redirecting, `const`), **factory** (pembatasan, cache, subtipe, validasi), **initializer list**, **initializing formal parameters**, **super parameters**, **parameter bernama privat** (3.12), **sintaks konstruktor ringkas** (3.13), dan **primary constructors** (3.13), serta **tear-off konstruktor**. Tujuannya satu: semua jalan menuju objek harus melewati titik yang menjaga invarian.

### B. Konsep Kunci & Filosofi Mendalam

- **Generatif:** membuat instance baru dan menginisialisasi variabel instance. **Default:** bila tak ada konstruktor yang dideklarasikan, Dart menyediakan generatif tanpa argumen dan tanpa nama.
- **Bernama:** beberapa konstruktor untuk satu class, atau penjelasan maksud (`Titik.pusat()`). **Konstruktor tidak diwariskan** — subclass harus mendeklarasikan sendiri.
- **`const`:** objek konstanta waktu-kompilasi; semua field `final`. Konstruktor `const` tidak selalu menghasilkan konstanta — bila dipanggil di konteks non-`const`, ia membuat objek biasa.
- **Redirecting:** badan kosong, meneruskan ke konstruktor lain di class yang sama dengan `: this(...)`.
- **Factory:** dipakai bila konstruktor *tidak selalu membuat instance baru* (mengembalikan instance dari cache atau subtipe) atau perlu *kerja non-trivial* sebelum membuat (memeriksa argumen). Factory **tidak dapat mengakses `this`** dan tidak dapat mengembalikan `null`. **Redirecting factory:** `factory X.y() = Z;` meneruskan ke konstruktor class lain tanpa mengulang parameter.
- **Initializing formal parameters:** `this.x` di daftar parameter langsung mengisi field; field-nya otomatis `final` dalam cakupan inisialisasi; dapat bernama dan punya nilai bawaan. Bagian-bagian yang **tidak dapat mengakses `this`**: factory, sisi kanan initializer list, dan argumen ke konstruktor superclass.
- **Initializer list:** diawali `:` sebelum badan; memisahkan inisialisasi dengan koma; cocok untuk field `final` dan `assert` saat pengembangan. **Urutan eksekusi:** initializer list → konstruktor superclass → badan konstruktor. Karena itu `this` baru boleh dipakai di badan.
- **Super parameters (≥ 2.17):** `Vector3d(super.x, super.y, this.z)` meneruskan parameter ke konstruktor superclass; tidak dapat dipakai pada konstruktor redirecting, dan bila pemanggilan super sudah memakai argumen posisional, super parameter tak boleh posisional.
- **Parameter bernama privat (≥ 3.12):** `Point({required this._x})` mengisi field privat `_x` langsung dari parameter; pemanggil memakai nama publik `x:`. Hanya berlaku pada *initializing formals*; nama publiknya harus valid dan tidak bentrok. Di initializer list, rujuk dengan nama privat.
- **Sintaks ringkas (≥ 3.13):** nama class boleh dihilangkan memakai modifier `new` atau `factory` langsung: `new(this.x, this.y);`, `new pusat() : x = 0, y = 0;`, `factory dari(Titik t) => ...;`. Berbeda dari konstruktor bernama tradisional, tidak ada titik di antara kata kunci dan nama.
- **Primary constructors (≥ 3.13):** daftar parameter di kepala class, mis. `class const Titik(final int x, final int y);` (modul 3.3).
- **Tear-off konstruktor:** `StringBuffer.new`, `String.fromCharCode` sebagai fungsi (4.2).
- **Filosofi:** *satu konstruktor utama yang menjaga invarian*, sisanya mengarah kepadanya (redirecting/factory). Dengan begitu invarian tidak bisa dilewati lewat jalur lain.
- **Dampak desain:** terlalu banyak konstruktor bernama yang masing-masing menginisialisasi sendiri memperbanyak tempat invarian bisa bocor.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — jenis konstruktor dalam satu class.**

```dart
import 'dart:math' as math;

class Titik {
  const Titik(this.x, this.y); // generatif + const + initializing formals
  const Titik.pusat() : this(0, 0); // redirecting + bernama

  Titik.dariPolar(double r, double sudut) // bernama + initializer list
      : x = r * math.cos(sudut),
        y = r * math.sin(sudut);

  factory Titik.dariJson(Map<String, Object?> json) {
    final x = json['x'];
    final y = json['y'];
    if (x is num && y is num) return Titik(x.toDouble(), y.toDouble());
    throw FormatException('json titik tidak valid', json);
  }

  final double x;
  final double y;
}

void main() {
  const a = Titik(1, 2);
  const b = Titik.pusat();
  final c = Titik.dariPolar(1, 0);
  final d = Titik.dariJson({'x': 3, 'y': 4.5});
  print('${a.x},${a.y} ${b.x},${b.y} ${c.x},${c.y} ${d.x},${d.y}');
}
```

- `const Titik.pusat() : this(0, 0);` — redirecting: tidak mengulang logika, hanya mengarahkan ke konstruktor utama.
- `Titik.dariPolar(...) : x = ..., y = ...` — nilai `final` dihitung di initializer list sebelum badan.
- `factory Titik.dariJson(...)` — melakukan pemeriksaan tipe (`x is num && y is num`) sebelum membuat; bila gagal, melempar `FormatException`. Setelah pemeriksaan, `x` dan `y` terpromosi menjadi `num` (modul 2.3).

**Contoh 2 — factory memilih subtipe.**

```dart
sealed class Pembayaran {
  const Pembayaran();

  factory Pembayaran.dariKode(String kode) => switch (kode) {
        'TUNAI' => const Tunai(),
        'KARTU' => const Kartu(),
        _ => throw ArgumentError.value(kode, 'kode', 'kode pembayaran tak dikenal'),
      };
}

class Tunai extends Pembayaran {
  const Tunai();
}

class Kartu extends Pembayaran {
  const Kartu();
}

void main() {
  assert(Pembayaran.dariKode('TUNAI') is Tunai);
  assert(Pembayaran.dariKode('KARTU') is Kartu);
}
```

- Factory di class dasar mengembalikan *subtipe yang berbeda* — sesuatu yang tak bisa dilakukan konstruktor generatif.
- Pemanggil tak perlu tahu class konkret; `Pembayaran` tetap `sealed` sehingga `switch` atasnya lengkap (2.6).

**Contoh 3 — initializer list, `assert`, dan urutan inisialisasi.**

```dart
class Rentang {
  Rentang(int awal, int akhir)
      : assert(awal <= akhir, 'awal harus <= akhir'),
        awal = awal,
        akhir = akhir,
        panjang = akhir - awal;

  final int awal;
  final int akhir;
  final int panjang;
}
```

- Di initializer list, `awal = awal` berarti *field = parameter*; sisi kanan merujuk ke parameter.
- `assert` hanya aktif saat pengembangan (modul 1.5); untuk masukan dari luar, validasi eksplisit di badan atau factory.
- Menyimpan `panjang` sebagai field duplikat berisiko tak sinkron bila kelas nanti dibuat mutabel; getter `int get panjang => akhir - awal;` menghindarinya.

**Contoh 4 — super parameters, parameter bernama privat (3.12), dan sintaks ringkas (3.13).**

```dart
class Kendaraan {
  Kendaraan(this.nama, {required this.roda});
  final String nama;
  final int roda;
}

class Mobil extends Kendaraan {
  Mobil(super.nama, {this.pintu = 4}) : super(roda: 4);
  final int pintu;
}

// Dart >= 3.12: parameter bernama privat; pemanggil memakai nama publik.
class Dompet {
  Dompet({required this._saldo, this._mataUang = 'IDR'}) : assert(_saldo >= 0);
  final int _saldo;
  final String _mataUang;

  int get saldo => _saldo;
  String get mataUang => _mataUang;
}

// Dart >= 3.13: sintaks konstruktor ringkas.
class Titik3 {
  final double x;
  final double y;

  new(this.x, this.y); // setara: Titik3(this.x, this.y);
  new pusat() : x = 0, y = 0; // setara: Titik3.pusat() : ...
  factory dari(Titik3 lain) => Titik3(lain.x, lain.y); // setara: factory Titik3.dari(...)
}

void main() {
  final m = Mobil('Avanza');
  print('${m.nama} ${m.roda} ${m.pintu}'); // Avanza 4 4
  final d = Dompet(saldo: 5000); // bukan _saldo: nama publik
  print('${d.saldo} ${d.mataUang}'); // 5000 IDR
  print(Titik3.pusat().x); // 0.0
}
```

- `Mobil(super.nama, {this.pintu = 4}) : super(roda: 4);` — `nama` diteruskan ke superclass tanpa menuliskannya ulang; `roda` diberikan sebagai argumen bernama pada pemanggilan super (karena pemanggilan itu tidak memakai argumen posisional, super parameter posisional tetap sah).
- `this._saldo` pada parameter bernama: kompilator menghapus garis bawah untuk pemanggil — `Dompet(saldo: 5000)`. Di initializer list tetap `_saldo`.
- `new(this.x, this.y);` dan `new pusat()` — class name dihilangkan; hasilnya sama persis dengan konstruktor tradisional.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Static factory method: alternatif factory constructor.
class Persen {
  const Persen._(this.nilai);
  final int nilai;

  static Persen? coba(int n) => (n >= 0 && n <= 100) ? Persen._(n) : null;
  factory Persen(int n) =>
      coba(n) ?? (throw RangeError.range(n, 0, 100, 'n'));
}
```

| Pilihan | Kelebihan | Kekurangan |
| --- | --- | --- |
| Konstruktor generatif | Paling sederhana; mendukung `const` | Tak bisa mengembalikan subtipe atau null |
| Konstruktor bernama | Menjelaskan maksud; banyak jalur | Tidak diwariskan; invarian bisa bocor bila tiap jalur menginisialisasi sendiri |
| Factory constructor | Cache, subtipe, validasi non-trivial | Tak ada akses `this`; tak bisa mengembalikan `null` |
| Static method (`coba`) | Boleh mengembalikan `null` atau `Hasil` | Pemanggilan bukan `new`-style; tak bisa `const` |
| Redirecting | Mengarah ke satu konstruktor utama | Hanya dalam class yang sama |
| Primary constructor (≥ 3.13) | Deklarasi paling ringkas | Tak ada semantik nilai otomatis |

### E. Terminologi Esensial

- **Konstruktor generatif / factory** — membuat instance baru dan menginisialisasinya / dapat mengembalikan instance lain atau subtipe. **Redirecting** — meneruskan ke konstruktor lain.
- **Initializer list** — bagian setelah `:` yang dijalankan sebelum badan. **Initializing formal parameter** — `this.x` pada daftar parameter.
- **Super parameter** — `super.x` yang meneruskan ke superclass. **Parameter bernama privat** — `this._x` yang tampil publik sebagai `x:` (3.12).
- **Primary constructor** — konstruktor di kepala class (3.13). **Tear-off konstruktor** — konstruktor sebagai fungsi.

### F. Visualisasi (ASCII)

```text
 Titik.dariPolar(r, sudut)  dipanggil

   1. initializer list    : x = ..., y = ...      (this BELUM boleh dipakai)
   2. konstruktor super   : Object()
   3. badan konstruktor   : { ... }               (this boleh dipakai di sini)
```

```text
   Jenis konstruktor
   ├── generatif
   │     ├── default        (tanpa nama, tanpa argumen; otomatis bila tak ada deklarasi)
   │     ├── bernama        Titik.pusat()
   │     ├── redirecting    : this(0, 0)
   │     └── const          const Titik(this.x, this.y)
   ├── factory
   │     ├── biasa          cache / subtipe / validasi
   │     └── redirecting    factory X.y() = Z;
   └── ringkas (≥ 3.13)     new(...)  new nama(...)  factory nama(...)
       primary (≥ 3.13)     class const Titik(final int x, final int y);
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 4.1 (aturan parameter), 3.3 dan 3.5 (value object dan smart constructor), 1.5 (kontrak), 2.3 (promosi tipe di factory).
- **Prasyarat bagi:** 4.5 (super parameters dan pewarisan), 4.8 (studi kasus). **Dikembangkan di:** Fase 5 (factory yang mengembalikan hasil), Fase 8 (konstruktor generik), Fase 9 (parse di batas kepercayaan lewat factory).

### H. Tips & Praktik Terbaik

- Tentukan satu konstruktor utama yang menjaga invarian; konstruktor lain mengarah kepadanya.
- Jadikan konstruktor `const` bila semua field `final` dan nilainya dapat diketahui saat kompilasi.
- Pakai factory untuk validasi, cache, atau memilih subtipe; pakai konstruktor bernama untuk menjelaskan maksud.
- Gunakan `assert` di initializer list untuk invarian pengembangan, bukan untuk masukan dari luar.
- Pilih sintaks ringkas/primary (≥ 3.13) hanya bila batas bawah SDK-mu mendukungnya.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mengakses `this` di initializer list atau factory | Galat kompilasi | Pindahkan ke badan konstruktor atau hitung dari parameter |
| Mengharap konstruktor bernama diwariskan | `Mobil.pusat()` tak ada | Deklarasikan ulang di subclass |
| Banyak konstruktor yang menginisialisasi sendiri | Invarian bocor lewat jalur tertentu | Arahkan semua ke satu konstruktor utama |
| Factory mencoba `return null` | Galat kompilasi | Pakai static method yang mengembalikan nullable |
| Super parameter posisional bersama argumen posisional pada `super(...)` | Galat kompilasi | Pakai salah satu |
| Menulis `this._x` bernama pada SDK < 3.12 | Galat kompilasi | Naikkan batas bawah SDK atau tulis initializer list manual |

### J. Sumber Referensi

- ✔ Konstruktor (semua jenis, sintaks ringkas, parameter bernama privat, super parameters): https://dart.dev/language/constructors
- ✔ Primary constructors: https://dart.dev/language/primary-constructors
- ✔ Pengumuman Dart 3.13: https://dart.dev/blog/announcing-dart-3-13
- ✔ Pengumuman Dart 3.14: https://dart.dev/blog/announcing-dart-3-14
- Versi bahasa: https://dart.dev/language/versioning
- Effective Dart — desain: https://dart.dev/effective-dart/design

---

## 4.5 Berbagi Perilaku: Pewarisan, Interface, Mixin, Komposisi

*Motivasi: setiap hubungan antar-class adalah ikatan — pilih yang paling longgar yang masih memenuhi kebutuhan.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membandingkan empat cara membagi perilaku antar class: **pewarisan** (`extends`), **interface** (`implements`), **mixin** (`with`), dan **komposisi** (menyimpan objek lain sebagai bagian). Termasuk di sini *class modifiers* (`abstract`, `interface`, `base`, `final`, `sealed`, `mixin`) yang mengatur siapa boleh mewarisi atau mengimplementasi, serta pola **strategi** dan **template method**. Pilihan di sini menentukan seberapa kuat class-mu terikat satu sama lain.

### B. Konsep Kunci & Filosofi Mendalam

- **Pewarisan (`extends`):** hubungan *is-a* yang sekaligus *mewarisi implementasi*. Hanya satu superclass. Subclass bergantung pada detail implementasi superclass (*fragile base class*): perubahan di atas dapat merusak yang di bawah. Konstruktor tidak diwariskan (4.4).
- **Prinsip substitusi (Liskov):** subclass harus dapat dipakai di mana pun superclass dipakai *tanpa melanggar kontrak* (1.5). Override yang memperketat precondition atau melonggarkan postcondition melanggar prinsip ini.
- **Interface (`implements`):** setiap class di Dart adalah interface implisit; `implements` hanya mewarisi *kontrak*, bukan implementasi, dan *semua* anggotanya harus diimplementasikan. Kopling lebih longgar dibanding pewarisan.
- **Mixin (`with`):** menggunakan ulang *implementasi* di beberapa hierarki tanpa menjadi superclass. Mixin tidak boleh punya `extends` atau konstruktor generatif. Mixin dapat mendeklarasikan anggota abstrak yang *wajib* disediakan class pemakainya. Klausa `on` hanya diperlukan bila mixin perlu memanggil `super`.
- **Linearisasi mixin:** `class AB extends P with A, B` menumpuk `A` lalu `B` di atas `P`; bila `A` dan `B` punya method bernama sama, **yang terakhir (B) menang**. Urutan penulisan adalah bagian dari logika. `mixin class` adalah deklarasi yang dapat dipakai sebagai class biasa *dan* sebagai mixin.
- **Class modifiers (Dart ≥ 3.0):** `abstract` (tak dapat diinstansiasi), `interface` (boleh diimplementasi, tak boleh di-extend di luar library), `base` (boleh di-extend, tak boleh diimplementasi di luar library), `final` (tak boleh di-extend maupun diimplementasi di luar library), `sealed` (tertutup dan exhaustive, 2.6). `abstract interface class` adalah antarmuka murni.
- **Komposisi (*has-a*):** class menyimpan objek lain dan *mendelegasikan* kepadanya. Lebih fleksibel: perilaku dapat diganti saat runtime dan tak membentuk hierarki dalam. Prinsip umum: *utamakan komposisi dan interface; pakai pewarisan hanya untuk hubungan is-a yang sungguh stabil.*
- **Strategi vs template method:** *strategi* menginjeksikan perilaku sebagai objek/fungsi (komposisi); *template method* membiarkan superclass mengatur langkah dan subclass mengisi sebagian (pewarisan).
- **Menutup warisan yang tak dirancang.** Beri `final`, `sealed`, atau `interface` pada class yang tak dirancang untuk diwarisi; itu mencegah pelanggan merusak invariannya.
- **Filosofi:** semakin sedikit yang dibagi, semakin sedikit yang bisa saling merusak.
- **Dampak desain:** pewarisan = kopling kuat; interface = kopling kontrak; mixin = kopling urutan; komposisi = kopling lewat antarmuka kecil yang bisa diganti.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — interface, implementasi, dan dekorator lewat komposisi.**

```dart
abstract interface class Penyimpan {
  void simpan(String kunci, String nilai);
  String? baca(String kunci);
}

class PenyimpanMemori implements Penyimpan {
  final Map<String, String> _data = {};

  @override
  void simpan(String kunci, String nilai) => _data[kunci] = nilai;

  @override
  String? baca(String kunci) => _data[kunci];
}

/// Dekorator: menambah perilaku (log) TANPA mewarisi, dengan membungkus Penyimpan lain.
class PenyimpanBerisik implements Penyimpan {
  PenyimpanBerisik(this._dalam);
  final Penyimpan _dalam;

  @override
  void simpan(String kunci, String nilai) {
    print('simpan $kunci');
    _dalam.simpan(kunci, nilai);
  }

  @override
  String? baca(String kunci) {
    print('baca $kunci');
    return _dalam.baca(kunci);
  }
}

void main() {
  final Penyimpan p = PenyimpanBerisik(PenyimpanMemori());
  p.simpan('a', '1');
  assert(p.baca('a') == '1');
}
```

- `abstract interface class` — hanya kontrak; tak bisa diinstansiasi dan tak bisa di-extend di luar library.
- `implements Penyimpan` — kewajiban mengimplementasi semua anggota, ditandai `@override`.
- `PenyimpanBerisik(this._dalam)` — komposisi: ia *memiliki* sebuah `Penyimpan` dan menambah log; bisa ditumpuk dengan implementasi apa pun.

**Contoh 2 — pewarisan dengan template method.**

```dart
abstract class Laporan {
  /// Template method: urutan langkah ditetapkan di sini; subclass mengisi bagian.
  List<String> hasilkan() => [kepala(), isi(), kaki()];

  String judul();
  String isi();
  String kepala() => '== ${judul()} ==';
  String kaki() => '-- selesai --';
}

class LaporanPenjualan extends Laporan {
  LaporanPenjualan(this.total);
  final int total;

  @override
  String judul() => 'Penjualan';

  @override
  String isi() => 'Total: $total';
}

void main() {
  final l = LaporanPenjualan(1500);
  assert(l.hasilkan().length == 3);
  print(l.hasilkan()); // [== Penjualan ==, Total: 1500, -- selesai --]
}
```

- `hasilkan` mengunci *urutan* langkah (kepala, isi, kaki); subclass hanya mengisi `judul` dan `isi`, dan boleh mengganti `kepala`/`kaki`.
- Kontrak: subclass tidak boleh mengubah makna `hasilkan` (substitusi).

**Contoh 3 — mixin dan linearisasi.**

```dart
mixin Pencatat {
  final List<String> _log = [];
  List<String> get log => List.unmodifiable(_log);
  void catat(String s) => _log.add(s);
}

class Layanan with Pencatat {
  void kerjakan() => catat('mengerjakan');
}

mixin A {
  String lapor() => 'A';
}

mixin B {
  String lapor() => 'B';
}

class P {
  String lapor() => 'P';
}

class AB extends P with A, B {}
class BA extends P with B, A {}

void main() {
  final s = Layanan()..kerjakan();
  assert(s.log.single == 'mengerjakan');
  print(AB().lapor()); // B  (mixin terakhir menang)
  print(BA().lapor()); // A
}
```

- `class Layanan with Pencatat` — `Layanan` mendapat `catat` dan `log` tanpa menjadi turunan apa pun.
- `AB extends P with A, B` — urutan penulisan menentukan pemenang: yang terakhir diterapkan berada paling atas.
- Mixin tidak punya konstruktor; state-nya (`_log`) diinisialisasi pada deklarasi.

**Contoh 4 — komposisi menggantikan hierarki yang kaku.**

```dart
abstract interface class Mesin {
  int get tenaga;
  String nyalakan();
}

class MesinBensin implements Mesin {
  @override
  int get tenaga => 120;
  @override
  String nyalakan() => 'brum';
}

class MesinListrik implements Mesin {
  @override
  int get tenaga => 150;
  @override
  String nyalakan() => 'ssss';
}

class Mobil {
  Mobil(this.mesin);
  final Mesin mesin; // perilaku sebagai BAGIAN yang dapat diganti
  String jalan() => mesin.nyalakan();
}

void main() {
  assert(Mobil(MesinBensin()).jalan() == 'brum');
  assert(Mobil(MesinListrik()).jalan() == 'ssss');
}
```

- Dengan hierarki `MobilListrik extends Mobil`, kombinasi baru (mobil hibrida, truk listrik) melipatgandakan subclass. Dengan komposisi, `Mobil` tetap satu class dan `Mesin` yang divariasikan.
- `final Mesin mesin;` dapat disuntikkan lewat konstruktor, sehingga test memakai mesin palsu (4.7).

**Contoh 5 — class modifiers sekilas.**

```dart
sealed class Bentuk {}              // tertutup; switch atasnya wajib lengkap (2.6)
abstract interface class Kontrak {} // hanya boleh diimplementasi, tak boleh di-extend
base class Dasar {}                 // boleh di-extend; tak boleh diimplementasi di luar library
final class Daun {}                 // tak boleh di-extend maupun diimplementasi di luar library
```

- Modifier adalah cara menyatakan *niat desain*: class mana yang dirancang untuk diwarisi, mana yang tidak.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Strategi sebagai FUNGSI (bukan interface) bila hanya ada satu operasi:
typedef Pemotong = int Function(int harga);

int hargaAkhir(int harga, Pemotong potong) => potong(harga);
```

| Mekanisme | Mewarisi implementasi? | Kopling | Pilih bila |
| --- | --- | --- | --- |
| `extends` | Ya | Kuat | Hubungan is-a yang stabil; template method |
| `implements` | Tidak (kontrak saja) | Sedang | Beberapa implementasi untuk satu peran; pengujian dengan objek palsu |
| `with` (mixin) | Ya, tanpa hierarki | Sedang (urutan penting) | Kemampuan kecil lintas-hierarki (log, kesetaraan) |
| Komposisi | Tidak | Longgar | Perilaku yang dapat diganti; hindari ledakan subclass |
| Fungsi (`typedef`) | — | Longgar | Hanya satu operasi; tak perlu class |

### E. Terminologi Esensial

- **Pewarisan (inheritance)** — subclass mewarisi anggota superclass. **Interface** — kontrak anggota. **Mixin** — potongan implementasi yang dapat ditempelkan.
- **Komposisi / delegasi** — menyimpan objek lain dan meneruskan pekerjaan kepadanya. **Dekorator** — pembungkus yang menambah perilaku pada antarmuka yang sama.
- **Linearisasi** — urutan penumpukan mixin yang menentukan pemenang bentrok nama. **Liskov (LSP)** — subtipe harus dapat menggantikan supertipe tanpa melanggar kontrak.
- **Template method / strategi** — superclass mengatur langkah / perilaku diinjeksikan. **Fragile base class** — perubahan di superclass merusak subclass.

### F. Visualisasi (ASCII)

```text
  extends     B ──► A        B mewarisi implementasi A   (is-a, kopling kuat)
  implements  B ┄┄► A        B memenuhi kontrak A saja   (kopling sedang)
  with        B ◄── M        B menempel M (mixin)        (urutan penting)
  komposisi   B ◆──► A       B MEMILIKI A dan mendelegasi (kopling longgar)
```

```text
  class AB extends P with A, B

       P
       └─ P+A   (A di atas P)
          └─ P+A+B   ← AB.lapor() memakai B (terakhir menang)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 4.3 (invarian class), 4.4 (konstruktor dan super parameters), 2.6 (`sealed`), 1.5 (kontrak dan substitusi).
- **Prasyarat bagi:** 4.7 (matriks pemanggilan) dan 4.8 (injeksi lewat antarmuka). **Dikembangkan di:** Fase 8 (generics dan batas tipe pada hierarki), Fase 11 (batas modul, API publik yang tertutup).

### H. Tips & Praktik Terbaik

- Utamakan komposisi + interface; pewarisan hanya bila hubungan is-a benar dan stabil.
- Beri `final`, `sealed`, atau `interface` pada class yang tidak dirancang untuk diwarisi.
- Gunakan `@override` selalu; analyzer menangkap kesalahan penulisan nama.
- Jaga mixin kecil dan fokus; mixin besar adalah hierarki terselubung.
- Tulis kontrak method yang boleh di-override di dokumentasi, agar subclass tahu apa yang wajib dipertahankan.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Hierarki dalam untuk berbagi kode | Perubahan di atas merembet ke bawah | Ekstrak perilaku menjadi komposisi atau mixin |
| Subclass melanggar kontrak superclass | Kode yang memakai superclass rusak diam-diam | Jaga substitusi; tulis test kontrak |
| Mixin dengan state besar | Hierarki terselubung | Ubah menjadi komposisi |
| Mengabaikan urutan mixin | Method yang salah dipanggil | Tulis urutan dengan sengaja; uji hasilnya |
| `implements` tanpa melengkapi anggota | Galat kompilasi | Implementasikan semua atau pakai `extends` |
| Tidak menutup class yang tak dirancang untuk diwarisi | Pengguna merusak invarian lewat subclass | `final`, `sealed`, atau `interface` |

### J. Sumber Referensi

- ✔ Mixin: https://dart.dev/language/mixins
- ✔ Class modifiers: https://dart.dev/language/class-modifiers · ✔ untuk pengelola API: https://dart.dev/language/class-modifiers-for-apis
- Extend a class: https://dart.dev/language/extend
- ✔ Effective Dart — desain: https://dart.dev/effective-dart/design
- Liskov substitution: https://en.wikipedia.org/wiki/Liskov\_substitution\_principle
- Composition over inheritance: https://en.wikipedia.org/wiki/Composition\_over\_inheritance
- Decorator: https://en.wikipedia.org/wiki/Decorator\_pattern · Strategy: https://en.wikipedia.org/wiki/Strategy\_pattern · Template method: https://en.wikipedia.org/wiki/Template\_method\_pattern

---

## 4.6 Extension Method & Callable Object

*Motivasi: kadang yang kamu butuhkan bukan class baru, melainkan cara baru memanggil sesuatu yang sudah ada.*

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi kode lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Modul ini membahas dua cara memberi *bentuk pemanggilan baru* tanpa membuat hierarki: **extension methods** (menambah method, getter, setter, atau operator pada tipe yang sudah ada, termasuk tipe yang bukan milikmu seperti `String`, `List`, `int?`) dan **callable objects** (class dengan method `call` sehingga instance dapat dipanggil seperti fungsi). Keduanya melengkapi fungsi, class, dan mixin sebagai tempat logika.

### B. Konsep Kunci & Filosofi Mendalam

- **Extension method:** deklarasi `extension Nama on Tipe { ... }` menambah anggota yang dipanggil seperti method biasa. Ia berguna untuk mengubah helper `fungsi(x)` menjadi `x.fungsi()` yang lebih terbaca, terutama pada tipe yang tak bisa kamu ubah.
- **Diselesaikan secara statis.** Pemilihan extension ditentukan oleh **tipe statis** ekspresi saat kompilasi, bukan tipe runtime. Pada variabel bertipe `Object` atau `dynamic`, extension untuk tipe lebih spesifik tidak terpanggil.
- **Anggota asli menang.** Extension tidak dapat menimpa anggota yang sudah ada pada tipe; bila nama bentrok, anggota asli yang dipakai. Bila dua extension menyediakan nama yang sama, pemanggilan menjadi ambigu dan harus disambiguasi lewat pemanggilan eksplisit `NamaExt(x).metode()` atau `show`/`hide` pada impor.
- **Tanpa state.** Extension tidak dapat menambah field instance; hanya perilaku dan getter/setter terhitung.
- **Extension pada tipe nullable** (`on String?`) dapat dipanggil pada `null` — nyaman tetapi dapat menyembunyikan nilai `null` yang seharusnya ditangani; pakai dengan sadar.
- **Extension generik** (`on Iterable<T>`) atau pada tipe terspesifikasi (`on Iterable<num>`) memberi helper yang aman secara tipe.
- **Beda dengan extension type (3.5).** Extension *method* menambah anggota tanpa mengubah tipe; extension *type* membuat tipe baru (terhapus saat runtime).
- **Callable object:** class yang mendeklarasikan method `call` dapat dipanggil `objek(argumen)`; juga dapat di-*tear-off* sebagai `objek.call`. Cocok untuk objek *berkonfigurasi* yang berperilaku seperti fungsi (pembatas, validator, strategi).
- **Filosofi:** extension memperbaiki *ergonomi* pemanggilan; callable object memberi *state, nama, dan pengujian* pada sesuatu yang bentuknya fungsi.
- **Dampak desain:** extension yang tak diimpor tak terlihat (sulit ditemukan) dan dapat mengejutkan bila bentrok dengan anggota baru di versi SDK berikutnya; callable object bertukar sedikit boilerplate dengan kejelasan konfigurasi.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — extension pada `String`, `String?`, dan `Iterable<num>`.**

```dart
extension IstilahString on String {
  String get kapital =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  bool get kosongAtauSpasi => trim().isEmpty;
}

extension TanpaNull on String? {
  bool get kosongAtauNull {
    final self = this; // salin ke lokal agar dapat dipromosikan (modul 2.3)
    return self == null || self.trim().isEmpty;
  }
}

extension StatistikAngka on Iterable<num> {
  double get rataRata {
    if (isEmpty) throw StateError('tidak ada elemen');
    return fold<num>(0, (a, b) => a + b) / length;
  }
}

void main() {
  assert('dart'.kapital == 'Dart');
  assert(' '.kosongAtauSpasi);
  const String? kosong = null;
  assert(kosong.kosongAtauNull);
  assert([1, 2, 3].rataRata == 2.0);
}
```

- `on String` — extension berlaku untuk semua `String`; `this` merujuk ke string tersebut.
- `on String?` — dapat dipanggil pada `null`; `this` bertipe `String?`, sehingga disalin ke `self` agar bisa dipromosikan.
- `on Iterable<num>` — berlaku untuk `List<int>`, `Set<double>`, dll.

**Contoh 2 — dispatch statis: tipe statis menentukan.**

```dart
extension Sapa on Object {
  String get sapa => 'halo dari extension';
}

class Orang {
  String get sapa => 'halo dari class';
}

void main() {
  final Orang o = Orang();
  print(o.sapa); // halo dari class  (anggota asli menang)
  final Object x = o;
  print(x.sapa); // halo dari extension (tipe statis Object)
}
```

- Objek yang sama menghasilkan jawaban berbeda tergantung *tipe statis* variabelnya — itulah resolusi statis.
- Pelajaran: jangan memakai extension untuk menggantikan perilaku polimorfik; gunakan method biasa.

**Contoh 3 — callable object.**

```dart
class Pembatas {
  const Pembatas(this.min, this.maks) : assert(min <= maks);
  final int min;
  final int maks;

  int call(int nilai) => nilai < min ? min : (nilai > maks ? maks : nilai);
}

void main() {
  const batasi = Pembatas(0, 100);
  assert(batasi(150) == 100);
  assert(batasi(-5) == 0);
  assert([-5, 50, 200].map(batasi.call).toList().toString() == '[0, 50, 100]');
}
```

- `int call(int nilai)` — nama `call` khusus: membuat instance dapat dipanggil `batasi(150)`.
- `batasi.call` — tear-off method sebagai fungsi biasa, mis. untuk `map`.
- Konfigurasi (`min`, `maks`) tersimpan di objek, bernama, dan dapat diperiksa dan diuji — tidak tersembunyi seperti pada closure.

### D. Opsi Kode Lain untuk Logika yang Sama

```dart
// Fungsi tingkat atas dan closure untuk membatasi nilai:
int batasiFungsi(int nilai, int min, int maks) =>
    nilai < min ? min : (nilai > maks ? maks : nilai);

int Function(int) buatPembatas(int min, int maks) =>
    (nilai) => batasiFungsi(nilai, min, maks);
```

| Pilihan | Pilih bila | Risiko |
| --- | --- | --- |
| Fungsi tingkat atas | Logika murni, tanpa konfigurasi tetap | Kurang terbaca pada rantai pemanggilan |
| Extension method | Helper pada tipe yang bukan milikmu; sintaks method | Dispatch statis; bentrok nama; tak terlihat bila tak diimpor |
| Callable object | Objek berkonfigurasi yang dipakai seperti fungsi | Sedikit boilerplate; kurang dikenal pembaca |
| Closure | Konfigurasi sederhana yang ditangkap sekali | State tersembunyi; tak punya nama untuk diuji |
| Method biasa | Perilaku mengikuti objek dan polimorfik | Perlu instance |

### E. Terminologi Esensial

- **Extension method** — anggota tambahan pada tipe yang sudah ada, diselesaikan secara statis. **Resolusi statis** — pemilihan berdasar tipe saat kompilasi.
- **Callable object** — instance dengan method `call` yang dapat dipanggil seperti fungsi. **Tear-off `call`** — `objek.call` sebagai fungsi.
- **Ambiguitas extension** — dua extension menyediakan nama sama; diselesaikan secara eksplisit. **Extension type** — tipe baru tanpa biaya runtime (3.5).

### F. Visualisasi (ASCII)

```text
  tipe STATIS ekspresi          anggota yang dipilih
  ──────────────────────        ───────────────────────────────────────
  Orang   o.sapa            →   anggota asli Orang.sapa      (asli menang)
  Object  x.sapa            →   extension Sapa.sapa          (tipe statis Object)
  dynamic d.sapa            →   dicari saat runtime; extension TIDAK dipakai
```

```text
  batasi(150)
     │   instance Pembatas(0, 100)
     ▼
   Pembatas.call(150)  ──►  100
   (konfigurasi min/maks hidup di objek, terlihat dan teruji)
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 4.2 (tear-off dan fungsi sebagai nilai), 4.3 (method dan operator), 2.3 (salin ke lokal agar terpromosi), 3.5 (extension type sebagai pembeda).
- **Prasyarat bagi:** 4.7 (matriks pemanggilan). **Dikembangkan di:** Fase 8 (extension generik dan batas tipe), Fase 11 (extension sebagai API ergonomis modul).

### H. Tips & Praktik Terbaik

- Pakai extension untuk ergonomi pada tipe yang bukan milikmu; jangan untuk perilaku polimorfik.
- Beri nama pada extension (bukan anonim) bila ingin dapat disambiguasi atau diekspor.
- Hati-hati dengan extension pada tipe nullable; pastikan perilaku terhadap `null` memang yang kamu maksud.
- Pilih callable object bila konfigurasi perlu nama dan diuji; closure bila kecil dan sekali pakai.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Mengharap extension menimpa method asli | Method asli tetap dipakai | Namai berbeda; extension tidak menimpa |
| Mengharap extension bekerja pada `dynamic` | Galat runtime: method tak ditemukan | Pastikan tipe statis cocok |
| Dua extension menyediakan nama sama | Galat ambiguitas | `NamaExt(x).metode()` atau `hide`/`show` pada impor |
| Menyimpan state di extension | Tak mungkin; galat kompilasi | Pakai class atau extension type |
| Extension di file lain tidak diimpor | Method tak ditemukan | Impor library tempat extension dideklarasikan |
| Memakai callable object tanpa nama jelas | Pembaca bingung `x(...)` itu apa | Namai class dengan jelas dan dokumentasikan |

### J. Sumber Referensi

- Extension methods: https://dart.dev/language/extension-methods
- Callable objects: https://dart.dev/language/callable-objects
- ✔ Fungsi (tear-off): https://dart.dev/language/functions
- Extension types: https://dart.dev/language/extension-types
- API `Function` (konsep `call`): https://api.dart.dev/stable/dart-core/Function-class.html

---

## 4.7 Satu Logika, Banyak Cara Memanggil *(TAMBAHAN)*

*Motivasi: logika yang sama bisa berpakaian banyak; kuncinya tahu pakaian mana yang cocok untuk acara apa.*

> **Mengapa ditambahkan.** Kurikulum lazim mengajarkan tiap bentuk (fungsi, static, method, extension, callable, closure) di bab terpisah, sehingga pembelajar hafal sintaksnya tetapi tak punya *peta* untuk memilih dan untuk membaca titik panggil. Modul ini menyandingkan semuanya pada **satu logika yang sama**, agar kamu dapat membaca `f(x)`, `X.f(x)`, `x.f(y)`, `x(y)`, dan `x.f` dengan yakin.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Sintaks & contoh · D Opsi lain · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Kita ambil satu logika sederhana — *potong harga sebesar persen tertentu* — dan menuliskannya dalam **enam bentuk**: fungsi tingkat atas, method static, method instance, extension method, callable object, dan closure; lalu menyatukannya lewat **tear-off**. Tujuannya bukan menghafal, melainkan menjawab lima pertanyaan setiap kali melihat atau menulis sebuah pemanggilan.

### B. Konsep Kunci & Filosofi Mendalam

- **Lima pertanyaan penentu.** (1) *Di mana konfigurasi atau state disimpan?* (2) *Apa makna `this`?* (3) *Siapa yang menentukan implementasi — saat kompilasi atau saat runtime?* (4) *Dapatkah ia dikirim sebagai fungsi?* (5) *Bagaimana ia diuji dan diganti?*
- **Membaca titik panggil.** `f(x)`: fungsi tingkat atas, closure/variabel fungsi, atau callable object. `Kelas.f(x)`: method static atau konstruktor bernama. `obj.f(x)`: method instance *atau* extension (periksa tipe statis `obj`). `obj(x)`: callable object atau variabel fungsi. `obj.f` tanpa kurung: *tear-off* method yang terikat pada `obj`.
- **Makna `this`.** Pada method instance: objeknya. Pada extension: *penerima* (nilai bertipe statis yang diperluas). Pada method static dan fungsi tingkat atas: tidak ada `this`. Pada closure: tidak ada `this` baru; ia menangkap lingkungan tempatnya dibuat. Pada tear-off method: `this` **terikat pada instance saat tear-off dibuat** — meski dipanggil nanti dari tempat lain.
- **Resolusi.** Method instance diselesaikan secara **dinamis** menurut tipe runtime objek (polimorfik). Extension, method static, dan fungsi tingkat atas diselesaikan **secara statis** dan tidak dapat di-override.
- **Tear-off menyeragamkan bentuk.** Fungsi, method terikat, dan konstruktor dapat menjadi nilai bertipe `T Function(...)` sehingga dapat dikirim ke `map`, disimpan, atau diinjeksikan (4.2).
- **Aturan pilih: cakupan terkecil yang cukup.** Fungsi murni → extension (bila butuh sintaks method pada tipe bukan milikmu) → class (bila ada state + invarian) → callable object (konfigurasi + dipakai seperti fungsi) → closure (konfigurasi sekali pakai).
- **Filosofi:** bentuk bukan soal selera; ia menentukan *di mana konfigurasi hidup* dan *seberapa mudah perilaku diganti saat tes*.
- **Dampak desain:** bentuk static dan tingkat atas sulit diganti saat tes (tak ada titik injeksi) kecuali dibungkus antarmuka atau diterima sebagai parameter fungsi; bentuk instance berantarmuka paling mudah diganti.

### C. Sintaks Dasar & Contoh Inti Implementasi

**Contoh 1 — enam bentuk, satu logika.**

```dart
// 1. Fungsi tingkat atas (murni): semua data lewat argumen.
int potong(int harga, int persen) => harga - harga * persen ~/ 100;

// 2. Method static: sama, tetapi dikelompokkan dalam namespace class.
class Harga {
  static int potong(int harga, int persen) => harga - harga * persen ~/ 100;
}

// 3. Method instance: persen adalah KONFIGURASI objek.
class Diskon {
  const Diskon(this.persen);
  final int persen;
  int terapkan(int harga) => harga - harga * persen ~/ 100;
}

// 4. Extension method: dipanggil seperti method milik int.
extension HargaExt on int {
  int dipotong(int persen) => this - this * persen ~/ 100;
}

// 5. Callable object: objek berkonfigurasi yang dipanggil seperti fungsi.
class DiskonCallable {
  const DiskonCallable(this.persen);
  final int persen;
  int call(int harga) => harga - harga * persen ~/ 100;
}

// 6. Closure dari fungsi pabrik: persen ditangkap.
int Function(int) buatDiskon(int persen) =>
    (harga) => harga - harga * persen ~/ 100;

void main() {
  const harga = 100000;
  const diskon = Diskon(10);
  const callable = DiskonCallable(10);
  final closure = buatDiskon(10);

  assert(potong(harga, 10) == 90000); // 1
  assert(Harga.potong(harga, 10) == 90000); // 2
  assert(diskon.terapkan(harga) == 90000); // 3
  assert(harga.dipotong(10) == 90000); // 4
  assert(callable(harga) == 90000); // 5
  assert(closure(harga) == 90000); // 6
}
```

- Bentuk 1 dan 2 membawa `persen` sebagai argumen tiap kali; bentuk 3, 5, dan 6 menyimpan `persen` *sekali* (di objek atau lingkungan closure).
- Bentuk 4 hanya ergonomi: `harga.dipotong(10)` terbaca seperti kalimat; `this` adalah `harga`.
- Bentuk 5 dipanggil `callable(harga)` — tanpa nama method — karena method-nya bernama `call`.
- Kelima bentuk menghasilkan angka yang sama; yang berbeda adalah *di mana konfigurasinya* dan *bagaimana ia diganti*.

**Contoh 2 — tear-off menyeragamkan semuanya, dan `this` terikat.**

```dart
typedef Pemotong = int Function(int);

int hargaAkhir(int harga, Pemotong potong) => potong(harga);

class Hitung {
  Hitung(this.nilai);
  int nilai;
  int tambah(int n) => nilai += n;
}

void main() {
  const diskon = Diskon(10);
  const callable = DiskonCallable(10);
  final closure = buatDiskon(10);

  // Tiga bentuk berbeda, SATU tipe fungsi: Pemotong.
  assert(hargaAkhir(100000, diskon.terapkan) == 90000);
  assert(hargaAkhir(100000, callable.call) == 90000);
  assert(hargaAkhir(100000, closure) == 90000);
  assert([100000, 50000].map(closure).toList().toString() == '[90000, 45000]');

  final a = Hitung(10);
  final f = a.tambah; // tear-off terikat pada a
  f(5);
  final b = Hitung(100);
  final g = b.tambah;
  g(1);
  assert(a.nilai == 15 && b.nilai == 101); // masing-masing memengaruhi objeknya sendiri
}
```

- `diskon.terapkan`, `callable.call`, dan `closure` sama-sama sesuai dengan `int Function(int)`; `hargaAkhir` tak peduli bentuk aslinya.
- `a.tambah` mengikat `this` ke `a` saat tear-off dibuat; `f(5)` mengubah `a`, bukan `b`.

**Contoh 3 — bentuk pemanggilan lain yang perlu dikenali.**

```dart
void main() {
  // Cascade: banyak operasi pada objek yang sama.
  final buf = StringBuffer()
    ..write('a')
    ..write('b');

  // Null-aware: berhenti bila penerima null.
  const String? s = null;
  final panjang = s?.length;

  // Callback opsional.
  const void Function()? cb = null;
  cb?.call();

  assert(buf.toString() == 'ab' && panjang == null);
}
```

- `..` memanggil beberapa method pada `buf` yang sama dan menghasilkan `buf`; `?.` dan `?..` adalah versi null-aware.
- `cb?.call()` memanggil callback hanya bila tidak null (modul 4.1).

### D. Opsi Kode Lain untuk Logika yang Sama

| Bentuk | Pemilik konfigurasi | Cara panggil | Dapat dikirim sebagai fungsi? | Mudah diganti saat tes? | Pilih bila |
| --- | --- | --- | --- | --- | --- |
| Fungsi tingkat atas | Argumen | `potong(h, 10)` | Ya (tear-off) | Ya, bila murni | Logika murni tanpa konfigurasi tetap |
| Method static | Argumen | `Harga.potong(h, 10)` | Ya (tear-off) | Sulit tanpa antarmuka | Hanya bila perlu namespace; sering lebih baik fungsi |
| Method instance | Field objek | `d.terapkan(h)` | Ya (tear-off terikat) | Ya, lewat antarmuka | Ada state, invarian, atau polimorfisme |
| Extension method | Argumen / penerima | `h.dipotong(10)` | Ya (tear-off) | Sulit diganti | Ergonomi pada tipe yang bukan milikmu |
| Callable object | Field objek | `c(h)` | Ya (`c.call`) | Ya | Konfigurasi bernama yang dipakai seperti fungsi |
| Closure | Lingkungan tertangkap | `k(h)` | Ya (sudah fungsi) | Ya | Konfigurasi kecil sekali pakai |

### E. Terminologi Esensial

- **Titik panggil (call site)** — tempat pemanggilan ditulis. **Receiver / penerima** — objek di kiri titik pada `obj.f()`.
- **Resolusi dinamis / statis** — pemilihan implementasi saat runtime / saat kompilasi. **Tear-off terikat** — method yang sudah terikat pada instance tertentu.
- **Cascade** — operator `..`. **Null-aware call** — `?.` dan `?.call()`.
- **Konfigurasi vs state** — nilai yang ditetapkan sekali vs nilai yang berubah.

### F. Visualisasi (ASCII)

```text
 Membaca titik panggil

  f(x)          → fungsi tingkat atas │ closure/variabel fungsi │ callable object
  Kelas.f(x)    → method static │ konstruktor bernama/factory
  obj.f(x)      → method instance (dinamis)  │  extension (statis, cek tipe statis obj)
  obj(x)        → callable object │ variabel fungsi
  obj.f         → tear-off method TERIKAT pada obj
  Kelas.new     → tear-off konstruktor
```

```text
 Logika butuh konfigurasi atau state yang tetap?
  ├─ tidak → fungsi tingkat atas (murni)
  │           ├─ ingin sintaks method pada tipe bukan milikmu → extension
  │           └─ perlu namespace saja → tetap fungsi (static jarang perlu)
  └─ ya    → berapa operasi yang berbagi konfigurasi itu?
              ├─ banyak, atau perlu invarian/polimorfisme → class dengan method
              ├─ satu, dan konfigurasi perlu nama dan diuji → callable object
              └─ satu, konfigurasi kecil sekali pakai → closure dari fungsi pabrik
```

### G. Hubungan dengan Modul Lain

- **Memakai:** 4.1 (tanda tangan), 4.2 (closure dan tear-off), 4.3 (method dan state), 4.5 (polimorfisme), 4.6 (extension dan callable).
- **Prasyarat bagi:** 4.8 (injeksi dependensi). **Dikembangkan di:** Fase 6 (biaya tiap bentuk), Fase 10 (menguji bentuk-bentuk ini), Fase 11 (memilih bentuk di batas modul).

### H. Tips & Praktik Terbaik

- Mulai dari fungsi tingkat atas; naikkan ke bentuk yang lebih kaya hanya ketika ada alasan (konfigurasi, state, polimorfisme).
- Saat membaca titik panggil `obj.f(...)`, cek dulu tipe statis `obj`: ia method instance atau extension?
- Terima fungsi (`typedef`) sebagai parameter bila hanya satu operasi yang dibutuhkan; itu titik injeksi paling ringan.
- Hindari method static sebagai tempat logika yang perlu diganti saat tes; pakai antarmuka atau parameter fungsi.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Menganggap `obj.f` dan `obj.f()` sama | Fungsi diteruskan, bukan hasilnya, atau sebaliknya | Ingat: tanpa kurung = tear-off (nilai fungsi) |
| Mengira tear-off method kehilangan `this` | Heran saat objek yang berubah bukan yang diharapkan | Tear-off terikat pada instance saat dibuat |
| Memakai static untuk logika yang perlu di-mock | Test tak dapat mengganti perilaku | Antarmuka atau parameter fungsi |
| Closure dipakai untuk state penting | Sulit diperiksa dan diuji | Pindahkan ke class atau callable object |
| Extension dikira polimorfik | Perilaku bergantung pada tipe statis | Pakai method instance untuk polimorfisme |

### J. Sumber Referensi

- ✔ Fungsi (tear-off, closure): https://dart.dev/language/functions
- ✔ Mixin dan class: https://dart.dev/language/mixins
- Method: https://dart.dev/language/methods
- Extension methods: https://dart.dev/language/extension-methods
- Callable objects: https://dart.dev/language/callable-objects
- Dispatch statis vs dinamis: https://en.wikipedia.org/wiki/Static\_dispatch

---

## 4.8 Studi Kasus Terpadu: To-Do v3 *(TAMBAHAN)*

*Motivasi: arsitektur yang baik terasa membosankan — tiap bagian tahu tugasnya, dan tak ada yang terkejut.*

> **Mengapa ditambahkan.** Fase 4 paling jelas dilihat ketika inti murni dari Fase 3.7 dibungkus dengan *class yang punya tugas jelas* dan *dependensi yang disuntikkan*. To-Do v3 menambahkan penyimpanan lewat antarmuka kecil, sebuah koordinator `AplikasiTodo`, dan test yang memakai penyimpan palsu — tanpa menyentuh inti sama sekali.

**Isi modul:** A Deskripsi · B Konsep & filosofi · C Langkah & kode · D Variasi · E Terminologi · F Diagram · G Hubungan modul · H Tips · I Kesalahan umum · J Referensi

### A. Deskripsi Konkret & Peran dalam Kurikulum

Kamu menambahkan ke `lib/todo.dart` dari Fase 3.7: (1) antarmuka `Penyimpan` dengan dua implementasi (`PenyimpanBerkas` untuk produksi, `PenyimpanMemori` untuk tes), (2) pengkode dan pembaca data (`kodekan`, `dekode`), (3) class koordinator `AplikasiTodo` yang memegang state riwayat dan menyimpannya saat berubah, dan (4) shell yang kini hanya merangkai bagian-bagian. `Perintah`, `Urai`, `Item`, `Judul`, `Riwayat`, dan `jalankan` **tidak berubah**.

### B. Konsep Kunci & Filosofi Mendalam

- **Pemisahan tanggung jawab.** `jalankan` (murni) menghitung state berikutnya; `AplikasiTodo` (koordinator berstate) memutuskan *kapan menyimpan*; `Penyimpan` (antarmuka) tahu *bagaimana menyimpan*; shell tahu *bagaimana berbicara dengan terminal*.
- **Injeksi dependensi lewat konstruktor.** `AplikasiTodo` menerima `Penyimpan`, bukan membuatnya sendiri. Di produksi diberi `PenyimpanBerkas`; di tes diberi `PenyimpanMemori` atau penyimpan palsu penghitung tulisan.
- **Antarmuka kecil.** `Penyimpan` hanya punya dua operasi (`baca`, `tulis`); semakin kecil antarmuka, semakin mudah diganti dan diuji.
- **Invarian di koordinator.** `_riwayat` privat; satu-satunya jalan mengubahnya adalah `proses`; setiap perubahan otomatis disimpan, dan pemanggilan yang tak mengubah apa pun tidak menyentuh penyimpan.
- **Konstruktor memuat state awal** memakai method static privat `_muat` di initializer list (4.4); `this` belum tersedia di sana, sehingga helper harus static dan menerima argumen.
- **Ekspos aman.** `daftar` mengembalikan *snapshot* tak termodifikasi (3.4), bukan list internal.
- **Bentuk pemanggilan beragam, satu logika.** `proses` dapat dipanggil langsung, di-tear-off untuk `forEach`, atau dibungkus (4.7).
- **Batas yang sengaja ditunda.** Kegagalan I/O (berkas hilang, rusak, tak dapat ditulis) dan keamanan jalur berkas **belum ditangani sepenuhnya** — itu Fase 5 dan Fase 9. Di sini `dekode` melempar `FormatException` untuk data rusak dan kita mencatat batasnya secara eksplisit.
- **Dampak desain:** karena inti tidak berubah, hanya \~60 baris baru yang ditambahkan, dan perilaku persistensi dapat diuji tanpa menyentuh disk.

### C. Langkah, Sintaks, dan Kode

**Langkah 1 — antarmuka penyimpanan dan implementasinya.**

```dart
import 'dart:io';

abstract interface class Penyimpan {
  String? baca();
  void tulis(String isi);
}

class PenyimpanMemori implements Penyimpan {
  PenyimpanMemori([this._isi]);
  String? _isi;

  @override
  String? baca() => _isi;

  @override
  void tulis(String isi) => _isi = isi;
}

class PenyimpanBerkas implements Penyimpan {
  PenyimpanBerkas(this.jalur);
  final String jalur;

  @override
  String? baca() {
    final f = File(jalur);
    return f.existsSync() ? f.readAsStringSync() : null;
  }

  @override
  void tulis(String isi) => File(jalur).writeAsStringSync(isi);
}
```

- `abstract interface class Penyimpan` — kontrak murni; hanya boleh diimplementasi.
- `PenyimpanMemori([this._isi])` — parameter posisional opsional yang langsung mengisi field privat; nilai awal `null` berarti belum ada data.
- `PenyimpanBerkas` memakai API sinkron `dart:io` agar kode tetap sederhana; versi asinkron dan kegagalan I/O dibahas di Fase 5 dan 7.

**Langkah 2 — pengkode dan pembaca data (fungsi murni).**

```dart
import 'dart:convert';

String kodekan(List<Item> daftar) => jsonEncode([
      for (final i in daftar) {'judul': i.judul.teks, 'selesai': i.selesai},
    ]);

Item _dekodeItem(Object? e) {
  if (e case {'judul': String judul, 'selesai': bool selesai}) {
    final j = Judul.coba(judul);
    if (j != null) return Item(j, selesai: selesai);
  }
  throw FormatException('entri todo rusak', e);
}

List<Item> dekode(String teks) {
  final data = jsonDecode(teks);
  if (data is! List) throw FormatException('berkas todo rusak', teks);
  return [for (final e in data) _dekodeItem(e)];
}
```

- `jsonEncode([...])` — mengubah daftar peta sederhana menjadi teks JSON.
- `if (e case {'judul': String judul, 'selesai': bool selesai})` — pola map memvalidasi bentuk dan tipe, lalu mengikat variabel (modul 2.5).
- `Judul.coba(judul)` — data dari berkas diperlakukan sebagai *tak tepercaya*: judul kosong ditolak (parse, don't validate, 3.5).
- `data is! List` lalu `throw` — guard clause; setelahnya `data` terpromosi menjadi `List` (2.3).

**Langkah 3 — koordinator `AplikasiTodo`.**

```dart
class AplikasiTodo {
  AplikasiTodo(Penyimpan penyimpan, {int batas = 50})
      : _penyimpan = penyimpan,
        _riwayat = Riwayat<List<Item>>.mulai(_muat(penyimpan), batas: batas);

  final Penyimpan _penyimpan;
  Riwayat<List<Item>> _riwayat;

  static List<Item> _muat(Penyimpan p) {
    final isi = p.baca();
    return isi == null ? <Item>[] : dekode(isi);
  }

  /// Snapshot daftar saat ini (tak dapat diubah, independen dari state internal).
  List<Item> get daftar => List.unmodifiable(_riwayat.kini);

  /// Menjalankan [perintah]; menyimpan hanya bila state berubah.
  List<String> proses(Perintah perintah) {
    final (baru, keluaran) = jalankan(_riwayat, perintah);
    if (!identical(baru, _riwayat)) {
      _riwayat = baru;
      _penyimpan.tulis(kodekan(_riwayat.kini));
    }
    return keluaran;
  }
}
```

- `AplikasiTodo(Penyimpan penyimpan, {int batas = 50})` — dependensi *wajib* sebagai posisional, konfigurasi opsional sebagai bernama (4.1).
- Initializer list: `_penyimpan = penyimpan`, lalu `_riwayat = ... _muat(penyimpan)`; `_muat` harus `static` karena `this` belum tersedia (4.4).
- `proses` memanggil fungsi tingkat atas `jalankan` (bukan method — nama method sengaja berbeda agar tidak menutupinya).
- `identical(baru, _riwayat)` — `jalankan` mengembalikan *objek riwayat yang sama* untuk operasi yang tak berlaku atau tak mengubah; maka kita tak menulis.

**Langkah 4 — shell yang merangkai bagian-bagian (`bin/logika_fase4.dart`).**

```dart
import 'dart:io';

import 'package:logika_fase4/todo.dart';

void main(List<String> args) {
  final jalur = args.isNotEmpty ? args.first : 'todo.json';
  final app = AplikasiTodo(PenyimpanBerkas(jalur));
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
```

- `main(List<String> args)` — argumen baris perintah opsional: jalur berkas; bawaan `todo.json`.
- Shell hanya merangkai: urai → proses → cetak. Semua logika ada di tempat lain.
- `app.proses(perintah).forEach(stdout.writeln)` — tear-off `stdout.writeln` sebagai fungsi (4.2).

**Langkah 5 — test dengan penyimpan palsu (`test/todo_test.dart`).**

```dart
import 'dart:convert';

import 'package:logika_fase4/todo.dart';
import 'package:test/test.dart';

class PenyimpanPenghitung implements Penyimpan {
  int tulisan = 0;
  String? isi;

  @override
  String? baca() => isi;

  @override
  void tulis(String s) {
    tulisan++;
    isi = s;
  }
}

void main() {
  group('kodekan dan dekode', () {
    test('bolak-balik menghasilkan daftar setara', () {
      final daftar = [
        Item(Judul.dari('a')),
        Item(Judul.dari('b'), selesai: true),
      ];
      expect(dekode(kodekan(daftar)), daftar);
    });

    test('data rusak ditolak dengan FormatException', () {
      expect(() => dekode('bukan json'), throwsFormatException);
      expect(() => dekode(jsonEncode({'a': 1})), throwsFormatException);
      expect(
        () => dekode(jsonEncode([{'judul': ' ', 'selesai': false}])),
        throwsFormatException,
      );
    });
  });

  group('AplikasiTodo', () {
    test('keadaan disimpan dan dipulihkan oleh instance baru', () {
      final penyimpan = PenyimpanMemori();
      final a = AplikasiTodo(penyimpan);
      a.proses(Tambah(Judul.dari('roti')));
      a.proses(const Selesai(1));

      final b = AplikasiTodo(penyimpan); // memuat dari penyimpan yang sama
      expect(b.daftar.single.judul.teks, 'roti');
      expect(b.daftar.single.selesai, isTrue);
    });

    test('tidak menulis bila tidak ada perubahan', () {
      final p = PenyimpanPenghitung();
      final app = AplikasiTodo(p);
      app.proses(const Tampilkan());
      app.proses(const Batal()); // tidak ada yang dibatalkan
      app.proses(const Selesai(1)); // nomor tak ada
      expect(p.tulisan, 0);
      app.proses(Tambah(Judul.dari('roti')));
      expect(p.tulisan, 1);
    });

    test('proses dapat di-tear-off dan dipakai sebagai fungsi', () {
      final app = AplikasiTodo(PenyimpanMemori());
      [Tambah(Judul.dari('a')), Tambah(Judul.dari('b')), const Hapus(1)]
          .forEach(app.proses);
      expect(app.daftar.single.judul.teks, 'b');
    });

    test('snapshot daftar tak dapat diubah', () {
      final app = AplikasiTodo(PenyimpanMemori())..proses(Tambah(Judul.dari('a')));
      expect(() => app.daftar.add(Item(Judul.dari('x'))), throwsUnsupportedError);
    });
  });
}
```

```bash
dart test
```

- `PenyimpanPenghitung` — *fake* sederhana yang menghitung tulisan; ia dapat dipakai karena `AplikasiTodo` bergantung pada antarmuka, bukan pada berkas.
- Test pertama membuktikan siklus simpan-pulih tanpa menyentuh disk.
- `forEach(app.proses)` — tear-off method terikat pada `app`; mengembalikan `List<String>` tidak masalah bagi `void Function(Perintah)`.
- `throwsUnsupportedError` — membuktikan snapshot benar-benar tak dapat dimodifikasi.

### D. Variasi Kode untuk Logika yang Sama

```dart
// 1) Penyimpan sebagai DUA FUNGSI (tanpa antarmuka) bila ingin sangat ringan:
typedef Baca = String? Function();
typedef Tulis = void Function(String isi);

// 2) Sintaks konstruktor ringkas (Dart >= 3.13):
// new(Penyimpan penyimpan, {int batas = 50})
//     : _penyimpan = penyimpan,
//       _riwayat = Riwayat<List<Item>>.mulai(_muat(penyimpan), batas: batas);
```

| Pendekatan | Kelebihan | Kekurangan |
| --- | --- | --- |
| Antarmuka `Penyimpan` (utama) | Nama dan kontrak jelas; mudah ditambah operasi | Satu class per implementasi |
| Dua parameter fungsi (`Baca`, `Tulis`) | Sangat ringan; tanpa class | Dua dependensi terpisah; kontrak kurang terkumpul |
| Singleton / variabel global | Paling sedikit kode | State global; test saling mengganggu |
| `AplikasiTodo` membuat penyimpan sendiri | Pemanggil lebih sederhana | Tak dapat diuji tanpa disk; kopling kuat |

### E. Terminologi Esensial

- **Injeksi dependensi (DI)** — dependensi diberikan dari luar, tidak dibuat di dalam. **Fake** — implementasi palsu yang sederhana untuk tes.
- **Koordinator / fasad** — class yang merangkai bagian-bagian dan memegang state. **Antarmuka kecil** — kontrak dengan sedikit operasi.
- **Snapshot** — salinan tak termodifikasi (3.4). **Inti murni / tepi impure** — logika tanpa efek vs I/O (1.2).
- **Total** — terdefinisi untuk semua masukan (2.7); `proses` total karena `jalankan` total.

### F. Visualisasi (ASCII)

```text
  bin/ (tepi: terminal) ──► AplikasiTodo (koordinator: state + kapan menyimpan)
                               │ memakai (komposisi, DI lewat konstruktor)
                               ├──► jalankan (murni) ──► Riwayat (imutabel)
                               └──► Penyimpan (antarmuka)
                                       ├── PenyimpanBerkas   (produksi)
                                       ├── PenyimpanMemori   (tes simpan-pulih)
                                       └── PenyimpanPenghitung (tes: berapa kali menulis?)
```

```text
   Fase 3.7                          Fase 4.8  (yang BERUBAH)
   ───────────────────────────       ──────────────────────────────────────────
   shell memegang Riwayat            AplikasiTodo memegang Riwayat
   (tak ada penyimpanan)             + Penyimpan lewat konstruktor (DI)
   jalankan, Perintah, Item          TIDAK berubah
```

### G. Hubungan dengan Modul Lain

- **Memakai:** seluruh Fase 4 (4.1 parameter, 4.2 tear-off, 4.3 class dan invarian, 4.4 konstruktor, 4.5 antarmuka dan komposisi, 4.7 bentuk pemanggilan), serta Fase 3 (riwayat, tipe tervalidasi, snapshot) dan Fase 2 (pola, promosi).
- **Dikembangkan di:** Fase 5 (kegagalan I/O, berkas rusak, pemulihan), Fase 7 (penyimpanan asinkron), Fase 9 (jalur berkas dan data tak tepercaya), Fase 10 (menguji koordinator), Fase 11 (memindahkan `Penyimpan` dan inti ke paket terpisah).

### H. Tips & Praktik Terbaik

- Suntikkan semua dependensi yang menyentuh dunia luar (berkas, jaringan, waktu, acak); jangan membuatnya di dalam class.
- Jaga antarmuka sekecil mungkin; tambahkan operasi hanya bila ada pemanggil nyata.
- Pertahankan inti murni; koordinator hanya memutuskan *kapan*, bukan *bagaimana menghitung*.
- Tulis test dengan fake, bukan dengan disk, sehingga cepat dan deterministik.

### I. Potensi Kesalahan Umum & Solusi

| Kesalahan | Gejala | Solusi |
| --- | --- | --- |
| Membuat dependensi di dalam class | Test menyentuh disk, lambat, saling mengganggu | Injeksi lewat konstruktor |
| Antarmuka besar | Fake sulit ditulis | Pecah menjadi antarmuka kecil |
| Method instance bernama sama dengan fungsi tingkat atas | Rekursi tak sengaja | Beri nama berbeda (`proses` vs `jalankan`) atau awali `this.`/nama pustaka |
| Menyimpan di setiap `proses`, termasuk yang tak mengubah | Tulisan berlebih | Bandingkan hasil dan simpan hanya bila berubah |
| Mengekspos list internal | Pemanggil mengubah state dari luar | Kembalikan snapshot atau view (3.4) |
| Menelan error I/O diam-diam | Data hilang tanpa tanda | Rancang kebijakan kegagalan (Fase 5) |

### J. Sumber Referensi

- ✔ Konstruktor (initializer list, parameter bernama/posisional): https://dart.dev/language/constructors
- ✔ Mixin dan antarmuka: https://dart.dev/language/mixins
- ✔ Class modifiers (`abstract interface class`): https://dart.dev/language/class-modifiers
- ✔ Pengujian di Dart: https://dart.dev/tools/testing
- `dart:io` dan `dart:convert`: https://api.dart.dev/stable/dart-io/dart-io-library.html · https://api.dart.dev/stable/dart-convert/dart-convert-library.html
- Dependency injection: https://en.wikipedia.org/wiki/Dependency\_injection

---

## Latihan Fase 4 (sengaja tanpa kunci jawaban)

Kerjakan sendiri, jalankan dengan `--enable-asserts`, lalu commit dengan struktur `fase-4/latihan-N/` berisi `README.md` (spesifikasi + tabel contoh), `lib/`, dan `test/`.

1. **\[4.1\]** Ambil tiga fungsi yang punya parameter `bool` posisional atau lebih dari lima parameter. Rancang ulang tanda tangannya (parameter bernama, objek opsi, atau record). Tulis `sebelum/sesudah`, dan tunjukkan satu panggilan keliru yang kini tidak dapat ditulis.
2. **\[4.2\]** Tulis `ulangi<T>(T Function() aksi, {required int maks})` (percobaan ulang sederhana) dan `memo` dengan *batas ukuran cache*. Uji dengan menghitung jumlah pemanggilan. Jelaskan state apa yang tersembunyi di dalam closure dan kapan kamu akan memindahkannya ke class.
3. **\[4.3\]** Buat class `Keranjang` mutabel yang terenkapsulasi dengan invarian (jumlah ≥ 1, tak ada barang ganda) dan getter `total`. Bandingkan dengan versi imutabel dari Fase 3; tulis tabel kapan masing-masing lebih cocok.
4. **\[4.4\]** Buat class `Uang` dengan satu konstruktor utama dan empat jalur pembuatan (bernama, factory dari teks, `const`, dan satu lagi pilihanmu). Buktikan lewat test bahwa semua jalur menghasilkan objek yang sah. Tulis ulang dengan sintaks konstruktor ringkas bila batas bawah SDK-mu ≥ 3.13.
5. **\[4.5\]** Modelkan sistem notifikasi dengan tiga pendekatan: interface + implementasi, mixin `Pencatat`, dan komposisi dekorator. Tambahkan varian keempat dan catat apa yang berubah di tiap pendekatan. Jelaskan satu situasi di mana pewarisan lebih baik daripada komposisi.
6. **\[4.6\]** Tulis tiga extension method (pada `String?`, pada `Iterable<T>` generik, dan pada `Duration`) serta satu callable object `Validator`. Tunjukkan satu kasus bentrok nama atau dispatch statis yang mengejutkan, dan cara menyelesaikannya.
7. **\[4.7\]** Pilih satu logika (mis. `hitungPajak`) dan implementasikan dalam keenam bentuk. Tulis tabel keputusanmu: untuk tiap skenario (dipanggil di `map`, butuh konfigurasi, perlu diganti saat runtime, perlu dites), bentuk mana yang kamu pilih dan mengapa.
8. **\[4.8\]** Tambahkan ke To-Do v3: perintah `ekspor` (menulis ke jalur lain lewat `Penyimpan` kedua) dan konfigurasi `batas` riwayat dari argumen baris perintah. Catat bagian mana yang *tidak perlu diubah* berkat injeksi dependensi. Tulis rancangan (bukan kode) untuk penulisan berkas yang aman dari pemutusan di tengah proses — itu bahan Fase 5 dan 9.

---

## Ringkasan Fase 4 & Daftar Periksa Kelulusan

| Modul | Satu kalimat inti |
| --- | --- |
| 4.1 | Tanda tangan fungsi adalah kontrak: parameter bernama untuk yang ke-3 dan seterusnya, boolean selalu bernama. |
| 4.2 | Fungsi adalah nilai: closure menangkap variabel dan membawa state tersembunyi; tear-off lebih disukai daripada lambda pembungkus. |
| 4.3 | Class menjaga invarian state lewat enkapsulasi; getter murah dan murni, method untuk pekerjaan. |
| 4.4 | Konstruktor adalah pintu masuk invarian: satu konstruktor utama, sisanya mengarah kepadanya. |
| 4.5 | Utamakan komposisi dan interface; pewarisan untuk is-a yang stabil; tutup warisan yang tak dirancang. |
| 4.6 | Extension memperbaiki ergonomi (statis, anggota asli menang); callable object memberi nama dan state pada objek-fungsi. |
| 4.7 | Satu logika, banyak bentuk: pilih berdasar tempat konfigurasi, makna `this`, dan kemudahan diganti saat tes. |
| 4.8 | Inti murni + koordinator berstate + dependensi lewat antarmuka kecil = bagian-bagian yang dapat diganti dan diuji. |

**Daftar periksa kelulusan** (jawab tanpa membuka dokumen):

- [ ] Aku bisa menjelaskan aturan jenis parameter (posisional, opsional, bernama, `required`, bawaan) dan merancang tanda tangan yang menolak salah-panggil.
- [ ] Aku bisa menjelaskan apa yang ditangkap closure, mengapa closure di loop `for` mencetak 0, 1, 2, dan kapan state di closure sebaiknya jadi class.
- [ ] Aku bisa memilih antara tear-off dan lambda, serta menjelaskan ke objek mana sebuah tear-off method terikat.
- [ ] Aku bisa menjelaskan privasi per library, kapan memakai getter vs method, dan bagaimana menjaga invarian objek.
- [ ] Aku bisa menyebut semua jenis konstruktor Dart, urutan inisialisasi (initializer list → super → badan), dan kapan memilih factory.
- [ ] Aku bisa membedakan `extends`, `implements`, `with`, dan komposisi, serta menjelaskan linearisasi mixin dan class modifiers.
- [ ] Aku bisa menjelaskan mengapa extension diselesaikan secara statis, dan menulis callable object.
- [ ] Aku bisa membaca titik panggil `f(x)`, `X.f(x)`, `x.f(y)`, `x(y)`, dan `x.f`, dan menyebut apa yang terjadi di baliknya.
- [ ] Aku bisa menyuntikkan dependensi lewat konstruktor dan menguji dengan fake.
- [ ] Delapan latihan sudah di-commit dengan tabel contoh dan test.

**Pratinjau Fase 5 — Logika Kegagalan & Ketahanan.** `Exception` vs `Error` secara mendalam; `try`/`catch`/`on`/`finally`, `rethrow`, dan pembersihan resource; hasil sebagai tipe (`Hasil`/Result) vs exception; kegagalan I/O (berkas hilang, rusak, tak dapat ditulis); kebijakan pemulihan, percobaan ulang, dan idempotensi; pesan galat dan pencatatan; serta merancang agar sistem *gagal dengan aman*. Prasyaratnya adalah daftar periksa di atas terpenuhi.

---

## Referensi Induk Fase 4

> **Catatan verifikasi.** Tanda ✔ berarti halaman tersebut dibuka dan diverifikasi lewat pencarian atau pengambilan halaman saat dokumen ini disusun (13 November 2026); beberapa dibuka melalui cermin resmi `dart.cn` dengan jalur yang sama. Tautan tanpa tanda adalah halaman resmi atau baku yang stabil, tetapi belum diverifikasi ulang; bila ada yang berpindah, cari judulnya di dart.dev.

**Dokumentasi resmi Dart**

- ✔ Fungsi: https://dart.dev/language/functions · ✔ Konstruktor: https://dart.dev/language/constructors · ✔ Mixin: https://dart.dev/language/mixins
- ✔ Class modifiers: https://dart.dev/language/class-modifiers · ✔ untuk pengelola API: https://dart.dev/language/class-modifiers-for-apis · ✔ Primary constructors: https://dart.dev/language/primary-constructors
- ✔ Pengumuman Dart 3.14: https://dart.dev/blog/announcing-dart-3-14 · ✔ Pengumuman Dart 3.13: https://dart.dev/blog/announcing-dart-3-13 · ✔ Pengujian: https://dart.dev/tools/testing
- ✔ Effective Dart (desain): https://dart.dev/effective-dart/design · Class: https://dart.dev/language/classes · Method: https://dart.dev/language/methods · Extend: https://dart.dev/language/extend
- Extension methods: https://dart.dev/language/extension-methods · Callable objects: https://dart.dev/language/callable-objects · Extension types: https://dart.dev/language/extension-types · Typedef: https://dart.dev/language/typedefs
- API: https://api.dart.dev/stable/dart-core/Function-class.html · https://api.dart.dev/stable/dart-io/dart-io-library.html · https://api.dart.dev/stable/dart-convert/dart-convert-library.html

**Konsep dan teori**

- Liskov substitution: https://en.wikipedia.org/wiki/Liskov\_substitution\_principle · Composition over inheritance: https://en.wikipedia.org/wiki/Composition\_over\_inheritance · Dependency injection: https://en.wikipedia.org/wiki/Dependency\_injection
- Decorator: https://en.wikipedia.org/wiki/Decorator\_pattern · Strategy: https://en.wikipedia.org/wiki/Strategy\_pattern · Template method: https://en.wikipedia.org/wiki/Template\_method\_pattern · Closure: https://en.wikipedia.org/wiki/Closure\_(computer\_programming)
- Event sourcing (konteks riwayat): https://martinfowler.com/eaaDev/EventSourcing.html

**Buku bacaan lanjutan (tanpa tautan)**

- E. Gamma, R. Helm, R. Johnson, J. Vlissides, *Design Patterns* — strategi, dekorator, template method, dan alasan komposisi.
- J. Bloch, *Effective Java* — bab pewarisan, komposisi, dan desain untuk diwarisi (prinsipnya berlaku lintas bahasa).
- M. Seemann dan S. van Deursen, *Dependency Injection: Principles, Practices, and Patterns* — injeksi lewat konstruktor dan desain yang dapat diuji.

---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

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

