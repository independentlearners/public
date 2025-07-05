> pro

# **[FASE 5: Forms & Input Handling][0]**

Ini berfokus pada cara aplikasi kita menerima dan memvalidasi input dari pengguna. Kita akan memulai dari fondasi paling dasar dalam menangani input pengguna.

### **Daftar Isi**

<details>
  <summary>📃 Struktur Materi</summary>

---

- **[7. Form Architecture & Validation](#7-form-architecture--validation)**
  - **[7.1. Form Widgets & Validation](#71-form-widgets--validation)**
    - [7.1.1. Form dan FormField](#711-form-dan-formfield)
    - [7.1.2. Validation Strategies](#)
  - **7.2. Advanced Form Management**
    - 7.2.1. Flutter Form Builder
    - 7.2.2. Reactive Forms
  - **7.3. Input Formatters & Masks**
    - 7.3.1. Text Input Formatting
    - 7.3.2. Advanced Input Handling

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

Kita telah membahas fondasi dari formulir di Flutter. Anda sekarang mengerti bagaimana `Form`, `TextFormField`, dan `GlobalKey` bekerja sama untuk mengumpulkan dan memvalidasi input.

Selanjutnya, kita akan mendalami berbagai strategi validasi yang lebih canggih.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md

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
