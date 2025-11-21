
# Fungsi, Modul, dan Namespace

---

# Inti singkat sebelum detil

* **Fungsi**: unit eksekusi yang menerima argumen, melakukan operasi, dan mengembalikan nilai (opsional). Memungkinkan abstraksi, reuse, dan testing.
* **Modul**: unit organisasi kode (file / paket) yang mengekspos API terbatas; memfasilitasi enkapsulasi, pemuatan malas, dependency management.
* **Namespace**: cara mencegah tabrakan nama (name collisions) — di banyak bahasa diwujudkan melalui modul, objek/ table, atau mekanisme prefix/import.

---

# Bagian A — Fungsi (konsep & pola penting)

**Konsep teknis**

* Fungsi punya: *nama* (opsional untuk anonymous), *parameter*, *body*, *return value* (opsional), *scope* (lokal/globlal), *closure* (akses lingkungan lexical).
* **Pure function**: hasil hanya bergantung pada argumen, tanpa efek samping — mudah diuji dan dioptimalkan.
* **Higher-order function**: menerima fungsi sebagai argumen atau mengembalikan fungsi.
* **Closure**: fungsi “menangkap” variabel dari environment lexical-nya.

**Jebakan / perhatian**

* Mutasi state global dari dalam fungsi → efek samping tak terkontrol.
* Variadic argument/optional param berbeda antar bahasa (syntax/semantik).
* Performance: alokasi closure berulang dalam loop dapat menimbulkan overhead.

---

# Bagian B — Modul & Namespace (konsep & praktik)

**Konsep teknis**

* Modul menyusun kode: bisa berupa satu file, paket, atau library. Modul mendefinisikan apa yang diekspos (public API) dan apa yang disembunyikan (private).
* Namespace mencegah tabrakan nama: nama modul, prefix import, atau table/object digunakan sebagai namespace.
* Dependency resolution & loading: mekanisme `import/require` memutuskan kapan/di mana modul di-load — eager vs lazy.

**Praktik**

* Buat API kecil dan stabil; sembunyikan implementasi lewat scope privat.
* Gunakan nama paket/modul lengkap (reverse domain atau nama unik) untuk menghindari konflik.
* Dokumentasikan API (signature, tipe, exceptions/errors).

---

# Bagian C — DART: Fungsi, Modul (library / package), Namespace

### Identitas singkat Dart (penting untuk Anda)

* **Dibuat oleh:** Google.
* **Implementasi / bahasa inti:** runtime (Dart VM) dan alat pengembang core banyak ditulis C++ + Dart untuk beberapa bagian. Tooling (pub, dartfmt, analyzer) dibangun oleh tim `dart-lang`.
* **Sumber resmi:** dart.dev (language tour, libraries, packages).

### Persiapan & persyaratan untuk memodifikasi / mengembangkan

* **Untuk menulis/menggunakan modul:** pasang **Dart SDK**; gunakan `dart`, `dart pub` (atau `flutter` untuk proyek Flutter).
* **Untuk membuat package/modul:** buat `pubspec.yaml`, `lib/` untuk library, `bin/` untuk executable, lalu `dart pub publish` untuk publikasi.
* **Untuk memodifikasi runtime/kompiler:** skill C++, GN/Ninja build, baca repo `dart-lang/sdk`.
* **Tooling dev:** editor (VSCode/Neovim + LSP `dart_language_server`), `dart analyze`, `dart test`, `dart format`.

---

## Contoh Dart — fungsi, modul, namespace (kode + penjelasan kata-per-kata)

**File: lib/math_utils.dart** (modul/library)

```dart
library my_pkg.math_utils;

int add(int a, int b) {
  return a + b;
}

int _privateHelper(int x) {
  return x * 2;
}
```

**Penjelasan kata-per-kata:**

* `library` : direktif opsional yang memberi nama library.
* `my_pkg.math_utils` : identifier nama library; tata nama pakai titik untuk namespace logis.
* `int add(int a, int b) {`

  * `int` : tipe return fungsi `add`.
  * `add` : nama fungsi.
  * `(int a, int b)` : parameter list, `a` dan `b` bertipe `int`.
  * `{` : buka tubuh fungsi.
