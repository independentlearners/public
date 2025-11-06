▸▸▸──────────────────────────────────────────────────────────────
# Kurikulum Desktop Engineering — Fokus: Sway / Wayland Tooling (TUI configurator → plugin)

📚 RINGKASAN TUJUAN

* Membangun jalur pembelajaran terstruktur (hierarki + konseptual) yang memungkinkan pelajar:
  • Memahami arsitektur Wayland & Sway;
  • Mampu mengonfigurasi dan memodifikasi file konfigurasi Sway dan komponen terkait (bar, notif, wallpaper, locker);
  • Menulis skrip & plugin (Bash / Lua);
  • Merancang dan mengembangkan tooling TUI native (MVP → produksi), termasuk opsi single-binary dan host plugin;
  • Mengimplementasikan efek visual ringan (animasi halus) pada lingkungan Wayland atau mengadaptasi ke DE lain (KDE, GNOME) bila diperlukan.

🎯 AUDIENCE / SASARAN PEMBELAJAR

* Tingkat: Pemula → Menengah → Kontributor
* Prasyarat minimal: nyaman menggunakan Linux (terminal), Git dasar, keinginan mempelajari bahasa scripting.
* Hasil akhir yang diharapkan: peserta mampu membuat konfigurasi DE modular, menulis skrip integrasi, membangun MVP TUI configurator, dan memilih jalur teknis untuk produksi (Dart/Go/Rust/Nelua).

🧭 RUANG LINGKUP DOKUMEN

1. Konsep inti Wayland & peran compositor (Sway), dan hubungan dengan wlroots.
2. Komponen ekosistem yang sering dipakai (bar, notification daemon, wallpaper, locker) — identitas teknis (bahasa) dan bagaimana memodifikasi.
3. Format konfigurasi umum (INI/key=value, JSON/JSONC, TOML, YAML) dan praktik terbaik.
4. Scripting: Bash (wajib), Lua (direkomendasikan untuk plugin).
5. Desain tooling TUI: opsi bahasa implementasi (Dart, Nelua, Go, Rust), trade-off, integrasi plugin.
6. Teknik visual/animasi lembut di Wayland (prinsip, batasan, strategi implementasi).
7. Packaging, CI, distribusi (AUR, .deb/.rpm, static binary).
8. Panduan kontribusi komunitas, template, dan kata kunci riset mandiri.

⚙️ IDENTITAS TEKNOLOGI (ringkasan — siapa dibangun dari bahasa apa)

* **Sway (compositor / tiling window manager)** — dibangun menggunakan **C**; memakai library **wlroots** (C) sebagai layer compositor. ([Wikipedia][1])
* **wlroots** — library modular Wayland untuk compositor, ditulis **C**. ([GitHub][2])
* **Waybar (status bar populer untuk wlroots/Sway)** — implementasi utama berisi kode C++ (projek di GitHub, modul menggunakan C++). ([git.drkhsh.at][3])
* **Mako (notification daemon)** — implementasi ditulis **C**; konfigurasi sederhana, dipanggil dari Sway lewat `exec`. ([GitHub][4])
* **swaybg / swaylock** — utilitas resmi ekosistem Sway, umumnya ditulis **C** (tool native untuk wallpaper dan screen lock). ([GitHub][5])

(catatan: setiap bagian selanjutnya akan menyertakan “Identitas lengkap + bahasa pembangun” dan apa yang perlu Anda pelajari untuk memodifikasinya — mis. bahasa yang harus dikuasai, toolchain/build system, konsep yang wajib dikuasai seperti Meson/Ninja untuk proyek C, Cargo untuk Rust, dsb.)

🛠️ MENTAL MODEL & PRINSIP PEMBELAJARAN (singkat)

* **Dari konsep → praktek → kontribusi**: pahami arsitektur umumnya, praktikkan konfigurasi minimal, buat eksperimen kecil (skrip/autostart → modul bar → plugin), lalu tingkatkan menjadi komponen yang dapat diuji & dikirimkan.
* **Prioritaskan interoperabilitas**: Sway memanggil banyak tool eksternal (waybar, mako, swaybg) — pelajari cara menghubungkannya sebelum mengubah implementasi internal.
* **MVP cepat**: buat prototipe alur konfigurasi / UI (Dart jika ingin cepat) → stabilkan → refactor core ke bahasa sistem (Go/Rust) bila butuh single-binary/performa.

✅ Output yang akan Anda terima bertahap dari saya (per bagian):

1. Dokumen kurikulum (tahap demi tahap, tiap tahap berisi tujuan, daftar topik, latihan, estimasi jam)
2. Contoh konfigurasi & skrip (plain text) untuk langsung diuji pada Arch/Sway Anda
3. Blueprint proyek TUI (struktur proyek, Cargo.toml / go.mod / pubspec contoh tergantung bahasa pilihan)
4. Daftar kata kunci pencarian & sumber rujukan per topik (agar komunitas bisa riset mandiri)
5. Checklist kontribusi & template PR untuk repo komunitas


[1]: https://en.wikipedia.org/wiki/Sway_%28window_manager%29?utm_source=chatgpt.com "Sway (window manager)"
[2]: https://github.com/swaywm/wlroots?utm_source=chatgpt.com "swaywm/wlroots: A modular Wayland compositor library"
[3]: https://git.drkhsh.at/waybar/file/src/modules/sway/mode.cpp.html?utm_source=chatgpt.com "mode.cpp - waybar - [fork] highly customizable wayland bar - git"
[4]: https://github.com/emersion/mako "GitHub - emersion/mako: A lightweight Wayland notification daemon"
[5]: https://github.com/swaywm/swaybg?utm_source=chatgpt.com "swaywm/swaybg: Wallpaper tool for Wayland compositors"

<!--
Bagus — saya lanjutkan dengan **Tahap 0: Prasyarat & Mindset**. Karena Anda memilih **Dart** sebagai jalur implementasi tooling (prototype → produksi), seluruh langkah di bawah difokuskan agar Anda bisa bergerak cepat dengan Dart + integrasi skrip Lua/Bash. Baca tiap bagian, praktikkan bila perlu, lalu ketik **Lanjutkan** ketika Anda siap untuk saya susun Tahap 1.
▸▸▸──────────────────────────────────────────────────────────────
-->

▸▸▸──────────────────────────────────────────────────────────────
# TAHAP 0 — PRASYARAT & MINDSET (Persiapan lingkungan, pemahaman dasar, checklist cepat)

