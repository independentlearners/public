<!--
<details>
  <summary>📃 Daftar Isi</summary>

</details>
-->

Ini adalah ujian terakhir. Kita akan menggabungkan semua yang telah kita pelajari: `swaymsg`, `jq`, `wofi`, `bash`, dan logika pemrograman menjadi satu alat yang sangat berguna.

Kita memilih proyek ini karena ini memecahkan masalah nyata pengguna *tiling window manager*: **"Kita punya terlalu banyak jendela dan kita lupa menaruh Firefox di mana."**

Kita akan membangun: **The Window Teleporter**.

-----

## 🏆 Modul 7: Proyek Akhir (Capstone) — "The Window Teleporter"

**Misi:**
Membuat skrip yang:

1.  Mencari **semua** jendela yang terbuka di seluruh workspace.
2.  Menampilkannya dalam menu daftar yang rapi menggunakan `wofi`.
3.  Saat dipilih, jendela tersebut akan **ditarik** (dipindahkan) ke workspace Anda saat ini dan langsung difokuskan.

-----

### Langkah 1: Strategi Data (Membedah `jq`)

Tantangan terbesar adalah mengambil data pohon (`get_tree`) dan meratakannya menjadi daftar teks yang bisa dibaca manusia.

Kita butuh format seperti ini agar enak dilihat di Wofi:
`[ID_Jendela] Nama_App: Judul Jendela (di Workspace X)`

Mari kita rakit perintah `jq`-nya.

**Perintah Percobaan (Jalankan di terminal):**

```bash
swaymsg -t get_tree | jq -r '
  ..
  | select(.type? == "con" and .pid?)
  | "\(.id)   [\(.app_id // .window_properties.class)]   \(.name)"
'
```

**Penjelasan Kata-per-Kata (Logika `jq`):**

  * **`..`**: Cari secara rekursif di seluruh pohon.
  * **`select(.type? == "con" and .pid?)`**:
      * `.type? == "con"`: Kita hanya mau *container* (jendela), bukan workspace atau output.
      * `.pid?`: Kita memastikan itu adalah jendela aplikasi nyata yang punya *Process ID*, bukan container kosong placeholder.
  * **`"\(.id) ..."`**: Ini adalah **String Interpolation**.
      * Di dalam `jq`, kita bisa menyisipkan nilai variabel ke dalam string dengan `\(...)`.
      * Kita menyusun string kustom yang berisi ID, Nama Aplikasi, dan Judul.
  * **`\(.app_id // .window_properties.class)`**:
      * Operator **`//`** berarti "ATAU DEFAULT".
      * Aplikasi Wayland murni punya `.app_id`. Aplikasi XWayland (jadul) tidak punya, tapi punya `.window_properties.class`.
      * Logikanya: "Ambil `app_id`, jika kosong/null, ambil `class`".

-----

### Langkah 2: Menyusun Skrip Lengkap

Buat file baru: `~/.config/sway/scripts/teleport_window.sh`.

Berikut adalah kode lengkapnya. Salin ini, lalu kita bedah.

```bash
#!/bin/bash

# --- BAGIAN 1: MENGAMBIL DATA ---
# Kita mengambil daftar jendela dan memformatnya untuk Wofi.
# Format: "ID <TAB> AppName: WindowTitle"
windows=$(swaymsg -t get_tree | jq -r '
    ..
    | select(.type? == "con" and .pid?)
    | "\(.id)\t\(.app_id // .window_properties.class): \(.name)"
')

# Cek: Jika tidak ada jendela, keluar.
if [ -z "$windows" ]; then
    notify-send "Teleporter" "Tidak ada jendela ditemukan!"
    exit 1
fi

# --- BAGIAN 2: INTERAKSI PENGGUNA (WOFI) ---
# Tampilkan daftar ke wofi.
# Kita gunakan -i (case insensitive) dan -d (dmenu mode)
selected=$(echo "$windows" | wofi --show dmenu -i --prompt "Teleport Window:" --width 800)

# Jika pengguna menekan Esc (batal), variabel 'selected' akan kosong.
if [ -z "$selected" ]; then
    exit 0
fi

# --- BAGIAN 3: EKSEKUSI ---
# Variabel '$selected' sekarang berisi string seperti:
# "1234    firefox: Google Search"

# Kita perlu mengekstrak ANGKA di depan (1234) karena itu adalah ID yang dimengerti Sway.
# Kita gunakan 'awk' untuk mengambil kolom pertama.
window_id=$(echo "$selected" | awk '{print $1}')

# Pindahkan jendela tersebut ke workspace saat ini dan fokuskan
swaymsg "[con_id=$window_id] move workspace current"
swaymsg "[con_id=$window_id] focus"
```

