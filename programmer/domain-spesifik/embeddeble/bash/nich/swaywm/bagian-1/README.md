<!--
<details>
  <summary>📃 Daftar Isi</summary>

</details>

#
Tentu, mari kita langsung masuk ke inti dari *scripting* Sway.

-----


-->
## 💬 Modul 1: `swaymsg` — Juru Bicara Anda ke Sway

Di Modul 0, kita belajar bahwa Sway memiliki "saluran telepon" (IPC). Sekarang, kita akan belajar cara menggunakan "telepon"-nya.

**`swaymsg`** adalah program baris perintah (CLI) yang Anda gunakan untuk mengirim pesan ke proses Sway yang sedang berjalan. Ini adalah alat **utama** Anda. 99% dari *scripting* Sway adalah tentang memanggil `swaymsg` dengan perintah yang tepat.

**Sintaks Dasar:**
`swaymsg [opsi] [perintah]`

  * **Penting:** Perintah yang Anda gunakan dengan `swaymsg` **sama persis** dengan perintah yang Anda tulis di file `config` Anda, tetapi tanpa `bindsym`.
      * Di `config`: `bindsym $mod+Return exec alacritty`
      * Di terminal/skrip: `swaymsg exec alacritty`

-----

### 1.1: *One-liners* (Memberi Perintah)

Bagian ini adalah tentang *memberi tahu* Sway untuk **melakukan** sesuatu. Ini adalah perintah "imperatif". Anda menyuruh, Sway patuh. Perintah ini biasanya hanya mengembalikan JSON sederhana seperti `{"success": true}`.

#### Perintah 1: `exec` (Menjalankan Program)

Ini adalah perintah yang paling umum Anda gunakan.

```bash
swaymsg exec alacritty
```

**Penjelasan Kata-per-Kata:**

  * **`swaymsg`**: Memanggil program "telepon" IPC Sway.
  * **`exec`**: Ini adalah *perintah* yang Anda kirim ke Sway. Ini berarti "execute" atau "jalankan". Ini memberi tahu Sway untuk meluncurkan program eksternal baru.
  * **`alacritty`**: Ini adalah *argumen* untuk perintah `exec`. Ini adalah nama program yang ingin Anda jalankan. Sway akan mencari `alacritty` di dalam `PATH` (ingat Modul 0.2\!) dan menjalankannya.

**Kapan digunakan:** Berguna dalam skrip untuk meluncurkan aplikasi sebagai bagian dari alur kerja (misalnya, skrip yang membuka editor teks *dan* peramban Anda secara bersamaan).

-----

#### Perintah 2: `focus` (Mengubah Fokus)

Perintah ini memindahkan fokus aktif Anda (jendela mana yang Anda ketik) tanpa menggunakan mouse.

```bash
swaymsg focus left
```

**Penjelasan Kata-per-Kata:**

  * **`swaymsg`**: Panggil alat IPC.
  * **`focus`**: Ini adalah *perintah*. Ini memberi tahu Sway untuk memindahkan fokus dari *container* (jendela) saat ini.
  * **`left`**: Ini adalah *argumen* untuk `focus`. Ini menentukan *arah* ke mana fokus harus bergerak. Argumen lain yang valid bisa berupa:
      * `right`, `up`, `down` (arah)
      * `parent` (fokus ke "induk" dari jendela saat ini dalam hierarki *layout*)
      * `child` (fokus ke "anak" dari *container* saat ini)

**Kapan digunakan:** Ini adalah inti dari navigasi *tiling*. Anda dapat membuat skrip yang secara cerdas memindahkan fokus berdasarkan kriteria tertentu, bukan hanya arah.

-----

#### Perintah 3: `move` (Memindahkan Kontainer)

Perintah ini *memindahkan* jendela yang sedang fokus ke lokasi baru.

```bash
swaymsg move container to workspace 3
```

**Penjelasan Kata-per-Kata:**

  * **`swaymsg`**: Panggil alat IPC.
  * **`move container`**: Ini adalah *perintah* lengkap. `move` sendiri adalah perintah dasarnya, dan `container` memperjelas bahwa kita ingin memindahkan seluruh *container* (jendela) yang sedang fokus.
  * **`to workspace`**: Ini adalah *argumen* yang memberi tahu `move` *jenis* perpindahan apa yang kita lakukan.
  * **`3`**: Ini adalah *argumen* akhir, yang menentukan tujuan. Ini bisa berupa nomor *workspace* (`3`) atau nama (`"3:Web"`).

