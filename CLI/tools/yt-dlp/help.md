**yt-dlp -h**
**Penggunaan:** yt-dlp.exe

---

**Opsi Umum:**

- -h, --help :
  Tampilkan teks bantuan ini dan keluar

- --version :
  Tampilkan versi program dan keluar

- -U, **--update** :
  Perbarui program ini ke versi stabil terbaru

- --no-update:
  Jangan periksa pembaruan (default)

- --update-to [CHANNEL]@[TAG] :
  Tingkatkan/turunkan ke versi tertentu. CHANNEL dapat berupa repositori juga. CHANNEL dan TAG default ke "stabil" dan "terbaru" masing-masing jika dihilangkan; Lihat "PEMBARUAN" untuk detailnya. Saluran yang didukung: stabil, malam, master

- -i, **--ignore-errors**:
  Abaikan kesalahan unduhan dan pasca-pemrosesan. Unduhan akan dianggap berhasil meskipun pasca-pemrosesan gagal

- **--no-abort-on-error**:
  Lanjutkan dengan video berikutnya pada kesalahan unduhan; misalnya, untuk melewati video yang tidak tersedia dalam daftar putar (default)

- **--abort-on-error** : Hentikan pengunduhan video lebih lanjut jika terjadi kesalahan (Alias: --no-ignore-errors)
- **--dump-user-agent** : Tampilkan user-agent saat ini dan keluar
- --list-extractors: Daftar semua ekstraktor yang didukung dan keluar
- --extractor-descriptions: Keluaran deskripsi dari semua ekstraktor yang didukung dan keluar
  --use-extractors NAMA: Nama ekstraktor yang akan digunakan dipisahkan dengan koma. Anda juga dapat menggunakan regex, "semua", "default" dan "akhir" (pencocokan URL akhir); misalnya, --ies "holodex.\*,end,youtube". Awali nama dengan "-" untuk mengecualikannya, misalnya --ies default,-generic. Gunakan --list-extractors untuk daftar nama ekstraktor. (Alias: --ies)
- --default-search AWALAN: Gunakan awalan ini untuk URL yang tidak memenuhi syarat. Misalnya, "gvsearch2:python" mengunduh dua video dari Google Video untuk pencarian istilah "python". Gunakan nilai "otomatis" untuk membiarkan yt-dlp menebak ("peringatan_otomatis" untuk mengeluarkan peringatan saat menebak). "kesalahan" hanya menampilkan kesalahan. Nilai default "fixup_error" memperbaiki URL yang rusak, tetapi mengeluarkan kesalahan jika ini tidak mungkin alih-alih mencari
- --ignore-config: Jangan memuat file konfigurasi lainnya kecuali yang diberikan ke --config-locations. Untuk kompatibilitas mundur, jika opsi ini ditemukan di dalam file konfigurasi sistem, konfigurasi pengguna tidak dimuat. (Alias: --no-config)
- --no-config-locations: Jangan memuat file konfigurasi khusus apa pun (default). Saat diberikan di dalam file konfigurasi, abaikan semua --config-locations sebelumnya yang ditentukan dalam file saat ini
- --config-locations JALUR: Lokasi file konfigurasi utama; baik jalur ke konfigurasi atau direktori yang mengandungnya ("-" untuk stdin). Dapat digunakan beberapa kali dan di dalam file konfigurasi lainnya
- --plugin-dirs JALUR: Jalur ke direktori tambahan untuk mencari plugin. Opsi ini dapat digunakan beberapa kali untuk menambahkan beberapa direktori. Perhatikan bahwa ini saat ini hanya berfungsi untuk plugin ekstraktor; plugin pasca-pemrosesan hanya dapat dimuat dari direktori plugin default
- --flat-playlist: Jangan mengekstrak entri hasil URL daftar putar; beberapa metadata entri mungkin hilang dan pengunduhan mungkin dilewati
- --no-flat-playlist: Ekstrak sepenuhnya video dari daftar putar (default)
- --live-from-start: Unduh siaran langsung dari awal. Saat ini hanya didukung untuk YouTube (Eksperimental)
- --no-live-from-start: Unduh siaran langsung dari waktu saat ini (default)
- --wait-for-video MIN[-MAKS]: Tunggu hingga aliran terjadwal tersedia. Lewatkan jumlah detik minimum (atau rentang) untuk menunggu antara percobaan ulang
- --no-wait-for-video: Jangan menunggu aliran terjadwal (default)
- --mark-watched: Tandai video ditonton (bahkan dengan --simulate)
- --no-mark-watched: Jangan menandai video ditonton (default)
- --color [STREAM:]:KEBIJAKAN: Apakah akan mengeluarkan kode warna dalam output, secara opsional diawali dengan STREAM (stdout atau stderr) untuk menerapkan pengaturan ke. Dapat berupa "selalu", "otomatis" (default), "tidak pernah", atau "no_color" (gunakan urutan terminal tanpa warna). Gunakan "auto-tty" atau "no_color-tty" untuk memutuskan berdasarkan dukungan terminal saja. Dapat digunakan beberapa kali
- --compat-options OPTS: Opsi yang dapat membantu menjaga kompatibilitas dengan konfigurasi youtube-dl atau youtube-dlc dengan mengembalikan beberapa perubahan yang dilakukan dalam yt-dlp. Lihat "Perbedaan dalam perilaku default" untuk detailnya
- --alias ALIASES OPSI: Buat alias untuk string opsi. Kecuali alias dimulai dengan tanda hubung "-", itu diawali dengan "--". Argumen diurai sesuai dengan bahasa mini pemformatan string Python. Misalnya, --alias get-audio,-X "-S=aext:{0},abr -x --audio-format {0}" membuat opsi "--get-audio" dan "-X" yang mengambil argumen (ARG0) dan mengembang menjadi "-S=aext:ARG0,abr -x --audio-format ARG0". Semua alias yang ditentukan tercantum dalam output --help. Opsi alias dapat memicu lebih banyak alias; jadi berhati-hatilah untuk menghindari mendefinisikan opsi rekursif. Sebagai tindakan pencegahan, setiap alias dapat dipicu maksimal 100 kali. Opsi ini dapat digunakan beberapa kali

---

**Opsi Jaringan:**

- --proxy URL: Gunakan proxy HTTP/HTTPS/SOCKS yang ditentukan. Untuk mengaktifkan proxy SOCKS, tentukan skema yang benar, misalnya socks5://user:pass@127.0.0.1:1080/. Lewatkan string kosong (--proxy "") untuk koneksi langsung
- --socket-timeout DETIK: Waktu tunggu sebelum menyerah, dalam detik
- --source-address IP: Alamat IP sisi klien untuk mengikat
- --impersonate KLIEN[:OS]: Klien untuk ditiru untuk permintaan. Misalnya, chrome, chrome-110, chrome:windows-10. Lewatkan --impersonate="" untuk meniru klien apa pun. Perhatikan bahwa memaksakan peniruan untuk semua permintaan dapat berdampak buruk pada kecepatan unduhan dan stabilitas
- --list-impersonate-targets: Daftar klien yang tersedia untuk ditiru.
- -4, --force-ipv4: Lakukan semua koneksi melalui IPv4
- -6, --force-ipv6: Lakukan semua koneksi melalui IPv6
- --enable-file-urls: Aktifkan URL file://. Ini dinonaktifkan secara default karena alasan keamanan.

---

**Pembatasan Geo:**

- --geo-verification-proxy URL: Gunakan proxy ini untuk memverifikasi alamat IP untuk beberapa situs yang dibatasi secara geografis. Proxy default yang ditentukan oleh --proxy (atau tidak ada, jika opsi tidak ada) digunakan untuk pengunduhan aktual
- --xff NILAI: Cara memalsukan header HTTP X-Forwarded-For untuk mencoba melewati pembatasan geografis. Salah satu dari "default" (hanya ketika diketahui berguna), "never", blok IP dalam notasi CIDR, atau kode negara ISO 3166-2 dua huruf

---

**Pemilihan Video:**

- **-I**, --playlist-items ITEM_SPEC: Indeks playlist_index yang dipisahkan koma dari item yang akan diunduh. Anda dapat menentukan rentang menggunakan "[MULA]:[HENTI][:LANGKAH]". Untuk kompatibilitas mundur, MULA-HENTI juga didukung. Gunakan indeks negatif untuk menghitung dari kanan dan LANGKAH negatif untuk mengunduh dalam urutan terbalik. Misalnya, **`"-I 1:3,7,-5::2"`** yang digunakan pada daftar putar berukuran 15 akan mengunduh item pada indeks 1,2,3,7,11,13,15
- --min-filesize UKURAN: Hentikan unduhan jika ukuran file lebih kecil dari UKURAN, misalnya 50k atau 44,6M
- --max-filesize UKURAN: Hentikan unduhan jika ukuran file lebih besar dari UKURAN, misalnya 50k atau 44,6M
- --date TANGGAL: Unduh hanya video yang diunggah pada tanggal ini. Tanggal dapat berupa "YYYYMMDD" atau dalam format [sekarang|hari ini|kemarin]-N[hari|minggu|bulan|tahun]]. Misalnya, "--date today-2weeks" hanya mengunduh video yang diunggah pada hari yang sama dua minggu lalu
- --datebefore TANGGAL: Unduh hanya video yang diunggah pada atau sebelum tanggal ini. Format tanggal yang diterima sama dengan --date
- --dateafter TANGGAL: Unduh hanya video yang diunggah pada atau setelah tanggal ini. Format tanggal yang diterima sama dengan --date
- --match-filters FILTER: Filter video generik. Setiap bidang "TEMPLAT KELUARAN" dapat dibandingkan dengan angka atau string menggunakan operator yang ditentukan dalam "Memfilter Format". Anda juga dapat cukup menentukan bidang untuk dicocokkan jika bidang tersebut ada, dan "&" untuk memeriksa beberapa kondisi. Gunakan "\" untuk keluar dari "&" atau tanda kutip jika diperlukan. Jika digunakan beberapa kali, filter akan cocok jika setidaknya satu dari kondisi terpenuhi. Misalnya --match-filters !is_live --match-filters "like_count>?100 & description~='(?i)\bcats \& dogs\b'" hanya cocok dengan video yang tidak ditayangkan ATAU yang memiliki jumlah like lebih dari 100 (atau kolom like tidak tersedia) dan juga memiliki deskripsi yang berisi frasa "cats & dogs" (tanpa huruf besar/kecil). Gunakan "--match-filters -" untuk menanyakan secara interaktif apakah akan mengunduh setiap video