🎯 TUJUAN TAHAP
Menyiapkan lingkungan kerja dan mental model yang diperlukan untuk:
• Cepat membuat prototype TUI configurator dengan **Dart**;
• Mengintegrasikan skrip/plugin **Lua** atau **Bash** sebagai proses eksternal;
• Memahami bagian-bagian yang mungkin perlu Anda modifikasi di tingkat konfigurasi DE (tanpa harus memodifikasi kode C upstream kecuali diperlukan).

📌 OUTCOME YANG DIHARAPKAN
Setelah tahap ini Anda akan mampu:

* Menjalankan Sway dan komponen ekosistem dasar di mesin pengembangan.
* Menyiapkan Dart SDK dan membuat executable AOT/standalone sederhana.
* Menulis dan menjalankan skrip Bash/Lua yang terintegrasi dengan Sway (mis. modul Waybar custom, helper untuk wallpaper, lock).
* Memahami struktur folder konfigurasi (`~/.config/sway`, `~/.config/waybar`, `~/.config/mako`, dsb.) dan cara reload Sway untuk pengujian cepat.

🔧 LINGKUNGAN & ALAT YANG PERLU DISIAPKAN (ringkas)

* **Sistem operasi:** Linux (Arch Linux direkomendasikan karena lingkungan Sway/Wayland mudah tersedia).
* **Compositor & core tools:** Sway (compositor), wlroots (library compositor). (Identitas teknis: Sway/wlroots ditulis C; Anda **tidak perlu** menguasai C untuk memodifikasi konfigurasi).
* **Komponen ekosistem:** waybar (bar/status), mako (notification daemon), swaybg (wallpaper), swaylock (lockscreen). (Semua ini umumnya tool native C/C++—cukup jalankan/konfigurasi melalui file, tidak wajib ubah source).
* **Bahasa & toolchain pengembangan aplikasi:**

  * **Dart SDK** — `dart` + `pub`/`dart pub` (untuk package), `dart compile exe` untuk AOT/executable.
  * **Editor:** Neovim / Helix / VSCode — sesuaikan preferensi; konfigurasi LSP untuk Dart (analysis server) disarankan.
  * **Scripting & plugin runtime:** **Lua** (interpreter `lua` / `luajit`) dan **Bash** (shell scripting).
* **Version control / CI:** Git, GitHub/GitLab (untuk dokumentasi & contoh repo).
* **Optional tetapi berguna:** alat perekam GIF/screencast (untuk dokumentasi demo), `systemd --user` untuk unit autostart.

📚 KOMPETENSI TEKNIS YANG WAJIB / SANGAT DISARANKAN

1. **Wajib:**

   * Terminal Linux dasar (navigasi, man, systemctl, proses).
   * Bash scripting: variabel, pipes, redirects, fungsi, exit codes.
   * Membaca & mengedit file konfigurasi Sway (`~/.config/sway/config`) — mengenal `exec`, `bindsym`, `include`, `mode`.
   * Dart dasar (OOP, asinkron/`Future`, paket `process` / `Process.start` untuk spawn proses).
   * Penggunaan Git (commit/push/pr).

2. **Sangat disarankan:**

   * Format konfigurasi: JSON/JSONC (Waybar), TOML (jika dipakai), YAML (jika muncul), serta format `key = value` sederhana (mako).
   * Lua dasar (fungsi, tabel) untuk membuat modul kecil yang akan dipanggil sebagai skrip oleh bar atau tool Anda.
   * Cara membuat executable Dart (`dart compile exe`) dan memahami dependency runtime bila ada.

⚙️ LANGKAH-LANGKAH PRAKTIS (setup cepat, urutan direkomendasikan)

1. **Siapkan OS & Sway (jika belum):** instal Sway dan jalankan sesi Wayland. Pastikan Anda bisa: login ke sway, reload config (`swaymsg reload` / `Mod+Shift+c`), dan lihat `~/.config/sway/config`.
2. **Instal komponen bar & notif:** pasang Waybar (atau swaybar), mako, swaybg, swaylock. Uji masing-masing dengan `exec` di config dan reload.
3. **Siapkan Dart SDK:** instal versi stabil terbaru; verifikasi `dart --version`. Buat project Dart sederhana (`dart create -t console-full mytui`) untuk coba-coba.
4. **Siapkan Lua & Bash:** pastikan `lua` atau `luajit` bisa dijalankan di terminal; buat skrip Lua kecil yang mencetak JSON/line output (untuk modul bar).
5. **Prototipe integrasi:** buat skrip Bash yang memanggil skrip Lua, lalu panggil skrip Bash dari Waybar module atau dari `exec` di sway config. Uji alur: (sway) → (waybar module calls) → (bash) → (lua) → output.
6. **Dart prototype:** buat TUI minimal (CLI) di Dart yang bisa spawn proses Lua/Bash dan menampilkan hasilnya. Gunakan `Process.start` / `Process.run` dan tangani stdout/stderr. Komunikasi sederhana via stdout lines.
7. **Build AOT simple:** coba `dart compile exe bin/main.dart` lalu jalankan executable yang dihasilkan. Pastikan integrasi tetap bekerja (spawn child process).

📝 CHECKLIST SETUP AWAL (centang saat selesai)

* [ ] Sway berjalan dan config dasar bisa di-reload
* [ ] Waybar / mako / swaybg / swaylock tersedia dan bisa di-run via `exec`
* [ ] Dart SDK terpasang dan `dart create` berhasil
* [ ] Lua interpreter & Bash tersedia
* [ ] Contoh skrip Lua yang menghasilkan output untuk bar/test module
* [ ] Contoh Dart prototype yang spawn proses eksternal dan menampilkan output
* [ ] Versi kontrol Git inisialisasi di folder kerja

⏱️ ESTIMASI WAKTU PERSIAPAN (perkiraan kasar)

* Setup lingkungan & instalasi komponen: **4–8 jam** (termasuk troubleshooting kecil).
* Belajar dasar Dart & contoh spawn process: **8–16 jam**.
* Prototipe integrasi (Waybar→Bash→Lua→Dart): **8–24 jam**.
  Total persiapan: **~20–48 jam** sebelum Anda bisa mulai Tahap 1 (arsitektur & config Sway) dengan lancar.

🔎 CATATAN PENTING TENTANG MODIFIKASI (siapa dibangun dengan apa — dan apa yang perlu untuk mengubah)

