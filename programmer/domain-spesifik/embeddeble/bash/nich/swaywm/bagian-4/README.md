<!--
<details>
  <summary>📃 Daftar Isi</summary>

</details>

#
Ini adalah level di mana Anda berubah dari "pengguna biasa" menjadi "penyihir" Sway.

Sebagian besar skrip yang kita buat sejauh ini bersifat **Imperatif** ("Lakukan X sekarang").
Di Modul 4, kita akan membuat skrip **Reaktif** ("Tunggu sampai X terjadi, lalu lakukan Y").

-----

-->
## 🔬 Modul 4: Skrip Reaktif (Event-driven)

Untuk membuat skrip reaktif, kita tidak bisa terus-menerus bertanya "apakah ada perubahan?" setiap detik (polling). Itu akan memboroskan CPU.

Sebaliknya, kita menggunakan fitur **Subscribe** (Berlangganan). Kita memberi tahu Sway: *"Hei, bangunkan aku hanya jika jendela baru terbuka."*

### 4.1: `swaymsg -t subscribe` (Pendengar)

Perintah ini membuka aliran data (stream) yang tidak akan berhenti sampai kita mematikannya.

**Perintah Dasar:**

```bash
swaymsg -t subscribe -m '["window", "workspace"]'
```

**Penjelasan Kata-per-Kata:**

  * **`swaymsg`**: Alat IPC kita.
  * **`-t subscribe`**: Tipe permintaan. Kita ingin berlangganan *event*.
  * **`-m`** (Monitor): **Sangat Penting.** Tanpa flag ini, `swaymsg` hanya akan mengirim permintaan langganan lalu keluar. Dengan `-m`, `swaymsg` akan tetap berjalan (*hang*) dan mencetak baris baru setiap kali ada kejadian.
  * **`'["window", "workspace"]'`**: Argumen JSON. Ini adalah daftar kategori *event* yang ingin kita dengar.
      * `window`: Beritahu saya jika jendela dibuka, ditutup, atau dipindah fokusnya.
      * `workspace`: Beritahu saya jika workspace dibuat, dikosongkan, atau dipindah.

-----

### 4.2: Pola "The While Loop" (Jantung Skrip Daemon)

Karena `swaymsg -m` tidak pernah berhenti, kita tidak bisa menaruhnya begitu saja dalam skrip biasa. Kita harus **mengalirkan** (*pipe*) output-nya ke dalam sebuah lingkaran (*loop*) yang membacanya baris demi baris.

Ini adalah kerangka (boilerplate) standar untuk semua skrip reaktif Sway:

```bash
#!/bin/bash

swaymsg -t subscribe -m '["window"]' | while read -r event; do
    # Logika skrip kita ada di sini
    echo "Sesuatu terjadi: $event"
done
```

**Penjelasan Kata-per-Kata:**

1.  **`swaymsg ... |`**: Jalankan mode monitor, dan kirim *output*-nya ke "pipa".
2.  **`while`**: Perintah Bash untuk memulai lingkaran. Lingkaran ini akan terus berputar selama perintah setelahnya (`read`) berhasil.
3.  **`read -r event`**:
      * `read`: Baca satu baris teks dari "pipa".
      * `-r`: *Raw*. Jangan menginterpretasikan karakter *backslash* (seperti `\n`) sebagai karakter spesial. Baca apa adanya.
      * `event`: Simpan baris teks tersebut ke dalam variabel bernama `$event`. Variabel ini sekarang berisi satu objek JSON lengkap yang menggambarkan kejadian yang baru saja terjadi.
4.  **`do ... done`**: Blok kode yang akan dijalankan setiap kali baris baru diterima.

-----

### 4.3: Studi Kasus — "Auto-Renaming Workspace"

Mari kita buat skrip nyata.
**Tujuan:** Jika saya membuka aplikasi "Spotify", ubah nama workspace saat ini menjadi "🎵 Music".

Kita perlu logika di dalam loop untuk membedah JSON `$event`.
JSON *event* `window` memiliki properti bernama `"change"` (apa yang terjadi: `new`, `close`, `focus`) dan `"container"` (detail jendela).

**Kode Skrip Lengkap (`auto_name.sh`):**

```bash
#!/bin/bash

swaymsg -t subscribe -m '["window"]' | while read -r event; do
    
    # 1. Cek apa jenis perubahannya
    change=$(echo "$event" | jq -r '.change')

    # 2. Kita hanya peduli jika jendela baru dibuat ('new') atau fokus berpindah ('focus')
    if [ "$change" == "new" ] || [ "$change" == "focus" ]; then
        
        # 3. Ambil app_id dari jendela yang menyebabkan event tersebut
        app_id=$(echo "$event" | jq -r '.container.app_id')

        # 4. Logika Kondisional
        if [ "$app_id" == "Spotify" ]; then
            swaymsg "rename workspace to '🎵 Music'"
        elif [ "$app_id" == "firefox" ]; then
            swaymsg "rename workspace to 'Web'"
        fi
    fi

done
```