- **--no-match-filters:** Jangan gunakan --match-filters apa pun (default)
- **--break-match-filters FILTER:** Sama seperti "--match-filters" tetapi menghentikan proses unduhan saat video ditolak
- **--no-break-match-filters:** Jangan gunakan --break-match-filters apa pun (default)
- **--no-playlist:** Unduh hanya video, jika URL mengacu pada video dan daftar putar
- **--yes-playlist:** Unduh daftar putar, jika URL mengacu pada video dan daftar putar
- **--age-limit TAHUN:** Unduh hanya video yang sesuai untuk usia yang diberikan
- **--download-archive FILE:** Unduh hanya video yang tidak tercantum dalam file arsip. Rekam ID semua video yang diunduh di dalamnya
- **--no-download-archive:** Jangan gunakan file arsip (default)
- **--max-downloads NOMOR:** Hentikan setelah mengunduh NOMOR file
- **--break-on-existing:** Hentikan proses unduhan saat menemukan file yang ada dalam arsip yang disediakan dengan --download-archive
- **--no-break-on-existing:** Jangan hentikan proses unduhan saat menemukan file yang ada dalam arsip (default)
- **--break-per-input:** Mengubah --max-downloads, --break-on-existing, --break-match-filters, dan autonumber untuk mengatur ulang per URL input
- **--no-break-per-input:** --break-on-existing dan opsi serupa menghentikan seluruh antrian unduhan
- **--skip-playlist-after-errors N:** Jumlah kegagalan yang diizinkan hingga sisa daftar putar dilewati

---

**Opsi Unduhan:**

- -N, --concurrent-fragments N: Jumlah fragmen video dash/hlsnative yang harus diunduh secara bersamaan (default adalah 1)
- -r, --limit-rate KECEPATAN: Kecepatan unduhan maksimum dalam byte per detik, misalnya 50K atau 4.2M
- --throttled-rate KECEPATAN: Kecepatan unduhan minimum dalam byte per detik di bawahnya pembatasan diasumsikan dan data video diekstrak ulang, misalnya 100K
- -R, --retries PERCOBAAN_ULANG: Jumlah percobaan ulang (default adalah 10), atau "tak terbatas"
- --file-access-retries PERCOBAAN_ULANG: Jumlah kali mencoba ulang pada kesalahan akses file (default adalah 3), atau "tak terbatas"
- --fragment-retries PERCOBAAN_ULANG: Jumlah percobaan ulang untuk fragmen (default adalah 10), atau "tak terbatas" (DASH, hlsnative dan ISM)
- --retry-sleep [TIPE:]:WAKTU: Waktu untuk tidur di antara percobaan ulang dalam detik (opsional) diawali dengan jenis percobaan ulang (http (default), fragment, file_access, extractor) untuk menerapkan waktu tidur. WAKTU dapat berupa angka, linear=MULA[:AKHIR[:LANGKAH=1]] atau exp=MULA[:AKHIR[:DASAR=2]]. Opsi ini dapat digunakan beberapa kali untuk mengatur waktu tidur untuk berbagai jenis percobaan ulang, misalnya --retry-sleep linear=1::2 --retry-sleep fragment:exp=1:20
- --skip-unavailable-fragments: Lewati fragmen yang tidak tersedia untuk unduhan DASH, hlsnative dan ISM (default) (Alias: --no-abort-on-unavailable-fragments)
- --abort-on-unavailable-fragments: Hentikan unduhan jika fragmen tidak tersedia (Alias: --no-skip-unavailable-fragments)
- --keep-fragments: Simpan fragmen yang diunduh di disk setelah pengunduhan selesai
- --no-keep-fragments: Hapus fragmen yang diunduh setelah pengunduhan selesai (default)
- --buffer-size UKURAN: Ukuran buffer unduhan, misalnya 1024 atau 16K (default adalah 1024)
- --resize-buffer: Ukuran buffer secara otomatis diubah ukurannya dari nilai awal --buffer-size (default)
- --no-resize-buffer: Jangan sesuaikan ukuran buffer secara otomatis
- --http-chunk-size UKURAN: Ukuran potongan untuk pengunduhan HTTP berbasis potongan, misalnya 10485760 atau 10M (default dinonaktifkan). Mungkin berguna untuk melewati pembatasan bandwidth yang diberlakukan oleh webserver (eksperimental)
- --playlist-random: Unduh video daftar putar dalam urutan acak
- --lazy-playlist: Proses entri dalam daftar putar saat diterima. Ini menonaktifkan n_entries, --playlist-random dan --playlist-reverse
- --no-lazy-playlist: Proses video dalam daftar putar hanya setelah seluruh daftar putar diurai (default)
- --xattr-set-filesize: Setel atribut file x ytdl.filesize dengan ukuran file yang diharapkan
- --hls-use-mpegts: Gunakan wadah mpegts untuk video HLS; memungkinkan beberapa pemutar memutar video saat mengunduh, dan mengurangi kemungkinan kerusakan file jika unduhan terganggu. Ini diaktifkan secara default untuk streaming langsung
- --no-hls-use-mpegts: Jangan gunakan wadah mpegts untuk video HLS. Ini adalah default saat tidak mengunduh streaming langsung
- --download-sections REGEX: Unduh hanya bab yang cocok dengan ekspresi reguler. Awalan "\*" menunjukkan rentang waktu alih-alih bab.
- --downloader [PROTO:]:NAMA: Nama atau jalur pengunduh eksternal yang akan digunakan (opsional) diawali dengan protokol (http, ftp, m3u8, dash, rstp, rtmp, mms) untuk menggunakannya. Saat ini mendukung native, aria2c, avconv, axel, curl, ffmpeg, httpie, wget. Anda dapat menggunakan opsi ini beberapa kali untuk mengatur pengunduh yang berbeda untuk protokol yang berbeda. Misalnya, --downloader aria2c --downloader "dash,m3u8:native" akan menggunakan aria2c untuk unduhan http/ftp, dan pengunduh asli untuk unduhan dash/m3u8 (Alias: --external-downloader)

**--downloader-args NAMA:ARGUMEN**

- **Terjemahan:** Berikan argumen-argumen ini kepada pengunduh eksternal. Tentukan nama pengunduh dan argumen-argumennya yang dipisahkan oleh titik dua ":".
- **Penjelasan:** Opsi ini memungkinkan Anda untuk memberikan argumen khusus kepada pengunduh eksternal yang digunakan oleh yt-dlp (misalnya, `aria2c`, `ffmpeg`).
  - **Contoh:** Jika Anda ingin menggunakan `aria2c` sebagai pengunduh dan memberikan argumen `--max-concurrent-downloads=5` kepadanya, Anda dapat menggunakan: `--downloader aria2c --downloader-args aria2c:--max-concurrent-downloads=5`
  - Untuk `ffmpeg`, Anda dapat menggunakan sintaks yang sama seperti opsi `--postprocessor-args` untuk meneruskan argumen ke posisi yang berbeda dalam perintah `ffmpeg`.

---

**Opsi Berkas Sistem**

- **-a, --batch-file FILE**

  - **Terjemahan:** File yang berisi URL-URL untuk diunduh ("-" untuk stdin), satu URL per baris. Baris yang diawali dengan "#", ";" atau "]" dianggap sebagai komentar dan diabaikan.
  - **Penjelasan:** Dengan opsi ini, Anda dapat menyediakan sebuah file teks yang berisi daftar URL video yang ingin Anda unduh. Setiap URL harus dituliskan pada satu baris. yt-dlp akan secara otomatis mengunduh semua URL yang tercantum dalam file tersebut.

- **--no-batch-file**

  - **Terjemahan:** Jangan membaca URL dari file batch (default).
  - **Penjelasan:** Opsi ini menonaktifkan penggunaan file batch. Jika opsi ini digunakan, yt-dlp akan hanya mengunduh URL yang diberikan secara langsung sebagai argumen pada baris perintah.

- **-P, --paths [TIPE:]JALUR**

  - **Terjemahan:** Jalur-jalur tempat file-file harus diunduh. Tentukan tipe file dan jalur yang dipisahkan oleh titik dua ":". Semua TIPE yang sama dengan `--output` didukung. Selain itu, Anda juga dapat menyediakan jalur "home" (default) dan "temp". Semua file perantara pertama-tama diunduh ke jalur "temp" dan kemudian file akhir dipindahkan ke jalur "home" setelah unduhan selesai. Opsi ini diabaikan jika `--output` adalah jalur absolut.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menentukan lokasi penyimpanan file yang diunduh berdasarkan tipe file.
    - **Contoh:** `--paths video:/path/to/videos audio:/path/to/audio` akan menyimpan file video di `/path/to/videos` dan file audio di `/path/to/audio`.

- **-o, --output [TIPE:]TEMPLATE**

  - **Terjemahan:** Template nama file keluaran; lihat "OUTPUT TEMPLATE" untuk detailnya.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menentukan format nama file yang akan digunakan untuk menyimpan file yang diunduh. Anda dapat menggunakan berbagai variabel dalam template ini untuk menyesuaikan nama file.

- **--output-na-placeholder TEKS**

  - **Terjemahan:** Placeholder untuk bidang yang tidak tersedia dalam `--output` (default: "NA").
  - **Penjelasan:** Ketika menggunakan template nama file, jika ada informasi yang tidak tersedia untuk suatu bidang (misalnya, judul video tidak ditemukan), maka placeholder ini akan digunakan dalam nama file.

