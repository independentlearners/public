# Struktur Data

---

## Ringkasan singkat (inti)

* **List**: koleksi terurut; implementasi umum: *array-based* (List/Vector) atau *linked list*.
* **Map (dictionary / associative array)**: koleksi pasangan kunci→nilai; implementasi umum: *hash table* atau *balanced tree map*.
* **Tree**: struktur hirarkis (node + anak); contoh: Binary Search Tree (BST), AVL, Red-Black, B-Tree.
* **Graph**: kumpulan vertex (node) dan edge (sisi); representasi: adjacency list atau adjacency matrix.

---

## Kompleksitas operasional (umum)

* **Array-based list**: akses O(1), pencarian O(n), push_end amortized O(1), insert/delete di tengah O(n).
* **Linked list**: akses O(n), insert/delete di posisi diketahui O(1).
* **Hash map** (average): lookup/insert/delete O(1); worst-case O(n) bila collision buruk.
* **Tree (balanced)**: search/insert/delete O(log n); traversal O(n).
* **Graph (adjacency list)**: BFS/DFS O(V + E). Adjacency matrix: cek edge O(1), iterasi tetangga O(V), ruang O(V²).

---

# 1) LIST — rincian, implementasi & contoh

### Konsep

List = koleksi terurut elemen yang dapat diindeks. Implementasi praktis di bahasa modern biasanya *array dynamic* (contoh: `List` di Dart) atau table/array di Lua (`table` dengan integer keys).

### Kapan gunakan

* Saat memerlukan urutan elemen dan akses indeks cepat.
* Untuk queue/stack sederhana (push/pop di akhir).

### Jebakan

* Operasi insert/delete di tengah mahal (O(n)).
* Jika butuh banyak penyisipan/deletion di tengah, gunakan linked list atau struktur lain (gap buffer, rope untuk string besar).

### Contoh — Dart (array-based List)

```dart
void main() {
  List<int> arr = [1, 2, 3];     // deklarasi list
  arr.add(4);                    // tambah di akhir
  arr.insert(1, 5);              // sisip di indeks 1
  arr.removeAt(2);               // hapus indeks 2
  for (var v in arr) print(v);   // iterasi
}
```

**Penjelasan kata-per-kata (baris penting):**

* `void main() {`

  * `void` = tipe return fungsi (`main`) — tidak mengembalikan nilai.
  * `main` = entry point program.
  * `{` = buka block.
* `List<int> arr = [1, 2, 3];`

  * `List<int>` = tipe generik, list berisi `int`.
  * `arr` = identifier variabel.
  * `=` = assignment.
  * `[1, 2, 3]` = literal list dengan 3 elemen.
  * `;` = akhiri statement.
* `arr.add(4);`

  * `arr` = instance List.
  * `.` = akses anggota (method).
  * `add(4)` = panggil method `add` dengan argumen `4` (menambahkan elemen ke akhir).
* `arr.insert(1, 5);`

  * `insert(index, value)` = sisipkan `value` di posisi `index`, geser elemen berikutnya.
* `arr.removeAt(2);`

  * `removeAt(index)` = hapus elemen pada `index`.
* `for (var v in arr) print(v);`

  * `for (...)` = loop iterasi; `var v in arr` = setiap elemen `arr` diikat ke `v`.
  * `print(v)` = cetak nilai `v`.

### Contoh — Lua (table sebagai array)

```lua
local arr = {1, 2, 3}
table.insert(arr, 4)       -- append
table.insert(arr, 2, 5)    -- insert at position 2
table.remove(arr, 3)       -- remove index 3
for i, v in ipairs(arr) do
  print(i, v)
end
```

**Penjelasan kata-per-kata (baris penting):**

* `local arr = {1, 2, 3}`

  * `local` = variabel lokal.
  * `arr` = nama variabel.
  * `=` = assignment.
  * `{1, 2, 3}` = table literal dengan integer keys mulai 1 (konvensi array di Lua).
* `table.insert(arr, 4)`

  * `table.insert` = fungsi library `table` untuk menyisipkan; default menyisip di akhir.
  * `(arr, 4)` = argumen: table, nilai.
* `table.insert(arr, 2, 5)`

  * `insert(t, pos, value)` = sisip `value` di `pos`.
* `table.remove(arr, 3)`

  * `remove(t, pos)` = hapus elemen di `pos`.
* `for i, v in ipairs(arr) do`

  * `ipairs` = iterator index-berurutan (1..n) untuk array-like tables; `i` index, `v` value.

---

# 2) MAP (dictionary) — rincian, implementasi & contoh

### Konsep

Map = struktur kunci→nilai. Implementasi umum: *hash table* (performant untuk lookup) atau *tree map* (ordered map, mis. red-black).

### Kapan gunakan

* Ketika perlu lookup cepat berdasarkan kunci (string, integer, objek hashable).

### Jebakan

* Kunci harus hashable (atau convertible ke bentuk hashable).
* Iterasi pada hash map **tidak berurutan** kecuali spesifik bahasa menjamin order (beberapa bahasa sekarang mempertahankan insertion order).

### Contoh — Dart (`Map`)

