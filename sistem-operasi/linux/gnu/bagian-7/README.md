# 🔍 Verifikasi Tools GNU

Tujuan utama bab ini adalah memastikan bahwa sistem Anda benar-benar menggunakan alat-alat dari proyek GNU, bukan implementasi alternatif (misalnya `busybox`, `toybox`, atau `llvm`), serta memahami bagaimana cara mengaudit, memeriksa versi, dan memperbarui tool GNU secara aman di Arch Linux.

---

## 1. Tujuan verifikasi

Mengapa perlu melakukan verifikasi?
Karena banyak distribusi Linux modern (terutama turunan minimalis atau embedded) mengganti sebagian alat GNU dengan versi ringan yang *tidak 100% kompatibel*. Misalnya:

* `ls`, `cat`, `grep` versi BusyBox
* `ld` dari LLVM (lld)
* `make` dari BSD Make

Pada sistem seperti Arch, hampir semuanya adalah **GNU Tools asli**, tetapi verifikasi tetap penting untuk:

* memastikan konsistensi sistem;
* menghindari konflik PATH (misal alat non-GNU di `/usr/local/bin`);
* dan mendukung rekonstruksi toolchain yang stabil saat membangun paket atau kernel.

---

## 2. Mengecek versi alat GNU dasar

Setiap alat GNU mencantumkan identitas proyek pada opsi `--version`. Contoh:

```bash
ls --version | head -n 1
grep --version | head -n 1
bash --version | head -n 1
gcc --version | head -n 1
make --version | head -n 1
gdb --version | head -n 1
ld --version | head -n 1
```

Hasil normal di Arch Linux:

```
ls (GNU coreutils) 9.5
grep (GNU grep) 3.11
GNU bash, version 5.2.32
gcc (GCC) 14.2.0
GNU Make 4.4.1
GNU gdb (GDB) 14.2
GNU ld (GNU Binutils) 2.43.1
```

Jika Anda melihat nama lain seperti `toybox`, `busybox`, atau `BSD`, berarti alat itu bukan dari GNU.

---

## 3. Menemukan semua alat GNU di sistem

Gunakan `pacman` untuk mencari paket yang berhubungan dengan GNU:

```bash
pacman -Q | grep gnu
```

atau, untuk daftar yang lebih luas:

```bash
pacman -Q | grep -E 'gcc|make|binutils|gdb|coreutils|bash|glibc|findutils|grep'
```

Anda juga bisa memeriksa metadata paket:

```bash
pacman -Qi coreutils | grep URL
```

Biasanya menampilkan tautan resmi GNU:

```
URL             : https://www.gnu.org/software/coreutils/
```

---

## 4. Verifikasi melalui berkas biner

Untuk memastikan biner yang dijalankan berasal dari GNU Toolchain resmi, gunakan:

```bash
file /usr/bin/ls
ldd /usr/bin/ls
readelf -p .comment /usr/bin/ls
```

Contoh hasil `.comment`:

```
GCC: (GNU) 14.2.0
```

Menandakan program dikompilasi menggunakan GCC dari GNU.

---

## 5. Audit PATH untuk mendeteksi duplikasi

Jika Anda memiliki alat non-GNU di PATH lebih tinggi dari `/usr/bin`, sistem bisa memanggil versi lain tanpa disadari. Cek urutan PATH:

```bash
echo $PATH | tr ':' '\n'
```

Lalu periksa sumber alat:

```bash
type -a ls
type -a grep
```

Pastikan baris pertama selalu `/usr/bin/<tool>` (bukan `/usr/local/bin` atau `/bin/busybox`).

---

## 6. Verifikasi konsistensi Toolchain (GCC, Binutils, Glibc)

Untuk memastikan ketiganya kompatibel:

```bash
gcc -v | grep version
ld -v | grep version
ldd --version | head -n 1
```

Pastikan semuanya menggunakan versi terbaru dan berasal dari GNU.

Contoh di Arch:

```
gcc version 14.2.0 (GCC)
GNU ld (GNU Binutils) 2.43.1
ldd (GNU libc) 2.40
```

Perbedaan besar antarversi bisa menyebabkan error linking atau ketidakcocokan ABI.

