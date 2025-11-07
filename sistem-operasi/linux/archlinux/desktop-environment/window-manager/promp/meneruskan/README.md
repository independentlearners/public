Sekarang, saya ingin Anda mendalami dan mengembangkan setiap fase, modul, dan sub-bagian dari kurikulum yang sudah kamu buat tersebut. Untuk setiap entri (dari fase utama hingga sub-sub-bagian terdalam) dalam kurikulum yang sudah kamu buat, Anda harus menghasilkan output yang sangat detail dan komprehensif dan menjelaskannya secara bertahap agar mencapai kemaksimalan yang menyeluruh serta menjadikan penjelasan sangat dan sangat mudah dipahami, untuk setiap bagian kode yang dijelaskan harus menjelaskan juga dasar konteks atau materi atau sintksisnya seprti contoh semisal ini dalam konteks materi framework flutter, ketika kamu menjelaskan sebuah widget maka sintaks dart yang mendasarinya juga wajib disebutkan! Kemudian semua penjelasan itu juga harus mencakup elemen-elemen berikut:

Jelaskan tiap-tiap bagian atau fase besrta Sub-sub Bagiannya dengan sangat dan sangat detail bahkan mencakup bagian yang mungkin jarang dibahas meskipun itu adalah sebuah opsional

Deskripsi Konkret & Peran dalam Kurikulum: Jelaskan secara praktis apa yang dicakup oleh bagian tersebut dan mengapa penting dalam konteks pembelajaran secara keseluruhan.

Konsep Kunci & Filosofi Mendalam: Uraikan konsep-konsep inti, prinsip-prinsip yang mendasari, dan filosofi di balik teknologi atau topik yang dibahas. Pastikan penjelasan ini mudah dipahami bahkan oleh non-IT sekalipun.

Sintaks Dasar / Contoh Implementasi Inti:

Sediakan potongan kode minimalis namun fungsional, perintah konsol jika dibuhkan, atau contoh implementasi langkah demi langkah untuk memahami setiap materinya, berikan contoh studi kasus, diagram alur kerja, atau ilustrasi konsep visual untuk sebuah widget dan semua hal mengenai visualisasi terkait materi grafis atau pondasi grafis.

Pastikan hal tersebut menjelaskan bagaimana konsep diimplementasikan dalam praktik terbaiknya.

Terminologi Esensial & Penjelasan Detil: Daftar dan jelaskan setiap istilah teknis atau jargon yang mungkin muncul dalam konteks modul tersebut dengan definisi yang jelas dan contoh jika diperlukan, sehingga mudah dimengerti oleh siapa pun.

Struktur Pembelajaran Internal (Struktur Daftar Isi): Berikan daftar poin-poin atau sub-topik yang akan dibahas lebih lanjut di setiap bagian atau penjelasan lanjutan, ini berfungsi sebagai "mini-daftar isi" untuk setiap entri. Dan harus berada di atas halaman sebelum memulai materinya

Rekomendasi Visualisasi (Jika Diperlukan): Tunjukkan di mana visualisasi (diagram alur, struktur pohon, ilustrasi arsitektur, dll.) akan sangat membantu pemahaman. Anda bisa membuat seperti berikut tetapi yang rapi karena berikut ini hanya sekedar contoh yang perlu kamu terapkan untuk semua penjelasan dan contoh yang di tampilkan, kamu juga perlu membuat tambahan untuk mewakili semua yang sudah kamu jelaskan dengan contoh mungkin seperti berikut:

```

┌──────────────────────────┐

│        Induk atau        │

│        Pembungkus        │─────────┐

│  ┌────────────────────┐  │         ▼

│  │                    │  │ Keterangan lainnya jika ada

│  │     anak-anak      │  │

│  │     Widget UI      │  │

│  │                    │  │

│  │                    │  │

│  │     Jenis Kode     │  │

│  │        atau        │  │

│  │      Sintaks       │  │

│  │                    │  │

│  │     Keterangan     │─────────┐

│  │       lainnya      │  │      ▼

│  │                    │  │ Keterangan lainnya jika ada

│  │                    │  │

│  │                    │  │

│  │                    │  │

│  └────────────────────┘  │

│                          │

│                          │

└──────────────────────────┘



CONTOH LAIN:



┌──────────────────────────────┐

│  MaterialApp.router          │ Pembungkus utama aplikasi.

│  (Titik Awal Konfigurasi)    │─────────┐

│  ┌────────────────────────┐  │         ▼

│  │ routerConfig: _router  │  │ Memberitahu MaterialApp untuk menggunakan

│  │                        │  │ konfigurasi dari objek GoRouter.

│  │ ┌────────────────────┐ │  │

│  │ │ GoRouter           │ │  │

│  │ │ (Otak Routing)     │ │─────┐

│  │ │ ┌────────────────┐ │ │  │  ▼

│  │ │ │ routes: [      │ │ │  │ Berisi daftar semua rute (GoRoute)

│  │ │ │                │ │ │  │ yang dikenali oleh aplikasi.

│  │ │ │   GoRoute(     │ │ │  │

│  │ │ │     path:'/',  │ │ │  │

│  │ │ │     builder:.. │ │ │  │

│  │ │ │     routes: [  │ │ │  │

│  │ │ │      GoRoute() │ │ │  │

│  │ │ │     ]          │ │ │  │

│  │ │ │   )            │ │ │  │

│  │ │ │ ]              │ │ │  │

│  │ │ └────────────────┘ │ │  │

│  │ └────────────────────┘ │  │

│  └────────────────────────┘  │

└──────────────────────────────┘



DIAGRAM YANG MENJELASKAN DIATAS JIKA DIPERLUKAN

ATAU JIKA DAPAT MEMBANTU SEBUAH PEMAHAMAN

SEPERTI CONTOH BERIKUT:



PERTAMA

DIAGRAM ALUR KONSEPTUAL:

  ┌──────────────────┐      ┌────────────────────────┐      ┌─────────────────┐

  │                  │      │                        │      │                 │

  │     URL/OS       ├─────►│ RouteInformationParser ├─────►│  Objek State    │

  │                  │      │                        │      │                 │

  │ (misal '/book/1')│      │     (Penerjemah)       │      │ (misal AppPath) │

  │                  │      │                        │      │                 │

  └──────────────────┘      └──────────┬─────────────┘      └────────┬────────┘

                                       │                             │

                                       │                             │

                                       │                             │

                                       │◄────────────────────────────┘

                                       │

                                       │

                                       │

                             ┌─────────▼──────────┐      ┌─────────────────────┐

                             │                    │      │                     │

                             │   RouterDelegate   ├─────►│       UI State      │

                             │                    │      │                     │

                             │       (Otak)       │      │   (ChangeNotifier)  │

                             │                    │      │                     │

                             └─────────┬──────────┘      └─────────────────────┘

                                       │

                                       │

                                       │

                             ┌─────────▼────────────┐

                             │                      │

                             │   build(Navigator)   │

                             │                      │

                             │ dengan [Page1,Page2] │

                             │                      │

                             └──────────────────────┘

CONTOH KEDUA

ATAU SEPERTI INI:





  ┌──────────────────────────┐

  │  if (state berubah)      │  // Kondisi dari state aplikasi

  │  (Logika di Delegate)    │

  └──────────┬───────────────┘

             │

  ┌──────────▼───────────────┐

  │  pages: [ ... ]          │  // Mendeklarasikan tumpukan halaman

  │  (Properti Navigator)    │

  └──────────┬───────────────┘

             │

  ┌──────────▼───────────────┐

  │  MaterialPage            │  // "Pembungkus" deklaratif

  │  (Deskripsi Route)       │

  └──────────┬───────────────┘

             │

  ┌──────────▼───────────────┐

  │ child: BookDetailsScreen │  // Widget UI aktual

  │ (Konten Layar)           │

  └──────────────────────────┘

```

Instruksi Tambahan :

Gunakan gaya penulisan resmi, ringkas, dan mudah dipahami pemula sekalipun, namun dengan kedalaman teknis untuk tingkat ahli.

Nada menyemangati, tanpa humor ringan apapun. Tetapi lebih kepada sesuatu yang memotifasi dan semangat untuk mempelajarinya

Kerjakan bertahap—bukan sekaligus—dan pastikan tidak ada pertanyaan tersisa sebelum berpindah.

Hubungan dengan Modul Lain: Jelaskan bagaimana bagian yang nantinya terhubung atau menjadi prasyarat untuk modul berikutnya sesuai apa yang ada dalam daftar kurikulum.

Sumber Referensi Lengkap:

Untuk setiap konsep atau sintaks yang dijelaskan, sertakan tautan langsung ke dokumentasi resmi, panduan, tutorial, atau artikel relevan dari sumber terpercaya (misalnya, dokumentasi resmi Dart/Flutter, artikel Medium terkemuka, publikasi ilmiah, buku, dsb.).

Jika ada library atau API eksternal yang disebutkan dalam konteks yang akan dijelaskan, sertakan tautan langsung ke halaman terkait atau bahkan jika itu berhubungan dengan pub.dev atau dokumentasi resmi lainnya.

Pastikan semua tautan berfungsi dan mengarah ke informasi yang paling akurat dan up-to-date.

Tips dan Praktik Terbaik: Berikan saran praktis, best practices, atau "hal-hal yang perlu diperhatikan" yang relevan dengan topik terkait pada setiap pembahasan.

Potensi Kesalahan Umum & Solusi: Identifikasi kesalahan yang sering dilakukan oleh pembelajar dan berikan panduan tentang cara mengatasinya serta cara mempraktekannya dengan baik.

Selalu lihat isi kurikulum sebelum membuat jawaban: Pastikan bahwa penjelasan materinya adalah yang paling kompregensif bahkan seandainya itu tidak ada dalam daftar kurikulum maka kamu perlu menambahkannya dan berikan deskripsi khusus terhadap penjelasan tambahan yang tidak ada dalam kurikulum tetapi semuanya harus tetap mengacu pada kurikulum, pada bagian ini, mungkin saya akan menampilkan kembali daftar yang harus kamu kerjakan agar tetap mengacu pada kurikulumnya tetapi jika kurikulum tersebut sebetulnya melampaui materi yang direkomendasikan atau daftar dari kurikulum tersebut meloncat maka kamu wajib memberikan arahan serta memberikan daftar tambahannya agar materi tersebut ditambahkan dalam daftar kurikulum sebagai pembaruan. Oleh karenanya, sebelum memulai materi paling awal maka kamu perlu mengaudit kurikulum tersebut untuk mengantisipasi adanya materi yang bersifat meloncat atau kesalahan daftar, output dari audit ini tidak harus dijawab semuanya sebab ini hanya memastikan adanya kesalahan teknis terkait penyusunan karena yang seharusnya kamu fokus disini adalah membangun materi paling komprehensif yang pernah ada. Dari sinilah mengapa kamu tidak harus menjawabnya sekalugus tetapi lebih kepada bertahap sebab salah satu tujuannya adalah membangun materi paling baik, maka dari itu kamu wajib fokus secara mendalam untuk memberikan materi paling baik dimana ini memungkinkan untuk dijadikan sebuah dokumentasi hasil pembelajaran mandiri. Jadi walaupun sebetulnya ini melampaui kurikulum tetapi tidak berarti bahwa kurikulum harus dijadikan acuhan sebelum kurikulum tersebut di audit terlebih dahulu. Oleh karenanya itulah alasan mengapa mungkin saya akan menampilkan kembali sebuah daftar dari kurikulumnya yang harus kamu kerjakan yang mana ini ditunjukan untuk agar kamu mengingat urutannya dengan baik sesuai judul dari bagian/fasenya serta juga sub-subnya dan juga agar kamu memberikan wawasan dan penjelasan yang melebihinya.

Pastikan setiap penjelasan yang Anda berikan tidak menyisakan pertanyaan, seolah-olah Anda sedang menjelaskan kepada seseorang yang benar-benar baru di bidang tersebut, namun tetap menjaga kedalaman teknis yang memadaibahkan untuk tingkat ahli. Tujuan utamanya adalah menciptakan materi pembelajaran yang menjelaskan setiap bagian/fase dengan sangat detail, mudah dipahami, akurat, dan dapat langsung digunakan sebagai referensi pembelajaran yang kuat dan profesional. Kamu tidak perlu menjawab semuanya sekaligus tetapi bertahap dari bagian ke bagian berikutnya sehingga kamu mendalami suatu bagian secara khusus dan mengofirmasi saya untuk melanjutkan pada bagian atau fase atau modul berikutnya.

Pastikan bahwa kamu menyerteakan sumber informasi yang kamu ambil secara dokumentasi resmi ataupun lainnya, intinya bahwa setiap materi ini harus memiliki acuhan sumber untuk menyatakan bahwa materi tersebut bukan hasil dari halusinasi AI tetapi mengacu pada sumber terpercaya dan komprehensif sebagai materi yang patut untuk dijadikan referensi pembelajaran
