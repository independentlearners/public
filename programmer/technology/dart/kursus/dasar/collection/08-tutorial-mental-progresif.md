# 08 — Tutorial Mental Progresif: Dasar hingga Mahir

## Kenapa Tidak Ada Kunci Jawaban di File Ini

Singkat saja: riset kognitif soal *generation effect* cukup konsisten — informasi yang kamu hasilkan sendiri (walau lewat trial-and-error dan salah dulu) melekat jauh lebih kuat di memori jangka panjang dibanding informasi yang kamu baca sudah jadi. Kalau file ini saya isi kode lengkap, kamu akan merasa paham saat membaca — padahal itu ilusi kompetensi. Baru terasa bedanya nanti, saat kamu ditagih menulis dari nol dan ternyata kosong.

Jadi: tantangan, kriteria selesai, petunjuk arah (bukan jawaban), pertanyaan refleksi. Itu saja. Kalau setelah usaha serius kamu tetap mentok, itu sinyal sah untuk buka file `01`–`07` lagi atau tanya saya — bukan kegagalan.

## Tema yang Dipakai di Seluruh Level: Sistem Perpustakaan Mini

Kelima level di bawah membangun satu sistem yang sama secara bertahap — katalog perpustakaan sederhana. Kamu tidak wajib memakai kode dari level sebelumnya untuk mengerjakan level berikutnya (tiap level saya beri ulang konteks yang cukup), tapi kalau kamu memang melanjutkan kode yang sama, itu bonus realisme: begitulah software beneran berkembang.

---

## Level 1 — Dasar: List & Map

**Tujuan:** paham operasi CRUD dasar List dan Map, dan yang lebih penting — paham KAPAN masing-masing dipilih, bukan cuma bagaimana cara pakainya.

**Tantangan:** Bangun katalog buku untuk perpustakaan mini. Setiap buku punya: judul, penulis, ISBN (unik), jumlah halaman, genre.

Fungsi yang harus tersedia:
- Tambah buku baru
- Cari buku berdasarkan ISBN — harus terasa "instan" bahkan kalau katalognya besar
- Hapus buku berdasarkan ISBN
- Tampilkan semua buku, terurut berdasarkan judul

**Kriteria selesai:**
- Struktur data utama yang kamu pilih untuk menyimpan katalog harus punya alasan eksplisit yang bisa kamu jelaskan dengan kalimat, bukan cuma "kelihatannya cocok"
- Program menangani kasus mencoba menambah buku dengan ISBN yang sudah ada — kamu putuskan sendiri perilakunya (tolak? timpa? beri peringatan?), tapi keputusan itu harus sadar, bukan kebetulan dari cara kode kamu ditulis
- Diuji dengan minimal 5 buku dummy

**Petunjuk:**
- ISBN itu unik dan dipakai sebagai kunci pencarian utama — struktur apa yang secara alami cocok untuk akses cepat berdasarkan key unik?
- "Tampilkan terurut berdasarkan judul" adalah kebutuhan TAMPILAN, bukan kebutuhan PENYIMPANAN — kamu tidak perlu memilih struktur penyimpanan yang otomatis terurut hanya demi ini.

**Refleksi:**
- Kenapa `Map<String, Buku>` dengan key ISBN lebih masuk akal dibanding `List<Buku>` untuk kasus pencarian di sini?
- Trade-off apa yang kamu korbankan dengan memilih Map dibanding List?

---

## Level 2 — Menengah: Transformasi Iterable

**Tujuan:** mahir memakai `map`/`where`/`fold` sebagai pengganti loop manual dengan accumulator, dan benar-benar paham bedanya lazy vs eager dalam kode yang kamu tulis sendiri (bukan cuma contoh di file `01`).

**Tantangan:** Dari katalog Level 1 (atau buat ulang datanya kalau perlu), hasilkan laporan statistik:
1. Rata-rata jumlah halaman seluruh buku
2. Daftar judul buku bergenre "Fiksi" saja, diurutkan dari halaman terbanyak ke tersedikit
3. Pengelompokan buku berdasarkan genre, hasil akhirnya `Map<String, List<Buku>>`

**Kriteria selesai:**
- Tidak ada variabel accumulator manual (`var total = 0; for (...) { total += ... }`) untuk hal-hal yang bisa dilakukan `fold`
- Kode tetap berjalan benar kalau katalog kosong — khususnya untuk rata-rata, apa yang terjadi kalau pembaginya nol? Tangani secara eksplisit, jangan biarkan error atau `NaN` lolos diam-diam

