[materi_perbandingan](./materi_perbandingan.md)

# Fase 2 · Modul 2.1 — Dasar JavaScript yang Dipakai QML

---

## A. Audit singkat

**Sudah benar, terverifikasi:**
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

