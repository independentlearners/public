# Materi Mendalam Mastery Qt 6 — Fase 1: Bahasa QML

*Dokumentasi belajar mandiri, lanjutan dokumen Fase 0 · 7 November 2026 · Acuan: Kurikulum Mastery Qt 6 — QML & Qt Quick (Edisi Revisi 4 November 2026) · Target Qt 6.12 LTS (minimal 6.8) · Arch Linux, terminal-centric*

## Cara membaca dokumen ini

Dokumen ini melanjutkan dokumen Fase 0 dengan pola yang sama: audit singkat, pengantar tingkat fase, lalu satu modul per giliran. Prasyarat: Fase 0 (terutama terminal di 0.0.3, git di 0.0.6, membaca error di 0.0.7, dan mendaftarkan berkas di 0.2.6). Semua contoh QML dijalankan dengan `qml NamaBerkas.qml` di folder `~/Development/qt-learning/fase1/`.

| Bagian | Isi | Status |
| --- | --- | --- |
| 1. Audit Fase 1 dan Modul 1.1 | Pemeriksaan sebelum materi | Selesai |
| 2. Fase 1 (tingkat fase) | Peran, filosofi, peta, hubungan | Selesai |
| 3. Modul 1.1 — Sintaks Dasar dan Struktur Dokumen | Sub-bagian 1.1.1 sampai 1.1.7 | Ditulis di dokumen ini |
| Modul 1.2, 1.3, 1.4 | Tipe data, properti, komponen | Menunggu konfirmasi Anda |

**Konvensi** sama dengan Fase 0: baris berawalan `$` adalah perintah; tabel **Kata demi kata** menerangkan kode; **\[TAMBAHAN\]** menandai materi di luar kurikulum asli beserta alasannya; **\[amati\]** berarti hasil bergantung mesin Anda dan harus dibuktikan sendiri. Tautan berasal dari dokumentasi resmi, dan belum diuji otomatis.

## 1. Audit

Diperiksa pada 7 November 2026 terhadap dokumentasi resmi Qt (*Structure of a QML Document*, *Import Statements*, *QML Coding Conventions*, `qmlformat`) dan sumber komunitas untuk perilaku nama berkas.

### 1.1 Audit Fase 1 (tingkat fase)

- **Urutan modul masuk akal.** 1.1 sintaks, 1.2 tipe, 1.3 properti, 1.4 komponen; prasyaratnya Fase 0 sudah terpenuhi (terminal, `qml`, git, membaca error).
- **Loncatan ringan ke Fase 2.** Contoh di Fase 1 memakai ekspresi JavaScript dan handler (`onClicked`, `console.log`) sebelum Fase 2 mengajarkan JavaScript. Mitigasi: Fase 1 membatasi JavaScript pada ekspresi satu baris dan `console.log`; setiap kemunculan dijelaskan seperlunya dengan penunjuk ke Fase 2.
- **Estimasi 2–3 minggu** tampak cukup untuk empat modul; dengan sub-bagian tambahan, Jalur A sebaiknya diasumsikan 3 minggu.

### 1.2 Audit Modul 1.1

**Terverifikasi (tidak perlu diubah):**

- Sebuah dokumen QML terdiri atas tiga bagian: daftar pragma (opsional), pernyataan import, dan **satu** deklarasi objek akar. Dokumen selalu berkode UTF-8, dan menurut konvensi satu baris kosong memisahkan import dari hierarki objek.
- Pragma ditulis **sebelum** import (contoh resmi menaruh `pragma ComponentBehavior: Bound` di baris pertama).
- Nama berkas berawalan huruf besar memudahkan pemakaian sebagai tipe. Berkas berawalan huruf kecil tidak dikenali sebagai tipe oleh dokumen lain dalam satu direktori.
- Urutan atribut menurut *QML Coding Conventions* Qt: `id`, deklarasi properti, deklarasi signal, fungsi JavaScript, properti objek, lalu objek anak.
- `qmlformat -i` memformat berkas di tempat; `qmllint` menganalisis statis.

**Perlu dikoreksi atau dilengkapi:**

1. **Daftar pragma tidak ada.** Kurikulum hanya menyebut “pragma ditulis sebelum import”. Qt 6 punya tujuh pragma yang bermakna (Singleton, ComponentBehavior, ListPropertyAssignBehavior, FunctionSignatureBehavior, NativeMethodBehavior, ValueTypeBehavior, Translator), masing-masing dengan versi awal dan nilai bawaan. Ditambahkan di 1.1.1.
2. **Tiga jenis import belum dibedakan.** Selain import modul, ada import direktori dan import berkas JavaScript, dengan sintaks `as` untuk namespace. Ditambahkan di 1.1.1.
3. **Cek pemahaman no. 1 perlu jawaban presisi.** `button.qml` tetap dokumen QML yang sah (bisa dijalankan dengan `qml button.qml`), tetapi tidak dapat dipakai sebagai tipe lewat nama itu karena nama tipe harus berawalan huruf besar. Ada jalan keluar (`QT_QML_SOURCE_TYPE_NAME` di CMake atau entri `qmldir`). Jebakan terkait: berkas bernama `Button.qml` bisa bertabrakan dengan `Button` dari Qt Quick Controls. Ditambahkan di 1.1.6.
4. **Aturan `id` tidak dijabarkan.** Tidak ada penjelasan aturan penamaan, cakupan (scope), dan hal yang tidak bisa dilakukan `id`. Ditambahkan di 1.1.4.
5. **`qmlformat` dan konvensi hanya disebut sekilas.** Tidak ada penjelasan `--normalize`, pengaturan indentasi, pengaturan titik koma, atau direktif `// qmlformat off`. Ditambahkan di 1.1.5.
6. **Gaya tanda kutip.** Contoh kurikulum memakai kutip tunggal; contoh resmi Qt memakai kutip ganda. Keduanya sah di JavaScript; yang penting konsisten. Dicatat di 1.1.5.
7. **Jawaban “mengapa dua root dilarang”** belum dijelaskan alasan desainnya, dan pesan galat nyatanya tidak ditunjukkan. Ditambahkan di 1.1.2 dan 1.1.7.
8. **Sub-bagian tambahan:** 1.1.7 Lab merusak dokumen dan kamus galat. Alasannya mengikuti pola 0.0.7: hafalan pesan lebih lemah daripada koleksi pesan yang Anda buktikan sendiri.

**Daftar isi Modul 1.1 yang diperbarui:**

| No. | Judul | Asal |
| --- | --- | --- |
| 1.1.1 | Struktur dokumen: pragma, import, root | Asli 1.1.1, diperluas |
| 1.1.2 | Objek dan hierarki | Asli 1.1.2 |
| 1.1.3 | Properti dasar | Asli 1.1.3 |
| 1.1.4 | `id` dan referensi | Asli 1.1.4, diperluas |
| 1.1.5 | Komentar, `qmlformat`, dan konvensi penulisan | Asli 1.1.5, diperluas |
| 1.1.6 | Konvensi nama berkas | Asli 1.1.6, diperluas |
| 1.1.7 | Lab merusak dokumen dan kamus galat | **\[TAMBAHAN\]** |

## 2. Fase 1 — Bahasa QML (tingkat fase)

**Daftar isi bagian ini:** 2.1 Deskripsi dan peran · 2.2 Konsep kunci dan filosofi · 2.3 Peta Fase 1 · 2.4 Hubungan dengan fase lain · 2.5 Kriteria lulus · 2.6 Kesalahan umum tingkat fase · 2.7 Referensi

### 2.1 Deskripsi dan peran

Fase 1 mengajarkan **bahasa QML itu sendiri**: bagaimana sebuah dokumen disusun (1.1), tipe nilai apa yang ada (1.2), bagaimana properti dideklarasikan dan dihubungkan (1.3), dan bagaimana dokumen dipecah menjadi komponen yang bisa dipakai ulang (1.4). Fase 0 memberi Anda tangan yang cakap di terminal; Fase 1 memberi Anda bahasa untuk menyatakan apa yang ingin Anda lihat di layar. Semua fase berikutnya memakai bahasa ini, sehingga ketelitian di sini terbayar berkali-kali.

### 2.2 Konsep kunci dan filosofi

1. **Dokumen adalah tipe.** Satu berkas `.qml` mendefinisikan satu tipe baru yang bisa Anda pakai di berkas lain. Ini memaksa pemikiran dalam komponen.
2. **Deklaratif.** Anda menyatakan *apa* yang ada dan bagaimana bagian-bagiannya berhubungan; engine yang menjaga hubungan itu (0.1.1).
3. **Hierarki sebagai struktur.** Objek bersarang membentuk pohon; pohon itulah antarmuka Anda.
4. **Baca sebelum tulis.** Hampir setiap baris QML yang akan Anda tulis di kehidupan nyata berawal dari membaca dokumentasi sebuah tipe (0.1.5); Fase 1 melatih Anda membaca dokumen QML orang lain dengan cepat.

**Analogi:** QML seperti denah arsitek. Satu lembar denah menggambarkan satu ruangan (tipe); ruangan boleh berisi ruangan kecil lain (anak); dan denah tidak berisi instruksi pembangunan, hanya hasil akhirnya.

### 2.3 Peta Fase 1

```
   1.1 Sintaks dasar dan struktur dokumen   "bagaimana dokumen disusun"
         |
   1.2 Tipe data dan sistem tipe            "nilai apa yang boleh ditaruh"
         |
   1.3 Properti, alias, atribut objek        "bagaimana nilai dideklarasikan dan dihubungkan"
         |
   1.4 Komponen dan reuse                    "bagaimana dokumen dipakai ulang"
         |
         v
   Fase 2 (JavaScript) ... Fase 3 (reaktivitas) ... Fase 4 (visual)
```

### 2.4 Hubungan dengan fase lain

| Konsep dari Fase 1 | Dipakai kembali di |
| --- | --- |
| Struktur dokumen, `id`, hierarki | Seluruh fase; Modul 5.1 (komponen), 8.1 (modul) |
| Tipe dan konversi | Fase 2 (JavaScript), Fase 10 (jembatan C++) |
| Properti dan binding | Fase 3 (reaktivitas), Fase 6 (state dan animasi) |
| Komponen dan reuse | Fase 5 (layout dan styling), Fase 8 (modul), Fase 9 (kontrol kustom) |
| `qmllint`, `qmlformat`, konvensi | Modul 12.2 (kualitas) |

### 2.5 Kriteria lulus

Anda lulus Fase 1 bila dapat, **tanpa melihat catatan**:

- Menyusun dokumen QML yang benar (pragma, import, satu root, hierarki) dan menjelaskan fungsi tiap bagiannya.
- Memilih tipe properti yang tepat untuk sebuah data dan menghindari jebakan konversi.
- Mendeklarasikan properti (`property`, `readonly`, `required`, `alias`) dan menjelaskan kapan memakai masing-masing.
- Memecah antarmuka menjadi komponen berkas dan menggunakannya ulang, dengan nama berkas yang benar.
- Memformat dan memeriksa kode dengan `qmlformat` dan `qmllint`, dan membaca pesan galat sintaks dengan cepat.

### 2.6 Kesalahan umum tingkat fase

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Menulis QML seperti JavaScript atau JSON | Sintaks tampak mirip (0.1.1) | Ingat: tipe, hierarki, binding |
| Satu berkas raksasa | Tidak memecah ke komponen | Dahulukan komponen kecil (1.4) |
| Memakai `var` untuk semuanya | Menghindari memilih tipe | Tipe terketik (1.2) |
| Mengabaikan peringatan `qmllint` | Merasa “jalan juga” | Bersihkan sampai nol |
| Menyalin tutorial Qt 5 | Mencari tanpa memeriksa versi | Periksa 0.1.5 |

### 2.7 Referensi tingkat fase

