# [Modul 1: Identitas, Konsep Dasar, dan Instalasi][0]

Sebelum kita menyentuh konfigurasi, Anda harus memahami "siapa" dan "apa" Wofi itu sebenarnya. Di dunia Linux (terutama Arch), memahami asal-usul paket membantu kita memprediksi perilaku dan cara penanganannya.

### 1. Identitas dan Konsep Teknis (Technical Identity)

**Apa itu Wofi?**
Wofi adalah sebuah *launcher* (peluncur aplikasi) dan *menu builder* yang dibangun khusus untuk protokol **Wayland**. Jika di X11 Anda mengenal `dmenu` atau `rofi`, maka Wofi adalah ekuivalennya untuk Wayland yang tidak memerlukan lapisan kompatibilitas XWayland.

**Identitas Teknologi:**

  * **Bahasa Pemrograman:** Dibangun menggunakan **C**. Ini penting diketahui karena C menawarkan performa tinggi dan akses memori tingkat rendah, menjadikan Wofi ringan (*lightweight*).
  * **Basis GUI:** Menggunakan **GTK3**. Ini berarti Wofi bisa dikustomisasi tampilannya menggunakan CSS (seperti web), sebuah poin plus untuk estetika.
  * **Lisensi:** GPLv3 (General Public License v3). Ini adalah *Open Source* murni.
  * **Sifat:** *Standalone*. Wofi tidak terikat pada Sway saja, tapi bisa berjalan di *compositor* Wayland lain (seperti Hyprland atau River).

**Persyaratan Pengembangan/Modifikasi (Jika Anda ingin membedahnya):**
Jika Anda ingin memodifikasi *source code*-nya (forking), Anda memerlukan:

1.  Pengetahuan bahasa **C**.
2.  Paham pustaka **GTK3** dan **Wayland protocol**.
3.  Compiler seperti `gcc` atau `clang` dan build system `meson`.

-----

### 2. English Corner: Grammar & Vocabulary for Documentation

Di sesi ini, kita belajar bagaimana membaca dokumentasi teknis Wofi layaknya seorang profesional.

#### **A. Key Vocabulary (Kosa Kata Kunci)**

| Word | Part of Speech | Definition (ID) | Context Example |
| :--- | :--- | :--- | :--- |
| **Launcher** | Noun (Kata Benda) | Peluncur aplikasi/menu. | *Wofi is a minimalist application **launcher**.* |
| **Dependency** | Noun (Kata Benda) | Paket lain yang dibutuhkan agar software berjalan. | *GTK3 is a required **dependency** for Wofi.* |
| **Repository** | Noun (Kata Benda) | Tempat penyimpanan kode sumber. | *Clone the **repository** to build from source.* |
| **Argument** | Noun (Kata Benda) | Nilai tambahan yang diberikan pada perintah CLI. | *Pass the `--show` **argument** to start Wofi.* |
| **Deprecated** | Adjective (Kata Sifat) | Usang/tidak disarankan lagi (biasanya akan dihapus). | *This flag is **deprecated** in the latest version.* |

#### **B. Grammar Focus: Passive Voice (Kalimat Pasif)**

Dokumentasi teknis sering menggunakan *Passive Voice* untuk menekankan **objek** atau **tindakan**, bukan pelakunya.

  * **Rumus:** Subject + to be + Verb 3 (Past Participle).
  * **Contoh:**
      * *Active:* The developer wrote Wofi in C. (Developer menulis Wofi dalam bahasa C).
      * *Passive:* Wofi **is written** in C. (Wofi ditulis dalam bahasa C). -\> *Fokus pada Wofi-nya.*
      * *Passive:* The configuration file **is loaded** from `~/.config/wofi`. (File konfigurasi dimuat dari...).

#### **C. Professional Interaction (Contoh Percakapan)**

Jika Anda bertanya di forum internasional (seperti Reddit r/swaywm atau Github Issues) mengenai instalasi:

> *"Excuse me, could you verify if Wofi **is compatible with** the latest wlroots update? I noticed some rendering issues in my setup."*
> (Permisi, bisakah Anda memverifikasi apakah Wofi kompatibel dengan pembaruan wlroots terbaru? Saya melihat ada masalah rendering di setup saya.)

-----

### 3. Instalasi di Arch Linux (Implementation)

Karena Anda menggunakan Arch Linux, kita akan menggunakan manajer paket `pacman`. Wofi sudah tersedia di repositori resmi (biasanya di `extra`).

**Langkah 1: Instalasi via CLI**
Buka terminal (foot/alacritty/kitty) Anda di Sway.

```bash
# Perbarui database paket dulu agar tidak error "target not found"
sudo pacman -Syu

# Instal wofi
sudo pacman -S wofi
```

**Langkah 2: Verifikasi Instalasi**
Setelah proses selesai, pastikan Wofi terinstal dengan benar dan cek versinya.

```bash
wofi --version
```

*Output yang diharapkan:* Menampilkan nomor versi (misal: `v1.4.1`).

**Langkah 3: Uji Coba Sederhana (Dry Run)**
Mari kita coba jalankan Wofi tanpa konfigurasi (mode default) untuk melihat apakah ia muncul di layar Sway Anda.

