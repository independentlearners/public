# **Kurikulum Komprehensif: Menguasai Ekosistem Nix**

Kurikulum ini dirancang untuk mengubah seorang pemula absolut menjadi seorang pakar Nix yang mampu merancang, mengelola, dan menyebarkan sistem perangkat lunak yang andal, reproduktif, dan dapat diprediksi dalam skala apa pun.

#### **Prasyarat**

- **Wajib:** Kemampuan dasar menggunakan antarmuka baris perintah (CLI) pada sistem operasi Linux atau macOS.
- **Direkomendasikan:** Pengalaman dengan setidaknya satu bahasa pemrograman (misalnya, Python, JavaScript, atau Dart/Flutter sesuai minat Anda) akan membantu memahami konsep fungsional.
- **Opsional:** Pemahaman dasar mengenai manajemen paket tradisional (seperti `apt`, `yum`, `npm`) akan memberikan kontras yang bermanfaat.

#### **Alat Esensial**

- **Terminal Emulator:** Alat utama untuk berinteraksi dengan Nix.
- **Editor Teks/IDE:** Visual Studio Code dengan ekstensi `Nix IDE` atau `nix-format` sangat direkomendasikan. Alternatif lain seperti Neovim dengan `nvim-lspconfig` juga sangat baik.
- **Git:** Esensial untuk manajemen versi file konfigurasi dan untuk berinteraksi dengan Nix Flakes.
- **Sistem Operasi:** Linux (distribusi apa pun) atau macOS. Pengguna Windows dapat menggunakan WSL2.

#### **Estimasi Waktu & Level**

- **Fase 1 (Pondasi):** 4-6 minggu (Tingkat Pemula)
- **Fase 2 (Menengah):** 6-8 minggu (Tingkat Menengah)
- **Fase 3 (Mahir):** 8-12 minggu (Tingkat Mahir)
- **Fase 4 (Pakar):** Pembelajaran berkelanjutan (Tingkat Pakar/Enterprise)

**Total Waktu Belajar Inti:** Sekitar 5-7 bulan untuk mencapai tingkat kemahiran yang solid.

---

### **Fase 1: Pondasi – Pengenalan Ekosistem Nix (Tingkat Pemula)**

**Tujuan Fase:** Memahami "mengapa" di balik Nix, menginstal ekosistem, dan mampu menggunakan perintah dasar untuk mengelola paket dan lingkungan sementara.

---

#### **Modul 1.1: Filosofi dan Konsep Inti Nix**

1.  **Deskripsi Konkret:** Modul ini adalah fondasi teoretis. Anda akan mempelajari masalah-masalah dalam manajemen perangkat lunak tradisional ("dependency hell") dan bagaimana pendekatan unik Nix menyelesaikannya melalui prinsip-prinsip fungsional.
2.  **Konsep Dasar dan Filosofi:**
    - **Reproducibility (Keterulangan):** Mengapa build yang sama dengan input yang sama _selalu_ menghasilkan output yang identik secara bit-per-bit. Ini adalah inti dari keandalan Nix.
    - **Declarative Model (Model Deklaratif):** Anda tidak memberi tahu sistem _bagaimana_ cara mencapai suatu keadaan, melainkan _apa_ keadaan akhir yang diinginkan. Sistem yang akan mencari cara untuk mencapainya.
    - **Purity (Kemurnian):** Proses build diisolasi dari sisa sistem untuk mencegah dependensi yang tidak dideklarasikan. Build tidak dapat mengakses jaringan atau direktori acak, memastikan hasil yang murni.
    - **The Nix Store:** Konsep di balik direktori `/nix/store`, di mana setiap paket disimpan dalam subdirektori unik yang namanya berasal dari _hash_ semua dependensinya. Ini memungkinkan banyak versi dari perangkat lunak yang sama untuk hidup berdampingan tanpa konflik.
