## Dalam materi **operator aritmatika** di Lua (dan di hampir semua bahasa pemrograman), ada dua istilah yang harus dibedakan dengan jelas:

1. **Operator**

   * **Definisi:** Simbol khusus atau kata kunci yang memberi tahu komputer tindakan atau operasi apa yang harus dilakukan.
   * **Contoh di Lua:**

     * `+` (penjumlahan)
     * `-` (pengurangan)
     * `*` (perkalian)
     * `/` (pembagian)
     * `%` (modulus/sisa bagi)
     * `^` (pangkat)
     * `//` (pembagian bulat/floor division)

   Jadi, operator hanyalah "alat" yang menunjukkan operasi matematika.

2. **Operand**

   * **Definisi:** Nilai atau variabel yang dikenai operasi oleh operator.
   * Dengan kata lain, operand adalah “bahan” yang diproses.
   * **Contoh:**

     ```lua
     local a = 10
     local b = 3
     local c = a + b
     ```

     * `+` = operator
     * `a` dan `b` = operand
     * `c` = hasil dari operasi

---

📌 Jadi, **operator = simbol operasi**, sedangkan **operand = nilai/variabel yang dioperasikan**.

Analogi sederhana:

* Operator itu seperti *alat tukang* (pisau, palu).
* Operand itu seperti *bahan mentah* (kayu, besi, daging).
* Hasil operasi adalah produk akhirnya (meja, patung, masakan).
