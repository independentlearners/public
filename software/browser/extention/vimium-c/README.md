# Apa itu **Vimium C**?

Vimium C adalah ekstensi open-source yang memungkinkan navigasi halaman, pengelolaan tab, dan pencarian secara penuh menggunakan shortcut keyboard. Ia menyajikan beragam perintah familiar bagi pengguna editor Vim. Di antaranya:

* Tekan `f` untuk menampilkan "hint"—penanda link atau elemen yang bisa diklik pada halaman.
* `j`, `k`, `h`, `l` bergerak ke bawah, atas, kiri, dan kanan—seperti di Vim.
* Ketik `/` untuk mencari teks di halaman, `v` memasuki *Visual Mode*.
* `Shift+J/K`, `g0`, `g$` untuk berpindah atau navigasi tab.
* `x` menutup tab, `Shift+X` membuka kembali tab terdekat yang ditutup; bahkan mendukung pengulangan seperti `5X` untuk membuka 5 tab yang baru saja ditutup. ([Toko Web Chrome][1])

Selain itu, terdapat "Vomnibar"—panel pencarian omnibox yang memungkinkan pencarian cepat di riwayat, bookmark, dan tab terbuka. Tersedia juga opsi pengaturan shortcut khusus per situs atau elemen, serta mampu memblokir atau mengizinkan shortcut di URL tertentu. ([Toko Web Chrome][1], [chrome-stats.com][2])

---

### Keunggulan & Kelemahannya

Menurut perangkat statistik ekstensi, Vimium C memiliki nilai bintang tinggi (sekitar 4.84–4.90), dan meraih posisi terpercaya dalam kategori *Functionality & UI* ([chrome-stats.com][2]). Pengguna menyukai kecepatan dan efektivitasnya—beberapa menyebutnya tak tergantikan dalam pengalaman menjelajahi web. ([chrome-stats.com][2])

Namun, peringatan kecil juga disampaikan: beberapa halaman mungkin menghadapi masalah dalam menyorot elemen (hinting) atau terjadi jeda performa. ([chrome-stats.com][2])

---

### Rangkuman yang Memotivasi

Vimium C adalah contoh brilian dari pemikiran bebas mouse: gaya navigasi tangan penuh dan efisien yang mampu mempercepat ritme belajar dan produktivitas. Ia membangkitkan kembali filosofi minimalis berbasis keyboard—memudahkan transisi dari berpikir ke mengetik.

Bagi pelajar IT seperti Anda, ekstensi ini bisa jadi sarana sempurna untuk tertanam pemahaman mendalam tentang kontrol berbasis teks—mirip pengembangan plugin TUI atau otomatisasi Shell script. Saat mendalami Vimium C, Anda juga bisa mengeksplor plugin, melakukan modifikasi, atau bahkan mengembangkan fitur tambahan seperti sinkronisasi konfigurasi, antarmuka CLI, atau mapping kontekstual.

---

[1]: https://chromewebstore.google.com/detail/vimium-c-all-by-keyboard/hfjbmagddngcpeloejdejnfgbamkjaeg?utm_source=chatgpt.com "Vimium C - All by Keyboard - Chrome Web Store"
[2]: https://chrome-stats.com/d/hfjbmagddngcpeloejdejnfgbamkjaeg?utm_source=chatgpt.com "Vimium C - Keyboard Shortcut Navigation Extension - Chrome-Stats"

Kita akan menyusun panduan yang terstruktur: penggunaan praktis → kustomisasi kunci & Vomnibar → setting per-situs & trik tingkat lanjut → pengembangan/modifikasi kode sumber → troubleshooting terperinci → batasan nyata dan cara mengatasinya. Setiap bagian menyertakan contoh yang bisa langsung Anda salin-tempel, serta persyaratan teknis bila Anda ingin memodifikasi sumbernya.

> Catatan singkat tentang identitas teknis ekstensi ini — supaya sesuai kebiasaan Anda: **Vimium C** adalah ekstensi open-source yang ditulis dalam **JavaScript/TypeScript** (kode awal dipindahkan dari CoffeeScript → JavaScript → TypeScript). Jika Anda hendak memodifikasi atau membangun ulang, Anda memerlukan pengetahuan tentang JavaScript/TypeScript, pengemasan Chrome extension (Manifest v2/v3), dan alat Node.js (npm/gulp/tsc). Sumber resmi dan instruksi build tersedia di repositori utama. ([GitHub][1], [Toko Web Chrome][2])