---

## 7. Melacak dependensi GNU Toolchain

Untuk melihat paket apa saja yang bergantung pada GNU Toolchain:

```bash
pactree gcc
pactree binutils
pactree glibc
```

Anda akan melihat bagaimana seluruh sistem (termasuk makepkg, pacman, dan utilitas pembangunan lainnya) bertumpu pada GNU Toolchain.

---

## 8. Membandingkan dengan alternatif non-GNU

Coba lihat contoh minimalis:

```bash
busybox ls
```

Outputnya jauh lebih sederhana dan tidak mendukung opsi lanjutan seperti `--color` atau `--classify`.
Dengan begitu, pengguna akan memahami mengapa GNU Coreutils jauh lebih lengkap dan fleksibel untuk sistem pengembangan profesional.

---

## 9. Memverifikasi integritas paket GNU

Gunakan *hash* dan tanda tangan digital dari repositori resmi:

```bash
sudo pacman -Qkk coreutils
sudo pacman -Qkk bash
```

Jika hasilnya:

```
coreutils: 156 total files, 0 altered files
```

berarti paket aman dan belum dimodifikasi.
Untuk sumber:

```bash
gpg --verify coreutils-x.y.tar.xz.sig
```

---

## 10. Menemukan dokumentasi GNU resmi

Semua dokumentasi resmi GNU sudah terinstal di sistem Arch dalam format `info`. Gunakan:

```bash
info coreutils
info make
info gcc
info gdb
```

Atau lihat direktori:

```bash
ls /usr/share/info | grep gnu
```

Anda juga dapat membuka manual daring di:
🔗 [https://www.gnu.org/manual/](https://www.gnu.org/manual/)

---

## 11. Audit versi seluruh alat GNU

Gunakan skrip sederhana untuk menampilkan semua versi alat GNU sekaligus:

```bash
for tool in bash coreutils gcc gdb make binutils grep findutils sed tar gzip glibc; do
  echo "== $tool ==" && $tool --version | head -n 1
  echo
done
```

Hasilnya memberi gambaran cepat seluruh toolchain yang Anda miliki.

---

## 12. Praktik terbaik sistem berbasis GNU

1. Gunakan grup `base-devel` sebagai fondasi pembangunan sistem.
2. Hindari mencampur tool GNU dan non-GNU tanpa alasan teknis jelas.
3. Verifikasi paket inti setelah setiap pembaruan besar (`pacman -Qkk`).
4. Simpan versi toolchain stabil saat akan membangun kernel atau compiler.
5. Gunakan container atau chroot untuk uji coba toolchain eksperimental.

---

## 13. Referensi utama

* **GNU Project Manual** — [https://www.gnu.org/manual/](https://www.gnu.org/manual/)
* **ArchWiki: [Core utilities (GNU)](https://wiki.archlinux.org/title/Core_utilities_%28GNU%29)**
* **ArchWiki: [Development tools](https://wiki.archlinux.org/title/Development_tools)**
* **FSF Licensing Overview** — [https://www.gnu.org/licenses/](https://www.gnu.org/licenses/)
* **Linux From Scratch** (Chapter 5: Toolchain build validation).

---

## 14. Checklist akhir pelajar

1. Dapat mengenali alat GNU melalui `--version`.
2. Memeriksa sumber biner dengan `readelf` atau `file`.
3. Mengecek konsistensi GCC, Binutils, Glibc.
4. Menggunakan `pacman -Qkk` untuk validasi paket.
5. Memahami perbedaan alat GNU dengan non-GNU.
6. Dapat memverifikasi seluruh GNU Toolchain dalam sistem Arch.

---

Dengan ini, **seluruh dokumentasi GNU** Anda telah tuntas:

* dari **sejarah dan filosofi**,
* ke **komponen teknis**,
* hingga **integrasi dan verifikasi di sistem nyata**.
<!--
Jika Anda ingin, saya dapat membantu **menyusun versi final lengkapnya** dalam format dokumentasi profesional (misalnya Markdown `.md` atau dokumen panduan `.pdf`) dengan struktur rapi, daftar isi otomatis, dan gaya dokumentasi GNU resmi.
-->
