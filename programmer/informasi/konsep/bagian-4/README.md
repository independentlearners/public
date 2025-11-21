# Algoritma & Kompleksitas

---

# 1. Apa itu algoritma (definisi singkat dan proper)

* **Algoritma** = prosedur terdefinisi untuk menyelesaikan masalah: input → langkah terhingga → output. Tujuan analisis: ukuran efisiensi (waktu dan ruang) seiring pertumbuhan ukuran input. Untuk kajian formal, rujukan standar adalah *Introduction to Algorithms (CLRS)*. ([MIT Press][1])

---

# 2. Kompleksitas: konsep inti (time & space)

* **Time complexity**: jumlah operasi dasar (model umum: langkah elementer) yang dibutuhkan sebagai fungsi n = |input|.
* **Space complexity**: jumlah memori tambahan yang dipakai (tidak termasuk input jika dinyatakan demikian).
* Kita biasanya fokus pada **asymptotic behavior** (bagaimana fungsi tumbuh saat n → ∞) karena konstanta dan faktor rendah sering tidak penting untuk skala besar.

---

# 3. Notasi asimptotik (O, Θ, Ω) — definisi formal singkat

* **Big-O (O)** — batas atas asimptotik: f(n) = O(g(n)) berarti untuk n besar, f(n) ≤ C·g(n). (Biasanya dipakai untuk menyatakan *worst-case*). ([Wikipedia][2])
* **Big-Omega (Ω)** — batas bawah asimptotik: f(n) = Ω(g(n)).
* **Big-Theta (Θ)** — pertumbuhan tajam (tight bound): f(n) = Θ(g(n)) jika f adalah O(g) dan Ω(g).
  (Referensi ringkas: pengertian dan definisi lengkap di sumber ringkasan asymptotic notations). ([programiz.com][3])

---

# 4. Kasus: best / average / worst / amortized

* **Worst-case**: performa maksimum pada semua input ukuran n (dipakai untuk jaminan).
* **Best-case**: performa minimum.
* **Average-case**: ekspektasi atas distribusi input — memerlukan asumsi distribusi input.
* **Amortized**: rata-rata biaya per operasi dalam rangkaian operasi (mis. dynamic array `append` amortized O(1)). Contoh: meski resize memakan O(n), terjadi jarang sehingga rata-rata per `push` tetap O(1).

---

# 5. Contoh konkret — analisis dua algoritma sederhana

## 5.1 Linear search (pseudocode)

```
function linear_search(A, x):
  for i = 1 to length(A):
    if A[i] == x:
      return i
  return NOT_FOUND
```

**Analisis langkah-demi-langkah**

* Pada tiap iterasi kita melakukan 1 komparasi `A[i] == x`.
* Worst-case: elemen tidak ada atau berada terakhir → lakukan `n` komparasi ⇒ **O(n)**.
* Best-case: berada di A[1] ⇒ 1 komparasi ⇒ **Ω(1)**.
* Average-case (asumsi uniform): ≈ n/2 komparasi ⇒ Θ(n).

---

## 5.2 Binary search (pseudocode) — array terurut

```
function binary_search(A, x):
  lo = 1; hi = length(A)
  while lo <= hi:
    mid = floor((lo+hi)/2)
    if A[mid] == x: return mid
    else if A[mid] < x: lo = mid + 1
    else hi = mid - 1
  return NOT_FOUND
```

**Analisis**

* Setiap iterasi memotong ukuran interval menjadi setengah → jumlah iterasi ≤ ⌈log2 n⌉ + 1.
* Jadi worst / average / best: **O(log n)** (best-case O(1) jika ketemu di mid pertama).
* Binary search adalah contoh **divide & conquer**: pecah masalah menjadi subproblem ukuran n/2. (Detail formal bisa dipecahkan lewat rekuren). ([MIT Press][1])

---

# 6. Rekurensi & Master Theorem (cara cepat menyelesaikan rekuren divide-and-conquer)

Bentuk umum yang dipakai Master Theorem:
[
T(n) = a,T(n/b) + f(n)
]
dengan a ≥ 1, b > 1. Hasilnya (kasus ringkas):

