# Komposisi & Enkapsulasi

---

# Inti singkat (definisi & perbedaan)

* **Komposisi**: teknik membangun objek/sistem dengan **menggabungkan** objek-objek kecil (has-a) sehingga fitur dibentuk dari bagian yang dapat diganti/diujicoba. Prinsip timurannya: *favor composition over inheritance*. Keunggulan: fleksibilitas, pengujian (unit test) lebih mudah, mengurangi coupling.
* **Enkapsulasi**: menyembunyikan detail implementasi (state/internal data) dan mengekspos API publik terbatas (getter/setter, method). Tujuan: menjaga invariants, mencegah konsumsi langsung state internal, memudahkan refaktor tanpa memecah pengguna kode.

Keduanya saling melengkapi: komposisi menyusun struktur dari bagian; enkapsulasi menjaga bagian-bagian itu tidak bocor ke luar.

---

# Mengapa ini penting (ringkas teknis)

* Mengurangi *tight coupling* → mempermudah penggantian komponen (mocking, testing).
* Memperjelas *separation of concerns* → tiap modul/component punya tanggung jawab tunggal.
* Enkapsulasi melindungi invariants → meminimalkan bug akibat akses langsung ke field internal.
* Memudahkan maintenance & evolusi API (bisa ubah implementasi internal tanpa mengubah kontrak publik).

---

# Pola dan teknik praktis

* **Dependency Injection (DI)** — injeksikan dependensi melalui konstruktor atau setter daripada membuat di dalam objek. Mempermudah test dan penggantian implementasi.
* **Strategy Pattern** — perilaku dapat diganti dengan mengganti objek strategi yang dikomposisikan.
* **Decorator / Wrapper** — tambah fungsionalitas dengan membungkus objek yang sudah ada.
* **Factory / Builder** — buat objek komposit kompleks sambil tetap menjaga enkapsulasi pembuatan.
* **Module scope / closure privacy (Lua)** — gunakan closure untuk membuat data privat.
* **Library/private names (Dart)** — gunakan `_` (underscore) untuk private pada level library; letakkan implementasi di `lib/src/` dan ekspor yang perlu di `lib/<api>.dart`.

---

# Contoh 1 — Dart: Komposisi + Enkapsulasi + Dependency Injection

**Identitas & persiapan (Dart)**

* Dibuat oleh Google; runtime/VM & tooling kombinasi C++/Dart.
* Untuk pengembangan/modifikasi: pasang **Dart SDK**, editor (VSCode/Neovim + LSP `dart`), `dart test`, atur `pubspec.yaml`.
* Untuk memodifikasi runtime/kompiler: C++ + GN/Ninja + repo `dart-lang/sdk`.

**Kode (Dart)** — contoh service komposit dengan enkapsulasi:

```dart
// lib/src/logger.dart
class Logger {
  void log(String msg) => print('[LOG] $msg');
}

// lib/src/storage.dart
class Storage {
  final Map<String, String> _data = {}; // private internal storage

  void save(String key, String value) {
    _data[key] = value;
  }

  String? _get(String key) => _data[key]; // private helper
}

// lib/user_service.dart
import 'src/logger.dart';
import 'src/storage.dart';

class UserService {
  final Logger _logger;      // private dependency
  final Storage _storage;    // private dependency

  UserService(this._logger, this._storage); // dependency injection via constructor

  void createUser(String id, String name) {
    _storage.save(id, name);             // enkapsulasi: client tidak lihat _data
    _logger.log('User created: $id');    // delegasi ke komponen logger
  }

  String? getUser(String id) => _storage._get(id); // <-- anti-pattern: exposes private
}
```

**Penjelasan kata-per-kata (garis utama; tiap baris penting)**

* `class Logger {`

  * `class` : deklarasi kelas.
  * `Logger` : nama kelas.

* `void log(String msg) => print('[LOG] $msg');`

  * `void` : tipe return (tidak mengembalikan nilai).
  * `log` : nama method.
  * `(String msg)` : parameter bertipe `String` bernama `msg`.
  * `=>` : shorthand untuk body single-expression (arrow function).
  * `print('[LOG] $msg')` : cetak ke stdout.

* `final Map<String, String> _data = {};`

  * `final` : immutable reference (field tidak dapat di-reassign).
  * `Map<String, String>` : tipe map kunci String → nilai String.
  * `_data` : nama field — leading underscore membuatnya **private pada library**.
  * `= {};` : inisialisasi dengan literal map kosong.

