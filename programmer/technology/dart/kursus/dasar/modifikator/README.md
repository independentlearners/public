# Dokumentasi Lengkap: Modifikator dalam Dart

> Disusun berdasarkan referensi resmi **dart.dev** (mencerminkan Dart 3.12.2), termasuk cakupan **Primary Constructors** yang memerlukan Dart 3.13+. Setiap bagian menyertakan kode, contoh implementasi, dan tautan sumber resminya masing-masing.

## Daftar Isi

1. [Pendahuluan](#1-pendahuluan)
2. [Modifikator Variabel & Nilai](#2-modifikator-variabel--nilai)
3. [Modifikator Visibilitas (Privasi Pustaka)](#3-modifikator-visibilitas-privasi-pustaka)
4. [Modifikator Kelas (Dart 3.0+)](#4-modifikator-kelas-dart-30)
5. [Modifikator Anggota Kelas](#5-modifikator-anggota-kelas)
6. [Modifikator Fungsi & Generator](#6-modifikator-fungsi--generator)
7. [Modifikator & Konstruksi Parameter](#7-modifikator--konstruksi-parameter)
8. [Kata Kunci Relasi Antar Kelas](#8-kata-kunci-relasi-antar-kelas)
9. [Operator Null Safety Terkait](#9-operator-null-safety-terkait)
10. [Anotasi (Metadata) Terkait](#10-anotasi-metadata-terkait)
11. [Kata Kunci Deklarasi Terkait Lainnya](#11-kata-kunci-deklarasi-terkait-lainnya)
12. [Tabel Ringkasan Lengkap](#12-tabel-ringkasan-lengkap)
13. [Best Practices: Cara Terbaik Merancang dengan Modifikator](#13-best-practices-cara-terbaik-merancang-dengan-modifikator)
14. [Sumber Dokumentasi Resmi](#14-sumber-dokumentasi-resmi)

---

## 1. Pendahuluan

Dalam Dart, **modifikator** adalah kata kunci yang ditempatkan sebelum sebuah deklarasi (variabel, kelas, anggota kelas, fungsi, atau parameter) untuk mengubah **perilaku**, **batasan akses**, atau **kontrak** dari deklarasi tersebut. Modifikator tidak menambah "apa yang dilakukan" kode secara langsung — ia menambah **aturan main** di sekitar kode itu: kapan boleh diubah, siapa yang boleh mewarisi, kapan nilai ditentukan, dan seterusnya.

Dart itu istimewa karena tidak punya `public` / `private` / `protected` seperti Java atau C#. Sebagai gantinya, Dart mengandalkan kombinasi **konvensi penamaan** (garis bawah `_`) dan **modifikator kelas** (`base`, `interface`, `final`, `sealed`) yang jauh lebih granular dan eksplisit ketimbang model OOP klasik. Ini adalah salah satu keputusan desain paling khas dari bahasa ini.

Dokumen ini mencakup seluruh kategori modifikator — dari variabel dasar (`var`, `final`, `const`, `late`) hingga fitur terbaru **Primary Constructors** yang baru memerlukan Dart 3.13+. Setiap kode dijamin sesuai dengan sintaks resmi yang telah diverifikasi langsung dari dart.dev per penyusunan dokumen ini (Agustus 2026).

---

## 2. Modifikator Variabel & Nilai

### 2.1 `var`

`var` memberi tahu compiler untuk **menyimpulkan (infer)** tipe data dari nilai awal. Setelah disimpulkan, tipe tersebut statis dan tidak bisa diganti — hanya *nilainya* yang bisa berubah.

```dart
var nama = 'Budi Santoso';   // disimpulkan sebagai String
var umur = 27;               // disimpulkan sebagai int
var aktif = true;            // disimpulkan sebagai bool

nama = 'Andi Wijaya';        // OK — masih String
// nama = 123;               // ERROR — tidak bisa berubah tipe setelah disimpulkan
```

### 2.2 `final`

`final` mengunci variabel agar hanya bisa diisi **tepat satu kali**, ditentukan saat **runtime**. Objek yang dirujuknya sendiri boleh mutable.

```dart
final tanggalRegistrasi = DateTime.now();
// tanggalRegistrasi = DateTime(2020); // ERROR: variabel final hanya bisa diisi sekali

final daftarBelanja = <String>['Beras', 'Gula'];
daftarBelanja.add('Kopi');   // OK — mengubah ISI list, bukan referensinya
// daftarBelanja = ['Teh'];  // ERROR — referensi tidak bisa diganti
```

### 2.3 `const`

`const` adalah konstanta yang nilainya **wajib diketahui saat kompilasi**. Berbeda dari `final`, objek `const` sepenuhnya immutable — termasuk isinya — dan dua nilai `const` yang identik akan **dikanonisasi** ke satu instance memori yang sama.

```dart
const kecepatanCahaya = 299792458; // meter/detik

class Titik {
  final int x, y;
  const Titik(this.x, this.y); // constructor const
}

void main() {
  const a = Titik(1, 2);
  const b = Titik(1, 2);
  print(identical(a, b)); // true — instance yang sama, bukan cuma "sama nilai"
}
```

> Catatan: instance variable (field dalam kelas) boleh `final`, tetapi **tidak boleh** `const` — hanya variabel top-level, lokal, atau `static const` yang bisa `const`.

### 2.4 `late`

`late` punya dua kegunaan: (1) menunda pemeriksaan inisialisasi non-nullable saat compiler tidak bisa membuktikan nilainya pasti terisi, dan (2) inisialisasi malas (*lazy*) untuk komputasi yang mahal.

```dart
class Konfigurasi {
  late String apiKey; // wajib diisi SEBELUM dipakai, atau runtime error

  void muatDariEnv(String nilai) => apiKey = nilai;
}

// Lazy initialization — hanya dijalankan sekali, saat PERTAMA kali diakses
late String hasilBerat = hitungYangMahal();

String hitungYangMahal() {
  print('Menghitung...');
  return 'Selesai';
}
```

### 2.5 `final` vs `const`: Perbandingan

| Aspek | `final` | `const` |
|---|---|---|
| Kapan nilai ditentukan | Runtime | Compile-time |
| Bisa diisi ulang | Tidak (sekali saja) | Tidak (sekali saja) |
| Isi objek bisa diubah | Bisa (jika objeknya sendiri mutable) | Tidak — seluruhnya immutable |
| Boleh jadi instance variable | Ya | Tidak |
| Dikanonisasi (instance sama utk nilai sama) | Tidak | Ya |

### 2.6 Wildcard Variable `_` (Dart 3.7+)

Sejak Dart 3.7, identifier `_` **tunggal** (persis satu garis bawah, bukan prefiks) berfungsi sebagai *placeholder* non-binding — nilainya dieksekusi tapi tidak bisa diakses. Ini **berbeda** dari privasi library (bagian 3) yang memakai `_` sebagai *prefiks* nama.

```dart
for (var _ in [1, 2, 3]) {
  print('Perulangan berjalan, nilainya diabaikan');
}

try {
  throw Exception('Gagal!');
} catch (_) {
  print('Terjadi kesalahan, detail diabaikan');
}
```

**Sumber:** [dart.dev/language/variables](https://dart.dev/language/variables)

---

## 3. Modifikator Visibilitas (Privasi Pustaka)

Dart **tidak punya** kata kunci `public`/`private`/`protected`. Privasi ditentukan murni oleh konvensi: identifier yang **diawali** `_` bersifat privat terhadap **library** (biasanya setara satu file) tempat ia dideklarasikan — bukan privat terhadap kelas.

```dart
class RekeningBank {
  double _saldo = 0; // privat terhadap LIBRARY, bukan hanya class ini

  double get saldo => _saldo; // expose lewat getter publik

  void _validasi(double jumlah) {
    if (jumlah <= 0) throw ArgumentError('Jumlah harus lebih besar dari nol');
  }

  void setor(double jumlah) {
    _validasi(jumlah);
    _saldo += jumlah;
  }
}
```

**Wawasan penting:** karena privasi berbasis *library* (bukan *class*), dua kelas yang dideklarasikan dalam file yang sama bisa saling mengakses anggota privat satu sama lain — pola ini mirip "friend class" di C++, dan menjadi salah satu alasan Effective Dart merekomendasikan mengelompokkan kelas-kelas yang erat kaitannya dalam satu library.

**Sumber:** [dart.dev/effective-dart/design — Libraries](https://dart.dev/effective-dart/design)

---

## 4. Modifikator Kelas (Dart 3.0+)

Ini adalah modifikator paling kuat sekaligus paling sering disalahpahami di Dart modern. Fungsinya mengontrol **dari luar library**, siapa yang boleh mengonstruksi, meng-*extend*, atau meng-*implement* sebuah kelas.

### 4.1 Tanpa Modifikator (Default)

Tanpa modifikator apa pun, sebuah kelas bebas dikonstruksi, di-*extend*, di-*implement*, maupun di-*mixin*-kan dari library mana pun.

```dart
class Hewan {
  void bersuara() => print('...');
}
```
```dart
// Dari library lain — SEMUA diperbolehkan:
Hewan h = Hewan();                                  // konstruksi
class Anjing extends Hewan { ... }                   // extends
class RobotAnjing implements Hewan { ... }            // implements
```

### 4.2 `abstract`

Kelas `abstract` tidak bisa diinstansiasi dari library mana pun (termasuk library sendiri), dan biasanya berisi method abstrak yang wajib diimplementasikan turunannya.

```dart
abstract class Bentuk {
  double get luas; // anggota abstrak — wajib diimplementasikan turunan

  void cetakInfo() => print('Luas bentuk ini: $luas'); // boleh punya method konkret
}

class Lingkaran extends Bentuk {
  final double jariJari;
  Lingkaran(this.jariJari);

  @override
  double get luas => 3.14159 * jariJari * jariJari;
}

// Bentuk b = Bentuk(); // ERROR: abstract class tidak bisa diinstansiasi
```

> Tip: jika ingin kelas abstrak "terlihat" bisa diinstansiasi, gunakan *factory constructor* (lihat 5.4).

### 4.3 `base`

`base` **mewajibkan pewarisan implementasi**: kelas hanya bisa di-*extend*, tidak boleh di-*implement* dari luar library-nya. Ini menjamin constructor dasar selalu berjalan dan seluruh anggota privat tetap terwarisi.

```dart
// File: akun.dart
base class Akun {
  double saldo = 0;
  void tarik(double jumlah) { /* ... */ }
}
```
```dart
// File lain
import 'akun.dart';

Akun a = Akun();                          // Boleh: konstruksi langsung

base class AkunPremium extends Akun {     // Boleh: extends — TAPI subclass-nya
  int poinLoyalitas = 0;                  // WAJIB juga base/final/sealed
}

// class AkunPalsu implements Akun { }
// ERROR: tidak bisa di-implement dari luar library karena ditandai 'base'
```

### 4.4 `interface`

Kebalikan dari `base`: `interface` **mewajibkan implementasi ulang**, hanya bisa di-*implement*, tidak boleh di-*extend* dari luar library. Ini mengurangi risiko *fragile base class problem* — pemanggilan method internal antar-method dijamin memakai implementasi milik library sendiri.

```dart
// File: pembayaran.dart
interface class Pembayaran {
  void proses(double jumlah) => print('Memproses Rp$jumlah');
}
```
```dart
import 'pembayaran.dart';

Pembayaran p = Pembayaran();  // Boleh: konstruksi langsung

// class TransferBank extends Pembayaran { }
// ERROR: tidak bisa di-extends dari luar library

class TransferBank implements Pembayaran {  // Boleh: implements
  @override
  void proses(double jumlah) => print('Transfer bank sejumlah Rp$jumlah');
}
```

#### `abstract interface`

Kombinasi paling umum untuk mendefinisikan **kontrak murni** (pure interface), setara `interface` di Java/TypeScript — bisa di-*implement* dari luar, tidak bisa di-*extend*, dan tidak bisa diinstansiasi langsung.

```dart
abstract interface class Notifikasi {
  void kirim(String pesan);
}

class NotifikasiEmail implements Notifikasi {
  @override
  void kirim(String pesan) => print('Email terkirim: $pesan');
}
```

### 4.5 `final` (Sebagai Modifikator Kelas)

`final` pada kelas **menutup total** hierarki tipe dari luar library — tidak bisa di-*extend* maupun di-*implement*. Ini menjamin Anda bisa menambah anggota API secara bertahap tanpa risiko method-nya di-*override* pihak ketiga.

```dart
// File: konfigurasi.dart
final class KonfigurasiSistem {
  final String versi;
  KonfigurasiSistem(this.versi);
}
```
```dart
import 'konfigurasi.dart';

KonfigurasiSistem k = KonfigurasiSistem('1.0'); // Boleh: konstruksi

// class KonfigurasiKhusus extends KonfigurasiSistem { }     // ERROR
// class KonfigurasiTiruan implements KonfigurasiSistem { }  // ERROR
```

> `final` "mewarisi" efek `base` — dalam library yang sama, `final class` masih boleh di-*extend*/di-*implement*, tapi subclass-nya wajib ditandai `base`, `final`, atau `sealed` juga.

### 4.6 `sealed`

`sealed` membuat **himpunan subtipe yang tertutup dan diketahui** oleh compiler. Kelas `sealed` implisit `abstract` (tidak bisa diinstansiasi), dan compiler bisa memverifikasi `switch` yang **exhaustive** (mencakup semua kemungkinan subtipe) — sangat berguna untuk memodelkan "state" tertutup seperti hasil operasi jaringan.

```dart
sealed class HasilOperasi {}

class Sukses extends HasilOperasi {
  final String data;
  Sukses(this.data);
}

class Gagal extends HasilOperasi {
  final String pesanError;
  Gagal(this.pesanError);
}

String tangani(HasilOperasi hasil) {
  return switch (hasil) {
    Sukses s => 'Berhasil: ${s.data}',
    Gagal g => 'Gagal: ${g.pesanError}',
    // Tidak perlu 'default' — kalau ada subtipe baru yang belum ditangani,
    // compiler akan MEMBERI ERROR di titik ini (exhaustiveness checking)
  };
}
```

> Jika tidak butuh exhaustive switch, atau ingin bebas menambah subtipe baru tanpa mematahkan API, gunakan `final` alih-alih `sealed`.

### 4.7 Kombinasi Modifikator

Urutan penulisan (kalau digabung) **wajib** mengikuti pola berikut:

```
(opsional) abstract → (opsional, pilih SATU) base | interface | final | sealed → (opsional) mixin → class
```

**Kombinasi yang TIDAK valid:**

| Kombinasi | Alasan |
|---|---|
| `abstract` + `sealed` | Redundan — `sealed` sudah implisit `abstract` |
| `interface`/`final`/`sealed` + `mixin` | Kontradiktif — ketiganya melarang "mixing in", padahal `mixin` justru mengizinkannya |

Hanya `base` yang boleh mendahului deklarasi `mixin` murni (`base mixin Nama { }`). Untuk peta kombinasi selengkapnya, lihat [Class modifier reference](https://dart.dev/language/modifier-reference) resmi.

### 4.8 `class`, `mixin`, atau `mixin class`?

`mixin class` (Dart 3.0+) mendefinisikan deklarasi yang bisa dipakai **baik sebagai class biasa maupun sebagai mixin**, dengan nama dan tipe yang sama.

```dart
mixin class Auditable {
  DateTime? waktuDiubah;
  void tandaiDiubah() => waktuDiubah = DateTime.now();
}

class Dokumen with Auditable {       // dipakai sebagai MIXIN
  String judul = '';
}

class LogEntry extends Auditable {   // dipakai sebagai CLASS biasa
  String pesan = '';
}
```

Batasan: `mixin class` tidak boleh punya klausa `extends` atau `on` (sama seperti mixin murni). Effective Dart menyarankan: **utamakan `mixin` murni atau `class` murni** — `mixin class` terutama berguna untuk migrasi kode lama, bukan untuk kode baru.

**Sumber:** [dart.dev/language/class-modifiers](https://dart.dev/language/class-modifiers) · [dart.dev/language/mixins](https://dart.dev/language/mixins)

---

## 5. Modifikator Anggota Kelas

### 5.1 `static`

`static` menjadikan anggota **milik kelas itu sendiri**, bukan milik instance mana pun — diakses lewat `NamaKelas.anggota`, dibagikan ke semua instance.

```dart
class KonversiSuhu {
  static const double bekuCelsius = 0;
  static double celsiusKeFahrenheit(double c) => c * 9 / 5 + 32;
}

void main() => print(KonversiSuhu.celsiusKeFahrenheit(37));
```

### 5.2 `covariant`

`covariant` mengizinkan Anda **mempersempit** tipe parameter saat *override*, dengan konsekuensi: pengecekan tipe berpindah dari compile-time ke **runtime**.

```dart
class Hewan {}
class Kucing extends Hewan {}

class Kandang {
  void tempatkan(Hewan h) => print('Menempatkan hewan di kandang');
}

class KandangKucing extends Kandang {
  @override
  void tempatkan(covariant Kucing k) => print('Menempatkan kucing di kandang khusus');
}
```

> Pakai `covariant` seminimal mungkin — setiap pemakaiannya memindahkan jaminan keamanan tipe dari compiler ke runtime, sehingga kesalahan tipe baru ketahuan saat aplikasi berjalan, bukan saat kompilasi.

### 5.3 `external`

`external` menandai bahwa **implementasi** sebuah deklarasi ada **di luar** file deklarasinya — biasanya kode native, VM internal, atau interop platform lain (C, JavaScript, dsb).

```dart
class Sensor {
  external double bacaSuhu(); // implementasinya ada di kode native/platform
}
```

`external` bisa dipakai pada top-level function, instance method, getter/setter, constructor non-redirecting, bahkan instance variable (yang otomatis setara getter+setter external).

### 5.4 `factory`

Constructor `factory` **tidak selalu** membuat instance baru — cocok untuk pola seperti singleton, caching, atau memilih subclass secara dinamis.

```dart
class Logger {
  static final Map<String, Logger> _cache = {};
  final String nama;

  Logger._internal(this.nama); // constructor privat, hanya dipakai internal

  factory Logger(String nama) {
    return _cache.putIfAbsent(nama, () => Logger._internal(nama));
  }
}

void main() {
  var log1 = Logger('network');
  var log2 = Logger('network');
  print(identical(log1, log2)); // true — instance yang sama dikembalikan
}
```

### 5.5 `get` & `set`

Setiap akses properti di Dart — bahkan field biasa — sesungguhnya adalah pemanggilan getter/setter di balik layar. `get`/`set` eksplisit memungkinkan nilai dihitung saat diakses/diubah, sekaligus memisahkan kontrak publik dari detail penyimpanan internal.

```dart
import 'dart:math';

class Persegi {
  double sisi;
  Persegi(this.sisi);

  double get luas => sisi * sisi;          // getter — diakses TANPA tanda kurung
  double get keliling => sisi * 4;

  set luas(double nilaiLuas) {             // setter — satu argumen, tanpa return value
    sisi = nilaiLuas > 0 ? sqrt(nilaiLuas) : 0;
  }
}
```

**Sumber:** [dart.dev/language/functions#getters-and-setters](https://dart.dev/language/functions) · [dart.dev/language/constructors#factory-constructors](https://dart.dev/language/constructors) · [dart.dev/language/type-system#covariant-keyword](https://dart.dev/language/type-system)

---

## 6. Modifikator Fungsi & Generator

### 6.1 `async`

Menjadikan fungsi mengembalikan `Future`, memperbolehkan pemakaian `await` di dalamnya.

```dart
Future<String> ambilDataPengguna(int id) async {
  await Future.delayed(Duration(seconds: 1)); // simulasi permintaan jaringan
  return 'Pengguna #$id';
}
```

### 6.2 `async*` — Generator Asinkron

Mengembalikan `Stream`, memakai `yield` untuk mengirim nilai satu per satu secara asinkron.

```dart
Stream<int> hitungMundur(int dari) async* {
  for (int i = dari; i >= 0; i--) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}
```

### 6.3 `sync*` — Generator Sinkron

Mengembalikan `Iterable`, dievaluasi secara *lazy* (malas) setiap kali diminta elemen berikutnya.

```dart
Iterable<int> bilanganAsli(int n) sync* {
  int k = 0;
  while (k < n) {
    yield k++;
  }
}
```

> Untuk generator rekursif, `yield*` mendelegasikan seluruh sub-urutan sekaligus (lebih efisien daripada memanggil ulang secara manual dalam loop).

### 6.4 `operator`

Memungkinkan *overloading* operator bawaan (`+`, `-`, `==`, dll.) agar objek kustom bisa dipakai dengan sintaks operator alami.

```dart
class Vektor2D {
  final double x, y;
  const Vektor2D(this.x, this.y);

  Vektor2D operator +(Vektor2D lain) => Vektor2D(x + lain.x, y + lain.y);
  Vektor2D operator *(double skalar) => Vektor2D(x * skalar, y * skalar);

  @override
  bool operator ==(Object other) =>
      other is Vektor2D && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Vektor2D($x, $y)';
}
```

**Sumber:** [dart.dev/language/functions#generators](https://dart.dev/language/functions) · [dart.dev/language/methods#operators](https://dart.dev/language/methods)

---

## 7. Modifikator & Konstruksi Parameter

### 7.1 `required`

Named parameter defaultnya opsional — `required` menjadikannya wajib diisi pemanggil.

```dart
void daftarkanPengguna({
  required String nama,
  required String email,
  int umur = 18,     // ada default → otomatis opsional
  String? alamat,    // nullable tanpa default → opsional, default-nya null
}) {
  print('Mendaftarkan $nama ($email)');
}

// daftarkanPengguna(nama: 'Sari'); // ERROR: 'email' wajib diisi
daftarkanPengguna(nama: 'Sari', email: 'sari@contoh.id');
```

### 7.2 Optional Positional `[...]`

```dart
String sapa(String nama, [String? gelar, String? kota]) {
  var hasil = 'Halo';
  if (gelar != null) hasil += ' $gelar';
  hasil += ' $nama';
  if (kota != null) hasil += ' dari $kota';
  return hasil;
}

print(sapa('Dewi'));                  // Halo Dewi
print(sapa('Dewi', 'Dr.', 'Malang')); // Halo Dr. Dewi dari Malang
```

### 7.3 ⚠️ Catatan Penting: `final`/`var` pada Parameter Fungsi Biasa

Sejak **Dart 3.13**, `final` dan `var` **tidak lagi bisa** dipakai pada parameter fungsi biasa — kedua kata kunci ini kini dikhususkan untuk *primary constructor* (lihat 7.4). Jika ingin memaksa parameter tidak diubah dalam fungsi, gunakan linter [`parameter_assignments`](https://dart.dev/tools/linter-rules/parameter_assignments), bukan kata kunci `final` pada parameter.

```dart
// void proses(final int x) { }  // ERROR sejak Dart 3.13 pada fungsi biasa
void proses(int x) { }           // Cara yang benar
```

### 7.4 🆕 Primary Constructors (Dart 3.13+)

Ini fitur **paling baru** dalam ranah modifikator Dart. Primary constructor memungkinkan deklarasi field dan constructor utama dalam **satu baris** di header kelas, tepat di mana `var`/`final` sekarang benar-benar bersinar sebagai modifikator parameter.

```dart
// ============ SEBELUM (cara tradisional) ============
class Titik {
  final int x;
  final int y;
  Titik(this.x, this.y);
}

// ============ SESUDAH (primary constructor) ============
class Titik(final int x, final int y);
```

Parameter dengan modifikator `var` atau `final` di primary constructor disebut **declaring parameter** — otomatis membangkitkan *field* dengan nama yang sama. Parameter tanpa modifikator ini berperilaku seperti parameter constructor biasa (tidak membuat field).

```dart
class User(String name);            // TIDAK membuat field — parameter biasa
class Point(var int x, var int y);  // Membuat field x dan y

// Named parameter privat: garis bawah otomatis "dihilangkan" untuk pemanggil
class Pengguna({required var String _nama});
// Dipanggil dengan: Pengguna(nama: 'Rudi')  ← tanpa underscore di sisi pemanggil,
// tapi field internalnya tetap privat: _nama
```

> ⚠️ **Catatan versi:** primary constructor memerlukan *language version* minimal **3.13**. Pastikan `environment: sdk: ^3.13.0` (atau lebih baru) di `pubspec.yaml` sebelum memakai sintaks ini. Fitur ini juga berlaku pada `enum` (`enum Warna(final String hex) { merah('#FF0000'); }`), meski dengan sedikit batasan tambahan untuk `mixin class` dan `extension type`.

**Sumber:** [dart.dev/language/functions#named-parameters](https://dart.dev/language/functions) · [dart.dev/language/primary-constructors](https://dart.dev/language/primary-constructors)

---

## 8. Kata Kunci Relasi Antar Kelas

`extends` (pewarisan tunggal), `implements` (penerapan interface implisit), `with` (mixin), `super` (rujukan ke induk), dan anotasi `@override` (verifikasi bahwa anggota benar-benar meng-*override* sesuatu) biasanya dipakai bersamaan dalam desain kelas nyata:

```dart
abstract class Karyawan {
  final String nama;
  Karyawan(this.nama);
  double hitungGaji();
}

mixin PenerimaBonus {
  double bonus = 0;
  double tambahBonus(double gajiPokok) => gajiPokok + bonus;
}

class Manajer extends Karyawan with PenerimaBonus implements Comparable<Manajer> {
  final double gajiPokok;
  Manajer(super.nama, this.gajiPokok); // 'super.nama' meneruskan ke constructor induk

  @override
  double hitungGaji() => tambahBonus(gajiPokok);

  @override
  int compareTo(Manajer lain) => hitungGaji().compareTo(lain.hitungGaji());
}
```

Urutan klausa dalam header kelas **wajib**: `extends` → `with` → `implements`.

**Sumber:** [dart.dev/language/extend](https://dart.dev/language/extend) · [dart.dev/language/mixins](https://dart.dev/language/mixins)

---

## 9. Operator Null Safety Terkait

```dart
String? namaOpsional;        // '?' — tipe nullable
String namaWajib = 'Rina';   // tanpa '?' — non-nullable, wajib diinisialisasi

void proses(String? masukan) {
  // '!' — null assertion: MEMAKSA compiler percaya nilainya tidak null.
  // BERBAHAYA jika ternyata null → melempar exception saat runtime.
  // print(masukan!.length);

  if (masukan != null) {
    print(masukan.length); // di sini Dart TAHU 'masukan' pasti String (promosi tipe)
  }

  print(masukan?.length);       // '?.' — akses aman, null jika objeknya null
  print(masukan?.length ?? 0);  // '??' — nilai alternatif kalau kiri-nya null
  masukan ??= 'Default';        // '??=' — isi HANYA jika saat ini null
}
```

**Sumber:** [dart.dev/null-safety](https://dart.dev/null-safety) · [dart.dev/null-safety/understanding-null-safety](https://dart.dev/null-safety/understanding-null-safety)

---

## 10. Anotasi (Metadata) Terkait

Bukan "modifikator" dalam artian ketat, tapi sangat erat kaitannya karena juga mengubah bagaimana compiler/analyzer memperlakukan sebuah deklarasi.

```dart
class Kalkulator {
  @Deprecated('Gunakan tambah() sebagai gantinya, akan dihapus di versi 2.0')
  int jumlahkan(int a, int b) => a + b;

  int tambah(int a, int b) => a + b;

  @override
  String toString() => 'Kalkulator';

  @pragma('vm:prefer-inline')
  int kuadrat(int x) => x * x;
}
```

- `@override` — diperiksa analyzer untuk memastikan anggota yang ditandai **benar-benar** meng-override sesuatu dari superclass/interface (menangkap salah ketik lebih awal).
- `@deprecated` (huruf kecil) — konstanta bawaan dengan pesan generik; `@Deprecated('pesan')` (huruf besar, memanggil constructor) — memungkinkan pesan kustom.
- `@pragma(...)` — petunjuk khusus kompiler/VM (mis. hint inlining); string pragma bersifat spesifik-implementasi.
- Anotasi seperti `@protected`, `@visibleForTesting`, `@immutable` **bukan** bagian dari bahasa inti — itu berasal dari paket [`meta`](https://pub.dev/packages/meta) milik tim Dart, bukan keyword native.

**Sumber:** [dart.dev/language/metadata](https://dart.dev/language/metadata)

---

## 11. Kata Kunci Deklarasi Terkait Lainnya

### `extension`
```dart
extension StringExtension on String {
  String get dibalik => split('').reversed.join('');
}

void main() => print('Dart'.dibalik); // 'traD'
```

### `typedef`
```dart
typedef Validator = bool Function(String nilai);

bool validasiEmail(String nilai) => nilai.contains('@');

void jalankanValidasi(String nilai, Validator validator) {
  print(validator(nilai) ? 'Valid' : 'Tidak valid');
}
```

### `deferred` (Lazy Import)
```dart
import 'package:paket_besar/paket_besar.dart' deferred as besar;

Future<void> muatSaatDibutuhkan() async {
  await besar.loadLibrary();
  besar.fungsiBerat();
}
```

### `show` / `hide`
```dart
import 'dart:math' show pi, sqrt;
import 'dart:math' hide Random;
```

**Sumber:** [dart.dev/language/extension-methods](https://dart.dev/language/extension-methods) · [dart.dev/language/typedefs](https://dart.dev/language/typedefs) · [dart.dev/language/libraries](https://dart.dev/language/libraries)

---

## 12. Tabel Ringkasan Lengkap

| Kata Kunci | Kategori | Fungsi Singkat | Sejak |
|---|---|---|---|
| `var` | Variabel | Tipe disimpulkan, bisa diubah | — |
| `final` | Variabel / Kelas | Sekali isi (var) / tutup extend+implement (kelas) | — |
| `const` | Variabel / Constructor | Konstanta compile-time, immutable & dikanonisasi | — |
| `late` | Variabel | Inisialisasi ditunda / lazy | — |
| `_` (prefiks) | Identifier | Privat terhadap library | — |
| `_` (wildcard tunggal) | Variabel | Placeholder non-binding | 3.7 |
| `abstract` | Kelas | Tidak bisa diinstansiasi langsung | — |
| `base` | Kelas / Mixin | Wajib extend, larang implement dari luar | 3.0 |
| `interface` | Kelas | Wajib implement, larang extend dari luar | 3.0 |
| `sealed` | Kelas | Set subtipe tertutup + exhaustive switch | 3.0 |
| `mixin` (modifier) | Kelas | Bisa dipakai sbg class ATAU mixin | 3.0 |
| `static` | Anggota | Milik kelas, bukan instance | — |
| `covariant` | Parameter | Persempit tipe param saat override | — |
| `external` | Fungsi / Anggota | Implementasi berada di luar deklarasi | — |
| `factory` | Constructor | Tidak selalu membuat instance baru | — |
| `get` / `set` | Anggota | Getter / setter | — |
| `async` | Fungsi | Mengembalikan `Future` | — |
| `async*` | Fungsi | Generator asinkron → `Stream` | — |
| `sync*` | Fungsi | Generator sinkron → `Iterable` | — |
| `operator` | Anggota | Overload operator | — |
| `required` | Parameter | Named parameter wajib diisi | — |
| `var` / `final` (primary ctor) | Parameter | Declaring parameter → otomatis buat field | 3.13 |
| `extends` | Kelas | Pewarisan tunggal | — |
| `implements` | Kelas | Penerapan interface implisit | — |
| `with` | Kelas | Mixin | — |
| `super` | Constructor / Method | Rujukan ke induk | — |
| `?` | Tipe | Nullable | Null safety |
| `!` | Ekspresi | Null assertion | Null safety |
| `?.` | Ekspresi | Akses aman | Null safety |
| `??` / `??=` | Ekspresi | Nilai alternatif / isi jika null | Null safety |

---

## 13. Best Practices: Cara Terbaik Merancang dengan Modifikator

1. **Utamakan `final` di atas `var`** untuk field dan variabel top-level yang tidak berubah (linter: `prefer_final_fields`). State yang tidak mutable lebih mudah dinalar dan lebih aman terhadap efek samping tak terduga.
2. **Nyatakan intent API lewat class modifier**, bukan komentar dokumentasi. Gunakan `final class`/`interface class`/`base class`/`sealed class` secara sadar — ini membuat compiler yang menegakkan aturan, bukan sekadar harapan di komentar.
3. **Pertimbangkan constructor `const`** jika semua field final dan constructor cuma menginisialisasi — tapi ingat ini komitmen API publik: mencabutnya nanti adalah *breaking change* bagi pengguna yang sudah memakainya dalam konteks konstan.
4. **Getter/setter hanya untuk operasi yang "field-like"**: tanpa argumen (getter), idempotent, tanpa efek samping yang terlihat pengguna, dan tidak melakukan pekerjaan yang "mengejutkan" secara biaya (mis. I/O jaringan sebaiknya jadi method, bukan getter).
5. **Hindari `late final` publik tanpa initializer** — secara diam-diam ini menghasilkan *setter publik*, yang jarang benar-benar diinginkan. Alternatif: inisialisasi di deklarasi, jadikan privat dengan getter publik, atau pakai factory constructor.
6. **Utamakan `mixin` murni atau `class` murni** ketimbang `mixin class`, kecuali benar-benar perlu keduanya sekaligus (biasanya untuk migrasi kode lama).
7. **Defaultkan ke privat.** Deklarasi publik adalah komitmen dukungan jangka panjang. Tambahkan `_` kecuali memang ingin library lain mengaksesnya.
8. **Pakai `covariant` seminimal mungkin** — setiap pemakaiannya memindahkan jaminan keamanan tipe dari compile-time ke runtime.
9. **Gunakan `Future<void>`**, bukan `Future` polos, untuk method asinkron yang tidak menghasilkan nilai berguna namun tetap perlu di-`await` pemanggilnya.
10. **Manfaatkan `sealed` untuk merepresentasikan "state" tertutup** (mis. hasil operasi jaringan, status UI) agar `switch` bisa exhaustive dan compiler otomatis mengingatkan saat ada kasus baru yang belum ditangani.

**Sumber:** [dart.dev/effective-dart/design](https://dart.dev/effective-dart/design) · [dart.dev/effective-dart/usage](https://dart.dev/effective-dart/usage)

---

## 14. Sumber Dokumentasi Resmi

| Topik | Tautan |
|---|---|
| Variabel (`var`, `final`, `const`, `late`, wildcard) | https://dart.dev/language/variables |
| Modifikator kelas (overview) | https://dart.dev/language/class-modifiers |
| Modifikator kelas untuk maintainer API | https://dart.dev/language/class-modifiers-for-apis |
| Referensi kombinasi modifikator | https://dart.dev/language/modifier-reference |
| Mixin & `mixin class` | https://dart.dev/language/mixins |
| Constructors (`factory`, redirecting, dsb.) | https://dart.dev/language/constructors |
| Primary constructors (Dart 3.13+) | https://dart.dev/language/primary-constructors |
| Functions (parameter, generator, `external`, getter/setter) | https://dart.dev/language/functions |
| Methods (`operator`, instance/abstract method) | https://dart.dev/language/methods |
| Classes (implicit interface) | https://dart.dev/language/classes |
| Extend a class (`extends`, `super`) | https://dart.dev/language/extend |
| Extension methods | https://dart.dev/language/extension-methods |
| Typedefs | https://dart.dev/language/typedefs |
| Type system (`covariant`) | https://dart.dev/language/type-system |
| Libraries & imports (`show`/`hide`/`deferred`) | https://dart.dev/language/libraries |
| Metadata (anotasi) | https://dart.dev/language/metadata |
| Null safety | https://dart.dev/null-safety |
| Understanding null safety | https://dart.dev/null-safety/understanding-null-safety |
| Daftar seluruh keyword Dart | https://dart.dev/language/keywords |
| Effective Dart: Design | https://dart.dev/effective-dart/design |
| Effective Dart: Usage | https://dart.dev/effective-dart/usage |
| Effective Dart: Style | https://dart.dev/effective-dart/style |
| Dart API Reference | https://api.dart.dev |
| Versi bahasa (language versioning) | https://dart.dev/language/versioning |

[Konstanta][1]
[final][2]

[1]: ./constanta/README.md
[2]: ./final/README.md
