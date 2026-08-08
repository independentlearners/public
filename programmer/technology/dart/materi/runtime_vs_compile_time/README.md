# Runtime VS Compile-Time

### **Pendahuluan:**

Dalam Dart (dan banyak bahasa pemrograman lain), mengerti perbedaan _nilai yang dievaluasi_ di **compile-time** versus **runtime** sangat krusial untuk menulis kode yang aman, efisien, dan mudah dipelihara. Di bawah ini kita akan membahas konsep-konsep kunci, istilah-istilah penting, serta contohnya, agar Anda mampu memahami secara mendalam bagaimana compiler Dart bekerja dengan nilai-nilai yang Anda tulis.

---

## 1. Terminologi Utama

| Istilah                   | Definisi                                                                                                  |
| ------------------------- | --------------------------------------------------------------------------------------------------------- |
| **Compiler**              | Program yang menerjemahkan kode sumber (source code) menjadi bentuk yang dapat dijalankan (bytecode/AOT). |
| **Compile-time**          | Tahap saat kode dikompilasi (sebelum dijalankan). Semua pemeriksaan tipe dan konstanta dilakukan di sini. |
| **Runtime**               | Tahap saat program sedang berjalan; semua logika dinamis dieksekusi di sini.                              |
| **Constant (konstanta)**  | Nilai yang tidak berubah sepanjang program.                                                               |
| **Compile-time constant** | Nilai konstanta yang dapat dihitung sepenuhnya oleh compiler tanpa eksekusi program.                      |
| **Runtime constant**      | Nilai yang ditandai `final`–tidak berubah setelah inisialisasi–tetapi dihitung saat program berjalan.     |
| **Literal**               | Bentuk penulisan nilai secara langsung, misalnya `42`, `"halo"`, `[1,2,3]`.                               |
| **Expression (ekspresi)** | Kombinasi literal, variabel, dan operator yang menghasilkan suatu nilai saat dievaluasi.                  |
| **Initializer**           | Kode yang menetapkan nilai awal ke variabel/konstanta.                                                    |
| **AOT (Ahead-Of-Time)**   | Kompilasi penuh sebelum program dijalankan, menghasilkan kode mesin.                                      |
| **JIT (Just-In-Time)**    | Kompilasi sebagian saat runtime, umumnya untuk pengembangan (hot reload).                                 |

---

## 2. Compile-time vs. Runtime: Perbedaan Inti

1. **Waktu Penghitungan**

   - **Compile-time**: Semua pemeriksaan tipe, verifikasi konstanta, dan optimasi dilakukan sebelum program dieksekusi.
   - **Runtime**: Eksekusi logika, alokasi memori dinamis, dan perhitungan nilai yang memerlukan data yang baru tersedia (misalnya input pengguna).

2. **Contoh Compile-time Constant**

   ```dart
   const int maxSuppliers = 100;           // Literal integer
   const String greeting = 'Selamat pagi'; // Literal string
   const List<int> primes = [2, 3, 5, 7];  // List literal
   ```

   Semua di atas dihitung dan disimpan di _read-only memory_ saat kompilasi.

3. **Contoh Runtime Constant (final)**

   ```dart
   final DateTime startTime = DateTime.now();
   final config = loadConfig();             // Fungsi yang memerlukan I/O
   ```

   – Dilabel `final` karena nilai hanya ingin di-assign sekali, tetapi perhitungannya baru terjadi saat runtime.

4. **Kesalahan Umum**

   - Menulis `const DateTime now = DateTime.now();` ⇒ **Error**, karena `DateTime.now()` tidak bisa dievaluasi saat compile-time.
   - Menggunakan ekspresi non-konstan di konteks `const`.

---

## 3. Kapan Harus Pakai `const` vs `final`

| Skenario                                          | Gunakan | Alasan                                                                           |
| ------------------------------------------------- | ------- | -------------------------------------------------------------------------------- |
| Nilai benar-benar tidak berubah, literal saja     | `const` | Mengizinkan compiler untuk optimasi dan interning objek; performa lebih baik.    |
| Nilai ditetapkan sekali tetapi perlu data runtime | `final` | Ekspresi memerlukan informasi runtime (I/O, waktu, random, dll.).                |
| Struktur data besar, perlu di-cache compiler      | `const` | Mengurangi footprint memori karena objek direferensikan bersama (canonicalized). |
| Konfigurasi yang di-load dari file/env            | `final` | Tidak mungkin diketahui saat compile-time.                                       |

> **Tip Semangat**: “Gunakan `const` sebisa mungkin, dan `final` saat terpaksa.” 😉

---

## 4. Bagaimana Compiler Dart Menangani Konstanta

1. **Canonicalization**

   - Objek `const` yang sama persis hanya dialokasikan sekali.
   - Misal:

     ```dart
     const a = [1, 2];
     const b = [1, 2];
     print(identical(a, b)); // true
     ```

2. **Constant Expression Evaluation**

   - Compiler memeriksa apakah suatu ekspresi terdiri dari: literal, referensi konstanta lain, dan operator yang diizinkan (misalnya `+`, `-`, `*`).
   - Jika ya, maka ia dievaluasi di compile-time.

3. **Error pada Konteks `const`**

   - Tidak boleh ada referensi ke variabel `final` atau fungsi yang bukan `const`.
   - Harus dipenuhi aturan _strictly constant_.

---

## 5. Contoh Praktis dan Penjelasan Mendalam

