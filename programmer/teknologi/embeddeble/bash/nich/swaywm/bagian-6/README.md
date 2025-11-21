<!--
<details>
  <summary>📃 Daftar Isi</summary>

</details>

#

-->
Ini adalah modul terpenting bagi kesehatan mental Anda.

Di dunia pemrograman antarmuka grafis (GUI) seperti Sway, *debugging* jauh lebih sulit daripada di terminal biasa. Mengapa? Karena jika skrip Anda gagal saat dijalankan oleh tombol (`bindsym`), **biasanya tidak terjadi apa-apa**. Tidak ada pesan error, tidak ada jendela pop-up. Hening.

Di Modul 6, kita akan belajar cara membuat "suara" dari keheningan itu.

-----

## 🩺 Modul 6: Debugging — "Kenapa Skrip Saya Tidak Jalan?"

### 6.1: Masalah "Silent Fail" dan Redirection (Pengalihan)

Saat Anda menjalankan skrip di terminal, Anda melihat *output*-nya. Saat Sway menjalankan skrip (lewat `exec`), output itu dibuang ke "ruang hampa" (biasanya `/dev/null` atau log sistem yang sulit dicari).

Untuk melihat error, kita harus menangkap output tersebut ke dalam sebuah file.

**Teknik Debugging Paling Ampuh: Logging ke File**

Ubah perintah di config Sway Anda sementara waktu:

**Sebelum (Gagal Diam-diam):**

```sway
bindsym $mod+x exec ~/.config/sway/scripts/myscript.sh
```

**Sesudah (Debugging Mode):**

```sway
bindsym $mod+x exec ~/.config/sway/scripts/myscript.sh >> /tmp/sway_script.log 2>&1
```

**Penjelasan Kata-per-Kata (Sangat Penting):**

  * **`>>`**: Operator *Redirection* (Pengalihan) tipe *Append* (Tambahkan).
      * Ini mengambil *Standard Output* (hasil print normal dari `echo`) dan menambahkannya ke akhir file target.
      * Mengapa `>>` dan bukan `>`? Agar kita bisa melihat sejarah error, bukan hanya yang terakhir (yang akan menimpa file lama jika pakai `>`).
  * **`/tmp/sway_script.log`**: Lokasi file log. Direktori `/tmp` adalah tempat yang aman karena akan dibersihkan saat *reboot*.
  * **`2>&1`**: Ini adalah mantra sihir Bash.
      * **`2`**: Kode angka untuk *Standard Error* (Pesan kesalahan).
      * **`>`**: Alihkan ke...
      * **`&1`**: Kode angka untuk *Standard Output*.
      * **Arti:** "Tolong kirim pesan error (2) ke tempat yang sama dengan pesan normal (1)."
      * Tanpa ini, Anda hanya akan melihat pesan `echo`, tetapi jika ada error sintaks (seperti `command not found`), itu tidak akan masuk ke file log.

**Cara Membaca Log:**
Buka terminal lain dan jalankan perintah ini untuk memantau log secara *real-time*:

```bash
tail -f /tmp/sway_script.log
```

(*`tail -f` artinya "tampilkan bagian ekor file dan ikuti terus (follow) jika ada baris baru".*)

-----

### 6.2: `swaynag` sebagai "Print Debugging"

Terkadang Anda malas membuka terminal untuk melihat log. Anda hanya ingin tahu: *"Sampai baris ini, berapa nilai variabel X?"*

Di pemrograman biasa, kita pakai `print` atau `console.log`. Di Sway, kita pakai `swaynag`.

**Contoh Masalah:**
Skrip Anda seharusnya memindahkan "Firefox", tapi tidak jalan. Anda curiga Sway melihatnya sebagai "firefox" (huruf kecil), bukan "Firefox".

**Solusi Debugging:**
Sisipkan baris ini di dalam skrip Anda sebelum logika `if`:

```bash
# ... kode sebelumnya ...
app_id=$(swaymsg -t get_tree | jq ...)

# --- BARIS DEBUG ---
swaynag -m "DEBUG: Nilai app_id saat ini adalah: '$app_id'"
# -------------------

if [ "$app_id" == "Firefox" ]; then ...
```

