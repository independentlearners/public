# **[20. Rilis dan Distribusi Plugin][1]**

Bagian ini akan membahas aspek-aspek penting dalam merilis plugin Anda, mulai dari versioning, pembuatan dokumentasi yang baik, pemilihan lisensi, hingga publikasi agar dapat diakses oleh pengguna lain.

---

### 20.1 Versioning (Semantic Versioning)

- **Deskripsi Konsep:**
  - **Versioning (Pemberian Versi):** Adalah praktik memberikan nomor versi yang unik untuk setiap rilis perangkat lunak Anda. Ini membantu pengguna dan pengembang lain untuk melacak perubahan, mengelola dependensi, dan memahami dampak dari pembaruan.
  - **Semantic Versioning (SemVer):** Adalah standar spesifikasi versioning yang banyak diadopsi. Formatnya adalah `MAJOR.MINOR.PATCH` (misalnya, `1.2.3`). Aturan utamanya adalah:
    1.  **`MAJOR` (Versi Mayor):** Dinaikkan ketika Anda membuat perubahan API yang **tidak kompatibel ke belakang** (breaking changes). Pengguna yang memperbarui ke versi mayor baru mungkin perlu mengubah kode atau konfigurasi mereka.
    2.  **`MINOR` (Versi Minor):** Dinaikkan ketika Anda **menambahkan fungsionalitas baru** dengan cara yang **kompatibel ke belakang** (backward-compatible). Pengguna dapat memperbarui dengan aman dan mendapatkan fitur baru.
    3.  **`PATCH` (Versi Patch):** Dinaikkan ketika Anda membuat **perbaikan bug yang kompatibel ke belakang**. Pengguna dapat memperbarui dengan aman untuk mendapatkan perbaikan.
  - **Label Tambahan:** SemVer juga memungkinkan label tambahan untuk pra-rilis (misalnya, `1.0.0-alpha.1`) atau metadata build (misalnya, `1.0.0+build.123`).
- **Terminologi:**
  - **Semantic Versioning (SemVer):** Skema versioning `MAJOR.MINOR.PATCH`.
  - **Breaking Change (Perubahan Merusak):** Perubahan pada API publik plugin Anda yang membuat versi sebelumnya tidak lagi kompatibel tanpa modifikasi.
  - **Backward-Compatible (Kompatibel ke Belakang):** Perubahan yang memungkinkan kode yang bekerja dengan versi sebelumnya tetap bekerja dengan versi baru.
- **Implementasi dalam Neovim (dan Pengembangan Umum):**
  - **Git Tags:** Cara paling umum untuk menandai rilis dalam proyek Git Anda adalah dengan menggunakan _tags_. Misalnya, setelah Anda siap merilis versi `v0.1.0`, Anda akan membuat tag Git dengan nama tersebut:
    ```bash
    git tag v0.1.0
    git push origin v0.1.0 # Dorong tag ke remote repository
    ```
  - **Manfaat untuk Pengguna:** Pengguna (dan plugin manager mereka) dapat mengandalkan versi ini untuk:
    - Memastikan mereka mendapatkan versi plugin yang stabil dan diketahui.
    - Mengunci ke versi tertentu jika mereka tidak ingin pembaruan otomatis yang mungkin merusak.
    - Memahami dampak dari pembaruan berdasarkan perubahan nomor versi.