* `return a + b;`

  * `return` : mengembalikan nilai ke pemanggil.
  * `a + b` : ekspresi penjumlahan.
* `_privateHelper` : nama fungsi dimulai underscore → **privat pada level library** (visible hanya dalam library yang sama).
* `x * 2` : ekspresi perkalian.

**File: lib/api.dart** (mengekspor API)

```dart
export 'math_utils.dart' show add;
```

* `export` : mengekspor simbol dari modul lain melalui file ini.
* `'math_utils.dart'` : path relatif ke file yang diekspor.
* `show add` : hanya mengekspor `add`, tidak mengekspor `_privateHelper`.

**File: bin/main.dart** (menggunakan modul)

```dart
import 'package:my_pkg/api.dart' as api;

void main() {
  var s = api.add(2, 3);
  print(s);
}
```

**Penjelasan kata-per-kata:**

* `import 'package:my_pkg/api.dart' as api;`

  * `import` : memuat library/package.
  * `'package:my_pkg/api.dart'` : URI package (resolusi di `pubspec.yaml`).
  * `as api` : memberikan **prefix namespace** `api` untuk menghindari tabrakan nama.
* `var s = api.add(2, 3);` : gunakan fungsi `add` lewat prefix `api`.

**Catatan privasi/visibility di Dart**

* Identitas private: nama yang dimulai `_` bersifat **private pada level library**, bukan private per file.
* Namespaces: `import ... as prefix` adalah cara membuat namespace eksplisit.

**Cara membuat package Dart singkat**

* `pubspec.yaml` minimal:

```yaml
name: my_pkg
version: 0.1.0
description: Example package
environment:
  sdk: '>=2.12.0 <3.0.0'
```

* `dart pub get` untuk instal deps; `dart pub publish` untuk publish.

---

# Bagian D — LUA: Fungsi, Modul (require), Namespace (table pattern)

### Identitas singkat Lua (penting untuk Anda)

* **Dibuat oleh:** Roberto Ierusalimschy, Luiz Henrique de Figueiredo, Waldemar Celes (PUC-Rio).
* **Implementasi / bahasa inti:** interpreter utama ditulis dalam C (sumber di lua.org).
* **Situs & dokumentasi resmi:** lua.org.

### Persiapan & persyaratan untuk memodifikasi / mengembangkan

* **Untuk menulis/menggunakan modul:** pasang `lua` atau `luajit`; gunakan `luarocks` untuk package management jika perlu.
* **Untuk packaging modul:** tempatkan file `.lua` di `lua/` path dalam plugin atau sesuaikan `package.path`/`package.cpath`.
* **Untuk Neovim plugin development:** gunakan `lua/yourmod/init.lua` atau `lua/yourmod.lua` dan pastikan runtimepath. Packer/Lazy/paq digunakan untuk manajemen plugin.
* **Untuk memodifikasi interpreter:** skill C, build via `make`.

---

## Contoh Lua — modul & namespace (kode + penjelasan kata-per-kata)

**File: lua/my_pkg/math_utils.lua**

```lua
local M = {}

function M.add(a, b)
  return a + b
end

local function privateHelper(x)
  return x * 2
end

M.doubleAndAdd = function(a, b)
  return privateHelper(a) + privateHelper(b)
end

return M
```

**Penjelasan kata-per-kata:**

* `local M = {}`

  * `local` : variabel lokal (privat di file/module).
  * `M` : konvensi nama table/module.
  * `{}` : table kosong, akan bertindak sebagai namespace.
* `function M.add(a, b)` : mendefinisikan field `add` pada table `M` sebagai fungsi; `a`, `b` adalah parameter.
* `local function privateHelper(x)` : fungsi lokal (tidak dimasukkan ke `M`) → *privat pada module*.
* `M.doubleAndAdd = function(a, b) ... end` : menambahkan fungsi lain ke API modul.
* `return M` : modul mengembalikan table `M` sebagai nilai `require`.

**Cara menggunakan modul**