**Analisis:**
Saat skrip jalan, baris kuning akan muncul di atas layar memberi tahu Anda nilai persis yang dilihat variabel tersebut. Jika muncul `DEBUG: Nilai app_id saat ini adalah: 'firefox'`, Anda langsung tahu kesalahan Anda (masalah kapitalisasi).

-----

### 6.3: Validasi Config (`sway -C`)

Seringkali skrip tidak jalan karena Sway bahkan tidak memuat baris `bindsym` atau `exec` tersebut karena ada *typo* di file config.

Sebelum me-reload Sway, biasakan menjalankan:

```bash
sway -C
```

**Penjelasan Kata-per-Kata:**

  * **`sway`**: Program utama Sway.
  * **`-C`**: *Flag* untuk **Check Config**.
      * Perintah ini akan membaca `~/.config/sway/config` Anda, memvalidasi sintaksnya, mencari error, tetapi **TIDAK** menjalankan Sway.
      * Jika tidak ada output (hening), berarti config Anda valid.
      * Jika ada output merah, perbaiki baris yang disebutkan sebelum melakukan reload.

-----

### 6.4: Membedah Struktur JSON yang Salah

Masalah umum di Modul 2 (jq) adalah filter Anda tidak menghasilkan apa-apa (`null`).

**Jangan langsung menulis filter panjang.** Lakukan bertahap di terminal.

**Salah (Langsung coba filter rumit):**

```bash
swaymsg -t get_tree | jq '.nodes[1].nodes[0].name'
# Output: null (Kenapa? Saya tidak tahu salahnya di mana)
```

**Benar (Debugging Bertahap):**

1.  Cek level 1: `swaymsg -t get_tree | jq '.nodes[1] | keys'`
      * *Lihat apakah kuncinya benar.*
2.  Cek level 2: `swaymsg -t get_tree | jq '.nodes[1].nodes[0] | keys'`
      * *Oh, ternyata tidak ada 'nodes' di situ, tapi adanya 'floating\_nodes'.*

**Tips Pro:** Gunakan `less` untuk menjelajahi output JSON yang besar.

```bash
swaymsg -t get_tree | jq '.' | less
```

(*Gunakan tombol panah untuk scroll, `/` untuk mencari kata kunci*).

-----

### 6.5: Checklist "Kenapa Skrip Saya Tidak Jalan?"

Jika Anda buntu, ikuti **Protokol Darurat** ini:

1.  **Izin File:**
      * Jalankan `ls -l scripts/myscript.sh`.
      * Apakah ada huruf `x` (rwx)? Jika tidak -\> `chmod +x`.
2.  **Shebang:**
      * Apakah baris pertama file adalah `#!/bin/bash`?
3.  **Path:**
      * Apakah di config Sway Anda menggunakan *path* absolut (`/home/user/...`)? Jangan pakai `~/` jika ragu, pakai `$HOME` atau path lengkap.
4.  **Manual Run:**
      * Jalankan skrip langsung dari terminal Anda. Apakah jalan?
      * Jika jalan di terminal tapi tidak di Sway -\> Masalah **Environment Variables** (PATH). Tambahkan `source ~/.bashrc` di awal skrip atau definisikan PATH manual di dalam skrip.
5.  **Log It:**
      * Gunakan teknik `>> log.txt 2>&1`.

-----

### Ringkasan Modul 6

Debugging adalah tentang mengubah "tidak tahu" menjadi "tahu".

  * Gunakan `>> file.log 2>&1` untuk menangkap error tersembunyi.
  * Gunakan `swaynag` untuk menampilkan nilai variabel secara visual.
  * Gunakan `sway -C` untuk memastikan konfigurasi Anda tidak cacat sintaks.
  * Jangan menebak struktur JSON, bedah perlahan dengan `jq` di terminal.

-----

# Selamat! 

Anda telah menyelesaikan **Materi Inti** dari Kelas Master Scripting Sway.

-----

Kita punya satu modul tersisa: **Modul 7: Proyek Akhir (Capstone)**.
Di sini kita memiliki satu tantangan coding lengkap (dengan kunci jawaban) yang menggabungkan:

  * `swaymsg` (IPC)
  * `jq` (Parsing)
  * `wofi` (Interaksi)
  * Bash Logic (Scripting)

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Nich][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../../README.md
[kurikulum]: ../../README.md
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
