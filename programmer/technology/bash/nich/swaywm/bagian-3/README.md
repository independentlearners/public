<!--
<details>
  <summary>📃 Daftar Isi</summary>

</details>

#
Baik, keputusan yang tepat. `jq` memang sangat luas dan bisa dipelajari sambil jalan. Kita fokuskan dulu pada kerangka kerja utamanya.

Sekarang kita masuk ke tahap implementasi. Anda sudah punya ide skrip, tapi bagaimana cara memasangnya agar bekerja mulus dengan Sway?

-----

-->
## 🚀 Modul 3: Dari Konfig ke Skrip (Integrasi)

Di modul ini, kita akan belajar cara menjembatani file konfigurasi Sway (`~/.config/sway/config`) dengan skrip Bash eksternal yang Anda buat.

### 3.1: `exec` vs. `bindsym`

Di dalam file konfigurasi Sway, ada dua cara utama untuk menjalankan skrip Anda. Penting untuk membedakan keduanya agar skrip berjalan di waktu yang tepat.

#### 1\. Perintah `exec` (Startup)

Digunakan untuk skrip yang harus berjalan **sekali saja** saat Sway pertama kali dinyalakan. Ini biasanya untuk *daemon*, *background process*, atau pengaturan awal.

**Contoh di Config:**

```sway
exec --no-startup-id ~/.config/sway/scripts/autostart.sh
```

**Penjelasan Kata-per-Kata:**

  * **`exec`**: Kata kunci konfigurasi Sway. Artinya "jalankan perintah shell ini saat Sway mulai".
  * **`--no-startup-id`**: *Flag* (opsi) ini sangat disarankan untuk skrip latar belakang.
      * Secara default, Sway mencoba melacak aplikasi yang diluncurkan untuk menampilkan kursor "loading" (lingkaran berputar).
      * Untuk skrip yang tidak memiliki jendela GUI (seperti skrip *autostart*), pelacakan ini akan gagal dan kursor Anda mungkin akan terus berputar selama 30 detik (timeout). Flag ini mematikan pelacakan tersebut.
  * **`~/.config/...`**: Path absolut ke skrip Anda.

#### 2\. Perintah `bindsym` (Interaktif)

Digunakan untuk menjalankan skrip saat Anda menekan kombinasi tombol tertentu.

**Contoh di Config:**

```sway
bindsym $mod+Shift+e exec ~/.config/sway/scripts/powermenu.sh
```

**Penjelasan Kata-per-Kata:**

  * **`bindsym`**: Kata kunci konfigurasi Sway. Artinya "bind symbol" (ikat simbol/tombol).
  * **`$mod+Shift+e`**: Kombinasi tombol pemicu. (`$mod` biasanya tombol Windows/Super).
  * **`exec`**: Perhatikan bahwa `bindsym` membutuhkan *tindakan*. Tindakannya adalah `exec`. Di sini, `exec` berarti "jalankan perintah shell ini SEKARANG (saat tombol ditekan)".
  * **`~/.config/...`**: Path absolut ke skrip.

-----

### 3.2: *Best Practice* Lokasi & Izin (*Permissions*)

Agar sistem Anda rapi dan aman, jangan menaruh skrip sembarangan.

#### Struktur Direktori

Sangat disarankan untuk menyimpan skrip khusus Sway di dalam folder konfigurasi Sway itu sendiri.

1.  Buat foldernya (jika belum ada):
    ```bash
    mkdir -p ~/.config/sway/scripts
    ```
      * `mkdir`: *Make Directory* (Buat folder).
      * `-p`: *Parents*. Buat folder induknya juga jika belum ada (aman dijalankan kapan saja).

#### Izin Eksekusi (`chmod`)

Ini adalah langkah yang paling sering dilupakan pemula. File teks biasa tidak bisa dijalankan oleh komputer sampai Anda memberinya izin "Execute".

**Perintah:**

```bash
chmod +x ~/.config/sway/scripts/myscript.sh
```

**Penjelasan Kata-per-Kata:**

  * **`chmod`**: *Change Mode*. Perintah Unix untuk mengubah izin file.
  * **`+x`**: *Add Executable*. Menambahkan (+) izin eksekusi (x) ke file tersebut.
      * Tanpa ini, Sway akan menolak menjalankan skrip dan Anda tidak akan melihat pesan error apa pun (silent fail).
  * **`~/.../myscript.sh`**: Lokasi file target.

