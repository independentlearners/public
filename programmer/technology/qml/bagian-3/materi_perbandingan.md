# Materi Mendalam Mastery Qt 6 — Fase 2: JavaScript untuk QML

*Dokumentasi belajar mandiri, lanjutan dokumen Fase 0 dan Fase 1 · 7 November 2026 · Acuan: Kurikulum Mastery Qt 6 — QML & Qt Quick (Edisi Revisi 4 November 2026) · Target Qt 6.12 LTS (minimal 6.8) · Arch Linux, terminal-centric*

## Cara membaca dokumen ini

Pola sama dengan dokumen sebelumnya: audit singkat, pengantar tingkat fase, lalu satu modul per giliran dengan konfirmasi Anda sebelum lanjut. Prasyarat: Fase 0 dan Fase 1 (terutama `galat.md`, `qmllint`, dan komponen). Semua contoh dijalankan dengan `qml NamaBerkas.qml` di `~/Development/qt-learning/fase2/`, dan hasil dicetak ke terminal lewat `console.log`.

| Bagian | Isi | Status |
| --- | --- | --- |
| 1. Audit Fase 2 dan Modul 2.1 | Pemeriksaan sebelum materi | Selesai |
| 2. Fase 2 (tingkat fase) | Peran, filosofi, peta, hubungan | Selesai |
| 3. Modul 2.1 — Dasar JavaScript yang Dipakai QML | Sub-bagian 2.1.1 sampai 2.1.10 | Ditulis di dokumen ini |
| Modul 2.2, 2.3, 2.4 | JavaScript di dokumen, berkas JS dan pragma, lingkungan host | Menunggu konfirmasi Anda |

**Konvensi** sama dengan Fase 0 dan 1: `$` adalah perintah; tabel **Kata demi kata** menerangkan kode; **\[TAMBAHAN\]** menandai materi di luar kurikulum asli beserta alasannya; **\[amati\]** dan **\[uji dulu\]** berarti hasil bergantung mesin atau versi Anda dan harus dibuktikan sendiri. Hasil cetak array dan objek memakai `JSON.stringify` agar bentuknya pasti. Tautan belum diuji otomatis.

## 1. Audit

Diperiksa pada 7 November 2026 terhadap dokumentasi Qt 6.12 (*JavaScript Host Environment*), daftar fungsi JavaScript resmi Qt (versi 6.5), dan catatan di kurikulum. Bagian Fase 2 dan Modul 2.1 saya baca ulang sebelum audit ini.

### 1.1 Audit Fase 2 (tingkat fase)

**Terverifikasi (tidak perlu diubah):**

- Runtime QML mengimplementasikan ECMAScript **edisi ke-7** (ES2016) dengan beberapa tambahan: **`??` sejak Qt 5.15, `?.` sejak 6.2, pemisah numerik sejak 6.8**. Halaman versi Qt lain dapat membahasnya dengan kata berbeda; yang pasti, tidak ada daftar rinci fitur sesudah ES2016, sehingga tiap fitur lanjut harus diuji (2.1.9).
- JavaScript di QML berjalan di **lingkungan host khusus**, bukan peramban: tidak ada `document`, `window`, atau DOM.
- Aturan khusus QML (dokumentasi *Host Environment*): anotasi tipe pada fungsi ditegakkan sejak Qt 6.7 (1.2.8); **fungsi yang ditugaskan ke signal handler tidak boleh beranotasi tipe**; enum tidak dapat menjadi tipe anotasi; objek global JavaScript bersifat **konstan** (tidak dapat diubah); operator `instanceof` diperluas untuk tipe QML; dan ada tambahan khas Qt seperti `String.prototype.arg()` serta metode `Date` dan `Number` yang peka locale.
- Daftar fungsi resmi (6.5) mencantumkan `Map`, `Set`, `WeakMap`, `WeakSet`, `Symbol`, `Promise`, `Proxy`, `Reflect`, `ArrayBuffer`, `JSON`, serta anggota seperti `Object.assign`, `Object.entries`, `Object.values`, `String.prototype.padStart`, `padEnd`, `repeat`, `includes`, `startsWith`, `endsWith`, `Array.prototype.includes`, `find`, `findIndex`, `fill`, `Number.EPSILON`, `Number.isInteger`, dan `Number.isSafeInteger`.

**Perlu dikoreksi atau dilengkapi:**

1. **Daftar tidak lengkap bukan bukti ketiadaan.** Fungsi yang **tidak tercantum** di daftar resmi, antara lain `Array.from`, `Array.of`, `Object.fromEntries`, `Array.prototype.flat`, `flatMap`, `String.prototype.replaceAll`, `at`, BigInt, `async`/`await`, generator, dan spread pada objek, belum bisa dianggap ada **maupun** tak ada. Kurikulum sudah menandainya **\[uji dulu\]**; di sini ditegakkan dengan satu lab probe (2.1.9).
2. **Koreksi untuk dokumen Fase 1.** Di 1.2.4 saya memakai `Array.from(x)` sebagai cara mengubah array-like menjadi larik JavaScript tanpa menandainya **\[uji dulu\]**. Fungsi itu tidak ada di daftar resmi. Catatan koreksi ditambahkan di dokumen Fase 1; cadangannya `Array.prototype.slice.call(x)`.
3. **`setTimeout` dan `setInterval`.** Kurikulum menyatakan keduanya bukan bawaan QML (gunakan `Timer` atau `Qt.callLater`). Ini konsisten dengan lingkungan host tanpa peramban, tetapi tetap dibuktikan di lab probe.
4. **Gaya titik koma.** Contoh kurikulum menulis kode tanpa titik koma; konvensi Qt (1.1.5) menyarankan titik koma pada pernyataan dalam blok. Keduanya sah karena penyisipan titik koma otomatis (*ASI*), tetapi ASI punya jebakan (mis. `return` diikuti baris baru). Dibahas di 2.1.3.
5. **Hubungan dengan Bagian B.** Kurikulum menyebut pendalaman JavaScript ada di Bagian B (Jalur Pendalaman). Fase 2 adalah **fondasi** yang dibutuhkan Fase 3; Bagian B dibaca sesudahnya agar tidak tumpang tindih.
6. **Sub-bagian tambahan:** 2.1.10 (lab galat JavaScript) melanjutkan pola 1.1.7, 1.3.9, dan 1.4.6.

### 1.2 Audit Modul 2.1

**Terverifikasi:** contoh minimal kurikulum berjalan menurut semantik JavaScript baku: `data.map(format)` mengoper `(item, indeks, larik)` ke `format(item)` yang hanya memakai parameter pertama; destructuring dengan nilai bawaan, template literal, `?.`, dan `??` sah di Qt 6.2 ke atas; hasil yang diharapkan `Kopi: 15000 | Teh: 0` dan `tanpa alias`. Jawaban Cek pemahaman benar: `??` hanya menggantikan `null` dan `undefined`, sedangkan `||` juga menggantikan `0`, `''`, `false`, dan `NaN`.

**Perlu dikoreksi atau dilengkapi:**

1. **Contoh minimal hanya menjalankan di terminal.** Akar `Item` tanpa ukuran tidak menampilkan jendela berguna; ini wajar untuk contoh yang hanya mencetak, dan dicatat agar tidak membingungkan (tidak ada jendela yang perlu diharapkan).
2. **2.1.9 “Fitur yang harus diuji dulu”** tidak berisi cara menguji. Ditambahkan skrip probe yang menghasilkan satu berkas per fitur sintaks (karena galat sintaks tidak dapat ditangkap dalam berkas yang sama) dan satu berkas pendeteksi untuk fungsi bawaan.
3. **Terminologi.** Perlu ditambah: *hoisting*, *closure*, *scope*, *shadowing*, *spread* dan *rest*, *mutasi*, *coercion*, *ASI*, dan *fungsi murni*.
4. **Tipe dan konversi** di Fase 1 (1.2.6) sudah memuat jebakan konversi; 2.1.2 tidak mengulang melainkan mendalami sisi JavaScript-nya.
5. **Tambahan khas QML pada string dan angka** (`String.prototype.arg`, `Number.prototype.toLocaleString(locale, format, precision)`) belum disebut di 2.1.6; ditambahkan.
6. **Contoh Latihan** hanya satu soal; ditambah soal bertahap dan satu latihan terpadu.

**Daftar isi Modul 2.1 yang diperbarui:**

| No. | Judul | Asal |
| --- | --- | --- |
| 2.1.1 | Variabel dan scope | Asli |
| 2.1.2 | Tipe dan konversi | Asli |
| 2.1.3 | Fungsi dan arrow function | Asli |
| 2.1.4 | Array: `map`, `filter`, `reduce`, `find` | Asli |
| 2.1.5 | Objek dan destructuring | Asli |
| 2.1.6 | String dan template literal | Asli |
| 2.1.7 | `??` dan `?.` | Asli |
| 2.1.8 | `try/catch` | Asli |
| 2.1.9 | Fitur yang harus diuji dulu: lab probe | Asli, diperluas |
| 2.1.10 | Lab galat JavaScript | **\[TAMBAHAN\]** |

## 2. Fase 2 — JavaScript untuk QML (tingkat fase)

**Daftar isi bagian ini:** 2.1 Deskripsi dan peran · 2.2 Konsep kunci dan filosofi · 2.3 Peta Fase 2 · 2.4 Hubungan dengan fase lain · 2.5 Kriteria lulus · 2.6 Kesalahan umum tingkat fase · 2.7 Referensi

### 2.1 Deskripsi dan peran dalam kurikulum

Fase 2 mengajarkan JavaScript **secukupnya dan benar** untuk QML: dasar bahasa (2.1), cara JavaScript hidup di dalam dokumen QML (2.2), berkas JavaScript dan pragma (2.3), dan batas lingkungan host (2.4). Fase 1 memberi Anda bahasa deklaratif; Fase 2 memberi catatan tangan imperatif di marginnya, untuk logika yang tidak dapat dinyatakan sebagai hubungan. Fase 3 (reaktivitas) mengandalkan keduanya.

### 2.2 Konsep kunci dan filosofi

1. **Deklaratif dulu, imperatif seperlunya.** Bila sesuatu dapat dinyatakan sebagai binding, itu pilihan pertama (0.1.1). JavaScript dipakai untuk **aksi**, **perhitungan yang tak bisa berbentuk rumus**, dan **pengolahan data**.
2. **JavaScript di QML bukan JavaScript peramban.** Ia berjalan di mesin Qt (V4) dengan tambahan khas Qt, tanpa DOM dan tanpa API web.
3. **Berjalan di thread GUI.** Setiap baris JavaScript yang Anda tulis berebut anggaran bingkai (0.0.2); kerja berat harus dipecah atau dipindah (`WorkerScript`, C++).
4. **Uji sebelum mengandalkan.** Karena dukungan fitur sesudah ES2016 tidak terdaftar rinci, kebiasaan menguji fitur dengan berkas kecil adalah keterampilan inti, bukan pelengkap.

**Analogi:** QML adalah menu; JavaScript adalah catatan tangan pelayan di pinggirnya. Catatan yang baik singkat dan jelas; menu yang dipenuhi catatan berarti sebagian harus dijadikan hidangan tersendiri (komponen atau C++).

### 2.3 Peta Fase 2

```
   2.1 Dasar JavaScript yang dipakai QML      "bahasanya"
         |
   2.2 JavaScript di dalam dokumen QML        "di mana ia hidup: binding, handler, fungsi"
         |
   2.3 Berkas JavaScript dan pragma           "memisahkan logika: .js, .pragma library"
         |
   2.4 Lingkungan host dan batasnya           "apa yang ada dan tidak ada: console, Qt, tanpa DOM"
         |
         v
   Fase 3 (reaktivitas)   ...   Bagian B (pendalaman JavaScript)
```

### 2.4 Hubungan dengan fase lain

| Konsep dari Fase 2 | Dipakai kembali di |
| --- | --- |
| Variabel, fungsi, array, objek | Fase 3 (binding dan handler), Fase 7 (data dan model) |
| `??`, `?.`, `try/catch` | Fase 3, Fase 7 (data dari jaringan), Modul 13.1 (validasi masukan) |
| Berkas `.js`, `.pragma library` | Fase 8 (singleton dan modul), Fase 10 (perbandingan dengan C++) |
| Lingkungan host | Fase 11 (kinerja), Modul 13.1 (keamanan) |
| Lab galat dan `galat.md` | Seluruh fase (kamus galat) |

### 2.5 Kriteria lulus

Anda lulus Fase 2 bila dapat, **tanpa melihat catatan**:

