<!--
<details>
  <summary>📃 Daftar Isi</summary>

</details>

#
Tentu, kita lanjutkan.

Ini adalah modul yang paling teknis, namun juga yang paling membuka potensi. Jika Modul 1 adalah tentang "berbicara" ke Sway, Modul 2 adalah tentang "memahami" jawaban Sway.

---->

# 🔬 Modul 2: `jq` — Membedah JSON dari Sway

Di Modul 1.2, kita melihat bahwa `swaymsg -t get_workspaces` atau `swaymsg -t get_tree` memberi kita *output* **JSON**.

**Apa itu JSON?** Singkatnya, ini adalah format data terstruktur. Anggap saja ini sebagai "kamus" (`{"kunci": "nilai"}`) atau "daftar" (`["item1", "item2"]`).

**Masalah:** Output dari `swaymsg -t get_tree` bisa ribuan baris. Kita tidak bisa menggunakan `grep` untuk mencari sesuatu secara andal. Kita butuh alat presisi.

**Solusi:** **`jq`**. Ini adalah "sed/awk untuk JSON". Ini adalah bahasa mini untuk mem-filter, memotong, dan mengubah data JSON.

-----

### 2.1: Pengantar `jq`

Mari kita mulai dengan perintah `swaymsg` dan melihat bagaimana `jq` berinteraksi dengannya.

```bash
swaymsg -t get_workspaces | jq '.'
```

**Penjelasan Kata-per-Kata:**

  * **`swaymsg -t get_workspaces`**: Perintah dari Modul 1.2. Ini *menghasilkan* teks JSON (sebuah *array* dari *objek* *workspace*) ke *standard output*.
  * **`|`** (Pipe / Pipa): Ini adalah operator **shell** (Bash). Ini adalah "lem". Ia mengambil *semua output* dari perintah di sebelah kirinya (`swaymsg`) dan "menyambungkannya" sebagai *input* ke perintah di sebelah kanannya (`jq`).
  * **`jq`**: Ini memanggil program `jq`.
  * **`'.'`** (Tanda Petik Tunggal dan Titik):
      * **`'...'` (Petik Tunggal)**: Sangat penting. Ini memberitahu *shell* (Bash) untuk memperlakukan apa pun di dalamnya sebagai *string* tunggal dan tidak mencoba menginterpretasikannya. Kita memberikan "program" `jq` di dalam tanda petik ini.
      * **`.` (Titik)**: Ini adalah filter `jq` yang paling dasar. Ini berarti "identitas" atau "cetak seluruh input apa adanya". Ini adalah cara yang baik untuk memformat ulang (pretty-print) JSON dan memastikan `jq` berfungsi.

-----

#### Filter `jq` Dasar

Kita akan menggunakan `swaymsg -t get_workspaces` sebagai data contoh kita. Outputnya terlihat seperti ini (sudah disederhanakan):

```json
[
  { "num": 1, "name": "1:Main", "focused": false },
  { "num": 2, "name": "2:Web", "focused": true }
]
```

Ini adalah **Array** (ditandai dengan `[ ... ]`) yang berisi dua **Objek** (ditandai dengan `{ ... }`).

1.  **Mengakses Elemen Array: `.[ ]`**
    Untuk mendapatkan elemen *pertama* (indeks 0):

    ```bash
    swaymsg -t get_workspaces | jq '.[0]'
    ```

      * **`.[0]`**: "Dari input (`.`), beri saya elemen di indeks `0`."
      * **Output:** `{ "num": 1, "name": "1:Main", "focused": false }`

2.  **Mengakses Kunci Objek: `.key`**
    Sekarang, mari kita ambil *hanya nama* dari elemen pertama:

    ```bash
    swaymsg -t get_workspaces | jq '.[0].name'
    ```

      * **`.[0].name`**: "Dari input (`.`), ambil elemen `[0]`, *lalu* dari objek itu, beri saya nilai dari kunci `name`."
      * **Output:** `"1:Main"`

3.  **Mengurai Array (Iterator): `.[]`**
    Ini adalah konsep `jq` yang paling kuat. Bagaimana jika kita ingin *nama* dari *semua* workspace?

    ```bash
    swaymsg -t get_workspaces | jq '.[]'
    ```

      * **`.[]`**: "Ambil array input (`.`), dan 'buka bungkusnya'. Beri saya setiap elemen sebagai *item* terpisah."
      * **Output:**
        ```json
        { "num": 1, "name": "1:Main", "focused": false }
        { "num": 2, "name": "2:Web", "focused": true }
        ```

    Ini bukan lagi JSON yang valid, tapi ini adalah *stream* objek. Sekarang kita bisa mem-pipa *di dalam jq*.