* **Sway / wlroots** — dibangun dengan **C**; jika Anda ingin mengubah perilaku compositor itu sendiri, Anda perlu menguasai C, Meson/Ninja build system, dan protokol Wayland. Untuk kebanyakan tujuan DE engineering, **tidak perlu**—cukup modifikasi config atau buat helper tool eksternal.
* **Waybar / Mako / swaybg / swaylock** — umumnya ditulis C/C++ (Waybar khususnya C++), tetapi Anda **hanya perlu** mengubah konfigurasi dan membuat skrip modul eksternal (dalam Bash/Lua/Dart) yang mereka panggil.
* **Tooling Anda (Dart)** — Anda yang menulisnya: pelajari cara membuat executable AOT, meng-handle argumen CLI, membaca/menulis file config (TOML/JSON), spawn proses, dan menyediakan API sederhana (mis. socket/HTTP/local IPC) agar plugin Lua/Bash dapat berinteraksi.

🔐 KEAMANAN & SANDBoxING (perhatian ringan)

* Menjalankan plugin sebagai proses eksternal lebih aman daripada mengeksekusi kode plugin langsung di binary utama tanpa sandbox. Namun tetap pertimbangkan permission (akses file, jalur eksekusi).
* Untuk versi produksi nanti, dokumentasikan API plugin dan batasan yang diperlukan (apa yang boleh dan tidak boleh dilakukan plugin).

▸▸▸──────────────────────────────────────────────────────────────
<!--
Baik, kita lanjut ke **bagian berikutnya**, yaitu fase **penerapan konsep tingkat lanjut dan penguasaan ekosistem pengembangan dengan Dart**.
Setelah fase sebelumnya (fondasi + CLI architecture + sistem utilitas terminal) kamu kuasai, maka fase ini membawa Dart ke level “engineering” — di mana kamu mulai memadukan *konsep tingkat bahasa*, *arsitektur perangkat lunak*, dan *alat pengembangan profesional*.
---
-->
### 🧩 **Fase 4: Dart Advanced Engineering & CLI Framework Architecture**

Durasi: ±3–5 bulan (jika belajar 4–8 jam/hari)

#### Tujuan utama:

Menjadikan Dart bukan sekadar bahasa pemrograman, melainkan *tooling ecosystem* pribadi, yang bisa kamu jadikan fondasi untuk:

* Membangun **framework CLI modular**, mirip seperti `NestJS`, `FastAPI`, atau `Cobra` (Go).
* Mengintegrasikan sistem **plugin berbasis refleksi dan namespace**, sehingga tools dapat dikembangkan oleh pihak lain.
* Membuat **build system atau project scaffolding** seperti `dart create` atau `flutter create`.
* Membentuk **basis AI-tool integration** (untuk tahap selanjutnya ketika masuk ke pengembangan AI CLI dan TUI).

---

#### 1. **Kedalaman bahasa Dart**

Bahasan lanjutan yang harus benar-benar kamu pahami:

* **Isolate dan concurrency** → paralelisasi CLI, pemrosesan data besar, simulasi job runner.
* **Reflection, Mirrors, dan Metaprogramming** → memungkinkan sistem plugin otomatis.
* **Generics & Type System in-depth** → membuat CLI modular, type-safe, dan dapat diperluas.
* **Stream & Async/Await patterns** → komunikasi antar komponen TUI/CLI.
* **Interop dengan C (via FFI)** → membuka jalan integrasi kernel-level tools dan ekstensi sistem.

---

#### 2. **Arsitektur modular untuk CLI/TUI**

Kamu akan mulai membangun *framework* internal yang terdiri dari:

* **Core runtime module**: menangani parsing argumen, konfigurasi global, logging, dan lifecycle CLI.
* **Command abstraction layer**: memisahkan perintah utama dan subperintah seperti `cli system:build`, `cli config:list`.
* **Plugin system**: memanfaatkan refleksi atau registrasi manual menggunakan `Map<String, Command>`.
* **Event & pipeline system**: agar CLI kamu bisa bereaksi pada event (misalnya build selesai, hook plugin, dsb).

Contoh sederhana (kerangka awal sistem modular):

```dart
abstract class Command {
  String get name;
  String get description;
  Future<void> run(List<String> args);
}

class CommandRegistry {
  final _commands = <String, Command>{};

  void register(Command command) {
    _commands[command.name] = command;
  }

  Future<void> execute(String name, List<String> args) async {
    final cmd = _commands[name];
    if (cmd != null) {
      await cmd.run(args);
    } else {
      print('Perintah tidak ditemukan: $name');
    }
  }
}
```

Struktur seperti ini adalah dasar *plugin manager CLI*, di mana setiap command bisa dikompilasi secara modular.

---

#### 3. **Penguasaan alat bantu pengembangan**

Kamu wajib menguasai:

* **Build tools**: `dart compile exe`, `dart pub global activate`.
* **Project automation**: `melos` untuk manajemen monorepo Dart.
* **Testing framework**: `package:test`, mocking dengan `mockito`.
* **Documentation automation**: `dart doc` dan integrasi ke CI/CD (GitHub Actions).
* **Benchmarking**: `benchmark_harness` untuk mengukur performa CLI.

---

#### 4. **Persiapan ke tahap integrasi sistem**

Setelah kamu bisa membuat CLI framework modular, kamu akan mulai:

* Menghubungkan CLI kamu ke **sistem TUI** (paket `dart_console`, `tui`, atau binding FFI ke `ncurses`).
* Menulis sistem logging dan konfigurasi yang bisa dipanggil lewat GUI/TUI ringan.
* Membuat **template project generator** seperti `flutter create`, tetapi berbasis CLI framework buatanmu sendiri.

---

#### 5. **Keluaran dari fase ini**

Di akhir fase ini, kamu akan memiliki:

* Satu **framework CLI modular buatan sendiri** (native executable `.bin`).
* Sistem plugin reflektif yang dapat memanggil ekstensi baru.
* Tooling sistem seperti:

  ```
  mycli create plugin tui
  mycli build --release
  mycli run --with-plugin analytics
  ```
* Dokumentasi dan tes unit lengkap.

Fase ini akan menjadikanmu seorang **Dart System Engineer** — bukan sekadar developer. Setelah ini, baru masuk ke **Fase 5**, yaitu integrasi ke *AI Command Interface* dan *Desktop Integration Layer* (yang akan menjadi tulang punggung proyek DE builder berbasis TUI yang kamu rencanakan).

<!--
---
Bagus — saya lanjutkan dengan **Fase 5: Integrasi AI & Desktop Environment Tools**. Bagian ini menjembatani kemampuan tooling Dart yang sudah Anda bangun dengan automasi cerdas, orchestration DE, dan interaksi runtime antara core (Dart) dan plugin/script (Lua/Bash). Baca perlahan; setelah memeriksa, ketik **Lanjutkan** untuk saya susun bagian berikutnya (Fase 6: Desain TUI lengkap & contoh implementasi).
-->
▸▸▸──────────────────────────────────────────────────────────────
# FASE 5 — INTEGRASI AI & DESKTOP ENVIRONMENT TOOLS (DART-CENTRIC)