- **--restrict-filenames**

  - **Terjemahan:** Batasi nama file hanya pada karakter ASCII, dan hindari "&" dan spasi dalam nama file.
  - **Penjelasan:** Opsi ini akan memastikan bahwa nama file hanya terdiri dari karakter ASCII (huruf, angka, dan beberapa simbol dasar). Hal ini dapat membantu menghindari masalah kompatibilitas pada beberapa sistem operasi.

- **--no-restrict-filenames**

  - **Terjemahan:** Izinkan karakter Unicode, "&" dan spasi dalam nama file (default).
  - **Penjelasan:** Opsi ini memungkinkan penggunaan karakter Unicode (seperti huruf beraksen) dan karakter khusus seperti "&" dan spasi dalam nama file.

- **--windows-filenames**

  - **Terjemahan:** Paksa nama file menjadi kompatibel dengan Windows.
  - **Penjelasan:** Opsi ini akan memaksa nama file untuk mengikuti aturan penamaan file yang berlaku pada sistem operasi Windows.

- **--no-windows-filenames**

  - **Terjemahan:** Buat nama file kompatibel dengan Windows hanya jika menggunakan Windows (default).
  - **Penjelasan:** Opsi ini hanya akan membuat nama file kompatibel dengan Windows jika yt-dlp dijalankan pada sistem operasi Windows.

- **--trim-filenames PANJANG**

  - **Terjemahan:** Batasi panjang nama file (tidak termasuk ekstensi) ke jumlah karakter yang ditentukan.
  - **Penjelasan:** Opsi ini digunakan untuk membatasi panjang nama file untuk menghindari nama file yang terlalu panjang.

- **-w, --no-overwrites**

  - **Terjemahan:** Jangan menimpa file apa pun.
  - **Penjelasan:** Jika opsi ini digunakan, yt-dlp tidak akan menimpa file yang sudah ada dengan nama yang sama. Jika ditemukan file dengan nama yang sama, proses unduhan akan dilewati.

- **--force-overwrites**

  - **Terjemahan:** Timpa semua file video dan metadata. Opsi ini termasuk `--no-continue`.
  - **Penjelasan:** Opsi ini akan memaksa yt-dlp untuk menimpa semua file yang sudah ada, termasuk file video dan file metadata.

- **--no-force-overwrites**

  - **Terjemahan:** Jangan menimpa video, tetapi timpa file terkait (default).
  - **Penjelasan:** Opsi ini akan memungkinkan penimpaan file terkait seperti file metadata (.info.json, .description), tetapi tidak akan menimpa file video itu sendiri.

- **-c, --continue**

  - **Terjemahan:** Lanjutkan unduhan file/fragmen yang telah diunduh sebagian (default).
  - **Penjelasan:** Jika opsi ini aktif, yt-dlp akan mencoba melanjutkan unduhan file yang sebelumnya telah diunduh sebagian.

- **--no-continue**

  - **Terjemahan:** Jangan melanjutkan unduhan fragmen yang diunduh sebagian. Jika file tidak terfragmentasi, mulai ulang unduhan seluruh file.
  - **Penjelasan:** Opsi ini akan mencegah yt-dlp melanjutkan unduhan yang telah dihentikan sebelumnya. Jika file tidak diunduh dalam bentuk fragmen, maka unduhan akan dimulai dari awal.

- **--part"../../../yt-dlp"**

  - **Terjemahan:** Gunakan file .part "../../../yt-dlp"alih-alih menulis langsung ke file output (default).
  - **Penjelasan:** Opsi ini akan membuat file sementara dengan ekstensi ".part" selama proses unduhan berlangsung. Setelah unduhan selesai, file ".part" akan diganti namanya menjadi nama file yang sebenarnya.

- **--no-part"../../../yt-dlp"**

  - **Terjemahan:** Jangan gunakan file .part "../../../yt-dlp"- tulis langsung ke file output.
  - **Penjelasan:** Opsi ini akan membuat yt-dlp menulis langsung ke file output tanpa menggunakan file ".part" sementara.

- **--mtime**

  - **Terjemahan:** Gunakan header Last-modified untuk mengatur waktu modifikasi file (default).
  - **Penjelasan:** Opsi ini akan menggunakan informasi "Last-modified" dari server web untuk mengatur waktu modifikasi file yang diunduh.

- **--no-mtime**

  - **Terjemahan:** Jangan gunakan header Last-modified untuk mengatur waktu modifikasi file.
  - **Penjelasan:** Opsi ini akan menonaktifkan penggunaan header "Last-modified" untuk mengatur waktu modifikasi file.

- **--write-description**

  - **Terjemahan:** Tulis deskripsi video ke file .description.
  - **Penjelasan:** Opsi ini akan menyimpan deskripsi video ke dalam file terpisah dengan ekstensi ".description".

- **--no-write-description**
  - **Terjemahan:** Jangan menulis deskripsi video (default).
  - **Penjelasan:** Opsi ini akan mencegah yt-dlp menyimpan deskripsi video ke file terpisah.

---

**Opsi Metadata dan Cookie**

- **--write-info-json**

  - **Terjemahan:** Tulis metadata video ke file .info.json (ini mungkin berisi informasi pribadi).
  - **Penjelasan:** Opsi ini akan menyimpan metadata video, seperti judul, deskripsi, ID video, durasi, dll., ke dalam file JSON dengan ekstensi ".info.json". File ini dapat berguna untuk analisis data atau digunakan oleh aplikasi lain.

- **--no-write-info-json**

  - **Terjemahan:** Jangan menulis metadata video (default).
  - **Penjelasan:** Opsi ini akan mencegah yt-dlp menyimpan metadata video ke file JSON.

- **--write-playlist-metafiles**

  - **Terjemahan:** Tulis metadata playlist selain metadata video saat menggunakan `--write-info-json`, `--write-description`, dll. (default).
  - **Penjelasan:** Jika Anda mengunduh video dari daftar putar, opsi ini akan menyimpan metadata playlist (seperti judul playlist, jumlah video, dll.) ke dalam file terpisah.

- **--no-write-playlist-metafiles**

  - **Terjemahan:** Jangan menulis metadata playlist saat menggunakan `--write-info-json`, `--write-description`, dll.
  - **Penjelasan:** Opsi ini akan mencegah yt-dlp menyimpan metadata playlist ke file terpisah.

- **--clean-info-json**

  - **Terjemahan:** Hapus beberapa metadata internal seperti nama file dari infojson (default).
  - **Penjelasan:** Opsi ini akan menghapus beberapa informasi internal dari file .info.json, seperti jalur penyimpanan file video, untuk mengurangi ukuran file dan melindungi privasi.

- **--no-clean-info-json**

  - **Terjemahan:** Tulis semua bidang ke infojson.
  - **Penjelasan:** Opsi ini akan menuliskan semua informasi metadata ke file .info.json tanpa menghapus informasi internal.

- **--write-comments**

  - **Terjemahan:** Ambil komentar video untuk ditempatkan di infojson. Komentar diambil bahkan tanpa opsi ini jika proses ekstraksi diketahui cepat (Alias: `--get-comments`).
  - **Penjelasan:** Opsi ini akan mengambil komentar yang terkait dengan video dan menambahkannya ke dalam file .info.json.

- **--no-write-comments**

  - **Terjemahan:** Jangan ambil komentar video kecuali jika proses ekstraksi diketahui cepat (Alias: `--no-get-comments`).
  - **Penjelasan:** Opsi ini akan mencegah yt-dlp mengambil dan menyimpan komentar video ke dalam file .info.json.

- **--load-info-json FILE**

  - **Terjemahan:** File JSON yang berisi informasi video (dibuat dengan opsi "--write-info-json").
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menggunakan file .info.json yang telah dibuat sebelumnya untuk mengunduh video. Dengan menggunakan file ini, yt-dlp dapat menggunakan informasi yang telah diekstrak sebelumnya untuk mempercepat proses unduhan.

- **--cookies FILE**

  - **Terjemahan:** File berformat Netscape untuk membaca cookie dari dan menyimpan cookie jar ke dalamnya.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menggunakan file cookie yang telah disimpan sebelumnya untuk melakukan autentikasi ke situs web yang memerlukan login.

- **--no-cookies**

  - **Terjemahan:** Jangan membaca/menyimpan cookie dari/ke file (default).
  - **Penjelasan:** Opsi ini akan menonaktifkan penggunaan file cookie.

- **--cookies-from-browser BROWSER[+KEYRING][:PROFILE][::CONTAINER]**

  - **Terjemahan:** Nama browser untuk memuat cookie dari. Browser yang didukung saat ini adalah: brave, chrome, chromium, edge, firefox, opera, safari, vivaldi, whale. Secara opsional, KEYRING yang digunakan untuk mendekripsi cookie Chromium pada Linux, nama/jalur PROFILE untuk memuat cookie dari, dan nama CONTAINER (jika Firefox) ("none" untuk tidak ada wadah) dapat diberikan dengan pemisah masing-masing. Secara default, semua wadah dari profil yang paling terakhir diakses digunakan.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menggunakan cookie yang disimpan di browser web Anda (seperti Chrome, Firefox) untuk melakukan autentikasi ke situs web yang memerlukan login.

- **--no-cookies-from-browser**

  - **Terjemahan:** Jangan muat cookie dari browser (default).
  - **Penjelasan:** Opsi ini akan menonaktifkan penggunaan cookie dari browser web.

- **--cache-dir DIR**

  - **Terjemahan:** Lokasi di sistem file tempat yt-dlp dapat menyimpan beberapa informasi yang diunduh (seperti ID klien dan tanda tangan) secara permanen. Secara default ${XDG_CACHE_HOME}/yt-dlp.
  - **Penjelasan:** Opsi ini menentukan lokasi penyimpanan cache yt-dlp. Cache ini digunakan untuk menyimpan informasi yang dapat mempercepat proses unduhan di masa mendatang.