1. Jika (f(n) = O(n^{\log_b a - \epsilon})) untuk beberapa ε>0, maka (T(n)=\Theta(n^{\log_b a})).
2. Jika (f(n) = \Theta(n^{\log_b a}\log^k n)), maka (T(n)=\Theta(n^{\log_b a}\log^{k+1} n)).
3. Jika (f(n) = \Omega(n^{\log_b a + \epsilon})) dan regularity condition terpenuhi, maka (T(n)=\Theta(f(n))).
   (Detail lengkap dan pembuktian serta kasus lanjutan lihat referensi Master Theorem). ([Wikipedia][4])

**Contoh**: Merge Sort → (T(n) = 2T(n/2) + \Theta(n)). Di sini a=2, b=2 → (n^{\log_b a} = n^{1}). f(n)=Θ(n) sebanding dengan (n^{\log_b a}) (kasus 2 dengan k=0) → (T(n)=\Theta(n\log n)). ([MIT Press][1])

---

# 7. Kompleksitas algoritma umum — ringkasan praktis

* **Searching:** linear O(n), binary O(log n) (but array must be sorted).
* **Sorting (comparison-based):** lower bound Θ(n log n). Contoh: QuickSort average Θ(n log n), worst O(n²) (pivot buruk); MergeSort Θ(n log n) worst-case. (Pembahasan lengkap di CLRS). ([MIT Press][1])
* **Hash table lookup/insert/delete:** average O(1), worst O(n) (collision degenerate).
* **Balanced BST (AVL/Red-Black):** O(log n) untuk search/insert/delete.
* **Heap (priority queue):** insert O(log n), extract-min O(log n).
* **Graph algorithms:** BFS/DFS O(V+E); Dijkstra O((V+E) log V) dengan heap; Bellman-Ford O(V·E).
* **String matching:** KMP O(n+m), naive O(n·m).
  Sumber ringkasan dan pembahasan formal di CLRS dan artikel-teaching DSA. ([MIT Press][1])

---

# 8. Kelas Kompleksitas & teori (P, NP, NP-complete, NP-hard)

* **P** = masalah keputusan yang dapat diselesaikan oleh mesin deterministik dalam waktu polinomial.
* **NP** = masalah keputusan di mana solusi *dapat diverifikasi* dalam waktu polinomial (atau diselesaikan oleh nondeterministic TM dalam polinomial).
* **NP-complete** = masalah di NP yang merupakan yang “terberat”: setiap masalah di NP bisa direduksi padanya dalam waktu polinomial. Jika satu NP-complete punya algoritma polinomial, maka P = NP.
* **NP-hard** = set masalah setidaknya se-sulit masalah NP (tidak harus ada di NP).
  Masalah P vs NP adalah salah satu pertanyaan terbuka terbesar; ringkasan formal tersedia di literatur dan referensi komprehensif. ([Wikipedia][5])

---

# 9. Teknik desain algoritma (pattern & kapan pakai)

Ringkasan teknik utama, tiap teknik disertai gambaran kapan dipakai:

1. **Divide & Conquer** — pecah menjadi subproblem independen (MergeSort, QuickSort). Gunakan bila masalah dapat dibagi-natural. (Master Theorem sering dipakai). ([Wikipedia][4])
2. **Dynamic Programming (DP)** — subproblem overlap + optimal substructure (Fibonacci with memo, Knapsack). Ubah rekursi eksponensial menjadi polinomial dengan memoization/tabulasi.
3. **Greedy** — pilih opsi lokal terbaik, gunakan bila bukti optimalitas (Prim, Kruskal, Huffman).
4. **Backtracking / Branch & Bound** — pencarian ruang solusi dengan pruning (SAT solvers, TSP brute + bound).
5. **Randomized algorithms** — gunakan randomness untuk kesederhanaan/performa (QuickSort random pivot, Miller-Rabin primality test).
6. **Approximation algorithms** — untuk NP-hard problems, cari solusi mendekati optimal dengan garansi faktor.
7. **Streaming / online algorithms** — untuk data yang besar/berkelanjutan, memori terbatas, gunakan teknik probabilistik (Bloom filter, reservoir sampling).

---

# 10. Metodologi menganalisis algoritma (langkah-langkah praktis)

1. **Tentukan model operasi** yang dihitung (mis. komparasi, assignment, aritmetika).
2. **Tulis pseudocode** dan tandai operasi dominan.
3. **Buat persamaan rekuren** bila algoritma rekursif.
4. **Selesaikan rekuren** (substitution, Master Theorem, atau recursion tree).
5. **Sederhanakan ke notasi asimptotik** (buang konstanta & lower-order terms).
6. **Pertimbangkan space** (auxiliary memory) terpisah dari input.
7. **Periksa best/avg/worst / amortized** sesuai konteks aplikasi.
   Contoh: untuk kode iteratif, hitung jumlah iterasi; untuk nested loop, kalikan jumlah iterasi lapisan-lapisan kecuali ada pemotongan/penyusutan.

