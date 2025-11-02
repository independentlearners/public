# Latar Belakang — Richard M. Stallman & Free Software Foundation (FSF)

## 1. Ringkasan singkat

Richard M. Stallman (RMS) memulai proyek GNU pada akhir 1983 dengan tujuan teknis sekaligus etis: membangun sebuah **sistem operasi bebas** serta mengembalikan kendali perangkat lunak kepada pengguna—bukannya pemilik/penerbit perangkat lunak. Untuk mendukung dan mengorganisir proyek ini, Stallman mendirikan **Free Software Foundation (FSF)** pada 1985. FSF bertindak sebagai rumah bagi dokumentasi proyek, lisensi (mis. GPL), serta advokasi kebebasan perangkat lunak. ([gnu.org][1])

---

## 2. Motivasi dan nilai dasar — konteks historis

Pada era 1970–1980-an semakin banyak perangkat lunak kritis berubah menjadi proprietary; pengguna kehilangan kemampuan untuk mempelajari, memperbaiki, atau membagi perangkat lunak tersebut. Stallman menilai situasi ini sebagai masalah moral dan praktis: ketika perangkat lunak tidak dapat diperiksa atau diperbaiki oleh penggunanya, maka pengguna kehilangan kebebasan penting. Manifesto GNU (1985) adalah dokumen perintis yang memaparkan argumen ini dan mengajak komunitas untuk berkontribusi pada proyek yang “bebas” (libre). ([gnu.org][1])

---

## 3. Empat Kebebasan Perangkat Lunak (The Four Freedoms) — inti filosofi

Istilah “Free Software” menurut GNU/FSF merujuk pada kebebasan, bukan harga. Ada empat kebebasan inti yang harus dimiliki perangkat lunak agar dianggap *free*:

0. **Kebebasan untuk menjalankan program** untuk tujuan apa pun.
1. **Kebebasan untuk mempelajari cara kerja program** dan mengubahnya (akses terhadap *source code* wajib).
2. **Kebebasan untuk mendistribusikan salinan** agar orang lain mendapat manfaat.
3. **Kebebasan untuk memperbaiki program** dan merilis perbaikan ke publik.

Pemahaman praktis: bila salah satu kebebasan ini tidak tersedia—mis. kode sumber tidak disertakan atau dihalangi—maka perangkat lunak dapat dikategorikan proprietary. Penjabaran resmi dan contoh penerapan tersedia di dokumentasi GNU/FSF. ([gnu.org][2])

---

## 4. Free Software Foundation (FSF) — peran dan struktur singkat

* **Tujuan organisasi:** mempromosikan kebebasan pengguna perangkat lunak, mengelola dan menjaga lisensi (GPL, LGPL, dsb.), serta mendukung pengembangan paket GNU.
* **Kegiatan:** penulisan/penjagaan lisensi, advokasi hukum dan teknis, konservasi proyek GNU, kampanye kesadaran, serta penyediaan sumber daya untuk pengembang.
* **Hubungan dengan proyek GNU:** FSF adalah badan payung yang mendukung proyek GNU; beberapa proyek penting merupakan proyek resmi GNU. Untuk sumber dan program, lihat halaman FSF dan GNU Project. ([fsf.org][3])

---

## 5. Dampak hukum & sosial dari filosofi FSF

* **Copyleft (konsep utama FSF):** berbeda dengan lisensi permissive (MIT/BSD), copyleft (contoh: GPL) mewajibkan turunan karya untuk tetap diberi kebebasan yang sama—artinya jika Anda mendistribusikan versi yang dimodifikasi, Anda harus menyediakan source code dan melisensikannya di bawah syarat yang kompatibel. Konsekuensi praktis: memaksa ekosistem agar tetap "bebas" ketika karya disebarluaskan. ([gnu.org][4])
* **Pertentangan dengan pendekatan komersial:** beberapa entitas memilih model lisensi permissive untuk mempermudah integrasi dengan kode komersial; FSF berargumen bahwa copyleft melindungi kebebasan pengguna jangka panjang. Perdebatan ini adalah bagian dari sejarah gerakan perangkat lunak bebas vs open source. ([WIRED][5])

---

## 6. Praktis — cara pelajar memverifikasi dan menelaah klaim “free” pada perangkat lunak

### 6.1 Menemukan *source* dan file lisensi pada paket sumber atau tarball

* Setelah mengunduh tarball (contoh: `grep-3.11.tar.xz`), periksa file lisensi:

```bash
tar -tf grep-3.11.tar.xz | sed -n '1,40p'
# atau setelah ekstraksi:
ls -la grep-3.11/ | grep -Ei 'copying|license|licen|gpl'
```

* Biasanya nama file lisensi: `COPYING`, `LICENSE`, atau `COPYING.LESSER` (untuk LGPL). Jika file tersebut ada dan berisi teks GPL → berarti proyek mendistribusikan lisensi tersebut bersama sumber.

### 6.2 Verifikasi GPG signature (praktik keamanan)

Bila tersedia `.sig` atau `.asc` pada server upstream (mis. `ftp.gnu.org`), verifikasi tanda tangan untuk memastikan integritas dan keaslian tarball:

```bash
wget https://ftp.gnu.org/gnu/grep/grep-3.11.tar.xz
wget https://ftp.gnu.org/gnu/grep/grep-3.11.tar.xz.sig
gpg --keyserver hkps://keys.openpgp.org --recv-keys <KEYID>   # impor public key pengembang/maintainer
gpg --verify grep-3.11.tar.xz.sig grep-3.11.tar.xz
```

