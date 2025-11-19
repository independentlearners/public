# [Modul 3: Integrasi Wofi ke dalam Sway (The Handshake)][0]

Ini adalah tahap di mana sistem operasi Anda mulai terasa "milik Anda". Kita akan menghubungkan "otak" Wofi dengan "saraf" Sway.

-----

Di Sway (dan i3wm), interaksi keyboard adalah raja. Kita tidak menjalankan aplikasi dengan mengklik ikon menu start, melainkan dengan menekan kombinasi tombol (*keybinding*). Tujuan modul ini adalah menggantikan `dmenu` (launcher default yang kuno) dengan Wofi yang baru saja kita konfigurasi.

### 1\. Konsep Teknis: Variables & Bindings di Sway

Sebelum menyentuh file konfigurasi Sway, pahami dulu dua konsep ini:

1.  **Variables (`set $nama nilai`):**
    Sway mengizinkan kita membuat "wadah" untuk perintah yang panjang. Ini membuat konfigurasi rapi. Biasanya, launcher disimpan dalam variabel bernama `$menu`.
2.  **Keybindings (`bindsym`):**
    Perintah untuk mengikat kombinasi tombol fisik ke sebuah aksi.
      * Sintaks: `bindsym [Modifier]+[Key] exec [Command]`
      * **Modifier:** Biasanya `$mod` (Tombol Windows/Super) atau `Mod1` (Alt).

**Mengapa mengganti dmenu?**
`dmenu` aslinya dibuat untuk X11. Meskipun ada versi Wayland, Wofi menawarkan fitur modern seperti ikon, mode CSS, dan pencarian fuzzy yang lebih baik tanpa perlu *patching* rumit.

-----

### 2\. English Corner: Connectors & Key Terms

Bagian ini penting agar Anda bisa menulis komentar (*comments*) yang profesional di dalam file konfigurasi Anda sendiri.

#### **A. Key Vocabulary**

| Word | Part of Speech | Definition (ID) | Context Example |
| :--- | :--- | :--- | :--- |
| **Binding** | Noun | Pengikatan tombol keyboard. | *Check your key **bindings** for conflicts.* |
| **Modifier** | Noun | Tombol pengubah (Ctrl, Alt, Super). | *Use the Super key as the main **modifier**.* |
| **Comment out** | Phrasal Verb | Menonaktifkan kode dengan tanda `#`. | *You should **comment out** the old dmenu line.* |
| **Execute** | Verb | Menjalankan perintah. | *This binding will **execute** the script.* |
| **Replacement** | Noun | Pengganti. | *Wofi is a modern **replacement** for dmenu.* |

#### **B. Grammar Focus: Connectors (Kata Hubung)**

Menggunakan kata hubung membuat penjelasan logika menjadi mengalir.

  * **Therefore (Oleh karena itu):** Menunjukkan hasil/akibat.
      * *Context:* dmenu is outdated. **Therefore**, we use Wofi.
  * **Instead of (Alih-alih/Daripada):** Menunjukkan penggantian.
      * *Context:* Use Wofi **instead of** dmenu for better UI.
  * **However (Akan tetapi):** Menunjukkan kontradiksi/catatan penting.
      * *Context:* You can use any key. **However**, standard practice uses `$mod+d`.

#### **C. Professional Interaction**

Contoh kalimat saat mendokumentasikan perubahan di file config Anda (Best Practice):

> `# Dmenu is deprecated for this setup. Therefore, I replaced it with Wofi to utilize GTK styling.`

-----

### 3\. Implementasi: Mengedit Sway Config

Mari kita terapkan di terminal.

**Langkah 1: Buka Konfigurasi Sway**

```bash
nano ~/.config/sway/config
```

**Langkah 2: Temukan dan Matikan (Comment Out) dmenu**
Cari baris yang mendefinisikan `$menu`. Biasanya terlihat seperti ini:
`set $menu dmenu_path | dmenu | xargs swaymsg exec --`

Ubah menjadi komentar (tambahkan `#` di depan):

```bash
# set $menu dmenu_path | dmenu | xargs swaymsg exec --
```