- Memilih `const`, `let`, atau `var` dengan alasan, dan menjelaskan scope dan hoisting.
- Menulis fungsi, arrow function, dan closure, serta menjelaskan perbedaan `this`.
- Mengolah data dengan `map`, `filter`, `reduce`, `find`, dan destructuring.
- Memakai `??` dan `?.` dengan benar dan membedakannya dari `||`.
- Menangani galat dengan `try/catch`, dan membaca pesan galat JavaScript di QML.
- Memisahkan logika ke berkas `.js` dengan aman dan menjelaskan `.pragma library`.
- Membuktikan dukungan sebuah fitur JavaScript dengan berkas uji sebelum mengandalkannya.

### 2.6 Kesalahan umum tingkat fase

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Memakai API peramban (`window`, `document`, `fetch`, `setTimeout`) | Mengira ini web | Lihat 2.4; pakai `Timer`, `XMLHttpRequest`, `Qt.callLater` |
| Logika berat di handler | Mengabaikan thread GUI | Pecah kerja atau pindah (0.0.2) |
| JavaScript untuk hal yang cukup dengan binding | Kebiasaan imperatif | Dahulukan binding |
| Mengandalkan fitur ES terbaru tanpa uji | Menyamakan dengan Node atau peramban | Lab probe (2.1.9) |
| Mengabaikan galat di terminal | Aplikasi tetap jalan | Baca log; nol peringatan |

### 2.7 Referensi tingkat fase