Jika verifikasi GPG sukses → file sah ditandatangani oleh pemegang kunci. Jika tidak ada .sig, verifikasi checksum (SHA256) dari situs resmi. (Catatan: model tanda tangan dan keyserver dapat berbeda menurut proyek.)

### 6.3 Memeriksa lisensi lewat manajer paket (Arch) — contoh praktis

* Untuk **paket yang terpasang**:

```bash
pacman -Qi coreutils
```

Perhatikan field `Licenses` (atau `License`) pada output. Untuk paket di repo tetapi belum terpasang:

```bash
pacman -Si coreutils
```

Untuk menelusuri file yang disertakan paket:

```bash
pacman -Ql coreutils | head -n 20
```

Dan untuk menemukan paket yang menyediakan file tertentu:

```bash
pacman -Qo /usr/bin/ls
```

Arsip dokumentasi dan metadata PKGBUILD sering menyertakan informasi lisensi yang jelas. (Pacman dan repositori Arch menjaga metadata ini; lihat Arch Wiki untuk detail praktik tanda tangan paket). ([wiki.archlinux.org][6])

### 6.4 Memeriksa lisensi pada Debian/Ubuntu

* Lokasi informasi lisensi sering berada pada:

  * `/usr/share/doc/<paket>/copyright`
  * atau lihat sumber paket (`apt source <paket>`) kemudian inspeksi file LICENSE/COPYING.
    Contoh:

```bash
apt update
apt download grep
dpkg -x grep_*.deb ./grep-extracted
grep -Ri "license" grep-extracted || ls grep-extracted/usr/share/doc/*
```

---

## 7. Contoh kasus & interpretasi singkat

* **GPL (copyleft) — efek praktis:** bila Anda mengubah binary GPL dan mendistribusikannya, Anda harus juga menyediakan *source code* perubahan dan boleh jadi menaruhnya di tempat yang mudah diakses (mis. server atau bundled bersama paket). Pembagian ini berbeda dengan lisensi permissive yang mengizinkan redistribusi biner tanpa mewajibkan pelepasan source perubahan. Sumber resmi detail ada di teks GPLv3. ([gnu.org][4])
* **Mengapa kernel Linux tetap di GPLv2?** Banyak komponen GNU beralih atau merekomendasikan GPLv3, namun kernel Linux tetap memakai `GPLv2-only` atau `GPLv2-or-later` tergantung versi/pengembang; alasan teknis-politik dan kompatibilitas membuat kernel belum beralih ke GPLv3 penuh, yang menimbulkan diskusi panjang di komunitas. Perbedaan antara v2 dan v3 meliputi isu paten, DRM (tivoization), dan ketentuan lain yang ditambahkan dalam GPLv3. ([Wikipedia][7])

---

## 8. Sumber belajar lanjutan (yang saya gunakan / rekomendasikan)

* GNU Manifesto — teks asli (Richard Stallman). ([gnu.org][1])
* What is Free Software? — Penjabaran Four Freedoms, GNU Project. ([gnu.org][2])
* GNU General Public License v3 (teks lisensi & penjelasan). ([gnu.org][4])
* Arch Wiki — pacman, package signing, tips & best practices packaging. ([wiki.archlinux.org][6])
* Artikel & ringkasan perbedaan GPLv2 vs GPLv3 (Wired, ifrOSS, diskusi komunitas). ([WIRED][5])

---

## 9. Ringkasan poin-poin penting untuk pelajar (actionable checklist)

1. Baca **GNU Manifesto** untuk konteks filosofis. ([gnu.org][1])
2. Ketahui dan hafalkan **empat kebebasan** — ini akan menjadi alat ukur saat menilai apakah suatu proyek “free software”. ([gnu.org][2])
3. Saat mengunduh tarball, selalu cari file `COPYING`/`LICENSE` dan verifikasi tanda tangan `.sig` bila tersedia.
4. Gunakan `pacman -Qi <paket>` (Arch) atau periksa `/usr/share/doc/<paket>/copyright` (Debian) untuk konfirmasi lisensi paket. ([wiki.archlinux.org][6])
5. Pelajari perbedaan antara **copyleft** (GPL) dan **permissive** (MIT/BSD) agar memahami konsekuensi distribusi. ([gnu.org][4])

---

[1]: https://www.gnu.org/gnu/manifesto.en.html?utm_source=chatgpt.com "The GNU Manifesto - GNU Project - Free Software ..."
[2]: https://www.gnu.org/philosophy/free-sw.html?utm_source=chatgpt.com "What is Free Software?"
[3]: https://www.fsf.org/?utm_source=chatgpt.com "Front Page — Free Software Foundation — working together ..."
[4]: https://www.gnu.org/licenses/gpl-3.0.en.html?utm_source=chatgpt.com "The GNU General Public License v3.0"
[5]: https://www.wired.com/2007/06/gnu-gplv3-launches-tomorrow?utm_source=chatgpt.com "GNU GPLv3 Launches Tomorrow"
[6]: https://wiki.archlinux.org/title/Pacman?utm_source=chatgpt.com "pacman - ArchWiki"
[7]: https://en.wikipedia.org/wiki/GNU_General_Public_License?utm_source=chatgpt.com "GNU General Public License"