```dart
// 1. Const primitive
const double pi = 3.14159;

// 2. Const complex (evaluasi compile-time)
const double diameter = 10 * pi;

// 3. Final runtime
final double randomNumber = Random().nextDouble();

// 4. Konteks const di constructor
class Circle {
  final double radius;
  const Circle(this.radius);
}

void main() {
  const c1 = Circle(5);       // valid: radius literal
  // const c2 = Circle(randomNumber); // invalid: randomNumber baru ada di runtime
}
```

- **`pi` dan `diameter`** dapat dihitung compiler—aman, cepat, inti memori kecil.
- **`randomNumber`** harus di-assign saat program berjalan—tidak bisa `const`.
- **`Circle`** bisa ditandai `const` constructor, sehingga objek `Circle` dengan parameter compile-time juga jadi konstanta.

---

## 6. Ringkasan & Praktik Terbaik

1. **Kenali kebutuhan**: Apakah nilai Anda benar-benar konstan? Jika ya, gunakan `const`.
2. **Manfaatkan `final`**: Saat Anda hanya perlu assign sekali, tapi butuh runtime data.
3. **Perhatikan canonicalization**: `const` membantu menghemat memori dan meningkatkan performa.
4. **Hindari kesalahan**: Jangan paksa `const` pada ekspresi yang memerlukan runtime.

---

### ⚙️ **Alur Konsep Nilai di Dart (Compile-time vs Runtime)**

```
┌───────────────┐
│   Kode Dart   │
└──────┬────────┘
       │
       ▼
┌──────────────────────┐
│   Apakah nilai bisa  │
│   diketahui saat     │
│   COMPILE-TIME?      │
└──────┬───────▲───────┘
       │       │
    YES│       │NO
       ▼       ▼
┌────────────┐ ┌──────────────────────┐
│   const    │ │ final (Runtime Const)│
│ (Compile-T)│ │  ──────────────────  │
└────┬───────┘ │ Dihitung saat program│
     │         │ berjalan             │
     ▼         └──────────────────────┘
┌──────────────┐
│ Compiler     │
│ Evaluasi &   │
│ Canonicalize │
└──────┬───────┘
       ▼
┌─────────────┐
│ Optimasi    │
│ Memori &    │
│ Performa    │
└─────────────┘
```

---

### 🧠 **Tabel Perbedaan `const` vs `final`**

```
╔════════════╦════════════════════════════════════╗
║  Keyword   ║              Detail                ║
╠════════════╬════════════════════════════════════╣
║  const     ║ Compile-time constant              ║
║            ║ Harus bisa diketahui oleh compiler ║
║            ║ Dievaluasi saat kompilasi          ║
║            ║ Canonicalized (bisa berbagi memori)║
╠════════════╬════════════════════════════════════╣
║  final     ║ Runtime constant                   ║
║            ║ Tidak bisa diubah setelah diisi    ║
║            ║ Diinisialisasi saat program jalan  ║
║            ║ Cocok untuk input, waktu, API, dll ║
╚════════════╩════════════════════════════════════╝
```

---

### 🔍 **Evaluasi Ekspresi oleh Compiler Dart**

```
                ┌──────────────────────┐
                │   Ekspresi dalam     │
                │   inisialisasi       │
                └─────────┬────────────┘
                          │
         ┌────────────────┼───────────────────┐
         ▼                                    ▼
┌──────────────────────┐       ┌──────────────────────────────┐
│ Semua literal, const │       │ Mengandung data dari runtime │
│ dan operator konstan │       │ (seperti DateTime.now(), I/O)│
└────────────┬─────────┘       └───────────────┬──────────────┘
             │                                 │
        Bisa pakai                          Harus pakai
         `const`                             `final`
```

---

### 🧪 **Contoh Evaluasi: Mana yang Valid?**

```
╔═════════════════════════════════════════════════╦══════════════╗
║ Ekspresi                                        ║  Validasi    ║
╠═════════════════════════════════════════════════╬══════════════╣
║ const int x = 10 * 2;                           ║  ✓ Compile-T ║
║ final String id = 'USR-${DateTime.now()}';      ║  ✓ Runtime   ║
║ const now = DateTime.now();                     ║  × Error     ║
║ final pi = 3.14;                                ║  ✓ Runtime   ║
╚═════════════════════════════════════════════════╩══════════════╝
```

---

### 🔄 **Siklus Hidup Nilai `const` dan `final` dalam Eksekusi**

```
                  ┌──────────────┐
                  │ Kode Sumber  │
                  └──────┬───────┘
                         ▼
       ┌────────────────────────────────┐
       │ Compiler Dart (`dart compile`) │
       └────────────┬───────────────────┘
                    │
        ┌───────────▼─────────────┐
        │ Evaluasi const          │
        │ (Compile-time saja)     │
        └────────────┬────────────┘
                     │
      ┌──────────────▼───────────────┐
      │ Konstanta disisipkan langsung│
      │ dalam binary hasil kompilasi │
      └──────────────┬───────────────┘
                     ▼
            ┌────────▼────────┐
            │ Program Jalan   │
            │ Evaluasi `final`│
            │ (runtime only)  │
            └─────────────────┘
```

---

### 📘 Catatan Akhir

- **const** ➜ dievaluasi saat _compile-time_, sangat cepat, hemat memori
- **final** ➜ satu kali assign saat _runtime_, cocok untuk nilai dinamis yang tidak berubah
- **Jika bisa `const`, selalu gunakan `const` terlebih dahulu.**

Dengan memahami detail compile-time vs runtime, memungkinkan menulis kode Dart yang **lebih cepat**, **lebih aman**, dan **mudah dipelihara**. Langkah selanjutnya: cobalah menulis modul kecil dengan perpaduan `const` dan `final`, lalu amati sumber binary AOT untuk melihat optimasinya 🚀

**[Kembali](../modul-2/bagian-1/README.md)**
