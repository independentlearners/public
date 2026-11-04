# Audit Kurikulum Qt 6: JavaScript dalam QML dan Mastery QML & Qt Quick

Laporan audit kurikulum · 4 November 2026

## Catatan ruang lingkup

README.md asli tidak terlampir, jadi kelengkapan terhadap README asli tidak bisa dicocokkan baris per baris. Audit ini dilakukan terhadap isi file yang dikirim dan checklist prompt awal. Untuk akurasi, tiga halaman dokumentasi Qt diperiksa langsung (Host Environment, daftar objek JavaScript, konversi tipe QML↔C++) ditambah beberapa pencarian. Tautan lain belum dibuka satu per satu.

## Ringkasan hasil audit

Dokumen “Mastery QML & Qt Quick” sudah berfungsi sebagai peta jalan yang solid untuk programmer. Dokumen “JavaScript dalam QML” masih berupa indeks topik, belum sumber belajar. Akurasi teknis umumnya baik dan tidak ada kesalahan fatal, tetapi ada beberapa koreksi nyata. Dua persyaratan awal belum terpenuhi: template per-modul yang konsisten (terutama Dokumen 1) dan keterbacaan untuk non-IT. Penilaian subjektif: sekitar 8/10 untuk programmer yang baru di Qt, sekitar 4/10 untuk non-IT.

## Poin kuat

- Batas lingkup Dokumen 1 tegas dan benar. Tabel browser vs QML dan peringatan “jangan samakan dengan browser” sesuai dokumentasi resmi.
- Tabel dukungan fitur per versi akurat. `??` didukung sejak Qt 5.15, `?.` sejak 6.2, dan separator numerik sejak 6.8, di atas basis ECMAScript edisi ke-7. `QVariantList` bisa diubah in-place sejak 6.5 dan `QVariantMap` sejak 6.9.
- Contoh `PropertyChanges { panel.width: 400 }` benar. Bentuk dengan ID memang yang direkomendasikan, sedangkan bentuk `target:` dipertahankan untuk kompatibilitas Qt 5.
- Praktik Qt 6 modern dipakai konsisten: `qt_add_qml_module`, `QML_ELEMENT`, hindari context property, `required property`.
- Struktur kelulusan berbasis proyek, rubrik 100 poin (bobotnya benar berjumlah 100), strategi “dokumentasi dulu, pelajari keterbatasan API”, dan prinsip least privilege di Modul 13.1.

## Area peningkatan

### A. Koreksi akurasi

1. **Modul 2.3:** `.pragma ComponentBehavior` keliru. `.pragma library` adalah direktif file `.js`, sedangkan `pragma ComponentBehavior: Bound` (tanpa titik) adalah pragma dokumen `.qml`. Pisahkan keduanya, dan sebutkan juga `pragma FunctionSignatureBehavior`, yang mengatur perilaku anotasi tipe fungsi.
2. **Modul 1.2:** `time` bukan value type QML. QTime dikonversi menjadi JavaScript `Date`, dan tabel tipe dasar resmi tidak memuat `time`. Tipe yang justru hilang dari daftar adalah `font`, `matrix4x4`, dan `quaternion`.
3. **Modul 9.2:** “Default style” dan “Basic style” dipisah. Di Qt 6 “Default” diganti nama menjadi “Basic”, dan style bawaan di Linux adalah Fusion. Tambahkan juga pemilihan style lewat `QQuickStyle`, argumen `-style`, env `QT_QUICK_CONTROLS_STYLE`, atau `qtquickcontrols2.conf`, serta konsekuensi run-time selection: compiler QML tidak bisa menghasilkan kode C++ untuk binding pada properti kontrol.
4. **Modul 4.2:** `qmlscene` tidak boleh disajikan sebagai alat Qt 6. Di Qt 6 ia sudah deprecated dan mencetak peringatan agar memakai `qml`.
5. **Dokumen 1, Fase 2.2:** BigInt tidak ada di daftar objek global yang didukung engine, sedangkan Symbol dan Promise tercantum. Hapus atau tandai tidak didukung. Untuk object spread (`{...obj}`, Fase 1 dan 7.1): itu fitur ES2018, sedangkan engine berbasis ES7 dan halaman Host Environment hanya menyebut tiga tambahan di atas. Tandai sebagai “uji dulu dengan `qml`”.
6. **Dokumen 1, Fase 8.4 (`this`):** `this` tidak terdefinisi di sebagian besar konteks QML. Hanya di binding, signal handler, dan fungsi yang dideklarasikan di QML ia merujuk ke scope object. Mulai dari aturan ini, bukan dari perbandingan arrow vs regular function ala browser.
7. **Dokumen 1, Fase 15.3 (`async`/`await`):** dokumentasi resmi tidak menyebut dukungannya. Sejauh yang diketahui belum didukung. Jadikan eksperimen pembuktian, bukan materi pokok.
8. **Modul 5.3 (Theme singleton):** contoh tidak lengkap. Di CMake, file harus ditandai `QT_QML_SINGLETON_TYPE TRUE`, kalau tidak singleton tidak terdaftar. Ini jebakan klasik.
9. **Modul 0.2/4.4:** `main.cpp` tidak ditampilkan, dan target `hello` dijalankan sebagai `./build/myapp`. Pembelajar tidak bisa menjalankan contoh pertama. Beri `main.cpp` minimal (`QGuiApplication` + `QQmlApplicationEngine` + `loadFromModule`).
10. **Minor:**
    - Modul 7.3: `function createRectangle()` berada di luar objek, jadi bukan QML valid.
    - Modul 5.1: `parent.title` rapuh, ganti dengan `id: root`.
    - §8.4: repo `qtquickcontrols2` adalah warisan Qt 5, karena sejauh yang diketahui kontrol Qt 6 sudah berada di `qtdeclarative`.
    - Estimasi Foundation tertulis 4–7 minggu, padahal jumlah Fase 0–2 adalah 5–8.

