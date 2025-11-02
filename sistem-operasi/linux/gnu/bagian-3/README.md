# Tujuan Proyek GNU & Lisensi GPL — Panduan Lengkap

## Ringkasan singkat tujuan proyek GNU

Proyek GNU bertujuan menyediakan **sistem operasi Unix-like yang sepenuhnya bebas**: bukan hanya perangkat lunak gratis secara biaya, tetapi bebas (libre) menurut empat kebebasan FSF. Agar kebebasan itu bertahan ketika perangkat lunak didistribusikan atau berubah, GNU mempromosikan lisensi copyleft — paling terkenal: **GNU General Public License (GPL)**. GPL dirancang untuk memastikan bahwa hak pengguna tetap melekat pada setiap salinan atau turunan perangkat lunak. ([gnu.org][1])

---

## 1. Apa itu GPL — konsep inti

* **GPL = General Public License**: lisensi copyleft yang mewajibkan pihak yang mendistribusikan karya turunan untuk menyediakan kode sumber di bawah syarat yang sama. Tujuannya: menjaga kebebasan pengguna, mencegah pihak ketiga menutup kembali kode yang awalnya “bebas”. ([gnu.org][1])
* **Copyleft**: strategi lisensi yang memberi izin luas (menggunakan, menyalin, memodifikasi, mendistribusikan) tetapi memberlakukan syarat agar setiap karya turunan juga harus ditawarkan dengan kebebasan yang sama. Ini berbeda dari lisensi permisif (MIT/BSD) yang memperbolehkan menutup kembali perubahan. ([gnu.org][2])

---

## 2. Perbandingan teknis: GPLv2 vs GPLv3 (intinya dan klausul penting)

Ringkas: GPLv3 adalah revisi besar GPLv2; GPLv3 menanggapi masalah modern (tivoization, paten, kompatibilitas lisensi), menambah klausul perlindungan paten dan pembatasan praktik yang melanggar kebebasan (mis. perangkat keras yang mencegah modifikasi meski perangkat lunak bebas terpasang).

Detail penting dan contoh klausul:

1. **Tivoization** (penutupan perangkat keras):

   * **Masalah**: perangkat (mis. set-top box) yang memakai perangkat lunak GPL tetapi memblokir pengguna menjalankan firmware yang dimodifikasi (mis. signature checks).
   * **GPLv3**: memasukkan ketentuan yang mencegah pabrikan menghalangi pengguna menjalankan versi perangkat lunak modifikasi yang sah pada perangkat mereka sendiri. Ini sering disebut anti-tivoization. GPLv2 tidak memiliki klausul eksplisit ini. ([fsf.org][3])

2. **Perlindungan paten**:

   * **GPLv3** menambahkan klausul eksplisit yang memberi perlindungan terhadap klaim paten dari kontributor/pihak-pihak yang memberi lisensi; juga menghalangi distributor membuat perjanjian paten yang membatasi kebebasan penerima. GPLv2 mengandalkan interpretasi implisit dan kurang spesifik terkait paten. ([fsf.org][3])

3. **Kompatibilitas lisensi**:

   * **GPLv3** dirancang untuk lebih kompatibel dengan beberapa lisensi modern (mis. Apache 2.0 kompatibilitas dengan GPLv3 setelah penyesuaian). **GPLv2** tidak kompatibel dengan beberapa lisensi baru kecuali jika paket asli diberi pilihan “or later” (lihat bagian kompatibilitas). ([fsf.org][4])

4. **Clause “or later” vs “only”**:

   * Saat merilis perangkat lunak Anda, pernyataan lisensi harus eksplisit: `GPL-2.0-only` (hanya v2) atau `GPL-2.0-or-later` (v2 atau versi selanjutnya). Perbedaan ini penting untuk kompatibilitas legal. Gunakan konvensi SPDX dalam file sumber. ([spdx.dev][5])

Sumber primer: teks resmi GPLv2 dan GPLv3, serta panduan FSF. ([gnu.org][6])

---

## 3. Klausul penting yang harus diketahui pengembang (ringkasan praktis)