🎯 TUJUAN UTAMA
Menggabungkan AI-assist, orkestrasi konfigurasi DE, dan mekanisme plugin untuk menghasilkan pengalaman konfigurator DE berbasis TUI yang:

* cerdas (saran konfigurasi, perbaikan otomatis),
* dapat diperluas (plugin Lua/Bash),
* dapat di-deploy sebagai executable Dart yang mengendalikan workflow konfigurasi Sway/Wayland.

📌 OUTCOME YANG DIHARAPKAN
Peserta/Anda akan mampu:

* Menyusun arsitektur komunikasi antara core Dart dan plugin eksternal (Lua/Bash).
* Menyediakan API lokal sederhana (IPC: unix socket / stdin-stdout / local HTTP) agar plugin dapat berinteraksi.
* Mengintegrasikan model AI offline/online untuk: rekomendasi, verifikasi konfigurasi, dan generation snippet (opsional).
* Menambahkan fitur safe-execution, sandboxing dasar, dan logging audit untuk plugin.

───────────────────────────────────────────────────────────────────

1. ARSITEKTUR KOMPONEN (ringkas, identitas & peran)
   ───────────────────────────────────────────────────────────────────

Core tooling — **Dart** (bahasa implementasi)

* Identitas: bahasa Dart; executable dibuat via `dart compile exe`.
* Peran: host aplikasi TUI, orchestrator konfigurasi, manajer plugin, UI/UX flow, integrasi AI client.

Plugin / Scripting — **Lua / Bash** (runtime eksternal)

* Identitas: Lua (interpreted) / Bash (shell).
* Peran: implementasi modul-modul kecil (status modules, widget generator, custom hooks), task runner, transformasi config.

Inter-proc comms (IPC)

* Pilihan: Unix Domain Socket, STDIN/STDOUT line protocol, Named pipes, local HTTP (loopback).
* Peran: jalur komunikasi antara Dart core dan plugin; cocok untuk request/response dan event stream.

AI Integration

* Pilihan: local models (ONNX/TensorFlow/Python wrapper) atau layanan cloud (OpenAI, LLMs).
* Peran: saran konfigurasi, penjelasan perubahan, diffs otomatis, dan generation template.

Sway & components

* Sway (C, wlroots) tetap sebagai target yang dikonfigurasi melalui file/script; core mengedit file config lalu memerintahkan `swaymsg reload`/`swaymsg` untuk apply perubahan.

───────────────────────────────────────────────────────────────────
2) POLA KOMUNIKASI & PROTOKOL SEDERHANA (rekomendasi praktis)
───────────────────────────────────────────────────────────────────

A. **Line-based JSON over STDIO (sederhana, reliable)**

* Plugin script dijalankan sebagai proses child (Dart `Process.start`) dan berkomunikasi lewat stdin/stdout.
* Format pesan: satu JSON per baris. Contoh:
  `{"id":"mod1","type":"status_request","payload":{"cmd":"get_cpu"}}\n`
  Plugin membalas:
  `{"id":"mod1","type":"status_response","payload":{"value":"3.2%"}}\n`
* Kelebihan: mudah debugging, tidak perlu soket; cross-platform.

B. **Unix Domain Socket / Local HTTP (lebih fleksibel)**

* Untuk plugin yang berjalan sebagai daemon atau service, gunakan UDS atau loopback HTTP.
* Kelebihan: lebih cocok untuk long-running services, multiple clients, dan monitoring.

C. **Event Bus internal (Dart Streams)**

* Di sisi Dart, gunakan `StreamController.broadcast()` untuk mem-publish event yang dapat dikonsumsi oleh berbagai modul UI.

───────────────────────────────────────────────────────────────────
3) MODEL PLUGIN: LIFE-CYCLE & API (konsep & contoh)
───────────────────────────────────────────────────────────────────

Model: plugin adalah program kecil yang menerima perintah, mengeksekusi, dan merespons. Ada dua mode plugin:

1. **Transient plugin (exec-on-demand)**

   * Dipanggil oleh core saat dibutuhkan; mengembalikan output lalu keluar.
   * Cocok untuk generator snippet, validator config, quick-fix tasks.

2. **Daemon plugin (long-running)**

   * Menjalankan server lokal (UDS/HTTP) menerima perintah berkelanjutan; ideal untuk status bar modules atau watchers.

API minimal yang disarankan:

* `handshake` — versi plugin, capabilities (features list).
* `execute` — jalankan nama aksi + argumen.
* `subscribe` — beri subscribe ke event tertentu (e.g., workspace change).
* `health` — kembalikan status & metadata.

Contoh flow handshake (JSON line):

* Core → Plugin: `{"type":"handshake","version":1}`
* Plugin → Core: `{"type":"handshake_ok","name":"waybar-cpu","version":"0.1","capabilities":["status","poll:1s"]}`

───────────────────────────────────────────────────────────────────
4) AI ASSIST: USE-CASES & INTEGRASI (praktis)
───────────────────────────────────────────────────────────────────

Use-cases praktis:

* **Saran konfigurasi**: input: current sway config; output: suggested keybindings, workspace rules, bar modules.
* **Pengujian & Validasi**: verifikasi syntax, flag konflik, rekomendasi perbaikan (explainable diff).
* **Snippet generation**: generate `waybar` JSON module untuk service custom.
* **Refactor assist**: otomatis merapikan include, move blocks to separate files.

Integrasi teknis:

* **Client-only**: Core Dart memanggil API LLM eksternal (HTTP) dengan payload (config snippet) dan menampilkan hasil di TUI.
* **Local model**: jalankan model via Python microservice dan panggil lewat UDS/HTTP.
* **Safety**: sanitasi output LLM; berikan badge confidence; selalu tampilkan diff dan minta konfirmasi manual sebelum menulis file config produksi.

Privasi & keamanan:

* Jika menggunakan cloud LLM, tampilkan pemberitahuan eksplisit di UI; sediakan opsi disable/upload.
* Batasi akses token di `~/.config/mycli/credentials` dengan permission 600.

───────────────────────────────────────────────────────────────────
5) SANDBOXING & KEAMANAN EKSEKUSI PLUGIN
───────────────────────────────────────────────────────────────────

Pendekatan bertahap (praktis):