**Petunjuk:**
- `fold` pas untuk akumulasi seperti rata-rata (nilai awal, lalu combine tiap elemen)
- Pengelompokan by genre adalah pola yang sangat umum — coba bangun `Map<String, List<Buku>>`-nya secara manual pakai `fold` dulu (mulai dari `<String, List<Buku>>{}` sebagai nilai awal). Nanti di file `07` kamu sudah tahu ada `groupBy` dari `package:collection` sebagai jalan pintas — tapi bangun dulu versi manualnya supaya paham APA yang sedang disingkat.

**Refleksi:**
- Di baris kode mana persisnya transformasi Iterable-mu benar-benar "dieksekusi" — bukan cuma didefinisikan?
- Kalau katalognya 1 juta buku dan kamu cuma butuh 3 judul fiksi pertama (bukan semuanya), urutan method chain apa yang paling efisien, dan kenapa `toList()` yang dipanggil terlalu awal bisa jadi pemborosan?

---

## Level 3 — Lanjut: Set, Equality, dan Queue

**Tujuan:** paham semantik keunikan plus custom equality dalam konteks nyata, dan FIFO processing dengan Queue.

### Bagian A — Set & Equality

**Tantangan:** Ekstrak semua nama penulis unik dari katalog. Masalahnya: data sumber kadang menulis nama penulis dengan variasi kapitalisasi yang seharusnya dianggap orang yang sama (misal "Andrea Hirata" dan "andrea hirata" muncul di entri buku berbeda).

**Kriteria selesai:**
- Dua nama penulis yang cuma beda kapitalisasi HARUS dianggap satu entitas di hasil akhir
- Buktikan dengan kasus uji eksplisit — bandingkan jumlah penulis sebelum dan sesudah penanganan ini diterapkan

**Petunjuk:** Ada dua pendekatan valid: (1) override `==`/`hashCode` di class Penulis seperti contoh `Titik` di file `03`, atau (2) normalisasi string (misal ke lowercase) sebelum dimasukkan ke Set. Keduanya sah — pikirkan sendiri apa yang hilang/didapat dari masing-masing pendekatan di konteks nama orang (petunjuk: kapitalisasi asli nama orang biasanya informasi yang ingin tetap kamu tampilkan ke pengguna).

### Bagian B — Queue

**Tantangan:** Bangun sistem antrean peminjaman. Anggota mendaftar antre untuk buku yang sedang dipinjam orang lain. Saat buku dikembalikan, orang PALING DEPAN di antrean yang dilayani duluan (FIFO).

Fungsi yang harus tersedia: `daftarAntre(namaAnggota, isbn)`, dan `bukuKembali(isbn)` yang mengembalikan nama anggota berikutnya yang berhak (atau null kalau antrean kosong).

**Kriteria selesai:**
- `List.removeAt(0)` TIDAK BOLEH dipakai untuk melayani antrean — kamu harus bisa menjelaskan dengan kalimat kenapa itu masalah

**Petunjuk:** `Queue` dari `dart:collection`, bukan `List`. Kemungkinan kamu butuh satu `Queue` per ISBN (jadi `Map<String, Queue<String>>`) — pikirkan kenapa strukturnya jadi gabungan dua collection, bukan satu.

**Refleksi:**
- Kalau kamu pilih normalisasi string (bukan override equality) untuk kasus penulis, informasi apa dari data asli yang berpotensi hilang kalau tidak hati-hati?
- Kenapa performa `removeAt(0)` baru terasa jadi masalah nyata ketika antrean berisi ribuan anggota, bukan lima?

---

## Level 4 — Mahir: Membangun Collection Kustom

**Tujuan:** menerapkan pola dari file `06` untuk struktur data dengan perilaku khusus yang benar-benar dipaksakan di level struktur, bukan dicek manual di luar.

**Tantangan:** Perpustakaan ingin fitur "5 buku terakhir dilihat" per anggota. Begitu ada buku ke-6 dilihat, buku yang paling lama tidak disentuh harus otomatis tersingkir (perilaku LRU / *Least Recently Used*, kapasitas tetap 5).

**Kriteria selesai:**
- Batas kapasitas maksimum dipaksakan DI DALAM struktur data itu sendiri — bukan lewat `if (daftar.length > 5) ...` yang ditulis manual di setiap tempat yang memanggilnya
- Melihat ulang buku yang sudah ada di daftar harus memindahkannya ke posisi "paling baru dilihat," bukan menambah entri duplikat
- Ditulis sebagai class yang bisa dipakai ulang, bukan logic sekali pakai di dalam `main()`

**Petunjuk:** Ada dua jalan valid. (1) `LinkedHashMap` sudah menjaga urutan insersi secara alami — bagaimana caranya "memindahkan sebuah key yang sudah ada ke posisi paling akhir" di Map berbasis insertion-order? (petunjuk: hapus lalu masukkan lagi bukan operasi mahal untuk kasus ukuran kecil begini). (2) `extends ListBase` dan kontrol logic eviction sendiri di dalam override `add`.

