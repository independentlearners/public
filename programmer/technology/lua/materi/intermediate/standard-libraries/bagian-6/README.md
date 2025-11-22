# [Modul 6 — Coroutine (`coroutine`)][0]

Ini adalah salah satu fitur paling unik dari Lua, karena coroutine memberi kemampuan **multitasking kooperatif** di dalam bahasa yang sederhana. Dengan coroutine, kita bisa menulis program yang seolah-olah paralel, meskipun dijalankan dalam satu thread.


details>
  <summary>📃 Daftar Isi</summary>

---

### Struktur Pembelajaran Internal (mini-TOC)

* **6.1 Pengenalan Coroutine**

  * Apa itu coroutine
  * Perbedaan dengan thread
  * Filosofi: cooperative multitasking
* **6.2 API Coroutine**

  * `coroutine.create`, `coroutine.resume`, `coroutine.yield`
  * `coroutine.status`, `coroutine.running`
  * `coroutine.wrap`
* **6.3 Studi Kasus**

  * Producer–Consumer sederhana
  * Generator angka
  * Parser ringan
* Latihan & kuiz
* Praktik terbaik & kesalahan umum
* Visualisasi

</details>

---

## 6.1 Pengenalan Coroutine

### Deskripsi & Peran

Coroutine adalah **fungsi khusus** yang dapat dijeda (`yield`) dan dilanjutkan kembali (`resume`).
Berbeda dengan fungsi biasa, coroutine tidak hanya *return* sekali, tetapi bisa **berhenti sementara** lalu **melanjutkan dari titik terakhir**.

Peran:

* Membuat generator (iterasi step-by-step).
* Simulasi multitasking ringan.
* Implementasi parser atau state machine.

### Filosofi

* **Cooperative multitasking:** coroutine hanya berpindah ketika ia sendiri memutuskan (`yield`), tidak seperti thread yang dipaksa oleh OS.
* Desain sederhana & portable: tidak ada preemptive scheduling, semua kendali ada di programmer.

---

## 6.2 API Coroutine

### Membuat coroutine

```lua
local co = coroutine.create(function()
  for i = 1, 3 do
    print("Coroutine loop", i)
    coroutine.yield()  -- jeda
  end
end)
```

👉 `coroutine.create(fn)` membuat coroutine baru dari fungsi `fn`.

---

### Menjalankan coroutine

```lua
print(coroutine.status(co))       -- "suspended"
coroutine.resume(co)              -- jalankan sampai yield
print(coroutine.status(co))       -- "suspended"
coroutine.resume(co)              -- lanjutkan lagi
coroutine.resume(co)              -- lanjutkan lagi
print(coroutine.status(co))       -- "dead"
```

👉 `resume` melanjutkan coroutine sampai `yield` atau selesai.
👉 `status` bisa: `"suspended"`, `"running"`, `"dead"`.

---

### Mengembalikan nilai

```lua
local co = coroutine.create(function(a, b)
  coroutine.yield(a + b)
  return a * b
end)

local ok, result = coroutine.resume(co, 2, 3)
print(result)    -- 5 (hasil yield)
ok, result = coroutine.resume(co)
print(result)    -- 6 (hasil return)
```

---

### `coroutine.wrap`

```lua
local f = coroutine.wrap(function()
  for i = 1, 3 do
    coroutine.yield(i)
  end
end)

print(f())   -- 1
print(f())   -- 2
print(f())   -- 3
print(f())   -- nil (sudah selesai)
```

👉 `wrap` membuat fungsi yang otomatis `resume` saat dipanggil.

---

### `coroutine.running`

```lua
local co = coroutine.create(function()
  print("Sedang jalan:", coroutine.running())
end)
coroutine.resume(co)
```

👉 Memberi tahu coroutine mana yang sedang aktif.

---

## 6.3 Studi Kasus

### 1. Generator Angka

```lua
function number_gen(n)
  return coroutine.wrap(function()
    for i = 1, n do
      coroutine.yield(i)
    end
  end)
end

local g = number_gen(5)
for i = 1, 5 do
  print(g())  -- 1,2,3,4,5
end
```

---

### 2. Producer–Consumer

```lua
local producer = coroutine.create(function()
  for i = 1, 5 do
    coroutine.yield("Data-" .. i)
  end
end)

local function consumer(prod)
  while true do
    local ok, data = coroutine.resume(prod)
    if not ok or not data then break end
    print("Konsumsi:", data)
  end
end

consumer(producer)
```

👉 Producer menghasilkan data, consumer mengonsumsi.

---

### 3. Parser ringan

```lua
local function word_parser(text)
  return coroutine.wrap(function()
    for w in text:gmatch("%w+") do
      coroutine.yield(w)
    end
  end)
end

for w in word_parser("Halo dunia luas") do
  print("Kata:", w)
end
```

---

## Visualisasi (ASCII Diagram)

```
┌──────────────┐
│ coroutine    │
│ create(fn)   │
└─────┬────────┘
      │ resume()
      ▼
 ┌──────────────┐
 │   Fungsi     │
 │   (jalan)    │
 └─────┬────────┘
       │ yield()
       ▼
 ┌──────────────┐
 │ Status:      │
 │ suspended    │
 └──────────────┘
```

---

## Praktik Terbaik

