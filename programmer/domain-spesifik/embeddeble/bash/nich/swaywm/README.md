# Silabus: Kelas Master Scripting Sway

### 🏛️ Modul 0: Prasyarat dan Landasan (Foundation)

Sebelum kita menyelam ke Sway, kita perlu memastikan fondasi kita kuat. Modul ini adalah tentang *konteks* skrip di dalam Sway.

* **Sub-modul 0.1:** Apa itu *Sway IPC*? Memahami konsep "Inter-Process Communication" sebagai jantung dari scripting Sway.
* **Sub-modul 0.2:** *Environment* Skrip: Mengapa `~/.bashrc` Anda tidak berlaku? Memahami perbedaan antara *shell environment* dan *Sway environment* (Perbedaan `PATH`, variabel, dll).
* **Sub-modul 0.3:** Peralatan Inti: Mempersiapkan *toolset* (Bash, `jq`, `grep`, `sed`).

---

### 💬 Modul 1: `swaymsg` — Juru Bicara Anda ke Sway

Modul ini adalah inti dari segalanya. **`swaymsg`** adalah *satu-satunya* alat yang Anda perlukan untuk berkomunikasi dengan Sway yang sedang berjalan.

* **Sub-modul 1.1:** *One-liners*: Menjalankan perintah sederhana (`focus`, `move`, `layout`, `exec`).
* **Sub-modul 1.2:** *Querying State* (Mengambil Data): Menggunakan `swaymsg -t get_workspaces`, `get_outputs`, `get_tree` untuk "melihat" apa yang sedang Sway pikirkan.
* **Sub-modul 1.3:** Konsep *Command Chaining*: Menggabungkan beberapa perintah dalam satu panggilan `swaymsg`.

---

### parsing Modul 2: `jq` — Membedah JSON dari Sway

Output dari `swaymsg` (dari Modul 1.2) adalah JSON. Untuk membuat skrip yang cerdas, kita harus bisa membacanya. Ini adalah *skill khusus* yang memisahkan skrip Sway dasar dan lanjutan.

* **Sub-modul 2.1:** Pengantar `jq`: "sed/awk" untuk JSON.
* **Sub-modul 2.2:** Resep `jq`: Menemukan *window ID* yang sedang fokus, *nama workspace* saat ini, *output* (monitor) yang aktif.
* **Sub-modul 2.3:** Logika Kondisional: Menulis skrip `if-then-else` di Bash berdasarkan output `jq` (Contoh: "Jika jendela ini adalah Firefox, pindahkan ke workspace 2").

---

### 🚀 Modul 3: Dari Konfig ke Skrip (Integrasi)

Bagaimana Sway *menjalankan* skrip Anda? Modul ini menghubungkan file `config` Anda dengan skrip eksternal.

* **Sub-modul 3.1:** `bindsym` vs. `exec`: Kapan menggunakan yang mana?
* **Sub-modul 3.2:** *Best Practice*: Di mana menyimpan skrip Anda (`~/.config/sway/scripts`) dan membuatnya *executable* (`chmod +x`).
* **Sub-modul 3.3:** Melempar Argumen: Membuat skrip generik yang menerima input dari `config` Anda (Contoh: `bindsym $mod+1 exec "move_to_workspace.sh 1"`).

---

### 🔬 Modul 4: Skrip Reaktif (Event-driven)

Ini adalah tingkat lanjut. Daripada *memberi tahu* Sway apa yang harus dilakukan, kita akan *mendengarkan* apa yang Sway lakukan dan bereaksi secara otomatis.

* **Sub-modul 4.1:** Pengantar `swaymsg -t subscribe`: Mendengarkan *event* (kejadian) secara *real-time*.
* **Sub-modul 4.2:** Studi Kasus 1: Membuat skrip *daemon* (berjalan di latar belakang) yang merespons `window::new` atau `window::focus`.
* **Sub-modul 4.3:** Studi Kasus 2: Mengganti nama *workspace* secara dinamis berdasarkan jendela yang terbuka di dalamnya (misal: "1: 🌐" jika Firefox terbuka).

---

### 🛠️ Modul 5: Integrasi Ekosistem (Tools Pendukung)