- [QML Applications](https://doc.qt.io/qt-6/qmlapplications.html) · [QML Reference](https://doc.qt.io/qt-6/qmlreference.html) · [QML Syntax Basics](https://doc.qt.io/qt-6/qtqml-syntax-basics.html)
- [Structure of a QML Document](https://doc.qt.io/qt-6/qtqml-documents-structure.html) · [QML Object Attributes](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html)
- [QML Coding Conventions](https://doc.qt.io/qt-6/qml-codingconventions.html)

---

## 3. Modul 1.1 — Sintaks Dasar dan Struktur Dokumen

**Daftar isi modul ini:** 3.1 Deskripsi dan peran · 3.2 Filosofi modul · 3.3 Visual: anatomi sebuah dokumen · 3.4 Terminologi modul · 3.5 Estimasi waktu · lalu 1.1.1 sampai 1.1.7

### 3.1 Deskripsi dan peran

Modul ini membekali Anda membaca dan menulis kerangka setiap dokumen QML: bagian-bagiannya, aturan penulisannya, cara menamai berkas dan objek, dan cara memeliharanya dengan alat. Semua modul berikutnya menambah isi pada kerangka ini.

### 3.2 Filosofi modul

**Aturan sedikit, pengaruh besar.** Sintaks QML sengaja kecil: tiga bagian dokumen, satu bentuk deklarasi objek. Karena aturannya sedikit, kesalahan kecil (huruf besar-kecil, satu akar ekstra) berakibat besar dan mudah dikenali setelah Anda tahu pola galatnya.

### 3.3 Visual: anatomi sebuah dokumen

```
  Main.qml                       (satu berkas = satu tipe bernama "Main")
 +-----------------------------------------------------------+
 | pragma ComponentBehavior: Bound      <-- pragma (opsional)  |
 | import QtQuick                       <-- import             |
 | import QtQuick.Controls as QQC                              |
 |                                      <-- satu baris kosong  |
 | Rectangle {                          <-- objek AKAR (satu!) |
 |     id: root                         <-- id                 |
 |     property int jumlah: 3           <-- deklarasi properti |
 |     width: 300                       <-- penugasan nilai    |
 |     Text { text: 'Halo' }            <-- objek anak         |
 | }                                                           |
 +-----------------------------------------------------------+
```

### 3.4 Terminologi modul

| Istilah | Arti |
| --- | --- |
| Dokumen QML | Satu berkas `.qml`: pragma, import, satu objek akar |
| Objek akar (root) | Objek paling luar; ia menentukan tipe yang didefinisikan berkas |
| Objek anak (child) | Objek di dalam objek lain |
| Properti | Atribut bernilai dari sebuah objek |
| `id` | Nama objek yang berlaku di dalam satu dokumen |
| Pragma | Arahan kepada engine tentang cara menafsirkan dokumen |
| Import | Pernyataan yang memberi tahu engine modul, direktori, atau berkas JavaScript mana yang dipakai |
| Namespace lokal | Awalan yang diberikan lewat `as` pada sebuah import |
| Tipe | Jenis objek yang dapat diciptakan (mis. `Rectangle`) |

### 3.5 Estimasi waktu

Jalur A: 8–10 jam; Jalur B: 3–4 jam.

---

## 1.1.1 Struktur dokumen: pragma, import, root

*Semangat: seluruh bangunan besar berdiri dari fondasi yang rapi.*

**Daftar isi 1.1.1:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Tiga bagian dokumen · d. Pragma · e. Import: tiga jenis · f. Contoh yang dapat dijalankan · g. Opsi lain · h. Visual: jalur pencarian import · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Bagian ini menjelaskan tiga bagian yang menyusun setiap dokumen QML dan fungsi masing-masing. Bila Anda dapat membaca bagian atas sebuah berkas QML dan menjelaskan semuanya, Anda sudah memahami bagaimana berkas itu akan ditafsirkan.

### b. Konsep dan filosofi

Dokumen QML terdiri atas **tiga bagian, dalam urutan tetap**: (1) daftar pragma yang opsional, (2) pernyataan import, (3) **satu** deklarasi objek akar. Dokumen selalu berkode UTF-8. Menurut konvensi, satu baris kosong memisahkan import dari objek.

**Mengapa hanya satu akar?** Sebuah berkas mendefinisikan satu tipe, dan sebuah tipe punya tepat satu bentuk dasar. Dua akar berarti dua tipe dalam satu berkas, yang tidak dapat dinamai oleh satu nama berkas. Bila Anda butuh banyak objek berdampingan, bungkus dalam satu akar (misalnya `Item`).

**Import bukan `#include`.** QML tidak punya preprosesor. Import tidak menyalin kode ke dokumen; ia hanya memberi tahu engine **ke mana mencari** tipe yang Anda sebut. Setiap nama tipe, termasuk yang dipakai di dalam blok JavaScript, diselesaikan semata-mata berdasarkan import.

### c. Tiga bagian dokumen

| Bagian | Wajib? | Isi | Contoh |
| --- | --- | --- | --- |
| Pragma | Tidak | Arahan untuk engine | `pragma ComponentBehavior: Bound` |
| Import | Ya (minimal satu bila memakai tipe dari modul) | Modul, direktori, atau JS yang dipakai | `import QtQuick` |
| Objek akar | Ya | Satu deklarasi objek | `Rectangle { ... }` |

Secara bawaan, dokumen dapat memakai tipe dari berkas `.qml` lain **dalam direktori yang sama** tanpa import. Untuk tipe dari modul atau direktori lain, import wajib.

### d. Pragma

Pragma adalah arahan kepada engine tentang cara memperlakukan dokumen ini. Ia ditulis **sebelum** import. Daftar menurut dokumentasi resmi Qt:

| Pragma | Nilai (bawaan **dicetak tebal**) | Sejak | Fungsi |
| --- | --- | --- | --- |
| `Singleton` | tanpa nilai | 5.2 | Menjadikan tipe akar singleton (satu instans per engine); perlu didaftarkan di modulnya (0.2.6) |
| `ListPropertyAssignBehavior` | **Append**, Replace, ReplaceIfNotDefault | 6.3 | Bagaimana penugasan ke properti list diperlakukan pada tipe turunan |
| `ComponentBehavior` | **Unbound**, Bound | 6.4 | Apakah komponen di dalam berkas terikat ke konteks aslinya; dokumentasi menyebut bawaan akan berubah menjadi Bound di versi Qt mendatang |
| `FunctionSignatureBehavior` | **Enforced**, Ignored | 6.5 | Apakah anotasi tipe pada fungsi dipaksakan; sejak Qt 6.7 dipaksakan juga oleh interpreter |
| `NativeMethodBehavior` | **RejectThisObject**, AcceptThisObject | 6.5 | Cara menangani objek `this` pada pemanggilan metode C++ |
| `ValueTypeBehavior` | **Reference** dan **Inaddressable** (bawaan), Copy, Addressable (6.6), Assertable (6.8) | 6.5 | Cara nilai bertipe-nilai (mis. `rect`) ditangani di JavaScript |
| `Translator` | nama konteks terjemahan | 6.7 | Menentukan konteks `qsTr` untuk dokumen |

Pragma yang paling berguna bagi pemula adalah `ComponentBehavior: Bound`: dengan nilai ini, komponen di dalam berkas (misalnya delegate `ListView`) dapat memakai `id` objek luar secara aman, dan alat seperti `qmllint` dapat menalar tipenya. Detailnya dibahas di Modul 7 dan 12.

### e. Import: tiga jenis

| Jenis | Bentuk umum | Contoh |
| --- | --- | --- |
| Modul | `import <URI> [versi] [as Awalan]` | `import QtQuick`, `import QtQuick.Controls as QQC` |
| Direktori | `import "<jalur>" [as Awalan]` | `import "../util" as Util` |
| Berkas JavaScript | `import "<berkas.js>" as <Pengenal>` | `import "helpers.js" as Helpers` |

Aturan yang perlu diingat:

- Nomor versi pada import modul **opsional**; bila dihilangkan, versi terbaru modul yang diimpor (menurut dokumentasi, bahkan versi minor saja boleh dihilangkan).
- `as Awalan` memasang tipe dari modul ke **namespace lokal**; sejak itu **setiap** pemakaian tipe dari modul itu wajib diawali `Awalan.`. Berguna bila dua modul punya tipe bernama sama.
- Pengenal untuk import JavaScript harus unik dalam dokumen; awalan modul boleh dipakai bersama oleh beberapa modul.
- Namespace hanya berlaku di dalam berkas; ia bukan properti yang bisa diakses dari luar.
- Memakai tipe tanpa mengimpor modulnya menghasilkan error, dan engine menolak memuat berkas.

### f. Contoh yang dapat dijalankan

Buat folder, lalu dua berkas:

```bash
$ mkdir -p ~/Development/qt-learning/fase1 && cd ~/Development/qt-learning/fase1
$ cat > helpers.js << 'EOF'
.pragma library

function salam(nama) {
    return 'Halo, ' + nama
}
EOF
```

Simpan sebagai `Main.qml`:

```qml
import QtQuick
import QtQuick.Controls as QQC
import "helpers.js" as Helpers

Rectangle {
    width: 320
    height: 140
    color: '#1e1e2e'

    Column {
        anchors.centerIn: parent
        spacing: 8

        Text { color: 'white'; text: Helpers.salam('QML') }
        QQC.Button { text: 'Tombol Controls' }
    }
}
```

```bash
$ qml Main.qml
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `.pragma library` (di `helpers.js`) | Arahan JavaScript: berkas ini menjadi pustaka bersama tanpa konteks QML sendiri. Ia **berbeda** dari pragma dokumen QML. |
| `function salam(nama) { ... }` | Fungsi JavaScript yang mengembalikan teks sapaan (Fase 2). |
| `import QtQuick` | Memuat tipe dasar: `Rectangle`, `Column`, `Text`. Tanpa awalan, tipenya bisa dipakai langsung. |
| `import QtQuick.Controls as QQC` | Memuat Qt Quick Controls ke namespace `QQC`. Tipenya **harus** ditulis `QQC.Button`. |
| `import "helpers.js" as Helpers` | Mengimpor berkas JavaScript relatif terhadap dokumen; fungsinya diakses lewat `Helpers`. |
| `Rectangle { ... }` | Objek akar tunggal; menentukan bahwa `Main` adalah sebuah `Rectangle`. |
| `Column { ... spacing: 8 }` | Menyusun anak-anaknya vertikal dengan jarak 8. |
| `Helpers.salam('QML')` | Memanggil fungsi dari berkas JavaScript. |
| `QQC.Button { ... }` | Tombol dari Controls lewat namespace. |

**Percobaan.** Tambahkan baris `Button { text: 'tanpa awalan' }` di dalam `Column`, jalankan, dan catat galatnya. Ia menunjukkan bahwa modul yang diimpor dengan `as` tidak lagi tersedia tanpa awalan **\[amati pesannya\]**. Hapus baris itu kembali.

### g. Opsi lain

| Tujuan | Opsi | Catatan |
| --- | --- | --- |
| Memakai tipe dari modul | `import QtQuick.Controls` (tanpa awalan) | Paling ringkas; bila tak ada bentrok nama |
| Menghindari bentrok nama | `import ... as Awalan` | Setiap pemakaian wajib berawalan |
| Memakai komponen di folder lain | Import direktori `import "../util"` | Cepat untuk proyek kecil; untuk proyek besar pakai modul (Fase 8) |
| Membagi logika | Berkas `.js` | Cocok untuk fungsi murni; untuk logika dengan status gunakan QML atau C++ |
| Logika bersama berupa tipe | Singleton QML (`pragma Singleton`) | Fase 8 |
| Mengunci pembatasan versi | `import QtQuick 6.8` | Menyatakan minimum (0.1.5-g) |

### h. Visual: jalur pencarian import

Saat Anda menulis `import Nama`, engine mencari modul di **jalur impor**. Daftar bawaannya (dokumentasi *Import Statements*, Qt 6.9):

```
  1. direktori berkas yang sedang dibaca
  2. lokasi QML terpasang Qt (QLibraryInfo::QmlImportsPath)   <-- qmake6 -query QT_INSTALL_QML
  3. jalur dari QML_IMPORT_PATH   (dipisah ":" di Linux)
  4. qrc:/qt-project.org/imports  (di dalam resource)
  5. qrc:/qt/qml                  (di dalam resource, sejak Qt 6.5)

  tambahan:  qml -I /jalur  |  QQmlEngine::addImportPath(...)  |  QML_IMPORT_PATH
  melacak :  QML_IMPORT_TRACE=1 qml Main.qml 2>&1 | head -50      (0.3)
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Pragma | Arahan untuk engine pada awal dokumen |
| `Bound` / `Unbound` | Komponen terikat ke konteks aslinya / tidak |
| Import modul | Memuat tipe terdaftar dari sebuah modul |
| Import direktori | Memuat komponen `.qml` dari sebuah folder |
| Import JavaScript | Memuat berkas `.js` dengan pengenal |
| Namespace lokal (`as`) | Awalan nama tipe, berlaku dalam satu berkas |
| Jalur impor | Daftar tempat engine mencari modul |
| `QML_IMPORT_PATH` | Variabel lingkungan jalur impor tambahan |
| `.pragma library` | Arahan berkas JavaScript untuk pustaka bersama |

### j. Tips dan praktik terbaik

- Biasakan satu urutan tetap: pragma, import (urut abjad membantu), satu baris kosong, objek akar.
- Impor hanya yang dipakai; `qmllint` memberi tahu import yang tidak terpakai.
- Gunakan `as` hanya untuk mengatasi bentrok nama; jangan mengimpor semuanya ke namespace demi “kerapian”.
- Aktifkan `pragma ComponentBehavior: Bound` pada berkas yang memiliki delegate atau komponen bersarang, supaya tooling dapat menalar `id`.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `X is not a type` | Modul tidak diimpor, atau diimpor dengan `as` | Tambah `import`, atau tulis `Awalan.X` |
| `module "X" is not installed` | Nama modul salah atau paket belum terpasang | 0.1.2 dan `QML_IMPORT_TRACE=1` |
| Pragma diabaikan atau galat | Ditulis setelah import | Pindahkan ke atas, sebelum import |
| Tipe dari folder lain tidak ditemukan | Lupa import direktori | `import "../folder"` atau daftarkan ke modul (0.2.6) |
| Fungsi dari `.js` tidak ditemukan | Pengenal import salah ketik | Cocokkan nama setelah `as` |
| Import JavaScript gagal | Jalur relatif salah | Jalur dihitung dari berkas QML yang mengimpor |

### l. Hubungan dengan modul lain

Prasyarat untuk 1.1.2 (objek akar dan anak), 1.1.6 (nama berkas dan impor direktori), Modul 1.4 (komponen), Fase 2 (JavaScript yang diimpor), Fase 8 (modul), dan Modul 12.2 (peringatan lint tentang import).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan contoh di bagian f. Lalu: (1) tambahkan `pragma ComponentBehavior: Bound` di baris pertama dan catat apakah ada perbedaan; (2) pindahkan pragma ke bawah `import QtQuick` dan catat hasilnya **\[amati\]**; (3) ubah `QQC` menjadi nama lain dan perbaiki semua pemakaiannya; (4) jalankan `QML_IMPORT_TRACE=1 qml Main.qml 2>&1 | head -30` dan temukan baris untuk `QtQuick.Controls`.

**Cek pemahaman.** (1) Apa tiga bagian dokumen QML dan urutannya? (2) Apa bedanya import modul, direktori, dan JavaScript? (3) Apa akibat `import ... as X` terhadap cara menulis tipe dari modul itu?

### n. Referensi

- [Structure of a QML Document](https://doc.qt.io/qt-6/qtqml-documents-structure.html) · [QML Syntax: Import Statements](https://doc.qt.io/qt-6/qtqml-syntax-imports.html)
- [Defining JavaScript Resources in QML](https://doc.qt.io/qt-6/qtqml-javascript-resources.html) · [Importing JavaScript Resources in QML](https://doc.qt.io/qt-6/qtqml-javascript-imports.html)
- [QML Modules (identified modules)](https://doc.qt.io/qt-6/qtqml-modules-identifiedmodules.html) · [qml tool](https://doc.qt.io/qt-6/qtqml-tooling-qml.html)

---

## 1.1.2 Objek dan hierarki

*Semangat: pohon yang Anda gambar hari ini akan tumbuh menjadi aplikasi yang Anda banggakan.*

**Daftar isi 1.1.2:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh: pohon objek · d. Mengapa anak cukup ditulis di dalam kurung (default property) · e. Urutan tumpukan · f. Mengapa dua akar dilarang · g. Opsi lain: memilih tipe akar · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Bagian ini menjelaskan bentuk dasar setiap isi dokumen QML: deklarasi objek, bagaimana objek bersarang membentuk pohon, dan bagaimana pohon itu memengaruhi tampilan dan referensi antarobjek. Hampir seluruh QML yang akan Anda tulis hanyalah variasi dari bentuk ini.

### b. Konsep dan filosofi

- **Deklarasi objek** berbentuk `Tipe { atribut... }`: nama tipe, lalu kurung kurawal berisi atribut (properti, handler, objek anak).
- Sebuah **objek** adalah instans sebuah tipe. Menulis `Rectangle { ... }` berarti “adakan satu persegi panjang dengan ciri-ciri berikut”.
- **Hierarki:** objek di dalam objek membentuk **pohon**. Objek akar adalah akar pohon; objek di dalamnya adalah anak, dan anak yang sama induknya disebut saudara (*sibling*).
- Pada objek visual (`Item` dan turunannya), setiap anak mengetahui induknya lewat properti `parent`, dan posisinya (`x`, `y`) dihitung **relatif terhadap induk**.

**Filosofi:** pohon **adalah** struktur antarmuka. Anda tidak menyusun layar dengan perintah “taruh A di atas B”, melainkan dengan menyatakan bahwa A berada di dalam B. Karena itu, mengubah struktur (memindah, menyembunyikan, atau menghapus induk) otomatis memengaruhi seluruh anaknya.

### c. Contoh: pohon objek

Simpan sebagai `Pohon.qml`, jalankan `qml Pohon.qml`:

```qml
import QtQuick

Rectangle {
    id: root
    width: 360
    height: 200
    color: '#1e1e2e'

    Rectangle {
        id: kartu
        width: 200
        height: 100
        radius: 12
        color: '#89b4fa'
        anchors.centerIn: parent

        Text {
            anchors.centerIn: parent
            text: 'Lebar induk: ' + parent.width
        }
    }

    Rectangle {
        width: 60
        height: 60
        color: '#f38ba8'
        x: 150
        y: 70
    }
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `Rectangle { id: root ... }` pertama | Objek akar. Ukurannya 360x200 menentukan ukuran dokumen. |
| `Rectangle { id: kartu ... }` | Anak pertama dari `root`. Nama `kartu` hanya untuk merujuk dari tempat lain. |
| `anchors.centerIn: parent` | Letakkan di tengah **induknya**. Pada `kartu`, `parent` adalah `root`; pada `Text`, `parent` adalah `kartu`. |
| `Text { ... }` | Cucu dari `root`, anak dari `kartu`. |
| `'Lebar induk: ' + parent.width` | Ekspresi: menyambung teks dengan angka. Di sini `parent` adalah `kartu`, sehingga hasilnya `Lebar induk: 200`. |
| `Rectangle { ... x: 150; y: 70 }` kedua | Anak kedua dari `root`, saudara dari `kartu`. `x` dan `y` relatif terhadap `root`. |

Amati: kotak merah tampak **di atas** kartu biru, karena dideklarasikan sesudahnya (bagian e).

### d. Mengapa anak cukup ditulis di dalam kurung (default property)

Perhatikan bahwa Anda tidak menulis `children: [...]`. Setiap atribut objek yang bukan penugasan properti, misalnya sebuah objek lain, otomatis diberikan kepada **default property** milik tipe induknya. Pada `Item` (dan karenanya `Rectangle`), default property bernama `data`, sebuah daftar yang menerima **campuran** objek visual dan non-visual:

- objek visual (`Item` dan turunannya) menjadi **anak** (`children`) dan tampil;
- objek lain (mis. `Timer`, `QtObject`) menjadi **sumber daya** (`resources`) dan tidak tampil.

Dua bentuk berikut setara:

```qml
// bentuk ringkas (yang biasa dipakai)
Item {
    Rectangle { width: 10; height: 10 }
    Timer { interval: 1000 }
}

// bentuk eksplisit
Item {
    data: [
        Rectangle { width: 10; height: 10 },
        Timer { interval: 1000 }
    ]
}
```

| Bagian | Arti |
| --- | --- |
| `data: [ ..., ... ]` | Mengisi list default property secara eksplisit; kurung siku dan koma membentuk list. |
| Bentuk ringkas | Qt menaruh tiap objek anak ke `data` secara otomatis. Inilah yang Anda lihat sehari-hari. |
| `Timer` | Objek non-visual; ia masuk `resources`, sehingga hanya bagian visual yang masuk `children`. |

### e. Urutan tumpukan

Anak yang bersaudara digambar menurut **urutan deklarasi**: yang ditulis lebih akhir tampil lebih atas. Properti `z` mengubah urutan itu (nilai lebih besar lebih atas, bawaan 0). Bila dua saudara ber-`z` sama, urutan deklarasi menentukan. Untuk menukar tumpukan, ubah `z` atau urutan penulisan, bukan struktur pohonnya.

### f. Mengapa dua akar dilarang

Coba simpan sebagai `DuaAkar.qml`:

```qml
import QtQuick

Rectangle { width: 100; height: 100; color: 'red' }
Rectangle { width: 100; height: 100; color: 'blue' }
```

```bash
$ qml DuaAkar.qml
```

Engine menolak dokumen itu dengan galat sintaks **\[amati pesannya\]** karena tipe yang didefinisikan berkas harus tunggal (1.1.1-b). Perbaiki dengan membungkusnya dalam satu akar:

```qml
import QtQuick

Row {
    Rectangle { width: 100; height: 100; color: 'red' }
    Rectangle { width: 100; height: 100; color: 'blue' }
}
```

| Bagian | Arti |
| --- | --- |
| `Row { ... }` | Satu akar yang menyusun anak-anaknya mendatar; kini hanya ada satu akar. |
| Dua `Rectangle` | Menjadi anak `Row`, ditata otomatis berdampingan. |

### g. Opsi lain: memilih tipe akar

| Tujuan dokumen | Tipe akar yang lazim | Catatan |
| --- | --- | --- |
| Kotak berwarna atau panel | `Rectangle` | Bentuk visual dengan warna dan batas |
| Wadah tanpa gambar | `Item` | Paling ringan; pilihan umum untuk komponen |
| Jendela aplikasi | `Window`, `ApplicationWindow` | Dimuat lewat engine (0.2.3) |
| Objek non-visual (data, logika) | `QtObject` | Tidak punya `parent` visual |
| Menyusun anak berdampingan | `Row`, `Column`, `Grid`, `Flow` | Fase 5 |
| Komponen dengan bentuk kendali | `Control` dan turunan di Controls | Fase 9 |

### h. Visual

```
  root (Rectangle)                     urutan GAMBAR (bawah ke atas):
   |-- kartu (Rectangle)                 1. root
   |     '-- Text                        2. kartu            (saudara pertama)
   '-- (Rectangle merah)                 3. Text di dalam kartu
                                         4. kotak merah       (saudara kedua, tampil di atas kartu)

  parent dari Text   = kartu
  parent dari kartu  = root
  parent dari root   = (Window / view yang memuatnya)
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Hierarki / pohon objek | Susunan objek bersarang |
| Induk (`parent`) / anak (`child`) / saudara (`sibling`) | Hubungan antarobjek dalam pohon |
| Default property | Properti yang otomatis menerima objek anak (di `Item`: `data`) |
| `data`, `children`, `resources` | Daftar campuran / anak visual / sumber non-visual |
| `z` | Urutan tumpukan (z-order) |
| Objek visual / non-visual | Dapat tampil di layar / tidak |

### j. Tips dan praktik terbaik

- Bila sebuah komponen menjadi kumpulan banyak bagian, jadikan `Item` akarnya; ia paling ringan.
- Hindari pohon yang terlalu dalam; bila lebih dari kira-kira empat tingkat, pertimbangkan memecah ke komponen berkas (1.4).
- Jangan bergantung pada urutan penulisan untuk tampilan yang penting; gunakan `z` secara sengaja dan beri komentar.
- Rujuk induk dengan `id` yang jelas (1.1.4) alih-alih menumpuk `parent.parent`.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Dua objek akar menghasilkan galat | Berkas = satu tipe | Bungkus dalam satu akar |
| Objek tidak tampak sama sekali | `Item` tanpa lebar dan tinggi (bawaan 0) | Beri ukuran, atau jangkarkan (`anchors.fill`) |
| Anak menimpa saudara tak terduga | Urutan deklarasi dan `z` | Atur `z` eksplisit |
| `parent` bernilai `null` di objek non-visual | `QtObject` tidak punya `parent` visual | Rujuk lewat `id` |
| Posisi `x`, `y` “salah” | Dihitung relatif terhadap induk, bukan layar | Periksa siapa induknya |

### l. Hubungan dengan modul lain

Prasyarat untuk 1.1.3 (properti), 1.1.4 (`id` untuk merujuk dalam pohon), Modul 1.4 (komponen), Modul 4.1 dan 4.2 (Item, koordinat, z-order), serta Fase 5 (layout).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Pohon.qml`. (1) Tukar urutan dua anak `root` dan amati perubahan tumpukan; kembalikan, lalu capai efek sama dengan `z: 1`. (2) Tambahkan `Text` di dalam kotak merah dan tulis nilai `parent.width`-nya; prediksi dulu, lalu cocokkan. (3) Buat `DuaAkar.qml`, catat pesan galatnya, lalu perbaiki dengan `Row`.

**Cek pemahaman.** (1) Siapa `parent` dari `Text` di contoh? (2) Mengapa anak cukup ditulis di dalam kurung? (3) Mengapa kotak merah tampak di atas kartu?

### n. Referensi

- [Item (QML Type)](https://doc.qt.io/qt-6/qml-qtquick-item.html) · [Concepts: Visual Parent in Qt Quick](https://doc.qt.io/qt-6/qtquick-visualcanvas-visualparent.html)
- [QML Object Attributes: default properties](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html) · [Rectangle](https://doc.qt.io/qt-6/qml-qtquick-rectangle.html)
- [QML Object Types](https://doc.qt.io/qt-6/qtqml-typesystem-objecttypes.html)

---

## 1.1.3 Properti dasar

*Semangat: setiap properti yang Anda pahami menambah satu kata ke kosakata Anda.*

**Daftar isi 1.1.3:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh: jenis nilai · d. Titik koma, baris baru, dan blok · e. Properti yang paling sering dipakai pada Item · f. Properti grup: titik atau kurung · g. Opsi lain: bentuk penugasan · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Bagian ini mengajarkan cara **menugaskan nilai ke properti yang sudah ada**: bentuk penulisannya, jenis nilai yang boleh, dan properti Item yang paling sering dipakai. (Mendeklarasikan properti **baru**, `readonly`, `required`, dan `alias` dibahas di Modul 1.3; tipenya di Modul 1.2.)

### b. Konsep dan filosofi

- **Properti** adalah atribut bernilai milik sebuah objek: lebar, warna, teks. Bentuk penugasan: `nama: nilai`.
- **Nilai** dapat berupa **literal** (`300`, `'teks'`, `true`, `'#2a9d8f'`) atau **ekspresi** JavaScript (`width / 2`, `parent.width - 20`). Ekspresi yang merujuk properti lain menjadi **binding**: ia dihitung ulang otomatis bila yang dirujuk berubah (0.1.1).
- Nama properti diawali **huruf kecil** (lowerCamelCase), kecuali attached properties (Modul 1.3).
- Sebuah properti punya **tipe**; nilai yang ditugaskan harus cocok atau dapat dikonversi (Modul 1.2).

**Filosofi:** properti adalah **antarmuka objek**. Anda tidak memanggil `setWidth(300)`; Anda menyatakan `width: 300`, dan engine menjaga sisanya, termasuk memberi tahu objek lain bahwa lebar berubah.

### c. Contoh: jenis nilai

Simpan sebagai `Properti.qml`:

```qml
import QtQuick

Rectangle {
    width: 320
    height: width / 2
    color: '#2a9d8f'
    radius: 12
    border.color: 'white'
    border.width: 2
    opacity: 0.9

    Text {
        anchors.centerIn: parent
        text: 'Lebar: ' + parent.width
        color: 'white'
        font { pixelSize: 24; bold: true }
    }
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `width: 320` | Literal angka. |
| `height: width / 2` | Ekspresi (**binding**): tinggi selalu setengah lebar. |
| `color: '#2a9d8f'` | Warna sebagai teks heksadesimal `#rrggbb`. Nama warna seperti `'steelblue'` juga sah. |
| `radius: 12` | Radius sudut dalam piksel. |
| `border.color`, `border.width` | Properti **grup** `border` ditulis dengan notasi titik. |
| `opacity: 0.9` | Keburaman dari 0 sampai 1. |
| `anchors.centerIn: parent` | Properti grup `anchors`, dengan nilai berupa referensi objek. |
| `'Lebar: ' + parent.width` | Ekspresi yang menyambung teks dan angka. |
| `font { pixelSize: 24; bold: true }` | Properti grup `font` dengan notasi kurung; dua penugasan dipisah `;`. |

### d. Titik koma, baris baru, dan blok

- Satu penugasan **per baris** adalah gaya yang disarankan Qt. Bila beberapa penugasan satu baris, pisahkan dengan `;` (mis. `width: 300; height: 200`).
- Ekspresi satu baris tidak memerlukan `return` atau titik koma.
- Ekspresi **bertahap** ditulis sebagai blok `{ ... }` dan **wajib** mengembalikan nilai dengan `return`. Di dalam blok, akhiri tiap pernyataan dengan `;` (konvensi Qt).

Simpan sebagai `Blok.qml`:

```qml
import QtQuick

Rectangle {
    width: 300
    height: 100
    color: 'steelblue'

    Rectangle {
        color: 'white'
        height: parent.height - 20
        width: {
            const sisa = parent.width - 20;
            return sisa / 3;
        }
        x: 10
        y: 10
    }
}
```

| Bagian | Arti |
| --- | --- |
| `width: { ... }` | Blok JavaScript sebagai nilai properti. |
| `const sisa = ...;` | Variabel lokal yang tidak dapat ditugaskan ulang (Fase 2). |
| `return sisa / 3;` | Nilai blok: tanpa `return`, hasilnya tidak terdefinisi. |
| `parent.width - 20` | Merujuk lebar induk, yaitu `Rectangle` luar. |

Blok yang lebih dari beberapa baris sebaiknya menjadi **fungsi** atau dipindah ke berkas `.js` (konvensi Qt; Fase 2).

### e. Properti yang paling sering dipakai pada Item

| Properti | Fungsi | Bawaan |
| --- | --- | --- |
| `x`, `y` | Posisi relatif terhadap induk | 0 |
| `width`, `height` | Ukuran | 0 (untuk `Item`) |
| `z` | Urutan tumpukan | 0 |
| `visible` | Tampil atau tersembunyi | `true` |
| `opacity` | Keburaman 0–1 | 1 |
| `enabled` | Menerima input atau tidak | `true` |
| `rotation`, `scale` | Rotasi dan skala | 0 dan 1 |
| `clip` | Memotong anak yang keluar batas | `false` |
| `anchors.*` | Penjangkaran ke induk atau saudara | tidak ada |

Untuk `Rectangle`: `color` (bawaan putih), `radius`, `border.color`, `border.width`, `gradient`. Untuk `Text`: `text`, `color`, `font`, `wrapMode`, `horizontalAlignment`. Nilai bawaan persis tertera di halaman tiap tipe (0.1.5).

### f. Properti grup: titik atau kurung

```qml
// notasi titik
Text {
    font.bold: true
    font.pixelSize: 20
    font.italic: true
}

// notasi kurung (grup)
Text {
    font { bold: true; pixelSize: 20; italic: true }
}
```

Keduanya setara. Konvensi Qt: bila memakai **beberapa** properti dari satu grup, pertimbangkan notasi kurung bila lebih mudah dibaca; untuk satu properti, notasi titik lebih ringkas.

### g. Opsi lain: bentuk penugasan

| Bentuk | Contoh | Sifat | Dibahas |
| --- | --- | --- | --- |
| Literal | `width: 300` | Nilai tetap | di sini |
| Binding | `height: width / 2` | Mengikuti dependensi secara otomatis | 0.1.1, Fase 3 |
| Blok JavaScript | `width: { ...; return x; }` | Binding kompleks | Fase 2 |
| Penugasan di handler | `onClicked: width = 100` | Imperatif; **memutus** binding yang ada | 0.1.1, Modul 3.1 |
| Elemen `Binding { }` | `Binding { target: x; property: 'width'; value: 10 }` | Binding kondisional yang dapat dinyalakan dan dimatikan | Modul 3.1 |
| `Qt.binding(...)` | `width = Qt.binding(() => parent.width)` | Membuat binding secara imperatif | Modul 3.1 |

### h. Visual

```
  nama : nilai
   |      |
   |      +-- literal    : 300, 'teks', true, '#2a9d8f'
   |      +-- ekspresi   : width / 2, parent.width - 20     <-- BINDING (dijaga engine)
   |      +-- blok       : { ...; return hasil; }
   |
   +-- nama sederhana : width
   +-- grup (titik)   : border.width       +-- grup (kurung): font { pixelSize: 24 }
   +-- attached       : Layout.fillWidth   (Modul 1.3)
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Penugasan | `nama: nilai` pada properti yang ada |
| Literal | Nilai tertulis langsung |
| Ekspresi / binding | Rumus JavaScript yang dihitung ulang otomatis |
| Properti grup | Kumpulan properti berelasi (`font`, `border`, `anchors`) |
| Notasi titik / kurung | Dua cara menulis properti grup |
| `return` | Menyatakan nilai sebuah blok |
| Nilai bawaan | Nilai properti bila tidak ditugaskan |

### j. Tips dan praktik terbaik

- Satu properti per baris; titik koma hanya untuk potongan pendek satu baris.
- Dahulukan binding daripada penugasan imperatif.
- Jangan menulis ukuran piksel di mana-mana; hitung dari induk atau properti lain agar tampilan lentur.
- Beri komentar hanya pada nilai yang “ajaib” (mis. mengapa 20 piksel margin).

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `Cannot assign to non-existent property "colr"` | Salah eja nama properti | Periksa dokumentasi tipe (0.1.5) |
| Galat tipe saat `width: 'lebar'` | Teks ke properti angka | Gunakan tipe yang tepat (1.2) |
| Blok tanpa hasil | Lupa `return` | Tambah `return` |
| Objek tidak tampak | Lebar atau tinggi 0 | Beri ukuran |
| Binding “hilang” setelah klik | Penugasan imperatif memutusnya | Pakai `Binding {}` atau `Qt.binding` (Modul 3.1) |
| Mengira `anchors` sama dengan `x`/`y` | Dua cara berbeda menempatkan | Pilih satu per objek |

### l. Hubungan dengan modul lain

Prasyarat untuk 1.1.4 (referensi lewat `id`), Modul 1.2 (tipe properti), Modul 1.3 (properti baru dan alias), Fase 2 (JavaScript di binding), Fase 3 (binding mendalam), dan Fase 4 (properti visual).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Properti.qml` dan `Blok.qml`. (1) Ubah `width` induk dan amati `height`; (2) tulis ulang `font { ... }` dengan notasi titik; (3) sengaja salah eja `colr` dan catat pesan galat; (4) ganti `width: 320` dengan `width: 'lebar'` dan catat pesannya **\[amati\]**; (5) ubah blok di `Blok.qml` agar lebarnya dua pertiga sisa.

**Cek pemahaman.** (1) Apa bedanya literal dan ekspresi? (2) Mengapa blok harus memakai `return`? (3) Apa fungsi notasi kurung pada properti grup?

### n. Referensi

- [QML Object Attributes: property attributes](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html) · [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html)
- [Item](https://doc.qt.io/qt-6/qml-qtquick-item.html) · [Rectangle](https://doc.qt.io/qt-6/qml-qtquick-rectangle.html) · [Text](https://doc.qt.io/qt-6/qml-qtquick-text.html)
- [QML Coding Conventions: grouped properties](https://doc.qt.io/qt-6/qml-codingconventions.html)

---

## 1.1.4 id dan referensi

*Semangat: memberi nama pada sesuatu adalah awal dari mengendalikannya.*

**Daftar isi 1.1.4:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Aturan penamaan · d. Jangkauan (scope) · e. Contoh: saling merujuk · f. Yang tidak bisa dilakukan `id` · g. Opsi lain merujuk objek · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

`id` memberi nama pada sebuah objek **di dalam satu dokumen** sehingga objek lain dapat membaca dan mengubahnya. Ia adalah perekat paling dasar antarobjek: tanpa `id`, objek hanya bisa merujuk induknya lewat `parent`.

### b. Konsep dan filosofi

- `id` **bukan properti**. Ia adalah penanda khusus di tingkat dokumen: `id: kartu` tidak menciptakan `kartu.id` yang bisa dibaca.
- Nilainya adalah **nama** objek itu, bukan teks; karena itu **tanpa tanda kutip**.
- Satu objek paling banyak punya satu `id`, dan nama itu hanya bermakna di dalam dokumen tempat ia ditulis.

**Filosofi:** `id` adalah alamat lokal. Seperti nomor ruangan di sebuah gedung, ia hanya bermakna di dalam gedung (dokumen) itu. Bila gedung lain perlu tahu, Anda harus secara sengaja membuka akses (lewat properti dan alias, Modul 1.3).

### c. Aturan penamaan

| Aturan | Contoh benar | Contoh salah |
| --- | --- | --- |
| Diawali huruf kecil atau garis bawah | `kartu`, `_kartu` | `Kartu`, `1kartu` |
| Hanya huruf, angka, dan garis bawah | `kotak2`, `tombol_ok` | `tombol-ok`, `tombol ok` |
| Bukan kata cadangan JavaScript | `kontainer` | `var`, `function`, `class` |
| Unik dalam satu dokumen | `kotakA`, `kotakB` | dua objek ber-`id: kotak` |
| Tanpa kutip | `id: kartu` | `id: 'kartu'` |

Konvensi: akar diberi `id: root`; nama lain menggambarkan **peran** (`judul`, `tombolSimpan`), bukan tipe (`rect1`, `text2`).

### d. Jangkauan (scope)

- `id` dapat dipakai di **seluruh dokumen yang sama**: oleh saudara, anak, cucu, handler, dan fungsi di berkas itu.
- `id` dari komponen luar umumnya dapat diakses di dalam komponen bersarang di berkas yang sama (mis. delegate). Pragma `ComponentBehavior: Bound` (1.1.1-d) membuat akses ini aman dan terbaca oleh tooling.
- `id` **tidak** terlihat di dokumen lain, bahkan bila dokumen itu memakai tipe ini sebagai anak atau akar. Untuk membuka sebuah bagian ke luar, gunakan **properti** dan **alias** (Modul 1.3).

### e. Contoh: saling merujuk

Simpan sebagai `Referensi.qml`:

```qml
import QtQuick

Rectangle {
    id: root
    width: 360
    height: 160
    color: '#1e1e2e'

    Rectangle {
        id: kotakA
        width: 100
        height: 100
        x: 20
        y: 30
        color: '#89b4fa'
    }

    Rectangle {
        id: kotakB
        width: kotakA.width / 2
        height: kotakA.height
        x: kotakA.x + kotakA.width + 20
        y: kotakA.y
        color: '#f38ba8'

        Text {
            anchors.centerIn: parent
            text: 'root: ' + root.width
            color: 'white'
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: kotakA.width += 20
    }
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `id: root` | Nama bagi objek akar. |
| `id: kotakA`, `id: kotakB` | Nama bagi dua saudara; keduanya unik. |
| `width: kotakA.width / 2` | `kotakB` merujuk **saudara**-nya lewat `id`. Ini binding: bila `kotakA.width` berubah, lebar `kotakB` ikut berubah. |
| `x: kotakA.x + kotakA.width + 20` | Menempatkan `kotakB` di kanan `kotakA` dengan jarak 20; juga binding. |
| `text: 'root: ' + root.width` | Objek **cucu** merujuk **akar** lewat `id`, tanpa `parent.parent`. |
| `onClicked: kotakA.width += 20` | Handler mengubah properti objek lain lewat `id`. Setiap klik melebarkan `kotakA`, dan `kotakB` mengikuti otomatis. |

Bandingkan dengan `parent`: `parent` selalu menunjuk induk **langsung** dan berubah arti bila struktur pohon diubah. `id` menunjuk objek tertentu, di mana pun ia berada. Konvensi Qt menyarankan merujuk properti induk lewat `id` secara eksplisit agar kode terbaca dan tooling dapat menalarnya.

### f. Yang tidak bisa dilakukan id

- Mengubah `id` setelah objek dibuat, atau menugaskannya secara dinamis.
- Membaca `id` seperti properti (`kartu.id`).
- Merujuk `id` milik dokumen lain.
- Memakai nama yang sama dua kali dalam satu dokumen. Pesan galat tepatnya ada di lab 1.1.7 **\[amati\]**.

### g. Opsi lain merujuk objek

| Cara | Kapan | Catatan |
| --- | --- | --- |
| `id` | Merujuk objek di dokumen yang sama | Paling umum dan jelas |
| `parent` | Hubungan langsung ke induk visual | Rapuh bila struktur berubah |
| `property alias` | Membuka objek anak ke dokumen lain | Modul 1.3 |
| `required property` | Meminta data dari luar komponen | Modul 1.3 dan 1.4 |
| Signal dan handler | Memberi tahu pihak lain tanpa mengenal mereka | Fase 3 (lebih longgar) |
| `objectName` | Dicari dari C++ atau uji | Fase 10 dan 12 |

### h. Visual

```
  Referensi.qml                                   Dokumen lain
  +---------------------------------------+       +-----------------------+
  |  root                                 |       |  Referensi {          |
  |   |-- kotakA   <-- dirujuk kotakB     |       |     // kotakA tidak   |
  |   |-- kotakB   (mengintip kotakA,     |  x    |     // terlihat di    |
  |   |    '-- Text (membaca root)        |       |     // sini           |
  |   '-- MouseArea (mengubah kotakA)     |       |  }                    |
  |  semua id saling terlihat DI SINI     |       +-----------------------+
  +---------------------------------------+      (butuh property / alias, Modul 1.3)
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| `id` | Nama sebuah objek di dalam satu dokumen |
| Scope (cakupan) | Wilayah tempat sebuah nama dikenal |
| Referensi objek | Merujuk objek lain lewat namanya |
| Unqualified access | Memakai nama properti tanpa menyebut objeknya (mis. `width` merujuk objek luar secara implisit); hindari |
| `objectName` | Properti teks bebas untuk mencari objek dari kode |
| Kata cadangan | Kata khusus bahasa yang tidak boleh dipakai sebagai nama |

### j. Tips dan praktik terbaik

- Beri `id` hanya pada objek yang benar-benar dirujuk, dan beri nama sesuai perannya.
- Jadikan `id: root` kebiasaan pada akar setiap komponen.
- Jangan menumpuk `parent.parent.parent`; beri `id` dan rujuk langsung.
- Rujuk properti objek lain dengan `id.properti`, bukan nama yang tidak berkualifikasi.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Galat `id` tidak valid | Diawali huruf besar atau mengandung `-` | Ikuti aturan di bagian c |
| Dua objek dengan `id` yang sama | Salin-tempel | Beri nama unik |
| `ReferenceError: kartu is not defined` | Memakai `id` dari dokumen lain | Buka lewat property dan alias (1.3) |
| `id` berkutip | Mengira `id` itu teks | Tulis tanpa kutip |
| `parent` menunjuk objek yang salah setelah struktur berubah | Mengandalkan `parent` | Pakai `id` |
| Terlalu banyak `id` | Menamai segala objek | Hapus yang tak dirujuk |

### l. Hubungan dengan modul lain

Prasyarat untuk Modul 1.3 (alias membuka `id` ke luar), 1.4 (komponen dan batas `id`), Fase 3 (binding antarobjek), Fase 5 (anchor ke saudara lewat `id`), dan Modul 12.2 (peringatan `qmllint` tentang akses tak berkualifikasi).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Referensi.qml`, klik beberapa kali, dan catat apa yang berubah. Lalu: (1) ubah `root.width` pada `Text` menjadi `parent.parent.width` dan jelaskan mengapa hasilnya sama, dan mengapa `id` lebih baik; (2) tambahkan `kotakC` yang berada di kanan `kotakB` dan lebarnya sama dengan `kotakB`; (3) coba beri dua objek `id` yang sama dan catat pesan galat **\[amati\]**.

**Cek pemahaman.** (1) Mengapa `id` tidak boleh berkutip? (2) Mengapa `kotakA` tidak terlihat dari dokumen lain? (3) Apa risiko merujuk induk dengan `parent`?

### n. Referensi

- [QML Object Attributes: the id attribute](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html) · [Scope and Naming Resolution](https://doc.qt.io/qt-6/qtqml-documents-scope.html)
- [QML Coding Conventions: unqualified access](https://doc.qt.io/qt-6/qml-codingconventions.html) · [Structure of a QML Document](https://doc.qt.io/qt-6/qtqml-documents-structure.html)

---

## 1.1.5 Komentar, qmlformat, dan konvensi penulisan

*Semangat: kode yang rapi menghormati pembacanya, termasuk Anda enam bulan lagi.*

**Daftar isi 1.1.5:** a. Deskripsi dan peran · b. Komentar · c. Konvensi penulisan Qt · d. `qmlformat` · e. `qmllint` · f. Gaya tanda kutip · g. Otomatisasi: hook git · h. Opsi lain · i. Visual · j. Terminologi · k. Tips · l. Kesalahan umum · m. Hubungan · n. Latihan dan cek · o. Referensi

### a. Deskripsi dan peran

Bagian ini adalah kebiasaan yang membuat QML Anda mudah dibaca dan dipelihara: komentar yang tepat, urutan atribut yang seragam, pemformatan otomatis, dan pemeriksaan statis. Dua alat yang ikut Qt, `qmlformat` dan `qmllint`, mengerjakan sebagian besarnya untuk Anda.

### b. Komentar

- `// komentar satu baris` dan `/* komentar beberapa baris */`, seperti JavaScript.
- Komentar yang baik menjelaskan **mengapa**, bukan **apa**: `x: 20` tidak butuh komentar, tetapi “margin 20 sama dengan lebar bayangan” berguna.
- `qmllint` mengenali komentar direktif untuk mematikan peringatan sementara pada bagian tertentu (`// qmllint disable ...` dan `// qmllint enable`); periksa kategori yang tersedia di dokumentasi versi Anda **\[uji dulu\]**. Pakai hemat dan selalu dengan alasan.
- `qmlformat` punya direktif `// qmlformat off` dan `// qmlformat on` untuk melindungi blok yang sengaja dirapikan manual; direktif tidak bersarang dan diabaikan pada mode `--normalize`.

### c. Konvensi penulisan Qt

Dokumen *QML Coding Conventions* Qt merekomendasikan urutan atribut dalam sebuah objek, dipisahkan satu baris kosong:

1. `id`
2. deklarasi properti
3. deklarasi signal
4. fungsi JavaScript
5. properti objek (penugasan nilai)
6. objek anak

Prinsip lain dari dokumen yang sama: kelompokkan properti terkait; gunakan notasi grup bila lebih terbaca; rujuk properti induk lewat `id` (bukan akses tak berkualifikasi); utamakan `required property` untuk data yang dibutuhkan dari luar; beri nama parameter secara eksplisit pada handler signal; beri anotasi tipe pada fungsi; skrip satu ekspresi ditulis di tempat, beberapa baris dalam blok, dan skrip panjang dipindah ke fungsi atau berkas `.js`; dalam blok, akhiri pernyataan dengan titik koma.

Simpan sebagai `Kartu.qml`, contoh yang menerapkannya:

```qml
import QtQuick

Rectangle {
    id: root

    property string judul: 'Kartu'
    property bool terpilih: false

    signal diklik

    function nyalakan() {
        root.terpilih = true;
    }

    width: 220
    height: 90
    radius: 10
    color: root.terpilih ? '#a6e3a1' : '#89b4fa'

    Text {
        anchors.centerIn: parent
        text: root.judul
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.nyalakan();
            root.diklik();
        }
    }
}
```

| Bagian | Arti |
| --- | --- |
| `id: root` | Urutan 1: `id` di baris pertama, mudah ditemukan. |
| `property string judul ...`, `property bool terpilih ...` | Urutan 2: deklarasi properti baru (dibahas di Modul 1.3). |
| `signal diklik` | Urutan 3: deklarasi signal tanpa parameter (Fase 3). |
| `function nyalakan() { ... }` | Urutan 4: fungsi JavaScript; dalam blok, pernyataan diakhiri `;`. |
| `width`, `height`, `radius`, `color` | Urutan 5: properti objek. `color` adalah binding yang bergantung pada `terpilih`. |
| `Text { ... }`, `MouseArea { ... }` | Urutan 6: objek anak. |
| Satu baris kosong antar bagian | Pemisah antarkelompok, sesuai konvensi. |
| `onClicked: { root.nyalakan(); root.diklik(); }` | Blok dua pernyataan; memanggil fungsi dan memancarkan signal. |

### d. qmlformat

`qmlformat` memformat berkas QML menurut konvensi tersebut. Tanpa opsi, hasilnya ditulis ke keluaran standar; berkas asli tidak berubah.

```bash
$ command -v qmlformat qmllint
$ qmlformat Kartu.qml | diff -u Kartu.qml - | head -30
$ qmlformat -i Kartu.qml
$ qmlformat -n -i Kartu.qml
$ git diff --stat
```

| Bagian | Arti |
| --- | --- |
| `command -v qmlformat qmllint` | Pastikan nama executable di mesin Anda (Bagian 4 kurikulum). |
| `qmlformat Kartu.qml \| diff -u Kartu.qml - \| head -30` | Tampilkan **apa yang akan berubah** tanpa mengubah berkas: tanda `-` pada `diff` berarti membaca dari pipa (0.0.4). |
| `-i`, `--inplace` | Ubah berkas di tempat. |
| `-n`, `--normalize` | Urutkan ulang atribut menurut konvensi (mengelompokkan dan mengurutkan properti, fungsi, dan signal berdasarkan nama); bisa mengubah susunan yang sengaja Anda buat. |
| `git diff --stat` | Lihat berkas mana yang berubah; biasakan memformat **sebelum** commit (0.0.6). |

Opsi lain `qmlformat` (menurut dokumentasi Qt):

| Opsi | Fungsi |
| --- | --- |
| `-t`, `--tabs` | Pakai tab, bukan spasi |
| `-w`, `--indent-width <n>` | Lebar indentasi (bawaan 4) |
| `-W`, `--column-width <n>` | Pecah baris yang lebih panjang dari lebar itu (bawaan -1, nonaktif) |
| `--group-attributes-together` | Kelompokkan atribut tanpa mengurutkan; tidak dapat digabung dengan `--normalize` |
| `--objects-spacing`, `--functions-spacing` | Pastikan baris kosong antarobjek atau antarfungsi (bersama `--normalize` atau `--group-attributes-together`) |
| `--single-line-empty-objects` | Tulis objek kosong dalam satu baris |
| `--semicolon-rule always` atau `essential` | Selalu menambah titik koma di ujung pernyataan JS, atau hanya yang perlu |
| `-S`, `--sort-imports` | Urutkan import abjad (dapat mengubah makna bila nama tipe ada di beberapa modul) |
| `-l`, `--newline <jenis>` | Jenis baris baru: `native`, `unix`, `windows`, `macos` |
| `--ignore-settings`, `-F <berkas>`, `-V` | Abaikan berkas pengaturan; format daftar berkas; mode verbose |

Pengaturan yang sama dapat disimpan di berkas pengaturan proyek (cari bagian *Settings File* di dokumentasi `qmlformat` untuk nama dan lokasinya), sehingga seluruh tim memformat sama.

### e. qmllint

`qmllint` menganalisis QML **tanpa menjalankannya** dan melaporkan masalah: salah eja properti, tipe tidak dikenal, import yang tak terpakai, akses tak berkualifikasi, dan sebagainya.

```bash
$ qmllint Kartu.qml
$ qmllint --help | head -30
```

Untuk melihatnya bekerja, simpan sebagai `Tak.qml` dan jalankan `qmllint Tak.qml`:

```qml
import QtQuick

Rectangle {
    property int lebarDasar: 100

    Text { text: lebarDasar }
}
```

| Bagian | Arti |
| --- | --- |
| `Text { text: lebarDasar }` | `Text` memakai `lebarDasar` milik induk **tanpa menyebut objeknya**: *unqualified access*. `qmllint` biasanya memperingatkannya **\[amati pesan dan kategori\]**. |
| Perbaikan | Beri `id: root` pada `Rectangle` dan tulis `root.lebarDasar`. |
| `--help` | Daftar opsi, termasuk jalur import tambahan (mis. `-I`) untuk modul buatan Anda. |

Kebijakan yang disarankan: nol peringatan sebelum commit. Dalam proyek CMake, jalankan `cmake --build build --target all_qmllint` (0.2.7).

### f. Gaya tanda kutip

Contoh resmi Qt memakai kutip **ganda** untuk string; kurikulum ini memakai kutip **tunggal** agar contoh lebih ringkas. Keduanya sah di JavaScript, dan `qmlformat` tidak mengubah jenis kutip. Aturannya: pilih satu gaya per proyek dan konsisten. (Pernyataan `import` pada contoh berkas memakai kutip ganda sesuai dokumentasi.)

### g. Otomatisasi: hook git

Hook `pre-commit` menjalankan pemeriksaan sebelum commit selesai:

```bash
#!/usr/bin/env bash
# .githooks/pre-commit: hentikan commit bila qmllint gagal
set -e
git diff --cached --name-only --diff-filter=ACM -- '*.qml' | xargs -r qmllint
```

```bash
$ mkdir -p .githooks
$ chmod +x .githooks/pre-commit
$ git config core.hooksPath .githooks
```

| Bagian | Arti |
| --- | --- |
| `set -e` | Hentikan skrip pada perintah yang gagal. |
| `git diff --cached --name-only --diff-filter=ACM -- '*.qml'` | Daftar berkas QML yang **sudah di-stage** (A = ditambah, C = disalin, M = diubah). |
| `xargs -r qmllint` | Jalankan `qmllint` pada daftar itu; `-r` berarti jangan jalankan bila daftar kosong (GNU xargs). |
| `git config core.hooksPath .githooks` | Menunjuk git ke folder hook yang ikut di repositori (hook di `.git/hooks` tidak ikut di-commit). |

Periksa kode keluar `qmllint` di versi Anda dan apakah peringatan membuatnya gagal; bila tidak, cek opsi di `qmllint --help` **\[uji dulu\]**.

### h. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Format saat menyimpan | Editor dengan `qmlls` atau perintah eksternal | Konfigurasi editor di Modul 12.2 |
| Format di CI | `qmlformat file \| diff -u file -` yang gagal bila ada selisih | Menjaga seragam tanpa mengubah berkas |
| Lint di CI | Target `all_qmllint` | 0.2.7 |
| IDE | Qt Creator memformat dan menandai peringatan | Opsional |
| Panduan gaya tim | Dokumen `CONTRIBUTING.md` yang menaut konvensi Qt | Hindari mengarang gaya sendiri |

### i. Visual

```
  tulis  -->  qmlformat  -->  qmllint  -->  git diff  -->  commit (0.0.6)
   |             |              |
   |        susun & rapikan   periksa statis (tanpa menjalankan)
   |
   '--- urutan atribut: id | properti | signal | fungsi | properti objek | anak
```

### j. Terminologi

| Istilah | Arti |
| --- | --- |
| Linter | Alat analisis statis (`qmllint`) |
| Formatter | Alat perapi tata letak kode (`qmlformat`) |
| Normalize | Mengurutkan ulang atribut menurut konvensi |
| Unqualified access | Merujuk properti tanpa menyebut objeknya |
| Hook git | Skrip yang dijalankan git pada peristiwa tertentu |
| Diff | Selisih antara dua versi |

### k. Tips dan praktik terbaik

- Format **dulu**, lalu lint, lalu commit; pisahkan commit pemformatan dari commit perubahan isi.
- Biasakan melihat `qmlformat ... | diff` sebelum `-i` pada berkas orang lain.
- Jangan mematikan peringatan `qmllint` tanpa komentar yang menjelaskan alasannya.
- Simpan konfigurasi format di repositori agar semua orang seragam.

### l. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Diff commit penuh perubahan spasi | Memformat sekaligus mengubah isi | Pisahkan commit |
| `-n` mengacak urutan yang disengaja | `--normalize` mengurutkan ulang | Pakai `--group-attributes-together`, atau `// qmlformat off` |
| Peringatan “unqualified” diabaikan | Merasa “jalan juga” | Beri `id` dan rujuk eksplisit |
| Hook tidak jalan | Tidak executable, atau `core.hooksPath` belum diatur | `chmod +x`, atur `core.hooksPath` |
| Campur kutip ganda dan tunggal | Tidak ada kesepakatan | Pilih satu |
| Menyunting berkas yang diformat ulang oleh orang lain | Konfigurasi format berbeda | Satukan lewat berkas pengaturan |

### m. Hubungan dengan modul lain

Prasyarat untuk seluruh kode QML sesudah ini, Modul 0.2.7 (target lint), 1.3 dan 1.4 (urutan atribut pada properti dan komponen), Fase 2 (gaya JavaScript), dan Modul 12.2 (kualitas dan CI).

### n. Latihan dan cek pemahaman

**Latihan 15 menit** (dari kurikulum, dilengkapi). Ubah warna dan teks pada `Kartu.qml`, jalankan `qml Kartu.qml`; lalu jalankan `qmlformat Kartu.qml | diff -u Kartu.qml -`, kemudian `qmlformat -i`, dan `qmllint`. Tambahkan `Tak.qml`, catat peringatannya, dan perbaiki dengan `id`. Terakhir, atur hook `pre-commit` dan buktikan ia menghentikan commit untuk berkas yang bermasalah.

**Cek pemahaman.** (1) Sebutkan urutan atribut menurut konvensi Qt. (2) Apa bedanya `qmlformat` dengan dan tanpa `-i`? (3) Apa yang dilakukan `qmllint`, dan mengapa ia tidak menjalankan kode?

### o. Referensi

- [QML Coding Conventions](https://doc.qt.io/qt-6/qml-codingconventions.html) · [qmlformat](https://doc.qt.io/qt-6/qtqml-tooling-qmlformat.html) · [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html)
- [Git Hooks](https://git-scm.com/docs/githooks) · [git config: core.hooksPath](https://git-scm.com/docs/git-config)
- [xargs](https://www.gnu.org/software/findutils/manual/html_node/find_html/xargs-options.html)

---

## 1.1.6 Konvensi nama berkas

*Semangat: satu nama yang tepat menghemat seribu penjelasan.*

**Daftar isi 1.1.6:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Aturan nama · d. Bagaimana sebuah tipe ditemukan · e. Contoh yang dapat dijalankan · f. Menamai dengan baik · g. Opsi lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Di QML, **nama berkas adalah nama tipe**. Bagian ini menjelaskan aturan penamaan, bagaimana dokumen lain menemukan tipe itu, dan jebakan yang membuat “berkas ada, tetapi tidak dikenali”.

### b. Konsep dan filosofi

Setiap berkas `.qml` mendefinisikan satu tipe; nama tipenya adalah nama berkas tanpa ekstensi. `Kartu.qml` menjadi tipe `Kartu`, dan dokumen lain dapat menulis `Kartu { }`. Filosofinya: **kode yang menyatakan maksud lewat nama**. Anda membaca `Main.qml` sebagai kumpulan istilah domain (`Kartu`, `AppButton`), bukan kumpulan kotak dan teks mentah.

### c. Aturan nama

| Aturan | Alasan |
| --- | --- |
| Diawali **huruf besar** | Nama tipe QML harus berawalan huruf besar agar dapat dipakai sebagai tipe |
| Hanya huruf, angka, garis bawah | Nama tipe harus berupa pengenal yang sah |
| Ekstensi `.qml` | Penanda dokumen QML |
| PascalCase (`DaftarKontak`) | Konvensi Qt dan mudah dibaca |
| Satu tipe per berkas | Konsekuensi satu akar (1.1.1) |
| Nama menggambarkan peran | `TombolSimpan` lebih jelas daripada `Komponen3` |

Berkas berawalan huruf kecil tetap **dokumen QML yang sah**: ia dapat dijalankan langsung (`qml tombol.qml`) atau dimuat lewat URL (mis. `Loader`). Yang tidak bisa adalah memakainya sebagai tipe dengan nama itu di dokumen lain: dokumentasi Qt dan banyak laporan pembelajar menyebut galat seperti “nama tidak dikenali” setelah berkas komponen berawalan huruf kecil.

### d. Bagaimana sebuah tipe ditemukan

Bila dokumen menulis `Nama { }`, engine mencari berurutan:

1. **Direktori yang sama** dengan dokumen (impor implisit): berkas `.qml` di folder itu tersedia tanpa `import`.
2. **Import direktori**: `import "folder"` membuat berkas `.qml` di folder itu tersedia.
3. **Import modul**: tipe terdaftar di sebuah modul (`import QtQuick`, atau modul Anda sendiri lewat `qmldir`; 0.2.4).

Sebuah berkas `qmldir` dapat memetakan nama tipe ke berkas mana pun, termasuk berkas berawalan huruf kecil. Di CMake, properti sumber `QT_QML_SOURCE_TYPE_NAME` melakukan hal serupa (periksa dokumentasi `qt_add_qml_module`).

**Jebakan 0.2.6 yang sama:** `qml Main.qml` membaca folder secara langsung sehingga berkas dalam folder terlihat; aplikasi yang dibangun hanya melihat apa yang didaftarkan ke modul. Berkas yang “jalan di `qml`” belum tentu jalan di aplikasi.

### e. Contoh yang dapat dijalankan

Susun folder berikut di `~/Development/qt-learning/fase1/nama/`:

```
nama/
  Main.qml
  AppButton.qml
  tombol.qml
  widgets/
    Badge.qml
```

```bash
$ mkdir -p ~/Development/qt-learning/fase1/nama/widgets && cd ~/Development/qt-learning/fase1/nama
$ cat > AppButton.qml << 'EOF'
import QtQuick

Rectangle {
    id: root

    property string label: 'Tombol'

    width: 140
    height: 40
    radius: 8
    color: '#89b4fa'

    Text {
        anchors.centerIn: parent
        text: root.label
    }
}
EOF
$ cat > widgets/Badge.qml << 'EOF'
import QtQuick

Rectangle {
    width: 28
    height: 28
    radius: 14
    color: '#f38ba8'
}
EOF
$ cat > tombol.qml << 'EOF'
import QtQuick

Rectangle { width: 100; height: 40; color: 'orange' }
EOF
$ cat > Main.qml << 'EOF'
import QtQuick
import "widgets"

Rectangle {
    width: 320
    height: 120
    color: '#1e1e2e'

    AppButton { x: 20; y: 20; label: 'Simpan' }
    Badge { x: 180; y: 26 }
}
EOF
$ qml Main.qml
$ qml tombol.qml
```

| Bagian | Arti |
| --- | --- |
| `AppButton.qml` | Tipe baru `AppButton`, dengan properti `label`. Namanya diawali `App` agar tidak bentrok dengan `Button` milik Controls. |
| `widgets/Badge.qml` | Tipe `Badge`, tinggal di subfolder. |
| `tombol.qml` | Dokumen sah berawalan huruf kecil; tidak bisa dipakai sebagai tipe `tombol`. |
| `import "widgets"` | **Import direktori**: membuat `Badge` tersedia di `Main.qml`. |
| `AppButton { ... label: 'Simpan' }` | Tipe di folder yang sama, tanpa `import`. |
| `qml tombol.qml` | Menjalankan `tombol.qml` langsung: bukti ia dokumen yang sah. |

**Percobaan** (kembalikan setelah tiap langkah):

1. Hapus `import "widgets"` dan jalankan; catat galat untuk `Badge` **\[amati\]**.
2. Tambahkan baris `tombol { }` di `Main.qml`; catat galatnya **\[amati\]**.
3. Ganti nama `AppButton.qml` menjadi `appButton.qml` dan pakai `appButton { }`; catat hasilnya **\[amati\]**.
4. Buat `Button.qml` lokal, tambah `import QtQuick.Controls` di `Main.qml`, lalu pakai `Button { }`; amati tipe mana yang dipakai dan apakah ada peringatan ambiguitas **\[amati\]**. Itulah mengapa nama tipe sendiri sebaiknya diberi awalan.

### f. Menamai dengan baik

- Beri **awalan proyek** pada tipe sendiri (`AppButton`, `MyAppCard`) agar tidak bentrok dengan tipe Qt (`Button`, `Label`, `Dialog`).
- Gunakan nama domain (`DaftarKontak`) untuk tipe yang menyatakan isi, nama peran (`TombolSimpan`) untuk kendali.
- Hindari nama yang menjelaskan **bentuk** (`BiruBesar`); bentuk berubah, peran tidak.
- Nama berkas JavaScript yang akan dialamatkan sebagai komponen juga berawalan huruf besar (dokumentasi `qt_add_qml_module`).

### g. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Tipe dalam folder yang sama | Impor implisit | Paling sederhana |
| Tipe di folder lain | `import "folder"` | Cepat untuk proyek kecil |
| Tipe dipakai banyak aplikasi | Modul dengan `qmldir` | Fase 8 dan 0.2.4 |
| Nama berkas berbeda dari nama tipe | `qmldir` atau `QT_QML_SOURCE_TYPE_NAME` | Hanya bila terpaksa |
| Tipe kecil dalam satu berkas | Komponen inline (`component Nama: Item { ... }`) | Modul 1.4 |
| Memuat berkas dinamis | `Loader { source: 'tombol.qml' }` | Fase 5 dan 8 |
| Varian per platform | File selector (`+android/Main.qml` dan sejenisnya) | Fase 13 |
| Berkas formulir desain | `.ui.qml` (Qt Creator dan Qt Design Studio) | Format khusus; baca dokumentasi alat itu bila memakainya |

### h. Visual

```
  Main.qml menulis:  Badge { }
        |
        v
  [1] folder yang sama punya Badge.qml?          --tidak-->
  [2] ada  import "widgets"  yang berisi Badge.qml? --ya--> DITEMUKAN: widgets/Badge.qml
  [3] modul yang diimpor mendaftarkan Badge?     --tidak-->  galat: "Badge is not a type"

  nama berkas  =  nama tipe     Badge.qml  -->  Badge { }
  badge.qml (huruf kecil)       dokumen sah, tapi BUKAN tipe "badge"
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Tipe (QML type) | Jenis objek yang dapat diciptakan; di sini, hasil sebuah berkas |
| PascalCase | Setiap kata diawali huruf besar tanpa pemisah |
| Impor implisit | Berkas satu folder saling terlihat tanpa `import` |
| Import direktori | `import "folder"` |
| `qmldir` | Berkas definisi modul yang memetakan nama tipe ke berkas |
| Komponen inline | Tipe kecil yang didefinisikan di dalam berkas lain |
| Awalan proyek | Imbuhan nama untuk menghindari bentrok |

### j. Tips dan praktik terbaik

- Nama berkas menjadi API; pilihlah sekali dengan matang, lalu pakai konsisten.
- Satu folder untuk satu kelompok komponen yang berkaitan (`widgets/`, `pages/`).
- Bila proyek tumbuh, pindahkan folder ke modul (Fase 8) alih-alih menumpuk import direktori.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `X is not a type` untuk berkas yang ada | Berawalan huruf kecil, atau folder berbeda tanpa import | Ganti nama jadi huruf besar; tambah `import "folder"` |
| Jalan di `qml`, gagal di aplikasi | Berkas belum didaftarkan ke modul | Daftarkan di `QML_FILES` (0.2.6) |
| Tipe sendiri “menimpa” tipe Qt | Nama sama (`Button`) | Beri awalan proyek |
| Spasi atau tanda minus di nama berkas | Bukan pengenal yang sah | Ganti dengan PascalCase |
| Dua tipe dengan nama sama dari folder berbeda | Import ambigu | Beri namespace `as` atau ganti nama |

### l. Hubungan dengan modul lain

Prasyarat untuk Modul 1.4 (komponen dan reuse), 0.2.6 (mendaftarkan berkas), Fase 8 (modul QML dan `qmldir`), dan Fase 9 (kendali kustom).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Susun folder di bagian e, jalankan `Main.qml` dan `tombol.qml`, lakukan empat percobaan, dan catat semua pesan di `galat.md` (1.1.7).

**Cek pemahaman.** (1) Apa yang terjadi bila file bernama `button.qml`, dan apa yang tetap bisa dilakukan dengannya? (2) Apa tiga cara sebuah tipe ditemukan? (3) Mengapa tipe sendiri perlu awalan proyek?

### n. Referensi

- [Defining Object Types through QML Documents](https://doc.qt.io/qt-6/qtqml-documents-definetypes.html) · [QML Object Types](https://doc.qt.io/qt-6/qtqml-typesystem-objecttypes.html)
- [Module Definition qmldir Files](https://doc.qt.io/qt-6/qtqml-modules-qmldir.html) · [Import Statements (directory imports)](https://doc.qt.io/qt-6/qtqml-syntax-imports.html)
- [qt\_add\_qml\_module](https://doc.qt.io/qt-6/qt-add-qml-module.html) · [QQmlFileSelector](https://doc.qt.io/qt-6/qqmlfileselector.html)

---

## 1.1.7 Lab merusak dokumen dan kamus galat \[TAMBAHAN\]

**Mengapa ditambahkan:** pesan galat nyata berbeda antar versi Qt, dan menghafalnya rapuh. Yang kokoh adalah **kebiasaan memproduksi, membaca, dan mencatat** pesan galat Anda sendiri, dengan cara yang sama seperti 0.0.7 dan 0.3.6. Lab ini menghasilkan kamus galat pribadi untuk versi Qt yang Anda pakai.

*Semangat: pesan galat yang sudah pernah Anda sengaja timbulkan tidak akan lagi menakutkan.*

**Daftar isi 1.1.7:** a. Deskripsi dan peran · b. Empat kelas galat · c. Membuat berkas rusak · d. Menjalankan dan mencatat · e. Membandingkan dengan `qmllint` · f. Kamus galat pribadi · g. Opsi lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Sebagian besar waktu Anda di Fase 1 akan dihabiskan membaca pesan galat sintaks dan pemuatan. Lab ini mempercepat itu: sepuluh kerusakan yang paling umum, masing-masing dijalankan, dicatat, dan diklasifikasi menurut tahap kegagalannya.

### b. Empat kelas galat

| Kelas | Kapan terjadi | Gejala khas | Contoh |
| --- | --- | --- | --- |
| 1. Sintaks (*parse*) | Saat berkas dibaca | Dokumen tidak dimuat sama sekali | Kurung hilang, dua akar |
| 2. Pemuatan tipe dan import | Saat engine menyelesaikan nama | `X is not a type`, modul tidak ditemukan | Tanpa import, nama modul salah |
| 3. Penugasan dan pembuatan objek | Saat objek dibuat | Properti tidak ada, tipe tidak cocok, `id` tidak valid | `colr`, `width: 'lebar'`, `id: Kotak` |
| 4. Runtime | Saat aplikasi sudah berjalan | Peringatan, aplikasi tetap jalan | `ReferenceError` pada binding |

Penting: galat kelas 1 hingga 3 umumnya mencegah dokumen tampil; kelas 4 sering **tidak** menghentikan aplikasi sehingga mudah terlewat.

### c. Membuat berkas rusak

Simpan sebagai `buat-lab.sh` di `~/Development/qt-learning/fase1/`, lalu `bash buat-lab.sh`:

```bash
#!/usr/bin/env bash
set -eu
mkdir -p lab-galat
cd lab-galat

cat > e01-dua-akar.qml << 'EOF'
import QtQuick

Rectangle { width: 100; height: 100; color: 'red' }
Rectangle { width: 100; height: 100; color: 'blue' }
EOF

cat > e02-tanpa-import.qml << 'EOF'
Rectangle { width: 100; height: 100; color: 'red' }
EOF

cat > e03-properti-salah.qml << 'EOF'
import QtQuick

Rectangle { width: 100; height: 100; colr: 'red' }
EOF

cat > e04-tipe-salah.qml << 'EOF'
import QtQuick

Rectangle { width: 'lebar'; height: 100; color: 'red' }
EOF

cat > e05-kurung-hilang.qml << 'EOF'
import QtQuick

Rectangle {
    width: 100
    height: 100
    Rectangle { width: 10; height: 10 }
EOF

cat > e06-id-besar.qml << 'EOF'
import QtQuick

Rectangle { id: Kotak; width: 100; height: 100 }
EOF

cat > e07-id-ganda.qml << 'EOF'
import QtQuick

Item {
    Rectangle { id: kotak; width: 50; height: 50 }
    Rectangle { id: kotak; width: 50; height: 50; x: 60 }
}
EOF

cat > e08-referensi-hilang.qml << 'EOF'
import QtQuick

Text { text: 'lebar: ' + tidakAda.width }
EOF

cat > e09-modul-salah.qml << 'EOF'
import QtQuik

Rectangle { width: 100; height: 100 }
EOF

cat > e10-pragma-bawah.qml << 'EOF'
import QtQuick
pragma ComponentBehavior: Bound

Rectangle { width: 100; height: 100 }
EOF

echo 'lab-galat/ dibuat: sepuluh berkas rusak'
```

| Berkas | Kerusakan | Dugaan kelas |
| --- | --- | --- |
| `e01-dua-akar` | Dua objek akar | 1 (sintaks) |
| `e02-tanpa-import` | Tidak ada `import QtQuick` | 2 (tipe) |
| `e03-properti-salah` | `colr` bukan properti | 3 |
| `e04-tipe-salah` | Teks pada properti angka | 3 |
| `e05-kurung-hilang` | Kurung kurawal penutup hilang | 1 |
| `e06-id-besar` | `id` berawalan huruf besar | 3 |
| `e07-id-ganda` | Dua `id` sama | 3 |
| `e08-referensi-hilang` | Merujuk `id` yang tidak ada | 4 (runtime) |
| `e09-modul-salah` | `QtQuik` | 2 |
| `e10-pragma-bawah` | Pragma ditulis setelah import | belum diketahui **\[amati\]** |

Kolom “dugaan” adalah hipotesis Anda untuk diuji, bukan jawaban. Salah menduga adalah bagian dari pelajaran.

### d. Menjalankan dan mencatat

Simpan sebagai `jalankan-lab.sh`:

```bash
#!/usr/bin/env bash
# jalankan tiap berkas rusak, simpan log, ringkas hasilnya
cd lab-galat || exit 1
mkdir -p log
for f in e*.qml; do
    timeout 3 qml "$f" &> "log/$f.log"
    kode=$?
    printf '%-26s exit=%s\n' "$f" "$kode"
    head -n 2 "log/$f.log" | sed 's/^/    /'
done
```

```bash
$ bash jalankan-lab.sh
```

| Bagian | Arti |
| --- | --- |
| `cd lab-galat \|\| exit 1` | Masuk ke folder lab; bila gagal, hentikan skrip. |
| `for f in e*.qml; do ... done` | Ulangi untuk tiap berkas berawalan `e` berekstensi `.qml`. |
| `timeout 3 qml "$f" &> "log/$f.log"` | Jalankan maksimal 3 detik dan simpan seluruh keluaran ke log berkas itu (0.0.4, 0.3.1). |
| `kode=$?` | Tangkap exit code segera. |
| `printf '%-26s exit=%s\n'` | Cetak nama dan exit code dalam kolom rapi. |
| `head -n 2 ... \| sed 's/^/    /'` | Tampilkan dua baris pertama log, diberi indentasi empat spasi. |

**Membaca exit code** (0.3.6): `124` berarti aplikasi **bertahan** sampai `timeout` membunuhnya; kode lain berarti `qml` berhenti sendiri, biasanya karena galat. Catat nilai tepatnya untuk tiap berkas **\[amati\]**.

### e. Membandingkan dengan qmllint

```bash
$ for f in lab-galat/e*.qml; do echo "== $f"; qmllint "$f" 2>&1 | head -n 3; done
```

Untuk tiap berkas catat: apakah `qmllint` menangkapnya **sebelum** dijalankan? Perkiraan yang dapat Anda uji: kelas 1 hingga 3 umumnya tertangkap statis, dan sebagian kelas 4 (referensi tak dikenal) juga. Berkas yang lolos lint tetapi gagal saat jalan (atau sebaliknya) adalah temuan penting tentang batas analisis statis **\[amati\]**.

### f. Kamus galat pribadi

Simpan sebagai `galat.md` di repositori belajar dan isi dari hasil lab Anda:

```markdown
| Berkas | Kerusakan | Kelas | Pesan pertama (salin utuh) | Exit | Tertangkap qmllint? | Perbaikan |
| --- | --- | --- | --- | --- | --- | --- |
| e01 | dua akar | ? | ... | ? | ? | bungkus dalam satu akar |
```

Tambahkan baris baru **setiap kali Anda bertemu galat baru** sepanjang kurikulum. Dalam beberapa bulan, ia menjadi referensi paling berharga milik Anda, karena ia berisi pesan dari versi Qt dan lingkungan **Anda**.

### g. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Uji otomatis pesan galat | Skrip di atas dijalankan di CI | Mendeteksi perubahan pesan antar versi Qt |
| Menangkap galat dari kode | `QQmlEngine::warnings` dan message handler | Fase 10 dan 12.1 |
| Menyalakan log lebih rinci | `QT_LOGGING_RULES` | 0.3.5 |
| Melihat sumber pesan | Cari teks pesan di dokumentasi dan sumber Qt | 0.1.5 |
| Berbagi kamus | Sertakan di README proyek | Membantu rekan baru |

### h. Visual

```
  dokumen QML
      |
   [1 sintaks]   gagal --> dokumen tidak dibaca          (kurung, dua akar)
      |
   [2 tipe/import] gagal --> "X is not a type", modul tak ada
      |
   [3 buat objek] gagal --> properti tak ada, tipe salah, id tak valid
      |
   [4 runtime]   peringatan --> aplikasi JALAN terus     (ReferenceError di binding)
      |
   tampil

   qmllint menyorot sebagian [1..4] SEBELUM Anda menjalankan
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Parse error | Galat saat membaca sintaks |
| Type resolution | Pencocokan nama tipe ke definisinya lewat import |
| Runtime warning | Peringatan saat aplikasi sudah berjalan |
| Analisis statis | Pemeriksaan tanpa menjalankan (`qmllint`) |
| Kamus galat | Catatan pribadi pesan galat beserta penyebab dan perbaikan |
| Reproduksi sengaja | Memunculkan galat dengan sengaja untuk dipelajari |

### j. Tips dan praktik terbaik

- Satu kerusakan per berkas, supaya sebabnya jelas.
- Salin pesan **utuh**, jangan diringkas; pencarian dokumentasi membutuhkan kata persis.
- Ulangi lab setelah memperbarui Qt dan bandingkan hasilnya dengan `diff`.
- Jangan menghapus berkas lab; ia bahan uji regresi pesan.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Semua berkas keluar dengan 124 | `qml` membuka jendela dan bertahan | Itu normal untuk berkas sah; cek log untuk galat kelas 4 |
| Log kosong | Berkas lolos tanpa pesan | Tambahkan `QT_LOGGING_RULES` atau periksa kelas 4 |
| Pesan berbeda dari dugaan | Dugaan hanya hipotesis | Catat pesan sebenarnya |
| Skrip berhenti di tengah | `set -eu` menangkap variabel atau perintah gagal | Baca pesan skrip, perbaiki |

### l. Hubungan dengan modul lain

Prasyarat untuk Modul 1.2 sampai 1.4 (setiap kesalahan baru dicatat di `galat.md`), Fase 2 (galat JavaScript), Fase 3 (galat binding), dan Modul 12.2 (menjadikan `qmllint` bagian CI).

### m. Latihan dan cek pemahaman

**Latihan 30 menit.** Buat dan jalankan lab, isi `galat.md` untuk sepuluh berkas, jalankan `qmllint` pada tiap berkas, dan tandai mana yang tertangkap statis. Commit `buat-lab.sh`, `jalankan-lab.sh`, dan `galat.md`; tambahkan `lab-galat/log/` ke `.gitignore`.

**Cek pemahaman.** (1) Apa empat kelas galat dan mana yang tidak menghentikan aplikasi? (2) Mengapa menyalin pesan galat utuh lebih baik daripada meringkas? (3) Apa batas analisis statis menurut hasil lab Anda?

### n. Referensi

- [Debugging QML Applications](https://doc.qt.io/qt-6/qtquick-debugging.html) · [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html)
- [Bash: Looping Constructs](https://www.gnu.org/software/bash/manual/html_node/Looping-Constructs.html) · [sed](https://www.gnu.org/software/sed/manual/sed.html)
- [Arch Wiki: General troubleshooting](https://wiki.archlinux.org/title/General_troubleshooting)

---

## 3.7 Penutup Modul 1.1

**Daftar isi bagian ini:** 3.7.1 Peta konsep · 3.7.2 Latihan terpadu · 3.7.3 Cek pemahaman modul · 3.7.4 Hubungan ke modul berikutnya · 3.7.5 Pembaruan yang diusulkan untuk kurikulum · 3.7.6 Status dan langkah berikutnya

### 3.7.1 Peta konsep

```
   1.1.1 Struktur dokumen: pragma | import | satu akar
        |
   1.1.2 Objek dan hierarki (default property, z-order)
        |
   1.1.3 Properti dasar: nama: nilai (literal, ekspresi, grup)
        |
   1.1.4 id dan referensi (scope di dalam satu dokumen)
        |
   1.1.5 Komentar, qmlformat, qmllint, konvensi
        |
   1.1.6 Nama berkas = nama tipe
        |
   1.1.7 Lab galat --> galat.md (kamus pribadi)
        |
        v
   Modul 1.2 (tipe data) ...
```

### 3.7.2 Latihan terpadu

Di folder `~/Development/qt-learning/fase1/terpadu/` (30–45 menit), tanpa menyalin: (1) buat `Main.qml` dengan satu akar, `id: root`, dan dua anak; (2) buat `AppButton.qml` (dengan properti `label`) dan `widgets/Badge.qml`, dipakai lewat impor implisit dan `import "widgets"`; (3) susun atribut menurut konvensi Qt; (4) jalankan `qmlformat`, `qmllint`, dan `qml Main.qml`; (5) sengaja timbulkan tiga galat dari lab 1.1.7 dan catat di `galat.md`; (6) commit dengan pesan bermakna dan pastikan `git status` bersih.

### 3.7.3 Cek pemahaman modul

1. Apa tiga bagian dokumen QML dan urutannya? Mengapa hanya satu akar?
2. Apa bedanya import modul, direktori, dan JavaScript? Apa efek `as`?
3. Sebutkan dua pragma beserta fungsinya, dan versi Qt awalnya.
4. Mengapa anak objek cukup ditulis di dalam kurung? Sebut nama default property pada `Item`.
5. Apa bedanya literal dan ekspresi? Kapan blok `{ }` perlu `return`?
6. Tulis tiga aturan penamaan `id`, dan jelaskan mengapa `id` tidak terlihat di dokumen lain.
7. Sebutkan urutan atribut menurut konvensi Qt.
8. Apa yang dilakukan `qmlformat -i`, `qmlformat -n -i`, dan `qmllint`?
9. Apa yang terjadi bila file bernama `button.qml`, dan jalan keluar apa yang ada?
10. Sebutkan empat kelas galat dan satu contoh masing-masing.

### 3.7.4 Hubungan ke modul berikutnya

| Modul | Mengandalkan dari 1.1 |
| --- | --- |
| 1.2 Tipe data | Penugasan properti dan jenis nilai (1.1.3); kamus galat untuk galat tipe (1.1.7) |
| 1.3 Properti, alias, atribut | Deklarasi di atas penugasan (1.1.5), batas `id` (1.1.4) |
| 1.4 Komponen dan reuse | Nama berkas dan pencarian tipe (1.1.6), akar tunggal (1.1.1) |
| Fase 2 JavaScript | Ekspresi dan blok (1.1.3), import berkas `.js` (1.1.1) |
| Fase 3 Reaktivitas | Binding dan referensi `id` (1.1.3, 1.1.4) |
| Fase 8 Modul | Import, jalur impor, `qmldir` (1.1.1, 1.1.6) |
| Modul 12.2 Kualitas | `qmlformat`, `qmllint`, hook git (1.1.5) |

### 3.7.5 Pembaruan yang diusulkan untuk kurikulum

Tempelkan ke README Anda sebagai pengganti atau tambahan pada Modul 1.1.

```markdown
**Daftar isi.** 1.1.1 Struktur dokumen: pragma, import, root · 1.1.2 Objek dan hierarki · 1.1.3 Properti dasar · 1.1.4 `id` dan referensi · 1.1.5 Komentar, `qmlformat`, dan konvensi penulisan · 1.1.6 Konvensi nama berkas · 1.1.7 Lab merusak dokumen dan kamus galat

**Terminologi (tambahan).** Pragma (arahan engine, ditulis sebelum import; contoh: `Singleton` sejak 5.2, `ComponentBehavior` sejak 6.4); tiga jenis import (modul, direktori, JavaScript) dan `as` untuk namespace lokal; default property (pada `Item`: `data`); unqualified access (merujuk properti tanpa menyebut objeknya); urutan atribut Qt (id, properti, signal, fungsi, properti objek, objek anak).

**Kesalahan umum (tambahan).** Pragma setelah import; import `as` lalu memakai tipe tanpa awalan; `id` berawalan huruf besar atau berkutip; merujuk `id` dari dokumen lain; mengira berkas yang jalan di `qml` pasti jalan di aplikasi (berkas belum terdaftar ke modul); tipe sendiri bernama sama dengan tipe Qt (`Button`).

**Cek pemahaman (jawaban lebih presisi, no. 1).** Berkas `button.qml` tetap dokumen QML yang sah (dapat dijalankan dengan `qml button.qml`), tetapi tidak dapat dipakai sebagai tipe `button` karena nama tipe harus berawalan huruf besar; ganti nama menjadi berawalan huruf besar (mis. `AppButton.qml`), atau petakan lewat `qmldir` atau `QT_QML_SOURCE_TYPE_NAME`.

**Gaya penulisan.** Contoh resmi Qt memakai kutip ganda; kurikulum ini memakai kutip tunggal. Pilih satu gaya dan konsisten.

**Referensi (tambahan).** [Structure of a QML Document](https://doc.qt.io/qt-6/qtqml-documents-structure.html) · [Import Statements](https://doc.qt.io/qt-6/qtqml-syntax-imports.html) · [QML Coding Conventions](https://doc.qt.io/qt-6/qml-codingconventions.html) · [qmlformat](https://doc.qt.io/qt-6/qtqml-tooling-qmlformat.html)

**Estimasi.** Fase 1 secara keseluruhan: Jalur A sekitar 3 minggu.
```

### 3.7.6 Status dan langkah berikutnya

| Bagian | Status |
| --- | --- |
| Audit Fase 1 dan Modul 1.1 | Selesai |
| Fase 1 (tingkat fase) | Selesai |
| Modul 1.1 (1.1.1–1.1.7) | **Selesai** |
| Modul 1.2 — Tipe Data dan Sistem Tipe | Berikutnya, menunggu konfirmasi |
| Modul 1.3 — Properti, Alias, dan Atribut Objek | Setelah 1.2 |
| Modul 1.4 — Komponen dan Reuse | Setelah 1.3 |

---

> - **[⬆️ Ke Atas](#)**
> - **[➡️ Selanjutnya][selanjutnya]**
> - **[⬅️ Sebelumnya][sebelumnya]**
> - **[📚 Kurikulum][kurikulum]**
> - **[🏠 Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

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