4.  **Pipa Internal `jq`: `|`**
    `jq` memiliki operator *pipe*-nya sendiri, jangan bingung dengan *pipe shell*.

    ```bash
    swaymsg -t get_workspaces | jq '.[] | .name'
    ```

      * **`.[]`**: "Buka array menjadi *stream* objek."
      * **`|`**: **Pipa internal `jq`**. "Ambil setiap *item* dari *stream* di sebelah kiri, dan berikan sebagai *input* ke filter di sebelah kanan."
      * **`.name`**: "Dari *item* yang diberikan (satu objek *workspace*), ambil nilai dari kunci `name`."
      * **Output:**
        ```
        "1:Main"
        "2:Web"
        ```

-----

### 2.2: Resep `jq` (Studi Kasus Sway)

Mari kita selesaikan tugas-tugas nyata.

#### Resep 1: Mendapatkan Nama Workspace yang Sedang Fokus

Ini adalah resep paling umum. Kita ingin skrip kita tahu di *workspace* mana kita berada.

  * **Logika:**

    1.  Dapatkan semua *workspace* (`swaymsg -t get_workspaces`).
    2.  Buka array-nya (`.[]`).
    3.  Temukan satu yang memiliki `"focused": true`.
    4.  Dari yang itu, ambil `"name"`.

  * **Perintah:**

    ```bash
    swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .name'
    ```

  * **Penjelasan Kata-per-Kata (Program `jq`):**

      * **`.[]`**: "Buka array *workspace* menjadi *stream* objek."
      * **`|`**: "Kirim setiap objek *workspace* ke filter berikutnya."
      * **`select(...)`**: Ini adalah *filter*. Ia hanya akan "meloloskan" *item* yang kondisi di dalamnya `true`.
      * **`.focused == true`**: Ini adalah *kondisi*.
          * `.focused`: "Lihat kunci `focused` dari *item* saat ini (objek *workspace*)."
          * `== true`: "Periksa apakah nilainya sama dengan `true`."
      * **`|`**: "Ambil *item* yang lolos `select` (hanya akan ada satu) dan kirim ke filter berikutnya."
      * **`.name`**: "Dari objek *workspace* yang fokus itu, ambil nilai dari kunci `name`."

  * **Output:** `"2:Web"`

  * **Menghilangkan Tanda Kutip (PENTING\!)**
    Outputnya adalah `"2:Web"`, bukan `2:Web`. Tanda kutip itu adalah bagian dari JSON *string*. Untuk skrip Bash, kita (biasanya) tidak menginginkannya. Gunakan *flag* **`-r`** (`--raw-output`).

    ```bash
    swaymsg -t get_workspaces | jq -r '.[] | select(.focused == true) | .name'
    ```

      * **`-r`**: "Jika output akhirnya adalah *string*, jangan cetak tanda kutip JSON-nya."
      * **Output:** `2:Web` (teks mentah, sempurna untuk Bash).

-----

#### Resep 2: Mendapatkan `app_id` dari Jendela yang Fokus

Ini lebih rumit. Kita perlu menggunakan `get_tree` karena `get_workspaces` tidak tahu tentang jendela.

  * **Logika:**

    1.  Dapatkan *seluruh* pohon data (`swaymsg -t get_tree`).
    2.  Cari di *setiap* node di seluruh pohon.
    3.  Temukan satu node yang memiliki `"focused": true`.
    4.  Dari node itu, ambil `"app_id"` (atau `.name` untuk judul, atau `.window_properties.class` untuk *class* X11).

  * **Perintah:**

    ```bash
    swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | .app_id'
    ```

  * **Penjelasan Kata-per-Kata (Program `jq`):**

      * **`..`** (Recursive Descent): Ini adalah operator "cari di mana-mana". Ini berarti "lihat di sini (`.`), dan di semua *children*-nya, dan *children* dari *children*-nya..." Ini akan menghasilkan *stream* dari *setiap node* di pohon JSON.
      * **`|`**: "Kirim setiap node (satu per satu) ke filter berikutnya."
      * **`select(.focused? == true)`**:
          * `select(...)`: Hanya loloskan node yang cocok.
          * `.focused?`: "Lihat kunci `focused`." Tanda tanya `?` adalah pengaman. "Jangan error jika kunci `focused` tidak ada" (karena beberapa node seperti *workspace* mungkin tidak memilikinya, meskipun di Sway biasanya ada).
          * `== true`: "Periksa apakah nilainya `true`."
      * **`|`**: "Ambil node jendela yang fokus dan kirim ke filter berikutnya."
      * **`.app_id`**: "Dari node itu, beri saya nilai `app_id`-nya." (Ini akan menjadi `null` jika itu bukan jendela aplikasi, tapi itu tidak masalah bagi kita).

  * **Output:** `firefox` atau `Alacritty` atau `null` (jika Anda fokus pada *container* kosong).