3.  **Sintaks Dasar/Contoh Implementasi Inti:**
    - Modul ini lebih fokus pada konsep daripada kode. Contohnya adalah ilustrasi:
      - Manajemen paket tradisional: `A -> B -> C (v1.0)`. Jika program lain butuh `C (v2.0)`, terjadi konflik.
      - Manajemen Nix:
        - `A -> B -> /nix/store/...-C-1.0`
        - `D -> E -> /nix/store/...-C-2.0`
        - Kedua versi C dapat hidup berdampingan.
4.  **Terminologi Kunci:**
    - **Package Manager:** Perangkat lunak yang mengotomatiskan proses instalasi, pembaruan, konfigurasi, dan penghapusan paket perangkat lunak.
    - **Dependency Hell:** Situasi di mana satu paket perangkat lunak bergantung pada versi spesifik dari paket lain, yang mungkin bertentangan dengan dependensi dari perangkat lunak lain.
    - **Derivation:** File `.drv` di dalam Nix Store yang merupakan instruksi lengkap dan murni tentang cara membuat sebuah paket, termasuk semua dependensinya.
    - **Nix Store:** Direktori read-only (`/nix/store`) yang berisi semua paket dan dependensinya.
5.  **Daftar Isi:**
    - Masalah dalam Manajemen Konfigurasi Tradisional
    - Prinsip Inti: Deklaratif, Reproduktif, Murni
    - Anatomi Nix Store (`/nix/store`)
    - Konsep Derivasi: Resep untuk Membangun Perangkat Lunak
    - Garbage Collection: Membersihkan Paket yang Tidak Lagi Digunakan
