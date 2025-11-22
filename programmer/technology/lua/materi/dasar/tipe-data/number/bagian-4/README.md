# LEVEL 4: RANDOM NUMBERS & PROBABILITY

Kemampuan untuk menghasilkan angka acak sangat fundamental dalam banyak aplikasi, mulai dari game (misalnya, penempatan musuh, loot drops) hingga simulasi ilmiah dan statistik.

#### **4.1 Random Number Generation**

- **Topik**: `math.random`, `math.randomseed`.

- **Konsep Fundamental**: Komputer adalah mesin yang deterministik. Oleh karena itu, angka yang dihasilkan oleh `math.random` sebenarnya adalah **pseudorandom**. Mereka tampak acak, tetapi sebenarnya dihasilkan oleh sebuah algoritma matematika. Jika Anda memulai algoritma dengan titik awal (disebut **seed**) yang sama, Anda akan selalu mendapatkan urutan angka "acak" yang sama persis.

- **Materi dan Penjelasan**:

  - **`math.randomseed(seed)`**: Fungsi ini digunakan untuk menginisialisasi atau "menyemai" generator angka acak.

    - **Mengapa ini penting?**
      1.  **Reproducibility**: Saat melakukan debugging atau pengujian, Anda ingin perilaku acak Anda konsisten. Dengan menyemai generator dengan nilai yang sama (misalnya, `math.randomseed(123)`), Anda memastikan bahwa setiap kali program dijalankan, urutan angka acak yang dihasilkan akan identik.
      2.  **Keacakan yang Lebih Baik**: Pada beberapa sistem lama, jika Anda tidak menyemai generator, ia mungkin akan memulai dengan seed default yang sama setiap kali, menghasilkan urutan yang sama berulang kali.
    - **Praktik Umum**: Untuk mendapatkan keacakan yang tampak berbeda setiap kali program dijalankan, seed biasanya diatur menggunakan waktu saat ini.
      ```lua
      -- Atur seed berdasarkan jumlah detik sejak epoch (1 Jan 1970)
      math.randomseed(os.time())
      ```

  - **`math.random()`**: Fungsi ini memiliki tiga mode pemanggilan.

    1.  **`math.random()` (tanpa argumen)**: Menghasilkan angka float antara `0.0` dan `1.0` (inklusif).
    2.  **`math.random(n)`**: Menghasilkan integer antara `1` dan `n` (inklusif).
    3.  **`math.random(m, n)`**: Menghasilkan integer antara `m` dan `n` (inklusif).

    <!-- end list -->

    ```lua
    math.randomseed(os.time())

    -- Mode 1: Hasil lemparan koin (kurang dari 0.5 atau tidak)
    print(math.random()) -- Contoh Output: 0.81369...

    -- Mode 2: Lemparan dadu 6 sisi
    print(math.random(6)) -- Contoh Output: 4

    -- Mode 3: Angka acak antara 10 dan 20
    print(math.random(10, 20)) -- Contoh Output: 17
    ```

#### **4.2 Advanced Random Techniques**

- **Topik**: Distribusi probabilitas dan teknik sampling.
- **Materi dan Penjelasan**:

  - **Distribusi Seragam (Uniform Distribution)**: `math.random` menghasilkan angka dengan distribusi seragam, yang berarti setiap kemungkinan hasil memiliki probabilitas yang sama untuk terjadi.
  - **Distribusi Normal (Normal Distribution)**: Juga dikenal sebagai "kurva lonceng", di mana nilai di sekitar rata-rata lebih mungkin terjadi daripada nilai yang jauh. Ini tidak ada di Lua secara default, tetapi dapat diimplementasikan menggunakan **transformasi Box-Muller**.

    ```lua
    -- Implementasi sederhana Box-Muller untuk menghasilkan angka terdistribusi normal
    -- dengan rata-rata 0 dan standar deviasi 1.
    local _extra_gaussian
    function random_normal()
      if _extra_gaussian then
        local val = _extra_gaussian
        _extra_gaussian = nil
        return val
      end

      local u1, u2
      repeat
        u1 = math.random()
        u2 = math.random()
      until u1 > 1e-9 -- Hindari log(0)

      local r = math.sqrt(-2 * math.log(u1))
      local theta = 2 * math.pi * u2

      _extra_gaussian = r * math.sin(theta)
      return r * math.cos(theta)
    end

    print(random_normal()) -- Contoh Output: -0.435... (kemungkinan besar antara -3 dan 3)
    ```

  - **Seleksi Acak Berbobot (Weighted Random Selection)**: Bagaimana jika Anda ingin satu hasil lebih mungkin daripada yang lain (misalnya, 70% kemungkinan mendapatkan pedang, 30% perisai)?

    ```lua
    function weighted_choice(choices)
      local sum = 0
      for _, weight in pairs(choices) do
        sum = sum + weight
      end

      local r = math.random() * sum
      for item, weight in pairs(choices) do
        r = r - weight
        if r <= 0 then
          return item
        end
      end
    end

    local loot_table = { sword = 70, shield = 25, legendary_axe = 5 }
    print(weighted_choice(loot_table)) -- Kemungkinan besar akan mencetak "sword"
    ```

  - **Algoritma Pengacakan (Shuffle Algorithms)**: Untuk mengacak urutan elemen dalam sebuah tabel, seperti setumpuk kartu. Algoritma Fisher-Yates adalah standar emas.

    ```lua
    function shuffle(tbl)
      for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i] -- Tukar elemen
      end
      return tbl
    end

    local cards = { "A", "K", "Q", "J" }
    shuffle(cards)
    print(table.concat(cards, ", ")) -- Contoh Output: Q, A, J, K
    ```

#### **4.3 Cryptographically Secure Random**

- **Topik**: Alternatif untuk kebutuhan keamanan.
- **Materi dan Penjelasan**:
  - **Keterbatasan `math.random()`**: Karena `math.random` bersifat pseudorandom dan dapat diprediksi jika seed-nya diketahui, ia **sama sekali tidak cocok** untuk tujuan kriptografi apa pun, seperti membuat kata sandi, kunci enkripsi, atau token sesi.
  - **Menggunakan Library Eksternal**: Solusi yang tepat adalah menggunakan library yang dirancang untuk kriptografi, yang mengambil sumber keacakan dari sistem operasi (yang lebih tidak dapat diprediksi). Anda dapat menemukan ini di [LuaRocks](https://luarocks.org/search?q=crypto).
  - **Solusi Spesifik Platform**: Pada sistem mirip Unix (Linux, macOS), Anda dapat membaca dari file perangkat khusus `/dev/urandom` untuk mendapatkan byte acak yang kuat secara kriptografis. Ini memerlukan pengetahuan tentang operasi file biner.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

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
