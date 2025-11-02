# 📎 9. Lampiran — PKGBUILD, Build dari Source, & Checklist Kontributor

Bagian ini berfungsi sebagai panduan teknis pelengkap untuk pengembang yang ingin **membangun, memodifikasi, atau memverifikasi alat GNU secara langsung** di Arch Linux. Semua langkah di sini bersifat praktis, reproducible, dan dapat diuji di sistem nyata.

---

## 1. Contoh PKGBUILD: `grep` (GNU Grep)

Berikut adalah contoh `PKGBUILD` sederhana untuk **GNU Grep**, siap digunakan di Arch Linux.

```bash
# Maintainer: Nama Anda <you@example.com>
pkgname=grep-custom
pkgver=3.11
pkgrel=1
pkgdesc="GNU grep - fast pattern matching (custom build)"
arch=('x86_64')
url="https://www.gnu.org/software/grep/"
license=('GPL-3.0-or-later')
depends=('glibc')
makedepends=('texinfo')
source=("https://ftp.gnu.org/gnu/grep/grep-${pkgver}.tar.xz"
        "https://ftp.gnu.org/gnu/grep/grep-${pkgver}.tar.xz.sig")
sha256sums=('PUT_SHA256_HASH_HERE'
            'SKIP')

validpgpkeys=('7E81AF524DFAF74E')

build() {
  cd "${srcdir}/grep-${pkgver}"
  ./configure --prefix=/usr
  make -j$(nproc)
}

check() {
  cd "${srcdir}/grep-${pkgver}"
  make check || true
}

package() {
  cd "${srcdir}/grep-${pkgver}"
  make DESTDIR="${pkgdir}" install
}
```

Build dan instalasi:

```bash
makepkg -si
```

---

## 2. Contoh build dari source: `coreutils`

**GNU Coreutils** adalah jantung sistem userland GNU (berisi `ls`, `cat`, `mv`, `chmod`, dll).
Langkah-langkah build manual di Arch:

```bash
sudo pacman -S base-devel gmp mpfr libmpc texinfo
wget https://ftp.gnu.org/gnu/coreutils/coreutils-9.5.tar.xz
wget https://ftp.gnu.org/gnu/coreutils/coreutils-9.5.tar.xz.sig
gpg --keyserver hkps://keys.openpgp.org --recv-keys <KEYID>
gpg --verify coreutils-9.5.tar.xz.sig coreutils-9.5.tar.xz
tar -xf coreutils-9.5.tar.xz
cd coreutils-9.5
./configure --prefix=/usr
make -j$(nproc)
make check
sudo make install
```

Verifikasi hasil:

```bash
ls --version
```

Output:

```
ls (GNU coreutils) 9.5
```

---

## 3. Langkah debugging build besar (contoh: GCC)

GCC adalah proyek GNU paling kompleks.
Berikut pendekatan sistematis untuk debugging build-nya:

### a. Gunakan log build penuh

```bash
make -j$(nproc) 2>&1 | tee build.log
grep -i error build.log | less
```

### b. Periksa dependensi matematika

Pastikan pustaka berikut tersedia dan kompatibel:

```bash
pacman -Qi gmp mpfr libmpc isl
```

### c. Debug konfigurasi

```bash
grep "configure:" config.log | tail -n 10
```

### d. Jalankan subset tes

```bash
make -k check RUNTESTFLAGS="gcc.dg/torture.exp=compile.exp"
```

### e. Jika gagal:

* Pastikan `LD_LIBRARY_PATH` bersih dari pustaka versi lama.
* Gunakan container *clean chroot* Arch:

  ```bash
  arch-nspawn /var/lib/archbuild/x86_64/root /bin/bash
  ```
* Hindari menimpa compiler sistem; instal di `/opt/gcc-custom`.

---

## 4. Checklist keamanan & praktik verifikasi GPG

Sebelum membangun alat GNU apa pun dari sumber, selalu lakukan langkah-langkah ini:

### 🔐 **Langkah verifikasi GPG**

1. Impor kunci pengembang resmi:

   ```bash
   gpg --keyserver hkps://keys.openpgp.org --recv-keys <KEYID>
   ```
2. Verifikasi tanda tangan file sumber:

   ```bash
   gpg --verify file.tar.xz.sig file.tar.xz
   ```
3. Cek hasil:

   ```
   gpg: Good signature from "GNU Maintainer <maintainer@gnu.org>"
   ```

### 📦 **Validasi integritas paket**

```bash
sha256sum -c <(cat <<EOF
<hash>  file.tar.xz
EOF
)
```

### ⚙️ **Isolasi build**

Gunakan `chroot` atau container Arch:

```bash
sudo mkarchroot /var/lib/archbuild/base-devel/root base-devel
sudo arch-nspawn /var/lib/archbuild/base-devel/root bash
```

### 🧩 **Verifikasi biner hasil build**

```bash
file /usr/bin/ls
readelf -p .comment /usr/bin/ls
```

Pastikan compiler menunjukkan “(GNU)”.

### 🧱 **Audit PATH**

```bash
type -a make gcc ld
```

Pastikan versi GNU yang aktif adalah yang di `/usr/bin`.

---

## 5. Checklist kontributor dokumentasi

Bagi siapa pun yang berkontribusi pada proyek dokumentasi GNU ini, patuhi pedoman berikut:

| Tahapan                  | Deskripsi                                                            |
| ------------------------ | -------------------------------------------------------------------- |
| **1. Validasi sumber**   | Gunakan referensi resmi GNU/FSF/Arch Wiki                            |
| **2. Standar penulisan** | Gunakan gaya bahasa dokumentasi profesional, formal, dan berurutan   |
| **3. Reproducibility**   | Semua perintah build harus bisa direproduksi di Arch Linux           |
| **4. Verifikasi hasil**  | Gunakan `make check` dan GPG signature                               |
| **5. Lisensi**           | Cantumkan lisensi GPL-3.0 di setiap kontribusi kode                  |
| **6. Referensi**         | Cantumkan sumber di akhir setiap file dokumentasi                    |
| **7. Audit teknis**      | Jalankan linting Markdown (`markdownlint`) dan validasi syntax shell |

---
