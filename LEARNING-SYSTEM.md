# Sistem Pembelajaran

Dokumen ini menetapkan arsitektur dan aturan pengembangan `independentlearners/public` sebagai repositori pembelajaran publik berbahasa Indonesia.

## Tujuan

Repositori ini dikembangkan sebagai peta pengetahuan dan sistem pembelajaran yang dapat digunakan pelajar Indonesia. Fokus utama pengembangan adalah:

- menyusun materi dalam urutan yang logis;
- mengidentifikasi prasyarat dan lompatan konsep;
- membedakan pengetahuan, latihan, eksperimen, proyek, dan troubleshooting;
- meningkatkan keterlacakan sumber dan status verifikasi;
- menjaga tautan antarmateri dan tautan submodule tetap valid;
- meningkatkan kualitas secara bertahap tanpa menghapus pengetahuan yang masih bernilai.

## Arsitektur Repository

`public` berfungsi sebagai peta dan kurikulum publik. Area pembelajaran yang memiliki siklus pengembangan sendiri dapat berada pada repository terpisah melalui submodule.

Submodule yang terdaftar saat ini:

- [Dart](./saya/dart/) — ruang pembelajaran Dart.
- [Lua](./saya/lua/) — ruang pembelajaran Lua.
- [TMOEX](./saya/tmoex/) — repository domain/proyek terkait.
- [Dartpedia](./saya/dartpedia/) — basis pengetahuan Dart yang terstruktur.
- [Aplikasi](./saya/aplikasi/) — ruang proyek/aplikasi.

Daftar di atas mengikuti konfigurasi `.gitmodules`. Jangan menghapus, memindahkan, atau mengganti path submodule tanpa memperbarui seluruh tautan yang merujuk kepadanya.

## Model Pembelajaran

Materi baru secara bertahap diarahkan menuju alur berikut:

```text
Orientasi
   ↓
Prasyarat
   ↓
Konsep
   ↓
Contoh
   ↓
Latihan
   ↓
Eksperimen
   ↓
Assessment
   ↓
Proyek
   ↓
Review
   ↓
Pengetahuan terverifikasi
```

Tidak semua materi harus memiliki seluruh tahap tersebut. Tahap yang tidak relevan boleh dihilangkan, tetapi alasan penghilangannya sebaiknya jelas.

## Klasifikasi Konten

Gunakan klasifikasi berikut ketika struktur materi mulai dirapikan:

- `concept` — penjelasan konsep dan teori.
- `tutorial` — pembelajaran langkah demi langkah.
- `reference` — informasi referensi yang dapat dicari kembali.
- `practice` — latihan terarah.
- `experiment` — pengujian atau eksplorasi bebas yang terkontrol.
- `project` — penerapan beberapa konsep menjadi hasil nyata.
- `troubleshooting` — diagnosis dan penyelesaian masalah.
- `assessment` — pemeriksaan pemahaman atau kemampuan.

Klasifikasi ini adalah pedoman arsitektur, bukan kewajiban untuk membuat delapan direktori pada setiap topik.

## Learning Contract

Topik yang telah matang sebaiknya memiliki informasi berikut:

1. Prasyarat.
2. Tujuan pembelajaran.
3. Konsep utama.
4. Contoh.
5. Latihan atau eksperimen.
6. Kesalahan umum.
7. Assessment atau kriteria penyelesaian.
8. Referensi.
9. Status dan tanggal peninjauan jika diperlukan.

## Status Materi

Status yang digunakan untuk proses kurasi:

- `planned` — direncanakan tetapi belum dikerjakan.
- `in-progress` — sedang dikembangkan.
- `review` — sedang diperiksa atau disusun ulang.
- `completed` — memenuhi kriteria penyelesaian yang ditetapkan.
- `needs-revision` — memerlukan perbaikan substansial.
- `deprecated` — dipertahankan untuk konteks historis tetapi tidak direkomendasikan sebagai jalur utama.

Status tidak boleh dianggap sebagai bukti bahwa pelajar pasti menguasai materi.

## Tingkat Kemampuan

Jika level digunakan, penilaiannya harus berbasis kemampuan, bukan panjang dokumen:

- `L0 — Orientation` — mengenali istilah dan konteks.
- `L1 — Fundamental` — memahami konsep dasar.
- `L2 — Basic` — mampu menerapkan konsep pada kasus sederhana.
- `L3 — Intermediate` — mampu menyelesaikan masalah tanpa mengikuti contoh secara langsung.
- `L4 — Advanced` — mampu merancang solusi dan mengevaluasi trade-off.
- `L5 — Expert` — mampu menjelaskan, mengevaluasi, menggeneralisasi, dan mengajarkan konsep secara mendalam.

## Sumber dan Verifikasi

Materi dapat berasal dari dokumentasi resmi, eksperimen pribadi, kursus, komunitas, atau bantuan AI. Bantuan AI tidak dengan sendirinya menjadikan sebuah pernyataan terverifikasi.

Jika provenance penting untuk memahami kualitas materi, gunakan informasi seperti:

```yaml
source:
  - official-documentation
  - personal-experiment
  - course
  - ai-assisted
verification: unverified
last_reviewed: YYYY-MM-DD
```

Nilai `verification` yang direkomendasikan:

- `unverified`
- `partially-verified`
- `verified`

## Aturan Tautan

Perubahan struktur harus dilakukan secara konservatif terhadap tautan.

Sebelum memindahkan atau menghapus direktori/file:

1. cari seluruh referensi ke path lama;
2. periksa tautan dari README induk dan README turunannya;
3. periksa referensi dari repository yang terhubung melalui submodule;
4. pindahkan atau perbarui target terlebih dahulu jika diperlukan;
5. lakukan audit tautan setelah perubahan.

Tautan yang menunjuk ke submodule harus tetap mengarah ke path yang terdaftar di `.gitmodules`, kecuali konfigurasi submodule sengaja diubah sebagai bagian dari migrasi yang terdokumentasi.

## Prinsip Kurasi

Perbaikan repository harus dilakukan bertahap. Materi lama tidak boleh dihapus hanya karena belum sempurna. Prioritasnya adalah:

1. memahami struktur yang sudah ada;
2. mempertahankan informasi yang masih bernilai;
3. memperbaiki urutan dan hubungan antarkonsep;
4. menghapus duplikasi setelah diverifikasi;
5. menambahkan materi yang benar-benar menjadi penghubung atau prasyarat;
6. melakukan verifikasi sumber;
7. baru kemudian melakukan penyederhanaan atau migrasi struktur.

## Prinsip Utama

> **Jangan membuat repository terlihat lebih rapi dengan mengorbankan keterhubungan pengetahuan. Rapikan struktur setelah hubungan antarpengetahuan dipahami.**