---

# 1. Ringkasan cepat fitur inti (apa yang bisa dilakukan)

* Navigasi seluruh halaman — `j`/`k`/`h`/`l`, `gg`, `G`, `d`, `u`. ([GitHub][1])
* Link-hinting: tekan `f` (buka di tab sekarang) atau `F` (buka di tab baru); ada mode pencarian hint yang lebih pintar. ([GitHub][1], [libhunt.com][3])
* Vomnibar (omni-search/panel) untuk mencari bookmarks, history, tab, atau menjalankan search engines custom. ([Toko Web Chrome][2], [GitHub][4])
* Mode visual (`v`) untuk menyeleksi teks, yank (`y`) dan paste-and-go (`p`) pada URL. ([GitHub][1])
* Operasi tab (pindah, buka, tutup, urut) dan manajemen jendela. ([GitHub][1])
* Pemetaaan kunci (custom key mappings), unmap, mapKey, `runKey` dan aturan **per-situs** / **per-mode**. ([GitHub][1])

---

# 2. Mulai cepat — perintah & penggunaan harian

Gunakan `?` (tanda tanya) di browser setelah memasang untuk memunculkan **help dialog** lokal: daftar semua key binding Anda (sangat berguna untuk referensi cepat). Untuk navigasi dan aksi umum:

Contoh ringkas:

* `j` / `k` — scroll down / up
* `f` — hint dan buka link (ketik label yang muncul)
* `F` — hint lalu buka link di tab baru
* `gi` — fokus ke input yang pertama / nth (berguna untuk form)
* `/` — cari kata di halaman (find)
* `v` — visual mode (pilih teks)
* `yt` / `yp` / `y` — berguna untuk menyalin/menempel (lihat dokumentasi help). ([GitHub][1])

---

# 3. Kustomisasi — Custom Key Mappings (inti)

Buka **Options → Custom key mappings** di halaman ekstensi (atau `chrome://extensions` → opsi Vimium C). Anda menulis satu per baris. Sintaks dasar:

* `map <key> <command>` — peta kunci ke perintah (mengganti perilaku di halaman).
* `mapKey <key> <another_key>` — jadikan satu key berperilaku seperti key lain (preprocessing).
* `unmap <key>` / `unmapAll` — batalkan mapping.
* `map! <key>` — map baik di normal maupun insert mode (jika didukung). ([GitHub][1])

Contoh praktis (salin-tempel ke kotak Custom key mappings):

```
" Contoh: buka omnibar dengan r
map r Vomnibar.activate

" Contoh: ganti ctrl-f menjadi link hints
unmap f
map <c-f> LinkHints.activateMode

" Contoh: mapKey khusus untuk Vomnibar
mapKey <key:o> <another_key>
```

Penjelasan: gunakan `unmap` sebelum memetakan ulang jika Anda ingin memulihkan perilaku browser untuk key tertentu. ([GitHub][1], [Stack Overflow][5])

---

# 4. Aturan per-situs dan *runKey / env* — kontrol kontekstual kuat

Vimium C memiliki fitur untuk menjalankan perintah berbeda pada situs berbeda menggunakan `runKey` dan `env` directive (lebih kuat dari Vimium asli). Ini memungkinkan: satu urutan tombol melakukan hal berlainan pada `github.com` vs `news.ycom` — sangat berguna untuk workflow.

Contoh (format sederhana di Custom key mappings / rules yang mendukung per-situs):

```
# Pada github.com, 'g i' fokuskan ke input issues/pr
map gI runKey env=github.com:gi

# Atau menggunakan pola:
map <leader>r runKey env=/.+\\.example\\.com/:reload
```

(Referensi: cara memetakan per-situs dan `runKey` dijelaskan di wiki Vimium-C). ([GitHub][6])

---

# 5. Vomnibar — mengonfigurasi search engines dan perilaku

Vomnibar mendukung *custom search engines* dengan format `keyword: url` dimana `%s` diganti query. Di pengaturan, tambahkan entri seperti:

```
w: https://en.wikipedia.org/w/index.php?search=%s
g: https://www.google.com/search?q=%s
imdb: https://www.imdb.com/find?q=%s
```

Tips: saat memetakan perintah ke Vomnibar, Anda dapat memberi flag seperti `icase` (case-insensitive) untuk memastikan pencarian konsisten. Lihat wiki: *How to ... on Vomnibar*. ([GitHub][4])