- **Sumber Dokumentasi:**
  - **Situs Web Semantic Versioning:** [https://semver.org/](https://semver.org/) (Spesifikasi lengkap dan FAQ).

**Contoh Alur Versioning:**

- `v0.1.0`: Rilis awal plugin Anda.
- `v0.1.1`: Memperbaiki bug kecil. (Perubahan PATCH)
- `v0.2.0`: Menambahkan fitur baru yang tidak merusak fitur lama. (Perubahan MINOR)
- `v0.2.1`: Perbaikan bug lagi. (Perubahan PATCH)
- `v1.0.0`: Merilis versi stabil pertama, atau melakukan perubahan besar pada API yang mungkin memerlukan pengguna untuk mengubah konfigurasi mereka. (Perubahan MAJOR)

Mengadopsi SemVer sejak awal akan sangat membantu dalam jangka panjang, baik untuk Anda maupun pengguna plugin Anda.

---

### 20.2 Dokumentasi (README, Help Files)

Dokumentasi yang baik adalah salah satu aspek terpenting dari plugin yang sukses. Tanpa dokumentasi, pengguna mungkin tidak tahu cara menginstal, mengkonfigurasi, atau menggunakan plugin Anda secara efektif.

- **Deskripsi Konsep:** Menyediakan panduan yang jelas dan komprehensif tentang plugin Anda. Ini mencakup informasi untuk pengguna akhir dan mungkin juga untuk pengembang lain yang ingin berkontribusi atau memahami kode Anda.

- **Terminologi:**

  - **`README.md`:** File Markdown di root repositori Anda yang biasanya menjadi halaman depan proyek Anda di platform seperti GitHub.
  - **Vim help files (`.txt`):** File teks dengan format khusus yang dapat diakses dari dalam Neovim melalui perintah `:help`.
  - **Helptags:** File indeks yang dihasilkan oleh Neovim (`:helptags`) yang memungkinkan pencarian cepat dalam file help.

- **Implementasi dalam Neovim:**

  #### 1\. `README.md`

  - **Tujuan:** Memberikan gambaran umum yang cepat, instruksi instalasi, dan contoh penggunaan dasar. Ini adalah "pintu depan" plugin Anda.
  - **Struktur Umum (Saran):**

    - **Nama Plugin dan Deskripsi Singkat:** Jelaskan apa fungsi plugin Anda dalam satu atau dua kalimat.

    - **Fitur Utama:** Daftar poin-poin fitur unggulan.

    - **Demo/Screenshots/GIFs (Opsional tapi sangat membantu):** Tunjukkan plugin Anda beraksi.

    - **Persyaratan (Requirements/Dependencies):** Sebutkan versi Neovim minimum, plugin lain, atau alat eksternal yang dibutuhkan.

    - **Instalasi:** Berikan contoh cara menginstal menggunakan plugin manager populer (misalnya, `lazy.nvim`, `packer.nvim`).

      ````markdown
      ## Installation

      ### lazy.nvim

      ```lua
      {
        "username/my-cool-plugin.nvim",
        dependencies = {"nvim-lua/plenary.nvim"}, -- Contoh dependensi
        opts = {
          -- konfigurasi Anda di sini
        }
      }
      ```
      ````

      ### packer.nvim

      ```lua
      use {
        "username/my-cool-plugin.nvim",
        requires = {"nvim-lua/plenary.nvim"},
        config = function()
          require("my-cool-plugin").setup({
            -- konfigurasi Anda di sini
          })
        end
      }
      ```

    - **Penggunaan Dasar (Basic Usage):** Contoh konfigurasi minimal dan bagaimana cara menggunakan fitur inti.

    - **Konfigurasi Lanjutan (Advanced Configuration/Customization):** Jelaskan semua opsi konfigurasi yang tersedia dan bagaimana cara menyesuaikannya.

    - **Perintah (Commands):** Jika plugin Anda menyediakan perintah pengguna, daftarkan dan jelaskan.

    - **Pemetaan Kunci Default (Default Keymaps):** Jika ada, dan bagaimana cara menonaktifkan atau mengubahnya.

    - **API (jika ada):** Jika plugin Anda mengekspos API Lua untuk digunakan oleh plugin lain atau konfigurasi pengguna tingkat lanjut, dokumentasikan.

    - **Berkontribusi (Contributing):** Panduan singkat jika Anda terbuka untuk kontribusi.

    - **Lisensi:** Sebutkan lisensi plugin Anda.

    - **Ucapan Terima Kasih (Acknowledgements, opsional):** Jika ada.

  - **Gaya Penulisan:** Jelas, ringkas, dan sertakan contoh kode yang berfungsi.

  #### 2\. File Help Vim (`doc/nama-plugin.txt`)

  - **Tujuan:** Menyediakan dokumentasi mendalam yang dapat diakses langsung dari dalam Neovim (`:help nama-plugin-tag`).
  - **Struktur dan Format (`:h help-writing`):**

    - **File `doc/tags`:** File ini **tidak ditulis manual**. Ia dihasilkan oleh perintah `:helptags path/to/your/plugin/doc` atau `:helptags ALL`. Plugin manager seringkali menjalankan ini secara otomatis. File `tags` berisi daftar semua tag help dan file tempatnya.
    - **Nama File:** Biasanya `doc/nama-plugin-anda.txt`.
    - **Baris Pertama (Modeline):** `*nama-plugin.txt* Berisi bantuan untuk plugin NamaPluginAnda` (Contoh).
    - **Tags (Penanda):** Didefinisikan dengan tanda bintang di kedua sisi: `*plugin-name-main-tag*`. Ini adalah target yang bisa dilompati dengan `:help`. Buat tag yang logis dan mudah diingat.
    - **Judul Bagian:** Seringkali ditulis dalam huruf kapital atau diapit dengan karakter seperti `=`.

      ```vim
      ==============================================================================
      MY-COOL-PLUGIN - PENGENALAN                               *my-cool-plugin-introduction*

      Ini adalah plugin Neovim yang sangat keren...
      ```

    - **Teks Normal:** Penjelasan fitur, opsi, dll.
    - **Contoh Kode:** Biasanya di-indentasi dengan beberapa spasi atau tab.
      ```vim
      Contoh konfigurasi: >
          require('my-cool-plugin').setup({
              enable_awesome = true
          })
      <
      (Tanda `>` dan `<` di sini adalah konvensi untuk blok kode, opsional)
      ```
    - **Referensi ke Tag Lain:** Gunakan pipa: `|another-plugin-tag|` atau `|CTRL-X|`.
    - **Struktur yang Disarankan:**
      - Pengenalan (`*my-plugin-introduction*`)
      - Instalasi (`*my-plugin-installation*`)
      - Penggunaan Dasar (`*my-plugin-usage*`)
      - Konfigurasi (`*my-plugin-configuration*`)
        - Penjelasan setiap opsi.
      - Perintah (`*my-plugin-commands*`)
      - API Lua (`*my-plugin-api*`) (jika ada)
      - FAQ / Troubleshooting (`*my-plugin-faq*`)
      - Changelog / Riwayat Versi (`*my-plugin-changelog*`)

  - **Tips:**
    - Buatlah terstruktur dan mudah dinavigasi.
    - Perbarui dokumentasi setiap kali Anda menambahkan fitur atau membuat perubahan.
    - Lihat dokumentasi plugin lain yang Anda sukai sebagai contoh.

- **Sumber Dokumentasi Neovim:**

  - `:h help-writing` (Panduan resmi Vim untuk menulis file help, berlaku juga untuk Neovim).
  - `:h :helptags`.

---

### 20.3 Lisensi Open Source

- **Deskripsi Konsep:**
  - **Lisensi Perangkat Lunak:** Dokumen legal yang memberikan hak kepada orang lain untuk menggunakan, memodifikasi, dan/atau mendistribusikan perangkat lunak Anda di bawah kondisi tertentu.
  - **Pentingnya Lisensi Open Source:** Jika Anda tidak menyertakan lisensi, secara default karya Anda dilindungi oleh hak cipta eksklusif ("All Rights Reserved"). Ini berarti orang lain secara teknis tidak memiliki izin untuk menggunakan, menyalin, mendistribusikan, atau memodifikasi kode Anda. Lisensi open source memberikan izin tersebut, mendorong adopsi dan kolaborasi.
- **Terminologi:**
  - **Open Source License (Lisensi Sumber Terbuka):** Lisensi yang memenuhi kriteria Open Source Definition (misalnya, kebebasan untuk menggunakan, memodifikasi, mendistribusikan).
  - **Permissive License (Lisensi Permisif):** Lisensi open source dengan batasan minimal tentang bagaimana perangkat lunak dapat digunakan, dimodifikasi, dan didistribusikan (misalnya, MIT, Apache 2.0, BSD). Biasanya hanya memerlukan atribusi.
  - **Copyleft License (Lisensi Copyleft):** Lisensi open source yang mengharuskan karya turunan (modifikasi atau karya yang menggabungkan kode berlisensi copyleft) untuk didistribusikan di bawah lisensi yang sama atau kompatibel (misalnya, GPL).
- **Implementasi (Cara Menerapkan):**
  1.  **Pilih Lisensi:** Pikirkan tentang bagaimana Anda ingin orang lain menggunakan plugin Anda.
      - **MIT License:** Sangat populer untuk plugin Neovim karena kesederhanaannya dan sifat permisifnya. Pada dasarnya, "lakukan apa saja dengan kode ini, tetapi sertakan pemberitahuan hak cipta asli dan teks lisensi ini."
      - **Apache License 2.0:** Juga permisif, tetapi lebih detail dan menyertakan klausul paten eksplisit.
      - **GNU GPLv3 (atau GPLv2):** Jika Anda ingin memastikan bahwa semua turunan dari plugin Anda juga tetap open source di bawah GPL.
  2.  **Sertakan File Lisensi:** Buat file bernama `LICENSE` atau `LICENSE.md` di direktori root plugin Anda. Salin teks lengkap dari lisensi yang Anda pilih ke dalam file ini.
  3.  **Sebutkan di README:** Sebutkan lisensi yang Anda gunakan di file `README.md` Anda.
  4.  **(Opsional) Header File:** Beberapa proyek menambahkan header lisensi singkat di bagian atas setiap file sumber, meskipun untuk plugin Lua yang lebih kecil, file `LICENSE` di root biasanya cukup.
- **Sumber Informasi Lisensi:**
  - **Choose a License:** [https://choosealicense.com/](https://choosealicense.com/) (Bantuan dari GitHub untuk memilih lisensi).
  - **Open Source Initiative (OSI):** [https://opensource.org/licenses/](https://opensource.org/licenses/) (Daftar lisensi yang disetujui OSI).

Memilih lisensi adalah langkah penting. Lisensi MIT adalah pilihan default yang aman dan umum untuk plugin Neovim.

---

### 20.4 Publikasi (GitHub, LuaRocks)

Setelah plugin Anda siap dengan versi, dokumentasi, dan lisensi, Anda perlu mempublikasikannya agar orang lain dapat menemukannya.

- **Deskripsi Konsep:** Membuat plugin Anda tersedia untuk diunduh dan diinstal oleh komunitas.

- **Terminologi:**

  - **GitHub (atau GitLab, Codeberg, dll.):** Platform hosting repositori Git berbasis web yang paling umum digunakan untuk proyek open source, termasuk plugin Neovim.
  - **LuaRocks:** Manajer paket utama untuk modul dan pustaka Lua.

- **Implementasi:**

  #### 1\. GitHub (atau Platform Git Serupa)

  - **Repositori:** Ini adalah cara standar untuk mendistribusikan plugin Neovim.
    - Buat repositori publik di GitHub (atau platform pilihan Anda).
    - Dorong (push) kode plugin Anda, termasuk struktur direktori yang benar, `README.md`, `doc/` file, dan file `LICENSE`.
    - Gunakan Git tags (misalnya, `v0.1.0`) untuk menandai rilis resmi.
  - **GitHub Releases:** Fitur di GitHub yang memungkinkan Anda membuat "rilis" formal yang terkait dengan tag Git.
    - Anda dapat menambahkan catatan rilis (changelog) untuk setiap versi.
    - Anda dapat melampirkan file biner (jika ada, meskipun jarang untuk plugin Lua murni).
  - **Visibilitas dan Plugin Manager:** Sebagian besar plugin manager Neovim (lazy.nvim, packer.nvim, dll.) bekerja dengan mengambil plugin langsung dari URL repositori Git. Memiliki repositori di GitHub membuat plugin Anda mudah ditemukan dan diinstal.
  - **Issue Tracker:** Gunakan fitur issue tracker di GitHub untuk mengelola laporan bug dan permintaan fitur dari pengguna.

  #### 2\. LuaRocks

  - **Tujuan Utama:** LuaRocks dirancang untuk mendistribusikan _pustaka_ atau _modul_ Lua yang dapat digunakan kembali, bukan aplikasi atau plugin utuh yang sangat terikat pada host seperti Neovim.
  - **Relevansi untuk Plugin Neovim:**
    - **Biasanya Tidak untuk Plugin Utuh:** Pengguna Neovim umumnya **tidak** menginstal plugin Neovim melalui `luarocks install my-neovim-plugin`. Mereka menggunakan plugin manager Neovim.
    - **Mungkin Berguna untuk Komponen Pustaka:**
      - Jika plugin Anda mengembangkan sebuah _pustaka Lua murni_ yang general dan bisa berguna di luar konteks Neovim (atau untuk plugin Neovim lain sebagai dependensi murni Lua), maka mempublikasikan pustaka tersebut ke LuaRocks bisa menjadi ide bagus.
      - Plugin lain kemudian bisa mendeklarasikan pustaka LuaRocks Anda sebagai dependensi (beberapa plugin manager mungkin memiliki dukungan untuk ini, atau pengguna mungkin menginstalnya secara global).
  - **`rockspec` File:** Jika Anda memutuskan untuk mempublikasikan sesuatu ke LuaRocks, Anda perlu membuat file `.rockspec`. Ini adalah file spesifikasi Lua yang mendefinisikan:
    - Metadata paket (nama, versi, lisensi, deskripsi, homepage).
    - Sumber kode (misalnya, URL ke tag Git, atau file tarball).
    - Instruksi build (jika ada komponen C).
    - Dependensi (pada rock lain atau pustaka sistem).
    <!-- end list -->
    ```lua
    -- Contoh rockspec sederhana (misal, untuk pustaka murni Lua)
    package = "my-lua-library"
    version = "0.1.0-1" -- versi-revisi_rockspec
    source = {
        url = "git://[github.com/username/my-lua-library](https://github.com/username/my-lua-library)", -- Atau path ke tarball
        tag = "v0.1.0"
    }
    description = {
        summary = "Pustaka Lua yang sangat berguna.",
        detailed = [[
            Deskripsi lebih panjang tentang apa yang dilakukan pustaka ini
            dan bagaimana cara menggunakannya.
        ]],
        homepage = "[https://github.com/username/my-lua-library](https://github.com/username/my-lua-library)",
        license = "MIT" -- Harus sesuai dengan file LICENSE Anda
    }
    dependencies = {
        "lua >= 5.1" -- Persyaratan versi Lua
        -- "another-luarock-dependency >= 1.2"
    }
    build = {
        type = "builtin",
        modules = {
            ["my-lua-library.core"] = "lua/my-lua-library/core.lua",
            ["my-lua-library.utils"] = "lua/my-lua-library/utils.lua"
        }
    }
    ```
  - **Publikasi ke LuaRocks:** Anda akan menggunakan alat baris perintah `luarocks` untuk mengunggah rockspec Anda ke server LuaRocks (setelah membuat akun). `luarocks upload my-lua-library-0.1.0-1.rockspec`.

- **Sumber Dokumentasi:**

  - **GitHub Help:** [https://docs.github.com/](https://docs.github.com/)
  - **LuaRocks Wiki & Documentation:** [https://github.com/luarocks/luarocks/wiki](https://github.com/luarocks/luarocks/wiki)

---

Dengan memperhatikan versioning, dokumentasi yang komprehensif, lisensi yang jelas, dan mempublikasikan plugin Anda di platform yang tepat (terutama GitHub), Anda tidak hanya membuat plugin Anda dapat diakses tetapi juga membangun fondasi untuk komunitas di sekitarnya.

Pada bagian berikutnya kita akan membahas tentang praktik terbaik umum dan pemeliharaan.

> - **[Ke Atas](#)**
> - **[Selanjutnya][4]**
> - **[Sebelumnya][3]**
> - **[Kurikulum][2]**
> - **[Domain Spesifik][5]**

[5]: ../../../../../../../README.md
[4]: ../21-bastpractice/README.md
[3]: ../19-struktur/README.md
[2]: ../../../../../README.md
[1]: ../../../neovim/README.md
