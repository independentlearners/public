# Daftar Kursus Dart

Dokumentasi kursus singkat dan terstruktur untuk mempelajari Dart dari level dasar hingga lanjutan. Di bawah tiap judul materi terdapat deskripsi singkat dan tautan ke sub-materi terkait.

> **Catatan struktur:** setiap bagian memiliki halaman *Ringkasan* (umumnya `README.md` pada folder topik) sebagai pusat penjelasan. Folder di dalamnya sebagian besar berisi contoh deklarasi dan implementasi kode, sementara beberapa file penjelasan menggunakan nama sesuai topiknya (mis. `inheritance.md`, `polymorphism.md`, `perulangan.md`).

<details>
  <summary>
    <strong>Dasar</strong>
    <div style="font-size:11px;color:grey;margin-left:24px;"><i>Sintaks, tipe data, kontrol alur, dan koleksi data dasar Dart</i></div>
  </summary>
  <div style="padding-left:25px;margin-top:8px;">

Deskripsi singkat: Materi ini membahas fondasi bahasa Dart—variabel, tipe data, kontrol alur, fungsi, koleksi data, dan null safety—agar siap membangun program dan memahami konsep lanjutan.

- [Ringkasan & Peta Materi Dasar][dasar] — halaman utama bagian Dasar
- Topik penting (urutan belajar yang disarankan):
  - [Variabel][variabel] — deklarasi dan penamaan variabel
  - [Tipe Data][tipe-data] — number, string, boolean, dynamic, var, runes, symbol, bigint
  - [Komentar][komentar] — menulis dokumentasi dan catatan kode
  - [Null Safety][nullsafety] — penanganan nilai `null` yang aman pada sistem tipe Dart
  - [Operator][operator] — aritmatika, logika, penugasan, perbandingan, ternary, type-test
  - [Konversi][konversi] — parsing & type conversion, termasuk `toString`
  - [Control Flow][control-flow] — if/else, switch-case
  - [Perulangan][perulangan] — for, while, do-while, break, continue
  - [Collection][collection] — Iterable, List, Set, Map, Queue, hingga membuat collection kustom
    - Implementasi dasar: [List][collection-list] · [Map][collection-map] · [Set][collection-set]
    - Implementasi menengah: [Linked List][collection-linked-list] · [Queue][collection-queue] · [Stack][collection-stack]
  - [Fungsi][fungsi] — deklarasi, parameter, closure, higher-order & recursive function
  - [Modifikator][modifikator] — final, const, dan runtime constant
  - [Generator][generator] — evaluasi lambat (lazy) dengan generator function
  - [late][late] — inisialisasi variabel yang ditunda

  </div>
</details>

<details>
  <summary>
    <strong>OOP</strong>
    <div style="font-size:11px;color:grey;margin-left:24px;"><i>Dasar-dasar Pemrograman Berorientasi Objek</i></div>
  </summary>
  <div style="padding-left:25px;margin-top:8px;">

Deskripsi singkat: Memperkenalkan kelas, objek, enkapsulasi, inheritance, polymorphism, konstruktor, dan pattern OOP di Dart.

- [Ringkasan & Peta Materi OOP][oop] — halaman utama bagian OOP
- Topik penting:
  - [Object & Class][oop-class] — dasar objek, class, field, dan sealed class
  - [Constructor][oop-constructor] — constructor biasa, named, factory, dan const
  - [Encapsulation][oop-encapsulation] — access modifier, getter, dan setter
  - [Inheritance][oop-inheritance] — pewarisan class, override method & field
  - [Interface][oop-interface] — kontrak antar class
  - [Abstract][oop-abstract] — class dan method abstrak
  - [Polymorphism][oop-polymorphism] — overriding, type check & cast
  - [Method][oop-method] — deklarasi method dan expression body
  - [Operator Overloading][oop-operator] — cascade notation dan custom operator
  - [Import & Export][oop-import-export] — modularisasi kode antar file
  - Struktur data lanjutan: [HashSet][oop-hashset] · [SplayTreeMap][oop-splaymap] · [SplayTreeSet][oop-splayset]

  </div>
</details>

<details>
  <summary>
    <strong>Generic</strong>
    <div style="font-size:11px;color:grey;margin-left:24px;"><i>Generic types & error handling</i></div>
  </summary>
  <div style="padding-left:25px;margin-top:8px;">