---

# 6. Mode hinting & tautan cerdas (advanced link hints)

Vimium C memperluas link-hinting klasik — mendukung pencarian teks pada link, URL, alt text (berguna untuk ikon) dan mode “typed hints” (ketik beberapa karakter dari link). Jika hint tidak muncul:

* Pastikan tidak diblacklist oleh situs (lihat excludeUrls di options).
* Jika halaman heavy JS mengubah DOM setelah load, gunakan `LinkHints.activateMode` dengan delay atau gunakan `Reload` sebelum hinting. ([GitHub][1])

---

# 7. Menyelaraskan dengan workflow TUI / CLI — ide integrasi

Beberapa strategi bagi Anda (pelajar IT yang suka CLI/TUI):

* Buat skrip eksport konfigurasi (file teks) yang bisa Anda simpan di repo dotfiles; kemudian import ke Vimium C via *Options → Import*.
* Kembangkan utilitas kecil (Node.js) yang mengubah file konfigurasi menjadi mapping Vimium otomatis (mis. generate mapping berdasarkan file JSON).
* Buat plugin Neovim yang mengirim perintah ke browser via WebSocket (via helper extension atau native messaging) untuk sinkronisasi keybinding antara Neovim ↔ Vimium C. (Perlu modifikasi ekstensi/menambahkan native messaging host). ([GitHub][1])

---

# 8. Pengembangan & Modifikasi Sumber (step-by-step)

Jika Anda ingin masuk lebih dalam (memodifikasi kode, menambahkan fitur), berikut langkah praktis:

Prasyarat & keterampilan:

* **Bahasa:** JavaScript & TypeScript (rekam jejak proyek menunjukkan transisi ke TypeScript). ([GitHub][1])
* **Tooling:** Node.js (>=13), npm, `typescript`, `gulp` (opsional), `pngjs` bila target Chromium. ([GitHub][1])
* **Lainnya:** Git, browser Chromium (Chrome/Edge/Brave) atau Firefox (dev versions supported).

Langkah cloning & build cepat:

```bash
# clone
git clone https://github.com/gdh1995/vimium-c.git
cd vimium-c

# install minimal dependencies
npm install typescript
npm install pngjs

# compile TypeScript
node scripts/tsc

# atau gunakan gulp untuk dev build: (cek gulpfile)
gulp local
# produksi:
gulp dist
```

Memuat ke browser untuk debugging:

1. Buka `chrome://extensions/` (atau `edge://extensions/`) → aktifkan *Developer mode*.
2. Klik **Load unpacked** → pilih folder `dist/` atau `build/` hasil kompilasi.
3. Gunakan *Inspect views* / Service worker logs untuk debugging background/service worker. ([GitHub][1])

Struktur kode penting (bias umum pada webextensions):

* `content_scripts` — kode yang diinject ke halaman (link hints, key event listener).
* `background` (manifest v2) / service worker (manifest v3) — manajemen global (tab, storage).
* `options` / `popup` — halaman opsi/Vomnibar UI.
* `_locales/` — file terjemahan. ([GitHub][1])

Tips dev:

* Gunakan `console.log` di content script; lihat pada DevTools halaman target (tab tempat extension aktif).
* Untuk background/service worker logging di Manifest v3, periksa *Service Worker* di halaman extension → Inspect.
* `gulp local` mendukung hot compile; gunakan untuk percepat siklus edit → test. ([GitHub][1])

---

# 9. Troubleshooting umum & solusi praktis

Masalah: **Vimium mengambil alih saat mengetik di formulir (insert mode)**

* Solusi: Tekan `i` (enter insert mode) saat fokus pada input; atau gunakan `gi` untuk fokus input. Jika ekstensi tidak kembali ke normal, klik area halaman atau tekan `<esc>`. Untuk mencegah masalah, tambahkan situs ke *Excluded URLs* di options (mis. `mail.google.com`, `docs.google.com`). Lihat issues terkait Google Docs/Gmail. ([GitHub][7], [Reddit][8])

Masalah: **`f` atau hints tidak muncul / hinting tidak sesuai**

* Solusi: beberapa halaman menggunakan shadow DOM atau iframe sandbox; periksa devtools: apakah elemen di shadow DOM? Jika ya, hinting mungkin terbatas. Jika iframe `sandbox` atau `about:blank` terpisah, Vimium-C bisa membutuhkan izin host tambahan. Cek juga *LinkHints mode* di options. ([GitHub][1])

