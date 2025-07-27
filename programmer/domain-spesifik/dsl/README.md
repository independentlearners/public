Berikut rangkuman **5 bahasa/DSL** yang sering dipandang sebagai pesaing atau alternatif Nix, beserta keunggulan dan kekurangannya:

1. **GNU Guix (Scheme DSL)**

   - **Desain**: Berbasis GNU Guile (dialek Scheme).
   - **Kelebihan**:

     - _Turing‑complete_ dengan kekuatan macro Scheme—mudah membuat fungsi build kompleks.
     - Filosofi reproducible build sama persis dengan Nix karena pakai model derivation yang mirip.
     - Model “transaksi atomic” untuk upgrade/rollback di Guix System (setara NixOS).

   - **Kekurangan**:

     - Kurva belajar Scheme lebih curam dibanding Nix DSL yang “hanya” fungsi murni.
     - Ekosistem paket relatif lebih kecil daripada Nixpkgs.

2. **Bazel (Starlark)**

   - **Desain**: Starlark, subset Python statis untuk build hermetik.
   - **Kelebihan**:

     - Fokus pada _monorepo_ skala besar dan build sangat terdistribusi.
     - Integrasi bagus dengan CI/CD Google‑style, caching remote yang solid.

   - **Kekurangan**:

     - Bukan package manager lengkap—lebih pada orchestrasi build, bukan manajemen paket OS.
     - Ekosistem paket non–Google sifatnya ad hoc (membutuhkan rule pihak ketiga).

3. **Spack (Python‑based DSL)**

   - **Desain**: Skrip Python yang mendeklarasikan paket dan varian kompilasi.
   - **Kelebihan**:

     - Sangat populer di HPC (High–Performance Computing) karena dukungan build varian _compiler_, MPI, GPU.
     - Ekstensi paket cukup mudah—tinggal menulis class Python.

   - **Kekurangan**:

     - Lingkungan build _tidak sepenuhnya_ terisolasi seperti di Nix; bisa ditabrak library sistem.
     - Fokusnya pada scientific stack, bukan sistem desktop/server umum.

4. **Homebrew Formulae (Ruby DSL)**

   - **Desain**: Formula–formula Ruby untuk Mac/Linux.
   - **Kelebihan**:

     - Sangat mudah dipahami bila sudah familiar Ruby; community brew besar.
     - _Bottle_ prebuilt binary banyak tersedia—install cepat.

   - **Kekurangan**:

     - Build biasanya “impure” (mengandalkan toolchain sistem), kurang reproducible 100%.
     - Manajemen konfigurasi sistem keseluruhan tidak tersedia—hanya paket.

5. **Conda (YAML + Python)**

   - **Desain**: Spek paket ditulis dalam YAML, build dilakukan dengan skrip Python.
   - **Kelebihan**:

     - Fokus pada _data science_ dan multi‑platform (Linux/Mac/Win) —manajemen env per proyek.
     - Ecosystem Anaconda besar, banyak paket ilmiah siap pakai.

   - **Kekurangan**:

     - Lewatkan isolasi hermetik; sering tergantung _system channels_ luar.
     - Tidak dirancang untuk manajemen konfigurasi OS.

---

## Mana yang “lebih baik”?

Tidak ada jawaban mutlak—semua bergantung **tujuan** dan **ekosistem**:

- **Butuh OS‑level reproducibility + atomic rollback?**
  Pilih **Nix** atau **Guix**.
- **Monorepo + build skala besar** → **Bazel**.
- **Scientific/HPC stack dengan banyak varian compiler** → **Spack**.
- **Proyek data science multi‑platform** → **Conda**.
- **Install cepat paket umum (terutama di macOS/Linux desktop)** → **Homebrew**.

Secara umum, kalau kamu ingin konsistensi penuh dan manajemen konfigurasi sistem deklaratif, **Nix** (atau jika kamu butuh kekuatan Scheme, **Guix**) tetap juara. Untuk build orchestration murni di monorepo, **Bazel** lebih tepat.

---

- **[Domain Spesifik][domain-spesifik]**

[domain-spesifik]: ../../README.md
