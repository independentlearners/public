## [Modul 4: Advanced Scripting & Custom Menus (CLI Focus)][0]

Sekarang kita memasuki wilayah "Power User". Jika Modul 1-3 adalah tentang *menginstal* dan *mengonfigurasi* alat orang lain, Modul 4 adalah tentang *menciptakan* alat Anda sendiri.

-----

Wofi memiliki mode rahasia yang disebut **dmenu mode**. Dalam mode ini, Wofi tidak mencari aplikasi. Ia menjadi "bodoh". Ia hanya duduk diam menunggu Anda memberinya daftar teks, dan ketika Anda memilih satu, ia akan memuntahkan teks itu kembali kepada Anda.

Ini adalah inti dari filosofi Unix: **Pipes (`|`)**.

### 1\. Identitas dan Konsep Teknis (Technical Deep Dive)

**Bagaimana cara kerjanya?**
Kita menggunakan konsep Input/Output standar Linux:

1.  **STDIN (Standard Input):** Kita "menyuapkan" daftar opsi ke Wofi.
2.  **Wofi UI:** Wofi menampilkan opsi tersebut secara visual.
3.  **STDOUT (Standard Output):** Saat Anda menekan Enter, Wofi mencetak pilihan Anda ke terminal.

**Sintaks Dasar:**

```bash
echo -e "Opsi 1\nOpsi 2" | wofi --show dmenu
```

  * `echo -e`: Mencetak teks (`-e` mengizinkan `\n` sebagai baris baru).
  * `|`: Pipa. Mengambil output dari perintah kiri, dan memasukkannya ke input perintah kanan.
  * `--show dmenu`: Memberitahu Wofi untuk tidak mencari aplikasi, tapi membaca input dari pipa.

-----

### 2\. English Corner: Scripting Logic

Saat menulis skrip, kita sering berbicara tentang logika dan alur. Ini kosa kata wajib bagi programmer.

#### **A. Key Vocabulary**

| Word | Part of Speech | Definition (ID) | Context Example |
| :--- | :--- | :--- | :--- |
| **Variable** | Noun | Wadah penyimpan data sementara. | *Store the user's choice in a **variable**.* |
| **Echo** | Verb | Menampilkan/mencetak teks ke output. | *First, **echo** the menu options.* |
| **Pipe** | Noun/Verb | Mengalirkan data dari satu proses ke proses lain. | *We need to **pipe** the list into Wofi.* |
| **Case Statement** | Noun | Struktur logika percabangan (Switch-Case). | *Use a **case statement** to handle multiple options.* |
| **Executable** | Adjective | Bisa dijalankan sebagai program. | *Make the script **executable** with chmod.* |

#### **B. Grammar Focus: Sequence Markers (Penanda Urutan)**

Saat menjelaskan algoritma skrip, gunakan kata-kata ini untuk menjabarkan langkah-langkahnya secara profesional:

1.  **Firstly/Initially:** Langkah pertama.
2.  **Subsequently/Then:** Langkah selanjutnya.
3.  **Finally/Ultimately:** Langkah terakhir.

*Contoh:*

> *"**Firstly**, the script defines the variables. **Then**, it pipes them into Wofi. **Finally**, it executes the command based on the user's selection."*

#### **C. Professional Interaction**

Menjelaskan skrip Anda kepada rekan kerja:

> *"I created a custom bash script for system power management. It utilizes Wofi as the frontend interface and executes systemctl commands based on the standard output."*

-----

### 3\. Implementasi: Membuat "Power Menu" (Shutdown/Reboot)

Kita akan membuat menu elegan untuk mematikan laptop, karena mengetik `shutdown now` setiap kali itu melelahkan.

**Langkah 1: Siapkan Folder Script**
Sebagai pengguna Arch yang rapi, kita simpan script pribadi di `~/.local/bin`.

```bash
mkdir -p ~/.local/bin
```

**Langkah 2: Tulis Script**
Gunakan editor teks favorit Anda:

```bash
nano ~/.local/bin/wofi-power.sh
```

Salin kode berikut. Saya telah menyertakan komentar penjelasan dalam bahasa Inggris teknis agar Anda terbiasa.

