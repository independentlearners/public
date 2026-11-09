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

| Berkas | Kerusakan | Kelas | Pesan pertama (salin utuh) | Exit | Tertangkap qmllint? | Perbaikan |
| --- | --- | --- | --- | --- | --- | --- |
| e01 | dua akar | ? | ... | ? | ? | bungkus dalam satu akar |

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

**Daftar isi.** 1.1.1 Struktur dokumen: pragma, import, root · 1.1.2 Objek dan hierarki · 1.1.3 Properti dasar · 1.1.4 `id` dan referensi · 1.1.5 Komentar, `qmlformat`, dan konvensi penulisan · 1.1.6 Konvensi nama berkas · 1.1.7 Lab merusak dokumen dan kamus galat

**Terminologi (tambahan).** Pragma (arahan engine, ditulis sebelum import; contoh: `Singleton` sejak 5.2, `ComponentBehavior` sejak 6.4); tiga jenis import (modul, direktori, JavaScript) dan `as` untuk namespace lokal; default property (pada `Item`: `data`); unqualified access (merujuk properti tanpa menyebut objeknya); urutan atribut Qt (id, properti, signal, fungsi, properti objek, objek anak).

**Kesalahan umum (tambahan).** Pragma setelah import; import `as` lalu memakai tipe tanpa awalan; `id` berawalan huruf besar atau berkutip; merujuk `id` dari dokumen lain; mengira berkas yang jalan di `qml` pasti jalan di aplikasi (berkas belum terdaftar ke modul); tipe sendiri bernama sama dengan tipe Qt (`Button`).

**Cek pemahaman (jawaban lebih presisi, no. 1).** Berkas `button.qml` tetap dokumen QML yang sah (dapat dijalankan dengan `qml button.qml`), tetapi tidak dapat dipakai sebagai tipe `button` karena nama tipe harus berawalan huruf besar; ganti nama menjadi berawalan huruf besar (mis. `AppButton.qml`), atau petakan lewat `qmldir` atau `QT_QML_SOURCE_TYPE_NAME`.

**Gaya penulisan.** Contoh resmi Qt memakai kutip ganda; kurikulum ini memakai kutip tunggal. Pilih satu gaya dan konsisten.

