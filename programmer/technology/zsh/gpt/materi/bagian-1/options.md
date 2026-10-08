Perintah `echo $-` digunakan untuk menampilkan status opsi aktif pada shell session saat ini.

Perintah ini terdiri dari dua bagian:

**1. `echo`**
Perintah untuk mencetak argumen ke standard output.

**2. `$-`**
Parameter khusus shell. Bukan variabel lingkungan biasa. Nilainya adalah gabungan huruf yang merepresentasikan flag opsi yang sedang aktif. Nilai ini diatur saat shell dijalankan, melalui perintah builtin `set`, atau diatur secara otomatis oleh shell itu sendiri. Parameter ini bersifat read-only.

### Makna Output

Ketika Anda menjalankan:

```bash
echo $-
```

Output yang umum adalah:

```
himBH
```

Setiap huruf memiliki arti spesifik sesuai spesifikasi POSIX dan ekstensi Bash:

| Flag | Opsi | Penjelasan |
| --- | --- | --- |
| **i** | interactive | Shell berjalan dalam mode interaktif. Ini adalah penanda paling penting. |
| **H** | histexpand | Ekspansi history dengan karakter `!` aktif. |
| **B** | braceexpand | Ekspansi kurung kurawal `{a,b,c}` aktif. |
| **h** | hashall | Shell melakukan hash terhadap lokasi executable untuk mempercepat pencarian perintah. |
| **m** | monitor | Job control aktif. Memungkinkan penggunaan `fg`, `bg`, dan eksekusi background dengan `&`. |

Flag tambahan akan muncul jika Anda mengaktifkan opsi lain:

* **e**: `errexit`, aktif setelah `set -e`. Shell akan berhenti jika sebuah perintah gagal.
* **x**: `xtrace`, aktif setelah `set -x`. Shell akan menampilkan setiap perintah sebelum dieksekusi, berguna untuk debugging.
* **a**: `allexport`, aktif setelah `set -a`.

Contoh perubahan:

```bash
echo $-      # Output: himBH
set -e
echo $-      # Output: ehimBH -> flag e bertambah
```

### Kegunaan Praktis

Kegunaan utama `$-` adalah untuk deteksi konteks shell di dalam skrip, terutama untuk membedakan shell interaktif dan non-interaktif.

Pola yang standar digunakan di file konfigurasi seperti `.bashrc`:

```bash
case $- in
  *i*) echo "Shell interaktif: load alias dan prompt" ;;
  *) return ;;
esac
```

Atau dengan conditional modern:

```bash
if [[ $- == *i* ]]; then
  # Perintah hanya dijalankan jika sesi bersifat interaktif
fi
```

Hal ini mencegah perintah yang seharusnya hanya untuk interaksi pengguna dijalankan saat mengeksekusi skrip shell.

Secara ringkas, `echo $-` adalah metode diagnostik untuk mengetahui opsi dan mode apa yang sedang aktif pada instance shell Anda.