* Gunakan coroutine untuk **flow kontrol**, bukan sebagai pengganti thread OS.
* Gunakan `wrap` untuk generator agar kode lebih rapi.
* Hindari `yield` di luar coroutine (akan error).
* Gunakan `status` untuk debugging state coroutine.

---

## Kesalahan Umum & Solusi

* **Panggil `yield` di fungsi biasa** → error: hanya boleh di coroutine.
* **Resume coroutine mati (`dead`)** → error, pastikan cek `status`.
* **Mengira coroutine paralel** → sebenarnya sequential, hanya *cooperative*.

---

## Latihan & Kuiz

1. Buat generator yang menghasilkan **bilangan genap** dari 2 sampai N.
2. Implementasikan coroutine yang membaca string lalu `yield` setiap kata.
3. Apa hasil `coroutine.status(co)` setelah coroutine selesai? (jawaban: `"dead"`).

---

## Hubungan dengan Modul Lain

* **Modul 3 (Table):** coroutine sering dipakai untuk membuat iterator yang mengisi table.
* **Modul 5 (I/O):** bisa dipakai untuk membaca file besar baris demi baris (streaming).
* **Modul 10 (Debug):** debugging coroutine penting karena state bisa “menggantung”.

---

## Referensi

* Lua 5.4 Reference Manual — [Coroutine Library](https://www.lua.org/manual/5.4/manual.html#6.2)
* Programming in Lua (Roberto Ierusalimschy) — Bab 9: Coroutine
* Lua-users wiki — [Coroutines Tutorial](http://lua-users.org/wiki/CoroutinesTutorial)

---

Mari kita buat **Mini-Project berbasis Coroutine: Pipeline Pemrosesan Data (Producer → Filter → Consumer)**. Proyek ini akan memperlihatkan bagaimana coroutine bisa digunakan untuk mengalirkan data tahap demi tahap, seolah-olah ada “jalur produksi” yang kooperatif.

---

# Mini-Project: Pipeline Pemrosesan Data dengan Coroutine

### Tujuan

* Mempraktikkan penggunaan **coroutine.create, coroutine.resume, coroutine.yield**.
* Membuat arsitektur **pipeline** sederhana: data mengalir dari **producer**, diproses oleh **filter**, lalu dikonsumsi oleh **consumer**.
* Melihat bagaimana coroutine memungkinkan kontrol aliran data tanpa thread paralel.

---

## Deskripsi Proyek

* **Producer**: menghasilkan angka 1–10.
* **Filter**: hanya melewatkan angka genap.
* **Consumer**: menampilkan hasil akhir.

---

## Implementasi Kode

```lua
-- pipeline.lua
-- Pipeline Producer → Filter → Consumer

-- producer: menghasilkan angka 1 sampai n
local function producer(n)
  return coroutine.create(function()
    for i = 1, n do
      coroutine.yield(i)
    end
  end)
end

-- filter: hanya melewatkan angka genap
local function filter(prod)
  return coroutine.create(function()
    while true do
      local ok, val = coroutine.resume(prod)
      if not ok or not val then break end
      if val % 2 == 0 then
        coroutine.yield(val)
      end
    end
  end)
end

-- consumer: membaca data dan menampilkan
local function consumer(filt)
  while true do
    local ok, val = coroutine.resume(filt)
    if not ok or not val then break end
    print("Konsumsi:", val)
  end
end

-- Jalankan pipeline
local p = producer(10)
local f = filter(p)
consumer(f)
```

---

## Output Contoh

```
Konsumsi: 2
Konsumsi: 4
Konsumsi: 6
Konsumsi: 8
Konsumsi: 10
```

---

## Penjelasan Kode

1. **Producer**

   * Coroutine yang `yield` angka satu per satu.
   * Tidak sekaligus mengembalikan semua data, tapi memberi satu nilai setiap kali di-*resume*.

2. **Filter**

   * Menerima data dari producer.
   * Mengecek apakah genap, jika iya → `yield` ke tahap berikutnya.

3. **Consumer**

   * Men-*resume* filter sampai habis.
   * Mencetak hasil ke layar.

4. **Pipeline berjalan**:

   * Consumer memanggil filter → filter memanggil producer → data mengalir → hasil dicetak.

---

## Visualisasi Pipeline (ASCII Diagram)

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  Producer    │    │   Filter     │    │  Consumer    │
│  (1..10)     │───►│ hanya genap  │───►│ print hasil  │
└──────────────┘    └──────────────┘    └──────────────┘

Alur eksekusi: consumer → resume(filter) → resume(producer)
```

---

## Latihan Tambahan

1. Modifikasi filter agar hanya melewatkan **bilangan prima**.
2. Tambahkan tahap **transformasi** yang mengkuadratkan angka sebelum dikonsumsi.
3. Ubah producer agar membaca angka dari file (`io.lines`) lalu mengalirkannya ke filter.

---

## Praktik Terbaik

* Gunakan coroutine untuk pipeline data yang **sekuensial** dan **berulang**, bukan untuk pekerjaan berat paralel.
* Pecah fungsi menjadi producer–filter–consumer agar kode modular dan mudah diuji.
* Gunakan `wrap` jika ingin pipeline lebih sederhana tanpa `resume` manual.

---

Dengan mini-project ini, Anda sudah melihat **coroutine sebagai generator & pipeline**.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-7/README.md

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