Masalah: **Konflik dengan pintasan Chrome/OS (mis. Ctrl+W, Ctrl+T)**

* Penjelasan: ekstensi tidak bisa menimpa shortcut yang sudah dikuasai browser/OS pada level native (keterbatasan API Chrome). Pilih kombinasi lain atau gunakan `mapKey` yang tidak bentrok. (Sumber diskusi: StackOverflow). ([Stack Overflow][9])

Masalah: **Performa atau memory leak / service worker behavior (Manifest v3)**

* Penjelasan: beberapa versi menguji auto-release resources untuk tab tak aktif. Jika Anda membangun ulang, pertimbangkan dukungan MinCVer dan opsi build untuk target browser. Gunakan tools performance profiling. ([Add-ons Mozilla][10], [GitHub][1])

---

# 10. Batasan nyata — apa yang **tidak** bisa dilakukan (dan cara mengatasinya)

* **Menimpa shortcut Chrome/OS built-in** — ini dibatasi oleh API browser; solusi: reorganisasi mapping atau gunakan ekstensi pembantu yang menyediakan forwarding (beberapa helper exist). ([Stack Overflow][9])
* **Interaksi terhadap `chrome://` dan beberapa halaman internal browser** — tidak diizinkan untuk ekstensi content scripts. Tidak ada solusi praktis selain menggunakan fitur browser sendiri.
* **Akses ke aplikasi lokal tanpa Native Messaging** — jika Anda butuh integrasi CLI lokal → gunakan Native Messaging host (butuh paket kecil di sisi OS). Ini membuka kemungkinan integrasi Neovim ↔ Browser tapi butuh instalasi lokal.
* **Beberapa iframe sandbox / cross-origin isolation** — hints/interaction mungkin terbatasi; solusi: jika Anda memiliki kontrol server, hindari sandbox yang terlalu ketat, atau gunakan extension helper lainnya. ([GitHub][1])

---

# 11. Keamanan & privasi

* Vimium C adalah open-source (Apache-2.0). Periksa `permissions` di manifest untuk memastikan Anda nyaman: host permissions, tabs, storage, dll. Bila ingin aman: gunakan build lokal dan tinjau kode. ([GitHub][1])

---

# 12. Daftar cek persiapan bila Anda ingin memodifikasi / mengembangkan

1. Pelajari JavaScript & TypeScript dasar (mengerti DOM, event handling).
2. Pasang: Git, Node.js (>=13), npm, TypeScript, gulp (opsional). ([GitHub][1])
3. Clone repo `gdh1995/vimium-c`.
4. Jalankan `npm install`, `node scripts/tsc` (atau `gulp local`).
5. Muat hasil `dist/` sebagai *unpacked extension* di `chrome://extensions`.
6. Tes fitur baru di halaman nyata; gunakan logging dan DevTools untuk debugging. ([GitHub][1])

---

# 13. Contoh konfigurasi lengkap (siap pakai) — simpan sebagai cadangan

Salin ini ke *Custom key mappings* Anda (contoh praktis untuk workflow umum):

```
" Dasar
map j scrollDown
map k scrollUp
map h scrollLeft
map l scrollRight

" Link hints & Tab
map f LinkHints.activate
map F LinkHints.activateInNewTab
map x removeTab
map <c-x> undoClosedTab

" Vomnibar custom searches
unmap r
map r Vomnibar.activate
" custom search engines in options -> Search engines:
" g: https://www.google.com/search?q=%s
" w: https://en.wikipedia.org/w/index.php?search=%s

" Per-situs: contoh behavior khusus untuk example.com
map <c-e> runKey env=example.com:openUrl
```

(Anda perlu juga menambahkan search engines melalui UI options). ([GitHub][1])

---

# 14. Jika Anda menemui masalah yang tidak bisa dipecahkan

Langkah rekomendasi:

1. Periksa dokumentasi & wiki Vimium-C (issue tracker) untuk bug serupa. ([GitHub][1])
2. Repro minimal: buat halaman HTML kecil yang menampilkan masalah.
3. Gunakan `Load unpacked` versi build lokal dan tambahkan `console.log` debug.
4. Jika bug di core, buka issue di GitHub (sertakan steps-to-reproduce, versi browser, versi vimium-c). ([GitHub][1])

---

# 15. Ide-ide peningkatan yang bisa Anda kembangkan (roadmap pribadi)