- [JavaScript Expressions in QML](https://doc.qt.io/qt-6/qtqml-javascript-expressions.html) · [JavaScript Host Environment](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html)
- [List of JavaScript Objects and Functions](https://doc.qt.io/qt-6/qtqml-javascript-functionlist.html) · [ECMAScript 2016 (edisi ke-7)](https://262.ecma-international.org/7.0/)
- [MDN JavaScript Guide](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide)

---

## 3. Modul 2.1 — Dasar JavaScript yang Dipakai QML

**Daftar isi modul ini:** 3.1 Deskripsi dan peran · 3.2 Filosofi modul · 3.3 Visual: anatomi sebuah ekspresi · 3.4 Terminologi modul · 3.5 Estimasi waktu · lalu 2.1.1 sampai 2.1.10 · 3.6 Penutup Modul 2.1

### 3.1 Deskripsi dan peran

Modul ini membekali Anda dengan bagian JavaScript yang benar-benar akan dipakai di QML: variabel dan scope, tipe, fungsi, array, objek, string, operator `??` dan `?.`, dan penanganan galat, plus cara membuktikan dukungan fitur sebelum mengandalkannya. Semua modul berikutnya memakai JavaScript sebagai lapisan imperatif.

### 3.2 Filosofi modul

**Kecil, murni, dan teruji.** Tulis fungsi kecil yang hanya bergantung pada argumennya (murni), uji dengan berkas kecil, dan tempatkan di tempat yang jelas. JavaScript yang baik di QML hampir tidak terlihat: beberapa baris yang menutup celah antara binding dan kenyataan.

### 3.3 Visual: anatomi sebuah ekspresi

```
  Component.onCompleted: {                      <- handler (blok JavaScript)
      const data = [ { nama: 'Kopi', harga: 15_000 } ]      <- const + literal objek + pemisah numerik
      const { nama, harga = 0 } = data[0]                   <- destructuring + nilai bawaan
      console.log(`${nama}: ${harga}`)                       <- template literal
      console.log(data[1]?.alias ?? 'tanpa alias')           <- ?. lalu ??
  }
```

### 3.4 Terminologi modul

| Istilah | Arti |
| --- | --- |
| Scope (cakupan) | Wilayah tempat sebuah nama dikenal |
| Hoisting | Pemindahan deklarasi ke awal scope oleh engine |
| Closure | Fungsi yang “mengingat” variabel dari scope tempat ia dibuat |
| Arrow function | Fungsi ringkas `(a, b) => a + b`, tanpa `this` sendiri |
| Destructuring | Mengurai array atau objek menjadi variabel |
| Spread / rest | `...x` untuk membentangkan / mengumpulkan |
| Mutasi | Mengubah isi di tempat |
| Nullish coalescing | `??`: nilai cadangan hanya untuk `null` atau `undefined` |
| Optional chaining | `?.`: berhenti dengan `undefined` bila bagian kiri `null` atau `undefined` |
| ASI | *Automatic Semicolon Insertion*: engine menyisipkan titik koma |
| Fungsi murni | Hasil hanya bergantung pada argumen; tanpa efek samping |
| TDZ | *Temporal Dead Zone*: akses `let` atau `const` sebelum dideklarasikan |

### 3.5 Estimasi waktu

Jalur A: 14–18 jam; Jalur B: 5–6 jam.

---

## 2.1.1 Variabel dan scope

*Semangat: sebelum menulis logika, ketahui di mana setiap nama hidup.*

**Daftar isi 2.1.1:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh: `var`, `let`, `const` · d. Scope di dalam dokumen QML · e. Aturan praktis · f. Opsi lain · g. Visual · h. Terminologi · i. Tips · j. Kesalahan umum · k. Hubungan · l. Latihan dan cek · m. Referensi

### a. Deskripsi dan peran

Bagian ini menjelaskan tiga cara mendeklarasikan variabel dan aturan *scope*-nya. Sebagian besar bug JavaScript pemula berasal dari salah paham di sini.

### b. Konsep dan filosofi

| Kata kunci | Scope | Boleh ditugaskan ulang | Hoisting |
| --- | --- | --- | --- |
| `var` | Fungsi | Ya | Dipindah ke atas, bernilai `undefined` sampai ditugaskan |
| `let` | Blok `{ }` | Ya | Terdaftar, tetapi tidak dapat diakses sebelum deklarasi (TDZ) |
| `const` | Blok `{ }` | **Tidak** | Sama seperti `let` |

- `const` mencegah **penugasan ulang** variabel, bukan **mengubah isi** objek atau array yang ditunjuknya.
- Di QML, objek global JavaScript bersifat **konstan** (dokumentasi *Host Environment*): Anda tidak dapat menambah atau mengubah anggota global. Menugaskan ke nama yang tidak pernah dideklarasikan tidak menjadi variabel global diam-diam seperti di sebagian peramban lama; periksa perilakunya di lab 2.1.10 **\[amati\]**.

**Filosofi:** gunakan **`const` secara bawaan**, `let` bila nilainya memang harus berubah, dan **jangan pakai `var`**. Setiap variabel sebaiknya hidup di scope sesempit mungkin.

### c. Contoh: var, let, const

Simpan sebagai `Variabel.qml`, jalankan `qml Variabel.qml`:

```qml
import QtQuick

Item {
    Component.onCompleted: {
        var a = 1;
        if (true) { var a = 2; }
        console.log('var a =', a);

        let b = 1;
        if (true) { let b = 2; }
        console.log('let b =', b);

        const daftar = [1, 2];
        daftar.push(3);
        console.log('const daftar =', JSON.stringify(daftar));

        console.log(typeof naik, typeof turun);
        function naik() { }
        var turun = function () { };

        try {
            console.log(x);
            let x = 5;
        } catch (e) {
            console.log('TDZ:', e.name);
        }

        const f1 = [];
        for (var i = 0; i < 3; i++) f1.push(() => i);
        console.log('var  :', JSON.stringify(f1.map(f => f())));

        const f2 = [];
        for (let j = 0; j < 3; j++) f2.push(() => j);
        console.log('let  :', JSON.stringify(f2.map(f => f())));
    }
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `var a = 1; if (...) { var a = 2; }` | `var` tidak peduli blok: deklarasi kedua adalah variabel **yang sama**. Dugaan: `var a = 2`. |
| `let b = 1; if (...) { let b = 2; }` | `let` punya scope blok: `b` di dalam blok adalah variabel **lain**. Dugaan: `let b = 1`. |
| `const daftar = [1, 2]; daftar.push(3)` | Mengubah **isi** diperbolehkan; `daftar = []` akan menghasilkan `TypeError`. Dugaan: `[1,2,3]`. |
| `typeof naik, typeof turun` | Deklarasi fungsi dipindah penuh ke atas (`function`); `var turun` hanya namanya (`undefined`). |
| `try { console.log(x); let x = 5; }` | Akses `x` sebelum deklarasinya: **TDZ**, dugaan `ReferenceError`. |
| `for (var i ...)` dengan closure | Semua closure berbagi satu `i`; hasil dugaan `[3,3,3]`. |
| `for (let j ...)` dengan closure | Tiap putaran membuat `j` baru; hasil dugaan `[0,1,2]`. |
| `JSON.stringify(...)` | Membuat bentuk cetak array yang pasti. |

Bandingkan keluaran Anda dengan dugaan di kolom kanan; selisih apa pun dicatat di `galat.md`.

### d. Scope di dalam dokumen QML

Di dalam dokumen QML, selain variabel JavaScript, nama dapat berasal dari **`id`** dan **properti** objek (1.1.4). Variabel lokal bisa **menimpa** (*shadow*) properti:

```qml
import QtQuick

Item {
    id: root
    property int jumlah: 10

    function contoh() {
        const jumlah = 99;
        console.log(jumlah, root.jumlah);
    }

    Component.onCompleted: contoh()
}
```

| Bagian | Arti |
| --- | --- |
| `const jumlah = 99` | Variabel lokal bernama sama dengan properti. |
| `console.log(jumlah, root.jumlah)` | Dugaan: `99 10`. Nama tak berkualifikasi merujuk variabel lokal; properti tetap dapat dicapai lewat `root.jumlah`. |

Inilah alasan konvensi Qt menyarankan **menyebut objek secara eksplisit** (`root.jumlah`), sehingga tidak ada keraguan. Pragma `ComponentBehavior: Bound` (1.1.1) juga memengaruhi `id` dari komponen luar di dalam komponen bersarang.

### e. Aturan praktis

1. `const` secara bawaan; `let` bila harus berubah; tidak pernah `var`.
2. Deklarasikan variabel **sedekat mungkin** dengan pemakaiannya, di scope sesempit mungkin.
3. Jangan menaruh variabel di luar fungsi di berkas `.js` (itu keadaan bersama; lihat 2.3).
4. Beri nama yang tidak menimpa properti atau `id`.
5. Satu deklarasi per baris.

### f. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Nilai tetap sepanjang objek hidup | `readonly property` | Di tingkat QML (1.3.2) |
| Keadaan yang diamati UI | `property` | Bukan variabel JavaScript |
| Variabel hanya untuk satu fungsi | `const` atau `let` lokal | Pilihan umum |
| Konstanta bersama | Berkas `.js` atau singleton | 2.3 dan Fase 8 |
| Mengunci objek | `Object.freeze(obj)` | Mencegah mutasi; dangkal |

### g. Visual

```
  var   :  [ fungsi .................................. ]   satu variabel, terlihat di seluruh fungsi
  let   :  [ fungsi [ blok { let b } ] ]               b hanya di dalam blok
  const :  seperti let, TIDAK boleh ditugaskan ulang (isi objek tetap boleh berubah)

  QML:  nama lokal  >  id / properti dokumen        (lokal menimpa; sebut root.x untuk yang di luar)
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| Deklarasi / penugasan | Membuat nama / memberinya nilai |
| Scope fungsi / blok | Wilayah berlaku `var` / `let` dan `const` |
| Hoisting | Pemindahan deklarasi ke atas scope |
| TDZ | Wilayah sebelum deklarasi `let` atau `const` |
| Shadowing | Nama lokal menutupi nama di scope luar |
| Closure | Fungsi yang membawa scope tempat ia lahir |

### i. Tips dan praktik terbaik

- Biarkan `qmllint` menandai `var` dan akses tak berkualifikasi.
- Bila Anda menulis `let`, tanyakan: bisakah ini `const`?
- Gunakan `Object.freeze` untuk konstanta objek bila perlu, ingat sifatnya dangkal.
- Hindari nama satu huruf kecuali untuk indeks kecil.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Semua closure di loop mengembalikan nilai sama | `var` dalam loop | Pakai `let` |
| `ReferenceError` pada variabel yang “ada” di bawah | TDZ | Deklarasikan sebelum dipakai |
| `TypeError: Assignment to constant variable` | Menugaskan ulang `const` | Pakai `let`, atau ubah isi alih-alih menugaskan ulang |
| Variabel lokal menimpa properti | Nama sama | Ganti nama, atau rujuk lewat `id` |
| Mengira `const` membuat objek tak berubah | Hanya penugasan ulang yang dilarang | `Object.freeze` |

### k. Hubungan dengan modul lain

Prasyarat untuk 2.1.3 (closure dan fungsi), Modul 2.2 (scope di dalam dokumen QML), Modul 2.3 (variabel di berkas JavaScript), dan Fase 3 (binding yang bergantung pada nama).

### l. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Variabel.qml`, catat setiap baris, dan bandingkan dengan dugaan. Lalu: (1) ubah loop `var` agar menghasilkan `[0,1,2]` tanpa mengganti `var` menjadi `let` (petunjuk: fungsi pembungkus); (2) coba menugaskan ulang `daftar` dan catat galatnya; (3) coba `x = 5` tanpa deklarasi dan catat hasilnya **\[amati\]**.

**Cek pemahaman.** (1) Apa beda scope `var` dan `let`? (2) Mengapa `const` tidak membuat array tak berubah? (3) Apa itu TDZ dan bagaimana mengujinya?

### m. Referensi

- [MDN: let](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let) · [const](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/const) · [var](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/var) · [Closures](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures)
- [JavaScript Host Environment](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html) · [Scope and Naming Resolution](https://doc.qt.io/qt-6/qtqml-documents-scope.html)

---

## 2.1.2 Tipe dan konversi

*Semangat: yang tahu jenis nilainya tahu perilaku programnya.*

**Daftar isi 2.1.2:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh: jenis nilai · d. Angka: batas dan pemisah · e. Konversi eksplisit · f. Dari tipe QML ke JavaScript · g. Opsi lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Bagian ini mendalami tipe dari sisi **JavaScript**; sisi QML dan jebakan konversi umum sudah di 1.2. Fokusnya: tipe primitif, batas angka, dan konversi yang Anda tulis sendiri.

### b. Konsep dan filosofi

JavaScript punya tujuh jenis nilai primitif yang dikenal luas (`number`, `string`, `boolean`, `null`, `undefined`, `symbol`, dan `bigint` pada edisi yang lebih baru), serta objek. Di QML:

- `number` adalah satu-satunya jenis angka: bilangan ganda IEEE 754. Properti `int` dan `real` keduanya tampil sebagai `number`.
- `bigint` **tidak tercantum** di daftar objek resmi Qt; anggap tidak tersedia sampai Anda membuktikan (2.1.9).
- `symbol` tersedia (daftar fungsi resmi mencantumkan `Symbol`).
- `null` dan `undefined` keduanya “kosong” dengan makna berbeda: `undefined` berarti **belum ada nilai**, `null` berarti **sengaja kosong**.

**Filosofi:** jangan menebak jenis nilai; periksa dengan `typeof`, konversi di perbatasan, dan bandingkan dengan `===`.

### c. Contoh: jenis nilai

Simpan sebagai `Tipe.qml`:

```qml
import QtQuick

Item {
    Component.onCompleted: {
        const nilai = [42, 'teks', true, null, undefined, Symbol('s'), [1], { a: 1 }, () => 1, new Date(0)];
        console.log(nilai.map(v => typeof v).join(', '));

        console.log(Number.isInteger(5), Number.isInteger(5.5), Number.isSafeInteger(2 ** 53));
        console.log(Number.MAX_SAFE_INTEGER, Number.EPSILON > 0);
        console.log(Object.is(NaN, NaN), NaN === NaN, Object.is(0, -0), 0 === -0);
        console.log(Infinity > 1e308, -Infinity < -1e308, 1 / 0, -1 / 0, 0 / 0);
    }
}
```

| Bagian | Arti |
| --- | --- |
| `nilai.map(v => typeof v).join(', ')` | Jenis tiap elemen. Dugaan: `number, string, boolean, object, undefined, symbol, object, object, function, object`. Perhatikan `typeof null` yang `object`. |
| `Number.isInteger(5)` | `true`; `5.5` menjadi `false`. |
| `Number.isSafeInteger(2 ** 53)` | `2 ** 53` berada di luar rentang bilangan bulat aman: `false`. Operator `**` ada sejak ES2016. |
| `Number.MAX_SAFE_INTEGER` | `9007199254740991`. |
| `Object.is(NaN, NaN)`, `NaN === NaN` | `true` dan `false`: `Object.is` menganggap dua `NaN` sama. |
| `Object.is(0, -0)`, `0 === -0` | `false` dan `true`: `Object.is` membedakan nol positif dan negatif. |
| `1 / 0`, `-1 / 0`, `0 / 0` | `Infinity`, `-Infinity`, `NaN`: JavaScript tidak melempar galat pada pembagian nol. |

### d. Angka: batas dan pemisah

- Bilangan bulat aman berada di antara `-(2^53 - 1)` dan `2^53 - 1` (`Number.MAX_SAFE_INTEGER`). Di luar itu, presisi hilang (relevan untuk epoch dalam mikrodetik atau identifier panjang; 1.2.3).
- **Pemisah numerik** (`15_000`, `1_000_000`) tersedia **sejak Qt 6.8** menurut dokumentasi: membuat angka besar terbaca. Pemisah hanya untuk keterbacaan; nilainya tetap angka biasa.
- Pembulatan: `Math.round` (ke terdekat; pecahan `.5` dibulatkan ke arah `+Infinity`), `Math.floor`, `Math.ceil`, `Math.trunc`, dan `toFixed(n)` yang mengembalikan **teks**.

```qml
import QtQuick

Item {
    Component.onCompleted: {
        const harga = 15_000;
        console.log(harga, typeof harga, 1_000_000 === 1000000);
        console.log(Math.round(2.5), Math.round(-2.5), Math.trunc(-2.7), Math.floor(-2.7), Math.ceil(-2.2));
        console.log((1234.5678).toFixed(2), typeof (1234.5678).toFixed(2));
        console.log(0.1 * 3, (0.1 * 3).toFixed(2), Number((0.1 * 3).toFixed(2)));
    }
}
```

| Bagian | Arti |
| --- | --- |
| `15_000` | Angka dengan pemisah (Qt 6.8 ke atas); `1_000_000 === 1000000` bernilai `true`. |
| `Math.round(2.5), Math.round(-2.5)` | Dugaan `3` dan `-2`: `.5` dibulatkan menuju `+Infinity`. |
| `Math.trunc(-2.7)`, `Math.floor(-2.7)`, `Math.ceil(-2.2)` | `-2`, `-3`, `-2`. |
| `(1234.5678).toFixed(2)` | Teks `'1234.57'`; `typeof` bernilai `string`. |
| `0.1 * 3` | `0.30000000000000004`; `toFixed(2)` memberi teks `'0.30'`; `Number(...)` mengubah kembali ke angka `0.3`. |

Catatan: pemisah numerik membutuhkan Qt 6.8 atau lebih baru; di bawahnya sintaksnya galat. Karena kurikulum menargetkan minimum 6.8, aman dipakai; tetap catat bila Anda menyasar versi lebih lama.

### e. Konversi eksplisit

| Tujuan | Pakai | Catatan |
| --- | --- | --- |
| Teks ke angka (ketat) | `Number('42')` | `NaN` bila ada karakter tak valid |
| Teks ke bulat (longgar) | `parseInt('42px', 10)` | Selalu beri radix 10; berhenti di karakter pertama yang tak valid |
| Teks ke pecahan (longgar) | `parseFloat('3.14abc')` | Berhenti di karakter tak valid |
| Apa pun ke teks | `String(x)`, `` `${x}` `` | `String(null)` adalah `'null'` |
| Apa pun ke boolean | `Boolean(x)`, `!!x` | Daftar falsy: `0`, `''`, `NaN`, `null`, `undefined`, `false` |
| Objek ke teks JSON | `JSON.stringify(x)` | Fungsi dan `undefined` dilewati |
| Teks JSON ke objek | `JSON.parse(s)` | Melempar galat bila tidak valid (2.1.8) |

### f. Dari tipe QML ke JavaScript

| Tipe QML | Tampil di JavaScript sebagai |
| --- | --- |
| `bool` | `boolean` |
| `int`, `real`, `double` | `number` |
| `string` | `string` |
| `var` | Apa pun yang disimpannya |
| `date` | `Date` |
| `list`, `QVariantList` dari C++ | Array-like (`Array.isArray` bisa `false`; 1.2.4) |
| `color`, `point`, `rect`, `url`, `font` | Objek nilai (`typeof` perlu diamati; 1.2.8) |
| Objek QML | `object` |

### g. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Angka tepat untuk uang | Simpan satuan terkecil sebagai bilangan bulat | Hindari pecahan biner |
| Memformat angka untuk tampilan | `toFixed`, `toLocaleString` (Qt menambah parameter locale) | 2.1.6 |
| Bilangan sangat besar | `BigInt` | **\[uji dulu\]**; tidak tercantum di daftar resmi |
| Membandingkan nilai atau objek | `===`, `Object.is`, atau fungsi pembanding | Objek dibandingkan per rujukan |
| Memeriksa jenis objek QML | `instanceof`, `as` | 1.2.8 |

### h. Visual

```
  nilai --typeof--> 'number' | 'string' | 'boolean' | 'object' (termasuk null, array, Date) | 'function' | 'undefined' | 'symbol'

  Number('42') ==> 42        parseInt('42px', 10) ==> 42       Number('42px') ==> NaN
  0.1 + 0.2 ==> 0.30000000000000004      toFixed(2) ==> '0.30' (teks!)
  batas aman: -(2^53 - 1) ... 2^53 - 1
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Primitif | Nilai sederhana yang tak dapat diubah (angka, teks, boolean, ...) |
| IEEE 754 | Standar bilangan pecahan biner |
| `NaN` | Bukan angka |
| Falsy | Nilai yang bernilai salah dalam kondisi |
| Radix | Basis bilangan pada `parseInt` |
| Pemisah numerik | Garis bawah dalam literal angka (6.8) |
| Koersi | Perubahan tipe otomatis oleh operator |

### j. Tips dan praktik terbaik

- Konversi di tepi (data masuk), lalu gunakan tipe yang benar di dalam.
- Tulis `=== undefined` dan `=== null` eksplisit bila membedakan keduanya penting; gunakan `== null` hanya bila sengaja menangkap keduanya (dan beri komentar).
- Hindari `parseInt` tanpa radix.
- Gunakan pemisah numerik untuk konstanta besar demi keterbacaan.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `'5' + 3` menjadi `'53'` | `+` dengan teks menyambung | `Number('5') + 3` |
| `toFixed` menghasilkan teks yang lalu dijumlahkan | `toFixed` mengembalikan `string` | `Number(...)` bila perlu angka |
| `NaN` merambat | Konversi gagal tak diperiksa | `Number.isNaN` |
| `0.1 + 0.2 !== 0.3` | Pecahan biner | Toleransi atau satuan bulat |
| `typeof null === 'object'` mengejutkan | Keanehan bahasa | `x === null` |
| Sintaks `15_000` galat | Qt di bawah 6.8 | Perbarui Qt, atau hapus pemisah |

### l. Hubungan dengan modul lain

Prasyarat untuk 2.1.3 sampai 2.1.8, Modul 2.4 (lingkungan host dan `Number`/`Date` khas Qt), Fase 3 (binding bertipe), dan Fase 7 (data JSON dari jaringan).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan kedua berkas contoh dan cocokkan dengan dugaan. Lalu: (1) hitung total belanja dari tiga harga ber-pecahan dan bandingkan hasil tanpa dan dengan satuan terkecil; (2) tulis fungsi `keAngka(teks)` yang mengembalikan `NaN` bila ada karakter tak valid dan periksa tiga masukan; (3) coba `10n` (literal BigInt) di berkas terpisah dan catat hasilnya **\[uji dulu\]**.

**Cek pemahaman.** (1) Mengapa `typeof null` adalah `'object'`? (2) Apa bedanya `Number('42px')` dan `parseInt('42px', 10)`? (3) Sejak Qt berapa pemisah numerik tersedia?

### n. Referensi

- [MDN: Data types and data structures](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures) · [Number](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number) · [Math](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math)
- [List of JavaScript Objects and Functions](https://doc.qt.io/qt-6/qtqml-javascript-functionlist.html) · [JavaScript Host Environment](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html)

---

## 2.1.3 Fungsi dan arrow function

*Semangat: fungsi kecil yang jelas adalah batu bata logika yang baik.*

**Daftar isi 2.1.3:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh: bentuk fungsi · d. `this` · e. Jebakan ASI · f. Fungsi di dalam objek QML · g. Opsi lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Fungsi adalah unit logika JavaScript. Di QML ia muncul sebagai **metode** objek, sebagai **ekspresi handler** (`onClicked`), dan sebagai **fungsi pembantu** di berkas `.js`. Bagian ini mengajarkan bentuk-bentuknya, closure, `this`, dan jebakan yang khas.

### b. Konsep dan filosofi

| Bentuk | Contoh | Ciri |
| --- | --- | --- |
| Deklarasi fungsi | `function jumlah(a, b) { return a + b; }` | Dipindah ke atas scope (*hoisted*); punya `this` dan `arguments` |
| Ekspresi fungsi | `const f = function (x) { ... }` | Tidak di-hoist sebagai fungsi |
| Arrow function | `(a, b) => a * b`, `x => x * x` | Ringkas; **tidak punya `this` sendiri**; `return` implisit untuk ekspresi tunggal |
| Metode objek | `{ hitung() { ... } }` | Singkatan penulisan fungsi di dalam objek |

Fitur parameter: **nilai bawaan** (`b = 10`), **rest** (`...angka`, mengumpulkan sisa argumen menjadi array), dan **spread** pada panggilan (`f(...larik)`). **Closure** adalah fungsi yang membawa variabel dari scope tempat ia lahir.

**Filosofi:** tulis fungsi **murni** bila bisa: hasilnya hanya bergantung pada argumen dan tidak mengubah apa pun di luar. Fungsi murni mudah diuji, mudah dipahami, dan aman dipakai di dalam binding (Fase 3).

### c. Contoh: bentuk fungsi

Simpan sebagai `Fungsi.qml`:

```qml
import QtQuick

Item {
    function jumlah(a, b = 10) {
        return a + b;
    }

    function buatPenghitung() {
        let n = 0;
        return () => ++n;
    }

    Component.onCompleted: {
        const kali = (a, b) => a * b;
        const kuadrat = x => x * x;
        const rata = (...angka) => angka.reduce((s, x) => s + x, 0) / angka.length;

        console.log(jumlah(1), jumlah(1, 2), kali(3, 4), kuadrat(5));
        console.log(rata(2, 4, 6), rata(...[1, 2, 3, 4]));

        const p1 = buatPenghitung();
        const p2 = buatPenghitung();
        console.log(p1(), p1(), p1(), p2());

        console.log(Math.max(...[3, 9, 4]), [1, 2, 3].map(kuadrat).join(','));
    }
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `function jumlah(a, b = 10)` | Metode QML dengan parameter bawaan. Dugaan: `jumlah(1)` adalah `11`, `jumlah(1, 2)` adalah `3`. |
| `function buatPenghitung() { let n = 0; return () => ++n; }` | Mengembalikan arrow function yang **mengingat** `n`: closure. |
| `const kali = (a, b) => a * b` | Arrow dengan dua parameter dan `return` implisit; dugaan `kali(3, 4)` adalah `12`. |
| `const rata = (...angka) => ...` | Rest: `angka` adalah array dari semua argumen; `reduce` menjumlahkannya (2.1.4); `rata(2, 4, 6)` adalah `4`. |
| `rata(...[1, 2, 3, 4])` | Spread: membentangkan array menjadi argumen terpisah; hasil `2.5`. |
| `p1(), p1(), p1(), p2()` | Tiap penghitung punya `n` sendiri: dugaan `1 2 3 1`. |
| `Math.max(...[3, 9, 4])` | `9`; `[1, 2, 3].map(kuadrat)` menghasilkan `1,4,9`. |

### d. this

`this` di fungsi biasa ditentukan oleh **cara pemanggilan**; arrow function **tidak punya `this` sendiri** dan memakai milik scope di sekitarnya. Simpan sebagai `Ini.qml`:

```qml
import QtQuick

Item {
    Component.onCompleted: {
        const obj = {
            nama: 'obj',
            biasa: function () { return this.nama; },
            tertunda() { return [1].map(() => this.nama)[0]; },
            panah: () => typeof this
        };

        console.log(obj.biasa(), obj.tertunda(), obj.panah());

        const lepas = obj.biasa;
        try {
            console.log(lepas());
        } catch (e) {
            console.log(e.name);
        }
    }
}
```

| Bagian | Arti |
| --- | --- |
| `biasa: function () { return this.nama; }` | `this` = objek pemanggil (`obj`): dugaan `obj`. |
| `tertunda() { [1].map(() => this.nama) }` | Arrow di dalam metode **mewarisi** `this` metode: dugaan `obj`. |
| `panah: () => typeof this` | Arrow di level objek tidak mengikat `this` ke `obj`; isi `this`-nya bergantung konteks QML Anda **\[amati\]**. |
| `const lepas = obj.biasa; lepas()` | Fungsi dilepas dari objeknya: `this` bukan lagi `obj`; hasilnya bergantung mode eksekusi (galat atau `undefined`) **\[amati\]**. |

Aturan praktis: gunakan **arrow function untuk callback** (`map`, `filter`, `setelah selesai`) dan **metode biasa** untuk fungsi yang memang menjadi milik objek. Di QML, lebih aman merujuk objek lewat **`id`** (1.1.4) daripada bergantung pada `this`.

### e. Jebakan ASI

Engine menyisipkan titik koma otomatis (*ASI*) pada akhir baris tertentu, dan di beberapa tempat hasilnya mengejutkan:

```qml
import QtQuick

Item {
    Component.onCompleted: {
        function a() {
            return
            42
        }

        function b() {
            return 42
        }

        console.log(a(), b());
    }
}
```

| Bagian | Arti |
| --- | --- |
| `return` diikuti baris baru | ASI menyisipkan `;` setelah `return`: fungsi mengembalikan `undefined`, dan `42` tak pernah dijalankan. Dugaan `undefined 42`. |
| `return 42` | Satu baris: benar. |

Karena itu Qt menyarankan titik koma pada pernyataan dalam blok (1.1.5), dan `qmlformat --semicolon-rule always` dapat menegakkannya. Hati-hati juga dengan baris yang diawali `(` atau `[` tepat setelah baris tanpa titik koma.

### f. Fungsi di dalam objek QML

- Metode QML dideklarasikan dengan `function nama(param: tipe): tipeHasil { ... }` (1.3.6); **anotasi tipe ditegakkan sejak Qt 6.7** (1.2.8).
- **Arrow function yang dipakai sebagai signal handler tidak boleh beranotasi tipe** (dokumentasi *Host Environment*); tipe parameter ditentukan oleh signal.
- Pernyataan JavaScript tingkat atas (`const x = 1;` langsung di badan objek QML) **tidak diizinkan**; deklarasi hanya boleh di dalam fungsi, handler, atau berkas `.js`.
- Fungsi yang dipanggil di dalam binding membuat binding bergantung pada **semua properti yang dibaca di dalam fungsi itu** (Fase 3). Fungsi dengan efek samping (mengubah properti) di dalam binding adalah bau kode.

### g. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Metode milik objek QML | `function nama() { }` di badan objek | Beranotasi tipe; terlihat dari luar |
| Logika bersama banyak berkas | Fungsi di berkas `.js` | 2.3 |
| Fungsi sebagai nilai properti | `property var f: (x) => x * 2` | Hilang jaminan tipe; hindari |
| Callback singkat | Arrow function | Tanpa `this` sendiri |
| Logika berat | Fungsi C++ yang diekspos | Fase 10 |

### h. Visual

```
  function f(a, b = 1, ...sisa) { }        f(1)  f(1, 2)  f(1, 2, 3, 4)
        |                                   a=1,b=1     a=1,b=2     a=1,b=2,sisa=[3,4]
  (x) => x * 2                              arrow: ringkas, TANPA this sendiri

  closure:  buatPenghitung()  --->  fungsi + [n = 0] yang dibawanya  (tiap pemanggilan punya n sendiri)
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Fungsi murni | Hasil hanya bergantung argumen; tanpa efek samping |
| Closure | Fungsi beserta variabel dari scope lahirnya |
| Rest / spread | Mengumpulkan / membentangkan argumen atau elemen |
| Parameter bawaan | Nilai jika argumen tak diberikan (`b = 10`) |
| Fungsi tingkat tinggi | Fungsi yang menerima atau mengembalikan fungsi |
| ASI | Penyisipan titik koma otomatis |
| Callback | Fungsi yang diberikan untuk dipanggil nanti |

### j. Tips dan praktik terbaik

- Tulis fungsi pendek dengan satu tugas dan nama kata kerja.
- Pakai arrow untuk callback, deklarasi fungsi untuk metode bernama.
- Beri titik koma dalam blok, dan jalankan `qmlformat` (1.1.5).
- Jangan mengubah properti di fungsi yang dipakai dalam binding.
- Beri anotasi tipe pada metode QML (1.2.8).

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `return` mengembalikan `undefined` | ASI setelah `return` | Satu baris, atau kurung buka di baris yang sama |
| `this` salah setelah fungsi dilepas dari objeknya | `this` ditentukan pemanggilan | Arrow di dalam metode, atau rujuk lewat `id` |
| Galat saat memberi anotasi pada handler panah | Dilarang di signal handler | Hapus anotasi; tipe berasal dari signal |
| Galat pada pernyataan `const` di badan objek | Tidak diizinkan di tingkat objek | Pindah ke fungsi atau `.js` |
| Closure di loop mengembalikan nilai sama | `var` dalam loop | `let` (2.1.1) |
| Binding berubah-ubah tak terduga | Fungsi dengan efek samping di binding | Fungsi murni |

### l. Hubungan dengan modul lain

Prasyarat untuk 2.1.4 (callback array), Modul 2.2 (fungsi dalam dokumen QML dan binding), Modul 2.3 (fungsi di berkas `.js`), dan Fase 3 (handler dan binding).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Fungsi.qml`, `Ini.qml`, dan contoh ASI, lalu cocokkan dengan dugaan. Lalu: (1) tulis `kompos(f, g)` yang mengembalikan fungsi `x => f(g(x))`; (2) tulis fungsi murni `diskon(harga, persen = 10)` dan uji tiga masukan; (3) ubah salah satu metode contoh menjadi bentuk beranotasi dan panggil dengan tipe salah, catat hasilnya **\[amati\]**.

**Cek pemahaman.** (1) Apa bedanya arrow function dan fungsi biasa dalam hal `this`? (2) Apa itu closure? (3) Mengapa `return` diikuti baris baru berbahaya?

### n. Referensi

- [MDN: Functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Functions) · [Arrow functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions) · [this](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/this)
- [JavaScript Host Environment](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html) · [QML Object Attributes: methods](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html)

---

## 2.1.4 Array: map, filter, reduce, find

*Semangat: mengolah data dengan satu rangkaian pertanyaan lebih terang daripada seribu perulangan.*

**Daftar isi 2.1.4:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh: katalog produk · d. Yang mengubah dan yang tidak · e. Mengurutkan dengan benar · f. Array di QML · g. Opsi lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Hampir semua data yang Anda tampilkan (daftar kontak, produk, hasil jaringan) berbentuk array. Metode array tingkat tinggi memungkinkan Anda menyaring, mengubah, dan mengagregasi tanpa perulangan manual.

### b. Konsep dan filosofi

| Metode | Fungsi | Mengubah array asli? |
| --- | --- | --- |
| `map(f)` | Array baru dari hasil `f` pada tiap elemen | Tidak |
| `filter(f)` | Elemen yang lolos uji `f` | Tidak |
| `reduce(f, awal)` | Menggabungkan elemen jadi satu nilai | Tidak |
| `find(f)`, `findIndex(f)` | Elemen / indeks pertama yang lolos | Tidak |
| `some(f)`, `every(f)` | Ada / semua elemen lolos? | Tidak |
| `includes(x)`, `indexOf(x)` | Apakah / di mana `x` ada | Tidak |
| `slice(a, b)`, `concat(...)` | Salinan potongan / gabungan | Tidak |
| `join(pemisah)` | Menjadi teks | Tidak |
| `push`, `pop`, `shift`, `unshift` | Tambah / buang di ujung | **Ya** |
| `splice(a, n)` | Buang atau sisip di tengah | **Ya** |
| `sort(f)`, `reverse()` | Urutkan / balik | **Ya** |

**Filosofi:** utamakan metode **yang tidak mengubah** array asli; ia sejalan dengan pola penugasan ulang di QML (1.2.4) dan lebih sulit disalahgunakan.

### c. Contoh: katalog produk

Simpan sebagai `Larik.qml`:

```qml
import QtQuick

Item {
    Component.onCompleted: {
        const produk = [
            { nama: 'Kopi', harga: 15_000, stok: 3 },
            { nama: 'Teh', harga: 8_000, stok: 0 },
            { nama: 'Roti', harga: 12_000, stok: 5 },
            { nama: 'Susu', harga: 18_000, stok: 2 }
        ];

        const tersedia = produk.filter(p => p.stok > 0);
        const nama = tersedia.map(p => p.nama);
        const total = tersedia.reduce((s, p) => s + p.harga * p.stok, 0);
        const termurah = tersedia.reduce((a, b) => a.harga <= b.harga ? a : b);
        const roti = produk.find(p => p.nama === 'Roti');
        const idx = produk.findIndex(p => p.nama === 'Susu');

        console.log(nama.join(', '));
        console.log(total, termurah.nama, roti.harga, idx);
        console.log(produk.some(p => p.stok === 0), produk.every(p => p.harga > 5_000));
        console.log([3, 1, 10, 2].sort().join(','), [3, 1, 10, 2].sort((a, b) => a - b).join(','));
        console.log(produk.map(p => p.nama).includes('Teh'));

        const a = [1, 2, 3, 4, 5];
        const salinan = a.slice(1, 3);
        const hapus = a.splice(1, 2);
        console.log(JSON.stringify(salinan), JSON.stringify(hapus), JSON.stringify(a));
        console.log(JSON.stringify([...a, 9]), JSON.stringify(a.concat([7, 8])));
    }
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `produk.filter(p => p.stok > 0)` | Tinggal produk yang stoknya ada: Kopi, Roti, Susu. |
| `tersedia.map(p => p.nama)` | Array nama; `join(', ')` menjadikannya `Kopi, Roti, Susu`. |
| `reduce((s, p) => s + p.harga * p.stok, 0)` | Jumlah nilai persediaan: `141000`. Nilai awal `0` wajib agar aman pada array kosong. |
| `reduce((a, b) => a.harga <= b.harga ? a : b)` | Mencari yang termurah tanpa nilai awal: `Roti`. |
| `find(...)`, `findIndex(...)` | Elemen `Roti` (harga `12000`) dan indeks `Susu` (`3`). |
| `some(...)`, `every(...)` | `true` dan `true`. |
| `[3, 1, 10, 2].sort()` | **Urut teks**, bukan angka: `1,10,2,3`. |
| `.sort((a, b) => a - b)` | Urut angka dengan pembanding: `1,2,3,10`. |
| `a.slice(1, 3)` | Salinan `[2,3]`; `a` tidak berubah. |
| `a.splice(1, 2)` | **Mengubah** `a`: membuang `[2,3]`; `a` menjadi `[1,4,5]`. |
| `[...a, 9]`, `a.concat([7, 8])` | Array baru `[1,4,5,9]` dan `[1,4,5,7,8]`; spread pada array sah di ES2015 (tetap **\[uji dulu\]** di 2.1.9). |

Bandingkan keluaran Anda dengan dugaan; bentuk cetaknya memakai `JSON.stringify` agar pasti.

### d. Yang mengubah dan yang tidak

Ringkasan: `push`, `pop`, `shift`, `unshift`, `splice`, `sort`, `reverse`, `fill`, dan `copyWithin` **mengubah array asli**. Sisanya mengembalikan nilai atau array baru. Bila array itu milik properti `var` yang diamati antarmuka, mutasi tidak memicu pemberitahuan (1.2.4); hasilkan array baru lalu tugaskan ulang:

```qml
property var daftar: [1, 2, 3]

function tambah(x) { daftar = [...daftar, x]; }
function hapusPertama() { daftar = daftar.slice(1); }
function gandakan() { daftar = daftar.map(v => v * 2); }
```

### e. Mengurutkan dengan benar

- **`sort()` tanpa pembanding mengurutkan sebagai teks**; angka `10` berada sebelum `2`. Selalu beri pembanding: `(a, b) => a - b`.
- Pembanding harus mengembalikan angka negatif, nol, atau positif (bukan boolean).
- Untuk teks berbahasa tertentu gunakan `a.localeCompare(b)`.
- `sort` **mengubah** array asli; salin dulu bila perlu: `[...a].sort(...)` atau `a.slice().sort(...)`.
- Standar modern menuntut `sort` yang **stabil** (elemen setara tetap berurutan); engine Anda belum tentu memenuhinya **\[uji dulu\]**: urutkan data bertanda yang sama dan amati.

### f. Array di QML

- Properti `var` dengan array: ubah lewat penugasan ulang (1.2.4).
- Properti `list<T>` **bukan** `Array`; membaca lewat `length` dan indeks.
- Array-like dari C++ punya metode array, tetapi `Array.isArray()` bisa `false` (1.2.4). Mengubahnya menjadi larik sungguhan: `Array.prototype.slice.call(x)` (sudah teruji luas); `Array.from(x)` tidak tercantum di daftar fungsi resmi Qt **\[uji dulu\]**.
- `ListModel` dan model C++ adalah jawaban untuk data yang berubah dan dipantau (Fase 7).

### g. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Daftar yang dipantau perubahannya | `ListModel`, model C++ | Fase 7 |
| Mengubah array menjadi objek | `reduce` ke objek | `Object.fromEntries` tak tercantum resmi **\[uji dulu\]** |
| Meratakan array bersarang | `reduce` dengan `concat` | `flat` tak tercantum resmi **\[uji dulu\]** |
| Menghapus duplikat | `Array.from(new Set(x))` atau `x.filter((v, i) => x.indexOf(v) === i)` | `Set` tercantum resmi |
| Perulangan dengan efek samping | `for` atau `forEach` | Bukan `map` |
| Mengelompokkan | `reduce` ke objek | Tulis sendiri |

### h. Visual

```
  produk --filter(stok>0)--> tersedia --map(nama)--> ['Kopi','Roti','Susu']
                                |
                                +--reduce(sum)--> 141000

  mengubah asli :  push pop shift unshift splice sort reverse fill
  array baru    :  map filter slice concat  [...a, x]
  sort() polos  :  [10, 2, 3] --> [10, 2, 3]  (urut TEKS)      sort((a,b)=>a-b) --> [2, 3, 10]
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Higher-order function | Fungsi yang menerima fungsi lain (`map`, `filter`) |
| Reduksi | Menggabungkan banyak nilai menjadi satu |
| Mutasi | Mengubah isi di tempat |
| Pembanding | Fungsi `(a, b) => angka` untuk `sort` |
| Stabil | Elemen setara mempertahankan urutan asal |
| Array-like | Objek berindeks dan ber-`length` tanpa metode penuh |

### j. Tips dan praktik terbaik

- Rangkai `filter`, `map`, dan `reduce` secara terbaca; pecah ke variabel bernama bila panjang.
- Selalu beri nilai awal pada `reduce`, kecuali Anda yakin arraynya tak kosong.
- Pakai `find` (bukan `filter(...)[0]`) bila hanya butuh satu elemen.
- Jangan memakai `map` untuk efek samping.
- Untuk daftar besar, perhatikan biaya: setiap rantai membuat array baru.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `[10, 2, 3].sort()` salah urut | Urut sebagai teks | Beri pembanding |
| `TypeError` pada `reduce` | Array kosong tanpa nilai awal | Beri nilai awal |
| Array asli berubah tak sengaja | `sort`, `splice`, `reverse` mengubah asli | Salin dulu |
| Tampilan tak berubah setelah `push` | Mutasi tak diamati | Tugaskan ulang |
| `find` mengembalikan `undefined` | Tidak ada yang lolos | Periksa hasil dengan `?.` atau `??` (2.1.7) |
| `Array.from` galat | Tidak tercantum resmi | Uji; cadangan `slice.call` |

### l. Hubungan dengan modul lain

Prasyarat untuk 2.1.5 (objek dalam array), 2.1.7 (hasil `find` yang bisa `undefined`), Fase 3 (binding dari hasil olahan), dan Fase 7 (model dan data).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Larik.qml` dan cocokkan dugaan. Lalu: (1) tulis fungsi yang mengelompokkan produk menurut `stok > 0` dengan `reduce`; (2) urutkan produk menurut harga naik tanpa mengubah array asli; (3) hapus duplikat dari `[1, 2, 2, 3, 1]` dengan dua cara dan catat mana yang berjalan di mesin Anda **\[amati\]**.

**Cek pemahaman.** (1) Metode mana yang mengubah array asli? (2) Mengapa `sort()` tanpa pembanding salah untuk angka? (3) Mengapa `reduce` perlu nilai awal?

### n. Referensi

- [MDN: Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array) · [Array.prototype.reduce](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce) · [Array.prototype.sort](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort)
- [List of JavaScript Objects and Functions](https://doc.qt.io/qt-6/qtqml-javascript-functionlist.html) · [QML Value Types: list](https://doc.qt.io/qt-6/qtqml-typesystem-valuetypes.html)

---

## 2.1.5 Objek dan destructuring

*Semangat: data yang tertata rapi adalah setengah dari logika yang benar.*

**Daftar isi 2.1.5:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh: membuat dan mengurai objek · d. Menyalin: dangkal dan dalam · e. Parameter destructuring · f. `Map` dan `Set` · g. Objek JavaScript dan objek QML · h. Opsi lain · i. Visual · j. Terminologi · k. Tips · l. Kesalahan umum · m. Hubungan · n. Latihan dan cek · o. Referensi

### a. Deskripsi dan peran

Objek JavaScript adalah kumpulan pasangan kunci-nilai. Anda memakainya untuk data (satu baris model, satu respons jaringan) dan untuk mengelompokkan nilai yang dikirim ke fungsi. Destructuring adalah cara ringkas mengurainya.

### b. Konsep dan filosofi

- **Literal objek**: `{ nama: 'Kopi', harga: 15_000 }`. Penyingkatan: `{ nama, harga }` (nama variabel = kunci), kunci dihitung `[kunci]: nilai`, dan metode `info() { ... }`.
- **Destructuring** mengurai langsung: `const { nama, harga = 0 } = item`, dengan nama ulang (`nama: n`) dan nilai bawaan; untuk array: `const [a, , c = 'x', ...sisa] = larik`.
- **Operasi umum:** `Object.keys`, `Object.values`, `Object.entries`, `Object.assign` (semuanya tercantum di daftar fungsi resmi), operator `in`, `delete`, dan `JSON.stringify` / `JSON.parse`.
- Objek disalin **per rujukan**; menyalin berarti membuat objek baru secara sengaja.

**Filosofi:** perlakukan objek data sebagai **nilai yang tak diubah**: buat salinan baru untuk perubahan (sejalan dengan 1.2.4 dan 2.1.4).

### c. Contoh: membuat dan mengurai objek

Simpan sebagai `Objek.qml`:

```qml
import QtQuick

Item {
    Component.onCompleted: {
        const nama = 'Kopi';
        const harga = 15_000;
        const kunci = 'stok';
        const item = { nama, harga, [kunci]: 3, info() { return `${this.nama}!`; } };

        const { nama: n, harga: h = 0, diskon = 5 } = item;
        console.log(n, h, diskon);

        const [pertama, , ketiga = 'x', ...sisa] = [1, 2, undefined, 4, 5];
        console.log(pertama, ketiga, JSON.stringify(sisa));

        console.log(Object.keys(item).join(','), Object.values({ a: 1, b: 2 }).join(','));
        console.log(JSON.stringify(Object.entries({ a: 1, b: 2 })));
        console.log(JSON.stringify(Object.assign({}, { a: 1 }, { b: 2 }, { a: 9 })));
        console.log(item.info(), 'harga' in item, 'diskon' in item);
    }
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `{ nama, harga, [kunci]: 3, info() { ... } }` | Singkatan kunci, kunci dihitung (`stok`), dan metode. |
| `const { nama: n, harga: h = 0, diskon = 5 } = item` | Mengurai `nama` ke `n`, `harga` ke `h` (bawaan `0`), dan `diskon` yang tak ada menjadi `5`. Dugaan: `Kopi 15000 5`. |
| `const [pertama, , ketiga = 'x', ...sisa] = [...]` | Elemen pertama, **lompati** yang kedua (koma kosong), ketiga yang `undefined` memakai bawaan `'x'`, `...sisa` mengumpulkan sisanya. Dugaan: `1 x [4,5]`. |
| `Object.keys(item)` | `nama,harga,stok,info`; `Object.values({ a: 1, b: 2 })` adalah `1,2`. |
| `Object.entries({ a: 1, b: 2 })` | `[["a",1],["b",2]]`. |
| `Object.assign({}, {a: 1}, {b: 2}, {a: 9})` | Menggabung ke objek baru; sumber terakhir menang: `{"a":9,"b":2}`. |
| `item.info()`, `'harga' in item`, `'diskon' in item` | `Kopi!`, `true`, `false`. |

### d. Menyalin: dangkal dan dalam

```qml
import QtQuick

Item {
    Component.onCompleted: {
        const dalam = { x: { y: 1 } };

        const dangkal = Object.assign({}, dalam);
        dangkal.x.y = 99;
        console.log(dalam.x.y);

        const salin = JSON.parse(JSON.stringify(dalam));
        salin.x.y = 5;
        console.log(dalam.x.y, 'y' in dalam.x, delete dalam.x.y, 'y' in dalam.x);
    }
}
```

| Bagian | Arti |
| --- | --- |
| `Object.assign({}, dalam)` | Salinan **dangkal**: objek bersarang `x` dipakai bersama. Mengubah `dangkal.x.y` mengubah `dalam.x.y`: dugaan `99`. |
| `JSON.parse(JSON.stringify(dalam))` | Salinan **dalam** sederhana; mengubah `salin` tidak memengaruhi asli. Dugaan baris berikut: `99 true true false`. |
| `delete dalam.x.y` | Menghapus kunci; mengembalikan `true`. |

Batas trik JSON: `Date` menjadi teks, `undefined` dan fungsi hilang, nilai `NaN` menjadi `null`. Untuk data sederhana (angka, teks, array, objek) ia memadai.

Spread pada objek (`{ ...a, b: 1 }`, ES2018) **tidak tercantum** di spesifikasi yang didokumentasikan; uji di 2.1.9 sebelum mengandalkannya, dan pakai `Object.assign({}, a, { b: 1 })` sebagai cadangan.

### e. Parameter destructuring

```qml
function tampil({ nama, harga = 0 } = {}) {
    return `${nama}: ${harga}`;
}
```

```qml
Component.onCompleted: console.log(tampil({ nama: 'Kopi', harga: 15_000 }), tampil({ nama: 'Teh' }))
```

| Bagian | Arti |
| --- | --- |
| `{ nama, harga = 0 } = {}` | Parameter berupa objek yang langsung diurai; `= {}` mencegah galat bila tak ada argumen. |
| `tampil({ nama: 'Teh' })` | `harga` memakai bawaan: `Teh: 0`. |

Pola ini membuat fungsi menerima **parameter bernama** (urutan tak penting) dan mudah ditambah opsi baru tanpa merusak pemanggil lama; gunakan untuk fungsi dengan banyak parameter.

### f. Map dan Set

`Map` dan `Set` tercantum resmi di Qt:

```qml
import QtQuick

Item {
    Component.onCompleted: {
        const m = new Map([['a', 1]]);
        m.set('b', 2);
        console.log(m.size, m.get('b'), m.has('c'));

        const s = new Set([1, 2, 2, 3]);
        console.log(s.size, s.has(2));
    }
}
```

| Bagian | Arti |
| --- | --- |
| `new Map([['a', 1]])` | Peta kunci-nilai; kunci boleh apa saja (bukan hanya teks). |
| `m.size`, `m.get('b')`, `m.has('c')` | Dugaan `2 2 false`. |
| `new Set([1, 2, 2, 3])` | Himpunan tanpa duplikat. |
| `s.size`, `s.has(2)` | Dugaan `3 true`. |

### g. Objek JavaScript dan objek QML

| Aspek | Objek JavaScript `{}` | Objek QML (`QtObject`, `Item`) |
| --- | --- | --- |
| Properti | Dinamis, dapat ditambah kapan saja | Tetap, dideklarasikan |
| Pemberitahuan perubahan | Tidak ada | Ada (`onXChanged`) |
| Tipe | Tanpa jaminan | Terketik |
| Dipakai untuk | Data mentah, argumen, hasil JSON | Antarmuka, logika berkelanjutan |

Bila data punya bentuk tetap dan perlu diamati, jadikan **tipe QML** (1.3), bukan objek `var`.

### h. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Kunci dinamis | `Map` | Kunci bukan hanya teks |
| Himpunan unik | `Set` | Cek keanggotaan cepat |
| Menyalin objek | `Object.assign`, trik JSON | Spread objek **\[uji dulu\]** |
| Mengunci objek | `Object.freeze` | Dangkal |
| Data berbentuk tetap | Tipe QML atau kelas C++ | Fase 1.3 dan 10 |

### i. Visual

```
  const { nama: n, harga: h = 0 } = { nama: 'Kopi' }       n = 'Kopi',  h = 0 (bawaan)
  const [a, , c = 'x', ...sisa] = [1, 2, undefined, 4, 5]  a = 1,  c = 'x',  sisa = [4, 5]

  salinan DANGKAL:  dua objek ---> SATU objek bersarang bersama
  salinan DALAM  :  JSON.parse(JSON.stringify(x))  ---> objek bersarang baru
```

### j. Terminologi

| Istilah | Arti |
| --- | --- |
| Literal objek | Penulisan objek langsung `{ ... }` |
| Destructuring | Mengurai objek atau array ke variabel |
| Salinan dangkal / dalam | Menyalin satu tingkat / seluruh tingkat |
| `Map` / `Set` | Peta kunci-nilai / himpunan tanpa duplikat |
| Parameter bernama | Fungsi menerima satu objek yang diurai |
| Kunci dihitung | `[ekspresi]: nilai` |

### k. Tips dan praktik terbaik

- Gunakan parameter destructuring untuk fungsi dengan tiga parameter atau lebih.
- Salin sebelum mengubah objek yang bukan milik Anda.
- Pakai `Map` bila kuncinya tak terduga atau bukan teks.
- Jangan terlalu dalam menyarangkan destructuring; satu atau dua tingkat sudah cukup.

### l. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Mengubah salinan ikut mengubah asli | Salinan dangkal | Salinan dalam atau struktur datar |
| `TypeError` saat mengurai `undefined` | Tak ada nilai bawaan `= {}` | `({ a } = {})` |
| Objek `var` diubah tapi UI diam | Mutasi tak diamati | Tugaskan ulang (1.2.4) |
| `Date` hilang setelah salinan JSON | JSON mengubah `Date` jadi teks | Konversi manual, atau jangan lewat JSON |
| Kunci `undefined` tak tampil di JSON | JSON membuang `undefined` | Pakai `null` bila perlu dipertahankan |
| Spread objek galat | Fitur ES2018 | Uji; pakai `Object.assign` |

### m. Hubungan dengan modul lain

Prasyarat untuk 2.1.7 (`?.` pada objek bersarang), 2.1.8 (`JSON.parse` dan galat), Modul 2.2 (data di binding), dan Fase 7 (baris model dan JSON dari jaringan).

### n. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Objek.qml` dan contoh salinan; cocokkan dugaan. Lalu: (1) tulis fungsi `ubahHarga(item, harga)` yang mengembalikan salinan tanpa mengubah aslinya; (2) tulis fungsi dengan parameter destructuring dan tiga opsi bernilai bawaan; (3) ganti `Object.assign` dengan spread objek di berkas terpisah dan catat hasilnya **\[uji dulu\]**.

**Cek pemahaman.** (1) Apa bedanya salinan dangkal dan dalam? (2) Mengapa parameter destructuring memerlukan `= {}`? (3) Kapan data sebaiknya menjadi tipe QML, bukan objek JavaScript?

### o. Referensi

- [MDN: Destructuring assignment](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment) · [Working with objects](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Working_with_objects) · [Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map) · [Set](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set)
- [List of JavaScript Objects and Functions](https://doc.qt.io/qt-6/qtqml-javascript-functionlist.html)

---

## 2.1.6 String dan template literal

*Semangat: teks yang dirangkai dengan cermat adalah antarmuka yang paling sering dibaca pengguna.*

**Daftar isi 2.1.6:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh: teks sehari-hari · d. Tambahan khas Qt: `arg` dan locale · e. Membangun teks dengan aman · f. Opsi lain · g. Visual · h. Terminologi · i. Tips · j. Kesalahan umum · k. Hubungan · l. Latihan dan cek · m. Referensi

### a. Deskripsi dan peran

Hampir setiap antarmuka menampilkan teks yang dirakit dari data: nama, jumlah, harga, tanggal. Bagian ini mengajarkan cara merakitnya dengan rapi, memakai metode string yang paling berguna, dan menghindari jebakan yang membuat teks salah, tidak aman, atau sulit diterjemahkan.

### b. Konsep dan filosofi

- String JavaScript adalah barisan karakter **UTF-16**: satu karakter di luar BMP (mis. emoji) memakai dua unit (`'😀'.length` adalah `2`).
- **Template literal** memakai tanda kutip balik: `` `...${ekspresi}...` ``. Ia dapat memuat ekspresi apa pun dan membentang beberapa baris.
- String **tak dapat diubah** (*immutable*): setiap metode menghasilkan string baru.
- Metode yang tercantum di daftar fungsi resmi Qt antara lain `includes`, `startsWith`, `endsWith`, `repeat`, `padStart`, `padEnd`. Metode ES5 klasik (`trim`, `split`, `slice`, `substring`, `indexOf`, `replace`, `toUpperCase`, `toLowerCase`, `charAt`, `localeCompare`) tersedia luas.

**Filosofi:** pisahkan **isi** (data) dari **bentuk** (pola teks). Pola teks yang dapat diterjemahkan memakai `qsTr` dan `arg` (Fase 9), bukan sambungan manual yang urutannya terkunci pada satu bahasa.

### c. Contoh: teks sehari-hari

Simpan sebagai `Teks.qml`:

```qml
import QtQuick

Item {
    Component.onCompleted: {
        const nama = 'Kopi';
        const harga = 15_000;
        const jumlah = 3;

        console.log(`${nama} x${jumlah} = ${harga * jumlah}`);
        console.log(`Baris 1
Baris 2`);
        console.log('x'.repeat(3), '7'.padStart(3, '0'), 'ab'.padEnd(5, '.') + '|');
        console.log('  halo  '.trim() + '|', 'Halo Dunia'.toUpperCase(), 'Halo'.length);
        console.log('a,b,c'.split(',').join(' - '), 'Halo Dunia'.slice(5), 'Halo Dunia'.substring(0, 4));
        console.log('Halo Dunia'.includes('Dun'), 'Halo'.startsWith('Ha'), 'Halo'.endsWith('lo'), 'Halo'.indexOf('l'));
        console.log('a-b-c'.replace('-', '+'), 'a-b-c'.replace(/-/g, '+'));
        console.log('Ünï'.length, '😀'.length, [...'😀'].length);
    }
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `` `${nama} x${jumlah} = ${harga * jumlah}` `` | Template literal dengan tiga sisipan; dugaan `Kopi x3 = 45000`. |
| `` `Baris 1 ... Baris 2` `` | Template literal **multibaris**: pindah baris menjadi bagian teks; keluaran dua baris. |
| `'x'.repeat(3)`, `'7'.padStart(3, '0')`, `'ab'.padEnd(5, '.')` | `xxx`, `007`, `ab...`; \` |
| `'  halo  '.trim()`, `.toUpperCase()`, `.length` | `halo`, `HALO DUNIA`, `4`. |
| `'a,b,c'.split(',').join(' - ')` | Pecah menjadi array lalu gabung ulang: `a - b - c`. |
| `.slice(5)`, `.substring(0, 4)` | `Dunia` dan `Halo`. |
| `.includes('Dun')`, `.startsWith`, `.endsWith`, `.indexOf('l')` | `true true true 2`. |
| `'a-b-c'.replace('-', '+')` | `replace` dengan **string** hanya mengganti **kemunculan pertama**: `a+b-c`. |
| `.replace(/-/g, '+')` | Dengan regex ber-bendera `g`, semua diganti: `a+b+c`. |
| `'Ünï'.length`, `'😀'.length`, `[...'😀'].length` | Dugaan `3`, `2`, dan `1` (spread string per titik kode; **\[uji dulu\]**). |

`replaceAll` (ES2021) tidak tercantum di daftar resmi; pakai regex ber-`g` sampai Anda membuktikannya di 2.1.9.

### d. Tambahan khas Qt: arg dan locale

Qt menambah metode dan perilaku yang peka locale pada tipe JavaScript (dokumentasi *Host Environment* dan daftar fungsi):

- `String.prototype.arg(...)` mengganti penanda `%1`, `%2`, dan seterusnya, seperti `QString::arg` di C++.
- `Number.prototype.toLocaleString(locale, format, precision)` dan `toLocaleCurrencyString(locale, symbol)` memformat angka menurut locale; `Qt.locale()` menyediakan objek locale.
- `Date.prototype.toLocaleString(locale, format)` memformat tanggal menurut locale (1.2.3).

```qml
import QtQuick

Item {
    Component.onCompleted: {
        console.log('%1 + %2 = %3'.arg(2).arg(3).arg(5));
        console.log(qsTr('Total: %1 dari %2').arg(3).arg(10));

        const id = Qt.locale('id_ID');
        console.log((1234567.891).toLocaleString(id), (1234.5).toLocaleCurrencyString(id));
        console.log((1234567.891).toLocaleString(Qt.locale('en_US'), 'f', 2));
    }
}
```

| Bagian | Arti |
| --- | --- |
| `'%1 + %2 = %3'.arg(2).arg(3).arg(5)` | Tiap `arg` mengisi penanda berikutnya: `2 + 3 = 5`. |
| `qsTr('Total: %1 dari %2').arg(3).arg(10)` | Pola yang dapat diterjemahkan; urutan penanda dapat berbeda per bahasa (Fase 9). |
| `Qt.locale('id_ID')` | Objek locale Indonesia. |
| `(1234567.891).toLocaleString(id)` | Angka menurut locale; bentuk pemisah desimal dan ribuan bergantung data locale di sistem Anda **\[amati\]**. |
| `toLocaleCurrencyString(id)` | Angka sebagai mata uang menurut locale **\[amati\]**. |
| `toLocaleString(Qt.locale('en_US'), 'f', 2)` | Format tetap dengan dua angka desimal **\[amati\]**. |

Hasil persis bergantung pada data locale di mesin Anda; catat di `galat.md`.

### e. Membangun teks dengan aman

- **Template literal tidak meloloskan (escape) apa pun.** Menyisipkan masukan pengguna ke dalam URL, HTML, atau perintah dapat menimbulkan *injection* (Modul 13.1).
- Untuk komponen URL, gunakan `encodeURIComponent`:

```qml
import QtQuick

Item {
    Component.onCompleted: {
        const q = 'kopi & teh';
        console.log(`https://contoh.example/cari?q=${encodeURIComponent(q)}`);
    }
}
```

| Bagian | Arti |
| --- | --- |
| `encodeURIComponent(q)` | Meloloskan karakter khusus agar aman di dalam URL. Dugaan: `kopi%20%26%20teh`. |
| `https://contoh.example/...` | Domain contoh yang dicadangkan untuk dokumentasi. |

- Untuk menampilkan masukan pengguna di `Text`, jangan memakai format `RichText` pada data yang tidak tepercaya (Fase 4 dan 13): tag HTML di dalamnya akan ditafsirkan.
- Jangan menyusun teks bahasa pengguna lewat sambungan (`'Total: ' + n + ' item'`); pakai `qsTr` dan `arg`.

### f. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Teks dapat diterjemahkan | `qsTr('... %1').arg(x)` | Fase 9 |
| Format angka, tanggal | `toLocaleString`, `Qt.formatDate` | Peka locale |
| Menyusun banyak potongan | `array.join('')` | Hindari `+=` berulang pada teks sangat besar |
| Mencari pola | Ekspresi reguler `/.../` | Pakai bendera `g` untuk semua kemunculan |
| Teks bergaya | Properti `textFormat`, `StyledText` | Fase 4; waspadai data tak tepercaya |
| Urut teks sesuai bahasa | `a.localeCompare(b)` | Bukan `<` |

### g. Visual

```
  `Kopi x${jumlah} = ${harga * jumlah}`   -->   'Kopi x3 = 45000'
   ^ kutip balik   ^ sisipan ekspresi

  qsTr('Total: %1 dari %2').arg(3).arg(10)   -->  'Total: 3 dari 10'   (pola dapat diterjemahkan)
  'a-b-c'.replace('-', '+')   --> 'a+b-c'      .replace(/-/g, '+') --> 'a+b+c'
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| Template literal | String berkutip balik dengan sisipan `${...}` |
| UTF-16 | Pengodean karakter yang dipakai string JavaScript |
| Immutable | Tidak dapat diubah di tempat |
| `arg` | Metode Qt untuk mengisi penanda `%n` |
| Locale | Aturan bahasa dan wilayah (format angka, tanggal) |
| Injection | Masukan pengguna yang ditafsirkan sebagai kode atau markup |
| Ekspresi reguler | Pola pencarian teks |

### i. Tips dan praktik terbaik

- Pakai template literal untuk teks teknis (log, kunci); pakai `qsTr` dan `arg` untuk teks yang dibaca pengguna.
- Selalu `encodeURIComponent` untuk data di dalam URL.
- Jangan mengasumsikan satu karakter sama dengan satu unit string (emoji, aksen).
- Perlakukan teks dari luar sebagai tak tepercaya sampai divalidasi.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Hanya penanda pertama yang diganti | `replace` dengan string | Regex ber-`g` |
| `replaceAll` galat | Tidak tercantum resmi | Regex ber-`g`; uji di 2.1.9 |
| `'5' + 3` menjadi `'53'` | Sambungan teks | `Number(...)` |
| Panjang emoji tak sesuai | UTF-16 | Pakai iterasi titik kode **\[uji dulu\]** |
| Teks tak dapat diterjemahkan | Sambungan manual | `qsTr` dan `arg` |
| Masukan pengguna merusak tampilan | `RichText` pada data tak tepercaya | `PlainText` atau validasi |

### k. Hubungan dengan modul lain

Prasyarat untuk Fase 4 (`Text`), Fase 9 (internasionalisasi: `qsTr`, locale), Modul 13.1 (injection dan validasi), dan Fase 7 (membangun URL dan teks dari data).

### l. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Teks.qml` dan contoh `arg`, locale, dan URL; cocokkan dugaan dan catat keluaran locale di `galat.md`. Lalu: (1) tulis fungsi `rupiah(n)` yang memformat angka dengan pemisah ribuan dua cara (manual dan `toLocaleString`) dan bandingkan; (2) tulis `bersihkan(s)` yang memangkas dan menggabung spasi berlebih dengan regex; (3) coba `'a-b-c'.replaceAll('-', '+')` dan catat hasilnya **\[uji dulu\]**.

**Cek pemahaman.** (1) Mengapa `replace` dengan string hanya mengganti satu kali? (2) Apa fungsi `arg`, dan mengapa lebih baik daripada sambungan untuk teks yang diterjemahkan? (3) Mengapa template literal tidak aman untuk menyusun URL dari masukan pengguna?

### m. Referensi

- [MDN: Template literals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals) · [String](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String) · [encodeURIComponent](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURIComponent)
- [JavaScript Host Environment: String dan Number](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html) · [List of JavaScript Objects and Functions](https://doc.qt.io/qt-6/qtqml-javascript-functionlist.html) · [Qt.locale](https://doc.qt.io/qt-6/qml-qtqml-qt.html)

---

## 2.1.7 ?? dan ?.

*Semangat: kode yang tahu kapan sebuah nilai benar-benar kosong adalah kode yang tahan banting.*

**Daftar isi 2.1.7:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh: nilai kosong · d. `??` melawan `||` · e. Aturan dan jebakan · f. Pola di QML · g. Opsi lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Data sering tidak lengkap: objek yang belum dimuat, bidang opsional di JSON, `Loader` yang belum membuat item. Dua operator ini menangani **nilai kosong** secara ringkas dan benar.

### b. Konsep dan filosofi

- **Nullish coalescing `a ?? b`:** hasilnya `b` **hanya bila `a` adalah `null` atau `undefined`**. Tersedia di QML sejak Qt 5.15.
- **Optional chaining `a?.b`:** bila `a` adalah `null` atau `undefined`, ekspresi **berhenti** dan menghasilkan `undefined`, tanpa galat. Tersedia sejak Qt 6.2. Bentuknya: `a?.b`, `a?.[i]`, dan `a?.()`.
- `||` menggantikan semua nilai **falsy** (`0`, `''`, `false`, `NaN`, `null`, `undefined`), sehingga salah menangani `0` dan teks kosong yang sah.

**Filosofi:** bedakan **“tidak ada”** dari **“ada tetapi kosong atau nol”**. `0` adalah nilai yang sah; `??` menghormatinya.

### c. Contoh: nilai kosong

Simpan sebagai `Nullish.qml`:

```qml
import QtQuick

Item {
    id: root
    property var data: ({ pengguna: { nama: 'Ani', alamat: null, hobi: [] } })

    Rectangle { id: kotak; color: 'steelblue'; width: 10; height: 10 }

    Component.onCompleted: {
        const d = root.data;
        console.log(d.pengguna.nama, d.pengguna?.nama, d.admin?.nama);
        console.log(d.pengguna.alamat ?? 'tanpa alamat', d.pengguna.alamat || 'tanpa alamat');
        console.log(0 || 'cadangan', 0 ?? 'cadangan', '' || 'cadangan', '[' + ('' ?? 'cadangan') + ']');
        console.log(d.pengguna.hobi?.[0] ?? 'tanpa hobi', d.admin?.hobi?.[0] ?? 'tanpa hobi');
        console.log(typeof d.tidakAda?.(), d.pengguna.nama?.toUpperCase());
        console.log((kotak.parent as Rectangle)?.color ?? 'bukan Rectangle');
    }
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `d.pengguna?.nama`, `d.admin?.nama` | `Ani` dan `undefined`: `d.admin` tidak ada, jadi rantai berhenti tanpa galat (tanpa `?.`, `d.admin.nama` melempar `TypeError`). |
| `d.pengguna.alamat ?? 'tanpa alamat'` | `alamat` adalah `null` sehingga memakai cadangan. |
| \`0 |  |
| \`'' |  |
| `d.pengguna.hobi?.[0] ?? 'tanpa hobi'` | Elemen pertama tak ada (`undefined`), jadi cadangan. |
| `d.admin?.hobi?.[0] ?? ...` | Dua rantai opsional berurutan. |
| `typeof d.tidakAda?.()` | Panggilan opsional: bila fungsinya tak ada, hasil `undefined` tanpa galat (**\[uji dulu\]** `?.()` di versi Anda). |
| `d.pengguna.nama?.toUpperCase()` | `ANI`. |
| `(kotak.parent as Rectangle)?.color ?? 'bukan Rectangle'` | `as` memeriksa tipe (1.2.8): `parent` adalah `Item`, bukan `Rectangle`, jadi hasilnya `null`, rantai berhenti, dan cadangan dipakai. Pola ini ada di dokumentasi *Host Environment*. |

### d. ?? melawan ||

| Ekspresi | Hasil dengan operator OR (dua batang tegak) | Hasil dengan operator nullish (dua tanda tanya) |
| --- | --- | --- |
| `0` lalu `10` | `10` | `0` |
| `''` lalu `'x'` | `'x'` | `''` |
| `false` lalu `true` | `true` | `false` |
| `NaN` lalu `5` | `5` | `NaN` |
| `null` lalu `5` | `5` | `5` |
| `undefined` lalu `5` | `5` | `5` |

Pilih `??` bila nilai `0`, `''`, atau `false` adalah **data yang sah** (jumlah, teks kosong, bendera); pilih `||` hanya bila memang ingin menggantikan semua nilai falsy.

### e. Aturan dan jebakan

- Mencampur `??` dengan `||` atau `&&` **tanpa kurung** adalah galat sintaks; tulis kurung: `(a || b) ?? c`.
- `a?.b` menangani `null` dan `undefined` **di sebelah kiri**; bila `a` ada tetapi `a.b` tidak, hasilnya `undefined` (properti tak ada), bukan galat.
- `?.` tidak menangkap **semua** galat: `a?.b.c` tetap melempar bila `a` ada, `a.b` `undefined`, dan Anda mengakses `.c`. Rantai opsional di setiap titik yang mungkin kosong: `a?.b?.c`.
- Operator penugasan logis `??=`, `||=`, `&&=` (ES2021) tidak tercantum di spesifikasi yang didokumentasikan; uji di 2.1.9.
- Jangan menutupi bug: `?.` yang berlebihan membuat data yang seharusnya selalu ada “tampak baik” padahal rusak.

### f. Pola di QML

```qml
// item yang dimuat Loader belum tentu ada
text: loader.item?.judul ?? 'memuat...'

// objek yang mungkin null
width: target?.width ?? 0

// bidang JSON opsional
const kota = respons.alamat?.kota ?? 'tidak diketahui'

// baris model yang mungkin tidak ada
const nama = model.get(i)?.nama ?? ''
```

| Pola | Arti |
| --- | --- |
| `loader.item?.judul ?? 'memuat...'` | `Loader.item` bernilai `null` sampai komponen selesai dimuat. |
| `target?.width ?? 0` | Properti objek yang boleh `null`. |
| `respons.alamat?.kota ?? ...` | JSON dengan bidang opsional (Fase 7). |
| `model.get(i)?.nama ?? ''` | `get` mengembalikan `undefined` bila indeks di luar rentang. |

### g. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Cadangan hanya untuk `null`/`undefined` | `??` | Disarankan |
| Cadangan untuk semua falsy | \` |  |
| Pemeriksaan eksplisit | `x !== undefined && x !== null` | Lebih panjang, paling jelas |
| Nilai bawaan parameter | `function f(a = 1)` | Hanya untuk `undefined` |
| Nilai bawaan destructuring | `const { a = 1 } = obj` | Hanya untuk `undefined` |
| Validasi data masuk | Fungsi pemeriksa di perbatasan | 1.2.6 |

### h. Visual

```
  a ?? b        a bukan null/undefined ?  --> a      selain itu --> b
  a || b        a truthy ?               --> a      selain itu --> b     (0, '', false, NaN ikut diganti)
  a?.b          a null/undefined ?       --> undefined (berhenti)      selain itu --> a.b

  versi Qt:   ??  >= 5.15       ?.  >= 6.2       pemisah numerik  >= 6.8
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Nullish | Bernilai `null` atau `undefined` |
| Nullish coalescing (`??`) | Nilai cadangan hanya untuk nullish |
| Optional chaining (`?.`) | Akses aman yang berhenti pada nullish |
| Falsy | `0`, `''`, `false`, `NaN`, `null`, `undefined` |
| Short-circuit | Berhenti mengevaluasi sisa ekspresi |
| Type assertion (`as`) | Menyatakan tipe objek QML (1.2.8) |

### j. Tips dan praktik terbaik

- Pilih `??` sebagai bawaan untuk nilai cadangan; `||` hanya dengan alasan.
- Pasang `?.` hanya di titik yang **memang** boleh kosong.
- Beri komentar mengapa sebuah bagian boleh kosong.
- Kombinasikan `as` dan `?.` untuk memeriksa tipe objek QML dengan ringkas.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Nilai `0` hilang | Memakai \` |  |
| Galat sintaks saat mencampur | `??` dengan \` |  |
| `TypeError` meski ada `?.` | Rantai tak opsional di tengah | `a?.b?.c` |
| Bug tersembunyi | `?.` berlebihan | Biarkan data wajib melempar galat |
| `?.` galat sintaks | Qt di bawah 6.2 | Perbarui, atau pemeriksaan manual |
| `??=` galat | Fitur ES2021 | Uji; tulis `x = x ?? nilai` |

### l. Hubungan dengan modul lain

Prasyarat untuk Modul 2.2 (binding dengan data opsional), 2.1.8 (galat yang tidak boleh ditutupi), Fase 5 (`Loader`), dan Fase 7 (model dan JSON).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Nullish.qml` dan cocokkan dugaan. Lalu: (1) tulis fungsi `ambilKota(respons)` yang aman terhadap tiga tingkat objek opsional; (2) tulis `jumlahAtauNol(x)` dengan `??` dan versi `||`, lalu uji dengan `0`, `''`, `null`, dan `5`; (3) coba `0 || 1 ?? 2` dan catat galatnya, lalu perbaiki dengan kurung **\[amati\]**.

**Cek pemahaman.** (1) Apa beda `a ?? b` dan `a || b`? (2) Mengapa `a?.b.c` masih dapat melempar galat? (3) Sejak Qt berapa `??` dan `?.` tersedia?

### n. Referensi

- [MDN: Nullish coalescing](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Nullish_coalescing) · [Optional chaining](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Optional_chaining)
- [JavaScript Host Environment](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html) · [Loader](https://doc.qt.io/qt-6/qml-qtquick-loader.html)

---

## 2.1.8 try/catch

*Semangat: yang bersiap pada galat tidak lagi dikagetkan olehnya.*

**Daftar isi 2.1.8:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh: menangkap dan melempar · d. Apa yang terjadi bila tak ditangkap di QML · e. Strategi penanganan · f. Galat dalam kode asinkron · g. Opsi lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Galat adalah bagian normal program: masukan rusak, jaringan putus, objek kosong. Bagian ini mengajarkan cara melempar dan menangkap galat JavaScript, dan kapan **tidak** menangkapnya.

### b. Konsep dan filosofi

- `throw` melempar sebuah nilai (sebaiknya objek `Error`); `try { ... } catch (e) { ... }` menangkapnya; `finally { ... }` **selalu** dijalankan, bahkan setelah `return`.
- Jenis bawaan: `Error`, `TypeError` (operasi pada jenis yang salah), `ReferenceError` (nama tak dikenal), `RangeError` (nilai di luar rentang), `SyntaxError` (mis. `JSON.parse` pada teks tak valid).
- Objek galat punya `name` dan `message`, dan sering `stack`.
- Menangkap berarti **mengambil tanggung jawab**: tangkap hanya bila Anda dapat berbuat sesuatu yang berguna.

**Filosofi:** **validasi** untuk hal yang dapat diprediksi (masukan pengguna), **pengecualian** untuk hal yang tak seharusnya terjadi. Jangan menelan galat dalam diam.

### c. Contoh: menangkap dan melempar

Simpan sebagai `Galat.qml`:

```qml
import QtQuick

Item {
    function ambilJson(teks) {
        try {
            return { ok: true, data: JSON.parse(teks) };
        } catch (e) {
            return { ok: false, galat: `${e.name}: ${e.message}` };
        } finally {
            console.log('selesai memproses');
        }
    }

    function bagi(a, b) {
        if (b === 0)
            throw new RangeError('pembagi nol');
        return a / b;
    }

    Component.onCompleted: {
        console.log(JSON.stringify(ambilJson('{"a": 1}')));
        console.log(ambilJson('{rusak').ok);

        try {
            bagi(1, 0);
        } catch (e) {
            console.log(e instanceof RangeError, e.name, e.message);
        }

        try {
            null.x;
        } catch (e) {
            console.log(e.name);
        }

        try {
            tidakAda;
        } catch (e) {
            console.log(e.name);
        }
    }
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `try { return { ok: true, data: JSON.parse(teks) }; }` | Mencoba mengurai JSON; bila berhasil, mengembalikan objek hasil. |
| `catch (e) { return { ok: false, galat: ... } }` | Bila gagal, mengembalikan objek yang menyatakan kegagalan **tanpa melempar lagi**: pola *objek hasil*. |
| `finally { console.log('selesai memproses'); }` | Dijalankan **selalu**, sebelum nilai kembali diteruskan; baris ini tercetak lebih dulu dari hasil. |
| `throw new RangeError('pembagi nol')` | Melempar galat dengan jenis dan pesan. |
| `catch (e) { console.log(e instanceof RangeError, e.name, e.message) }` | Dugaan `true RangeError pembagi nol`. |
| `null.x` | Dugaan `TypeError`. |
| `tidakAda` | Dugaan `ReferenceError`. |

Urutan keluaran yang diduga: `selesai memproses`, `{"ok":true,"data":{"a":1}}`, `selesai memproses`, `false`, `true RangeError pembagi nol`, `TypeError`, `ReferenceError`. Pesan persis `JSON.parse` berbeda antar mesin; catat milik Anda **\[amati\]**.

### d. Apa yang terjadi bila tak ditangkap di QML

Pada aplikasi QML, galat yang **tidak ditangkap** di dalam handler atau binding umumnya **tidak menghentikan aplikasi**: engine mencetak peringatan bersama berkas dan baris ke terminal, lalu melanjutkan; nilai binding yang gagal biasanya tidak diperbarui. Ini baik untuk ketahanan, tetapi membuat galat mudah terlewat. Buktikan sendiri:

```qml
import QtQuick

Item {
    Component.onCompleted: {
        console.log('sebelum');
        null.x;
        console.log('sesudah');
    }
}
```

```bash
$ qml TakDitangkap.qml
```

Simpan sebagai `TakDitangkap.qml` dan catat: apakah baris `sesudah` tercetak? bagaimana bentuk pesan peringatan? apakah ada exit code berbeda? **\[amati\]**. Dari sini lahir kebiasaan: **jangan membiarkan peringatan di terminal**; perlakukan sebagai galat (`QT_FATAL_WARNINGS=1`, 0.3.4).

### e. Strategi penanganan

| Situasi | Strategi |
| --- | --- |
| Masukan pengguna bisa salah | **Validasi** dulu; jangan memakai pengecualian untuk alur normal |
| Data dari luar (JSON, jaringan) | `try/catch` di **perbatasan**, ubah menjadi objek hasil |
| Galat yang tak dapat Anda tangani | Biarkan naik; jangan telan |
| Anda menangkap lalu perlu naik lagi | `throw e` setelah mencatat |
| Pesan untuk pengguna | Ringkas dan tanpa rincian internal; rincian ke log (Modul 13.1) |
| Pembersihan wajib | `finally` |

```qml
try {
    proses();
} catch (e) {
    console.error('proses gagal:', e.message);
    throw e;
}
```

| Bagian | Arti |
| --- | --- |
| `console.error(...)` | Mencatat sebagai galat di terminal. |
| `throw e` | Melempar ulang galat yang sama agar tidak tertelan. |

### f. Galat dalam kode asinkron

`try/catch` hanya menangkap galat **yang terjadi selama blok itu berjalan**. Galat di callback yang dijalankan **nanti** (hasil `XMLHttpRequest`, `Timer`, `Promise`) tidak tertangkap oleh `try` di sekelilingnya; tangani di dalam callback itu sendiri atau lewat mekanisme galatnya (mis. `onerror`, Fase 7). `async` dan `await` tidak tercantum di spesifikasi yang didokumentasikan (2.1.9).

### g. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Memeriksa asumsi saat pengembangan | `console.assert(kondisi, pesan)` | Mencetak bila salah; tidak menghentikan |
| Menjadikan peringatan fatal | `QT_FATAL_WARNINGS=1` | Berguna di uji (0.3.4) |
| Mengembalikan kegagalan sebagai nilai | Objek hasil `{ ok, galat }` | Menghindari pengecualian lintas lapisan |
| Menangkap tanpa variabel | `catch { ... }` | ES2019; **\[uji dulu\]** |
| Menunda penanganan | Signal bernama `galat(pesan)` | Fase 3 |

### h. Visual

```
  try { ... }  --lempar-->  catch (e) { ... }  --> lanjut
     |                                 |
     '------ selalu ------> finally { ... }

  tak ditangkap di QML  -->  peringatan (berkas:baris) di terminal;  aplikasi umumnya JALAN terus
  galat di callback nanti -->  TIDAK tertangkap try di sekelilingnya
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Pengecualian (exception) | Galat yang dilempar |
| Melempar / menangkap | `throw` / `catch` |
| `finally` | Blok yang selalu berjalan |
| Objek hasil | Nilai yang menyatakan sukses atau gagal tanpa melempar |
| Perbatasan | Tempat data dari luar masuk |
| Stack trace | Daftar pemanggilan saat galat |

### j. Tips dan praktik terbaik

- Lempar objek `Error` (bukan teks atau angka) agar punya `name`, `message`, dan `stack`.
- Tangkap di perbatasan, bukan di mana-mana.
- Selalu catat atau lempar ulang; jangan `catch (e) { }` kosong.
- Jangan menampilkan `e.message` mentah kepada pengguna akhir.
- Perlakukan peringatan di terminal sebagai galat yang belum ditangani.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Galat hilang tanpa jejak | `catch` kosong | Catat atau lempar ulang |
| `try` tidak menangkap galat callback | Galat terjadi nanti | Tangani dalam callback |
| Aplikasi “jalan” tetapi salah | Galat tak ditangkap hanya jadi peringatan | Baca terminal; `QT_FATAL_WARNINGS=1` |
| Pesan teknis tampil ke pengguna | `e.message` mentah | Pesan ringkas; rincian ke log |
| Memakai pengecualian untuk alur biasa | Validasi dilewati | Validasi dulu |
| `JSON.parse` melempar tak terduga | Masukan tak tepercaya | `try/catch` di perbatasan |

### l. Hubungan dengan modul lain

Prasyarat untuk Modul 2.2 (galat di binding dan handler), Modul 2.4 (`console.*`), Fase 7 (galat jaringan dan JSON), Fase 12 (pengujian), dan Modul 13.1 (pesan galat aman).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Galat.qml` dan `TakDitangkap.qml`; cocokkan dugaan dan catat pesan di `galat.md`. Lalu: (1) tulis `parseAman(teks, bawaan)` yang mengembalikan `bawaan` bila JSON tak valid dan mencatat galatnya; (2) tulis `muatKonfigurasi` yang melempar `Error` bila bidang wajib hilang, dan penangkapnya yang memberi pesan ramah; (3) jalankan `TakDitangkap.qml` dengan `QT_FATAL_WARNINGS=1` dan catat bedanya **\[amati\]**.

**Cek pemahaman.** (1) Kapan `finally` berjalan? (2) Mengapa `try` tidak menangkap galat di callback `XMLHttpRequest`? (3) Mengapa `catch (e) { }` kosong berbahaya?

### n. Referensi

- [MDN: try...catch](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/try...catch) · [Error](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error) · [throw](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/throw)
- [JavaScript Expressions in QML](https://doc.qt.io/qt-6/qtqml-javascript-expressions.html) · [Debugging QML Applications](https://doc.qt.io/qt-6/qtquick-debugging.html)