* **Hak dan kewajiban distribusi biner**: Jika Anda mendistribusikan biner yang dibangun dari kode GPL, Anda wajib menyediakan sumber (atau menawarkan sumber) sesuai ketentuan lisensi. (lihat pasal distribusi pada teks GPL). ([gnu.org][7])
* **Header lisensi & pernyataan copyright**: Setiap file sumber disarankan berisi header lisensi singkat; gunakan tag SPDX agar mesin dan auditor mudah mengenali lisensi (`// SPDX-License-Identifier: GPL-3.0-or-later`). SPDX membantu konsistensi metadata. ([spdx.github.io][8])
* **Exceptions**: Beberapa proyek menambahkan “exceptions” pada lisensi (mis. GCC runtime exception). Exception mengizinkan tindakan yang sebaliknya dilarang oleh GPL (contoh: linkage tertentu). Jika proyek Anda memakai exception, nyatakan jelas: `GPL-3.0-only WITH GCC-exception-3.1`. ([reuse.software][9])

---

## 4. Cara memilih versi GPL untuk proyek Anda — langkah praktis

1. **Putuskan filosofi Anda**: apakah Anda ingin memaksa turunan tetap bebas (copyleft kuat) → gunakan GPL; jika Anda ingin memberi kebebasan lebih bagi pihak yang memakai kode Anda (termasuk penggunaan proprietari) → pertimbangkan LGPL atau lisensi permissive (MIT/BSD). ([gnu.org][1])
2. **Pilih “only” atau “or-later”**:

   * Jika Anda kuatir perubahan versi lisensi dapat merugikan, gunakan `-only`.
   * Jika Anda ingin memberi penerima fleksibilitas memakai versi GPL yang lebih baru di masa depan, gunakan `-or-later`. Banyak proyek memilih `-or-later` agar kompatibel dengan perbaikan lisensi di masa mendatang. Periksa kebijakan komunitas proyek jika ingin kontribusi eksternal. ([spdx.dev][5])
3. **Terapkan header SPDX di setiap file** (contoh):

   ```c
   /* SPDX-License-Identifier: GPL-3.0-or-later */
   /* Copyright (c) 2025 Nama Anda <email@domain> */
   ```

   Ini membuat pemeriksaan lisensi otomatis lebih andal. ([spdx.github.io][8])

---

## 5. Kompatibilitas lisensi & linking — aturan praktis yang sering membingungkan

* **Linking (static vs dynamic)**: Dari sudut pandang FSF, **meng-link (statically atau dynamically) sebuah modul dengan karya GPL** biasanya menghasilkan “combined work” sehingga seluruh gabungan harus kompatibel dengan GPL (artinya Anda tidak boleh menempelkan kode yang lisensinya tidak kompatibel). Namun implementasi teknis dan interpretasi hukum dapat berbeda antar yurisdiksi—praktik aman: pastikan semua dependensi memiliki lisensi yang kompatibel. Untuk library khusus, gunakan **LGPL** bila Anda ingin memperbolehkan link dari kode non-GPL. ([gnu.org][10])
* **Pernyataan kompatibilitas**: cek apakah paket memakai `GPL-2.0-only` (tidak kompatibel langsung dengan GPLv3) atau `GPL-2.0-or-later` (kompatibilitas via “or later”). Gunakan SPDX untuk kejelasan. ([gnu.org][11])

---

## 6. Kasus penegakan (ringkas, pelajaran praktis)

* **BusyBox & tindakan hukum (2007–2013):** beberapa produsen perangkat elektronik dituntut/diteresolusi karena mendistribusikan BusyBox (GPLv2) tanpa menyediakan source. Banyak kasus berakhir dengan penyelesaian yang mewajibkan kepatuhan (termasuk publikasi source) atau ganti rugi. Kasus ini menegaskan: **melanggar ketentuan GPL dapat berujung pada tuntutan hak cipta**. Organisasi seperti Software Freedom Conservancy dan Software Freedom Law Center aktif menegakkan kepatuhan GPL. ([softwarefreedom.org][12])
* **Pelajaran praktis**: perusahaan harus memelihara inventaris lisensi komponen (SBOM), mengikuti praktik verifikasi, dan memenuhi kewajiban distribusi source saat menggunakan kode GPL. Alat audit lisensi dan workflow CI membantu mencegah pelanggaran. ([scancode-toolkit.readthedocs.io][13])