```lua
local math_utils = require('my_pkg.math_utils')
print(math_utils.add(2,3))
```

* `require('my_pkg.math_utils')` : memuat modul; Lua mencari file melalui `package.path` / `package.cpath`.
* `math_utils.add(2,3)` : panggil fungsi di namespace `math_utils`.

**Namespace & table dispatch**

* Di Lua, **table** adalah cara utama membuat namespace. Gunakan `local` untuk menyembunyikan anggota agar private.

**Pengaturan `package.path` singkat**

* Default `package.path` berisi pola seperti `./?.lua;./?/init.lua;...`. Untuk menambahkan direktori:

```lua
package.path = package.path .. ';/home/user/.config/nvim/lua/?.lua'
```

**Neovim plugin (struktur minimal)**

* `~/.config/nvim/lua/myplugin/init.lua` → `return require('myplugin.core')`
* `~/.config/nvim/lua/myplugin/core.lua` → definisikan table API, register commands/autocmd, dan return table.

---

# Bagian E — Pola lanjutan & Best practices (Dart + Lua)

## Dart

* **Library partitioning**: gunakan `lib/src/` untuk implementasi privat dan `lib/<public_api>.dart` yang `export 'src/..' show ...` untuk kontrol exposure.
* **Null-safety**: deklarasikan tipe nullable `T?` vs non-null `T`. Perhatikan `late` untuk inisialisasi terlambat.
* **Packages & pub.dev**: gunakan package semata untuk reuse; berikan dokumentasi dan contoh.
* **Testing & CI**: `dart test`, `dart analyze`, gunakan GitHub Actions untuk CI.

## Lua

* **Module pattern**: `local M = {}` + `return M`. Gunakan `local` untuk variabel privat.
* **Metatables / metamethods**: untuk mengimplementasikan operator overloading, method lookup, etc — advanced namespace pattern.
* **Avoid global**: set `setmetatable(_G, { __newindex = function() error("global assignment") end })` di dev untuk deteksi accidental globals.
* **Neovim**: gunakan `vim.api.*` atau `vim.fn` untuk interoperabilitas; expose API minimal.

---

# Bagian F — Debugging, dokumentasi, dan tooling

## Debug & trace

* **Dart**: `dart --observe` / Dart DevTools (profiler + debugger), `print()` untuk quick trace, `dart analyze` untuk linting.
* **Lua**: REPL `lua`, `luajit -j off` (jika Luajit), debug dengan `mobdebug` atau `print` tracing; gunakan `busted` untuk unit tests.

## Dokumentasi & tipe

* **Dart**: gunakan doc comments `///` dan `dartdoc`. Tulis signature + contoh.
* **Lua**: gunakan komentar dan format seperti EmmyLua annotations (`---@param`, `---@return`) untuk LSP & autocomplete (bermanfaat untuk Neovim & editor).

---

# Bagian G — Checklist persiapan teknis untuk Anda (ringkas, actionable)

### Untuk Dart module/package

1. Pasang **Dart SDK** (`dart --version` untuk verifikasi).
2. Siapkan `pubspec.yaml`.
3. Tempatkan kode publik di `lib/`, implementasi privat di `lib/src/`.
4. Gunakan `export`/`show` untuk mengontrol API.
5. Gunakan `import 'package:.../file.dart' as prefix;` untuk namespace.
6. Jalankan `dart analyze`, `dart test`.

### Untuk Lua module / Neovim plugin

1. Pasang `lua` atau `luajit` dan `luarocks` bila perlu.
2. Susun modul di `lua/yourmod/*.lua`. `init.lua` berguna untuk namespace.
3. Pastikan `package.path` mengandung lokasi modul, atau letakkan sesuai runtimepath Neovim.
4. Gunakan `require('yourmod')` untuk memuat.
5. Untuk Neovim plugin, pelajari `vim.api.nvim_create_user_command`, `vim.keymap.set`, dan packaging dengan Packer/Lazy.
6. Test interaktif di `nvim --headless -c 'lua print(vim.inspect(require("yourmod")))' -c q`.

---

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
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