**Analisis Kode Mendalam:**

  * **`change=$(echo "$event" | jq -r '.change')`**:
      * Kita mengambil variabel `$event` (baris JSON terbaru).
      * Kita mengirimnya ke `jq`.
      * Kita mengambil nilai `.change`.
      * Hasilnya (misal: "focus") disimpan ke variabel `$change`.
  * **`if [ "$change" == "new" ] ...`**:
      * Penting untuk memfilter. Event `window` juga memicu kejadian seperti `title` (saat judul tab berubah). Jika kita tidak memfilter, skrip akan berjalan terlalu sering dan mungkin membuat lag. Kita hanya ingin beraksi saat jendela muncul atau kita pindah fokus.
  * **`.container.app_id`**:
      * Dalam objek JSON event window, detail aplikasi ada di dalam sub-objek `container`. Kita perlu masuk ke sana dulu baru mengambil `app_id`.
  * **`swaymsg "rename workspace ..."`**:
      * Perintah IPC untuk mengubah nama workspace aktif secara instan.

-----

### 4.4: Menjalankan Skrip Daemon (Background)

Skrip jenis ini **tidak** berhenti. Jika Anda menjalankannya di terminal, terminal Anda akan "macet" (sedang bekerja).

Oleh karena itu, di konfigurasi Sway, Anda harus menjalankannya sebagai proses latar belakang (*background process*).

**Di `~/.config/sway/config`:**

```sway
exec_always --no-startup-id ~/.config/sway/scripts/auto_name.sh
```

**Penjelasan Kata-per-Kata:**

  * **`exec_always`**: Berbeda dengan `exec` (yang hanya jalan saat login awal). `exec_always` akan menjalankan perintah ini setiap kali Anda me-reload Sway (`$mod+Shift+c`).
      * **Masalah:** Jika Anda reload Sway, skrip lama mungkin masih jalan, dan skrip baru jalan juga. Anda bisa punya 10 skrip berjalan sekaligus\!
      * **Solusi:** Kita perlu memodifikasi skrip kita sedikit agar "membunuh dirinya sendiri" jika dijalankan ulang, atau menggunakan alat bantu.

**Teknik "Kill Old Instance" (Tambahkan ini di baris paling atas skrip Bash Anda):**

```bash
#!/bin/bash

# Matikan semua proses bernama 'auto_name.sh' KECUALI proses saya sendiri ($$)
pkill -f "auto_name.sh" 2>/dev/null || true

# ... lanjut ke kode swaymsg ...
```

  * **`pkill -f "nama_skrip"`**: Cari dan matikan proses yang namanya cocok.
  * **`2>/dev/null`**: Buang pesan error jika tidak ada proses yang ditemukan (agar log bersih).
  * **`|| true`**: Pastikan baris ini tidak menghentikan skrip jika `pkill` gagal (karena tidak ada proses lama).
      * *Catatan: Teknik ini agak kasar (dirty), tapi efektif untuk skrip sederhana.*

-----

### Ringkasan Modul 4

1.  **Event-Driven**: Kita tidak mencari info, kita **berlangganan** (`subscribe`) info.
2.  **Monitor Mode**: Gunakan `swaymsg -t subscribe -m` untuk mendapatkan aliran data terus menerus.
3.  **While Read Loop**: Pola wajib untuk memproses aliran data baris demi baris di Bash.
4.  **Filtering**: Gunakan `jq` untuk memastikan kita hanya bereaksi pada event yang relevan (`change == "focus"`), bukan setiap gerakan mouse.
5.  **Daemon**: Skrip ini berjalan selamanya di latar belakang, jadi hati-hati dengan manajemen proses (`exec_always` vs `exec`).

Anda sekarang sudah bisa membuat Sway Anda "hidup". Ia bisa merespons saat Anda membuka laptop, mencolok monitor, atau membuka aplikasi.

Selanjutnya, di **Modul 5: Integrasi Ekosistem**, kita akan belajar bagaimana skrip Sway ini bisa memicu notifikasi desktop (`mako`), mengubah status bar (`waybar`), atau menampilkan menu interaktif (`wofi`).

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Nich][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../../README.md
[kurikulum]: ../../README.md
[sebelumnya]: ../bagian-3/README.md
[selanjutnya]: ../bagian-5/README.md

<!--
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
