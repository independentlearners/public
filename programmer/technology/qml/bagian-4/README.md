# Fase 3 · Modul 3.1 — Property Binding

---

## A. Audit singkat

**Tumpang tindih dengan Fase 2.** Sebagian isi Fase 3 sudah dibahas pada Fase 2. Itu bukan kesalahan kurikulum, karena Fase 3 memang memperdalam. Agar tidak mengulang, setiap modul Fase 3 merujuk ke sana dan menambah yang belum ada:

| Modul Fase 3 | Sudah dibahas | Yang akan ditambah |
|---|---|---|
| **3.1** Property Binding | 2.2.1, 2.2.8 | mekanik dependensi, tipe `Binding` lengkap, loop, array/objek, biaya |
| 3.2 Signal dan Connections | 2.2.2, 2.2.7 | rekursi change handler, rantai signal, celah lain |
| 3.3 Lifecycle | 2.2.6 | `destroy()`, objek dinamis, `Loader` |
| 3.4 Scope, ID, Konteks | 2.2.4 | shadowing, context property, `qmllint` |

**Terverifikasi:**
- Alur contoh kurikulum benar (5, 13, tetap 100, 23). Sifatnya sesuai dokumentasi: penugasan nilai statis menghapus binding, dan `Qt.binding()` memasang binding baru.
- Elemen `Binding` berasal dari `import QtQml` dan memiliki properti `target`, `property`, `value`, `when`, serta `delayed` dan `restoreMode`.
- Teks peringatan loop memang berbentuk `Binding loop detected for property "…"`, diawali jenis objeknya (contoh dari log: `QML ToolTip: Binding loop detected for property "contentWidth"`).
- Sinyal perubahan hanya dipancarkan bila nilai properti itu sendiri berubah. Pada array, nilainya berupa referensi yang tak berubah walau isinya berubah. Jadi `push` memang tidak memicu notifikasi.
- Ekspresi binding dievaluasi ulang bila properti yang direferensikan berubah, sehingga sebaiknya sesederhana mungkin.

**Perlu dikoreksi atau dilengkapi:**
1. **Contoh kurikulum tidak berhenti sendiri.** Akar `Item` dijalankan `qml` akan membuka jendela dan tetap hidup. Tambahkan `Qt.quit()`, atau pakai varian `QtObject` di bawah.
2. **`Binding` mengevaluasi `value` tanpa syarat.** Ekspresi `value` tetap dievaluasi walau `when` bernilai false. Ini bisa memunculkan peringatan, misalnya saat dipakai menjaga nilai `null`. Sintaks ringkas dengan target ber-`id` hanya mengevaluasi ekspresi saat Binding aktif. Kurikulum tidak menyebutnya.
3. **`restoreMode` dan `delayed` tidak dibahas.** `restoreMode` bawaannya `RestoreBindingOrValue` dan ada demi kompatibilitas, tidak dianjurkan untuk kode baru. `delayed` menunda pembaruan target sampai antrean event kosong, dengan biaya waktu-jalan.
4. **Sintaks `Binding` modern.** Selain `target/property/value`, ada bentuk ringkas `Binding { objek.properti: ekspresi }` dan bentuk `Binding on properti { ... }`.
5. **Properti yang tak terpantau (*non-NOTIFYable*) tidak disebut.** Properti yang non-konstan dan tak punya notifikasi, bila dipakai di binding, membuat binding berpotensi usang. `qmllint` menandainya sebagai `stale-property-read`. Saat berjalan, mesin dapat mencetak peringatan "Expression … depends on non-NOTIFYable properties". Penting untuk Fase C++ nanti dan telah ditambahkan di 3.1.1.
6. **Array/objek: ada alternatif lain.** Selain `[...daftar, x]`, ada `concat` dan pemicu manual `daftarChanged()`. Pengembang Qt membenarkan memancarkan sinyal secara manual setelah mengubah isi. Contoh resmi Qt 6.12 sendiri menyalin sequence lewat spread `[...qrealListProperty]`, jadi spread pada array aman. Spread pada *objek* tetap `[uji]` (audit 2.1.9).
7. **3.1.6 "Biaya binding" diperkaya** dengan temuan dokumentasi 6.12: akumulasi dalam variabel sementara, granularitas notifikasi sequence dan value type, serta binding vs anchors. Isinya di 3.1.6.
8. **Salah satu nilai di kurikulum perlu dibaca hati-hati:** `width: height` dan `height: width` adalah loop pada `Item` dengan ukuran bawaan 0. Pada kontrol berlayout, loop sering muncul dari properti `implicitWidth` yang tak kentara (laporan log KDE menunjukkannya).

**TAMBAHAN:** **3.1.7** Diagnosis binding. Kurikulum tidak punya bagian khusus tentang cara menemukan binding yang putus atau berulang.

---

## B. Daftar isi Modul 3.1 (diperbarui)

<details>
  <summary>📃 Daftar Isi</summary>

---

- **3.1.1** Cara engine melacak dependensi (+ properti non-NOTIFYable) `[diperluas]`
- **3.1.2** Binding vs assignment
- **3.1.3** `Binding` dan `Qt.binding` (+ `when`, `restoreMode`, `delayed`) `[diperluas]`
- **3.1.4** Binding loop (+ sinkronisasi dua arah) `[diperluas]`
- **3.1.5** Array dan objek (+ pemicu manual, granularitas notifikasi) `[diperluas]`
- **3.1.6** Biaya binding (+ akumulator, anchors, profiler) `[diperluas]`
- **3.1.7** Diagnosis binding: log, `qmllint`, peringatan `[TAMBAHAN]`
- Latihan dan kunci jawaban · Glosarium · Hubungan dengan modul lain

</details>

**Urutan belajar yang disarankan:** 3.1.1 → 3.1.2 → 3.1.3 → 3.1.4 → 3.1.5 → 3.1.6 → 3.1.7.

---

## C. Peta besar

```
 sumber (properti)  ──sinyal perubahan──►  binding  ──nilai──►  properti tujuan
        ▲                                                         │
        └───────── (loop bila tujuan juga menjadi sumber) ◄───────┘

 Tiga keadaan sebuah properti:
   [NILAI STATIS] ──"= Qt.binding(f)"──► [BINDING HIDUP]
         ▲                                     │
         └───────── "= nilai biasa" ───────────┘   (binding terputus)
```

**Filosofinya:** binding adalah *pernyataan hubungan*, bukan perintah. Anda tidak mengatur kapan menghitung, mesin yang menjaga konsistensinya. Ongkosnya: Anda harus yakin dua hal. Pertama, setiap sumber *memberi tahu* bila berubah. Kedua, tak ada yang diam-diam menimpa rumusnya. Hampir semua bug binding jatuh ke salah satu dari keduanya.

**Cara menjalankan contoh:** semua berkas memakai `QtObject` dan dijalankan dengan `qml -a core nama.qml` (laboratorium 2.1.0). Varian kurikulum yang memakai `Item` dijalankan dengan `QT_QPA_PLATFORM=offscreen qml nama.qml`.

---

## D. Materi

### 3.1.1 Cara engine melacak dependensi

*Memahami bagaimana mesin "melihat" kode Anda adalah separuh dari mengendalikannya.*

**Konsep.** Setiap kali sebuah binding dievaluasi, mesin mencatat properti mana yang *dibaca*. Ketika salah satunya berubah, binding dihitung ulang. Mesin QML memantau variabel dalam ekspresi binding dan mengevaluasi ulang saat variabel itu berubah. Seperti 2.2.1, tetapi sekarang kita lihat dari dalam.

```qml
import QtQml

QtObject {
    property var jejak: ({ n: 0 })
    property int a: 2
    property int b: 3
    property bool pakaiB: true
    property int hasil: { jejak.n++; return pakaiB ? a + b : a }

    Component.onCompleted: {
        console.log(hasil, jejak.n)                // 5 1
        b = 10;      console.log(hasil, jejak.n)   // 13 2   b terbaca, jadi dependensi
        pakaiB = false; console.log(hasil, jejak.n) // 2 3
        b = 99;      console.log(hasil, jejak.n)   // 2 3    b tak lagi dibaca → TIDAK dihitung ulang [uji]
        Qt.quit()
    }
}
```

**Bedah kode:**
- `property var jejak: ({ n: 0 })`: objek penghitung. Kurung membungkus agar `{...}` dibaca sebagai objek, bukan blok. Mengubah `jejak.n` tidak memicu notifikasi (3.1.5), jadi aman dipakai sebagai penghitung tanpa menimbulkan loop.
- `property int hasil: { jejak.n++; return ... }`: binding berbentuk blok dengan `return`. `jejak.n++` sengaja mencatat setiap evaluasi. Efek samping seperti ini **hanya untuk demo**.
- `pakaiB ? a + b : a`: `b` hanya dibaca saat `pakaiB` benar.
- Setelah `pakaiB = false`, mengubah `b` tidak lagi memicu evaluasi: dependensi *disusun ulang di setiap evaluasi*. Perilaku ini `[uji]`.

```
 evaluasi "hasil"
   ├─ baca pakaiB ─► langganan sinyal pakaiBChanged
   ├─ baca a / b  ─► langganan aChanged / bChanged   (hanya yang DIBACA kali ini)
   └─ simpan nilai
 sinyal apa pun dari daftar langganan terpancar → evaluasi ulang → daftar disusun ulang
```

**Syarat agar properti bisa dipantau.** Properti harus *notifiable* atau *constant*.
- Properti konstan tak pernah berubah. Properti yang notifiable memberi tahu binding yang bergantung padanya saat nilainya berubah.
- Properti QML yang Anda deklarasikan (`property int a`) otomatis punya sinyal perubahan.
- Properti dari C++ harus dideklarasikan dengan `NOTIFY` (atau `CONSTANT`). Bila tidak, mesin mencetak peringatan "Expression … depends on non-NOTIFYable properties", dan `qmllint` melaporkan `stale-property-read`.
- Efeknya: binding tidak dihitung ulang karena mesin tidak diberi tahu.

**Hal yang perlu diingat:**
- Evaluasi bersifat sinkron pada perubahan, tetapi urutan evaluasi antar-binding tidak boleh diandalkan.
- Bila dua sumber berubah beruntun, binding dapat dievaluasi dua kali dan sempat melihat keadaan *sementara* yang tak konsisten (*glitch*). `Binding.delayed` (3.1.3) adalah salah satu obatnya.

**Opsi lain, menyatakan hubungan:**

| Cara | Kapan |
|---|---|
| Binding langsung `x: y * 2` | Hubungan sederhana |
| Fungsi dipanggil di binding `x: hitung()` | Logika lebih panjang (dependensi terlacak lewat fungsi, 2.2.1) |
| `Binding` (3.1.3) | Target tak bisa diikat deklaratif, atau bersyarat |
| Handler `onXChanged` | Efek samping atau urutan langkah, bukan hubungan murni |

| Kesalahan | Solusi |
|---|---|
| Properti C++ tanpa `NOTIFY` dipakai di binding | Tambahkan `NOTIFY`/`CONSTANT`, atau `BINDABLE` di Qt 6 |
| Mengira binding dievaluasi sekali | Dievaluasi ulang tiap dependensinya berubah |
| Membaca properti di luar ekspresi (callback async) lalu heran tak terpantau | Hanya yang dibaca *selama evaluasi* tercatat |