### B. Topik penting yang belum tercakup atau terlalu tipis

- **Runtime dan bootstrap:** `QT_QPA_PLATFORM` (wayland/xcb), `QT_QUICK_BACKEND=software`, `QSG_RHI_BACKEND`, `QSG_INFO`, `QSG_VISUALIZE`, `QML_IMPORT_TRACE`, `QT_LOGGING_RULES`. Ini sangat relevan di Arch dengan WM.
- **Kompilasi QML Qt 6:** `qmlcachegen`, `qmlsc`, `qmltc`, dan anotasi tipe fungsi. Sejak Qt 6.7 anotasi tipe selalu ditegakkan saat fungsi dipanggil, tetapi di kurikulum ia hanya muncul sebagai kata kunci. Tambahkan juga `as` type assertion.
- **Threading:** `QThread`/worker object, thread affinity, `QtConcurrent`/`QFuture`, `WorkerScript`. Saat ini hanya disebut di daftar, tanpa modul.
- **C++ Qt 6 modern:** bindable properties (`QProperty`), `QQmlListProperty`, attached dan extension types (`QML_ATTACHED`, `QML_EXTENDED`, `QML_FOREIGN`), `QQmlParserStatus`, `QQmlComponent` dari sisi C++.
- **Qt Quick:** Shapes, MultiEffect, Particles, Qt Quick Dialogs, persistensi `Settings`. `QtQml.StateMachine` juga perlu dibedakan dari `State` Qt Quick, karena Modul 6.1 menyebut “state machines” tanpa membedakan.
- **Jebakan tipe data dari dokumentasi resmi:** array-like hasil konversi dari C++ tetap mengembalikan `false` pada `Array.isArray()`, konversi `QDate`↔`Date` bergantung pada UTC, dan penomoran bulan JavaScript 0–11 sedangkan Qt 1–12. Masukkan ke Dokumen 1 Fase 2.8, 6.5, dan 14.
- **Dokumen 1:**
  - Sintaks Connections modern `function onX()`, karena bentuk lama `onX:` sudah deprecated.
  - `required property` dan `pragma ComponentBehavior: Bound` untuk delegate (Fase 8/9).
  - Pendaftaran file `.js` di `QML_FILES` agar ikut ter-embed (Fase 13).
- **Keamanan (13.1):**
  - Gerbang baca file lokal oleh XHR (`QML_XHR_ALLOW_FILE_READ`).
  - Injeksi lewat `QML_IMPORT_PATH` dan `QT_PLUGIN_PATH`.
  - `Qt.createQmlObject` atau `Loader` dari URL tak tepercaya sama dengan eksekusi kode.
  - Isolasi proses (bubblewrap/firejail/Flatpak) dan perbedaan model isolasi Wayland vs X11.
- **Tooling dan distribusi:** target CMake `all_qmllint`, konfigurasi `qmlls` untuk Neovim, dan `PKGBUILD` (Arch) yang belum disebut eksplisit.

### C. Kepatuhan terhadap persyaratan per modul

| Persyaratan | Dokumen 2 (Mastery) | Dokumen 1 (JS dalam QML) |
| --- | --- | --- |
| Deskripsi konkret dan konsep mendalam | Baik | Tidak ada. Fase berisi daftar kata kunci tanpa kalimat penjelas (mis. “Function execution context.”) |
| Contoh kode | Belasan modul tanpa contoh (mis. 2.4, 3.4, 7.4, 9.4, 10.1, 10.6, 11.1, 11.2, 12.1, 12.4, 13.4, 14.1, 14.4, 14.5) | Fase 10, 12, 14–19 tanpa kode |
| Terminologi | Kurang dari separuh modul | Hanya Fase 1 |
| Daftar isi | Ada | Berupa poin tanpa struktur |
| Referensi | Ada | Hanya 8 dari 20 fase punya referensi inline |
| Indikasi visual | Hanya 2 (0.2 dan 11.1) | Nol |

