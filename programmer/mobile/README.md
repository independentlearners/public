# Roadmap Dart dan Flutter

Berikut roadmap seri untuk jadi **master Dart & Flutter**—serius, padat, dan saling berkesinambungan—lalu daftar bahasa untuk kedepan:

---

## [1. Pondasi Dart](programmer\mobile\dart\bin\dasar)

1. **[Sintaks Dasar & Tipe Data](programmer\mobile\dart\bin\dasar\tipe-data) (2–3 minggu)**

   - [Variabel](programmer\mobile\dart\bin\dasar\variabel), tipe primitif ([`int`, `double`,](programmer\mobile\dart\bin\dasar\tipe-data\number\README.md) `String`, `bool`)
   - Koleksi (`List`, `Map`, `Set`)
   - Null safety: `?`, `!`, `late`
   - **Tips:** Praktikkan setiap konsep dengan mini–project (misal: kalkulator sederhana).

2. **Kontrol Alur & Fungsi (2 minggu)**

   - `if`/`else`, `switch`, loop (`for`, `while`, `for-in`)
   - Fungsi biasa vs. arrow (`=>`) vs. anonymous
   - Positional & named parameters

3. **OOP & Desain Kode (3–4 minggu)**

   - Class, constructor, inheritance, mixins, interface
   - Getter/setter, `abstract`, `factory` constructor
   - **Solid Principles Ringkas:** Single Responsibility, Open/Closed

4. **Asynchronous & Concurrency (3 minggu)**

   - `Future`, `async`/`await`, `Stream`
   - Error handling di async (`try`/`catch` di `Future`)
   - **Latihan:** Fetch data via HTTP, proses stream (misal parsing log)

5. **Paket & Ekosistem (2 minggu)**

   - `pub.dev`: cari, baca dokumentasi, import package
   - `dartfmt`, `dart analyze` & `dart test`
   - Menulis unit test dengan `test` package

6. **Advanced Dart (4 minggu)**

   - Generics, extension methods, operators overloading
   - Reflection & meta-programming (package: `reflectable`)
   - Build tools: `build_runner`, code generation (misal `json_serializable`)

---

## 2. Transisi: Dari Dart ke Flutter

> Setelah mahir core–Dart, kamu langsung lompat ke Flutter dengan confidence—karena semua logika, asinkron, OOP, testing, dan code generation siap mendukung.

---

## 3. Pondasi Flutter

1. **Setup & Struktur Proyek (1 minggu)**

   - Instalasi SDK, Android Studio/VS Code, emulator
   - Anatomy folder (`lib/`, `pubspec.yaml`, `assets/`)

2. **Widget Dasar (2–3 minggu)**

   - `StatelessWidget` vs. `StatefulWidget`
   - Layout: `Row`, `Column`, `Stack`, `Container`, `Padding`, `Expanded`
   - Hot reload & widget inspector: debugging UI

3. **Interaksi UI & State Management (4–5 minggu)**

   - `setState` sederhana → scoped state
   - Paket populer: Provider, Riverpod, Bloc/Cubit
   - Pengelolaan form (`Form`, `TextFormField`, validasi)

4. **Navigasi & Routing (2 minggu)**

   - `Navigator.push`/`pop`
   - Named routes, arguments, deep linking
   - Fluent routing (package `go_router` atau `auto_route`)

5. **Networking & Persistence (3 minggu)**

   - HTTP: `http` vs. `dio`
   - JSON parsing dengan code gen (`json_serializable`)
   - Local storage: `shared_preferences`, `hive`, `sqflite`

6. **UI/UX Tingkat Lanjut (4 minggu)**

   - Custom paint & animations (`AnimationController`, `Tween`)
   - Themes & responsive design (Adaptive, MediaQuery)
   - Integrasi platform: camera, GPS, sensor (via plugin)

7. **Testing & Deployment (2–3 minggu)**

   - Widget tests, integration tests (`flutter_test`, `integration_test`)
   - CI/CD sederhana (GitHub Actions, Codemagic)
   - Build & publish ke Play Store / App Store

8. **Maintenance & Best Practices**

   - Clean architecture (layered: data/domain/presentation)
   - Code review checklist, lint rules (`analysis_options.yaml`)
   - Performance profiling & optimasi (Flutter DevTools)

---

[**Langkah Selanjutnya**](programmer\README.md)
