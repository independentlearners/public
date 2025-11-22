# [Modul 5 — I/O Library (`io`)][0]

Modul ini sangat penting karena di sinilah Lua berinteraksi dengan **file system** (membaca/menulis file), yang merupakan pondasi dari banyak aplikasi nyata.

---

<details>
  <summary>📃 Daftar Isi</summary>

### Struktur Pembelajaran Internal (mini-TOC)

* **5.1 Pengenalan I/O di Lua**

  * Konsep stream (stdin, stdout, stderr)
  * Filosofi: file handle sederhana, berbasis C stdio
* **5.2 Mode I/O**

  * Simple mode (`io.read`, `io.write`)
  * Safe mode (open file, handle, close)
* **5.3 Membaca File**

  * `io.open`, `:read`, `:lines`
  * Membaca seluruh file sekaligus
* **5.4 Menulis File**

  * `:write`, `io.output`, mode append/overwrite
* **5.5 Studi Kasus**

  * Menyimpan hasil simulasi dadu ke file
  * Membaca file konfigurasi sederhana
* Latihan & kuiz
* Praktik terbaik & kesalahan umum
* Visualisasi

</details>

---

## 5.1 Pengenalan I/O di Lua

### Deskripsi & Peran

I/O (Input/Output) library adalah pintu Lua untuk berkomunikasi dengan dunia luar: membaca data dari keyboard, file, atau menulis output ke file/log.

Lua menyediakan dua pendekatan:

1. **Simple mode:** fungsi global (`io.read`, `io.write`) → cepat digunakan.
2. **Handle-based mode:** bekerja dengan objek file (`io.open`, `file:read`, `file:close`) → lebih fleksibel & aman.

### Filosofi

* Lua membungkus fungsi **C stdio (fopen, fread, fwrite)** agar sederhana & portabel.
* Desainnya minimal, tapi cukup kuat untuk kebutuhan scripting dan embedding.

### Konsep Stream

* **stdin:** input standar (keyboard)
* **stdout:** output standar (terminal)
* **stderr:** output error standar

---

## 5.2 Mode I/O

### Simple mode

```lua
-- membaca input dari user
io.write("Masukkan nama: ")
local name = io.read()   -- baca 1 baris
print("Halo,", name)
```

### Handle-based mode

```lua
-- buka file untuk dibaca
local file = io.open("data.txt", "r")
if file then
  local content = file:read("*all")
  print(content)
  file:close()
end
```

Mode open (`io.open(filename, mode)`):

* `"r"` → read (baca saja)
* `"w"` → write (buat baru, hapus isi lama)
* `"a"` → append (tambah di akhir)
* `"r+"` → read/write tanpa hapus isi
* `"w+"` → write/read (overwrite)
* `"a+"` → append/read

---

## 5.3 Membaca File

### Baca seluruh isi

```lua
local file = io.open("hello.txt", "r")
local content = file:read("*all")
file:close()
print(content)
```

### Baca baris demi baris

```lua
local file = io.open("hello.txt", "r")
for line in file:lines() do
  print(line)
end
file:close()
```

### Baca sebagian (karakter/byte)

```lua
local file = io.open("hello.txt", "r")
local part = file:read(5)  -- baca 5 karakter pertama
print(part)
file:close()
```

---

## 5.4 Menulis File

### Menimpa file

```lua
local file = io.open("out.txt", "w")
file:write("Halo Dunia\n")
file:close()
```

### Append

```lua
local file = io.open("out.txt", "a")
file:write("Baris baru\n")
file:close()
```

### Output default

```lua
io.output("log.txt")     -- set output default
io.write("Pesan log\n")  -- ditulis ke log.txt
```

---

## 5.5 Studi Kasus

### Menyimpan hasil simulasi dadu (lanjutan mini-project)

```lua
math.randomseed(os.time())
local N = 100
local counts = {1=0,2=0,3=0,4=0,5=0,6=0}

for i=1,N do
  local roll = math.random(1,6)
  counts[roll] = counts[roll] + 1
end

-- simpan hasil ke file
local file = io.open("hasil_dadu.txt", "w")
file:write("Hasil Simulasi Lempar Dadu ("..N.." kali)\n")
file:write("--------------------------------------\n")
for face=1,6 do
  local freq = counts[face]
  local percent = (freq/N)*100
  file:write(string.format("Angka %d: %d kali (%.2f%%)\n", face, freq, percent))
end
file:close()
```

Output `hasil_dadu.txt`:

```
Hasil Simulasi Lempar Dadu (100 kali)
--------------------------------------
Angka 1: 20 kali (20.00%)
Angka 2: 18 kali (18.00%)
...
```

### Membaca file konfigurasi sederhana

