<!--
<details>
  <summary>📃 Daftar Isi</summary>

</details>

#
Kita telah belajar cara berbicara dengan Sway (`swaymsg`) dan cara mendengarkan Sway (`subscribe`).

Sekarang di **Modul 5**, kita akan belajar cara berbicara dengan **Manusia** (Anda).

Skrip yang baik tidak hanya berjalan; ia berinteraksi. Ia memberikan pilihan (Menu), memberi laporan (Notifikasi), atau memperingatkan jika terjadi kesalahan (Swaynag).

-----

-->
## 🛠️ Modul 5: Integrasi Ekosistem (Tools Pendukung)

Ekosistem Wayland terdiri dari alat-alat modular. Kita tidak menggunakan fitur bawaan Sway (karena minim), melainkan alat eksternal yang bekerja sama melalui standar Unix (pipes dan text streams).

### 5.1: `wofi` — Membuat Menu Interaktif

Di Sway, kita tidak punya "klik kanan menu" atau dialog pop-up bawaan. Kita menggunakan **Launcher**. Alat paling populer di Sway adalah `wofi` (atau `rofi` versi Wayland).

Fitur paling kuat dari `wofi` adalah **dmenu mode**. Ini mengubah `wofi` dari sekadar peluncur aplikasi menjadi "pemilih teks grafis".

**Konsep Dasar:**

1.  Anda mengirim daftar teks ke `wofi` (lewat pipe `|`).
2.  `wofi` menampilkannya sebagai menu yang bisa dipilih.
3.  Saat Anda memilih satu, `wofi` mencetak teks itu ke *output*.

#### Contoh Skrip: Power Menu (`powermenu.sh`)

Kita akan membuat menu untuk Shutdown/Reboot.

```bash
#!/bin/bash

# 1. Definisikan pilihan
entries="⏻ Shutdown\n🔄 Reboot\n🔒 Lock\n🚪 Logout"

# 2. Tampilkan menu dan simpan pilihan pengguna ke variabel
selected=$(echo -e "$entries" | wofi --show dmenu --width 200 --height 200 --prompt "Power Menu")

# 3. Eksekusi perintah berdasarkan pilihan
case $selected in
  "⏻ Shutdown")
    exec systemctl poweroff;;
  "🔄 Reboot")
    exec systemctl reboot;;
  "🔒 Lock")
    exec swaylock -f -c 000000;;
  "🚪 Logout")
    exec swaymsg exit;;
esac
```

**Penjelasan Kata-per-Kata:**

  * **`entries="..."`**: Variabel string biasa.
  * **`\n`**: *Newline* (Baris baru). Ini pemisahnya. `wofi` akan melihat setiap baris baru sebagai satu opsi menu.
  * **`echo -e`**:
      * `echo`: Cetak teks.
      * `-e`: *Enable interpretation of backslash escapes*. Tanpa `-e`, bash akan mencetak `\n` sebagai huruf literal, bukan baris baru, dan menu Anda akan gagal.
  * **`|`**: Pipe. Kirim teks tadi ke `wofi`.
  * **`wofi`**: Panggil program menu.
      * **`--show dmenu`**: Mode wajib untuk membaca dari *pipe* (stdin). Jangan gunakan mode `drun` atau `run` di sini.
      * **`--width` / `--height`**: Ukuran jendela menu (opsional).
      * **`--prompt "..."`**: Teks judul di bagian atas menu.
  * **`case $selected in ... esac`**: Struktur kontrol Bash (Switch-Case). Lebih rapi daripada banyak `if-else`.
      * Ini mencocokkan teks yang dipilih pengguna (misal "⏻ Shutdown") dengan tindakan yang sesuai.
      * **`;;`**: Menandakan akhir dari satu blok tindakan.

-----

### 5.2: `notify-send` — Memberi Umpan Balik

Skrip latar belakang bekerja dalam diam. Jika Anda menekan tombol untuk mengambil *screenshot*, bagaimana Anda tahu itu berhasil? Kita butuh notifikasi.

Alat standar: **`notify-send`** (bagian dari paket `libnotify-bin`).
Daemon penampil (yang menggambar kotak notifikasi): **`mako`** atau **`dunst`**.

**Contoh Penggunaan:**

```bash
notify-send -u critical -t 3000 "Sway Script" "Gagal terhubung ke monitor!"
```