* **Mode development:** plugin dapat dijalankan full privileges (developer trusted).
* **Mode produksi (recommended):** jalankan plugin dengan user-limited permissions (systemd --user sandboxing), gunakan chroot/container ringan (podman rootless) jika perlu.
* **Validation & capability flags:** setiap plugin menyatakan capabilities; core menolak plugin yang meminta `fs-write:/etc` tanpa approval manual.

Prinsip minimal:

* Jangan jalankan plugin yang tidak dipercaya dengan akses filesystem sensitif.
* Logging dan audit: semua perubahan yang memodifikasi file config dicatat (timestamp, user action, plugin id).

───────────────────────────────────────────────────────────────────
6) PENERAPAN TEKNIS: EXAMPLE SNIPPETS (conceptual, plain text)
───────────────────────────────────────────────────────────────────

A. Dart: spawn plugin dan konsumsi line-based JSON

* Core (simplified):

  * `final proc = await Process.start('lua', ['plugin.lua']);`
  * Listen `proc.stdout.transform(utf8.decoder).transform(LineSplitter()).listen(handleLine);`
  * Kirim JSON: `proc.stdin.writeln(jsonEncode(message));`

B. Plugin Lua (skeleton) — menunggu stdin line json dan membalas:

* Pseudocode Lua:

  ```
  for line in io.lines() do
    local msg = json_decode(line)
    if msg.type == 'handshake' then
      io.write(json_encode({type='handshake_ok', name='example', version='0.1'}) .. '\n')
      io.flush()
    elseif msg.type == 'execute' then
      -- do work
      io.write(json_encode({type='result', payload=...}) .. '\n')
      io.flush()
    end
  end
  ```

C. Local AI call (Dart) — request→display→confirm:

* Send config snippet to AI service; show response diff in TUI; prompt `Apply? (y/n)`; if `y`, write file and `swaymsg reload`.

───────────────────────────────────────────────────────────────────
7) TESTING & CI (ringkas)
───────────────────────────────────────────────────────────────────

* **Unit tests**: isolasi logic (parsing config, policy rules).
* **Integration tests**: spawn core + plugin (use temp dirs), assert protocol handshake & expected outputs.
* **E2E tests**: use VM/container untuk menjalankan Sway minimal + core; assert file changes.
* **CI pipeline**: GitHub Actions matrix (linux), lint, tests, build `dart compile exe`, pack artifact.

───────────────────────────────────────────────────────────────────
8) RESOURCE & KATA KUNCI PENCARIAN (copy-paste-ready)
───────────────────────────────────────────────────────────────────

* `dart Process.start json line protocol example`
* `lua json decode io.lines example`
* `unix domain socket dart`
* `dart isolate vs process difference`
* `swaymsg reload apply config example`
* `openai text-davinci api config generation example`
* `systemd --user sandboxing ExecStart=ProtectHome=read-only`
* `podman rootless run sandbox`

───────────────────────────────────────────────────────────────────
9) ESTIMASI WAKTU IMPLEMENTASI FASE INI (perkiraan)
───────────────────────────────────────────────────────────────────

* Design protokol & API plugin: **8–16 jam**
* Implement core spawn/handshake (Dart) + one transient plugin (Lua): **16–32 jam**
* Integrasi AI simple (client to LLM API) + UI confirm flow: **12–24 jam**
* Hardening sandboxing & CI tests: **20–40 jam**
  **Total perkiraan:** 56–112 jam (≈14–28 hari kerja pada 4 jam/hari; 7–14 hari pada 8 jam/hari)

───────────────────────────────────────────────────────────────────
PENUTUP (motivasi & langkah aksi singkat)
───────────────────────────────────────────────────────────────────
Fase 5 menghadirkan kemampuan penting: orchestration, keamanan plugin, dan integrasi AI. Jalankan ini bertahap: mulai dari protokol line-based JSON sederhana (cepat dan robust), lalu tingkatkan ke UDS/daemon bila perlu. Untuk AI, prioritaskan workflow “display → confirm → apply” agar pengguna tetap memegang kontrol penuh.
<!--
Jika Anda siap, ketik **Lanjutkan** — saya akan susun **Fase 6: Desain TUI lengkap & contoh implementasi (kerangka proyek Dart, contoh modul plugin, dan template file konfigurasi)**.

Bagus — saya susun **Fase 6: Desain TUI lengkap & contoh implementasi** (fokus penuh ke **Dart**). Bagian ini berisi arsitektur antarmuka TUI, struktur proyek, contoh kode/struktur plugin, template file konfigurasi, panduan ikon/font (Nerd Fonts / Font Awesome), best practice UI/UX TUI, serta checklist pengujian dan estimasi jam. Baca perlahan — jika sudah siap untuk bagian berikutnya, ketik **Lanjutkan**.
-->
▸▸▸──────────────────────────────────────────────────────────────
# FASE 6 — DESAIN TUI LENGKAP & CONTOH IMPLEMENTASI (DART)

🎯 TUJUAN UTAMA
Mendesain dan mengimplementasikan TUI configurator berbasis Dart yang:

* responsif, modular, dan mudah diperluas dengan plugin (Lua/Bash);
* mampu spawn plugin/process, berkomunikasi via JSON line-protocol;
* dapat dikompilasi menjadi executable (`dart compile exe`) untuk distribusi;
* tampil estetis menggunakan ikon font (Nerd Fonts / FontAwesome) dan layout yang jelas.

📌 OUTCOME YANG DIHARAPKAN
Setelah menyelesaikan fase ini Anda akan memiliki:

* kerangka proyek Dart untuk TUI configurator (struktur folder + contoh file);
* modul plugin contoh (Lua) yang berinteraksi via STDIN/STDOUT;
* template konfigurasi Sway + contoh Waybar JSONC module yang terhubung ke plugin;
* panduan ikon/font dan cara menampilkannya di terminal (font patch & terminal config);
* checklist QA, testing & packaging untuk rilis awal.

───────────────────────────────────────────────────────────────────

1. ARSITEKTUR TUI — LAPISAN & PERAN
   ───────────────────────────────────────────────────────────────────

Tingkat arsitektur (lapis dari bawah ke atas):

1. **Layer I/O & System**

   * Spawn proses, file I/O, menjalankan `swaymsg`, menulis file config.
   * Modul: `ProcessManager`, `FileManager`, `SwayAdapter`.

2. **Layer Komunikasi Plugin**

   * Menyediakan API untuk plugin via line-based JSON / UDS.
   * Modul: `PluginHost`, `PluginRegistry`, protocol handler (encode/decode).