```lua
-- config.txt
-- mode=dev
-- level=3

local config = {}
for line in io.lines("config.txt") do
  local key, val = line:match("(%w+)=(%w+)")
  if key and val then
    config[key] = val
  end
end

print("Mode:", config.mode)
print("Level:", config.level)
```

---

## Visualisasi (ASCII Diagram)

```
┌───────────────────────────────┐
│           IO Library          │
│ ┌────────────┬──────────────┐ │
│ │ Simple I/O │ File Handle  │ │
│ │ io.read    │ io.open      │ │
│ │ io.write   │ file:read    │ │
│ │            │ file:write   │ │
│ │            │ file:close   │ │
│ └────────────┴──────────────┘ │
│ stdin / stdout / stderr        │
└───────────────────────────────┘
```

---

## Praktik Terbaik

* Selalu **tutup file** setelah selesai (`file:close()`) agar resource tidak bocor.
* Gunakan **handle-based mode** untuk kontrol lebih baik daripada simple mode.
* Gunakan `io.lines` untuk file besar (streaming), jangan `*all` jika file >1GB.
* Gunakan `pcall` atau `if not file then ... end` untuk handle error saat open file.

---

## Kesalahan Umum & Solusi

* **Lupa menutup file** → data tidak tersimpan dengan benar.
* **Mode salah** (`"r"` saat ingin menulis) → error `file not open for writing`.
* **Asumsi path file** → gunakan path absolut jika tidak yakin working directory.
* **Membaca seluruh isi file besar** dengan `*all` → out of memory, gunakan streaming.

---

## Latihan & Kuiz

1. Buat program yang meminta input nama pengguna, lalu simpan ke file `users.txt`.
2. Tambahkan program untuk membaca kembali file `users.txt` dan menampilkan semua nama.
3. Apa yang terjadi jika membuka file dengan mode `"w"` pada file yang sudah ada? (jawaban: file di-*overwrite* / isi lama hilang).

---

## Hubungan dengan Modul Lain

* **Modul 3 (Table):** hasil parsing file biasanya disimpan dalam table.
* **Modul 4 (Math):** output hasil perhitungan sering ditulis ke file log.
* **Modul 11 (OS):** sering dipakai bersamaan (misalnya `os.date` untuk timestamp di file log).
* **Modul 14 (C API):** saat embedding, I/O bisa diarahkan ulang dari host application.

---

## Referensi