**Kapan digunakan:** Sangat berguna untuk skrip "pengorganisasi". Misalnya, skrip yang menemukan semua jendela peramban Anda dan memindahkan semuanya ke *workspace* "Web".

-----

#### Perintah 4: `layout` (Mengubah Tata Letak)

Perintah ini mengubah cara jendela diatur di *workspace* saat ini.

```bash
swaymsg layout tabbed
```

**Penjelasan Kata-per-Kata:**

  * **`swaymsg`**: Panggil alat IPC.
  * **`layout`**: Ini adalah *perintah* untuk mengubah mode *layout* dari *container* induk saat ini (biasanya seluruh *workspace*).
  * **`tabbed`**: Ini adalah *argumen* yang menentukan *layout* baru. Pilihan paling umum adalah:
      * `splith` (bagi horizontal)
      * `splitv` (bagi vertikal)
      * `tabbed` (seperti *tab* di peramban)
      * `stacked` (seperti *tabbed*, tetapi vertikal)

**Kapan digunakan:** Untuk skrip yang beralih *layout* secara dinamis. (Contoh: "Jadikan *layout tabbed* jika saya di monitor laptop, tapi `splith` jika di monitor *ultrawide*").

-----

### 1.2: *Querying State* (Mengambil Data)

Ini adalah bagian di mana *scripting* menjadi **cerdas**. Daripada hanya *menyuruh*, kita sekarang *bertanya* pada Sway. "Apa yang sedang terjadi?"

Untuk melakukan ini, kita menggunakan *flag* (opsi) **`-t`** pada `swaymsg`.

  * **`-t`**: Ini adalah singkatan dari `--type`. Ini memberi tahu `swaymsg` bahwa kita tidak mengirim *perintah*, tetapi kita meminta *tipe* informasi tertentu.

Saat Anda menggunakan `-t`, `swaymsg` akan merespons dengan **JSON** (JavaScript Object Notation), format data yang akan kita bedah di Modul 2.

#### Perintah 1: `get_workspaces`

Meminta daftar semua *workspace* Anda saat ini dan statusnya.

```bash
swaymsg -t get_workspaces
```

**Penjelasan Kata-per-Kata:**

  * **`swaymsg`**: Panggil alat IPC.
  * **`-t`**: *Flag* yang sangat penting. Mengubah mode `swaymsg` dari "menyuruh" menjadi "bertanya".
  * **`get_workspaces`**: Ini adalah *tipe* permintaan. "Tolong beri saya (get) semua data *workspace*."

**Contoh Output (JSON):**

```json
[
  {
    "id": 1,
    "num": 1,
    "name": "1",
    "visible": true,
    "focused": true,
    "rect": { "x": 0, "y": 0, "width": 1920, "height": 1080 },
    "output": "DP-1"
  },
  {
    "id": 2,
    "num": 2,
    "name": "2:www",
    "visible": false,
    "focused": false,
    "rect": { "x": 1920, "y": 0, "width": 2560, "height": 1440 },
    "output": "HDMI-A-1"
  }
]
```

Dari sini, skrip Anda bisa tahu bahwa *workspace* "1" sedang fokus di monitor "DP-1".

-----

#### Perintah 2: `get_outputs`

Meminta daftar semua monitor (output) Anda yang terdeteksi.

```bash
swaymsg -t get_outputs
```

**Penjelasan Kata-per-Kata:**

  * **`swaymsg`**: Panggil alat IPC.
  * **`-t`**: *Flag* untuk mode "bertanya".
  * **`get_outputs`**: *Tipe* permintaan. "Beri saya semua data monitor."

**Kapan digunakan:** Penting untuk skrip yang menangani pencolokan/pencabutan laptop dari *docking station* atau monitor eksternal.

-----

#### Perintah 3: `get_tree`

Ini adalah "Perintah Dewa". Ini meminta **segalanya**.