* Sinkronisasi konfigurasi via GitHub Gist atau dotfiles (CLI untuk export/import).
* Adapter Neovim → browser: kirim perintah Vim ke Vomnibar via Native Messaging.
* Fitur aksesibilitas: teks-to-speech untuk link hints, integrasi shortcut lebih fleksibel untuk keyboard non-QWERTY.
* Plugin PDF viewer improvements (Vimium-C sudah punya helper PDF viewer; Anda bisa memodifikasinya). ([GitHub][1])

---

# Penutup yang menyemangati

Anda sekarang memiliki peta lengkap: dari penggunaan sehari-hari sampai jalur teknis untuk memodifikasi sumber. Untuk langkah praktis berikutnya, saya bisa langsung:

* Menyiapkan **file mapping** yang sesuai gaya kerja Anda (mis. fokus CLI, tab heavy, atau dev browsing).
* Menulis **skrip build** kecil untuk mempermudah `gulp local` / hot-reload.
* Membuat contoh modul **Native Messaging** untuk integrasi Neovim ↔ Vimium-C.

---

[1]: https://github.com/gdh1995/vimium-c "GitHub - gdh1995/vimium-c: A keyboard shortcut browser extension for keyboard-based navigation and tab operations with an advanced omnibar"
[2]: https://chromewebstore.google.com/detail/vimium-c-all-by-keyboard/hfjbmagddngcpeloejdejnfgbamkjaeg?utm_source=chatgpt.com "Vimium C - All by Keyboard - Chrome Web Store"
[3]: https://www.libhunt.com/compare-vimium-vs-vimium-c?utm_source=chatgpt.com "vimium vs vimium-c - compare differences and reviews? - LibHunt"
[4]: https://github.com/gdh1995/vimium-c/wiki/How-to-...-on-Vomnibar?utm_source=chatgpt.com "How to ... on Vomnibar · gdh1995/vimium-c Wiki - GitHub"
[5]: https://stackoverflow.com/questions/66280656/how-to-remap-a-key-to-another-key-in-vimium?utm_source=chatgpt.com "How to Remap a Key to Another Key in Vimium - Stack Overflow"
[6]: https://github.com/gdh1995/vimium-c/wiki/Map-a-key-to-different-commands-on-different-websites?utm_source=chatgpt.com "Map a key to different commands on different websites - GitHub"
[7]: https://github.com/philc/vimium/issues/3367?utm_source=chatgpt.com "Vimium tab navigation stops working with Google Docs / Gmail #3367"
[8]: https://www.reddit.com/r/vim/comments/17ulz1a/quick_question_about_vimium_c_newbie/?utm_source=chatgpt.com "Quick question about Vimium C (newbie) : r/vim - Reddit"
[9]: https://stackoverflow.com/questions/4530514/vimium-how-to-map-vimium-shortcut-keys-over-chrome-default-shortcut-keys?utm_source=chatgpt.com "Vimium - how to map vimium shortcut keys over chrome default ..."
[10]: https://addons.mozilla.org/en-US/firefox/addon/vimium-c/versions/?utm_source=chatgpt.com "Vimium C - All by Keyboard version history - Firefox Browser Add-ons"


# **Daftar Default Pintasan *Vimium C* — Lengkap dan Tepat Sasaran**

### 1. Navigasi Halaman (Scroll & Posisi)

* `j` atau `Ctrl+e` → Gulir ke bawah
* `k` atau `Ctrl+y` → Gulir ke atas
* `gg` → Pindah ke paling atas
* `G` (Shift+g) → Pindah ke paling bawah
* `d` → Gulir setengah halaman ke bawah
* `u` → Gulir setengah halaman ke atas
* `h` → Gulir ke kiri
* `l` → Gulir ke kanan
* `zH` → Gulir sepenuhnya ke kiri
* `zL` → Gulir sepenuhnya ke kanan
* `r` → Muat ulang halaman
* `yy` → Salin URL halaman ke clipboard
* `p` → Buka URL dari clipboard di tab sekarang
* `Shift+p` → Buka URL clipboard di tab baru
* `gu` → Naik satu level URL hierarchy
* `gU` → Naik ke root URL
* `i` → Masuk *insert mode*
* `v` → Masuk *visual mode* (pilih teks)
* `Shift+v` (`V`) → Masuk *visual line mode*
* `gi` → Fokus ke input teks pertama (gunakan Tab untuk lanjut)
  *(Sumber ringkasan komprehensif: KeyCombiner)* ([keycombiner.com][1])