3. **Core App / State**

   * Manajemen state aplikasi (current config, pending changes, plugin list).
   * Modul: `AppState`, event bus (`StreamController.broadcast()`), config store.

4. **TUI Renderer / View**

   * Layout layar: sidebar (navigasi), center panel (editor/preview), bottom bar (status).
   * Modul: `TuiRenderer`, `LayoutManager`, `Widget` primitives.

5. **Interaction Layer**

   * Input handling (keybindings), modal dialogs, confirmations, help.
   * Modul: `InputHandler`, `ModalManager`.

6. **Plugin UI Adapters**

   * Bridge untuk menampilkan output plugin (e.g., status module for waybar preview).
   * Modul: `PluginWidget`.

───────────────────────────────────────────────────────────────────
2) PILIHAN LIBRARY & TOOLING DART (ringkas)
───────────────────────────────────────────────────────────────────

(Rekomendasi library untuk TUI di Dart — pilih yang sesuai preferensi dan eksperimen Anda)

* `dart_console` / `dart_cli_ui` (console utilities) — untuk input/output terminal, warna, cursor.
* Kemungkinan binding FFI ke `ncurses` jika membutuhkan widget tingkat lanjut (opsional & lebih rumit).
* `json_serializable` / `dart:convert` — untuk serialisasi JSON (protokol plugin).
* `args` / `cli_completion` — untuk CLI flags & autocompletion.
* `path`, `io` — file & filesystem.

Catatan: ekosistem TUI Dart tidak se-mature Go/Rust. Fokus pada desain modular dan komunikasi process-based agar Anda tidak tergantung pada satu library.

───────────────────────────────────────────────────────────────────
3) STRUKTUR PROYEK (contoh)
───────────────────────────────────────────────────────────────────

project-root/
├─ bin/
│  └─ mytui.dart         ← entrypoint TUI (main)
├─ lib/
│  ├─ src/
│  │  ├─ core/           ← AppState, ConfigStore, Logging
│  │  ├─ io/             ← ProcessManager, FileManager, SwayAdapter
│  │  ├─ plugin/         ← PluginHost, PluginRegistry, protocol
│  │  ├─ ui/             ← Widgets, LayoutManager, Renderer
│  │  └─ input/          ← InputHandler, Keymap
│  └─ mytui.dart         ← public API (re-export)
├─ example/
│  ├─ plugins/           ← contoh plugin Lua/Bash
│  └─ configs/           ← contoh sway config + waybar jsonc
├─ test/                 ← unit & integration tests
├─ pubspec.yaml
└─ README.txt

───────────────────────────────────────────────────────────────────
4) KOMPONEN UI UTAMA & DESAIN (konsep + alasan)
───────────────────────────────────────────────────────────────────

A. **Sidebar navigasi**

* Isi: daftar kategori (General, Bar, Notifications, Wallpaper, Lock, Plugins, Build/Deploy).
* Alasan: memberi hirarki dan akses cepat.

B. **Editor/Panel Tengah**

* Mode: view-only preview / inline edit (simple key commands) / diff view.
* Alasan: pengguna perlu melihat perubahan sebelum apply.

C. **Preview / Live Demo Area**

* Menampilkan simulasi waybar/status atau snapshot. Bisa menampilkan output plugin yang berjalan.
* Alasan: feedback visual mengurangi kesalahan.

D. **Bottom Status Bar**

* Menampilkan mode input, pesan status, saran AI (singkat), dan jam.
* Alasan: konfirmasi dan feedback.

E. **Modals / Confirmation Dialogs**

* Wajib untuk operasi berisiko (tulis file, reload sway, install plugin).
* Alasan: safety & UX.

F. **Theme & Colors**

* Sediakan light/dark palette; gunakan kontras tinggi untuk terminal.
* Alasan: keterbacaan di berbagai terminal dan font.

───────────────────────────────────────────────────────────────────
5) CONTOH KODE SEDERHANA (Dart) — spawn plugin, baca line-json
───────────────────────────────────────────────────────────────────

Contoh ringkas (pseudocode Dart, buat di `bin/mytui.dart`):

```dart
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final proc = await Process.start('lua', ['example/plugin.lua']);
  proc.stdout.transform(utf8.decoder).transform(LineSplitter()).listen((line) {
    try {
      final msg = jsonDecode(line);
      handlePluginMessage(msg);
    } catch (e) {
      stderr.writeln('Invalid JSON from plugin: $e');
    }
  });

  // kirim handshake
  final handshake = jsonEncode({'type': 'handshake', 'version': 1});
  proc.stdin.writeln(handshake);

  // contoh kirim execute
  final exec = jsonEncode({'type':'execute','action':'get_status'});
  proc.stdin.writeln(exec);

  // tangani stdin user (sederhana)
  stdin.listen((data) {
    // forward input or handle hotkeys
  });
}

void handlePluginMessage(Map msg) {
  if (msg['type'] == 'handshake_ok') {
    print('Plugin ready: ${msg['name']}');
  } else if (msg['type'] == 'result') {
    print('Plugin result: ${msg['payload']}');
  }
}
```

───────────────────────────────────────────────────────────────────
6) CONTOH SKELETON PLUGIN (Lua) — `example/plugins/example.lua`
───────────────────────────────────────────────────────────────────

```lua
local json = require('dkjson') -- atau implementasi json sederhana

-- simple json decode helper (sesuaikan dengan modul json Anda)
function decode(line)
  return json.decode(line)
end

function encode(tbl)
  return json.encode(tbl)
end

-- handshake
io.write(encode({type='handshake_ok', name='example', version='0.1'}) .. '\n')
io.flush()

for line in io.lines() do
  local ok, msg = pcall(decode, line)
  if not ok then
    io.write(encode({type='error', message='invalid json'}) .. '\n')
    io.flush()
  else
    if msg.type == 'execute' and msg.action == 'get_status' then
      local payload = {cpu='3.1%', mem='512MB'}
      io.write(encode({type='result', payload=payload}) .. '\n')
      io.flush()
    end
  end
end
```

Catatan: di sistem nyata gunakan modul json yang tersedia (`dkjson`, `cjson`, atau `lua-cjson`).

───────────────────────────────────────────────────────────────────
7) TEMPLATE CONFIG SEDERHANA (contoh Waybar JSONC + sway include)
───────────────────────────────────────────────────────────────────

Contoh `~/.config/waybar/config.jsonc` (module custom memanggil plugin script):

