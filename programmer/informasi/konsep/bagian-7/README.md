# Reusabilitas & Maintainability

---

# Inti — definisi singkat

* **Reusabilitas**: kemampuan potongan kode (fungsi, modul, paket) untuk dipakai ulang di konteks/ proyek lain tanpa perubahan signifikan.
* **Maintainability**: kemudahan memodifikasi, memperbaiki, atau memperluas kode dari waktu ke waktu (termasuk bugfix, fitur, migrasi), dengan risiko regresi minimum.

Keduanya berkaitan: kode yang reusable cenderung lebih modular dan lebih mudah dipelihara, tetapi fokus proses & dokumentasi adalah kunci agar reuse berlangsung aman.

---

# Prinsip desain inti (prioritas)

1. **Single Responsibility Principle (SRP)** — tiap modul/kelas punya satu alasan untuk berubah.
2. **Modularity & Low Coupling / High Cohesion** — modul harus fokus (cohesion tinggi) dan tergantung sedikit pada modul lain (coupling rendah).
3. **Abstraction & Interfaces** — bergantung pada kontrak (interface/abstraksi), bukan implementasi.
4. **Composition over Inheritance** — komposisi lebih fleksibel dan lebih mudah diuji.
5. **Explicit API & Encapsulation** — sembunyikan detail internal, ekspor API minimal.
6. **DRY (Don’t Repeat Yourself)** — hindari pengulangan logika; gunakan utility/ library.
7. **KISS & YAGNI** — jangan over-engineer; tambah kompleksitas hanya bila diperlukan.
8. **Small, well-documented commits & semantic versioning** — memudahkan tracking perubahan dan kompatibilitas.

---

# Pola & praktik konkret untuk reusabilitas

* **Library boundary**: pisahkan `lib/src/` (implementasi privat) dan `lib/<public_api>.dart` (ekspos hanya apa perlu).
* **Contracts / interfaces**: definisikan abstraksi (Dart: abstract class; Lua: table-of-functions contract).
* **Dependency injection**: instantiate dependencies di level aplikasi, bukan di dalam modul.
* **Extension points**: sediakan hooks atau strategi pattern agar fitur dapat diperluas tanpa ubah kode inti.
* **Adapter/wrapper**: sediakan adapter untuk mengakomodasi API eksternal sehingga implementasi utama tetap stabil.
* **Minimal, stable public API**: versi minor menambahkan fitur, major breaking changes — patuhi semver.

---

# Praktik & proses maintainability (engineering)

* **Automated tests**: unit tests (fast), integration tests (focus contract), end-to-end where perlu. Coverage bukan tujuan tunggal — kualitas test lebih penting.
* **Static analysis & formatting**: pakai linters + formatter (otomatis via pre-commit/CI).
* **CI/CD**: setiap PR lewat pipeline yang menjalankan lint/test/build.
* **Code review**: review untuk desain API, tidak hanya style.
* **Changelog & release notes**: tulis breaking changes, migration steps.
* **Deprecation policy**: tandai API deprecated selama 1–2 rilis minor sebelum dihapus.
* **Security & dependency updates**: automated dependency scanning dan scheduled updates; audit supply chain untuk packages kritikal.
* **Observability**: log yang cukup, telemetry untuk library (opsional) agar pengguna bisa debug integrasi.
* **Refactoring cycles**: refactor kecil berkala, jangan tunda technical debt.

---

# Metrik yang berguna (operasional)

* **Code churn**: file yang sering berubah → indikasi desain buruk.
* **Cyclomatic complexity**: fungsi/ method kompleksitas tinggi → kandidat refactor.
* **Test coverage (per file & per module)**: gunakan sebagai indikator, tapi prioritaskan meaningful tests.
* **Issue/bug density**: fungsi/moudle yang menghasilkan banyak bug → perbaiki desain.
* **Time to restore (MTTR)** and **time to change** — metrik proses tim.

---

# Tooling rekomendasi & persiapan (singkat, actionable)

**Untuk Dart**

* Siapkan: **Dart SDK**, editor + LSP (Neovim: `dart` LSP via `nvim-lspconfig`), `pub`/`dart pub`.
* Tools: `dart analyze` (static analysis), `dart format` (formatter), `dart test` (unit test), `package:mocktail`/`mockito` (mock), `melos` (monorepo management, optional).
* Package structuring: `lib/src/` + `lib/<public_api>.dart`. Gunakan `example/` untuk contoh penggunaan.

**Untuk Lua / Neovim plugin**

* Siapkan: `lua`/`luajit`, `luarocks` (opsional). Untuk Neovim: `nvim` + plugin manager (Packer/Lazy).
* Tools: `luacheck` (lint), `stylua` (formatter), `busted` (unit test), `luacov` (coverage).
* Struktur plugin/module: `lua/<plugin>/init.lua` sebagai public entry, implementasi di `lua/<plugin>/src/*.lua`. Gunakan `README.md` dan `doc/` untuk dokumentasi help (Neovim :help).

---

# Contoh praktis singkat — pola publik/privat & reuse

## Dart — struktur paket & contoh `lib/src` + public export