* `void save(String key, String value) { _data[key] = value; }`

  * `save` : API publik untuk menyimpan; internal `_data` diubah di sini — konsisten dengan enkapsulasi.

* `String? _get(String key) => _data[key];`

  * `_get` : helper private (underscore).
  * `String?` : tipe nullable String (null-safety).

* `class UserService { final Logger _logger; final Storage _storage;`

  * `UserService` : service komposit.
  * `_logger`, `_storage` : field private menyimpan dependensi — **enkapsulasi dependency**.

* `UserService(this._logger, this._storage);`

  * Konstruktor shorthand: assign argumen ke field (dependency injection via constructor).

* `void createUser(String id, String name) { _storage.save(id, name); _logger.log('User created: $id'); }`

  * `createUser` : API publik; melakukan operasi komposit (delegasi ke Storage dan Logger). Pengguna `UserService` tidak tahu implementasi `Storage._data`.

* `String? getUser(String id) => _storage._get(id); // <-- anti-pattern`

  * Mengakses `_get` private dari `Storage` di luar file `storage.dart` akan **gagal** jika `UserService` berada di library lain. Menunjukkan *anti-pattern* jika _get diekspos (should provide public getter instead).

**Catatan praktik yang benar**

* Jangan panggil atau expose anggota yang bermula `_` dari luar library. Jika `UserService` dan `Storage` di library yang sama (`lib/src`), private masih terlihat; untuk enkapsulasi antar paket, gunakan API publik yang jelas (`storage.get(...)`) bukan mengakses `_get`.
* Gunakan interface/abstract class jika ingin memudahkan mocking: `abstract class IStorage { void save(...); String? get(...); }`

---

# Contoh 2 — Dart: Perbaikan enkapsulasi & interface untuk testabilitas

```dart
abstract class IStorage {
  void save(String key, String value);
  String? get(String key);
}

class InMemoryStorage implements IStorage {
  final Map<String, String> _data = {};
  @override
  void save(String key, String value) { _data[key] = value; }
  @override
  String? get(String key) => _data[key];
}

class UserService {
  final Logger _logger;
  final IStorage _storage;
  UserService(this._logger, this._storage);

  void createUser(String id, String name) {
    _storage.save(id, name);
    _logger.log('User created: $id');
  }

  String? getUser(String id) => _storage.get(id);
}
```

**Inti:** gunakan `IStorage` (kontrak) — `UserService` bergantung pada abstraksi ⇒ memudahkan unit testing (mock `IStorage`) dan penggantian implementasi (disk, remote).

---

# Contoh 3 — Lua: Komposisi dan Enkapsulasi lewat table + closure

**Identitas & persiapan (Lua)**

* Interpreter: `lua`/`luajit`. Untuk Neovim plugin: letakkan modul di `lua/<modul>.lua`, gunakan `require`. Untuk packaging: `luarocks`. Untuk modifikasi interpreter: C + make.

**Kode (Lua)** — object sederhana dengan private state (closure) dan komposisi strategy:

```lua
-- lua/user_service.lua
local function createStorage()
  local data = {}               -- data private, captured by closure
  return {
    save = function(key, value) data[key] = value end,
    get  = function(key) return data[key] end
  }
end

local function createLogger()
  return {
    log = function(msg) print('[LOG] ' .. msg) end
  }
end

local function createUserService(storage, logger)
  local svc = {}
  function svc.createUser(id, name)
    storage.save(id, name)      -- delegasi ke komponen storage
    logger.log('User created: ' .. id)
  end
  function svc.getUser(id)
    return storage.get(id)
  end
  return svc
end

-- penggunaan (komposisi)
local storage = createStorage()
local logger  = createLogger()
local userService = createUserService(storage, logger)
userService.createUser('u1', 'Alice')
print(userService.getUser('u1'))
```

**Penjelasan kata-per-kata (baris penting)**

* `local function createStorage()`

  * `local` : fungsi lokal (tidak global).
  * `function createStorage()` : definisi fungsi pembuat storage.

* `local data = {}`

  * `data` : table lokal dalam scope `createStorage` — **privat** untuk closure.

* `return { save = function(key, value) data[key] = value end, get = function(key) return data[key] end }`

  * Kembalikan table API yang berisi fungsi `save` dan `get`. Fungsi ini **menangkap** `data` melalui closure sehingga `data` tidak bisa diakses dari luar — *enkapsulasi*.