```jsonc
{
  "modules-left": ["sway/workspaces", "custom/plugin-status"],
  "custom/plugin-status": {
    "exec": "~/.config/mytui/plugins/plugin-wrapper.sh",
    "interval": 1,
    "return-type": "json",
    "format": "{output}",
  }
}
```

`plugin-wrapper.sh` menjalankan plugin Lua dan menerjemahkan output ke format waybar (stdout per line).

Contoh `~/.config/sway/config` snippet:

```
# Autostart mytui (opsional)
exec_always --no-startup-id ~/.local/bin/mytui &
# Exec waybar
exec_always --no-startup-id waybar
```

───────────────────────────────────────────────────────────────────
8) IKON & FONT — menampilkan ikon menarik di TUI
───────────────────────────────────────────────────────────────────

Rekomendasi pendekatan:

* **Gunakan Nerd Fonts / Powerline patched fonts** — menyatukan glyph dari Font Awesome, Material, dan ikon terminal lain => tampil konsisten.
* **Konfigurasi terminal emulator**: pastikan terminal (alacritty, foot, kitty, urxvt) menggunakan font patched.
* **Di TUI**: kirim glyph unicode (mis. , , ) — jangan gunakan escape sequences kompleks.
* **Fallback & checking:** Tampilkan fallback text bila glyph tidak tersedia.

Contoh penggunaan ikon dalam output:

* `" Sway"` untuk judul, `"狀 Status"` untuk status, `" 12:34"` untuk jam.

Catatan teknis: beberapa terminal memerlukan `icu` support dan font fallback untuk emoji/glyph besar. Pastikan README menuntun pengguna untuk meng-install Nerd Fonts (link & nama font) dan mengatur terminal.

───────────────────────────────────────────────────────────────────
9) UX & KEPUTUSAN DESAIN (best practices)
───────────────────────────────────────────────────────────────────

* **Sederhanakan alur**: layar utama fokus ke 3 tugas: pilih bagian config → lihat preview → apply.
* **Konfirmasi eksplisit**: setiap tulisan file/config membutuhkan persetujuan.
* **Undo/rollback**: simpan backup otomatis (timestamped) sebelum menimpa konfigurasi.
* **Mode expert / safe**: safe = hanya membuat perubahan ke file lokal; expert = jalankan `swaymsg reload`.
* **Logging & audit**: tulis log perubahan di `~/.local/share/mytui/logs/` dengan rotasi.

───────────────────────────────────────────────────────────────────
10) TESTING, PACKAGING & RILIS
───────────────────────────────────────────────────────────────────

Testing:

* Unit test logic transformasi config.
* Integration test: buat temp dir, jalankan core + plugin lua, assert handshake dan response.
* E2E: VM/container dengan sway minimal (opsional).

Packaging:

* Build AOT: `dart compile exe bin/mytui.dart -o ~/.local/bin/mytui`
* Buat PKGBUILD (untuk AUR) atau .deb/.rpm packaging script.
* Release artifact: zip tar.gz berisi `mytui` + contoh configs + docs.

───────────────────────────────────────────────────────────────────
11) ESTIMASI WAKTU IMPLEMENTASI FASE 6 (perkiraan)
───────────────────────────────────────────────────────────────────

* Desain UI & prototyping layout: **16–24 jam**
* Implement core spawn & plugin protocol: **12–24 jam**
* Implement basic renderer & input handling: **24–48 jam**
* Contoh plugin & waybar integration: **8–16 jam**
* Testing & packaging awal: **12–24 jam**
  **Total perkiraan:** 72–136 jam (≈18–34 hari pada 4 jam/hari; 9–17 hari pada 8 jam/hari)

───────────────────────────────────────────────────────────────────
12) CHECKLIST PRAKTIS (siap diikuti)
───────────────────────────────────────────────────────────────────

* [ ] Inisialisasi project Dart (pubspec + bin entry)
* [ ] Buat modul `PluginHost` yang spawn plugin & handshake
* [ ] Implement line-based JSON decode/encode helpers
* [ ] Buat widget layout: sidebar, center editor, preview, status bar
* [ ] Contoh plugin Lua di `example/plugins/`
* [ ] Integrasi Waybar module wrapper (script) yang memanggil plugin
* [ ] Backup & rollback mekanisme sebelum menulis config
* [ ] Dokumentasi font/icon: instruksi install Nerd Fonts
* [ ] Unit + integration tests minimal
* [ ] Build AOT & test executable

───────────────────────────────────────────────────────────────────
13) KATA KUNCI PENCARIAN (copy-paste-ready)
───────────────────────────────────────────────────────────────────

* `dart console tui library`
* `dart Process.start stdin stdout example`
* `lua json io.lines example`
* `waybar custom module exec json`
* `nerd fonts install linux`
* `dart compile exe publish`
* `sway swaymsg reload example`

───────────────────────────────────────────────────────────────────
PENUTUP (langkah aksi singkat)
───────────────────────────────────────────────────────────────────

Langkah berikut yang saya sarankan Anda lakukan sekarang (urutan prioritas):

1. Inisialisasi project Dart dengan struktur yang diberikan.
2. Implement minimal `PluginHost` untuk handshake dengan contoh plugin Lua.
3. Buat preview sederhana di terminal yang mencetak output plugin.
4. Hubungkan module Waybar via script wrapper untuk menampilkan output plugin.

<!--
Setelah Anda menyelesaikan langkah-langkah awal atau ingin saya kirimkan **kode contoh lengkap** (file `bin/mytui.dart`, `lib/src/plugin/host.dart`, `example/plugins/plugin.lua`, wrapper script, contoh `waybar/config.jsonc`) — ketik **Lanjutkan** dan saya akan sediakan bagian contoh file satu per satu (sesuai permintaan Anda, perlahan-lahan).
Jika Anda ingin saya mulai langsung dengan **menghasilkan file contoh pertama** (mis. `bin/mytui.dart`), ketik **Lanjutkan** sekarang.
-->
---

Di bawah ini Anda akan melihat: (A) perkiraan jam per-tahap (min–maks) dari semua langkah diatas, (B) penjumlahan total jam, lalu konversi ke hari dan minggu berdasarkan **dua skenario belajar** Anda (4 jam/hari dan 8 jam/hari), dengan **1 hari libur per minggu** (⇒ 6 hari belajar per minggu). Semua perhitungan ditunjukkan langkah demi langkah agar mudah diverifikasi.

---

I. RINGKASAN JAM PER-TAHAP (min — maks)