- **--no-cache-dir**

  - **Terjemahan:** Nonaktifkan penyimpanan cache di sistem file.
  - **Penjelasan:** Opsi ini akan menonaktifkan penggunaan cache yt-dlp.

- **--rm-cache-dir**
  - **Terjemahan:** Hapus semua file cache di sistem file.
  - **Penjelasan:** Opsi ini akan menghapus semua file cache yt-dlp yang tersimpan di lokasi cache.

---

**Opsi Thumbnail**

- **--write-thumbnail**

  - **Terjemahan:** Tulis gambar thumbnail ke disk.
  - **Penjelasan:** Opsi ini akan menyimpan gambar thumbnail video ke dalam file terpisah.

- **--no-write-thumbnail**

  - **Terjemahan:** Jangan tulis gambar thumbnail ke disk (default).
  - **Penjelasan:** Opsi ini akan mencegah yt-dlp menyimpan gambar thumbnail video ke dalam file terpisah.

- **--write-all-thumbnails**

  - **Terjemahan:** Tulis semua format gambar thumbnail ke disk.
  - **Penjelasan:** Opsi ini akan menyimpan semua format gambar thumbnail yang tersedia ke dalam file terpisah.

- **--list-thumbnails**
  - **Terjemahan:** Daftar thumbnail yang tersedia untuk setiap video. Simulasikan kecuali --no-simulate digunakan.
  - **Penjelasan:** Opsi ini akan menampilkan daftar format thumbnail yang tersedia untuk setiap video tanpa melakukan unduhan.

---

**Opsi Pintasan Internet**

- **--write-link** (Menulis file pintasan internet, tergantung platform saat ini (.url, .webloc atau .desktop). URL mungkin di-cache oleh OS)
  - **Terjemahan:** Menulis file pintasan internet tergantung pada platform yang digunakan (Windows: .url, macOS: .webloc, Linux: .desktop). File ini berisi tautan ke video YouTube dan memungkinkan Anda untuk membuka video tersebut di browser web default Anda dengan sekali klik.
  - **Penjelasan:** Opsi ini berguna untuk membuat pintasan cepat ke video YouTube di desktop Anda.
  - **Opsi tambahan:**
    - **--write-url-link:** Khusus menulis file pintasan .url untuk Windows.
    - **--write-webloc-link:** Khusus menulis file pintasan .webloc untuk macOS.
    - **--write-desktop-link:** Khusus menulis file pintasan .desktop untuk Linux.

---

**Opsi Verbositas dan Simulasi**

- **-q, --quiet** (Mengaktifkan mode tenang. Jika digunakan dengan --verbose, cetak log ke stderr)
  - **Terjemahan:** Menonaktifkan output ke konsol. Ini berguna untuk menjalankan yt-dlp secara diam-diam di latar belakang.
  - **Penjelasan:** Opsi ini berguna jika Anda tidak ingin melihat output dari yt-dlp saat dijalankan.
- **--no-quiet** (Menonaktifkan mode tenang. (Default))
  - **Terjemahan:** Mengaktifkan output ke konsol. (Default)
  - **Penjelasan:** Opsi ini membiarkan yt-dlp mencetak informasi ke konsol seperti biasa.
- **--no-warnings** (Mengabaikan peringatan)
  - **Terjemahan:** Mengabaikan peringatan yang dikeluarkan yt-dlp selama proses pengunduhan.
  - **Penjelasan:** Opsi ini berguna jika Anda tidak ingin melihat peringatan yang mungkin tidak relevan dengan proses pengunduhan Anda.
- **-s, --simulate** (Jangan unduh video dan jangan menulis apa pun ke disk)
  - **Terjemahan:** Melakukan simulasi unduhan tanpa benar-benar mengunduh video atau menulis file apa pun ke disk.
  - **Penjelasan:** Opsi ini berguna untuk melihat informasi tentang video, seperti judul, deskripsi, dan format yang tersedia, tanpa benar-benar mengunduhnya.
- **--no-simulate** (Unduh video bahkan jika opsi cetak/daftar digunakan)
  - **Terjemahan:** Mengunduh video meskipun opsi cetak atau daftar digunakan (seperti --print atau --list-thumbnails).
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk mencetak informasi atau daftar opsi yang tersedia sambil tetap mengunduh video.
- **--ignore-no-formats-error** (Mengabaikan kesalahan "Tidak Ada Format Video". Berguna untuk mengekstrak metadata meskipun video sebenarnya tidak tersedia untuk diunduh (eksperimental))
  - **Terjemahan:** Mengabaikan kesalahan "Tidak Ada Format Video" yang mungkin terjadi jika video tidak tersedia untuk diunduh. Ini memungkinkan Anda untuk mengekstrak metadata video meskipun Anda tidak dapat mengunduhnya.
  - **Penjelasan:** Opsi ini berguna untuk mendapatkan informasi tentang video yang mungkin dihapus atau diprivatekan.
- **--no-ignore-no-formats-error** (Membuang kesalahan saat tidak ada format video yang dapat diunduh (default))
  - **Terjemahan:** Membiarkan yt-dlp menampilkan kesalahan "Tidak Ada Format Video" jika video tidak tersedia untuk diunduh. (Default)
  - **Penjelasan:** Opsi ini membantu memastikan Anda mengetahui jika video yang Anda coba unduh tidak tersedia.
- **--skip-download** (Jangan unduh video tetapi tulis semua file terkait (Alias: --no-download))
  - **Terjemahan:** Melewati unduhan video tetapi tetap menulis file terkait lainnya, seperti file info.json atau thumbnail. (Alias: --no-download)
  - **Penjelasan:** Opsi ini berguna jika Anda hanya membutuhkan metadata atau thumbnail dari video dan tidak perlu mengunduh video itu sendiri.

---

**Opsi Pencetakan dan Pencatatan**

- **-O, --print [WHEN:]TEMPLATE** (Nama bidang atau template output untuk dicetak ke layar, secara opsional diawali dengan kapan untuk mencetaknya, dipisahkan oleh ":". Nilai yang didukung dari "WHEN" sama dengan --use-postprocessor (default: video). Menyarankan --quiet. Menyarankan --simulate kecuali --no-simulate atau tahap selanjutnya dari WHEN digunakan. Opsi ini dapat digunakan beberapa kali)

  - **Terjemahan:** Mencetak informasi tertentu tentang video ke konsol. Anda dapat menentukan informasi mana yang ingin dicetak menggunakan template.

- **--print-to-file [WHEN:]TEMPLATE FILE**

  - **Terjemahan:** Menambahkan template yang diberikan ke file tertentu. Nilai WHEN dan TEMPLATE sama dengan opsi `--print`. Sintaks untuk FILE sama dengan template output. Opsi ini dapat digunakan beberapa kali.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk mencetak informasi video tertentu ke file teks alih-alih ke konsol. Anda dapat menentukan informasi yang ingin dicetak menggunakan template dan menyimpannya ke file yang Anda tentukan.
  - **Contoh:**
    - `--print-to-file title:%(title)s.txt` - Mencetak judul video ke file bernama `title.txt`.
    - `--print-to-file download:eta:%(eta)s ETA осталось --to-file duration:%(duration)s` - Mencetak perkiraan waktu tersisa (ETA) dan durasi video ke file yang sama.

- **-j, --dump-json**
  - **Terjemahan:** Mencetak informasi JSON untuk setiap video secara diam-diam (tidak menampilkan output lain). Melakukan simulasi kecuali `--no-simulate` digunakan. Lihat "OUTPUT TEMPLATE" untuk deskripsi lengkap mengenai key yang tersedia.
  - **Penjelasan:** Opsi ini berguna untuk mengekstrak informasi video dalam format JSON yang dapat digunakan oleh program lain. Simulasi digunakan secara default untuk mencegah pengunduhan video yang sebenarnya.
- **-J, --dump-single-json**

  - **Terjemahan:** Mencetak informasi JSON untuk setiap URL atau infojson yang diberikan secara diam-diam (tidak menampilkan output lain). Melakukan simulasi kecuali `--no-simulate` digunakan. Jika URL merujuk ke playlist, seluruh informasi playlist akan dicetak dalam satu baris.
  - **Penjelasan:** Mirip dengan `--dump-json`, opsi ini mengekstrak informasi JSON tetapi untuk setiap URL atau file infojson yang diberikan. Ini berguna untuk memproses informasi dari beberapa video atau playlist.

- **--force-write-archive** (Alias: --force-download-archive)

  - **Terjemahan:** Memaksa entri arsip unduhan untuk ditulis selama tidak ada kesalahan yang terjadi, bahkan jika opsi simulasi digunakan (`-s` atau lainnya).
  - **Penjelasan:** Opsi ini berguna saat menggunakan fitur arsip yt-dlp untuk melacak unduhan sebelumnya. Biasanya, opsi simulasi akan mencegah entri arsip ditulis selama simulasi. Opsi ini memaksa entri ditulis bahkan saat simulasi, selama tidak ada kesalahan yang terjadi.

- **--newline**

  - **Terjemahan:** Mencetak progress bar di baris baru.
  - **Penjelasan:** Opsi ini mengubah tampilan progress bar menjadi format multi-line, sehingga output lainnya tidak terganggu.

- **--no-progress**

  - **Terjemahan:** Menonaktifkan progress bar.
  - **Penjelasan:** Opsi ini menyembunyikan progress bar sepenuhnya.

- **--progress**

  - **Terjemahan:** Menampilkan progress bar, bahkan dalam mode diam (`--quiet`).
  - **Penjelasan:** Opsi ini memaksa progress bar ditampilkan meskipun mode diam diaktifkan.

- **--console-title**

  - **Terjemahan:** Menampilkan kemajuan unduhan di title bar konsol.
  - **Penjelasan:** Opsi ini menampilkan informasi kemajuan unduhan, seperti judul video dan perkiraan waktu tersisa (ETA), di title bar konsol Anda.