Ini mengembalikan satu objek JSON raksasa yang berisi *seluruh* status Sway: semua monitor, semua *workspace*, semua *container*, semua jendela individu, properti mereka, *layout* mereka, apakah mereka fokus, dll.

```bash
swaymsg -t get_tree
```

**Penjelasan Kata-per-Kata:**

  * **`swaymsg`**: Panggil alat IPC.
  * **`-t`**: *Flag* untuk mode "bertanya".
  * **`get_tree`**: *Tipe* permintaan. "Beri saya seluruh 'pohon' *layout* dari atas sampai bawah."

*Output*-nya akan sangat besar dan rumit. Inilah sebabnya mengapa Modul 2 (tentang `jq`) sangat penting, karena `jq` adalah alat untuk menemukan satu jarum di tumpukan jerami raksasa ini.

-----

### 1.3: Konsep *Command Chaining* (Rantai Perintah)

Bagaimana jika Anda ingin melakukan *dua* hal secara berurutan? Anda bisa menggunakan **pemisah perintah**.

Pemisah perintah di `swaymsg` adalah titik koma (**`;`**).

#### Skenario:

Anda ingin beralih ke *workspace* 2, DAN *kemudian* segera mengubah *layout* di sana menjadi *tabbed*.

#### Contoh:

```bash
swaymsg "workspace 2; layout tabbed"
```

**Penjelasan Kata-per-Kata:**

  * **`swaymsg`**: Panggil alat IPC.
  * **`"..."`**: **Tanda kutip (petik dua)**. Ini sangat penting. Ini memberitahu *shell* (Bash) Anda untuk memperlakukan `workspace 2; layout tabbed` sebagai **satu argumen tunggal** yang akan diberikan ke `swaymsg`. Tanpa ini, *shell* Anda mungkin akan mencoba menjalankan `layout tabbed` sebagai perintah *shell* terpisah.
  * **`workspace 2`**: Perintah pertama yang akan dieksekusi Sway. Ini instan.
  * **`;`**: **Pemisah Perintah (Command Separator)**. Ini adalah instruksi *untuk Sway*. Sway melihat ini dan tahu, "OK, setelah perintah pertama selesai, saya akan melanjutkan ke perintah berikutnya."
  * **`layout tabbed`**: Perintah kedua, yang akan dieksekusi *setelah* fokus berhasil pindah ke *workspace* 2.

#### Jebakan Umum (PENTING):

Bagaimana jika Anda ingin meluncurkan program *dan* memindahkannya?

```bash
# Versi Naif (KEMUNGKINAN BESAR GAGAL)
swaymsg "exec alacritty; move container to workspace 3"
```

**Mengapa ini gagal?**
`exec alacritty` hanya *memulai* proses `alacritty`. Sway tidak *menunggu* jendela Alacritty benar-benar *muncul* dan *terdaftar*. Perintah `move container to workspace 3` akan berjalan sepersekian detik kemudian, *sebelum* jendela Alacritty ada. Akibatnya, perintah `move` akan gagal atau (lebih buruk) memindahkan jendela apa pun yang kebetulan sedang fokus *saat itu*.

*Command Chaining* hanya efektif untuk perintah-perintah *internal* Sway yang instan (`focus`, `layout`, `move`, `workspace`, dll), bukan untuk perintah yang melibatkan program eksternal (`exec`).

-----

### Ringkasan Modul 1

  * Anda sekarang tahu `swaymsg` adalah alat utama Anda.
  * Anda bisa **menyuruh** Sway melakukan sesuatu (`exec`, `focus`, `move`).
  * Anda bisa **bertanya** pada Sway tentang statusnya menggunakan `-t` (`get_workspaces`, `get_tree`).
  * Anda bisa **menggabungkan** beberapa perintah internal Sway menggunakan `;` dan tanda kutip (`"..."`).

Kita sekarang memiliki kemampuan untuk "berbicara" dan "mendengar" dari Sway. Tapi "mendengar" kita masih buruk. Kita mendapatkan *output* JSON yang besar, tapi kita belum bisa "memahaminya".

-----

Di modul berikutnya, kita akan belajar cara menjadi "penerjemah" JSON yang andal.

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][domain]**

[domain]: ../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

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
