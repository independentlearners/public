# Data Race

### Inti Definisi (lebih formal)

Data race terjadi jika:

1. Ada ≥ 2 thread mengakses **memori yang sama**
2. Akses tersebut terjadi **secara bersamaan (concurrent)**
3. Minimal satu akses adalah **write**
4. Tidak ada **synchronization primitive** (lock, mutex, dsb)

---

### Contoh sederhana (konsep)

Misal ada variabel global:

```dart
int counter = 0;
```

Lalu dua thread menjalankan:

```dart
counter = counter + 1;
```

Secara internal, ini bukan operasi atomik:

1. Baca `counter`
2. Tambah 1
3. Tulis kembali

Jika dua thread melakukan ini bersamaan:

* Thread A baca `0`
* Thread B baca `0`
* Thread A tulis `1`
* Thread B tulis `1`

Hasil akhir: **1 (harusnya 2)** → ini data race.

---

### Dampak teknis

* Non-deterministic behavior
* Bug yang sulit direproduksi (heisenbug)
* Korupsi data
* Crash atau undefined behavior (terutama di C/C++)

---

### Cara mencegah

Gunakan mekanisme sinkronisasi:

1. **Mutex / Lock**

   * Menjamin hanya satu thread mengakses resource

2. **Atomic operation**

   * Operasi yang dijamin tidak terinterupsi

3. **Immutable data**

   * Data tidak bisa diubah → aman untuk dibaca bersama

4. **Message passing (actor model)**

   * Tidak berbagi state, hanya kirim pesan

---

### Konteks Dart (penting)

Dalam Dart:

* Tidak ada shared memory antar thread seperti di C/C++
* Menggunakan **Isolate**
* Setiap isolate punya memory sendiri

👉 Artinya:

* **Data race klasik hampir tidak terjadi di Dart**
* Komunikasi dilakukan via **message passing**, bukan shared variable

Namun:

* Jika menggunakan FFI (misalnya ke C), data race bisa muncul kembali

---

### Analogi mental (biar tajam)

Bayangkan:

* Satu buku catatan (variabel)
* Dua orang menulis di halaman yang sama tanpa koordinasi

➡️ Tulisan akan saling menimpa → hasil kacau

---

### Insight lanjutan (untuk level engineer)

* Data race adalah subset dari **race condition**
* Semua data race adalah race condition, tapi tidak semua race condition adalah data race
* Bahasa seperti Rust secara desain **mencegah data race di compile time** (ownership system)


