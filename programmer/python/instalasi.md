# Python

### Panduan Instalasi Python

_**spesifikasi sistem yang diperlukan**_

> - **Sistem Operasi**: Windows 10 (64-bit).
> - **RAM**: Minimal 1 GB, tetapi disarankan minimal 2 GB atau lebih untuk perform
>   Hai! Saya di sini untuk membantu Anda menginstal Python di komputer Windows 10 Anda. Mari kita lakukan langkah demi langkah:

### 1. Unduh Python:

1. Buka [halaman unduh Python](https://www.python.org/downloads/ "python.org") di peramban web Anda.
2. Di halaman tersebut, pilih versi Python yang ingin Anda unduh (misalnya, Python 3.10.4), dan klik tautan unduhan untuk sistem operasi Windows.

### 2. Jalankan Installer:

1. Setelah unduhan selesai, buka file installer yang telah Anda unduh.
2. Pada jendela instalasi, pastikan untuk mencentang opsi "Add Python to PATH" sebelum mengklik tombol "Install Now". Ini akan memastikan Python dan `pip` dapat diakses dari terminal Anda.
3. Ikuti petunjuk instalasi hingga selesai.

### 3. Verifikasi Instalasi via Terminal:

1. Buka Terminal atau Command Prompt (cmd).
2. Ketik perintah berikut untuk memverifikasi bahwa Python telah diinstal:
   ```cmd
   python --version
   ```
   Jika instalasi berhasil, Anda akan melihat nomor versi Python yang terpasang.

### 4. Instal `pip` jika Diperlukan:

1. `pip` biasanya diinstal bersamaan dengan Python, namun jika belum terpasang, Anda bisa menjalankan perintah berikut di command prompt:
   ```cmd
   python -m ensurepip --default-pip
   ```