**Referensi:** [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html) · [qmllint: stale-property-read](https://doc.qt.io/qt-6/qmllint-warnings-and-errors-stale-property-read.html) · [Writing QML Extensions with C++](https://doc.qt.io/qt-6.8/qtqml-tutorials-extending-qml-example.html)

---

### 3.1.2 Binding vs assignment

*Satu tanda sama dengan bisa menjadi perbedaan antara rumus dan angka mati.*

Versi kurikulum, dipasangkan agar berhenti sendiri (varian `QtObject`):
```qml
import QtQml

QtObject {
    property int a: 2
    property int b: 3
    property int total: a + b

    Component.onCompleted: {
        console.log(total)                                      // 5
        a = 10; console.log(total)                              // 13: binding ikut berubah
        total = 100                                             // assignment: binding DIPUTUS
        a = 20; console.log(total)                              // 100
        total = Qt.binding(function () { return a + b })        // pulihkan binding
        console.log(total)                                      // 23
        total = a + b                                           // BUKAN binding: hanya hasil sekali
        a = 0; console.log(total)                               // 23 (tak mengikuti)
        Qt.quit()
    }
}
```

**Bedah kode:**
- `property int total: a + b`: ekspresi di kanan `:` pada deklarasi adalah binding.
- `total = 100`: tanda `=` di dalam blok JavaScript adalah *penugasan*. Menugaskan nilai statis dari JavaScript menghapus binding yang ada.
- `total = Qt.binding(function () {...})`: untuk membuat hubungan baru secara imperatif, ekspresi dibungkus `Qt.binding()`.
- `total = a + b`: baris yang paling sering keliru. Ia menghitung `a + b` **sekali** lalu menyimpannya sebagai angka mati, jadi bukan binding. Setelah `a = 0`, `total` tetap 23.

```
 deklarasi "total: a + b"  ─────► [BINDING]
 "total = <apa pun biasa>" ─────► [STATIS]      (termasuk "total = a + b")
 "total = Qt.binding(f)"   ─────► [BINDING]
```

**Yang memutus dan yang tidak:**

| Tindakan | Memutus binding `total`? |
|---|---|
| `total = 100` | Ya |
| `total = a + b` | Ya (jadi angka mati) |
| `total = Qt.binding(...)` | Tidak, memasang binding baru |
| `a = 10` (mengubah sumber) | Tidak |
| `Binding { ... when: false }` | Tidak (memulihkan, 3.1.3) |

**Aturan praktis:** satu properti, satu "pemilik". Jika sebuah properti sudah punya binding, jangan menugaskannya dari JavaScript. Bila memang perlu "penimpaan", simpan penimpaannya di properti lain (pola `timpa` di 2.2.8) atau pakai `Binding` bersyarat (3.1.3).

**Opsi lain, mengubah nilai tanpa memutus:**

| Ingin | Cara |
|---|---|
| Mengubah sumbernya | Ubah `a` atau `b` |
| Menimpa sementara | Properti `timpa` terpisah, atau `Binding { when: ... }` |
| Menyimpan nilai awal permanen | Deklarasi dengan nilai statis (bukan ekspresi) |
| Mencegah tertimpa | `readonly property int total: a + b` (penugasan ditolak) `[uji]` |

| Kesalahan | Solusi |
|---|---|
| `total = a + b` dikira binding | Pakai `Qt.binding` atau pindahkan ke deklarasi |
| Binding hilang tanpa sebab terlihat | Aktifkan log `qt.qml.binding.removal` (3.1.7) |
| Handler menugaskan properti ber-binding | Pakai properti terpisah atau `Binding` |

**Referensi:** [Property Binding: creating bindings from JavaScript](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html#creating-property-bindings-from-javascript) · [Qt.binding()](https://doc.qt.io/qt-6/qml-qtqml-qt.html#binding-method)

---

### 3.1.3 `Binding` dan `Qt.binding`

*Bila Anda tak bisa mengikat dari dalam, ikatlah dari luar.*

**Konsep.** Dua alat berbeda untuk dua situasi:
- `Qt.binding(f)`: memasang binding **dari kode JavaScript** (imperatif).
- `Binding { ... }`: tipe QML yang memasang binding **secara deklaratif dari luar** objek target, dan dapat bersyarat (`when`).

**`Binding` dengan syarat (sintaks ringkas):**
```qml
import QtQml

QtObject {
    id: root
    property int sumber: 1
    property bool aktif: false
    property int tujuan: 100

    Binding { root.tujuan: root.sumber * 10; when: root.aktif }

    Component.onCompleted: {
        console.log(tujuan)                    // 100 (Binding belum aktif)
        aktif = true;  console.log(tujuan)     // 10
        sumber = 5;    console.log(tujuan)     // 50
        aktif = false; console.log(tujuan)     // 100 (dipulihkan ke nilai semula)
        Qt.quit()
    }
}
```

**Bedah kode:**
- `Binding { root.tujuan: ... }`: sintaks ringkas, mengikat properti `tujuan` milik objek ber-`id: root`. Bentuk ini tidak mengizinkan penggantian target atau properti saat jalan, tetapi lebih ringkas dibanding `target`/`property`/`value`.
- `when: root.aktif`: menentukan kapan Binding aktif. Secara bawaan, binding atau nilai yang ditetapkan sebelumnya dipulihkan ketika Binding menjadi tidak aktif. Karena itu setelah `aktif = false`, `tujuan` kembali ke 100.
- Ekspresi yang dievaluasi hanya saat Binding aktif (khasiat sintaks ringkas). Itu mencegah peringatan bila ekspresi menyentuh nilai `null`.

**Tiga bentuk yang setara:**
```qml
Binding { root.tujuan: root.sumber * 10; when: root.aktif }                     // ringkas

Binding { target: root; property: 'tujuan'; value: root.sumber * 10; when: root.aktif }   // eksplisit

Binding on tujuan { when: root.aktif; value: root.sumber * 10 }                 // sebagai value source
```
Bentuk kedua penting bila target tak punya `id` (misalnya singleton) atau perlu diganti saat jalan. Target yang tidak punya `id` memerlukan properti `target`.

**Jebakan `value` yang tetap dievaluasi:** pada bentuk 2 dan 3,
```qml
Binding on tujuan {
    when: root.objek !== null
    value: root.objek.sifat        // dievaluasi walau when=false → TypeError saat objek null
}
```
Ada dua jalan keluar: pakai sintaks ringkas, atau ulangi pemeriksaan dalam ekspresi dan `return` lebih awal.
```qml
value: { if (root.objek === null) return; return root.objek.sifat }
```

**Properti lain:**
- `restoreMode`: menentukan apakah dan bagaimana nilai semula dipulihkan (`RestoreNone`, `RestoreBinding`, `RestoreValue`, `RestoreBindingOrValue` bawaan). Properti ini ada demi kompatibilitas dan tidak dianjurkan untuk kode baru.
- `delayed`: menunda pembaruan target sampai antrean event kosong. Berguna sebagai optimisasi atau untuk mencegah nilai perantara, dengan biaya waktu-jalan karena butuh proksi nilai.
- `property: 'rectangle.x'`: dapat berupa properti grup dari value type.
- Impor: `import QtQml`.

**`Qt.binding` di tempat lain:**
- Selain memasang binding imperatif, dipakai saat menetapkan nilai awal objek yang dibuat dinamis (`createObject`, `Loader.setSource`).
- Ia tak boleh dipakai langsung di deklarasi binding properti (`property int b: Qt.binding(...)` adalah galat), kecuali hasilnya disimpan dalam array pada properti `var`.

**Opsi lain:**

| Kebutuhan | Pilihan |
|---|---|
| Binding bersyarat deklaratif | `Binding` + `when` |
| Memasang binding dari handler/fungsi | `Qt.binding` |
| Mengikat properti objek C++ tanpa `id` | `Binding { target: ...; property: ...; value: ... }` |
| Mencegah nilai perantara | `Binding` + `delayed: true` |
| Penimpaan pengguna | Properti `timpa` terpisah (2.2.8) |

| Kesalahan | Solusi |
|---|---|
| Menulis `Binding on x` lalu heran muncul `TypeError` saat nilai null | `value` tetap dievaluasi: jaga dalam ekspresi atau pakai sintaks ringkas |
| Memakai `restoreMode` di kode baru | Biarkan bawaan |
| `property int b: Qt.binding(...)` | Dilarang. Pasang dari handler, atau gunakan binding biasa |
| Dua `Binding` aktif ke properti yang sama | Hasil tak menentu. Pastikan satu pemilik pada satu waktu |

**Referensi:** [Binding](https://doc.qt.io/qt-6/qml-qtqml-binding.html) · [Qt.binding()](https://doc.qt.io/qt-6/qml-qtqml-qt.html#binding-method)

---

### 3.1.4 Binding loop

*Dua orang yang saling menunggu giliran tak pernah selesai.*

```qml
import QtQml

QtObject {
    property int a: b + 1
    property int b: a + 1

    Component.onCompleted: { console.log(a, b); Qt.quit() }
}
```
Dugaan: peringatan berbentuk `QML QtObject: Binding loop detected for property "a"` `[uji]`. Nilai `a` dan `b` yang tercetak tak terdefinisi maknanya, jadi jangan diandalkan.

**Bedah kode:**
- `a` bergantung pada `b`, dan `b` pada `a`: lingkaran dependensi.
- Mesin QML memiliki mekanisme untuk mendeteksi dan memutus loop semacam ini. Mesin tidak membeku. Ia menghentikan putaran dan mencetak peringatan, tetapi nilai akhirnya tak bermakna.

```
 a ──depends on──► b
 ▲                  │
 └──depends on──────┘        ⇒ siklus: tak ada urutan evaluasi yang valid
```

**Varian yang sering terjadi:**
1. Siklus langsung (di atas).
2. Antar-ukuran: `width: height` bersama `height: width` pada `Item` (contoh kurikulum).
3. Rujukan ke diri sendiri: `x: x + 1`.
4. Siklus berlapis lewat beberapa objek atau lewat `implicitWidth`/`implicitHeight` pada kontrol dan layout. Laporan log KDE menunjukkan peringatan loop pada `implicitWidth` dan `implicitHeight`.

**Cara memutus:**
- Buat arah satu: tentukan mana sumber, mana turunan.
- Pindahkan sumber ke properti ketiga yang independen.
- Untuk sinkron dua arah yang memang dibutuhkan, jangan pakai dua binding. Pakai dua handler dengan **penjaga kesetaraan**:

```qml
import QtQml

QtObject {
    property real celsius: 0
    property real fahrenheit: 32

    onCelsiusChanged: {
        const f = celsius * 9 / 5 + 32
        if (Math.abs(fahrenheit - f) > 1e-9) fahrenheit = f
    }
    onFahrenheitChanged: {
        const c = (fahrenheit - 32) * 5 / 9
        if (Math.abs(celsius - c) > 1e-9) celsius = c
    }

    Component.onCompleted: {
        celsius = 100;    console.log(fahrenheit)    // 212
        fahrenheit = 32;  console.log(celsius)       // 0
        Qt.quit()
    }
}
```
- `Math.abs(...) > 1e-9`: penjaga dengan toleransi. Tanpanya, galat pembulatan bilangan pecahan bisa membuat dua handler saling menimpa tanpa henti. Penjaga bekerja karena sinyal perubahan hanya dipancarkan bila nilai benar-benar berubah, sehingga siklus berhenti begitu nilainya sama. Pola ini juga bukan binding, jadi tidak memunculkan peringatan loop. Risikonya rekursi handler, yang dibahas di Modul 3.2.

**Opsi lain:**

| Situasi | Solusi |
|---|---|
| Hubungan satu arah | Satu binding, tanpa balasan |
| Dua arah sungguhan | Handler + penjaga kesetaraan (di atas) |
| Aktif hanya pada kondisi tertentu | `Binding { when }` |
| Nilai perantara mengganggu | `Binding { delayed: true }` |

| Kesalahan | Solusi |
|---|---|
| Mengabaikan peringatan "karena aplikasi tetap jalan" | Nilai tidak bermakna. Putus siklusnya |
| Dua binding saling merujuk lewat `implicit*` | Tetapkan ukuran dari sumber luar |
| Sinkron dua arah tanpa penjaga | Tambahkan pemeriksaan kesetaraan dengan toleransi |

**Referensi:** [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html) · [QTBUG-110422](https://bugreports.qt.io/browse/QTBUG-110422)

---

### 3.1.5 Array dan objek

*Mesin hanya melihat bahwa kotaknya berganti. Ia tak mengintip isi kotak.*

**Konsep.** Properti `var` yang menyimpan array atau objek menyimpan **referensi**. Notifikasi dipancarkan saat referensi diganti, bukan saat isinya berubah.

```qml
import QtQml

QtObject {
    property var daftar: ['a']
    property int jumlah: daftar.length
    property int dipicu: 0
    onDaftarChanged: dipicu++

    Component.onCompleted: {
        daftar.push('b')
        console.log(jumlah, dipicu)       // 1 0   push TIDAK memicu apa pun
        daftar = [...daftar, 'c']
        console.log(jumlah, dipicu)       // 3 1   penugasan ulang memicu
        daftar.push('d'); daftarChanged()
        console.log(jumlah, dipicu)       // 4 2   pemicu manual
        daftar = daftar.concat(['e'])
        console.log(jumlah, dipicu)       // 5 3
        Qt.quit()
    }
}
```

**Bedah kode:**
- `daftar.push('b')`: mengubah isi array yang sama. Referensi tak berubah, jadi `jumlah` tetap 1.
- `daftar = [...daftar, 'c']`: membuat array **baru** (spread menyalin elemen lama lalu menambah `'c'`). Referensi berganti, sinyal terpancar, `jumlah` menjadi 3. Contoh resmi Qt 6.12 memakai spread untuk menyalin sequence.
- `daftarChanged()`: setiap properti memiliki sinyal perubahan yang bisa dipancarkan secara manual. Pengembang Qt membenarkan cara ini setelah mengubah isi. Bungkus `push` dan emit dalam satu fungsi pembantu supaya tak terlupa.
- `daftar.concat(['e'])`: array baru tanpa memerlukan spread.

```
 daftar ──► [ 'a', 'b' ]   push mengubah isi di sini  → sinyal TIDAK keluar
 daftar = ──► [ 'a','b','c' ]   referensi baru         → sinyal keluar
```

**Objek mengikuti aturan yang sama:**
```js
profil.umur = 21                                   // tak memicu
profil = Object.assign({}, profil, { umur: 21 })   // memicu (objek baru)
profilChanged()                                    // memicu manual
```
`{ ...profil, umur: 21 }` untuk objek `[uji]`.

**Granularitas notifikasi.** Untuk properti sequence dan value type (font, color, vector3d, …), sinyal perubahan dipancarkan bila elemen mana pun berubah, jadi semua binding yang merujuk properti itu dievaluasi ulang walau yang berubah hanya satu elemen. Bila banyak binding bergantung pada satu elemen, buat **properti perantara** yang terikat ke elemen itu, lalu pakai sebagai sumber:
```qml
property int tengah: daftarAngka[1]          // perantara: hanya dievaluasi ulang bila NILAInya berubah
property int a: tengah + 10
property int b: tengah + 20
```

**Pilihan wadah data:**

| Kebutuhan | Pilihan |
|---|---|
| Daftar kecil yang diganti utuh | `property var` + penugasan ulang |
| Daftar objek QML | `list<T>` atau `ListModel` |
| Daftar yang sering bertambah/berkurang, dipakai `ListView` | `ListModel` (prototipe) atau model C++ `QAbstractListModel` |
| Data besar | Model C++ |

`ListModel` cocok untuk prototipe tetapi tidak untuk data besar; untuk itu pakai `QAbstractItemModel`. Alasan ia lebih baik untuk tampilan: model mengabarkan penyisipan dan penghapusan per baris, bukan "seluruh array berganti".

**Peringatan salah paham:** `property list<T>` bukan array JavaScript biasa. Operasi `push` pada properti jenis itu hanya mengubah salinan `[uji]` (laporan lama di forum, sebab tak ada notifikasi di sana). Rujuk dokumentasi list property sebelum mengandalkannya.

| Kesalahan | Solusi |
|---|---|
| `daftar.push(x)` lalu UI tak berubah | Penugasan ulang atau `daftarChanged()` |
| Mengubah `profil.umur` dan binding diam | Objek baru atau emit manual |
| Menyalin array besar di setiap penambahan | Pakai model (`ListModel`/C++) |
| Banyak binding ke satu elemen sequence | Properti perantara |

**Referensi:** [Sequence tips (Performance)](https://doc.qt.io/qt-6.12/qtquick-performance.html#sequence-tips) · [Forum Qt: property var array](https://forum.qt.io/topic/52239/solved-property-var-array-doesn-t-trigger-onchanged-signal) · [ListModel](https://doc.qt.io/qt-6.12/qml-qtqml-models-listmodel.html) · [MDN: Spread syntax](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_syntax)

---

### 3.1.6 Biaya binding

*Binding murah, tetapi tidak gratis, dan ia dijalankan lebih sering daripada yang Anda kira.*

**Konsep.** Setiap perubahan pada sumber memicu evaluasi ulang. Biayanya muncul dari tiga hal: frekuensi (seberapa sering sumber berubah), isi (seberapa berat ekspresi), dan rantai (berapa banyak binding turunan ikut terpicu).

**Peragaan: akumulasi langsung vs lewat variabel sementara.**
```qml
import QtQml

QtObject {
    property int akumulasi: 0
    property var statistik: ({ n: 0 })
    property string label: { statistik.n++; return 'total=' + akumulasi }

    function buruk() { for (const x of [1, 2, 3, 4, 5, 20]) akumulasi += x }
    function baik()  { let t = akumulasi; for (const x of [1, 2, 3, 4, 5, 20]) t += x; akumulasi = t }

    Component.onCompleted: {
        let awal = statistik.n
        buruk()
        console.log('buruk:', statistik.n - awal)      // 6 evaluasi
        akumulasi = 0
        awal = statistik.n
        baik()
        console.log('baik :', statistik.n - awal)      // 1 evaluasi
        Qt.quit()
    }
}
```

**Bedah kode:**
- `label`: binding yang menghitung berapa kali ia dievaluasi lewat `statistik.n`.
- `buruk()`: menugaskan `akumulasi` di setiap putaran, enam kali, sehingga `label` dievaluasi enam kali.
- `baik()`: menumpuk di variabel lokal `t` lalu menugaskan sekali, sehingga hanya satu evaluasi. Ini pola dari dokumentasi: jika hanya hasil akhir yang penting, pakai akumulator sementara lalu tugaskan sekali, agar tak memicu evaluasi ulang pada tahap perantara. Dokumentasi mencontohkan kasus `Text` yang disusun ulang enam kali.

**Daftar kebiasaan hemat** (semuanya dari dokumentasi 6.12 kecuali bila ditandai):

| Kebiasaan | Alasan |
|---|---|
| Ekspresi binding sesederhana mungkin | Ia dievaluasi ulang setiap properti yang dirujuk berubah. |
| Akumulasi di variabel lokal, tugaskan sekali | Menghindari evaluasi perantara (di atas) |
| Simpan `rect.color` di variabel sebelum dipakai berulang | Setiap pembacaan value type membuat pembungkus di heap JavaScript dan memanggil getter. |
| Pakai properti perantara untuk elemen sequence/value type | Granularitas sinyal seluruh properti (3.1.5) |
| Anchors atau nilai statis dibanding binding untuk tata letak | Memosisikan dengan binding relatif lambat, anchors lebih efisien, dan inisialisasi statis paling cepat bila tata letak tidak dinamis. |
| Jangan menjalankan JavaScript berat per frame animasi | Menganimasikan properti mengevaluasi ulang binding yang merujuknya. |
| Beri anotasi tipe dan andalkan Qt Quick Compiler | Berkat perkakas seperti Qt Quick Compiler, fungsi dan binding sederhana bisa sangat cepat. |
| **Ukur dulu** | Mengoptimalkan tanpa profil kemungkinan memberi perbaikan kecil saja. |

**Biaya yang tersembunyi di fungsi:** fungsi yang dipanggil dari binding dievaluasi ulang setiap dependensi *di dalamnya* berubah, termasuk dependensi yang Anda lupa ada. Fungsi panjang di binding adalah antipola. Pecah menjadi properti turunan kecil.

**Profiling.** Gunakan QML Profiler di Qt Creator (atau penampil jejak di Qt Extension for VS Code) untuk melihat binding mana yang berjalan paling sering. Rujukan: [Qt Quick Tools and Utilities](https://doc.qt.io/qt-6.12/qtquick-tools-and-utilities.html).

**Opsi lain:**

| Masalah | Cara |
|---|---|
| Binding terlalu sering dievaluasi | `Binding { delayed: true }`, akumulator, properti perantara |
| Binding berat | Pecah jadi beberapa properti kecil, atau pindahkan ke fungsi C++ |
| Tata letak lambat | Anchors, atau ukuran statis |
| Hitungan sekali pakai saat startup | Properti biasa yang diisi di `onCompleted` (waspadai memutus binding) |

| Kesalahan | Solusi |
|---|---|
| Menaruh perulangan berat di binding | Pindah ke fungsi yang dipicu seperlunya |
| Menugaskan properti di dalam perulangan | Akumulasi lalu tugaskan sekali |
| Optimasi tanpa mengukur | Profil dulu |
| Menaruh efek samping di binding | Pakai handler |

**Referensi:** [Performance considerations and suggestions](https://doc.qt.io/qt-6.12/qtquick-performance.html) · [Qt Quick Tools and Utilities](https://doc.qt.io/qt-6.12/qtquick-tools-and-utilities.html)

---

### 3.1.7 Diagnosis binding: log, `qmllint`, peringatan `[TAMBAHAN]`

*Bug yang bisa dilihat setengahnya sudah selesai.*

| Gejala | Alat | Perintah atau tanda |
|---|---|---|
| Nilai berhenti mengikuti sumber | Log pemutusan binding | `QT_LOGGING_RULES="qt.qml.binding.removal.info=true" qml …` |
| Nilai tak bermakna, peringatan loop | Pesan `Binding loop detected` | Putus siklus (3.1.4) |
| Binding tak dihitung ulang | Peringatan "non-NOTIFYable" | Tambahkan `NOTIFY`/`CONSTANT` |
| Banyak peringatan tipe | `qmllint` | `qmllint berkas.qml` (nama biner di Arch bisa `qmllint6`) |
| Terlalu sering dievaluasi | Penghitung (3.1.6) atau profiler | |

**Rincian:**
- Kategori log `qt.qml.binding.removal` mencetak pesan setiap kali binding terhapus akibat penugasan imperatif. Pesan itu alat bantu diagnosis, belum tentu masalah.
- Peringatan tentang properti non-NOTIFYable muncul saat binding dipasang pada properti yang belum punya sinyal perubahan.
- `qmllint` mendeteksi pola berbahaya sebelum aplikasi jalan, misalnya `stale-property-read`.
- C++ juga memiliki kategori log `qt.qproperty.binding` untuk binding property yang bersifat C++.

**Rutinitas yang disarankan:** jalankan `qmllint` sebelum menjalankan. Aktifkan log pemutusan binding di sesi pengembangan. Jangan membiarkan peringatan loop tersisa di log.

---

## E. Latihan 15 menit dan kunci jawaban

**Latihan (dari kurikulum):** jalankan contoh, lalu sebabkan binding loop dengan sengaja dan baca peringatannya.

```qml
// loop.qml
import QtQuick
Item { width: height; height: width }
```
```bash
QT_QPA_PLATFORM=offscreen qml loop.qml 2>&1 | head
```
Dugaan: peringatan `Binding loop detected for property "width"` (dan atau `"height"`) `[uji]`. Varian tanpa grafis ada di 3.1.4.

**Cek pemahaman:**
1. *Mengapa `total = 100` memutus binding?* Karena penugasan nilai statis dari JavaScript menghapus binding yang ada pada properti itu.
2. *Bagaimana memulihkannya?* Dengan `total = Qt.binding(function () { return a + b })`, atau mendesain ulang agar penimpaan disimpan di properti lain (atau pakai `Binding { when }`).
3. *Mengapa `daftar.push(x)` tidak memicu pembaruan?* Karena referensi array tidak berubah. Gunakan penugasan ulang (`daftar = [...daftar, x]`) atau `daftarChanged()`.
4. *Mengapa `total = a + b` di handler bukan binding?* Ia dievaluasi sekali menjadi angka. Hanya deklarasi atau `Qt.binding` yang membuat hubungan hidup.

**Tantangan:** buat dua properti `sumber` dan `turunan`. Pasang `Binding` bersyarat dengan `delayed: true`, lalu buktikan (dengan `console.log` di `Qt.callLater`) bahwa nilai target baru berubah setelah event loop kembali `[uji]`.

---

## F. Glosarium Modul 3.1

| Istilah | Arti |
|---|---|
| Binding | Properti yang diisi ekspresi dan dihitung ulang otomatis |
| Dependensi | Properti yang dibaca sebuah binding selama evaluasi |
| Sinyal perubahan (`xChanged`) | Notifikasi bahwa properti berubah; dasar pemantauan |
| Notifiable / constant | Properti yang memberi tahu perubahan / yang tak pernah berubah |
| Non-NOTIFYable | Properti non-konstan tanpa notifikasi; membuat binding usang |
| Memutus binding | Menimpa binding dengan nilai statis |
| `Qt.binding()` | Membuat binding dari JavaScript imperatif |
| `Binding` | Tipe QML pembuat binding deklaratif dari luar, dapat bersyarat |
| `when` | Syarat aktifnya `Binding` |
| `restoreMode` | Cara pemulihan nilai semula saat `Binding` nonaktif (usang) |
| `delayed` | Menunda pembaruan `Binding` sampai antrean event kosong |
| Binding loop | Siklus dependensi antar-binding |
| Glitch | Keadaan sementara tak konsisten di antara dua perubahan |
| Properti perantara | Properti penampung nilai yang dipakai banyak binding |
| Granularitas notifikasi | Satuan terkecil yang memicu sinyal (seluruh properti) |
| Akumulator | Variabel lokal penampung hasil sebelum ditugaskan sekali |
| Referensi vs isi | Properti `var` menyimpan referensi; mengubah isi tidak mengganti referensi |

---

## G. Hubungan dengan modul lain

| Modul | Hubungan |
|---|---|
| **2.2.1, 2.2.8** | Dasar binding dan `Qt.binding` yang diperdalam di sini |
| **3.2** Signal dan Handler | Handler `onXChanged` dan sinkron dua arah (3.1.4); rekursi handler |
| **3.3** Lifecycle | Kapan binding dipasang relatif terhadap `onCompleted`; objek dinamis dengan `Qt.binding` |
| **3.4** Scope | Konteks evaluasi binding; `this` di `Qt.binding` (2.2.4) |
| **Fase C++** | `NOTIFY`, `CONSTANT`, dan `BINDABLE` agar properti C++ bisa dipantau |
| **Fase Model/View** | `ListModel` dan model C++ sebagai pengganti array untuk daftar dinamis |

**Prasyarat Modul 3.2:** menguasai 3.1.1 sampai 3.1.5. Bagian 3.1.6 dan 3.1.7 dianjurkan sebelum membangun komponen kompleks.

---

<!-- **Catatan tautan:** halaman Qt yang saya buka langsung adalah Binding dan Performance considerations (6.12). Property Binding dan objek `Qt` saya baca pada putaran sebelumnya. Halaman peringatan `qmllint` dan tutorial ekstensi C++ saya baca lewat pencarian. Sumber forum dan bug tracker saya pakai hanya untuk perilaku yang tak terdokumentasi eksplisit, dan sebagian berasal dari versi Qt lebih lama, jadi tandai `[uji]` pada versi Anda. Tautan MDN tidak saya buka satu per satu. Bila ada yang tidak terbuka, kabari saya. -->
# Fase 3 · Modul 3.2 — Signal, Handler, dan Connections

---

## A. Audit singkat

**Tumpang tindih dengan Fase 2.** Sebagian besar dasar Modul 3.2 sudah ada di **2.2.2** (signal handler, parameter, `arguments`) dan **2.2.7** (`Connections`, `connect()`). Di sini tidak mengulang penjelasannya, melainkan memperdalam dan menutup celah.

**Terverifikasi:**
- Handler bernama `on<Sinyal>` dengan huruf pertama kapital, dan menurut dokumentasi tidak boleh dipanggil langsung. Bila kodenya perlu dipakai bersama, pindahkan ke fungsi terpisah atau pancarkan sinyalnya.
- Handler perubahan properti `on<Properti>Changed` tersedia secara implisit untuk setiap properti.
- Parameter sinyal diakses dengan menugaskan fungsi ke handler, dan menyuntikkan parameter ke blok kode biasa sudah usang serta memicu peringatan saat parameternya dipakai. Catatan kurikulum benar.
- Bentuk `Connections { function onNamaSinyal(...) {...} }` adalah yang ditunjukkan dokumentasi.
- `connect()` mengizinkan satu sinyal diterima banyak method, dan `disconnect()` memutusnya.

**Perlu dikoreksi atau dilengkapi:**
1. **"Sintaks lama di dalam `Connections` usang."** Dokumentasi 6.12 memakai kata *tidak dianjurkan*, dan menambahkan jebakan penting: bila satu handler ditulis dengan sintaks lama (tanpa `function`), semua handler berbentuk `function` dalam objek `Connections` yang sama diabaikan. Jadi mencampur dua gaya bisa membuat handler "hilang" tanpa pesan.
2. **"`Connections` tanpa `target` yang valid."** Perlu diluruskan. Bila `target` tidak diisi, ia berlaku untuk induk dari objek `Connections`. Bila diisi `null`, tidak ada koneksi dan handler diabaikan sampai target tidak null. Jadi bukan galat. Bahayanya justru kebisuan: target `null` membuat handler tak berbunyi.
3. **Properti `Connections` yang tak disebut.** `enabled` (aktif atau tidak) dan `ignoreUnknownSignals` (mengabaikan galat saat menyambung ke sinyal yang tak ada, berguna bila target berganti jenis).
4. **Contoh kurikulum memakai sintaks sinyal lama** `signal pesanTerkirim(string isi)`. Dokumentasi menyatakan sintaks pilihan menaruh tipe setelah nama (`isi: string`), dan menyarankan memakai sintaks baru. Contoh saya memakai sintaks baru.
5. **Urutan pemanggilan tidak dibahas, padahal dipakai di latihan.** Dokumentasi C++ menyatakan bila beberapa slot tersambung ke satu sinyal, slot dijalankan satu per satu dalam urutan sambungannya. Slot yang tersambung umumnya langsung dijalankan seperti pemanggilan fungsi biasa. Karena QML berjalan di atas mekanisme yang sama, urutan di QML mengikuti urutan koneksi `[uji]`. Itu dokumentasi C++ versi 5.x, tetapi mekanismenya sama di Qt 6.
6. **Emisi bersifat sinkron.** Kode setelah `emit` baru dijalankan setelah semua slot kembali. Ini kunci memahami rekursi pada 3.2.6, dan belum ada di kurikulum.
7. **Penjaga kesetaraan adalah pola resmi Qt.** Dokumentasi C++ menjelaskan bahwa sinyal hanya dipancarkan bila nilai berubah, supaya koneksi siklik tak berputar tanpa henti. Ini pola yang sama dengan 3.1.4.
8. **Koneksi yang tertinggal.** Koneksi ke objek fungsi bertahan selama pengirim sinyalnya hidup, bahkan setelah penerimanya hilang, dan dokumentasi menyarankan memutusnya saat penerima dihancurkan. Ini sudah ada di 2.2.7, tetapi kurikulum 3.2 hanya menyebut "lupa `disconnect`".

**TAMBAHAN:** **3.2.7** Merancang antarmuka komponen: sinyal, properti, fungsi, plus alat diagnosis. Kurikulum belum memuat kapan memilih apa.

---

## B. Daftar isi Modul 3.2 (diperbarui)

- **3.2.1** Deklarasi signal dan parameter (+ sintaks baru, emisi sinkron) `[diperluas]`
- **3.2.2** Handler (+ perubahan properti hanya saat nilai berubah) `[diperluas]`
- **3.2.3** `Connections` modern (+ `target`, `enabled`, jebakan sintaks campuran) `[diperluas]`
- **3.2.4** `connect`/`disconnect` dan rantai signal (+ urutan, masa hidup) `[diperluas]`
- **3.2.5** Signal dari C++ (pratinjau Fase 10)
- **3.2.6** Rekursi tak sengaja pada change handler (+ pola pencegahan) `[diperluas]`
- **3.2.7** Merancang antarmuka komponen dan mendiagnosis sinyal `[TAMBAHAN]`
- Latihan dan kunci jawaban · Glosarium · Hubungan dengan modul lain

**Urutan belajar yang disarankan:** 3.2.1 → 3.2.2 → 3.2.3 → 3.2.4 → 3.2.6 → 3.2.5 → 3.2.7.

---

## C. Peta besar

```
 pengirim ──emit──►  [ penerima 1: onX handler ]        urutan = urutan sambungan
    │                [ penerima 2: Connections ]        semua dijalankan SINKRON
    │                [ penerima 3: connect(fn) ]        (kode setelah emit menunggu)
    │
    └─ pengirim tak tahu siapa penerimanya → renggang (loose coupling)
```

**Filosofinya:** sinyal itu *pengumuman*, fungsi itu *permintaan*, properti itu *keadaan*. Sinyal berkata "sesuatu sudah terjadi", tanpa peduli siapa yang mendengar dan tanpa menunggu balasan. Pemisahan inilah yang membuat komponen bisa dipakai ulang dan diaudit: pengirim tidak bergantung pada penerima.

**Cara menjalankan contoh:** semua berkas memakai `QtObject` dan dijalankan dengan `qml -a core nama.qml`.

---

## D. Materi

### 3.2.1 Deklarasi signal dan parameter

*Pengumuman yang jelas membuat penerima tak perlu menebak.*

**Sintaks.**
```
signal <nama>[([<nama parameter> : <tipe>[, ...]])]
```
Sinyal dipancarkan dengan memanggilnya seperti method.

```qml
import QtQml

QtObject {
    signal selesai(hasil: int)
    signal mulai()

    onSelesai: hasil => console.log('handler:', hasil)

    Component.onCompleted: {
        console.log('sebelum emit')
        selesai(42)
        console.log('sesudah emit')
        Qt.quit()
    }
}
```
Keluaran yang diharapkan, berurutan: `sebelum emit`, `handler: 42`, `sesudah emit`.

**Bedah kode:**
- `signal selesai(hasil: int)`: mendeklarasikan sinyal bernama `selesai` dengan satu parameter bernama `hasil` bertipe `int`. Tipe ditulis **setelah** nama.
- `signal mulai()`: sinyal tanpa parameter.
- `onSelesai: hasil => ...`: handler dari 3.2.2.
- `selesai(42)`: memancarkan sinyal. Handler langsung dijalankan **di dalam** pemanggilan ini, sehingga `'handler: 42'` tercetak sebelum `'sesudah emit'`. Kode setelah emisi baru dijalankan setelah semua slot kembali. Emisi tidak antre, dan tidak menunggu event loop.

**Tipe parameter yang lazim:** `int`, `real`, `bool`, `string`, `url`, `color`, `var` (apa pun dari JavaScript), serta tipe objek QML. Sinyal tidak mengembalikan nilai, jadi balasan tidak lewat sinyal.

**Sintaks lama** (jangan dipakai untuk kode baru):
```qml
signal pesanTerkirim(string isi)       // tipe sebelum nama
```
Dokumentasi menyatakan Anda sebaiknya memakai sintaks baru. Keduanya tetap berjalan, jadi Anda akan melihat yang lama di kode warisan.

**Sinyal otomatis.** Setiap properti punya sinyal perubahan `xChanged` tanpa parameter (3.2.2). Nama yang sudah dipakai properti tak boleh dipakai ulang untuk sinyal buatan sendiri.

**Opsi lain, cara menyampaikan "sesuatu terjadi":**

| Cara | Kapan |
|---|---|
| Sinyal | Peristiwa; banyak pihak mungkin peduli |
| Properti yang berubah (+ `onXChanged`) | *Keadaan* yang bisa dibaca kapan saja |
| Fungsi callback sebagai parameter | Satu penerima, hasil dikirim kembali segera |
| Nilai kembalian fungsi | Permintaan sinkron dengan jawaban |

**Tips penamaan:** sinyal berbentuk lampau atau peristiwa (`pesanTerkirim`, `selesai`, `dipilih`). Fungsi berbentuk perintah (`kirimPesan`). Properti berbentuk kata benda (`jumlah`).

| Kesalahan | Solusi |
|---|---|
| Tipe sebelum nama (gaya lama) | `nama: tipe` |
| Mengira `selesai(42)` menunggu event loop | Ia sinkron, handler jalan di dalam panggilan |
| Parameter tak diberi tipe pada API publik | Beri tipe agar `qmllint` membantu |
| Nama sinyal bentrok dengan properti | Ganti nama |

**Referensi:** [Signal and Handler Event System: adding signals](https://doc.qt.io/qt-6/qtqml-syntax-signals.html#adding-signals-to-custom-qml-types) · [QML Object Attributes: signal attributes](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html#signal-attributes) · [Signals & Slots (C++)](https://doc.qt.io/qt-6.12/signalsandslots.html)

---

### 3.2.2 Handler

*Handler yang baik kecil, tanpa kejutan, dan tak memanggil handler lain.*

Ringkasan bentuk (rincian di 2.2.2):

| Bentuk | Contoh | Catatan |
|---|---|---|
| Arrow | `onSelesai: hasil => ...` | Dianjurkan |
| Fungsi anonim | `onSelesai: function (hasil) {...}` | `arguments` tersedia |
| Blok biasa | `onSelesai: { ... hasil ... }` | **Usang**, parameter disuntikkan |
| Perubahan properti | `onNilaiChanged: ...` | Otomatis ada |
| Terlampir | `Component.onCompleted: ...` | Dari tipe terlampir |

**Handler perubahan properti hanya terpicu saat nilai benar-benar berbeda.**
```qml
import QtQml

QtObject {
    property int nilai: 0
    onNilaiChanged: console.log('berubah ke', nilai)

    Component.onCompleted: {
        nilai = 1       // berubah ke 1
        nilai = 1       // tidak ada keluaran: nilai sama
        nilai = 2       // berubah ke 2
        Qt.quit()
    }
}
```
- `onNilaiChanged`: tidak perlu mendeklarasikan sinyal `nilaiChanged`, karena ada otomatis. Sinyal perubahan properti diberikan secara implisit oleh keberadaan properti itu, walau dokumentasi tipenya tidak mencantumkan handler tersebut.
- `nilai = 1` kedua kalinya tidak memancarkan apa pun. Sinyal perubahan hanya dipancarkan bila nilai properti benar-benar berubah. Karena itu penjaga kesetaraan (3.1.4) bisa memutus siklus.

**Beberapa handler untuk satu sinyal.** Boleh ada beberapa handler di scope berbeda untuk sinyal yang sama, tetapi dalam satu objek, satu nama handler hanya sekali. Untuk banyak penerima pada satu objek, pakai `Connections` atau `connect()`.

**Aturan keras:** handler dipicu oleh sinyal, bukan dipanggil. Jangan memanggil handler langsung. Bila ada kode bersama, pindahkan ke fungsi terpisah.
```qml
onSelesai: hasil => proses(hasil)               // tipis
function proses(hasil: int) : void { /* logika */ }
```

**Handler untuk properti tak terdokumentasi.** `TapHandler`, misalnya, tak punya `onPressedChanged` di dokumentasinya, tetapi ada karena properti `pressed` ada (kutipan di atas). Aturannya umum: `on<Properti>Changed` selalu tersedia bila properti ada.

**Opsi lain, bereaksi terhadap perubahan:**

| Kebutuhan | Pilihan |
|---|---|
| Menghitung nilai turunan | Binding (bukan handler) |
| Efek samping (log, panggil layanan, ubah objek lain) | Handler `onXChanged` |
| Mendengarkan objek lain | `Connections` (3.2.3) |
| Beberapa penerima sekaligus | `connect()` (3.2.4) |

| Kesalahan | Solusi |
|---|---|
| Memakai handler untuk menghitung nilai turunan | Pakai binding, lebih deklaratif dan tak menumpuk handler |
| Memanggil `onSelesai(...)` langsung | Pancarkan sinyal, atau panggil fungsi bersama |
| Mengandalkan handler terpicu pada nilai yang sama | Tidak terpicu; ubah nilainya dulu |
| Parameter nama salah ketik (`mgs` vs `msg`) | `ReferenceError`. Samakan nama (sudah tercatat di 2.2.2) |

**Referensi:** [Receiving signals with signal handlers](https://doc.qt.io/qt-6/qtqml-syntax-signals.html#receiving-signals-with-signal-handlers) · [Property change signal handlers](https://doc.qt.io/qt-6/qtqml-syntax-signals.html#property-change-signal-handlers)

---

### 3.2.3 `Connections` modern

*Mendengarkan dari kejauhan, dan berganti pengirim tanpa kerepotan.*

**Kapan dipakai.** `Connections` dipakai saat butuh banyak koneksi ke sinyal yang sama, saat membuat koneksi di luar scope pengirim, atau saat menyambung ke target yang tidak didefinisikan di QML.

```qml
import QtQml

QtObject {
    id: root
    property QtObject sumber: pengirimA

    QtObject { id: pengirimA; signal ping(n: int) }
    QtObject { id: pengirimB; signal ping(n: int) }

    Connections {
        target: root.sumber
        function onPing(n) {
            console.log('diterima dari', root.sumber === pengirimA ? 'A' : 'B', n)
        }
    }

    Component.onCompleted: {
        pengirimA.ping(1)          // diterima dari A 1
        sumber = pengirimB
        pengirimA.ping(2)          // (tak terdengar lagi)
        pengirimB.ping(3)          // diterima dari B 3
        Qt.quit()
    }
}
```

**Bedah kode:**
- `QtObject { id: pengirimA; signal ping(n: int) }`: dua objek kecil, masing-masing mendeklarasikan sinyal `ping`.
- `target: root.sumber`: `target` diikat ke sebuah **binding**. Saat `sumber` berpindah ke `pengirimB`, `Connections` otomatis memutus dari A dan menyambung ke B. Itulah keunggulannya atas `connect()` manual.
- `function onPing(n)`: bentuk modern. Awalan `on` + nama sinyal berhuruf kapital, di dalam sebuah `function`.
- Hasilnya: `ping(2)` dari A tidak terdengar karena target sudah berpindah.

**Properti `Connections`:**

| Properti | Perilaku |
|---|---|
| `target` | Pengirim sinyal. Bila tidak diisi, bawaannya adalah induk objek `Connections`. Bila `null`, tidak ada koneksi sampai target tidak null. |
| `enabled` | Menyatakan apakah objek menerima peristiwa; bawaannya `true`. Cocok untuk mematikan sementara |
| `ignoreUnknownSignals` | Normalnya sambungan ke sinyal yang tak ada menimbulkan galat saat berjalan. Bila `true`, galat itu diabaikan, berguna saat target berganti jenis. |

**Target bawaan = induk.** Contoh singkat tanpa `target`:
```qml
import QtQml

QtObject {
    signal tik()
    Connections { function onTik() { console.log('didengar lewat induk') } }
    Component.onCompleted: { tik(); Qt.quit() }
}
```
Keluaran yang diharapkan: `didengar lewat induk` `[uji]`.

**Jebakan sintaks campuran** (dari dokumentasi):
```qml
Connections {
    target: sumber
    onPing: console.log('gaya lama')             // tidak dianjurkan
    function onPing2(n) { /* ... */ }            // DIABAIKAN karena ada gaya lama di atas
}
```
Bila satu handler ditulis tanpa `function`, semua handler berbentuk `function` di objek `Connections` yang sama diabaikan. Pilih satu gaya, dan gunakan yang `function`.

**Opsi lain:**

| Situasi | Pilihan |
|---|---|
| Satu pengirim, satu penerima, dalam satu objek | Handler `onX` biasa |
| Pengirim lain atau berganti | `Connections` |
| Objek dinamis tanpa `id` | `connect()` (3.2.4) |
| Sinyal belum tentu ada | `Connections` + `ignoreUnknownSignals: true` |

| Kesalahan | Solusi |
|---|---|
| `target: null` membuat handler senyap | Periksa target; beri log saat target berubah |
| Mencampur gaya lama dan `function` | Satu gaya saja |
| Nama handler tak cocok dengan sinyal (`onPing` vs `onping`) | Awalan `on` + huruf kapital |
| Tak sadar target bawaan adalah induk | Selalu tulis `target:` eksplisit |

**Referensi:** [Connections](https://doc.qt.io/qt-6/qml-qtqml-connections.html) · [Using the Connections type](https://doc.qt.io/qt-6/qtqml-syntax-signals.html#using-the-connections-type)

---

### 3.2.4 `connect`/`disconnect` dan rantai signal

*Tahu siapa yang mendengar, dan kapan mereka berhenti mendengar.*

```qml
import QtQml

QtObject {
    id: root
    signal selesai(hasil: int)

    function pertama(h: int) { console.log('1:', h) }
    function kedua(h: int)   { console.log('2:', h) }

    Component.onCompleted: {
        selesai.connect(pertama)
        selesai.connect(kedua)
        selesai(7)                      // 1: 7  lalu  2: 7   (urutan sambungan) [uji]
        selesai.disconnect(pertama)
        selesai(8)                      // hanya 2: 8
        Qt.quit()
    }
}
```

**Bedah kode:**
- `selesai.connect(pertama)`: `connect()` ada di setiap objek sinyal. Argumennya fungsi (atau sinyal lain). Setelahnya, setiap `selesai(...)` memanggil `pertama(...)`.
- Dua sambungan = dua penerima. Urutan pemanggilannya mengikuti urutan sambungan (dokumentasi C++, `[uji]` di QML).
- `selesai.disconnect(pertama)`: memutus penerima itu. **Fungsi yang sama** harus diberikan, jadi fungsi anonim yang tak disimpan tak bisa diputus.

**Rantai sinyal.** Menyambung sinyal ke sinyal lain membentuk rantai. Contoh gaya dokumentasi:
```qml
Component.onCompleted: sumber.tapped.connect(send)    // tapped terpancar → send ikut terpancar
```
Menyambung sinyal langsung ke sinyal lain memancarkan sinyal kedua seketika setiap kali yang pertama terpancar.

**Masa hidup koneksi.** Inilah jebakan terbesar `connect()`.
- Koneksi ke objek fungsi bertahan selama pengirim sinyalnya hidup, bukan penerimanya.
- Dokumentasi mencontohkan banyak `Rectangle` dalam `Repeater` yang menyambung ke sinyal perubahan warna milik item lain. Setelah persegi dihapus, fungsi penanganan tetap dipanggil dan memunculkan pesan galat di latar belakang.
- Obatnya: putus koneksi saat penerima dihancurkan. Simpan referensi fungsinya:

```qml
Item {
    property var penanda: () => { color = pengirim.warna }
    Component.onCompleted: pengirim.warnaChanged.connect(penanda)
    Component.onDestruction: pengirim.warnaChanged.disconnect(penanda)
}
```
`penanda` disimpan di properti supaya `disconnect` memakai fungsi yang sama (`property var` untuk fungsi `[uji]`).

**Opsi lain:**

| Cara | Cocok untuk |
|---|---|
| `onX` handler | Satu penerima di objek pengirim |
| `Connections` | Target tetap atau berganti, masa hidup otomatis mengikuti `Connections` |
| `connect()` | Banyak penerima, objek dinamis, rantai sinyal; **wajib `disconnect`** bila penerima lebih singkat umurnya |

| Kesalahan | Solusi |
|---|---|
| `connect(() => {...})` anonim lalu tak bisa diputus | Simpan fungsinya |
| Koneksi menggantung setelah penerima hilang | `disconnect` di `Component.onDestruction` |
| `connect` dua kali dengan fungsi yang sama | Dipanggil dua kali, seperti duplikat C++ `[uji]` |
| Mengandalkan urutan penerima tanpa menyadarinya | Tulis kode yang tidak bergantung urutan |

**Referensi:** [Connecting signals to methods and signals](https://doc.qt.io/qt-6/qtqml-syntax-signals.html#connecting-signals-to-methods-and-signals) · [Signals & Slots (C++)](https://doc.qt.io/qt-6.12/signalsandslots.html)

---

### 3.2.5 Signal dari C++ (pratinjau Fase 10)

*Backend berbicara, UI mendengar.*

Pratinjau saja. Penjelasan lengkapnya ada di Fase 10:
```cpp
class Pengirim : public QObject {
    Q_OBJECT
    QML_ELEMENT
public:
    Q_INVOKABLE void kirim(const QString &isi) { emit pesanTerkirim(isi); }
signals:
    void pesanTerkirim(const QString &isi);
};
```
- `Q_OBJECT`: mengaktifkan sistem meta-objek (sinyal dan slot).
- `QML_ELEMENT`: mendaftarkan kelas sebagai tipe QML.
- `signals:` + `void pesanTerkirim(...)`: deklarasi sinyal; implementasinya dihasilkan otomatis oleh `moc`.
- Di QML: `Pengirim { onPesanTerkirim: isi => console.log(isi) }`. Aturan handler sama persis dengan sinyal QML.
- Properti C++ yang ingin dipakai di binding wajib bersinyal perubahan (`NOTIFY`, lihat 3.1.1).

**Perhatian lintas utas.** Pada koneksi antre (*queued*), kode setelah emisi langsung berlanjut dan slot dijalankan belakangan. Sinyal yang dipancarkan dari utas lain umumnya diantrekan ke utas penerima. Detailnya Fase 10.

**Referensi:** [Exposing Attributes of C++ Classes to QML](https://doc.qt.io/qt-6/qtqml-cppintegration-exposecppattributes.html) (belum ditinjau langsung) · [Signals & Slots](https://doc.qt.io/qt-6.12/signalsandslots.html)

---

### 3.2.6 Rekursi tak sengaja pada change handler

*Handler yang mengubah dirinya sendiri adalah orang yang menarik tali sepatunya sambil berdiri di atasnya.*

**Konsep.** Karena emisi sinkron, menugaskan sebuah properti **di dalam** handler perubahannya dapat memancarkan sinyal yang sama lagi, dan handler dipanggil **di dalam dirinya sendiri** (bertingkat).

**Rekursi yang berakhir:**
```qml
import QtQml

QtObject {
    property int x: 0
    onXChanged: {
        if (x < 3) x++
        console.log('x =', x)
    }
    Component.onCompleted: { x = 1; Qt.quit() }
}
```
Dugaan: tiga baris `x = 3` `[uji]`, karena handler memanggil dirinya bertingkat sebelum tiap tingkat mencetak.
- `x = 1` memicu handler tingkat 1: `x < 3`, jadi `x++` (menjadi 2), yang langsung memicu tingkat 2. Tingkat 2 menjadikan x 3 dan memicu tingkat 3. Tingkat 3 tidak menaikkan lagi, lalu mencetak.
- Setelah tingkat 3 kembali, tingkat 2 melanjutkan ke `console.log`, lalu tingkat 1. Keduanya melihat `x` sudah 3.
- Ini sebabnya kode setelah penugasan di dalam handler sering melihat nilai yang sudah berubah.

**Rekursi tak berujung (eksperimen opsional di terminal terpisah):**
```qml
onXChanged: x = x + 1        // setiap perubahan memicu perubahan berikutnya
```
Hasilnya kemungkinan galat batas tumpukan (`RangeError`) atau peringatan `[uji]`. Jangan dipakai di kode nyata.

**Pola pencegahan:**

1. **Penjaga kesetaraan** (paling sederhana):
```qml
property int nilai: 0
onNilaiChanged: {
    const v = Math.max(0, Math.min(10, nilai))
    if (v !== nilai) nilai = v        // hanya menugaskan bila perlu
}
```
2. **Bendera re-entrancy:**
```qml
property bool memperbaiki: false
onNilaiChanged: {
    if (memperbaiki) return
    memperbaiki = true
    try { nilai = Math.max(0, Math.min(10, nilai)) }
    finally { memperbaiki = false }
}
```
- `try/finally` memastikan bendera selalu dikembalikan walau terjadi galat.
- Pada kedua pola, penerima lain tetap sempat melihat nilai perantara (15 sebelum diperbaiki menjadi 10), yaitu *glitch* seperti di 3.1.1.
3. **Rancang ulang tanpa handler** (terbaik):
```qml
property int mentah: 0
readonly property int nilai: Math.max(0, Math.min(10, mentah))
```
Nilai tak pernah sempat salah, tak ada handler, tak ada rekursi. Pola ini mengubah "koreksi setelah terjadi" menjadi "turunan yang selalu benar".
4. **Tunda:** `Qt.callLater(fn)` memindahkan koreksi ke giliran berikutnya (Modul 2.4.3), dengan akibat nilai salah sempat terlihat sebentar.

**Hubungan dengan binding loop (3.1.4):**

| | Binding loop | Rekursi handler |
|---|---|---|
| Penyebab | Dua binding saling bergantung | Handler menugaskan properti yang memicu dirinya |
| Pendeteksi | Mesin mencetak peringatan dan memutus | Tidak ada pendeteksi; berhenti hanya bila nilai konvergen atau tumpukan habis |
| Obat | Putus arah, properti perantara | Penjaga, bendera, atau desain turunan |

| Kesalahan | Solusi |
|---|---|
| `onXChanged: x = x + 1` | Jangan; gunakan penjaga atau turunan |
| Dua handler saling menimpa (`aChanged` ↔ `bChanged`) | Penjaga kesetaraan dengan toleransi (3.1.4) |
| Mengira kode setelah penugasan melihat nilai lama | Handler sudah berjalan di dalam penugasan |
| Mengubah properti yang dibaca binding dari dalam handler binding itu | Putus siklusnya |

**Referensi:** [Signals & Slots: penjaga nilai](https://doc.qt.io/qt-5/signalsandslots.html) · [Property change signal handlers](https://doc.qt.io/qt-6/qtqml-syntax-signals.html#property-change-signal-handlers)

---

### 3.2.7 Merancang antarmuka komponen dan mendiagnosis sinyal `[TAMBAHAN]`

*Antarmuka yang baik menjawab tiga pertanyaan: apa yang bisa saya minta, apa yang bisa saya lihat, apa yang bisa saya dengar.*

**Memilih bentuk API komponen:**

| Pertanyaannya | Bentuk | Contoh |
|---|---|---|
| "Lakukan ini." | Fungsi | `kirim(isi)` |
| "Apa keadaanmu sekarang?" | Properti | `jumlahPesan` |
| "Kabari saya jika ..." | Sinyal | `pesanTerkirim(isi)` |
| "Terima nilai ini dari saya" | Properti yang bisa ditulis | `penerima` |

**Aturan praktis:**
- Keadaan yang bisa dibaca kapan saja = properti. Peristiwa sesaat = sinyal.
- Jangan membuat sinyal untuk sekadar mengabarkan perubahan properti. Sudah ada `onXChanged`.
- Komponen tidak memanggil fungsi komponen luar. Ia memancarkan sinyal dan membiarkan pemilik memutuskan (prinsip isolasi dari 2.2.4).
- Hindari sinyal yang menuntut penerima membalas lewat nilai kembalian. Sinyal tidak punya balasan.

**Mendiagnosis sinyal:**

| Pertanyaan | Alat |
|---|---|
| "Siapa yang memancarkan ini?" | `console.trace()` di dalam handler (jejak 10 frame terakhir) |
| "Handler tak terpicu" | Cek nama (`onX` kapital), `target` `Connections`, `enabled`, dan `qmllint` |
| "Terpicu terlalu sering" | `console.count('nama')` di handler (Modul 2.4.4) |
| "Koneksi menggantung" | Pesan galat dari penerima yang sudah hilang, lalu cari `connect` tanpa `disconnect` |
| "Mana urutan sebenarnya?" | Cetak penanda di tiap penerima (latihan di bawah) |

---

## E. Latihan 15 menit dan kunci jawaban

**Latihan (dari kurikulum):** buat komponen dengan signal `selesai(int hasil)`, sambungkan ke dua handler berbeda, dan cetak urutan pemanggilannya.

```qml
import QtQml

QtObject {
    id: root
    signal selesai(hasil: int)

    onSelesai: hasil => console.log('handler bawaan:', hasil)

    Connections {
        target: root
        function onSelesai(hasil) { console.log('connections:', hasil) }
    }

    function viaConnect(h: int) { console.log('connect():', h) }

    Component.onCompleted: {
        selesai.connect(viaConnect)
        selesai(1)
        Qt.quit()
    }
}
```
Hasilnya tiga baris. Urutannya mengikuti urutan *sambungan*: handler bawaan terhubung saat objek dibuat, `Connections` saat dibuat, dan `connect()` saat `onCompleted` berjalan. Prediksi `[uji]`: `handler bawaan`, `connections`, lalu `connect():`. Tulis hasil nyata Anda sebagai catatan versi Qt.

**Cek pemahaman:** *Mengapa `Connections` lebih rapi daripada `connect()` manual untuk target yang berubah-ubah?* Karena `target` dapat diikat ke binding, dan `Connections` otomatis memutus dari target lama lalu menyambung ke yang baru. Dengan `connect()` Anda harus `disconnect` dan `connect` ulang sendiri, dan koneksi lama bisa tertinggal.

**Pertanyaan tambahan:**
1. *Mengapa `ping(2)` dari A tidak terdengar setelah `sumber` pindah ke B?* Karena `target` mengikuti `sumber`.
2. *Mengapa `nilai = 1` dua kali hanya memicu satu `onNilaiChanged`?* Sinyal perubahan hanya terpancar bila nilai berbeda.
3. *Mengapa ada tiga baris `x = 3` pada 3.2.6?* Karena emisi sinkron: handler tingkat dalam selesai lebih dulu, lalu setiap tingkat luar mencetak setelah nilai sudah berubah.

**Tantangan:** ubah contoh `nilai` pada 3.2.6 menjadi pola ke-3 (properti `mentah` + `readonly property nilai`), lalu buktikan dengan `console.count` bahwa tidak ada handler yang dipicu berulang.

---

## F. Glosarium Modul 3.2

| Istilah | Arti |
|---|---|
| Signal | Peristiwa yang dipancarkan sebuah objek |
| Emit | Memancarkan sinyal (memanggilnya seperti fungsi) |
| Handler (`onX`) | Kode yang dijalankan saat sinyal terpancar |
| Change signal | Sinyal otomatis `xChanged` untuk setiap properti |
| Attached handler | Handler dari tipe terlampir, mis. `Component.onCompleted` |
| `Connections` | Tipe untuk menyambung ke sinyal objek lain |
| `connect()` / `disconnect()` | Menyambung/memutus sinyal ke fungsi atau sinyal lain |
| Signal chain | Rantai: sinyal yang menyambung ke sinyal lain |
| Direct connection | Penerima dijalankan seketika, di utas yang sama |
| Queued connection | Penerima dijalankan belakangan, di utas penerima |
| Re-entrancy | Handler dipanggil lagi saat sedang berjalan |
| Penjaga kesetaraan | Pemeriksaan "ubah hanya bila berbeda" |
| Loose coupling | Pengirim tak mengenal penerima |
| Koneksi menggantung | Koneksi yang bertahan setelah penerima hilang |

---

## G. Hubungan dengan modul lain

| Modul | Hubungan |
|---|---|
| **2.2.2 dan 2.2.7** | Dasar yang diperdalam di sini |
| **3.1** Property Binding | Penjaga kesetaraan (3.1.4) dan rekursi handler (3.2.6) saling melengkapi |
| **3.3** Lifecycle | `Component.onDestruction` untuk memutus koneksi manual |
| **3.4** Scope | `id` dan scope untuk menjangkau pengirim dari `Connections` |
| **Fase 10** C++ | Sinyal C++, `NOTIFY`, koneksi lintas utas |
| **Modul 2.4** | `console.trace`, `console.count`, `Qt.callLater` sebagai alat bantu |

**Prasyarat Modul 3.3:** menguasai 3.2.1 sampai 3.2.4. Bagian 3.2.6 sangat dianjurkan sebelum menulis komponen yang bereaksi terhadap perubahannya sendiri.

---

<!-- **Catatan tautan:** halaman Qt yang saya buka langsung adalah Connections dan Signal and Handler Event System (6.12). Urutan pemanggilan dan emisi sinkron saya ambil dari dokumentasi C++ Signals & Slots, yang cuplikannya berasal dari beberapa versi (5.x dan 6.12), sehingga perilaku di QML perlu Anda uji. Halaman `qtqml-cppintegration-exposecppattributes` dan MDN tidak saya buka satu per satu. Bila ada yang tidak terbuka, kabari saya. -->
# Fase 3 · Modul 3.3 — Lifecycle Objek

---

## A. Audit singkat

**Tumpang tindih dengan Fase 2.** `Component.onCompleted` dan `onDestruction` sudah ada di **2.2.6**, dan `Qt.callLater` di **2.4.3**. Di sini tidak mengulangnya, melainkan memperdalam: fase pembuatan, penghancuran, pembuatan dinamis, dan `Loader`.

**Terverifikasi:**
- `completed()` dipancarkan setelah objek selesai diinstansiasi, saat seluruh lingkungan QML sudah terbentuk. Handler `onCompleted` boleh dipasang di objek mana pun, dan urutan eksekusinya tidak terdefinisi. Catatan kurikulum benar.
- `destruction()` dipancarkan saat objek mulai dihancurkan, dan dipakai untuk membatalkan pekerjaan yang dilakukan sebagai tanggapan atas `completed` atau kode imperatif lain. Urutan handler-nya juga tidak terdefinisi.
- `Qt.callLater(fungsi)` menjalankan fungsi setelah mesin kembali ke event loop, dan pemanggilan berturut-turut dengan fungsi yang sama digabung menjadi satu. Catatan kurikulum benar.
- Aman memanggil `destroy()` pada sebuah objek dari dalam objek itu sendiri.

**Perlu dikoreksi atau dilengkapi:**
1. **Contoh kurikulum tidak berhenti sendiri dan butuh jendela.** Akarnya `Item` dengan `Rectangle`, jadi `qml` membuka jendela dan menunggu. Gunakan varian `QtObject` di bawah, atau tambahkan `Qt.quit()` dan jalankan dengan `QT_QPA_PLATFORM=offscreen`. Pesan `'induk dihancurkan'` juga belum tentu tercetak saat aplikasi keluar `[uji]`.
2. **`destroy()` tidak sembarang.** Kurikulum menyebutnya tanpa aturan. Dokumentasi menetapkan:
   - Objek hanya bisa dihancurkan secara dinamis bila dibuat secara dinamis. Memanggil `destroy()` pada objek yang dibuat statis menghasilkan galat.
   - Jangan menghapus manual objek yang dibuat oleh pabrik objek seperti `Loader` dan `Repeater`, dan hindari menghapus objek yang tidak Anda buat sendiri.
   - `destroy()` punya argumen opsional berupa penundaan dalam milidetik (bawaan 0). Objek tidak langsung dihancurkan, melainkan dibersihkan di antara akhir blok skrip dan frame berikutnya.
3. **Konteks pembuatan harus lebih panjang umurnya.** Bila konteks pembuatan dihancurkan lebih dulu, binding dan signal handler pada objek dinamis tidak lagi bekerja. Objek dinamis juga tidak punya `id`. Keduanya belum ada di kurikulum.
4. **Kepemilikan dan pengumpul sampah.** Bila `createObject()` dipanggil tanpa induk, Anda harus menyimpan referensi ke objek itu agar tak dihancurkan garbage collector. Menetapkan `Item::parent` sesudahnya tidak mengubah kepemilikan, hanya induk grafisnya.
5. **Nilai awal lewat argumen kedua.** Nilai properti yang diberikan ke `createObject` diterapkan sebelum pembuatan difinalkan, lebih efisien, dan memungkinkan binding dipasang (dengan `Qt.binding`) sebelum objek dibuat. Ini juga menghindari galat binding bila properti tertentu harus terisi lebih dulu.
6. **Pembuatan asinkron dan penanganan galat** tidak disebut. `incubateObject` membuat instans tanpa membekukan UI (bawaannya asinkron). `Component.status` bernilai `Null`, `Ready`, `Loading`, atau `Error`, dan `errorString()` mendeskripsikan galatnya. `createObject` mengembalikan `null` bila gagal.
7. **`Loader` lebih dari sekadar "objek tertunda".** Bila `source` atau `sourceComponent` berubah, item lama dihancurkan. `active: false` melepas item tanpa mengubah sumbernya. `asynchronous` membuat instansiasi tersebar di beberapa frame. Rincian di 3.3.5.
8. **Peringatan keamanan.** Objek tidak boleh dibuat secara dinamis dari sumber tak tepercaya, dan batasan untuk sumber QML statis berlaku sama. Ini masuk 3.3.3 dan 3.3.6.
9. **`Qt.callLater` bukan penunda waktu, dan identitas fungsi menentukan penggabungan.** Sudah ada di 2.4.3. Di 3.3.4 saya tambahkan bahwa fungsi anonim yang dibuat baru setiap kali tidak digabung `[uji]`.

**TAMBAHAN:** **3.3.6** Pola aman siklus hidup dan diagnosis, supaya pembuatan, pemakaian, dan pembuangan objek dipasangkan secara disiplin.

---

## B. Daftar isi Modul 3.3 (diperbarui)

- **3.3.1** Fase pembuatan objek (+ nilai awal, konteks, kepemilikan) `[diperluas]`
- **3.3.2** `onCompleted` dan sifat urutannya
- **3.3.3** Penghancuran dan `destroy()` (+ aturan, penundaan, akses setelah mati) `[diperluas]`
- **3.3.4** `Qt.callLater` (+ identitas fungsi dan argumen terakhir) `[diperluas]`
- **3.3.5** `Loader` dan objek yang dibuat tertunda (+ dinamis, asinkron) `[diperluas]`
- **3.3.6** Pola aman siklus hidup dan diagnosis `[TAMBAHAN]`
- Latihan dan kunci jawaban · Glosarium · Hubungan dengan modul lain

**Urutan belajar yang disarankan:** 3.3.1 → 3.3.2 → 3.3.3 → 3.3.4 → 3.3.5 → 3.3.6.

---

## C. Peta besar

```
  dibuat ───────► hidup ───────► dihancurkan
    │               │                │
 nilai awal      binding,         onDestruction
 + binding       sinyal,          (bersih-bersih)
    │            handler                │
 onCompleted        │              objek hilang
 ("siap")           │              (referensi jadi tak valid)
    └───── pencipta: Component/createObject, Loader, Repeater, deklarasi statis
```

**Filosofinya:** setiap objek memiliki *pemilik* dan *umur*. Kebocoran, akses ke objek mati, dan startup lambat hampir selalu bermuara pada dua pertanyaan yang tak dijawab: siapa pemilik objek ini, dan kapan ia boleh mati? Disiplin siklus hidup sama pentingnya dengan disiplin memori di C++.

**Cara menjalankan contoh:**
- Berkas berbasis `QtObject`: `qml -a core nama.qml`.
- Berkas visual (`Item`, `Loader`): `QT_QPA_PLATFORM=offscreen qml nama.qml` (laboratorium 2.1.0).

---

## D. Materi

### 3.3.1 Fase pembuatan objek

*Tahu urutan kelahiran menghindarkan Anda dari menyentuh sesuatu yang belum ada.*

**Konsep.** Sebuah objek QML tidak langsung "siap pakai" begitu muncul di memori. Ia dibuat, diberi nilai awal, dipasangi binding, baru kemudian dinyatakan siap. Hanya bagian-bagian yang didokumentasikan yang boleh Anda andalkan:

```
 Component ──createObject(parent, {nilai awal})──►
   ① objek dibangun
   ② nilai awal dari argumen {…} diterapkan   ← SEBELUM pembuatan difinalkan
   ③ binding dipasang dan dievaluasi
   ④ Component.completed → onCompleted dijalankan     (urutan antarobjek: TAK TERDEFINISI)
      ... objek hidup ...
   ⑤ destroy() / pemilik menghancurkan / GC
   ⑥ Component.destruction → onDestruction            (urutan antarobjek: TAK TERDEFINISI)
```
Langkah ② dan ④ dan ⑥ bersumber dari dokumentasi. Urutan internal ① dan ③ saya sederhanakan.

**Peragaan: lingkungan sudah terbentuk saat `onCompleted`.**
```qml
import QtQml

QtObject {
    property int a: 1
    property int b: a * 2

    QtObject { Component.onCompleted: console.log('anak 1 siap') }
    QtObject { Component.onCompleted: console.log('anak 2 siap') }
    QtObject { Component.onCompleted: console.log('anak 3 siap') }

    Component.onCompleted: console.log('induk siap, b =', b)    // b = 2
}
```

**Bedah kode:**
- `property int b: a * 2`: binding yang sudah terpasang ketika `onCompleted` jalan, jadi `b` bernilai 2.
- Tiga `QtObject` anak ditambahkan lewat *default property* `data` (2.2.5).
- Setiap objek memiliki `Component.onCompleted` sendiri. Handler ini boleh ada di objek mana pun, dan urutan menjalankannya tidak terdefinisi. Jalankan beberapa kali dan catat urutan yang Anda lihat, tetapi **jangan mengandalkannya**.

**Nilai awal dan konteks (untuk objek dinamis):**
- Argumen kedua `createObject` adalah peta nilai awal. Nilai itu diterapkan sebelum pembuatan difinalkan, menghindari galat binding bila properti tertentu harus terisi agar binding lain bekerja.
- Objek dibuat dalam konteks tempat `Component` dibuat. Itu yang membuat objek hasil `createObject` bisa memakai `id` dan properti dari konteks asalnya.
- Konteks pembuatan harus hidup lebih lama daripada objek yang dibuat.

**Kepemilikan.**

| Cara membuat | Pemilik | Konsekuensi |
|---|---|---|
| Deklarasi statis di QML | Objek induk dalam dokumen | Hidup selama induknya |
| `createObject(parent, ...)` | `parent` | Hancur bersama `parent` |
| `createObject(null, ...)` | Referensi JavaScript | Wajib menyimpan referensi, atau GC dapat menghancurkannya. |
| `Loader`, `Repeater` | Pabrik itu sendiri | Jangan dihancurkan manual (3.3.3) |

**Opsi lain, cara memberi nilai awal pada objek dinamis:**

| Cara | Kapan |
|---|---|
| `createObject(parent, { x: 1 })` | Dianjurkan: sebelum finalisasi |
| `obj.x = 1` setelah dibuat | Sederhana, tetapi binding lain sempat melihat nilai kosong |
| `{ x: Qt.binding(() => ...) }` | Nilai awal berupa binding |
| `required property` (Fase berikut) | Memaksa pencipta mengisi nilai awal |

| Kesalahan | Solusi |
|---|---|
| Mengakses objek tetangga di `onCompleted` dan berasumsi sudah siap | Urutan tak terdefinisi. Pakai binding atau sinyal |
| Mengisi properti setelah objek dibuat, binding sempat salah | Berikan sebagai nilai awal |
| `createObject(null)` lalu referensi dilepas | Simpan referensi atau beri induk |
| Konteks pembuatan hancur lebih dulu | Pastikan ia hidup lebih lama |

**Referensi:** [Component](https://doc.qt.io/qt-6/qml-qtqml-component.html) · [Dynamic QML Object Creation from JavaScript](https://doc.qt.io/qt-6/qtqml-javascript-dynamicobjectcreation.html)

---

### 3.3.2 `onCompleted` dan sifat urutannya

*Siap bukan berarti semua orang sudah siap.*

Ringkasan dari 2.2.6, ditambah yang baru:
- `completed` bisa dipakai menjalankan skrip saat startup, setelah seluruh lingkungan QML terbentuk.
- Bila ada beberapa `onCompleted`, urutannya tak terdefinisi. Objek A tidak boleh bergantung pada B yang "pasti sudah siap".
- Pekerjaan berat di `onCompleted` memperlambat startup, karena aplikasi baru tampil setelah semuanya selesai.

**Pola menyebar pekerjaan awal:**

| Pekerjaan | Cara |
|---|---|
| Nilai awal sederhana | Deklarasikan sebagai properti (tanpa `onCompleted`) |
| Langkah awal imperatif kecil | `Component.onCompleted` |
| Pekerjaan berat yang boleh menunggu | `Qt.callLater(fn)` atau `Timer { interval: 0 }` |
| Komponen berat yang tak langsung dibutuhkan | `Loader` (3.3.5) atau `incubateObject` (3.3.3) |

**Contoh ketergantungan yang benar (tanpa mengandalkan urutan):**
```qml
import QtQml

QtObject {
    id: root
    property bool siap: false
    property string status: siap ? 'siap' : 'menunggu'

    QtObject { Component.onCompleted: root.siap = true }
    Component.onCompleted: console.log(status)
}
```
Hasilnya tergantung urutan `onCompleted` (`menunggu` atau `siap`), sehingga kode seperti ini rapuh `[uji]`. Perbaikannya: jangan membaca `status` di `onCompleted`, tetapi pasang `onStatusChanged` atau `Binding` yang bereaksi kapan pun `siap` berubah. Binding bekerja tanpa peduli urutan.

| Kesalahan | Solusi |
|---|---|
| Menganggap anak selalu siap sebelum induk (atau sebaliknya) | Urutan tak terdefinisi; gunakan binding/sinyal |
| Banyak kerja di `onCompleted` | Tunda atau tarik ke `Loader` |
| Menugaskan properti ber-binding di `onCompleted` | Binding terputus (2.2.8) |

**Referensi:** [Component: completed()](https://doc.qt.io/qt-6/qml-qtqml-component.html#completed-signal)

---

### 3.3.3 Penghancuran dan `destroy()`

*Membuang dengan benar sama berharganya dengan membuat dengan benar.*

**Peragaan lengkap: buat, simpan, hancurkan, periksa.**
```qml
import QtQml

QtObject {
    id: root
    property Component cetakan: Component {
        QtObject {
            property string nama: ''
            Component.onCompleted: console.log('lahir:', nama)
            Component.onDestruction: console.log('mati :', nama)
        }
    }
    property var daftar: []

    Component.onCompleted: {
        for (const n of ['a', 'b', 'c']) {
            const o = cetakan.createObject(root, { nama: n })
            daftar.push(o)
        }
        console.log('dibuat:', daftar.length)          // 3
        daftar[1].destroy()
        console.log('destroy dipanggil')               // objek BELUM mati di titik ini
    }

    Timer {
        interval: 50; running: true
        onTriggered: {
            try { console.log(daftar[1].nama) }
            catch (e) { console.log('akses setelah mati:', e.name) }
            Qt.quit()
        }
    }
}
```
Keluaran yang diharapkan: `lahir: a`, `lahir: b`, `lahir: c`, `dibuat: 3`, `destroy dipanggil`, `mati : b`, lalu `akses setelah mati: TypeError` `[uji]`.

**Bedah kode:**
- `property Component cetakan: Component { QtObject {...} }`: *templat* objek. Satu `Component` memuat satu objek akar.
- `cetakan.createObject(root, { nama: n })`: membuat instans dengan `root` sebagai induk, `nama` sebagai nilai awal.
- `daftar.push(o)`: menyimpan referensi. Aman walau tak mengisi ulang properti, karena tak ada binding yang bergantung pada `daftar`.
- `daftar[1].destroy()`: menjadwalkan penghancuran. `'destroy dipanggil'` tercetak **sebelum** `'mati : b'`, karena objek dibersihkan di antara akhir blok skrip dan frame berikutnya.
- `Timer` 50 ms: menunggu sampai penghancuran benar-benar terjadi, lalu menguji akses ke objek mati. Jenis galat persisnya `[uji]`.

**Aturan `destroy()` (dari dokumentasi):**
- `destroy()` punya argumen opsional (bawaan 0) untuk menunda penghancuran kira-kira sekian milidetik. Contoh: `newObject.destroy(1000)`.
- Hanya untuk objek yang **Anda buat sendiri** secara dinamis. Objek yang dibuat statis di QML tak bisa dihancurkan secara dinamis, dan mencobanya menghasilkan galat.
```qml
QtObject { id: statis; Component.onCompleted: statis.destroy() }    // galat (jenis pesan [uji])
```
- Jangan menghapus manual objek yang dibuat oleh `Loader` dan `Repeater`. Matikan lewat `Loader.active` atau ubah `source`.
- Pada antarmuka visual, kadang cukup `opacity: 0` atau menggesernya keluar layar. Menghapus objek yang tak dipakai bermanfaat bila jumlahnya banyak.

**Akses setelah mati.** Setelah `destroy()` selesai, referensi JavaScript ke objek itu tidak lagi valid. Membaca propertinya melempar galat (`TypeError` `[uji]`), atau membaca `null`. Karena itu: hapus referensi dari daftar Anda saat menghancurkan:
```js
const mati = daftar[1]
daftar = daftar.filter(o => o !== mati)     // ganti array agar binding pembaca ikut berubah (3.1.5)
mati.destroy()
```

**Pembuatan asinkron (`incubateObject`).**
```js
const inkubator = cetakan.incubateObject(root, { nama: 'x' })     // bawaan: asinkron
if (inkubator.status !== Component.Ready)
    inkubator.onStatusChanged = status => { if (status === Component.Ready) console.log(inkubator.object) }
```
Inkubator membuat instans tanpa membekukan UI, dengan `status`, `object`, `onStatusChanged`, dan `forceCompletion()`. Meski diminta sinkron, dalam keadaan tertentu pembuatan tetap asinkron, misalnya bila komponen pemanggilnya sendiri dibuat secara asinkron.

**Membuat komponen dari berkas, dengan penanganan galat:**
```js
const komponen = Qt.createComponent('Sprite.qml')
if (komponen.status === Component.Ready) {
    const o = komponen.createObject(parent, { x: 100, y: 100 })
    if (o === null) console.log('gagal membuat objek')
} else if (komponen.status === Component.Error) {
    console.log('galat memuat:', komponen.errorString())
}
```
Dokumentasi menunjukkan pola ini, termasuk menyambung `komponen.statusChanged` bila berkas belum siap (jaringan). Jalur relatif diselesaikan relatif terhadap berkas tempat `Qt.createComponent()` dijalankan.

**Peringatan keamanan.**
- Objek tidak boleh dibuat dinamis dari sumber tak tepercaya, dan batasan untuk sumber QML statis berlaku sama. Rujukan: [Untrusted data](https://doc.qt.io/qt-6/untrusteddata.html) (tidak saya buka langsung).
- `Qt.createQmlObject` sangat lambat karena mengompilasi string QML setiap kali dan mudah menghasilkan QML tak valid. Jangan merakit QML dari masukan pengguna. Itu setara menjalankan kode asing. Simpan komponen sebagai berkas, lalu sesuaikan lewat properti.

**Opsi lain:**

| Kebutuhan | Cara |
|---|---|
| Satu objek dinamis | `Component.createObject` |
| Tanpa membekukan UI | `incubateObject` atau `Loader { asynchronous: true }` |
| Banyak objek dari data | `Repeater`/`Instantiator` (tidak saya buka langsung) atau model |
| Menyembunyikan saja | `visible: false`/`opacity: 0` |
| QML dari string | **Hindari** `Qt.createQmlObject` |

| Kesalahan | Solusi |
|---|---|
| `destroy()` pada objek statis | Pakai `Loader` atau `visible`; destroy hanya untuk yang dibuat dinamis |
| Menghancurkan objek buatan `Loader` | Ubah `active`/`source` |
| Memakai objek tepat setelah `destroy()` | Hapus referensi; objek baru mati kemudian |
| Lupa memeriksa `status` dan `null` | Cek `Component.Ready` dan hasil `createObject` |
| Konteks hancur lebih dulu | Pastikan konteks lebih panjang umurnya |

**Referensi:** [Dynamic QML Object Creation: deleting objects](https://doc.qt.io/qt-6/qtqml-javascript-dynamicobjectcreation.html#deleting-objects-dynamically) · [Component: createObject, incubateObject](https://doc.qt.io/qt-6/qml-qtqml-component.html#createObject-method)

---

### 3.3.4 `Qt.callLater`

*Kadang yang Anda butuhkan bukan menunggu, melainkan bersabar sampai giliran Anda.*

**Konsep.** `Qt.callLater(fungsi, argumen...)` mendaftarkan fungsi untuk dijalankan **setelah mesin kembali ke event loop**, bukan setelah sekian detik. Pemanggilan berulang dengan fungsi yang sama dalam putaran event yang sama hanya dijalankan sekali, dengan argumen dari pemanggilan terakhir.

```qml
import QtQml

QtObject {
    property int hitung: 0
    function muat() { hitung++ }
    function tampil(x) { console.log('x =', x) }

    Component.onCompleted: {
        Qt.callLater(muat); Qt.callLater(muat); Qt.callLater(muat)               // fungsi sama → sekali
        Qt.callLater(tampil, 1); Qt.callLater(tampil, 2)                          // sekali, argumen terakhir: x = 2
        Qt.callLater(() => { hitung += 10 }); Qt.callLater(() => { hitung += 10 }) // fungsi anonim BEDA → dua kali [uji]
        Qt.callLater(() => { console.log('hasil:', hitung); Qt.quit() })           // 1 + 20 = 21 [uji]
    }
}
```

**Bedah kode:**
- `Qt.callLater(muat)` tiga kali: satu eksekusi `muat`. `hitung` bertambah satu.
- `Qt.callLater(tampil, 1)` lalu `(tampil, 2)`: satu eksekusi, dengan argumen terakhir, yaitu `x = 2`.
- Dua panah `() => { hitung += 10 }` yang ditulis dua kali adalah dua objek fungsi berbeda, jadi penggabungan berdasarkan identitas tidak berlaku. Keduanya berjalan, sehingga `hitung` menjadi 21 `[uji]`. Untuk penggabungan, beri **nama** fungsinya.
- Panggilan terakhir mencetak hasil setelah semua yang tertunda jalan (urutan pendaftaran `[uji]`).

**Kapan tepat dipakai:**

| Situasi | Alasan |
|---|---|
| Beberapa properti berubah beruntun dan Anda ingin menghitung ulang sekali | Penggabungan panggilan |
| Perlu menunda sampai tumpukan panggilan sekarang selesai | Kembali ke event loop dulu |
| Memutus siklus handler (3.2.6) | Memindahkan koreksi ke giliran berikutnya |
| **Bukan** untuk menunggu 1 detik | Pakai `Timer` (2.4.7) |

**Kapan tidak tepat:** bila hasilnya dibutuhkan segera di baris berikutnya, atau bila urutan relatif terhadap objek lain harus pasti. `callLater` menjamin "nanti", bukan "kapan persisnya".

| Kesalahan | Solusi |
|---|---|
| Mengira `callLater` menunda sekian milidetik | Itu `Timer` |
| Fungsi anonim baru tiap panggilan, lalu heran tak tergabung | Beri nama dan rujuk fungsi yang sama |
| Mengira urutan terhadap objek lain pasti | Jangan mengandalkan |
| Menaruh kerja berat di dalamnya | Tetap berjalan di utas UI; pecah |

**Referensi:** [Qt.callLater](https://doc.qt.io/qt-6/qml-qtqml-qt.html#callLater-method)

---

### 3.3.5 `Loader` dan objek yang dibuat tertunda

*Jangan membangun rumah yang belum akan dihuni.*

**Konsep.** `Loader` adalah `Item` yang memuat komponen **sesuai permintaan**. Ia berguna menunda pembuatan komponen sampai dibutuhkan, misalnya saat dibuat atas permintaan atau demi kinerja.

```qml
import QtQuick

Item {
    id: root
    width: 100; height: 100

    Component {
        id: halaman
        Item {
            Component.onCompleted: console.log('halaman: lahir')
            Component.onDestruction: console.log('halaman: mati')
        }
    }

    Loader {
        id: pemuat
        active: false
        sourceComponent: halaman
        onLoaded: console.log('loaded; item ada =', item !== null)
    }

    Timer { interval: 100; running: true; onTriggered: { console.log('aktifkan'); pemuat.active = true } }
    Timer { interval: 300; running: true; onTriggered: { console.log('nonaktifkan'); pemuat.active = false } }
    Timer { interval: 600; running: true; onTriggered: Qt.quit() }
}
```
Jalankan dengan `QT_QPA_PLATFORM=offscreen qml loader.qml`. Keluaran yang diharapkan: `aktifkan`, `halaman: lahir`, `loaded; item ada = true`, `nonaktifkan`, `halaman: mati` `[uji urutan lahir dan loaded]`.

**Bedah kode:**
- `Component { id: halaman; Item {...} }`: templat. Komponen yang didefinisikan di dalam `Component` tidak dimuat sampai diminta.
- `active: false`: bila Loader tidak aktif, mengubah `source` atau `sourceComponent` tidak menginstansiasi item sampai Loader diaktifkan. Bawaannya `true`.
- `pemuat.active = true`: `Loader` membuat instans dari `halaman`, dan `onCompleted` di dalamnya berjalan.
- `onLoaded`: dipancarkan saat `status` menjadi `Loader.Ready`, atau pada pemuatan awal yang berhasil. `item` adalah objek akar yang dimuat.
- `pemuat.active = false`: item yang dimuat dilepas, tanpa mengubah `source` atau `sourceComponent`. `onDestruction` jalan.

**Properti penting (dari dokumentasi 6.12):**

| Properti | Perilaku |
|---|---|
| `source` / `sourceComponent` | Bila berubah, item sebelumnya dihancurkan. String kosong atau `undefined` membongkar item dan mengosongkan Loader. |
| `active` | Mengaktifkan atau melepas tanpa mengubah sumber |
| `asynchronous` | Bawaan `false`. Bila `true`, objek dibuat tersebar di beberapa frame, dan `status` menjadi `Loading` lalu `Ready`. Dipadu dengan `source`, pemuatan dan kompilasi juga di utas latar. |
| `status` | `Null`, `Ready`, `Loading`, `Error` |
| `item` | Objek akar yang dimuat |
| `setSource(url, props)` | Memuat dengan nilai awal. Bila Loader tak aktif, sumber dan properti awal disimpan dan dipakai saat Loader diaktifkan. |

**Catatan khusus:**
- Bila sumber adalah berkas lokal, `status` sejak awal `Ready` (atau `Error`), dan tidak ada `onStatusChanged`, tetapi `onLoaded` tetap dipanggil. Andalkan `onLoaded`.
- **Mendengarkan item yang dimuat:** Sinyal dari objek yang dimuat dapat diterima dengan `Connections`.
  ```qml
  Connections { target: pemuat.item; function onMessage(msg) { console.log(msg) } }
  ```
  `target` mengikuti `item`, jadi otomatis berganti saat item baru dimuat (3.2.3).
- **Ukuran:** Bila ukuran Loader tak ditentukan, ia menyesuaikan item yang dimuat. Bila ditentukan atau di-anchor, item yang dimuat diubah ukurannya mengikuti Loader.
- **Fokus:** Loader adalah *focus scope*, jadi `focus: true` perlu diset pada Loader agar anaknya bisa mendapat fokus aktif.
- **Loader di dalam delegate:** Konteks `index` milik delegate tidak terlihat oleh komponen yang dibuat Loader dengan konteks pembuatan lain. Tiga jalan keluar: pindahkan komponen ke dalam (inline), pindahkan ke berkas terpisah, atau kirim sebagai properti Loader (`property int modelIndex: index`).

**Opsi lain, memuat tertunda:**

| Kebutuhan | Pilihan |
|---|---|
| Satu komponen sesuai permintaan | `Loader` |
| Satu per satu dari kode | `Component.createObject` / `incubateObject` |
| Daftar komponen dari model | `Repeater`/`ListView` (tidak saya buka langsung) |
| Tanpa tampilan (logika) | `Loader` juga bisa memuat objek non-visual (sejak QtQuick 2.0) |
| Sekadar sembunyikan | `visible: false` |

| Kesalahan | Solusi |
|---|---|
| Mengakses `loader.item` sebelum selesai | Tunggu `onLoaded` atau periksa `status` |
| Menghancurkan objek hasil Loader manual | Ubah `active`/`source` |
| `index` tak terlihat dalam Loader di delegate | Kirim sebagai properti Loader |
| Berharap tampilan tak berkedip saat `asynchronous` | Bungkus dengan `visible: status === Loader.Ready` |
| Loader menarik fokus yang tak terduga | Atur `focus` secara eksplisit |

**Referensi:** [Loader](https://doc.qt.io/qt-6/qml-qtquick-loader.html) · [Qt: dynamic object creation](https://doc.qt.io/qt-6/qml-qtqml-qt.html#dynamic-object-creation)

---

### 3.3.6 Pola aman siklus hidup dan diagnosis `[TAMBAHAN]`

*Setiap yang dibuat harus punya pasangan: siapa yang membuangnya.*

**Pasangan yang harus seimbang:**

| Dibuat | Dibuang oleh |
|---|---|
| `createObject(parent, ...)` | Induk, atau `destroy()` Anda sendiri |
| `createObject(null, ...)` | Anda: simpan referensi, lalu `destroy()` |
| `Loader` | `active: false`, atau mengubah `source` |
| `signal.connect(fn)` | `signal.disconnect(fn)` (3.2.4) |
| `Timer { running: true }` | `running: false`, atau objek induk hancur |
| Handler yang menyimpan referensi objek | Putus di `Component.onDestruction` |

**Pola bersih-bersih:**
```qml
Item {
    property var penanda: () => { /* ... */ }
    Component.onCompleted: sumber.nilaiChanged.connect(penanda)
    Component.onDestruction: sumber.nilaiChanged.disconnect(penanda)
}
```
(`property var` untuk fungsi `[uji]`.) Karena objek hasil `createObject` hanya bisa dipakai selama konteks pembuatannya hidup, pastikan objek dinamis yang merujuk konteks lain dibuang lebih dulu.

**Diagnosis:**

| Gejala | Dugaan | Alat |
|---|---|---|
| "Cannot read property … of null" | Memakai objek yang sudah dihancurkan | `console.trace()` di tempat terjadi |
| Binding/handler objek dinamis diam | Konteks pembuatan sudah hilang | Periksa umur pencipta |
| Objek lenyap tanpa sebab | `createObject(null)` tanpa referensi (kena GC) | Simpan referensi, atau beri induk |
| Startup lambat | Terlalu banyak kerja di `onCompleted` | Tunda, `Loader`, `incubateObject` |
| `destroy()` galat | Objek dibuat statis | Pakai `Loader` atau `visible` |
| Objek tak kunjung hilang | Pemilik masih memegang | Cek induk dan referensi |

**Rutinitas:** catat `onCompleted` dan `onDestruction` dengan `console.log` saat mengembangkan komponen, lalu jalankan skenario "dibuat, dipakai, dibuang" dan pastikan jumlahnya seimbang (`console.count`, Modul 2.4.4).

---

## E. Latihan 15 menit dan kunci jawaban

**Latihan (dari kurikulum):** jalankan contoh, tambahkan dua anak lagi, dan amati bahwa Anda tidak boleh berasumsi urutan keluarannya.

```qml
import QtQml

QtObject {
    Component.onCompleted: console.log('induk siap')
    Component.onDestruction: console.log('induk dihancurkan')

    QtObject { Component.onCompleted: console.log('anak 1 siap') }
    QtObject { Component.onCompleted: console.log('anak 2 siap') }
    QtObject { Component.onCompleted: console.log('anak 3 siap') }

    Timer { interval: 50; running: true; onTriggered: Qt.quit() }
}
```
Jalankan `for i in 1 2 3 4 5; do qml -a core urutan.qml 2>&1 | tr '\n' '|'; echo; done`. Bandingkan urutan keluaran antar-putaran. Dokumentasi menyatakan urutan tak terdefinisi, jadi jangan menggantungkan logika pada urutan yang tampak stabil di mesin Anda. Apakah `'induk dihancurkan'` tercetak saat `Qt.quit()` `[uji]`.

**Cek pemahaman:** *Kapan `Qt.callLater` lebih tepat daripada memanggil fungsi langsung?* Bila Anda ingin menggabungkan beberapa pemicu beruntun menjadi satu eksekusi (misalnya beberapa properti berubah dan Anda cukup menghitung ulang sekali), atau menunda sampai tumpukan panggilan sekarang selesai. Bukan untuk menunggu durasi tertentu, itu tugas `Timer`.

**Pertanyaan tambahan:**
1. *Mengapa `destroy()` pada objek statis menghasilkan galat?* Karena dokumentasi hanya mengizinkan penghancuran objek yang dibuat dinamis.
2. *Mengapa `'destroy dipanggil'` tercetak sebelum `'mati : b'`?* Karena objek dibersihkan belakangan, di antara akhir blok skrip dan frame berikutnya.
3. *Mengapa objek tanpa induk bisa hilang sendiri?* Jika tak ada referensi, pengumpul sampah dapat menghancurkannya.
4. *Apa yang terjadi bila `active: false` pada Loader yang sudah memuat?* Item dilepas, `onDestruction` jalan, `source`/`sourceComponent` tetap.

**Tantangan:** ubah contoh `Loader` agar `asynchronous: true`, tambahkan `visible: status === Loader.Ready`, lalu catat urutan `status` (`Loading` lalu `Ready`) dengan `onStatusChanged`. Setelah itu coba `setSource('Lain.qml', { nama: 'x' })` saat `active: false` untuk membuktikan properti awal tersimpan sampai Loader diaktifkan.

---

## F. Glosarium Modul 3.3

| Istilah | Arti |
|---|---|
| Lifecycle | Rangkaian dibuat, hidup, dihancurkan |
| Instansiasi | Membuat objek dari definisi komponen |
| `Component` | Definisi komponen yang dimuat saat diminta |
| `createObject` | Membuat instans dari `Component` dengan induk dan nilai awal |
| Nilai awal (initial properties) | Properti yang diisi sebelum pembuatan difinalkan |
| Konteks pembuatan (creation context) | Konteks tempat komponen dideklarasikan atau dibuat |
| Kepemilikan | Siapa yang menentukan umur objek (induk atau referensi JS) |
| Garbage collector (GC) | Pembebas objek JavaScript yang tak direferensikan |
| `destroy()` | Menjadwalkan penghancuran objek dinamis |
| `incubateObject` | Membuat instans secara asinkron |
| `Loader` | `Item` yang memuat komponen sesuai permintaan |
| `active` | Saklar `Loader` untuk membuat atau melepas item |
| Asinkron | Dikerjakan tersebar, tanpa membekukan UI |
| `Qt.callLater` | Menjalankan fungsi setelah kembali ke event loop, dengan penggabungan |
| Focus scope | Pembatas fokus (Loader adalah salah satunya) |

---

## G. Hubungan dengan modul lain

| Modul | Hubungan |
|---|---|
| **2.2.6, 2.4.3** | Dasar `onCompleted` dan `Qt.callLater` yang diperdalam di sini |
| **3.1** Property Binding | Binding sudah terpasang saat `onCompleted`; nilai awal vs `Qt.binding` |
| **3.2** Signal | `disconnect` saat `onDestruction`; `Connections` ke `Loader.item` |
| **3.4** Scope, ID, Konteks | Konteks pembuatan menentukan `id` dan properti yang terlihat oleh objek dinamis |
| **Fase View/Delegate** | `Loader` di delegate dan konteks `index` |
| **Keamanan (13.x)** | Larangan membuat objek dari sumber tak tepercaya |

**Prasyarat Modul 3.4:** menguasai 3.3.1 sampai 3.3.3, terutama konsep konteks pembuatan. Bagian 3.3.5 sangat dianjurkan sebelum membangun navigasi halaman.

---

**Catatan tautan:** halaman Qt yang saya buka langsung adalah Component, Dynamic QML Object Creation from JavaScript, dan Loader (6.12). `Qt.callLater` saya baca dari halaman objek `Qt` pada putaran sebelumnya. Halaman Untrusted Data, `Repeater`, `Instantiator`, dan inline components muncul sebagai tautan di dalam halaman-halaman itu tetapi tidak saya buka satu per satu. Bila ada yang tidak terbuka, kabari saya.

# Fase 3 · Modul 3.4 — Scope, ID, dan Konteks

*Penutup Fase 3. Melanjutkan Modul 3.1 sampai 3.3.*

---

## A. Audit singkat

**Tumpang tindih dengan Fase 2.** Dasar scope, `id`, dan prinsip isolasi komponen sudah ada di **2.2.4**, dan `this` di `Qt.binding` dijanjikan Modul 3.1 untuk dibahas di sini. Modul ini tidak mengulang pengantarnya, melainkan memperdalam: urutan pencarian resmi, shadowing, batas `id`, `ComponentBehavior`, context property, dan closure.

**Terverifikasi:**

- Binding, fungsi, dan berkas JavaScript impor berjalan dalam scope JavaScript biasa. Variabel lokal dan parameter fungsi menutupi properti QML bernama sama, dan setiap ekspresi punya variabel lokal sendiri.
- Objek pemilik binding disebut *scope object*. Propertinya dipakai tanpa awalan, dan `this` tidak diperlukan di sana.
- *Component scope* adalah gabungan `id` di dalam komponen dan properti objek akarnya.
- Contoh kurikulum benar: `root.nilai` bernilai 1 dan `parent.nilai` bernilai 2, karena keduanya dikualifikasi.
- `qmllint` memberi peringatan kategori `unqualified` pada akses tanpa kualifikasi, dengan alasan keterbacaan dan performa. Konvensi kode Qt juga meminta properti komponen induk dirujuk lewat `id`.
- Context property masih tersedia, tetapi dokumentasi 6.12 memberi dua peringatan keras: dependensinya tak dideklarasikan, dan ia tak terlihat oleh Qt Quick Compiler, `qmllint`, dan QML Language Server.
- `id` bukan properti: `objek.id` tidak ada, dan nilainya tak bisa diubah setelah objek dibuat.

**Perlu dikoreksi atau dilengkapi:**

1. **Urutan di analogi kurikulum perlu diperbaiki.** Analogi menaruh properti objek (meja kerja) sebelum `id` (ruangan). Dokumentasi menyatakan `id` selalu didahulukan atas nama properti lain, kecuali scope JavaScript. Walau scope object punya properti bernama sama dengan sebuah `id`, `id` yang menang. Urutan baru ada di 3.4.1 dan peta besar.
2. **Pencarian tidak melewati induk visual.** Nama tanpa awalan hanya melihat variabel lokal, `id`, scope object, dan objek akar komponen (lalu komponen pemanggil). Properti `Rectangle` induk yang berada di tengah hierarki tidak ikut. Ini kejutan terbesar bagi pemula, jadi saya jadikan latihan.
3. **Scoping dinamis tidak disebut.** QML menyambungkan scope komponen ke scope pemakainya, sehingga komponen di berkas lain bisa kebetulan memakai nama milik pemakainya. Dokumentasi menyebutnya kuat tetapi berbahaya. Masuk 3.4.4.
4. **Batas `id` kurang rinci.** Dokumentasi 6.12 punya bagian khusus: jangan merujuk `id` objek akar dari komponen lain, dan `id` internal yang diakses dari luar berkas menghasilkan `ReferenceError`. Aturan penamaan `id` juga belum ada. Masuk 3.4.2.
5. **Shadowing punya empat wajah, bukan satu.** Variabel lokal vs properti, `id` vs properti, properti lokal vs `id` luar (bergantung `ComponentBehavior`), dan properti turunan vs properti dasar. Untuk yang terakhir Qt menyediakan kata kunci `virtual`, `override`, dan `final`. Masuk 3.4.3.
6. **Atribut terlampir (*attached property*) tanpa kualifikasi** selalu menunjuk ke atribut milik scope object, bukan milik root delegate. Masuk 3.4.4.
7. **Context property: peringatan ada, alternatif belum.** Kurikulum hanya berkata hindari. Saya tambahkan alternatif konkret di 3.4.5, termasuk fakta bahwa mengubah konteks memicu evaluasi ulang semua binding di dalamnya.
8. **`ComponentBehavior` dan injeksi konteks delegate belum ada.** `pragma ComponentBehavior: Bound` mengubah siapa yang menang saat nama bentrok, dan delegate yang terikat tidak lagi menerima `model` dan `index` secara otomatis. Dokumentasi juga menyebut bahwa bawaannya akan berubah menjadi `Bound` di versi Qt mendatang. Ini TAMBAHAN 3.4.7.
9. **Closure** dirujuk ke Bagian B8. Di 3.4.6 saya hanya membuat jembatan dan satu jebakan yang menyambung langsung ke `Qt.binding` (3.1).

**TAMBAHAN:**

- **3.4.7** Delegate, injeksi konteks, dan `pragma ComponentBehavior`.
- **3.4.8** Merancang batas komponen dan mendiagnosis scope.

---

## B. Daftar isi Modul 3.4 (diperbarui)

- **3.4.1** Urutan pencarian nama (+ `this`, urutan resmi) `[diperluas]`
- **3.4.2** `id` dan batasnya (+ penamaan, alias, batas berkas) `[diperluas]`
- **3.4.3** Shadowing (+ empat wajah, `virtual`/`override`/`final`) `[diperluas]`
- **3.4.4** Akses berkualifikasi (+ atribut terlampir, scoping dinamis) `[diperluas]`
- **3.4.5** Context property dan alternatifnya (+ empat jalan keluar) `[diperluas]`
- **3.4.6** Closure di JavaScript (jembatan ke Bagian B8)
- **3.4.7** Delegate, injeksi konteks, dan `pragma ComponentBehavior` `[TAMBAHAN]`
- **3.4.8** Merancang batas komponen dan mendiagnosis scope `[TAMBAHAN]`
- Latihan dan kunci jawaban · Glosarium · Hubungan dengan modul lain

**Urutan belajar yang disarankan:** 3.4.1 → 3.4.2 → 3.4.3 → 3.4.4 → 3.4.5 → 3.4.6 → 3.4.7 → 3.4.8.

---

## C. Peta besar

```
 ekspresi menyebut sebuah nama:  nilai
   │  dicari dari yang PALING DEKAT ke yang PALING JAUH
   ▼
 ┌────────────────────────────────────────────────────────────┐
 │ ① scope JavaScript   variabel lokal, parameter, closure     │ ◄ menang atas semuanya
 ├────────────────────────────────────────────────────────────┤
 │ ② id                 objek ber-id di komponen yang sama     │ ◄ menang atas properti
 ├────────────────────────────────────────────────────────────┤
 │ ③ scope object       properti objek pemilik binding         │
 ├────────────────────────────────────────────────────────────┤
 │ ④ objek akar         properti root komponen ini             │
 ├────────────────────────────────────────────────────────────┤
 │ ⑤ komponen pemanggil scope komponen yang memakai kita       │ ◄ scoping dinamis
 ├────────────────────────────────────────────────────────────┤
 │ ⑥ tipe dan impor     Rectangle, enum, attached, berkas JS,  │
 │   objek global JS    Math, Date, Qt                         │
 └────────────────────────────────────────────────────────────┘
 ① dan ② terdokumentasi tegas. Urutan ③ → ④ → ⑤ mengikuti prinsip terdekat menang [uji].
 Induk visual (parent) yang berada DI ANTARA ③ dan ④ tidak ikut dicari.
```

**Filosofinya:** scope adalah kontrak tentang apa yang boleh diketahui sebuah ekspresi. Semakin sempit dan eksplisit kontraknya, semakin mudah komponen diaudit, diuji, dan dipindahkan. Ini prinsip *least privilege* yang sama dengan isolasi proses di sistem Anda: komponen yang hanya memegang apa yang diberikan kepadanya tak bisa merusak apa yang tak diberikan. Hampir semua bug scope jatuh ke tiga hal: nama yang menunjuk ke bukan yang Anda kira, nama yang diam-diam bergantung pada pemakainya, dan data global yang tak dideklarasikan siapa pun.

**Cara menjalankan contoh:**

- Berkas berbasis `QtObject`: `qml -a core nama.qml` (laboratorium 2.1.0).
- Contoh multi-berkas: simpan semua berkas dalam satu direktori lalu jalankan `qml -a core Main.qml`. Tipe `Penghitung` dari `Penghitung.qml` ditemukan otomatis karena berada di direktori yang sama.
- Berkas visual: `QT_QPA_PLATFORM=offscreen qml nama.qml`.
- Peringatan statis: `qmllint nama.qml` (di Arch bisa `qmllint6`).

---

## D. Materi

### 3.4.1 Urutan pencarian nama

*Mesin tidak menebak, ia mengikuti urutan. Pelajari urutannya dan Anda berhenti ditebak-tebak olehnya.*

**Konsep.** Setiap kali sebuah ekspresi menyebut nama, mesin harus memutuskan nama itu menunjuk ke apa. Aturannya: terdekat menang.

| Tingkat | Isi | Catatan |
| --- | --- | --- |
| ① Scope JavaScript | variabel lokal dan parameter fungsi | Aturan JS biasa; QML tidak mengubahnya |
| ② `id` | objek ber-`id` di komponen yang sama | Menang atas nama properti mana pun, kecuali scope JS |
| ③ Scope object | properti objek pemilik binding | Dipakai tanpa awalan dan tanpa `this` |
| ④ Objek akar | properti root komponen | Bersama ② membentuk *component scope* |
| ⑤ Komponen pemanggil | scope komponen yang memakai instans ini | Scoping dinamis (3.4.4) |
| ⑥ Tipe dan impor | tipe, enum, atribut terlampir, berkas JS impor, objek global JS | `id`, properti, dan tipe yang bentrok dengan objek global JS dilarang |

Dokumentasi menyatakan ① dan ② dengan tegas, dan bahwa properti lokal di sebuah komponen mengalahkan nama dari komponen pemanggilnya. Urutan persis antara ③ dan ④ tidak dirinci, jadi saya menyebutnya terdekat menang `[uji]` dan menyediakan percobaannya.

**Peragaan: siapa yang menang?**

```qml
import QtQml

QtObject {
    id: root
    property string nama: 'akar'                  // ④ properti objek akar

    property QtObject tamu: QtObject {
        id: pintu                                 // sebuah id bernama pintu
        property string nama: 'tamu'              // ③ properti scope object

        property string a: nama                   // ③ menutupi ④ → 'tamu'
        property string b: root.nama              // dikualifikasi → 'akar'
        property string c: {
            var nama = 'lokal'                    // ① variabel lokal
            return nama                           // → 'lokal'
        }
    }

    property QtObject lain: QtObject {
        property string pintu: 'properti'         // properti bernama sama dengan sebuah id
        property string d: typeof pintu           // ② id menang → 'object'
    }

    Component.onCompleted: {
        console.log(tamu.a, tamu.b, tamu.c, lain.d)
        Qt.quit()
    }
}
```

```bash
qml -a core cari.qml
```

Dugaan keluaran: `qml: tamu akar lokal object` `[uji]`.

**Bedah kode:**

- `import QtQml`: memuat tipe non-visual (`QtObject`, `Timer`, objek `Qt`). Tak butuh jendela.
- `QtObject { ... }`: objek paling sederhana. Karena menjadi akar berkas, properti-nya masuk component scope (④).
- `id: root`: nama bagi objek ini. Bukan properti, dan hanya berlaku di berkas ini.
- `property string nama: 'akar'`: deklarasi properti. `property` kata kunci, `string` tipe, `nama` nama, `:` memberi nilai awal.
- `property QtObject tamu: QtObject { ... }`: properti bertipe objek yang nilainya objek baru. Binding di dalam objek itu memakai objek tersebut sebagai scope object (③).
- `property string a: nama`: bacaan tanpa awalan. Properti `nama` milik `tamu` lebih dekat daripada milik akar.
- `property string c: { var nama = 'lokal'; return nama }`: blok dengan variabel lokal bernama sama dengan properti. QML tidak melarang; ini aturan JS (①).
- `typeof pintu`: operator JS yang mengembalikan jenis nilai. Hasil `object` berarti `pintu` dibaca sebagai objek ber-`id`, bukan string properti.
- `Component.onCompleted` dan `Qt.quit()`: baca semuanya setelah binding terpasang (3.3.2), lalu hentikan `qml`.

**`this` di binding dari JavaScript.** Di dalam handler atau fungsi sebuah objek, nama tanpa awalan merujuk ke objek itu, bukan ke anak-anaknya. Dokumentasi memberi contoh: `Component.onCompleted` milik sebuah `Item` memandang `width` sebagai lebar `Item`, bukan lebar `Rectangle` di dalamnya. Saat membuat binding lewat `Qt.binding` dan Anda ingin merujuk objek penerimanya, pakai `this`.

```qml
import QtQml

QtObject {
    id: root
    property int lebar: 500

    QtObject {
        id: kotak
        property int lebar: 100
        property int tinggi: 0
    }

    Component.onCompleted: {
        kotak.tinggi = Qt.binding(function () { return this.lebar * 2 })
        console.log(kotak.tinggi)            // 200, bukan 1000
        Qt.quit()
    }
}
```

**Bedah kode:**

- `QtObject { id: kotak ... }` di dalam akar: anak ditambahkan lewat default property `data` (2.2.5).
- `Qt.binding(function () { ... })`: pembungkus binding imperatif (3.1.3).
- `this.lebar`: `this` adalah objek penerima binding (`kotak`), jadi bernilai 100 dan hasilnya 200.
- Tanpa `this`, `lebar` akan dicari dari scope tempat handler ditulis, yaitu akar (500), dan hasilnya 1000.
- `this` hanya terdefinisi di dalam binding. Perilaku fungsi arrow tidak saya uji `[uji]`; aturan JS menyatakan arrow function tidak punya `this` sendiri, jadi pakai `function` atau, lebih baik, `kotak.lebar`.

**Opsi lain, menyebut nilai milik objek lain:**

| Cara | Kapan | Catatan |
| --- | --- | --- |
| `root.nilai` (lewat `id`) | Dalam satu berkas | Dianjurkan: jelas, cepat, dikenali alat |
| `parent.nilai` | Induk visual langsung | Rapuh bila struktur berubah; hanya untuk `Item` |
| `nilai` (telanjang) | Properti milik scope object sendiri | Aman bila memang miliknya |
| `this.nilai` | Di dalam fungsi `Qt.binding` | Hanya di dalam binding |
| Properti antarmuka yang diisi dari luar | Komponen yang dipakai ulang | Terbaik untuk batas berkas (3.4.4) |

**Hal yang perlu diingat:**

- Setiap nama yang dibaca binding juga menjadi dependensinya (3.1.1). Nama yang salah resolusi berarti salah pantau.
- Nama telanjang tidak pernah naik ke induk visual di tengah hierarki.
- Variabel lokal menutupi properti tanpa peringatan apa pun. Beri nama variabel lokal yang tidak menyerupai properti.

| Kesalahan | Solusi |
| --- | --- |
| Mengira nama telanjang menunjuk ke properti induk terdekat | Tidak. Hanya scope object, objek akar, dan `id`. Kualifikasi dengan `id` |
| Variabel lokal bernama sama dengan properti | Lokal menang dan properti terabaikan. Ganti nama |
| Memakai `this` di luar binding | `this` tak terdefinisi di sana. Pakai `id` |
| Mengandalkan nama dari pemakai komponen | Scoping dinamis (3.4.4). Ganti dengan properti eksplisit |

**Referensi:** [Scope and Naming Resolution](https://doc.qt.io/qt-6/qtqml-documents-scope.html) · [Property Binding: Using this](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html) · [JavaScript Host Environment](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html)

---

### 3.4.2 `id` dan batasnya (satu dokumen)

*Nama yang baik memberi Anda pegangan. Batas yang jelas menjaga pegangan itu tak bocor.*

**Konsep.** `id` adalah nama bagi sebuah objek, yang bisa dipakai objek lain dalam konteks yang sama. Fakta dari dokumentasi:

- Tiap elemen paling banyak punya satu `id`. Atribut ini disediakan bahasa dan tak bisa didefinisikan ulang oleh tipe mana pun.
- Aturan nama: diawali huruf kecil atau garis bawah, hanya berisi huruf, angka, dan garis bawah, dan bukan kata kunci JavaScript.
- Unik di dalam konteksnya, tak bisa diubah setelah objek dibuat, dan bukan properti (`objek.id` tidak ada).
- Hanya berlaku di dokumen (berkas) tempat ia dideklarasikan.

| `id` | Sah? | Alasan |
| --- | --- | --- |
| `root`, `tombol1`, `_tmp` | Ya |  |
| `Root` | Tidak | Harus diawali huruf kecil atau garis bawah |
| `tombol-1`, `tombol 1` | Tidak | Hanya huruf, angka, garis bawah |
| `class`, `function` | Tidak | Kata kunci JavaScript |
| `Math`, `Date` | Tidak | Bentrok dengan objek global JS (3.4.1) |

**Peragaan: `id` tak menyeberangi batas berkas.** Simpan dua berkas ini dalam satu direktori.

```qml
// Penghitung.qml
import QtQml

QtObject {
    property alias jumlah: mesin.hitung       // antarmuka resmi ke dunia luar

    QtObject {
        id: mesin                             // id privat: hanya berlaku di berkas ini
        property int hitung: 5
    }
}
```

```qml
// Main.qml
import QtQml

Penghitung {
    Component.onCompleted: {
        console.log('lewat alias:', jumlah)          // 5
        try {
            console.log(mesin.hitung)
        } catch (e) {
            console.log('galat:', e.message)         // mesin is not defined
        }
        Qt.quit()
    }
}
```

```bash
qml -a core Main.qml
```

Dugaan keluaran: `qml: lewat alias: 5` lalu `qml: galat: mesin is not defined` `[uji]` (bentuk persis pesan bisa berbeda).

```
 Penghitung.qml                          Main.qml
 ┌──────────────────────────┐          ┌───────────────────────────┐
 │ id: mesin     (PRIVAT)   │   ✗      │ mesin.hitung → ReferenceError
 │ alias jumlah ────────────┼────────► │ jumlah        ✓ (publik)  │
 └──────────────────────────┘          └───────────────────────────┘
```

**Bedah kode:**

- `property alias jumlah: mesin.hitung`: alias adalah referensi langsung ke properti lain, bukan salinan dan bukan binding. Membaca atau menulis `jumlah` sama dengan membaca atau menulis `mesin.hitung`.
- Batas alias menurut dokumentasi: hanya menunjuk objek atau properti di dalam jangkauan tipe itu, tak boleh ekspresi JS, tak boleh atribut terlampir, dan kedalamannya paling banyak dua tingkat (`rectangle.border.color` boleh).
- `Penghitung { ... }` di `Main.qml`: nama berkas `Penghitung.qml` otomatis menjadi nama tipe, karena berada di direktori yang sama.
- `try { } catch (e) { }`: menangkap galat JS agar skrip tak berhenti. `e.message` berisi teksnya.
- `mesin` di `Main.qml`: tak ada di konteks `Main.qml`, sehingga menghasilkan `ReferenceError`.

**Jangan merujuk `id` akar dari komponen lain.** Dokumentasi 6.12 mengingatkan: komponen yang memakai `root.width` padahal `root` dideklarasikan di berkas pemakainya bisa saja jalan karena scoping dinamis. Namun ia menciptakan dependensi tersembunyi, rapuh saat dimuat dinamis atau dipakai di konteks lain, dan dapat tertutup `id` lain yang bernama sama. Solusinya: properti eksplisit, alias, atau sinyal (3.4.4 dan 3.4.8).

**Tiga batas lain:**

- Objek dinamis (`createObject`) tidak punya `id`. Simpan referensinya di variabel atau properti (3.3.1).
- `id` yang dideklarasikan di dalam `Component {}` atau delegate berlaku di scope komponen itu, bukan di luarnya `[uji]`. Sebaliknya, isi delegate bisa melihat `id` di luarnya (scope bertingkat).
- `id` bukan nama untuk dibaca program saat berjalan. Untuk label yang perlu dibaca, pakai `objectName`.

**Konvensi:** letakkan `id` di baris pertama objek, dan beri nama `root` pada objek akar. Urutan atribut yang dipakai dokumentasi Qt: `id`, deklarasi properti, deklarasi sinyal, fungsi, properti objek, lalu objek anak.

**Opsi lain, mengekspos objek internal ke luar:**

| Cara | Kapan | Catatan |
| --- | --- | --- |
| `property alias x: anak.x` | Ekspos satu properti anak | Menulis ke alias menulis ke anak |
| `property alias anak: anakId` | Ekspos seluruh objek anak | Hanya tipe dasarnya yang terlihat; properti tambahan inline tak terlihat |
| Properti biasa + binding | Nilai turunan satu arah | Bukan referensi |
| Sinyal | Memberi tahu kejadian ke luar | 3.2.7 |
| Fungsi | Memberi perintah ke dalam | `function reset() { ... }` |

| Kesalahan | Solusi |
| --- | --- |
| Memakai `id` dari berkas lain | `ReferenceError`, atau kebetulan jalan lewat scoping dinamis. Ganti dengan properti, alias, atau sinyal |
| Dua `id` sama dalam satu dokumen | Galat saat memuat. Beri nama unik |
| Mengira `id` adalah properti | `objek.id` tidak ada. Pakai `objectName` bila perlu label |
| `id` yang tak layak sebagai identifier JS | Tak bisa dirujuk dari JS. Pilih nama biasa |

**Referensi:** [QML Object Attributes: the id Attribute, Property Aliases](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html) · [Scope and Naming Resolution](https://doc.qt.io/qt-6/qtqml-documents-scope.html) · [QML Coding Conventions](https://doc.qt.io/qt-6/qml-codingconventions.html)

---

### 3.4.3 Shadowing

*Dua nama yang sama bukan kebetulan yang lucu. Ia adalah utang yang ditagih saat refactor.*

**Konsep.** Shadowing terjadi ketika satu nama menutupi nama lain yang lebih jauh. Ada empat wajah. Semuanya sah menurut bahasa, tetapi dokumentasi menyebut penutupan properti sering tak disengaja, membingungkan, dan menyulitkan alat.

| # | Wajah | Siapa menang | Dasar |
| --- | --- | --- | --- |
| 1 | Variabel lokal JS vs properti | Variabel lokal | Dokumentasi: JavaScript Scope |
| 2 | `id` vs properti bernama sama | `id` | Dokumentasi: Component Scope |
| 3 | Properti lokal vs `id` di luar komponen | `Unbound`: properti lokal. `Bound`: `id` luar | Dokumentasi: ComponentBehavior (3.4.7) |
| 4 | Properti turunan vs properti dasar | Dua properti terpisah; yang terbaca ditentukan tempat nama itu ditulis | Dokumentasi: Overridden Properties |

**Wajah 1: variabel lokal dan parameter.**

```qml
import QtQml

QtObject {
    property int a: 3
    property int b: 9

    function tambahkan(b) {              // parameter b menutupi properti b
        var a = 13                       // variabel lokal a menutupi properti a
        return b + a
    }

    Component.onCompleted: {
        console.log(tambahkan(1))        // 14, bukan 4 dan bukan 10
        Qt.quit()
    }
}
```

**Bedah kode:**

- `function tambahkan(b) { ... }`: metode bernama `tambahkan` dengan satu parameter. Nama parameter sengaja sama dengan properti `b`.
- `var a = 13`: variabel lokal. `var` mendeklarasikannya di dalam fungsi, sehingga properti `a` tak tersentuh.
- `return b + a`: memakai parameter dan variabel lokal, bukan properti. Hasilnya 14 berapa pun nilai properti `a` dan `b`. Dokumentasi menegaskan QML mempertahankan aturan scoping JavaScript.

**Wajah 2** sudah Anda lihat di 3.4.1: `typeof pintu` bernilai `object` karena `id` mengalahkan properti `pintu`.

**Wajah 3** bergantung pada `pragma ComponentBehavior`, dibahas di 3.4.7 beserta percobaannya.

**Wajah 4: properti turunan.** Simpan tiga berkas dalam satu direktori.

```qml
// Hewan.qml
import QtQml

QtObject {
    property string nama: 'hewan'
    function perkenalan() { return 'Aku ' + nama }
}
```

```qml
// Kucing.qml
import QtQml

Hewan {
    property string nama: 'kucing'                 // menutupi properti nama milik Hewan
    function meong() { return 'Meong, aku ' + nama }
}
```

```qml
// Main.qml
import QtQml

Kucing {
    Component.onCompleted: {
        console.log(nama)              // kucing
        console.log(meong())           // Meong, aku kucing
        console.log(perkenalan())      // Aku hewan  ← membaca nama MILIK HEWAN
        Qt.quit()
    }
}
```

Dugaan keluaran: `kucing`, `Meong, aku kucing`, `Aku hewan` `[uji]`.

**Bedah kode:**

- `Hewan { ... }` di `Kucing.qml`: `Kucing` diturunkan dari `Hewan` (nama berkas menjadi nama tipe).
- `property string nama` di `Kucing.qml`: mendeklarasikan ulang properti. Hasilnya dua properti bernama `nama`, dan hanya satu yang terlihat dari tiap tempat.
- `perkenalan()` ditulis di `Hewan.qml`, jadi scope-nya adalah `Hewan` dan ia membaca `nama` milik `Hewan`. Itu sebabnya hasilnya `Aku hewan`. Dokumentasi menyebut kedua properti sepenuhnya terpisah: handler `onNamaChanged` satu tidak terpicu oleh yang lain, dan alias hanya menunjuk salah satunya.

**Menjadikannya eksplisit: `virtual`, `override`, `final`.** Dokumentasi 6.12 memperkenalkan tiga kata kunci agar penutupan tak lagi tak sengaja. Pesan utamanya tetap: lebih baik memberi nama unik daripada menutup atau menimpa.

```qml
// Hewan.qml
import QtQml

QtObject {
    virtual property string nama: 'hewan'      // dimaksudkan boleh ditimpa
    property int umur: 1                       // bukan virtual
}
```

```qml
// Kucing.qml
import QtQml

Hewan {
    final property string nama: 'kucing'       // menimpa nama; tak bisa ditimpa lagi
}
```

- `virtual`: properti ini sengaja boleh ditimpa turunan.
- `override`: properti ini sengaja menimpa properti virtual milik tipe dasar.
- `final`: boleh menimpa, tetapi tak bisa ditimpa atau ditutupi lagi oleh turunan berikutnya. Dokumentasi menganjurkan `final` daripada `override`.

| Deklarasi di turunan | Dasar biasa | Dasar `virtual` | Dasar `final` |
| --- | --- | --- | --- |
| `property x` | Peringatan | Peringatan (tanpa `override` atau `final`) | Galat |
| `final property x` | Peringatan | Boleh | Galat |
| `override property x` | Galat | Boleh | Galat |

Dokumentasi menambahkan bahwa sebagian besar peringatan ini akan menjadi galat di masa depan. Versi Qt minimum untuk kata kunci ini tidak saya temukan di halaman itu, jadi cek versi Anda dengan `pacman -Q qt6-declarative` `[uji]`.

**Wajah tersembunyi lain:** sinyal atau metode baru boleh memakai nama yang sudah ada pada tipe dasar dan akan menyembunyikannya, sehingga dokumentasi menyuruh berhati-hati. Sebaliknya, `id`, properti, dan tipe yang bentrok dengan objek global JS dilarang sama sekali.

**Opsi lain, menghindari shadowing:**

| Cara | Kapan |
| --- | --- |
| Nama unik (`namaHewan`, `namaKucing`) | Pilihan pertama, hampir selalu |
| Kualifikasi (`root.nama`) | Nama sama di scope berbeda tak terhindarkan |
| `virtual` + `final` | Penimpaan memang dirancang |
| `qmllint` | Menandai sebagian pola secara statis |

| Kesalahan | Solusi |
| --- | --- |
| Mendeklarasikan ulang properti dasar di turunan | Pakai nama baru, atau tandai `virtual` lalu `final` |
| Mengira mengubah `nama` turunan mengubah `nama` dasar | Keduanya terpisah. Beri nama berbeda |
| Nama parameter sama dengan properti | Parameter menang di dalam fungsi. Beri awalan, misalnya `n` atau `nilaiBaru` |
| `id` bernama sama dengan properti objek lain | `id` menang secara diam-diam. Pilih nama `id` yang khas |

**Referensi:** [Property Shadowing and Override Semantics](https://doc.qt.io/qt-6/qtqml-syntax-overridesemantics.html) · [Scope and Naming Resolution: Overridden Properties](https://doc.qt.io/qt-6/qtqml-documents-scope.html) · [QML Object Attributes: Override Semantics](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html)

---

### 3.4.4 Akses berkualifikasi

*Menyebut nama lengkap bukan formalitas. Ia asuransi.*

**Konsep.** Akses berkualifikasi berarti `objek.properti`, dengan `objek` berupa `id` (atau nama tipe untuk enum dan atribut terlampir). Akses tanpa kualifikasi adalah nama telanjang yang diselesaikan lewat urutan di 3.4.1. Panduan `qmllint` menyebut dua alasan memilih yang pertama: kode lebih mudah dibaca dan performanya lebih baik. Konvensi kode Qt juga meminta properti komponen induk selalu dirujuk lewat `id`. Dokumentasi konvensi menambahkan alasan ketiga: data dari luar komponen sebaiknya dinyatakan dengan `required property`, karena lebih cepat daripada pencarian telanjang dan memungkinkan manusia maupun alat menalar tipenya.

**Peragaan:**

```qml
import QtQuick

Item {
    id: root
    property int lebarKotak: 50

    Rectangle {
        width: lebarKotak            // ✗ telanjang: qmllint melapor [unqualified]
        height: root.lebarKotak      // ✓ berkualifikasi
        color: 'steelblue'
    }
}
```

```bash
qmllint Main.qml
```

Dugaan: satu peringatan `[unqualified]` untuk `lebarKotak` `[uji]`.

**Bedah kode:**

- `id: root` di baris pertama dan `property int lebarKotak: 50`: properti milik objek akar.
- `width: lebarKotak`: `Rectangle` tak punya `lebarKotak`, jadi nama ditemukan di objek akar (④). Jalan, tetapi bergantung pada pencarian bertingkat dan pada posisi `Rectangle` di dalam komponen ini.
- `root.lebarKotak`: jalur eksplisit. Tetap benar bila `Rectangle` dipindah ke dalam objek lain di berkas yang sama.
- `color: 'steelblue'`: warna boleh ditulis sebagai string; mesin mengubahnya menjadi nilai `color`.

**Tiga jebakan akses telanjang:**

**1. Tidak naik ke induk visual.** Nama telanjang tak mencari properti `Rectangle` induk di tengah hierarki. Anda akan membuktikannya di latihan E.

**2. Atribut terlampir.** Bacaan atribut terlampir tanpa awalan selalu menunjuk ke atribut milik scope object, padahal atribut seperti `ListView.isCurrentItem` hanya dipasang pada root delegate.

```qml
import QtQuick

ListView {
    width: 200; height: 100
    model: 3
    delegate: Item {
        id: baris
        width: 200; height: 30
        Rectangle {
            width: 200; height: 30
            color: baris.ListView.isCurrentItem ? 'tomato' : 'khaki'   // ✓ lewat root delegate
            // color: ListView.isCurrentItem ? 'tomato' : 'khaki'      // ✗ atribut milik Rectangle sendiri
        }
    }
}
```

**Bedah kode:**

- `baris.ListView.isCurrentItem`: `baris` adalah `id` root delegate, `ListView` adalah nama atribut terlampir, `isCurrentItem` isinya. Ini akses berkualifikasi atas atribut.
- Versi yang dikomentari membaca atribut `ListView` milik `Rectangle` itu sendiri, yang tak pernah diisi view, sehingga hasilnya tak sesuai harapan.

**3. Scoping dinamis.** Komponen di berkas lain bisa memakai nama milik pemakainya, dan jalan. Dokumentasi menyebutnya kuat tetapi harus dipakai hati-hati, hanya untuk dua komponen yang sudah erat terkait.

```qml
// Halaman.qml
import QtQml

QtObject {
    id: halaman
    property string judul: 'Halo'
    property QtObject kop: Kop { }          // Kop.qml tidak mendeklarasikan judul
}
```

```qml
// Kop.qml
import QtQml

QtObject {
    property string teks: '<b>' + judul + '</b>'   // judul datang dari pemakai
}
```

```qml
// Main.qml
import QtQml

Halaman {
    Component.onCompleted: { console.log(kop.teks); Qt.quit() }
}
```

Dugaan keluaran: `qml: <b>Halo</b>` `[uji]`. Pakai `Kop` di tempat lain tanpa `judul` dan ia gagal dengan `ReferenceError`.

```
 Halaman.qml                                Kop.qml
 ┌────────────────────────────┐              ┌─────────────────────────────┐
 │ property string judul ◄────┼── diam-diam ──┤ teks: '<b>' + judul + ...  │
 │   Kop { }  ──────────────┼── memakai ───► │ (judul tak dideklarasikan)   │
 └────────────────────────────┘              └─────────────────────────────┘
 Jalan karena scope Kop disambung ke scope pemakainya. Kop kini bergantung diam-diam pada Halaman.
```

**Perbaikan: antarmuka eksplisit.**

```qml
// Kop.qml
import QtQml

QtObject {
    required property string judul                    // data wajib, tertulis jelas
    property string teks: '<b>' + judul + '</b>'
}
```

```qml
// Halaman.qml
import QtQml

QtObject {
    id: halaman
    property string judul: 'Halo'
    property QtObject kop: Kop { judul: halaman.judul }   // diteruskan eksplisit
}
```

**Bedah kode:**

- `required property string judul`: properti yang wajib diisi saat objek dibuat. Dokumentasi: melanggarnya menggagalkan pemuatan bila terdeteksi statis. Nilai awal tak boleh ditulis pada deklarasinya.
- `Kop { judul: halaman.judul }`: pemakai mengisi properti dengan nilai yang dikualifikasi lewat `id`. Dua sisi kini saling menyatakan kontraknya.

**`parent`.** Properti `parent` ada pada `Item`, tetapi `QtObject` tak punya. Ia menunjuk induk visual, yang bisa berubah saat reparenting dan bisa `null`. Pakai untuk hubungan visual langsung (misalnya `anchors.fill: parent`), bukan untuk menjangkau data. Untuk data, pakai `id`.

**Opsi lain, komponen menerima data dari luar:**

| Cara | Terlihat bagi alat? | Kapan |
| --- | --- | --- |
| Properti biasa dengan nilai bawaan | Ya | Data opsional |
| `required property` | Ya, dan wajib diisi | Data wajib |
| Nama telanjang dari pemakai (scoping dinamis) | Tidak | Hindari |
| Context property | Tidak | Hindari (3.4.5) |

| Kesalahan | Solusi |
| --- | --- |
| Komponen memakai nama milik pemakainya | Jadikan properti, atau `required property` |
| `ListView.isCurrentItem` dibaca dari anak delegate | Lewat `id` root delegate |
| Mengandalkan `parent.x` untuk data | Pakai `id`; `parent` hanya untuk hubungan visual |
| Mengabaikan `[unqualified]` dari `qmllint` | Jadikan peringatan itu bagian dari rutinitas (3.4.8) |

**Referensi:** [QML Coding Conventions: Unqualified access, Required properties](https://doc.qt.io/qt-6/qml-codingconventions.html) · [qmllint: unqualified](https://doc.qt.io/qt-6/qmllint-warnings-and-errors-unqualified.html) · [Scope and Naming Resolution: Component Instance Hierarchy](https://doc.qt.io/qt-6/qtqml-documents-scope.html) · [QML Object Attributes: Attached Properties](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html)

---

### 3.4.5 Context property dan alternatifnya

*Pintu belakang yang nyaman tetap pintu belakang.*

**Konsep.** Context property adalah nama yang disuntikkan aplikasi C++ ke konteks QML lewat `QQmlContext::setContextProperty`. Kode QML lalu merujuknya tanpa awalan, seperti variabel global. Dokumentasi 6.12 memberi tiga peringatan:

- Kode QML Anda bergantung pada konteks tertentu yang tak dideklarasikan di mana pun. Tak ada `import` dan tak ada pernyataan apa yang diharapkan, sehingga siapa pun yang memakai ulang kode itu sulit mengetahui apakah tempat barunya punya konteks yang cukup.
- Context property tak terlihat oleh alat yang bekerja sebelum QML dimuat. Qt Quick Compiler, `qmllint`, dan QML Language Server memperlakukannya sebagai akses tanpa kualifikasi.
- Bila konteks diubah, semua binding di konteks itu dievaluasi ulang. Pakai hanya saat inisialisasi aplikasi.

**Peragaan lama (jangan ditiru).** Bagian C++ ini ditinjau lagi di Fase 10, jadi di sini cukup dibaca.

```cpp
// main.cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("namaApp", "Lab 3.4");   // nama telanjang di QML
    engine.load(QUrl::fromLocalFile("Main.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;
    return app.exec();
}
```

```qml
// Main.qml
import QtQuick
import QtQuick.Window

Window {
    visible: true
    title: namaApp        // dari mana asalnya? tak tertulis di berkas ini
}
```

**Bedah kode:**

- `QGuiApplication app(argc, argv)`: objek aplikasi Qt untuk program grafis.
- `QQmlApplicationEngine engine`: mesin QML yang memuat berkas dan menyimpan konteks akar.
- `engine.rootContext()`: konteks paling atas. Semua nama yang disetel di sini terlihat dari seluruh QML yang dimuat mesin ini.
- `setContextProperty("namaApp", "Lab 3.4")`: mendaftarkan nama `namaApp` dengan nilainya.
- `engine.load(QUrl::fromLocalFile("Main.qml"))`: memuat berkas QML. `rootObjects().isEmpty()` memeriksa apakah pemuatan gagal.
- `title: namaApp` di QML: nama telanjang yang tak dideklarasikan. `qmllint` menandainya `unqualified`, dan Qt Quick Compiler tak tahu tipenya.

**Empat jalan keluar:**

**A. Properti pada akar, diisi saat memuat (`required property` + `setInitialProperties`).** Dokumentasi menyebut context property umumnya dapat diganti properti biasa pada objek akar.

```cpp
engine.setInitialProperties({{"namaApp", "Lab 3.4"}});
engine.load(QUrl::fromLocalFile("Main.qml"));
```

```qml
// Main.qml
import QtQuick
import QtQuick.Window

Window {
    required property string namaApp        // tertulis, bertipe, diperiksa
    visible: true
    title: namaApp
}
```

- `setInitialProperties`: mengisi properti objek akar sebelum objek selesai dibuat. Kode C++ ini `[uji]` pada versi Qt Anda.
- `required property string namaApp`: kontrak yang terbaca di berkas QML. Lupa mengisinya akan menggagalkan pemuatan.

**B. Singleton QML.** Cocok untuk pengaturan yang dipakai di banyak tempat, dan bisa dicoba tanpa C++.

```
# qmldir
singleton Pengaturan 1.0 Pengaturan.qml
```

```qml
// Pengaturan.qml
pragma Singleton
import QtQml

QtObject {
    readonly property string namaApp: 'Lab 3.4'
}
```

```qml
// Main.qml
import QtQml
import '.'

QtObject {
    Component.onCompleted: { console.log(Pengaturan.namaApp); Qt.quit() }
}
```

```bash
qml -a core Main.qml
```

Dugaan keluaran: `qml: Lab 3.4` `[uji]` (pendaftaran singleton lewat `qmldir` dan `import '.'` perlu Anda cek di versi Qt Anda).

- `pragma Singleton`: menyatakan komponen di berkas ini sebagai singleton, satu instans per mesin QML.
- `qmldir`: berkas pendaftaran modul. Baris `singleton` memberi tahu mesin bahwa `Pengaturan` adalah singleton.
- `readonly property`: nilai hanya boleh diberikan saat inisialisasi, tak bisa ditimpa dari luar.
- `Pengaturan.namaApp`: akses berkualifikasi lewat nama tipe, terlihat oleh alat.

**C. Singleton C++ (`QML_SINGLETON`).** Pola yang sama dari sisi C++ untuk objek yang punya logika (akses berkas, jaringan). Detail pendaftaran di Fase 10.

**D. Teruskan lewat properti.** Akar menerima data, lalu meneruskannya ke anak yang memerlukan: `Panel { namaApp: root.namaApp }`. Paling eksplisit, dan paling mudah diuji.

| Cara | Dideklarasikan di QML? | Terlihat bagi alat? | Cocok untuk |
| --- | --- | --- | --- |
| Context property | Tidak | Tidak | Hindari untuk kode baru |
| `required property` + `setInitialProperties` | Ya | Ya | Data awal aplikasi |
| Singleton QML | Ya | Ya | Pengaturan dan konstanta bersama |
| Singleton C++ | Ya (setelah didaftarkan) | Ya | Layanan berlogika |
| Properti yang diteruskan | Ya | Ya | Data milik satu pohon komponen |

**Catatan keamanan dan isolasi.** Context property adalah *ambient authority*: setiap QML yang berjalan di konteks itu, termasuk QML pihak ketiga atau yang dimuat dari jaringan, otomatis bisa memanggil metode `Q_INVOKABLE` objek yang Anda suntikkan. Terapkan *least privilege*: sediakan antarmuka sesempit mungkin, jangan suntikkan objek yang bisa membaca berkas atau menjalankan proses ke konteks yang memuat QML yang tak sepenuhnya Anda percayai (Fase Keamanan 13.x).

**Catatan `Connections`.** Contoh di halaman dokumentasi context property memakai bentuk lama `onDataChanged:` di dalam `Connections`. Untuk kode baru pakai `function onDataChanged() { ... }` (3.2.3).

| Kesalahan | Solusi |
| --- | --- |
| Memakai context property di komponen yang dipakai ulang | Ganti dengan `required property` atau singleton |
| Mengubah context property berulang kali saat berjalan | Seluruh binding di konteks dievaluasi ulang. Pakai properti biasa |
| Heran mengapa `qmllint` melaporkan nama yang jelas ada | Alat tak melihat context property. Itu memang kelemahannya |
| Menyuntikkan objek berkemampuan besar | Persempit antarmuka. Sediakan hanya yang diperlukan |

**Referensi:** [Context Properties](https://doc.qt.io/qt-6/qtqml-cppintegration-contextproperties.html) · [Singletons in QML](https://doc.qt.io/qt-6/qml-singleton.html) · [QQmlApplicationEngine::setInitialProperties](https://doc.qt.io/qt-6/qqmlapplicationengine.html#setInitialProperties) · [QQmlContext](https://doc.qt.io/qt-6/qqmlcontext.html)

---

### 3.4.6 Closure di JavaScript (Bagian B8)

*Fungsi yang membawa pulang rumahnya: pahami ia, dan Anda memahami setengah asinkronisme QML.*

Modul ini hanya membuat jembatan. Pendalaman closure, termasuk `var`, `let`, `const`, dan IIFE, ada di Bagian B8.

**Konsep.** Closure adalah fungsi beserta lingkungan tempat ia dibuat. Di QML, binding, handler sinyal, fungsi `Qt.binding`, dan callback `Timer` semuanya closure atas rantai scope yang Anda pelajari di 3.4.1. Fungsi itu membawa variabel lokal sekitarnya, bukan salinannya.

**Jebakan utama: `var` dalam loop bertemu `Qt.binding`.** Binding baru dievaluasi ulang nanti, setelah loop selesai.

```qml
import QtQml

QtObject {
    id: root
    property int basis: 10

    QtObject { id: ta; property int n }
    QtObject { id: tb; property int n }
    QtObject { id: tc; property int n }

    Component.onCompleted: {
        const tujuan = [ta, tb, tc]
        for (var i = 0; i < tujuan.length; i++)
            tujuan[i].n = Qt.binding(function () { return i * root.basis })

        console.log(ta.n, tb.n, tc.n)        // 0 10 20  (dihitung saat dipasang)
        basis = 100                           // memicu evaluasi ulang
        console.log(ta.n, tb.n, tc.n)        // 300 300 300 dengan var; 0 100 200 dengan let
        Qt.quit()
    }
}
```

**Bedah kode:**

- `const tujuan = [ta, tb, tc]`: larik tiga objek tujuan. `const` melarang penugasan ulang variabel `tujuan`.
- `for (var i = 0; ...)`: `var` membuat satu variabel `i` untuk seluruh fungsi, bukan satu per putaran.
- `Qt.binding(function () { return i * root.basis })`: fungsi ini menangkap variabel `i` yang sama untuk ketiga binding, bukan nilainya.
- Cetakan pertama benar (0, 10, 20) karena tiap binding dievaluasi segera saat dipasang, ketika `i` bernilai 0, 1, dan 2.
- Setelah loop, `i` bernilai 3. Saat `basis` berubah, ketiga binding dievaluasi ulang dengan `i` yang sama, yaitu 3, sehingga semuanya 300. Bug ini tersembunyi sampai ada perubahan `[uji]`.
- Perbaikan: `for (let i = 0; ...)`. Pada `let` di kepala `for`, setiap putaran memiliki variabel `i` sendiri, sehingga hasil akhirnya 0, 100, 200.

**Opsi lain, perbaikan untuk logika yang sama:**

| Cara | Contoh | Catatan |
| --- | --- | --- |
| `let` di kepala loop | `for (let i = 0; ...)` | Paling ringkas |
| Callback dengan parameter | `tujuan.forEach(function (t, k) { t.n = Qt.binding(function () { return k * root.basis }) })` | `k` dibuat baru per panggilan |
| Fungsi pabrik | `function ikat(t, k) { t.n = Qt.binding(() => k * root.basis) }` | Tiap `k` terpisah |
| Hindari loop imperatif | `Repeater` atau `Instantiator` dengan `required property int index` (3.4.7) | Binding deklaratif |

**Hal yang perlu diingat:**

- Closure menahan lingkungannya. Handler yang tersambung ke sinyal berumur panjang menahan semua yang ia tangkap sampai Anda memutuskannya (3.2.4, 3.3.6).
- Closure yang menangkap objek yang kemudian dihancurkan akan membaca objek mati. Periksa dan putuskan di `Component.onDestruction` (3.3.3).
- `this` di dalam closure tidak selalu seperti dugaan (3.4.1). Tangkap `id` yang jelas, bukan `this`.

| Kesalahan | Solusi |
| --- | --- |
| `var` di loop yang membuat closure | Pakai `let`, atau fungsi pabrik |
| Mengira closure menyalin nilai | Ia menangkap variabel, bukan nilainya |
| Menahan objek lewat closure tanpa memutusnya | Putuskan koneksi saat objek hancur |

**Referensi:** [MDN: Closures](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures) · [MDN: let](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let) · [You Don't Know JS Yet: Scope & Closures](https://github.com/getify/You-Dont-Know-JS/tree/2nd-ed/scope-closures) · [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html)

---

### 3.4.7 Delegate, injeksi konteks, dan `pragma ComponentBehavior` `[TAMBAHAN]`

*Yang paling sering membingungkan adalah yang tak pernah Anda tulis: nama yang muncul sendiri.*

**Konsep.** Properti `delegate` pada `ListView`, `Repeater`, atau `Instantiator` bertipe komponen. Dokumentasi menyebut bahwa `Component` dibuat otomatis di sekeliling objek yang Anda tulis. Cara kerja lamanya: setiap instans delegate mendapat konteks privat yang berisi `index`, `model`, `modelData`, dan nama-nama role. Nama itu muncul tanpa deklarasi, jadi pemakaiannya adalah akses telanjang yang tak terlihat alat.

Cara modernnya adalah `required property`. Menurut dokumentasi, bila delegate punya properti wajib yang namanya sama dengan role model, properti itu diisi dengan nilai role tersebut.

**`pragma ComponentBehavior` (sejak Qt 6.4).** Satu berkas bisa memuat beberapa komponen yang bersarang. Komponen dalam bisa saja dibuat dari konteks lain, sehingga `id` luar belum tentu ada, dan mesin maupun alat tak bisa memastikan tipenya. Pragma ini menentukan sikapnya:

- `Unbound` (bawaan): komponen boleh dibuat dalam konteks lain. Bila nama bentrok, properti lokal mengalahkan `id` di luar komponen, tetapi tidak `id` di dalam komponen.
- `Bound`: semua komponen di berkas hanya membuat objek dalam konteks aslinya. `id` luar aman dipakai, dan alat menganggap tipe `id` itu tersedia. Bila nama bentrok, `id` luar mengalahkan properti lokal.
- Delegate yang terikat tidak menerima konteks privat. Data model hanya bisa masuk lewat `required property`, dan `model.nama` tak lagi bekerja.
- Pragma berlaku untuk semua komponen di berkas, sedalam apa pun bersarangnya, dan ditulis sebelum `import`.
- Dokumentasi menyatakan bahwa bawaannya akan berubah menjadi `Bound` pada versi Qt mendatang. Tulis `Bound` secara eksplisit mulai sekarang.

**Percobaan 1: siapa yang menang saat nama bentrok.**

```qml
pragma ComponentBehavior: Bound
import QtQuick

ListView {
    id: radius                          // id luar yang SENGAJA bernama sama dengan properti Rectangle
    width: 100; height: 100
    property int nilai: 12
    model: 1
    delegate: Rectangle {
        Component.onCompleted: {
            console.log(radius.nilai)   // Bound: 12
            Qt.quit()
        }
    }
}
```

```bash
QT_QPA_PLATFORM=offscreen qml bound.qml
```

Dugaan: `qml: 12`. Hapus baris `pragma`, dan `radius` kini dibaca sebagai properti `radius` milik `Rectangle` (sebuah angka), sehingga hasilnya `undefined` `[uji]`.

**Bedah kode:**

- `pragma ComponentBehavior: Bound`: mengikat semua komponen di berkas ke konteks asalnya.
- `id: radius`: nama `id` yang sengaja sama dengan properti `radius` milik `Rectangle`, untuk memancing bentrokan.
- `model: 1`: model berupa angka, jadi view membuat satu delegate.
- `delegate: Rectangle { ... }`: komponen implisit. `Component.onCompleted` jalan saat instans selesai dibuat.
- `radius.nilai`: pada `Bound`, `id` luar menang atas properti lokal, jadi hasilnya properti `nilai` milik `ListView`.

**Percobaan 2: delegate tanpa konteks tersuntik (tanpa jendela).**

```qml
pragma ComponentBehavior: Bound
import QtQml
import QtQml.Models

QtObject {
    id: root
    property string awalan: 'nomor'

    Instantiator {
        model: ListModel {
            ListElement { nama: 'satu' }
            ListElement { nama: 'dua' }
        }
        delegate: QtObject {
            required property int index          // diisi oleh pabrik objek
            required property string nama        // cocok dengan nama role model
            Component.onCompleted: console.log(root.awalan, index, nama)
        }
    }

    Timer { interval: 100; running: true; onTriggered: Qt.quit() }
}
```

```bash
qml -a core instansiasi.qml
```

Dugaan keluaran: `qml: nomor 0 satu` dan `qml: nomor 1 dua` (urutan tak dijamin) `[uji]`.

**Bedah kode:**

- `import QtQml.Models`: modul yang memuat `ListModel` dan `Instantiator`.
- `Instantiator`: pabrik non-visual yang membuat satu objek delegate per elemen model.
- `ListModel { ListElement { nama: 'satu' } }`: model dengan satu role bernama `nama`.
- `required property int index`: `index` kini dideklarasikan dan bertipe. Ia diisi pabrik dengan posisi elemen.
- `required property string nama`: namanya cocok dengan role, jadi diisi nilai role itu.
- `root.awalan`: akses ke `id` di luar delegate. Aman karena komponennya `Bound`.
- `Timer ... Qt.quit()`: memberi waktu pabrik membuat objek, lalu menghentikan `qml`.

Bila Anda menghapus `required property` lalu menulis `console.log(index, nama)` pada versi `Bound`, nama-nama itu tak lagi tersedia dan hasilnya galat atau `undefined` `[uji]`.

```
 Gaya lama (Unbound + injeksi)               Gaya baru (Bound + required)
 view --membuat--> delegate                  view --membuat--> delegate
        | konteks privat disuntik:                  | tanpa konteks privat
        |   index, model, modelData, role           | nilai masuk lewat required property
        v                                           v
 nama muncul dari udara (telanjang)          nama dideklarasikan, bertipe, terlihat alat
```

|  | Gaya lama | Gaya baru |
| --- | --- | --- |
| Pragma | Tidak ada (`Unbound`) | `pragma ComponentBehavior: Bound` |
| `index`, role | Muncul otomatis | `required property` |
| Bagi alat | Akses telanjang | Tipe dikenal |
| `id` di luar delegate | Bisa tak ada bila delegate dibuat di konteks lain | Aman |
| Nama bentrok | Properti lokal menang | `id` luar menang |

**Opsi lain, memberi data ke objek yang dibuat pabrik:**

| Cara | Kapan |
| --- | --- |
| `required property` yang cocok dengan role | Dianjurkan |
| `required property var model` (seluruh objek model) | Bila memerlukan semua role sekaligus `[uji]` |
| `model.nama` atau `modelData` telanjang | Kode lama; tak jalan pada delegate `Bound` |
| Properti di `Loader` untuk meneruskan `index` | Komponen yang dibuat `Loader` di dalam delegate (3.3.5) |

| Kesalahan | Solusi |
| --- | --- |
| `index` atau `nama` tak terdefinisi setelah menambah `Bound` | Deklarasikan `required property` yang cocok |
| Nama role di model tak cocok dengan nama properti | Samakan penulisannya, huruf besar kecil ikut dihitung |
| Delegate memakai `id` luar tetapi dibuat dari berkas lain | Pindahkan komponen ke dalam berkas yang sama, atau teruskan sebagai properti |
| Mengabaikan perubahan bawaan di versi Qt mendatang | Tulis `pragma ComponentBehavior: Bound` di setiap berkas sejak sekarang |

**Referensi:** [Structure of a QML Document: ComponentBehavior](https://doc.qt.io/qt-6/qtqml-documents-structure.html) · [QML Object Attributes: Required Properties](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html) · [Models and Views in Qt Quick](https://doc.qt.io/qt-6/qtquick-modelviewsdata-modelview.html) · [Instantiator](https://doc.qt.io/qt-6/qml-qtqml-models-instantiator.html)

---

### 3.4.8 Merancang batas komponen dan mendiagnosis scope `[TAMBAHAN]`

*Komponen yang baik bisa dipindah ke proyek lain tanpa membawa separuh aplikasi.*

**Konsep.** Semua yang Anda pelajari di 3.4.1 sampai 3.4.7 bermuara pada satu disiplin: setiap komponen punya batas yang tertulis. Yang masuk, yang keluar, dan yang privat terbaca langsung dari berkasnya.

```
  properti (masuk) ------>+-------------------------+-----> sinyal (keluar)
  required property ----->|  id privat + logika     |-----> alias (ekspos anak)
  fungsi (perintah) ----->|  tak melihat ke luar    |
                          +-------------------------+
   tidak ada di sini: id milik pemakai, nama dari pemakai, context property
```

**Daftar periksa perancangan:**

1. Satu berkas, satu komponen, dengan antarmuka eksplisit: properti untuk data masuk, sinyal untuk kejadian keluar, fungsi untuk perintah, alias untuk mengekspos anak.
2. `id` bersifat privat. Letakkan di baris pertama dan beri nama `root` pada objek akar (3.4.2).
3. Data wajib dari luar dinyatakan dengan `required property` (3.4.4).
4. Komponen tak merujuk `id` atau nama milik pemakainya (3.4.2 dan 3.4.4).
5. Tulis `pragma ComponentBehavior: Bound` di setiap berkas (3.4.7).
6. Kualifikasi setiap akses ke properti induk, dan jalankan `qmllint` sampai bersih.
7. Data global memakai singleton, bukan context property (3.4.5).

**Diagnosis:**

| Gejala | Dugaan | Alat atau tindakan |
| --- | --- | --- |
| `ReferenceError: x is not defined` | `id` dari berkas lain, atau komponen dipakai di luar konteks yang diasumsikan | Jadikan properti atau alias; uji isolasi (di bawah) |
| Peringatan `[unqualified]` | Akses telanjang | Kualifikasi dengan `id`, atau pakai `required property` |
| Nilai salah padahal nama benar | Shadowing oleh `id`, variabel lokal, atau properti turunan | `console.log(typeof x, x)` di dalam binding; ganti nama |
| Nama `index` atau role hilang di delegate | `Bound` tanpa `required property` | Deklarasikan properti wajibnya |
| Komponen hanya jalan di satu tempat | Scoping dinamis atau context property | Ganti dengan antarmuka eksplisit |
| Atribut terlampir kosong di anak delegate | Dibaca tanpa awalan | Lewat `id` root delegate |
| Binding di loop menghasilkan nilai sama | Closure menangkap `var` | Pakai `let` atau fungsi pabrik (3.4.6) |

**Alat:**

- `qmllint Main.qml` (di Arch bisa `qmllint6`): kategori `unqualified` dan lainnya. Jalankan sebelum menjalankan aplikasi.
- `qmlls` (QML Language Server, di Arch bisa `qmlls6`): peringatan yang sama langsung di editor lewat klien LSP.
- `console.log(typeof x, x)` di dalam binding: melihat apa yang sebenarnya diselesaikan sebuah nama.

**Uji isolasi.** Salin satu komponen beserta satu berkas pemakai minimal ke direktori kosong, lalu jalankan. Bila gagal dengan `ReferenceError`, komponen itu punya ketergantungan tersembunyi pada pemakainya. Perbaiki sampai ia berjalan di direktori kosong. Ini sama dengan menguji sebuah layanan di *sandbox*: yang tak berjalan tanpa lingkungannya ternyata sudah bergantung pada lingkungan itu.

**Catatan keamanan.** Akses telanjang dan scoping dinamis membuat permukaan pengaruh yang tak tertulis: siapa pun di scope pemakai bisa mengubah perilaku komponen tanpa kelihatan. Antarmuka eksplisit mempersempit permukaan itu. Anda dapat mengaudit sebuah komponen dengan membaca deklarasi properti, sinyal, dan fungsinya saja.

| Kesalahan | Solusi |
| --- | --- |
| Menganggap komponen yang jalan di aplikasi pasti mandiri | Jalankan uji isolasi |
| Menumpuk `id` luar di dalam komponen demi kemudahan | Jadikan properti yang diteruskan |
| Mengabaikan peringatan `qmllint` karena aplikasi tetap jalan | Peringatan `unqualified` adalah utang yang tertunda |

**Referensi:** [QML Coding Conventions](https://doc.qt.io/qt-6/qml-codingconventions.html) · [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html) · [QML Language Server](https://doc.qt.io/qt-6/qtqml-tooling-qmlls.html) · [Qt Quick Compiler](https://doc.qt.io/qt-6/qtqml-qtquick-compiler-tech.html)

---

## E. Latihan 15 menit dan kunci jawaban

**Latihan (dari kurikulum):** ubah contoh agar `Text` menampilkan `nilai` dari tiga tingkat, dan lihat apa yang dikeluhkan `qmllint` bila kualifikasi dihilangkan.

```qml
import QtQuick

Item {
    id: root
    property int nilai: 1

    Rectangle {
        id: tengah
        property int nilai: 2

        Rectangle {
            id: dalam
            property int nilai: 3

            Text {
                text: root.nilai + ' / ' + tengah.nilai + ' / ' + dalam.nilai
                Component.onCompleted: { console.log(text); Qt.quit() }
            }
        }
    }
}
```

```bash
QT_QPA_PLATFORM=offscreen qml tiga.qml
qmllint tiga.qml
```

Dugaan: `qml: 1 / 2 / 3`, dan `qmllint` bersih untuk `text` karena semuanya berkualifikasi `[uji]`.

Sekarang ganti baris `text:` menjadi `text: nilai` lalu ulangi kedua perintah. Dugaan: hasilnya `1` dan `qmllint` melapor `unqualified` untuk `nilai` `[uji]`.

**Kunci:**

- Versi telanjang menghasilkan 1, bukan 3. `Text` tak punya `nilai`, dan pencarian tidak mampir ke `dalam` atau `tengah`. Ia langsung ke objek akar komponen, yaitu `root`. Inilah kejutan yang dimaksud di audit nomor 2.
- Pada struktur yang lebih rumit, hasil telanjang bisa terlihat benar secara kebetulan. Karena itu `qmllint` menandainya, dan konvensi Qt meminta `id` yang eksplisit.

**Cek pemahaman (dari kurikulum):** *Mengapa `root.nilai` lebih baik daripada `nilai`?* Karena ia tak bergantung pada urutan pencarian dan tak tertipu oleh nama yang sama di tempat lain. Ia tetap benar saat elemen dipindahkan di dalam berkas, dibaca jelas oleh manusia, dan dikenali `qmllint` serta Qt Quick Compiler, sehingga alat dapat mengoptimalkannya.

**Pertanyaan tambahan:**

1. *Siapa yang menang antara variabel lokal JS, `id`, dan properti scope object?* Variabel lokal menang atas semuanya, lalu `id` atas properti.
2. *Mengapa `mesin.hitung` galat di `Main.qml` pada 3.4.2?* `id` hanya berlaku dalam dokumen tempat ia dideklarasikan. Ekspos lewat `property alias`.
3. *Apa bedanya `Bound` dan `Unbound` saat nama bentrok?* `Unbound`: properti lokal mengalahkan `id` luar. `Bound`: `id` luar mengalahkan properti lokal.
4. *Mengapa `model.nama` gagal pada delegate `Bound`?* Delegate terikat tidak menerima konteks privat. Data hanya lewat `required property`.
5. *Mengapa `ListView.isCurrentItem` gagal di anak delegate?* Atribut itu hanya terpasang pada root delegate. Baca lewat `id` root.
6. *Mengapa context property sulit bagi alat?* Ia disuntik saat berjalan dari C++, sehingga tak ada deklarasi yang bisa dibaca sebelum QML dimuat.
7. *Mengapa closure `var` di loop memberi nilai sama?* Satu variabel dipakai semua binding, dan nilainya sudah 3 saat dievaluasi ulang.

**Tantangan:**

- Ubah lab 3.4.5 dari context property menjadi `required property` + `setInitialProperties`, lalu bandingkan keluaran `qmllint` sebelum dan sesudah.
- Lakukan uji isolasi pada `Kop.qml` versi awal 3.4.4: salin ke direktori kosong tanpa `Halaman.qml`. Catat galatnya, lalu perbaiki dengan `required property`.

---

## F. Glosarium Modul 3.4

| Istilah | Arti |
| --- | --- |
| Scope | Wilayah tempat sebuah nama dapat dikenali |
| Scope object | Objek pemilik binding; propertinya dipakai tanpa awalan |
| Component scope | Gabungan `id` dalam komponen dan properti objek akarnya |
| Objek akar (root) | Objek paling atas dalam sebuah berkas QML |
| Konteks (context) | Lingkungan tempat `id` dan nama diselesaikan saat objek dibuat |
| Scoping dinamis | Komponen dapat memakai nama dari scope pemakainya |
| `id` | Nama bagi objek, berlaku dalam satu dokumen; bukan properti |
| Shadowing | Satu nama menutupi nama lain yang lebih jauh |
| `virtual` / `override` / `final` | Kata kunci untuk menyatakan penimpaan properti secara eksplisit |
| Akses berkualifikasi | Merujuk lewat `objek.nama`, bukan nama telanjang |
| Akses telanjang (unqualified) | Nama tanpa awalan yang diselesaikan lewat urutan pencarian |
| Atribut terlampir (*attached property*) | Properti yang dipasang tipe lain pada objek tertentu, misalnya `ListView.isCurrentItem` |
| `property alias` | Properti yang menjadi referensi langsung ke properti lain |
| `required property` | Properti yang wajib diisi saat objek dibuat |
| Context property | Nama yang disuntik dari C++ ke konteks QML |
| Singleton | Objek tunggal per mesin QML, diakses lewat nama tipenya |
| Delegate | Komponen yang dibuat view atau pabrik objek untuk tiap elemen model |
| Injeksi konteks | Nama (`index`, `model`, role) yang disuntik ke delegate secara otomatis |
| `ComponentBehavior` | Pragma yang menentukan apakah komponen terikat ke konteks asalnya (`Bound`) atau tidak (`Unbound`) |
| Closure | Fungsi beserta lingkungan tempat ia dibuat |
| `this` | Di dalam `Qt.binding`, objek penerima binding |
| `qmllint` | Pemeriksa statis QML; kategori `unqualified` melaporkan akses telanjang |
| `qmlls` | Server bahasa QML untuk editor |

---

## G. Hubungan dengan modul lain

| Modul | Hubungan |
| --- | --- |
| **2.2.4** | Dasar scope dan isolasi yang diperdalam di sini |
| **3.1** Property Binding | Setiap nama yang dibaca menjadi dependensi; `this` di `Qt.binding`; closure pada `Qt.binding` (3.4.6) |
| **3.2** Signal dan Connections | `target` `Connections` dijangkau lewat `id`; parameter handler eksplisit, bukan injeksi; `connect()` membuat closure |
| **3.3** Lifecycle | Konteks pembuatan menentukan nama yang terlihat; objek dinamis tak punya `id`; `Loader` di delegate dan `index` |
| **Fase View/Delegate** | `required property`, `pragma ComponentBehavior: Bound`, dan injeksi `index` dan `model` (3.4.7) |
| **Fase 10** (C++) | Context property, singleton, `setInitialProperties` |
| **Bagian B8** | Closure secara mendalam |
| **Keamanan (13.x)** | *Least privilege*: antarmuka komponen yang sempit dan permukaan injeksi yang kecil |

**Penutup Fase 3:** dengan Modul 3.4 selesai, Anda sudah memegang empat alat inti model objek QML: binding (3.1), sinyal (3.2), siklus hidup (3.3), dan scope (3.4). Fase berikutnya belum ada di berkas Anda, jadi kirimkan bagian kurikulumnya bila siap melanjutkan.

---

**Catatan tautan:** halaman Qt yang telah dibuka langsung adalah Scope and Naming Resolution, Structure of a QML Document, QML Object Attributes, Property Shadowing and Override Semantics, dan Context Properties (semuanya 6.12). Bagian `this` pada Property Binding, panduan `qmllint` kategori `unqualified`, dan QML Coding Conventions dibaca lewat hasil pencarian dari beberapa versi Qt 6, jadi tandai `[uji]` pada versi Anda. Halaman Qt lain (QQmlApplicationEngine, Singletons in QML, Instantiator, Models and Views, QQmlContext, qmllint, qmlls, Qt Quick Compiler, JavaScript Host Environment) muncul sebagai tautan di halaman yang sudah dibuka tetapi tidak dibuka dengan cara satu per satu. Tautan MDN dan You Don't Know JS tidak saya buka.

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../qml.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

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