* `local function createLogger() return { log = function(msg) print('[LOG] ' .. msg) end } end`

  * Logger sederhana yang diekspos sebagai table.

* `local function createUserService(storage, logger)`

  * Buat service yang menerima `storage` dan `logger` sebagai dependensi — **komposisi** & *dependency injection*.

* `function svc.createUser(id, name) storage.save(id, name) logger.log('User created: ' .. id) end`

  * `svc` hanya mengekspos function yang mendelegasikan ke komponen; pengguna `userService` tidak tahu struktur internal `storage.data`.

* `local storage = createStorage()` / `local logger = createLogger()` / `local userService = createUserService(storage, logger)`

  * Komposisi objek terjadi di sini: `userService` dibangun dari dua komponen yang terenkapsulasi.

**Keunggulan pola ini di Lua**

* Closure memberikan privasi tanpa mekanisme private khusus.
* Table sebagai namespace membuat API eksplisit.
* Komponen diganti dengan mudah (mis. buat `createStorage` yang menulis ke file atau DB) tanpa mengubah `createUserService` — *low coupling*.

---

# Enkapsulasi: teknik praktis & jebakan

**Teknik:**

* **Private fields** (`_` di Dart; `local` + closure di Lua).
* **Getters / Setters**: validasi input saat set; kalkulasi saat get.
* **Immutability**: expose read-only views (Dart: `UnmodifiableListView`, Lua: metatable with `__newindex` error).
* **Module API minimal**: ekspor hanya fungsi/objek yang dibutuhkan (`export show` di Dart; `return M` dengan hanya beberapa key di Lua).

**Jebakan:**

* Over-exposure (membuka terlalu banyak API) → sulit refactor.
* Terlalu ketat (menyembunyikan fungsi yang perlu diuji) → membuat testing sulit. Solusi: kalau perlu testing, pertimbangkan visibility di-level library (Dart) atau expose internal hanya untuk test build.
* Menggunakan composition tapi tetap mengekspose implementasi internal (mis. mengembalikan referensi ke structure internal langsung) → break enkapsulasi.

---

# Best practices ringkas

* Gunakan **interface/abstraction** untuk semua dependency eksternal.
* Prefer **composition** untuk fleksibilitas; gunakan inheritance hanya bila ada *is-a* semantik jelas.
* Enforce invariants melalui **method publik** dan hindari expose direct mutable references.
* Untuk API publik paket: letakkan implementasi di `lib/src/` dan hanya export yang perlu di `lib/<api>.dart`.
* Di Lua/Neovim plugin: gunakan `local` untuk semua variabel kecuali API, gunakan `return M` dan dokumentasikan fungsi publik.
* Tulis unit tests untuk tiap komponen; mocking mudah bila dependensi diinjeksi.

---

# Apa yang harus Anda siapkan untuk *mengembangkan / memodifikasi* sendiri

## Untuk Dart

* **Skill:** Dart language (null-safety, generics), OOP, unit testing.
* **Tools:** Dart SDK, `dart test`, editor + LSP (Neovim: coc.lua / nvim-lspconfig + dartls), `pubspec.yaml` management.
* **Practices:** letakkan implementasi di `lib/src/`, kontrol exposure via `export` file; gunakan `mockito` atau `mocktail` untuk mock di test.
* **Debugging:** Dart DevTools, `print` quick trace, `dart analyze`.

## Untuk Lua (terutama Neovim)

* **Skill:** Lua language (closures, metatables), pattern module, Neovim Lua API jika plugin.
* **Tools:** `lua`/`luajit`, `luarocks`, `busted` for tests. For Neovim: understand `runtimepath`, how to put `lua/yourmod/*.lua`, `require` usage, packer/lazy for install.
* **Debugging:** `print`, `vim.notify`, `nvim --headless -c 'lua ...'`, `mobdebug` if needed.
* **Packaging:** ensure `package.path` includes module location; provide clear API in `init.lua`.

---

# Referensi singkat (baca lanjutan)

* Principles: *Design Patterns* (Gamma et al.) — strategy, decorator, factory.
* Dart: official docs (dart.dev) — packages, libraries, visibility.
* Lua: *Programming in Lua* (Ierusalimschy) — closures & module patterns.
* Testing: `dart test`, `busted` (Lua).

---

> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-5/README.md
[selanjutnya]: ../bagian-7/README.md

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