Deskripsi singkat: Pelajari penggunaan generics untuk membuat fungsi/kelas yang type-safe, alat bantu seperti `Expando`, serta penanganan error/exception.

- [Ringkasan Generic (Class, Function & Type Parameter)][generik] — halaman utama & konsep dasar generics
- Topik pendukung:
  - [Expando][generik-expando] — menyimpan data tambahan tanpa mengubah objek asli
  - [Data & Struktur Generik][generik-data] — contoh struktur data generik
  - [ArgumentError][generik-argument-error] — praktik penanganan exception

  </div>
</details>

<details>
  <summary>
    <strong>Advance</strong>
    <div style="font-size:11px;color:grey;margin-left:24px;"><i>Kualitas kode, tooling, dan transformasi data lanjutan</i></div>
  </summary>
  <div style="padding-left:25px;margin-top:8px;">

Deskripsi singkat: Materi lanjutan untuk pemahaman mendalam—aturan linting untuk menjaga kualitas kode, serta transformasi/pemetaan (mapping) data. Bagian ini terbuka untuk topik arsitektur lanjutan lain (isolates, pattern async/stream, performance tuning) di masa depan.

- [Ringkasan & Peta Materi Advance][advance] — halaman utama bagian Advance
- Topik penting:
  - [Linter][advance-linter] — aturan kualitas kode dan konfigurasi `analysis_options`
    - Contoh aturan: [always_declare_return_types][advance-linter-return-types]
  - [Mapping][advance-mapping] — transformasi dan pemetaan data

  </div>
</details>

# Navigasi

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

<!-- Dasar -->
[dasar]: ./dasar/README.md
[variabel]: ./dasar/variabel/README.md
[tipe-data]: ./dasar/tipe-data/README.md
[komentar]: ./dasar/comentar/README.md
[nullsafety]: ./dasar/nullsafety/README.md
[operator]: ./dasar/operator/README.md
[konversi]: ./dasar/conversion/README.md
[control-flow]: ./dasar/control-flow/README.md
[perulangan]: ./dasar/perulangan/perulangan.md
[collection]: ./dasar/collection/00-panduan-dan-peta-belajar.md
[collection-list]: ./dasar/collection/dasar/list/README.md
[collection-map]: ./dasar/collection/dasar/map/README.md
[collection-set]: ./dasar/collection/dasar/set/README.md
[collection-linked-list]: ./dasar/collection/menengah/linked-list/README.md
[collection-queue]: ./dasar/collection/menengah/queue/README.md
[collection-stack]: ./dasar/collection/menengah/stack/README.md
[fungsi]: ./dasar/function/README.md
[modifikator]: ./dasar/modifikator/README.md
[generator]: ./dasar/other/generator/README.md
[late]: ./dasar/other/late/README.md

<!-- OOP -->
[oop]: ./oop/README.md
[oop-class]: ./oop/class/class-object/README.md
[oop-constructor]: ./oop/constructor/constructor/README.md
[oop-encapsulation]: ./oop/encapsulation/encapsulation.md
[oop-inheritance]: ./oop/inheritance/inheritance.md
[oop-interface]: ./oop/interface/README.md
[oop-abstract]: ./oop/abstrac/README.md
[oop-polymorphism]: ./oop/polymorphism/polymorphism.md
[oop-method]: ./oop/method/method.md
[oop-operator]: ./oop/operator/operator.md
[oop-import-export]: ./oop/import_export/docs.md
[oop-hashset]: ./oop/struktur-data/hash_set.md
[oop-splaymap]: ./oop/struktur-data/splay_tree_map.md
[oop-splayset]: ./oop/struktur-data/splay_tree_set.md

<!-- Generic -->
[generik]: ./generik/README.md
[generik-expando]: ./generik/expando/README.md
[generik-data]: ./generik/data/README.md
[generik-argument-error]: ./generik/argument_error/README.md

<!-- Advance -->
[advance]: ./adnvace/README.md
[advance-linter]: ./adnvace/linter/README.md
[advance-linter-return-types]: ./adnvace/linter/always-declare-return-types/README.md
[advance-mapping]: ./adnvace/mapping/README.md