**Refleksi:**
- Apa yang membuat pendekatan `LinkedHashMap` terasa lebih sederhana dibanding `ListBase` untuk kasus spesifik ini?
- Kalau kapasitasnya harus bisa diubah-ubah saat runtime (bukan tetap 5), bagian desain mana yang perlu kamu ubah?

---

## Level 5 — Expert: Algoritma dan Performa

**Tujuan:** berpikir seperti engineer — bukan cuma "kodenya jalan," tapi "kodenya jalan dengan kompleksitas yang saya pahami dan sudah saya ukur sendiri," bukan sekadar percaya teori Big-O tanpa verifikasi.

### Bagian A — Word Frequency dari Judul Buku

**Tantangan:** Dari katalog besar (generate minimal 1000 buku dummy dengan judul acak), hitung kata apa yang paling sering muncul di seluruh judul buku.

**Kriteria selesai:** Solusi harus berjalan dalam O(n) total terhadap jumlah kata, bukan O(n²). Jebakan paling umum di sini: memanggil `List.contains()` di dalam loop untuk cek "kata ini sudah pernah dihitung belum" — itu mengubah kompleksitas totalmu jadi kuadratik tanpa kamu sadari.

### Bagian B — Benchmark Nyata: List vs Set

**Tantangan:** Buat perbandingan waktu eksekusi nyata antara `List.contains()` pada 100.000 elemen vs `Set.contains()` pada 100.000 elemen (data sama), untuk 10.000 pencarian dengan nilai acak. Ukur pakai `Stopwatch` dari `dart:core`.

```dart
var stopwatch = Stopwatch()..start();
// ... kode yang mau diukur ...
stopwatch.stop();
print('${stopwatch.elapsedMilliseconds} ms');
```

**Kriteria selesai:** Kamu punya angka konkret dalam milidetik yang membuktikan (atau membantah!) klaim "Set jauh lebih cepat dari List untuk pencarian di data besar" — bukan sekadar mengutip teori Big-O dari file `07` tanpa verifikasi sendiri.

**Petunjuk:** Pastikan dataset List dan Set berisi elemen yang identik supaya perbandingan adil, dan pastikan nilai yang dicari sebagian ada di dataset dan sebagian tidak (kasus "tidak ketemu" punya karakteristik performa berbeda dari "ketemu").

**Refleksi:**
- Berapa kali lipat perbedaan waktu yang kamu ukur? Sesuai ekspektasi teori O(1) vs O(n) atau meleset — dan kalau meleset, kenapa menurutmu?
- Ada kondisi di mana `List.contains()` "cukup cepat" secara praktis meski kalah secara Big-O dari Set — kondisi seperti apa itu?

---

## Jadwal Spaced-Revisit

Mengerjakan sekali lalu tidak disentuh lagi adalah cara paling efektif untuk melupakan. Ini jadwal yang disarankan — sesuaikan ritmenya, yang penting prinsipnya: **kembali sebelum lupa total, bukan setelah lupa total.**

| Kapan | Aktivitas |
|---|---|
| Hari 1 | Level 1 |
| Hari 3 | Level 2, lalu revisit Level 1 (5 menit, coba ingat solusimu TANPA buka kode lama dulu) |
| Hari 5 | Level 3, lalu revisit sekilas Level 1–2 |
| Hari 8 | Level 4, lalu revisit sekilas Level 1–3 |
| Hari 12 | Level 5, lalu revisit SEMUA level sebelumnya dalam satu sesi |
| Hari 20 | Revisit total tanpa buka catatan sama sekali. Kalau masih lancar tanpa tersendat, materi ini sudah pindah ke memori jangka panjang |

## Sebelum Mulai Tiap Level

Isi dulu template dari file `00`:

> Yang ingin saya pahami di level ini: ______________
> Saya tahu sudah paham kalau saya bisa: ______________

Dua baris ini yang memisahkan "sedang belajar syntax" dari "sedang berpikir seperti engineer" — dan keduanya butuh mode fokus yang beda.

## Kalau Butuh Bantuan Setelah Usaha Serius

Sumber tambahan dengan hint/solution interaktif bawaan (bukan dari saya, dari Dart sendiri): [dart.dev/libraries/collections/iterables](https://dart.dev/libraries/collections/iterables) — ada editor DartPad tertanam dan dropdown hint/solution per soal, cocok dipakai kalau mentok di Level 1–2.

<!-- Selamat mengerjakan. Kalau nanti sudah selesai semua dan mau saya review arsitekturnya di fase GitHub, kasih tau konteks lengkapnya — bukan cuma potongan kode — biar feedback-nya soal desain, bukan cuma koreksi syntax permukaan. -->