**Langkah 3: Definisikan Wofi sebagai Menu Baru**
Tepat di bawah baris yang baru saja Anda matikan, tambahkan baris ini:

```bash
# Set Wofi as the default launcher
# Kita menggunakan --show drun agar Wofi mencari aplikasi desktop
set $menu wofi --show drun
```

*Catatan:* Karena kita sudah membuat file `~/.config/wofi/config` di Modul 2, kita tidak perlu menulis parameter panjang seperti `--width` atau `--height` di sini. Sway cukup memanggil `wofi`, dan Wofi akan membaca konfigurasi internalnya sendiri. Rapi, bukan?

**Langkah 4: Pastikan Binding Sudah Benar**
Cari baris `bindsym`. Biasanya default-nya adalah:

```bash
bindsym $mod+d exec $menu
```

Jika baris ini sudah ada, Anda tidak perlu mengubahnya. Artinya, saat Anda menekan `Super+d`, Sway akan mengeksekusi isi variabel `$menu` (yang sekarang adalah Wofi).

**Langkah 5: Simpan dan Validasi**

1.  Simpan file (Ctrl+O) dan Keluar (Ctrl+X).
2.  **Sangat Penting:** Validasi konfigurasi sebelum reload untuk mencegah Sway crash.
    ```bash
    sway -C
    ```
    *(Jika tidak ada output error, berarti aman).*

**Langkah 6: Reload Sway (Tanpa Logout)**
Gunakan perintah ini agar perubahan aktif seketika:

```bash
swaymsg reload
```

Sekarang, cobalah tekan `Super+d` (atau tombol Modifer+d Anda). Wofi yang elegan seharusnya muncul\!

-----

### 4\. Sumber Resmi (Official Resources)

Referensi untuk konfigurasi Sway:

1.  **Sway Config Man Page:** Ketik `man 5 sway`.
      * Cari bagian `CRITERIA` atau `BINDINGS` untuk pemahaman mendalam.
2.  **Swaymsg:** Ketik `man 1 swaymsg`.
      * Ini adalah alat komunikasi CLI untuk mengirim pesan ke Sway yang sedang berjalan (seperti perintah `reload` tadi).

-----

### 5\. Error Handling & Troubleshooting

Apa yang harus dilakukan jika Wofi tidak muncul saat `Super+d` ditekan?

**Masalah 1: "Error: Unknown/Invalid Command 'wofi'"**

  * **Analisis:** Sway tidak menemukan *executable* wofi di `$PATH`.
  * **Solusi:** Coba ketik `which wofi` di terminal. Jika kosong, berarti instalasi (Modul 1) gagal. Jika ada, coba restart komputer (terkadang PATH butuh refresh sesi).

**Masalah 2: Red Bar (Error Bar) di atas layar Sway**

  * **Analisis:** Ada salah ketik di file konfigurasi Sway (`~/.config/sway/config`).
  * **Solusi:**
    1.  Jalankan `sway -C` di terminal untuk melihat detail error.
    2.  Periksa apakah Anda lupa menutup kurung atau salah eja `bindsym`.

**Masalah 3: Wofi muncul tapi langsung menutup sendiri**

  * **Analisis:** Ini sering terjadi karena masalah fokus di Wayland. Wofi kehilangan fokus input dan menutup diri.
  * **Solusi:** Di file `~/.config/sway/config`, tambahkan aturan khusus untuk jendela ("window rules") agar Wofi melayang (*floating*):
    ```bash
    for_window [app_id="wofi"] floating enable
    ```
    *Penjelasan:* `app_id` adalah cara Wayland mengenali aplikasi (pengganti `class` di X11).

-----

**Next Step:**
Anda sekarang sudah memiliki launcher fungsional yang terintegrasi. Namun, Wofi bukan hanya untuk meluncurkan aplikasi. Wofi bisa menjadi **Power Menu** (Shutdown/Reboot), **Wifi Menu**, atau **Clipboard Manager**.

Ini membutuhkan kemampuan *scripting* dan pemahaman *pipes* (`|`) di Linux.

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Nich][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../../README.md
[kurikulum]: ../../README.md
[sebelumnya]: ../bagian-2/README.md
[selanjutnya]: ../bagian-4/README.md

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