```bash
wofi --show drun
```

  * `--show`: Argument untuk memberi tahu mode apa yang ingin ditampilkan.
  * `drun`: Singkatan dari *Desktop Run*. Ini akan mencari file `.desktop` di sistem Anda (aplikasi GUI yang terinstal).

Jika jendela melayang muncul di tengah layar berisi daftar aplikasi, selamat\! Tahap 1 sukses.

-----

### 4. Sumber Resmi (Official Resources)

Simpan tautan ini. Sebagai profesional, kita merujuk ke sini dulu sebelum bertanya ke forum.

1.  **Primary Source (Mercurial Repo):** [hg.sr.ht/\~scoopta/wofi](https://hg.sr.ht/~scoopta/wofi)
      * Ini adalah "rumah" aslinya. Dibuat oleh pengembang bernama `Scoopta`.
2.  **Documentation (Man Pages):**
      * Ketik di terminal: `man wofi` (untuk argumen CLI).
      * Ketik di terminal: `man 5 wofi` (untuk sintaks file konfigurasi - *Section 5 di man pages khusus untuk format file*).

-----

### 5. Error Handling & Troubleshooting

Bagian ini penting untuk mentalitas *problem solving* Anda.

**Kasus 1: Error "Target not found: wofi"**

  * **Analisis:** `pacman` tidak menemukan paket tersebut di database lokalnya.
  * **Solusi:** Kemungkinan Anda belum sinkronisasi database. Jalankan `sudo pacman -Syu` terlebih dahulu.
  * **English Error Message:** *"error: target not found: wofi"*

**Kasus 2: Error "Failed to connect to Wayland display"**

  * **Analisis:** Anda mencoba menjalankan Wofi di luar sesi Wayland (misalnya di sesi TTY atau X11 tanpa variabel lingkungan yang benar).
  * **Solusi:** Pastikan Anda menjalankan perintah tersebut *di dalam* sesi Sway yang sedang aktif. Cek variabel: `echo $WAYLAND_DISPLAY`.
  * **Plan B (Alternatif):**
    Jika Wofi ternyata berat atau *buggy* di hardware Anda, alternatif CLI-based yang lebih ringan dan "Unix philosophy" banget untuk Wayland adalah **Fuzzel** atau **Bemenu**. (Tapi kita fokus Wofi dulu).

-----

### Referensi utama (baca lanjutan)

* Wofi — repo/README (implementasi & dependensi). ([GitHub][1])
* Manual page wofi (man) — format config & opsi. ([Man Arch Linux][7])
* Paket Arch: detail paket `wofi` (dependensi dan repo). ([Arch Linux][5])
* Panduan build (contoh meson/ninja) & dependensi dev. ([GitHub][4])
* Panduan Sway (ArchWiki) — konfigurasi bindsym, reload, environment. ([ArchWiki][2])
* Catatan: pada beberapa distro paket mungkin tersedia di versi terbaru (sid/bookworm). Periksa `packages.debian.org/wofi`. ([Debian Packages][3])
* Jika icon atau aplikasi `.desktop` tidak muncul:
   > * Pastikan `.desktop` berada di `~/.local/share/applications` atau `/usr/share/applications`.
   > * Jalankan `update-desktop-database` jika menambah manual file baru. ([Garuda Linux Forum][9])
* **Style (CSS):** `~/.config/wofi/style.css` (atau file CSS yang Anda tentukan). Wofi memakai styling GTK/CSS untuk render; banyak tema tersedia di repo tema wofi. ([DEV Community][8])
* Log dapat memuat pesan terkait protocol error atau masalah GTK/Wayland; ini langkah pertama debugging. ([Man Arch Linux][6])

---

[1]: https://github.com/SimplyCEO/wofi "SimplyCEO/wofi"
[2]: https://wiki.archlinux.org/title/Sway "Sway - ArchWiki"
[3]: https://packages.debian.org/sid/wofi "Details of package wofi in sid"
[4]: https://github.com/fuzzybritches0/wofi "fuzzybritches0/wofi"
[5]: https://archlinux.org/packages/extra/x86_64/wofi "wofi 1.5.1-1 (x86_64)"
[6]: https://man.archlinux.org/man/wofi.1.en "wofi(1) - Arch manual pages"
[7]: https://man.archlinux.org/man/wofi.5.en "wofi(5) - Arch manual pages"
[8]: https://dev.to/juniordevforlife/how-i-set-up-wifi-in-debian-11-14ka "How I Set Up Wifi In Debian 11"
[9]: https://forum.garudalinux.org/t/adding-an-application-to-wofi/17048 "Adding an application to Wofi - Sway"
[10]: https://lists.fedoraproject.org/archives/list/sway%40lists.fedoraproject.org/thread/T2ECWRN7WFQZG6IA5QQLF7GG55QAZQS6/ "User Friendly Wofi Documentation - Sway"
[11]: https://bbs.archlinux.org/viewtopic.php "wofi crashing since 1.5 update / Applications & Desktop ..."

> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../../README.md
[kurikulum]: ../README.md
[selanjutnya]: ../bagian-2/README.md

<!----------------------------------------------------->
[0]: ../README.md