-----

### Langkah 3: Analisis Kode Mendalam

Mari kita fokus pada bagian yang baru bagi Anda, yaitu **Bagian 3 (Eksekusi)**.

#### 1\. Ekstraksi ID dengan `awk`

```bash
window_id=$(echo "$selected" | awk '{print $1}')
```

  * **Masalah:** `wofi` mengembalikan *seluruh baris* teks yang Anda pilih (misal: `948 firefox: Youtube`). Tapi `swaymsg` hanya butuh ID (`948`).
  * **Solusi (`awk`):** `awk` adalah alat pemroses teks kolom.
  * **`{print $1}`**: Ini memberi tahu awk: "Lihat spasi sebagai pemisah kolom, dan beri saya kolom pertama (`$1`) saja."

#### 2\. Addressing (Pengalamatan) Lanjutan di `swaymsg`

```bash
swaymsg "[con_id=$window_id] move workspace current"
```

Di Modul 1, kita menggunakan `swaymsg focus left`. Itu relatif.
Di sini, kita menggunakan **Criteria Addressing**.

  * **`[...]`**: Kurung siku memberi tahu Sway: "Saya tidak bicara tentang jendela yang *sekarang* fokus. Saya bicara tentang jendela spesifik yang cocok dengan kriteria ini."
  * **`con_id=$window_id`**: "Cari jendela yang ID internalnya sama dengan variabel `$window_id`."
  * **`move workspace current`**: "Tarik jendela tersebut ke workspace yang sedang saya lihat sekarang."

-----

### Langkah 4: Instalasi dan Pengujian

1.  **Simpan file** tersebut di `~/.config/sway/scripts/teleport_window.sh`.
2.  **Beri izin eksekusi:**
    ```bash
    chmod +x ~/.config/sway/scripts/teleport_window.sh
    ```
3.  **Edit Config Sway (`~/.config/sway/config`):**
    Tambahkan binding tombol yang nyaman. Contoh `Super + t` (untuk Teleport).
    ```sway
    bindsym $mod+t exec ~/.config/sway/scripts/teleport_window.sh
    ```
4.  **Reload Sway:** `swaymsg reload`.

**Cara Menguji:**

1.  Buka terminal di Workspace 1.
2.  Buka Browser di Workspace 2.
3.  Pindah ke Workspace 3 (kosong).
4.  Tekan `$mod+t`.
5.  Ketik "fire" (untuk firefox) atau "term" (untuk terminal).
6.  Tekan Enter.
7.  *Bim salabim\!* Jendela tersebut pindah ke hadapan Anda di Workspace 3.

-----

## 🎓 Penutup Kelas

Selamat\! Anda telah menyelesaikan kurikulum **Master Scripting Sway**.

Mari kita rekap perjalanan Anda:

1.  **Modul 0:** Anda memahami bahwa Sway dikendalikan lewat Socket IPC, bukan sihir.
2.  **Modul 1:** Anda menguasai `swaymsg` untuk memberi perintah dan bertanya.
3.  **Modul 2:** Anda belajar `jq` untuk membedah data JSON yang rumit.
4.  **Modul 3:** Anda mengintegrasikan skrip ke config dengan argumen (`$1`).
5.  **Modul 4:** Anda membuat skrip "hidup" yang bereaksi otomatis (`subscribe`).
6.  **Modul 5:** Anda menambahkan GUI (`wofi`, `notify-send`) agar skrip manusiawi.
7.  **Modul 6:** Anda tahu cara *debug* saat ada masalah (`>> log.txt`).
8.  **Modul 7:** Anda menggabungkan semuanya menjadi alat produktivitas nyata.

-----

> - **[Sebelumnya][sebelumnya]**
> - **[Nich][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../../README.md
[kurikulum]: ../../README.md
[sebelumnya]: ../bagian-6/README.md

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
