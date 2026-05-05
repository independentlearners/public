# Mismatch

### 1. Type Mismatch (paling fundamental)

Terjadi ketika tipe data tidak sesuai dengan yang diharapkan oleh sistem tipe.

Contoh di **Dart**:

```dart
int umur = "dua puluh"; // ❌ mismatch
```

Kenapa?

* Variabel `umur` mengharapkan `int`
* Yang diberikan `String`

**Solusi:**

* Ubah tipe data
* Atau lakukan konversi (casting / parsing)

---

### 2. Argument / Parameter Mismatch

Ketika fungsi menerima argumen yang tidak sesuai dengan definisinya.

```dart
void cetakUmur(int umur) {}

cetakUmur("20"); // ❌ mismatch
```

---

### 3. Data Structure Mismatch

Terjadi saat struktur data tidak sesuai dengan yang diharapkan.

```dart
Map<String, int> data = {
  "umur": "20" // ❌ value harus int
};
```

---

### 4. Interface / Contract Mismatch

Dalam OOP atau API:

* Method tidak sesuai signature
* Return type berbeda
* Implementasi tidak mengikuti kontrak

---

### 5. Runtime vs Compile-time Mismatch

Ini penting secara arsitektural:

* **Compile-time mismatch** → error langsung saat build
  (contoh: Dart strong typing)
* **Runtime mismatch** → lolos compile, tapi error saat dijalankan
  (contoh: `dynamic`, parsing JSON, dll)

---

### 6. Mismatch dalam konteks sistem (lebih luas)

* Database schema mismatch
* API response mismatch (JSON tidak sesuai model)
* Encoding mismatch (UTF-8 vs ASCII)

---

### Inti konsep (yang perlu kamu pegang sebagai engineer)

Mismatch =

> **pelanggaran kontrak antara "yang diberikan" vs "yang diharapkan"**

Dalam pemrograman modern (terutama Dart, Rust, TypeScript):

* Sistem tipe dibuat untuk **mendeteksi mismatch sedini mungkin**
* Tujuannya: **mengurangi bug runtime**