-----

### 2.3: Logika Kondisional: Menulis Skrip `if-then-else`

Sekarang kita gabungkan Bash dan `jq`. Ini adalah "otak" dari skrip Anda.

**Skenario:** Kita ingin membuat skrip "pintar". Jika jendela yang fokus adalah Firefox, pindahkan ke *workspace* "Web". Jika tidak, jangan lakukan apa-apa.

Kita akan menggunakan dua konsep Bash:

1.  **Command Substitution: `$(...)`**
    Bash akan menjalankan apa pun di dalam `$(...)`, menangkap *output*-nya, dan menempelkannya di tempat itu.
2.  **Variabel: `NAMA_VAR=nilai`**
    Menyimpan nilai untuk digunakan nanti.

**Skrip (`move_firefox.sh`):**

```bash
#!/bin/bash
# Skrip untuk memindahkan Firefox ke workspace "Web"

# 1. Dapatkan app_id dari jendela yang fokus dan simpan ke variabel
#    Kita menggunakan 'jq -r' agar outputnya bersih (misal: "firefox")
focused_app_id=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | .app_id')

# 2. Periksa nilai variabel dengan 'if'
if [ "$focused_app_id" == "firefox" ]; then
    # 3. Jika cocok, jalankan perintah 'swaymsg'
    swaymsg "move container to workspace Web"
fi
```

**Penjelasan Kata-per-Kata (Skrip Bash):**

  * **`#!/bin/bash`**: "Shebang". Memberitahu sistem untuk menggunakan `/bin/bash` untuk menjalankan file ini.
  * **`#`**: Komentar. Diabaikan oleh Bash.
  * **`focused_app_id=...`**: Mendeklarasikan *variabel* Bash bernama `focused_app_id`.
  * **`$(...)`**: **Command Substitution**. Bash akan *pertama* menjalankan perintah di dalamnya.
  * **`swaymsg ... | jq ...`**: Perintah "Resep 2" kita. Output mentahnya (misal: `firefox`) akan ditangkap.
  * *Hasil baris 1:* Variabel `focused_app_id` sekarang berisi string `firefox` (atau apa pun yang sedang fokus).
  * **`if`**: Memulai blok kondisional.
  * **`[ ... ]`**: Ini adalah *perintah* `test` Bash (singkatan). **PENTING: Harus ada spasi setelah `[` dan sebelum `]`\!**
  * **`"$focused_app_id"`**: Mengambil nilai variabel. **PENTING: Tanda kutip ganda** adalah *best practice* untuk mencegah error jika variabelnya kosong atau berisi spasi.
  * **`==`**: Operator perbandingan string. "apakah sama dengan".
  * **`"firefox"`**: String yang kita bandingkan.
  * **`; then`**: Sintaks Bash. "Jika kondisi `[...]` benar, *maka* lakukan berikut ini."
  * **`swaymsg "..."`**: Perintah `swaymsg` kita dari Modul 1.1.
  * **`fi`**: Menutup blok `if` (`if` dibalik).

-----

### Ringkasan Modul 2

  * `swaymsg -t ...` memberi kita JSON.
  * Kita menggunakan *shell pipe* (`|`) untuk mengirim JSON itu ke `jq`.
  * `jq` adalah bahasa filter.
      * `.` = seluruh input
      * `.[0]` = akses array
      * `.key` = akses objek
      * `.[]` = "buka" array
      * `|` (internal) = menyambung filter `jq`
      * `select(...)` = menyaring *item*
      * `..` = cari di mana-mana (rekursif)
      * `-r` = *raw output* (hapus tanda kutip string)
  * Kita menggunakan Bash `$(...)` untuk menyimpan output `jq` ke variabel.
  * Kita menggunakan Bash `if [ ... ]` untuk membuat keputusan berdasarkan variabel itu.

Anda sekarang memiliki *skillset* paling penting untuk *scripting* Sway: **Bertanya** (`swaymsg -t`), **Memfilter** (`jq`), dan **Bertindak** (`if ...; then swaymsg ...`).

-----
<!--
Apakah Anda ingin mendalami "Resep `jq`" lainnya, atau kita siap untuk melanjutkan ke **Modul 3: Dari Konfig ke Skrip (Integrasi)**, di mana kita akan belajar cara *memanggil* skrip ini dari file `config` Sway Anda?
> - **[Ke Atas](#)**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**
[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
-->

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**

[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

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
