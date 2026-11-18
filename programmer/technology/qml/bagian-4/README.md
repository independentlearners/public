# Fase 3 · Modul 3.1 — Property Binding

Saya membaca bagian Fase 3 dari berkas kurikulum yang Anda kirim, lalu mengaudit Modul 3.1 terhadap dokumentasi Qt 6.12 (Binding, Property Binding, Performance considerations) dan sumber pendukung. Seperti sebelumnya, saya tidak menjalankan kode ini pada Qt, jadi bagian bertanda `[uji]` perlu Anda buktikan sendiri.

---

## A. Audit singkat

**Tumpang tindih dengan Fase 2.** Sebagian isi Fase 3 sudah saya bahas di Fase 2. Itu bukan kesalahan kurikulum, karena Fase 3 memang memperdalam. Agar tidak mengulang, setiap modul Fase 3 merujuk ke sana dan menambah yang belum ada:

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
5. **Properti yang tak terpantau (*non-NOTIFYable*) tidak disebut.** Properti yang non-konstan dan tak punya notifikasi, bila dipakai di binding, membuat binding berpotensi usang. `qmllint` menandainya sebagai `stale-property-read`. Saat berjalan, mesin dapat mencetak peringatan "Expression … depends on non-NOTIFYable properties". Penting untuk Fase C++ nanti dan saya tambahkan di 3.1.1.
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

**Tumpang tindih dengan Fase 2.** Sebagian besar dasar Modul 3.2 sudah ada di **2.2.2** (signal handler, parameter, `arguments`) dan **2.2.7** (`Connections`, `connect()`). Di sini saya tidak mengulang penjelasannya, melainkan memperdalam dan menutup celah.

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

**Tumpang tindih dengan Fase 2.** `Component.onCompleted` dan `onDestruction` sudah ada di **2.2.6**, dan `Qt.callLater` di **2.4.3**. Di sini saya tidak mengulangnya, melainkan memperdalam: fase pembuatan, penghancuran, pembuatan dinamis, dan `Loader`.

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

Modul 3.3 selesai. Lanjut ke **Modul 3.4 — Scope, ID, dan Konteks**? Sebagian isinya sudah ada di 2.2.4, jadi 3.4 akan fokus pada shadowing, context property, dan kebiasaan akses berkualifikasi.

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