1. Tahap 0 — Prasyarat & setup: **20 — 48 jam**
2. Tahap 1 — Arsitektur Sway & config inti: **40 — 60 jam**
3. Tahap 2 — Bash scripting (praktis): **60 — 80 jam**
4. Tahap 3 — Format konfigurasi (TOML/YAML/JSON): **20 — 30 jam**
5. Tahap 4 — Belajar Lua untuk plugin: **50 — 70 jam**
6. Tahap 5 — Penerapan praktis (bangun sistem DE modular): **100 — 150 jam**
7. Fase 4 — Dart Advanced Engineering (framework CLI/TUI): **312 — 1056 jam**

   * (Asumsi: 3–5 bulan; dikonversi menjadi jam berdasarkan 13–22 minggu × 6 hari/minggu × 4–8 jam/hari)
8. Fase 5 — Integrasi AI & orchestration: **56 — 112 jam**
9. Fase 6 — Desain TUI lengkap & implementasi (Dart): **72 — 136 jam**

---

II. PENJUMLAHAN TOTAL JAM

* Jumlah jam minimum = 20 + 40 + 60 + 20 + 50 + 100 + 312 + 56 + 72
  = 20+40=60
  → 60+60=120
  → 120+20=140
  → 140+50=190
  → 190+100=290
  → 290+312=602
  → 602+56=658
  → 658+72 = **730 jam** (total minimum)

* Jumlah jam maksimum = 48 + 60 + 80 + 30 + 70 + 150 + 1056 + 112 + 136
  = 48+60=108
  → 108+80=188
  → 188+30=218
  → 218+70=288
  → 288+150=438
  → 438+1056=1494
  → 1494+112=1606
  → 1606+136 = **1742 jam** (total maksimum)

**Jadi total keseluruhan = *730 — 1742 jam*.**

---

III. KONVERSI KE HARI & MINGGU
Asumsi belajar per minggu: **6 hari** (1 hari libur). Dua skenario: 4 jam/hari dan 8 jam/hari.

A. Skenario A — **4 jam / hari**

* Hari belajar total (min) = 730 ÷ 4 = **182,5 hari**
  Minggu = 182,5 ÷ 6 = **30,4167 minggu** ≈ **30 minggu + 3 hari**
  Bulan (≈4.345 minggu per bulan) = 30,4167 ÷ 4.345 ≈ **7,0 bulan**

* Hari belajar total (maks) = 1742 ÷ 4 = **435,5 hari**
  Minggu = 435,5 ÷ 6 = **72,5833 minggu** ≈ **72 minggu + 4 hari**
  Bulan ≈ 72,5833 ÷ 4.345 ≈ **16,7 bulan** (≈ **1 tahun 4–5 bulan**)

**Skenario A (4h/hari, libur 1 hari/mgg): ≈ 30 minggu — 72.6 minggu → ~7 bulan — ~16.7 bulan.**

B. Skenario B — **8 jam / hari**

* Hari belajar total (min) = 730 ÷ 8 = **91,25 hari**
  Minggu = 91,25 ÷ 6 = **15,2083 minggu** ≈ **15 minggu + 1 hari**
  Bulan ≈ 15,2083 ÷ 4.345 ≈ **3,5 bulan**

* Hari belajar total (maks) = 1742 ÷ 8 = **217,75 hari**
  Minggu = 217,75 ÷ 6 = **36,2917 minggu** ≈ **36 minggu + 2 hari**
  Bulan ≈ 36,2917 ÷ 4.345 ≈ **8,36 bulan**

**Skenario B (8h/hari, libur 1 hari/mgg): ≈ 15.2 minggu — 36.3 minggu → ~3.5 bulan — ~8.4 bulan.**

---

IV. RINGKASAN SINGKAT & REKOMENDASI PRAKTIS

1. Total komprehensif seluruh kurikulum (dari prasyarat hingga TUI, AI, dan production-ready Dart tooling): **730 — 1742 jam**.
2. Dengan rutinitas **4 jam/hari** (6 hari/mgg): **~7 — 17 bulan**.
3. Dengan rutinitas **8 jam/hari** (6 hari/mgg): **~3.5 — 8.5 bulan**.
4. Jangkauan besar disebabkan oleh dua faktor utama:

   * Besarnya investasi waktu pada **Dart Advanced (fase 4)** — kami menilai 3–5 bulan intensif yang sangat memengaruhi total.
   * Tingkat kedalaman opsi (MVP saja vs produksi single-binary + sandboxing + CI + integrasi AI lokal).

---

V. PEMECAHAN KEPUTUSAN (cara membuatnya jadi lebih realistis/terukur)

* Jika ingin **MVP cepat** (validasi ide, prototipe TUI + plugin eksternal): fokus pada fase-fase inti (Tahap0–Tahap5 + Fase6 minimal) → Anda bisa menyelesaikan MVP dalam **~270–390 jam** (lihat angka awal) → dengan 4 jam/hari ≈ **68–98 hari** (±2–3 bulan), dengan 8 jam/hari ≈ **34–49 hari** (±1–2 bulan).
* Jika ingin **production-grade** (embed plugin, sandboxing, CI, AI offline, packaging AUR): ambil estimasi penuh (730–1742 jam) sesuai rentang di atas.
* Strategi bertahap terbaik: **MVP dulu (Dart + plugin eksternal)** → lalu iterasi refactor/optimasi (tambahkan sandboxing, integrasi AI lokal, AOT build) per kebutuhan.

---

VI. Saran jadwal implementasi singkat (milestone awal untuk 4 jam/hari)

* Minggu 1–2: Tahap 0 (setup, Dart & Lua, Sway minimal) — 20–48 jam.
* Minggu 3–5: Tahap 1 & 2 (Sway config + Bash scripting) — 100–140 jam.
* Minggu 6: Tahap 3 (format config) — 20–30 jam.
* Minggu 7–11: Tahap 4 & 5 (Lua + penerapan praktis) — 150–220 jam.
* Minggu 12–20: Fase 6 (TUI prototipe, plugin host) — 72–136 jam.
* Minggu 21+ : Fase 4 (Dart advanced) dan Fase 5 (AI integration) bertahap sesuai kebutuhan — ini fase paling variabel (312–1056 jam).

---

<!--
Saya bisa jelaskan jadwal harian/mingguan yang lebih rinci (90-hari atau 180-hari) sesuai skenario waktu Anda (4 jam/hari atau 8 jam/hari). Tulis **Susun Jadwal 90** untuk versi 90-hari (4 atau 8 jam/hari, sebut angka jam), atau **Susun Jadwal 180** untuk versi 6-bulan, maka saya akan menyusunnya sekarang secara bertahap seperti permintaan Anda.
-->