Skrip Anda tidak hidup dalam ruang hampa. Mereka perlu berinteraksi dengan alat lain di ekosistem Wayland.

* **Sub-modul 5.1:** *Launchers*: Membuat menu dinamis dengan `wofi` / `rofi` (Contoh: Skrip "Power Menu" [Shutdown, Reboot, Lock]).
* **Sub-modul 5.2:** *Notifications*: Mengirim notifikasi dari skrip Anda menggunakan `mako` / `dunst`.
* **Sub-modul 5.3:** *Error Handling*: Menggunakan **`swaynag`** di dalam skrip Anda untuk menampilkan pesan error yang *native* di Sway jika terjadi kegagalan.
* **Sub-modul 5.4:** *Status Bar*: Membuat modul kustom untuk `waybar` atau `i3status` menggunakan output dari skrip Anda.

---

### 🩺 Modul 6: Debugging — "Kenapa Skrip Saya Tidak Jalan?"

Sesuai permintaan Anda, modul ini fokus pada pemecahan masalah. Tujuannya adalah agar Anda tahu *apa yang harus dilakukan* saat terjadi error.

* **Sub-modul 6.1:** "Berhasil di Terminal, Gagal di Sway": Masalah klasik `PATH` dan *environment variables*.
* **Sub-modul 6.2:** *Logging*: Cara terbaik untuk mencatat *output* skrip untuk dianalisis (menggunakan `tee`, `>> logfile.txt`, dan `systemd journal`).
* **Sub-modul 6.3:** Membaca *Sway's Debug Log* (`sway -d`): Menemukan pesan error dari Sway itu sendiri.
* **Sub-modul 6.4:** *Common Pitfalls*: Menganalisis kesalahan umum (masalah *quoting*, asumsi asinkron, dll).
* **Sub-modul 6.5:** *Swaynag for Debugging*: Menggunakan `swaynag` sebagai "printf" versi Sway untuk melihat nilai variabel saat skrip dieksekusi.

---

### 🏆 Modul 7: Proyek Akhir (Capstone)

Menggabungkan semua yang telah dipelajari untuk membangun satu skrip canggih dari awal hingga akhir.

* **Pilihan Proyek A:** *Smart Layout Toggler* (Skrip yang beralih antara *layout* berbeda berdasarkan jumlah jendela di *workspace*).
* **Pilihan Proyek B:** *Dynamic Output Manager* (Skrip yang otomatis mengonfigurasi monitor saat dicolok/dicabut, menggunakan *event subscriber*).
* **Pilihan Proyek C:** *Wofi Session Manager* (Skrip `wofi` yang terintegrasi untuk menyimpan dan memulihkan sesi jendela).

---

# 🏛️ Modul 0: Prasyarat dan Landasan

Modul ini adalah tentang "konteks". Kita tidak akan menulis skrip yang rumit dulu, tetapi kita akan memahami *lingkungan* tempat skrip kita akan dijalankan.

### 0.1: Apa itu Sway IPC?

Ini adalah konsep **paling penting** yang harus Anda pahami.

  * **Apa itu IPC?**
    IPC adalah singkatan dari **Inter-Process Communication** (Komunikasi Antar-Proses).

  * **Apa Maksudnya?**
    Saat Sway berjalan (Anda melihat *desktop*, *window*, dan *bar* Anda), Sway adalah sebuah **proses** (program yang sedang berjalan) di sistem Anda. Sebut saja ini "Proses Server".

    Jika Anda ingin berinterakasi dengannya (misalnya, memindahkan jendela atau mengubah fokus) dari *luar* file `config`—yaitu dari sebuah skrip—skrip Anda adalah "Proses Klien".

    IPC adalah "bahasa" atau "saluran telepon" yang memungkinkan "Proses Klien" (skrip Anda) berbicara dengan "Proses Server" (Sway yang sedang berjalan).

  * **Bagaimana Cara Kerjanya di Sway?**
    Sway menggunakan mekanisme bernama **Unix Socket**. Anggap saja ini sebagai file khusus di sistem Anda yang bertindak seperti saluran telepon internal. Skrip Anda "menelepon" *socket* ini untuk mengirim perintah, dan Sway "mendengarkan" telepon itu, mengeksekusi perintahnya, dan kadang mengirim balasan.

    > **Analogi:**

    >   * **Sway** adalah Manajer di kantornya (sedang berjalan).
    >   * **Unix Socket** adalah nomor telepon internalnya.
    >   * **Skrip Anda** adalah Asisten di meja lain.
    >   * Anda tidak bisa masuk ke kantor Manajer dan menggerakkan barang-barangnya (mengubah *memory* proses).
    >   * Sebagai gantinya, Anda (Asisten) harus menelepon nomor internal (Socket) dan berkata, "Tolong pindahkan fokus ke jendela di sebelah kanan."

  * **Alat Komunikasi Kita:**
    Kita tidak perlu tahu *cara* menelepon *socket* itu secara manual. Kita punya alat untuk itu: **`swaymsg`**. Ini akan kita bahas tuntas di Modul 1.