```bash
#!/bin/bash

# 1. Define the menu options (Variables)
# Kita pakai emoji agar estetik
shutdown="  Shutdown"
reboot="  Reboot"
lock="  Lock"
logout="  Logout"

# 2. Pipe options into Wofi (The Pipeline)
# Variabel $options menampung semua pilihan, dipisahkan baris baru (\n)
options="$shutdown\n$reboot\n$lock\n$logout"

# Jalankan wofi dalam mode dmenu.
# Kita simpan hasil pilihan user ke variabel 'selected'
selected=$(echo -e "$options" | wofi --show dmenu --prompt "Power Menu" --width 250 --height 210 --cache-file /dev/null)

# 3. Execute command based on selection (Case Statement)
# Bash akan mencocokkan isi variabel $selected dengan pola yang ada
case $selected in
    "$shutdown")
        systemctl poweroff
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$lock")
        # Asumsi Anda menggunakan swaylock. Ganti jika pakai tool lain.
        swaylock -f -c 000000
        ;;
    "$logout")
        swaymsg exit
        ;;
esac
```

*Simpan (Ctrl+O) dan Keluar (Ctrl+X).*

**Langkah 3: Make it Executable (Wajib\!)**
Script tidak akan jalan jika tidak punya izin eksekusi.

```bash
chmod +x ~/.local/bin/wofi-power.sh
```

**Langkah 4: Uji Coba Manual**
Jalankan langsung dari terminal untuk memastikan tidak ada error sintaks.

```bash
~/.local/bin/wofi-power.sh
```

Jika muncul menu kecil dan tombolnya berfungsi (coba pilih "Lock" dulu agar PC tidak mati), script sukses.

**Langkah 5: Integrasi ke Sway**
Sekarang kita ikat ke tombol keyboard, misal `Super+Shift+e` (standar i3/Sway untuk exit).

Buka config sway: `nano ~/.config/sway/config`
Tambahkan/Edit baris ini:

```bash
# Power Menu
bindsym $mod+Shift+e exec ~/.local/bin/wofi-power.sh
```

*Reload sway (`swaymsg reload`), dan tes tombolnya.*

-----

### 4\. Sumber Resmi (Official References)

1.  **Bash Scripting:** `man bash`.
      * Baca bagian `Compound Commands` untuk memahami sintaks `case`.
2.  **Wofi Dmenu:** `man wofi`.
      * Cari opsi `--dmenu`. Ini menjelaskan bagaimana Wofi membaca dari *stdin*.

-----

### 5\. Error Handling & Troubleshooting

Menangani masalah saat scripting adalah skill vital.

**Error A: "Permission denied"**

  * **Penyebab:** Anda lupa langkah `chmod +x`.
  * **Solusi:** Jalankan `chmod +x /path/to/script`.
  * **English Term:** *Executable bit missing.*

**Error B: Menu muncul, tapi tidak terjadi apa-apa saat diklik**

  * **Penyebab:** String di dalam `case` tidak cocok persis dengan output Wofi.
  * **Analisis:** Bash sangat sensitif. Jika di variabel ada spasi tambahan atau ikon berbeda dengan yang di `case`, perintah tidak jalan.
  * **Debugging:** Tambahkan `echo "You selected: $selected"` sebelum bagian `case` di script, lalu jalankan lewat terminal untuk melihat apa yang sebenarnya ditangkap oleh variabel.

**Error C: "Command not found" saat menekan tombol**

  * **Penyebab:** Sway tidak tahu di mana script itu berada.
  * **Solusi:** Gunakan *full path* (`/home/username/.local/bin/...`) di config sway, atau pastikan folder `~/.local/bin` sudah ada di `$PATH` Linux Anda.

-----

**Next Step:**
Anda baru saja membuat *custom power menu* yang murni CLI-based namun dengan tampilan GUI.

Modul terakhir adalah tentang bagaimana kita memastikan Wofi Anda tetap sehat, cara merawatnya, dan memahami limitasinya agar Anda tahu kapan harus berhenti mengoprek.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

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