-----

### 3.3: Melempar Argumen (Membuat Skrip Generik)

Jangan membuat 10 skrip berbeda untuk 10 hal yang mirip. Buatlah **satu** skrip yang bisa menerima instruksi.

**Skenario:** Anda ingin memindahkan jendela ke Workspace 1, 2, atau 3.

  * **Cara Buruk:** Membuat `move_to_1.sh`, `move_to_2.sh`, `move_to_3.sh`.
  * **Cara Benar:** Membuat satu `move_to.sh` yang menerima angka sebagai input.

#### Bagian 1: Di File Config Sway

Kita memanggil skrip yang sama, tapi dengan "ekor" (argumen) yang berbeda.

```sway
bindsym $mod+1 exec ~/.config/sway/scripts/move_to.sh 1
bindsym $mod+2 exec ~/.config/sway/scripts/move_to.sh 2
```

**Penjelasan Kata-per-Kata:**

  * **`.../move_to.sh`**: Memanggil skrip utama.
  * **`1`** (atau `2`): Ini adalah **Argumen Pertama**. Spasi memisahkan nama program dari argumennya. Bash akan mengirimkan angka ini ke dalam skrip.

#### Bagian 2: Di Dalam Skrip Bash (`move_to.sh`)

Bagaimana cara skrip membaca angka `1` atau `2` tadi? Kita menggunakan **Positional Parameters** (`$1`, `$2`, dst).

**Isi Skrip:**

```bash
#!/bin/bash

# Menangkap argumen pertama ke dalam variabel agar mudah dibaca
TARGET_WS=$1

# Menggunakan variabel tersebut dalam perintah swaymsg
swaymsg move container to workspace number "$TARGET_WS"
```

**Penjelasan Kata-per-Kata:**

  * **`TARGET_WS=$1`**:
      * `TARGET_WS`: Nama variabel yang kita buat sendiri.
      * `=`: Operator penugasan (assignment).
      * **`$1`**: Ini adalah variabel spesial Bash. Isinya adalah **kata pertama** setelah nama skrip saat dijalankan.
          * Jika di config tertulis `...sh 1`, maka `$1` berisi `1`.
          * Jika di config tertulis `...sh hello`, maka `$1` berisi `hello`.
  * **`swaymsg ... "$TARGET_WS"`**:
      * Bash akan mengganti `"$TARGET_WS"` dengan isinya (misalnya `1`) sebelum menjalankan perintah.
      * Hasil akhirnya yang dijalankan komputer: `swaymsg move container to workspace number 1`.

#### Teknik Lanjutan: Argumen Default

Bagaimana jika Anda lupa menulis angka di config? Skrip akan error karena `$1` kosong. Kita bisa membuat nilai *default*.

```bash
# Gunakan $1, tapi jika kosong, gunakan "1"
TARGET_WS=${1:-1}
```

  * **`${...}`**: Format manipulasi variabel.
  * **`:-`**: Operator *default value*. "Jika variabel di kiri kosong/null, gunakan nilai di kanan."

-----

### Ringkasan Modul 3

1.  Gunakan **`exec --no-startup-id`** untuk skrip yang berjalan otomatis saat login.
2.  Gunakan **`bindsym ... exec`** untuk skrip yang dipicu tombol.
3.  Selalu simpan skrip di tempat teratur (misal: `~/.config/sway/scripts`) dan **WAJIB** jalankan `chmod +x`.
4.  Gunakan **`$1`** di dalam Bash untuk menangkap input dari config Sway, membuat skrip Anda fleksibel dan dapat digunakan ulang.

Anda sekarang sudah bisa membuat skrip, memberinya izin, dan menghubungkannya ke tombol keyboard Anda dengan cara yang benar dan efisien.

-----
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Nich][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../../README.md
[kurikulum]: ../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

<!--

Selanjutnya adalah **Modul 4: Skrip Reaktif (Event-driven)**. Ini adalah level "master" yang sebenarnya, di mana skrip Anda berjalan otomatis merespons tindakan Anda (seperti membuka jendela), bukan hanya saat ditekan tombol.

Apakah Anda siap masuk ke Modul 4?
> - **[Ke Atas](#)**
-->

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