6.  **Sumber Referensi:**
    - [About Nix & NixOS](https://www.google.com/search?q=https://nixos.org/about.html)
    - [Nix Pills 1: Why you should give it a try](https://nixos.org/guides/nix-pills/why-you-should-give-it-a-try.html)
7.  **Visualisasi:**
    - Sangat direkomendasikan diagram yang membandingkan pohon dependensi tradisional (dengan potensi konflik) dengan struktur grafik asiklik terarah (DAG) dari dependensi di Nix Store.

---

#### **Modul 1.2: Instalasi dan Perintah Dasar**

1.  **Deskripsi Konkret:** Anda akan melakukan instalasi Nix pada sistem Anda dan belajar menggunakan perintah-perintah esensial untuk mencari, menginstal, dan mengelola paket secara ad-hoc.
2.  **Konsep Dasar dan Filosofi:** Perintah-perintah ini adalah titik masuk Anda ke ekosistem Nix. `nix-shell` adalah salah satu alat paling kuat, memungkinkan Anda menciptakan lingkungan sementara yang terisolasi tanpa "mengotori" sistem global Anda.
3.  **Sintaks Dasar/Contoh Implementasi Inti:**

    ```bash
    # Memasuki shell sementara dengan Python 3.11 dan Git
    nix-shell -p python311 git

    # Mencari paket
    nix-search nixpkgs python

    # Menjalankan perintah dari sebuah paket tanpa menginstalnya secara permanen
    nix-run nixpkgs#hello

    # Menginstal paket ke profil pengguna (pendekatan yang kurang disarankan untuk penggunaan jangka panjang)
    nix-env -iA nixpkgs.cowsay

    # Membersihkan paket yang tidak terpakai (garbage collection)
    nix-collect-garbage -d
    ```

4.  **Terminologi Kunci:**
    - **`nix-shell`:** Perintah untuk menciptakan lingkungan shell interaktif yang berisi paket-paket yang ditentukan.
    - **`nix-env`:** Perintah untuk mengelola paket secara imperatif yang diinstal di profil pengguna.
    - **`nixpkgs`:** Koleksi paket Nix terbesar, yang dikelola oleh komunitas. Ini adalah "channel" default.
    - **Profile:** Kumpulan symlink yang menunjuk ke paket-paket di Nix Store, membuatnya tersedia di `PATH` pengguna.
5.  **Daftar Isi:**
    - Instalasi Nix pada Linux dan macOS (Multi-user vs. Single-user)
    - Memahami Konsep Channels (Saluran)
    - Perintah `nix-shell` untuk Lingkungan Sementara
    - Mencari dan Menginspeksi Paket dengan `nix-search` dan `nix-hub`
    - Penggunaan `nix-env` untuk Manajemen Profil (dan kapan harus dihindari)
    - Dasar-dasar Garbage Collection
6.  **Sumber Referensi:**
    - [Nix Quick Start](https://www.google.com/search?q=https://nixos.org/guides/nix-pills/install-nix.html)
    - [Official Nix Manual: `nix-shell`](<https://www.google.com/search?q=%5Bhttps://nixos.org/manual/nix/stable/command-ref/nix-shell.html%5D(https://nixos.org/manual/nix/stable/command-ref/nix-shell.html)>)
    - [Official Nix Manual: `nix-env`](<https://www.google.com/search?q=%5Bhttps://nixos.org/manual/nix/stable/command-ref/nix-env.html%5D(https://nixos.org/manual/nix/stable/command-ref/nix-env.html)>)

---

### **Fase 2: Menengah – Manajemen Lingkungan dan Paket (Tingkat Menengah)**

**Tujuan Fase:** Mampu menulis ekspresi Nix sendiri untuk mendefinisikan paket dan lingkungan pengembangan yang kompleks dan reproduktif menggunakan praktik modern (Flakes).

---

#### **Modul 2.1: Pengenalan Bahasa Pemrograman Nix**

1.  **Deskripsi Konkret:** Anda akan mempelajari sintaks dan semantik dari bahasa Nix itu sendiri. Ini adalah bahasa fungsional yang _lazy_ dan dirancang khusus untuk konfigurasi.
2.  **Konsep Dasar dan Filosofi:** Bahasa Nix bukanlah bahasa serbaguna; tujuannya adalah untuk menghasilkan struktur data (khususnya, derivasi). Memahaminya sebagai bahasa untuk "mendeskripsikan" daripada "melakukan" adalah kunci.
3.  **Sintaks Dasar/Contoh Implementasi Inti:**
    ```nix
    # File: example.nix
    let
      # Mendefinisikan variabel lokal
      nama = "Dunia";
      versi = "1.0";
    in
    # Output utama adalah sebuah attribute set (objek/map)
    {
      pesan = "Halo, ${nama}!"; # String interpolation
      paket = "program-saya-${versi}";
      konfigurasi = {
        enabled = true;
        port = 8080;
      };
      # Fungsi sederhana
      tambah = a: b: a + b;
    }
    ```
4.  **Terminologi Kunci:**
    - **Lazy Evaluation:** Ekspresi tidak dievaluasi sampai nilainya benar-benar dibutuhkan.
    - **Functional Language:** Program dibangun dengan menyusun fungsi-fungsi murni, menghindari state yang dapat berubah dan data mutable.
    - **Attribute Set (attrset):** Struktur data fundamental di Nix, mirip dengan map atau objek di bahasa lain, yang terdiri dari pasangan kunci-nilai.
    - **Lambda:** Fungsi anonim, biasanya dalam bentuk `arg: body`.
5.  **Daftar Isi:**
    - Tipe Data Dasar: String, Angka, Boolean, Path, Null
    - Struktur Data: List dan Attribute Sets
    - Sintaks `let ... in ...` untuk variabel lokal
    - Menulis dan Menggunakan Fungsi (Lambda)
    - Built-in Functions (Fungsi Bawaan) yang Penting
    - Mengimpor File Nix Lain (`import ./file.nix`)
6.  **Sumber Referensi:**
    - [A Tour of Nix](https://www.google.com/search?q=https://nix.dev/tutorials/a-tour-of-nix/)
    - [Nix Language Basics (nix.dev)](https://www.google.com/search?q=https://nix.dev/guides/learning-journey/nix-language-basics)
    - [Nix Pills 3-5: The Nix language](https://www.google.com/search?q=https://nixos.org/guides/nix-pills/nix-language-a-tour.html)

---

#### **Modul 2.2: Menulis Derivasi Sederhana**

1.  **Deskripsi Konkret:** Anda akan belajar cara membuat paket perangkat lunak Anda sendiri dari awal menggunakan fungsi `stdenv.mkDerivation`. Ini adalah langkah dari konsumen menjadi produsen di ekosistem Nix.
2.  **Konsep Dasar dan Filosofi:** `stdenv.mkDerivation` mengabstraksikan proses build standar (unpack, patch, configure, build, install) yang umum di dunia Unix/Linux. Dengan menyediakan input yang benar (seperti source code dan build tools), Anda dapat memaketkan hampir semua perangkat lunak.
3.  **Sintaks Dasar/Contoh Implementasi Inti:**

    ```nix
    # File: my-hello.nix
    { pkgs ? import <nixpkgs> {} }:

    pkgs.stdenv.mkDerivation {
      name = "hello-custom-2.12";

      # Sumber kode
      src = pkgs.fetchurl {
        url = "mirror://gnu/hello/hello-2.12.tar.gz";
        sha256 = "0ssi1wpaf7q9fy4vinxi9abela19m703p75a2l7ah8l39qgw2kiz";
      };

      # Dependensi saat build
      buildInputs = [ pkgs.perl ];
    }
    ```

    - Jalankan dengan: `nix-build my-hello.nix`

4.  **Terminologi Kunci:**
    - **`stdenv` (Standard Environment):** Lingkungan build dasar yang menyediakan alat-alat kompilasi umum (GCC, make, etc.).
    - **`mkDerivation`:** Fungsi utama dalam `stdenv` untuk mendefinisikan sebuah paket.
    - **`fetchurl` / `fetchFromGitHub`:** Fungsi untuk mengunduh kode sumber secara reproduktif (dengan hash).
    - **Phases:** Tahapan-tahapan dalam proses build (unpackPhase, buildPhase, installPhase, etc.).
5.  **Daftar Isi:**
    - Struktur Dasar `mkDerivation`
    - Menyediakan Sumber Kode (Lokal dan Remote)
    - Menentukan `buildInputs` vs. `nativeBuildInputs`
    - Memahami Fase-fase Build
    - Meng-override Fase Build
    - Mem-patch Kode Sumber
6.  **Sumber Referensi:**
    - [Nix Pills: Packaging an existing program](https://www.google.com/search?q=https://nixos.org/guides/nix-pills/packaging-existing-software.html)
    - [Nixpkgs Manual: Standard Environment](https://www.google.com/search?q=https://nixos.org/manual/nixpkgs/stable/%23ssec-stdenv)

---

#### **Modul 2.3: Pengenalan Nix Flakes**

1.  **Deskripsi Konkret:** Anda akan mempelajari **Nix Flakes**, antarmuka modern yang membungkus kode Nix Anda dengan input dan output yang eksplisit, menjadikannya lebih portabel, dapat disusun, dan reproduktif. **Ini adalah cara yang direkomendasikan untuk proyek-proyek baru.**
2.  **Konsep Dasar dan Filosofi:** Flakes memecahkan masalah dependensi yang "mengambang" (seperti `<nixpkgs>`) dengan memaksa semua dependensi eksternal (termasuk nixpkgs itu sendiri) untuk dideklarasikan secara eksplisit dan versinya dikunci dalam file `flake.lock`. Ini memberikan reproduktifitas tingkat tinggi.
3.  **Sintaks Dasar/Contoh Implementasi Inti:**

    ```nix
    # File: flake.nix
    {
      description = "A flake for my Dart project";

      inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";
      };

      outputs = { self, nixpkgs, flake-utils }:
        flake-utils.lib.eachDefaultSystem (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            # Lingkungan pengembangan
            devShells.default = pkgs.mkShell {
              packages = [
                pkgs.dart # Contoh untuk minat Anda di Dart
                pkgs.flutter
              ];
            };

            # Paket custom
            packages.default = pkgs.stdenv.mkDerivation { /* ... */ };
          }
        );
    }
    ```

4.  **Terminologi Kunci:**
    - **`flake.nix`:** File entri utama untuk sebuah Flake.
    - **`flake.lock`:** File yang dihasilkan secara otomatis, mengunci versi hash dari semua `inputs`.
    - **`inputs`:** Dependensi eksternal dari Flake Anda (misalnya, repositori Git atau Flake lain).
    - **`outputs`:** Apa yang disediakan oleh Flake Anda (paket, lingkungan dev, modul NixOS, dll.).
5.  **Daftar Isi:**
    - Mengaktifkan Fitur Eksperimental Flakes
    - Anatomi `flake.nix`: `description`, `inputs`, `outputs`
    - Menentukan Input dan Memahami `flake.lock`
    - Mendefinisikan Output: `packages`, `devShells`, `apps`
    - Menggunakan Flake: `nix build`, `nix develop`, `nix run`
    - Menggunakan `flake-utils` untuk menyederhanakan kode cross-platform
6.  **Sumber Referensi:**
    - [Official Nix Manual: Flakes](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html)
    - [Practical Nix Flakes](https://www.tweag.io/blog/2020-05-25-flakes/) (Blog oleh Tweag)
    - [Zero to Nix: Flakes](https://www.google.com/search?q=https://zero-to-nix.com/concepts/flakes)
7.  **Interoperabilitas:** Ini adalah modul kunci untuk interoperabilitas. Dalam `devShells`, Anda bisa menyertakan _toolchain_ untuk bahasa apa pun: Dart/Flutter, Rust (dengan `rust-overlay`), Python (dengan `poetry2nix` atau `mach-nix`), dll. Ini menunjukkan kekuatan Nix dalam menciptakan lingkungan yang konsisten untuk teknologi apa pun.

---

### **Fase 3: Mahir – Menguasai NixOS dan Konfigurasi Sistem (Tingkat Mahir)**

**Tujuan Fase:** Mampu menginstal, mengkonfigurasi, dan mengelola seluruh sistem operasi NixOS secara deklaratif, termasuk layanan, pengguna, dan konfigurasi pengguna (dotfiles).

---

#### **Modul 3.1: Arsitektur dan Konfigurasi Dasar NixOS**

1.  **Deskripsi Konkret:** Anda akan beralih dari mengelola paket ke mengelola seluruh sistem operasi. Modul ini mencakup instalasi NixOS dan pemahaman file konfigurasi utamanya, `configuration.nix`.
2.  **Konsep Dasar dan Filosofi:** NixOS membawa ide-ide Nix ke tingkat sistem operasi. Seluruh konfigurasi sistem—dari kernel, paket yang diinstal, hingga layanan yang berjalan—didefinisikan dalam satu set file Nix. Ini memungkinkan rollback atomik dari seluruh konfigurasi sistem.
3.  **Sintaks Dasar/Contoh Implementasi Inti:**

    ```nix
    # File: /etc/nixos/configuration.nix
    { config, pkgs, ... }:

    {
      imports = [ ./hardware-configuration.nix ];

      boot.loader.grub.enable = true;
      # ...

      # Mengaktifkan layanan jaringan
      networking.hostName = "nixos-server";

      # Menginstal paket secara global di sistem
      environment.systemPackages = with pkgs; [
        vim
        git
        wget
      ];

      # Mengaktifkan layanan web server
      services.nginx.enable = true;

      system.stateVersion = "23.11"; # Jangan pernah mengubah ini secara sembarangan
    }
    ```

4.  **Terminologi Kunci:**
    - **`configuration.nix`:** File konfigurasi utama untuk sistem NixOS.
    - **`nixos-rebuild switch`:** Perintah untuk menerapkan konfigurasi baru dan menjadikannya generasi boot saat ini.
    - **Generation (Generasi):** Snapshot dari konfigurasi sistem Anda. Anda dapat boot ke generasi sebelumnya jika terjadi masalah.
    - **Module System:** Sistem yang kuat yang memungkinkan konfigurasi dibagi menjadi file-file logis yang dapat digunakan kembali dan digabungkan.
5.  **Daftar Isi:**
    - Proses Instalasi NixOS
    - Struktur `configuration.nix`
    - Perintah `nixos-rebuild` (switch, boot, test)
    - Memahami Konsep Generasi dan Rollback
    - Menambahkan Paket ke Sistem
    - Mencari Opsi Konfigurasi NixOS
6.  **Sumber Referensi:**
    - [NixOS Manual](https://nixos.org/manual/nixos/stable/)
    - [NixOS Options Search](https://search.nixos.org/options)
7.  **Visualisasi:**
    - Diagram yang menunjukkan bagaimana `nixos-rebuild` mengambil `configuration.nix`, mengevaluasinya, membangun semua komponen di `/nix/store`, dan kemudian membuat entri boot baru dan symlink `/run/current-system`.

---

#### **Modul 3.2: Home Manager: Konfigurasi Dotfiles Deklaratif**

1.  **Deskripsi Konkret:** Pelajari cara mengelola file konfigurasi di direktori home Anda (dotfiles seperti `.bashrc`, `.gitconfig`) secara deklaratif menggunakan Home Manager.
2.  **Konsep Dasar dan Filosofi:** Home Manager menerapkan prinsip-prinsip NixOS ke ruang pengguna. Ini memungkinkan Anda untuk memiliki konfigurasi pengguna yang reproduktif dan dapat dibawa ke mesin mana pun (bahkan non-NixOS) yang menjalankan Nix.
3.  **Sintaks Dasar/Contoh Implementasi Inti:**

    ```nix
    # File: ~/.config/nixpkgs/home.nix
    { config, pkgs, ... }:

    {
      home.username = "nama_pengguna";
      home.homeDirectory = "/home/nama_pengguna";

      # Paket khusus pengguna
      home.packages = with pkgs; [
        neovim
        ripgrep
      ];

      # Mengelola git secara deklaratif
      programs.git = {
        enable = true;
        userName = "Nama Anda";
        userEmail = "email@anda.com";
      };

      home.stateVersion = "23.11";
    }
    ```

4.  **Terminologi Kunci:**
    - **Dotfiles:** File konfigurasi di direktori home, biasanya diawali dengan titik (misalnya, `.zshrc`).
    - **Home Manager:** Alat dan koleksi modul Nix untuk mengelola lingkungan pengguna.
5.  **Daftar Isi:**
    - Instalasi dan Konfigurasi Home Manager (sebagai modul NixOS atau standalone)
    - Struktur `home.nix`
    - Mengelola Paket dengan `home.packages`
    - Menggunakan Opsi Program (Git, Zsh, Neovim, dll.)
    - Membuat file konfigurasi kustom dengan `home.file`
6.  **Sumber Referensi:**
    - [Home Manager Manual](https://www.google.com/search?q=https://nix-community.github.io/home-manager/index.html)
    - [Home Manager Options Search](https://nix-community.github.io/home-manager/options.html)

---

### **Fase 4: Pakar – Aplikasi Skala Enterprise dan Lanjutan (Tingkat Pakar)**

**Tujuan Fase:** Mampu menerapkan Nix dalam konteks profesional yang kompleks, termasuk CI/CD, deployment multi-node, keamanan, dan pengembangan modul kustom.

---

#### **Modul 4.1: Continuous Integration/Deployment (CI/CD) dengan Nix**

1.  **Deskripsi Konkret:** Pelajari cara memanfaatkan Nix untuk menciptakan pipeline CI/CD yang sangat andal dan cepat di platform seperti GitHub Actions atau GitLab CI.
2.  **Konsep Dasar dan Filosofi:** Karena Nix build bersifat murni dan dapat di-cache, ia sangat ideal untuk CI. Build yang berhasil di mesin pengembang akan berhasil di CI. Dengan cache biner seperti `cachix`, build yang sudah pernah dibuat tidak perlu dibuat ulang, mempercepat pipeline secara dramatis.
3.  **Sintaks Dasar/Contoh Implementasi Inti:**
    ```yaml
    # File: .github/workflows/ci.yml
    name: "CI with Nix"
    on: [push, pull_request]
    jobs:
      build:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v3
          - uses: cachix/install-nix-action@v20
            with:
              nix_path: nixpkgs=channel:nixos-unstable
          - uses: cachix/cachix-action@v12
            with:
              name: my-cache # Nama cache biner Anda di Cachix
              authToken: "${{ secrets.CACHIX_AUTH_TOKEN }}"
          - run: nix-build # Atau 'nix build' jika menggunakan flakes
    ```
4.  **Terminologi Kunci:**
    - **Binary Cache:** Server yang menyimpan hasil build (paket) dari Nix Store, memungkinkan pengguna lain untuk mengunduhnya daripada membangun dari awal.
    - **`cachix`:** Layanan populer untuk hosting binary cache pribadi.
5.  **Daftar Isi:**
    - Prinsip CI/CD yang Reproduktif
    - Menggunakan Nix di GitHub Actions
    - Menyiapkan Binary Cache dengan `cachix`
    - Membangun dan Menjalankan Tes dalam Lingkungan Nix yang Terisolasi
    - Studi Kasus: Membangun artefak rilis yang statis
6.  **Sumber Referensi:**
    - [Cachix - Official Website](https://www.cachix.org/)
    - [GitHub Action for installing Nix](https://github.com/cachix/install-nix-action)

---

#### **Modul 4.2: Deployment Multi-Node (NixOps & Colmena)**

1.  **Deskripsi Konkret:** Pelajari alat untuk menyebarkan konfigurasi NixOS ke beberapa mesin secara bersamaan, baik itu server fisik, mesin virtual, atau cloud instance.
2.  **Konsep Dasar dan Filosofi:** Alat-alat ini memperluas model deklaratif NixOS ke seluruh infrastruktur. Anda mendefinisikan seluruh jaringan mesin dalam satu set file Nix dan menyebarkannya dengan satu perintah.
3.  **Sintaks Dasar/Contoh Implementasi Inti:**

    - Konsepnya adalah mendefinisikan beberapa mesin dalam file Nix:
    <!-- end list -->

    ```nix
    # Contoh konseptual Colmena
    {
      meta = {
        # ...
      };

      node-1 = { ... }: import ./server1.nix;
      node-2 = { ... }: import ./server2.nix;
    }
    ```

4.  **Terminologi Kunci:**
    - **`NixOps`:** Alat klasik untuk deployment NixOS.
    - **`Colmena`:** Alat modern berbasis Flake untuk deployment NixOS, sering dianggap lebih sederhana dan lebih cepat.
5.  **Daftar Isi:**
    - Perbandingan NixOps vs. Colmena
    - Menyiapkan Proyek Colmena dengan Flakes
    - Mendefinisikan Kumpulan Mesin (Hive)
    - Menyebarkan Konfigurasi dengan `colmena apply`
    - Mengelola Rahasia (Secrets) dengan `agenix` atau `sops-nix`
6.  **Sumber Referensi:**
    - [Colmena Documentation](https://colmena.cli.rs/)
    - [NixOps Manual](https://www.google.com/search?q=https://nixos.org/manual/nixops/stable/)
    - [sops-nix for secrets management](https://github.com/Mic92/sops-nix)

---

#### **Modul 4.3: Keamanan dalam Ekosistem Nix**

1.  **Deskripsi Konkret:** Pelajari bagaimana fitur-fitur Nix dapat dimanfaatkan untuk meningkatkan postur keamanan sistem dan aplikasi Anda.
2.  **Konsep Dasar dan Filosofi:** Reproduktifitas dan model deklaratif memungkinkan auditabilitas yang tinggi. Anda tahu persis apa yang ada di sistem Anda dan dari mana asalnya. Pinning dependensi melalui `flake.lock` mencegah serangan supply chain tertentu.
3.  **Sintaks Dasar/Contoh Implementasi Inti:**
    ```bash
    # Menggunakan nix-vuln untuk memindai kerentanan di flake.lock Anda
    nix-shell -p nix-vuln --run "nix-vuln flake"
    ```
4.  **Terminologi Kunci:**
    - **Supply Chain Attack:** Serangan yang menargetkan perangkat lunak dengan menyuntikkan kode berbahaya ke dalam salah satu dependensinya.
    - **Pinning:** Mengunci dependensi ke versi hash spesifik, mencegah pembaruan yang tidak terduga atau berbahaya.
5.  **Daftar Isi:**
    - Mengunci Dependensi dengan Flakes untuk Mencegah Serangan Supply Chain
    - Memindai Kerentanan dengan `nix-vuln`
    - Membangun Lingkungan Minimalis untuk Aplikasi (Docker images dari Nix)
    - Auditabilitas Konfigurasi NixOS
    - Pengerasan (Hardening) Konfigurasi NixOS
6.  **Sumber Referensi:**
    - [nix-vuln GitHub](https://www.google.com/search?q=https://github.com/flyingcircusio/nix-vuln)
    - [NixOS Security Hardening Guide](https://www.google.com/search?q=https://nixos.wiki/wiki/Security_Hardening_Guide)

---

### **Sumber Daya Komunitas & Validasi Keahlian**

- **Komunitas:**
  - **NixOS Discourse:** Forum resmi dan tempat terbaik untuk bertanya. [https://discourse.nixos.org/](https://discourse.nixos.org/)
  - **NixOS Wiki:** Sumber daya yang dikelola komunitas dengan banyak panduan praktis. [https://nixos.wiki/](https://nixos.wiki/)
  - **Matrix/IRC:** Untuk diskusi real-time, ada banyak kanal yang didedikasikan untuk Nix/NixOS.
- **Sertifikasi & Validasi Keahlian:**
  - Saat ini, tidak ada program sertifikasi formal untuk Nix/NixOS.
  - Keahlian divalidasi melalui kontribusi praktis:
    1.  **Kontribusi ke `nixpkgs`:** Memaketkan perangkat lunak baru atau memperbaiki paket yang ada adalah bukti keahlian yang sangat dihargai.
    2.  **Portofolio Proyek:** Memiliki konfigurasi NixOS dan proyek berbasis Flake yang dikelola dengan baik di profil GitHub Anda.
    3.  **Partisipasi aktif di komunitas:** Membantu pengguna lain di Discourse menunjukkan pemahaman yang mendalam.

### **Hasil Pembelajaran (Learning Outcomes)**

Setelah menyelesaikan kurikulum ini, Anda akan mampu:

1.  **Menjelaskan dan Menerapkan** prinsip-prinsip inti Nix (reproduktifitas, deklaratif, kemurnian).
2.  **Mengelola paket dan lingkungan pengembangan** yang terisolasi dan reproduktif untuk proyek apa pun (termasuk Dart/Flutter, Python, Rust, dll.).
3.  **Menulis ekspresi Nix dan Flakes** untuk memaketkan perangkat lunak dan mendefinisikan output proyek yang kompleks.
4.  **Menginstal, mengkonfigurasi, dan mengelola** sistem operasi NixOS secara deklaratif dari awal hingga akhir.
5.  **Mengelola konfigurasi pengguna (dotfiles)** secara reproduktif menggunakan Home Manager.
6.  **Mengintegrasikan Nix ke dalam alur kerja CI/CD** untuk build yang andal dan cepat.
7.  **Menerapkan dan mengelola infrastruktur multi-node** menggunakan alat seperti Colmena.
8.  **Menganalisis dan meningkatkan keamanan** sistem berbasis Nix.

---

- **[Domain Spesifik][domain-spesifik]**

[domain-spesifik]: ../../README.md