**Inti Pembelajaran (Key Takeaway):** Kita tidak "mengedit file" untuk mengontrol Sway. Kita "mengirim pesan" ke proses Sway yang sedang berjalan menggunakan IPC.

-----

### 0.2: Environment Skrip (Masalah Paling Umum)

Ini adalah sumber kebingungan terbesar kedua: **"Skrip saya berjalan di terminal, tapi gagal total saat dijalankan dari config Sway\!"**

  * **Apa itu Environment?**
    Singkatnya, ini adalah sekumpulan variabel yang memberi tahu program di mana harus mencari sesuatu. Variabel yang paling terkenal adalah **`PATH`**.

    Variabel `PATH` adalah daftar direktori (folder) yang dicari oleh *shell* Anda ketika Anda mengetik perintah.

      * Saat Anda mengetik `firefox` di terminal, *shell* Anda mencari di semua folder yang ada di `PATH` Anda sampai menemukan *file executable* bernama `firefox`.

  * **Masalahnya: Dua Environment yang Berbeda**

    1.  **Environment Terminal Anda:** Saat Anda membuka terminal (misal: Kitty, Alacritty), terminal itu akan membaca file seperti `~/.bashrc` atau `~/.zshrc`. Di file inilah Anda biasanya menambahkan `PATH` kustom (misal: `export PATH="$PATH:$HOME/.local/bin"`). Hasilnya, `PATH` Anda **lengkap**.
    2.  **Environment Sway Anda:** Sway (biasanya) **tidak** dijalankan dari terminal interaktif Anda. Sway dijalankan oleh *Display Manager* (GDM, SDDM) atau dari TTY. Akibatnya, Sway **tidak membaca `~/.bashrc` atau `~/.zshrc`**. Sway mewarisi *environment* yang jauh lebih minimalis dan mendasar.

  * **Contoh Skenario Error:**

    1.  Anda membuat skrip keren bernama `volume_up.sh` dan menyimpannya di `/home/user/.local/bin/`.
    2.  Anda membuat *file* itu *executable* (`chmod +x volume_up.sh`).
    3.  Di `~/.bashrc`, Anda punya baris: `export PATH="$PATH:/home/user/.local/bin"`.
    4.  **Tes di Terminal:** Anda buka terminal, ketik `volume_up.sh`. **Berhasil\!**
    5.  **Implementasi di Sway:** Anda buka `~/.config/sway/config` dan menambahkan:
        ```
        bindsym XF86AudioRaiseVolume exec "volume_up.sh"
        ```
    6.  Anda menekan tombol *Volume Up*. **Gagal. Tidak terjadi apa-apa.**

  * **Mengapa Gagal?**
    Karena saat Sway menjalankan perintah `exec`, Sway menggunakan `PATH`-nya sendiri yang minimalis. `PATH` Sway tidak tahu-menahu tentang `/home/user/.local/bin/`. Sway mencari `volume_up.sh` di `/usr/bin` dan `/bin` (standar), tidak menemukannya, dan menyerah.

  * **Solusi (Untuk Saat Ini):**
    Selalu gunakan **path absolut** (path lengkap) di dalam file konfigurasi Sway Anda.

      * **Salah:** `exec "volume_up.sh"`
      * **Benar:** `exec "/home/user/.local/bin/volume_up.sh"`
      * **Lebih Baik (Portabel):** `exec "$HOME/.local/bin/volume_up.sh"` (Karena `$HOME` biasanya diatur dengan benar bahkan di *environment* minimal).