```dart
void main() {
  Map<String, int> m = {'a': 1, 'b': 2};
  m['c'] = 3;
  if (m.containsKey('b')) {
    print(m['b']);
  }
  for (var k in m.keys) print('$k -> ${m[k]}');
}
```

**Penjelasan kata-per-kata:**

* `Map<String, int> m = {'a': 1, 'b': 2};`

  * `Map<String, int>` = map dengan kunci `String` dan nilai `int`.
  * `{'a': 1, 'b': 2}` = literal map.
* `m['c'] = 3;`

  * `m['c']` = akses/assign menggunakan operator indeks untuk map; membuat entri baru jika belum ada.
* `m.containsKey('b')` = cek keberadaan kunci.
* `for (var k in m.keys)` = iterasi atas set keys; `m[k]` ambil value.

### Contoh — Lua (table sebagai associative array)

```lua
local m = { a = 1, b = 2 }
m['c'] = 3
if m['b'] ~= nil then
  print(m['b'])
end
for k, v in pairs(m) do
  print(k, '->', v)
end
```

**Penjelasan kata-per-kata:**

* `local m = { a = 1, b = 2 }`

  * Table literal dengan key `a`, `b`. Di Lua, `{a = 1}` sama dengan `["a"] = 1`.
* `m['c'] = 3` = assign key `'c'` dengan value `3`.
* `m['b'] ~= nil` = di Lua, cek non-nil (karena `false` juga ada); `~=` = operator not-equal.
* `for k, v in pairs(m) do` = iterasi semua pasangan kunci-nilai tanpa urutan tertentu.

---

# 3) TREE — rincian, implementasi & contoh

### Konsep

Tree = struktur node hirarkis; setiap node memiliki 0..n anak. Binary tree = max 2 anak. BST (Binary Search Tree) mengurutkan sehingga left < node < right.

### Kapan gunakan

* Representasi hierarki (folder, DOM), indeks (B-Tree di DB), penyimpanan terurut untuk operasi range search.

### Jebakan

* BST yang tidak seimbang → performa degrade ke O(n). Jika butuh jaminan, gunakan balanced trees (AVL, Red-Black) atau B-Tree untuk disk-based indeks.

### Traversal umum

* Preorder, Inorder, Postorder (rekursif atau iterative).

### Contoh sederhana — Dart: Binary Tree + inorder traversal

```dart
class Node<T> {
  T value;
  Node<T>? left;
  Node<T>? right;
  Node(this.value, {this.left, this.right});
}

void inorder<T>(Node<T>? node) {
  if (node == null) return;
  inorder(node.left);
  print(node.value);
  inorder(node.right);
}

void main() {
  var root = Node<int>(10, left: Node(5), right: Node(15));
  inorder(root);
}
```

**Penjelasan kata-per-kata (baris penting):**

* `class Node<T> {`

  * `class` = definisi class.
  * `Node<T>` = generic class parameter `T` (tipe nilai).
* `T value;` = field `value` bertipe `T`.
* `Node<T>? left;` = field `left` berupa `Node<T>` yang bisa `null` (`?` = nullable).
* `Node(this.value, {this.left, this.right});` = konstruktor: `this.value` inisialisasi field dari argumen posisi; `{}` = named optional parameters untuk left/right.
* `void inorder<T>(Node<T>? node) {` = fungsi generic inorder traversal.
* `if (node == null) return;` = base case rekursi.
* `inorder(node.left); print(node.value); inorder(node.right);` = urutan inorder: kiri, node, kanan.

### Contoh sederhana — Lua: Binary Tree (table-based) + inorder

```lua
local function node(val, left, right)
  return { value = val, left = left, right = right }
end

local function inorder(n)
  if not n then return end
  inorder(n.left)
  print(n.value)
  inorder(n.right)
end

local root = node(10, node(5), node(15))
inorder(root)
```

**Penjelasan kata-per-kata:**

* `local function node(val, left, right)` = definisi fungsi pembuat node.
* `return { value = val, left = left, right = right }` = table merepresentasikan node.
* `if not n then return end` = base case (Lua `not n` true bila `n` nil/false).
* `inorder(n.left)` dll = traversal rekursif.

---

# 4) GRAPH — rincian, implementasi & contoh

### Konsep

Graph = (V, E). Directed vs undirected, weighted vs unweighted. Representasi: adjacency list (preferred for sparse graphs) atau adjacency matrix (dense).

### Algoritma penting

* BFS (shortest path unweighted), DFS, Dijkstra (weighted non-negative), Bellman-Ford (negatif edges), topological sort (DAG), MST (Kruskal/Prim).

### Jebakan

* Pilih representasi sesuai densitas: adjacency matrix mahal memori O(V²).
* Saat melakukan traversal, track visited untuk mencegah infinite loop (graph dengan cycle).

### Contoh — Dart: adjacency list + BFS