**Referensi (tambahan).** [Structure of a QML Document](https://doc.qt.io/qt-6/qtqml-documents-structure.html) · [Import Statements](https://doc.qt.io/qt-6/qtqml-syntax-imports.html) · [QML Coding Conventions](https://doc.qt.io/qt-6/qml-codingconventions.html) · [qmlformat](https://doc.qt.io/qt-6/qtqml-tooling-qmlformat.html)

**Estimasi.** Fase 1 secara keseluruhan: Jalur A sekitar 3 minggu.

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

## 4. Modul 1.2 — Tipe Data dan Sistem Tipe

**Daftar isi bagian ini:** 4.1 Audit Modul 1.2 · 4.2 Deskripsi dan peran · 4.3 Filosofi modul · 4.4 Visual: peta tipe · 4.5 Estimasi waktu · lalu 1.2.1 sampai 1.2.8 · 4.6 Penutup Modul 1.2

### 4.1 Audit Modul 1.2

Diperiksa pada 7 November 2026 terhadap dokumentasi Qt (*QML Value Types*, *QML Object Attributes*, *Data Type Conversion Between QML and C++*, *QML Enumerations*, *Structure of a QML Document*). Kurikulum Modul 1.2 saya baca ulang sebelum audit ini.

**Terverifikasi (tidak perlu diubah):**

- **Tidak ada tipe `time`.** Konversi `QTime` ke JavaScript menghasilkan `Date`; karena `QTime` tidak punya komponen tanggal, tanggalnya dibuat hanya untuk konversi dan **tidak boleh diandalkan**. Sebaliknya, `Date` ke `QTime` dilakukan lewat `QDateTime` dalam waktu lokal.
- **`QDate` dan `Date` dipetakan lewat awal hari dalam UTC.** String tanggal-saja di JavaScript (`'2026-11-07'`) ditafsirkan sebagai awal hari **UTC**, sedangkan `new Date(2026, 10, 7)` memakai awal hari **lokal**. Di zona di belakang UTC, hasilnya bisa mundur satu hari. Dokumentasi menyarankan getter UTC atau memakai properti `QDateTime`.
- **Bulan JavaScript 0–11, Qt 1–12.**
- **Array-like dari `QVariantList`:** `Array.isArray()` bernilai `false`, tetapi objeknya menyediakan metode array umum dan menyinkronkan `length` otomatis. Sejak Qt 6.5 properti `QVariantList` dapat diubah di tempat dari QML; sejak 6.9 juga `QVariantMap`.
- **`enumeration` tidak bisa dipakai sebagai tipe properti**; nilai enum adalah bilangan bulat dan disimpan sebagai `int`.
- **Tipe properti ditegakkan.** Menugaskan nilai bertipe salah saat inisialisasi menghasilkan galat dan objeknya tidak dimuat; salah tipe saat runtime membuat nilai baru tidak ditugaskan beserta galat.
- Kelas GUI Qt (`QColor`, `QFont`, `QQuaternion`, `QMatrix4x4`) hanya tersedia di QML bila `QtQuick` diimpor.

**Perlu dikoreksi atau dilengkapi:**

1. **Nama istilah dan tautan.** Mulai Qt 6.6/6.7, halaman *QML Basic Types* menjadi *QML Value Types* (`qtqml-typesystem-valuetypes.html`) dan istilah “basic type” menjadi “value type”. Tautan referensi kurikulum (`...basictypes.html`) sebaiknya diganti.
2. **Tabel tipe belum lengkap.** Belum ada `easingCurve` (tipe nilai dari QtQml, berguna untuk animasi), `variant` (generik lama; pakai `var`), dan `void`. Perlu kolom penyedia: `date`, `string`, `url`, `var`, dan sebagainya disediakan bahasa; `point`, `rect`, `size`, `easingCurve` dari QtQml; `color`, `font`, `vector2d/3d/4d`, `matrix4x4`, `quaternion` dari QtQuick (perlu `import QtQuick`).
3. **Tiga kelompok tipe tak punya sub-bagian:** `url`, `font`, dan tipe matematika (vektor, matriks, kuaternion). Daftar isi diperluas (`url` ke 1.2.1, `font` ke 1.2.2) dan 1.2.7 ditambahkan.
4. **`list<T>`.** Contoh kurikulum (`list<Item>`) benar. Dokumentasi *Object Attributes* menyebut `list` untuk **tipe objek** dan menyarankan `var` untuk nilai bebas; dokumentasi *Value Types* terbaru menyebut elemen dapat berupa tipe objek atau tipe nilai. Karena dokumen berbeda, uji sendiri `property list<int>` pada versi Anda **\[uji dulu\]**.
5. **Jebakan konversi perlu dilengkapi:** string tanggal-saja = UTC; pembagian selalu riil di JavaScript (`5 / 2` adalah `2.5`); perbandingan `real` dengan toleransi; `'5' + 3` menghasilkan `'53'`; teks tidak otomatis menjadi angka pada properti `int`.
6. **Tidak ada bagian tentang menegakkan tipe.** Sejak Qt 6.7, anotasi tipe pada fungsi **ditegakkan** oleh interpreter dan JIT, dan pragma `FunctionSignatureBehavior` serta `ValueTypeBehavior` (nilai `Assertable` sejak 6.8) mengaturnya. Ditambahkan sebagai 1.2.8.
7. **Jawaban cek pemahaman.** (1) Pengganti `time`: tipe `date` (JavaScript `Date`) dengan memakai komponen jam-menitnya, atau `int` detik sejak tengah malam bila hanya durasi. (2) Properti terketik lebih baik karena kesalahan tertangkap dini (galat saat nilai salah), tooling (`qmllint`, `qmlls`) dapat menalar, dan kompiler QML dapat menghasilkan kode lebih efisien.
8. **`typeof` pada tipe nilai** (`color`, `point`, `url`) tidak selalu bernilai seperti dugaan; hasilnya diamati di lab, bukan dihafal.

**Daftar isi Modul 1.2 yang diperbarui:**

| No. | Judul | Asal |
| --- | --- | --- |
| 1.2.1 | Primitif dan `url` | Asli 1.2.1, diperluas |
| 1.2.2 | Geometri, warna, dan font | Asli 1.2.2, diperluas |
| 1.2.3 | `date` dan konversi `QDate`/`QTime` | Asli 1.2.3 |
| 1.2.4 | `list` dan `var` | Asli 1.2.4 |
| 1.2.5 | Enum | Asli 1.2.5 |
| 1.2.6 | Konversi dan jebakan | Asli 1.2.6, diperluas |
| 1.2.7 | Vektor, matriks, dan kuaternion | **\[TAMBAHAN\]** |
| 1.2.8 | Memeriksa dan menegakkan tipe | **\[TAMBAHAN\]** |

### 4.2 Deskripsi dan peran dalam kurikulum

Modul ini mengajarkan tipe-tipe nilai yang dapat dipegang sebuah properti, bagaimana memilih yang tepat, dan bagaimana engine mengonversi antartipe. Pemilihan tipe adalah keputusan desain yang menentukan: seberapa banyak kesalahan ditangkap sebelum aplikasi dijalankan, seberapa cepat kode berjalan, dan seberapa mudah Anda menjembatani QML dengan C++ (Fase 10).

### 4.3 Filosofi modul

**Tipe adalah kontrak.** Properti bertipe berjanji “hanya menerima angka bulat”; engine menjaga janji itu dan memberi tahu bila dilanggar. `var` membatalkan kontrak: fleksibel, tetapi tanpa jaminan dan tanpa bantuan alat. Pilihlah tipe seketat yang masuk akal, longgarkan hanya dengan alasan.

### 4.4 Visual: peta tipe

```
  TIPE NILAI QML  (disalin saat ditugaskan; diakses di JS lewat "referensi tipe nilai")

  disediakan BAHASA          : bool  int  real/double  string  url  date  var  list<T>  enum  void
  disediakan QtQml           : point  rect  size  easingCurve
  disediakan QtQuick (import): color  font  vector2d/3d/4d  matrix4x4  quaternion

  TIPE OBJEK QML (disalin sebagai RUJUKAN)
                             : Item  Rectangle  Text  ... dan tipe dari berkas .qml Anda

  var = wadah apa saja  -->  fleksibel tetapi tanpa jaminan tipe
```

### 4.5 Estimasi waktu

Jalur A: 8–10 jam; Jalur B: 3–4 jam.

---

## 1.2.1 Primitif dan url

*Semangat: di balik setiap aplikasi besar ada angka dan teks yang dipilih dengan cermat.*

**Daftar isi 1.2.1:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh 1: lima tipe dasar · d. Contoh 2: tipe ditegakkan · e. Contoh 3: pembagian dan pecahan · f. `url` dan jalur relatif · g. Memilih tipe angka · h. Opsi lain · i. Visual · j. Terminologi · k. Tips · l. Kesalahan umum · m. Hubungan · n. Latihan dan cek · o. Referensi

### a. Deskripsi dan peran

Bagian ini membahas tipe yang paling sering Anda pakai: `bool`, `int`, `real` dan `double`, `string`, serta `url`. Hampir seluruh properti di aplikasi Anda akan berupa salah satunya.

### b. Konsep dan filosofi

| Tipe | Isi | Catatan |
| --- | --- | --- |
| `bool` | `true` atau `false` | Hasil perbandingan |
| `int` | Bilangan bulat (32-bit bertanda) | Hitungan, indeks, jumlah |
| `real`, `double` | Bilangan dengan pecahan, presisi ganda | Ukuran, harga, koordinat; keduanya setara |
| `string` | Teks bebas | Bertipe teks Unicode |
| `url` | Alamat sumber daya (berkas atau jaringan) | Jalur relatif dihitung dari dokumen |

Semua ini adalah **tipe nilai**: ketika Anda menugaskannya ke properti lain, yang disalin adalah nilainya, bukan rujukannya. Dalam JavaScript, nilai-nilai ini muncul sebagai *primitif* dan angka adalah bilangan ganda IEEE 754 (`typeof` bernilai `'number'` untuk `int`, `real`, dan `double`).

**Filosofi:** pilih tipe yang menyatakan **maksud**. `int` berkata “ini dihitung dalam satuan utuh”; `real` berkata “ini bisa berpecahan”. Alat dan pembaca mendapat informasi gratis dari pilihan Anda.

### c. Contoh 1: lima tipe dasar

Simpan sebagai `Primitif.qml`, jalankan `qml Primitif.qml`:

```qml
import QtQuick

Item {
    property bool aktif: true
    property int jumlah: 3
    property real harga: 12.5
    property double ukuran: 0.1
    property string nama: 'Kopi'
    property url gambar: 'img/logo.png'

    Component.onCompleted: {
        console.log('aktif', aktif, typeof aktif);
        console.log('jumlah', jumlah, typeof jumlah);
        console.log('harga', harga, typeof harga);
        console.log('nama', nama, typeof nama, nama.length);
        console.log('total', jumlah * harga);
        console.log('gambar', gambar, typeof gambar);
        console.log(`Beli ${jumlah} ${nama} seharga ${harga}`);
    }
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `property bool aktif: true` | Deklarasi properti baru bertipe `bool` dengan nilai awal (Modul 1.3). |
| `property int jumlah: 3` | Bilangan bulat. |
| `property real harga: 12.5`, `property double ukuran: 0.1` | Bilangan berpecahan; `real` dan `double` setara. |
| `property string nama: 'Kopi'` | Teks; `nama.length` adalah panjangnya. |
| `property url gambar: 'img/logo.png'` | Teks yang diubah engine menjadi alamat; relatif terhadap dokumen. |
| `Component.onCompleted: { ... }` | Blok yang dijalankan sekali setelah objek selesai dibuat (Fase 2). |
| `console.log(..., typeof aktif)` | Mencetak nilai dan jenis JavaScript-nya; hasil tampil di terminal berawalan `qml:`. |
| `jumlah * harga` | Ekspresi angka: `3 * 12.5` menghasilkan `37.5`. |
| `` `Beli ${jumlah} ... ` `` | *Template literal*: teks dengan sisipan ekspresi di dalam `${...}`. |

Catat hasil `typeof gambar` dan bentuk cetak `gambar` **\[amati\]**: nilai `url` biasanya tampil sebagai alamat lengkap, bukan teks yang Anda tulis.

### d. Contoh 2: tipe ditegakkan

Simpan sebagai `Salah.qml` dan jalankan:

```qml
import QtQuick

Item {
    property int volume: 'empat'
}
```

Menurut dokumentasi, menugaskan nilai bertipe salah pada saat inisialisasi **menghasilkan galat dan objeknya tidak dimuat**; bila salah tipe terjadi saat runtime, nilai baru tidak ditugaskan dan galat dicetak. Catat pesan dan exit code Anda di `galat.md` (1.1.7) **\[amati\]**. Perhatikan bahwa **teks tidak otomatis menjadi angka**: `'empat'` ditolak, dan menurut aturan yang sama `'5'` pada properti `int` juga bukan nilai yang cocok (uji, jangan asumsikan).

### e. Contoh 3: pembagian dan pecahan

Simpan sebagai `Angka.qml`:

```qml
import QtQuick

Item {
    Component.onCompleted: {
        console.log('5 / 2 =', 5 / 2);
        console.log('floor =', Math.floor(5 / 2));
        console.log('0.1 + 0.2 =', 0.1 + 0.2);
        console.log('sama persis?', 0.1 + 0.2 === 0.3);
        console.log('hampir sama?', Math.abs(0.1 + 0.2 - 0.3) < 1e-9);
        console.log('NaN:', Number('abc'), Number.isNaN(Number('abc')));
    }
}
```

| Bagian | Arti |
| --- | --- |
| `5 / 2` | JavaScript tidak punya pembagian bulat: hasilnya `2.5`. |
| `Math.floor(5 / 2)` | Pembulatan ke bawah untuk mendapat hasil bulat (`2`). |
| `0.1 + 0.2` | Dalam bilangan ganda hasilnya `0.30000000000000004`, bukan `0.3`. |
| `... === 0.3` | `false`: jangan membandingkan bilangan berpecahan dengan `===`. |
| `Math.abs(a - b) < 1e-9` | Bandingkan dengan **toleransi** yang sesuai skala masalah. |
| `Number('abc')`, `Number.isNaN(...)` | Konversi gagal menghasilkan `NaN` (*bukan angka*); periksa dengan `Number.isNaN`. |

### f. url dan jalur relatif

`url` adalah tipe tersendiri, bukan sekadar `string`. Ketika Anda menugaskan teks ke properti `url` (misalnya `Image.source`), engine menghitung alamatnya **relatif terhadap dokumen** yang berisi penugasan itu, sehingga `'img/logo.png'` benar di aplikasi yang dibangun (resource) maupun saat dijalankan dengan `qml` (berkas). Fungsi `Qt.resolvedUrl('img/logo.png')` melakukan hitungan yang sama secara eksplisit di JavaScript.

```qml
import QtQuick

Item {
    property url gambar: 'img/logo.png'

    Component.onCompleted: {
        console.log('url   :', gambar);
        console.log('teks  :', gambar.toString());
        console.log('resolv:', Qt.resolvedUrl('img/logo.png'));
    }
}
```

| Bagian | Arti |
| --- | --- |
| `gambar.toString()` | Mengubah `url` menjadi teks. |
| `Qt.resolvedUrl('img/logo.png')` | Menghitung alamat penuh relatif terhadap dokumen saat ini. |

Pada aplikasi yang dibangun (Modul 0.2), hasilnya berbentuk alamat resource (`qrc:/qt/qml/...`); di `qml` berbentuk `file:///...` **\[amati\]**.

### g. Memilih tipe angka

| Pertanyaan | Pilih |
| --- | --- |
| Dihitung satuan utuh (jumlah, indeks, banyaknya baris)? | `int` |
| Bisa berpecahan (ukuran, harga, kecepatan, skala)? | `real` |
| Berupa urutan bit atau status berhingga? | `int` dengan enum (1.2.5) |
| Tidak yakin? | `real`, bukan `var` |

### h. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Angka bebas tipe | `property var x` | Hilang jaminan tipe; hindari |
| Tipe JavaScript `number` | Hanya di dalam blok JS | Bukan tipe properti |
| Teks yang berisi angka dari pengguna | `Number(teks)` atau `parseFloat(teks)` | Periksa `NaN` |
| Mata uang atau pecahan yang harus tepat | Simpan satuan terkecil sebagai `int` (mis. sen) | Hindari galat pecahan |
| Alamat sebagai teks | `string` | Kehilangan perhitungan relatif otomatis |
| Alamat sebagai alamat | `url` | Disarankan untuk `source` dan sejenisnya |

### i. Visual

```
  nilai --> properti bertipe

  3        --> int      OK
  3.7      --> int      ?   (periksa perilaku: dipotong atau ditolak) [amati]
  'empat'  --> int      GALAT: nilai bertipe salah, objek tidak dimuat
  12.5     --> real     OK
  'a.png'  --> url      OK  (dihitung relatif terhadap dokumen)
  'a.png'  --> string   OK  (tetap teks biasa)
```

### j. Terminologi

| Istilah | Arti |
| --- | --- |
| Tipe nilai (value type) | Tipe yang disalin saat ditugaskan |
| Primitif | Nilai sederhana di JavaScript (angka, teks, boolean) |
| `NaN` | *Not a Number*, hasil konversi angka yang gagal |
| Template literal | Teks berkutip balik dengan sisipan `${...}` |
| Presisi ganda (double) | Bilangan pecahan 64-bit IEEE 754 |
| Epsilon / toleransi | Selisih terkecil yang masih dianggap sama |
| Alamat relatif | Alamat yang dihitung dari lokasi dokumen |

### k. Tips dan praktik terbaik

- Beri tipe pada **setiap** properti. `var` hanya untuk data yang memang bebas bentuk.
- Bandingkan bilangan pecahan dengan toleransi; bandingkan bilangan bulat dengan `===`.
- Gunakan `url` untuk sumber daya, bukan `string`.
- Untuk keuangan, simpan satuan terkecil dalam `int`.

### l. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Galat `Unable to assign ...` saat memuat | Nilai bertipe salah | Periksa tipe properti dan nilai |
| `0.1 + 0.2 !== 0.3` | Pecahan biner | Toleransi |
| `5 / 2` bukan `2` | Tidak ada pembagian bulat | `Math.floor` atau `Math.trunc` |
| `NaN` merambat ke tampilan | Konversi teks gagal | `Number.isNaN` dan nilai cadangan |
| Gambar tidak ditemukan di aplikasi, ada di `qml` | Jalur relatif berbeda atau berkas tak terdaftar | `Qt.resolvedUrl`, `RESOURCES` (0.2.6) |
| `typeof` mengejutkan | Salah menduga | Amati dan catat |

### m. Hubungan dengan modul lain

Prasyarat untuk 1.2.2 (tipe bernilai majemuk), Modul 1.3 (mendeklarasikan properti), Fase 2 (JavaScript: angka dan teks), Modul 4.3 (gambar dan `url`), dan Modul 10.2 (pemetaan tipe C++).

### n. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Primitif.qml`, `Salah.qml`, `Angka.qml`, dan contoh `url`. Lalu: (1) tulis `property int bagi: 5 / 2` dan catat nilainya **\[amati\]**; (2) tulis `property int pecah: 3.7` dan catat hasilnya atau galatnya **\[amati\]**; (3) ubah `0.1 + 0.2` menjadi perbandingan dengan toleransi sendiri; (4) catat semua pesan baru di `galat.md`.

**Cek pemahaman.** (1) Mengapa `===` tidak cocok untuk membandingkan bilangan berpecahan? (2) Apa bedanya `url` dan `string`? (3) Kapan memilih `int` dan kapan `real`?

### o. Referensi

- [QML Value Types](https://doc.qt.io/qt-6/qtqml-typesystem-valuetypes.html) · [QML Object Attributes: property attributes](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html)
- [JavaScript Host Environment (Qt)](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html) · [Qt global object](https://doc.qt.io/qt-6/qml-qtqml-qt.html)
- [MDN: Number](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number) · [IEEE 754 (Wikipedia)](https://en.wikipedia.org/wiki/IEEE_754)

---

## 1.2.2 Geometri, warna, dan font

*Semangat: setiap piksel yang Anda tata dimulai dari titik, ukuran, dan warna.*

**Daftar isi 1.2.2:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh 1: geometri dan warna · d. Warna dalam berbagai bentuk · e. Font · f. Tipe nilai disalin · g. Opsi lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Bagian ini membahas tipe nilai berstruktur yang menyusun tampilan: `point`, `size`, `rect` (titik dan ukuran), `color` (warna), dan `font` (tipografi). Mereka punya atribut (`x`, `width`, `r`, `pixelSize`) dan dibuat dengan fungsi objek global `Qt`.

### b. Konsep dan filosofi

| Tipe | Atribut | Dibuat dengan | Penyedia |
| --- | --- | --- | --- |
| `point` | `x`, `y` | `Qt.point(x, y)` | QtQml |
| `size` | `width`, `height` | `Qt.size(w, h)` | QtQml |
| `rect` | `x`, `y`, `width`, `height` | `Qt.rect(x, y, w, h)` | QtQml |
| `color` | `r`, `g`, `b`, `a` (0–1) | `'#rrggbb'`, `Qt.rgba(...)` | QtQuick |
| `font` | `family`, `pixelSize`, `bold`, `italic`, ... | `Qt.font({...})` atau `font { ... }` | QtQuick |

`color` dan `font` hanya tersedia bila `QtQuick` diimpor. Selain tipe-tipe ini, objek `Qt` menyediakan banyak fungsi bantu untuk memanipulasi tipe nilai.

**Filosofi:** tipe majemuk membungkus **satu gagasan** menjadi satu nilai (“posisi” bukan dua angka lepas), sehingga bisa dioper, disalin, dan diikat sebagai satu kesatuan.

### c. Contoh 1: geometri dan warna

Simpan sebagai `Geometri.qml`:

```qml
import QtQuick

Item {
    property point titik: Qt.point(40, 30)
    property size ukuran: Qt.size(120, 80)
    property rect area: Qt.rect(titik.x, titik.y, ukuran.width, ukuran.height)
    property color warna: Qt.rgba(0.16, 0.62, 0.56, 1.0)

    width: 300
    height: 160

    Rectangle {
        x: area.x
        y: area.y
        width: area.width
        height: area.height
        color: warna
        border.color: Qt.lighter(warna, 1.5)
        border.width: 3

        Text {
            anchors.centerIn: parent
            text: 'rect ' + area.x + ',' + area.y
            color: 'white'
            font { pixelSize: 16; bold: true }
        }
    }

    Component.onCompleted: console.log(warna, warna.r, area)
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `property point titik: Qt.point(40, 30)` | Properti bertipe `point`, diisi dengan fungsi pembuat. |
| `Qt.rect(titik.x, ..., ukuran.height)` | Menyusun `rect` dari atribut `point` dan `size` lain; binding yang ikut berubah bila keduanya berubah. |
| `Qt.rgba(0.16, 0.62, 0.56, 1.0)` | Warna dari merah, hijau, biru, alfa, masing-masing 0–1. |
| `x: area.x` ... | Memakai atribut `rect` untuk mengatur posisi dan ukuran. |
| `Qt.lighter(warna, 1.5)` | Fungsi bantu: warna yang 1,5 kali lebih terang. |
| `font { pixelSize: 16; bold: true }` | Properti grup `font` (1.1.3). |
| `console.log(warna, warna.r, area)` | Mencetak warna, komponen merahnya, dan `rect` **\[amati bentuk cetaknya\]**. |

### d. Warna dalam berbagai bentuk

| Bentuk | Contoh | Catatan |
| --- | --- | --- |
| Nama | `'steelblue'`, `'red'` | Nama warna SVG |
| Heksa RGB | `'#2a9d8f'` | `#rrggbb` |
| Heksa ARGB | `'#802a9d8f'` | **Alfa di depan**: `#aarrggbb`. Jebakan: CSS memakai `#rrggbbaa` |
| Komponen | `Qt.rgba(r, g, b, a)` | Nilai 0–1 |
| HSL | `Qt.hsla(h, s, l, a)` | Nilai 0–1 |
| Manipulasi | `Qt.lighter`, `Qt.darker`, `Qt.alpha`, `Qt.tint` | Fungsi bantu pada objek `Qt` |

Teks seperti `'red'` pada properti `color` dikonversi otomatis; sebuah properti `color` menyimpan **warna**, bukan teks, sehingga Anda dapat membaca `warna.r`.

### e. Font

```qml
Text {
    text: 'Halo'
    font.family: 'monospace'
    font.pixelSize: 24
    font.bold: true
}
```

| Atribut | Arti |
| --- | --- |
| `family` | Nama keluarga huruf |
| `pixelSize` | Ukuran dalam piksel |
| `pointSize` | Ukuran dalam poin (bergantung DPI) |
| `bold`, `italic`, `underline` | Gaya |
| `weight` | Ketebalan numerik |

Setel **salah satu** dari `pixelSize` atau `pointSize`, bukan keduanya. Menurut dokumentasi, perubahan atribut apa pun pada `font` memicu **satu** handler `onFontChanged`; handler untuk atribut individu seperti `onFont.pixelSizeChanged` **tidak valid**. Nilai bawaan dan daftar lengkap ada di halaman `font` di dokumentasi.

### f. Tipe nilai disalin

Tipe nilai bersifat **disalin**: menugaskannya ke properti lain membuat salinan terpisah.

```qml
import QtQuick

Item {
    property point a: Qt.point(1, 2)
    property point b

    Component.onCompleted: {
        b = a;
        b.x = 99;
        console.log(a.x, b.x);
    }
}
```

| Bagian | Arti |
| --- | --- |
| `b = a;` | Penugasan imperatif: `b` berisi **salinan** nilai `a`. |
| `b.x = 99;` | Mengubah salinan `b` saja. |
| `console.log(a.x, b.x)` | Dugaan: `1 99`; `a` tidak ikut berubah **\[amati\]**. |

Bandingkan dengan **tipe objek** (`Item`, `Rectangle`): menugaskan dua properti ke objek yang sama berarti keduanya merujuk satu objek, dan mengubah objek tampak di keduanya.

### g. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| `size` dari teks | `sourceSize: '100x200'` | Teks berbentuk `lebarxtinggi` dikonversi otomatis |
| Warna dengan transparansi | `Qt.rgba(...)`, `'#aarrggbb'`, atau properti `opacity` | `opacity` memengaruhi seluruh objek, bukan hanya warna |
| Font bersama | Satu `QtObject` atau tipe sendiri berisi `property font` | Konsistensi tipografi (Fase 5) |
| Warna tema | Palet dan style Controls | Fase 9 |
| Titik dan ukuran di C++ | `QPointF`, `QSizeF`, `QRectF` | Dipetakan otomatis ke `point`, `size`, `rect` |

### h. Visual

```
  point  (x,y)            size (w,h)           rect = point + size
     .---------> x           +------+             (x,y) +---------+
     |                       |  h   |                   |         | height
     v y                     +--w---+                   +---width-+

  color:  ARGB  a r g b      Qt.rgba(r,g,b,a)  0..1       '#aarrggbb'  (alfa DI DEPAN)
  font :  family pixelSize bold italic ...   (satu nilai; satu handler onFontChanged)
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| `point`, `size`, `rect` | Tipe nilai geometri |
| `color` | Tipe warna ARGB |
| ARGB | Urutan alfa, merah, hijau, biru |
| `font` | Tipe nilai tipografi |
| `pixelSize` / `pointSize` | Ukuran font dalam piksel / poin |
| Tipe nilai dan tipe objek | Disalin / dirujuk |
| Fungsi pembuat | `Qt.point`, `Qt.size`, `Qt.rect`, `Qt.rgba` |

### j. Tips dan praktik terbaik

- Pakai `Qt.rgba` atau heksa untuk warna eksplisit; nama warna hanya untuk percobaan cepat.
- Gunakan `rect` ketika empat nilai berhubungan sebagai satu kotak.
- Tentukan satu satuan ukuran font (`pixelSize` atau `pointSize`) untuk seluruh aplikasi.
- Ingat `#aarrggbb`, bukan `#rrggbbaa`.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Warna transparan tak terduga | Menulis `#rrggbbaa` seperti CSS | Pakai `#aarrggbb` atau `Qt.rgba` |
| Dua `font` berbeda ukuran | Menyetel `pixelSize` dan `pointSize` bersamaan | Pilih satu |
| `onFont.pixelSizeChanged` galat | Atribut tipe nilai tak punya signal sendiri | Pakai `onFontChanged` |
| Salinan tak ikut berubah | Tipe nilai disalin | Rujuk tipe objek, atau tugaskan ulang |
| `color` tak dikenali | `QtQuick` belum diimpor | `import QtQuick` |
| `Qt.rect(...)` tidak dikenal | Salah ejaan atau lupa objek `Qt` | `Qt.rect` |

### l. Hubungan dengan modul lain

Prasyarat untuk Fase 4 (`Item`, posisi, `Rectangle`, `Text`), Fase 5 (layout dan style), Fase 6 (animasi pada properti), dan Fase 9 (tema dan palet).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Geometri.qml`. (1) Ganti `Qt.rgba` dengan `'#802a9d8f'` dan amati transparansinya; (2) tambahkan `font.italic`; (3) buat dua properti `point` dengan `b = a` dan buktikan salinan; (4) tulis handler `onFontChanged` pada sebuah `Text` dan ubah `font.pixelSize` lewat `MouseArea`; catat kapan handler berjalan.

**Cek pemahaman.** (1) Apa arti `#802a9d8f` pada Qt? (2) Mengapa mengubah `b.x` tidak mengubah `a.x`? (3) Mengapa `onFont.pixelSizeChanged` tidak valid?

### n. Referensi

- [QML Value Types](https://doc.qt.io/qt-6/qtqml-typesystem-valuetypes.html) · [Qt global object](https://doc.qt.io/qt-6/qml-qtqml-qt.html)
- [font (QML value type)](https://doc.qt.io/qt-6/qml-font.html) · [Item](https://doc.qt.io/qt-6/qml-qtquick-item.html)
- [Text](https://doc.qt.io/qt-6/qml-qtquick-text.html) · [Rectangle](https://doc.qt.io/qt-6/qml-qtquick-rectangle.html)

---

## 1.2.3 date dan konversi QDate/QTime

*Semangat: waktu adalah bagian tersulit dari pemrograman, dan Anda memilih untuk memahaminya dengan benar.*

**Daftar isi 1.2.3:** a. Deskripsi dan peran · b. Konsep: satu momen, banyak tampilan · c. Contoh: bulan, zona, dan UTC · d. Konversi dengan C++ · e. Menghitung dan memformat · f. Memilih representasi waktu · g. Opsi lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Tipe `date` menyimpan tanggal dan waktu, dan di QML ia adalah **objek `Date` JavaScript**. Tidak ada tipe `time` terpisah. Bagian ini menjelaskan cara memakainya dengan benar, dan jebakan zona waktu dan penomoran bulan yang membuat banyak aplikasi menampilkan hari yang salah.

### b. Konsep: satu momen, banyak tampilan

- `Date` menyimpan **satu momen absolut**: jumlah milidetik sejak 1 Januari 1970 UTC. Tampilannya (tanggal dan jam) bergantung pada **zona waktu** yang dipakai untuk membacanya.
- Pembuatan menentukan zona: `new Date(2026, 10, 7)` memakai **waktu lokal** (awal hari di zona Anda), sedangkan `new Date('2026-11-07')` (teks tanggal-saja) ditafsirkan sebagai awal hari **UTC**. Di zona yang tidak sama dengan UTC, keduanya adalah momen **berbeda**.
- **Bulan JavaScript 0 sampai 11** (Januari = 0); Qt menomori bulan 1 sampai 12. Hari (`getDate()`) dimulai dari 1.
- **Pengganti tipe `time`:** gunakan `date` dan baca komponen jam, menit, dan detiknya (`getHours()`, `getMinutes()`), atau simpan `int` detik sejak tengah malam bila Anda hanya butuh durasi atau jam dalam sehari.

### c. Contoh: bulan, zona, dan UTC

Simpan sebagai `Tanggal.qml`:

```qml
import QtQuick

Item {
    property date sekarang: new Date()
    property date lahir: new Date(2000, 0, 31)

    Component.onCompleted: {
        const d1 = new Date('2026-11-07');
        const d2 = new Date(2026, 10, 7);

        console.log('d1 UTC   :', d1.toISOString());
        console.log('d2 lokal :', d2.toISOString());
        console.log('bulan JS :', d2.getMonth(), '-> bulan Qt:', d2.getMonth() + 1);
        console.log('d1 sama d2?', d1.getTime() === d2.getTime());
        console.log(Qt.formatDate(d1, 'yyyy-MM-dd'));
        console.log(Qt.formatTime(d2, 'hh:mm'));
        console.log(Qt.formatDateTime(sekarang, 'dd/MM/yyyy hh:mm'));
        console.log(Math.round((sekarang - lahir) / 86400000), 'hari sejak lahir');
    }
}
```

```bash
$ qml Tanggal.qml
$ TZ=UTC qml Tanggal.qml
$ TZ=Asia/Jakarta qml Tanggal.qml
$ TZ=America/Los_Angeles qml Tanggal.qml
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `property date sekarang: new Date()` | Properti `date` berisi saat ini. |
| `new Date(2000, 0, 31)` | 31 **Januari** 2000, waktu lokal (bulan 0). |
| `new Date('2026-11-07')` | Teks tanggal-saja: awal hari **UTC**. |
| `new Date(2026, 10, 7)` | 7 **November** 2026 (bulan 10), awal hari **lokal**. |
| `toISOString()` | Mencetak momen dalam UTC (akhiran `Z`). |
| `getMonth()` | Bulan 0–11; `+ 1` mengubahnya ke penomoran Qt. |
| `getTime()` | Milidetik sejak epoch; dipakai untuk membandingkan momen. |
| `Qt.formatDate/formatTime/formatDateTime` | Memformat `Date` memakai pola (`yyyy`, `MM`, `dd`, `hh`, `mm`) dalam waktu lokal. |
| `(sekarang - lahir) / 86400000` | Selisih dua `Date` dalam milidetik dibagi milidetik per hari. |
| `TZ=... qml ...` | Prefiks variabel (0.0.3) yang mengubah zona waktu proses. |

**Yang akan Anda lihat \[amati\].** Pada `TZ=UTC`, `d1` dan `d2` adalah momen yang sama. Pada zona UTC+7 (mis. `Asia/Jakarta`), `d2` (tengah malam lokal) adalah pukul 17.00 UTC hari sebelumnya, tujuh jam sebelum `d1`, sehingga `getTime()` berbeda. Pada zona di belakang UTC (mis. `America/Los_Angeles`), `d1` jatuh pada sore hari **sebelumnya** di waktu lokal, dan `Qt.formatDate(d1, ...)` menampilkan tanggal yang mundur satu hari. Inilah jebakan yang diperingatkan dokumentasi Qt.

### d. Konversi dengan C++

Tabel berikut dari dokumentasi *Data Type Conversion Between QML and C++*:

| C++ | JavaScript (QML) | Catatan |
| --- | --- | --- |
| `QDateTime` | `Date` | Konversi dua arah otomatis; **paling kokoh** untuk pertukaran |
| `QDate` | `Date` | Diwakili **awal hari dalam UTC**. Kembali ke `QDate` lewat `QDateTime::date()` dalam waktu lokal, kecuali bila bentuk UTC-nya bertepatan dengan awal hari berikutnya, yang memakai bentuk UTC |
| `QTime` | `Date` | Tanggal dibuat **hanya untuk konversi**; jangan andalkan komponen tanggalnya |
| `Date` | `QTime` | Dikonversi lewat `QDateTime` lokal, lalu `time()` |

Akibat praktis: bila properti C++ berupa `QDate`, bacalah di QML dengan `getUTCFullYear()`, `getUTCMonth()`, dan `getUTCDate()`, bukan getter lokal. Namun cara paling aman adalah **menghindari `QDate` dan `QTime` di antarmuka QML** dan memakai `QDateTime` (atau epoch/ISO) sehingga satu standar waktu jelas di kedua sisi.

### e. Menghitung dan memformat

```qml
import QtQuick

Item {
    function tambahHari(d, n) {
        const x = new Date(d);
        x.setDate(x.getDate() + n);
        return x;
    }

    Component.onCompleted: {
        const awal = new Date(2026, 10, 7, 9, 30);
        const nanti = tambahHari(awal, 30);
        console.log(Qt.formatDateTime(nanti, 'yyyy-MM-dd hh:mm'));
        console.log(nanti > awal, nanti.getTime() - awal.getTime());
        console.log(awal.toLocaleDateString(), awal.toLocaleTimeString());
    }
}
```

| Bagian | Arti |
| --- | --- |
| `new Date(d)` | Menyalin `Date`, supaya aslinya tidak berubah. |
| `x.setDate(x.getDate() + n)` | Menambah hari secara kalender (mengurus pergantian bulan dan tahun). |
| `nanti > awal` | `Date` dapat dibandingkan dengan `<` dan `>`; untuk kesamaan, bandingkan `getTime()`, bukan `===`. |
| `toLocaleDateString()` | Format sesuai lokal sistem; dibahas lebih jauh bersama `Qt.locale()` di Fase 9. |

Waspadai **peralihan DST**: menambah 24 jam (`getTime() + 86400000`) tidak sama dengan menambah satu hari kalender di zona dengan DST; gunakan `setDate`.

### f. Memilih representasi waktu

| Kebutuhan | Representasi | Catatan |
| --- | --- | --- |
| Momen yang dikirim atau disimpan | Epoch milidetik sebagai `real` atau `double` | **Bukan `int`**: sekitar `1.7e12` melampaui rentang 32-bit |
| Epoch dalam detik | `real` atau `double` | `int` 32-bit berhenti sekitar tahun 2038 |
| Dibaca manusia atau antarsistem | Teks ISO 8601 (`'2026-11-07T09:30:00Z'`) | Jelas dan dapat diurutkan sebagai teks |
| Pertukaran dengan C++ | `QDateTime` | Satu standar zona di kedua sisi |
| Tanggal kalender tanpa jam (ulang tahun) | Tiga bilangan `int` (tahun, bulan, hari) atau teks `'2000-01-31'` | Hindari `Date` yang tak sengaja bergeser zona |
| Durasi atau jam dalam sehari | `int` detik | Pengganti `time` |

### g. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Format bersama locale | `Qt.locale().toString(date, format)` | Fase 9 |
| Pustaka tanggal JavaScript | `.js` pustaka (mis. dayjs) di `QML_FILES` | Ikuti lisensinya; kecil dan murni JS |
| Perhitungan berat | Di C++ memakai `QDateTime` dan `QTimeZone` | Fase 10 |
| Waktu sekarang berulang | `Timer` dan `new Date()` | Fase 6 |
| Zona waktu tertentu | Hitung di C++ (`QTimeZone`) | JavaScript hanya lokal dan UTC |

### h. Visual

```
  satu momen (epoch ms)  ------------------+
                                           |
   dibaca di UTC        ----> 2026-11-06 17:00  (zona UTC+7: tengah malam 7 Nov lokal)
   dibaca di UTC+7      ----> 2026-11-07 00:00
   dibaca di UTC-8      ----> 2026-11-06 09:00

   new Date(2026, 10, 7)    = awal hari LOKAL     (bulan 10 = November)
   new Date('2026-11-07')   = awal hari UTC       (teks tanggal-saja)
   bulan: JS 0..11   |   Qt 1..12
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Epoch | Titik awal hitungan waktu: 1 Januari 1970 UTC |
| UTC | Waktu universal terkoordinasi |
| Waktu lokal | Waktu menurut zona pengguna |
| ISO 8601 | Standar penulisan tanggal-waktu teks |
| DST | Waktu musim panas; menggeser jam di beberapa zona |
| `QDateTime`, `QDate`, `QTime` | Tipe tanggal-waktu di C++ |
| Momen absolut | Titik pada garis waktu, tidak bergantung zona |

### j. Tips dan praktik terbaik

- Simpan dan kirim momen sebagai epoch atau ISO UTC; ubah ke waktu lokal hanya saat menampilkan.
- Tulis `new Date(tahun, bulan - 1, hari)` dengan komentar jelas, dan dokumentasikan penomoran bulan di mana pun Anda mengubah.
- Hindari `QDate` dan `QTime` di antarmuka C++/QML.
- Selalu uji logika tanggal dengan `TZ=UTC` dan satu zona lain.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Tanggal mundur satu hari | Teks tanggal-saja = UTC, dibaca lokal | Getter UTC, atau `new Date(y, m, d)` |
| Bulan salah satu | Lupa 0–11 | `bulan - 1` saat membuat, `+ 1` saat menampilkan |
| `time` tidak dikenal | Tipe tidak ada | Pakai `date` atau `int` detik |
| Epoch tidak muat di `int` | 32-bit | `real` atau `double` |
| Jam bergeser pada peralihan DST | Menambah 24 jam | `setDate` |
| Membandingkan `Date` dengan `===` | Dua objek berbeda | Bandingkan `getTime()` |

### l. Hubungan dengan modul lain

Prasyarat untuk 1.2.6 (jebakan konversi), Fase 2 (objek `Date`), Fase 6 (`Timer`), Fase 7 (data dari jaringan), dan Fase 10 (jembatan `QDateTime`).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Tanggal.qml` dengan empat zona di bagian c dan catat keluaran `d1`/`d2`/`formatDate`. Lalu buat fungsi `umurTahun(lahir)` yang menghitung umur dengan benar sampai hari ini dan ujilah dengan `TZ=UTC` dan satu zona lain.

**Cek pemahaman.** (1) Apa pengganti tipe `time`? (2) Mengapa `new Date('2026-11-07')` dan `new Date(2026, 10, 7)` bisa berbeda? (3) Mengapa epoch milidetik tidak boleh disimpan di `int`?

### n. Referensi

- [Data Type Conversion Between QML and C++](https://doc.qt.io/qt-6/qtqml-cppintegration-data.html) · [Qt global object: formatDate, formatTime, formatDateTime](https://doc.qt.io/qt-6/qml-qtqml-qt.html)
- [MDN: Date](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date) · [ISO 8601 (Wikipedia)](https://en.wikipedia.org/wiki/ISO_8601)
- [JavaScript Host Environment (Qt)](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html)

---

## 1.2.4 list dan var

*Semangat: kelonggaran adalah alat yang kuat, dan kekuatan menuntut kehati-hatian.*

**Daftar isi 1.2.4:** a. Deskripsi dan peran · b. Konsep: tiga jenis koleksi · c. Contoh: perilaku nyata · d. Mengubah isi dan pemberitahuan · e. Pola pembaruan yang aman · f. `list` dari C++ dan sequence type · g. Opsi lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Bagian ini membahas dua tipe fleksibel: `list<T>` (koleksi objek QML bertipe) dan `var` (wadah serba bisa). Memahami perilakunya, terutama **kapan perubahan isi diberitahukan**, mencegah bug tampilan yang “diam”.

### b. Konsep: tiga jenis koleksi

| Jenis | Isi | Ciri |
| --- | --- | --- |
| `list<T>` | Daftar objek QML bertipe `T` (mis. `list<Item>`) | Terketik; menjadi nilai `default property` (`data`, `children`, `states`); bukan `Array` JavaScript |
| `var` | Nilai JavaScript apa pun: angka, teks, objek `{}`, larik `[]` | Tanpa jaminan tipe; sangat fleksibel |
| Larik JavaScript (di dalam fungsi) | `[1, 2, 3]` | Metode array lengkap; bukan properti |

Dokumentasi menyatakan: bila Anda ingin menyimpan daftar **nilai yang tidak harus berupa objek QML**, deklarasikan properti `var`. Catatan: dokumentasi tipe nilai terbaru menyebut `list` boleh berelemen tipe objek atau tipe nilai; uji `property list<int>` pada versi Anda **\[uji dulu\]**.

`var` menyimpan **apa saja**, tetapi dengan harga: engine dan `qmllint` tidak tahu isinya, dan `onXChanged` hanya terpancar ketika **properti itu sendiri** ditugaskan ulang (bagian d).

### c. Contoh: perilaku nyata

Simpan sebagai `Daftar.qml`:

```qml
import QtQuick

Item {
    id: root

    property var bebas: ({ kunci: 'nilai', angka: 7 })
    property var larik: [1, 2, 3]
    property list<Item> daftar: [
        Item { objectName: 'satu' },
        Item { objectName: 'dua' }
    ]

    onBebasChanged: console.log('onBebasChanged')
    onLarikChanged: console.log('onLarikChanged')

    Component.onCompleted: {
        console.log(daftar.length, daftar[0].objectName);
        console.log('larik isArray:', Array.isArray(larik), typeof bebas);

        bebas.kunci = 'baru';
        console.log('--- isi objek diubah');

        bebas = { kunci: 'ganti', angka: 8 };
        console.log('--- objek diganti');

        larik.push(4);
        console.log('--- push selesai, panjang', larik.length);

        larik = larik.concat([5]);
        console.log('--- larik diganti, panjang', larik.length);
    }
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `property var bebas: ({ kunci: 'nilai', angka: 7 })` | Objek JavaScript di `var`. **Kurung** `( ... )` wajib: tanpa kurung, `{ ... }` dibaca sebagai blok kode. |
| `property var larik: [1, 2, 3]` | Larik di `var`. |
| `property list<Item> daftar: [ Item {...}, Item {...} ]` | Daftar dua objek `Item`; kurung siku dan koma. |
| `onBebasChanged`, `onLarikChanged` | Handler yang dipanggil bila **properti** `bebas` atau `larik` ditugaskan nilai baru (1.3.6). |
| `daftar.length`, `daftar[0].objectName` | `list` dapat dibaca lewat `length` dan indeks. |
| `Array.isArray(larik)` | `true` untuk larik JavaScript di `var`. |
| `bebas.kunci = 'baru'` | Mengubah **isi** objek. |
| `bebas = { ... }` | **Menugaskan ulang** properti. |
| `larik.push(4)` | Menambah elemen pada larik yang sama (mengubah isi). |
| `larik.concat([5])` | Menghasilkan larik **baru**, lalu ditugaskan ulang. |

**Dugaan yang harus Anda buktikan \[amati\].** `onBebasChanged` terpanggil **hanya** pada penugasan ulang (`bebas = {...}`), tidak pada `bebas.kunci = 'baru'`; `onLarikChanged` terpanggil hanya pada `larik = larik.concat(...)`, tidak pada `push`. Itulah inti jebakan: mengubah **isi** sebuah `var` tidak memberi tahu pihak yang bergantung padanya.

### d. Mengubah isi dan pemberitahuan

- Ikatan (binding) dan handler perubahan bereaksi terhadap **penugasan properti**. Untuk `var` berisi objek atau larik, mengubah isi di tempat tidak menugaskan properti, sehingga tampilan yang terikat tidak diperbarui.
- Solusinya: **buat nilai baru dan tugaskan ulang** (pola di bagian e), atau memakai model yang memang memancarkan pemberitahuan perubahan (`ListModel`, model C++; Fase 7).
- `list<T>` juga bukan `Array`: baca dengan `length` dan indeks; operasi mengubah (menambah/menghapus) dilakukan lewat tugas ulang seluruh daftar atau lewat API pemiliknya. Bila metode array tersedia atau tidak pada `list` di versi Anda, buktikan dengan percobaan (`daftar.push(...)`) **\[amati\]**.

### e. Pola pembaruan yang aman

```qml
property var larik: [1, 2, 3]

function tambah(x) {
    larik = larik.concat([x]);
}

function hapusPertama() {
    larik = larik.slice(1);
}

function gandakan() {
    larik = larik.map(v => v * 2);
}

function ubahKunci(k, nilai) {
    bebas = Object.assign({}, bebas, { [k]: nilai });
}
```

| Bagian | Arti |
| --- | --- |
| `larik.concat([x])` | Larik baru dengan tambahan `x`; asli tidak berubah. |
| `larik.slice(1)` | Larik baru tanpa elemen pertama. |
| `larik.map(v => v * 2)` | Larik baru hasil transformasi tiap elemen; `=>` adalah fungsi panah (Fase 2). |
| `Object.assign({}, bebas, { [k]: nilai })` | Objek baru berisi salinan `bebas` dengan satu kunci diganti. |
| Penugasan ulang di tiap fungsi | Memicu `onLarikChanged` dan binding yang bergantung padanya. |

### f. list dari C++ dan sequence type

- Daftar dari C++ (`QVariantList`) tampil di QML sebagai **array-like**: dapat dipakai seperti larik JavaScript (metode array tersedia dan `length` tersinkron), tetapi `Array.isArray()` bernilai **`false`**. Sejak Qt 6.5 properti `QVariantList` pada tipe C++ dapat diubah di tempat dari QML.
- *Sequence type* (mis. `QList<int>`, `QList<qreal>`, `QList<bool>`, `QStringList`) juga berperilaku seperti larik JavaScript.
- Untuk mendapatkan larik JavaScript sungguhan: `Array.from(x)` (karena array-like punya `length` dan indeks).

### g. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Daftar yang diamati perubahannya | `ListModel` | Fase 7 |
| Daftar besar dari C++ | Model C++ (`QAbstractListModel`) | Fase 10 |
| Satu “baris” data bernama | Tipe sendiri (`QtObject` dengan properti terketik) | Lebih aman daripada objek `var` |
| Menyimpan beberapa nilai tetap | `readonly property var` | Tidak boleh diganti, isi boleh dibaca |
| JSON dari jaringan | `var` lalu validasi | Fase 7 |
| Tipe untuk daftar objek | `list<Tipe>` | Terketik dan terbaca alat |

### h. Visual

```
  var bebas = { a: 1 }
       |
       |  bebas.a = 2        isi berubah, properti TIDAK ditugaskan  --> TIDAK ada onBebasChanged
       |  bebas = { a: 2 }   properti ditugaskan ulang                --> onBebasChanged  (binding ikut)

  list<Item>  : [Item, Item]   baca: length, indeks     (bukan Array JavaScript)
  QVariantList: array-like     metode array ya, Array.isArray -> false
  Array.from(x) -> larik JavaScript sungguhan
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| `list<T>` | Properti berisi daftar objek QML bertipe `T` |
| `var` | Tipe serba bisa |
| Array-like | Objek mirip larik (indeks dan `length`) |
| Penugasan ulang | Mengganti nilai properti seluruhnya |
| Mutasi (mengubah di tempat) | Mengubah isi tanpa mengganti nilai |
| Sequence type | Tipe urutan C++ yang tampil seperti larik |
| Immutable (tak berubah) | Gaya membuat salinan baru alih-alih mengubah |

### j. Tips dan praktik terbaik

- Utamakan `list<T>` untuk daftar objek, dan model untuk data yang berubah.
- Perlakukan isi `var` sebagai **tak berubah**: buat nilai baru dan tugaskan ulang.
- Jangan memakai `var` hanya karena malas memilih tipe (1.2).
- Bungkus data berstruktur dalam tipe sendiri bila bentuknya tetap.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Tampilan tidak berubah setelah `push` | Mutasi tidak memicu pemberitahuan | Tugaskan ulang (`concat`, `slice`, `map`) |
| `{ ... }` dibaca sebagai blok | Objek tanpa kurung di binding | `({ ... })` |
| `Array.isArray()` salah pada data C++ | Array-like | `Array.from(x)` |
| `list<int>` ditolak | Dokumentasi lama membatasi tipe objek | Uji versi Anda, atau pakai `var` |
| Menulis `daftar.push(...)` pada `list` | `list` bukan `Array` | Tugaskan ulang atau gunakan API pemilik |
| Data bentuk bebas di mana-mana | `var` merajalela | Tipe sendiri dan `required property` |

### l. Hubungan dengan modul lain

Prasyarat untuk Modul 1.3 (properti dan handler perubahan), Fase 2 (metode Array), Fase 3 (binding dan pemberitahuan), Fase 7 (model dan view), dan Fase 10 (data dari C++).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Daftar.qml` dan cocokkan dugaan di bagian c dengan hasil Anda. Lalu: (1) coba `daftar.push(Item {})` dan catat hasilnya; (2) coba `property list<int> angka: [1, 2, 3]` dan catat hasilnya **\[uji dulu\]**; (3) buat tombol yang menambah elemen ke `larik` dengan `concat` dan tampilkan `larik.length` di `Text` yang terikat.

**Cek pemahaman.** (1) Mengapa `larik.push(4)` tidak memicu `onLarikChanged`? (2) Mengapa objek literal di binding perlu kurung? (3) Apa pengganti `list` bila isinya bukan objek QML?

### n. Referensi

- [QML Object Attributes: list properties](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html) · [QML Value Types](https://doc.qt.io/qt-6/qtqml-typesystem-valuetypes.html)
- [Data Type Conversion: sequence types](https://doc.qt.io/qt-6/qtqml-cppintegration-data.html) · [QML Sequence Types](https://doc.qt.io/qt-6/qml-sequence-types.html)
- [MDN: Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array) · [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html)

---

## 1.2.5 Enum

*Semangat: nama yang bermakna mengalahkan angka ajaib, setiap saat.*

**Daftar isi 1.2.5:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh 1: enum milik Qt · d. Contoh 2: enum buatan sendiri · e. Pembantu `Qt.enum...` · f. Opsi lain · g. Visual · h. Terminologi · i. Tips · j. Kesalahan umum · k. Hubungan · l. Latihan dan cek · m. Referensi

### a. Deskripsi dan peran

Enum memberi **nama** pada sekumpulan nilai bulat yang terbatas (status, mode, arah). Kode `status === 1` tidak menjelaskan apa-apa; `status === Status.Mode.Loading` menjelaskan segalanya. Anda akan memakai enum bawaan Qt (`Text.AlignRight`, `Image.Ready`) setiap hari dan membuat sendiri bila sebuah komponen punya keadaan berhingga.

### b. Konsep dan filosofi

- Menurut dokumentasi, **enum bukan tipe tersendiri di QML**: ia adalah **properti dari tipe pembungkusnya**, dan nilainya diwakili oleh tipe dasarnya (bilangan bulat). Untuk nilai dalam rentang bilangan bulat 32-bit bertanda, `int` aman untuk menyimpannya.
- Karena itu **`enumeration` tidak dapat dipakai sebagai tipe properti**: deklarasikan `property int mode`.
- Enum harus dipegang oleh **tipe bernama**; namespace QML juga tipe yang boleh menampung enum. Dari luar, nilai diacu sebagai `<Tipe>.<Nilai>`; untuk enum yang dideklarasikan di QML, gunakan juga nama enumnya agar jelas: `Status.Mode.Loading`.
- Enum dapat didefinisikan di **QML** (kata kunci `enum`, sejak Qt 5.10) atau di **C++** (`Q_ENUM`, Fase 10).

**Filosofi:** keadaan berhingga sebaiknya dinyatakan dengan **himpunan nama**, bukan angka dan teks lepas. Salah ketik nama enum dikenali alat; salah ketik angka tidak.

### c. Contoh 1: enum milik Qt

Simpan sebagai `EnumQt.qml`:

```qml
import QtQuick

Item {
    width: 300
    height: 100

    property int nilai: teks.horizontalAlignment

    Text {
        id: teks
        anchors.fill: parent
        text: 'Rata kanan'
        horizontalAlignment: Text.AlignRight
    }

    Component.onCompleted: console.log(nilai, Text.AlignRight, Text.AlignLeft)
}
```

| Bagian | Arti |
| --- | --- |
| `Text.AlignRight` | Nilai enum milik tipe `Text`; ditulis `<Tipe>.<Nilai>`. |
| `horizontalAlignment: Text.AlignRight` | Memberi properti `Text` nilai enum. |
| `property int nilai: teks.horizontalAlignment` | Enum disimpan di properti `int`: bukti bahwa ia berwujud bilangan bulat. |
| `console.log(nilai, Text.AlignRight, Text.AlignLeft)` | Mencetak nilai angka sebenarnya **\[amati\]**. |

### d. Contoh 2: enum buatan sendiri

Buat dua berkas di folder yang sama. `Status.qml`:

```qml
import QtQuick

Item {
    id: root

    enum Mode {
        Idle,
        Loading,
        Error = 10
    }

    property int mode: Status.Mode.Idle

    function nama() {
        switch (root.mode) {
        case Status.Mode.Idle:
            return 'idle';
        case Status.Mode.Loading:
            return 'loading';
        case Status.Mode.Error:
            return 'error';
        default:
            return 'tidak dikenal';
        }
    }
}
```

`UjiStatus.qml`:

```qml
import QtQuick

Item {
    Status { id: s }

    Component.onCompleted: {
        console.log(s.mode, s.nama());
        s.mode = Status.Mode.Loading;
        console.log(s.mode, s.nama());
        s.mode = Status.Mode.Error;
        console.log(s.mode, s.nama());
        console.log(Status.Mode.Idle, Status.Mode.Loading, Status.Mode.Error);
    }
}
```

```bash
$ qml UjiStatus.qml
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `enum Mode { ... }` | Deklarasi enum di dalam tipe `Status`. Nama enum dan nilainya **diawali huruf besar**. |
| `Idle, Loading, Error = 10` | Tanpa angka, nilai berurutan dari 0 (`Idle` 0, `Loading` 1); `Error = 10` menetapkan angka eksplisit. |
| `property int mode: Status.Mode.Idle` | Properti `int` berisi nilai enum; nilai awal diacu dengan nama bertingkat. |
| `switch (root.mode) { case ...: return ...; }` | Percabangan menurut nilai (Fase 2); tiap nilai punya nama. |
| `Status { id: s }` | Memakai tipe `Status` (berkas sama folder, 1.1.6). |
| `s.mode = Status.Mode.Loading` | Mengubah status dengan nama, bukan angka. |

Dugaan keluaran: `0 idle`, `1 loading`, `10 error`, dan `0 1 10` **\[amati\]**. Coba juga acuan `Status.Loading` (tanpa nama enum) dan catat apakah ia berfungsi di versi Anda **\[amati\]**; bentuk bertingkat `Status.Mode.Loading` selalu lebih jelas.

### e. Pembantu Qt.enum...

Objek global `Qt` menyediakan tiga pembantu untuk memetakan **nama kunci** dan **nilai angka**:

| Fungsi | Fungsi |
| --- | --- |
| `Qt.enumStringToValue` | Teks nama kunci menjadi nilai angkanya |
| `Qt.enumValueToString` | Nilai angka menjadi nama kunci yang bernilai itu |
| `Qt.enumValueToStrings` | Nilai angka menjadi daftar nama kunci yang bernilai itu |

Mereka berguna untuk log dan untuk membaca enum dari teks (mis. berkas konfigurasi). Bentuk argumen persisnya ada di dokumentasi `Qt`; baca dan coba sendiri **\[uji dulu\]**.

### f. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Keadaan berhingga dalam satu komponen | `enum` di QML | Disarankan |
| Konstanta terkumpul tanpa tipe | `QtObject` berisi `readonly property int ...` | Mudah, tetapi tanpa jaminan keanggotaan |
| Konstanta bersama seluruh aplikasi | Singleton QML (`pragma Singleton`) | Fase 8 |
| Keadaan sebagai teks | `readonly property string idle: 'idle'` | Mudah dibaca, rentan salah ketik |
| Enum yang juga dipakai C++ | `Q_ENUM` pada tipe C++ | Fase 10 |
| Keadaan visual | `State` dan `states` | Fase 6 (berbeda tujuan) |

### g. Visual

```
  Status.qml                         pemakai
  +----------------------+           +-----------------------------------+
  | enum Mode {          |           | s.mode = Status.Mode.Loading      |
  |   Idle      (0)      |  nama     |   ^                               |
  |   Loading   (1)      | <-------- |   '-- nama dikenali alat          |
  |   Error     (10)     |           | console.log(s.mode)   -->  1      |
  | }                    |           +-----------------------------------+
  | property int mode    |   enum = bilangan bulat di balik layar (simpan di int)
  +----------------------+
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| Enumerasi (enum) | Himpunan nama bagi nilai bulat |
| Enumerator / kunci | Satu nama dalam enum |
| Tipe pembungkus | Tipe bernama yang memegang enum |
| `<Tipe>.<Enum>.<Nilai>` | Bentuk acuan penuh |
| `Q_ENUM` | Makro C++ untuk mengekspos enum ke QML |
| Magic number | Angka tak bernama di kode |

### i. Tips dan praktik terbaik

- Ganti setiap angka ajaib yang menyatakan keadaan dengan enum.
- Selalu tulis bentuk bertingkat (`Status.Mode.Loading`).
- Tambahkan penjaga `default:` pada `switch` untuk nilai tak dikenal.
- Untuk keadaan antarmuka yang berubah visual, pertimbangkan `State` (Fase 6) selain enum.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Galat saat memakai `Mode` sebagai tipe properti | Enum bukan tipe | `property int mode` |
| Enum berawalan huruf kecil ditolak | Aturan penamaan | Awali dengan huruf besar |
| Enum di dokumen tanpa nama tipe tidak bisa diacu | Enum harus dipegang tipe bernama | Letakkan di berkas bertipe, atau namespace |
| Nilai enum 64-bit rusak | Melampaui rentang aman | Hindari nilai di luar rentang 32-bit |
| Perbandingan dengan angka telanjang | Menghilangkan makna | Selalu bandingkan dengan nama enum |
| Mengacu `Status.Loading` gagal | Anggapan keliru: dokumentasi menyatakan kedua bentuk sah (koreksi di 5.1 butir 9) | Pakai `Status.Mode.Loading` |

### k. Hubungan dengan modul lain

Prasyarat untuk Modul 1.3 (properti bertipe `int` yang memakai enum), Fase 2 (`switch`), Fase 6 (state dan animasi), Fase 8 (singleton konstanta), dan Fase 10 (`Q_ENUM`).

### l. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `EnumQt.qml` dan `UjiStatus.qml`. Lalu tambahkan nilai baru `Selesai` ke `Mode`, perbarui `nama()`, dan jalankan ulang. Coba acuan `Status.Loading` dan `Qt.enumValueToString` dan catat hasilnya.

**Cek pemahaman.** (1) Mengapa `enumeration` tidak bisa menjadi tipe properti? (2) Apa nilai `Loading` bila tidak diberi angka? (3) Mengapa bentuk bertingkat lebih baik?

### m. Referensi

- [QML Enumerations](https://doc.qt.io/qt-6/qtqml-typesystem-enumerations.html) · [QML Object Attributes: enumeration attributes](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html)
- [Qt global object: enum helpers](https://doc.qt.io/qt-6/qml-qtqml-qt.html) · [Defining enumerations in C++](https://doc.qt.io/qt-6/qtqml-cppintegration-definetypes.html)

---

## 1.2.6 Konversi dan jebakan

*Semangat: jebakan yang sudah Anda kenal tidak lagi menjebak.*

**Daftar isi 1.2.6:** a. Deskripsi dan peran · b. Apa yang dikonversi engine · c. Daftar jebakan lengkap · d. Contoh 1: konversi JavaScript · e. Contoh 2: konversi pada properti bertipe · f. Strategi aman · g. Opsi lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Bagian ini menyatukan semua jebakan konversi yang tersebar di 1.2.1 sampai 1.2.5 menjadi satu peta, dan menambah jebakan umum JavaScript yang akan Anda temui setiap hari di QML.

### b. Apa yang dikonversi engine

- **Teks ke tipe bernilai** pada properti bertipe: engine mengubah string menjadi tipenya secara otomatis untuk tipe yang tidak punya representasi natural, misalnya `'red'` menjadi `color`, `'100x200'` menjadi `size` (`Image.sourceSize`), dan `'img/a.png'` menjadi `url`.
- **Tipe C++ ke tipe QML** dan sebaliknya (Fase 10): `QDateTime` ke `Date`, `QVariantList` ke array-like, `QString` ke `string`, dan seterusnya.
- **Tipe salah ditolak:** nilai yang tak cocok dengan tipe properti menghasilkan galat; pada inisialisasi objek tidak dimuat, pada runtime nilai tidak ditugaskan.
- **JavaScript sendiri mengonversi diam-diam** pada operator (`+`, `==`, `if`). Konversi ini berasal dari bahasa, bukan dari QML, dan merupakan sumber jebakan paling banyak.

### c. Daftar jebakan lengkap

| No. | Jebakan | Gejala | Solusi | Dibahas |
| --- | --- | --- | --- | --- |
| 1 | Bulan JavaScript 0–11, Qt 1–12 | Bulan salah satu | `bulan - 1` dan `+ 1` | 1.2.3 |
| 2 | Teks tanggal-saja = UTC; `new Date(y, m, d)` = lokal | Tanggal mundur satu hari | Getter UTC atau satu standar | 1.2.3 |
| 3 | `QDate` lewat awal hari UTC; `QTime` membuat tanggal buatan | Hari bergeser, tanggal tak bermakna | `QDateTime` | 1.2.3 |
| 4 | `Array.isArray()` salah pada array-like C++ | Pemeriksaan tipe gagal | `Array.from(x)` | 1.2.4 |
| 5 | Mengubah isi `var` tak memicu pemberitahuan | Tampilan tak berubah | Tugaskan ulang | 1.2.4 |
| 6 | `0.1 + 0.2 !== 0.3` | Perbandingan salah | Toleransi | 1.2.1 |
| 7 | `5 / 2` adalah `2.5` | Hasil bukan bulat | `Math.floor` atau `Math.trunc` | 1.2.1 |
| 8 | `'5' + 3` adalah `'53'` | Penjumlahan jadi sambungan teks | `Number('5') + 3` | di sini |
| 9 | `Number('abc')` adalah `NaN`; `NaN !== NaN` | Nilai `NaN` merambat | `Number.isNaN` | di sini |
| 10 | `0 == ''` benar; `==` mengonversi | Kesamaan mengejutkan | Selalu `===` | di sini |
| 11 | `0`, `''`, `NaN`, `null`, `undefined` bernilai salah dalam `if` | Memeriksa “ada nilainya” keliru | Bandingkan eksplisit (`x !== undefined`) | di sini |
| 12 | `typeof null` adalah `'object'` | Pemeriksaan `null` salah | `x === null` | di sini |
| 13 | Epoch milidetik tak muat di `int` | Angka rusak | `real` atau `double` | 1.2.3 |
| 14 | `#aarrggbb`, bukan `#rrggbbaa` | Transparansi salah | Format Qt atau `Qt.rgba` | 1.2.2 |
| 15 | Tipe nilai disalin | Ubah salinan tak mengubah asli | Tugaskan ulang | 1.2.2 |
| 16 | `enumeration` tak bisa menjadi tipe properti | Galat deklarasi | `int` | 1.2.5 |

### d. Contoh 1: konversi JavaScript

Simpan sebagai `Konversi.qml`. **Tulis dulu dugaan Anda untuk tiap baris, baru jalankan.**

```qml
import QtQuick

Item {
    Component.onCompleted: {
        console.log('5' + 3, Number('5') + 3, '5' * 3);
        console.log(parseInt('42px', 10), parseFloat('3.14abc'), Number('42px'));
        console.log(0 == '', 0 === '', null == undefined, null === undefined);
        console.log(Boolean(0), Boolean(''), Boolean('0'), Boolean([]), Boolean(NaN));
        console.log(typeof null, typeof undefined, typeof [], typeof {});
        console.log(NaN === NaN, Number.isNaN(NaN));
        console.log(Number.MAX_SAFE_INTEGER, Math.pow(2, 31));
    }
}
```

| Ekspresi | Hasil menurut standar JavaScript | Pelajaran |
| --- | --- | --- |
| `'5' + 3` | `'53'` | `+` dengan teks menyambung |
| `Number('5') + 3` | `8` | Konversi eksplisit |
| `'5' * 3` | `15` | `*` memaksa angka; `+` tidak |
| `parseInt('42px', 10)` | `42` | Selalu beri radix 10 |
| `parseFloat('3.14abc')` | `3.14` | Berhenti di karakter tak valid |
| `Number('42px')` | `NaN` | `Number` ketat |
| `0 == ''` | `true` | `==` mengonversi |
| `0 === ''` | `false` | `===` tidak |
| `null == undefined` | `true` | Tetapi `null === undefined` adalah `false` |
| `Boolean(0)`, `Boolean('')`, `Boolean(NaN)` | `false` | Nilai “salah” |
| `Boolean('0')`, `Boolean([])` | `true` | Teks dan larik apa pun tak kosong, termasuk `'0'` |
| `typeof null` | `'object'` | Keanehan bahasa |
| `NaN === NaN` | `false` | Pakai `Number.isNaN` |
| `Number.MAX_SAFE_INTEGER` | `9007199254740991` | Batas bilangan bulat aman |
| `Math.pow(2, 31)` | `2147483648` | Satu di atas rentang `int` 32-bit |

Cocokkan hasil di terminal Anda dengan kolom tengah; bila ada yang berbeda, catat di `galat.md`.

### e. Contoh 2: konversi pada properti bertipe

Simpan sebagai `Tebak.qml`:

```qml
import QtQuick

Item {
    property int bulat: 0
    property real pecah: 0
    property string teks: ''
    property bool benar: false
    property size ukuran: Qt.size(0, 0)

    Component.onCompleted: {
        bulat = 3.7;
        console.log('bulat  =', bulat);
        pecah = 5 / 2;
        console.log('pecah  =', pecah);
        teks = 42;
        console.log('teks   =', teks, typeof teks);
        benar = 1;
        console.log('benar  =', benar);
        ukuran = '100x200';
        console.log('ukuran =', ukuran.width, ukuran.height);
    }
}
```

| Baris | Menguji | Hasil |
| --- | --- | --- |
| `bulat = 3.7` | Pecahan ke `int` | **\[amati\]** dipotong, dibulatkan, atau ditolak |
| `pecah = 5 / 2` | Hasil bagi ke `real` | `2.5` |
| `teks = 42` | Angka ke `string` | **\[amati\]** |
| `benar = 1` | Angka ke `bool` | **\[amati\]** |
| `ukuran = '100x200'` | Teks ke `size` | Dikonversi otomatis (didokumentasikan): `100` dan `200` |

Bagian terpenting latihan ini adalah **mencatat** perilaku sebenarnya di versi Qt Anda; jangan mengandalkan konversi diam-diam yang tidak Anda uji.

### f. Strategi aman

1. **Konversi di perbatasan.** Ubah data mentah (teks, JSON, nilai C++) ke tipe yang tepat **sekali**, di tempat ia masuk.
2. **Konversi eksplisit:** `Number(x)`, `String(x)`, `Boolean(x)`, `Math.round`, `Math.floor`.
3. **Bandingkan dengan `===`** dan periksa `undefined`, `null`, dan `NaN` secara eksplisit.
4. **Properti bertipe sebagai pagar:** biarkan engine menolak nilai yang salah, bukan `var` yang menerima segalanya.
5. **Satu standar waktu** (epoch atau ISO UTC) di seluruh aplikasi.
6. **Catat temuan** di `galat.md` (1.1.7).

### g. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Validasi masukan pengguna | `Number.isFinite(Number(x))` | Menolak `NaN` dan tak hingga |
| Konversi teks ke bulat | `parseInt(x, 10)` | Menerima akhiran non-angka |
| Konversi ketat | `Number(x)` | `NaN` bila ada karakter salah |
| Pembulatan | `Math.round`, `Math.floor`, `Math.trunc`, `toFixed(n)` | `toFixed` menghasilkan teks |
| Validasi bentuk data | Skema atau fungsi pemeriksa | Fase 7 |
| Konversi dari C++ | Tipe terketik di `Q_PROPERTY` | Fase 10 |

### h. Visual

```
  masukan mentah (teks / JSON / C++)
          |
   [KONVERSI EKSPLISIT di perbatasan]   Number() String() Date parse  Array.from()
          |
   properti BERTIPE (pagar)  --salah-->  galat, nilai ditolak
          |
   logika aplikasi (=== , toleransi, UTC)
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Konversi implisit | Perubahan tipe otomatis oleh bahasa atau engine |
| Konversi eksplisit | Perubahan tipe yang Anda tulis |
| Truthy / falsy | Nilai yang dianggap benar / salah dalam kondisi |
| `NaN` | Bukan angka |
| Koersi (coercion) | Pemaksaan tipe oleh operator |
| Perbatasan (boundary) | Tempat data dari luar masuk ke aplikasi |

### j. Tips dan praktik terbaik

- Jadikan `===` sebagai satu-satunya operator kesamaan Anda.
- Setelah membaca data luar, langsung konversi ke tipe terketik.
- Tulis uji kecil untuk tiap konversi yang Anda andalkan (Modul 12.3).
- Simpan daftar jebakan ini di `catatan.md` sebagai daftar periksa.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Penjumlahan menghasilkan sambungan teks | Salah satu operan `string` | `Number(...)` |
| `if (jumlah)` salah untuk `0` yang sah | Truthiness | `jumlah !== undefined` |
| `NaN` di layar | Konversi gagal tak diperiksa | `Number.isNaN` dan nilai cadangan |
| Hasil beda antar zona | Waktu lokal vs UTC | Standar tunggal |
| Mengabaikan jebakan di tabel | Menganggap “tidak akan terjadi” | Jadikan daftar periksa |

### l. Hubungan dengan modul lain

Prasyarat untuk Fase 2 (operator dan tipe JavaScript), Fase 3 (binding yang bergantung pada tipe), Fase 7 (data jaringan), Fase 10 (jembatan C++), dan Modul 12.3 (menguji konversi).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** (dari kurikulum, dilengkapi) Jalankan `Konversi.qml` dan `Tebak.qml`. Tulis dugaan Anda sebelum menjalankan, lalu bandingkan dan catat setiap selisih di `galat.md`. Pilih tiga jebakan dari tabel dan tulis satu uji kecil untuk masing-masing.

**Cek pemahaman.** (1) Mengapa `'5' + 3` menghasilkan `'53'` dan `'5' * 3` menghasilkan `15`? (2) Mengapa `==` sebaiknya dihindari? (3) Di mana tempat terbaik mengonversi data mentah?

### n. Referensi

- [Data Type Conversion Between QML and C++](https://doc.qt.io/qt-6/qtqml-cppintegration-data.html) · [QML Value Types](https://doc.qt.io/qt-6/qtqml-typesystem-valuetypes.html)
- [MDN: Equality comparisons and sameness](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Equality_comparisons_and_sameness) · [MDN: Falsy](https://developer.mozilla.org/en-US/docs/Glossary/Falsy)
- [JavaScript Host Environment (Qt)](https://doc.qt.io/qt-6/qtqml-javascript-hostenvironment.html)

---

## 1.2.7 Vektor, matriks, dan kuaternion \[TAMBAHAN\]

**Mengapa ditambahkan:** kurikulum menyebut tipe-tipe ini di tabel Modul 1.2 (“banyak dipakai di Qt Quick 3D dan shader”), tetapi tidak ada sub-bagian yang memperkenalkannya. Anda akan bertemu `Qt.vector3d` pada properti `axis` sebuah rotasi, pada uniform shader, dan di Qt Quick 3D; lebih baik mengenalnya sekarang secukupnya.

*Semangat: matematika di balik gerak dimulai dari satu anak panah.*

**Daftar isi 1.2.7:** a. Deskripsi dan peran · b. Konsep · c. Contoh 1: vektor dan matriks · d. Contoh 2: rotasi 3D pada item 2D · e. Presisi tunggal · f. Opsi lain · g. Visual · h. Terminologi · i. Tips · j. Kesalahan umum · k. Hubungan · l. Latihan dan cek · m. Referensi

### a. Deskripsi dan peran

Tipe-tipe ini adalah tipe nilai dari modul QtQuick untuk matematika spasial. Anda tidak akan sering menulisnya sekarang, tetapi mengenali bentuknya mencegah kebingungan ketika membaca kode transformasi, shader, dan 3D.

### b. Konsep

| Tipe | Isi | Pembuat |
| --- | --- | --- |
| `vector2d` | `x`, `y` | `Qt.vector2d(x, y)` |
| `vector3d` | `x`, `y`, `z` | `Qt.vector3d(x, y, z)` |
| `vector4d` | `x`, `y`, `z`, `w` | `Qt.vector4d(x, y, z, w)` |
| `matrix4x4` | Matriks 4 baris 4 kolom | `Qt.matrix4x4(...)` |
| `quaternion` | `scalar`, `x`, `y`, `z` | `Qt.quaternion(s, x, y, z)` |

Metode umumnya (nama persisnya ada di dokumentasi tiap tipe **\[amati\]**): vektor (`length()`, `normalized()`, `dotProduct()`, `crossProduct()` pada `vector3d`, `plus()`, `minus()`, `times()`), matriks (`translate()`, `rotate()`, `scale()`, `times()`, `inverted()`, `transposed()`), dan kuaternion (konversi dari dan ke sudut Euler). Seperti tipe nilai lain, semuanya **disalin** saat ditugaskan.

### c. Contoh 1: vektor dan matriks

Simpan sebagai `Vektor.qml`:

```qml
import QtQuick

Item {
    Component.onCompleted: {
        const a = Qt.vector3d(1, 0, 0);
        const b = Qt.vector3d(0, 1, 0);
        console.log('dot    :', a.dotProduct(b));
        console.log('cross  :', a.crossProduct(b));
        console.log('panjang:', Qt.vector3d(3, 4, 0).length());
        console.log('normal :', Qt.vector3d(3, 4, 0).normalized());

        const m = Qt.matrix4x4();
        m.translate(Qt.vector3d(10, 0, 0));
        console.log('matriks:', m);
    }
}
```

| Bagian | Arti |
| --- | --- |
| `Qt.vector3d(1, 0, 0)` | Vektor tiga dimensi (sumbu x). |
| `a.dotProduct(b)` | Hasil kali titik; `0` bila tegak lurus. |
| `a.crossProduct(b)` | Hasil kali silang: vektor tegak lurus keduanya (`(0, 0, 1)`). |
| `.length()`, `.normalized()` | Panjang (`5` untuk `(3, 4, 0)`) dan vektor satuan searah. |
| `Qt.matrix4x4()` | Matriks identitas bila tanpa argumen. |
| `m.translate(...)` | Menggeser matriks sejauh vektor itu. |

Hasil persis dan bentuk cetaknya **\[amati\]**.

### d. Contoh 2: rotasi 3D pada item 2D

Simpan sebagai `Putar.qml`:

```qml
import QtQuick

Item {
    width: 240
    height: 160

    Rectangle {
        id: kartu
        anchors.centerIn: parent
        width: 120
        height: 80
        color: '#89b4fa'

        transform: Rotation {
            origin.x: kartu.width / 2
            origin.y: kartu.height / 2
            axis: Qt.vector3d(0, 1, 0)
            angle: 45
        }
    }
}
```

| Bagian | Arti |
| --- | --- |
| `transform: Rotation { ... }` | Menerapkan transformasi pada item (Fase 4 dan 6). |
| `origin.x`, `origin.y` | Titik pusat putaran: tengah kartu. |
| `axis: Qt.vector3d(0, 1, 0)` | Sumbu putar: sumbu y; kartu tampak berputar seperti pintu. |
| `angle: 45` | Sudut putar dalam derajat. |

Ubah `axis` menjadi `Qt.vector3d(1, 0, 0)` dan `angle` menjadi `-30` untuk melihat sumbu lain.

### e. Presisi tunggal

Tipe vektor dan matriks ini dipetakan ke tipe Qt C++ yang menyimpan komponen sebagai bilangan **berpresisi tunggal (float)**, berbeda dari `real` yang berpresisi ganda. Akibatnya nilai seperti `0.1` dapat tampak sebagai `0.10000000149...` saat dicetak dari komponennya. Jangan membandingkan komponen vektor dengan `===`; pakai toleransi (1.2.1) **\[amati\]**.

### f. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Posisi 2D sederhana | `point`, `Qt.point(x, y)` | Presisi ganda |
| Perhitungan berat | Di C++ (`QVector3D`, `QMatrix4x4`, `QQuaternion`) | Fase 10 |
| Scene 3D | Qt Quick 3D | Fase 11; modul ber-lisensi GPLv3 pada Qt open source (0.1.3) |
| Transformasi 2D | `Translate`, `Rotation`, `Scale`, `Matrix4x4` | Fase 4 dan 6 |
| Uniform shader | Properti `vector4d`, `matrix4x4` pada `ShaderEffect` | Modul 11.3 |

### g. Visual

```
  vector3d a = (1,0,0)    vector3d b = (0,1,0)
  a . b  = 0   (tegak lurus)        a x b = (0,0,1)  (tegak lurus keduanya)

        y ^
          |  b
          +------> x
         /  a
        v z (a x b)

  Rotation { axis: (0,1,0); angle: 45 }  -> item berputar mengitari sumbu y
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| Vektor | Besaran dengan arah dan panjang |
| Hasil kali titik / silang | Operasi antarvektor (skalar / vektor baru) |
| Normalisasi | Menjadikan panjang vektor 1 |
| Matriks transformasi | Matriks yang menggeser, memutar, atau menskalakan |
| Kuaternion | Representasi rotasi 3D tanpa gimbal lock |
| Presisi tunggal / ganda | float 32-bit / double 64-bit |

### i. Tips dan praktik terbaik

- Mulailah dengan `Rotation` dan `axis` pada item 2D sebelum menyentuh matriks.
- Jangan menyimpan koordinat layar dalam vektor presisi tunggal bila perlu ketepatan; pakai `point` atau `real`.
- Bacalah halaman tipe sebelum memakai metode; nama dapat bergeser antar versi.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `Qt.vector3d` tak dikenal | `QtQuick` belum diimpor | `import QtQuick` |
| Perbandingan komponen gagal | Presisi tunggal | Toleransi |
| Rotasi tak tampak | Sudut atau sumbu salah, pusat di pojok | Atur `origin` |
| Mengira kuaternion sama dengan sudut Euler | Dua representasi berbeda | Konversi eksplisit |

### k. Hubungan dengan modul lain

Prasyarat untuk Fase 4 (transformasi item), Fase 6 (animasi sudut), Modul 11.3 (shader), Fase 11 (Qt Quick 3D), dan Fase 10 (tipe C++ padanan).

### l. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Vektor.qml` dan `Putar.qml`. Cocokkan hasil dot dan cross dengan hitungan tangan; ubah `axis` dan `angle`; lalu cetak `Qt.vector3d(0.1, 0, 0).x` dan catat presisinya **\[amati\]**.

**Cek pemahaman.** (1) Apa arti hasil kali titik nol? (2) Mengapa komponen vektor tak boleh dibandingkan dengan `===`? (3) Di mana tipe ini paling sering muncul?

### m. Referensi

- [QML Value Types](https://doc.qt.io/qt-6/qtqml-typesystem-valuetypes.html) · [Qt global object: pembuat vektor dan matriks](https://doc.qt.io/qt-6/qml-qtqml-qt.html)
- [Rotation](https://doc.qt.io/qt-6/qml-qtquick-rotation.html) · [Qt Quick 3D](https://doc.qt.io/qt-6/qtquick3d-index.html)
- [Wikipedia: Quaternion](https://en.wikipedia.org/wiki/Quaternion) · [3Blue1Brown: Essence of linear algebra](https://www.3blue1brown.com/topics/linear-algebra)

---

## 1.2.8 Memeriksa dan menegakkan tipe \[TAMBAHAN\]

**Mengapa ditambahkan:** kurikulum menyatakan bahwa tipe terketik lebih baik, tetapi belum membekali alat untuk **memeriksa** tipe sebuah nilai dan **menegakkan** tipe pada fungsi. Sejak Qt 6.7, anotasi tipe pada fungsi ditegakkan oleh engine, dan pragma tertentu mengatur perilakunya (1.1.1-d). Bagian ini menjadikannya kebiasaan.

*Semangat: kepastian tidak datang dari harapan, melainkan dari kontrak yang ditegakkan.*

**Daftar isi 1.2.8:** a. Deskripsi dan peran · b. Tiga lapis tipe · c. Contoh 1: anotasi fungsi · d. Contoh 2: memeriksa dengan `typeof`, `instanceof`, `as` · e. Alat statis: `qmllint` · f. Opsi lain · g. Visual · h. Terminologi · i. Tips · j. Kesalahan umum · k. Hubungan · l. Latihan dan cek · m. Referensi

### a. Deskripsi dan peran

Bagian ini menutup Modul 1.2 dengan pertanyaan praktis: *bagaimana saya tahu bahwa nilai ini bertipe yang saya kira, dan bagaimana saya membuat kode menolak tipe yang salah?*

### b. Tiga lapis tipe

| Lapis | Mekanisme | Kapan bekerja |
| --- | --- | --- |
| 1. Properti terketik | `property int jumlah` | Saat penugasan (galat bila salah; 1.2.1) |
| 2. Anotasi fungsi dan pernyataan tipe | `function f(a: int): string`, `x as Item` | Saat fungsi dipanggil atau saat pernyataan dievaluasi |
| 3. Analisis statis | `qmllint`, `qmlls`, kompiler QML | Sebelum program dijalankan |

Dokumentasi menyatakan bahwa anotasi pada fungsi **ditegakkan** oleh interpreter dan JIT sejak Qt 6.7; pragma `FunctionSignatureBehavior` (`Enforced` bawaan, `Ignored`) mengaturnya. Anotasi juga membantu alat dan kompiler QML (Qt Quick Compiler) menalar kode dan menghasilkan hasil yang lebih efisien.

### c. Contoh 1: anotasi fungsi

Simpan sebagai `Anotasi.qml`:

```qml
import QtQuick

Item {
    function tambah(a: int, b: int): int {
        return a + b;
    }

    function sapa(nama: string): string {
        return 'Halo, ' + nama;
    }

    Component.onCompleted: {
        console.log(tambah(2, 3));
        console.log(sapa('QML'));
        console.log(tambah('x', 3));
    }
}
```

| Bagian | Arti |
| --- | --- |
| `function tambah(a: int, b: int): int` | Fungsi dengan **tipe parameter** (`: int` setelah nama) dan **tipe hasil** (`: int` setelah tanda kurung). |
| `return a + b;` | Hasil harus cocok dengan tipe hasil. |
| `tambah(2, 3)` | Panggilan yang benar: `5`. |
| `sapa('QML')` | Parameter dan hasil bertipe `string`. |
| `tambah('x', 3)` | **Melanggar** anotasi: `'x'` bukan `int`. Pada Qt 6.7 ke atas, ia ditegakkan; catat apakah muncul galat, hasil apa yang keluar, dan apakah program berlanjut **\[amati\]**. |

Coba juga menambah `pragma FunctionSignatureBehavior: Ignored` di baris pertama dan ulangi; catat bedanya **\[amati\]**.

### d. Contoh 2: memeriksa dengan typeof, instanceof, as

Simpan sebagai `Periksa.qml`:

```qml
import QtQuick

Item {
    Rectangle { id: kotak; width: 10; height: 10 }

    Component.onCompleted: {
        console.log(kotak instanceof Rectangle, kotak instanceof Item, kotak instanceof Text);

        const t = kotak as Text;
        const r = kotak as Rectangle;
        console.log(t, r === kotak);

        console.log(typeof kotak, typeof kotak.width, typeof kotak.color);
        console.log(typeof Qt.point(1, 2), typeof Qt.rgba(0, 0, 0, 1), typeof new Date());
    }
}
```

| Bagian | Arti |
| --- | --- |
| `kotak instanceof Rectangle` | Apakah objek turunan tipe itu (mewarisi juga dihitung): dugaan `true`, `true`, `false`. |
| `kotak as Text` | **Pernyataan tipe**: bila objek bukan `Text`, hasilnya `null` (dugaan). |
| `kotak as Rectangle` | Bila cocok, hasilnya objek itu sendiri (`r === kotak`). |
| `typeof x` | Jenis nilai menurut JavaScript. Untuk angka `'number'`; untuk objek QML `'object'`; untuk tipe nilai seperti `color` dan `point` hasilnya perlu diamati **\[amati\]**. |

Sejak Qt 6.8, pragma `ValueTypeBehavior: Assertable` mengizinkan pernyataan tipe `as` juga pada tipe nilai (1.1.1-d). Hasil `typeof` untuk tipe nilai adalah salah satu hal yang paling baik **dicatat sendiri** di `galat.md`, bukan dihafal.

### e. Alat statis: qmllint

Tipe yang jelas membuat `qmllint` jauh lebih berguna. Bandingkan dua berkas:

```qml
import QtQuick

Item {
    property var nilai: 5

    function dobel(x) {
        return x * 2;
    }

    Component.onCompleted: console.log(dobel(nilai))
}
```

```qml
import QtQuick

Item {
    property int nilai: 5

    function dobel(x: int): int {
        return x * 2;
    }

    Component.onCompleted: console.log(dobel(nilai))
}
```

```bash
$ qmllint TakTerketik.qml
$ qmllint Terketik.qml
```

Simpan berturut-turut sebagai `TakTerketik.qml` dan `Terketik.qml`, jalankan keduanya, lalu catat peringatan yang muncul untuk masing-masing dan beda keduanya **\[amati\]**. Dalam proyek CMake, `qmlcachegen` dan target `all_qmllint` (0.2.7) memanfaatkan tipe yang sama; semakin terketik kode Anda, semakin sedikit yang harus ditebak alat.

### f. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Mematikan penegakan sementara (migrasi kode lama) | `pragma FunctionSignatureBehavior: Ignored` | Hanya sementara; bersihkan kodenya |
| Data yang memang bebas bentuk | `var` | Bungkus dalam fungsi terketik pada tepinya |
| Memeriksa bentuk objek `var` | Fungsi pemeriksa kecil (`typeof x.kunci === 'string'`) | Fase 7 |
| Tipe pada properti dari luar | `required property int x` | Modul 1.3 |
| Penjagaan tipe yang kuat | Tipe C++ terdaftar | Fase 10 |

### g. Visual

```
  nilai masuk --> [properti bertipe]   galat bila salah tipe
              --> [parameter bertipe]  ditegakkan sejak Qt 6.7 (FunctionSignatureBehavior)
              --> [x as Tipe]          null bila bukan Tipe
              --> [qmllint / qmlls]    peringatan SEBELUM dijalankan
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| Anotasi tipe | Penulisan tipe pada parameter dan hasil fungsi |
| Type assertion | Pernyataan bahwa nilai bertipe tertentu (`as`) |
| `instanceof` | Memeriksa keturunan tipe objek |
| `typeof` | Jenis nilai menurut JavaScript |
| Enforced / Ignored | Anotasi ditegakkan / diabaikan |
| Analisis statis | Pemeriksaan tanpa menjalankan |
| Kompiler QML | Pembuat bytecode atau C++ dari QML (Modul 11.5) |

### i. Tips dan praktik terbaik

- Beri anotasi tipe pada semua fungsi baru, dan pada fungsi lama saat Anda menyentuhnya.
- Perlakukan `var` sebagai perbatasan: terima di tepi, konversi ke tipe terketik, lalu gunakan di dalam.
- Bersihkan peringatan `qmllint` sampai nol sebagai kebiasaan (1.1.5).
- Catat hasil `typeof` tipe nilai di `galat.md`.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Galat saat memanggil fungsi dengan tipe salah | Anotasi ditegakkan sejak 6.7 | Perbaiki pemanggil, atau konversi dulu |
| `x as Tipe` bernilai `null` | Objek bukan tipe itu | Periksa `instanceof`, atau perbaiki asumsi |
| `typeof` mengejutkan pada tipe nilai | Tipe nilai tak selalu “primitif” | Catat dan jangan bergantung padanya |
| Peringatan lint tentang tipe tak dikenal | Modul belum diimpor atau tipe belum terdaftar | Periksa import dan `QML_FILES` |
| Mematikan penegakan lalu lupa | Pragma `Ignored` tertinggal | Cabut setelah migrasi |

### k. Hubungan dengan modul lain

Prasyarat untuk Modul 1.3 (`required property` dan alias), Fase 2 (fungsi JavaScript), Fase 3 (handler dan binding terketik), Modul 10 (tipe C++), Modul 11.5 (kompiler QML), dan Modul 12.2 (`qmllint`).

### l. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Anotasi.qml` dan `Periksa.qml`, lalu bandingkan `TakTerketik.qml` dan `Terketik.qml` dengan `qmllint`. Tulis tiga fungsi baru lengkap dengan anotasi, panggil masing-masing dengan argumen benar dan salah, dan catat perilaku sebenarnya di `galat.md`.

**Cek pemahaman.** (1) Apa tiga lapis penegakan tipe? (2) Apa yang dilakukan `x as Tipe` bila objek bukan tipe itu? (3) Mengapa menambah anotasi membantu `qmllint`?

### m. Referensi

- [Structure of a QML Document: pragma](https://doc.qt.io/qt-6/qtqml-documents-structure.html) · [QML Coding Conventions: type annotations](https://doc.qt.io/qt-6/qml-codingconventions.html)
- [Qt Quick Compiler](https://doc.qt.io/qt-6/qtqml-qtquick-compiler-tech.html) · [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html)
- [MDN: typeof](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/typeof) · [MDN: instanceof](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/instanceof)

---

## 4.6 Penutup Modul 1.2

**Daftar isi bagian ini:** 4.6.1 Peta konsep · 4.6.2 Latihan terpadu · 4.6.3 Cek pemahaman modul · 4.6.4 Hubungan ke modul berikutnya · 4.6.5 Pembaruan yang diusulkan untuk kurikulum · 4.6.6 Status

### 4.6.1 Peta konsep

```
   1.2.1 Primitif + url   -->  1.2.2 Geometri, warna, font
        |                        |
        +----------+-------------+
                   v
   1.2.3 date (UTC vs lokal)    1.2.4 list dan var (penugasan ulang)
                   |                 |
                   +--------+--------+
                            v
                      1.2.5 Enum  (int di balik layar)
                            |
                      1.2.6 Konversi dan jebakan  (daftar 16)
                            |
          1.2.7 Vektor / matriks / kuaternion     1.2.8 Menegakkan tipe
                            |
                            v
                  Modul 1.3 (properti, alias, atribut)
```

### 4.6.2 Latihan terpadu

Di folder `~/Development/qt-learning/fase1/tipe/` (30–45 menit), tanpa menyalin dari dokumen: (1) buat `Profil.qml` dengan properti terketik `string nama`, `int umur`, `real tinggi`, `date lahir`, `color warna`, `url foto`, dan satu `enum Peran`; (2) tulis fungsi beranotasi `umurDari(lahir)` yang menghitung umur dengan benar lintas zona waktu (uji `TZ=UTC` dan satu zona lain); (3) sengaja salahkan tiga tipe dan catat galatnya di `galat.md`; (4) jalankan `qmlformat`, `qmllint`, dan `qml Profil.qml` sampai bersih; (5) tulis `Konversi` dengan lima jebakan dari daftar dan perilaku nyata di mesin Anda; (6) commit dengan pesan bermakna.

### 4.6.3 Cek pemahaman modul

1. Sebut lima tipe nilai dan penyedianya (bahasa, QtQml, atau QtQuick).
2. Mengapa `0.1 + 0.2 === 0.3` salah, dan bagaimana membandingkannya?
3. Apa beda `url` dan `string` untuk `Image.source`?
4. Mengapa tidak ada tipe `time`, dan apa penggantinya?
5. Mengapa `new Date('2026-11-07')` dan `new Date(2026, 10, 7)` bisa berbeda?
6. Mengapa epoch milidetik tidak boleh disimpan di `int`?
7. Mengapa mengubah isi `var` tidak memicu `onXChanged`, dan apa pola aman untuk memperbaruinya?
8. Mengapa `enumeration` tidak bisa menjadi tipe properti, dan bagaimana menyimpannya?
9. Sebutkan empat jebakan konversi JavaScript dan cara menghindarinya.
10. Apa yang dilakukan anotasi tipe pada fungsi sejak Qt 6.7, dan bagaimana `qmllint` memanfaatkannya?

### 4.6.4 Hubungan ke modul berikutnya

| Modul | Mengandalkan dari 1.2 |
| --- | --- |
| 1.3 Properti, alias, atribut | Tipe untuk deklarasi `property`, `required`, `readonly`, `alias` (1.2.1–1.2.5) |
| 1.4 Komponen dan reuse | Properti terketik sebagai antarmuka komponen (1.2.8) |
| Fase 2 JavaScript | Tipe JavaScript, `Date`, `Array`, jebakan konversi (1.2.3, 1.2.4, 1.2.6) |
| Fase 3 Reaktivitas | Binding bertipe dan pemberitahuan perubahan (1.2.4) |
| Fase 4 dan 6 Visual dan animasi | `color`, `font`, `point`, `rect`, `easingCurve`, `Rotation` (1.2.2, 1.2.7) |
| Fase 7 Model dan data | `list`, `var`, `Array.from`, konversi data luar (1.2.4, 1.2.6) |
| Fase 10 Jembatan C++ | Konversi tipe, `QDateTime`, sequence type, `Q_ENUM` (1.2.3, 1.2.5) |

### 4.6.5 Pembaruan yang diusulkan untuk kurikulum

Tempelkan ke README Anda sebagai pengganti atau tambahan pada Modul 1.2.

**Terminologi (pengganti).** Mulai Qt 6.6/6.7 istilah dokumentasi adalah *value type* (tipe nilai), bukan *basic type*: tipe nilai disalin saat ditugaskan, dan tipe objek dirujuk. Penyedia: bahasa QML (`bool`, `int`, `real`, `double`, `string`, `url`, `date`, `var`, `variant`, `list`, `void`), QtQml (`point`, `rect`, `size`, `easingCurve`), dan QtQuick (`color`, `font`, `vector2d`, `vector3d`, `vector4d`, `matrix4x4`, `quaternion`; perlu `import QtQuick`).

**Daftar isi.** 1.2.1 Primitif dan `url` · 1.2.2 Geometri, warna, dan font · 1.2.3 `date` dan konversi `QDate`/`QTime` · 1.2.4 `list` dan `var` · 1.2.5 Enum · 1.2.6 Konversi dan jebakan · 1.2.7 Vektor, matriks, dan kuaternion · 1.2.8 Memeriksa dan menegakkan tipe

**Jebakan konversi (tambahan).** Teks tanggal-saja di JavaScript = awal hari UTC, sedangkan `new Date(y, m, d)` = lokal; `5 / 2` adalah `2.5`; `'5' + 3` adalah `'53'`; epoch milidetik tidak muat di `int`; bandingkan bilangan pecahan dengan toleransi; mengubah isi `var` tidak memicu pemberitahuan (tugaskan ulang); `#aarrggbb`, bukan `#rrggbbaa`.

**Cek pemahaman (jawaban lebih presisi).** (1) Pengganti `time`: gunakan `date` dan baca jam-menitnya, atau `int` detik bila hanya durasi. (2) Properti terketik lebih baik karena kesalahan tertangkap dini (galat saat nilai salah), tooling (`qmllint`, `qmlls`) dapat menalar, dan kompiler QML dapat menghasilkan kode lebih efisien.

**Referensi (ganti dan tambah).** [QML Value Types](https://doc.qt.io/qt-6/qtqml-typesystem-valuetypes.html) (menggantikan `...basictypes.html`) · [QML Enumerations](https://doc.qt.io/qt-6/qtqml-typesystem-enumerations.html) · [Data Type Conversion Between QML and C++](https://doc.qt.io/qt-6/qtqml-cppintegration-data.html)

### 4.6.6 Status

| Bagian | Status |
| --- | --- |
| Audit Fase 1 dan Modul 1.1 | Selesai |
| Modul 1.1 (1.1.1–1.1.7) | Selesai |
| Modul 1.2 (1.2.1–1.2.8) | **Selesai** |
| Modul 1.3 — Properti, Alias, dan Atribut Objek | Menunggu konfirmasi Anda |
| Modul 1.4 — Komponen dan Reuse | Setelah 1.3 |

---

## 5. Modul 1.3 — Properti, Alias, dan Atribut Objek

**Daftar isi bagian ini:** 5.1 Audit Modul 1.3 · 5.2 Deskripsi dan peran · 5.3 Filosofi modul · 5.4 Visual: anatomi atribut · 5.5 Estimasi waktu · lalu 1.3.1 sampai 1.3.9 · 5.6 Penutup Modul 1.3

### 5.1 Audit Modul 1.3

Diperiksa pada 7 November 2026 terhadap dokumentasi *QML Object Attributes* (Qt 6.12), *Property Shadowing and Override Semantics*, dan catatan komunitas. Kurikulum Modul 1.3 saya baca ulang sebelum audit ini.

**Terverifikasi (tidak perlu diubah):**

- Sintaks deklarasi properti, kini dengan tiga kata kunci tambahan: `[default] [virtual] [override] [final] [required] [readonly] property <tipe> <nama>`.
- Deklarasi properti otomatis membuat **signal perubahan** dan handler `on<Nama>Changed` (huruf pertama nama menjadi besar).
- `readonly` harus diberi nilai tetap atau binding saat inisialisasi dan tidak dapat diubah sesudahnya; penugasan menghasilkan `TypeError: Cannot assign to read-only property`. Properti `readonly` **tidak boleh** sekaligus `default`.
- `required` harus diisi saat instans dibuat. Menurut dokumentasi, pelanggaran yang dapat dideteksi statis membuat aplikasi tidak mau mulai; pada instansiasi dinamis (`Qt.createComponent`) hasilnya peringatan dan nilai `null`. **Nilai awal untuk properti `required` tidak boleh ditetapkan dari QML.**
- Alias tidak mengalokasikan penyimpanan baru; ia langsung merujuk properti lain, dan menulis ke alias berarti menulis ke targetnya.
- Sebuah objek hanya punya **satu** default property; objek anak yang ditulis langsung dalam objek lain masuk ke sana.
- Attached property dipasang **hanya pada objek yang bersangkutan**, tidak pada anak-anaknya.
- QML tidak punya modifier `private` (tidak ada dalam sintaks deklarasi); pola `QtObject` dengan `id` adalah pola umum, dan memang tidak ditegakkan oleh bahasa.

**Perlu dikoreksi atau dilengkapi:**

1. **Kata kunci `virtual`, `override`, `final` belum ada.** Sejak versi terbaru, menimpa properti dari tipe dasar tanpa penanda memunculkan peringatan, dan Qt menyarankan memakai nama yang unik. Ditambahkan sebagai 1.3.8.
2. **Bentuk `required <namaProperti>`** untuk menjadikan properti yang **sudah ada** (mis. `color` pada `Rectangle`) wajib diisi, belum disebut. Ditambahkan di 1.3.2.
3. **Batasan alias belum diajarkan.** Alias hanya boleh merujuk objek atau properti dalam cakupan tipenya; tidak boleh berisi ekspresi JavaScript; tidak boleh merujuk attached property; tidak boleh merujuk properti pada kedalaman tiga tingkat atau lebih (dua tingkat boleh); dan tidak memiliki tipe eksplisit, sehingga properti tambahan yang dideklarasikan inline pada objek sasaran tidak terlihat lewat alias. Ditambahkan di 1.3.3.
4. **Aturan default property perlu dilengkapi.** Ia hanya berguna untuk tipe `var`, tipe objek, dan tipe urutan; menulis anak secara implisit **dan** eksplisit pada default list property dalam satu objek menghasilkan urutan tak terdefinisi. Ditambahkan di 1.3.3.
5. **Group properties:** dokumentasi menyatakan bahwa notasi titik dan kurung hanya notasi, bukan jenis properti berbeda, dengan aturan berbeda bagi tipe nilai (harus dapat ditulis) dan tipe objek (objek tidak boleh null). Kedua bentuk tidak boleh dicampur untuk properti yang sama dalam satu objek. Ditambahkan di 1.3.4.
6. **Attached property pada anak** adalah kesalahan paling umum; solusinya mengaksesnya lewat `id` objek pemilik (`delegateItem.ListView.isCurrentItem`). Ditambahkan di 1.3.5.
7. **Pola `QtObject` ber-id `d` punya batas.** Ia bekerja bila akar komponen memiliki default property (mis. `Item`). Bila akarnya sendiri `QtObject`, laporan pengembang menyebut galat `Cannot assign to non-existent default property` **\[uji dulu\]**. Ditambahkan di 1.3.7.
8. **Cakupan sub-bagian.** Properti bertipe objek (`property Item target`), deklarasi signal, dan anotasi tipe pada metode belum punya tempat; ditambahkan di 1.3.1 dan 1.3.6.
9. **Koreksi untuk 1.2.5 (dokumen ini).** Saya sempat menulis bahwa acuan `Status.Loading` (tanpa nama enum) mungkin gagal. Dokumentasi menyatakan **kedua bentuk sah**: `<Tipe>.<Enum>.<Nilai>` dan `<Tipe>.<Nilai>`. Teks di 1.2.5 diperbaiki.
10. **Sub-bagian tambahan:** 1.3.8 (bayangan properti) dan 1.3.9 (lab galat properti, mengikuti pola 1.1.7).

**Daftar isi Modul 1.3 yang diperbarui:**

| No. | Judul | Asal |
| --- | --- | --- |
| 1.3.1 | Deklarasi dan tipe | Asli 1.3.1, diperluas |
| 1.3.2 | `readonly` dan `required` | Asli 1.3.2, diperluas |
| 1.3.3 | Alias dan default property | Asli 1.3.3, diperluas |
| 1.3.4 | Group properties | Asli 1.3.4, diperluas |
| 1.3.5 | Attached properties | Asli 1.3.5, diperluas |
| 1.3.6 | Handler perubahan `onXChanged`, signal, dan metode | Asli 1.3.6, diperluas |
| 1.3.7 | Pola private lewat `QtObject` | Asli 1.3.7, diperluas |
| 1.3.8 | Bayangan properti: `virtual`, `override`, `final` | **\[TAMBAHAN\]** |
| 1.3.9 | Lab galat properti | **\[TAMBAHAN\]** |

### 5.2 Deskripsi dan peran dalam kurikulum

Modul ini mengajarkan cara **mendefinisikan antarmuka sebuah tipe**: properti baru, properti yang wajib diisi dan yang tak boleh diubah, pintu pintas ke bagian dalam (alias), anak default, kelompok sub-properti, dan properti yang “ditempelkan” dari luar. Pada Modul 1.4 Anda akan memakai semuanya untuk membangun komponen yang rapi, dan di Fase 3 untuk menyambungkan perubahan antarobjek.

### 5.3 Filosofi modul

**Properti adalah kontrak antara sebuah tipe dan pemakainya.** Ia menyatakan apa yang boleh dibaca, apa yang boleh diubah, apa yang wajib diberikan, dan apa yang diumumkan ketika berubah. Semakin jelas kontraknya, semakin sedikit kejutan. Karena QML tidak punya `private`, **disiplin pengembanglah** yang menjaga batas antara antarmuka dan isi dalam.

### 5.4 Visual: anatomi atribut

```
  Panel.qml  (satu tipe)
 +--------------------------------------------------------------+
 | Rectangle {                                                    |
 |   id: root                              <- id (nama lokal)     |
 |   required property string judul        <- properti baru WAJIB  |
 |   readonly property int minimum: 10     <- properti baru TETAP  |
 |   property alias warnaLatar: root.color <- alias (pintu pintas) |
 |   default property alias isi: kolom.data <- anak masuk ke sini  |
 |   signal diklik                         <- signal               |
 |   function sapa() { }                   <- metode               |
 |   width: 240                            <- penugasan properti   |
 |   border { color: 'white'; width: 2 }   <- group property       |
 |   Layout.fillWidth: true                <- attached property    |
 |   onJudulChanged: console.log(judul)    <- handler perubahan    |
 |   Column { id: kolom }                  <- objek anak           |
 | }                                                              |
 +--------------------------------------------------------------+
```

### 5.5 Estimasi waktu

Jalur A: 10–12 jam; Jalur B: 4–5 jam.

---

## 1.3.1 Deklarasi dan tipe

*Semangat: setiap properti yang Anda deklarasikan adalah janji kepada pemakai tipe Anda.*

**Daftar isi 1.3.1:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh: berbagai tipe properti · d. Nilai awal dan perubahan · e. Tipe objek dan `var` · f. Opsi lain · g. Visual · h. Terminologi · i. Tips · j. Kesalahan umum · k. Hubungan · l. Latihan dan cek · m. Referensi

### a. Deskripsi dan peran

Bagian ini mengajarkan cara **menambah properti baru** pada sebuah tipe: sintaksnya, tipe yang boleh, nilai awal, dan fakta bahwa setiap properti baru otomatis mengumumkan perubahannya.

### b. Konsep dan filosofi

Sintaks lengkap (dokumentasi Qt 6.12):

```
[default] [virtual] [override] [final] [required] [readonly] property <tipe> <nama> [: <nilai>]
```

- **Nama** diawali huruf kecil, hanya huruf, angka, dan garis bawah, bukan kata cadangan JavaScript.
- **Tipe** dapat berupa tipe nilai apa pun kecuali `enumeration` (1.2), tipe objek QML (`Item`, `Rectangle`, atau tipe dari berkas Anda sendiri), atau `var`. Tipe yang disediakan QtQuick (mis. `color`, `font`) memerlukan `import QtQuick`.
- **Nilai awal** boleh digabung pada deklarasi (`property int jumlah: 3`) dan boleh berupa nilai tetap atau binding.
- Setiap properti yang dideklarasikan **otomatis** menciptakan signal perubahan dan handler `on<Nama>Changed`.
- Properti biasa **menyimpan nilainya sendiri** (berbeda dengan alias, 1.3.3).

**Filosofi:** properti adalah bagian dari **antarmuka publik** tipe Anda. Beri nama menurut peran, beri tipe sepersempit mungkin, dan pikirkan apakah pemakai boleh mengubahnya (`readonly`) atau wajib mengisinya (`required`).

### c. Contoh: berbagai tipe properti

Simpan sebagai `Deklarasi.qml`, jalankan `qml Deklarasi.qml`:

```qml
import QtQuick

Rectangle {
    id: root

    property string judul: 'Kartu'
    property int jumlah: 3
    property real harga: 12.5
    property real total: jumlah * harga
    property bool aktif: false
    property color aksen: '#89b4fa'
    property url ikon
    property date dibuat: new Date()
    property Item target
    property var bebas: ({ a: 1 })
    property list<Rectangle> kotak: [
        Rectangle { color: 'red' },
        Rectangle { color: 'blue' }
    ]

    width: 320
    height: 120
    color: root.aksen

    Text {
        anchors.centerIn: parent
        text: root.judul + ': ' + root.total
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.jumlah += 1
    }

    onJumlahChanged: console.log('jumlah ->', jumlah, 'total ->', total)

    Component.onCompleted: {
        console.log('ikon:', ikon, '| target:', target, '| bebas.a:', bebas.a);
        console.log('kotak:', kotak.length, '| aktif:', aktif, '| tahun:', dibuat.getFullYear());
    }
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `property string judul: 'Kartu'` | Properti teks baru dengan nilai awal. |
| `property real total: jumlah * harga` | Properti yang nilainya **binding**: otomatis dihitung ulang saat `jumlah` atau `harga` berubah. |
| `property url ikon` | Tanpa nilai awal: nilai bawaan tipenya (untuk `url`, kosong). |
| `property Item target` | Properti bertipe **objek**; bawaannya `null`. |
| `property var bebas: ({ a: 1 })` | Properti serbabisa; tanda kurung membuat objek literal (1.2.4). |
| `property list<Rectangle> kotak: [ ... ]` | Daftar objek `Rectangle`. |
| `onJumlahChanged: ...` | Handler signal perubahan `jumlahChanged`; terpanggil tiap `jumlah` berubah. |
| `MouseArea { onClicked: root.jumlah += 1 }` | Klik menambah `jumlah`; `total` ikut berubah karena binding. |
| `Component.onCompleted` | Mencetak nilai bawaan properti tanpa nilai awal. |

Nilai bawaan yang akan Anda lihat: `ikon` kosong, `target` `null`, `kotak.length` `2`, `aktif` `false` **\[amati\]**. Klik jendela dan perhatikan baris `jumlah -> ...` yang tercetak.

### d. Nilai awal dan perubahan

- Signal perubahan terpancar saat **nilai berubah**, bukan saat penugasan ulang dengan nilai yang sama.
- Pada pembuatan objek, nilai awal ditetapkan sebelum objek selesai; handler perubahan mungkin terpanggil beberapa kali pada tahap awal, sehingga logika yang bergantung pada “berubah” sebaiknya tidak mengandaikan urutan tertentu (Fase 3).
- Binding dan nilai tetap dapat diberikan lagi oleh pemakai tipe: `Deklarasi { jumlah: 5; harga: 20 }`.

### e. Tipe objek dan var

Menurut dokumentasi, tipe objek QML apa pun boleh menjadi tipe properti: `property Item target`, atau bahkan tipe dari berkas Anda sendiri (`property ColorfulButton tombol`). Keuntungannya: alat tahu isinya (`qmllint`, penyelesaian kode), dan nilai yang tidak cocok ditolak. `var` dapat menyimpan apa saja, termasuk daftar dan objek:

```qml
property var someNumber: 1.5
property var someList: [1, 2, 'tiga', 'empat']
property var someObject: Rectangle { width: 100; height: 100; color: 'red' }
```

Bila isinya sudah diketahui bentuknya, pilih tipe yang spesifik (1.2).

### f. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Nilai yang hanya dibaca pemakai | `readonly property` | 1.3.2 |
| Nilai yang wajib diisi pemakai | `required property` | 1.3.2 |
| Meneruskan properti objek lain | `property alias` | 1.3.3 |
| Menyimpan keadaan internal | Properti pada `QtObject` ber-id | 1.3.7 |
| Properti yang berasal dari C++ | `Q_PROPERTY` | Fase 10 |
| Menggabungkan beberapa nilai | Tipe majemuk (`point`, `rect`) atau tipe objek sendiri | 1.2.2 |

### g. Visual

```
  property int jumlah: 3          jumlahChanged()  --------+
       |                                                    |
       v                                                    v
  [ penyimpanan jumlah = 3 ]   <-- diubah:  root.jumlah += 1      onJumlahChanged: ...
       ^                                                    |
       |                                           binding yang membaca jumlah
  property real total: jumlah * harga   <---------  dihitung ulang otomatis
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| Properti kustom | Properti yang Anda deklarasikan di dokumen QML |
| Signal perubahan | `<nama>Changed`, terpancar saat nilai berubah |
| Handler perubahan | `on<Nama>Changed`, kode yang menanggapinya |
| Tipe objek | Tipe QML sebagai tipe properti (`Item`) |
| Nilai bawaan | Nilai bila tidak ada nilai awal |
| Penyimpanan | Tempat nilai disimpan; alias tidak punya penyimpanan sendiri |

### i. Tips dan praktik terbaik

- Beri tipe pada setiap properti; `var` hanya untuk data yang memang bebas bentuk.
- Urutkan deklarasi sesuai konvensi: `id`, properti, signal, fungsi, lalu penugasan (1.1.5).
- Beri nama berdasarkan peran, bukan bentuk.
- Gunakan binding untuk nilai turunan (`total`), bukan menghitungnya secara manual di banyak tempat.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Galat saat memuat: nilai bertipe salah | Tipe properti dan nilai tidak cocok | Periksa tipe (1.2.1) |
| `enumeration` ditolak sebagai tipe | Enum bukan tipe | `property int` (1.2.5) |
| `color` tak dikenal sebagai tipe | `QtQuick` belum diimpor | `import QtQuick` |
| Handler perubahan terpanggil terlalu sering | Menghitung ulang di setiap perubahan | Pakai binding, atau gabungkan |
| Nama properti diawali huruf besar | Salah penamaan | Mulai huruf kecil |
| Mengira nilai selalu `undefined` bila tidak diisi | Setiap tipe punya bawaan sendiri | Amati dan catat (`galat.md`) |

### k. Hubungan dengan modul lain

Prasyarat untuk 1.3.2 sampai 1.3.9, Modul 1.4 (properti sebagai antarmuka komponen), Fase 3 (binding dan handler), dan Fase 10 (`Q_PROPERTY`).

### l. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Deklarasi.qml`, klik beberapa kali, dan catat baris `jumlah -> ...`. Lalu: (1) tambahkan properti `property string label: judul + '!'` dan amati saat `judul` diubah; (2) tambahkan `property list<int> angka: [1, 2]` dan catat hasilnya **\[uji dulu\]**; (3) catat nilai bawaan properti yang tidak Anda beri nilai awal.

**Cek pemahaman.** (1) Apa yang otomatis terbentuk saat Anda mendeklarasikan properti? (2) Mengapa `enumeration` tidak bisa menjadi tipe properti? (3) Apa bedanya `property Item target` dan `property var target`?

### m. Referensi

- [QML Object Attributes: property attributes](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html) · [QML Value Types](https://doc.qt.io/qt-6/qtqml-typesystem-valuetypes.html)
- [QML Object Types](https://doc.qt.io/qt-6/qtqml-typesystem-objecttypes.html) · [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html)

---

## 1.3.2 readonly dan required

*Semangat: batas yang jelas membuat kolaborasi, bahkan dengan diri sendiri, menjadi mudah.*

**Daftar isi 1.3.2:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh: Kartu dengan `required` dan `readonly` · d. `required` pada properti yang sudah ada · e. `required` dan delegate · f. Memilih: nilai bawaan, `required`, `readonly` · g. Opsi lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

`required` menyatakan *“pemakai wajib mengisi ini”*; `readonly` menyatakan *“pemakai tidak boleh mengubah ini”*. Keduanya adalah cara bahasa menjaga kontrak sebuah tipe.

### b. Konsep dan filosofi

| Kata kunci | Artinya | Konsekuensi bila dilanggar |
| --- | --- | --- |
| `required` | Properti **harus** diberi nilai saat instans dibuat | Aplikasi tidak mau mulai bila terdeteksi statis; pada instansiasi dinamis: peringatan dan hasil `null` |
| `readonly` | Properti ditetapkan sekali (nilai tetap atau binding) dan **tak dapat diganti** | `TypeError: Cannot assign to read-only property` |

Aturan penting dari dokumentasi:

- Properti `required` **tidak boleh diberi nilai awal** dari QML (bertentangan dengan tujuannya).
- `readonly` harus diberi nilai tetap atau binding **pada deklarasi**. Binding tetap berjalan (nilainya mengikuti dependensinya), tetapi ekspresinya tak bisa diganti.
- `readonly` **tidak boleh** sekaligus `default`.

**Filosofi:** `required` lebih aman daripada nilai bawaan kosong (`''` atau `0`), karena nilai kosong **diam-diam sah** dan bug baru muncul belakangan; `required` memaksa kesalahan muncul **sejak awal** dan dengan pesan yang jelas.

### c. Contoh: Kartu dengan required dan readonly

Buat dua berkas. `Kartu.qml`:

```qml
import QtQuick

Rectangle {
    id: root

    required property string judul
    readonly property int minimum: 10
    readonly property int lebarDalam: width - 2 * minimum

    width: 240
    height: 90
    radius: 8
    color: '#89b4fa'

    Text {
        anchors.centerIn: parent
        text: root.judul + ' (dalam: ' + root.lebarDalam + ')'
    }
}
```

`UjiKartu.qml`:

```qml
import QtQuick

Column {
    spacing: 8

    Kartu { judul: 'Satu' }
    Kartu { judul: 'Dua'; width: 300 }
}
```

```bash
$ qml UjiKartu.qml
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `required property string judul` | Pemakai **wajib** mengisi `judul`; tanpa nilai awal. |
| `readonly property int minimum: 10` | Konstanta tipe; tak dapat diubah dari luar maupun dalam. |
| `readonly property int lebarDalam: width - 2 * minimum` | `readonly` dengan **binding**: tetap mengikuti perubahan `width`, tetapi pemakai tak bisa menimpanya. |
| `Kartu { judul: 'Satu' }` | Pemakaian benar: `required` terpenuhi. |
| `Kartu { judul: 'Dua'; width: 300 }` | `width` biasa boleh diubah; `lebarDalam` ikut menjadi 280. |

**Dua percobaan salah \[amati pesan dan exit code\]:**

```qml
// SalahRequired.qml
import QtQuick

Kartu { }
```

```qml
// SalahReadonly.qml
import QtQuick

Kartu {
    judul: 'Tiga'
    Component.onCompleted: minimum = 5
}
```

| Berkas | Dugaan |
| --- | --- |
| `SalahRequired.qml` | Gagal dimuat karena `judul` wajib belum diisi |
| `SalahReadonly.qml` | Jalan, lalu `TypeError: Cannot assign to read-only property` saat penugasan |

### d. required pada properti yang sudah ada

Bentuk `required <namaProperti>` menjadikan properti **yang sudah ada** wajib diisi:

```qml
// ColorRectangle.qml
import QtQuick

Rectangle {
    required color
}
```

Setiap pemakai `ColorRectangle` kini **wajib** menetapkan `color`. Berguna untuk komponen yang tidak masuk akal tanpa nilai tertentu.

### e. required dan delegate

Menurut dokumentasi, `required property` memainkan peran khusus pada model-view: bila delegate sebuah view punya properti `required` yang **namanya sama** dengan nama *role* model, properti itu otomatis diisi dari model. Ini cara modern dan aman untuk delegate (Fase 7). Dari C++, properti `required` dapat diisi lewat `QQmlComponent::createWithInitialProperties`, `QQmlApplicationEngine::setInitialProperties`, atau `QQuickView::setInitialProperties`.

### f. Memilih: nilai bawaan, required, readonly

| Situasi | Pilihan |
| --- | --- |
| Nilai masuk akal sebagai bawaan (ukuran, warna) | Properti biasa dengan nilai awal |
| Tanpa nilai dari luar komponen tidak bermakna (judul, data utama) | `required` |
| Nilai turunan yang tak boleh ditimpa (`lebarDalam`) | `readonly` dengan binding |
| Konstanta (`minimum`) | `readonly` |
| Hanya komponen sendiri yang boleh mengubah, tetapi pemakai boleh membaca | `readonly` + ubah lewat metode atau alias ke properti terpisah (1.3.7) |

### g. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Wajib diisi, dengan nilai bawaan | Tidak didukung bersama | Pilih salah satu |
| Validasi nilai yang masuk | `onXChanged` yang menolak atau menormalkan | Fase 3 |
| Properti hanya dibaca dari C++ | `Q_PROPERTY` tanpa setter (`READ` saja) | Fase 10 |
| Menyembunyikan dari pemakai | Properti pada `QtObject` ber-id (konvensi) | 1.3.7 |

### h. Visual

```
  Kartu { }                       -->  required judul belum diisi  --> GAGAL (aplikasi tak mulai)
  Kartu { judul: 'Satu' }         -->  OK
  Kartu { judul: 'x'
          Component.onCompleted: minimum = 5 }
                                  -->  TypeError: Cannot assign to read-only property

  required  = "WAJIB diisi"        readonly = "TIDAK boleh diubah"
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| `required property` | Properti yang wajib diisi pemakai |
| `readonly property` | Properti yang tak dapat diganti setelah inisialisasi |
| Nilai awal | Nilai pada deklarasi |
| Role (model) | Nama bidang data pada baris model |
| Instansiasi dinamis | Membuat objek saat berjalan (`Qt.createComponent`) |
| Kontrak | Aturan penggunaan sebuah tipe |

### j. Tips dan praktik terbaik

- Jadikan data utama sebuah komponen `required`; beri nilai bawaan hanya bila masuk akal.
- Gunakan `readonly` untuk konstanta dan nilai turunan; beri komentar bila alasannya tidak jelas.
- Biasakan menulis `required` di baris atas deklarasi agar kontrak terbaca sekilas.
- Gunakan `required` pada delegate (Fase 7), bukan akses implisit ke `modelData`.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Aplikasi tidak mau mulai | Properti `required` belum diisi | Isi pada setiap pemakaian |
| Nilai awal pada `required` ditolak | Dokumentasi melarangnya | Hapus nilai awal |
| `Cannot assign to read-only property` | Mengubah `readonly` dari luar atau dalam | Ubah desain: gunakan properti biasa, atau ubah lewat jalur lain |
| `readonly default property` galat | Kombinasi terlarang | Pilih salah satu |
| Mengira `readonly` mencegah baca | Hanya mencegah **menulis** | Gunakan `QtObject` internal untuk menyembunyikan (1.3.7) |

### l. Hubungan dengan modul lain

Prasyarat untuk Modul 1.4 (antarmuka komponen), Fase 3 (binding yang memicu perubahan), Fase 7 (delegate dengan `required`), dan Fase 10 (properti read-only dari C++).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Buat `Kartu.qml` dan `UjiKartu.qml`, jalankan, lalu jalankan `SalahRequired.qml` dan `SalahReadonly.qml` dan catat pesan serta exit code di `galat.md`. Tambahkan `ColorRectangle.qml` dengan `required color` dan pakai tanpa dan dengan `color`.

**Cek pemahaman.** (1) Mengapa `required` lebih aman daripada nilai bawaan kosong? (2) Apakah `readonly` mencegah pemakai membaca nilainya? (3) Apa fungsi `required color` pada `Rectangle`?

### n. Referensi

- [QML Object Attributes: required properties](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html) · [Read-Only Properties](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html)
- [Models and Views in Qt Quick](https://doc.qt.io/qt-6/qtquick-modelviewsdata-modelview.html) · [QQmlComponent::createWithInitialProperties](https://doc.qt.io/qt-6/qqmlcomponent.html#createWithInitialProperties)

---

## 1.3.3 Alias dan default property

*Semangat: pintu yang dirancang baik membuat rumah terasa luas.*

**Daftar isi 1.3.3:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh 1: alias · d. Batasan alias · e. Alias dan tipe · f. Default property · g. Contoh 2: `Panel.qml` dari kurikulum · h. Opsi lain · i. Visual · j. Terminologi · k. Tips · l. Kesalahan umum · m. Hubungan · n. Latihan dan cek · o. Referensi

### a. Deskripsi dan peran

Alias memungkinkan sebuah komponen **membuka sebagian isi dalamnya** sebagai properti publik, tanpa menyalin nilainya. Default property memungkinkan pemakai komponen menulis anak langsung di dalam kurung, tanpa menyebut properti tujuan. Keduanya adalah kunci komponen yang enak dipakai.

### b. Konsep dan filosofi

- **Alias adalah referensi, bukan penyimpanan.** Menurut dokumentasi, properti biasa mengalokasikan ruang penyimpanan baru; alias menghubungkan properti baru (*aliasing property*) langsung ke properti yang sudah ada (*aliased property*). Karena itu, **menulis ke alias berarti menulis ke targetnya.**
- Sintaks: `property alias <nama>: <rujukan alias>`; kata kunci `alias` menggantikan tipe, dan **rujukan wajib ada** saat deklarasi (tidak ada nilai awal opsional seperti properti biasa).
- **Default property** menerima objek yang ditulis langsung di dalam objek tanpa menyebut properti. Sebuah objek punya **satu** default property.

**Filosofi:** tulis komponen dengan **pintu yang sedikit dan jelas**: alias untuk bagian yang memang pantas dibuka, bukan untuk membongkar seluruh dalam komponen.

### c. Contoh 1: alias

Buat `Tombol.qml`:

```qml
import QtQuick

Rectangle {
    id: root

    property alias teksTombol: label.text
    property alias warnaTeks: label.color

    width: 140
    height: 40
    radius: 8
    color: '#89b4fa'

    Text {
        id: label
        anchors.centerIn: parent
    }
}
```

Dan `UjiTombol.qml`:

```qml
import QtQuick

Row {
    spacing: 10

    Tombol { teksTombol: 'Simpan' }
    Tombol { teksTombol: 'Batal'; warnaTeks: 'white'; color: '#f38ba8' }
}
```

```bash
$ qml UjiTombol.qml
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `property alias teksTombol: label.text` | Properti baru `teksTombol` yang **menunjuk** `label.text`. Tidak ada salinan teks tersimpan di `Tombol`. |
| `property alias warnaTeks: label.color` | Alias kedua, ke warna teks. |
| `Text { id: label }` | Anak yang dirujuk alias lewat `id` (1.1.4). |
| `Tombol { teksTombol: 'Simpan' }` | Pemakai mengatur teks **tanpa mengetahui** adanya `Text` di dalam. |
| `color: '#f38ba8'` | `color` adalah properti `Rectangle` sendiri, bukan alias. |

Dokumentasi menegaskan perbedaannya: bila `teksTombol` bukan alias melainkan properti biasa, mengubahnya **tidak** mengubah teks yang tampil, karena binding tidak dua arah. Dengan alias, mengubah `teksTombol` langsung mengubah `label.text`.

**Percobaan \[amati\]:** tambahkan di `UjiTombol.qml` sebuah handler `onTeksTombolChanged` pada salah satu `Tombol` dan ubah teksnya lewat `MouseArea`; catat apakah handler terpanggil.

### d. Batasan alias

Menurut dokumentasi Qt 6.12, alias:

| Batasan | Arti |
| --- | --- |
| Hanya merujuk objek atau properti **dalam cakupan tipenya** | Tidak boleh merujuk objek di luar berkas komponennya |
| Tidak boleh berisi ekspresi JavaScript sembarang | Hanya rujukan: `label.text`, bukan `label.text + '!'` |
| Rujukan **wajib** ada saat deklarasi | Tidak ada alias “kosong” |
| Tidak boleh merujuk **attached property** | Lihat 1.3.5 |
| Tidak boleh merujuk properti pada kedalaman **tiga tingkat atau lebih** | `a.b.c.d` ditolak; hingga dua tingkat (`rectangle.border.color`) boleh |
| Tidak boleh memiliki tipe eksplisit | Tipenya adalah tipe terdeklarasi dari targetnya |

Contoh batasan kedalaman dari dokumentasi:

```qml
property alias color: myItem.myRect.border.color   // tidak bekerja (tiga tingkat)
property alias color: rectangle.border.color       // bekerja (dua tingkat)
```

### e. Alias dan tipe

Karena alias tidak punya tipe sendiri, **properti tambahan** yang dideklarasikan inline pada objek sasaran tidak terlihat lewat alias:

```qml
// MyItem.qml
Item {
    property alias inner: innerItem

    Item {
        id: innerItem
        property int extraProperty
    }
}
```

```qml
// pemakai
MyItem {
    inner.extraProperty: 5   // GAGAL: inner hanya bertipe Item
}
```

Solusi menurut dokumentasi: jadikan objek dalam itu **komponen berkas sendiri** (misalnya `ExtraItem.qml` yang mendeklarasikan `extraProperty`), lalu `ExtraItem { id: innerItem }`; kini alias merujuk `ExtraItem` dan semua propertinya tersedia. Anda akan membuktikan kegagalan ini di lab 1.3.9.

### f. Default property

- Sebuah objek punya paling banyak **satu** default property. Objek yang ditulis langsung di dalam objek lain tanpa menyebut properti **otomatis** masuk ke sana.
- Menandai properti dengan `default` paling berguna untuk tipe `var`, **tipe objek**, dan tipe urutan; menandai `string` sebagai default tidak berguna karena hanya objek yang bisa ditugaskan secara implisit.
- Pada `Item`, default property adalah `data` (1.1.2); itulah sebabnya anak dapat ditulis tanpa `children:`.
- Pola umum: `default property alias isi: wadah.children` (dokumentasi) atau `.data` (kurikulum): objek anak yang ditulis pemakai dialihkan ke wadah di dalam komponen.
- **Peringatan dokumentasi:** pada satu definisi objek, jangan campur penugasan **implisit** dan **eksplisit** ke default list property; urutannya tidak terdefinisi.

```qml
Item {
    // Pakai salah satu: implisit ATAU eksplisit, bukan keduanya
    Rectangle { width: 40 }              // implisit
    data: [ Rectangle { width: 100 } ]   // eksplisit
}
```

### g. Contoh 2: Panel.qml dari kurikulum

Simpan sebagai `Panel.qml`:

```qml
import QtQuick

Rectangle {
    id: root

    required property string judul
    readonly property int minimum: 10
    property alias warnaLatar: root.color
    default property alias isi: kolom.data

    width: 240
    height: 120

    Column {
        id: kolom
        anchors.fill: parent

        Text { text: root.judul }
    }
}
```

`UjiPanel.qml`:

```qml
import QtQuick

Row {
    spacing: 12

    Panel { judul: 'Satu'; warnaLatar: '#89b4fa' }

    Panel {
        judul: 'Dua'
        warnaLatar: '#a6e3a1'

        Text { text: 'anak masuk ke kolom' }
    }
}
```

| Bagian | Arti |
| --- | --- |
| `required property string judul` | Wajib diisi (1.3.2). |
| `readonly property int minimum: 10` | Konstanta tipe (1.3.2). |
| `property alias warnaLatar: root.color` | Alias ke properti **milik root sendiri**; sah karena `root` berada dalam cakupan tipe ini. |
| `default property alias isi: kolom.data` | Anak yang ditulis pemakai dialihkan ke `kolom.data`. |
| `Column { id: kolom ... }` | Wadah yang menerima anak itu. |
| `Panel { judul: 'Dua' ... Text { ... } }` | `Text` pemakai **otomatis** ke dalam `kolom`, di bawah judul. |

Anak dialihkan ke `data`, bukan `children`: `data` menerima objek visual **dan** non-visual (mis. `Timer`), sedangkan `children` hanya objek visual. Pilih sesuai kebutuhan.

Catat apakah `Panel` yang mendeklarasikan default property baru sambil berakar `Rectangle` berjalan mulus di versi Anda **\[amati\]**.

### h. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Membuka satu bagian dalam | `property alias` | Paling ringan |
| Membuka bagian dalam yang bisa diganti pemakai | Properti bertipe `Component` atau `Item` | Fase 5 dan 9 (pola `contentItem`) |
| Anak pemakai ke satu tempat | `default property alias isi: wadah.data` | Pola panel |
| Anak pemakai ke beberapa tempat | Beberapa properti objek bernama (`header`, `footer`) | Pemakai mengisi satu per satu |
| Menyalin nilai, bukan meneruskan | Properti biasa dengan binding | Satu arah |
| Meneruskan banyak properti sekaligus | Beberapa alias, atau jadikan bagian dalam komponen publik | Hindari membongkar semuanya |

### i. Visual

```
  Tombol.qml                                          pemakai
 +------------------------------------------+         +------------------------------+
 |  property alias teksTombol: label.text    | <-----> |  Tombol { teksTombol: 'OK' } |
 |        |                                  |  menulis|                              |
 |        '------ referensi -------+         |  tembus |                              |
 |  Text { id: label; text: ...  <-'         |         +------------------------------+
 +------------------------------------------+

  alias  = pintu ke SATU tempat (tanpa salinan)
  default property alias = "anak pemakai masuk ke wadah ini"
```

### j. Terminologi

| Istilah | Arti |
| --- | --- |
| Alias (aliasing property) | Properti yang merujuk properti lain |
| Aliased property | Properti yang dirujuk |
| Rujukan alias | Ekspresi sederhana di sisi kanan deklarasi alias |
| Default property | Properti penerima anak yang ditulis tanpa nama properti |
| Penugasan implisit / eksplisit | Menulis anak langsung / menulis `data: [...]` |
| Cakupan tipe | Isi satu berkas komponen |

### k. Tips dan praktik terbaik

- Buka lewat alias hanya yang pemakai **perlu**; setiap alias adalah janji yang harus dijaga.
- Beri nama alias menurut peran bagi pemakai (`teksTombol`), bukan menurut asal (`labelText`).
- Gunakan satu default property per komponen, untuk anak pemakai.
- Bila alias terlalu banyak, pertimbangkan membuka satu objek bertipe jelas.

### l. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Alias ke properti yang tidak ada | Salah eja atau `id` salah | Periksa nama dan `id` |
| Alias berisi ekspresi | Mengira alias seperti binding | Pakai properti biasa dengan binding |
| Alias ke tiga tingkat | Melampaui batas | Jadikan bagian itu komponen sendiri, atau alias bertahap |
| Properti tambahan tak terlihat lewat alias | Alias tak bertipe | Komponen berkas sendiri |
| Campur anak implisit dan `data:` | Urutan tak terdefinisi | Pilih satu gaya |
| Default `string` tak berfungsi | Hanya objek yang masuk secara implisit | Tulis nama properti |

### m. Hubungan dengan modul lain

Prasyarat untuk Modul 1.4 (komponen), Fase 5 (komponen dan layout), Fase 8 (modul), dan Fase 9 (pola `contentItem` pada kendali).

### n. Latihan dan cek pemahaman

**Latihan 15 menit.** Buat `Tombol.qml` dan `Panel.qml`, dan pakai masing-masing dua kali; satu `Panel` berisi anak `Text`. Lalu: (1) ubah `default property alias` menjadi `.children` dan tambahkan sebuah `Timer` sebagai anak, catat hasilnya **\[amati\]**; (2) coba alias dengan ekspresi (`label.text + '!'`) dan catat galatnya **\[amati\]**.

**Cek pemahaman.** (1) Apa beda properti biasa dan alias? (2) Apa arti “menulis ke alias menulis ke targetnya”? (3) Mengapa `default property string` tidak berguna?

### o. Referensi

- [QML Object Attributes: property aliases](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html) · [default properties](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html)
- [Item: data dan children](https://doc.qt.io/qt-6/qml-qtquick-item.html) · [QML Object Types](https://doc.qt.io/qt-6/qtqml-typesystem-objecttypes.html)

---

## 1.3.4 Group properties

*Semangat: yang tersusun rapi di dalam, terbaca rapi di luar.*

**Daftar isi 1.3.4:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh 1: titik dan kurung · d. Tipe nilai dan tipe objek · e. Membuat group property sendiri · f. Aturan dan batasan · g. Opsi lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

Banyak properti punya **sub-properti**: `font` punya `pixelSize` dan `bold`; `border` punya `color` dan `width`; `anchors` punya `left` dan `margins`. Bagian ini menjelaskan cara menulisnya, apa yang terjadi di baliknya, dan cara membuat kelompok sendiri.

### b. Konsep dan filosofi

Menurut dokumentasi, notasi grup tersedia untuk **properti apa pun yang tipenya punya sub-properti**; ia adalah **notasi**, bukan jenis properti tersendiri. Dua bentuk:

```qml
Text { font.pixelSize: 12; font.bold: true }       // notasi titik
Text { font { pixelSize: 12; bold: true } }        // notasi kurung (grup)
```

**Filosofi:** kelompokkan hal yang berhubungan sebagai satu gagasan; baca dan tulis sebagai satu kesatuan.

### c. Contoh 1: titik dan kurung

Simpan sebagai `Grup.qml`:

```qml
import QtQuick

Rectangle {
    width: 320
    height: 140
    color: '#1e1e2e'

    Rectangle {
        border.color: 'white'
        border.width: 2
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        width: 100
        height: 60
        color: '#89b4fa'
    }

    Rectangle {
        border { color: 'white'; width: 2 }
        anchors {
            right: parent.right
            rightMargin: 20
            verticalCenter: parent.verticalCenter
        }
        width: 100
        height: 60
        color: '#f38ba8'
    }

    Text {
        anchors.centerIn: parent
        color: 'white'
        text: 'Grup'
        font { pixelSize: 18; bold: true }
    }
}
```

| Bagian | Arti |
| --- | --- |
| `border.color`, `border.width` | Dua sub-properti `border` dengan notasi titik. |
| `border { color: 'white'; width: 2 }` | Hasil yang sama dengan notasi kurung. |
| `anchors { right: ...; rightMargin: 20; verticalCenter: ... }` | Notasi kurung yang rapi untuk banyak sub-properti. |
| `font { pixelSize: 18; bold: true }` | Grup `font`. |

### d. Tipe nilai dan tipe objek

Notasinya sama, tetapi yang terjadi di baliknya berbeda (dokumentasi):

| Jenis isi properti | Contoh | Perilaku engine | Syarat |
| --- | --- | --- | --- |
| **Tipe nilai** | `font` | Engine **membaca** nilai, **mengubahnya**, lalu **menulis kembali** | Properti harus **dapat ditulis** |
| **Tipe objek** | `border`, `anchors` | Penugasan **ditulis ke objek** yang saat itu dipegang properti | Objek **tidak boleh null**; propertinya boleh read-only |

Menjadikan properti objek read-only adalah cara bagus mencegah kode QML mengganti objek tempat sub-properti berada; dokumentasi menyebutnya umumnya ide yang baik. Nama sub-properti diselesaikan menurut **tipe yang dideklarasikan** untuk properti, bukan tipe objek yang kebetulan dipegang saat runtime.

### e. Membuat group property sendiri

Anda dapat membuat kelompok sendiri dengan menjadikan sebuah **tipe objek** sebagai tipe properti. `Estetika.qml`:

```qml
import QtQuick

QtObject {
    property color warna: '#89b4fa'
    property int radius: 8
}
```

`KartuGaya.qml`:

```qml
import QtQuick

Rectangle {
    readonly property Estetika estetika: Estetika { }

    width: 200
    height: 80
    color: estetika.warna
    radius: estetika.radius
}
```

`UjiGaya.qml`:

```qml
import QtQuick

Row {
    spacing: 10

    KartuGaya { }
    KartuGaya { estetika.warna: '#f38ba8'; estetika.radius: 20 }
    KartuGaya { estetika { warna: '#a6e3a1'; radius: 0 } }
}
```

| Bagian | Arti |
| --- | --- |
| `Estetika.qml` | Tipe objek berisi sub-properti `warna` dan `radius`. |
| `readonly property Estetika estetika: Estetika { }` | Properti bertipe `Estetika`, diisi objek; `readonly` mencegah penggantian objeknya, tetapi sub-propertinya tetap dapat diatur. |
| `estetika.warna: '#f38ba8'` | Pemakai menulis sub-properti dengan notasi titik **ke objek yang dipegang**. |
| `estetika { warna: ...; radius: 0 }` | Notasi kurung yang setara. |

Perhatikan: karena nama sub-properti diselesaikan menurut tipe **terdeklarasi**, properti harus bertipe `Estetika`, bukan `QtObject`; bila tidak, `warna` tidak dikenal (bandingkan dengan masalah alias di 1.3.3-e).

### f. Aturan dan batasan

- **Jangan campur** penugasan objek utuh **dan** sub-properti untuk properti yang sama dalam satu definisi objek: pilih salah satu. Uji gabungan `font: Qt.font({ pixelSize: 20 })` dengan `font.bold: true` dan catat galatnya **\[amati\]**.
- Properti tipe nilai harus **dapat ditulis**; properti tipe objek boleh read-only.
- Objek yang dituju harus **tidak null** saat penugasan diterapkan.
- Untuk perubahan: perubahan satu sub-properti pada tipe **nilai** (seperti `font`) dicatat sebagai **satu** perubahan properti induk (1.2.2-e).

### g. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Satu sub-properti | Notasi titik | Paling ringkas |
| Banyak sub-properti | Notasi kurung | Lebih terbaca; konvensi Qt |
| Kelompok buatan sendiri | Tipe objek sebagai tipe properti | Bagian e |
| Menyalin seluruh kelompok | Tugaskan objek utuh (mis. `font: Qt.font({...})`) | Jangan campur dengan sub-properti |
| Kelompok dari C++ | `Q_PROPERTY` bertipe `QObject*` | Fase 10 |

### h. Visual

```
  Text {                                    Text {
      font.pixelSize: 12                        font { pixelSize: 12
      font.bold: true                                  bold: true }
  }                                         }
            \______________ sama ______________/

  font    (tipe NILAI)  : baca -> ubah -> tulis kembali      (properti harus dapat ditulis)
  border  (tipe OBJEK)  : tulis ke objek yang dipegang       (objek tidak boleh null)
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Group property | Properti yang memiliki sub-properti |
| Sub-properti | Atribut di dalam sebuah group property |
| Notasi titik / kurung | Dua cara menulis sub-properti |
| Tipe nilai / tipe objek | Disalin / dirujuk |
| Tipe terdeklarasi | Tipe yang dinyatakan pada deklarasi properti |

### j. Tips dan praktik terbaik

- Pakai notasi kurung bila menulis dua sub-properti atau lebih.
- Jadikan properti objek kelompok `readonly` bila pemakai tak perlu menggantinya.
- Bangun kelompok sendiri hanya bila ada beberapa properti yang memang satu gagasan.
- Beri nama kelompok menurut peran (`estetika`, `batas`).

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Sub-properti kelompok sendiri tidak dikenal | Properti bertipe `QtObject` | Tipe terdeklarasi harus tipe yang punya sub-properti |
| Galat saat mencampur objek utuh dan sub-properti | Dua bentuk pada properti yang sama | Pilih satu bentuk |
| Galat karena objek null | Properti objek belum diisi | Beri nilai awal objek |
| Galat menulis ke group tipe nilai | Properti read-only | Jadikan dapat ditulis |
| Menulis `onFont.pixelSizeChanged` | Tidak ada signal per sub-properti pada tipe nilai | `onFontChanged` |

### l. Hubungan dengan modul lain

Prasyarat untuk Fase 4 (`anchors`, `border`), Fase 5 (layout dan style), Fase 9 (tema dan palet), dan Fase 10 (properti objek dari C++).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Grup.qml` dan `UjiGaya.qml`. Lalu: (1) ubah `Estetika` menjadi bertipe `QtObject` pada `KartuGaya` dan catat galatnya; (2) tambahkan sub-properti `batas` ke `Estetika` dan pakai; (3) lakukan uji campuran di bagian f dan catat galatnya.

**Cek pemahaman.** (1) Apa bedanya group properti bertipe nilai dan bertipe objek? (2) Mengapa sub-properti diselesaikan menurut tipe terdeklarasi? (3) Mengapa properti objek kelompok sebaiknya `readonly`?

### n. Referensi

- [QML Object Attributes: grouped properties](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html) · [QML Value Types](https://doc.qt.io/qt-6/qtqml-typesystem-valuetypes.html)
- [QML Object Types](https://doc.qt.io/qt-6/qtqml-typesystem-objecttypes.html) · [QML Coding Conventions: grouped properties](https://doc.qt.io/qt-6/qml-codingconventions.html)

---

## 1.3.5 Attached properties

*Semangat: kadang yang dibutuhkan sebuah objek datang dari tempat ia berada, bukan dari dirinya.*

**Daftar isi 1.3.5:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh 1: `ListView.isCurrentItem` · d. Kesalahan paling umum: anak tidak punya attached · e. Yang sering Anda temui · f. Batasan · g. Opsi lain · h. Visual · i. Terminologi · j. Tips · k. Kesalahan umum · l. Hubungan · m. Latihan dan cek · n. Referensi

### a. Deskripsi dan peran

**Attached properties** dan **attached signal handlers** memungkinkan sebuah objek “dianotasi” dengan properti atau signal tambahan yang bukan miliknya, tetapi relevan karena **tempat ia berada**: sebuah delegate dalam `ListView` mengetahui apakah ia item terpilih; sebuah `Item` di dalam layout menyatakan perilaku ukurannya lewat `Layout`.

### b. Konsep dan filosofi

Bentuk penulisan (dokumentasi):

```
<TipeLekat>.<namaProperti>
<TipeLekat>.on<NamaSignal>
```

Sebuah tipe QML (biasanya dibuat di C++) dapat menyediakan **attaching type**; instansnya dipasang ke objek tertentu saat berjalan, sehingga objek itu dapat mengakses properti dan signalnya dengan awalan nama attaching type. Contoh yang paling sering: `Component.onCompleted` (attached signal handler dari tipe `Component`).

**Filosofi:** informasi yang bergantung pada **konteks** (bukan sifat bawaan objek) diberikan oleh konteksnya, sehingga objek yang sama dapat dipakai di konteks berbeda tanpa mengubah tipenya.

### c. Contoh 1: ListView.isCurrentItem

Simpan sebagai `Attached.qml`:

```qml
import QtQuick

ListView {
    width: 240
    height: 200
    model: 3
    currentIndex: 1

    delegate: Item {
        id: baris
        required property int index

        width: 220
        height: 40

        Rectangle {
            anchors.fill: parent
            anchors.margins: 4
            color: baris.ListView.isCurrentItem ? '#a6e3a1' : '#89b4fa'

            Text {
                anchors.centerIn: parent
                text: 'baris ' + baris.index
            }
        }
    }
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `ListView { model: 3 ... }` | Daftar dengan tiga baris; `model: 3` hanya membuat tiga entri bernomor (Fase 7). |
| `currentIndex: 1` | Baris kedua menjadi baris terpilih. |
| `delegate: Item { ... }` | Cetakan tiap baris; `Item` adalah **akar delegate**. |
| `required property int index` | `index` diisi otomatis dari model (1.3.2-e). |
| `baris.ListView.isCurrentItem` | **Attached property**: `ListView` adalah attaching type; `isCurrentItem` menyatakan apakah baris ini terpilih. Diakses lewat `id` pemilik. |
| `color: ... ? '#a6e3a1' : '#89b4fa'` | Operator kondisional: warna hijau untuk baris terpilih. |

### d. Kesalahan paling umum: anak tidak punya attached

Menurut dokumentasi, kesalahan paling umum adalah mengira attached property tersedia langsung pada **anak-anak** objek tempat ia dipasang. Itu **tidak benar**: instans attaching type hanya dipasang pada objek tertentu itu, bukan pada seluruh anaknya.

Ubah `Attached.qml` menjadi `SalahAttached.qml` dengan satu perubahan: ganti `baris.ListView.isCurrentItem` menjadi `ListView.isCurrentItem` di dalam `Rectangle` anak. Dokumentasi menyatakan versi itu **tidak bekerja** karena `ListView.isCurrentItem` hanya dipasang pada akar delegate **\[amati\]**: catat apa yang tampil (warna selalu sama) dan pesan galat atau peringatannya.

Perbaikannya sudah ada di contoh benar: beri `id` pada **akar delegate** dan akses lewat `id.Tipe.properti` (`baris.ListView.isCurrentItem`).

### e. Yang sering Anda temui

| Attached | Contoh | Dipakai untuk |
| --- | --- | --- |
| `Component` | `Component.onCompleted`, `Component.onDestruction` | Aksi setelah objek selesai dibuat atau sebelum dihancurkan |
| `ListView` | `ListView.isCurrentItem`, `ListView.view` | Informasi tentang delegate dalam daftar (Fase 7) |
| `Layout` | `Layout.fillWidth`, `Layout.preferredWidth` | Perilaku ukuran dalam layout (Fase 5; `import QtQuick.Layouts`) |
| `Keys` | `Keys.onPressed` | Penanganan tombol (Fase 6; butuh fokus) |

Contoh pemakaian `Layout` (Fase 5):

```qml
import QtQuick
import QtQuick.Layouts

RowLayout {
    width: 300
    height: 60

    Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: '#89b4fa' }
    Rectangle { Layout.preferredWidth: 80; Layout.fillHeight: true; color: '#f38ba8' }
}
```

| Bagian | Arti |
| --- | --- |
| `RowLayout` | Layout mendatar; menetapkan konteks bagi `Layout`. |
| `Layout.fillWidth: true` | Isi sisa lebar. |
| `Layout.preferredWidth: 80` | Lebar yang disukai 80. |
| `Layout.fillHeight: true` | Isi tinggi. |

### f. Batasan

- Attached property **tidak** tersedia pada anak pemilik (bagian d).
- **Alias tidak boleh** merujuk attached property (1.3.3-d).
- Attached property hanya bermakna di konteks yang menyediakannya: `Layout.fillWidth` di luar layout tidak berefek.
- Anda tidak mendefinisikan attached property di QML; ia disediakan oleh tipe C++ (Fase 10).

### g. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Mengetahui posisi dalam view | `ListView.isCurrentItem`, atau `required property bool current` dari model | Fase 7 |
| Mengatur perilaku dalam layout | Properti `Layout.*` | Fase 5 |
| Menjalankan kode setelah dibuat | `Component.onCompleted` | Hindari logika berat (0.0.2) |
| Mengirim informasi ke anak | Properti biasa pada pemilik, dirujuk lewat `id` | Jelas dan terketik |
| Menghindari attached | Properti `required` yang diisi model | Disarankan pada delegate |

### h. Visual

```
  ListView
    '-- delegate: Item { id: baris }        <-- ListView.* DIPASANG DI SINI
            '-- Rectangle                    <-- anak: TIDAK ada ListView.*  (salah: ListView.isCurrentItem)
                      benar:  baris.ListView.isCurrentItem   (lewat id pemilik)

  <TipeLekat>.<properti>      Layout.fillWidth     ListView.isCurrentItem
  <TipeLekat>.on<Signal>      Component.onCompleted
```

### i. Terminologi

| Istilah | Arti |
| --- | --- |
| Attached property | Properti yang dipasang ke objek oleh konteksnya |
| Attaching type | Tipe yang menyediakan properti itu (`ListView`, `Layout`) |
| Attached signal handler | Handler signal yang dipasang serupa (`Component.onCompleted`) |
| Akar delegate | Objek paling luar sebuah delegate |
| Konteks | Tempat objek berada (view, layout) |

### j. Tips dan praktik terbaik

- Beri `id` pada akar delegate dan rujuk attached lewat `id.Tipe.properti`.
- Pada delegate, utamakan `required property` untuk data dari model; pakai attached hanya untuk informasi view.
- Hindari `Component.onCompleted` untuk logika yang dapat dinyatakan dengan binding.

### k. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| `ListView.isCurrentItem` tidak bekerja di anak | Attached hanya pada akar delegate | `id` akar, lalu `id.ListView.isCurrentItem` |
| `Layout.fillWidth` tak berefek | Bukan anak langsung layout, atau `QtQuick.Layouts` tak diimpor | Periksa induk dan import |
| Alias ke attached ditolak | Larangan alias | Properti biasa dengan binding |
| `Component.onCompleted` berjalan terlalu dini | Komponen lain belum siap | Hindari bergantung urutan |
| Mengira attached dapat dideklarasikan di QML | Disediakan C++ | Fase 10 |

### l. Hubungan dengan modul lain

Prasyarat untuk Fase 5 (`Layout`), Fase 6 (`Keys`), Fase 7 (`ListView`, delegate, `required`), dan Fase 10 (membuat attached type di C++).

### m. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Attached.qml`, lalu `SalahAttached.qml`, dan catat bedanya. Ubah `currentIndex` dan amati. Jalankan contoh `RowLayout` dan ubah `Layout.preferredWidth` menjadi 160.

**Cek pemahaman.** (1) Mengapa `ListView.isCurrentItem` tidak bekerja di anak delegate? (2) Bagaimana mengaksesnya dengan benar? (3) Mengapa alias tidak boleh merujuk attached property?

### n. Referensi

- [QML Object Attributes: attached properties](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html) · [ListView](https://doc.qt.io/qt-6/qml-qtquick-listview.html)
- [Component (attached signals)](https://doc.qt.io/qt-6/qml-qtqml-component.html) · [Layout](https://doc.qt.io/qt-6/qml-qtquick-layouts-layout.html)
- [Providing attached properties (C++)](https://doc.qt.io/qt-6/qtqml-cppintegration-definetypes.html)

---

## 1.3.6 Handler perubahan onXChanged, signal, dan metode

*Semangat: yang tahu kapan sesuatu berubah, tahu kapan harus bertindak.*

**Daftar isi 1.3.6:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh: level yang berubah · d. Mendeklarasikan signal · e. Metode · f. Properti dengan “on” (modifier) · g. Binding atau handler? · h. Opsi lain · i. Visual · j. Terminologi · k. Tips · l. Kesalahan umum · m. Hubungan · n. Latihan dan cek · o. Referensi

### a. Deskripsi dan peran

Bagian ini mengajarkan tiga atribut yang berhubungan dengan **peristiwa dan tindakan**: handler perubahan (`onXChanged`), signal buatan sendiri, dan metode (fungsi). Ketiganya menjadikan sebuah tipe tidak hanya menyimpan data, tetapi juga **bereaksi** dan **berbicara**.

### b. Konsep dan filosofi

- Setiap properti mengumumkan perubahannya lewat signal `<nama>Changed`. Handlernya bernama `on<Nama>Changed` (huruf pertama nama menjadi besar). Ini berlaku juga untuk properti bawaan yang tidak didokumentasikan signalnya: `TextInput` yang punya `text` otomatis punya `onTextChanged`.
- Di dalam handler, Anda dapat memakai nama properti langsung (`text`), tetapi menyebut objeknya (`root.level`) lebih jelas.
- **Signal** adalah pemberitahuan bahwa sesuatu terjadi; **handler** adalah kode yang menanggapinya; **metode** adalah blok JavaScript yang dapat dipanggil.

**Filosofi:** objek **mengumumkan** apa yang terjadi padanya (signal), dan pihak lain **memilih** menanggapinya (handler). Objek tidak perlu tahu siapa yang mendengarkan: itulah yang membuat komponen terlepas satu sama lain (Fase 3).

### c. Contoh: level yang berubah

Simpan sebagai `Perubahan.qml`:

```qml
import QtQuick

Rectangle {
    id: root

    property int level: 0
    property string status: level > 5 ? 'tinggi' : 'rendah'

    signal naik(dari: int, ke: int)

    function ubah(delta: int) {
        root.level = Math.max(0, root.level + delta);
    }

    width: 280
    height: 120
    color: root.level > 5 ? '#f38ba8' : '#89b4fa'

    onLevelChanged: console.log('level ->', root.level, root.status)
    onNaik: (dari, ke) => console.log('naik dari', dari, 'ke', ke)

    Text {
        anchors.centerIn: parent
        text: 'level ' + root.level + ' (' + root.status + ')'
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            const lama = root.level;
            root.ubah(1);
            root.naik(lama, root.level);
        }
    }
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `property string status: level > 5 ? ... : ...` | Nilai turunan lewat **binding**; tidak perlu handler. |
| `signal naik(dari: int, ke: int)` | Deklarasi signal dengan dua parameter bertipe; gaya titik dua yang disarankan dokumentasi. |
| `function ubah(delta: int) { ... }` | Metode dengan parameter bertipe; `Math.max(0, ...)` menjaga level tak negatif. |
| `onLevelChanged: console.log(...)` | Handler perubahan: terpanggil tiap `level` berubah. |
| `onNaik: (dari, ke) => console.log(...)` | Handler signal buatan sendiri. Parameternya disebut pada fungsi panah; tipenya tidak perlu (signal sudah menentukan); fungsi panah tidak mendukung anotasi tipe. |
| `root.naik(lama, root.level)` | **Memancarkan** signal dengan memanggilnya seperti metode. |
| `const lama = root.level;` | Menyimpan nilai lama sebelum diubah. |

Klik jendela berkali-kali; amati urutan baris `level -> ...` dan `naik dari ... ke ...` di terminal, dan perubahan warna setelah level melewati 5.

### d. Mendeklarasikan signal

Sintaks (dokumentasi Qt 6.12):

```
signal <nama>[([<parameter>: <tipe>[, ...]])]
```

```qml
Item {
    signal clicked
    signal hovered()
    signal actionPerformed(action: string, actionResult: int)
}
```

- Tanda kurung boleh dihilangkan bila tidak ada parameter. Bila ada parameter, **tipenya wajib** dideklarasikan; tipe yang diizinkan sama dengan tipe properti.
- Gaya `signal batal(string aksi)` (tipe di depan, seperti properti) juga sah; untuk konsistensi dengan metode, utamakan gaya titik dua.
- Mendeklarasikan dua signal atau metode **bernama sama** dalam satu blok adalah galat; menggunakan kembali nama signal yang sudah ada pada tipe dasar diperbolehkan tetapi dapat menyembunyikannya (hati-hati).
- Menambah signal otomatis menambah handler `on<Signal>` dengan implementasi kosong.

### e. Metode

Sintaks:

```
function <nama>([<parameter>[: <tipe>][, ...]]) [: <tipeHasil>] { <badan> }
```

```qml
Rectangle {
    id: rect

    function hitungTinggi(): real {
        return rect.width / 2;
    }

    width: 100
    height: hitungTinggi()
}
```

| Bagian | Arti |
| --- | --- |
| `function hitungTinggi(): real` | Metode tanpa parameter dengan tipe hasil `real`. |
| `height: hitungTinggi()` | Memanggil metode di dalam binding: `height` akan dihitung ulang bila `width` berubah, karena `rect.width` dibaca di dalamnya. |

Menurut dokumentasi, parameter metode tanpa tipe dianggap `var`; **deklarasikan tipenya** untuk membantu `qmlcachegen` menghasilkan kode yang lebih cepat dan agar mudah dipelihara (1.2.8). Metode dapat dipanggil dari dalam komponen maupun dari objek lain yang memegang rujukannya.

### f. Properti dengan “on” (modifier)

Sintaks `Tipe on properti { ... }` membuat objek yang **bekerja pada properti yang sudah ada**:

```qml
Rectangle {
    width: 40
    height: 40
    NumberAnimation on x { from: 0; to: 200; duration: 1500; loops: Animation.Infinite }
}
```

`NumberAnimation on x` adalah deklarasi objek biasa yang menganimasikan `x` (Fase 6; sudah Anda pakai di 0.0.2). Bila properti sasaran bukan numerik, animasi tidak menghasilkan galat tetapi juga tidak menganimasikan apa pun; perilakunya ditentukan implementasi tipe itu.

### g. Binding atau handler?

| Situasi | Pilih |
| --- | --- |
| Nilai yang **selalu** merupakan fungsi dari nilai lain | **Binding** (`status: level > 5 ? ...`) |
| Aksi yang terjadi **ketika** sesuatu berubah (log, memanggil API, memulai animasi) | **Handler** (`onLevelChanged`) |
| Mengubah properti lain berdasarkan perubahan | Binding bila mungkin; handler bila perlu efek samping |
| Mengubah banyak properti sebagai respons satu kejadian | Handler atau fungsi |

Handler yang menugaskan properti lain **secara imperatif** dapat memutus binding yang ada (1.1.3-g); dan dua handler yang saling mengubah properti masing-masing dapat membentuk lingkaran tanpa akhir. Bila Anda mencobanya, jalankan dengan `timeout 3` (0.3.1) **\[amati\]**.

### h. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Menanggapi perubahan dari luar objek | `Connections { target: x; ... }` | Fase 3 |
| Menunda aksi sampai loop berikutnya | `Qt.callLater(fungsi)` | Fase 3 |
| Binding kondisional | `Binding { }` | Modul 3.1 |
| Menanggapi signal dari objek lain | Sambungkan lewat `Connections` atau `signalName.connect(...)` | Fase 3 |
| Logika panjang | Pindahkan ke fungsi atau berkas `.js` | 1.1.5 |

### i. Visual

```
  root.level = 6                              klik MouseArea
       |                                           |
       v                                           v
  levelChanged()  ---->  onLevelChanged: log      root.ubah(1);  root.naik(lama, baru)
       |                                                                |
       +--> binding: status, color, Text.text  (otomatis)               +--> onNaik: (dari, ke) => ...
```

### j. Terminologi

| Istilah | Arti |
| --- | --- |
| Signal | Pemberitahuan bahwa sesuatu terjadi |
| Handler | Kode yang menanggapi signal (`onNaik`) |
| Signal perubahan | `<nama>Changed`, otomatis untuk tiap properti |
| Memancarkan (emit) | Memanggil signal seperti metode |
| Metode | Fungsi milik objek |
| Fungsi panah | Penulisan fungsi `(a, b) => ...` |
| Modifier property (“on”) | Objek yang bekerja pada properti yang ada |

### k. Tips dan praktik terbaik

- Dahulukan binding; pakai handler untuk **aksi**, bukan untuk menghitung nilai.
- Beri nama signal sebagai kata kerja lampau atau peristiwa (`naik`, `diklik`).
- Deklarasikan tipe parameter signal dan metode.
- Jangan menaruh logika berat di handler perubahan; ia berjalan di thread GUI (0.0.2).

### l. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Handler tak terpanggil | Nama salah (`onlevelChanged`) | Huruf pertama nama menjadi besar: `onLevelChanged` |
| Binding “hilang” setelah handler | Penugasan imperatif memutusnya | Pakai binding, atau `Binding {}` (Modul 3.1) |
| Lingkaran perubahan tanpa akhir | Dua handler saling mengubah | Satu arah, atau penjaga nilai |
| Parameter signal tanpa tipe galat | Tipe wajib | Tulis `nama: tipe` |
| Dua signal atau metode sama nama | Dilarang dalam satu blok | Ganti nama |
| Fungsi panah dengan anotasi tipe ditolak | Tidak didukung | Tulis tipe di deklarasi signal, bukan di handler |

### m. Hubungan dengan modul lain

Prasyarat untuk Fase 3 (model objek dan reaktivitas: signal, `Connections`, binding), Fase 6 (interaksi dan animasi), Fase 2 (fungsi dan fungsi panah), dan Fase 10 (signal dan slot C++).

### n. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Perubahan.qml` dan klik. Lalu: (1) tambahkan `onStatusChanged` dan catat kapan ia terpanggil; (2) ubah `status` menjadi properti biasa yang diubah di `onLevelChanged` dan bandingkan perilakunya; (3) tambahkan signal `turun(dari: int, ke: int)` dan tombol yang menurunkan level.

**Cek pemahaman.** (1) Siapa yang membuat handler `onLevelChanged`? (2) Kapan memilih binding dan kapan handler? (3) Bagaimana memancarkan signal buatan sendiri?

### o. Referensi

- [QML Object Attributes: signals, handlers, methods](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html) · [Signal and Handler Event System](https://doc.qt.io/qt-6/qtqml-syntax-signals.html)
- [Property Binding](https://doc.qt.io/qt-6/qtqml-syntax-propertybinding.html) · [MDN: Arrow functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions)

---

## 1.3.7 Pola private lewat QtObject

*Semangat: batas yang Anda jaga sendiri adalah batas yang paling dapat dipercaya.*

**Daftar isi 1.3.7:** a. Deskripsi dan peran · b. Konsep dan filosofi · c. Contoh: penghitung dengan keadaan internal · d. Batas pola ini · e. Tingkat enkapsulasi · f. Opsi lain · g. Visual · h. Terminologi · i. Tips · j. Kesalahan umum · k. Hubungan · l. Latihan dan cek · m. Referensi

### a. Deskripsi dan peran

Bagian ini menjawab: *bagaimana menyembunyikan keadaan internal sebuah komponen dari pemakainya?* QML tidak punya `private`, tetapi ada pola yang efektif dalam batas tertentu.

### b. Konsep dan filosofi

Sintaks deklarasi properti di dokumentasi tidak memuat modifier `private`; semua properti sebuah tipe terlihat oleh pemakainya. Pola yang lazim:

- Simpan keadaan internal dalam sebuah anak `QtObject` ber-`id` pendek (mis. `d`).
- `id` hanya terlihat **di dalam satu dokumen** (1.1.4), sehingga pemakai di dokumen lain **tidak dapat** merujuk `d`.
- Ekspos hanya yang perlu lewat properti `readonly` dan metode publik.

**Filosofi:** enkapsulasi di QML adalah **perjanjian ditambah ruang lingkup**. Tidak ada penjaga, tetapi `id` yang tak terlihat dari luar memberi batas nyata antardokumen.

### c. Contoh: penghitung dengan keadaan internal

Simpan sebagai `Penghitung.qml`:

```qml
import QtQuick

Rectangle {
    id: root

    readonly property int jumlah: d.hitung
    readonly property bool penuh: d.hitung >= d.batas

    function tambah() {
        d.naikkan();
    }

    width: 220
    height: 80
    color: root.penuh ? '#f38ba8' : '#a6e3a1'

    QtObject {
        id: d

        readonly property int batas: 3
        property int hitung: 0

        function naikkan() {
            if (d.hitung < d.batas)
                d.hitung += 1;
        }
    }

    Text {
        anchors.centerIn: parent
        text: 'jumlah ' + root.jumlah
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.tambah()
    }
}
```

`UjiPenghitung.qml`:

```qml
import QtQuick

Penghitung {
    Component.onCompleted: {
        console.log(jumlah, penuh);
        console.log(typeof d);
    }
}
```

**Kata demi kata**

| Bagian | Arti |
| --- | --- |
| `QtObject { id: d ... }` | Objek non-visual tanpa tampilan yang menampung keadaan internal. |
| `readonly property int batas: 3` dan `property int hitung: 0` | Data internal di dalam `d`. |
| `function naikkan() { ... }` | Logika internal yang menjaga batas. |
| `readonly property int jumlah: d.hitung` | Antarmuka publik: **hanya baca**, mengikuti keadaan internal lewat binding. |
| `function tambah()` | Satu-satunya cara publik mengubah keadaan. |
| `typeof d` di `UjiPenghitung.qml` | Dugaan: `'undefined'`, karena `d` tidak terlihat di dokumen lain; **\[amati pesan atau hasil\]**. |

### d. Batas pola ini

- Pola ini bekerja karena akar komponen (`Rectangle`) punya **default property** yang menerima objek anak. Bila akar sendiri adalah `QtObject`, yang tidak punya default property, laporan pengembang menyebut anak `QtObject` langsung ditolak dengan galat `Cannot assign to non-existent default property` **\[uji dulu\]**. Solusinya: jadikan akar `Item`, atau deklarasikan properti bertipe objek (`property QtObject d: QtObject { ... }`) yang **terlihat** oleh pemakai (konvensi garis bawah `_d` hanya menandai niat).
- `d` bukan “private” sungguhan: tidak ada penjaga bahasa di **dalam** dokumen; semua kode di berkas itu dapat mengubahnya.
- Pemakai tetap dapat merusak hal-hal yang Anda ekspos sebagai properti biasa; karena itu jadikan antarmuka `readonly` bila mungkin.

### e. Tingkat enkapsulasi

| Tingkat | Mekanisme | Ditegakkan oleh |
| --- | --- | --- |
| Antardokumen | `id` hanya terlihat di dokumennya | Bahasa |
| Dalam dokumen | `QtObject` ber-`id` pendek (`d`) | Disiplin |
| Konvensi nama | Awalan garis bawah (`_hitung`) | Hanya konvensi; tidak ditegakkan |
| Antarmodul | Tipe internal dalam modul | Modul (Fase 8; periksa dokumentasi `qmldir`) |
| Sungguhan | Kelas C++ dengan anggota `private` | Kompiler (Fase 10) |

### f. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Keadaan internal sederhana | `QtObject` ber-`id` | Bagian c |
| Fungsi internal | Fungsi di dalam `QtObject` `d` | Tidak muncul di antarmuka tipe |
| Menyembunyikan seluruh tipe | Tipe internal modul | Fase 8 |
| Enkapsulasi kuat | Backend C++ | Fase 10 |
| Menandai “jangan sentuh” | Nama berawalan `_` | Hanya komunikasi antarpengembang |

### g. Visual

```
  Penghitung.qml  (satu dokumen)
  +---------------------------------------------------------+
  |  PUBLIK:   readonly jumlah   readonly penuh   tambah()    |
  |                  ^                ^              |       |
  |                  |  binding       |              v       |
  |  INTERNAL:  QtObject { id: d  hitung  batas  naikkan() } |
  +---------------------------------------------------------+
        ^
        |  id "d" TIDAK terlihat dari dokumen lain
  pemakai (UjiPenghitung.qml) hanya melihat antarmuka PUBLIK
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| Enkapsulasi | Menyembunyikan isi dalam di balik antarmuka |
| Antarmuka publik | Bagian yang boleh dipakai pemakai |
| Keadaan internal | Data milik komponen yang tak seharusnya disentuh |
| `QtObject` | Objek non-visual dasar QML |
| Konvensi | Kesepakatan yang tidak ditegakkan oleh alat |

### i. Tips dan praktik terbaik

- Beri `id: d` pada objek keadaan internal dan jangan menamainya dengan nama yang mengundang pemakaian dari luar.
- Ekspos data hanya lewat `readonly property` dan perubahan hanya lewat metode.
- Jangan mengekspos `d` lewat alias atau properti publik.
- Untuk komponen penting, tulis di komentar atas file apa antarmuka publiknya.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Galat saat menaruh `QtObject` di akar `QtObject` | Akar tak punya default property | Akar `Item`, atau properti bertipe objek |
| Pemakai mengubah keadaan internal | Mengekspos properti biasa | `readonly` dan metode |
| Mengira `d` private sungguhan | Salah paham | Anggap sebagai konvensi ditambah scope |
| `d` terlihat di alias | Alias ke `d` | Jangan membuat alias ke objek internal |
| Terlalu banyak keadaan internal | Komponen terlalu besar | Pecah komponen (1.4) |

### k. Hubungan dengan modul lain

Prasyarat untuk Modul 1.4 (antarmuka komponen), Fase 3 (reaktivitas dan keadaan), Fase 8 (tipe internal modul), dan Fase 10 (enkapsulasi di C++).

### l. Latihan dan cek pemahaman

**Latihan 15 menit.** Jalankan `Penghitung.qml` dan `UjiPenghitung.qml`. Lalu: (1) catat hasil `typeof d` di pemakai **\[amati\]**; (2) coba mengubah `jumlah` dari pemakai dan catat galatnya; (3) ubah akar menjadi `QtObject` dan catat galat atau keberhasilannya **\[uji dulu\]**.

**Cek pemahaman.** (1) Mengapa QML tidak punya `private` namun pola `QtObject` tetap berguna? (2) Mengapa `d` tidak terlihat dari dokumen lain? (3) Mengapa antarmuka sebaiknya `readonly`?

### m. Referensi

- [Scope and Naming Resolution](https://doc.qt.io/qt-6/qtqml-documents-scope.html) · [QML Object Attributes: property attributes](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html)
- [QtObject](https://doc.qt.io/qt-6/qml-qtqml-qtobject.html) · [Qt Interest: Best software engineering practices for QML (diskusi)](https://lists.qt-project.org/pipermail/interest/2024-September/039906.html)

---

## 1.3.8 Bayangan properti: virtual, override, final \[TAMBAHAN\]

**Mengapa ditambahkan:** deklarasi properti di Qt 6.12 kini mengenal kata kunci `virtual`, `override`, dan `final`, dan `qmllint` serta engine memperingatkan bila Anda **menimpa** properti dari tipe dasar tanpa penanda. Kurikulum belum menyebutnya, padahal dokumentasi menyatakan sebagian besar peringatan itu **akan menjadi galat** di masa depan.

*Semangat: nama yang unik menghindarkan kebingungan yang tidak perlu.*

**Daftar isi 1.3.8:** a. Deskripsi dan peran · b. Apa itu bayangan (*shadowing*) · c. Tiga kata kunci · d. Contoh · e. Aturan kombinasi · f. Opsi lain · g. Visual · h. Terminologi · i. Tips · j. Kesalahan umum · k. Hubungan · l. Latihan dan cek · m. Referensi

### a. Deskripsi dan peran

Saat sebuah tipe turunan mendeklarasikan ulang properti yang sudah dimiliki tipe dasarnya, terjadi *shadowing*. Bagian ini menjelaskan mengapa itu dihindari dan cara menyatakannya dengan sengaja bila memang perlu.

### b. Apa itu bayangan (shadowing)

Menurut dokumentasi, secara bawaan properti **dapat dibayangi**: Anda mendeklarasikan ulang properti di tipe turunan, mungkin dengan tipe dan atribut baru. Hasilnya **dua properti bernama sama**, dan hanya satu yang dapat diakses pada satu konteks. Dokumentasi menilai ini jarang diinginkan: sering tidak disengaja, efeknya membingungkan, dan buruk bagi alat. Karena itu, **utamakan nama yang unik** daripada menimpa.

### c. Tiga kata kunci

| Kata kunci | Arti |
| --- | --- |
| `virtual` | Properti **dimaksudkan untuk ditimpa** oleh tipe turunan |
| `override` | Properti ini **sengaja** menimpa properti `virtual` dari tipe dasar |
| `final` | Deklarasi ini **final**: boleh menimpa properti tipe dasar, tetapi **tidak boleh ditimpa lagi** |

Penimpaan secara otomatis mewarisi sifat virtual properti yang ditimpa. Dokumentasi menyarankan memakai `final` daripada `override` bila memungkinkan.

### d. Contoh

Buat tiga berkas. `Dasar.qml`:

```qml
import QtQuick

QtObject {
    virtual property int a: 1
    property int b: 2
    final property int c: 3
}
```

`Turunan.qml`:

```qml
import QtQuick

Dasar {
    override property int a: 10
    property int b: 20
}
```

`UjiTurunan.qml`:

```qml
import QtQuick

Item {
    Turunan { id: t }

    Component.onCompleted: console.log(t.a, t.b, t.c)
}
```

| Bagian | Arti |
| --- | --- |
| `virtual property int a: 1` | Properti yang boleh ditimpa. |
| `property int b: 2` | Properti biasa (tidak virtual). |
| `final property int c: 3` | Properti yang **tidak boleh** ditimpa. |
| `override property int a: 10` | Menimpa `a` secara sah dan sengaja. |
| `property int b: 20` | Menimpa properti yang bukan virtual: **peringatan** menurut dokumentasi. |

Jalankan `qml UjiTurunan.qml` dan `qmllint Turunan.qml`; catat peringatan dan kategori pesannya **\[amati\]**: dokumentasi `qmllint` mencantumkan kategori seperti *Property already exists in base type*, *Member shadows member*, dan *Member overrides a non-virtual member*. Lalu coba (satu per satu): tambahkan `property int c: 30` pada `Turunan` (menimpa properti `final`: galat), dan ganti `override` pada `a` menjadi `final` (sah).

### e. Aturan kombinasi

| Penulisan | Akibat (menurut dokumentasi) |
| --- | --- |
| `override property` pada properti yang tidak menimpa apa pun | Galat |
| `override` pada properti yang tidak `virtual` | Galat saat runtime atau lint |
| Menimpa properti `virtual` tanpa `override` atau `final` | Peringatan |
| Menimpa properti non-virtual tanpa penanda | Peringatan |
| Menimpa properti `final` | Galat |
| `virtual override` bersamaan | Galat penguraian (hapus `override`) |
| `virtual final` bersamaan | Galat penguraian (saling eksklusif) |
| `override final` bersamaan | Galat penguraian (hapus `override`) |

Dokumentasi menambahkan: sebagian besar peringatan akan menjadi galat di masa depan; tidak dijadikan galat sekarang demi kompatibilitas.

### f. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Menghindari bentrok | Beri nama unik (`lantaiBangunan`) | Disarankan |
| Mengubah nilai bawaan properti dasar | Tetapkan nilainya di turunan tanpa mendeklarasikan ulang | `width: 200` |
| Sengaja mengganti perilaku | `virtual` di dasar, `override` di turunan | Hanya bila perlu |
| Mengunci API | `final` | Mencegah penimpaan |
| Menyatakan properti wajib pada tipe dasar | `required color` | 1.3.2-d |

### g. Visual

```
  Dasar:    virtual a   |  b (biasa)   |  final c
                |            |             |
  Turunan:  override a    property b    (c tak boleh ditimpa)
               sah         PERINGATAN        GALAT bila dicoba

  prinsip:  nama UNIK  >  shadowing  ;  final  >  override
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| Shadowing (bayangan) | Mendeklarasikan ulang properti dengan nama yang sama di tipe turunan |
| Override | Penimpaan yang disengaja dan dinyatakan |
| `virtual` | Dapat ditimpa |
| `final` | Tidak dapat ditimpa lagi |
| Tipe dasar / turunan | Tipe yang diwarisi / yang mewarisi |

### i. Tips dan praktik terbaik

- Pilih nama unik; hindari menimpa.
- Tandai `final` pada properti yang tak ingin Anda izinkan ditimpa.
- Bersihkan peringatan `qmllint` tentang penimpaan hari ini; besok bisa menjadi galat.
- Dokumentasikan di komentar mengapa sebuah properti `virtual`.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Peringatan “property already exists in base type” | Mendeklarasikan ulang properti tipe dasar | Ganti nama, atau tandai `virtual`/`override`/`final` |
| Dua properti bernama sama dengan nilai berbeda | Shadowing tak disengaja | Nama unik |
| Galat menimpa properti `final` | Dilarang | Ganti nama |
| Kombinasi kata kunci ditolak | `virtual override`, `virtual final`, `override final` | Pakai satu penanda sesuai tabel |

### k. Hubungan dengan modul lain

Prasyarat untuk Modul 1.4 (komponen dengan turunan), Fase 5 dan 9 (menurunkan kendali), Fase 8 (API modul), dan Modul 12.2 (peringatan `qmllint`).

### l. Latihan dan cek pemahaman

**Latihan 15 menit.** Buat tiga berkas di bagian d, jalankan `qml UjiTurunan.qml` dan `qmllint Turunan.qml`, catat peringatan, lalu perbaiki dengan salah satu cara (ganti nama, atau `final`). Catat pesan di `galat.md`.

**Cek pemahaman.** (1) Apa itu shadowing dan mengapa dihindari? (2) Apa bedanya `override` dan `final`? (3) Mengapa dokumentasi menyarankan nama unik?

### m. Referensi

- [Property Shadowing and Override Semantics](https://doc.qt.io/qt-6/qtqml-syntax-overridesemantics.html) · [qmllint: property override warnings](https://doc.qt.io/qt-6/qmllint-warnings-and-errors-property-override.html)
- [QML Object Attributes: override semantics](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html)

---

## 1.3.9 Lab galat properti \[TAMBAHAN\]

**Mengapa ditambahkan:** kontrak sebuah tipe (`required`, `readonly`, alias, default property) baru terasa nyata ketika Anda **melanggarnya** dan membaca pesannya. Lab ini melanjutkan 1.1.7 untuk topik properti. Seperti sebelumnya, kolom dugaan adalah hipotesis, bukan jawaban.

*Semangat: batas yang pernah Anda uji adalah batas yang Anda pahami.*

**Daftar isi 1.3.9:** a. Deskripsi dan peran · b. Membuat berkas rusak · c. Menjalankan dan mencatat · d. Dugaan dan hasil · e. Memperluas `galat.md` · f. Opsi lain · g. Visual · h. Terminologi · i. Tips · j. Kesalahan umum · k. Hubungan · l. Latihan dan cek · m. Referensi

### a. Deskripsi dan peran

Lima belas pelanggaran kontrak properti yang paling umum, dijalankan satu per satu. Anda akan mencatat pesan galat, exit code, dan apakah `qmllint` menangkapnya sebelum dijalankan.

### b. Membuat berkas rusak

Simpan sebagai `buat-lab-properti.sh` di `~/Development/qt-learning/fase1/`, lalu `bash buat-lab-properti.sh`:

```bash
#!/usr/bin/env bash
set -eu
mkdir -p lab-properti
cd lab-properti

cat > Kartu.qml << 'EOF'
import QtQuick

Rectangle {
    id: root
    required property string judul
    readonly property int minimum: 10
    width: 200
    height: 60
    Text { anchors.centerIn: parent; text: root.judul }
}
EOF

cat > MyItem.qml << 'EOF'
import QtQuick

Item {
    property alias inner: innerItem
    Item {
        id: innerItem
        property int extraProperty
    }
}
EOF

cat > p01-required-hilang.qml << 'EOF'
import QtQuick

Kartu { }
EOF

cat > p02-readonly-ubah.qml << 'EOF'
import QtQuick

Kartu {
    judul: 'x'
    Component.onCompleted: minimum = 5
}
EOF

cat > p03-required-nilai-awal.qml << 'EOF'
import QtQuick

Item { required property int nilai: 5 }
EOF

cat > p04-alias-ekspresi.qml << 'EOF'
import QtQuick

Item {
    property alias teks: label.text + '!'
    Text { id: label }
}
EOF

cat > p05-alias-tiga-tingkat.qml << 'EOF'
import QtQuick

Item {
    property alias warna: myItem.myRect.border.color
    Item {
        id: myItem
        property Rectangle myRect: Rectangle { }
    }
}
EOF

cat > p06-alias-tanpa-rujukan.qml << 'EOF'
import QtQuick

Item { property alias nama }
EOF

cat > p07-alias-attached.qml << 'EOF'
import QtQuick

Item {
    id: root
    property alias kunciAktif: root.Keys.enabled
}
EOF

cat > p08-alias-properti-tambahan.qml << 'EOF'
import QtQuick

MyItem {
    inner.extraProperty: 5
}
EOF

cat > p09-dua-default.qml << 'EOF'
import QtQuick

Item {
    default property alias satu: a.data
    default property alias dua: b.data
    Item { id: a }
    Item { id: b }
}
EOF

cat > p10-campur-implisit-eksplisit.qml << 'EOF'
import QtQuick

Item {
    Rectangle { width: 40; height: 40 }
    data: [ Rectangle { width: 100; height: 100 } ]
}
EOF

cat > p11-group-campur.qml << 'EOF'
import QtQuick

Text {
    text: 'x'
    font: Qt.font({ pixelSize: 20 })
    font.bold: true
}
EOF

cat > p12-attached-di-anak.qml << 'EOF'
import QtQuick

ListView {
    width: 200
    height: 100
    model: 2
    delegate: Item {
        width: 100
        height: 40
        Rectangle {
            anchors.fill: parent
            color: ListView.isCurrentItem ? 'green' : 'gray'
        }
    }
}
EOF

cat > p13-signal-ganda.qml << 'EOF'
import QtQuick

Item {
    signal naik
    signal naik(x: int)
}
EOF

cat > p14-properti-kapital.qml << 'EOF'
import QtQuick

Item { property int Jumlah: 1 }
EOF

cat > p15-handler-salah-nama.qml << 'EOF'
import QtQuick

Item {
    property int level: 0
    onlevelChanged: console.log('berubah')
}
EOF

echo 'lab-properti/ dibuat: Kartu.qml, MyItem.qml, dan lima belas berkas p*.qml'
```

### c. Menjalankan dan mencatat

Simpan sebagai `jalankan-lab-properti.sh`:

```bash
#!/usr/bin/env bash
cd lab-properti || exit 1
mkdir -p log
for f in p*.qml; do
    timeout 3 qml "$f" &> "log/$f.log"
    kode=$?
    printf '%-34s exit=%s\n' "$f" "$kode"
    head -n 2 "log/$f.log" | sed 's/^/    /'
done
echo '--- qmllint ---'
for f in p*.qml; do
    echo "== $f"
    qmllint "$f" 2>&1 | head -n 3
done
```

```bash
$ bash buat-lab-properti.sh
$ bash jalankan-lab-properti.sh
```

| Bagian | Arti |
| --- | --- |
| `Kartu.qml`, `MyItem.qml` | Komponen pendukung untuk beberapa percobaan; berkas `p*.qml` menjalankannya. |
| Loop pertama | Menjalankan tiap berkas maksimal 3 detik, menyimpan log, dan mencetak exit code serta dua baris pertama log (1.1.7-d). |
| Loop kedua | Menjalankan `qmllint` pada tiap berkas, tiga baris pertama keluarannya. |

Exit code `124` berarti `qml` bertahan sampai `timeout` (aplikasi jalan); kode lain berarti berhenti sendiri.

### d. Dugaan dan hasil

Salin tabel ke `galat.md`, isi kolom **Hasil** dari terminal Anda, dan nilai tebakan Anda sendiri sebelum menjalankan:

| Berkas | Pelanggaran | Dugaan menurut dokumentasi | Hasil Anda |
| --- | --- | --- | --- |
| `p01-required-hilang` | Properti `required` tak diisi | Dimuat gagal (kelas 3) |  |
| `p02-readonly-ubah` | Menulis `readonly` | Jalan, lalu `TypeError: Cannot assign to read-only property` (kelas 4) |  |
| `p03-required-nilai-awal` | Nilai awal pada `required` | Ditolak |  |
| `p04-alias-ekspresi` | Alias berisi ekspresi | Ditolak (alias hanya rujukan) |  |
| `p05-alias-tiga-tingkat` | Alias tiga tingkat | Ditolak (batas dua tingkat) |  |
| `p06-alias-tanpa-rujukan` | Alias tanpa rujukan | Ditolak (rujukan wajib) |  |
| `p07-alias-attached` | Alias ke attached property | Ditolak |  |
| `p08-alias-properti-tambahan` | Properti tambahan lewat alias | Properti tidak dikenal (alias bertipe `Item`) |  |
| `p09-dua-default` | Dua default property | Ditolak (satu default) |  |
| `p10-campur-implisit-eksplisit` | Anak implisit dan `data:` bersamaan | Urutan tak terdefinisi; mungkin peringatan |  |
| `p11-group-campur` | `font:` utuh dan `font.bold` bersamaan | Belum diketahui **\[amati\]** |  |
| `p12-attached-di-anak` | `ListView` attached pada anak | Tak bekerja; amati warna dan pesan |  |
| `p13-signal-ganda` | Dua signal bernama sama | Ditolak |  |
| `p14-properti-kapital` | Nama properti berawalan huruf besar | Ditolak |  |
| `p15-handler-salah-nama` | `onlevelChanged` (huruf kecil) | Properti tidak dikenal |  |

Kelas galat bertambah satu untuk topik ini: **kelas 5, pelanggaran kontrak properti** (`required`, `readonly`, alias, default, group). Beberapa dari kelas 5 terdeteksi sebelum dijalankan (statis), beberapa baru saat runtime; catat di kolom “tertangkap qmllint?”.

### e. Memperluas galat.md

Tambahkan kolom **Kelas (1 sampai 5)** dan **Kontrak yang dilanggar** pada `galat.md` (1.1.7-f). Dalam beberapa bulan, tabel ini menjadi alat utama Anda membaca galat dengan cepat: *“ini kelas berapa, kontrak apa, perbaikan apa”*.

### f. Opsi lain

| Kebutuhan | Opsi | Catatan |
| --- | --- | --- |
| Mengulang lab setelah memperbarui Qt | Jalankan skrip dan `diff` terhadap log lama | Mendeteksi perubahan pesan |
| Lab untuk modul sendiri | Salin pola ke kontrak komponen Anda | Uji bahwa pelanggaran memang ditolak |
| Mengotomatiskan | Skrip di CI | Modul 12.3 |
| Menambah kasus | Tambah `p16-...` dan seterusnya | Satu pelanggaran per berkas |

### g. Visual

```
  kontrak properti dilanggar
       |
   [required hilang]        --> gagal dimuat            (statis atau saat memuat)
   [readonly ditulis]       --> TypeError saat runtime
   [alias melanggar batas]  --> galat deklarasi         (ekspresi, 3 tingkat, tanpa rujukan, attached)
   [dua default]            --> galat deklarasi
   [campur implisit/eksplisit] --> urutan tak terdefinisi / peringatan
   [attached di anak]       --> tak bekerja (diam atau peringatan)
```

### h. Terminologi

| Istilah | Arti |
| --- | --- |
| Kontrak properti | Aturan penggunaan: `required`, `readonly`, alias, default |
| Pelanggaran kontrak | Penggunaan yang ditolak atau memberi peringatan |
| Statis / runtime | Terdeteksi sebelum dijalankan / saat berjalan |
| Regresi pesan | Pesan galat berubah antar versi |

### i. Tips dan praktik terbaik

- Tulis dugaan **sebelum** menjalankan; belajar terbesar ada pada dugaan yang salah.
- Simpan lab dan log di repositori (kecuali `lab-properti/log/` yang masuk `.gitignore`).
- Ulangi lab setelah memperbarui Qt.
- Tambahkan kasus baru tiap bertemu galat kontrak yang belum tercatat.

### j. Kesalahan umum dan solusi

| Gejala | Penyebab | Solusi |
| --- | --- | --- |
| Semua berkas keluar 124 | Berkas sah bertahan sampai `timeout` | Periksa log untuk peringatan |
| `p10` tampak normal | Hanya urutan yang tak terdefinisi | Bandingkan beberapa kali |
| Pesan berbeda dari dugaan | Dugaan hanya hipotesis | Catat pesan sebenarnya |
| Skrip berhenti | `set -eu` menangkap kesalahan | Baca pesan skrip |

### k. Hubungan dengan modul lain

Prasyarat untuk Modul 1.4 (komponen yang kontraknya Anda tulis sendiri), Fase 3 (reaktivitas), dan Modul 12.2 sampai 12.3 (lint dan uji otomatis untuk kontrak).

### l. Latihan dan cek pemahaman

**Latihan 30 menit.** Buat dan jalankan lab, isi tabel dengan dugaan lebih dulu, lalu isi hasil, dan commit skrip dan `galat.md`. Pilih tiga pelanggaran dan tulis bagaimana desain komponen yang baik mencegahnya.

**Cek pemahaman.** (1) Pelanggaran mana yang terdeteksi saat memuat dan mana saat runtime? (2) Mengapa nilai awal pada `required` ditolak? (3) Mengapa alias tak boleh berisi ekspresi?

### m. Referensi

- [QML Object Attributes](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html) · [qmllint](https://doc.qt.io/qt-6/qtqml-tooling-qmllint.html)
- [Property Shadowing and Override Semantics](https://doc.qt.io/qt-6/qtqml-syntax-overridesemantics.html) · [Debugging QML Applications](https://doc.qt.io/qt-6/qtquick-debugging.html)

---

## 5.6 Penutup Modul 1.3

**Daftar isi bagian ini:** 5.6.1 Peta konsep · 5.6.2 Latihan terpadu · 5.6.3 Cek pemahaman modul · 5.6.4 Hubungan ke modul berikutnya · 5.6.5 Pembaruan yang diusulkan untuk kurikulum · 5.6.6 Status

### 5.6.1 Peta konsep

```
   1.3.1 Deklarasi dan tipe  (properti baru, signal perubahan otomatis)
        |
   1.3.2 readonly / required  (kontrak: tak boleh diubah / wajib diisi)
        |
   1.3.3 Alias dan default property  (pintu ke dalam, anak ke wadah)
        |
   1.3.4 Group properties   1.3.5 Attached properties
        |                         |
        +------------+------------+
                     v
   1.3.6 Handler perubahan, signal, metode   1.3.7 Pola QtObject d
                     |
   1.3.8 Shadowing / virtual / override / final
                     |
   1.3.9 Lab galat properti --> galat.md (kelas 5)
                     |
                     v
               Modul 1.4 (komponen dan reuse)
```

### 5.6.2 Latihan terpadu

Di folder `~/Development/qt-learning/fase1/komponen/` (45–60 menit), tanpa menyalin: (1) tulis `KartuProfil.qml` dengan `required property string nama`, `readonly property int minimum`, `property alias foto: gambar.source`, dan `default property alias isi: kolom.data`; (2) beri satu group property buatan sendiri (`estetika`, 1.3.4-e); (3) simpan keadaan internal di `QtObject { id: d }`; (4) deklarasikan satu signal dan satu metode beranotasi; (5) tulis `UjiKartuProfil.qml` yang memakai komponen itu tiga kali (dengan dan tanpa anak, dengan nilai berbeda); (6) jalankan `qmlformat`, `qmllint`, dan `qml`; (7) sengaja langgar dua kontrak, catat di `galat.md`; (8) commit dengan pesan bermakna.

### 5.6.3 Cek pemahaman modul

1. Tulis sintaks deklarasi properti lengkap dan jelaskan tiap kata kuncinya.
2. Apa yang otomatis terbentuk saat properti dideklarasikan?
3. Apa bedanya `required` dan `readonly`? Mengapa nilai awal pada `required` ditolak?
4. Apa bedanya alias dan properti biasa? Sebutkan empat batasan alias.
5. Mengapa `property alias warna: myItem.myRect.border.color` ditolak, dan apa penggantinya?
6. Apa itu default property, dan mengapa tidak boleh mencampur anak implisit dan eksplisit?
7. Apa bedanya group property bertipe nilai dan bertipe objek?
8. Mengapa `ListView.isCurrentItem` tidak bekerja di anak delegate, dan bagaimana mengaksesnya?
9. Kapan memakai binding, dan kapan handler `onXChanged`?
10. Bagaimana pola `QtObject` ber-`id: d` menyembunyikan keadaan internal, dan apa batasnya?

### 5.6.4 Hubungan ke modul berikutnya

| Modul | Mengandalkan dari 1.3 |
| --- | --- |
| 1.4 Komponen dan reuse | Antarmuka komponen: `required`, alias, default property, group, `d` (1.3.2–1.3.7) |
| Fase 3 Reaktivitas | Binding, handler perubahan, signal, `Connections` (1.3.1, 1.3.6) |
| Fase 5 dan 9 | Properti `Layout` (attached), pola `contentItem`, menurunkan kendali (1.3.5, 1.3.8) |
| Fase 7 Model dan view | `required property` pada delegate, `ListView.*` (1.3.2, 1.3.5) |
| Fase 8 Modul | Tipe internal, API modul, `final` (1.3.7, 1.3.8) |
| Fase 10 C++ | `Q_PROPERTY`, attached type di C++, enkapsulasi sungguhan (1.3.5, 1.3.7) |
| Modul 12.2 | Peringatan `qmllint` tentang shadowing dan akses (1.3.8) |

### 5.6.5 Pembaruan yang diusulkan untuk kurikulum

Tempelkan ke README Anda sebagai pengganti atau tambahan pada Modul 1.3.


**Daftar isi.** 1.3.1 Deklarasi dan tipe · 1.3.2 `readonly` dan `required` · 1.3.3 Alias dan default property · 1.3.4 Group properties · 1.3.5 Attached properties · 1.3.6 Handler perubahan `onXChanged`, signal, dan metode · 1.3.7 Pola private lewat `QtObject` · 1.3.8 Bayangan properti: `virtual`, `override`, `final` · 1.3.9 Lab galat properti

**Terminologi (tambahan).** Sintaks deklarasi: `[default] [virtual] [override] [final] [required] [readonly] property <tipe> <nama>`; `required <properti>` (menjadikan properti yang sudah ada wajib diisi); shadowing (mendeklarasikan ulang properti tipe dasar); attached property hanya dipasang pada objek bersangkutan, bukan anak-anaknya.

**Batasan alias (tambahan).** Alias hanya merujuk objek atau properti dalam cakupan tipenya; tidak boleh berisi ekspresi JavaScript; rujukan wajib ada; tidak boleh merujuk attached property; maksimal dua tingkat; tidak bertipe eksplisit sehingga properti tambahan pada objek sasaran tidak terlihat lewat alias.

**Kesalahan umum (tambahan).** Mengira attached property tersedia pada anak (akses lewat `id` pemilik); mencampur anak implisit dan `data:` eksplisit pada default property; mencampur penugasan objek utuh dan sub-properti pada group property yang sama; menimpa properti tipe dasar tanpa `virtual`/`override`/`final`; menaruh `QtObject` sebagai anak dari akar `QtObject`; memberi nilai awal pada properti `required`.

**Referensi (tambahan).** [QML Object Attributes](https://doc.qt.io/qt-6/qtqml-syntax-objectattributes.html) · [Property Shadowing and Override Semantics](https://doc.qt.io/qt-6/qtqml-syntax-overridesemantics.html)

### 5.6.6 Status

| Bagian | Status |
| --- | --- |
| Audit Fase 1 dan Modul 1.1 | Selesai |
| Modul 1.1 (1.1.1–1.1.7) | Selesai |
| Modul 1.2 (1.2.1–1.2.8) | Selesai |
| Modul 1.3 (1.3.1–1.3.9) | **Selesai** |
| Modul 1.4 — Komponen dan Reuse | Menunggu konfirmasi Anda |




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