---

# 11. Praktik implementasi & optimasi — hal teknis yang perlu dipersiapkan

Untuk bisa **mengimplementasi, memodifikasi, mengukur, dan mengoptimalkan** algoritma secara mandiri, siapkan:

**Pengetahuan wajib**

* Dasar algoritma & struktur data (CLRS disarankan). ([MIT Press][1])
* Matematika diskret dasar: log, eksponen, bukti induksi, rekuren.
* Teknik analisis (amortized, probabilistic analysis), dan cara membuktikan korektness.

**Tooling & environment**

* **Bahasa implementasi**:

  * *C/C++* — untuk performa rendah-level, kontrol memori, profil lanjutan.
  * *Rust* — keamanan memori + performa.
  * *Python* — cepat prototyping (pakai `timeit`, `cProfile`), tapi overhead tinggi.
  * *Dart / Lua* — bisa digunakan untuk edukasi/utility; untuk benchmark perhatikan runtime (Dart VM, LuaJIT).
    (Anda memakai Dart/Lua: gunakan Dart SDK + `dart devtools` untuk profiling; untuk Lua gunakan LuaJIT + profiler).
* **Profiling & benchmarking**: `perf`, `valgrind`/`callgrind`, `gprof`, `hyperfine` (CLI microbenchmark), Dart DevTools profiler, LuaJIT's profiler.
* **Unit test & benchmark harness**: buat suite test untuk validasi kompleksitas (scalability tests), gunakan `criterion`/`benchmark` frameworks bila tersedia.
* **Memory analysis**: valgrind massif, heap profilers (jemalloc stats), observability tools.

**Praktik engineering**

* Ukur performa nyata — waktu asymptotic hanya prediktor; constant factor dan cache locality sering dominan praktisnya.
* Perhatikan penggunaan memori & locality (contiguous arrays lebih cache-friendly daripada linked lists).
* Gunakan struktur data built-in yang teruji bila memungkinkan; implementasikan manual untuk learning/optimasi khusus.

---

# 12. Contoh analisis langkah demi langkah — MergeSort (rekuren + Master)

Pseudocode (singkat):

```
mergeSort(A):
  if length(A) <= 1: return A
  split A into L and R
  return merge(mergeSort(L), mergeSort(R))
```

* Rekurensi: T(n) = 2T(n/2) + Θ(n) (split & merge linear) → dengan Master Theorem → T(n) = Θ(n log n). ([Wikipedia][4])

---

# 13. Sumber & bacaan lanjut (direkomendasikan)

* *Introduction to Algorithms* — Cormen, Leiserson, Rivest, Stein (CLRS). Referensi utama untuk analisis algoritma. ([MIT Press][1])
* Master Theorem (baca ringkasan & contoh-contoh rekuren). ([Wikipedia][4])
* Asymptotic notation / tutorial DSA (Programiz / GeeksforGeeks) untuk pengertian cepat dan contoh. ([programiz.com][3])
* P vs NP dan kelas kompleksitas (Wikipedia / literatur teori komputasi). ([Wikipedia][5])

---

[1]: https://mitpress.mit.edu/9780262046305/introduction-to-algorithms/?utm_source=chatgpt.com "Introduction to Algorithms"
[2]: https://en.wikipedia.org/wiki/Big_O_notation?utm_source=chatgpt.com "Big O notation"
[3]: https://www.programiz.com/dsa/asymptotic-notations?utm_source=chatgpt.com "Asymptotic Analysis: Big-O Notation and More"
[4]: https://en.wikipedia.org/wiki/Master_theorem_%28analysis_of_algorithms%29?utm_source=chatgpt.com "Master theorem (analysis of algorithms)"
[5]: https://en.wikipedia.org/wiki/P_versus_NP_problem?utm_source=chatgpt.com "P versus NP problem"

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../
[2]: ../
[3]: ../
[4]: ../
[5]: ../
[6]: ../
[7]: ../
[8]: ../
[9]: ../
[10]: ../
[11]: ../
[12]: ../
[13]: ../
[14]: ../
[15]: ../
[16]: ../
[17]: ../
[18]: ../
