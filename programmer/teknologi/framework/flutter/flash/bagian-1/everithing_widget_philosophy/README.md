### ✅ Poin yang Tepat

- **Everything is a Widget**: Apapun di layar Flutter adalah hasil dari widget.
  - Tulisan? ➝ `Text` widget
  - Gambar? ➝ `Image` widget
  - Tombol? ➝ `ElevatedButton`, `TextButton`, dll.
  - Padding, margin, alignment? ➝ juga widget (`Padding`, `Align`, dll.)
- **Widget sebagai Objek**: Widget adalah instance dari class di Dart, dan sifatnya immutable (tidak berubah; update = buat baru).
- **Deklaratif**: Anda menyusun UI dengan menyatakan “apa” yang ingin ditampilkan, bukan “bagaimana” mengubahnya. Ini sangat berbeda dengan imperative UI seperti di Android View lama atau Swing.

---

### 🧠 Nuansa yang Bisa Ditekankan Lagi

- **Widget bukan yang benar-benar berubah di runtime** → yang berubah adalah _Element_ (instance dari widget) dan _RenderObject_-nya. Widget didefinisikan ulang tiap kali `build()` dipanggil, tapi Flutter menangani perubahan dengan cerdas.
- **Immutable** itu menguntungkan: karena setiap perubahan UI = deklarasi widget baru, maka kita bisa “membayangkan ulang” UI tanpa tracking step-by-step perubahannya (tanpa `setText()` seperti di UI imperative).
- **Consistency**: filosofi ini membuat kita tak perlu belajar komponen lain: semua widget apakah struktur (`Column`), tampilan (`Text`), atau perilaku (`GestureDetector`) kesemuanya akan ditangani dengan prinsip serupa.

---

### 🔍 Contoh Kecil

```dart
return Padding(
  padding: const EdgeInsets.all(8),
  child: Column(
    children: [
      Text('Halo, Flutter!'),
      ElevatedButton(
        onPressed: () => print('Klik!'),
        child: Text('Tekan Saya'),
      ),
    ],
  ),
);
```

Di atas:

- `Padding`, `Column`, `Text`, `ElevatedButton`, bahkan teks `'Halo, Flutter!'` kesemuanya adalah widget.
- Kita hanya cukup menyusun UI berdasarkan _struktur hierarki widget_ sementara Flutter akan menangani rendering dari bawah permukaan.

---

## ✅ 1. _Deklarasi UI = f(State)_ Tanpa `setState()`

Kalau Anda hanya mendeklarasikan UI sebagai fungsi dari state (**`UI = f(state)`**), tapi _tidak pernah memberi tahu Flutter saat state berubah_, maka UI tetap seperti semula. Kenapa? Karena **Flutter tidak tahu bahwa ada yang berubah**.

Contoh:

```dart
int _count = 0;

Widget build(BuildContext context) {
  return Text('$_count');
}

void increment() {
  _count++; // berubah...
  // ...tapi lupa panggil setState(), maka UI diam saja
}
```

Jadi meskipun nilai `_count` sudah naik, `Text('$_count')` tetap menampilkan angka lama karena **tidak terjadi rebuild**. Inilah sebabnya _“deklaratif saja tidak cukup—harus ada pemicu perubahan”_, dan itu tugas `setState()`.

---

## 🔗 2. `setState()` Sebagai Penghubung UI ⇄ Logika

Ini intinya:

> **`setState()` menjembatani perubahan data (logika/business logic) agar tercermin ke dalam UI.**

Maka, bila Anda punya logika seperti:

```dart
if (stokBarang < 1) {
  tampilkanNotifikasi();     // logika bisnis
  ubahWarnaTombolMenjadiAbu(); // efek visual
}
```

...bagian _"ubah visual"_ harus dikaitkan ke Flutter via `setState()` supaya UI terupdate.

---

## 🧬 Hubungan 3-Way/3-Arah

Anda bisa membayangkan seperti ini:

| Komponen       | Peran                                                                         |
| -------------- | ----------------------------------------------------------------------------- |
| **State**      | Data saat ini (bisa berubah sewaktu-waktu)                                    |
| **Widget**     | UI statis yang menggambarkan _state saat itu_                                 |
| **setState()** | Pemicu rebuild untuk mengubah _widget lama_ jadi _widget baru_ berbasis state |

Tanpa `setState()`, hubungan itu terputus.

---

## ⚠️ Penegasan Tambahan

- `setState()` tidak mengubah **state itu sendiri**, tapi hanya memberi sinyal ke Flutter: _“tolong render ulang ya.”_
- Ia bekerja lokal—hanya pada widget tempat `setState()` dipanggil (bukan seluruh layar).
- Untuk logika bisnis kompleks yang butuh dipakai di banyak tempat, `setState()` biasanya digantikan oleh:
  - `notifyListeners()` (ChangeNotifier)
  - `emit()` (Cubit/BLoC)
  - Penyedia `ref.watch(...)` (Riverpod)

Namun prinsipnya sama: _state berubah → UI harus tahu → UI render ulang berdasarkan data baru._

---

✅ Jadi **`setState()` = jembatan sinkron antara state yang berubah & UI yang harus menyesuaikan.** Tanpa itu, UI hanyalah bayangan lama dari pikiran yang sudah berubah.

### ⚠️ Pitfall yang Umum

- Mengira widget itu “hidup” atau menyimpan state → padahal widget tidak memiliki state internal.
- Bingung kenapa UI tak berubah setelah mengganti nilai → lupa panggil `setState()` atau trigger rebuild.
- Terlalu dalam membuat struktur nested → tidak pakai widget bantu seperti `Spacer`, `Builder`, atau `LayoutBuilder`.

---

### 🧭 Penutup

> **Semua di Flutter adalah widget** — dan itu memberi kita satu bahasa desain tunggal untuk UI, layout, hingga behavior.

---

**[Kembali][0]**

[0]: ../README.md