### 2. Link-Hinting & Interaksi Link

* `f` → Hint pada link/tombol & buka di tab sekarang
* `F` (Shift+f) → Hint & buka di tab baru
* `Alt+f` (`<a-f>`) → Buka banyak link sekaligus di tab baru
* `yf` → Salin URL link yang di-hint ke clipboard
* `gf` → Fokus iframe/frame berikutnya
* `gF` → Fokus ke frame utama/top
  *(Sumber: KeyCombiner & GitHub)* ([keycombiner.com][1], [GitHub][2])

### 3. Vomnibar (Omni-search / Panel)

* `o` → Buka URL/histori/bookmark via Vomnibar
* `O` (Shift+o) → Buka di tab baru
* `b` → Buka bookmark via Vomnibar
* `B` (Shift+b) → Buka bookmark di tab baru
* `T` → Cari tab terbuka & fokuskan
  *(Sumber: KeyCombiner & Web Store deskripsi)* ([keycombiner.com][1], [Toko Web Chrome][3], [addons.mozilla.org][4])

### 4. Pencarian Halaman & Navigasi melalui Pencarian

* `/` → Masuk *find mode*
* `n` → Hasil selanjutnya
* `N` (Shift+n) → Hasil sebelumnya
  *(Sumber: KeyCombiner)* ([keycombiner.com][1])

### 5. Navigasi History & URL

* `H` → Kembali (back)
* `L` → Maju (forward)
* `ge` → Edit URL inline
* `gE` → Edit URL dan buka di tab baru
  *(Sumber: KeyCombiner & GitHub)* ([keycombiner.com][1], [GitHub][2])

### 6. Marks & Lompat Cepat

* `m<letter>` → Set mark lokal (contoh `ma`)
* `m<Letter>` → Set mark global (contoh `mA`)
* `` `a `` / `` `A `` → Lompat ke mark (lokal/global)
* ` ` \`\` → Lompat ke posisi sebelumnya sebelum jump
  *(Sumber: KeyCombiner & GitHub)* ([keycombiner.com][1], [GitHub][2])

### 7. Manipulasi Tab & Jendela

* `t` → Buka tab baru
* `yt` → Duplikat tab sekarang
* `x` → Tutup tab sekarang
* `X` (Shift+x) → Restore tab yang ditutup
* `J` / `Shift+J` → Pindah ke tab kiri
* `K` / `Shift+K` → Pindah ke tab kanan
* `g0` → Pindah ke tab pertama
* `g$` → Pindah ke tab terakhir
* `^` → Kembali ke tab sebelumnya (visited)
* `Alt+p` (`<a-p>`) → Pin/unpin tab
* `Alt+m` (`<a-m>`) → Mute/unmute tab
* `Shift+w` (`W`) → Pindah tab ke jendela baru
* `<<` / `>>` → Pindah tab ke kiri / ke kanan
  *(Sumber: KeyCombiner & Web Store)* ([keycombiner.com][1], [Toko Web Chrome][3], [addons.mozilla.org][4])

### 8. Utilitas Lainnya & Miscellaneous

* `gs` → Lihat *page source*
* `[[` → Ikuti tautan "previous" (yang bertanda)
* `]]` → Ikuti tautan "next"
* `?` → Tampilkan dialog bantuan (help)
* `Esc` atau `Ctrl+[ `→ Batalkan sequence atau keluar mode insert/find/visual
  *(Sumber: KeyCombiner & GitHub)* ([keycombiner.com][1], [GitHub][2])

---

[1]: https://keycombiner.com/collections/vimium/?utm_source=chatgpt.com "Vimium Keyboard Shortcuts - KeyCombiner"
[2]: https://github.com/gdh1995/vimium-c?utm_source=chatgpt.com "gdh1995/vimium-c: A keyboard shortcut browser extension ... - GitHub"
[3]: https://chromewebstore.google.com/detail/vimium-c-all-by-keyboard/hfjbmagddngcpeloejdejnfgbamkjaeg?utm_source=chatgpt.com "Vimium C - All by Keyboard - Chrome Web Store"
[4]: https://addons.mozilla.org/en-US/firefox/addon/vimium-c/?utm_source=chatgpt.com "Vimium C - All by Keyboard – Get this Extension for Firefox (en-US)"

