**Penjelasan Istilah “Diketahui Saat Runtime” pada `final` di Dart**

Dalam konteks Dart, pernyataan bahwa nilai variabel `final` “diketahui saat runtime” berarti:

1. **Penentuan Nilai Terjadi Ketika Program Berjalan**

   - Nilai variabel `final` tidak harus sudah tersedia pada saat kode dikompilasi (compile-time).
   - Penetapan nilai hanya terjadi saat program dieksekusi (runtime), misalnya setelah menghitung, membaca masukan pengguna, atau memanggil API.

2. **Kontras dengan `const`**

   - `const` mengharuskan nilai sudah _compile-time constant_, yakni dapat dihitung dan disisipkan ke dalam program saat kompilasi.
   - `final` lebih fleksibel: Anda boleh menggunakan hasil perhitungan, pemanggilan fungsi, atau data eksternal untuk inisialisasi.

---

## Contoh Ilustrasi

```dart
// Contoh A: Inisialisasi pada compile-time (const)
const double pi = 3.14159;

// Contoh B: Inisialisasi pada runtime (final)
final DateTime waktuSekarang = DateTime.now();
print(waktuSekarang);
// Output: 2025-06-10 15:30:12.345  ← baru diketahui saat kode dijalankan
```

- Pada **Contoh A**, `pi` sudah tetap dan pasti sejak kompilasi; Dart dapat mengoptimalkan penggunaan nilai ini.
- Pada **Contoh B**, nilai `waktuSekarang` baru dihitung _ketika_ program berjalan; inilah yang dimaksud “diketahui saat runtime.”

---

## Ringkasan

- **`final`**

  - Nilainya hanya boleh di-set satu kali.
  - Nilai boleh berasal dari perhitungan atau pemanggilan fungsi pada saat program berjalan.
  - Ideal untuk data yang Anda tahu akan bersifat tetap **setelah** inisialisasi, tetapi belum tentu konstan saat kompilasi.

- **`const`**

  - Nilainya harus konstan dan tersedia pada saat kompilasi.
  - Cocok untuk nilai literal yang tidak berubah sama sekali.

Dengan demikian, meski contoh Anda:

```dart
final String kota = 'Jakarta';
```

terlihat serupa dengan:

```dart
var nama = 'Alice';
```

perbedaannya terletak pada aturan **pengubahan** dan **waktu penetapan** nilai:

- `nama` (dengan `var`) bisa di-_reassign_ selama tipe cocok.
- `kota` (dengan `final`) hanya boleh di-set sekali, dan nilainya bisa berasal dari proses runtime apa pun.

> - [Dart CLI][1]
> - [Home][2]

[1]: ../../../../../materi/cli/README.md
[2]: ../../../../../../../../README.md