* Lua 5.4 Reference Manual — [I/O Library](https://www.lua.org/manual/5.4/manual.html#6.8)
* Programming in Lua — Bab 21: Input and Output
* Lua-users wiki — [File Input/Output](http://lua-users.org/wiki/FileInputOutput)

---

Kita sudah menyelesaikan Modul 5 (I/O) dengan format penuh, plus studi kasus integrasi dengan **mini-project simulasi dadu**. Sebelum masuk ke **Modul 6 (Coroutine)**, mari kita buat **Mini-Project berbasis I/O: Catatan Harian Sederhana**. Proyek ini akan memanfaatkan semua konsep dari **Modul 5 (I/O)**, serta mempraktikkan **string**, **table**, dan **math** bila diperlukan.

---

# Mini-Project: Program Catatan Harian Sederhana

### Tujuan

* Melatih penggunaan **I/O Library** (`io.open`, `io.write`, `io.read`, `io.lines`).
* Menggunakan **string.format** untuk mencatat tanggal dan waktu.
* Mengelola catatan dalam file teks yang terus bertambah (append).

---

## Deskripsi Proyek

Program ini memungkinkan pengguna:

1. Menulis catatan harian baru.
2. Melihat semua catatan yang sudah disimpan.
3. Keluar dari program.

Semua catatan akan disimpan di file teks `diary.txt`.

---

## Implementasi Kode

```lua
-- diary.lua
-- Program Catatan Harian Sederhana

-- fungsi untuk menulis catatan baru
local function write_entry()
  io.write("Tulis catatan Anda: ")
  local entry = io.read("*l")  -- baca 1 baris dari input
  local timestamp = os.date("%Y-%m-%d %H:%M:%S")

  local file = io.open("diary.txt", "a")
  file:write(string.format("[%s] %s\n", timestamp, entry))
  file:close()

  print("Catatan berhasil disimpan!\n")
end

-- fungsi untuk membaca semua catatan
local function read_entries()
  local file = io.open("diary.txt", "r")
  if not file then
    print("Belum ada catatan.\n")
    return
  end

  print("==== Semua Catatan Harian ====")
  for line in file:lines() do
    print(line)
  end
  file:close()
  print("==============================\n")
end

-- menu utama
while true do
  print("=== Catatan Harian ===")
  print("1. Tulis Catatan Baru")
  print("2. Lihat Semua Catatan")
  print("3. Keluar")
  io.write("Pilih (1/2/3): ")
  local choice = io.read()

  if choice == "1" then
    write_entry()
  elseif choice == "2" then
    read_entries()
  elseif choice == "3" then
    print("Sampai jumpa!")
    break
  else
    print("Pilihan tidak valid.\n")
  end
end
```

---

## Contoh Jalannya Program

```
=== Catatan Harian ===
1. Tulis Catatan Baru
2. Lihat Semua Catatan
3. Keluar
Pilih (1/2/3): 1
Tulis catatan Anda: Hari ini belajar Lua modul I/O
Catatan berhasil disimpan!

=== Catatan Harian ===
1. Tulis Catatan Baru
2. Lihat Semua Catatan
3. Keluar
Pilih (1/2/3): 2
==== Semua Catatan Harian ====
[2025-09-10 13:25:42] Hari ini belajar Lua modul I/O
==============================
```

---

## Visualisasi (ASCII Diagram)

```
┌───────────────────────────────┐
│        Menu Utama             │
│ (input pilihan user)          │
└──────────────┬────────────────┘
               │
   ┌───────────┴───────────┐
   ▼                       ▼
[Tulis Entry]         [Baca Entry]
   │                       │
   ▼                       ▼
┌─────────────┐      ┌─────────────┐
│ io.open("a")│      │ io.open("r")│
│ tulis entry │      │ baca line   │
│ timestamp   │      │ tampilkan   │
└─────────────┘      └─────────────┘
```

---

Mari kita bedah **setiap baris kode pada mini-project "Catatan Harian Sederhana"** agar siapapun — bahkan yang benar-benar baru — bisa memahami maksud, fungsi, dan kegunaan dari setiap bagian program.

---

# Penjelasan Lengkap Program `diary.lua`

```lua
-- diary.lua
-- Program Catatan Harian Sederhana
```

👉 Komentar (ditandai `--`) hanya untuk manusia, tidak dijalankan oleh komputer.
Baris ini menjelaskan nama file dan tujuan program: **membuat catatan harian**.

---

## Fungsi Menulis Catatan

```lua
local function write_entry()
  io.write("Tulis catatan Anda: ")
  local entry = io.read("*l")  -- baca 1 baris dari input
  local timestamp = os.date("%Y-%m-%d %H:%M:%S")
```

* `local function write_entry()` → mendefinisikan sebuah fungsi lokal bernama `write_entry`. Fungsi ini dipanggil setiap kali pengguna ingin menulis catatan baru.
* `io.write("Tulis catatan Anda: ")` → menampilkan teks ke layar **tanpa baris baru** (beda dengan `print`). Digunakan sebagai **prompt** agar user tahu apa yang harus diketik.
* `local entry = io.read("*l")` → membaca **satu baris teks** yang diketik user di keyboard (input standar). Opsi `"*l"` berarti *read line*.
* `local timestamp = os.date("%Y-%m-%d %H:%M:%S")` → memanggil fungsi `os.date` untuk membuat cap waktu (timestamp) dalam format: `YYYY-MM-DD HH:MM:SS`. Contoh: `2025-09-10 13:25:42`.

---

```lua
  local file = io.open("diary.txt", "a")
  file:write(string.format("[%s] %s\n", timestamp, entry))
  file:close()
```

* `io.open("diary.txt", "a")` → membuka (atau membuat) file `diary.txt` dalam mode `"a"` (append). Mode ini **menambah teks di akhir file** tanpa menghapus catatan lama.
* `file:write(...)` → menulis teks ke dalam file.

  * `string.format("[%s] %s\n", timestamp, entry)` → menyusun teks dengan format: `[timestamp] isi_catatan`. Contoh:

    ```
    [2025-09-10 13:25:42] Hari ini belajar Lua modul I/O
    ```
* `file:close()` → menutup file agar data tersimpan dengan benar. Jika tidak ditutup, ada risiko isi file tidak ditulis penuh (buffer belum flush).

---

```lua
  print("Catatan berhasil disimpan!\n")
end
```

* `print("Catatan berhasil disimpan!\n")` → menampilkan pesan konfirmasi ke layar, memberi tahu user bahwa catatan berhasil disimpan.
* `end` → menutup definisi fungsi `write_entry`.

---

## Fungsi Membaca Catatan

```lua
local function read_entries()
  local file = io.open("diary.txt", "r")
  if not file then
    print("Belum ada catatan.\n")
    return
  end
```

* `local function read_entries()` → fungsi untuk menampilkan semua catatan yang sudah ada.
* `io.open("diary.txt", "r")` → membuka file `diary.txt` dalam mode `"r"` (read = baca).
* `if not file then` → jika file tidak ditemukan (belum ada catatan sama sekali), tampilkan pesan `"Belum ada catatan."` lalu `return` (keluar dari fungsi).

---

```lua
  print("==== Semua Catatan Harian ====")
  for line in file:lines() do
    print(line)
  end
  file:close()
  print("==============================\n")
end
```

* `print("==== Semua Catatan Harian ====")` → menampilkan header sebelum daftar catatan.
* `for line in file:lines() do` → perulangan yang membaca file baris demi baris.

  * `line` → setiap kali loop, variabel ini berisi satu baris dari file.
  * `print(line)` → menampilkan baris itu ke layar.
* `file:close()` → menutup file setelah selesai dibaca.
* `print("==============================\n")` → menutup tampilan catatan dengan garis pembatas.
* `end` → menutup definisi fungsi `read_entries`.

---

## Menu Utama (Loop Program)

```lua
while true do
  print("=== Catatan Harian ===")
  print("1. Tulis Catatan Baru")
  print("2. Lihat Semua Catatan")
  print("3. Keluar")
  io.write("Pilih (1/2/3): ")
  local choice = io.read()
```

* `while true do` → perulangan **infinite loop** (akan terus berjalan sampai kita `break`).
* `print(...)` → menampilkan menu utama.
* `io.write("Pilih (1/2/3): ")` → prompt agar user memilih menu.
* `local choice = io.read()` → membaca input user (string).

---

```lua
  if choice == "1" then
    write_entry()
  elseif choice == "2" then
    read_entries()
  elseif choice == "3" then
    print("Sampai jumpa!")
    break
  else
    print("Pilihan tidak valid.\n")
  end
end
```

* `if choice == "1"` → jika user mengetik `1`, panggil fungsi `write_entry()`.
* `elseif choice == "2"` → jika user mengetik `2`, panggil `read_entries()`.
* `elseif choice == "3"` → jika user mengetik `3`, tampilkan pesan `"Sampai jumpa!"` lalu `break` (keluar dari loop → program selesai).
* `else` → jika user mengetik selain 1/2/3, tampilkan `"Pilihan tidak valid."`.
* `end` → menutup blok `if`.
* `end` (paling akhir) → menutup blok `while`.

---

# Ringkasan Alur Program

1. **Menu utama** ditampilkan berulang (loop).
2. **Pilihan user:**

   * 1 → input catatan → simpan ke file.
   * 2 → baca & tampilkan isi file.
   * 3 → keluar program.
   * selain itu → error input.
3. Program terus berulang sampai user memilih keluar.

---

# Visualisasi Alur

```
┌─────────────┐
│ Menu Utama  │
└─────┬───────┘
      │
      ▼
┌───────────────┐
│ Input pilihan │
└───┬───┬───┬───┘
    │   │   │
    │   │   │
   1│  2│  3│
    │   │   │
    ▼   ▼   ▼
 [Write] [Read] [Exit]
```

---

Dengan penjelasan ini, setiap baris kode sudah jelas **fungsi dan kegunaannya**.
Program ini memang sederhana, tapi sudah memuat konsep inti: **input/output, fungsi, loop, kondisi, string formatting, file handling**.

## Latihan Tambahan

1. Tambahkan opsi untuk mencari catatan berdasarkan kata kunci (misalnya: "belajar").
2. Tambahkan fitur untuk menghapus seluruh catatan dengan konfirmasi.
3. Simpan catatan dengan format JSON sederhana agar lebih terstruktur.

---

## Praktik Terbaik

* Gunakan **append mode `"a"`** agar catatan lama tidak hilang.
* Selalu simpan **timestamp** untuk kronologi.
* Pastikan menutup file setelah operasi agar data aman.
* Untuk aplikasi nyata, gunakan format data yang lebih kokoh (JSON/YAML) dengan library tambahan.

---

## Kesalahan Umum

* Membuka file dengan `"w"` → semua catatan lama hilang.
* Membaca file tanpa cek apakah file ada → gunakan `if not file then ...`.
* Menyimpan catatan tanpa timestamp → sulit melacak kronologi.

---

Dengan proyek ini, Anda sudah berlatih **membaca & menulis file**, serta mulai menyusun program **berbasis menu interaktif**.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

<!----------------------------------------------------->

[0]: ../README.md
[1]: ../
[2]: ../
[3]: ../
[4]: ../
[5]: ../
[6]: ../
[7]: ../
[8]: ../
[9]: ../
[10]: ../
[11]: ../
[12]: ../
[13]: ../
[14]: ../
[15]: ../
[16]: ../
[17]: ../
[18]: ../
