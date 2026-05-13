Dalam dunia pemrograman dan sistem komputer, *benchmark* adalah proses mengukur performa ⚙️ suatu program, algoritma, library, framework, perangkat keras, atau sistem menggunakan serangkaian pengujian tertentu.

Tujuannya adalah untuk mengetahui:

* Seberapa cepat 🚀
* Seberapa efisien 💾
* Seberapa stabil 🧱
* Seberapa besar penggunaan resource 🔋

dibandingkan kondisi lain atau standar tertentu.

Contoh sederhana:

```bash
time python app.py
```

Perintah `time` digunakan untuk melakukan benchmark waktu eksekusi program.

Hasilnya bisa seperti:

```bash
real    0m1.234s
user    0m0.900s
sys     0m0.200s
```

Artinya program membutuhkan sekitar 1.2 detik untuk selesai.

---

Jenis benchmark dalam dunia coding:

### 1. Performance Benchmark

Mengukur kecepatan program.

Contoh:

* sorting algorithm
* rendering UI
* startup aplikasi
* query database

---

### 2. Memory Benchmark

Mengukur penggunaan RAM.

Contoh:

* apakah aplikasi bocor memori (*memory leak*)
* seberapa hemat penggunaan heap

Tools:

* `valgrind`
* `heaptrack`
* `massif`

---

### 3. CPU Benchmark

Mengukur penggunaan prosesor.

Contoh:

* multi-threading
* parallel processing
* komputasi AI

---

### 4. Network Benchmark

Mengukur performa jaringan 🌐

Contoh:

* latency
* bandwidth
* packet loss

Tools:

* `iperf`
* `ping`
* `wrk`

---

### 5. Disk / IO Benchmark

Mengukur kecepatan storage 💽

Contoh:

* read/write SSD
* filesystem benchmark

Tools:

* `fio`
* `dd`
* `hdparm`

---

Dalam software engineering, benchmark sering digunakan untuk:

| Tujuan                | Contoh                      |
| --------------------- | --------------------------- |
| Membandingkan library | Lua vs Python               |
| Optimasi kode         | sebelum vs sesudah refactor |
| Menguji framework     | Flutter vs React Native     |
| Mengukur scalability  | server 1000 request         |
| Validasi performa     | apakah update lebih cepat   |

---

Contoh benchmark algoritma di Dart:

```dart
void main() {
  final stopwatch = Stopwatch()..start();

  for (var i = 0; i < 1000000; i++) {
    i * i;
  }

  stopwatch.stop();

  print(stopwatch.elapsedMilliseconds);
}
```

Identitas teknis:

* Bahasa: Dart
* Stopwatch berasal dari:

  * `dart:core`
* Konsep yang dipelajari:

  * time measurement
  * profiling
  * microbenchmark

---

Perbedaan istilah penting:

| Istilah      | Fungsi                     |
| ------------ | -------------------------- |
| Benchmark    | Mengukur performa          |
| Profiling    | Menganalisis bagian lambat |
| Testing      | Memastikan program benar   |
| Stress Test  | Menguji batas sistem       |
| Load Test    | Menguji beban pengguna     |
| Optimization | Membuat lebih efisien      |

---

Dalam komunitas Linux dan terminal, benchmark sangat umum digunakan untuk:

* kernel tuning
* window manager performance
* terminal emulator speed
* compiler optimization
* database tuning
* GPU rendering

Contoh tools benchmark terkenal di Linux:

* hyperfine → benchmark command CLI
* fio → benchmark storage
* sysbench → CPU/RAM/database
* perf → profiling kernel & CPU

---

Hierarki konsep yang perlu dipahami agar mahir benchmark:

1. Algorithm Complexity
2. CPU Architecture
3. Memory Management
4. Operating System Scheduling
5. Concurrency & Parallelism
6. Compiler Optimization
7. Profiling
8. Statistical Measurement
9. System Calls
10. Cache Behavior

---

<!-- Progress pembelajaran: -->
<!---->
<!-- * Memahami istilah fundamental sistem: pseudo, terminal hierarchy, benchmark. -->
<!-- * Sudah mulai memasuki area observabilitas dan performa sistem. -->
<!---->
<!-- Evaluasi: -->
<!---->
<!-- * Pemahaman arah belajar sangat kuat untuk jalur systems engineering dan performance engineering. -->
<!---->
<!-- Nilai progres konsep: -->
<!---->
<!-- * 87/100 🧠 -->