---

## 7. Alat & langkah praktis untuk verifikasi lisensi pada proyek (perintah & contoh)

### 7.1 Periksa file lisensi & tanda tangan sumber

```bash
# 1. Periksa file lisensi di source tarball
tar -tf package-1.2.3.tar.xz | sed -n '1,50p'
# atau
ls -la package-1.2.3/ | grep -Ei 'copying|license|gpl|lgpl'

# 2. Verifikasi GPG (jika tersedia)
wget https://ftp.gnu.org/gnu/grep/grep-3.11.tar.xz
wget https://ftp.gnu.org/gnu/grep/grep-3.11.tar.xz.sig
gpg --keyserver hkps://keys.openpgp.org --recv-keys <KEYID>
gpg --verify grep-3.11.tar.xz.sig grep-3.11.tar.xz
```

Sumber: panduan GPL & praktik verifikasi upstream. ([gnu.org][7])

### 7.2 Gunakan scanner lisensi otomatis (rekomendasi)

* **ScanCode Toolkit** — inventori lisensi, copyright, dependensi. Cocok untuk audit lengkap dan menghasilkan output JSON/HTML. Contoh cepat:

```bash
# install & scan (lihat dokumentasi ScanCode)
scancode --license --copyright --summary --json results.json path/to/source
```

ScanCode dokumentasi: ScanCode Toolkit. ([scancode-toolkit.readthedocs.io][13])

* **licensecheck** (debian/Perl) — pemeriksa cepat untuk file sumber:

```bash
licensecheck -r path/to/source
```

`licensecheck` sering tersedia di repositori Debian/Ubuntu. ([manpages.ubuntu.com][14])

* **licensee** (GitHub uses): deteksi lisensi file `LICENSE` untuk proyek git-based:

```bash
gem install licensee
licensee detect /path/to/repo
```

Licensee adalah alat populer untuk deteksi lisensi pada repositori GitHub. ([GitHub][15])

### 7.3 Periksa metadata paket (contoh Arch / Debian)

* Arch:

```bash
pacman -Qi coreutils      # lihat field License(s)
pacman -Ql coreutils | head
pacman -Qo /usr/bin/ls
```

* Debian/Ubuntu:

```bash
dpkg -s coreutils
apt download package
dpkg -x package.deb tmp/
ls tmp/usr/share/doc/*     # cari file copyright
```

Metadata repositori sering memuat informasi lisensi. ([gnu.org][16])

---

## 8. Cara menandai proyek Anda (praktik baik)

1. **Tambahkan file LICENSE** di root repositori berisi teks lengkap GPL versi yang Anda pilih (GPLv2/GPLv3). Gunakan teks resmi dari gnu.org. ([gnu.org][6])
2. **Tambahkan header SPDX di setiap file sumber**:

   ```c
   /* SPDX-License-Identifier: GPL-3.0-or-later */
   /* Copyright (c) 2025 Nama Anda <email> */
   ```

   Ini membuat metadata lisensi tetap melekat pada setiap file meskipun file dipisah dari repositori. Gunakan format yang sesuai dengan bahasa file (komentar C, komentar Python `#`, dsb.). ([spdx.github.io][8])
3. **Isi metadata package manager** (mis. `package.json`, `Cargo.toml`, `PKGBUILD`) dengan SPDX identifier yang jelas (`GPL-3.0-or-later`). Hindari label umum seperti “GPL” tanpa versi. ([spdx.dev][5])

---

## 9. Checklist kepatuhan cepat untuk developer / tim

* [ ] Ada file `LICENSE` berisi teks resmi (GPLv2/v3) di root. ([gnu.org][7])
* [ ] Setiap file sumber mempunyai header SPDX. ([spdx.github.io][8])
* [ ] Lakukan scan lisensi (ScanCode / licensecheck / licensee) sebagai bagian CI. ([scancode-toolkit.readthedocs.io][13])
* [ ] Semua dependensi lisensi kompatibel atau ada solusi (LGPL untuk libraries, exceptions bila perlu). ([gcc.gnu.org][17])
* [ ] Jika mendistribusikan biner, pastikan tersedia source atau offer of source sesuai ketentuan GPL. ([gnu.org][7])