Kandidat visual yang paling bernilai: scope chain (Dokumen 1 F8), dependency graph binding (F11), alur signal (F12), event loop (F15), batas JS↔C++ (F16), dan lifecycle objek (F17).

### D. Aksesibilitas bagi non-IT

- Prasyarat “terminal Linux dan dasar pemrograman wajib” (Dokumen 2 §3) bertentangan dengan target non-IT.
- Tidak ada fase orientasi tentang program, compiler, event loop, GUI, path, dan git.
- Jargon muncul sebelum definisi (`QObject`, meta-object, scene graph), tanpa analogi dan tanpa glosarium terpusat.
- Tidak ada latihan atau cek pemahaman per modul.
- Saran: tambahkan Fase 0 “orientasi”, glosarium, dan template modul tetap: Analogi → Contoh minimal → Cara menjalankan → Kesalahan umum → Latihan 15 menit → Cek pemahaman. Untuk eksekusi, ajarkan `qml berkas.qml` sebagai jalur eksperimen satu file sebelum CMake.

### E. Tujuan “menambah fitur di proyek apa pun” dan penguasaan

- Jalur C++ integration, 14.5 (membaca source), dan framework design sudah mengarah ke penguasaan.
- Belum ada metodologi menambah fitur ke codebase asing: membaca arsitektur, menemukan titik ekstensi, reproduksi minimal, patch, uji.
- Proyek 01–06 belum punya spesifikasi dan kriteria penerimaan yang terukur.
- Perlu “peta keputusan” modul Qt lain (Quick 3D, Charts/Graphs, WebEngine, Multimedia, Wayland compositor). Klaim “segala kebutuhan” hanya realistis jika kurikulum mengajarkan cara belajar modul baru.
- Opsional, jika tujuannya UI desktop terminal-centric: capstone berupa komponen shell (bar atau launcher) di Wayland.

### F. Struktur

- Dokumen 1 dan Fase 2 Dokumen 2 tumpang tindih (2–3 minggu vs 12–18 minggu). Jadikan Dokumen 1 sebagai jalur pendalaman Fase 1–3 dengan tabel pemetaan fase.
- Urutan ketergantungan bermasalah di dua tempat. Dokumen 1 Fase 16 butuh C++ yang baru muncul di Dokumen 2 Fase 10. Modul 5.3 butuh CMake dan modul QML yang baru diajarkan di Fase 8.
- Tabel progres hanya mencakup 5 dari 15 fase, dan penomoran bab loncat dari 12 ke 14.

### G. Format dan tautan

- Hapus `?utm_source=chatgpt.com` dari semua tautan.
- Bersihkan artefak ekspor: `[image](...favicon...)`, label “Qt 6.10.3+2” dan “Qt 6.12.0+1”, dan `&#x20;`.
- Gambar Proyek 01–06 di-hotlink dari `images.openai.com`. Isinya thumbnail halaman acak yang tidak relevan dan akan mati. Ganti dengan diagram buatan sendiri (Mermaid atau ASCII).
- Versi tautan tercampur (`qt-6.10`, `qt-6.8`, `qt-6`). Pakai `/qt-6/` tanpa versi atau pin satu versi.
- Modul 9.2 memuat dua referensi dengan URL identik.
- Tiga pola tautan yang diragukan dan perlu dicek manual: `qtqml-debugging.html`, `qtqml-type-compiler.html`, `qtquick-gradient.html`.

## Urutan perbaikan yang disarankan

1. Terapkan koreksi A1–A9.
2. Tetapkan template modul, lalu isi Dokumen 1, mulai Fase 10, 12, dan 14–19.
3. Tambahkan Fase 0 non-IT dan glosarium.
4. Tambahkan modul yang hilang: runtime/bootstrap, kompilasi QML Qt 6, threading, dan metodologi memodifikasi proyek asing.
5. Bersihkan format dan tautan.

## Sumber verifikasi

- [JavaScript Host Environment (Qt 6.10)](https://doc.qt.io/qt-6.10/qtqml-javascript-hostenvironment.html)
- [List of JavaScript Objects and Functions](https://doc.qt.io/qt-6/qtqml-javascript-functionlist.html)
- [Data Type Conversion Between QML and C++](https://doc.qt.io/qt-6/qtqml-cppintegration-data.html)
- [PropertyChanges QML Type](https://doc.qt.io/qt-6/qml-qtquick-propertychanges.html)
- [Changes to Qt Quick Controls (migrasi Qt 6)](https://doc.qt.io/Qt-6/qtquickcontrols-changes-qt6.html)
- [Styling Qt Quick Controls (Qt 6.5)](https://doc.qt.io/qt-6.5/qtquickcontrols-styles.html)
- [Qt Forum: qmlscene issues](https://forum.qt.io/topic/163731/qmlscene-issues/3)
