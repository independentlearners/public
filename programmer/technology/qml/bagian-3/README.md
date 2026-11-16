[materi_perbandingan](./materi_perbandingan.md)

# Fase 2 · Modul 2.1 — Dasar JavaScript yang Dipakai QML

---

## A. Audit singkat

**Sudah terverifikasi:**
- Mesin QML mengimplementasikan ECMAScript edisi ke-7; `??` tersedia sejak Qt 5.15, `?.` sejak Qt 6.2, dan pemisah numerik `1_000_000` sejak Qt 6.8.
- Daftar resmi mencantumkan `Map`, `WeakMap`, `Set`, `WeakSet`, `Symbol`, dan `Promise`, dan tidak memuat `BigInt`.
- Pengembang KDE merujuk QTBUG-58620 untuk menyatakan bahwa QJSEngine tidak mendukung async/await. Sebuah diskusi forum juga menyebut `await` tidak berfungsi di QML. Keduanya laporan era Qt 5.15, jadi untuk 6.12 statusnya tetap `[uji dulu]`. Rujukan "milis Qt 6.4.1" di kurikulum tidak ditemukan. Yang ditemukan adalah diskusi 2017.

**Perlu dilengkapi:**
- **Object spread `{...obj}`.** Laporan Qt 5.12 menyebut spread berfungsi untuk array tetapi tidak untuk objek. Laporan Qt 5.15 menyebut galat "Invalid token ..." saat memakainya di objek. Ada juga permintaan fitur QTBUG-107206. Status di 6.12 belum terkonfirmasi.
- **Tambahan daftar `[uji dulu]`.** Fungsi berikut tidak tercantum di daftar resmi: `Array.prototype.flat/flatMap/at/findLast`, `Object.fromEntries`, `String.prototype.replaceAll/trimStart/trimEnd/matchAll`. Sintaks `??=` dan `catch {}` tanpa parameter juga masuk daftar ini. Tidak tercantum bukan berarti pasti tidak ada, karena daftar itu memuat beberapa fungsi pasca-ES2016 seperti `Object.entries` dan `padStart`. Maka "ES7 + tambahan" adalah gambaran yang tepat.
- **Catatan untuk Modul 2.3.** Tabel pragma menulis `FunctionSignatureBehavior` sebagai `[≥6.5]`. Halaman Host Environment 6.12 hanya menyebut penegakan tipe sejak 6.7. Ini perlu diverifikasi saat kita sampai di sana, belum tentu salah.

**Celah kurikulum → ditambahkan sebagai TAMBAHAN:**

| Celah | Penanganan |
|---|---|
| Tidak ada cara menjalankan dan menguji kode | **2.1.0** Laboratorium |
| Tidak ada operator dan kesetaraan | **2.1.10** |
| Tidak ada `if`/`switch`/perulangan, padahal fondasi | **2.1.11** |
| `var`, hoisting, larangan variabel global implisit khas QML, dan ASI | diperluas di 2.1.1 |
| Jembatan tipe properti QML dan tipe JS | diperluas di 2.1.2 |
| `forEach/some/every/includes/sort/slice/splice` | diperluas di 2.1.4 |
| Ekstensi Qt `String.arg()` dan `Number.toLocale*` | diperluas di 2.1.6 |
| Fitur yang harus diuji | 2.1.9 menjadi skrip uji otomatis |

---

## B. Daftar isi Modul 2.1 (diperbarui)

<details>
  <summary>📃 Daftar Isi</summary>

- **2.1.0** Laboratorium: menjalankan dan menguji kode `[TAMBAHAN]`
- **2.1.1** Variabel dan scope (hoisting, global implisit, ASI)
- **2.1.2** Tipe dan konversi
- **2.1.3** Fungsi dan arrow function
- **2.1.4** Array: `map`, `filter`, `reduce`, `find`, dan kawan-kawan
- **2.1.5** Objek dan destructuring
- **2.1.6** String dan template literal
- **2.1.7** `??` dan `?.`
- **2.1.8** `try/catch`
- **2.1.9** Fitur yang harus diuji dulu
- **2.1.10** Operator dan kesetaraan `[TAMBAHAN]`
- **2.1.11** Alur kendali dan perulangan `[TAMBAHAN]`
- Latihan dan kunci jawaban · Glosarium · Hubungan dengan modul lain

**Urutan belajar yang disarankan:** 2.1.0 → 2.1.1 → 2.1.2 → 2.1.10 → 2.1.11 → 2.1.3 → 2.1.4 → 2.1.5 → 2.1.6 → 2.1.7 → 2.1.8 → 2.1.9.

</details>

---

## C. Peta besar: di mana JavaScript hidup

```
   berkas .qml / .js
          │
          ▼
 ┌─────────────────────────────────────┐
 │ Mesin QML                           │
 │  ┌───────────────────────────────┐  │
 │  │ Mesin JavaScript (V4)         │  │ ← ECMAScript edisi ke-7 + tambahan
 │  │ Object Array String Math JSON │  │
 │  └───────────────────────────────┘  │
 │  Objek tuan rumah: Qt, console,     │
 │  XMLHttpRequest, qsTr ...           │
 └─────────────────────────────────────┘
   ✗ TIDAK ADA: window, document, DOM, require
```

**Filosofinya:** QML menyatakan *apa* (hubungan antarproperti). JavaScript hanya menjawab *bagaimana* pada bagian yang tak bisa dinyatakan sebagai hubungan. Ia tamu di rumah mesin Qt, bukan peramban dan bukan Node.js.

---

## D. Materi

### 2.1.0 Laboratorium: menjalankan dan menguji kode `[TAMBAHAN]`

*Yang tak bisa diuji tak boleh dipercaya.*

**Konsep.** Semua contoh di bawah ditaruh di dalam `Component.onCompleted: { ... }` pada satu berkas `lab.qml`, lalu dijalankan dari terminal tanpa jendela.

```bash
mkdir -p ~/lab-qml && cd ~/lab-qml
$EDITOR lab.qml
qml -a core lab.qml
```
- `mkdir -p`: buat direktori, dan jangan protes bila sudah ada.
- `&&`: jalankan perintah berikutnya hanya jika yang kiri sukses.
- `$EDITOR`: variabel lingkungan berisi penyunting teks Anda.
- `qml`: alat runtime QML. `-a core` memilih kelas aplikasi *core*, satu dari tiga pilihan (core, gui, widget), dengan gui sebagai bawaan, sehingga tidak membuka jendela.
- Nama biner di Arch bisa berbeda (misalnya `qml6`). Cek dengan `pacman -Ql qt6-declarative | grep '/bin/'`.

```qml
import QtQml

QtObject {
    Component.onCompleted: {
        console.log('halo dari QML')
        Qt.quit()
    }
}
```
- `import QtQml`: memuat modul inti QML. Tipe `QtObject` dan objek global `Qt` ada di sini, tanpa grafis.
- `QtObject { }`: objek paling polos, tanpa tampilan. Cocok untuk eksperimen logika.
- `Component.onCompleted:`: *attached property* yang dipicu sekali setelah objek selesai dibuat.
- `console.log(...)`: mencetak ke terminal dengan awalan `qml: `.
- `Qt.quit()`: mengakhiri aplikasi. Tanpanya proses menggantung dan Anda harus menekan `Ctrl+C`.

**Opsi lain:**

| Perintah | Tujuan |
|---|---|
| `qml lab.qml` (root `Item`) | Menampilkan jendela, untuk uji visual |
| `QT_QPA_PLATFORM=offscreen qml lab.qml` | Menjalankan komponen visual tanpa layar |
| `qmllint lab.qml` | Pemeriksaan statis tanpa menjalankan |
| `qml -a core lab.qml 2>&1 \| grep GAGAL` | Menyaring keluaran (log Qt umumnya ke stderr) |

**Kesalahan umum:** modul tak ditemukan (paket Qt 6 belum terpasang); proses tak berhenti (lupa `Qt.quit()`); mencoba `import` modul visual dengan `-a core`.

