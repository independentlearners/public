Penjelasan rinci tentang urutan eksekusi pada **post-increment/decrement** (`x++`/`x--`) dan **pre-increment/decrement** (`++x`/`--x`):

---

## 1. Post-increment (`x++`) / Post-decrement (`x--`)

- **Langkah 1:** Ambil _nilai lama_ dari variabel untuk dievaluasi dalam ekspresi.
- **Langkah 2:** Setelah ekspresi selesai menggunakan nilai lama, baru **tambahkan** (atau **kurangkan**) variabel itu sendiri.

> **Contoh:**
>
> ```dart
> void main() {
>   int x = 5;
>   print(x++);  // (1) Cetak nilai lama: 5
>                // (2) Baru x = x + 1 → x jadi 6
>   print(x);    // Cetak nilai x terkini: 6
> }
> ```
>
> **Urutannya:**
>
> 1. `print` mendapat `5`.
> 2. `x` dinaikkan menjadi `6`.
> 3. `print(x)` mencetak `6`.

---

## 2. Pre-increment (`++x`) / Pre-decrement (`--x`)

- **Langkah 1:** **Tambahkan** (atau **kurangkan**) variabel terlebih dahulu.
- **Langkah 2:** Ambil _nilai baru_ variabel untuk dievaluasi dalam ekspresi.

> **Contoh:**
>
> ```dart
> void main() {
>   int x = 5;
>   print(++x);  // (1) x = x + 1 → x jadi 6
>                // (2) Cetak nilai baru: 6
>   print(x);    // Cetak nilai x terkini: 6
> }
> ```
>
> **Urutannya:**
>
> 1. `x` dinaikkan menjadi `6`.
> 2. `print` mendapat `6`.
> 3. `print(x)` mencetak `6`.

---

## 3. Ringkasan Perbandingan

| Bentuk                 | Eksekusi Penambahan/Pengurangan | Nilai yang Dievaluasi dalam Ekspresi |
| ---------------------- | ------------------------------- | ------------------------------------ |
| **Post** `x++` / `x--` | Setelah ekspresi                | Nilai lama (sebelum operasi)         |
| **Pre** `++x` / `--x`  | Sebelum ekspresi                | Nilai baru (setelah operasi)         |

---

## 4. Contoh Lengkap

```dart
void main() {
  int a = 10;
  print('a = $a');
  // a = 10

  print('print(a++) → ${a++}');
  // → Cetak 10, lalu a jadi 11

  print('setelah a++ → a = $a');
  // a = 11

  print('print(++a) → ${++a}');
  // a jadi 12, lalu cetak 12

  print('setelah ++a → a = $a');
  // a = 12

  // Decrement serupa, hanya tanda -:
  print('print(a--) → ${a--}');
  // Cetak 12, lalu a jadi 11

  print('print(--a) → ${--a}');
  // a jadi 10, lalu cetak 10
}
```

**Penjelasan langkah-demi-langkah** untuk setiap `print(...)` sudah ditandai di komentar.

---

### Tips Praktis

1. **Gunakan ekspresi sederhana**—hindari gabungan `x++` dan `++x` dalam satu baris kompleks.
2. Bila butuh kejelasan, tulis eksplisit:

   ```dart
   x = x + 1;  // Daripada ++x
   x = x - 1;  // Daripada --x
   ```

3. **Amati output** dengan contoh `print` di atas sampai benar-benar paham urutan eksekusinya.

Dengan cara ini urutan evaluasi menjadi sangat jelas: **pre-** selalu tambahkan dulu, **post-** selalu pakai nilai dulu, baru tambahkan.

### Kode saya

```dart
void main() {
  var x = '-' * 10;
  int a = 10;

  print(x);
  print(a); // 10

  a++;
  print(x);
  print(a); // 11

  a++;
  print(x);
  print(a); // 12

  a++;
  print(x);
  print('$a pengurangan'); // 13

  --a;
  print(x);
  print(a); // 12

  --a;
  print(x);
  print(a); // 11

  --a;
  print(x);
  print(a); // 10
}
```

### Output

```pwsh
----------
10
----------
11
----------
12
----------
13 pengurangan
----------
12
----------
11
----------
10
```