**Penjelasan Kata-per-Kata:**

  * **`notify-send`**: Perintah pengirim pesan.
  * **`-u critical`**: *Urgency* (Urgensi).
      * `low`: Mungkin tidak tampil jika Anda sedang sibuk (Do Not Disturb).
      * `normal`: Standar.
      * `critical`: Biasanya berwarna merah, tampil di atas aplikasi fullscreen, dan tidak hilang sampai diklik (tergantung konfigurasi `mako` Anda).
  * **`-t 3000`**: *Time* (Waktu). Kedaluwarsa dalam 3000 milidetik (3 detik).
  * **`"Sway Script"`**: Argumen pertama adalah **Judul** notifikasi (teks tebal).
  * **`"Gagal..."`**: Argumen kedua adalah **Isi Pesan**.

-----

### 5.3: `swaynag` — Error Handling "Native"

Ini adalah permata tersembunyi. Pernahkah Anda membuat kesalahan di config Sway lalu muncul baris kuning di bagian atas layar? Itu adalah **`swaynag`**.

Berita baiknya: Anda bisa menggunakan `swaynag` di dalam skrip Anda sendiri\! Ini bagus untuk meminta konfirmasi berbahaya.

#### Contoh Skrip: Konfirmasi Hapus File

```bash
#!/bin/bash

# Tampilkan bar kuning. Jika user klik "Yes", jalankan perintah hapus.
swaynag -t warning -m "Anda yakin ingin menghapus file ini?" -b "Yes, Delete" "rm /tmp/penting.txt"
```

**Penjelasan Kata-per-Kata:**

  * **`swaynag`**: Program bar notifikasi bawaan Sway.
  * **`-t warning`**: *Type*. Menentukan warna (biasanya kuning untuk warning, merah untuk error).
  * **`-m "..."`**: *Message*. Teks yang tampil di bar.
  * **`-b "Tombol" "Perintah"`**: *Button*. Ini bagian ajaibnya.
      * Argumen pertama (`"Yes, Delete"`): Teks yang tertulis di tombol yang bisa diklik.
      * Argumen kedua (`"rm ..."`): Perintah terminal yang akan dijalankan **JIKA DAN HANYA JIKA** tombol tersebut diklik.
      * Jika pengguna mengabaikan bar atau mengklik tombol "X" (tutup), perintah "rm" tidak akan pernah dijalankan.

-----

### 5.4: Integrasi Waybar (Custom Modules)

Banyak pengguna Sway menggunakan **Waybar**. Waybar bisa menjalankan skrip kustom (Custom Modules). Agar terlihat bagus, skrip Anda harus mengeluarkan output dalam format **JSON**.

**Target:** Modul yang menampilkan jumlah jendela yang terbuka di workspace saat ini.

**Skrip (`count_windows.sh`):**

```bash
#!/bin/bash

# Hitung jumlah node (jendela) di workspace yang sedang fokus
count=$(swaymsg -t get_tree | jq -r '.. | select(.type? == "workspace" and .focused == true) | .. | select(.type? == "con") | .id' | wc -l)

# Output JSON untuk Waybar
# "text": Apa yang tampil di bar
# "tooltip": Apa yang tampil saat mouse di-hover
# "class": Untuk pewarnaan CSS (misal: jadi merah jika banyak jendela)

if [ "$count" -gt 5 ]; then
    css_class="critical"
else
    css_class="normal"
fi

echo "{\"text\": \"$count 🪟\", \"tooltip\": \"$count jendela terbuka\", \"class\": \"$css_class\"}"
```

**Penjelasan Kata-per-Kata (Baris `echo`):**

  * **`echo "..."`**: Mencetak satu baris teks.
  * **`{\"text\": ...}`**: Struktur JSON manual. Perhatikan kita harus menggunakan *escape character* (`\"`) untuk tanda kutip di dalam string JSON agar tidak bentrok dengan tanda kutip Bash.
  * **Waybar** akan membaca JSON ini setiap interval detik tertentu dan memperbarui tampilannya.

-----

### Ringkasan Modul 5

  * Gunakan **`wofi --dmenu`** untuk mendapatkan *input* pilihan dari pengguna.
  * Gunakan **`notify-send`** untuk laporan status pasif.
  * Gunakan **`swaynag`** untuk peringatan kritis atau konfirmasi tindakan ("Apakah Anda yakin?").
  * Gunakan **output JSON** jika Anda membuat skrip untuk ditampilkan di status bar (Waybar).

Anda sekarang memiliki kotak perkakas lengkap:

1.  Bicara ke Sway (`swaymsg`).
2.  Analisis Data (`jq`).
3.  Otomatisasi (`subscribe/daemon`).
4.  Interaksi User (`wofi`/`swaynag`).

-----

Kita akan masuk ke **Modul 6: Debugging**. Ini adalah modul yang Anda minta secara spesifik: "Bagaimana jika semua ini gagal?"

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Nich][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../../README.md
[kurikulum]: ../../README.md
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
