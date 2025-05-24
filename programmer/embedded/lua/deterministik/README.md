Kita hitung dengan mengikuti **aturan prioritas operasi (PEMDAS/BODMAS)**:

- Perkalian dan pembagian didahulukan sebelum penjumlahan dan pengurangan.

Jadi:

```
3 * 3 + 4 * 2
= 9 + 8
= 17
```

**Hasilnya adalah 17.** ✅

Coba jalankan kode berikut

```lua
-- Fungsi deterministik: hanya operasi murni
function f(x, y)
	return x * x + y * 2
end

print(f(3, 4)) -- selalu 17
```

Istilah **PEMDAS** atau **BODMAS** adalah aturan urutan operasi matematika. Ini penting supaya semua orang mendapatkan hasil yang sama saat menghitung ekspresi matematika.

---

### 📐 Penjelasan Singkat:

#### **PEMDAS** (digunakan di Amerika):

- **P** = Parentheses (tanda kurung)
- **E** = Exponents (pangkat/akar)
- **MD** = Multiplication and Division (kiri ke kanan)
- **AS** = Addition and Subtraction (kiri ke kanan)

#### **BODMAS** (lebih umum di Eropa dan Asia):

- **B** = Brackets (tanda kurung)
- **O** = Orders (pangkat dan akar)
- **DM** = Division and Multiplication (kiri ke kanan)
- **AS** = Addition and Subtraction (kiri ke kanan)

---

### Contoh:

```text
3 + 4 × 2
```

Kalau tidak pakai aturan ini, orang bisa menjumlah dulu (3 + 4 = 7), lalu dikali 2 = 14 ❌

Tapi dengan PEMDAS/BODMAS:

- Kerjakan perkalian dulu: 4 × 2 = 8
- Lalu tambahkan: 3 + 8 = **11** ✅

---

### Kenapa penting?

Dalam pemrograman atau matematika, **urutan eksekusi operasi** harus jelas, biar program atau orang lain nggak salah interpretasi hasilnya. Pada contoh berikut fokus kita adalah tetap **urutan operasi** (kurung → kali/bagi → tambah/kurang).

---

### Soal:

```
12 / (2 * 2) + 3 * (4 - 1)
```

---

### Langkah 1: Hitung isi dalam tanda kurung

```
(2 * 2) = 4
(4 - 1) = 3
```

Sekarang persamaan jadi:

```
12 / 4 + 3 * 3
```

---

### Langkah 2: Lakukan perkalian dan pembagian dari kiri ke kanan

```
12 / 4 = 3
3 * 3 = 9
```

Sekarang jadi:

```
3 + 9 = 12
```

### ✅ Jawaban akhir: **12**

---

### 🚦 Trik Cepat Ingat Urutan Operasi:

Gunakan akronim ini:

> **PEMDAS** →
> **P** = Parentheses (kurung)
> **E** = Exponents (pangkat, akar)
> **MD** = Multiply & Divide (kali & bagi, dari kiri ke kanan)
> **AS** = Add & Subtract (tambah & kurang, dari kiri ke kanan)

🧠 **Ingat:**
**MD dan AS dihitung dari kiri ke kanan, bukan harus kali dulu baru bagi.**

---

### 🎯 Contoh Kasus MD-AS:

#### Soal:

```
8 - 4 + 2
```

Jangan langsung hitung tambah dulu ya. Kita ikuti **dari kiri ke kanan**:

```
8 - 4 = 4
4 + 2 = 6 ✅
```

Kalau kamu balik jadi `4 + 2 = 6` lalu `8 - 6 = 2`, itu **salah** ❌

---

### 📌 Tips:

- Kalau ada **kurung**, kerjakan **duluan** apapun isinya.
- Jangan asal baca dari kanan ke kiri. **Ikuti arah kiri ke kanan** untuk kali/bagi atau tambah/kurang.

> Di Tulis ChatGPT

# Kode Saya

```lua
math.randomseed(12345)
-- set seed agar random() dapat diprediksi

print(math.random())
-- selalu menghasilkan urutan yang sama

print("--------")
print(3 * 3 + 4 * 2)
```
