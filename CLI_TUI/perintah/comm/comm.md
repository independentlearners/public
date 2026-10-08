<details>
  <summary>
    <strong>📝 Deepseek</strong>
    <div style="font-size: 11px; color: grey; margin-left: 24px;"><i>Kumpulan Dokumen & Catatan</i></div>
  </summary>
  <div style="padding-left: 25px; margin-top: 8px;">

# **comm**

### 1. Perintah `comm` (Membandingkan File)

Ini adalah utilitas baris perintah standar dari paket **`coreutils`** yang sudah terpasang di sistem Arch Linux. Fungsinya adalah **membandingkan dua file yang sudah diurutkan (sorted) baris demi baris**.

**Cara kerja dasar:**
Secara default, `comm` menghasilkan output tiga kolom:
- **Kolom 1:** Baris yang hanya ada di file pertama.
- **Kolom 2:** Baris yang hanya ada di file kedua.
- **Kolom 3:** Baris yang sama di kedua file.

**Opsi yang sering digunakan:**
- `-1`: Sembunyikan kolom 1.
- `-2`: Sembunyikan kolom 2.
- `-3`: Sembunyikan kolom 3.
- `-12`: Hanya tampilkan baris yang sama di kedua file.

**Contoh penggunaan di Arch Linux:**
Perintah ini sangat berguna untuk membandingkan daftar paket. Misalnya, untuk melihat paket yang terinstal tapi tidak ada di grup `base`:
```bash
comm -23 <(pacman -Qqe | sort) <(expac -l '\n' '%E' base | sort)
```
Perintah di atas akan menampilkan paket yang secara eksplisit Anda instal (`-Qqe`) namun bukan bagian dari grup `base`.

> **Tips:** Jika Anda merasa sintaks `comm` sulit diingat, Arch Wiki menyarankan alternatif dari paket **`moreutils`** bernama **`combine`** yang memiliki sintaks lebih sederhana.

### 2. Paket `python-comm` (Untuk Jupyter)

Ini adalah paket Python yang tersedia di repositori resmi Arch Linux (`Extra`). Paket ini menyediakan implementasi **`comm` untuk protokol kernel Jupyter**. Ini adalah komponen yang memungkinkan komunikasi antara frontend (seperti Jupyter Notebook) dan kernel (proses yang menjalankan kode).

Jika Anda menggunakan Jupyter di Arch Linux dan mengalami masalah komunikasi, memastikan paket `python-comm` terinstal bisa menjadi solusinya.

### 3. Komunikasi Serial (COM Port) & Minicom

Dalam konteks perangkat keras, "COMM" sering dikaitkan dengan **port serial (COM port)**. Arch Linux dapat dikonfigurasi untuk diakses melalui **serial console**, misalnya untuk mengelola server headless (tanpa monitor/keyboard).

Untuk berkomunikasi melalui port serial, Anda bisa menggunakan program seperti **Minicom**. Minicom adalah program terminal emulator dan kontrol modem berbasis teks yang tersedia di repositori Arch Linux. Alat ini berguna untuk:
- Mengakses komputer lain melalui kabel serial (misalnya saat jaringan LAN mati).
- Berkomunikasi dengan perangkat seperti switch, router, atau Arduino.
`comm` itu untuk **membandingkan dua file yang isinya sudah diurutkan**.

  </div>
</details>

<details>
  <summary>
    <strong>📝 Deepseek</strong>
    <div style="font-size: 11px; color: grey; margin-left: 24px;"><i>Kumpulan Dokumen & Catatan</i></div>
  </summary>
  <div style="padding-left: 25px; margin-top: 8px;">

# comm

Perintah comm adalah utilitas standar dari paket coreutils yang berfungsi untuk membandingkan dua berkas teks baris demi baris. Di Arch Linux, utilitas ini telah tersedia secara bawaan tanpa perlu pemasangan tambahan.

Berbeda dengan diff yang menampilkan perubahan, comm bekerja berdasarkan prinsip himpunan seperti diagram Venn.

## 1. Prasyarat Utama: Berkas Harus Terurut
`comm` mensyaratkan kedua berkas masukan telah diurutkan secara leksikografis sesuai dengan pengaturan `LC_COLLATE`. Apabila belum terurut, hasil perbandingan tidak akan akurat.