- **--progress-template [TYPES:]TEMPLATE**

  - **Terjemahan:** Template untuk output kemajuan, secara opsional diawali dengan salah satu dari "download:" (default), "download-title:" (judul konsol), "postprocess:", atau "postprocess-title:". Bidang video dapat diakses di bawah key "info" dan atribut kemajuan diakses di bawah key "progress". Contoh: `--console-title --progress-template "download-title:%(info.id)s-%(progress.eta)s"`
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menyesuaikan format progress bar dengan menentukan template kustom. Template dapat menyertakan berbagai atribut yang terkait dengan video dan kemajuan unduhan.

- **--progress-delta SECONDS**

  - **Terjemahan:** Waktu antara output kemajuan (default: 0).
  - **Penjelasan:** Menentukan interval waktu (dalam detik) antara setiap pembaruan progress bar yang ditampilkan. Nilai default adalah 0, yang berarti progress bar akan diperbarui sesering mungkin.

- **-v, --verbose**

  - **Terjemahan:** Mencetak berbagai informasi debugging.
  - **Penjelasan:** Opsi ini menampilkan informasi debugging yang lebih terperinci, seperti permintaan HTTP yang dilakukan, respons dari server, dan langkah-langkah internal yang dilakukan oleh yt-dlp.

- **--dump-pages**

  - **Terjemahan:** Mencetak halaman yang diunduh dengan encoding base64 untuk debugging masalah (sangat verbose).
  - **Penjelasan:** Opsi ini mencetak halaman web yang diunduh oleh yt-dlp dalam format base64, yang dapat membantu dalam debugging masalah koneksi atau masalah dengan konten web.

- **--write-pages**

  - **Terjemahan:** Menulis halaman perantara yang diunduh ke file dalam direktori saat ini untuk debugging masalah.
  - **Penjelasan:** Opsi ini menyimpan halaman web perantara yang diunduh oleh yt-dlp ke dalam file terpisah di direktori saat ini, yang dapat membantu dalam analisis dan debugging masalah.

- **--print-traffic**
  - **Terjemahan:** Menampilkan lalu lintas HTTP yang dikirim dan diterima.
  - **Penjelasan:** Opsi ini menampilkan informasi tentang data yang dikirim dan diterima selama interaksi yt-dlp dengan server web, termasuk permintaan HTTP dan respons server.

**Solusi Sementara (Workarounds)**

- **--encoding ENCODING**

  - **Terjemahan:** Memaksa encoding yang ditentukan (eksperimental).
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk memaksa yt-dlp menggunakan encoding tertentu untuk memproses data. Namun, perlu diperhatikan bahwa opsi ini masih dalam tahap eksperimental.

- **--legacy-server-connect**

  - **Terjemahan:** Secara eksplisit mengizinkan koneksi HTTPS ke server yang tidak mendukung renegotiasi aman RFC 5746.
  - **Penjelasan:** Opsi ini digunakan dalam situasi khusus di mana server web tidak mendukung fitur keamanan tertentu yang diperlukan oleh yt-dlp.

- **--no-check-certificates**

  - **Terjemahan:** Menekan validasi sertifikat HTTPS.
  - **Penjelasan:** **Peringatan:** Opsi ini dapat mengurangi keamanan koneksi. Gunakan dengan hati-hati. Opsi ini menonaktifkan verifikasi sertifikat SSL/TLS, yang dapat meningkatkan risiko keamanan. Hanya gunakan opsi ini jika Anda benar-benar yakin bahwa koneksi yang Anda buat aman.

- **--prefer-insecure**

  - **Terjemahan:** Menggunakan koneksi yang tidak terenkripsi untuk mengambil informasi tentang video (Saat ini hanya didukung untuk YouTube).
  - **Penjelasan:** **Peringatan:** Opsi ini dapat mengurangi keamanan koneksi. Gunakan dengan hati-hati. Opsi ini memaksa yt-dlp untuk menggunakan koneksi HTTP (tidak terenkripsi) untuk mengambil informasi tentang video.

- **--add-headers FIELD:VALUE**

  - **Terjemahan:** Menentukan header HTTP kustom dan nilainya, dipisahkan oleh titik dua ":". Anda dapat menggunakan opsi ini beberapa kali.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menambahkan header HTTP kustom ke permintaan yang dikirim oleh yt-dlp. Contohnya, Anda dapat menggunakannya untuk mensimulasikan browser tertentu atau untuk memberikan informasi tambahan kepada server.

- **--bidi-workaround**

  - **Terjemahan:** Menangani terminal yang tidak mendukung teks bidireksional. Membutuhkan eksekusi bidiv atau fribidi di PATH.
  - **Penjelasan:** Opsi ini digunakan untuk mengatasi masalah tampilan teks bidireksional (seperti bahasa Arab atau Ibrani) pada beberapa terminal.

- **--sleep-requests SECONDS**

  - **Terjemahan:** Jumlah detik untuk tidur di antara permintaan selama ekstraksi data.
  - **Penjelasan:** Opsi ini menentukan jeda waktu (dalam detik) antara setiap permintaan yang dikirim oleh yt-dlp ke server web. Ini dapat membantu mengurangi beban pada server.

- **--sleep-interval SECONDS**

  - **Terjemahan:** Jumlah detik untuk tidur sebelum setiap unduhan. Ini adalah waktu tidur minimum saat digunakan bersama dengan `--max-sleep-interval` (Alias: `--min-sleep-interval`).
  - **Penjelasan:** Opsi ini menentukan waktu tidur minimum sebelum setiap unduhan dimulai.

- **--max-sleep-interval SECONDS**

  - **Terjemahan:** Jumlah detik maksimum untuk tidur. Hanya dapat digunakan bersama dengan `--min-sleep-interval`.
  - **Penjelasan:** Opsi ini menentukan waktu tidur maksimum sebelum setiap unduhan dimulai.

- **--sleep-subtitles SECONDS**
  - **Terjemahan:** Jumlah detik untuk tidur sebelum setiap unduhan subtitle.
  - **Penjelasan:** Opsi ini menentukan jeda waktu (dalam detik) sebelum setiap unduhan subtitle dimulai.

---

**OPSI FORMAT VIDEO**

- **-f, --format FORMAT**

  - **Terjemahan:** Kode format video, lihat "PEMILIHAN FORMAT" untuk detail lebih lanjut.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menentukan format video yang ingin Anda unduh menggunakan kode format yang spesifik. Kode format dapat ditemukan dengan menggunakan opsi `-F` (lihat di bawah).
  - **Contoh:**
    - `-f best` - Mengunduh video dalam format terbaik yang tersedia.
    - `-f mp4` - Mengunduh video dalam format MP4.
    - `-f 18` - Mengunduh video dengan kode format 18 (biasanya 360p).

- **-S, --format-sort SORTORDER**

  - **Terjemahan:** Mengurutkan format berdasarkan bidang yang diberikan, lihat "Pengurutan Format" untuk detail lebih lanjut.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menentukan urutan pengurutan format video berdasarkan kriteria tertentu, seperti resolusi, bitrate, atau jenis codec.
  - **Contoh:**
    - `-S res` - Mengurutkan format berdasarkan resolusi (dari terendah ke tertinggi).
    - `-S res:-1` - Mengurutkan format berdasarkan resolusi (dari tertinggi ke terendah).
    - `-S res,abr` - Mengurutkan format berdasarkan resolusi terlebih dahulu, kemudian berdasarkan bitrate audio.

- **--format-sort-force**

  - **Terjemahan:** Memaksa urutan pengurutan yang ditentukan pengguna untuk memiliki prioritas di atas semua bidang, lihat "Pengurutan Format" untuk detail lebih lanjut (Alias: `--S-force`).
  - **Penjelasan:** Opsi ini memastikan bahwa urutan pengurutan yang Anda tentukan menggunakan `-S` akan diprioritaskan di atas semua kriteria pengurutan internal yt-dlp.

- **--no-format-sort-force**

  - **Terjemahan:** Beberapa bidang memiliki prioritas di atas urutan pengurutan yang ditentukan pengguna (default).
  - **Penjelasan:** Opsi ini memungkinkan yt-dlp untuk mempertimbangkan kriteria pengurutan internal tertentu meskipun Anda telah menentukan urutan pengurutan menggunakan `-S`.

- **--video-multistreams**

  - **Terjemahan:** Mengizinkan beberapa aliran video untuk digabungkan menjadi satu file.
  - **Penjelasan:** Jika video mengandung beberapa aliran video (misalnya, dengan resolusi berbeda), opsi ini akan menggabungkan semua aliran video tersebut menjadi satu file.

- **--no-video-multistreams**

  - **Terjemahan:** Hanya satu aliran video yang diunduh untuk setiap file output (default).
  - **Penjelasan:** Opsi ini akan mengunduh hanya satu aliran video untuk setiap file output.

- **--audio-multistreams**

  - **Terjemahan:** Mengizinkan beberapa aliran audio untuk digabungkan menjadi satu file.
  - **Penjelasan:** Jika video mengandung beberapa aliran audio (misalnya, dalam bahasa yang berbeda), opsi ini akan menggabungkan semua aliran audio tersebut menjadi satu file.

- **--no-audio-multistreams**

  - **Terjemahan:** Hanya satu aliran audio yang diunduh untuk setiap file output (default).
  - **Penjelasan:** Opsi ini akan mengunduh hanya satu aliran audio untuk setiap file output.

- **--prefer-free-formats**

  - **Terjemahan:** Lebih memilih format video dengan wadah bebas daripada wadah non-bebas dengan kualitas yang sama. Gunakan dengan "-S ext" untuk secara ketat lebih memilih wadah bebas terlepas dari kualitas.
  - **Penjelasan:** Opsi ini akan memberikan prioritas kepada format video yang menggunakan wadah bebas (seperti MP4, WebM) dibandingkan dengan wadah berlisensi (seperti AVI, FLV) jika kualitasnya sama.