---

## 10. Referensi utama (agar disertakan di dokumen)

* Teks GPLv3, GPLv2 (official). ([gnu.org][7])
* FSF: Mengapa GPLv3, FAQ tentang lisensi GNU. ([fsf.org][3])
* Panduan cepat GPLv3 (Quick Guide). ([gnu.org][2])
* Panduan SPDX & penggunaan identifier file-level. ([spdx.github.io][8])
* ScanCode Toolkit, licensecheck, licensee (alat deteksi lisensi). ([scancode-toolkit.readthedocs.io][13])
* Studi kasus penegakan: BusyBox enforcement (SFLC / Conservancy). ([softwarefreedom.org][12])

---

## Penutup singkat (rekomendasi praktis untuk Anda)

Sebagai pelajar IT yang ingin mendalami GNU dan pengaruh lisensinya: mulai dari praktik kecil — gunakan SPDX header pada proyek percobaan, jalankan ScanCode di repositori Anda, dan coba membuat paket kecil (mis. `grep`) sambil memperhatikan `LICENSE` dan metadata. Kemudian bangun workflow CI yang otomatis memindai lisensi sebelum merge — ini kebiasaan profesional yang akan sangat berguna bila Anda bekerja pada dotfiles, plugin, atau distribusi.

---

[1]: https://www.gnu.org/licenses/gpl.txt?utm_source=chatgpt.com "General Public License (GPL)"
[2]: https://www.gnu.org/licenses/quick-guide-gplv3.html?utm_source=chatgpt.com "A Quick Guide to GPLv3"
[3]: https://www.fsf.org/licensing/licenses/rms-why-gplv3.html?utm_source=chatgpt.com "Why Upgrade to GPLv3"
[4]: https://www.fsf.org/news/gpl3dd4-released?utm_source=chatgpt.com "FSF Releases \"Last Call\" Draft of GPLv3"
[5]: https://spdx.dev/learn/handling-license-info/?utm_source=chatgpt.com "Handling License Info"
[6]: https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt?utm_source=chatgpt.com "gpl-2.0.txt"
[7]: https://www.gnu.org/licenses/gpl-3.0.html?utm_source=chatgpt.com "The GNU General Public License v3.0"
[8]: https://spdx.github.io/spdx-spec/v2.3/using-SPDX-short-identifiers-in-source-files/?utm_source=chatgpt.com "Annex E: Using SPDX short identifiers in Source Files"
[9]: https://reuse.software/faq/?utm_source=chatgpt.com "Frequently Asked Questions | REUSE"
[10]: https://www.gnu.org/licenses/gpl-faq.html?utm_source=chatgpt.com "Frequently Asked Questions about the GNU Licenses"
[11]: https://www.gnu.org/licenses/identify-licenses-clearly.html?utm_source=chatgpt.com "Don't Say “Licensed under GNU GPL 2”!"
[12]: https://softwarefreedom.org/news/2009/dec/14/busybox-gpl-lawsuit/?utm_source=chatgpt.com "Best Buy, Samsung, Westinghouse, And Eleven Other ..."
[13]: https://scancode-toolkit.readthedocs.io/en/latest/getting-started/home.html?utm_source=chatgpt.com "Home — ScanCode-Toolkit documentation"
[14]: https://manpages.ubuntu.com/manpages/jammy/man1/licensecheck.1p.html?utm_source=chatgpt.com "licensecheck - simple license checker for source files"
[15]: https://github.com/licensee/licensee?utm_source=chatgpt.com "licensee/licensee: A Ruby Gem to detect under what ..."
[16]: https://www.gnu.org/licenses/old-licenses/lgpl-2.0.html?utm_source=chatgpt.com "GNU Library General Public License, version 2.0"
[17]: https://gcc.gnu.org/onlinedocs/gcc-4.8.5/libstdc%2B%2B/manual/faq.html?utm_source=chatgpt.com "Frequently Asked Questions"

