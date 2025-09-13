# **Proyek Mini 1 – Kalkulator Interaktif di Terminal**

---

## 1. Tujuan Proyek

Proyek ini melatih pemahaman materi dari **Fondasi Dasar Lua**, **Tipe Data dan Variabel**, **Operator dan Kontrol Flow**, ditambah pengenalan kecil tentang **Input/Output**.
Anda akan belajar:

* Membaca input pengguna lewat terminal.
* Menggunakan operator aritmatika dan logika untuk membuat keputusan.
* Mengontrol alur program dengan `if-elseif-else`, `while`, dan `break`.
* Memahami alasan di balik setiap kode yang digunakan.

---

## 2. Ringkasan Input/Output (Pengantar)

Sebelum masuk ke proyek, pahami dua hal sederhana:

* **`print(...)`** → menampilkan teks atau nilai ke layar.

  ```lua
  print("Halo, dunia!")
  print("Hasil:", 2 + 3)
  ```

* **`io.read()`** → membaca input dari pengguna.

  ```lua
  print("Masukkan nama:")
  local nama = io.read()
  print("Halo,", nama)
  ```

* **`tonumber(io.read())`** → mengubah input string menjadi angka.

  ```lua
  print("Masukkan angka:")
  local angka = tonumber(io.read())
  print("Dua kali angka =", angka * 2)
  ```

📌 Ini cukup untuk proyek mini. Materi I/O lebih lengkap tersedia di bab tersendiri.

---

## 3. Alur Program dan Alasan Desain

1. **Loop utama dengan `while true do ... end`**
   Dipakai agar program terus berulang sampai pengguna memilih keluar.
   Jika hanya `if`, program berhenti setelah satu kali jalan.

2. **Membaca input operasi dengan `io.read()`**
   Input awalnya string (`"+"`, `"-"`, dll.). Itu yang kita gunakan untuk memilih operasi.

3. **Membaca angka dengan `tonumber(io.read())`**
   Karena `io.read()` menghasilkan string, perlu konversi supaya bisa dihitung.

4. **Pemilihan operasi dengan `if-elseif-else`**
   Karena ada banyak kemungkinan (`+`, `-`, `*`, `/`).
   `elseif` memberi fleksibilitas untuk banyak kondisi.
   `else` sebagai jalur terakhir jika input tidak valid.

5. **Pengecekan `if b == 0` sebelum pembagian**
   Untuk mencegah kesalahan matematis membagi dengan nol.

6. **Pertanyaan lanjut (y/n) dan `break`**
   Setelah operasi selesai, pengguna ditanya apakah ingin melanjutkan.
   Jika jawabannya bukan `"y"`, loop dihentikan dengan `break`.
   Tanpa `break`, program tidak akan pernah berhenti.

---

## 4. Kode Program

```lua
while true do
    print("Pilih operasi (+, -, *, /):")
    local operasi = io.read()

    print("Masukkan angka pertama:")
    local a = tonumber(io.read())
    print("Masukkan angka kedua:")
    local b = tonumber(io.read())

    if operasi == "+" then
        print("Hasil:", a + b)
    elseif operasi == "-" then
        print("Hasil:", a - b)
    elseif operasi == "*" then
        print("Hasil:", a * b)
    elseif operasi == "/" then
        if b == 0 then
            print("Error: tidak bisa membagi dengan nol!")
        else
            print("Hasil:", a / b)
        end
    else
        print("Operasi tidak dikenal!")
    end

    print("\nApakah ingin lanjut? (y/n):")
    local lanjut = io.read()
    if lanjut ~= "y" then
        print("Program selesai. Terima kasih!")
        break
    end
end
```

---

## 5. Bedah Kode Lengkap

* **`while true do ... end`** → menjaga program terus berjalan.
* **`local operasi = io.read()`** → membaca simbol operasi sebagai string.
* **`tonumber(io.read())`** → mengubah input string ke number.
* **`if ... elseif ... else`** → mengatur logika pemilihan operasi.
* **`if b == 0`** → melindungi program dari pembagian dengan nol.
* **`if lanjut ~= "y" then break`** → jalan keluar dari loop utama.

---

## 6. Eksperimen Lanjutan

1. Tambahkan operasi pangkat `^`.
2. Format hasil pembagian hanya dua desimal dengan `string.format`.
3. Ubah logika keluar: pakai `lanjut == "n"` sebagai syarat berhenti.
4. Tambahkan validasi input agar program tidak error jika pengguna mengetik huruf.

---

## 7. Tantangan Mandiri

* Buat menu numerik (1–5) untuk memilih operasi, bukan simbol.
* Simpan riwayat perhitungan dalam tabel, lalu tampilkan ke pengguna.
* Tambahkan mode beruntun: hasil terakhir otomatis jadi input pertama operasi berikutnya.

---

## 8. Relevansi untuk Materi Berikutnya

* **Struktur Data** → simpan hasil operasi ke tabel.
* **Functions** → pisahkan setiap operasi ke dalam fungsi.
* **Modules** → pecah program menjadi file terorganisir.

Dengan pola ini, proyek mini menjadi pondasi untuk latihan yang lebih kompleks di bab selanjutnya.

---

## 9. Referensi

* Lua 5.1 Reference Manual – Basic Functions (`print`, `tonumber`):
  [https://www.lua.org/manual/5.1/manual.html#5.1](https://www.lua.org/manual/5.1/manual.html#5.1)
* Lua 5.1 Reference Manual – I/O Library (`io.read`, `io.write`):
  [https://www.lua.org/manual/5.1/manual.html#pdf-io.read](https://www.lua.org/manual/5.1/manual.html#pdf-io.read)
* Programming in Lua, Chapter 4 (Control Structures):
  [https://www.lua.org/pil/4.html](https://www.lua.org/pil/4.html)

---

<!--
Dengan susunan ini, pelajar sudah punya pegangan jelas: **kenapa setiap baris dipakai, bagaimana alurnya, dan apa yang bisa dieksperimenkan**.
-->
---


Apakah kamu mau saya buatkan juga **template halaman proyek mini** (semacam kerangka standar) supaya konsisten untuk proyek mini berikutnya?