**Referensi:** [qml runtime tool](https://doc.qt.io/qt-6/qtqml-tooling-qml.html) · [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html)

---

### 2.1.1 Variabel dan scope

*Nama yang jelas adalah separuh dari program yang benar.*

**Konsep dan filosofi.** Variabel adalah kotak berlabel. Prinsipnya sama dengan *least privilege* di keamanan: semakin sempit jangkauan sebuah nama dan semakin sedikit ia boleh berubah, semakin kecil permukaan kesalahannya.

| Kata kunci | Jangkauan | Boleh ditugaskan ulang? | Perilaku sebelum deklarasi | Sikap |
|---|---|---|---|---|
| `const` | blok `{}` | tidak | galat (TDZ) | **bawaan** |
| `let` | blok `{}` | ya | galat (TDZ) | bila nilainya berubah |
| `var` | fungsi | ya | "naik" (hoisting), bernilai `undefined` | hindari |

```js
const pajak = 0.11
let jumlah = 1
jumlah = jumlah + 1
if (jumlah > 1) {
    let pesan = 'lebih dari satu'
}
console.log(typeof pesan)
```
Keluaran: `qml: undefined`

- `const pajak = 0.11`: deklarasikan `pajak` yang terkunci pada nilai 0.11. `=` adalah penugasan: sisi kanan dihitung, lalu disimpan ke kotak di kiri.
- `let jumlah = 1`: kotak yang boleh diganti isinya.
- `jumlah = jumlah + 1`: tanpa kata kunci, karena kotaknya sudah ada. Sisi kanan dihitung dulu (1+1), baru disimpan.
- `if (...) { ... }`: `pesan` hanya hidup di dalam kurung kurawal.
- `typeof pesan`: operator yang mengembalikan nama tipe sebagai string. Ia tidak melempar galat untuk nama yang tidak ada, sehingga cocok untuk menguji keberadaan.

**Hoisting dan TDZ (temporal dead zone):**
```js
console.log(a)                       // undefined (bukan galat!)
var a = 5
try { console.log(b) } catch (e) { console.log(e.name) }   // ReferenceError
let b = 5
```
- `var a` "naik" ke awal fungsi, tetapi nilainya baru terisi di baris penugasannya.
- `b` ada tetapi belum boleh disentuh sampai deklarasinya dijalankan (TDZ), jadi mengakses lebih awal melempar `ReferenceError`.
- `e.name` berisi nama jenis galat.

**Aturan khas QML: variabel global implisit dilarang.** Objek global di QML bersifat konstan: properti tidak bisa diubah, dihapus, atau ditambah, sehingga penugasan ke variabel yang tak dideklarasikan tidak diizinkan dan menimbulkan exception.
```js
function salah() { hasil = 42 }
try { salah() } catch (e) { console.log('ditolak:', e.name) }
```
Perbaikan: tulis `const hasil = 42` atau `let hasil = 42`. Jenis galat persisnya `[uji]`.

**Closure di dalam perulangan, perbedaan `var` dan `let`:**
```js
const f1 = []
for (var i = 0; i < 3; i++) f1.push(() => i)
const f2 = []
for (let j = 0; j < 3; j++) f2.push(() => j)
console.log(JSON.stringify(f1.map(f => f())), JSON.stringify(f2.map(f => f())))
```
Keluaran: `[3,3,3] [0,1,2]`
- `var i` satu kotak untuk seluruh perulangan, jadi semua fungsi melihat nilai akhirnya (3).
- `let j` kotak baru di setiap putaran, jadi tiap fungsi menyimpan nilainya sendiri.
- `JSON.stringify(...)` mengubah array menjadi teks supaya cetakannya konsisten.

**Titik koma dan ASI (automatic semicolon insertion).** Mesin menyisipkan `;` sendiri di tempat-tempat tertentu, dan hasilnya bisa mengejutkan:
```js
function a() {
    return
    { nilai: 1 }
}
console.log(a())     // undefined: `return` berdiri sendiri di baris itu
```
Aturan aman: tulis nilai kembalian di baris yang sama dengan `return`. Jangan memulai baris dengan `(` atau `[` tanpa `;` di baris sebelumnya. Di QML, `;` juga memisahkan beberapa properti dalam satu baris (`width: 200; height: 100`).

```
 objek global (KONSTAN di QML)
  └─ scope berkas/komponen    id, properti objek akar  → Modul 2.2
       └─ scope fungsi        parameter, var
            └─ scope blok {}  let, const
 Pencarian nama: dari dalam ke luar, yang pertama ketemu menang.
```

**Opsi lain untuk menyimpan keadaan:**

| Kebutuhan | Cara |
|---|---|
| Keadaan privat di dalam fungsi | closure (`let` di fungsi luar) |
| Keadaan yang memicu pembaruan UI | `property` pada objek QML (Fase 3) |
| Keadaan bersama antar-importir | `.pragma library` (Modul 2.3) |
| Global bersama bertipe | `pragma Singleton` (Modul 5.3) |

**Tips:** mulai dengan `const`; satu deklarasi per baris; nama deskriptif dan konsisten (`camelCase`).

| Kesalahan | Solusi |
|---|---|
| Lupa kata kunci deklarasi | Selalu `const`/`let` |
| Mengira `const` membekukan objek | Itu hanya mengunci kotaknya. Gunakan `Object.freeze` (2.1.5) |
| `var` di perulangan + closure | Ganti `let` |
| Baris diawali `(` atau `[` | Beri `;` di akhir baris sebelumnya atau ubah susunan |

**Referensi:** [JavaScript Host Environment: restrictions](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html) · [Scope and Naming Resolution](https://doc.qt.io/qt-6/qtqml-documents-scope.html) · [MDN: let](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let) · [MDN: const](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/const) · [MDN: Hoisting](https://developer.mozilla.org/en-US/docs/Glossary/Hoisting)

---

### 2.1.2 Tipe dan konversi

*Mesin tidak menebak maksud Anda. Ia mengikuti aturan, dan aturannya bisa dipelajari.*

```
 nilai JS
 ├─ primitif (isinya tak bisa diubah)
 │    undefined · null · boolean · number · string · symbol
 └─ objek (diakses lewat referensi)
      Object · Array · Function · Date · RegExp · Map · Set · Error …
 BigInt: tidak tercantum di daftar resmi → [uji]
```

| Tipe | Arti | `typeof` |
|---|---|---|
| undefined | belum diberi nilai | `'undefined'` |
| null | sengaja kosong | `'object'` (cacat sejarah) |
| boolean | `true`/`false` | `'boolean'` |
| number | semua angka (double 64-bit IEEE-754) | `'number'` |
| string | teks (UTF-16) | `'string'` |
| objek / fungsi | selain di atas | `'object'` / `'function'` |

```js
console.log(typeof 42, typeof 'teks', typeof null)
console.log(0.1 + 0.2)
console.log(Math.abs(0.1 + 0.2 - 0.3) < Number.EPSILON)
console.log('5' + 3, '5' - 3)
console.log(Number('42px'), parseInt('42px', 10), parseFloat('3.5kg'))
console.log(Boolean(''), Boolean('0'), Boolean([]))
```
Keluaran: `number string object` · `0.30000000000000004` · `true` · `53 2` · `NaN 42 3.5` · `false true true`

- `0.1 + 0.2`: biner tidak bisa menyimpan 0.1 persis, seperti 1/3 di desimal.
- `Number.EPSILON`: selisih terkecil yang berarti. Membandingkan angka pecahan dengan toleransi ini jauh lebih aman daripada `===`.
- `'5' + 3`: `+` bila ada string menjadi penyambung. `'5' - 3`: `-` hanya bisa angka, jadi `'5'` diubah.
- `parseInt('42px', 10)`: membaca awalan numerik; argumen kedua adalah radix (basis). **Selalu isi.**
- **Falsy:** `false, 0, -0, '', null, undefined, NaN`. Selainnya truthy, termasuk `'0'` dan `[]`.

**Opsi konversi, pilih sesuai tujuan:**

| Tujuan | Opsi |
|---|---|
| Angka ketat | `Number(x)`, atau `+x` |
| Angka dari awalan teks | `parseInt(s, 10)`, `parseFloat(s)` |
| Membulatkan | `Math.round`, `Math.floor`, `Math.trunc` |
| Teks | `String(x)`, `` `${x}` ``, `x.toString()` (gagal di `null`/`undefined`) |
| Teks berdesimal | `n.toFixed(2)` (mengembalikan *string*) |

**Jembatan ke QML.** JavaScript hanya punya `number`. Tipe properti QML (`int`, `real`, `bool`, `string`, `var`) lebih ketat dan memberi informasi lebih kepada mesin. `var` dapat memuat nilai JS apa pun (Fase 3).

**Tips:** simpan uang sebagai bilangan bulat satuan terkecil (rupiah utuh), bukan pecahan. Bandingkan angka pecahan dengan toleransi.

| Kesalahan | Solusi |
|---|---|
| `'10' + 5` → `'105'` | Ubah dulu: `Number('10') + 5` |
| `isNaN('abc')` bernilai true | Pakai `Number.isNaN(x)` (tidak memaksa konversi) |
| `parseInt` tanpa radix | Selalu `parseInt(s, 10)` |
| `x === NaN` selalu false | `Number.isNaN(x)` |

**Referensi:** [MDN: Data structures](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures) · [MDN: Grammar and types](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Grammar_and_types) · [javascript.info: Type conversions](https://javascript.info/type-conversions) · [Qt: Number](https://doc.qt.io/qt-6/qml-qtqml-number.html)

---

### 2.1.3 Fungsi dan arrow function

*Fungsi kecil yang jujur lebih berharga daripada satu fungsi raksasa yang pintar.*

```js
function tambah(a, b = 0) { return a + b }
const kali = function (a, b) { return a * b }
const kuadrat = x => x * x
const jumlahSemua = (...angka) => angka.reduce((s, n) => s + n, 0)
const buatPencacah = () => { let n = 0; return () => ++n }
const hitung = buatPencacah()
console.log(tambah(2), kali(3, 4), kuadrat(5), jumlahSemua(1, 2, 3), hitung(), hitung())
```
Keluaran: `2 12 25 6 1 2`

- `function tambah(a, b = 0)`: *deklarasi fungsi*. `b = 0` adalah parameter default, dipakai bila argumen tidak diberikan (`undefined`).
- `return`: mengembalikan nilai dan menghentikan fungsi.
- `const kali = function (...) {...}`: *ekspresi fungsi*, fungsi sebagai nilai yang disimpan di kotak.
- `x => x * x`: *arrow function*. Satu parameter boleh tanpa kurung. Tanpa `{}`, nilai kanan otomatis dikembalikan.
- `(...angka)`: *rest parameter*, mengumpulkan semua argumen menjadi array sungguhan.
- `reduce((s, n) => s + n, 0)`: lipat array jadi satu nilai. `0` adalah nilai awal akumulator `s`.
- `buatPencacah`: **closure**. Fungsi dalam mengingat `n` milik fungsi luar, dan `n` tidak bisa diakses dari luar sama sekali (enkapsulasi gratis).

**Fungsi bertipe di QML.** Deklarasi fungsi di dokumen QML sebaiknya memakai anotasi tipe pada argumen dan nilai kembalian. Fungsi yang ditugaskan ke signal handler dikecualikan dan anotasi di sana dilarang. Sejak Qt 6.7 anotasi selalu ditegakkan, dengan nilai dipaksa ke tipe yang diminta.
```qml
import QtQml

QtObject {
    function luas(sisi: double) : double { return sisi * sisi }
    Component.onCompleted: { console.log(luas(3)); Qt.quit() }
}
```
- `sisi: double`: parameter bertipe `double`.
- `: double` setelah kurung: tipe nilai kembalian.
- Enumerasi bukan tipe di QML, jadi pakai `int` atau `double`.
- Perilaku lama (anotasi diabaikan interpreter) bisa diminta dengan `pragma FunctionSignatureBehavior: Ignored`.

**Opsi lain, lima bentuk untuk logika yang sama:**

| Bentuk | Kapan |
|---|---|
| Deklarasi fungsi | Fungsi bernama yang bisa dipakai sebelum baris definisinya (hoisted) |
| Ekspresi fungsi | Disimpan ke variabel atau diteruskan |
| Arrow function | Callback pendek (`map`, `filter`) |
| Method QML bertipe | Fungsi milik objek QML, rujukan lewat `id` (Modul 2.2) |
| Fungsi di berkas `.js` | Logika murni yang dipakai ulang (Modul 2.3) |

Catatan tentang `this`: arrow function tidak punya `this` sendiri. Di QML `this` memang tidak boleh diandalkan (Modul 2.2), jadi gaya arrow cocok.

**Tips:** fungsi *murni* (keluaran hanya bergantung pada masukan, tanpa efek samping) mudah diuji dan diaudit. Lebih dari tiga parameter? Pakai satu objek dengan destructuring.

| Kesalahan | Solusi |
|---|---|
| `['1','2','3'].map(parseInt)` → `1,NaN,NaN` | `map` mengirim indeks sebagai argumen kedua, dan `parseInt` menganggapnya radix. Tulis `.map(s => parseInt(s, 10))` |
| `return` diikuti baris baru | Letakkan nilai satu baris dengan `return` |
| Callback tak kunjung memanggil, atau terpanggil dua kali | Uji tiap jalur |

**Referensi:** [MDN: Functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Functions) · [javascript.info: Arrow functions](https://javascript.info/arrow-functions-basics) · [JavaScript Host Environment: type annotations](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html)

---

### 2.1.4 Array

*Kebanyakan "algoritma" sehari-hari hanyalah tiga kata kerja: saring, ubah, lipat.*

```js
const produk = [
    { nama: 'Kopi', harga: 15000, stok: 4 },
    { nama: 'Teh',  harga:  8000, stok: 0 },
    { nama: 'Roti', harga: 12000, stok: 9 },
]
const tersedia = produk.filter(p => p.stok > 0)
const namaMahal = produk.filter(p => p.harga > 10000).map(p => p.nama)
const total = produk.reduce((jml, p) => jml + p.harga * p.stok, 0)
const teh = produk.find(p => p.nama === 'Teh')
const adaKosong = produk.some(p => p.stok === 0)
console.log(tersedia.length, namaMahal.join(', '), total, teh.harga, adaKosong)
```
Keluaran: `2 Kopi, Roti 168000 8000 true`

- `filter`: array baru berisi elemen yang lolos uji.
- `map`: array baru yang panjangnya sama, tiap elemen diubah.
- `reduce`: lipat jadi satu nilai. Total = 15000×4 + 8000×0 + 12000×9.
- `find`: elemen pertama yang cocok, atau `undefined`.
- `some`: apakah ada yang cocok (`every`: apakah semua cocok).
- Koma setelah elemen terakhir (*trailing comma*) sah.

```
 produk ─filter(stok>0)→ [Kopi, Roti] ─map(nama)→ ['Kopi','Roti'] ─join→ "Kopi, Roti"
```

**Mutasi atau bukan, hafalkan:**

| Mengubah array asal | Menghasilkan baru/nilai |
|---|---|
| `push pop shift unshift splice sort reverse fill` | `map filter slice concat join indexOf includes find some every reduce` |

**Empat cara menjumlah, hasil sama (opsi lain):**
```js
let t1 = 0
for (let i = 0; i < produk.length; i++) t1 += produk[i].harga * produk[i].stok
let t2 = 0
for (const p of produk) t2 += p.harga * p.stok
let t3 = 0
produk.forEach(p => { t3 += p.harga * p.stok })
const t4 = produk.reduce((jml, p) => jml + p.harga * p.stok, 0)
```
Pilih `reduce`/`map`/`filter` bila Anda mengubah data, `for…of` bila ada `break` atau `continue`, `for` berindeks bila perlu posisi.

**Pengganti fungsi yang tak tercantum `[uji]`:**

| Butuh | Pengganti |
|---|---|
| `flat()` | `arr.reduce((a, b) => a.concat(b), [])` |
| `at(-1)` | `arr[arr.length - 1]` |
| `findLast(f)` | `arr.slice().reverse().find(f)` |

**Jebakan `sort`:** `[10, 9, 1].sort()` menghasilkan `[1, 10, 9]` karena membandingkan sebagai teks. Tulis `.sort((a, b) => a - b)`, dan salin dulu bila tak ingin mengubah aslinya: `arr.slice().sort(...)`.

**Jebakan khas QML:** mengubah isi array di `property var` dengan `push` tidak otomatis memicu pembaruan binding. Itu pokok Modul 3.1. Solusinya menugaskan array baru: `daftar = daftar.concat([x])`.

| Kesalahan | Solusi |
|---|---|
| `reduce` pada array kosong tanpa nilai awal melempar `TypeError` | Selalu beri nilai awal |
| Mengubah array sambil mengulanginya | Buat array baru lewat `filter`/`map` |
| `sort` tanpa pembanding untuk angka | Beri fungsi pembanding |

**Referensi:** [MDN: Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array) · [javascript.info: Array methods](https://javascript.info/array-methods) · [Qt: daftar fungsi Array yang didukung](https://doc.qt.io/qt-6/qtqml-javascript-functionlist.html)

---

### 2.1.5 Objek dan destructuring

*Objek adalah cara menamai data sehingga kode menjelaskan dirinya sendiri.*

```js
const nama = 'Kopi'
const item = { nama, harga: 15000, tag: ['panas', 'manis'] }
const { nama: judul, harga: h = 0, stok = 0 } = item
console.log(judul, h, stok)
const salinan = Object.assign({}, item, { harga: 16000 })
console.log(item.harga, salinan.harga)
for (const [kunci, nilai] of Object.entries(item)) console.log(kunci, JSON.stringify(nilai))
const [pertama, , ketiga = 'x'] = ['a', 'b']
console.log(pertama, ketiga)
```
Keluaran: `Kopi 15000 0` · `15000 16000` · `nama "Kopi"` / `harga 15000` / `tag ["panas","manis"]` · `a x`

- `{ nama, harga: 15000 }`: `nama` saja adalah *shorthand* untuk `nama: nama`.
- `const { nama: judul, harga: h = 0 } = item`: ambil properti `nama` dan simpan ke variabel `judul` (ganti nama). `harga` ke `h`, dengan 0 bila `undefined`. `stok` tak ada, jadi bernilai default 0.
- `Object.assign({}, item, {...})`: salin properti ke objek kosong baru, yang kanan menimpa yang kiri. Ini pengganti object spread `[uji]`.
- `Object.entries(item)`: array pasangan `[kunci, nilai]`. `for (const [k, v] of ...)` mengurai tiap pasangan.
- `[pertama, , ketiga = 'x']`: destructuring array berdasarkan posisi. Koma kosong melompati elemen kedua.

**Salinan dangkal vs dalam:**
```
 item ──► { nama, harga, tag ──► ['panas','manis'] }
 salinan ► { nama, harga, tag ──┘   ← array `tag` DIBAGI, bukan disalin
```
Salinan dalam lewat `JSON.parse(JSON.stringify(x))` membuang fungsi dan `undefined`, mengubah `Date` jadi teks, dan gagal pada referensi melingkar.

**Opsi lain:**

| Tujuan | Opsi |
|---|---|
| Menggabung objek | `Object.assign` (ada), `{...a, ...b}` `[uji]` |
| Membekukan | `Object.freeze(o)` (dangkal); cek dengan `Object.isFrozen` |
| Kamus aman | `Object.create(null)` (tanpa prototipe) |
| Daftar kunci/nilai | `Object.keys`, `Object.values`, `Object.entries` |

**Tips keamanan:** jangan menggabung data tak tepercaya dengan fungsi *merge* rekursif buatan sendiri (celah *prototype pollution*).

| Kesalahan | Solusi |
|---|---|
| Nilai default tak berlaku untuk `null` | Default hanya untuk `undefined`. Gunakan `??` (2.1.7) |
| Mengira `const` membuat objek tak berubah | `Object.freeze` |
| `for…in` pada array | Gunakan `for…of` atau `Object.entries` |

**Referensi:** [MDN: Destructuring](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment) · [javascript.info: Destructuring](https://javascript.info/destructuring-assignment) · [Forum Qt: objek destructuring/spread](https://forum.qt.io/topic/117535/object-destructuring-in-qml)

---

### 2.1.6 String dan template literal

*Teks adalah antarmuka pertama manusia dengan program.*

```js
const nama = 'Kopi', harga = 15000, qty = 3
console.log(`${nama} x${qty} = ${harga * qty}`)
console.log('Total: %1 item'.arg(qty))
console.log('a-b-c'.replace('-', '+'), 'a-b-c'.split('-').join('+'))
console.log('7'.padStart(3, '0'), 'ab'.repeat(3), '  x '.trim() + '|')
console.log(String(15000).replace(/\B(?=(\d{3})+(?!\d))/g, '.'))
console.log('😀'.length)
```
Keluaran: `Kopi x3 = 45000` · `Total: 3 item` · `a+b-c a+b+c` · `007 ababab x|` · `15.000` · `2`

- Backtick `` ` `` membuat *template literal*. `${ekspresi}` menyisipkan hasil ekspresi, dan boleh multibaris.
- `.arg(qty)`: ekstensi Qt pada `String`, mengganti `%1`, `%2`, dst. QML menambahkan fungsi arg() ke prototipe String. Inilah mitra `qsTr()` untuk terjemahan.
- `replace('-', '+')` hanya mengganti kemunculan **pertama**. `replaceAll` `[uji]`, jadi gunakan `split(...).join(...)`.
- `padStart(3, '0')`, `repeat(3)`, `trim()`: semuanya tercantum di daftar resmi.
- `/\B(?=(\d{3})+(?!\d))/g`: regex pemisah ribuan. `\B` = bukan batas kata, `(?=...)` = lookahead, `g` = semua kemunculan.
- `'😀'.length` bernilai 2 karena `length` menghitung unit UTF-16, bukan karakter tampak. Untuk titik kode gunakan `codePointAt`.

**Pemformatan mata uang, opsi lain:**
```js
const id = Qt.locale('id_ID')
console.log((15000).toLocaleCurrencyString(id, 'Rp'))
console.log((1234567.891).toLocaleString(id, 'f', 2))
```
Fungsi-fungsi ini adalah ekstensi Qt pada `Number`. Bentuk keluarannya bergantung data locale di mesin Anda `[uji]`. Alternatif tanpa locale adalah regex di atas.

**Tips:** gunakan template literal, bukan rangkaian `+`. Bungkus teks yang tampil ke pengguna dengan `qsTr()`. Jangan merakit URL, HTML, atau SQL dengan menyambung teks tak tepercaya. Pakai `encodeURIComponent` untuk URL, dan placeholder untuk SQL (Modul 2.4).

| Kesalahan | Solusi |
|---|---|
| `replace` hanya sekali | Regex `/g` atau `split/join` |
| `length` pada emoji | `codePointAt`, atau iterasi `for…of` |
| Perbandingan teks peka huruf | `toLowerCase()` atau `localeCompare` |

**Referensi:** [MDN: Template literals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals) · [Qt: String.arg()](https://doc.qt.io/qt-6/qml-string.html) · [Qt: Number](https://doc.qt.io/qt-6/qml-qtqml-number.html) · [Qt: QML Global Object](https://doc.qt.io/qt-6/qtqml-javascript-qmlglobalobject.html)

---

### 2.1.7 `??` dan `?.`

*Data dunia nyata selalu bolong. Tulis kode yang tidak panik karenanya.*

```js
const diskon = 0
console.log(diskon || 10, diskon ?? 10)
const pesanan = { pelanggan: null }
console.log(pesanan.pelanggan?.alamat?.kota ?? 'tidak diketahui')
const fungsi = undefined
console.log(fungsi?.(1) ?? 'tak ada fungsi')
const daftar = null
console.log(daftar?.[0] ?? 'kosong')
```
Keluaran: `10 0` · `tidak diketahui` · `tak ada fungsi` · `kosong`

- `a || b`: pakai `b` bila `a` **falsy** (termasuk 0, `''`). Salah untuk angka sah seperti 0.
- `a ?? b`: pakai `b` hanya bila `a` adalah `null` atau `undefined` (*nullish*).
- `x?.y`: bila `x` nullish, seluruh ekspresi menjadi `undefined` dan **berhenti**, tanpa `TypeError`.
- `f?.(1)` dan `a?.[0]`: bentuk untuk pemanggilan dan indeks.
- Versi: `??` sejak Qt 5.15, `?.` sejak 6.2 (dikonfirmasi di dokumentasi Qt).

```
 pesanan.pelanggan ?. alamat ?. kota ?? 'tidak diketahui'
        │ null/undefined? ─ya→ seluruh rantai = undefined ─→ ?? memberi default
        └ tidak → lanjut ke properti berikutnya
```

**Hubungan dengan cast QML.** Dokumentasi Qt memakai pola `(parent as Rectangle)?.color`: `as` mengembalikan `null` bila tipenya salah, dan `?.` mencegah galat.

**Opsi lain:**

| Ingin | Opsi |
|---|---|
| Default hanya untuk null/undefined | `??` |
| Default untuk semua falsy | `\|\|` |
| Akses aman bertingkat | `?.`, atau `a && a.b && a.b.c` |
| Percabangan eksplisit | `x === undefined ? d : x` atau `if` |

| Kesalahan | Solusi |
|---|---|
| `\|\|` untuk default angka | `??` |
| `?.` pada variabel tak dideklarasikan → `ReferenceError` | `?.` hanya melindungi nilai, bukan nama |
| `obj?.metode()` saat `metode` tak ada → `TypeError` | `obj.metode?.()` |
| Mencampur `??` dengan `\|\|` tanpa kurung | Spesifikasi melarangnya (SyntaxError) `[uji]`. Beri kurung |

**Referensi:** [MDN: Nullish coalescing](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Nullish_coalescing_operator) · [MDN: Optional chaining](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Optional_chaining) · [javascript.info: Optional chaining](https://javascript.info/optional-chaining)

---

### 2.1.8 `try/catch`

*Kegagalan yang dipersiapkan adalah fitur. Kegagalan yang dikejutkan adalah bug.*

```js
function bacaJson(teks) {
    try {
        return JSON.parse(teks)
    } catch (e) {
        console.warn('JSON rusak:', e.name)
        return null
    } finally {
        console.log('selesai membaca')
    }
}
console.log(JSON.stringify(bacaJson('{"a": 1}')))
console.log(bacaJson('{rusak'))
```
Keluaran: `selesai membaca` · `{"a":1}` · `JSON rusak: SyntaxError` · `selesai membaca` · `null`

- `try { }`: jalankan kode yang mungkin gagal. `JSON.parse` melempar `SyntaxError` untuk teks cacat.
- `catch (e)`: bila ada galat, lompat ke sini. `e.name` adalah jenisnya dan `e.message` pesannya.
- `finally { }`: selalu dijalankan, sukses atau gagal, bahkan setelah `return`.
- `console.warn`: pencatatan tingkat peringatan.
- Jenis galat bawaan: `Error, TypeError, RangeError, ReferenceError, SyntaxError, URIError, EvalError`.

```
 try ─ sukses ───────────────► finally ─► lanjut
   │ throw
   └► catch (e) ─► finally ─► lanjut
```

**Di QML:** pengecualian yang tak tertangkap umumnya hanya dicetak sebagai peringatan berisi berkas dan baris, dan ekspresi atau handler itu berhenti `[uji]`. Aplikasi tidak otomatis tutup. Jangan menjadikannya jaring pengaman.

**Opsi lain:**

| Pola | Kapan |
|---|---|
| `throw new Error('stok kosong')` | Kondisi yang tak boleh terjadi |
| *Guard clause* (`if (!x) return null`) | Kondisi yang wajar terjadi, tanpa melempar |
| Objek hasil `{ ok, nilai, galat }` | Pemanggil harus memutuskan sendiri |

**Tips keamanan:** jangan tampilkan `e.message` mentah ke pengguna atau log tanpa menyaringnya, karena dapat membocorkan jalur, token, atau data. Lempar objek `Error`, bukan string.

| Kesalahan | Solusi |
|---|---|
| `try` membungkus seluruh program | Bungkus hanya operasi yang memang bisa gagal |
| `catch` kosong menelan galat | Minimal catat; putuskan tindakan |
| `catch {}` tanpa parameter | Tulis `catch (_e) {}` bila belum teruji `[uji]` |

**Referensi:** [MDN: try...catch](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/try...catch) · [javascript.info: try…catch](https://javascript.info/try-catch)

---

### 2.1.9 Fitur yang harus diuji dulu

*Jangan mengandalkan ingatan atau asumsi. Buktikan di mesin Anda.*

**Mengapa memakai `eval`?** Kesalahan sintaks di berkas QML menggagalkan pemuatan seluruh berkas, dan `try/catch` tidak bisa menyelamatkannya. Kode yang diberikan sebagai teks ke `eval` baru dikompilasi saat dijalankan, sehingga galatnya bisa ditangkap. `eval` hanya untuk laboratorium. Jangan pernah dipakai pada masukan tak tepercaya.

```qml
import QtQml

QtObject {
    function uji(nama, kode) {
        try {
            console.log('OK    ', nama, '->', String(eval(kode)))
        } catch (e) {
            console.log('GAGAL ', nama, '->', e.name)
        }
    }
    Component.onCompleted: {
        uji('object spread',     '({ ...{ a: 1 }, b: 2 }).b')
        uji('array spread',      '[...[1, 2], 3].length')
        uji('async function',    'typeof (async function () {})')
        uji('BigInt',            'typeof BigInt')
        uji('pemisah numerik',   '1_000_000')
        uji('operator **',       '2 ** 10')
        uji('??',                'null ?? 5')
        uji('?.',                '({}).a?.b')
        uji('flat',              '[[1], [2]].flat().length')
        uji('at',                '[1, 2, 3].at(-1)')
        uji('Object.fromEntries','Object.fromEntries([["a", 1]]).a')
        uji('replaceAll',        '"a-b".replaceAll("-", "+")')
        uji('trimStart',         '"  x".trimStart()')
        uji('??=',               '(() => { let x = null; x ??= 5; return x })()')
        uji('catch tanpa param', '(() => { try { throw 1 } catch { return "ok" } })()')
        uji('Promise/Map/Set',   '[typeof Promise, typeof Map, typeof Set].join()')
        Qt.quit()
    }
}
```
Jalankan: `qml -a core uji-fitur.qml 2>&1 | grep -E 'OK|GAGAL'`

- `function uji(nama, kode)`: pembungkus uji, dengan nama fitur dan kode berupa teks.
- `eval(kode)`: mengevaluasi teks sebagai JavaScript dan mengembalikan nilai ekspresi terakhir.
- `String(...)`: memastikan hasilnya bisa dicetak apa pun tipenya.
- `e.name`: bila `SyntaxError`, fiturnya tidak dikenal mesin.
- Baris `typeof BigInt` akan menghasilkan `OK ... undefined` bila BigInt tidak ada. "OK" di sini hanya berarti pengujinya tidak melempar, jadi baca nilainya.

**Dugaan berdasarkan dokumen (bukan hasil uji):**

| Fitur | Dugaan |
|---|---|
| `**`, `??`, `?.`, pemisah numerik, array spread, Promise/Map/Set | ada (terdokumentasi atau dilaporkan) |
| object spread | kemungkinan gagal (laporan Qt 5.x, QTBUG-107206) |
| async/await | kemungkinan gagal (QTBUG-58620, laporan Qt 5.15) |
| BigInt, `flat`, `at`, `fromEntries`, `replaceAll`, `trimStart`, `??=`, `catch {}` | tidak tercantum di dokumen, ujilah |

**Pengganti bila gagal:**

| Butuh | Pengganti |
|---|---|
| async/await | `Timer`, callback, `Qt.callLater`, `Promise` (tercantum, perilakunya `[uji]`) |
| object spread | `Object.assign({}, a, b)` |
| `replaceAll` | `split(x).join(y)` atau regex `/g` |
| `trimStart` | `.replace(/^\s+/, '')` |
| `x ??= v` | `x = x ?? v` |
| `BigInt` | `Number` (aman hingga `Number.MAX_SAFE_INTEGER`), atau C++ |

**Referensi:** [List of JavaScript Objects and Functions](https://doc.qt.io/qt-6/qtqml-javascript-functionlist.html) · [QTBUG-58620](https://bugreports.qt.io/browse/QTBUG-58620) · [QTBUG-107206](https://bugreports.qt.io/browse/QTBUG-107206) · [ECMA-262](https://www.ecma-international.org/publications-and-standards/standards/ecma-262/)

---

### 2.1.10 Operator dan kesetaraan `[TAMBAHAN]`

*Satu tanda sama dengan yang kurang bisa menyamarkan satu bug seharian.*

```js
console.log(7 / 2, Math.trunc(7 / 2), 7 % 3, -7 % 3, 2 ** 10)
console.log(0 == '', 0 === '', null == undefined, null === undefined)
console.log(NaN === NaN, Object.is(NaN, NaN), Number.isNaN(NaN))
console.log('2' > '12', 2 > 12)
```
Keluaran: `3.5 3 1 -1 1024` · `true false true false` · `false true true` · `true false`

- `/` pembagian riil (tidak ada pembagian bulat). `Math.trunc` membuang pecahan.
- `%` sisa bagi. Tandanya mengikuti angka yang dibagi, jadi `-7 % 3` adalah `-1`. `**` pangkat (ES2016, masuk edisi ke-7).
- `==` membandingkan **dengan konversi**, `===` **tanpa**. Pakai `===` dan `!==` sebagai aturan.
- `NaN` tidak sama dengan dirinya sendiri. `Object.is` dan `Number.isNaN` menanganinya.
- `'2' > '12'` bernilai true karena membandingkan teks per karakter. Ubah ke angka bila maksudnya numerik.

**Temuan audit kecil.** Contoh `instanceof` pada halaman Host Environment menulis `!v instanceof Item`. Itu terurai sebagai `(!v) instanceof Item`. Bentuk yang benar adalah `!(v instanceof Item)`. Qt memperluas `instanceof` agar bisa memeriksa tipe QML.

**Tips:** operator bitwise (`& | ^ << >>`) bekerja pada bilangan bulat 32-bit. Gunakan untuk flag, jangan sebagai trik pembulatan (`x | 0`).

**Referensi:** [MDN: Equality comparisons](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Equality_comparisons_and_sameness) · [javascript.info: Comparisons](https://javascript.info/comparison)

---

### 2.1.11 Alur kendali dan perulangan `[TAMBAHAN]`

*Program adalah keputusan yang diulang.*

```js
const nilai = 78
const huruf = nilai >= 85 ? 'A' : nilai >= 70 ? 'B' : 'C'
switch (huruf) {
case 'A': console.log('istimewa'); break
case 'B': console.log('baik'); break
default:  console.log('perlu belajar')
}
const hari = ['Sen', 'Sel', 'Rab']
for (let i = 0; i < hari.length; i++) { if (i === 1) continue; console.log(i, hari[i]) }
for (const h of hari) console.log(h)
for (const i in hari) console.log(typeof i)
let n = 3
while (n > 0) { n-- }
do { n++ } while (n < 2)
```
Keluaran: `baik` · `0 Sen`, `2 Rab` · `Sen`, `Sel`, `Rab` · `string` ×3

- `kondisi ? a : b`: operator ternary, ekspresi `if/else` ringkas.
- `switch` memakai kesetaraan ketat. `break` mencegah *fall-through* (jatuh ke `case` berikutnya).
- `continue` melompat ke putaran berikutnya, `break` keluar dari perulangan.
- `for…of` mengulang **nilai**. `for…in` mengulang **kunci** sebagai string, termasuk kunci warisan, jadi jangan dipakai pada array.
- `do…while` dijalankan minimal sekali.

```
 Perlu indeks?  ─ya→ for (let i…)
   └ tidak → ingin mengubah/menyaring? ─ya→ map / filter / reduce
                 └ tidak → for…of (atau forEach)
 Kunci objek? → Object.keys/entries + for…of   (hindari for…in)
```

**Opsi lain, `switch` jadi tabel pencarian:**
```js
const peta = { A: 'istimewa', B: 'baik' }
console.log(peta[huruf] ?? 'perlu belajar')
```

**Peringatan UI:** JavaScript QML berjalan di utas UI. Perulangan berat membekukan antarmuka. Pecah pekerjaan dengan `Timer` atau pindahkan ke utas lain (misalnya `WorkerScript`, dibahas pada fase yang relevan).

| Kesalahan | Solusi |
|---|---|
| Lupa `break` di `switch` | Tulis `break` atau pakai tabel pencarian |
| Perulangan tak berujung | Pastikan kondisi berubah di setiap putaran |
| `for…in` pada array | `for…of` |

**Referensi:** [MDN: Loops and iteration](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Loops_and_iteration) · [javascript.info: Loops](https://javascript.info/while-for)

---

## E. Latihan 15 menit dan kunci jawaban

**Latihan (dari kurikulum):** saring produk berharga di atas 10000, lalu cetak namanya.

```js
function namaMahal(daftar, batas = 10000) {
    return daftar.filter(p => p.harga > batas).map(p => p.nama)
}
console.log(namaMahal(produk).join(', '))        // Kopi, Roti
```
Opsi lain: `for…of` dengan `if` lalu `push` ke array hasil.
```js
const hasil = []
for (const p of produk) if (p.harga > 10000) hasil.push(p.nama)
```

**Cek pemahaman:** `??` hanya menganggap `null` dan `undefined` sebagai kosong, sedangkan `||` menganggap semua nilai falsy (`0`, `''`, `false`) sebagai kosong. Karena itu `0 ?? 10` menghasilkan `0`, tetapi `0 || 10` menghasilkan `10`.

**Tantangan tambahan:** jalankan skrip 2.1.9 dan simpan hasilnya `OK/GAGAL` per fitur sebagai catatan versi Qt Anda.

---

## F. Glosarium Modul 2.1

| Istilah | Arti |
|---|---|
| ECMAScript | Standar bahasa; JavaScript adalah implementasinya |
| Host environment | Objek dan fungsi yang disediakan lingkungan penyelenggara (di sini: Qt) |
| Primitif | Nilai sederhana yang isinya tak bisa diubah |
| Hoisting | Deklarasi yang "naik" ke awal ruang lingkupnya |
| TDZ | Rentang sebelum `let`/`const` terdeklarasi, saat aksesnya melempar galat |
| Closure | Fungsi yang mengingat variabel dari tempat ia dibuat |
| Parameter default / rest | Nilai bawaan argumen / pengumpul sisa argumen menjadi array |
| Arrow function | Fungsi bersintaks ringkas `=>` tanpa `this` sendiri |
| Destructuring | Mengurai objek/array menjadi variabel terpisah |
| Template literal | String berkutip-balik yang mendukung `${}` |
| Nullish | `null` atau `undefined` |
| Falsy / truthy | Nilai yang dianggap salah / benar dalam konteks boolean |
| Optional chaining | `?.`, akses berantai yang berhenti aman bila ada yang kosong |
| Shallow / deep copy | Salinan dangkal (referensi dalam dibagi) / dalam (semua disalin) |
| Mutasi | Mengubah data di tempat, bukan membuat salinan |
| ASI | Penyisipan titik koma otomatis oleh mesin |
| Exception | Galat yang "dilempar" dan bisa ditangkap |
| Event loop | Antrean yang menjalankan pekerjaan satu per satu di utas UI |

---

## G. Hubungan dengan modul lain

| Modul | Hubungan |
|---|---|
| **2.2** JavaScript di dokumen QML | Memakai semua ekspresi di sini di dalam binding, handler, dan fungsi. Aturan `this` dibahas di sana |
| **2.3** File JS dan pragma | Fungsi dan variabel level atas di berkas `.js`; `.pragma library` dan keadaan bersama |
| **2.4** Lingkungan host | `JSON`, `Timer`, `XMLHttpRequest`, `Promise`, penyimpanan; pengganti async/await |
| **3.1** Properti dan binding | Mengapa mengubah isi array/objek di `property var` tidak memicu pembaruan |
| **5.3** Singleton | Pengganti variabel global bersama |
| **13.1** Keamanan | Risiko `eval`, XHR berkas lokal, dan pembersihan masukan |

**Prasyarat Modul 2.2:** menguasai 2.1.1 sampai 2.1.8. Lewati 2.1.9 hanya bila Anda sudah menjalankan skripnya.

---

# Fase 2 · Modul 2.2 — JavaScript di dalam Dokumen QML

---

## A. Audit singkat

**Terverifikasi:**
- JavaScript hidup di empat tempat dalam dokumen QML: isi binding, isi signal handler, method kustom, dan berkas `.js` terpisah. Kurikulum menyebut tiga tempat dan memindahkan `.js` ke Modul 2.3, jadi tetap selaras.
- Mesin QML memantau variabel dalam ekspresi binding dan mengevaluasi ulang ketika salah satunya berubah. Properti yang dibaca di dalam fungsi yang dipakai sebagai binding ikut terlacak. Jawaban "cek pemahaman" di kurikulum benar dan lengkap.
- Nilai `this` tidak terdefinisi di sebagian besar konteks QML. Di binding, signal handler, dan fungsi yang dideklarasikan di QML, `this` merujuk ke objek lingkup (scope object).
- Menugaskan nilai statis ke properti dari pernyataan JavaScript menghapus binding yang ada.

**Perlu dikoreksi atau dilengkapi:**
1. **Contoh kurikulum.** `hitungan` bernilai statis (`property int hitungan: 0`), jadi `hitungan = 5` tidak memutus apa pun. Korban nyata assignment adalah `height` dan `color`, yang memang berupa binding. Ini diperagakan di 2.2.8.
2. **Signal handler.** Cara menerima parameter sinyal adalah menugaskan fungsi (arrow atau anonim) ke handler. Menyuntikkan parameter ke blok kode biasa sudah usang dan memicu peringatan saat parameternya dipakai. Judul "Signal handler dan blok" berisiko mengajarkan gaya usang, jadi 2.2.2 mengajarkan bentuk fungsi.
3. **Hilang dari daftar isi:** handler perubahan properti `on<Properti>Changed`, `Connections`, `connect()/disconnect()`, handler terlampir (*attached*), `Component.onDestruction`, dan `Qt.binding()`. Semuanya telah ditambahkan.
4. **Scope.** Dokumentasi terbaru menyarankan agar tidak merujuk `id` objek akar dari komponen lain, karena itu melanggar enkapsulasi. Akses state eksternal lewat properti, alias properti, atau sinyal. Ini masuk 2.2.4.
5. **Fungsi di objek akar.** Method inline pada objek akar komponen dapat dipanggil dari luar komponen. Bila tak diinginkan, letakkan di objek non-akar atau, lebih baik, di berkas JavaScript. Ini masuk 2.2.5.
6. **Beberapa `onCompleted`.** Bila ada lebih dari satu handler `onCompleted`, urutan eksekusinya tidak terdefinisi. Ini masuk 2.2.6.
7. **Salah ketik di dokumentasi Qt.** Contoh di halaman Signal and Handler menulis parameter `mgs` tetapi memakai `msg` di badan fungsi, dan `{xPosition}` tanpa tanda `$` di template literal. Keduanya adalah contoh kesalahan nyata untuk bagian kesalahan umum.

---

## B. Daftar isi Modul 2.2 (diperbarui)

- **2.2.1** Binding expression
- **2.2.2** Signal handler dan blok (+ parameter sinyal, `on<Properti>Changed`) `[diperluas]`
- **2.2.3** Fungsi (parameter default, anotasi tipe)
- **2.2.4** `this` dan scope (+ dynamic scoping, id vs properti) `[diperluas]`
- **2.2.5** Fungsi pembantu (+ enkapsulasi) `[diperluas]`
- **2.2.6** `Component.onCompleted` (+ `onDestruction`, handler terlampir) `[diperluas]`
- **2.2.7** `Connections` dan `connect()` `[TAMBAHAN]`
- **2.2.8** Binding vs assignment, `Qt.binding()`, diagnosis `[TAMBAHAN]`
- Latihan dan kunci jawaban · Glosarium · Hubungan dengan modul lain

**Urutan belajar yang disarankan:** 2.2.1 → 2.2.2 → 2.2.8 → 2.2.3 → 2.2.4 → 2.2.5 → 2.2.6 → 2.2.7.

---

## C. Peta besar: deklaratif vs imperatif

```
 dokumen QML
 ├─ binding expression  → DEKLARATIF: "X selalu sama dengan ..."    otomatis, berulang
 ├─ signal handler      → IMPERATIF : "ketika Y terjadi, lakukan ..." sekali per kejadian
 ├─ method (function)   → IMPERATIF : makro bernama, dipanggil dari dua yang di atas
 └─ berkas .js          → pustaka (Modul 2.3)
```

**Filosofinya:** sedapat mungkin *nyatakan hubungan* (binding), dan hanya *perintahkan langkah* (handler, fungsi) bila hubungan tak cukup. Semakin deklaratif kode Anda, semakin sedikit keadaan yang harus Anda jaga sendiri, dan itu pangkal kode yang mudah diaudit.

**Cara menjalankan contoh** (laboratorium dari 2.1.0):
- Berkas berbasis `QtObject`: `qml -a core nama.qml`
- Berkas visual (`Rectangle`, `Text`): `QT_QPA_PLATFORM=offscreen qml nama.qml`, atau `qml nama.qml` bila ingin jendela.

---

## D. Materi

### 2.2.1 Binding expression

*Biarkan mesin yang menghitung ulang. Tugas Anda menyatakan hubungannya.*

**Konsep.** Binding adalah rumus sel spreadsheet: `total = harga × jumlah`. Anda tidak menulis "hitung ulang saat harga berubah". Cukup menulis rumusnya, dan mesin mencatat nilai apa saja yang dibaca rumus itu (dependensi).

```qml
import QtQml

QtObject {
    property int harga: 15000
    property int jumlah: 2
    property int total: harga * jumlah
    property string label: total > 20000 ? 'besar' : 'kecil'

    Component.onCompleted: {
        console.log(total, label)      // 30000 besar
        jumlah = 1
        console.log(total, label)      // 15000 kecil
        Qt.quit()
    }
}
```

**Bedah kode:**
- `property int harga: 15000`: `property` mendeklarasikan properti baru, `int` tipenya, `harga` namanya. Setelah `:` adalah nilai awal. Nilai tetap seperti `15000` adalah nilai statis, bukan binding.
- `property int total: harga * jumlah`: nilai di kanan adalah *ekspresi* yang membaca properti lain, sehingga ini **binding**. Mesin mencatat `harga` dan `jumlah` sebagai dependensi `total`.
- `label: total > 20000 ? 'besar' : 'kecil'`: binding bersyarat. `label` bergantung pada `total`, dan `total` bergantung pada `harga` dan `jumlah` (rantai).
- `jumlah = 1`: menugaskan properti. Mesin mendeteksi perubahan dan mengevaluasi ulang `total`, lalu `label`.
- Di `Component.onCompleted`, nama `jumlah` ditulis tanpa awalan karena objek itu sendiri adalah *scope object* (2.2.4).

```
 harga  ─┐
         ├─► total ──► label
 jumlah ─┘      ▲ setiap panah: "jika sumber berubah, hitung ulang tujuan"
```

**Dependensi lewat fungsi.** Properti yang dibaca di dalam fungsi yang dipakai sebagai binding ikut dihitung ulang saat berubah.
```qml
import QtQml

QtObject {
    property bool premium: false
    property int diskonPersen: hitungDiskon()
    function hitungDiskon() { return premium ? 20 : 0 }

    Component.onCompleted: {
        console.log(diskonPersen)      // 0
        premium = true
        console.log(diskonPersen)      // 20
        Qt.quit()
    }
}
```
`diskonPersen` tidak menyebut `premium` secara langsung, tetapi fungsi yang dipanggilnya membacanya, jadi tetap terlacak.

**Bentuk binding yang sah (opsi lain):**

| Bentuk | Contoh |
|---|---|
| Rujukan properti | `tinggi: lebar` |
| Aritmetika | `tinggi: lebar / 2` |
| Fungsi bawaan | `tinggi: Math.min(a, b)` |
| Ternary | `tinggi: a > 100 ? a : a / 2` |
| Blok dengan `return` | `tinggi: { if (a > 100) return a; return a / 2 }` |
| Pemanggilan fungsi | `tinggi: hitungTinggi()` (**dianjurkan** untuk logika panjang) |

Binding yang rumit (banyak baris, perulangan imperatif) menurunkan kinerja dan keterbacaan, dan urutan evaluasi antar-binding tidak boleh diandalkan. Dokumentasi juga membolehkan efek samping, tetapi tidak menganjurkannya.

**Tips:**
- Binding kecil, murni, tanpa efek samping (`console.log`, penugasan properti lain). Bila logikanya panjang, tarik ke fungsi.
- Jangan membuat dua properti saling bergantung (`a: b + 1` dan `b: a + 1`). Mesin akan mencetak peringatan *binding loop*.
- Jangan menaruh komputasi berat di binding. Ia dijalankan ulang setiap dependensinya berubah.

| Kesalahan | Solusi |
|---|---|
| Mengira binding hanya dihitung sekali | Ia dihitung ulang setiap dependensi berubah |
| Menugaskan `tinggi = 5` di handler dan heran ia berhenti mengikuti `lebar` | Lihat 2.2.8 |
| Mengandalkan urutan evaluasi antar-binding | Rancang agar hasilnya tak bergantung urutan |
| Efek samping di binding | Pindahkan ke handler (2.2.2) |

**Referensi:** [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html) · [JavaScript Expressions in QML Documents](https://doc.qt.io/qt-6/qtqml-javascript-expressions.html)

---

### 2.2.2 Signal handler dan blok

*Peristiwa datang tak terduga. Handler yang rapi membuat kejutan menjadi rutinitas.*

**Konsep.** Sinyal adalah *peristiwa* ("tombol diklik", "nilai berubah"). Handler adalah *tanggapan*. Bedanya dengan binding: binding menyatakan hubungan yang selalu berlaku, handler menjalankan langkah **sekali per peristiwa**.

| Jenis | Nama handler | Contoh |
|---|---|---|
| Sinyal bawaan atau buatan sendiri | `on<Sinyal>` | `onClicked`, `onDiklik` |
| Perubahan properti | `on<Properti>Changed` | `onHitunganChanged` |
| Terlampir (*attached*) | `Tipe.on<Sinyal>` | `Component.onCompleted` (2.2.6) |

```qml
import QtQml

QtObject {
    id: root
    property int hitungan: 0
    signal diklik(jumlah: int)

    onHitunganChanged: console.log('hitungan jadi', hitungan)
    onDiklik: jumlah => hitungan += jumlah

    Component.onCompleted: {
        diklik(2)           // hitungan jadi 2
        diklik(3)           // hitungan jadi 5
        Qt.quit()
    }
}
```

**Bedah kode:**
- `signal diklik(jumlah: int)`: mendeklarasikan sinyal baru. Sintaks yang dianjurkan adalah `signal nama(parameter : tipe)`, dengan tipe di belakang nama. Sintaks lama menaruh tipe di depan.
- `onDiklik:`: awalan `on` + nama sinyal berhuruf kapital di awal. Menulis `ondiklik` tidak akan dikenali.
- `jumlah => hitungan += jumlah`: *arrow function* yang menerima parameter sinyal. Nama parameter formal tidak harus sama dengan nama di sinyal.
- `onHitunganChanged`: handler yang otomatis ada karena properti `hitungan` ada. Anda tidak mendeklarasikannya.
- `diklik(2)`: **memancarkan** sinyal, caranya memanggilnya seperti fungsi.

**Blok dengan banyak pernyataan** (bentuk yang dianjurkan):
```qml
onDiklik: (jumlah) => {
    if (jumlah <= 0) return
    hitungan += jumlah
}
```

**Aturan parameter** (dari dokumentasi 6.12):
- Parameter di belakang boleh dihilangkan: `onErrorOccurred: message => ...`.
- Parameter di depan tidak boleh dilompati, tetapi boleh diberi nama pengisi: `(_, _, col) => ...`.
- Gaya usang: `onDiklik: { hitungan += jumlah }` menyuntikkan `jumlah` ke scope. Ini berjalan, tetapi usang, lebih lambat, dan memicu peringatan saat parameternya dipakai.
- Objek `arguments`: di fungsi biasa berisi argumen sinyal, di arrow function kosong. Dokumentasi menyarankan memakai parameter bernama, bukan `arguments`.

**Jangan memanggil handler langsung.** Walau handler mirip fungsi, jangan dipanggil langsung. Pindahkan kode bersama ke fungsi terpisah, atau pancarkan sinyalnya.
```qml
onDiklik: jumlah => proses(jumlah)       // handler tipis
function proses(n: int) : void { hitungan += n }   // logika di fungsi
```

**Handler untuk komponen visual** (butuh `QtQuick`, jalankan dengan `offscreen` atau jendela):
```qml
MouseArea { anchors.fill: parent; onClicked: (mouse) => root.tambah() }
```

**Opsi lain untuk logika yang sama:**

| Cara | Kapan |
|---|---|
| Handler inline | Satu tindakan kecil |
| Handler memanggil fungsi | Logika dipakai ulang atau diuji |
| `Connections` (2.2.7) | Mendengarkan objek lain |
| `sinyal.connect(fungsi)` (2.2.7) | Banyak penerima, atau objek dinamis |

| Kesalahan | Solusi |
|---|---|
| `onclicked` (huruf kecil) | `onClicked` |
| Nama parameter tak cocok di badan (`mgs` vs `msg`, seperti di contoh dokumentasi) | `ReferenceError`. Samakan nama |
| `{xPosition}` tanpa `$` di template literal | Tulis `${xPosition}` |
| Mengandalkan parameter yang "muncul sendiri" di blok | Pakai bentuk fungsi eksplisit |

**Referensi:** [Signal and Handler Event System](https://doc.qt.io/qt-6/qtqml-syntax-signals.html) · [QML Object Attributes](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html)

---

### 2.2.3 Fungsi (parameter default, anotasi tipe)

*Makro bernama adalah cara termurah untuk berhenti menyalin kode.*

```qml
import QtQml

QtObject {
    property int saldo: 100

    function tambah(n: int = 1) : void { saldo += n }
    function formatSaldo(prefix: string) : string { return `${prefix} ${saldo}` }
    function cek(batas: int) : bool { return saldo >= batas }

    Component.onCompleted: {
        tambah()
        tambah(10)
        console.log(formatSaldo('Rp'), cek(100))    // Rp 111 true
        Qt.quit()
    }
}
```

**Bedah kode:**
- `function tambah(...) { ... }`: kata kunci `function` di dalam deklarasi objek membuat **method** milik objek itu. Fungsi yang didefinisikan di dalam badan objek QML menjadi method objek tersebut dan dapat dipanggil dari handler, binding, atau objek lain.
- `n: int`: anotasi tipe parameter. `: void`, `: string`, dan `: bool` setelah tanda kurung adalah tipe nilai kembalian. `void` berarti tidak mengembalikan nilai.
- `= 1`: nilai default. Kombinasi default dengan anotasi tipe, `n: int = 1`, ditandai `[uji]`. Bila ditolak, tulis `function tambah(n = 1)`.
- `saldo += n`: `saldo` adalah properti objek yang sama (scope object, tanpa awalan).

**Aturan anotasi tipe** (dari dokumentasi 6.12):
- Deklarasi fungsi di dokumen QML dianjurkan memakai anotasi tipe karena membantu Qt Creator dan qmllint, serta mempermudah pemanggilan dari C++. Fungsi yang ditugaskan ke signal handler dikecualikan dan anotasi di sana dilarang. Sejak Qt 6.7 anotasi selalu ditegakkan dan nilai dipaksa ke tipe yang diminta.
- Enumerasi bukan tipe di QML. Pakai `int` atau `double`.

**Opsi lain, tempat menaruh fungsi:**

| Tempat | Sifat |
|---|---|
| Method pada objek QML (di atas) | Dekat dengan datanya, terlihat oleh binding dan handler |
| `property var f: x => x * 2` | Fungsi sebagai nilai properti `[uji]` |
| Berkas `.js` | Logika murni yang dipakai ulang (Modul 2.3) |
| Singleton | Pustaka bersama bertipe (Modul 5.3) |

**Tips:** beri anotasi tipe pada semua method. Satu fungsi, satu tugas. Sebaiknya fungsi murni.

| Kesalahan | Solusi |
|---|---|
| Menganotasi fungsi di signal handler | Dilarang. Biarkan tanpa anotasi |
| Mengira tipe diabaikan | Sejak 6.7 ditegakkan. Nilai dipaksa ke tipe itu |
| Perilaku lama dibutuhkan | `pragma FunctionSignatureBehavior: Ignored` (Modul 2.3) |
| Memakai enum sebagai tipe | Pakai `int` |

**Referensi:** [JavaScript Host Environment: type annotations](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html) · [QML Object Attributes: method attributes](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html)

---

### 2.2.4 `this` dan scope

*Tahu "siapa melihat apa" menghemat berjam-jam menelusuri bug.*

**Konsep.** *Scope* adalah daftar nama yang bisa dilihat dari suatu tempat dalam kode. Dua fakta dasar:
- Binding punya akses langsung ke properti objek lingkupnya tanpa awalan objek, sehingga QML tidak mengharuskan `this`.
- Component scope adalah gabungan seluruh `id` objek di dalam komponen dan properti objek akar komponen itu.

```
 Mencari sebuah nama (disederhanakan):
   1. variabel / parameter JavaScript lokal dan objek global (Math, JSON ...)
   2. id objek di dalam komponen
   3. properti objek lingkup (scope object)
   4. properti objek akar komponen
   5. hierarki komponen yang lebih luar
 Pertama yang cocok menang.
```
Urutan 1–3 didukung dokumentasi: id selalu mengalahkan nama properti, kecuali yang berasal dari JavaScript scope. Rincian lengkap urutan `[uji]`.

```qml
import QtQml

QtObject {
    id: root
    property int a: 1

    QtObject {
        id: anak
        property int a: 2
        property int nilai: a              // a milik `anak` (scope object)
        property int nilaiRoot: root.a     // lewat id, eksplisit
        function lokal() { const a = 99; return a }   // variabel lokal mengalahkan properti
        function siapa() { return this.a }            // this = scope object
    }

    Component.onCompleted: {
        console.log(anak.nilai, anak.nilaiRoot, anak.lokal(), anak.siapa())
        // 2 1 99 2
        Qt.quit()
    }
}
```

**Bedah kode:**
- Objek `anak` bersarang di dalam `root`. Keduanya punya properti `a`.
- `nilai: a`: binding yang dievaluasi dengan `anak` sebagai scope object, jadi `a` berarti `anak.a`.
- `root.a`: `root` adalah `id`, jalan eksplisit ke objek mana pun dalam dokumen yang sama.
- `const a = 99`: variabel lokal JavaScript menutupi properti. Ingat aturan scope blok dari 2.1.1.
- `this.a`: di fungsi yang dideklarasikan di QML, `this` adalah scope object, yaitu `anak`.

**Kapan `this` berguna.** Saat membuat binding dari JavaScript, `this` merujuk ke objek yang menerima binding, dan di luar binding nilainya tidak terdefinisi. Contoh gaya dokumentasi:
```qml
QtObject {
    property int lebar: 500
    property QtObject kotak: QtObject { property int lebar: 100; property int tinggi: 0 }

    Component.onCompleted: {
        kotak.tinggi = Qt.binding(function () { return this.lebar * 2 })
        console.log(kotak.tinggi)      // 200, bukan 1000
        Qt.quit()
    }
}
```
`this.lebar` merujuk ke `kotak.lebar` (100), sementara `lebar` tanpa awalan di sini berarti `lebar` milik objek akar (500).

**Aturan yang mudah dilupakan:**
- Di berkas `.js`, `this` tidak terdefinisi. Untuk merujuk objek tertentu, beri `id` atau kirim objeknya sebagai argumen.
- QML melarang nama tipe, id, dan properti yang bentrok dengan properti objek global, sehingga `Math.min(10, 9)` selalu aman.
- Pembacaan *attached property* tanpa awalan selalu menuju scope object, yang sering bukan maksud Anda. Tulis awalan eksplisit.

**Dynamic scoping: jangan merujuk `id` luar.** `id` hanya sah di dokumen yang sama. Memakai `root.width` di berkas `CustomItem.qml` yang `root`-nya dideklarasikan di berkas lain memang berjalan karena aturan scoping dinamis, tetapi menciptakan ketergantungan tersirat yang rapuh. Pola yang benar:
```qml
// CustomItem.qml : antarmuka eksplisit
Rectangle {
    property color boxColor: 'red'
    color: boxColor
}
// Main.qml : pemakai mengisi lewat properti
CustomItem { boxColor: 'blue' }
```
Untuk membuka state internal, pakai `property alias`, properti, atau sinyal. Ini juga prinsip isolasi: komponen hanya menyentuh apa yang diberikan kepadanya.

| Kesalahan | Solusi |
|---|---|
| Bergantung pada `this` di berkas `.js` | Berikan `id` atau parameter |
| Nama properti sama dengan `id` | `id` menang. Ubah salah satu |
| `root.x` di komponen terpisah | Properti/alias/sinyal |
| Properti terlampir tanpa awalan | Tulis eksplisit (`Tipe.properti`) |

**Referensi:** [Scope and Naming Resolution](https://doc.qt.io/qt-6/qtqml-documents-scope.html) · [JavaScript Host Environment: restrictions](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html) · [Property Binding: using this](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html)

---

### 2.2.5 Fungsi pembantu

*Fungsi kecil yang tersembunyi lebih aman daripada fungsi besar yang terbuka.*

```qml
import QtQml

QtObject {
    property int harga: 15000
    property string tampil: util.rupiah(harga)

    QtObject {
        id: util
        function rupiah(n: int) : string {
            return 'Rp ' + String(n).replace(/\B(?=(\d{3})+(?!\d))/g, '.')
        }
    }

    Component.onCompleted: {
        console.log(tampil)          // Rp 15.000
        harga = 2500000
        console.log(tampil)          // Rp 2.500.000
        Qt.quit()
    }
}
```

**Bedah kode:**
- `QtObject { id: util ... }` di dalam `QtObject` akar: objek anak pembawa fungsi. Ia ditambahkan lewat *default property* `data`, tanpa perlu menamai properti.
- `util.rupiah(harga)`: binding yang memanggil fungsi. Karena `harga` dibaca di ekspresi binding, `tampil` ikut berubah ketika `harga` berubah.
- Fungsi `rupiah` memakai regex dari 2.1.6. Ia murni: keluaran hanya bergantung pada masukan.

**Mengapa di objek anak, bukan di akar?** Fungsi inline di objek akar terbuka bagi pemanggil di luar komponen. Objek berberkas `id` hanya terlihat di dalam dokumennya, sehingga `util` tidak menjadi API publik tanpa disengaja.

**Opsi lain:**

| Tempat | Sifat |
|---|---|
| Fungsi di objek akar | API publik komponen. Beri nama, tipe, dokumentasi |
| Fungsi di objek anak berberkas `id` (di atas) | "Privat" dalam dokumen |
| Berkas `.js` | Dianjurkan dokumentasi untuk logika non-trivial (Modul 2.3) |
| Singleton | Dipakai banyak komponen (Modul 5.3) |

**Tips:** nama berupa kata kerja (`hitungTotal`, `rupiah`). Tipe masukan dan keluaran jelas. Hindari menaruh efek samping di fungsi yang dipanggil dari binding. Validasi masukan di batas komponen (keamanan).

| Kesalahan | Solusi |
|---|---|
| Semua fungsi di akar | Pisahkan API publik dan pembantu |
| Fungsi pembantu mengubah properti lain tanpa sepengetahuan pemanggil | Murnikan atau beri nama yang jujur |
| Menyalin regex atau rumus di banyak tempat | Satu fungsi bernama |

**Referensi:** [JavaScript Expressions: custom methods](https://doc.qt.io/qt-6/qtqml-javascript-expressions.html) · [QML Object Attributes](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html)

---

### 2.2.6 `Component.onCompleted` dan handler terlampir

*Setiap kehidupan punya awal. Tulislah awal yang bersih.*

```qml
import QtQml

QtObject {
    property int nilai: 0
    function mulai() { nilai = 42 }

    Component.onCompleted: {
        mulai()
        console.log('siap, nilai =', nilai)    // siap, nilai = 42
        Qt.quit()
    }
    Component.onDestruction: console.log('dihancurkan')   // [uji] bisa tak tercetak saat Qt.quit()
}
```

**Bedah kode:**
- `Component.onCompleted:`: handler **terlampir** (*attached signal handler*). Bukan menanggapi sinyal dari tipe `QtObject`. Mesin melampirkan objek bertipe `Component` ke setiap objek, dan sinyal `completed` dipancarkan saat objek selesai dibuat.
- Isi blok dijalankan setelah objek selesai diinstansiasi. Pada titik ini properti sudah terisi dan binding sudah terpasang.
- `Component.onDestruction`: dipicu tepat sebelum objek dihancurkan, untuk membersihkan sumber daya.

```
 objek dibuat → properti terisi → binding terpasang → completed → onCompleted dijalankan
                                                          ... hidup ...
                                              destruction → onDestruction dijalankan → objek hilang
```

**Aturan dari dokumentasi:**
- Tempat terbaik untuk kode awal aplikasi adalah `Component.onCompleted` pada objek paling atas, karena saat itu lingkungan QML sudah sepenuhnya terbentuk.
- Kode "global" di berkas `.js` berjalan saat lingkungan belum utuh, misalnya objek belum dibuat atau binding belum terpasang. Jangan taruh kode awal di sana.
- Objek mana pun, termasuk objek bersarang, boleh memiliki handler ini. Bila ada beberapa handler `onCompleted`, urutannya tidak terdefinisi. Jangan membuat objek A bergantung pada B yang "pasti sudah siap".

**Opsi lain untuk logika awal:**

| Cara | Kapan |
|---|---|
| Nilai awal lewat binding atau properti | **Utamakan**: deklaratif, tanpa langkah awal |
| `Component.onCompleted` | Langkah imperatif sekali di awal |
| `Timer { interval: 0; running: true }` | Menunda sampai putaran event berikutnya (Modul 2.4) |
| `Qt.callLater(fn)` | Menunda satu panggilan, tanpa duplikat (Modul 2.4) |
| `main()` di C++ | Inisialisasi tingkat aplikasi |

| Kesalahan | Solusi |
|---|---|
| Menugaskan properti ber-binding di `onCompleted` | Binding itu mati (2.2.8). Pakai `Qt.binding` atau properti terpisah |
| Pekerjaan panjang di `onCompleted` | Menahan UI. Pecah atau tunda |
| Bergantung pada urutan antar-`onCompleted` | Rancang tanpa urutan |

**Referensi:** [Component.onCompleted (signal)](https://doc.qt.io/qt-6/qml-qtqml-component.html#completed-signal) · [Attached signal handlers](https://doc.qt.io/qt-6/qtqml-syntax-signals.html#attached-signal-handlers) · [JavaScript in application startup code](https://doc.qt.io/qt-6/qtqml-javascript-expressions.html)

---

### 2.2.7 `Connections` dan `connect()` `[TAMBAHAN]`

*Mendengarkan dari jauh: satu sinyal, banyak telinga.*

```qml
import QtQml

QtObject {
    id: root
    signal pesan(dari: string, isi: string)

    function kePos(dari: string, isi: string)   { console.log('pos:', dari, isi) }
    function keEmail(dari: string, isi: string) { console.log('email:', dari, isi) }

    Connections {
        target: root
        function onPesan(dari, isi) { console.log('connections:', dari, isi) }
    }

    Component.onCompleted: {
        pesan.connect(kePos)
        pesan.connect(keEmail)
        pesan('Tom', 'Selamat ulang tahun')   // tiga baris (urutan tidak dijamin) [uji]
        pesan.disconnect(keEmail)
        pesan('Ani', 'Halo')                  // dua baris: pos dan connections
        Qt.quit()
    }
}
```

**Bedah kode:**
- `Connections { target: root; function onPesan(...) {...} }`: tipe yang mendengarkan sinyal **objek lain** (`target`). Bentuk `function onNamaSinyal(...)` adalah yang ditunjukkan dokumentasi 6.12.
- `pesan.connect(kePos)`: setiap sinyal punya method `connect()` yang menghubungkannya ke fungsi atau sinyal lain.
- `pesan.disconnect(keEmail)`: memutus. Fungsi yang sama harus diberikan.
- `connect` memungkinkan satu sinyal diterima banyak method, hal yang tak mungkin dengan handler karena nama handler harus unik. Ia juga berguna untuk objek yang dibuat secara dinamis.
- Menghubungkan sinyal ke sinyal membentuk rantai: `tombol.tapped.connect(kirim)` lalu `kirim` memicu handler `onKirim`.

**Peringatan masa hidup.** Koneksi ke objek fungsi tetap hidup selama pengirim sinyalnya hidup, bahkan setelah objek penerimanya hilang, sehingga fungsi itu terus dipanggil. Putuskan koneksi (`disconnect`) saat penerima dihancurkan, misalnya di `Component.onDestruction`.

**Opsi lain:**

| Cara | Kapan |
|---|---|
| Handler inline `onX` | Pengirim dan penerima satu objek |
| `Connections` | Mendengarkan objek lain, deklaratif |
| `connect()` | Banyak penerima, objek dinamis, rantai sinyal |

| Kesalahan | Solusi |
|---|---|
| Koneksi menggantung setelah objek hilang | `disconnect` di `onDestruction` |
| `target` kosong | `Connections` tidak mendengarkan apa pun. Pastikan terisi |
| Mengira urutan penerima dijamin | Jangan diandalkan |

**Referensi:** [Using the Connections type](https://doc.qt.io/qt-6/qtqml-syntax-signals.html#using-the-connections-type) · [Connecting signals to methods and signals](https://doc.qt.io/qt-6/qtqml-syntax-signals.html#connecting-signals-to-methods-and-signals) · [Connections](https://doc.qt.io/qt-6/qml-qtqml-connections.html)

---

### 2.2.8 Binding vs assignment, `Qt.binding()`, diagnosis `[TAMBAHAN]`

*Bug paling licik di QML adalah hubungan yang diam-diam putus.*

```qml
import QtQml

QtObject {
    property int lebar: 10
    property int tinggi: lebar * 2         // binding

    Component.onCompleted: {
        lebar = 20
        console.log(tinggi)                // 40   (binding hidup)

        tinggi = 5                         // ASSIGNMENT statis: binding DIBUNUH
        lebar = 30
        console.log(tinggi)                // 5    (tak lagi mengikuti lebar)

        tinggi = Qt.binding(function () { return lebar * 3 })   // pasang binding baru
        lebar = 40
        console.log(tinggi)                // 120
        Qt.quit()
    }
}
```

**Bedah kode:**
- `tinggi = 5`: menugaskan nilai statis dari pernyataan JavaScript menghapus binding. Setelahnya `tinggi` hanya bernilai 5 sampai ada penugasan lain.
- `Qt.binding(function () { ... })`: untuk membuat hubungan baru, ekspresi harus dibungkus fungsi `Qt.binding()`. Pembungkus ini mengubah "nilai sekali" menjadi "rumus yang hidup".
- Perbedaan satu karakter ini, `= 5` vs `= Qt.binding(...)`, adalah beda antara nilai beku dan rumus hidup.

```
 tinggi: lebar * 2   ──(tinggi = 5)──►  nilai statis 5      ──(Qt.binding(...))──►  binding baru
 [binding hidup]                         [binding mati]                              [binding hidup lagi]
```

**Diagnosis.** Mesin dapat mencetak pesan setiap kali binding hilang akibat penugasan imperatif, dengan mengaktifkan kategori log `qt.qml.binding.removal`. Pesan itu alat bantu diagnosis, belum tentu bukti masalah. Dari terminal, aturan filter yang sama lazimnya diberikan lewat variabel lingkungan `QT_LOGGING_RULES` (lihat QLoggingCategory):
```bash
QT_LOGGING_RULES="qt.qml.binding.removal.info=true" qml -a core lab.qml
```

**Opsi lain, agar tak perlu menugaskan ulang:**
```qml
import QtQml

QtObject {
    property int lebar: 10
    property real timpa: NaN                              // NaN = tak ada penimpaan
    property real tinggi: isNaN(timpa) ? lebar * 2 : timpa

    Component.onCompleted: { timpa = 5; console.log(tinggi)   // 5
        timpa = NaN; console.log(tinggi); Qt.quit() }          // 20
}
```
Pola ini menyimpan "penimpaan pengguna" di properti terpisah sehingga binding `tinggi` tidak pernah mati.

| Kesalahan | Solusi |
|---|---|
| `tinggi = ...` di handler tanpa sadar membunuh binding | Properti terpisah, atau `Qt.binding` bila memang ingin hubungan baru |
| Mengira `Qt.binding` memanggil fungsinya sekali | Ia memasang rumus yang dievaluasi ulang |
| `this` di dalam `Qt.binding` | Merujuk ke objek penerima (2.2.4) |
| Binding saling bergantung | Peringatan *binding loop*. Putus siklusnya |

**Referensi:** [Property Binding: creating bindings from JavaScript](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html#creating-property-bindings-from-javascript) · [Qt.binding()](https://doc.qt.io/qt-6/qml-qtqml-qt.html#binding-method) · [QLoggingCategory](https://doc.qt.io/qt-6/qloggingcategory.html)

---

## E. Latihan 15 menit dan kunci jawaban

**Latihan (dari kurikulum):** tambahkan `Text` yang menampilkan `hitungan` lewat binding, dan amati ia ikut berubah saat diklik.

```qml
import QtQuick

Rectangle {
    id: root
    property int hitungan: 0
    width: 200; height: width / 2
    color: hitungan % 2 === 0 ? 'tomato' : 'seagreen'

    function tambah(n = 1) { hitungan += n }

    Text { id: label; anchors.centerIn: parent; text: `Klik: ${root.hitungan}` }
    MouseArea { anchors.fill: parent; onClicked: root.tambah() }

    Component.onCompleted: {       // uji tanpa klik: hapus blok ini bila memakai jendela
        tambah(); console.log(label.text, color)    // Klik: 1 ...warna seagreen
        Qt.quit()
    }
}
```
Jalankan dengan `QT_QPA_PLATFORM=offscreen qml klik.qml`. Hapus blok `onCompleted` lalu jalankan `qml klik.qml` untuk mencoba klik sungguhan.

**Cek pemahaman:**
1. *Kapan binding dievaluasi ulang?* Saat salah satu properti yang dibacanya berubah, termasuk properti yang dibaca di dalam fungsi yang dipanggilnya.
2. *Mengapa `tinggi = 5` membuat `tinggi` berhenti mengikuti `lebar`?* Penugasan statis dari JavaScript menghapus binding. Pasang ulang dengan `Qt.binding()`.
3. *Mengapa blok `onX: { ... jumlah ... }` yang memakai parameter sinyal dianggap usang?* Parameter disuntikkan tak terlihat ke scope dan memicu peringatan saat dipakai. Pakai `jumlah => ...`.

**Tantangan:** buat komponen berisi hitungan dan fungsi `tambah`, lalu sembunyikan fungsi pembantu pemformat di objek anak (2.2.5). Pakai sinyal `diklik(jumlah)` dan `Connections` untuk menghubungkannya dari luar (2.2.7).

---

## F. Glosarium Modul 2.2

| Istilah | Arti |
|---|---|
| Binding | Properti yang diisi ekspresi, dihitung ulang otomatis saat dependensi berubah |
| Dependensi | Properti yang dibaca sebuah binding |
| Deklaratif / imperatif | "Apa yang selalu berlaku" / "langkah yang dijalankan" |
| Efek samping | Perubahan di luar nilai yang dikembalikan |
| Sinyal / emit | Peristiwa / memancarkannya dengan memanggilnya seperti fungsi |
| Signal handler | `on<Sinyal>`: kode yang dijalankan saat sinyal dipancarkan |
| Handler perubahan properti | `on<Properti>Changed`, otomatis ada untuk setiap properti |
| Parameter formal | Nama parameter pada fungsi handler (bebas, tak harus sama dengan sinyal) |
| Injeksi parameter | Menyuntikkan parameter sinyal ke scope blok. Usang |
| Handler terlampir | Handler dari tipe yang "dilampirkan" mesin, mis. `Component.onCompleted` |
| Scope object | Objek yang memiliki binding atau handler; propertinya terbaca tanpa awalan |
| Component scope | Gabungan `id` dalam komponen dan properti objek akar |
| Objek akar | Objek terluar dalam sebuah dokumen QML |
| `id` | Nama objek yang sah hanya di dokumen yang sama |
| Dynamic scoping | Nama luar yang kebetulan terlihat; rapuh, jangan diandalkan |
| `Qt.binding()` | Membuat binding dari JavaScript imperatif |
| Binding loop | Dua binding yang saling bergantung |
| `Connections` | Tipe yang mendengarkan sinyal objek lain |

---

## G. Hubungan dengan modul lain

| Modul | Hubungan |
|---|---|
| **2.1** Dasar JavaScript | Arrow function, destructuring, template literal, `const/let` dipakai di semua contoh |
| **2.3** File JS dan pragma | Memindahkan fungsi ke `.js`; `pragma ComponentBehavior: Bound` mengubah cara delegate memakai konteks |
| **2.4** Lingkungan host | `Timer` dan `Qt.callLater` sebagai alternatif logika awal; `console.*` |
| **3.1** Properti dan binding mendalam | Mengapa mengubah isi array/objek di `property var` tak memicu pembaruan; `alias`; `readonly` |
| **5.3** Singleton | Tempat fungsi pembantu bersama |
| **13.1** Keamanan | Permukaan API publik (fungsi di akar), validasi masukan, jangan menaruh rahasia di log |

**Prasyarat Modul 2.3:** menguasai 2.2.1 sampai 2.2.6. Bagian 2.2.7 dan 2.2.8 sangat dianjurkan sebelum Fase 3.

---

# Fase 2 · Modul 2.3 — File JavaScript dan Pragma

Saya membaca ulang bagian Modul 2.3 dari berkas kurikulum dan mengaudit isinya terhadap dokumentasi Qt 6.12. Yang saya periksa: Defining dan Importing JavaScript Resources, Structure of a QML Document, Singletons in QML, dan `qt_target_qml_sources`. Seperti sebelumnya, saya tidak menjalankan kode ini pada Qt, jadi bagian bertanda `[uji]` perlu Anda buktikan sendiri.

---

## A. Audit singkat

**Terverifikasi (tidak perlu diubah):**
- Perilaku bawaan adalah salinan unik yang terisolasi untuk setiap instans komponen QML. Dengan `.pragma library`, berkas dimuat sekali dan keadaannya dibagi antar-dokumen. Berkas pustaka itu tidak bisa mengakses objek atau properti instans komponen secara langsung, hanya lewat parameter fungsi.
- Tabel pragma mencatat `ComponentBehavior` sejak 6.4, `FunctionSignatureBehavior` sejak 6.5, dan `Translator` sejak 6.7. Ini **menyelesaikan catatan yang saya tinggalkan di audit Modul 2.2**. Label `[≥6.5]` di kurikulum benar. Penegakan anotasi tipe secara bawaan baru terjadi sejak 6.7, itu hal yang berbeda.
- Dengan `ComponentBehavior: Bound`, data model pada delegate hanya bisa dikirim lewat *required property*. Ini sesuai catatan kurikulum.
- Singleton QML lewat CMake memerlukan properti berkas `QT_QML_SINGLETON_TYPE`, dan `set_source_files_properties` harus dipanggil sebelum `qt_add_qml_module`. Tanpa CMake, qmldir manual memuat baris `singleton`.
- `QML_FILES` menerima berkas `.qml`, `.js`, dan `.mjs`, termasuk kompilasi ke bytecode dan pemeriksaan lint secara otomatis.

**Perlu dilengkapi:**
1. **Modul ES (`.mjs`) tidak ada di kurikulum.** Sintaks `.import` adalah ekstensi QML yang sudah digantikan standar ECMAScript, dan pemakaiannya tidak dianjurkan. Sintaks standar `import * as X from "f.mjs"` hanya berlaku di dalam berkas `.mjs`. `Qt.include()` juga usang dan sebaiknya dihindari. Sub-bab 2.3.4 saya susun ulang: `.mjs` dulu, `.import` sebagai warisan.
2. **Kopling tersembunyi pada mode bawaan.** Bila berkas JS tidak memuat `.import`, kodenya berjalan di scope yang sama dengan instans komponen dan dapat membaca serta mengubah objek dan propertinya. Kurikulum hanya menyebut "salinan sendiri". Ini penting untuk prinsip isolasi, jadi saya jelaskan khusus.
3. **Aturan pewarisan import.** Skrip dengan pernyataan import tidak mewarisi import dokumen pemanggil. Skrip tanpa import mewarisinya. Skrip `.pragma library` tidak pernah mewarisi.
4. **Aturan qualifier.** Qualifier untuk berkas JS harus diawali huruf besar, unik, dan tidak boleh sama dengan objek bawaan seperti `Date` atau `Math`.
5. **Tabel pragma tanpa versi dan nilai bawaan** untuk tiga pragma terakhir. Saya lengkapi dari tabel resmi.
6. **Posisi pragma.** Dokumen QML berurutan: daftar pragma (opsional), pernyataan import, lalu satu objek akar. Deklarasi `.pragma library` harus muncul sebelum kode JavaScript apa pun, kecuali komentar.
7. **Nama berkas berhuruf besar di CMake.** Contoh kurikulum memakai `MathUtils.js`. Berkas QML/JS secara bawaan dicatat sebagai tipe di qmldir. Untuk berkas JS berhuruf besar yang bukan modul ES dan bukan pustaka `.pragma library`, dokumentasi menyarankan mempertimbangkan properti `QT_QML_SKIP_QMLDIR_ENTRY`.
8. Sintaks `.import` tidak berfungsi pada skrip untuk WorkerScript.

**TAMBAHAN:** **2.3.7** Mendaftarkan JS di CMake dan perkakas, karena kurikulum hanya memberinya satu kalimat.

---

## B. Daftar isi Modul 2.3 (diperbarui)

- **2.3.0** Peta besar dan tata letak laboratorium `[TAMBAHAN]`
- **2.3.1** File `.js`: stateful (bawaan) dan kopling tersembunyi
- **2.3.2** `.pragma library`: pustaka stateless
- **2.3.3** `import ... as`
- **2.3.4** Impor antar-berkas JS: modul ES `.mjs` dan `.import` warisan `[diperluas]`
- **2.3.5** Pragma dokumen QML (+ versi, nilai bawaan) `[diperluas]`
- **2.3.6** JavaScript vs QML vs C++
- **2.3.7** Mendaftarkan JS di CMake dan perkakas `[TAMBAHAN]`
- Latihan dan kunci jawaban · Glosarium · Hubungan dengan modul lain

**Urutan belajar yang disarankan:** 2.3.0 → 2.3.1 → 2.3.2 → 2.3.3 → 2.3.4 → 2.3.7 → 2.3.5 → 2.3.6.

---

## C. Peta besar

```
        dua jenis "pragma" (jangan tertukar)
 ┌──────────────────────────────┬─────────────────────────────────┐
 │ .pragma library   (ada TITIK)│ pragma Singleton  (tanpa titik) │
 │ di dalam berkas  .js         │ di dalam berkas  .qml           │
 │ → pustaka stateless bersama  │ → arahan untuk mesin/dokumen    │
 └──────────────────────────────┴─────────────────────────────────┘
 Berkas .js : bawaan = stateful (salinan per instans)
              .pragma library = stateless (satu salinan bersama)
 Berkas .mjs: modul ES standar (export / import)
```

**Filosofinya:** JS yang diletakkan di berkas terpisah harus dipilih *sifat kerahasiaan dan keadaannya*: terisolasi per instans, atau murni tanpa keadaan. Aturan emasnya: **default-kan ke yang paling terisolasi dan paling sedikit mengetahui tentang pemanggilnya.**

**Tata letak laboratorium** (satu direktori, jalankan dengan `qml -a core Main.qml`):
```
lab-23/
├─ Main.qml
├─ Penghitung.qml        komponen QtObject
├─ hitung.js             stateful (bawaan)
├─ MathUtils.js          .pragma library
├─ faktorial.mjs         modul ES
├─ skrip.mjs             modul ES yang mengimpor faktorial.mjs
└─ Mjs.qml               penguji modul ES
```

---

## D. Materi

### 2.3.1 File `.js`: stateful (bawaan) dan kopling tersembunyi

*Ingat siapa yang memegang keadaan, karena merekalah sumber bug sunyi.*

**Konsep.** Berkas `.js` yang diimpor tanpa pragma adalah *code-behind*: logika milik satu komponen. Tiap instans tipe QML mendapat salinan objek dan keadaan JavaScript-nya sendiri, supaya perilakunya benar.

`hitung.js`:
```js
var hitungan = 0
function tambah() { hitungan += 1; return hitungan }
function ambilNama() { return nama }
```
`Penghitung.qml`:
```qml
import QtQml
import 'hitung.js' as Hitung

QtObject {
    property string nama: 'tanpa-nama'
    function tambah() : int { return Hitung.tambah() }
    function ambil() : string { return Hitung.ambilNama() }
}
```
`Main.qml`:
```qml
import QtQml

QtObject {
    Penghitung { id: a; nama: 'A' }
    Penghitung { id: b; nama: 'B' }

    Component.onCompleted: {
        console.log(a.tambah(), a.tambah(), b.tambah())   // 1 2 1  (salinan terpisah)
        console.log(a.ambil(), b.ambil())                 // A B    [uji]
        Qt.quit()
    }
}
```

**Bedah kode:**
- `var hitungan = 0`: keadaan di tingkat atas berkas. Contoh dokumentasi juga memakai `var` untuk keadaan semacam ini. Memakai `let` atau `const` di tingkat atas berkas skrip `[uji]`.
- `import 'hitung.js' as Hitung`: impor JS selalu dengan qualifier `as`, yang wajib berawalan huruf besar (2.3.3).
- `Penghitung { id: a }` dan `Penghitung { id: b }`: dua instans. Karena bawaan JS-nya per instans, `hitungan` masing-masing terpisah (`1 2` lalu `1`).
- `ambilNama()` membaca `nama` tanpa mendeklarasikannya. Itu terlihat karena skrip ini berjalan di scope instans pemanggil. Hal itu terjadi pada skrip yang tidak mengimpor sumber daya atau modul lain dengan `.import`. Hasilnya `A B`.

```
 Instans A ──► salinan hitung.js (hitungan=2, melihat nama='A')
 Instans B ──► salinan hitung.js (hitungan=1, melihat nama='B')
```

**Mengapa ini berbahaya:** `hitung.js` bergantung diam-diam pada properti `nama` milik komponen. Jika komponen berganti nama properti, JS rusak dan `qmllint` tidak banyak menolong. Kopling tersembunyi seperti ini adalah musuh isolasi. Perbaikannya: kirim sebagai parameter, `Hitung.ambilNama(nama)`.

**Kapan stateful memang tepat:** logika yang benar-benar milik satu komponen, berkeadaan, dan Anda sadar menaruhnya terpisah. Dokumentasi menganjurkan logika sederhana ditulis inline, dan logika kompleks dipisahkan ke berkas code-behind.

**Opsi lain untuk keadaan per komponen:**

| Cara | Sifat |
|---|---|
| Properti QML di komponen | Reaktif, terlihat oleh tooling |
| `.js` stateful (di atas) | Keadaan JS biasa, per instans |
| Objek anak berberkas `id` | Privat dalam dokumen (2.2.5) |
| C++ | Kritis kinerja atau keamanan |

| Kesalahan | Solusi |
|---|---|
| JS membaca properti komponen secara diam-diam | Kirim sebagai parameter |
| Mengira keadaan JS dibagi antar-instans | Tidak, ia per instans pada mode bawaan |

**Referensi:** [Defining JavaScript Resources in QML](https://doc.qt.io/qt-6/qtqml-javascript-resources.html) · [JavaScript Expressions in QML Documents](https://doc.qt.io/qt-6/qtqml-javascript-expressions.html)

---

### 2.3.2 `.pragma library`: pustaka stateless

*Yang tak tahu apa-apa tentang pemanggilnya tak bisa merusak pemanggilnya.*

`MathUtils.js`:
```js
.pragma library

function clamp(nilai, min, max) {
    return Math.min(Math.max(nilai, min), max)
}

function salah() { return dataInduk.nilai }
```
Uji dari `Main.qml` (tambahkan di `Component.onCompleted`):
```qml
import 'MathUtils.js' as MathUtils
// ...
console.log(MathUtils.clamp(15, 0, 10))                       // 10
try { MathUtils.salah() } catch (e) { console.log('ditolak:', e.name) }  // ReferenceError [uji jenis persis]
```

**Bedah kode:**
- `.pragma library`: baris pertama, diawali **titik**, tanpa titik dua. Ini arahan untuk berkas JS. Aturan penempatan: sebelum kode JS apa pun, komentar boleh mendahului.
- `function clamp(nilai, min, max)`: membatasi `nilai` ke rentang `[min, max]`. `Math.max(nilai, min)` menaikkan ke batas bawah, `Math.min(..., max)` menurunkan ke batas atas.
- `function salah() { return dataInduk.nilai }`: mencoba memakai nama yang hanya ada di komponen. Karena pustaka tidak melihat scope pemanggil, ia gagal (`ReferenceError`).
- Pustaka bersama tidak dapat mengakses objek atau properti instans komponen secara langsung, tetapi nilai QML boleh dilewatkan sebagai parameter fungsi.

**Keuntungan.** Menandai pustaka stateless dengan pragma dapat menghemat memori secara signifikan dan mempercepat instansiasi komponen. Berkas itu dimuat sekali oleh mesin walau banyak instans dibuat.

**Keadaan bersama.** Pustaka boleh menyimpan keadaan, dan keadaan itu dibagi ke semua pengimpor. Contoh dokumentasi: pemanggil `factorialCallCount` bisa mendapat nilai bukan nol di dokumen yang tak pernah memanggil `factorial`. Uji sendiri dengan menambahkan `.pragma library` di baris pertama `hitung.js` dari 2.3.1. Hasil pada `Main.qml` berubah menjadi `1 2 3` (satu salinan bersama). Tetapi `ambil()` akan gagal karena pustaka tak lagi melihat `nama`. Itu *tujuan*-nya.

```
 Tanpa pragma (stateful)             Dengan .pragma library (stateless)
  Instans A ── salinan JS A            Instans A ─┐
  Instans B ── salinan JS B            Instans B ─┼─ SATU salinan JS bersama
  Instans C ── salinan JS C            Instans C ─┘
  terisolasi per instans, boros        hemat memori; keadaan dibagi; tak melihat komponen
```

**Opsi lain untuk logika bersama:**

| Cara | Kapan |
|---|---|
| `.pragma library` | Fungsi murni, pembantu tanpa keadaan |
| Modul ES `.mjs` (2.3.4) | Pustaka bergaya standar, ekspor/impor eksplisit |
| QML singleton (2.3.5, Modul 5.3) | Keadaan bersama yang bertipe dan reaktif |
| C++ dengan `QML_ELEMENT` | Berat, perlu kinerja atau akses sistem |

**Tips:** pustaka sebaiknya *murni*. Gunakan keadaan bersama hanya bila sungguh perlu dan sadari akibatnya (bocornya data antar-komponen). Bawa data lewat parameter. Jangan simpan rahasia di variabel pustaka. Keadaan itu hidup selama mesin hidup.

| Kesalahan | Solusi |
|---|---|
| `.pragma library` bukan di bagian awal berkas | Pindahkan ke atas, sebelum kode |
| Pustaka mencoba memakai `id` atau properti QML | Kirim sebagai parameter |
| Menulis `pragma library` (tanpa titik) di berkas `.js` | Gunakan `.pragma library` |
| Mengandalkan keadaan terpisah per instans tetapi memakai pragma | Hapus pragma atau pindahkan keadaan ke QML |

**Referensi:** [Defining JavaScript Resources in QML: shared libraries](https://doc.qt.io/qt-6/qtqml-javascript-resources.html) · [Importing JavaScript Resources](https://doc.qt.io/qt-6/qtqml-javascript-imports.html)

---

### 2.3.3 `import ... as`

*Setiap impor adalah izin. Berilah nama yang jelas dan sedikit.*

**Konsep.** Sintaks dari QML:
```
import "URLSumber" as Qualifier
```
Impor berkas JS selalu diberi qualifier dengan kata kunci `as`. Qualifier harus diawali huruf besar dan unik, sehingga ada pemetaan satu-satu antara qualifier dan berkas. Itu juga berarti qualifier tidak boleh bernama seperti objek bawaan `Date` atau `Math`.

```qml
import QtQml
import 'MathUtils.js' as MathUtils          // relatif ke dokumen ini
import 'hitung.js'    as Hitung

QtObject {
    Component.onCompleted: {
        console.log(MathUtils.clamp(15, 0, 10))     // 10
        console.log(Hitung.tambah())                // 1
        Qt.quit()
    }
}
```

**Bedah kode:**
- `import 'MathUtils.js' as MathUtils`: `import` kata kunci, `'MathUtils.js'` URL sumber (relatif), `as` pemberi nama, `MathUtils` qualifier.
- `MathUtils.clamp(...)`: akses fungsi lewat `Qualifier.namaFungsi(parameter)`.
- URL relatif diselesaikan relatif terhadap dokumen atau sumber JS yang memuat impor itu. Bila berkas tak dapat diakses, terjadi galat. Bila diambil lewat jaringan, status komponen menjadi "Loading" sampai selesai diunduh.
- Parameter fungsi boleh bertipe nilai atau objek QML maupun tipe JavaScript biasa, dengan aturan konversi tipe data yang berlaku.

**Opsi lain, bentuk URL:**

| Bentuk | Contoh | Catatan |
|---|---|---|
| Relatif | `'MathUtils.js'`, `'lib/Util.js'` | **Pilihan utama** |
| Resource | `'qrc:/Modul/MathUtils.js'` | Jalur persis bergantung prefix modul `[sesuaikan]` |
| Jaringan atau `file:` absolut | `'https://...'` | **Hindari**: kode asing menjadi bagian aplikasi Anda |

**Aturan pewarisan import dalam JS** (dari dokumentasi):
- Skrip dengan pernyataan import sendiri tidak mewarisi import dokumen yang memuatnya.
- Skrip tanpa pernyataan import mewarisinya (dipertahankan demi kompatibilitas).
- Skrip bersama `.pragma library` tidak mewarisi import, bahkan jika ia tidak mengimpor skrip lain.

**Tips keamanan:** impor hanya dari sumber lokal (relatif atau resource). Impor lewat jaringan membuka jalan eksekusi kode dari luar.

| Kesalahan | Solusi |
|---|---|
| `import 'x.js' as mathUtils` (huruf kecil) | Awali huruf besar |
| Dua berkas dengan qualifier sama | Qualifier unik |
| `as Math` / `as Date` | Dilarang. Beri nama lain |
| Jalur salah → galat saat dimuat | Periksa jalur relatif, dan daftarkan berkas di CMake (2.3.7) |

**Referensi:** [Importing JavaScript Resources in QML](https://doc.qt.io/qt-6/qtqml-javascript-imports.html) · [Import Statements](https://doc.qt.io/qt-6/qtqml-syntax-imports.html)

---

### 2.3.4 Impor antar-berkas JS: modul ES `.mjs` dan `.import` warisan

*Pakailah standar. Ekstensi khusus-pabrikan cepat menua.*

**Modul ES (dianjurkan).** `faktorial.mjs`:
```js
export function faktorial(n) {
    return n <= 1 ? 1 : n * faktorial(n - 1)
}
```
`skrip.mjs`:
```js
import { faktorial } from 'faktorial.mjs'
export { faktorial }

export function laporan(n) {
    return `${n}! = ${faktorial(n)}`
}
```
`Mjs.qml`:
```qml
import QtQml
import 'skrip.mjs' as Skrip

QtObject {
    Component.onCompleted: {
        console.log(Skrip.laporan(5), Skrip.faktorial(4))    // 5! = 120 24
        Qt.quit()
    }
}
```

**Bedah kode:**
- `export function ...`: menandai fungsi sebagai milik antarmuka publik modul. Yang tidak diekspor tetap privat.
- `import { faktorial } from 'faktorial.mjs'`: mengambil nama tertentu. Kurung kurawal memilih nama, `from` menunjuk berkas.
- `export { faktorial }`: mengekspor ulang apa yang diimpor, sehingga pemanggil mendapatnya dari `skrip.mjs`.
- Jalur tanpa `./` mengikuti contoh dokumentasi. Memakai `./faktorial.mjs` `[uji]`.
- Sintaks `import * as X from "f.mjs"` standar hanya berlaku di dalam modul ES, yaitu berkas berekstensi `.mjs`. Untuk menjadikan fungsi tersedia tanpa qualifier, pakai modul ES dan pernyataan `import` tanpa `as`.

**`.import` (warisan, tidak dianjurkan).**
```js
.import 'MathUtils.js' as MU
.import QtQuick 2.0 as Qt2
```
- `.import` adalah ekstensi mesin QML yang bekerja juga di berkas non-modul. Karena sudah digantikan standar, pemakaiannya tidak dianjurkan.
- Bentuk `.import Modul Versi as Qualifier` memuat modul QML, berguna misalnya untuk singleton. Versi yang ditulis bergantung modulnya.
- Skrip yang memakai `.import` tidak mengakses import komponen pemanggilnya.
- `.import` tidak berfungsi pada skrip untuk WorkerScript.
- `Qt.include()` menyisipkan semua fungsi dan variabel berkas lain ke namespace saat ini dan mengabaikan pragma serta import di berkas itu. Fungsi ini usang. Sebuah pemanggilan fungsi tidak seharusnya mengubah konteks pemanggil.

```
 JS lama                        modern
  .import "x.js" as X     ───►   import ... from "x.mjs" / export
  Qt.include("x.js")      ───►   (hindari; usang)
  .pragma library         ───►   tetap sah untuk pustaka stateless
```

**Opsi lain:**

| Kebutuhan | Cara |
|---|---|
| Pustaka terenkapsulasi, ekspor eksplisit | `.mjs` |
| Pustaka stateless sederhana | `.js` + `.pragma library` |
| Impor modul QML dari JS | `.import Modul X.Y as Q` (warisan) |
| Menyisipkan berkas | **Jangan** (`Qt.include` usang) |

| Kesalahan | Solusi |
|---|---|
| `import ... from` di berkas `.js` biasa | Ganti ekstensi menjadi `.mjs` |
| Memakai `.import` di skrip WorkerScript | Tidak berfungsi. Pakai cara lain |
| Mengandalkan `Qt.include` | Migrasi ke `.mjs` |

**Referensi:** [Importing JavaScript Resources: imports within resources](https://doc.qt.io/qt-6/qtqml-javascript-imports.html) · [MDN: JavaScript modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules)

---

### 2.3.5 Pragma dokumen QML

*Arahan kepada mesin harus diucapkan di awal, sebelum urusan lain.*

**Konsep.** `pragma` (tanpa titik) adalah instruksi untuk mesin QML tentang cara menafsirkan dokumen `.qml`. Letaknya di bagian awal dokumen, sebelum pernyataan import dan objek akar.

| Pragma | Nilai (✱ = bawaan) | Sejak |
|---|---|---|
| `Singleton` | – | 5.2 |
| `ListPropertyAssignBehavior` | `Append` ✱, `Replace`, `ReplaceIfNotDefault` | 6.3 |
| `ComponentBehavior` | `Unbound` ✱, `Bound` | 6.4 |
| `FunctionSignatureBehavior` | `Enforced` ✱, `Ignored` | 6.5 |
| `NativeMethodBehavior` | `RejectThisObject` ✱, `AcceptThisObject` | 6.5 |
| `ValueTypeBehavior` | `Reference` ✱ / `Copy` (6.5), `Inaddressable` ✱ / `Addressable` (6.6), `Assertable` (6.8) | 6.5 |
| `Translator` | `<konteks terjemahan>` (bawaan: nama berkas) | 6.7 |

Semua baris di atas bersumber dari tabel resmi Qt 6.12.

#### `pragma Singleton`
`Konfig.qml`:
```qml
pragma Singleton
import QtQml

QtObject {
    readonly property string nama: 'LabQML'
    property int tingkatLog: 1
}
```
- `pragma Singleton`: menjadikan komponen pada akar dokumen sebagai singleton.
- Pragma saja tidak cukup. Bila memakai CMake, qmldir dibuat otomatis oleh `qt_add_qml_module`, dan berkas harus ditandai dengan properti berkas `QT_QML_SINGLETON_TYPE`. `set_source_files_properties` harus dipanggil sebelum `qt_add_qml_module`.
  ```cmake
  set_source_files_properties(Konfig.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
  qt_add_qml_module(appqmllab URI LabQml QML_FILES Main.qml Konfig.qml)
  ```
- Tanpa CMake, qmldir ditulis manual dengan baris `singleton Nama Versi Berkas.qml`. Contoh uji mandiri di subdirektori `config/` yang memiliki `qmldir` berisi `singleton Konfig 1.0 Konfig.qml`, lalu di `Main.qml` tulis `import 'config'` dan akses `Konfig.nama` `[uji]`.
- **Peringatan.** Singleton, setelah dibuat, hidup sampai mesin dihancurkan dan membawa kekurangan keadaan bersama karena menjadi bagian dari keadaan global. Pakai sedikit. Detail di Modul 5.3.

#### `pragma ComponentBehavior: Bound`
```qml
pragma ComponentBehavior: Bound
import QtQuick

ListView {
    id: color
    width: 100; height: 100
    property int r: 12
    model: 1
    delegate: Rectangle {
        Component.onCompleted: console.log(color.r)     // 12
    }
}
Timer { interval: 300; running: true; onTriggered: Qt.quit() }
```
Jalankan dengan `QT_QPA_PLATFORM=offscreen qml Terikat.qml` `[uji]`. Catatan: `Timer` harus berada di dalam akar. Pindahkan ke dalam `ListView { ... }` bila `qml` menolak dua objek akar.

- Pragma ini membatasi komponen bersarang agar hanya membuat objek di konteks asalnya, sehingga `id` dari komponen luar di berkas yang sama aman dipakai dan tooling dapat mengasumsikan tipenya.
- Bila terjadi bentrok nama, `id` di luar komponen terikat mengalahkan properti lokal objek. Pada komponen tak terikat, properti lokal mengalahkan `id` luar. Jadi pada mode `Unbound`, `color.r` yang sama kemungkinan merujuk ke komponen warna `Rectangle` (nilai bawaan putih, `r` = 1) `[uji]`.
- Bawaannya `Unbound`, dan pada versi Qt mendatang bawaan akan berubah menjadi `Bound`. Membiasakan `Bound` sejak sekarang melindungi dari perubahan itu.
- Pada delegate terikat, data model hanya bisa lewat *required properties*, bukan context property seperti `model.myColor`. Pola yang benar:
  ```qml
  delegate: Text {
      required property string modelData
      text: modelData
  }
  ```

#### `pragma FunctionSignatureBehavior`
- Sejak 6.7 anotasi tipe pada fungsi ditegakkan saat pemanggilan. Sebelumnya hanya kompiler skrip QML yang menegakkannya.
- `Ignored` mengembalikan perilaku sebelum 6.7. Akibatnya lebih sedikit kode yang dikompilasi ke C++ lebih awal dan lebih banyak yang diinterpretasi atau di-JIT. Biarkan bawaan (`Enforced`) untuk kode baru.

#### `ListPropertyAssignBehavior`
Menentukan apa yang terjadi saat menugaskan ke properti `list`: bawaan menambah (`Append`), `Replace` selalu mengganti isi, `ReplaceIfNotDefault` mengganti kecuali pada properti default.

#### `NativeMethodBehavior`, `ValueTypeBehavior`, `Translator` (ringkas)
- `NativeMethodBehavior`: memanggil method C++ dengan objek `this` berbeda dari asalnya rusak secara historis. `AcceptThisObject` mengizinkan `this` yang diberikan.
- `ValueTypeBehavior`: `Addressable` mengizinkan casting `a as rect` untuk value type. Jika dipakai dengan `as`, sebaiknya selalu tambahkan `Assertable` (6.8), karena di 6.6 dan 6.7 casting itu keliru ikut membuat nilai baru. `Copy` dan `Reference` adalah opsi eksperimental yang tak dianjurkan.
- `Translator`: `pragma Translator: myTranslationContext` mengatur konteks terjemahan berkas (Modul i18n).

**Tips:** satu pragma per baris di awal berkas. Pakai `ComponentBehavior: Bound` untuk berkas dengan delegate. Jangan menyalin pragma tanpa tahu efeknya.

| Kesalahan | Solusi |
|---|---|
| `.pragma ComponentBehavior: Bound` | Tulis `pragma ComponentBehavior: Bound` di berkas `.qml` |
| Pragma setelah `import` | Pindahkan ke atas |
| `pragma Singleton` tanpa pendaftaran | Tambahkan `QT_QML_SINGLETON_TYPE` (CMake) atau baris `singleton` di qmldir |
| Delegate `Bound` yang memakai `model.x` | Gunakan `required property` |

**Referensi:** [Structure of a QML Document: pragmas](https://doc.qt.io/qt-6/qtqml-documents-structure.html) · [Singletons in QML](https://doc.qt.io/qt-6/qml-singleton.html) · [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html)

---

### 2.3.6 JavaScript vs QML vs C++

*Alat yang tepat membuat pekerjaan sederhana tetap sederhana.*

```
 Hubungan antar-properti?                → binding (QML)                    (2.2.1)
 Respons sekali per peristiwa?           → signal handler (QML)             (2.2.2)
 Logika murni kecil?                     → fungsi di objek / .pragma library / .mjs
 Keadaan bersama berskala aplikasi?      → singleton (QML atau C++)
 Berat, kritis kinerja, akses OS, kripto → C++ (QML_ELEMENT, Q_INVOKABLE)
```

| Alat | Kuat di | Lemah di |
|---|---|---|
| QML (binding) | Hubungan deklaratif, tooling | Logika algoritmik panjang |
| JavaScript | Fleksibel, cepat dituliskan | Berjalan di utas UI; tipe longgar |
| C++ | Kinerja, tipe, keamanan memori terkelola, akses sistem | Siklus kompilasi lebih panjang |

- JS di QML berjalan di utas UI. Komputasi berat membekukan antarmuka (2.1.11).
- Berkas JS yang didaftarkan lewat `QML_FILES` ikut dikompilasi ke bytecode dan di-lint secara otomatis.
- Untuk mengekspos C++ ke QML: [Exposing Attributes of C++ Classes to QML](https://doc.qt.io/qt-6/qtqml-cppintegration-exposecppattributes.html).

**Aturan praktis:** mulai dari QML. Turun ke JS bila perlu. Naik ke C++ bila ukuran, kinerja, atau keamanan menuntutnya. Logika yang menyentuh data sensitif, kripto, atau sistem berkas sebaiknya tidak ada di JS.

**Referensi:** [Integrating QML and JavaScript](https://doc.qt.io/qt-6/qtqml-javascript-topic.html) · [QML and C++ integration](https://doc.qt.io/qt-6/qtqml-cppintegration-topic.html)

---

### 2.3.7 Mendaftarkan JS di CMake dan perkakas `[TAMBAHAN]`

*Berkas yang tak terdaftar tak ikut terkirim, dan Anda baru tahu saat aplikasi sudah di tangan orang lain.*

```cmake
qt_add_qml_module(appqmllab
    URI LabQml
    VERSION 1.0
    QML_FILES
        Main.qml
        Penghitung.qml
        hitung.js
        MathUtils.js
        faktorial.mjs
        skrip.mjs
)
```

**Bedah kode:**
- `qt_add_qml_module(appqmllab ...)`: mendefinisikan modul QML untuk target `appqmllab`.
- `URI LabQml`: nama modul untuk `import`.
- `QML_FILES`: daftar berkas `.qml`, `.js`, dan `.mjs` yang ditambahkan ke modul, termasuk kompilasi ke bytecode dan lint otomatis.
- Berkas yang tak tercantum tidak masuk ke resource. Aplikasi gagal memuatnya saat berjalan.

**Pengaturan per berkas.** Properti berkas seperti `QT_QML_SKIP_QMLLINT` harus diatur sebelum berkas ditambahkan lewat `qt_add_qml_module` atau `qt_target_qml_sources`. Contoh:
```cmake
set_source_files_properties(hitung.js PROPERTIES QT_QML_SKIP_QMLDIR_ENTRY TRUE)
```

**Pilihan lain** (dari dokumentasi `qt_target_qml_sources`):

| Pengaturan | Efek |
|---|---|
| `NO_LINT` / `NO_CACHEGEN` | Mematikan pemeriksaan lint / kompilasi bytecode untuk berkas yang tercantum |
| `QT_QML_SKIP_QMLLINT` | Properti berkas: lewati lint untuk satu berkas |
| `QT_QML_SKIP_CACHEGEN` | Properti berkas: lewati kompilasi bytecode |
| `QT_QML_SKIP_QMLDIR_ENTRY` | Mencegah berkas dicatat sebagai tipe di qmldir, biasanya untuk berkas yang tak membuka tipe publik, seperti berkas JS privat. |
| `qt_target_qml_sources(...)` | Menambah berkas ke modul **setelah** `qt_add_qml_module` |

**Perhatian untuk `MathUtils.js` dari kurikulum.** Untuk berkas JS bernama huruf besar yang bukan modul ES dan bukan pustaka `.pragma library`, pertimbangkan properti `QT_QML_SKIP_QMLDIR_ENTRY`. `MathUtils.js` yang berpragma pustaka aman. Tetapi `hitung.js` yang stateful sebaiknya tidak diberi nama berhuruf besar, atau diberi properti itu.

**Perkakas.** Jalankan `qmllint` (di Arch nama binernya bisa `qmllint6`, cek dengan `pacman -Ql qt6-declarative | grep '/bin/'`) pada `.qml` dan `.js` untuk menangkap kesalahan lebih awal.

| Kesalahan | Solusi |
|---|---|
| Lupa mendaftarkan `.js` | Tambahkan ke `QML_FILES` |
| Properti berkas diatur setelah `qt_add_qml_module` | Atur sebelumnya |
| JS stateful berhuruf besar menimbulkan entri qmldir | Beri `QT_QML_SKIP_QMLDIR_ENTRY` atau ganti nama |
| Mematikan lint demi diam | Perbaiki penyebabnya |

**Referensi:** [qt_target_qml_sources](https://doc.qt.io/qt-6/qt-target-qml-sources.html) · [Singletons in QML](https://doc.qt.io/qt-6/qml-singleton.html) · [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html)

---

## E. Latihan 15 menit dan kunci jawaban

**Latihan (dari kurikulum):** buat `MathUtils.js`, panggil dari `Main.qml`, lalu jelaskan konsekuensi bila `.pragma library` dihapus.

```js
// MathUtils.js
.pragma library
function clamp(nilai, min, max) { return Math.min(Math.max(nilai, min), max) }
```
```qml
// Main.qml
import QtQml
import 'MathUtils.js' as MathUtils
QtObject { Component.onCompleted: { console.log(MathUtils.clamp(15, 0, 10)); Qt.quit() } }   // 10
```

**Konsekuensi menghapus `.pragma library`:**
1. Fungsi `clamp` tetap bekerja dengan hasil yang sama, karena murni.
2. Tetapi setiap instans komponen mendapat salinan JS-nya sendiri, jadi lebih banyak memori dan instansiasi lebih lambat.
3. Keadaan (jika ada) tidak lagi dibagi.
4. Berkas bisa membaca scope komponen pemanggil, selama tidak ada `.import`. Kopling tersembunyi muncul.

**Cek pemahaman:**
1. *Apa beda `.pragma library` dan `pragma Singleton`?* Yang pertama arahan berkas `.js` untuk pustaka stateless bersama. Yang kedua arahan berkas `.qml` yang menjadikan tipe singleton dan perlu pendaftaran di CMake atau qmldir.
2. *Mengapa `.pragma library` tak boleh memakai `id` QML?* Karena ia satu salinan bersama dan tidak berjalan di scope instans mana pun.
3. *Mengapa lebih baik memakai `.mjs` daripada `.import`?* `.mjs` adalah standar ECMAScript dengan ekspor eksplisit, sedangkan `.import` ekstensi yang sudah digantikan dan tidak dianjurkan.

**Tantangan:** ubah `hitung.js` dari 2.3.1 agar menerima nama sebagai parameter dan jadikan `.pragma library`. Pastikan hasil `1 2 3` dan `ambil()` tetap berfungsi tanpa kopling tersembunyi.

---

## F. Glosarium Modul 2.3

| Istilah | Arti |
|---|---|
| Code-behind | Berkas JS yang menjadi logika milik satu komponen |
| Stateful / stateless | Menyimpan keadaan / tidak menyimpan keadaan |
| `.pragma library` | Arahan JS: jadikan berkas pustaka stateless bersama |
| `pragma` (dokumen) | Arahan untuk mesin pada berkas `.qml` |
| Qualifier | Nama awalan huruf besar pada `import ... as` |
| Modul ES (`.mjs`) | Berkas JS bergaya standar dengan `export`/`import` |
| `.import` | Ekstensi QML untuk impor di dalam `.js`; warisan |
| Singleton | Objek yang dibuat sekali per mesin |
| qmldir | Berkas deskripsi modul QML (tipe, singleton, versi) |
| `Bound` / `Unbound` | Komponen terikat / tak terikat pada konteks asalnya |
| Delegate | Komponen templat yang dibuat per item oleh `ListView`, `Repeater`, dll |
| Required property | Properti yang wajib diisi pembuatnya |
| Bytecode / cachegen | Kompilasi JS/QML ke bentuk siap-jalan saat build |
| Lint | Pemeriksaan statis kode |
| Resource prefix | Awalan jalur berkas di dalam resource aplikasi |

---

## G. Hubungan dengan modul lain

| Modul | Hubungan |
|---|---|
| **2.1** Dasar JavaScript | Sintaks `export`, `import`, dan fungsi murni berasal dari sana |
| **2.2** JavaScript di dokumen QML | Fungsi pembantu dipindahkan ke `.js`; `this` di berkas JS tak terdefinisi |
| **2.4** Lingkungan host | `WorkerScript` dan batas `.import`, `Qt`, `XMLHttpRequest` |
| **3.x** Properti dan binding | `required property` dan `ComponentBehavior: Bound` bertemu dengan model-delegate |
| **5.3** Singleton | Pendalaman `pragma Singleton`, `qmldir`, dan C++ `QML_SINGLETON` |
| **13.1** Keamanan | Larangan impor dari jaringan, jejak keadaan bersama, dan batas JS |

**Prasyarat Modul 2.4:** menguasai 2.3.1 sampai 2.3.5. Bagian 2.3.7 diperlukan begitu Anda memakai CMake.

---

**Catatan tautan:** halaman Qt yang saya buka langsung adalah Defining dan Importing JavaScript Resources, Structure of a QML Document, serta `qt_target_qml_sources`. Halaman Singletons in QML saya baca lewat pencarian, dan cuplikannya berasal dari beberapa versi dokumentasi. Tautan MDN dan halaman lain tidak saya buka satu per satu. Bila ada yang tidak terbuka, kabari saya.

# Fase 2 · Modul 2.4 — Lingkungan Host JavaScript dan Batasnya

Saya membaca ulang bagian Modul 2.4 dari berkas kurikulum dan mengaudit isinya terhadap dokumentasi Qt 6.12. Yang saya periksa: JavaScript Host Environment, QML Global Object, objek `Qt`, XMLHttpRequest, Settings, Console API, LocalStorage, dan Timer. Saya tidak menjalankan kode ini pada Qt, jadi bagian bertanda `[uji]` perlu Anda buktikan sendiri.

---

## A. Audit singkat

**Terverifikasi:**
- QML tidak menyediakan objek `window` maupun API DOM seperti di peramban, dan runtime-nya mengimplementasikan ECMAScript edisi ke-7.
- Secara bawaan `XMLHttpRequest` tidak bisa membaca berkas lokal. Untuk mengaktifkannya, variabel lingkungan perlu diset ke `1`, dan fitur itu hanya boleh dipakai bila aplikasi menjalankan kode QML/JS tepercaya.
- `Settings` memakai `import QtCore` dan tersedia sejak Qt 6.5. Label `[≥6.5]` di kurikulum benar.
- `QtQuick.LocalStorage` adalah tipe singleton untuk membaca dan menulis basis data SQLite.

**Perlu dikoreksi atau dilengkapi:**
1. **`Qt.callLater` bukan penunda waktu.** Tabel kurikulum menulis "Menunda aksi: `Timer`, `Qt.callLater`". `Qt.callLater` memanggil fungsi nanti, setelah mesin kembali ke event loop, dan beberapa pemanggilan berturut-turut dengan fungsi yang sama hanya dijalankan sekali. Ia menunda *giliran* dan menghapus duplikat, bukan menunda *durasi*.
2. **Variabel `QML_XHR_ALLOW_FILE_WRITE` hilang.** Selain `QML_XHR_ALLOW_FILE_READ`, ada variabel untuk menulis berkas. XHR di QML juga tidak menegakkan same-origin policy. Ini implikasi keamanan penting.
3. **Penyempurnaan atas 2.1.1.** Di sana saya menulis larangan variabel global implisit secara umum. Dokumentasi lebih tepat: kode JavaScript di berkas `.qml` tidak boleh mengubah objek global, tetapi kode di berkas `.js` boleh, dan perubahannya terlihat oleh berkas `.qml` yang mengimpornya. Kode "global" di berkas `.js` berjalan pada scope tereduksi: hanya berkas itu sendiri dan objek global, tanpa akses ke objek QML. Kesimpulan praktisnya tetap: selalu deklarasikan variabel.
4. **Objek global yang tidak tercantum di kurikulum.** Selain objek `Qt`, ada keluarga `qsTr()`, fungsi `gc()`, fungsi `print()`, objek `console`, serta `XMLHttpRequest` dan `DOMException`. Dari objek `Qt` yang relevan untuk modul ini: `Qt.exit(kode)`, `Qt.application`, `Qt.platform`, `Qt.formatDateTime`, `Qt.locale`.
5. **`Qt.application` tanpa GUI.** Pada QML tanpa `QGuiApplication`, properti `application.active`, `state`, `layoutDirection`, dan `font` tidak terdefinisi. Ini mengenai laboratorium `qml -a core` kita.
6. **Console API lebih luas.** Ada `log/debug/info/warn/error`, `assert`, `time/timeEnd`, `trace`, `count`, `profile/profileEnd`, dan `exception`. Keluarannya memakai kategori log `qml` atau `js`, tergantung jenis berkas yang mencatat.
7. **LocalStorage tidak terisolasi.** Basis datanya khusus pengguna dan khusus QML, tetapi dapat diakses semua aplikasi QML. Jadi bukan tempat rahasia.
8. **Settings.** Berbasis QSettings, memakai berkas INI teks biasa pada Unix, dan tanpa notifikasi perubahan antar-instans `Settings`.
9. **Salah ketik di dokumentasi Qt.** Contoh `Qt.formatDateTime` memakai `new Date(2001, 5, 21, 14, 13, 9)` tetapi hasilnya ditulis "21.05.2001". Indeks bulan JavaScript dimulai dari 0, jadi `5` adalah **Juni**. Gunakan `4` untuk Mei.
10. **Catatan versi.** `Qt.escapeHtml` baru ada sejak 6.12, dan varian `atob`/`btoa` dengan `ArrayBuffer` sejak 6.11.

**TAMBAHAN:** **2.4.0** laboratorium uji lingkungan host, dan **2.4.8** pola asinkron tanpa `async/await` (kurikulum mencantumkan `Promise` dan *event loop* di terminologi tetapi tanpa sub-bab).

---

## B. Daftar isi Modul 2.4 (diperbarui)

- **2.4.0** Laboratorium: menguji isi lingkungan host `[TAMBAHAN]`
- **2.4.1** Yang tersedia (+ `print`, `gc`, `DOMException`, `qsTr`) `[diperluas]`
- **2.4.2** Yang tidak ada
- **2.4.3** Objek `Qt` (+ `callLater`, `exit`, `application`, `platform`, format tanggal) `[diperluas]`
- **2.4.4** `console` (+ kategori log, filter) `[diperluas]`
- **2.4.5** XHR dan `QML_XHR_ALLOW_FILE_READ`/`WRITE` `[diperluas]`
- **2.4.6** Penyimpanan data: `Settings` dan `LocalStorage`
- **2.4.7** `Timer` vs penunda lain
- **2.4.8** Pola asinkron: callback, sinyal, `Promise` `[TAMBAHAN]`
- Ringkasan keamanan · Latihan dan kunci jawaban · Glosarium · Hubungan dengan modul lain

**Urutan belajar yang disarankan:** 2.4.0 → 2.4.1 → 2.4.2 → 2.4.4 → 2.4.3 → 2.4.7 → 2.4.8 → 2.4.5 → 2.4.6.

---

## C. Peta besar

```
   Kode JavaScript Anda
          │
          ▼
 ┌────────────────────────────────────────────────────┐
 │ ECMAScript edisi ke-7 (Object Array JSON Math Date │
 │ Promise Map Set ...)                               │
 ├────────────────────────────────────────────────────┤
 │ Objek tuan rumah QML (selalu ada, tanpa import):   │
 │ Qt  console  print  gc  qsTr…  XMLHttpRequest      │
 │ DOMException                                       │
 ├────────────────────────────────────────────────────┤
 │ Jenis tipe QML (perlu import): Timer (QtQml)       │
 │ Settings (QtCore)  LocalStorage (QtQuick.Local…)   │
 └────────────────────────────────────────────────────┘
   ✗ TIDAK ADA: window  document  DOM  localStorage global
```

**Filosofinya:** JavaScript di QML adalah *tamu dengan perabot yang dipilihkan tuan rumah*. Karena perabotnya sedikit dan eksplisit, permukaan serangannya juga lebih kecil daripada di peramban. Tugas Anda memahami persis apa yang dipinjamkan, dan tidak membuka pintu tambahan (variabel lingkungan XHR, basis data bersama) tanpa alasan.

---

## D. Materi

### 2.4.0 Laboratorium: menguji isi lingkungan host `[TAMBAHAN]`

*Dokumen memberi tahu. Mesin Anda membuktikan.*

Simpan sebagai `host.qml`, jalankan `qml -a core host.qml`:
```qml
import QtQml

QtObject {
    function ada(nama: string) : string {
        return String(eval('typeof ' + nama))
    }

    Component.onCompleted: {
        const daftar = ['Qt', 'console', 'print', 'gc', 'qsTr', 'XMLHttpRequest', 'DOMException',
                        'JSON', 'Math', 'Date', 'Promise', 'Map', 'Set',
                        'document', 'window', 'fetch', 'setTimeout', 'setInterval',
                        'localStorage', 'require', 'process', 'globalThis', 'URL',
                        'structuredClone', 'queueMicrotask']
        for (const n of daftar) console.log(n.padEnd(16), ada(n))
        Qt.quit()
    }
}
```

**Bedah kode:**
- `eval('typeof ' + nama)`: membentuk ekspresi `typeof Qt`, `typeof document`, dan seterusnya. `typeof` pada nama yang tidak ada mengembalikan `'undefined'` tanpa galat. `eval` hanya aman di sini karena daftar nama berasal dari kode kita sendiri.
- `for (const n of daftar)`: perulangan nilai array (2.1.11). `n.padEnd(16)` meratakan kolom.

**Dugaan berdasarkan dokumen (bukan hasil uji):**

| Nama | Dugaan |
|---|---|
| `Qt`, `console`, `print`, `gc`, `qsTr`, `XMLHttpRequest`, `DOMException` | ada (terdokumentasi sebagai objek global) |
| `JSON`, `Math`, `Date`, `Promise`, `Map`, `Set` | ada (daftar objek resmi) |
| `document`, `window` | `undefined` (tidak ada di QML) |
| `localStorage`, `require`, `process` | tak terdokumentasi `[uji]` |
| `fetch`, `setTimeout`, `setInterval`, `URL`, `structuredClone`, `queueMicrotask`, `globalThis` | tak terdokumentasi `[uji]` |

Simpan hasilnya sebagai catatan versi Qt Anda. Itulah "peta pasti" yang berlaku bagi aplikasi Anda.

---

### 2.4.1 Yang tersedia

*Kenali perabot yang dipinjamkan, supaya tak mencari yang tidak ada.*

**Konsep.** Objek dan fungsi tuan rumah berikut selalu tersedia dari semua kode JavaScript di QML tanpa import: objek `Qt`, `qsTr()` dan kawan-kawannya, `gc()`, `print()`, objek `console`, serta `XMLHttpRequest` dan `DOMException`.

| Kelompok | Isi | Dibahas |
|---|---|---|
| Standar ECMAScript | `Object Array String Number Math Date RegExp JSON Map Set Promise Symbol` … | Modul 2.1 |
| Perluasan Qt pada bawaan | fungsi `arg()` pada `String`, serta fungsi konversi sadar-locale pada `Date` dan `Number` | 2.1.6 |
| Objek `Qt` | utilitas, enum, `callLater`, `quit`, `application`, `platform` | 2.4.3 |
| `console`, `print` | pencatatan | 2.4.4 |
| `XMLHttpRequest`, `DOMException` | HTTP | 2.4.5 |
| `qsTr`, `qsTranslate`, `qsTrId` | terjemahan | modul i18n |
| `gc()` | memicu pengumpul sampah | di bawah |

- `print(...)`: mencetak ke konsol, mirip `console.log`. Pilih `console.log` karena punya kategori dan tingkat.
- `gc()`: menjalankan garbage collector, setara `QJSEngine::collectGarbage()`. Untuk uji kebocoran, bukan untuk kode produksi.
- Perluasan sadar-locale `Date`/`Number`: lihat [Date](https://doc.qt.io/qt-6/qml-qtqml-date.html) dan [Number](https://doc.qt.io/qt-6/qml-qtqml-number.html).

**Tipe QML bukan objek global.** `Timer`, `Settings`, dan `LocalStorage` membutuhkan `import`. Beda objek global dan tipe QML penting untuk menjawab "kenapa `Timer` tidak ditemukan".

**Opsi lain:**

| Kebutuhan | Opsi |
|---|---|
| Mencetak | `console.log` (utama), `print` |
| Terjemahan | `qsTr` (default), `qsTranslate`, `qsTrId` |
| Memeriksa tipe | `typeof`, `instanceof` (diperluas untuk tipe QML), `Qt.isQtObject(x)` |

| Kesalahan | Solusi |
|---|---|
| Mengira semua yang ada di MDN tersedia | Cek 2.4.0 di mesin Anda |
| `Timer` tak dikenali | `import QtQml` |
| Memakai `gc()` untuk "memperbaiki" kinerja | Perbaiki akar masalah |

**Referensi:** [QML Global Object](https://doc.qt.io/qt-6/qtqml-javascript-qmlglobalobject.html) · [JavaScript Host Environment](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html) · [List of JavaScript Objects and Functions](https://doc.qt.io/qt-6/qtqml-javascript-functionlist.html)

---

### 2.4.2 Yang tidak ada

*Mengetahui apa yang tidak ada sama berharganya dengan mengetahui apa yang ada.*

**Konsep.** Tidak ada peramban, jadi tidak ada `window`, `document`, atau DOM. Dokumentasi juga menyarankan memeriksa apakah sebuah fungsi bagian dari standar ECMAScript atau khusus peramban, karena banyak referensi JavaScript difokuskan pada peramban.

| Kebiasaan peramban | Padanan di QML |
|---|---|
| `document.getElementById('x')` | `id: x` lalu rujuk langsung `x` |
| `window.setTimeout(fn, 1000)` | `Timer` (2.4.7) |
| `fetch(url)` | `XMLHttpRequest` (2.4.5) |
| `localStorage.setItem(k, v)` | `Settings` / `LocalStorage` (2.4.6) |
| `alert(...)` | `console.log`, atau dialog QtQuick Controls |
| `require()` / `import` Node | `import 'x.mjs' as X` (Modul 2.3) |
| `window.location` | `Qt.resolvedUrl`, `Qt.openUrlExternally` |

**Pembatasan lain yang sudah Anda kenal:**
- Kode di berkas `.qml` tidak boleh mengubah objek global, jadi membuat variabel tanpa deklarasi menimbulkan exception. Kode di berkas `.js` boleh, dan perubahannya tampak di `.qml`. Tetap saja, jangan memanfaatkan itu.
- Kode global di `.js` berjalan di scope tereduksi tanpa akses ke objek QML, sehingga kode awal aplikasi harus diletakkan di `Component.onCompleted`. (2.2.6)
- `this` tidak terdefinisi di sebagian besar konteks. (2.2.4)

**Tips:** bila Anda menemukan snippet web, tanyakan: *apakah ini ECMAScript murni atau API peramban?* Jangan salin yang kedua.

| Kesalahan | Solusi |
|---|---|
| `document.getElementById` | Pakai `id` |
| `localStorage` global | `Settings` atau `LocalStorage` |
| Menyalin `fetch(...).then(...)` | Pakai XHR atau bungkus dengan `Promise` (2.4.8) |

**Referensi:** [JavaScript Host Environment](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html) · [MDN: JavaScript reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference)

---

### 2.4.4 `console`

*Anda tidak bisa memperbaiki yang tak terlihat. Catatlah dengan disiplin.*

```qml
import QtQml

QtObject {
    Component.onCompleted: {
        console.log('nilai:', 42, JSON.stringify({ a: 1 }))
        console.warn('peringatan')
        console.error('galat')
        console.assert(1 + 1 === 3, 'asersi gagal')
        console.count('hitung'); console.count('hitung')
        console.time('kerja')
        let s = 0
        for (let i = 0; i < 100000; i++) s += i
        console.timeEnd('kerja')
        console.trace()
        Qt.quit()
    }
}
```

**Bedah kode:**
- `console.log(a, b, c)`: argumen digabung dengan spasi. Untuk objek, serialkan dengan `JSON.stringify` agar cetakannya pasti.
- `console.warn`, `console.error`: tingkat lebih tinggi, dan mudah disaring.
- `console.assert(kondisi, pesan)`: menguji bahwa ekspresi benar. Bila tidak, ia menulis pesan opsional dan mencetak jejak tumpukan.
- `console.count('hitung')`: mencetak berapa kali kode itu berjalan, mis. `f called: 1`, `f called: 2`. Keluaran contoh kita: `hitung: 1`, `hitung: 2`.
- `console.time` / `timeEnd`: mencatat waktu dalam milidetik di antara keduanya, dengan string pengenal.
- `console.trace()`: mencetak jejak tumpukan eksekusi JavaScript, dibatasi 10 frame terakhir.

**Kategori dan filter.** Keluaran memakai kategori log `qml` atau `js` tergantung jenis berkasnya, lewat mekanisme `qCDebug/qCWarning/qCCritical`. Karena itu bisa disaring dari terminal `[uji]`:
```bash
QT_LOGGING_RULES='js.debug=false' qml -a core Main.qml                  # senyapkan log dari berkas .js
QT_MESSAGE_PATTERN='[%{time hh:mm:ss}] %{category} %{type}: %{message}' qml -a core Main.qml
```
- `QT_LOGGING_RULES`: aturan filter `kategori.tingkat=true|false`.
- `QT_MESSAGE_PATTERN`: pola format keluaran, standar Qt.

**Kategori kustom.** Kategori log dapat diberikan sebagai argumen pertama ke fungsi `console`. Dengan tipe `LoggingCategory` `[uji]`:
```qml
LoggingCategory { id: logLab; name: 'lab.demo' }
// ...
console.log(logLab, 'pesan dari kategori saya')
```

**Opsi lain:**

| Tujuan | Opsi |
|---|---|
| Pesan biasa | `console.log` / `debug` / `info` |
| Masalah | `console.warn` / `error` |
| Jejak asal | `console.trace` / `exception` |
| Pengukuran | `console.time`, `console.profile` (profiler) |
| Debugger penuh | `-qmljsdebugger` (lihat peringatan di bawah) |

**Peringatan keamanan:** mengaktifkan infrastruktur debugging dapat membahayakan integritas aplikasi dan sistem, sehingga hanya boleh di lingkungan terkendali. Jangan mencatat token, kata sandi, atau data pribadi ke log. Log sering berakhir di berkas, jurnal sistem, atau laporan galat.

| Kesalahan | Solusi |
|---|---|
| `console.log(obj)` mencetak tak terduga | `JSON.stringify(obj)` |
| Log berlebihan di binding (dicetak setiap evaluasi) | Pindahkan ke handler |
| Rahasia ikut tercatat | Sunting sebelum mencatat |

**Referensi:** [Debugging QML Applications: Console API](https://doc.qt.io/qt-6/qtquick-debugging.html#console-api) · [QLoggingCategory](https://doc.qt.io/qt-6/qloggingcategory.html) · [LoggingCategory (QML)](https://doc.qt.io/qt-6/qml-qtqml-loggingcategory.html)

---

### 2.4.3 Objek `Qt`

*Satu objek, banyak alat. Kenali yang benar-benar Anda butuhkan.*

```qml
import QtQml

QtObject {
    property int dipanggil: 0
    function perbarui() { dipanggil++ }

    Component.onCompleted: {
        console.log(Qt.platform.os)                                                       // linux
        console.log(Qt.md5('halo').length)                                                // 32
        console.log(Qt.formatDateTime(new Date(2026, 10, 16, 14, 5, 9), 'dd.MM.yyyy hh:mm:ss'))
        // 16.11.2026 14:05:09  (bulan 10 = November, indeks mulai 0)
        console.log(Qt.locale('id_ID').name)                                              // id_ID [uji]

        Qt.callLater(perbarui); Qt.callLater(perbarui); Qt.callLater(perbarui)
        console.log('sebelum event loop:', dipanggil)                                      // 0
        Qt.callLater(() => { console.log('sesudah:', dipanggil); Qt.quit() })             // sesudah: 1
    }
}
```

**Bedah kode:**
- `Qt.platform.os`: nama sistem operasi, dengan nilai seperti `"linux"`, `"windows"`, `"osx"`, `"android"`. Dengan `-a core`, ketersediaan `Qt.platform` `[uji]`.
- `Qt.md5(data)`: mengembalikan string heksadesimal hash MD5. MD5 rusak untuk keamanan, jadi hanya untuk checksum atau kunci cache, **bukan** kata sandi atau tanda tangan.
- `Qt.formatDateTime(tanggal, format)`: format memakai ekspresi seperti `dd`, `MM`, `yyyy`, `hh`, `mm`, `ss`.
- `Qt.locale('id_ID')`: mengembalikan objek locale dengan format nama `bahasa[_wilayah]`. Bila nama tak valid, locale "C" dipakai.
- `Qt.callLater(fn)`: dijalankan setelah mesin kembali ke event loop. Pemanggilan berturut-turut dengan fungsi yang sama hanya dijalankan sekali, dan bila ada duplikat, hanya argumen terakhir yang diteruskan. Tiga panggilan `perbarui` menghasilkan satu eksekusi, jadi `dipanggil` bernilai 1.

**Fungsi `Qt` yang penting, per kebutuhan:**

| Kebutuhan | Fungsi | Catatan |
|---|---|---|
| Keluar | `Qt.quit()` | Menghentikan aplikasi (di alat `qml`) |
| Keluar dengan kode | `Qt.exit(kode)` | Di alat `qml` membuat peluncur keluar dengan kode itu. Cocok untuk skrip CLI |
| Argumen/identitas aplikasi | `Qt.application.*` | Beberapa properti tak terdefinisi tanpa `QGuiApplication`. |
| Tanggal | `Qt.formatDate/DateTime/Time` | Gunakan indeks bulan mulai 0 pada `new Date` |
| URL relatif | `Qt.resolvedUrl('x')` | Relatif ke dokumen pemanggil |
| Teks aman HTML | `Qt.escapeHtml(s)` | `[≥6.12]` |
| Pengodean | `Qt.btoa`, `Qt.atob` | Basis64 itu *pengodean*, bukan enkripsi. Varian `ArrayBuffer` `[≥6.11]` |
| Memori | `Qt.gc()` | Untuk uji |

**Fungsi `Qt` yang berbahaya bila salah dipakai:**
- `Qt.openUrlExternally(url)`: meneruskan URL ke aplikasi eksternal; dokumentasi memperingatkan bahwa URL tak tepercaya bisa berakibat tak terduga dan menyarankan memeriksa `protocol` terhadap daftar yang diizinkan. Terapkan daftar putih, mis. hanya `https:`.
- `Qt.createQmlObject(string, ...)`: sangat lambat karena mengompilasi string QML setiap kali, dan mudah menghasilkan QML tak valid. Jangan merakit QML dari masukan tak tepercaya. Pakai komponen terpisah.

**Opsi lain:**

| Pola | Kapan |
|---|---|
| `Qt.callLater(fn)` | Menggabungkan pembaruan beruntun (misalnya perhitungan ulang tata letak) |
| `Timer { interval: 0 }` | Menunda satu giliran tetapi lewat objek yang bisa dihentikan |
| Langsung panggil | Bila tak perlu menunda |

| Kesalahan | Solusi |
|---|---|
| `Qt.callLater` dikira "tunggu 1 detik" | Pakai `Timer` |
| `new Date(2001, 5, 21)` dikira Mei | Indeks bulan mulai 0, jadi 5 adalah Juni |
| `Qt.md5` untuk hash kata sandi | Pakai pustaka kripto yang tepat (C++) |
| `Qt.application.active` undefined | Pakai `-a gui` atau jangan mengandalkannya |

**Referensi:** [Qt QML Type](https://doc.qt.io/qt-6/qml-qtqml-qt.html) · [Date](https://doc.qt.io/qt-6/qml-qtqml-date.html) · [Locale](https://doc.qt.io/qt-6/qml-qtqml-locale.html)

---

### 2.4.7 `Timer` vs penunda lain

*Menunggu adalah keputusan desain, bukan kebetulan.*

```qml
import QtQml

QtObject {
    id: root
    property int tik: 0

    Timer {
        interval: 300; repeat: true; running: true
        onTriggered: { root.tik += 1; console.log('tik', root.tik) }
    }
    Timer {
        interval: 1000; running: true
        onTriggered: { console.log('satu detik berlalu'); Qt.quit() }
    }
}
```
Keluaran yang diharapkan: `tik 1`, `tik 2`, `tik 3`, lalu `satu detik berlalu`.

**Bedah kode:**
- `Timer { ... }`: tipe dari `QtQml`. Dapat memicu aksi sekali atau berulang pada interval tertentu.
- `interval: 300`: interval dalam milidetik, bawaan 1000.
- `repeat: true`: bila true, pemicuan berulang. Bila tidak, timer memicu sekali lalu berhenti (`running` menjadi false). Bawaan `repeat` adalah false.
- `running: true`: menyalakan timer. Bawaannya false.
- `onTriggered`: handler sinyal `triggered()`.
- Timer kedua bersifat *sekali pakai* (one-shot) dan memanggil `Qt.quit()` setelah satu detik. Ini jawaban latihan kurikulum.

**Sifat penting:**
- Timer disinkronkan dengan timer animasi (umumnya 60 fps), sehingga resolusinya paling baik sekitar 16 ms. Bukan untuk pengukuran presisi tinggi. Gunakan selisih `Date.now()` untuk durasi nyata.
- Bila properti diubah saat timer berjalan, waktu yang telah berlalu direset.
- `triggeredOnStart: true` membuat timer langsung memicu saat dimulai. Bila `repeat` false, ia memicu dua kali: saat mulai dan setelah interval.
- `restart()`: bila belum berjalan, dimulai. Bila sudah, dihentikan, direset, lalu dimulai lagi.

**Pola debounce** (satu pencarian meski masukan berubah cepat):
```qml
import QtQml

QtObject {
    id: root
    property string kueri: ''
    onKueriChanged: debounce.restart()

    Timer {
        id: debounce
        interval: 200
        onTriggered: { console.log('cari:', root.kueri); Qt.quit() }
    }
    Component.onCompleted: { kueri = 'k'; kueri = 'ko'; kueri = 'kop' }    // tiga perubahan cepat
}
```
Keluaran: satu baris `cari: kop`.

**Opsi lain, menunda atau menjadwalkan:**

| Cara | Sifat |
|---|---|
| `Timer` sekali pakai | Menunggu durasi tertentu |
| `Timer` berulang | Denyut berkala |
| `Qt.callLater(fn)` | Giliran berikutnya, bukan durasi |
| `setTimeout` / `setInterval` | Tak terdokumentasi `[uji]` |
| `PauseAnimation` (QtQuick) | Jeda di dalam rangkaian animasi |
| `Qt.createQmlObject` untuk Timer baru | **Hindari**: lambat |
| `QTimer` di C++ | Ketepatan lebih baik, logika di luar QML |

| Kesalahan | Solusi |
|---|---|
| `running: true` tanpa mematikannya saat tak perlu | Matikan, atau gunakan one-shot |
| Mengubah `interval` di tengah jalan lalu heran waktunya reset | Itu perilaku terdokumentasi |
| Handler berat di `onTriggered` | Menahan UI. Pecah kerjanya |
| Menghitung durasi dengan jumlah tik | Pakai selisih `Date.now()` |

**Referensi:** [Timer](https://doc.qt.io/qt-6/qml-qtqml-timer.html) · [Qt.callLater](https://doc.qt.io/qt-6/qml-qtqml-qt.html#callLater-method)

---

### 2.4.8 Pola asinkron: callback, sinyal, `Promise` `[TAMBAHAN]`

*Dunia tidak menunggu Anda, jadi biarkan pekerjaan lambat memanggil Anda kembali.*

**Konsep.** Antarmuka QML berjalan di satu utas dengan *event loop*. Pekerjaan lambat (jaringan, timer) tidak boleh memblokirnya, jadi hasilnya datang belakangan lewat **callback**, **sinyal**, atau **Promise**. Seperti dicatat di audit 2.1.9, `async/await` tidak terkonfirmasi didukung. `Promise` dengan `.then` tercantum di daftar objek resmi.

```
 kode Anda ─ memulai pekerjaan ─► (event loop jalan terus, UI tetap hidup)
                                       │ selesai
 callback / sinyal / .then ◄───────────┘
```

**Membungkus Timer menjadi Promise** `[uji]`:
```qml
import QtQml

QtObject {
    property var penyelesai: null

    Timer {
        id: pewaktu
        interval: 300
        onTriggered: {
            const selesai = penyelesai
            penyelesai = null
            if (selesai) selesai('selesai')
        }
    }

    function tunggu() {
        return new Promise(resolve => { penyelesai = resolve; pewaktu.start() })
    }

    Component.onCompleted: {
        tunggu().then(hasil => { console.log(hasil); Qt.quit() })
    }
}
```

**Bedah kode:**
- `new Promise(resolve => {...})`: *Promise* mewakili hasil yang belum ada. Fungsi di dalamnya menerima `resolve`, yang dipanggil nanti dengan hasilnya.
- `penyelesai = resolve`: menyimpan `resolve` agar Timer bisa memanggilnya. `property var` menyimpan fungsi `[uji]`.
- `.then(hasil => ...)`: dijalankan ketika Promise terpenuhi.
- Hasilnya: setelah sekitar 300 ms tercetak `selesai`.

**Opsi lain untuk logika "tunggu lalu lakukan":**

| Cara | Kapan |
|---|---|
| Callback langsung (gaya XHR, 2.4.5) | Sederhana, tanpa lapisan tambahan |
| Sinyal + handler (2.2.2) | Hasil dipakai banyak pihak |
| `Promise` + `.then` | Merangkai beberapa langkah berurutan `[uji]` |
| `async`/`await` | Tak terkonfirmasi, uji dulu (2.1.9) |
| C++ + sinyal | Pekerjaan berat atau utas terpisah |

| Kesalahan | Solusi |
|---|---|
| Memblokir dengan perulangan kosong menunggu hasil | Biarkan event loop berjalan |
| Menggunakan `await` tanpa menguji | Uji di 2.1.9 atau pakai `.then` |
| Callback dipanggil dua kali atau tidak sama sekali | Uji semua jalur (sukses, gagal, batas waktu) |
| Lupa menangani penolakan (`reject`/`.catch`) | Selalu sediakan jalur gagal |

**Referensi:** [MDN: Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) · [javascript.info: Promise](https://javascript.info/promise-basics)

---

### 2.4.5 XHR dan `QML_XHR_ALLOW_FILE_READ`/`WRITE`

*Jaringan adalah perbatasan. Perlakukan setiap respons sebagai tak tepercaya.*

Siapkan server uji lokal yang hanya melayani `127.0.0.1`:
```bash
mkdir -p ~/lab-24/www && cd ~/lab-24
printf '{"nama":"Kopi","harga":15000}\n' > www/data.json
python -m http.server 8000 --bind 127.0.0.1 --directory www &
qml -a core Xhr.qml
kill %1
```
- `--bind 127.0.0.1`: hanya menerima koneksi dari mesin sendiri.
- `&` dan `kill %1`: jalankan di latar belakang, lalu hentikan setelah selesai.

`Xhr.qml`:
```qml
import QtQml

QtObject {
    function ambilJson(url, sukses, gagal) {
        const req = new XMLHttpRequest()
        req.onreadystatechange = function () {
            if (req.readyState !== XMLHttpRequest.DONE) return
            if (req.status !== 200) { gagal('HTTP ' + req.status); return }
            try { sukses(JSON.parse(req.responseText)) }
            catch (e) { gagal('JSON rusak: ' + e.name) }
        }
        req.open('GET', url)
        req.send()
    }

    Component.onCompleted: ambilJson('http://127.0.0.1:8000/data.json',
        data  => { console.log(data.nama, data.harga); Qt.quit() },       // Kopi 15000
        pesan => { console.log('gagal:', pesan); Qt.quit() })
}
```

**Empat langkah dari dokumentasi:** (1) buat objek `XMLHttpRequest`, (2) pasang fungsi callback pada `onreadystatechange`, (3) panggil `open()` dengan metode HTTP dan URL, (4) panggil `send()`.

**Bedah kode:**
- `req.onreadystatechange = function () {...}`: callback dipanggil setiap `readyState` berubah. Praktik baiknya memeriksa `readyState` sama dengan `DONE` sebelum membaca `response`, `responseText`, atau `responseXML`.
- `XMLHttpRequest.DONE`: konstanta keadaan "selesai". Konstanta lain: `UNSENT`, `OPENED`, `HEADERS_RECEIVED`, `LOADING`.
- `req.status !== 200`: kode HTTP. Nilai 0 umumnya berarti kegagalan jaringan.
- `JSON.parse(req.responseText)` dibungkus `try/catch`: respons tak tepercaya harus ditangani kegagalan parse-nya (2.1.8).
- `req.open('GET', url)`: parameter ketiga `async` bernilai true secara bawaan, jadi permintaan bersifat asinkron.
- Fungsi `sukses`/`gagal` dikirim sebagai callback: pola 2.4.8.

**Keadaan `readyState`:**
```
 UNSENT ─open()─► OPENED ─send()─► HEADERS_RECEIVED ─► LOADING ─► DONE
```

**Akses berkas lokal (dimatikan bawaan).** Secara bawaan XHR tidak bisa membaca sistem berkas lokal. Untuk membukanya, atur variabel lingkungan `QML_XHR_ALLOW_FILE_READ` dan/atau `QML_XHR_ALLOW_FILE_WRITE` ke `1`, dan hanya bila aplikasi menjalankan kode tepercaya.
```bash
QML_XHR_ALLOW_FILE_READ=1 qml -a core Berkas.qml
```
Contoh isi `Berkas.qml` (`req.open('GET', Qt.resolvedUrl('data.json'))` dengan `data.json` di direktori yang sama). Membaca `qrc:` tanpa variabel itu `[uji]`.

**Debug.** Variabel `QML_XHR_DUMP=1` mencatat metode, URL, dan isi permintaan terkirim, URL dan isi respons, serta galat jaringan. Isinya bisa memuat data sensitif. Hanya untuk uji lokal.

**Keamanan, ringkasan:**
- XHR di QML tidak menegakkan same-origin policy. Kode QML mana pun dapat menghubungi host mana pun. Terapkan daftar putih URL di kode Anda sendiri.
- Pakai HTTPS untuk jaringan nyata. Validasi bentuk JSON sebelum dipakai (jangan percaya `data.harga` pasti angka).
- Jangan menyalakan variabel berkas di aplikasi yang memuat QML atau JS dari sumber luar.
- XHR tidak mendokumentasikan properti batas waktu. Buat sendiri dengan `Timer` yang memanggil `req.abort()`: `abort()` membatalkan permintaan dan mengembalikan `readyState` ke `UNSENT`.

**Opsi lain:**

| Kebutuhan | Cara |
|---|---|
| HTTP sederhana | `XMLHttpRequest` (di atas) |
| Antarmuka mirip `fetch` | Bungkus XHR dengan `Promise` `[uji]` |
| TLS, autentikasi, unggah besar, unduh berkas | C++ `QNetworkAccessManager`, diekspos ke QML |
| Baca/tulis berkas | C++ `QFile`/`QSaveFile`, bukan XHR |

| Kesalahan | Solusi |
|---|---|
| Membaca `responseText` sebelum `DONE` | Periksa `readyState` dulu |
| Tak menangani `status !== 200` atau galat parse | Sediakan jalur `gagal` |
| Menyalakan `QML_XHR_ALLOW_FILE_*` "supaya jalan" | Pindahkan akses berkas ke C++ |
| Menaruh token di URL atau log | Pakai header dan jangan dicatat |

**Referensi:** [XMLHttpRequest](https://doc.qt.io/qt-6/qml-qtqml-xmlhttprequest.html) · [W3C XHR Level 1](https://www.w3.org/TR/2014/WD-XMLHttpRequest-20140130/) · [MDN: XMLHttpRequest](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest)

---

### 2.4.6 Penyimpanan data: `Settings` dan `LocalStorage`

*Menyimpan itu mudah. Menyimpan dengan aman dan sadar itu keterampilan.*

#### `Settings` (modul `QtCore`, ≥ 6.5)
```qml
import QtCore
import QtQml

QtObject {
    Settings {
        id: pengaturan
        location: Qt.resolvedUrl('lab.ini')
        category: 'LabQML'
        property int bukaKe: 0
    }

    Component.onCompleted: {
        pengaturan.bukaKe += 1
        console.log('dibuka ke', pengaturan.bukaKe)
        Qt.quit()
    }
}
```
Jalankan dua kali (`qml -a core Pengaturan.qml`), lalu `cat lab.ini`. Dugaan: `dibuka ke 1`, lalu `dibuka ke 2`, dan isi berkas `[LabQML]` dengan `bukaKe=2` `[uji]`.

**Bedah kode:**
- `import QtCore`: tipe `Settings` ada di modul ini, sejak Qt 6.5.
- `property int bukaKe: 0`: nilai pengaturan dideklarasikan sebagai properti di dalam elemen `Settings`, dan hanya tipe nilai yang dikenali QSettings yang didukung. Nilai 0 adalah bawaan.
- `category: 'LabQML'`: kategori mengelompokkan pengaturan dan mencegah bentrok kunci.
- `location`: jalur berkas pengaturan. Bila belum ada, dibuat. Bila diisi, format INI dipakai. Dengan `location` eksplisit, data **terisolasi di satu berkas yang Anda tentukan**, tidak bercampur dengan pengaturan aplikasi lain.
- Tanpa `location`, pengaturan diidentifikasi lewat nama, organisasi, dan domain aplikasi, yang bisa diatur dari C++ atau lewat `Qt.application.name/organization/domain`.

**Mode lain:**
- Properti `alias`: pendekatan yang dianjurkan untuk pembaruan otomatis dua arah (misalnya posisi dan ukuran jendela), dengan biaya penyimpanan setiap nilai alias berubah.
- Properti biasa dan `setValue`/`value`: kontrol lebih halus. Simpan saat `Component.onDestruction`.

**Batasan:**
- Berbasis QSettings, sehingga tidak ada notifikasi perubahan, dan menulis lewat satu instans `Settings` tidak memperbarui instans lain.
- Di Unix tanpa standar tertentu, berkas INI teks biasa dipakai (registry di Windows, XML plist di macOS). **Teks polos: jangan simpan rahasia.**

#### `LocalStorage` (SQLite)
```qml
import QtQml
import QtQuick.LocalStorage

QtObject {
    Component.onCompleted: {
        const db = LocalStorage.openDatabaseSync('LabQML', '', 'Basis data lab', 100000)
        db.transaction(tx => {
            tx.executeSql('CREATE TABLE IF NOT EXISTS produk (nama TEXT, harga INTEGER)')
            tx.executeSql('INSERT INTO produk VALUES (?, ?)', ['Kopi', 15000])
        })
        db.readTransaction(tx => {
            const hasil = tx.executeSql('SELECT nama, harga FROM produk WHERE harga > ?', [10000])
            for (let i = 0; i < hasil.rows.length; i++)
                console.log(hasil.rows.item(i).nama, hasil.rows.item(i).harga)
        })
        Qt.quit()
    }
}
```
Jalankan `qml -a core LocalStorage.qml`. Bila modul menolak `-a core`, gunakan `QT_QPA_PLATFORM=offscreen qml LocalStorage.qml` `[uji]`.

**Bedah kode:**
- `openDatabaseSync(nama, versi, deskripsi, ukuranPerkiraan)`: membuka atau membuat basis data. API-nya mengikuti API sinkron HTML5 Web Database (draf W3C 2009).
- `db.transaction(tx => {...})`: transaksi baca-tulis. Bila callback melempar exception, transaksi di-rollback.
- `db.readTransaction(...)`: transaksi baca-saja untuk `SELECT`.
- `tx.executeSql(sql, [nilai...])`: menjalankan pernyataan SQL dan mengikat daftar nilai ke parameter posisional `?`.
- `hasil.rows.length` dan `hasil.rows.item(i)`: akses baris hasil `[uji]` sesuai API Web Database.

**Mengapa `?` dan bukan penyambungan string** (injeksi SQL):
```js
// SALAH: masukan pengguna menjadi bagian perintah SQL
tx.executeSql("SELECT * FROM produk WHERE nama = '" + masukan + "'")
// BENAR: nilai diikat sebagai data, bukan perintah
tx.executeSql('SELECT * FROM produk WHERE nama = ?', [masukan])
```

**Peringatan lokasi.** Basis datanya khusus pengguna dan khusus QML, tetapi dapat diakses semua aplikasi QML, disimpan di subdirektori Databases dari `offlineStoragePath()` sebagai SQLite. Cari berkasnya `[uji]`:
```bash
find ~/.local/share -name '*.sqlite' -mmin -5
```
Berkas itu tidak terenkripsi dan terbaca oleh aplikasi QML lain milik pengguna yang sama.

**Pilih yang mana:**

| Data | Pilihan |
|---|---|
| Preferensi kecil (tema, ukuran jendela) | `Settings` |
| Tabel relasional kecil | `LocalStorage` |
| Data besar, indeks, migrasi serius | C++ `QSqlDatabase`/Qt SQL |
| **Rahasia** (token, kata sandi) | Brankas sistem lewat C++ (mis. [QtKeychain](https://github.com/frankosterfeld/qtkeychain)), bukan keduanya |
| Berkas biasa | C++ `QFile` |

| Kesalahan | Solusi |
|---|---|
| Menyimpan token di `Settings`/`LocalStorage` | Pakai keyring sistem |
| Menyambung string ke SQL | Parameter `?` |
| Mengira `Settings` saling sinkron antar-instans | Tidak. Gunakan satu instans (singleton) |
| Lupa `import QtCore` / `import QtQuick.LocalStorage` | Tambahkan import |

**Referensi:** [Settings](https://doc.qt.io/qt-6/qml-qtcore-settings.html) · [QSettings](https://doc.qt.io/qt-6/qsettings.html) · [Qt Quick Local Storage QML Types](https://doc.qt.io/qt-6/qtquick-localstorage-qmlmodule.html) · [SQLite](https://www.sqlite.org/docs.html)

---

## E. Ringkasan keamanan Modul 2.4

| Permukaan | Risiko | Praktik |
|---|---|---|
| `XMLHttpRequest` | Tanpa same-origin policy; respons tak tepercaya | Daftar putih URL, HTTPS, validasi JSON |
| `QML_XHR_ALLOW_FILE_READ/WRITE` | Kode QML/JS dapat membaca dan menulis berkas | Tinggalkan nonaktif; pakai C++ |
| `QML_XHR_DUMP`, `console.*` | Kebocoran data ke log | Hanya uji lokal; sunting rahasia |
| `LocalStorage` | Terbaca semua aplikasi QML pengguna | Bukan tempat rahasia |
| `Settings` | Teks polos (INI) | Bukan tempat rahasia |
| `Qt.openUrlExternally` | URL tak tepercaya | Daftar putih `protocol` |
| `Qt.createQmlObject`, `eval` | Eksekusi kode dari string | Hindari; pakai komponen |
| `Qt.md5` | Hash lemah | Hanya checksum |
| `-qmljsdebugger` | Membuka infrastruktur debug | Hanya lingkungan terkendali |

---

## F. Latihan 15 menit dan kunci jawaban

**Latihan (dari kurikulum):** jalankan contoh `Timer`, lalu ubah agar aplikasi keluar setelah satu detik memakai `Qt.quit()`.

```qml
import QtQml

QtObject {
    Timer {
        interval: 1000; running: true
        onTriggered: { console.log('satu detik berlalu'); Qt.quit() }
    }
}
```
`repeat` tidak diisi sehingga bawaannya false (sekali pakai). Hasilnya satu baris `satu detik berlalu`, lalu proses berhenti. Untuk kode keluar tertentu: `Qt.exit(2)` lalu periksa dengan `echo $?`.

**Cek pemahaman:**
1. *Bagaimana menunda aksi satu detik di QML?* Dengan `Timer { interval: 1000; running: true; onTriggered: ... }`. `Qt.callLater` bukan untuk itu.
2. *Bagaimana menyimpan preferensi pengguna?* Dengan `Settings` (modul `QtCore`, sejak 6.5), idealnya dengan `location` eksplisit. Jangan dipakai untuk rahasia.
3. *Mengapa `localStorage` ala peramban gagal?* Tidak ada objek global itu di QML. Padanannya adalah tipe `LocalStorage` (SQLite) setelah `import QtQuick.LocalStorage`.
4. *Mengapa membaca berkas lewat XHR bermasalah?* Dinonaktifkan bawaan, dan menyalakannya memberi kode QML/JS akses ke sistem berkas. Pindahkan ke C++.

**Tantangan:** tulis `ambilJson` dengan batas waktu: tambahkan `Timer` 2 detik yang memanggil `req.abort()` dan jalur `gagal('batas waktu')`. Uji dengan server yang sengaja lambat.

---

## G. Glosarium Modul 2.4

| Istilah | Arti |
|---|---|
| Host environment | Objek dan fungsi yang disediakan penyelenggara (Qt) di luar standar JS |
| Objek global | Nama yang selalu ada tanpa import (`Qt`, `console`, …) |
| DOM | Model dokumen peramban; tidak ada di QML |
| Event loop | Antrean yang menjalankan pekerjaan satu per satu di utas UI |
| Callback | Fungsi yang dipanggil kembali saat pekerjaan selesai |
| Promise | Objek penampung hasil yang belum tersedia |
| XHR | `XMLHttpRequest`, antarmuka HTTP klien |
| `readyState` | Tahap permintaan XHR (`UNSENT` sampai `DONE`) |
| Same-origin policy | Aturan peramban yang membatasi permintaan lintas asal; tidak ditegakkan di XHR QML |
| One-shot timer | Timer yang memicu sekali (`repeat: false`) |
| Debounce | Menunda aksi sampai masukan berhenti berubah |
| QSettings / INI | Pustaka pengaturan Qt / format berkas teks berpasangan kunci-nilai |
| SQLite | Basis data relasional dalam satu berkas |
| Parameter terikat (`?`) | Nilai yang dikirim terpisah dari perintah SQL |
| Kategori log | Label sumber pesan (`qml`, `js`, atau milik Anda) |
| Daftar putih | Hanya yang disebut yang diizinkan |

---

## H. Hubungan dengan modul lain

| Modul | Hubungan |
|---|---|
| **2.1** Dasar JavaScript | `JSON`, `Date`, `Promise`, `try/catch` dipakai di semua contoh |
| **2.2** JS di dokumen QML | `onTriggered`, `Component.onCompleted`, `Connections` |
| **2.3** File JS dan pragma | `.import` tidak berfungsi di WorkerScript; kode global `.js` bersifat tereduksi |
| **3.x** Properti dan binding | `property alias` ke `Settings`; `required property` pada model |
| **5.x** Singleton dan C++ | `Settings` sebagai singleton; C++ untuk jaringan, berkas, penyimpanan aman |
| **13.1** Keamanan | Ringkasan keamanan di atas diperdalam di sana |

**Fase 2 selesai.** Prasyarat Fase 3: menguasai 2.1 sampai 2.4, terutama binding (2.2.1), `Qt.binding` (2.2.8), dan lab (2.1.0, 2.4.0).

---

**Catatan tautan:** halaman Qt yang saya buka langsung adalah Host Environment, QML Global Object, XMLHttpRequest, Settings, objek `Qt`, dan Debugging. Halaman Timer dan LocalStorage saya baca lewat pencarian dari beberapa versi dokumentasi. Tautan MDN, SQLite, QtKeychain, dan `LoggingCategory` tidak saya buka satu per satu. Bila ada yang tidak terbuka, kabari saya.

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../qml.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

<!----------------------------------------------------->

[0]: ./README.md
[1]: ./
[2]: ./
[3]: ./
[4]: ./
[5]: ./
[6]: ./
[7]: ./
[8]: ./
[9]: ./
[10]: ./
[11]: ./
[12]: ./
[13]: ./
[14]: ./
[15]: ./
[16]: ./
[17]: ./
[18]: ./