- **--no-prefer-free-formats**

  - **Terjemahan:** Jangan memberikan preferensi khusus untuk wadah bebas (default).
  - **Penjelasan:** Opsi ini menonaktifkan preferensi untuk wadah bebas.

- **--check-formats**

  - **Terjemahan:** Pastikan format yang dipilih hanya dari format yang benar-benar dapat diunduh.
  - **Penjelasan:** Opsi ini akan memeriksa apakah format yang Anda pilih benar-benar dapat diunduh dari sumber yang diberikan.

- **--check-all-formats**

  - **Terjemahan:** Periksa semua format untuk mengetahui apakah mereka benar-benar dapat diunduh.
  - **Penjelasan:** Opsi ini akan memeriksa semua format video yang tersedia untuk mengetahui apakah mereka dapat diunduh.

- **--no-check-formats**

  - **Terjemahan:** Jangan memeriksa apakah format yang sebenarnya dapat diunduh.
  - **Penjelasan:** Opsi ini akan menonaktifkan pemeriksaan apakah format yang dipilih dapat diunduh.

- **-F, --list-formats**

  - **Terjemahan:** Menampilkan daftar format yang tersedia untuk setiap video. Simulasikan kecuali `--no-simulate` digunakan.
  - **Penjelasan:** Opsi ini akan menampilkan daftar kode format yang tersedia untuk setiap video tanpa melakukan unduhan.

- **--merge-output-format FORMAT**
  - **Terjemahan:** Wadah yang dapat digunakan saat menggabungkan format, dipisahkan oleh "/", misalnya "mp4/mkv". Diabaikan jika tidak diperlukan penggabungan. (saat ini didukung: avi, flv, mkv, mov, mp4, webm)
  - **Penjelasan:** Opsi ini menentukan wadah yang akan digunakan jika Anda menggabungkan beberapa aliran audio atau video menjadi satu file.

---

**OPSI SUBTITLE**

- **--write-subs**

  - **Terjemahan:** Menulis file subtitle.
  - **Penjelasan:** Opsi ini akan menyimpan file subtitle (misalnya, dalam format SRT, VTT) jika tersedia untuk video yang diunduh.

- **--no-write-subs**

  - **Terjemahan:** Jangan menulis file subtitle (default).
  - **Penjelasan:** Opsi ini akan mencegah yt-dlp menyimpan file subtitle.

- **--write-auto-subs**

  - **Terjemahan:** Menulis file subtitle yang dihasilkan secara otomatis (Alias: `--write-automatic-subs`).
  - **Penjelasan:** Opsi ini akan mencoba mengunduh subtitle yang dihasilkan secara otomatis oleh YouTube atau platform lainnya jika tersedia.

- **--no-write-auto-subs**

  - **Terjemahan:** Jangan menulis subtitle yang dihasilkan secara otomatis (default) (Alias: `--no-write-automatic-subs`).
  - **Penjelasan:** Opsi ini akan mencegah yt-dlp mengunduh dan menyimpan subtitle yang dihasilkan secara otomatis.

- **--list-subs**

  - **Terjemahan:** Menampilkan daftar subtitle yang tersedia untuk setiap video. Simulasikan kecuali `--no-simulate` digunakan.
  - **Penjelasan:** Opsi ini akan menampilkan daftar bahasa subtitle yang tersedia untuk video tanpa melakukan unduhan.

- **--sub-format FORMAT**

  - **Terjemahan:** Format subtitle; menerima preferensi format yang dipisahkan oleh "/", misalnya "srt" atau "ass/srt/best".
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menentukan format subtitle yang ingin Anda unduh. Anda dapat menentukan beberapa format yang diinginkan, dipisahkan oleh "/".

- **--sub-langs LANGS**
  - **Terjemahan:** Bahasa subtitle yang ingin diunduh (dapat berupa regex) atau "all" dipisahkan dengan koma, misalnya `--sub-langs "en.*,ja"` (di mana "en.\*" adalah pola regex yang cocok dengan "en" diikuti dengan 0 atau lebih karakter apa pun). Anda dapat menambahkan awalan "-" pada kode bahasa untuk mengecualikannya dari bahasa yang diminta, misalnya `--sub-langs all,-live_chat`. Gunakan `--list-subs` untuk daftar tag bahasa yang tersedia.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menentukan bahasa subtitle yang ingin Anda unduh. Anda dapat menggunakan kode bahasa ISO 639-1 (misalnya, "en" untuk bahasa Inggris, "fr" untuk bahasa Prancis) atau pola regex untuk menentukan beberapa bahasa sekaligus.

---

**Opsi Autentikasi**

- **-u, --username USERNAME**

  - **Terjemahan:** Login dengan ID akun ini.
  - **Penjelasan:** Opsi ini digunakan untuk memasukkan ID pengguna (username) akun yang diperlukan untuk mengakses konten tertentu.

- **-p, --password PASSWORD**

  - **Terjemahan:** Kata sandi akun. Jika opsi ini diabaikan, yt-dlp akan meminta secara interaktif.
  - **Penjelasan:** Opsi ini digunakan untuk memasukkan kata sandi akun yang diperlukan untuk mengakses konten tertentu. Jika tidak diberikan, yt-dlp akan meminta Anda untuk memasukkan kata sandi secara manual.

- **-2, --twofactor TWOFACTOR**

  - **Terjemahan:** Kode otentikasi dua faktor.
  - **Penjelasan:** Opsi ini digunakan untuk memasukkan kode otentikasi dua faktor jika diperlukan untuk mengakses akun.

- **-n, --netrc**

  - **Terjemahan:** Gunakan data otentikasi .netrc.
  - **Penjelasan:** Opsi ini menginstruksikan yt-dlp untuk menggunakan informasi otentikasi yang tersimpan dalam file `.netrc`. File `.netrc` biasanya disimpan di direktori home pengguna dan berisi informasi login untuk berbagai layanan.

- **--netrc-location PATH**

  - **Terjemahan:** Lokasi data otentikasi .netrc; baik jalur atau direktori yang mengandungnya. Default ke ~/.netrc.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menentukan lokasi file `.netrc` jika tidak berada di lokasi default.

- **--netrc-cmd NETRC_CMD**

  - **Terjemahan:** Perintah yang akan dieksekusi untuk mendapatkan kredensial untuk ekstraktor.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menggunakan perintah khusus untuk mendapatkan kredensial yang diperlukan untuk mengakses konten dari beberapa sumber.

- **--video-password PASSWORD**

  - **Terjemahan:** Kata sandi khusus untuk video.
  - **Penjelasan:** Opsi ini digunakan untuk memasukkan kata sandi yang mungkin diperlukan untuk mengakses beberapa video yang dilindungi kata sandi.

- **--ap-mso MSO**

  - **Terjemahan:** Pengidentifikasi operator sistem ganda Adobe Pass (penyedia TV), gunakan `--ap-list-mso` untuk daftar MSO yang tersedia.
  - **Penjelasan:** Opsi ini digunakan untuk menentukan penyedia layanan TV Anda jika Anda menggunakan layanan Adobe Pass untuk mengakses konten yang dilindungi.

- **--ap-username USERNAME**

  - **Terjemahan:** Login akun operator sistem ganda.
  - **Penjelasan:** Opsi ini digunakan untuk memasukkan ID pengguna Anda untuk layanan penyedia TV.

- **--ap-password PASSWORD**

  - **Terjemahan:** Kata sandi akun operator sistem ganda. Jika opsi ini diabaikan, yt-dlp akan meminta secara interaktif.
  - **Penjelasan:** Opsi ini digunakan untuk memasukkan kata sandi akun Anda untuk layanan penyedia TV. Jika tidak diberikan, yt-dlp akan meminta Anda untuk memasukkan kata sandi secara manual.

- **--ap-list-mso**

  - **Terjemahan:** Menampilkan daftar semua operator sistem ganda yang didukung.
  - **Penjelasan:** Opsi ini akan menampilkan daftar penyedia layanan TV yang didukung oleh Adobe Pass.

- **--client-certificate CERTFILE**

  - **Terjemahan:** Jalur ke file sertifikat klien dalam format PEM. Dapat menyertakan kunci pribadi.
  - **Penjelasan:** Opsi ini digunakan untuk menentukan lokasi file sertifikat klien jika diperlukan untuk mengakses konten tertentu.

- **--client-certificate-key KEYFILE**

  - **Terjemahan:** Jalur ke file kunci pribadi untuk sertifikat klien.
  - **Penjelasan:** Opsi ini digunakan untuk menentukan lokasi file kunci pribadi yang terkait dengan sertifikat klien.

- **--client-certificate-password PASSWORD**
  - **Terjemahan:** Kata sandi untuk kunci pribadi sertifikat klien, jika dienkripsi. Jika tidak diberikan, dan kunci dienkripsi, yt-dlp akan meminta secara interaktif.
  - **Penjelasan:** Opsi ini digunakan untuk memasukkan kata sandi yang diperlukan untuk membuka kunci pribadi sertifikat klien jika dienkripsi. Jika tidak diberikan, yt-dlp akan meminta Anda untuk memasukkan kata sandi secara manual.

---

**Opsi Pasca-Pemrosesan**

- **-x, --extract-audio**

  - **Terjemahan:** Mengonversi file video menjadi file audio-only (membutuhkan ffmpeg dan ffprobe).
  - **Penjelasan:** Opsi ini akan mengekstrak audio dari file video dan menyimpannya sebagai file audio terpisah. Proses ini memerlukan program ffmpeg dan ffprobe yang harus diinstal terlebih dahulu.

- **--audio-format FORMAT**

  - **Terjemahan:** Format untuk mengonversi audio saat -x digunakan. (saat ini didukung: best (default), aac, alac, flac, m4a, mp3, opus, vorbis, wav). Anda dapat menentukan beberapa aturan menggunakan sintaks yang mirip dengan `--remux-video`.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menentukan format audio yang diinginkan untuk file audio yang diekstrak. Anda dapat menentukan beberapa aturan konversi menggunakan sintaks yang mirip dengan `--remux-video`.