```dart
import 'dart:collection';

void bfs(Map<int, List<int>> g, int start) {
  var visited = <int>{};
  var q = Queue<int>();
  visited.add(start);
  q.add(start);
  while (q.isNotEmpty) {
    var u = q.removeFirst();
    print(u);
    for (var v in g[u] ?? []) {
      if (!visited.contains(v)) {
        visited.add(v);
        q.add(v);
      }
    }
  }
}

void main() {
  var g = {
    1: [2, 3],
    2: [4],
    3: [4],
    4: []
  };
  bfs(g, 1);
}
```

**Penjelasan kata-per-kata (baris penting):**

* `import 'dart:collection';` = import library untuk `Queue`.
* `Map<int, List<int>> g` = graph adjacency list: kunci vertex → list tetangga.
* `var visited = <int>{};` = set kosong untuk menandai visited.
* `var q = Queue<int>();` = antrian FIFO.
* `visited.add(start); q.add(start);` = inisialisasi BFS.
* `while (q.isNotEmpty) { ... }` = loop sampai queue kosong.
* `for (var v in g[u] ?? [])` = iterasi tetangga; `g[u] ?? []` = jika null gunakan list kosong.

### Contoh — Lua: adjacency list + BFS (implementasi queue sederhana)

```lua
local function bfs(g, start)
  local visited = {}
  local q = {start}
  local head = 1
  visited[start] = true
  while head <= #q do
    local u = q[head]; head = head + 1
    print(u)
    for _, v in ipairs(g[u] or {}) do
      if not visited[v] then
        visited[v] = true
        table.insert(q, v)
      end
    end
  end
end

local g = {
  [1] = {2,3},
  [2] = {4},
  [3] = {4},
  [4] = {}
}
bfs(g, 1)
```

**Penjelasan kata-per-kata:**

* `local q = {start}` = queue diimplementasikan sebagai table, `head` pointer indeks pop.
* `while head <= #q do` = loop selama ada elemen (size = `#q`).
* `for _, v in ipairs(g[u] or {}) do` = iterasi tetangga; `or {}` fallback kosong.

---

# Praktik terbaik & rekomendasi

* Gunakan struktur data built-in bila tersedia dan teruji (Dart `List`, `Map`, `Set`; Lua `table` + `table.*`).
* Pilih representasi yang sesuai (adjacency list untuk sparse graph).
* Perhatikan mutability & concurrency: di lingkungan multi-threaded / isolate (Dart) hindari sharing mutable state tanpa sinkronisasi; di Lua perhatikan environment global vs local.
* Untuk performance-critical code (algoritma intensif), ukur (profiling) dan pertimbangkan struktur yang lebih spesifik (B-Tree untuk disk, heap untuk priority queue).

---

# Persiapan untuk mengembangkan / memodifikasi sendiri (khusus Dart & Lua)

### Pengetahuan dasar yang wajib

* **Algoritma & Kompleksitas (O-notation)** — analisis waktu/ruang.
* **Struktur data dasar** — arrays, linked lists, stacks, queues, trees, heaps, hash tables, graphs.
* **Rekursi & iterasi**, pengelolaan memori dasar (paham kapan GC bekerja).
* **Debugging & testing** — menulis unit tests untuk validasi invariants (mis. BST invariants, connectivity di graph).

### Untuk Dart — apa dipersiapkan

* **Identitas Dart**: dibuat oleh Google; runtime/VM mayoritas ditulis di C++ dan sebagian di Dart; tooling: Dart SDK. Sumber resmi: `dart.dev`.
* **Yang harus dikuasai**: Dart language (generics, null-safety, class), koleksi built-in (`List`, `Set`, `Map`), cara membuat custom Iterator (`Iterator<T>`, `Iterable`), isolates untuk concurrency jika perlu.
* **Tools**: pasang Dart SDK, gunakan `dart analyze`, `dart test`. Editor: VSCode/Neovim (LSP `dart_language_server`).
* **Untuk modifikasi lebih dalam** (mis. implementasi koleksi native): butuh C++ dan build tools (GN/Ninja) serta pengenalan ke repo `dart-lang/sdk`.

### Untuk Lua — apa dipersiapkan

* **Identitas Lua**: dibuat oleh tim PUC-Rio (Ierusalimschy dkk.); interpreter utama ditulis di C. Situs resmi: `lua.org`.
* **Yang harus dikuasai**: tables (sebagai array & map), metamethods/metatables (untuk behavior kustom seperti operator overloading), closures, pattern untuk memodel struktur data menggunakan tables, dan pembuatan modul/packaging (`luarocks`).
* **Tools**: interpreter `lua` atau `luajit`, `luac` untuk bytecode. Untuk debugging: `mobdebug` atau print-based; gunakan `busted` untuk unit test. Untuk modifikasi interpreter: C knowledge + make/build.

---

# Referensi & bantuan singkat

* **Dart**: dokumentasi resmi (Language Tour, Collections) di `dart.dev`. CLI help: `dart --help`, `dart doc`, `dart test`.
* **Lua**: *Reference Manual* di `lua.org/manual.html` dan buku *Programming in Lua*. CLI help: `lua -v`, `man lua`.
* **Algoritma & Struktur Data**: buku klasik (Cormen et al. CLRS), dokumentasi library bahasa, sumber algoritma teruji (GeeksforGeeks, CP-algorithms untuk implementasi spesifik).

---

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

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
