# Perbandingan Penanganan Array dan Pengindeksan

## Mengapa Ini Penting

Saat berpindah dari Bash ke Zsh atau membuat fungsi kustom shell, pemahaman tentang **penanganan array dan pengindeksan** sangat krusial. Perbedaan mendasar di mana Zsh secara bawaan menggunakan pengindeksan *1-based* sedangkan Bash menggunakan *0-based* sering menjadi penyebab utama bug logika pada skrip lintas shell.

## Konsep Utama

### Indeksasi Basis 1 pada Zsh vs Basis 0 pada Bash

Sebagian besar bahasa pemrograman dan Bash shell memulai indeks elemen pertama array dari `0`. Namun, Zsh secara bawaan menggunakan konvensi basis `1` untuk menyelaraskan pengindeksan dengan hitungan posisi alami.

* **Bash (0-based):** `${array[0]}` merujuk pada elemen pertama.
* **Zsh (1-based):** `${array[1]}` merujuk pada elemen pertama, sedangkan `${array[0]}` pada Zsh secara bawaan tidak mengembalikan elemen pertama.

### Sintaks Pengirisan dan Manipulasi Elemen

Selain lokasi indeks pertama, sintaks pengirisan (*slicing*) atau pengambilan rentang elemen juga memiliki pendekatan berbeda antara kedua shell tersebut.

* **Sintaks Zsh:** Zsh mendukung sintaks rentang langsung `$array[awal,akhir]`. Contohnya `$array[1,3]` untuk mengambil elemen pertama hingga ketiga.
* **Sintaks Bash:** Bash menggunakan sintaks berbasis *offset* dan *length* `${array[@]:offset:length}`. Contohnya `${array[@]:0:3}` untuk mengambil 3 elemen mulai dari indeks 0.

## Contoh Praktis

Sekarang mari kita lihat bagaimana perbedaan pengindeksan basis 1 dan basis 0 diterapkan langsung dalam perintah shell melalui perbandingan sintaks antara Zsh dan Bash.

**Contoh 1: Mengakses Elemen Pertama Array**
Mendeklarasikan array `buah=(apel pisang jeruk)` dan mengakses elemen pertamanya.

1. **Deklarasikan Array:**
Jalankan perintah berikut di terminal:
`buah=(apel pisang jeruk)`


2. **Akses Elemen pada Bash:**
Eksekusi pada Bash menggunakan indeks 0:
`echo ${buah[0]}`
Hasil output: `apel`


3. **Akses Elemen pada Zsh:**
Eksekusi pada Zsh menggunakan indeks 1:
`echo $buah[1]`
Hasil output: `apel`


**Contoh 2: Mengambil Rentang Elemen (Slicing)**
Mengambil dua elemen pertama (`apel` dan `pisang`) dari array `buah`.

1. **Pengirisan pada Bash:**
Gunakan indeks offset `0` dan panjang `2`:
`echo ${buah[@]:0:2}`


2. **Pengirisan pada Zsh:**
Gunakan rentang indeks dari `1` sampai `2`:
`echo $buah[1,2]`

Setiap perbedaan kecil pada sintaks shell sangat mempengaruhi kompatibilitas skrip. Anda dapat mendalami cara mengubah perilaku bawaan Zsh atau mempelajari fitur manipulasi variabel tingkat lanjut.