- **--audio-quality QUALITY**

  - **Terjemahan:** Menentukan kualitas audio ffmpeg yang akan digunakan saat mengonversi audio dengan -x. Masukkan nilai antara 0 (terbaik) dan 10 (terburuk) untuk VBR atau bitrate tertentu seperti 128K (default 5).
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menentukan kualitas audio yang diinginkan untuk file audio yang diekstrak. Nilai yang lebih rendah menunjukkan kualitas yang lebih tinggi.

- **--remux-video FORMAT**

  - **Terjemahan:** Men-remux video ke dalam wadah lain jika diperlukan (saat ini didukung: avi, flv, gif, mkv, mov, mp4, webm, aac, aiff, alac, flac, m4a, mka, mp3, ogg, opus, wav). Jika wadah target tidak mendukung codec video/audio, remuxing akan gagal. Anda dapat menentukan beberapa aturan; misalnya, "aac>m4a/mov>mp4/mkv" akan meremux aac ke m4a, mov ke mp4, dan yang lainnya ke mkv.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk mengubah wadah (container) video tanpa mengubah codec video atau audio. Contohnya, Anda dapat mengubah video dari format MP4 ke format MKV.

- **--recode-video FORMAT**

  - **Terjemahan:** Meng-encode ulang video ke dalam format lain jika diperlukan. Sintaks dan format yang didukung sama dengan `--remux-video`.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk mengubah codec video dan/atau audio, serta wadah video.

- **--postprocessor-args NAME:ARGS**

  - **Terjemahan:** Berikan argumen ini ke post-processor. Tentukan nama post-processor/eksekusi dan argumen yang dipisahkan oleh titik dua ":" untuk memberikan argumen ke post-processor/eksekusi yang ditentukan. Post-processor yang didukung adalah: Merger, ModifyChapters, SplitChapters, ExtractAudio, VideoRemuxer, VideoConvertor, Metadata, EmbedSubtitle, EmbedThumbnail, SubtitlesConvertor, ThumbnailsConvertor, FixupStretched, FixupM4a, FixupM3u8, FixupTimestamp, dan FixupDuration. Eksekusi yang didukung adalah: AtomicParsley, FFmpeg, dan FFprobe. Anda juga dapat menentukan "PP+EXE:ARGS" untuk memberikan argumen ke eksekusi yang ditentukan hanya saat digunakan oleh post-processor yang ditentukan. Selain itu, untuk ffmpeg/ffprobe, "\_i"/"\_o" dapat ditambahkan ke awalan secara opsional diikuti oleh angka untuk meneruskan argumen sebelum file input/output yang ditentukan, misalnya `--ppa "Merger+ffmpeg_i1:-v quiet"`. Anda dapat menggunakan opsi ini beberapa kali untuk memberikan argumen berbeda ke post-processor yang berbeda. (Alias: `--ppa`)
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk memberikan argumen khusus kepada post-processor yang digunakan oleh yt-dlp. Post-processor adalah program atau skrip yang digunakan untuk melakukan tindakan tertentu pada file video setelah diunduh, seperti menggabungkan beberapa file, menambahkan subtitle, atau mengubah metadata.
  - **Contoh:**
    - `--postprocessor-args ExtractAudio+ffmpeg:-vn` - Menonaktifkan encoding video saat menggunakan post-processor ExtractAudio dengan ffmpeg.
    - `--postprocessor-args Merger:ffmpeg_i1:-c:v libx264` - Menentukan codec video untuk ffmpeg saat digunakan oleh post-processor Merger.

- **-k, --keep-video**

  - **Terjemahan:** Menyimpan file video sementara di disk setelah pasca-pemrosesan.
  - **Penjelasan:** Opsi ini akan menyimpan file video sementara yang dihasilkan selama proses pasca-pemrosesan (misalnya, saat mengekstrak audio) di disk.

- **--no-keep-video**

  - **Terjemahan:** Menghapus file video sementara setelah pasca-pemrosesan (default).
  - **Penjelasan:** Opsi ini akan menghapus file video sementara setelah proses pasca-pemrosesan selesai.

- **--post-overwrites**

  - **Terjemahan:** Menimpa file yang diproses ulang (default).
  - **Penjelasan:** Opsi ini akan menimpa file yang sudah ada jika proses pasca-pemrosesan menghasilkan file dengan nama yang sama.

- **--no-post-overwrites**

  - **Terjemahan:** Jangan menimpa file yang diproses ulang.
  - **Penjelasan:** Opsi ini akan mencegah yt-dlp menimpa file yang sudah ada jika proses pasca-pemrosesan menghasilkan file dengan nama yang sama.

- **--embed-subs**

  - **Terjemahan:** Menanamkan subtitle ke dalam video (hanya untuk video mp4, webm, dan mkv).
  - **Penjelasan:** Opsi ini akan menanamkan subtitle ke dalam file video jika format video mendukungnya (seperti MP4, WebM, MKV).

- **--no-embed-subs**

  - **Terjemahan:** Jangan menanamkan subtitle (default).
  - **Penjelasan:** Opsi ini akan mencegah yt-dlp menanamkan subtitle ke dalam file video.

- **--embed-thumbnail**

  - **Terjemahan:** Menanamkan thumbnail sebagai sampul dalam video.
  - **Penjelasan:** Opsi ini akan menanamkan gambar thumbnail sebagai sampul (cover art) ke dalam file video.

- **--no-embed-thumbnail**

  - **Terjemahan:** Jangan menanamkan thumbnail (default).
  - **Penjelasan:** Opsi ini akan mencegah yt-dlp menanamkan thumbnail ke dalam file video.

- **--embed-metadata**

  - **Terjemahan:** Menanamkan metadata ke dalam file video. Juga menanamkan bab/infojson jika ada kecuali `--no-embed-chapters`/`--no-embed-info-json` digunakan (Alias: `--add-metadata`).
  - **Penjelasan:** Opsi ini akan menanamkan metadata (seperti judul, artis, deskripsi) ke dalam file video. Jika tersedia, bab (chapters) dan informasi tambahan dari file info.json juga akan ditanamkan.

- **--no-embed-metadata**

  - **Terjemahan:** Jangan tambahkan metadata ke file (default) (Alias: `--no-add-metadata`).
  - **Penjelasan:** Opsi ini akan mencegah yt-dlp menanamkan metadata ke dalam file video.

- **--embed-chapters**

  - **Terjemahan:** Menambahkan penanda bab ke dalam file video (Alias: `--add-chapters`).
  - **Penjelasan:** Opsi ini akan menambahkan penanda bab (jika tersedia) ke dalam file video.

- **--no-embed-chapters**

  - **Terjemahan:** Jangan tambahkan penanda bab (default) (Alias: `--no-add-chapters`).
  - **Penjelasan:** Opsi ini akan mencegah yt-dlp menambahkan penanda bab ke dalam file video.

- **--embed-info-json**

  - **Terjemahan:** Menanamkan infojson sebagai lampiran ke file video mkv/mka.
  - **Penjelasan:** Opsi ini akan menanamkan informasi dari file info.json sebagai lampiran ke dalam file video dalam format MKV atau MKA.

- **--no-embed-info-json**

  - **Terjemahan:** Jangan menanamkan infojson sebagai lampiran ke file video.
  - **Penjelasan:** Opsi ini akan mencegah yt-dlp menanamkan informasi dari file info.json sebagai lampiran ke dalam file video.

- **--parse-metadata [WHEN:]FROM:TO**

  - **Terjemahan:** Mengurai metadata tambahan seperti judul/artis dari bidang lain; lihat "MEMODIFIKASI METADATA" untuk detailnya. Nilai yang didukung dari "WHEN" sama dengan yang ada di `--use-postprocessor` (default: pre_process).
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk mengekstrak dan mengisi metadata tambahan (seperti judul, artis) dari bidang lain dalam informasi video.

- **--replace-in-metadata [WHEN:]FIELDS REGEX REPLACE**

  - **Terjemahan:** Mengganti teks dalam bidang metadata menggunakan regex yang diberikan. Opsi ini dapat digunakan beberapa kali. Nilai yang didukung dari "WHEN" sama dengan yang ada di `--use-postprocessor` (default: pre_process).
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk mengganti teks dalam bidang metadata tertentu menggunakan ekspresi reguler (regex).

- **--xattrs**

  - **Terjemahan:** Menulis metadata ke atribut-x file video (menggunakan standar Dublin Core dan XDG).
  - **Penjelasan:** Opsi ini akan menulis metadata video ke dalam atribut-x file video. Atribut-x adalah data tambahan yang dapat disimpan dalam sistem file.

- **--concat-playlist POLICY**

  - **Terjemahan:** Menggabungkan video dalam playlist. Salah satu dari "never", "always", atau "multi_video" (default; hanya ketika video membentuk satu acara). Semua file video harus memiliki codec dan jumlah stream yang sama untuk dapat digabungkan. Prefiks "pl_video:" dapat digunakan dengan `--paths` dan `--output` untuk mengatur nama file output untuk file yang digabungkan. Lihat "OUTPUT TEMPLATE" untuk detailnya.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menggabungkan beberapa video dari satu playlist menjadi satu file video yang lebih panjang.

- **--fixup POLICY**

  - **Terjemahan:** Secara otomatis memperbaiki kesalahan yang diketahui pada file. Salah satu dari "never" (tidak melakukan apa-apa), "warn" (hanya mengeluarkan peringatan), "detect_or_warn" (default; memperbaiki file jika memungkinkan, memperingatkan jika tidak), "force" (mencoba memperbaiki bahkan jika file sudah ada).
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk mengontrol bagaimana yt-dlp menangani potensi masalah atau kesalahan pada file yang diunduh, seperti file yang rusak atau tidak lengkap.