**Inti Pembelajaran:** Jangan pernah berasumsi Sway memiliki `PATH` yang sama dengan terminal Anda. Gunakan *path* absolut untuk skrip Anda di dalam file `config`.

-----

### 0.3: Peralatan Inti (Toolset)

Untuk menjadi master *scripting* Sway, kita tidak hanya butuh Sway. Kita butuh "geng" pendukung. Ini adalah *toolset* wajib Anda:

1.  **`bash`** (atau `sh`)

      * **Peran:** "Lem" atau "Otak"
      * **Penjelasan:** Ini adalah bahasa skrip itu sendiri. Ini yang kita gunakan untuk menulis logika `if ... then ... else`, *loops*, dan menggabungkan perintah lain. Kita akan fokus pada `bash` yang kompatibel dengan POSIX `sh` agar skrip kita cepat dan portabel.

2.  **`swaymsg`**

      * **Peran:** "Telepon IPC"
      * **Penjelasan:** Ini adalah *client* resmi untuk berbicara dengan *server* IPC Sway. Alat ini sudah terinstal bersama Sway. Ini adalah inti dari Modul 1.

3.  **`jq`**

      * **Peran:** "Penerjemah JSON"
      * **Penjelasan:** Ini adalah alat yang **WAJIB DIINSTAL**. Saat Anda *bertanya* kepada Sway (misal: "Jendela apa yang sedang fokus?"), Sway tidak menjawab dalam bahasa manusia. Sway menjawab dalam format data terstruktur yang disebut **JSON**.
      * JSON terlihat seperti ini: `{"id": 123, "name": "Firefox", "focused": true}`.
      * Mencoba mem-parsing ini dengan alat teks biasa (seperti `grep`) adalah resep bencana. `jq` adalah alat *spesialis* untuk memfilter, membedah, dan mengekstrak data dari JSON.
      * **Instalasi (Contoh Ubuntu/Debian):**
        ```bash
        # 'sudo' menjalankan perintah sebagai administrator (root)
        # 'apt' adalah manajer paket
        # 'install' adalah perintah untuk menginstal
        # 'jq' adalah nama paket yang ingin kita instal
        sudo apt install jq
        ```
      * *(Sesuaikan perintah ini untuk distro Anda, misal: `sudo pacman -S jq` untuk Arch, `sudo dnf install jq` untuk Fedora).*

4.  **`grep` / `sed`** (Opsional, tapi klasik)

      * **Peran:** "Pisau Bedah Teks"
      * **Penjelasan:** Meskipun `jq` adalah raja untuk JSON, alat klasik Unix ini masih sangat berguna untuk memanipulasi *output* teks sederhana dengan cepat.
      * **`grep`**: Menemukan baris yang berisi teks tertentu.
      * **`sed`**: Mencari dan mengganti teks di dalam *stream*.

-----

### Ringkasan Modul 0

Anda sekarang telah memahami 3 pilar fundamental:

1.  Kita mengontrol Sway yang sedang berjalan melalui **IPC** (menggunakan `swaymsg`).
2.  Skrip kita dijalankan di *environment* yang **berbeda** (minimalis) dari terminal kita, jadi kita harus menggunakan *path* absolut.
3.  Alat utama kita adalah `bash` (untuk logika), `swaymsg` (untuk bicara), dan `jq` (untuk memahami jawaban Sway).

-----

<!--
Fondasi kita sudah kokoh. Apakah Anda merasa konsep IPC, Environment, dan Toolset ini sudah jelas?
Jika ya, kita bisa langsung menyelam ke alat pertama kita dan mulai memberi perintah pada Sway di **Modul 1: `swaymsg` — Juru Bicara Anda ke Sway**.
> - **[Ke Atas](#)**
> - **[Kurikulum][kurikulum]**
-->

