> [pro][fase6]

# **[FASE 5: Forms & Input Handling][0]**

Ini berfokus pada cara aplikasi kita menerima dan memvalidasi input dari pengguna. Kita akan memulai dari fondasi paling dasar dalam menangani input pengguna.

### **Daftar Isi**

<details>
  <summary>📃 Struktur Materi</summary>

---

- **[7. Form Architecture & Validation](#7-form-architecture--validation)**
  - **[7.1. Form Widgets & Validation](#71-form-widgets--validation)**
    - [7.1.1. Form dan FormField](#711-form-dan-formfield)
    - [7.1.2. Validation Strategies](#712-validation-strategies)
  - **[7.2. Advanced Form Management](#72-advanced-form-management)**
    - [7.2.1. Flutter Form Builder](#721-flutter-form-builder)
    - [7.2.2. Reactive Forms](#722-reactive-forms)
  - **[7.3. Input Formatters & Masks](#73-input-formatters--masks)**
    - [7.3.1. Text Input Formatting](#731-text-input-formatting)
    - [7.3.2. Advanced Input Handling](#732-advanced-input-handling)

</details>

---

### **7. Form Architecture & Validation**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Setiap aplikasi yang interaktif membutuhkan cara untuk mengumpulkan data dari pengguna, baik itu untuk login, pendaftaran, pencarian, atau posting konten. Fase ini mengajarkan arsitektur dan teknik untuk membangun formulir (_forms_) yang andal, mudah digunakan, dan aman. Kita akan belajar cara membuat _input fields_, memvalidasi data yang dimasukkan, dan menangani proses submisi. Menguasai ini adalah keterampilan fundamental untuk membangun aplikasi fungsional apa pun.

---

#### **7.1. Form Widgets & Validation**

##### **7.1.1. Form dan FormField**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah blok bangunan dasar dari semua formulir di Flutter. Widget `Form` bertindak sebagai sebuah "kontainer" yang dapat mengelola, memvalidasi, dan menyimpan beberapa _input field_ (`FormField`) secara bersamaan. `TextFormField` adalah implementasi `FormField` yang paling umum, yang pada dasarnya adalah `TextField` yang terintegrasi dengan `Form` induknya. Memahami trio (`Form`, `FormState`, `FormField`) ini adalah langkah pertama yang esensial.

**Konsep Kunci & Filosofi Mendalam:**

- **Stateful Container (`Form` & `FormState`):** `Form` adalah widget yang tidak terlihat. Kekuatannya terletak pada objek `FormState` yang dibuatnya secara internal. `FormState` inilah yang menjadi "otak" dari formulir; ia melacak semua `FormField` di dalamnya dan memiliki metode untuk berinteraksi dengan mereka secara kolektif.
- **Decoupling (Pemisahan):** `Form` memisahkan _state_ dari masing-masing _field_ dari logika validasi dan penyimpanan grup. Setiap `TextFormField` mengelola state-nya sendiri (teks yang sedang diketik), tetapi `FormState`-lah yang memerintahkan mereka semua untuk "validasi dirimu\!" atau "simpan nilaimu\!".
- **`GlobalKey` sebagai Jembatan:** Untuk mengakses `FormState` dari luar widget `Form` itu sendiri (misalnya, dari sebuah tombol "Submit"), kita menggunakan sebuah `GlobalKey<FormState>`. Kunci ini bertindak sebagai referensi atau "pegangan" yang stabil ke `FormState`, memungkinkan kita untuk memanggil metodenya seperti `_formKey.currentState.validate()`.

**Terminologi Esensial & Penjelasan Detil:**

- **`Form`:** Widget pembungkus yang mengelompokkan `FormField` widgets.
- **`FormField`:** Kelas dasar untuk _input field_ yang dapat divalidasi dan disimpan.
- **`TextFormField`:** Implementasi `FormField` yang paling umum, menggabungkan `TextField` dengan fungsionalitas `Form`.
- **`FormState`:** Objek state yang dibuat oleh `Form` untuk mengelola formulir.
- **`GlobalKey<FormState>`:** Kunci unik global yang digunakan untuk mengakses `FormState`.
- **`validator`:** Properti pada `FormField` yang menerima sebuah fungsi. Fungsi ini akan mengembalikan `String` (pesan error) jika input tidak valid, atau `null` jika valid.
- **`onSaved`:** Properti pada `FormField` yang menerima sebuah fungsi. Fungsi ini dipanggil untuk setiap _field_ ketika `formState.save()` dieksekusi, memungkinkan Anda untuk menyimpan nilai yang sudah divalidasi.
- **`autovalidateMode`:** Mengontrol kapan validasi dijalankan secara otomatis (misalnya, `onUserInteraction` akan menampilkan error setelah pengguna mulai mengetik).

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh formulir login sederhana dengan validasi untuk email dan password.

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // 1. Buat GlobalKey untuk Form.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // 2. Bungkus semua field dengan widget Form.
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 3. Gunakan TextFormField untuk input.
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Masukkan alamat email Anda',
                border: OutlineInputBorder(),
              ),
              // 4. Sediakan fungsi validator.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                if (!value.contains('@')) {
                  return 'Masukkan format email yang valid';
                }
                return null; // null berarti valid
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              obscureText: true, // Untuk menyembunyikan input password
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                if (value.length < 6) {
                  return 'Password minimal harus 6 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // 5. Validasi form melalui GlobalKey.
                if (_formKey.currentState!.validate()) {
                  // Jika form valid, tampilkan snackbar.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### **Visualisasi Hasil Kode**

Berikut adalah _mockup_ visual dari UI yang dihasilkan oleh kode di atas, termasuk saat validasi gagal.

```
┌──────────────────────────────────┐        ┌──────────────────────────────────┐
│  Tampilan Awal                   │        │  Tampilan Setelah Gagal Validasi │
├──────────────────────────────────┤        ├──────────────────────────────────┤
│                                  │        │                                  │
│   ┌──────────────────────────┐   │        │   ┌──────────────────────────┐   │
│   │ Email                    │   │        │   │ Email                    │   │
│   │ ________________________ │   │        │   │ ________________________ │   │
│   └──────────────────────────┘   │        │   │ Masukkan format email    │   │
│                                  │        │   └──────────────────────────┘   │
│   ┌──────────────────────────┐   │        │                                  │
│   │ Password                 │   │        │   ┌──────────────────────────┐   │
│   │ ________________________ │   │        │   │ Password                 │   │
│   └──────────────────────────┘   │        │   │ ________________________ │   │
│                                  │        │   │ Password tidak boleh...  │   │
│        ┌──────────────┐          │        │   └──────────────────────────┘   │
│        │    Login     │          │        │                                  │
│        └──────────────┘          │        │        ┌──────────────┐          │
│                                  │        │        │    Login     │          │
└──────────────────────────────────┘        │        └──────────────┘          │
                                            └──────────────────────────────────┘
```

### **Representasi Diagram Alur & Kode**

```
┌──────────────────────────────┐
│  Form                        │ // Induk: Kontainer tak terlihat.
│  (Pembungkus Utama)          │─────────┐
│  ┌────────────────────────┐  │         ▼
│  │ key: _formKey          │  │   Memberikan "pegangan" (GlobalKey)
│  │                        │  │   ke objek FormState internal.
│  ├────────────────────────┤  │
│  │ child: Column(...)     │  │
│  │ ┌────────────────────┐ │  │
│  │ │ TextFormField      │ │  │
│  │ │ (Anak #1: Email)   │ │─────────┐
│  │ │ ┌────────────────┐ │ │  │      ▼
│  │ │ │ validator:     │ │ │  │   Fungsi yang mendefinisikan aturan
│  │ │ │  (value) => {  │ │ │  │   untuk field ini. Mengembalikan
│  │ │ │   if(...)      │ │ │  │   'String' (error) atau null (valid).
│  │ │ │   return 'err' │ │ │  │
│  │ │ │  }             │ │ │  │
│  │ │ └────────────────┘ │ │  │
│  │ └────────────────────┘ │  │
│  │ ┌────────────────────┐ │  │
│  │ │ TextFormField      │ │  │
│  │ │ (Anak #2: Pass)    │ │  │
│  │ └────────────────────┘ │  │
│  │ ┌────────────────────┐ │  │
│  │ │ ElevatedButton     │ │  │
│  │ │ (Pemicu Aksi)      │ │─────────┐
│  │ │ ┌────────────────┐ │ │  │      ▼
│  │ │ │ onPressed: () {│ │ │  │    Saat tombol ditekan, ia menggunakan
│  │ │ │  _formKey.     │ │ │  │     _formKey untuk mengakses FormState
│  │ │ │  currentState!.│ │ │  │   dan memanggil metode .validate().
│  │ │ │  validate();   │ │ │  │
│  │ │ │ }              │ │ │  │
│  │ │ └────────────────┘ │ │  │
│  │ └────────────────────┘ │  │
│  └────────────────────────┘  │
└──────────────────────────────┘
```

**Alur Kerja Saat Validasi:**

1.  Pengguna menekan `ElevatedButton`.
2.  Fungsi `onPressed` dipanggil.
3.  `_formKey.currentState!.validate()` dieksekusi.
4.  `FormState` akan memanggil fungsi `validator` pada **setiap** `TextFormField` di dalamnya.
5.  Jika **semua** fungsi `validator` mengembalikan `null`, maka metode `validate()` akan mengembalikan `true`. Formulir dianggap valid.
6.  Jika **salah satu** fungsi `validator` mengembalikan sebuah `String`, `validate()` akan mengembalikan `false`, dan `String` tersebut akan ditampilkan sebagai pesan error di bawah `TextFormField` yang bersangkutan.

---

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Lupa membungkus `TextFormField` dengan widget `Form`, lalu mencoba memvalidasi.
- **Solusi:** `TextFormField` membutuhkan `Form` sebagai _ancestor_ (leluhur) agar validasinya berfungsi dengan benar melalui `FormState`. Pastikan semua _field_ yang ingin Anda validasi bersama berada di dalam satu `Form`.
- **Kesalahan:** Mendapat error `Null check operator used on a null value` saat memanggil `_formKey.currentState!.validate()`.
- **Solusi:** Ini biasanya terjadi jika `_formKey` belum terpasang ke `Form` saat `build` pertama kali, atau jika `Form` dihapus dari _widget tree_. Pastikan `Form` dengan `key` tersebut selalu ada di dalam _tree_ saat Anda mencoba memanggil metodenya.

**Sumber Referensi Lengkap:**

- **Cookbook Resmi:** [Build a form with validation - Flutter Docs](https://flutter.dev/docs/cookbook/forms/validation)
- **API Docs:** [Form class - Flutter API](https://api.flutter.dev/flutter/widgets/Form-class.html)
- **API Docs:** [TextFormField class - Flutter API](https://api.flutter.dev/flutter/material/TextFormField-class.html)

---

Kita telah membahas fondasi dari formulir di Flutter. Anda sekarang mengerti bagaimana `Form`, `TextFormField`, dan `GlobalKey` bekerja sama untuk mengumpulkan dan memvalidasi input. Sekarang kita akan mendalami berbagai teknik dan strategi untuk memastikan data yang dimasukkan oleh pengguna sesuai dengan aturan yang kita tetapkan.

---

### **7.1.2. Validation Strategies**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Validasi adalah proses memeriksa apakah input dari pengguna akurat dan dapat diterima. Tanpa validasi yang baik, aplikasi kita rentan terhadap data yang salah, error, dan bahkan celah keamanan. Bagian ini mengajarkan berbagai strategi validasi, mulai dari yang paling sederhana hingga skenario kompleks seperti memeriksa ketersediaan _username_ di server. Menguasai strategi ini akan memungkinkan Anda membangun formulir yang kuat (robust) dan memberikan umpan balik yang jelas kepada pengguna.

**Konsep Kunci & Filosofi Mendalam:**

- **Umpan Balik Instan vs. Terjaga:** Filosofi di balik strategi validasi adalah keseimbangan. Kita ingin memberikan umpan balik sesegera mungkin agar pengguna bisa memperbaiki kesalahan, tetapi tidak terlalu agresif sehingga mengganggu pengalaman mengetik. Properti `autovalidateMode` adalah kunci untuk mengontrol keseimbangan ini.
- **Validasi sebagai Aturan Bisnis:** Fungsi `validator` pada intinya adalah implementasi dari aturan bisnis (`business rules`) Anda dalam bentuk kode. Aturan seperti "password harus mengandung huruf kapital" atau "username tidak boleh sudah terdaftar" adalah bagian dari logika aplikasi Anda yang diterapkan langsung pada lapisan input.
- **Validasi Lintas Bidang (Cross-Field Validation):** Seringkali, validitas sebuah _field_ bergantung pada nilai dari _field_ lain (misalnya, "konfirmasi password" harus sama dengan "password"). Ini memperkenalkan tantangan karena setiap `validator` secara default hanya mengetahui nilainya sendiri. Solusi umumnya adalah dengan memberikan akses ke nilai _field_ lain saat validasi dijalankan.
- **Validasi Asinkron (Async Validation):** Bagaimana jika aturan validasi memerlukan panggilan jaringan (misalnya, memeriksa keunikan email di database)? Fungsi `validator` standar bersifat sinkron. Ini berarti kita memerlukan strategi khusus untuk menangani operasi asinkron tanpa memblokir UI, seringkali dengan memicu validasi ulang setelah operasi asinkron selesai.

**Terminologi Esensial & Penjelasan Detil:**

- **`autovalidateMode`:** Enum yang mengontrol kapan validasi berjalan.
  - `AutovalidateMode.disabled` (default): Validasi hanya berjalan saat `form.validate()` dipanggil secara manual.
  - `AutovalidateMode.onUserInteraction`: Validasi berjalan secara otomatis setelah interaksi pertama pengguna (misalnya, setelah mulai mengetik). Ini adalah mode yang paling direkomendasikan untuk pengalaman pengguna yang baik.
  - `AutovalidateMode.always`: Validasi berjalan terus-menerus, seringkali terlalu agresif karena akan menampilkan error bahkan sebelum pengguna selesai mengetik.
- **Cross-Field Validation:** Proses memvalidasi sebuah _field_ dengan menggunakan nilai dari satu atau lebih _field_ lain dalam _form_ yang sama.
- **Async Validation:** Proses memvalidasi input yang bergantung pada hasil operasi asinkron (mis. panggilan API).

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh formulir pendaftaran yang mendemonstrasikan beberapa strategi: `autovalidateMode`, validasi lintas bidang untuk password, dan simulasi validasi asinkron untuk _username_.

```dart
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: RegistrationForm(),
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});
  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  // Controller untuk mengakses nilai password di field lain
  final _passwordController = TextEditingController();
  String? _usernameError;
  Timer? _debounce;

  // Simulasi API check untuk username
  Future<bool> isUsernameTaken(String username) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return username.toLowerCase() == 'admin';
  }

  void _validateUsername(String username) {
    // Debouncing untuk mencegah panggilan API pada setiap ketikan
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () async {
      final isTaken = await isUsernameTaken(username);
      setState(() {
        if (isTaken) {
          _usernameError = 'Username "$username" sudah digunakan.';
        } else {
          _usernameError = null;
        }
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      // STRATEGI 1: Real-time validation setelah interaksi pertama
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // STRATEGI 2: Async validation (semi-manual)
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: const OutlineInputBorder(),
                errorText: _usernameError, // Tampilkan error async di sini
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  _validateUsername(value);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController, // Hubungkan controller
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // STRATEGI 3: Cross-field validation
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Password tidak cocok';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // `validate()` akan memicu semua validator sinkron
                if (_formKey.currentState!.validate() && _usernameError == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Form valid! Melakukan pendaftaran...')),
                  );
                }
              },
              child: const Text('Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### **Visualisasi Hasil Kode**

Berikut adalah _mockup_ visual yang menggambarkan berbagai status error dari formulir pendaftaran di atas.

```
┌──────────────────────────────────┐        ┌──────────────────────────────────┐
│  Validasi Lintas Bidang (Error)  │        │  Validasi Asinkron (Error)       │
├──────────────────────────────────┤        ├──────────────────────────────────┤
│                                  │        │                                  │
│   ┌──────────────────────────┐   │        │   ┌──────────────────────────┐   │
│   │ Username                 │   │        │   │ Username                 │   │
│   │ ________________________ │   │        │   │ admin___________________ │   │
│   └──────────────────────────┘   │        │   │ Username "admin" sudah...│   │
│                                  │        │   └──────────────────────────┘   │
│   ┌──────────────────────────┐   │        │                                  │
│   │ Password                 │   │        │   ┌──────────────────────────┐   │
│   │ password123_____________ │   │        │   │ Password                 │   │
│   └──────────────────────────┘   │        │   │ ________________________ │   │
│                                  │        │   └──────────────────────────┘   │
│   ┌──────────────────────────┐   │        │                                  │
│   │ Konfirmasi Password      │   │        │   ┌──────────────────────────┐   │
│   │ password456_____________ │   │        │   │ Konfirmasi Password      │   │
│   │ Password tidak cocok     │   │        │   │ ________________________ │   │
│   └──────────────────────────┘   │        │   └──────────────────────────┘   │
└──────────────────────────────────┘        └──────────────────────────────────┘
```

### **Representasi Diagram Alur & Kode (Validasi Lintas Bidang)**

Diagram ini menjelaskan bagaimana validasi untuk _field_ "Konfirmasi Password" bekerja.

```
┌──────────────────────────────┐
│  TextFormField               │ // Field Password
│  (Sumber Kebenaran)          │
│  ┌────────────────────────┐  │
│  │ controller:            │  │
│  │  _passwordController   │  │
│  └────────────────────────┘  │
└──────────────┬───────────────┘
               │ (Nilai `_passwordController.text` dapat diakses)
               │
┌──────────────▼───────────────┐
│  TextFormField               │ // Field Konfirmasi Password
│  (Field yang Membutuhkan)    │
│  ┌────────────────────────┐  │
│  │ validator: (value) => {│  │─────────┐
│  │   // Logika Validasi   │  │         ▼
│  │   if (value !=         │  │ Fungsi validator ini secara langsung
│  │    _passwordController.│  │ membandingkan nilai inputnya (`value`)
│  │       text) {          │  │ dengan nilai dari controller password.
│  │     return 'Error';    │  │
│  │   }                    │  │
│  │   return null;         │  │
│  │ }                      │  │
│  └────────────────────────┘  │
└──────────────────────────────┘
```

**Alur Kerja Validasi Asinkron (Simulasi):**

```
┌─────────────────┐      ┌─────────────┐       ┌─────────────────┐
│ User mengetik   ├─────►│ onChanged   ├──────►│_validateUsername│
│ 'admin'         │      │ (dipicu)    │       │(dipanggil)      │
└─────────────────┘      └──────┬──────┘       └────────┬────────┘
                                │                       │
                      ┌─────────▼──────────┐  ┌─────────▼──────────┐
                      │ Debounce Timer     │  │  Future.delayed    │
                      │ (Menunggu 700ms)   │  │  (Simulasi API)    │
                      └─────────┬──────────┘  └─────────┬──────────┘
                                │                       │
                                │ (Setelah 700ms)       │
                      ┌─────────▼──────────┐  ┌─────────▼──────────┐
                      │ isUsernameTaken    │  │  Mengembalikan     │
                      │ (dieksekusi)       │  │  `true`            │
                      └────────────────────┘  └─────────┬──────────┘
                                                        │
                                              ┌─────────▼──────────┐
                                              │ setState()         │
                                              │ (dipanggil)        │
                                              └─────────┬──────────┘
                                                        │
                                              ┌─────────▼──────────┐
                                              │ _usernameError     │
                                              │ di-set, UI rebuild │
                                              └────────────────────┘
```

---

**Potensi Kesalahan Umum & Solusi:**

- **Kesalahan:** Validasi lintas bidang gagal karena `_passwordController.text` kosong saat validator konfirmasi password berjalan.
- **Solusi:** Urutan `TextFormField` di dalam `Column` penting. Pastikan _field_ sumber (password) didefinisikan sebelum _field_ yang bergantung padanya (konfirmasi password). Gunakan `autovalidateMode: AutovalidateMode.onUserInteraction` agar validasi tidak berjalan sebelum pengguna berinteraksi.
- **Kesalahan:** Panggilan API untuk validasi asinkron terjadi pada setiap ketukan tombol, membebani server.
- **Solusi:** Implementasikan **debouncing**. Seperti pada contoh kode, gunakan `Timer` untuk menunggu jeda singkat setelah pengguna berhenti mengetik sebelum memicu panggilan API. Ini adalah praktik standar untuk optimisasi.

---

Kita telah mendalami berbagai strategi validasi untuk membuat formulir yang cerdas dan interaktif. Anda kini memahami cara menangani skenario validasi yang umum dan kompleks. Selanjutnya, kita akan melihat bagaimana _package_ pihak ketiga dapat menyederhanakan proses manajemen formulir yang lebih rumit lagi.

### **7.2. Advanced Form Management**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Setelah menguasai `Form` bawaan Flutter, kita sering menemukan bahwa untuk formulir yang sangat besar atau dinamis, kode kita bisa menjadi sangat panjang dan berulang (_boilerplate_). Bagian ini memperkenalkan _library_ pihak ketiga yang dirancang untuk mengatasi masalah ini. Kita akan mempelajari dua pendekatan populer: satu yang mempercepat pengembangan dengan menyediakan _field_ siap pakai (Flutter Form Builder), dan satu lagi yang mengadopsi paradigma reaktif yang kuat (Reactive Forms).

---

#### **7.2.1. Flutter Form Builder**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**Flutter Form Builder** adalah sebuah _library_ yang secara drastis menyederhanakan dan mempercepat pembuatan formulir. Ia menyediakan kumpulan besar _input field_ siap pakai (`FormBuilderTextField`, `FormBuilderDropdown`, `FormBuilderDateTimePicker`, dll.) yang sudah terintegrasi dengan logika validasi dan manajemen state. Perannya dalam kurikulum ini adalah sebagai solusi **pragmatis dan cepat** untuk mengurangi _boilerplate_. Anda bisa membangun formulir yang kompleks dengan kode yang jauh lebih sedikit dibandingkan menggunakan `Form` dan `TextFormField` standar.

**Konsep Kunci & Filosofi Mendalam:**

- **Less Code, More Fields:** Filosofi utamanya adalah menyediakan abstraksi tingkat tinggi di atas `FormField` standar. Daripada mengkonfigurasi `TextEditingController`, `validator`, dan `onSaved` secara manual untuk setiap _field_, Anda cukup menggunakan widget `FormBuilder*` yang sesuai, dan _library_ ini yang akan menangani detailnya di belakang layar.
- **Akses Nilai Terpusat:** Semua nilai dari _field_ dalam `FormBuilder` dapat diakses sebagai sebuah `Map<String, dynamic>` dari _state_ formulir. Setiap _field_ diidentifikasi oleh sebuah properti `name` yang unik, yang menjadi _key_ dalam _map_ tersebut.
- **Ekosistem Validasi:** _Library_ ini datang dengan paket pendamping, `form_builder_validators`, yang menyediakan kumpulan besar fungsi validator siap pakai (seperti `required`, `email`, `minLength`, `creditCard`, dll.) yang dapat digabungkan dengan mudah.

**Terminologi Esensial & Penjelasan Detil:**

- **`FormBuilder`:** Pengganti untuk widget `Form`. Ia memegang `GlobalKey` dan mengelola state formulir.
- **`FormBuilderTextField`, `FormBuilderCheckbox`, `FormBuilderRadioGroup`, dll.:** Widget-widget siap pakai yang merupakan pengganti untuk `TextFormField`, `Checkbox`, dll. Masing-masing memiliki properti `name` yang wajib diisi.
- **`formKey.currentState.save()`:** Menyimpan nilai dari semua _field_ ke dalam sebuah _map_ internal.
- **`formKey.currentState.value`:** Mengakses _map_ yang berisi nilai-nilai formulir yang telah disimpan.
- **`FormBuilderValidators`:** Kelas statis dari paket pendamping yang berisi banyak fungsi validator. Anda bisa menggabungkannya, contoh: `FormBuilderValidators.compose([FormBuilderValidators.required(), FormBuilderValidators.email()])`.

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh formulir pendaftaran acara dengan berbagai jenis input.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  // ... (Sama seperti sebelumnya) ...
}

class EventRegistrationForm extends StatefulWidget {
  const EventRegistrationForm({super.key});
  @override
  State<EventRegistrationForm> createState() => _EventRegistrationFormState();
}

class _EventRegistrationFormState extends State<EventRegistrationForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pendaftaran Acara')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // 1. Gunakan FormBuilder sebagai root
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // 2. Gunakan field-field siap pakai dengan properti 'name'
                FormBuilderTextField(
                  name: 'name',
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 16),
                FormBuilderDateTimePicker(
                  name: 'event_date',
                  inputType: InputType.date,
                  format: DateFormat('yyyy-MM-dd'),
                  decoration: const InputDecoration(labelText: 'Tanggal Kehadiran'),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 16),
                FormBuilderDropdown<String>(
                  name: 'session',
                  decoration: const InputDecoration(labelText: 'Sesi yang Diikuti'),
                  items: ['Pagi', 'Siang', 'Sore']
                      .map((sesi) => DropdownMenuItem(
                            value: sesi,
                            child: Text(sesi),
                          ))
                      .toList(),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 16),
                FormBuilderRadioGroup<bool>(
                  name: 'is_vegetarian',
                  decoration: const InputDecoration(
                    labelText: 'Apakah Anda seorang vegetarian?',
                    border: InputBorder.none,
                  ),
                  options: const [
                    FormBuilderFieldOption(value: true, child: Text('Ya')),
                    FormBuilderFieldOption(value: false, child: Text('Tidak')),
                  ],
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // 3. Validasi dan simpan nilai
                    if (_formKey.currentState!.saveAndValidate()) {
                      // 4. Akses semua nilai sebagai Map
                      final formData = _formKey.currentState!.value;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Data tersimpan: $formData')),
                      );
                    }
                  },
                  child: const Text('Daftar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

### **Visualisasi Hasil Kode**

Berikut adalah _mockup_ visual dari UI yang dihasilkan oleh `FormBuilder`.

```
┌──────────────────────────────────┐
│  Tampilan Pendaftaran Acara      │
├──────────────────────────────────┤
│ AppBar: [Pendaftaran Acara]      │
│ -------------------------------- │
│                                  │
│  Nama Lengkap                    │
│  ______________________________  │
│                                  │
│  Tanggal Kehadiran               │
│  [ 2025-07-06         ▼ ]        │
│                                  │
│  Sesi yang Diikuti               │
│  [ Pagi                 ▼ ]      │
│                                  │
│  Apakah Anda seorang vegetarian? │
│  ( ) Ya   [] Tidak               │
│                                  │
│        ┌──────────────┐          │
│        │    Daftar    │          │
│        └──────────────┘          │
│                                  │
└──────────────────────────────────┘
```

### **Representasi Diagram Alur & Kode**

Diagram ini menunjukkan bagaimana `FormBuilder` menyederhanakan struktur.

```
┌──────────────────────────────┐
│  FormBuilder                 │ // Induk: Pengelola Form
│  (Pengganti Form)            │─────────┐
│  ┌────────────────────────┐  │         ▼
│  │ key: _formKey          │  │ Sama seperti Form, menggunakan GlobalKey
│  │                        │  │ untuk akses state.
│  ├────────────────────────┤  │
│  │ child: Column(...)     │  │
│  │ ┌────────────────────┐ │  │
│  │ │ FormBuilderTextField │  │
│  │ │ (Field #1)         │ │─────────┐
│  │ │ ┌────────────────┐ │ │  │      ▼
│  │ │ │ name: 'name'   │ │ │  │ Properti 'name' digunakan sebagai
│  │ │ └────────────────┘ │ │  │ kunci untuk nilai field dalam Map.
│  │ │ ┌────────────────┐ │ │  │
│  │ │ │ validator:     │ │ │  │
│  │ │ │  FBValidators. │ │ │  │
│  │ │ │  required()    │ │ │  │
│  │ │ └────────────────┘ │ │  │
│  │ └────────────────────┘ │  │
│  │ ┌────────────────────┐ │  │
│  │ │ FormBuilderDropdown│ │  │
│  │ │ (Field #2)         │ │  │
│  │ │ name: 'session'    │ │  │
│  │ └────────────────────┘ │  │
│  │ ┌────────────────────┐ │  │
│  │ │ ElevatedButton     │ │  │
│  │ │ (Pemicu Aksi)      │ │─────────┐
│  │ │ ┌────────────────┐ │ │  │      ▼
│  │ │ │ onPressed: () {│ │ │  │ Metode .saveAndValidate() adalah
│  │ │ │ _formKey.      │ │ │  │ pintasan untuk .save() dan .validate().
│  │ │ │  currentState!.│ │ │  │
│  │ │ │saveAndValidate() │ │  │
│  │ │ │ }              │ │ │  │
│  │ │ └────────────────┘ │ │  │
│  │ └────────────────────┘ │  │
│  └────────────────────────┘  │
└──────────────────────────────┘
```

---

#### **7.2.2. Reactive Forms**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**Reactive Forms** adalah sebuah _library_ yang membawa paradigma formulir reaktif dari Angular ke Flutter. Pendekatannya sangat berbeda: alih-alih membiarkan widget (UI) mengelola state-nya sendiri, Anda mendefinisikan sebuah **model data** untuk formulir Anda di dalam kode Dart. UI kemudian "bereaksi" terhadap perubahan pada model ini. Perannya dalam kurikulum adalah untuk memperkenalkan pendekatan **model-driven** yang sangat terstruktur, kuat, dan sangat mudah diuji, yang bersinar dalam skenario formulir dinamis yang sangat kompleks.

**Konsep Kunci & Filosofi Mendalam:**

- **Model-Driven, Bukan UI-Driven:** Ini adalah pergeseran filosofi. Anda tidak lagi mengkonfigurasi validasi atau nilai awal di dalam widget UI. Sebagai gantinya, Anda mendefinisikan struktur formulir (`FormGroup`), _field_ (`FormControl`), dan validatornya di dalam sebuah model Dart. Widget UI (`ReactiveTextField`, dll.) hanya bertugas untuk "mengikat" dirinya ke _control_ yang sesuai di dalam model.
- **Stream-Based (Berbasis Stream):** Setiap `FormControl` pada dasarnya adalah sebuah `Stream`. Anda bisa mendengarkan `valueChanges` untuk bereaksi terhadap perubahan nilai secara _real-time_, atau `statusChanges` untuk bereaksi terhadap perubahan status validasi. Ini membuka kemungkinan untuk logika reaktif yang sangat canggih.
- **Pemisahan yang Ketat:** Logika formulir (struktur, validasi, nilai) sepenuhnya terpisah dari UI. Ini membuat logika sangat mudah diuji secara unit (_unit test_) tanpa perlu me-render satu widget pun. Anda bisa memanipulasi dan memvalidasi model formulir Anda secara terprogram.

**Terminologi Esensial & Penjelasan Detil:**

- **`FormControl`:** Mewakili satu _input field_ individual. Ia melacak nilai, status validasi, dan error dari _field_ tersebut.
- **`FormGroup`:** Kumpulan dari beberapa `FormControl` (atau `FormGroup` lain). Ia melacak nilai dan status validasi dari semua _control_ di dalamnya sebagai satu kesatuan.
- **`FormArray`:** Mirip `FormGroup`, tetapi digunakan untuk mengelola daftar `FormControl` yang dinamis, di mana pengguna bisa menambah atau menghapus _field_ (misalnya, menambahkan beberapa nomor telepon).
- **`ReactiveForm`:** Widget yang menghubungkan `FormGroup` (model) Anda dengan widget-widget `Reactive*Field` di dalam UI.
- **`ReactiveTextField`, `ReactiveDropdownField`, dll.:** Widget UI yang diikat ke sebuah `FormControl` menggunakan properti `formControlName`.

**Sintaks Dasar / Contoh Implementasi Inti:**
Formulir login yang sama, diimplementasikan dengan Reactive Forms.

```dart
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  // ... (Sama seperti sebelumnya) ...
}

class ReactiveLoginScreen extends StatelessWidget {
  // 1. Definisikan model form (FormGroup) di dalam kode Dart.
  // Ini bisa dibuat di dalam BLoC, Controller, atau langsung di widget.
  final FormGroup form = FormGroup({
    'email': FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    'password': FormControl<String>(
      validators: [Validators.required, Validators.minLength(6)],
    ),
  });

  ReactiveLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reactive Forms Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // 2. Gunakan ReactiveForm untuk menghubungkan model ke UI
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 3. Ikat widget UI ke control dengan 'formControlName'
              ReactiveTextField<String>(
                formControlName: 'email',
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validationMessages: {
                  ValidationMessage.required: (_) => 'Email tidak boleh kosong',
                  ValidationMessage.email: (_) => 'Format email tidak valid',
                },
              ),
              const SizedBox(height: 16),
              ReactiveTextField<String>(
                formControlName: 'password',
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validationMessages: {
                  ValidationMessage.required: (_) => 'Password tidak boleh kosong',
                  ValidationMessage.minLength: (error) => 'Password minimal 6 karakter',
                },
              ),
              const SizedBox(height: 24),
              ReactiveFormConsumer(
                builder: (context, formGroup, child) {
                  return ElevatedButton(
                    // Tombol dinonaktifkan jika form tidak valid
                    onPressed: formGroup.valid ? () {
                      // 4. Akses nilai langsung dari model form
                      final email = formGroup.control('email').value;
                      final password = form.control('password').value;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login dengan $email')),
                      );
                    } : null,
                    child: const Text('Login'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

### **Representasi Diagram Alur & Kode (Reactive Forms)**

Diagram ini menyoroti pendekatan _model-driven_.

```
┌──────────────────────────────┐
│  FormGroup                   │ // Model: Didefinisikan di dalam kode Dart.
│  (Sumber Kebenaran)          │─────────┐
│  ┌────────────────────────┐  │         ▼
│  │ 'email': FormControl(  │  │ Struktur, nilai awal, dan validator
│  │   validators: [...]    │  │ semuanya didefinisikan di sini,
│  │ ),                     │  │ terpisah dari UI.
│  │ 'password': FormControl│  │
│  └────────────────────────┘  │
└──────────────┬───────────────┘
               │
┌──────────────▼───────────────┐
│  ReactiveForm                │ // UI: Jembatan antara Model dan Widget
│  (Jembatan UI-Model)         │
│  ┌────────────────────────┐  │
│  │ formGroup: form        │  │
│  ├────────────────────────┤  │
│  │ child: Column(...)     │  │
│  │ ┌────────────────────┐ │  │
│  │ │ ReactiveTextField  │ │  │
│  │ │ (UI untuk 'email') │ │─────────┐
│  │ │ ┌────────────────┐ │ │  │      ▼
│  │ │ │formControlName:│ │ │  │ Properti ini mengikat widget UI ke
│  │ │ │  'email'       │ │ │  │ FormControl dengan nama yang sama
│  │ │ └────────────────┘ │ │  │ di dalam FormGroup.
│  │ └────────────────────┘ │  │
│  │ ┌────────────────────┐ │  │
│  │ │ ReactiveTextField  │ │  │
│  │ │ (UI untuk 'pass')  │ │  │
│  │ │ formControlName:   │ │  │
│  │ │  'password'        │ │  │
│  │ └────────────────────┘ │  │
│  └────────────────────────┘  │
└──────────────────────────────┘
```

---

### **7.3. Input Formatters & Masks**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Validasi memeriksa apakah data _benar_, sedangkan _formatting_ memastikan data memiliki _format_ yang benar saat dimasukkan. Bagian ini mengajarkan cara untuk secara otomatis memformat input pengguna saat mereka mengetik, seperti menambahkan pemisah ribuan pada angka, tanda hubung pada nomor telepon, atau garis miring pada tanggal. Ini secara signifikan meningkatkan pengalaman pengguna dengan memandu mereka untuk memasukkan data dalam format yang diharapkan.

---

#### **7.3.1. Text Input Formatting**

**Deskripsi Konkret & Peran dalam Kurikulum:**
**`TextInputFormatter`** adalah kelas dasar di Flutter yang memungkinkan Anda mencegat dan memodifikasi input teks dari pengguna secara _real-time_. Anda dapat menerapkan aturan untuk membatasi jenis karakter yang diizinkan (misalnya, hanya angka) atau untuk mengubah teks secara dinamis (misalnya, mengubah menjadi huruf kapital). Memahami ini memungkinkan Anda untuk membuat pengalaman input yang terkontrol dan terpandu.

**Konsep Kunci & Filosofi Mendalam:**

- **Mencegat dan Mengubah:** `TextInputFormatter` bekerja dengan mencegat `TextEditingValue` lama dan baru. `TextEditingValue` tidak hanya berisi teks, tetapi juga informasi tentang posisi kursor dan seleksi. Fungsi _formatter_ Anda menerima kedua nilai ini dan harus mengembalikan `TextEditingValue` baru yang akan ditampilkan di layar.
- **Berbasis Aturan, Bukan Validasi:** _Formatter_ tidak menampilkan pesan error. Ia secara paksa **mencegah** atau **mengubah** input agar sesuai dengan aturan. Ia beroperasi pada level yang lebih rendah daripada _validator_.

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh _field_ yang hanya mengizinkan input angka dan _field_ lain yang menggunakan _package_ populer untuk format nomor telepon.

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

void main() => runApp(const MyApp());

// ... (MyApp widget) ...

class FormatterScreen extends StatelessWidget {
  FormatterScreen({super.key});

  // 1. Menggunakan package populer untuk format kompleks
  final phoneFormatter = MaskTextInputFormatter(
    mask: '+62 (###) ####-####', // Pola masker
    filter: {"#": RegExp(r'[0-9]')}
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Formatters')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nominal Transfer (Hanya Angka)',
              ),
              keyboardType: TextInputType.number,
              // 2. Menggunakan formatter bawaan Flutter
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
              ),
              keyboardType: TextInputType.phone,
              // 3. Menggunakan formatter dari package eksternal
              inputFormatters: [phoneFormatter],
            ),
          ],
        ),
      ),
    );
  }
}
```

### **Visualisasi Hasil Kode**

```
┌──────────────────────────────────┐
│  Tampilan Input Formatter        │
├──────────────────────────────────┤
│ AppBar: [Input Formatters]       │
│ -------------------------------- │
│                                  │
│  Nominal Transfer (Hanya Angka)  │
│  1500000_______________________  │  <-- Tidak bisa mengetik huruf
│                                  │
│  Nomor Telepon                   │
│  +62 (812) 3456-7890___________  │  <-- Tanda kurung, spasi, hubung
│                                  │      ditambahkan secara otomatis.
│                                  │
└──────────────────────────────────┘
```

### **Representasi Diagram Sederhana (Struktur Widget)**

```
  TextField (Nomor Telepon)
  └── inputFormatters: [
      └── MaskTextInputFormatter(
          ├── mask: '+62 (###) ####-####'
          └── filter: {"#": RegExp(r'[0-9]')}
      )
  ]
```

---

#### **7.3.2. Advanced Input Handling**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Selain format, ada banyak cara lain untuk mengoptimalkan pengalaman input. Bagian ini mencakup teknik-teknik "pelengkap" yang membuat formulir Anda lebih cerdas dan lebih mudah digunakan, seperti mengoptimalkan jenis _keyboard_ yang muncul, mengontrol tombol aksi di _keyboard_, dan bahkan mengintegrasikan metode input alternatif seperti suara atau pemindai kode.

**Konsep Kunci & Implementasi:**

- **Keyboard Type Optimization (`keyboardType`):** Menampilkan _keyboard_ yang paling relevan untuk jenis input akan mengurangi friksi bagi pengguna.

  - **Struktur:** `TextField(keyboardType: TextInputType.emailAddress)`
  - **Contoh Nilai:**
    - `TextInputType.text`: Keyboard standar.
    - `TextInputType.number`: Keyboard angka.
    - `TextInputType.phone`: Keyboard angka dengan tombol `*` dan `#`.
    - `TextInputType.emailAddress`: Keyboard standar dengan tombol `@` dan `.`.
    - `TextInputType.url`: Keyboard standar dengan tombol `/` dan `.`.
    - `TextInputType.visiblePassword`: Keyboard standar yang tidak menyarankan kata-kata.

- **Text Input Actions (`textInputAction`):** Mengubah tombol "Enter" atau "Return" di _keyboard_ menjadi aksi yang lebih kontekstual. Ini sangat berguna untuk memindahkan fokus antar _field_ atau men-submit formulir.

  - **Struktur:** `TextField(textInputAction: TextInputAction.next)`
  - **Contoh Nilai:**
    - `TextInputAction.next`: Menampilkan tombol "Next". Berguna untuk memindahkan fokus ke _field_ berikutnya.
    - `TextInputAction.done`: Menampilkan tombol "Done". Berguna untuk _field_ terakhir dalam formulir untuk menyembunyikan _keyboard_ atau men-submit.
    - `TextInputAction.search`: Menampilkan tombol "Search".

- **Auto-correction dan Suggestions:**

  - **Struktur:** `TextField(autocorrect: false, enableSuggestions: false)`
  - **Kegunaan:** Sangat penting untuk menonaktifkan ini pada _field_ seperti _username_, email, atau kode unik di mana koreksi otomatis justru akan mengganggu.

- **Integrasi Input Alternatif (Konseptual):**

  - **Speech-to-Text:** Menggunakan mikrofon untuk mengubah ucapan menjadi teks.
    - **Representasi:**
      ```
        TextField (dengan Ikon Mikrofon)
        └── onPressed (ikon):
            └── speech_to_text.listen() // Mulai mendengarkan
                └── onResult: (result) =>
                    └── _controller.text = result.recognizedWords // Update field
      ```
    - **Paket Populer:** `speech_to_text`.
  - **Barcode Scanning:** Menggunakan kamera untuk memindai barcode atau QR code dan memasukkan nilainya ke dalam _field_.
    - **Representasi:**
      ```
        TextField (dengan Ikon Kamera)
        └── onPressed (ikon):
            └── Navigator.push(ScanScreen()) // Buka layar kamera
                └── mobile_scanner.onDetect: (barcode) =>
                    └── Navigator.pop(context, barcode.rawValue) // Kirim hasil kembali
      ```
    - **Paket Populer:** `mobile_scanner`.

---

### **Ringkasan dan Penutupan Fase 5**

Kita telah secara komprehensif menyelesaikan **FASE 5: Forms & Input Handling**.

# Selamat!

Anda kini telah menguasai spektrum penuh manajemen formulir, mulai dari fondasi `Form` dan `TextFormField` bawaan, strategi validasi yang canggih, hingga penggunaan _library_ pihak ketiga seperti **Flutter Form Builder** untuk kecepatan dan **Reactive Forms** untuk kekuatan dan testabilitas. Terakhir, kita menyempurnakannya dengan teknik _formatting_ dan penanganan input lanjutan untuk menciptakan pengalaman pengguna yang mulus dan terpandu.

---

Aplikasi Anda kini tidak hanya dapat menampilkan data dan bernavigasi, tetapi juga mampu menerima input dari pengguna dengan cara yang andal dan terstruktur. Kini, setelah kita memiliki UI, Navigasi, State, dan Forms, kita benar-benar siap untuk menghubungkan aplikasi kita ke dunia luar untuk mengambil dan menyimpan data nyata.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md
[fase6]:../../flash/bagian-5/README.md

<!----------------------------------------------------->

[0]: ../../README.md
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