- **--ffmpeg-location PATH**

  - **Terjemahan:** Lokasi biner ffmpeg; baik jalur ke biner atau direktori yang mengandungnya.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menentukan lokasi instalasi program ffmpeg jika yt-dlp tidak dapat menemukannya secara otomatis.

- **--exec [WHEN:]CMD**

  - **Terjemahan:** Menjalankan perintah, secara opsional diawali dengan kapan untuk menjalankannya, dipisahkan oleh ":". Nilai yang didukung dari "WHEN" sama dengan yang ada di `--use-postprocessor` (default: after_move). Sintaks yang sama dengan template output dapat digunakan untuk meneruskan bidang apa pun sebagai argumen ke perintah. Jika tidak ada bidang yang diteruskan, "%(filepath,\_filename|)q" ditambahkan ke akhir perintah. Opsi ini dapat digunakan beberapa kali.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menjalankan perintah eksternal setelah atau sebelum langkah tertentu dalam proses unduhan dan pemrosesan. Anda dapat menggunakan variabel khusus dalam perintah untuk menyertakan informasi tentang file yang diunduh.

- **--no-exec**

  - **Terjemahan:** Menghapus semua definisi `--exec` sebelumnya.
  - **Penjelasan:** Opsi ini akan menghapus semua perintah yang sebelumnya ditentukan menggunakan `--exec`.

- **--convert-subs FORMAT**

  - **Terjemahan:** Mengonversi subtitle ke format lain (saat ini didukung: ass, lrc, srt, vtt). Gunakan `--convert-subs none` untuk menonaktifkan konversi (default) (Alias: `--convert-subtitles`).
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk mengubah format subtitle dari satu format ke format lainnya.

- **--convert-thumbnails FORMAT**

  - **Terjemahan:** Mengonversi thumbnail ke format lain (saat ini didukung: jpg, png, webp). Anda dapat menentukan beberapa aturan menggunakan sintaks yang mirip dengan `--remux-video`. Gunakan `--convert-thumbnails none` untuk menonaktifkan konversi (default).
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk mengubah format gambar thumbnail.

- **--split-chapters**

  - **Terjemahan:** Membagi video menjadi beberapa file berdasarkan bab internal. Prefiks "chapter:" dapat digunakan dengan `--paths` dan `--output` untuk mengatur nama file output untuk file yang dibagi. Lihat "OUTPUT TEMPLATE" untuk detailnya.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk membagi file video menjadi beberapa file yang lebih kecil berdasarkan penanda bab yang ada dalam video.

- **--no-split-chapters**

  - **Terjemahan:** Jangan membagi video berdasarkan bab (default).
  - **Penjelasan:** Opsi ini akan mencegah yt-dlp membagi file video berdasarkan penanda bab.

- **--remove-chapters REGEX**

  - **Terjemahan:** Menghapus bab yang judulnya cocok dengan ekspresi reguler yang diberikan. Sintaksnya sama dengan `--download-sections`. Opsi ini dapat digunakan beberapa kali.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk menghapus bab-bab tertentu dari video berdasarkan judul bab yang cocok dengan ekspresi reguler.

- **--no-remove-chapters**

  - **Terjemahan:** Jangan menghapus bab apa pun dari file (default).
  - **Penjelasan:** Opsi ini akan mencegah yt-dlp menghapus bab dari file video.

- **--force-keyframes-at-cuts**

  - **Terjemahan:** Memaksa keyframe pada pemotongan saat mengunduh/membagi/menghapus bagian. Ini lambat karena memerlukan pengkodean ulang, tetapi video yang dihasilkan mungkin memiliki lebih sedikit artefak di sekitar pemotongan.
  - **Penjelasan:** Opsi ini memaksa yt-dlp untuk menempatkan keyframe pada titik pemotongan video, yang dapat menghasilkan kualitas video yang lebih baik tetapi membutuhkan waktu pemrosesan yang lebih lama.

- **--no-force-keyframes-at-cuts**

  - **Terjemahan:** Jangan memaksa keyframe di sekitar bab saat memotong/membagi (default).
  - **Penjelasan:** Opsi ini akan mencegah yt-dlp memaksa keyframe pada titik pemotongan.

- **--use-postprocessor NAME[:ARGS]**
  - **Terjemahan:** Nama (sensitif huruf besar-kecil) dari post-processor plugin yang akan diaktifkan, dan (opsional) argumen yang akan diteruskan ke dalamnya, dipisahkan oleh titik dua ":". ARGS adalah daftar yang dipisahkan oleh titik koma ";" dari NAME=VALUE. Argumen "when" menentukan kapan post-processor dipanggil. Dapat berupa "pre_process" (setelah ekstraksi video), "after_filter" (setelah video melewati filter), "video" (setelah `--format`; sebelum `--print`/`--output`), "before_dl" (setelah setiap unduhan video), "post_process" (setelah setiap unduhan video; default), "after_move" (setelah memindahkan file video ke lokasi akhirnya), "after_video" (setelah mengunduh dan memproses semua format dari satu video), atau "playlist" (pada akhir playlist). Opsi ini dapat digunakan beberapa kali untuk menambahkan post-processor yang berbeda.
  - **Penjelasan:** Opsi ini memungkinkan Anda untuk mengaktifkan dan mengkonfigurasi post-processor plugin tambahan yang dapat melakukan berbagai tugas pemrosesan lanjutan pada video yang diunduh.

## SponsorBlock Options:

**Penjelasan Umum:**

- SponsorBlock adalah fitur yang terintegrasi dengan SponsorBlock API untuk membantu Anda menghilangkan atau menandai segmen tertentu dalam video YouTube yang diunduh, seperti sponsor, intro, outro, dan lainnya.

**Opsi Individual:**

- **--sponsorblock-mark CATS**
  - **Terjemahan:** Kategori SponsorBlock yang akan ditandai sebagai bab terpisah, dipisahkan dengan koma. Kategori yang tersedia meliputi sponsor, intro, outro, selfpromo, preview, filler, interaction, music_offtopic, poi_highlight, chapter, all (semua), dan default (sama dengan all). Anda dapat menggunakan awalan tanda "-" untuk mengecualikan kategori tertentu. Lihat [1] untuk deskripsi kategori. Contoh: `--sponsorblock-mark all,-preview` ([1] [https://wiki.sponsor.ajay.app/w/Segment_Categories](https://wiki.sponsor.ajay.app/w/Segment_Categories))
- **--sponsorblock-remove CATS**
  - **Terjemahan:** Kategori SponsorBlock yang akan dihapus dari file video, dipisahkan dengan koma. Jika suatu kategori muncul di kedua mark dan remove, maka remove yang didahulukan. Sintaks dan kategori yang tersedia sama dengan `--sponsorblock-mark` kecuali "default" merujuk ke "all,-filler" dan poi_highlight, chapter tidak tersedia.
- **--sponsorblock-chapter-title TEMPLATE**
  - **Terjemahan:** Template untuk judul bab SponsorBlock yang dibuat oleh `--sponsorblock-mark`. Field yang tersedia meliputi start_time (waktu mulai), end_time (waktu akhir), category (kategori), categories (semua kategori), name (nama), dan category_names (nama semua kategori). Default: "[SponsorBlock]: %(category_names)l"
- **--no-sponsorblock**
  - **Terjemahan:** Menonaktifkan fungsi penandaan dan penghapusan SponsorBlock (`--sponsorblock-mark` dan `--sponsorblock-remove`).
- **--sponsorblock-api URL**
  - **Terjemahan:** Lokasi SponsorBlock API, default: [https://sponsor.ajay.app](https://sponsor.ajay.app)

## Extractor Options:

**Penjelasan Umum:**

- Opsi Extractor digunakan untuk mengontrol bagaimana yt-dlp mengekstrak data dan video dari berbagai platform web.

**Opsi Individual:**

- **--extractor-retries RETRIES**
  - **Terjemahan:** Jumlah percobaan ulang untuk kesalahan ekstraktor yang diketahui (default 3), atau "infinite" (tak terbatas).
- **--allow-dynamic-mpd**
  - **Terjemahan:** Memproses manifest DASH dinamis (default) (Alias: --no-ignore-dynamic-mpd).
- **--ignore-dynamic-mpd**
  - **Terjemahan:** Tidak memproses manifest DASH dinamis (Alias: --no-allow-dynamic-mpd).
- **--hls-split-discontinuity**
  - **Terjemahan:** Membagi playlist HLS ke format berbeda pada diskontinuitas seperti jeda iklan.
- **--no-hls-split-discontinuity**
  - **Terjemahan:** Tidak membagi playlist HLS ke format berbeda pada diskontinuitas seperti jeda iklan (default).
- **--extractor-args IE_KEY:ARGS**
  - **Terjemahan:** Meneruskan argumen ARGS ke ekstraktor IE_KEY. Lihat "EXTRACTOR ARGUMENTS" untuk detailnya. Opsi ini dapat digunakan beberapa kali untuk memberikan argumen ke ekstraktor yang berbeda.

## Catatan Tambahan:

- Dokumentasi yt-dlp menyediakan informasi lebih rinci tentang setiap opsi dan key yang tersedia dalam template output. Anda dapat mengakses dokumentasi melalui baris perintah dengan mengetikkan `yt-dlp --help` atau mengunjungi halaman resminya.
- Dokumentasi lengkap tersedia di: [https://github.com/yt-dlp/yt-dlp#readme](https://github.com/yt-dlp/yt-dlp#readme)
- Beberapa opsi ini mungkin bersifat eksperimental atau memiliki keterbatasan tertentu. Pastikan untuk membaca dokumentasi dengan seksama sebelum menggunakan opsi tersebut.
- Terjemahan ini berusaha mendekati makna asli dari teks bahasa Inggris.
- Beberapa istilah teknis mungkin memiliki terjemahan yang lebih tepat dalam konteks tertentu.
- Terjemahan ini dapat digunakan sebagai referensi umum, namun disarankan untuk memeriksa kembali jika diperlukan ketepatan yang sangat tinggi.
