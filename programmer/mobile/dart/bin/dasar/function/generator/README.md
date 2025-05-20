Di Dart, _generator function_ adalah fungsi khusus yang mampu menghasilkan (yield) serangkaian nilai secara _lazy_—artinya nilai dihitung dan dikembalikan satu per satu hanya saat dibutuhkan—daripada sekaligus. Generator berguna untuk menghemat memori dan mengekspresikan logika pembuatan daftar atau aliran data yang kompleks dengan lebih ringkas.

Ada **dua** jenis generator function di Dart:

1. **Synchronous Generator**
2. **Asynchronous Generator**

---

## 1. Synchronous Generator (`sync*`)

- **Deklarasi**: tambahkan kata kunci `sync*` setelah tanda tanda panah `→` pada definisi fungsi.
- **Return Type**: harus `Iterable<T>` atau `Iterable<dynamic>`.
- **Kata kunci utama**:

  - `yield`: menghasilkan satu elemen dari iterable.
  - `yield*`: mendelegasikan ke iterable lain (menyisipkan seluruh elemen dari iterable lain).

- **Cara kerja**:

  1. Saat fungsi dipanggil, tidak terjadi perhitungan langsung.
  2. Ketika pengguna mengiterasi (misalnya dengan `for (var x in generator())`), eksekusi berlangsung hingga menemukan `yield`, lalu mengembalikan nilai tersebut.
  3. Eksekusi berhenti sementara (state disimpan) sampai iterasi meminta elemen berikutnya.
  4. Proses berulang hingga fungsi selesai atau `return` terpanggil.

### Contoh

```dart
Iterable<int> countDown(int n) sync* {
  for (int i = n; i >= 0; i--) {
    yield i;                // kembalikan satu nilai i
  }
}
```

- Memanggil `countDown(3)` tidak langsung menghasilkan `[3,2,1,0]`, melainkan akan menghasilkan satu per satu ketika diiterasi.

---

## 2. Asynchronous Generator (`async*`)

- **Deklarasi**: tambahkan kata kunci `async*` setelah tanda panah `→`.
- **Return Type**: harus `Stream<T>` atau `Stream<dynamic>`.
- **Kata kunci utama**:

  - `yield`: menghasilkan satu event (nilai) pada stream.
  - `yield*`: mendelegasikan ke stream lain (menyisipkan event-event dari stream lain).

- **Cara kerja**:

  1. Fungsi dikembalikan segera sebagai objek `Stream<T>`, tanpa memulai logika di dalamnya.
  2. Setiap kali ada listener yang _subscribe_, eksekusi dimulai hingga `yield` pertama.
  3. Setiap `yield` memancarkan event ke listener, kemudian eksekusi menunggu permintaan selanjutnya atau sampai fungsi selesai.
  4. Cocok untuk operasi asinkron seperti I/O, delay, atau panggilan API, karena dapat menunggu `await` di dalamnya.

### Contoh

```dart
Stream<int> timedCount(int n) async* {
  for (int i = 1; i <= n; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;                // kirim event i setiap detik
  }
}
```

- `timedCount(3)` akan memancarkan 1, lalu setelah 1 detik memancarkan 2, lalu 3.

---

### Perbandingan Ringkas

| Fitur                     | `sync*` (Iterable)              | `async*` (Stream)            |
| ------------------------- | ------------------------------- | ---------------------------- |
| Kata kunci deklarasi      | `sync*`                         | `async*`                     |
| Return type               | `Iterable<T>`                   | `Stream<T>`                  |
| Digunakan untuk           | Koleksi lokal, logika CPU-bound | Operasi asinkron, I/O, event |
| Dapat menggunakan `await` | Tidak                           | Ya                           |
| Delegasi                  | `yield* Iterable<T>`            | `yield* Stream<T>`           |

---

### Kapan Menggunakan

- **`sync*`**: saat Anda ingin membangun koleksi dinamis yang _lazy_, contohnya menghasilkan rangkaian bilangan, filter, atau kombinasi data tanpa menampung semuanya dalam memori.
- **`async*`**: saat sumber data Anda bersifat asinkron—misalnya membaca file besar, melakukan polling, menunggu event user, atau melayani request jaringan—dan Anda ingin menyediakan antarmuka stream.

---

Dengan memahami dua jenis generator ini, Anda bisa menulis Dart yang lebih efisien (memori dan performa) serta mudah dibaca ketika bekerja dengan rangkaian data yang kompleks atau asinkron. Semangat mencoba!