**Struktur proyek singkat**

```
my_pkg/
  pubspec.yaml
  lib/
    my_pkg.dart         <-- public API (exports)
    src/
      utils.dart        <-- implementasi
      cache.dart
  test/
    utils_test.dart
```

**lib/my_pkg.dart**

```dart
export 'src/utils.dart' show computeHash;
export 'src/cache.dart' show Cache;
```

*Penjelasan:* `export` mengkontrol API publik; hanya `computeHash` dan `Cache` diekspos.

**lib/src/utils.dart**

```dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

String computeHash(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
```

**Penjelasan kata-per-kata (poin utama):**

* `String computeHash(String input) {`

  * `String` : tipe return fungsi.
  * `computeHash` : nama fungsi.
  * `(String input)` : parameter `input` bertipe `String`.
* `final bytes = utf8.encode(input);` : konversi string ke bytes; `final` menunjuk referensi immutable.
* `sha256.convert(bytes)` : fungsi hashing; hasil `digest`.
* `return digest.toString();` : mengembalikan representasi heksadesimal.

**Mengapa ini reusable & maintainable**

* Fungsi `computeHash` kecil, pure, tanpa efek samping → mudah diuji & dipakai di konteks lain.
* Implementasi terpusat di `src/` tapi publik melalui `lib/my_pkg.dart` → memungkinkan ubah implementasi tanpa mengubah pengguna.

## Lua — module pattern & Neovim safe entry

**Struktur**

```
myplugin/
  lua/
    myplugin/
      init.lua          -- public entry
      src/
        utils.lua
        cache.lua
  README.md
```

**lua/myplugin/init.lua**

```lua
local utils = require('myplugin.src.utils')
local cache = require('myplugin.src.cache')

local M = {}
M.compute_hash = utils.compute_hash
M.Cache = cache.new
return M
```

**Penjelasan kata-per-kata (poin):**

* `local utils = require('myplugin.src.utils')` : muat module internal.
* `local M = {}` : table public module.
* `M.compute_hash = utils.compute_hash` : expose fungsi essential saja.
* `return M` : pengguna `require('myplugin')` mendapat table `M`.

**lua/myplugin/src/utils.lua**

```lua
local M = {}
local sha256 = require('sha2')  -- asumsi luar paket tersedia

function M.compute_hash(s)
  return sha256.hex(s)
end

return M
```

* Fungsi sederhana, pure — mudah diuji dan reusable.

---

# Contoh CI minimal & release flow (GitHub Actions)

## Workflow: lint → test → build → publish (Dart example)

```yaml
name: CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dart-lang/setup-dart@v1
      - name: Get dependencies
        run: dart pub get
      - name: Format check
        run: dart format --set-exit-if-changed .
      - name: Static analysis
        run: dart analyze
      - name: Run tests
        run: dart test --coverage
```

**Penjelasan singkat:** jalankan langkah-langkah otomatis setiap PR; cegah merge jika lint/test gagal.

## Workflow: Lua (busted + luacheck)

* Steps: checkout → setup Lua (tooling via action or container) → `luacheck .` → `busted --verbose`.
* Untuk Neovim plugin, jalankan juga `nvim --headless -c 'luafile tests/test.lua' -c qa` untuk integrasi.

---

# Versioning, deprecation & compatibility

* Gunakan **SemVer**: `MAJOR.MINOR.PATCH`.

  * BREAKING change → bump MAJOR.
  * Add non-breaking feature → bump MINOR.
  * Bugfix → bump PATCH.
* **Deprecation policy**: beri `@deprecated` / comment di API, update changelog, tetap pertahankan implementasi selama setidaknya 1–2 rilis minor. Sediakan migration guide.
* **Feature flags** untuk perubahan besar agar pengguna dapat migrasi bertahap.

---

# Keamanan supply chain & dependency hygiene

* Automate dependency updates (dependabot, renovate) + review breaking updates.
* Pin transitive dependencies bila perlu (lockfile).
* Audit native/FFI deps (C binaries) untuk plugin Lua yang memuat modul C.
* Jangan mempublish credentials; gunakan secrets di CI.

---

# Checklist praktis untuk Anda — terapkan sekarang

1. **Modularisasi:** setiap fitur utama → module/package terpisah.
2. **API public minimal:** buat file ekspor (Dart: `lib/<api>.dart`, Lua: `init.lua`) yang hanya expose API publik.
3. **Abstraksi untuk dependensi eksternal:** buat interface/contract.
4. **Automated tests:** setiap modul punya unit test + CI menjalankan test.
5. **Static analysis + format:** lint + format di pre-commit + CI.
6. **CI pipeline:** lint → test → build → release checks.
7. **SemVer & changelog:** gunakan `CHANGELOG.md` dan aturan deprecate.
8. **Documentation & examples:** minimal `README.md` + `example/`.
9. **Security:** setup dependabot/renovate; review major updates.
10. **Observability & logs** (untuk library: tambahkan verbose/debug hooks yang bisa dinyalakan pengguna).

---

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-6/README.md
[selanjutnya]: ../bagian-8/README.md

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