```bash
sort file1 -o file1
sort file2 -o file2

# Atau tanpa berkas sementara dengan substitusi proses pada bash dan zsh
comm <(sort file1) <(sort file2)
```

Pada sistem Arch Linux dengan locale en_US.UTF-8, disarankan menggunakan LC_ALL=C sort untuk memastikan urutan yang konsisten dan kinerja yang lebih cepat.

## 2. Sintaks Dasar

```bash
comm [OPSI] BERKAS1 BERKAS2
```

## 3. Tiga Kolom Keluaran
Tanpa opsi tambahan, comm menghasilkan tiga kolom yang dipisahkan oleh karakter tab:

- Kolom 1: Baris yang hanya terdapat pada BERKAS1
- Kolom 2: Baris yang hanya terdapat pada BERKAS2
- Kolom 3: Baris yang terdapat pada kedua berkas

Contoh:

```
berkas1:      berkas2:
a             b
b             c
c             d
```

```bash
# Input
$ comm berkas1 berkas2
# Output
a
		b
		c
	d
```

Baris a berada pada kolom 1, d pada kolom 2, sedangkan b dan c berada pada kolom 3.

## 4. Opsi-Opsi Penting
Inti penggunaan comm adalah menyembunyikan kolom yang tidak diperlukan:

| Opsi                       |	Fungsi                                                                  |
|                        --- | ---                                                                      |
| -1                         |	Menyembunyikan kolom 1, yaitu baris unik di BERKAS1                     |
| -2	                       | Menyembunyikan kolom 2, yaitu baris unik di BERKAS2                      |
| -3	                       | Menyembunyikan kolom 3, yaitu baris yang sama                            |
| -12                        | 	Menampilkan hanya irisan, baris yang ada di kedua berkas                |
| -23	                       | Menampilkan hanya baris yang ada di BERKAS1                              |
| -13	                       | Menampilkan hanya baris yang ada di BERKAS2                              |
| -i	                       | Mengabaikan perbedaan huruf besar dan huruf kecil                        |
| --check-order	             | Memeriksa apakah masukan telah terurut, dan menampilkan galat jika belum |
| --nocheck-order	           | Tidak memeriksa urutan berkas                                            |
| --output-delimiter=STRING	 | Mengganti pemisah tab dengan string tertentu                             |
| -z, --zero-terminated	     | Menggunakan karakter NUL sebagai pemisah baris                           |


### Rumus yang umum digunakan:

 - Untuk irisan: comm -12 BERKAS1 BERKAS2
 - Untuk selisih BERKAS1 terhadap BERKAS2: comm -23 BERKAS1 BERKAS2
 - Untuk selisih BERKAS2 terhadap BERKAS1: comm -13 BERKAS1 BERKAS2

## 5. Contoh Penerapan di Arch Linux
#### a. Menampilkan paket AUR yang terpasang secara eksplisit:

```bash
comm -12 <(pacman -Qqe | sort) <(pacman -Qqm | sort)
```

#### b. Menampilkan paket eksplisit dari repositori resmi, bukan dari AUR:

```bash
comm -23 <(pacman -Qqe | sort) <(pacman -Qqm | sort)
```
#### c. Mengetahui paket baru setelah pembaruan sistem:

```bash
pacman -Qq > /tmp/sebelum.txt
# setelah menjalankan sudo pacman -Syu
pacman -Qq > /tmp/sesudah.txt
comm -13 /tmp/sebelum.txt /tmp/sesudah.txt
```
#### d. Membandingkan daftar cermin atau daftar pengguna:

```bash
comm -23 <(sort mirrorlist.lama) <(sort mirrorlist.baru)
```

#### 6. Perbedaan dengan Perintah Lain
 - diff: Digunakan untuk menunjukkan perubahan baris antar berkas.
 - comm: Digunakan untuk operasi himpunan pada baris teks.
 - join: Digunakan untuk menggabungkan dua berkas berdasarkan kolom kunci yang sama.

Untuk keakuratan, selalu gunakan sort -u terlebih dahulu apabila berkas mengandung duplikasi.
