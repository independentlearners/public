> [flash][pro5]

# **[FASE 5: Forms & Input Handling][0]**

<details>
  <summary>📃 Struktur daftar materi</summary>

---

- [7. Form Architecture & Validation](#7-form-architecture--validation)
  - [7.1 Form Widgets & Validation](#71-form-widgets--validation)
    - Form dan FormField
    - Form state management
    - FormState methods (validate, save, reset)
    - TextFormField implementation
    - Custom FormField creation
    - Focus management dalam forms
    - Form submission handling
    - Form Validation
  - [7.2 Advanced Form Management](#72-advanced-form-management)
  - [7.3 Input Formatters & Masks](#73-input-formatters--masks)

</details>

---

### **7. Form Architecture & Validation**

##### **7.1 Form Widgets & Validation**

- **Peran:** Formulir adalah elemen fundamental dalam hampir setiap aplikasi untuk mengumpulkan masukan dari pengguna. Bagian ini akan membahas dasar-dasar membangun formulir di Flutter, mengelola _state_-nya, dan memvalidasi masukan pengguna untuk memastikan data yang dikirimkan benar dan lengkap.

- **Form dan FormField**

  - **`Form` Widget:**

    - **Peran:** `Form` adalah _widget_ opsional tetapi sangat direkomendasikan yang bertindak sebagai _container_ untuk sekelompok `FormField` _widget_. Ini memungkinkan Anda untuk mengelola _state_ dari semua `FormField` di dalamnya secara bersamaan, serta melakukan operasi seperti validasi, penyimpanan, dan pengaturan ulang (reset) _state_ formulir secara kolektif.
    - **Detail:** `Form` _widget_ membutuhkan `GlobalKey<FormState>` untuk mengakses `FormState` terkait yang mengelola _state_ semua `FormField` anakannya. Ini sangat berguna untuk memicu validasi atau menyimpan semua nilai formulir dari satu tombol.

  - **`FormField` Widget:**

    - **Peran:** `FormField` adalah _widget_ abstrak yang berfungsi sebagai _base class_ untuk semua _input field_ dalam `Form`. Ini menyediakan fungsionalitas dasar untuk manajemen _state_ input, validasi, dan penanganan kesalahan.
    - **Detail:** Setiap `FormField` memiliki `validator` (fungsi untuk validasi), `onSaved` (fungsi untuk menyimpan nilai), dan _error state_ internal. `TextFormField` adalah implementasi paling umum dari `FormField` untuk input teks.

- **Visualisasi Hubungan Form dan FormField:**

  ```
  ┌───────────────────────────────────┐
  │           Form Widget             │
  │ (GlobalKey<FormState> _formKey)   │
  │                                   │
  │ ┌───────────────────────────────┐ │
  │ │        FormField 1            │ │
  │ │ (e.g., TextFormField for Name)│ │
  │ └───────────────────────────────┘ │
  │ ┌───────────────────────────────┐ │
  │ │        FormField 2            │ │
  │ │(e.g., TextFormField for Email)│ │
  │ └───────────────────────────────┘ │
  │ ┌───────────────────────────────┐ │
  │ │        FormField 3            │ │
  │ │ (e.g., DropdownFormField)     │ │
  │ └───────────────────────────────┘ │
  └───────────────────────────────────┘
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan bagaimana `Form` _widget_ berfungsi sebagai wadah induk untuk beberapa `FormField` _widget_. `GlobalKey<FormState>` pada `Form` adalah kunci untuk berinterinteraksi dengan _state_ gabungan dari semua _field_ di dalamnya.

- **Form State Management**

  - **Peran:** Mengelola _state_ formulir melibatkan pelacakan nilai masukan, _status validasi_ untuk setiap _field_, dan apakah formulir secara keseluruhan valid atau tidak.
  - **Detail:** `FormState` adalah kelas yang menyediakan API untuk berinteraksi dengan _state_ formulir. Anda mendapatkan instance `FormState` melalui `_formKey.currentState`.
  - **`GlobalKey<FormState>`:** Kunci unik yang digunakan untuk mengakses `FormState` dari sebuah `Form` di mana pun dalam _widget tree_.

  <!-- end list -->

  ```dart
  final _formKey = GlobalKey<FormState>(); // Deklarasikan di dalam StatefulWidget

  // Di dalam metode build:
  Form(
    key: _formKey, // Pasangkan kunci ke Form widget
    child: Column(
      children: <Widget>[
        // TextFormField, dll.
        ElevatedButton(
          onPressed: () {
            // Validasi dan simpan formulir
            if (_formKey.currentState!.validate()) { // Panggil validate() pada FormState
              _formKey.currentState!.save(); // Panggil save() pada FormState
              // Lanjutkan dengan pengiriman data
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Form Berhasil Dikirim')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ada kesalahan validasi')),
              );
            }
          },
          child: const Text('Submit'),
        ),
      ],
    ),
  );
  ```

- **FormState methods (validate, save, reset)**

  - **`validate()`:**

    - **Peran:** Memicu fungsi `validator` pada setiap `FormField` anakannya.
    - **Detail:** Mengembalikan `true` jika semua _field_ valid, dan `false` jika ada setidaknya satu _field_ yang tidak valid. Jika tidak valid, pesan kesalahan dari `validator` akan ditampilkan di bawah _field_ yang bersangkutan.
    - **Penggunaan:** Umumnya dipanggil saat tombol "Submit" ditekan.

  - **`save()`:**

    - **Peran:** Memicu fungsi `onSaved` pada setiap `FormField` anakannya.
    - **Detail:** Fungsi `onSaved` menerima nilai yang telah divalidasi dari _field_, memungkinkan Anda untuk menyimpan nilai tersebut ke variabel _state_ atau objek model.
    - **Penggunaan:** Hanya boleh dipanggil setelah `validate()` mengembalikan `true`.

  - **`reset()`:**

    - **Peran:** Mengatur ulang setiap `FormField` anakannya ke _initial value_-nya.
    - **Detail:** Juga akan menghapus pesan kesalahan validasi yang sedang ditampilkan.
    - **Penggunaan:** Berguna untuk tombol "Clear" atau setelah pengiriman formulir berhasil.

  <!-- end list -->

  ```dart
  // Contoh penggunaan di ElevatedButton.onPressed:

  // Fungsi untuk handle submit
  void _submitForm() {
    if (_formKey.currentState!.validate()) { // Lakukan validasi
      _formKey.currentState!.save(); // Jika valid, simpan data
      // Lanjutkan dengan logik pengiriman data ke backend atau proses lainnya
      print('Form data saved!');
      _formKey.currentState!.reset(); // Reset formulir setelah berhasil
    } else {
      print('Form validation failed!');
    }
  }

  // Fungsi untuk handle reset
  void _resetForm() {
    _formKey.currentState!.reset();
    print('Form reset!');
  }
  ```

- **TextFormField implementation**

  - **Peran:** `TextFormField` adalah `FormField` yang paling sering digunakan, dirancang khusus untuk menerima masukan teks dari pengguna.
  - **Detail:** Ia menggabungkan `TextField` dengan fungsionalitas `FormField`, termasuk kemampuan untuk memiliki `validator`, `onSaved`, dan menampilkan pesan kesalahan.

  <!-- end list -->

  ```dart
  TextFormField(
    decoration: const InputDecoration(
      labelText: 'Nama Pengguna',
      hintText: 'Masukkan nama lengkap Anda',
      border: OutlineInputBorder(),
      icon: Icon(Icons.person),
    ),
    // Contoh validator:
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Nama pengguna tidak boleh kosong';
      }
      return null; // Return null jika valid
    },
    // Contoh onSaved:
    onSaved: (value) {
      _username = value!; // Simpan nilai ke variabel state
      print('Nama Pengguna Disimpan: $_username');
    },
    // Opsi lain:
    keyboardType: TextInputType.text,
    initialValue: 'John Doe', // Nilai awal
    controller: _usernameController, // Alternatif untuk initialValue dan onSaved
    onChanged: (value) {
      // Dipanggil setiap kali teks berubah
      print('OnChanged: $value');
    },
    obscureText: false, // Untuk password
    maxLength: 50, // Batasi jumlah karakter
  ),
  ```

- **Custom FormField creation**

  - **Peran:** Terkadang, Anda mungkin memerlukan _input field_ yang lebih kompleks daripada `TextFormField` standar, seperti pemilih tanggal khusus, pemilih warna, atau _input_ dengan format unik. Untuk kasus ini, Anda dapat membuat `Custom FormField` Anda sendiri.
  - **Detail:** Anda dapat membuat `Custom FormField` dengan membungkus _widget input_ kustom Anda di dalam `FormField` _widget_ dan mengimplementasikan `builder` serta metode `validator` dan `onSaved` yang diperlukan.

  <!-- end list -->

  ```dart
  // Contoh Custom FormField untuk pemilih tanggal
  class DatePickerFormField extends FormField<DateTime> {
    DatePickerFormField({
      super.key,
      super.onSaved,
      super.validator,
      super.initialValue,
      required BuildContext context, // Untuk showDatePicker
    }) : super(
        builder: (FormFieldState<DateTime> state) {
          return InkWell(
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: state.value ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null && pickedDate != state.value) {
                state.didChange(pickedDate); // Perbarui state FormField
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Pilih Tanggal',
                border: const OutlineInputBorder(),
                errorText: state.errorText, // Tampilkan pesan kesalahan
              ),
              isEmpty: state.value == null,
              child: Text(
                state.value != null
                    ? '${state.value!.toLocal()}'.split(' ')[0]
                    : 'Tanggal Belum Dipilih',
              ),
            ),
          );
        },
      );
  }

  // Penggunaan di dalam Form:
  // DatePickerFormField(
  //   context: context,
  //   validator: (value) {
  //     if (value == null) {
  //       return 'Tanggal harus dipilih';
  //     }
  //     return null;
  //   },
  //   onSaved: (value) {
  //     _selectedDate = value;
  //   },
  // ),
  ```

- **Focus management dalam forms**

  - **Peran:** Mengelola _focus_ keyboard berarti mengontrol _input field_ mana yang aktif (memiliki kursor) dan bagaimana _focus_ berpindah antar _field_ (misalnya, saat pengguna menekan "Next" pada keyboard). Ini penting untuk ergonomi pengguna.
  - **Detail:**
    - **`FocusNode`:** Objek yang dapat dilampirkan ke _widget_ yang dapat di-_focus_ (seperti `TextFormField`) untuk mengontrol _focus_ secara terprogram.
    - **`FocusScope`:** _Widget_ yang mengelola grup `FocusNode`. Digunakan untuk memindahkan _focus_ ke _field_ berikutnya atau menutup _keyboard_.

  <!-- end list -->

  ```dart
  // Deklarasikan FocusNode di StatefulWidget
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // Di TextFormField:
  TextFormField(
    focusNode: _usernameFocusNode,
    decoration: const InputDecoration(labelText: 'Username'),
    textInputAction: TextInputAction.next, // Keyboard action "Next"
    onFieldSubmitted: (value) {
      // Pindahkan focus ke field email saat "Next" ditekan
      FocusScope.of(context).requestFocus(_emailFocusNode);
    },
  ),
  TextFormField(
    focusNode: _emailFocusNode,
    decoration: const InputDecoration(labelText: 'Email'),
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (value) {
      FocusScope.of(context).requestFocus(_passwordFocusNode);
    },
  ),
  TextFormField(
    focusNode: _passwordFocusNode,
    decoration: const InputDecoration(labelText: 'Password'),
    textInputAction: TextInputAction.send, // Keyboard action "Send" (atau "Done")
    onFieldSubmitted: (value) {
      // Saat "Send" ditekan, bisa langsung trigger submit form
      _submitForm();
      _passwordFocusNode.unfocus(); // Tutup keyboard
    },
  ),

  // Di Dispose (penting untuk membuang FocusNode)
  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
  ```

- **Form submission handling**

  - **Peran:** Setelah pengguna selesai mengisi formulir dan data telah divalidasi, langkah berikutnya adalah mengirimkan data tersebut, biasanya ke _backend server_ atau untuk diproses secara lokal.
  - **Detail:**
    1.  **Validasi:** Pastikan `_formKey.currentState!.validate()` mengembalikan `true`.
    2.  **Penyimpanan:** Panggil `_formKey.currentState!.save()` untuk memicu `onSaved` pada setiap _field_ dan kumpulkan data.
    3.  **Proses Data:** Gunakan data yang terkumpul (misalnya dalam variabel _state_ atau objek model) untuk memanggil API, menyimpan ke database lokal, dll.
    4.  **Feedback Pengguna:** Berikan umpan balik visual kepada pengguna (misalnya, _SnackBar_, _loading indicator_, pesan sukses/gagal).
    5.  **Reset/Navigasi:** Setelah pengiriman berhasil, Anda dapat mereset formulir (`_formKey.currentState!.reset()`) atau menavigasi ke halaman lain.

  <!-- end list -->

  ```dart
  // Asumsikan _username, _email, _password adalah variabel state
  String? _username;
  String? _email;
  String? _password;

  final _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Simpan nilai ke _username, _email, _password

      // Tampilkan loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mengirim data...')),
      );

      try {
        // Simulasi pengiriman data ke server
        await Future.delayed(const Duration(seconds: 2));
        print('Data berhasil dikirim:');
        print('Username: $_username');
        print('Email: $_email');
        print('Password: $_password');

        // Berikan feedback sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil dikirim!')),
        );

        _formKey.currentState!.reset(); // Reset formulir
        // Atau navigasi ke halaman lain: Navigator.of(context).pushReplacement(...);

      } catch (e) {
        // Tangani kesalahan pengiriman
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim data: $e')),
        );
      }
    }
  }
  ```

- **Form Validation**

  - **Peran:** Memastikan bahwa data yang dimasukkan oleh pengguna memenuhi kriteria tertentu (misalnya, tidak kosong, format email yang benar, panjang minimum/maksimum) sebelum data tersebut diproses atau disimpan.

  - **Detail:** Validasi adalah inti dari `FormField` melalui properti `validator`-nya. Fungsi `validator` menerima nilai input dan harus mengembalikan `null` jika nilai tersebut valid, atau sebuah `String` (pesan kesalahan) jika tidak valid.

  - **TextFormField Advanced Usage:**

    - **`autovalidateMode`:** Mengontrol kapan validasi dipicu secara otomatis.
      - `AutovalidateMode.disabled`: Tidak ada validasi otomatis. Dipicu hanya saat `_formKey.currentState!.validate()` dipanggil.
      - `AutovalidateMode.onUserInteraction`: Validasi dipicu setelah setiap interaksi pengguna dengan _field_ (misalnya, saat mengetik).
      - `AutovalidateMode.always`: Validasi dipicu setiap kali _widget_ dibangun ulang.
    - **`onChanged`:** Callback yang dipanggil setiap kali teks berubah. Berguna untuk validasi _real-time_ kustom atau pembaruan _state_ segera.
    - **`decoration`:** Objek `InputDecoration` untuk mengkustomisasi tampilan _field_, termasuk label, _hint text_, _prefix/suffix icons_, dan terutama `errorText`.

  - **Custom Form Fields:**

    - Seperti yang dibahas sebelumnya, Anda dapat membuat _widget_ input kustom dan membungkusnya dalam `FormField` untuk mengintegrasikan validasi. Fungsi `validator` akan tetap bekerja dengan cara yang sama.

  - **Validation Strategies:**

    - **Built-in validators:** `TextFormField` tidak memiliki validator "bawaan" dalam arti kata pustaka utilitas. Anda harus menulis fungsi `validator` Anda sendiri atau menggunakan _package_ validator pihak ketiga.

    - **Custom validator functions:** Cara paling umum untuk memvalidasi. Anda menulis fungsi yang mengembalikan `String` atau `null`.

      ```dart
      String? _emailValidator(String? value) {
        if (value == null || value.isEmpty) {
          return 'Email tidak boleh kosong';
        }
        // Regex sederhana untuk validasi email
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        if (!emailRegex.hasMatch(value)) {
          return 'Format email tidak valid';
        }
        return null;
      }
      // Penggunaan: validator: _emailValidator,
      ```

    - **Real-time vs on-submit validation:**

      - **Real-time:** Validasi terjadi saat pengguna mengetik atau setelah setiap _field_ kehilangan _focus_. Dicapai dengan `autovalidateMode: AutovalidateMode.onUserInteraction`. Memberikan umpan balik instan kepada pengguna.
      - **On-submit:** Validasi hanya terjadi saat tombol submit ditekan. Dicapai dengan `autovalidateMode: AutovalidateMode.disabled` dan memanggil `_formKey.currentState!.validate()` saat submit.

    - **Cross-field validation:**

      - **Peran:** Validasi yang bergantung pada nilai lebih dari satu _input field_ (misalnya, kata sandi dan konfirmasi kata sandi harus sama).
      - **Detail:** Ini sedikit lebih rumit dengan `Form` dan `FormField` standar karena `validator` setiap _field_ hanya memiliki akses ke nilai _field_ itu sendiri. Anda perlu mengakses nilai _field_ lain secara manual (misalnya, menggunakan `TextEditingController` untuk mendapatkan nilai _field_ lain) di dalam fungsi `validator` atau melakukan validasi lintas _field_ di dalam fungsi `_submitForm` setelah semua data diselamatkan.

      <!-- end list -->

      ```dart
      // Contoh validasi password dan konfirmasi password
      TextEditingController _passwordController = TextEditingController();
      TextEditingController _confirmPasswordController = TextEditingController();

      // ... di dalam build method
      TextFormField(
        controller: _passwordController,
        decoration: const InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
          if (value.length < 6) return 'Password minimal 6 karakter';
          return null;
        },
      ),
      TextFormField(
        controller: _confirmPasswordController,
        decoration: const InputDecoration(labelText: 'Konfirmasi Password'),
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Konfirmasi password tidak boleh kosong';
          if (value != _passwordController.text) return 'Password tidak cocok';
          return null;
        },
      ),
      ```

    - **Async validation:**

      - **Peran:** Validasi yang memerlukan operasi asinkron, seperti memeriksa ketersediaan nama pengguna di _server_.
      - **Detail:** Fungsi `validator` pada `FormField` harus mengembalikan `String?` secara sinkron. Untuk validasi asinkron, Anda perlu menggabungkan strategi.
        1.  **Validasi Awal Sinkron:** Gunakan validator sinkron untuk memeriksa validasi dasar (misalnya, tidak kosong).
        2.  **Validasi Asinkron Terpisah:** Lakukan panggilan asinkron (misalnya, setelah `onChanged` atau saat `onFieldSubmitted`).
        3.  **Tampilkan Indikator/Error:** Gunakan `TextEditingController` dan `ValueNotifier` atau _state management_ untuk menampilkan _loading indicator_ dan pesan kesalahan dari hasil validasi asinkron.
        4.  **Blokir Pengiriman:** Jangan biarkan formulir disubmit sampai validasi asinkron selesai dan berhasil.

      <!-- end list -->

      ```dart
      // Contoh ide validasi async (lebih kompleks dengan state management)
      String? _usernameAsyncError; // State untuk error async

      TextFormField(
        decoration: InputDecoration(
          labelText: 'Username',
          errorText: _usernameAsyncError, // Tampilkan error dari async
        ),
        onChanged: (value) async {
          // Trigger validasi async setelah delay (debounce)
          if (value.length >= 3) {
            setState(() => _usernameAsyncError = null); // Hapus error sebelumnya
            bool isAvailable = await _checkUsernameAvailability(value);
            if (!isAvailable) {
              setState(() => _usernameAsyncError = 'Nama pengguna sudah digunakan');
            }
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) return 'Username tidak boleh kosong';
          return null; // Hanya validasi sinkron dasar
        },
      ),

      Future<bool> _checkUsernameAvailability(String username) async {
         // Simulasi API call
         await Future.delayed(const Duration(seconds: 1));
         return username != 'admin'; // 'admin' tidak tersedia
      }
      ```

    - **Validation error display:**

      - Secara _default_, jika `validator` mengembalikan `String` yang bukan `null`, `TextFormField` akan menampilkan pesan kesalahan tersebut di bawah _input field_ dengan warna merah.
      - Anda dapat mengkustomisasi tampilan pesan kesalahan melalui `InputDecoration` (`errorText`, `errorStyle`, `errorMaxLines`).

- **Visualisasi Form Validation Flow:**

  ```
  ┌───────────────────────────┐
  │     User Interaction      │
  │  (e.g., Typing, Submit)   │
  └────────────┬──────────────┘
               │
               ▼
  ┌────────────────────────────────────┐
  │             Form Widget            │
  │  _formKey.currentState!.validate() │
  └────────────┬───────────────────────┘
               │ Memicu validator setiap FormField
               ▼
  ┌──────────────────────────────────┐
  │     FormField 1 (Name)           │
  │ ┌──────────────────────────────┐ │
  │ │          validator()         │ │
  │ │(Returns null or Error String)│ │
  │ └────────────┬─────────────────┘ │
  └──────────────│───────────────────┘
                 ▼
  ┌──────────────────────────────────┐
  │        FormField 2 (Email)       │
  │ ┌──────────────────────────────┐ │
  │ │           validator()        │ │
  │ │(Returns null or Error String)│ │
  │ └────────────┬─────────────────┘ │
  └──────────────│───────────────────┘
                 ▼
  ┌──────────────────────────────────┐
  │            FormState             │
  │ (Aggregates validation results)  │
  │ ┌───────────────────────┐        │
  │ │       All Valid?      │        │
  │ └────────────┬──────────┘        │
  └──────────────│───────────────────┘
       ┌─────────┴─────────┐
       ▼                   ▼
  ┌─────────────────┐    ┌─────────────────┐
  │    All Valid    │    │     Invalid     │
  │ (Returns true)  │    │ (Returns false) │
  └─────┬───────────┘    └───────────────┬─┘
        │                                │
        ▼                                ▼
  ┌───────────────────────────────┐   ┌───────────────────────────────────┐
  │ _formKey.currentState!.save() │   │      Display Error Messages       │
  │         (Process Data)        │   │ (e.g., "Nama tidak boleh kosong") │
  └───────────────────────────────┘   └───────────────────────────────────┘
  ```

  **Penjelasan Visual:**
  Alur validasi formulir dimulai dari interaksi pengguna yang memicu `validate()` pada `FormState`. Ini kemudian menjalankan `validator` pada setiap `FormField`. Hasil validasi dari setiap _field_ digabungkan oleh `FormState` untuk menentukan validitas formulir secara keseluruhan, dan pesan kesalahan akan ditampilkan untuk _field_ yang tidak valid.

---

**Contoh Kode Lengkap (Illustrasi):**

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form & Validation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyFormPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyFormPage extends StatefulWidget {
  const MyFormPage({super.key});

  @override
  State<MyFormPage> createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  final _formKey = GlobalKey<FormState>(); // Kunci untuk Form
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();

  String? _username;
  String? _email;
  String? _password;
  DateTime? _selectedDate; // Untuk Custom FormField

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Validator kustom untuk email
  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Fungsi untuk handle pengiriman formulir
  void _submitForm() async {
    // Memvalidasi semua FormField
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Memicu onSaved pada setiap FormField

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mengirim data...')),
      );

      try {
        await Future.delayed(const Duration(seconds: 2)); // Simulasi pengiriman data
        print('Data Berhasil Dikumpulkan:');
        print('Username: $_username');
        print('Email: $_email');
        print('Password: $_password');
        print('Tanggal Lahir: ${_selectedDate?.toLocal().toIso8601String().split('T')[0]}');


        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form Berhasil Dikirim!')),
        );

        _formKey.currentState!.reset(); // Atur ulang formulir
        _passwordController.clear(); // Clear controller password secara manual
        // Pindahkan fokus kembali ke field pertama
        FocusScope.of(context).requestFocus(_usernameFocusNode);

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim data: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon koreksi kesalahan dalam formulir.')),
      );
    }
  }

  // Fungsi untuk handle reset formulir
  void _resetForm() {
    _formKey.currentState!.reset();
    _passwordController.clear(); // Reset controller password secara manual
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Formulir direset.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form & Validation Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Pasangkan GlobalKey di sini
          autovalidateMode: AutovalidateMode.onUserInteraction, // Validasi real-time
          child: ListView(
            children: <Widget>[
              // TextFormField untuk Nama Pengguna
              TextFormField(
                focusNode: _usernameFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Nama Pengguna',
                  hintText: 'Masukkan nama lengkap Anda',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                textInputAction: TextInputAction.next, // Keyboard action "Next"
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama pengguna tidak boleh kosong';
                  }
                  if (value.length < 3) {
                    return 'Nama pengguna minimal 3 karakter';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value;
                },
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
              ),
              const SizedBox(height: 16.0),

              // TextFormField untuk Email
              TextFormField(
                focusNode: _emailFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Masukkan alamat email Anda',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _emailValidator, // Gunakan validator kustom
                onSaved: (value) {
                  _email = value;
                },
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),
              const SizedBox(height: 16.0),

              // TextFormField untuk Password
              TextFormField(
                focusNode: _passwordFocusNode,
                controller: _passwordController, // Menggunakan controller untuk cross-field validation
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Masukkan password Anda',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value;
                },
                onFieldSubmitted: (value) {
                  // Pindah fokus ke tombol submit atau trigger submit
                  FocusScope.of(context).unfocus(); // Menutup keyboard
                },
              ),
              const SizedBox(height: 16.0),

              // TextFormField untuk Konfirmasi Password (Contoh Cross-field validation)
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password',
                  hintText: 'Masukkan kembali password Anda',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password tidak boleh kosong';
                  }
                  if (value != _passwordController.text) { // Membandingkan dengan nilai dari controller
                    return 'Password tidak cocok';
                  }
                  return null;
                },
                // onSaved tidak diperlukan jika hanya untuk konfirmasi
                onFieldSubmitted: (value) {
                  _submitForm(); // Langsung submit saat enter ditekan di field terakhir
                },
              ),
              const SizedBox(height: 16.0),

              // Custom FormField untuk Pemilih Tanggal
              DatePickerFormField(
                context: context, // Meneruskan BuildContext untuk showDatePicker
                initialValue: _selectedDate, // Jika ada nilai awal
                validator: (value) {
                  if (value == null) {
                    return 'Tanggal lahir harus dipilih';
                  }
                  return null;
                },
                onSaved: (value) {
                  _selectedDate = value;
                },
              ),
              const SizedBox(height: 24.0),

              // Tombol Submit dan Reset
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _submitForm, // Panggil fungsi submit
                    child: const Text('Submit'),
                  ),
                  OutlinedButton(
                    onPressed: _resetForm, // Panggil fungsi reset
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom FormField untuk Pemilih Tanggal (seperti yang dijelaskan di atas)
class DatePickerFormField extends FormField<DateTime> {
  DatePickerFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    required BuildContext context, // Untuk showDatePicker
  }) : super(
          builder: (FormFieldState<DateTime> state) {
            return InkWell(
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: state.value ?? DateTime.now(),
                  firstDate: DateTime(1900), // Rentang tahun yang lebih luas
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null && pickedDate != state.value) {
                  state.didChange(pickedDate); // Perbarui state FormField
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Tanggal Lahir',
                  border: const OutlineInputBorder(),
                  errorText: state.errorText, // Tampilkan pesan kesalahan
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                isEmpty: state.value == null,
                child: Text(
                  state.value != null
                      ? '${state.value!.toLocal()}'.split(' ')[0] // Format tanggal sederhana
                      : 'Pilih Tanggal',
                  style: Theme.of(context).textTheme.titleMedium, // Sesuaikan gaya teks
                ),
              ),
            );
          },
        );
}
```

---

Dengan ini, kita telah membahas secara mendetail tentang **Form Widgets & Validation**, mencakup `Form` dan `FormField`, manajemen _state_, metode `FormState`, implementasi `TextFormField`, pembuatan `Custom FormField`, manajemen _focus_, penanganan pengiriman formulir, dan strategi validasi. Selanjutnya, kita akan berpindah ke **7.2 Advanced Form Management**, yang akan membahas _package_ seperti `Flutter Form Builder` dan `Reactive Forms`.

---

Sekarang, kita akan fokus pada sub-bagian yang merupakan langkah penting untuk memahami bagaimana mengelola formulir yang lebih kompleks dan dinamis dalam aplikasi Flutter.

Dalam bagian ini, kita akan membahas dua pendekatan utama untuk manajemen formulir lanjutan:

### **7.2 Advanced Form Management**

1.  **Flutter Form Builder**

    - **Pengaturan Form Builder**: Memahami cara menginisialisasi dan mengintegrasikan pustaka `flutter_form_builder` ke dalam proyek Anda. Ini akan menyederhanakan proses pembuatan formulir dengan menyediakan _widget_ yang telah dikonfigurasi sebelumnya.
    - **Form Field Pra-bangun**: Mengenal berbagai jenis _field_ formulir yang sudah disediakan oleh _Form Builder_, seperti _text input_, _checkboxes_, _radio buttons_, dan lain-lain. Ini mempercepat pengembangan karena Anda tidak perlu membangun _widget_ dasar dari awal.
    - **Validator Form Builder**: Mempelajari cara menerapkan validasi menggunakan validator bawaan `form_builder_validators` atau membuat validator kustom untuk memastikan integritas data masukan.
    - **Pembuatan Formulir Dinamis**: Menguasai teknik untuk membuat formulir yang dapat berubah secara dinamis berdasarkan masukan pengguna atau kondisi aplikasi. Ini sangat berguna untuk skenario di mana struktur formulir tidak statis.
    - **Manajemen State Form Builder**: Memahami bagaimana _Form Builder_ mengelola _state_ formulir secara internal dan bagaimana Anda dapat mengakses serta memanipulasinya.

2.  **Reactive Forms**
    - **Model Form Reaktif**: Mempelajari konsep inti dari _Reactive Forms_, di mana formulir direpresentasikan sebagai model data reaktif. Ini memungkinkan penanganan _state_ formulir yang lebih kuat dan prediktif.
    - **Form Control dan Form Group**: Memahami bagaimana `FormControl` merepresentasikan _field_ tunggal dan `FormGroup` mengelompokkan `FormControl` menjadi satu unit logis, memungkinkan validasi dan manipulasi kolektif.
    - **Validator Reaktif**: Menggunakan validator yang dirancang untuk bekerja dengan model formulir reaktif, termasuk validasi sinkron dan asinkron.
    - **Formulir Dinamis dengan Array**: Menerapkan formulir dinamis menggunakan `FormArray` untuk mengelola daftar _field_ yang dapat ditambahkan atau dihapus secara _runtime_.
    - **Streaming State Formulir**: Memanfaatkan kemampuan _Reactive Forms_ untuk mengekspos perubahan _state_ formulir sebagai _stream_, memungkinkan Anda bereaksi terhadap perubahan data secara efisien.
    - **Code Generation untuk Formulir**: Memanfaatkan `reactive_forms_generator` untuk secara otomatis membuat kode formulir berdasarkan definisi model, mengurangi _boilerplate_ dan meningkatkan _type-safety_.

Kedua pendekatan ini menawarkan solusi yang lebih canggih dibandingkan manajemen formulir bawaan Flutter (`Form` dan `FormField`) terutama untuk aplikasi skala besar dengan kebutuhan formulir yang kompleks.

#### **7. Form Architecture & Validation (Lanjutan)**

### **7.2 Advanced Form Management**

- **Peran:** Meskipun `Form` dan `TextFormField` bawaan Flutter sudah cukup untuk formulir sederhana, aplikasi yang lebih kompleks seringkali membutuhkan solusi yang lebih kuat untuk mengurangi _boilerplate_, mempermudah validasi, dan mengelola formulir dinamis. `Flutter Form Builder` adalah salah satu _package_ populer yang mengatasi tantangan ini.

---

###### **Flutter Form Builder**

- **Gambaran Umum:** `flutter_form_builder` adalah _package_ yang menyediakan serangkaian _widget_ _input field_ yang telah dikonfigurasi sebelumnya (seperti `FormBuilderTextField`, `FormBuilderCheckbox`, dll.) dan alat untuk manajemen formulir secara lebih terstruktur. Ini memungkinkan Anda membangun formulir dengan cepat dan fokus pada logika bisnis daripada detail implementasi _widget_ _input_.

- **1. Form Builder Setup**

  - **Peran:** Mengatur proyek Anda untuk menggunakan `flutter_form_builder`.
  - **Detail:** Tambahkan `flutter_form_builder` dan `form_builder_validators` (untuk validator siap pakai) ke `pubspec.yaml` Anda.
  - **`pubspec.yaml`:**
    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      flutter_form_builder: ^latest_version # Ganti dengan versi terbaru
      form_builder_validators: ^latest_version # Ganti dengan versi terbaru
    ```
  - Setelah menambahkan, jalankan `flutter pub get` di terminal.
  - **Struktur Dasar:** `FormBuilder` _widget_ adalah pengganti untuk `Form` _widget_ standar, yang juga memerlukan `GlobalKey<FormBuilderState>`.

  <!-- end list -->

  ```dart
  import 'package:flutter/material.dart';
  import 'package:flutter_form_builder/flutter_form_builder.dart';
  import 'package:form_builder_validators/form_builder_validators.dart'; // Import validator

  class MyFormBuilderPage extends StatefulWidget {
    const MyFormBuilderPage({super.key});

    @override
    State<MyFormBuilderPage> createState() => _MyFormBuilderPageState();
  }

  class _MyFormBuilderPageState extends State<MyFormBuilderPage> {
    // Deklarasi GlobalKey untuk FormBuilderState
    final _formKey = GlobalKey<FormBuilderState>();

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Flutter Form Builder Demo')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey, // Pasangkan kunci ke FormBuilder
            // autovalidateMode: AutovalidateMode.onUserInteraction, // Opsional: validasi real-time
            child: Column(
              children: [
                // Contoh FormBuilderTextField
                FormBuilderTextField(
                  name: 'namaPengguna', // Nama unik untuk field ini
                  decoration: const InputDecoration(labelText: 'Nama Pengguna'),
                  validator: FormBuilderValidators.required(), // Validator bawaan
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Akses state form dan validasi
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      // Data valid, akses nilai:
                      print(_formKey.currentState?.value);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Form Berhasil Dikirim (Form Builder)')),
                      );
                    } else {
                      print('Validasi Form Gagal');
                      print(_formKey.currentState?.errors); // Lihat error
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ada Kesalahan Validasi (Form Builder)')),
                      );
                    }
                  },
                  child: const Text('Submit Form Builder'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
  ```

- **2. Pre-built Form Fields (Form Field Pra-bangun)**

  - **Peran:** `flutter_form_builder` menyediakan banyak _widget_ _input_ yang siap pakai, yang sudah mengimplementasikan fungsionalitas `FormField` secara internal. Ini mencakup berbagai jenis _input_ yang umum digunakan.
  - **Detail:** Setiap _widget_ memiliki properti `name` yang unik, yang akan digunakan sebagai kunci dalam peta data saat Anda mengambil nilai formulir.
  - **Contoh Umum:**
    - `FormBuilderTextField`: Untuk input teks.
    - `FormBuilderDropdown`: Untuk pilihan _dropdown_.
    - `FormBuilderCheckbox`: Untuk kotak centang tunggal.
    - `FormBuilderRadioGroup`: Untuk grup pilihan radio.
    - `FormBuilderDateTimePicker`: Untuk memilih tanggal dan/atau waktu.
    - `FormBuilderSlider`: Untuk _slider_ nilai.
    - `FormBuilderRangeSlider`: Untuk _slider_ rentang nilai.
    - `FormBuilderSwitch`: Untuk _toggle switch_.
    - `FormBuilderRating`: Untuk input rating bintang.
    - `FormBuilderFilterChip`/`FormBuilderChoiceChip`: Untuk pilihan dalam bentuk _chip_.
  - **Contoh Kode:**

  <!-- end list -->

  ```dart
  // ... di dalam FormBuilder child Column
  FormBuilderTextField(
    name: 'namaLengkap',
    decoration: const InputDecoration(labelText: 'Nama Lengkap'),
    validator: FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Nama lengkap harus diisi'),
      FormBuilderValidators.maxLength(100, errorText: 'Nama terlalu panjang'),
    ]),
  ),
  const SizedBox(height: 16),

  FormBuilderDropdown<String>(
    name: 'jenisKelamin',
    decoration: const InputDecoration(
      labelText: 'Jenis Kelamin',
      hintText: 'Pilih jenis kelamin',
      border: OutlineInputBorder(),
    ),
    validator: FormBuilderValidators.required(errorText: 'Jenis kelamin harus dipilih'),
    items: ['Pria', 'Wanita', 'Lainnya']
        .map((gender) => DropdownMenuItem(
              value: gender,
              child: Text(gender),
            ))
        .toList(),
  ),
  const SizedBox(height: 16),

  FormBuilderDateTimePicker(
    name: 'tanggalLahir',
    decoration: const InputDecoration(
      labelText: 'Tanggal Lahir',
      border: OutlineInputBorder(),
      prefixIcon: Icon(Icons.calendar_today),
    ),
    inputType: InputType.date, // Hanya tanggal
    validator: FormBuilderValidators.required(errorText: 'Tanggal lahir harus diisi'),
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  ),
  const SizedBox(height: 16),

  FormBuilderCheckbox(
    name: 'persetujuan',
    title: const Text('Saya menyetujui syarat & ketentuan'),
    validator: FormBuilderValidators.requiredTrue(
      errorText: 'Anda harus menyetujui syarat & ketentuan',
    ),
  ),
  // ...
  ```

- **3. Form Builder Validators**

  - **Peran:** `form_builder_validators` adalah _package_ pendamping yang menyediakan koleksi validator yang kuat dan mudah digunakan untuk semua jenis _field_ formulir. Ini sangat mengurangi kebutuhan untuk menulis fungsi validator kustom.
  - **Detail:** Validator ini seringkali dapat digabungkan (menggunakan `FormBuilderValidators.compose()`) untuk menerapkan beberapa aturan validasi ke satu _field_. Setiap validator memiliki parameter `errorText` kustom.
  - **Contoh Umum Validator:**
    - `FormBuilderValidators.required()`: Memastikan _field_ tidak kosong.
    - `FormBuilderValidators.email()`: Memvalidasi format email.
    - `FormBuilderValidators.numeric()`: Memvalidasi bahwa input adalah angka.
    - `FormBuilderValidators.minLength(min)`: Panjang minimum.
    - `FormBuilderValidators.maxLength(max)`: Panjang maksimum.
    - `FormBuilderValidators.min(value)`: Nilai numerik minimum.
    - `FormBuilderValidators.max(value)`: Nilai numerik maksimum.
    - `FormBuilderValidators.url()`: Memvalidasi format URL.
    - `FormBuilderValidators.match(pattern)`: Memvalidasi menggunakan _regular expression_.
    - `FormBuilderValidators.compare(otherControlName, operator)`: Validasi lintas _field_ (misalnya, password dan konfirmasi password).
    - `FormBuilderValidators.compose([])`: Menggabungkan beberapa validator.
  - **Contoh Kode:**

  <!-- end list -->

  ```dart
  // Contoh email dengan beberapa validator
  FormBuilderTextField(
    name: 'email',
    decoration: const InputDecoration(labelText: 'Email'),
    validator: FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Email harus diisi'),
      FormBuilderValidators.email(errorText: 'Format email tidak valid'),
    ]),
  ),
  const SizedBox(height: 16),

  // Contoh password dan konfirmasi password dengan compare validator
  FormBuilderTextField(
    name: 'password',
    decoration: const InputDecoration(labelText: 'Password'),
    obscureText: true,
    validator: FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Password harus diisi'),
      FormBuilderValidators.minLength(6, errorText: 'Password minimal 6 karakter'),
    ]),
  ),
  const SizedBox(height: 16),

  FormBuilderTextField(
    name: 'confirmPassword',
    decoration: const InputDecoration(labelText: 'Konfirmasi Password'),
    obscureText: true,
    validator: (val) {
      // Akses nilai field lain melalui formKey
      if (val != _formKey.currentState?.fields['password']?.value) {
        return 'Password tidak cocok';
      }
      return FormBuilderValidators.required(errorText: 'Konfirmasi password harus diisi')(val);
    },
    // Alternatif menggunakan FormBuilderValidators.compare (membutuhkan FormBuilder versi lebih baru dan konfigurasi yang tepat)
    // validator: FormBuilderValidators.compare(
    //   _formKey.currentState!.fields['password']!.value,
    //   // Atau gunakan fieldName jika FormBuilderValidators.compare menerima itu
    //   // FormBuilderValidators.compare('password', operator: FormBuilderComparator.eq),
    //   errorText: 'Password tidak cocok',
    // ),
  ),
  ```

  - **Catatan tentang `compare` validator:** Implementasi `FormBuilderValidators.compare` dapat bervariasi antar versi. Untuk validasi _cross-field_ yang sederhana, mengakses `_formKey.currentState?.fields['otherFieldName']?.value` di validator _field_ kedua seringkali merupakan cara yang paling langsung.

- **4. Dynamic Form Generation (Pembuatan Formulir Dinamis)**

  - **Peran:** `Flutter Form Builder` sangat memfasilitasi pembuatan formulir yang strukturnya dapat berubah secara _runtime_ (misalnya, menambahkan atau menghapus _field_ berdasarkan pilihan pengguna).
  - **Detail:** Anda dapat menggunakan struktur data (misalnya, `List<Map<String, dynamic>>`) untuk mendefinisikan _field_ formulir dan kemudian menggunakan `ListView.builder` atau `Column` yang dibuat secara dinamis untuk merender _widget_ `FormBuilder` yang sesuai.
  - **Contoh Konseptual:**

  <!-- end list -->

  ```dart
  // Contoh sederhana: Menambah/menghapus FormBuilderTextField
  List<String> _dynamicFields = ['field1'];

  // ... dalam build method:
  Column(
    children: [
      ..._dynamicFields.map((fieldName) => FormBuilderTextField(
            name: fieldName,
            decoration: InputDecoration(labelText: 'Field $fieldName'),
            validator: FormBuilderValidators.required(),
          )).toList(),
      ElevatedButton(
        onPressed: () {
          setState(() {
            _dynamicFields.add('field${_dynamicFields.length + 1}');
          });
        },
        child: const Text('Tambah Field Baru'),
      ),
      // ... tombol submit
    ],
  );
  ```

  - Ini adalah salah satu kekuatan terbesar `Form Builder`, memungkinkan Anda membuat UI formulir yang fleksibel untuk skenario seperti formulir survei, konfigurasi produk yang kompleks, atau daftar item yang dapat diedit.

- **5. Form Builder State Management**

  - **Peran:** `FormBuilder` mengelola _state_ internal semua `FormBuilderField` anakannya, dan Anda dapat berinteraksi dengan _state_ ini melalui `_formKey.currentState`.

  - **Detail:**

    - `_formKey.currentState?.value`: Mengembalikan `Map<String, dynamic>` dari semua nilai _field_ yang divalidasi dan disimpan. Kunci dari peta ini adalah properti `name` dari setiap `FormBuilderField`.
    - `_formKey.currentState?.fields`: Mengembalikan `Map<String, FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>>` yang berisi _state_ individual dari setiap _field_. Ini berguna untuk mengakses _field_ tertentu secara programatis (misalnya, untuk mengubah nilai atau memicu validasi).
    - `_formKey.currentState?.patchValue(Map<String, dynamic> value)`: Memungkinkan Anda untuk memperbarui nilai satu atau lebih _field_ formulir secara programatis.
    - `_formKey.currentState?.reset()`: Mengatur ulang semua _field_ ke nilai awal atau ke kosong.
    - `_formKey.currentState?.validate()`: Memicu validasi tanpa menyimpan nilai.
    - `_formKey.currentState?.save()`: Memicu `onSaved` pada setiap _field_ tanpa validasi.
    - `_formKey.currentState?.saveAndValidate()`: Menggabungkan `validate()` dan `save()`, mengembalikan `true` jika valid dan disimpan.

  - **Contoh Kode untuk Manipulasi State:**

  <!-- end list -->

  ```dart
  // Setelah form di-build, Anda bisa mengakses field:
  // _formKey.currentState?.fields['namaPengguna']?.value = 'Nama Baru';
  // _formKey.currentState?.fields['email']?.validate(); // Validasi field spesifik

  // Mengisi formulir dengan data awal (misalnya dari API)
  @override
  void initState() {
    super.initState();
    // Contoh: Simulasi pengambilan data pengguna
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_formKey.currentState != null) {
        _formKey.currentState!.patchValue({
          'namaLengkap': 'Budi Santoso',
          'email': 'budi.santoso@example.com',
          'jenisKelamin': 'Pria',
          'tanggalLahir': DateTime(1990, 5, 15),
          'persetujuan': true,
        });
        // _formKey.currentState!.validate(); // Opsional: validasi setelah mengisi
      }
    });
  }

  // ... (di dalam build method atau callback)
  ElevatedButton(
    onPressed: () {
      _formKey.currentState?.reset(); // Mengatur ulang semua field
    },
    child: const Text('Reset Form'),
  ),
  ```

- **Visualisasi Alur `Flutter Form Builder`:**

  ```
  ┌───────────────────────────┐     ┌───────────────────────────────┐
  │     Your Widget Tree      │     │   GlobalKey<FormBuilderState> │
  │ ┌───────────────────────┐ │     │           (_formKey)          │
  │ │     FormBuilder       │◄──────┼───────────────────────────────┤
  │ │   (key: _formKey)     │ │     │                               │
  │ └───────────┬───────────┘ │     └───────────────────────────────┘
  │             │             │
  │  (Contains) ▼             │
  │ ┌───────────────────────┐ │
  │ │ FormBuilderTextField  │ │
  │ │ (name: 'username')    │ │
  │ └───────────────────────┘ │
  │ ┌───────────────────────┐ │
  │ │ FormBuilderDropdown   │ │
  │ │ (name: 'gender')      │ │
  │ └───────────────────────┘ │
  │ ┌───────────────────────┐ │
  │ │      ... others       │ │
  │ └───────────────────────┘ │
  └───────────┬───────────────┘
              │ User Interaction
              ▼
  ┌──────────────────────────────────────────────┐
  │   Submit Button onPressed                    │
  │  (_formKey.currentState?.saveAndValidate() ) │
  └───────────┬──────────────────────────────────┘
              │
              ▼
  ┌──────────────────────────────────────┐
  │  FormBuilderState                    │
  │ (Internal State Management)          │
  │ ┌──────────────────────────────────┐ │
  │ │ 1. Trigger Validators            │ │
  │ │    (via form_builder_validators) │ │
  │ └──────────────────────────────────┘ │
  │ ┌──────────────────────────────────┐ │
  │ │ 2. Collect Field Values          │ │
  │ │    (into Map<String, dynamic>)   │ │
  │ └──────────────────────────────────┘ │
  └───────────┬──────────────────────────┘
              │
              ▼
  ┌───────────────────────────┐
  │  Map<String, dynamic>     │
  │  {'username': 'value',    │
  │   'gender': 'value', ...} │
  │ (Ready for processing)    │
  └───────────────────────────┘
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan bagaimana `FormBuilder` bertindak sebagai _container_ utama yang mengelola semua `FormBuilderField` anakannya. `GlobalKey<FormBuilderState>` digunakan untuk mengakses _state_ formulir dan memicu operasi seperti validasi dan pengambilan nilai. Setelah validasi berhasil, `FormBuilderState` mengumpulkan semua nilai input ke dalam sebuah peta yang siap untuk diproses lebih lanjut.

- **Terminologi Esensial:**

  - **`flutter_form_builder`:** _Package_ Flutter untuk membangun dan mengelola formulir secara deklaratif dengan _widget_ pra-bangun.
  - **`FormBuilder`:** _Widget_ utama yang berfungsi sebagai _container_ formulir.
  - **`GlobalKey<FormBuilderState>`:** Kunci untuk mengakses _state_ formulir yang dikelola oleh `FormBuilder`.
  - **`FormBuilderField`:** _Base class_ untuk semua _field input_ di `FormBuilder`.
  - **`name`:** Properti unik yang mengidentifikasi setiap _field_ dalam formulir, digunakan sebagai kunci untuk mengambil nilai.
  - **`form_builder_validators`:** _Package_ pendamping yang menyediakan koleksi validator siap pakai.
  - **`FormBuilderValidators.compose()`:** Fungsi untuk menggabungkan beberapa validator.
  - **`_formKey.currentState?.value`:** Properti yang mengembalikan semua nilai formulir sebagai `Map`.
  - **`_formKey.currentState?.saveAndValidate()`:** Metode untuk memicu validasi dan menyimpan nilai secara bersamaan.
  - **`_formKey.currentState?.patchValue()`:** Metode untuk mengisi nilai formulir secara programatis.

- **Hubungan dengan Bagian Lain:**

  - **7.1 Form Widgets & Validation:** `Flutter Form Builder` dibangun di atas konsep `Form` dan `FormField`, tetapi menyederhanakan dan memperluas fungsionalitasnya. Konsep validasi tetap sama, tetapi dengan _tooling_ yang lebih mudah.
  - **7.3 Input Formatters & Masks:** Anda masih dapat menggunakan `TextInputFormatter` dengan `FormBuilderTextField` untuk format input yang lebih spesifik.

- **Tips & Best Practices (untuk peserta):**

  - **Selalu Gunakan `name` yang Unik:** Pastikan setiap `FormBuilderField` memiliki properti `name` yang unik untuk menghindari konflik dan memastikan pengambilan nilai yang benar.
  - **Manfaatkan Validator Bawaan:** Gunakan validator dari `form_builder_validators` sebanyak mungkin untuk menghemat waktu dan menjaga konsistensi.
  - **Pahami `saveAndValidate()`:** Ini adalah metode utama yang akan Anda gunakan saat tombol submit ditekan.
  - **Pertimbangkan `autovalidateMode`:** Gunakan `AutovalidateMode.onUserInteraction` untuk umpan balik validasi _real-time_ yang lebih baik kepada pengguna.

- **Potensi Kesalahan Umum & Solusi:**

  - **Kesalahan:** `_formKey.currentState` adalah `null`.
    - **Solusi:** Pastikan `GlobalKey<FormBuilderState>` dipasangkan ke _widget_ `FormBuilder` dan Anda tidak mencoba mengaksesnya sebelum `build` _method_ dijalankan (misalnya, di `initState` tanpa pengecekan `null`). Gunakan `WidgetsBinding.instance.addPostFrameCallback` jika perlu untuk akses setelah _frame_ pertama.
  - **Kesalahan:** Nilai _field_ tidak muncul di `_formKey.currentState?.value` atau kunci salah.
    - **Solusi:** Periksa properti `name` dari `FormBuilderField`. Pastikan itu adalah _String_ yang unik dan konsisten.
  - **Kesalahan:** Validator tidak berfungsi atau tidak menampilkan pesan kesalahan.
    - **Solusi:** Pastikan Anda telah mengimpor `form_builder_validators.dart` dan menggunakan validator dengan benar. Periksa juga `autovalidateMode` pada `FormBuilder` atau _field_ individual.

---

Kita telah menyelesaikan pembahasan mendetail tentang **Flutter Form Builder**. Ini adalah alat yang sangat kuat untuk membangun formulir yang efisien di Flutter. Selanjutnya, **Reactive Forms**.

- **Peran:** Berbeda dengan pendekatan deklaratif `FormBuilder` yang menyediakan _widget_ siap pakai, `Reactive Forms` menawarkan pendekatan yang lebih _imperatif_ dan _berbasis model_ untuk manajemen formulir. Ini sangat cocok untuk skenario di mana _state_ formulir sangat kompleks, dinamis, atau membutuhkan interaksi yang reaktif dengan bagian lain dari aplikasi.

---

###### **Reactive Forms**

- **Gambaran Umum:** `Reactive Forms` adalah _package_ yang terinspirasi dari `Reactive Forms` di Angular. Ia memperlakukan formulir sebagai model data yang bereaksi terhadap perubahan. Setiap _input field_ direpresentasikan oleh sebuah `FormControl`, dan sekelompok _field_ dapat dikelompokkan ke dalam `FormGroup`. Pendekatan ini memungkinkan validasi yang lebih canggih, manipulasi _state_ formulir yang programatis, dan integrasi yang mudah dengan _stream_ data.

- **1. Reactive Form Model**

  - **Peran:** Dalam `Reactive Forms`, struktur formulir Anda didefinisikan sebagai model data Dart, bukan secara langsung di _widget tree_. Ini memisahkan logika formulir dari UI.
  - **Detail:** Model formulir ini terdiri dari `FormGroup` dan `FormControl`. `FormGroup` adalah objek yang menampung koleksi `FormControl` dan/atau `FormGroup` lainnya. `FormControl` merepresentasikan _state_ dari satu _input field_.
  - **Pendekatan Deklaratif vs Reaktif:**
    - **Deklaratif (Form/FormBuilder):** Anda membangun UI dan memasang validator serta `onSaved` langsung ke _widget_.
    - **Reaktif (Reactive Forms):** Anda mendefinisikan struktur formulir (model) secara terpisah. UI kemudian "mengikat" dirinya ke model ini. Perubahan pada UI memperbarui model, dan perubahan pada model memperbarui UI.

  <!-- end list -->

  ```dart
  // Import package
  import 'package:flutter/material.dart';
  import 'package:reactive_forms/reactive_forms.dart';

  // Definisikan FormGroup di StatefulWidget Anda
  class MyReactiveFormPage extends StatefulWidget {
    const MyReactiveFormPage({super.key});

    @override
    State<MyReactiveFormPage> createState() => _MyReactiveFormPageState();
  }

  class _MyReactiveFormPageState extends State<MyReactiveFormPage> {
    // Deklarasikan FormGroup untuk formulir Anda
    late final FormGroup form;

    @override
    void initState() {
      super.initState();
      // Inisialisasi FormGroup dengan FormControl-nya
      form = FormGroup({
        'username': FormControl<String>(
          value: '', // Nilai awal
          validators: [Validators.required, Validators.minLength(3)],
        ),
        'email': FormControl<String>(
          value: '',
          validators: [Validators.required, Validators.email],
        ),
        'password': FormControl<String>(
          value: '',
          validators: [Validators.required, Validators.minLength(6)],
        ),
        'confirmPassword': FormControl<String>(
          value: '',
          validators: [Validators.required],
        ),
      }, validators: [
        // Contoh validator lintas field di FormGroup level
        Validators.mustMatch('password', 'confirmPassword', true),
      ]);
    }

    @override
    void dispose() {
      form.dispose(); // Penting: Buang FormGroup saat widget dibuang
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reactive Forms Demo')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ReactiveForm(
            formGroup: form, // Ikat UI ke model form
            child: Column(
              children: <Widget>[
                // Menggunakan ReactiveTextField untuk mengikat ke FormControl 'username'
                ReactiveTextField<String>(
                  formControlName: 'username',
                  decoration: const InputDecoration(labelText: 'Nama Pengguna'),
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Nama pengguna harus diisi',
                    ValidationMessage.minLength: (error) => 'Minimal 3 karakter',
                  },
                ),
                const SizedBox(height: 16),
                ReactiveTextField<String>(
                  formControlName: 'email',
                  decoration: const InputDecoration(labelText: 'Email'),
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Email harus diisi',
                    ValidationMessage.email: (error) => 'Format email tidak valid',
                  },
                ),
                const SizedBox(height: 16),
                ReactiveTextField<String>(
                  formControlName: 'password',
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Password harus diisi',
                    ValidationMessage.minLength: (error) => 'Minimal 6 karakter',
                  },
                ),
                const SizedBox(height: 16),
                ReactiveTextField<String>(
                  formControlName: 'confirmPassword',
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Konfirmasi Password'),
                  validationMessages: {
                    ValidationMessage.required: (error) => 'Konfirmasi password harus diisi',
                    ValidationMessage.mustMatch: (error) => 'Password tidak cocok',
                  },
                ),
                const SizedBox(height: 24),
                ReactiveFormConsumer( // Rebuild hanya sebagian kecil saat form berubah
                  builder: (context, form, child) {
                    return ElevatedButton(
                      onPressed: form.valid ? () => _submitForm(form) : null, // Tombol aktif jika form valid
                      child: const Text('Submit'),
                    );
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    form.reset(); // Reset form
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    void _submitForm(FormGroup form) {
      if (form.valid) {
        print('Form valid!');
        print(form.value); // Ambil semua nilai form
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submitted! Values: ${form.value}')),
        );
        // form.reset(); // Reset setelah submit
      } else {
        print('Form not valid!');
        form.markAllAsTouched(); // Tandai semua field sebagai touched untuk menampilkan error
      }
    }
  }
  ```

- **2. Form Control dan Form Group**

  - **`FormControl<T>`:**

    - **Peran:** Merepresentasikan satu _input field_. Ini menyimpan nilai _field_, _status validasi_ (valid/invalid, touched/untouched, dirty/pristine), dan _error messages_ untuk _field_ tersebut.
    - **Detail:** Anda dapat mengakses nilai (`.value`), mengubah nilai (`.updateValue()`, `.patchValue()`), menambahkan/menghapus validator (`.setValidators()`, `.addValidators()`), dan memicu validasi (`.markAsTouched()`, `.markAllAsTouched()`).
    - **Contoh Inisialisasi:** `FormControl<String>(value: 'initial', validators: [Validators.required])`

  - **`FormGroup`:**

    - **Peran:** Mengelompokkan koleksi `FormControl` dan/atau `FormGroup` lainnya. `FormGroup` juga memiliki nilai dan _status validasi_ sendiri, yang merupakan agregasi dari semua kontrol di dalamnya.
    - **Detail:** Anda mengakses `FormControl` atau `FormGroup` anaknya menggunakan kurung siku (misalnya `form.control('username')`) atau `dot notation` jika menggunakan _code generation_. `FormGroup` memungkinkan validasi lintas _field_ pada level grup.
    - **Contoh Inisialisasi:**
      ```dart
      FormGroup({
        'personalInfo': FormGroup({
          'firstName': FormControl<String>(validators: [Validators.required]),
          'lastName': FormControl<String>(),
        }),
        'contactInfo': FormGroup({
          'email': FormControl<String>(validators: [Validators.email]),
          'phone': FormControl<String>(),
        }),
      });
      ```

  - **`FormArray<T>`:**

    - **Peran:** Sebuah tipe `FormGroup` khusus yang mengelola _array_ dari `FormControl` atau `FormGroup`. Ini sangat berguna untuk skenario di mana Anda memiliki daftar _input_ yang dapat ditambahkan atau dihapus secara dinamis, seperti daftar _item_ dalam pesanan.
    - **Detail:** Mendukung penambahan (`.add()`), penghapusan (`.removeAt()`), dan akses ke elemen (`.at(index)`).

- **Visualisasi Reactive Form Model:**

  ```
  ┌───────────────────────────────────┐
  │          FormGroup (Root)         │
  │ (e.g., UserRegistrationForm)      │
  └────────────┬────────────────────┬─┘      
               │                    │       
     ┌─────────▼─────────┐    ┌─────▼─────────────┐
     │   FormControl     │    │   FormGroup       │
     │ (e.g., 'username')│    │ (e.g., 'address') │
     └───────────────────┘    └─────────┬─────────┘
                                        │
                              ┌─────────▼─────────┐
                              │   FormControl     │
                              │ (e.g., 'street')  │
                              └───────────────────┘
                              ┌───────────────────┐
                              │   FormControl     │
                              │ (e.g., 'city')    │
                              └───────────────────┘

  ┌───────────────────────────────────┐
  │          FormGroup (Root)         │
  │ (e.g., OrderForm)                 │
  └────────────┬────────────────────┬─┘
               │                    │
     ┌─────────▼─────────┐    ┌─────▼─────────────┐
     │   FormControl     │    │   FormArray       │
     │ (e.g., 'orderId') │    │ (e.g., 'items')   │
     └───────────────────┘    └─────────┬─────────┘
                                        │
                              ┌─────────▼─────────┐
                              │   FormGroup       │  (Item 1)
                              │(e.g., ProductForm)│
                              └───────────────────┘
                              ┌───────────────────┐
                              │   FormGroup       │  (Item 2)
                              │(e.g., ProductForm)│
                              └───────────────────┘
                              (... dynamic items)
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan hierarki `FormGroup`, `FormControl`, dan `FormArray`. `FormGroup` dapat berisi `FormControl` dan `FormGroup` lainnya, menciptakan struktur data yang kompleks. `FormArray` memungkinkan manajemen daftar elemen formulir yang dinamis.

- **3. Reactive Validators**

  - **Peran:** `Reactive Forms` menyediakan set validator yang kaya dan dapat digunakan secara sinkron maupun asinkron. Validator ini diterapkan langsung pada `FormControl` atau `FormGroup` di model formulir Anda.

  - **Detail:** Validator adalah fungsi yang mengembalikan `Map<String, dynamic>?` jika tidak valid (di mana kunci adalah nama kesalahan validasi, misalnya `required`, `email`) atau `null` jika valid.

  - **Contoh Validator Bawaan (`Validators` class):**

    - `Validators.required`: Memastikan nilai tidak kosong.
    - `Validators.email`: Memvalidasi format email.
    - `Validators.minLength(min)`: Panjang string minimal.
    - `Validators.maxLength(max)`: Panjang string maksimal.
    - `Validators.pattern(regex)`: Memvalidasi dengan _regular expression_.
    - `Validators.min(value)`: Nilai numerik minimal.
    - `Validators.max(value)`: Nilai numerik maksimal.
    - `Validators.mustMatch(controlName1, controlName2, [hide=false])`: Validasi lintas _field_ untuk kecocokan (misalnya, password konfirmasi). Ini adalah validator `FormGroup`.
    - `Validators.compose(validators)`: Menggabungkan beberapa validator.

  - **Custom Validator Functions:** Anda dapat membuat validator kustom sendiri:

    ```dart
    // Contoh validator kustom: memastikan nilai adalah bilangan genap
    Map<String, dynamic>? evenNumberValidator(AbstractControl<dynamic> control) {
      if (control.value == null) {
        return null; // Tidak validasi jika kosong (gunakan Validators.required jika perlu)
      }
      final int? value = int.tryParse(control.value.toString());
      if (value == null || value % 2 != 0) {
        return {'evenNumber': true}; // Mengembalikan Map error
      }
      return null; // Valid
    }

    // Penggunaan:
    // 'myNumber': FormControl<String>(
    //   value: '10',
    //   validators: [Validators.required, evenNumberValidator],
    // ),
    ```

  - **Async Validation:**

    - **Peran:** Menangani validasi yang memerlukan operasi asinkron (misalnya, memanggil API untuk memeriksa ketersediaan nama pengguna).
    - **Detail:** Validator asinkron adalah fungsi yang mengembalikan `Future<Map<String, dynamic>?>`. Ini ditambahkan ke `asyncValidators` pada `FormControl`.
    - **Perilaku:** Formulir akan berada dalam _state_ `pending` selama validasi asinkron berlangsung.

    <!-- end list -->

    ```dart
    // Contoh validator asinkron: memeriksa ketersediaan username di server
    Future<Map<String, dynamic>?> uniqueUsernameValidator(AbstractControl<dynamic> control) async {
      if (control.value == null || control.value.toString().isEmpty) {
        return null; // Biarkan validator 'required' menangani ini
      }
      await Future.delayed(const Duration(seconds: 1)); // Simulasi API call
      if (control.value == 'admin') {
        return {'uniqueUsername': true}; // Nama pengguna 'admin' tidak tersedia
      }
      return null;
    }

    // Penggunaan:
    // 'username': FormControl<String>(
    //   value: '',
    //   validators: [Validators.required],
    //   asyncValidators: [uniqueUsernameValidator],
    // ),
    ```

    - Saat `username` berubah, validator asinkron akan dijalankan. Selama 1 detik simulasi, _control_ `username` akan memiliki _status_ `pending`.

- **4. Dynamic Forms dengan Arrays**

  - **Peran:** `Reactive Forms` sangat unggul dalam menangani formulir dinamis, terutama dengan `FormArray`. Anda dapat dengan mudah menambahkan atau menghapus grup _field_ secara _runtime_.
  - **Detail:** Gunakan `FormArray` untuk mengelola daftar `FormControl` atau `FormGroup`. Di UI, Anda dapat menggunakan `ReactiveFormArray` atau membangun secara manual dengan `ListView.builder` dan `ReactiveTextField`.
  - **Contoh:** Mengelola daftar email atau daftar _skill_.

  <!-- end list -->

  ```dart
  // Dalam _MyReactiveFormPageState initState:
  form = FormGroup({
    'emails': FormArray<String>([ // FormArray of Strings (simple emails)
      FormControl<String>(value: 'email1@example.com', validators: [Validators.email]),
      FormControl<String>(value: 'email2@example.com', validators: [Validators.email]),
    ], validators: [Validators.minLength(1)]), // Minimal 1 email

    // Contoh FormArray of FormGroups (misalnya, daftar pengalaman kerja)
    'experiences': FormArray<FormGroup>([
      _buildExperienceFormGroup(), // Metode helper untuk membuat FormGroup pengalaman
    ]),
  });

  // Metode helper untuk membuat FormGroup pengalaman
  FormGroup _buildExperienceFormGroup() {
    return FormGroup({
      'company': FormControl<String>(validators: [Validators.required]),
      'role': FormControl<String>(validators: [Validators.required]),
      'years': FormControl<int>(validators: [Validators.min(1)]),
    });
  }

  // Di dalam build method, untuk menampilkan FormArray:
  Column(
    children: [
      // Daftar Email
      ReactiveFormArray<String>(
        formArrayName: 'emails',
        builder: (context, formArray, child) {
          return Column(
            children: [
              ...formArray.controls.asMap().entries.map((entry) {
                int index = entry.key;
                AbstractControl<dynamic> control = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: ReactiveTextField<String>(
                        formControlName: 'emails[${index}]', // Akses elemen FormArray
                        decoration: InputDecoration(
                          labelText: 'Email ${index + 1}',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              formArray.removeAt(index);
                            },
                          ),
                        ),
                        validationMessages: {
                          ValidationMessage.email: (error) => 'Format email tidak valid',
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
              ElevatedButton(
                onPressed: () {
                  formArray.add(FormControl<String>(validators: [Validators.email]));
                },
                child: const Text('Tambah Email'),
              ),
            ],
          );
        },
      ),
      const SizedBox(height: 16),

      // Daftar Pengalaman (lebih kompleks)
      ReactiveFormArray<FormGroup>(
        formArrayName: 'experiences',
        builder: (context, formArray, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pengalaman Kerja', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...formArray.controls.asMap().entries.map((entry) {
                int index = entry.key;
                FormGroup experienceFormGroup = entry.value as FormGroup;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ReactiveTextField<String>(
                            formControl: experienceFormGroup.control('company') as FormControl<String>,
                            decoration: InputDecoration(
                              labelText: 'Perusahaan ${index + 1}',
                            ),
                            validationMessages: {
                              ValidationMessage.required: (error) => 'Nama perusahaan harus diisi',
                            },
                          ),
                          ReactiveTextField<String>(
                            formControl: experienceFormGroup.control('role') as FormControl<String>,
                            decoration: const InputDecoration(labelText: 'Jabatan'),
                            validationMessages: {
                              ValidationMessage.required: (error) => 'Jabatan harus diisi',
                            },
                          ),
                          ReactiveTextField<int>(
                            formControl: experienceFormGroup.control('years') as FormControl<int>,
                            decoration: const InputDecoration(labelText: 'Tahun Pengalaman'),
                            keyboardType: TextInputType.number,
                            validationMessages: {
                              ValidationMessage.min: (error) => 'Minimal 1 tahun',
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                formArray.removeAt(index);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              ElevatedButton(
                onPressed: () {
                  formArray.add(_buildExperienceFormGroup());
                },
                child: const Text('Tambah Pengalaman'),
              ),
            ],
          );
        },
      ),
    ],
  );
  ```

- **5. Form State Streaming**

  - **Peran:** Salah satu kekuatan utama `Reactive Forms` adalah kemampuannya untuk mengekspos perubahan _state_ formulir sebagai _stream_. Ini memungkinkan Anda untuk mendengarkan perubahan pada _field_ individual atau seluruh formulir dan bereaksi secara reaktif, tanpa perlu menggunakan `setState` berlebihan.
  - **Detail:** Setiap `FormControl`, `FormGroup`, dan `FormArray` memiliki properti `valueChanges` dan `statusChanges` yang merupakan _stream_.
    - `valueChanges`: Mengeluarkan nilai terbaru setiap kali ada perubahan pada kontrol atau formulir.
    - `statusChanges`: Mengeluarkan _status validasi_ terbaru (`VALID`, `INVALID`, `PENDING`, `DISABLED`).
  - **Penggunaan:** Anda dapat menggunakan `StreamBuilder` atau mendengarkan _stream_ secara langsung di `initState` (dengan langganan yang dibuang di `dispose`). Ini sangat berguna untuk:
    - Mengaktifkan/menonaktifkan tombol submit secara dinamis.
    - Menampilkan pesan _loading_ saat validasi asinkron.
    - Memicu logika bisnis lain saat nilai tertentu berubah.
  - **Contoh:** Tombol submit yang hanya aktif ketika formulir valid (seperti di contoh kode lengkap di atas dengan `ReactiveFormConsumer`).
    ```dart
    // Menggunakan StreamBuilder untuk menampilkan status validitas formulir secara real-time
    StreamBuilder<ControlStatus>(
      stream: form.statusChanged,
      builder: (context, snapshot) {
        final isValid = snapshot.data == ControlStatus.valid;
        return Text(
          'Status Formulir: ${isValid ? "Valid" : "Invalid"}',
          style: TextStyle(color: isValid ? Colors.green : Colors.red),
        );
      },
    ),
    // Atau mendengarkan perubahan nilai specific control:
    // StreamBuilder<String?>(
    //   stream: form.control('username').valueChanges,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       return Text('Username berubah menjadi: ${snapshot.data}');
    //     }
    //     return const Text('Belum ada perubahan username');
    //   },
    // ),
    ```
  - `ReactiveFormConsumer` adalah _widget_ praktis dari _package_ ini yang menyediakan `formGroup` sebagai parameter _builder_, dan hanya merekonstruksi ketika _status_ atau nilai formulir berubah, memberikan optimisasi performa.

- **6. Code Generation untuk Forms (Reactive Forms Generator)**

  - **Peran:** Untuk mengurangi _boilerplate_ yang terkait dengan pendefinisian `FormGroup` dan `FormControl` secara manual, `reactive_forms` menyediakan _package_ `reactive_forms_generator`. Ini memungkinkan Anda mendefinisikan model formulir Anda sebagai kelas Dart biasa dengan anotasi, dan kemudian menghasilkan kode formulir secara otomatis.
  - **Detail:** Anda perlu menambahkan `reactive_forms_generator`, `build_runner`, dan `freezed_annotation` (opsional, untuk _utility_ model) ke `pubspec.yaml` Anda.
  - **`pubspec.yaml`:**

    ```yaml
    dependencies:
      reactive_forms: ^latest_version
      json_annotation: ^latest_version # Untuk serialisasi jika perlu

    dev_dependencies:
      build_runner: ^latest_version
      reactive_forms_generator: ^latest_version
      json_serializable: ^latest_version # Untuk serialisasi jika perlu
    ```

  - **Proses:**
    1.  Definisikan kelas model data dengan anotasi `@FormGroup()`, `@FormControl()`, `@FormArray()`.
    2.  Jalankan `flutter pub run build_runner build --delete-conflicting-outputs`.
    3.  Kode yang dihasilkan (misalnya `*.g.dart` dan `*.form.dart`) akan menyediakan `FormGroup` siap pakai dan _extension_ untuk memudahkan akses _type-safe_.
  - **Contoh (Konseptual dengan generator):**

  <!-- end list -->

  ```dart
  // user_data.dart
  import 'package:reactive_forms/reactive_forms.dart';
  import 'package:reactive_forms_generator/reactive_forms_generator.dart';

  part 'user_data.form.dart'; // File yang akan di-generate

  @ReactiveFormAnnotation()
  class UserData {
    @FormControlAnnotation(validators: [Validators.required, Validators.minLength(3)])
    final String? username;

    @FormControlAnnotation(validators: [Validators.required, Validators.email])
    final String? email;

    @FormControlAnnotation(validators: [Validators.required, Validators.minLength(6)])
    final String? password;

    @FormControlAnnotation<String>() // @FormControlAnnotation tanpa validator untuk konfirmasi
    final String? confirmPassword;

    // Contoh nested form group
    @FormGroupAnnotation()
    final Address? address;

    // Contoh form array
    @FormArrayAnnotation<String>(validators: [Validators.minLength(1)])
    final List<String> hobbies;

    UserData({
      this.username,
      this.email,
      this.password,
      this.confirmPassword,
      this.address,
      List<String>? hobbies,
    }) : hobbies = hobbies ?? [];
  }

  @ReactiveFormAnnotation()
  class Address {
    @FormControlAnnotation(validators: [Validators.required])
    final String? street;
    @FormControlAnnotation(validators: [Validators.required])
    final String? city;

    Address({this.street, this.city});
  }

  // Setelah build_runner dijalankan, Anda akan memiliki:
  // user_data.form.dart yang berisi UserDataForm, ReactiveUserDataForm, dll.
  // Kemudian di UI:
  // ReactiveUserDataForm(
  //   form: UserDataForm(
  //     username: '',
  //     email: '',
  //     password: '',
  //     confirmPassword: '',
  //     address: Address(street: '', city: ''),
  //     hobbies: ['coding'],
  //   ).form, // Mengambil FormGroup yang dihasilkan
  //   builder: (context, form, child) {
  //     return Column(
  //       children: [
  //         ReactiveTextField(
  //           formControl: form.usernameControl, // Akses type-safe control
  //           decoration: const InputDecoration(labelText: 'Username'),
  //         ),
  //         // ... dan field lainnya
  //         ReactiveTextField(
  //           formControl: form.address.streetControl, // Akses nested control
  //         ),
  //         ReactiveFormArray(
  //           formArray: form.hobbiesControl,
  //           // ...
  //         )
  //       ],
  //     );
  //   },
  // );
  ```

  - **Manfaat:** Mengurangi _boilerplate_, _type-safety_ yang lebih baik, kemudahan dalam manajemen formulir yang sangat kompleks.

- **Terminologi Esensial:**

  - **Reactive Forms:** Pendekatan berbasis model untuk manajemen formulir.
  - **`FormGroup`:** Objek yang mengelompokkan `FormControl` atau `FormGroup` lainnya.
  - **`FormControl`:** Merepresentasikan satu _input field_ dalam model formulir.
  - **`FormArray`:** `FormGroup` khusus untuk mengelola daftar `FormControl` atau `FormGroup` secara dinamis.
  - **`ReactiveForm`:** _Widget_ utama yang mengikat UI ke `FormGroup` model.
  - **`ReactiveTextField` (dll.):** _Widget_ input yang disediakan oleh `reactive_forms` untuk mengikat ke `FormControl` berdasarkan `formControlName` atau `formControl` langsung.
  - **`Validators`:** Kelas yang menyediakan validator bawaan untuk `Reactive Forms`.
  - **`asyncValidators`:** Properti pada `FormControl` untuk validator asinkron.
  - **`valueChanges` / `statusChanges`:** Properti _stream_ pada kontrol formulir untuk mendengarkan perubahan _state_.
  - **`reactive_forms_generator`:** _Package_ untuk menghasilkan kode formulir secara otomatis dari model Dart.

- **Hubungan dengan Bagian Lain:**

  - **State Management:** `Reactive Forms` sendiri adalah bentuk manajemen _state_ untuk formulir. Integrasinya dengan _stream_ membuatnya cocok untuk arsitektur berbasis _stream_ atau _reactive programming_.
  - **Validasi:** Menyediakan kerangka kerja yang kuat untuk validasi sinkron, asinkron, dan lintas _field_.
  - **`build_runner`:** Digunakan oleh `reactive_forms_generator` untuk proses _code generation_, sama seperti yang digunakan oleh `Auto Route`.

- **Tips & Best Practices (untuk peserta):**

  - **Pahami Model:** Fokus pada pendefinisian model formulir Anda (`FormGroup`, `FormControl`, `FormArray`) terlebih dahulu sebelum membangun UI.
  - **Gunakan Validator yang Tepat:** Manfaatkan validator bawaan `Validators` dan buat validator kustom jika diperlukan.
  - **Untuk Formulir Kompleks/Dinamis:** Pertimbangkan `Reactive Forms` sebagai pilihan utama, terutama jika Anda membutuhkan validasi asinkron atau manipulasi _state_ programatis yang ekstensif.
  - **Pertimbangkan Generator:** Untuk formulir yang sangat besar atau jika Anda mengutamakan _type-safety_, `reactive_forms_generator` sangat direkomendasikan.
  - **Dispose Form:** Selalu panggil `.dispose()` pada `FormGroup` Anda di `dispose()` _method_ dari `StatefulWidget` untuk mencegah _memory leak_.

- **Potensi Kesalahan Umum & Solusi:**

  - **Kesalahan:** `FormControl` atau `FormGroup` tidak ditemukan.
    - **Solusi:** Periksa `formControlName` di `ReactiveTextField` (atau _widget_ Reactive lainnya). Pastikan `formControlName` cocok dengan kunci yang digunakan saat mendefinisikan `FormGroup` atau `FormArray`.
  - **Kesalahan:** Error terkait _type safety_ saat mengakses nilai.
    - **Solusi:** Pastikan Anda mendefinisikan `FormControl` dengan tipe yang benar (misalnya `FormControl<String>`, `FormControl<int>`). Ketika mengambil nilai, pastikan Anda melakukan _casting_ yang tepat jika perlu, meskipun generator akan sangat membantu.
  - **Kesalahan:** Validasi asinkron tidak berfungsi atau formulir tetap `pending`.
    - **Solusi:** Pastikan Anda menempatkan validator asinkron di properti `asyncValidators` pada `FormControl` (bukan `validators`). Pastikan fungsi validator asinkron mengembalikan `Future<Map<String, dynamic>?>` dan menyelesaikan _future_ tersebut.

---

Salesai pembahasan mendalam tentang **Reactive Forms**, termasuk modelnya, kontrol, validator, formulir dinamis, _state streaming_, dan _code generation_.

### **7.3 Input Formatters & Masks**

- **Peran:** `Input Formatters` dan _masks_ adalah teknik yang digunakan untuk mengontrol dan memformat teks yang dimasukkan pengguna ke dalam _input field_ secara _real-time_. Ini memastikan bahwa data yang dimasukkan konsisten dengan format yang diharapkan, meningkatkan pengalaman pengguna, dan meminimalkan kesalahan validasi.

---

###### **Input Formatters & Masks**

- **1. Text Input Formatting**

  - **Peran:** Mengimplementasikan batasan atau transformasi pada teks saat pengguna mengetik, memastikan format data yang valid sejak awal.

  - **Detail:** Ini dicapai menggunakan kelas `TextInputFormatter` yang merupakan bagian dari `flutter/services.dart`. Anda dapat melampirkannya ke `TextField` atau `TextFormField` melalui properti `inputFormatters`.

  - **Built-in Input Formatters:**

    - Flutter menyediakan beberapa `TextInputFormatter` bawaan yang berguna untuk kasus umum:

      - **`FilteringTextInputFormatter.digitsOnly`:** Hanya mengizinkan masukan angka (0-9).
      - **`FilteringTextInputFormatter.allow(RegExp regex)`:** Hanya mengizinkan karakter yang cocok dengan _regular expression_ yang diberikan.
      - **`FilteringTextInputFormatter.deny(RegExp regex)`:** Melarang karakter yang cocok dengan _regular expression_ yang diberikan.
      - **`LengthLimitingTextInputFormatter(maxLength)`:** Membatasi panjang teks hingga jumlah karakter tertentu.
      - **`UpperCaseTextFormatter` (Contoh Kustom):** Mengubah semua teks menjadi huruf besar secara _real-time_. (Tidak ada bawaan langsung, perlu kustomisasi)

    - **Contoh Kode:**

    <!-- end list -->

    ```dart
    import 'package:flutter/material.dart';
    import 'package:flutter/services.dart'; // Penting untuk TextInputFormatter

    class InputFormatterDemo extends StatefulWidget {
      const InputFormatterDemo({super.key});

      @override
      State<InputFormatterDemo> createState() => _InputFormatterDemoState();
    }

    class _InputFormatterDemoState extends State<InputFormatterDemo> {
      final TextEditingController _phoneNumberController = TextEditingController();
      final TextEditingController _amountController = TextEditingController();
      final TextEditingController _dateController = TextEditingController();

      @override
      void dispose() {
        _phoneNumberController.dispose();
        _amountController.dispose();
        _dateController.dispose();
        super.dispose();
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Input Formatter & Mask Demo')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Hanya Angka
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nomor Telepon (Hanya Angka)'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Hanya izinkan angka
                    LengthLimitingTextInputFormatter(15), // Batasi panjang
                  ],
                ),
                const SizedBox(height: 16),

                // Hanya Huruf (a-z, A-Z)
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nama (Hanya Huruf)'),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), // Hanya izinkan huruf dan spasi
                  ],
                ),
                const SizedBox(height: 16),

                // Huruf Besar Otomatis (Membutuhkan Custom Formatter)
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Kode Produk (Uppercase Otomatis)'),
                  inputFormatters: [
                    UpperCaseTextFormatter(), // Custom formatter
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }
    }

    // Custom Formatter: Mengubah semua teks menjadi huruf besar
    class UpperCaseTextFormatter extends TextInputFormatter {
      @override
      TextEditingValue formatEditUpdate(
          TextEditingValue oldValue, TextEditingValue newValue) {
        return TextEditingValue(
          text: newValue.text.toUpperCase(),
          selection: newValue.selection,
        );
      }
    }
    ```

  - **Custom Input Formatter Creation:**

    - **Peran:** Membuat _formatter_ sendiri untuk logika pemformatan yang lebih kompleks yang tidak disediakan oleh _formatter_ bawaan.
    - **Detail:** Anda membuat kelas baru yang memperluas `TextInputFormatter` dan mengimplementasikan metode `formatEditUpdate`. Metode ini menerima `oldValue` dan `newValue` (objek `TextEditingValue`) dan harus mengembalikan `TextEditingValue` baru yang diformat.
    - **Konsep `TextEditingValue`:** Ini berisi teks dan informasi _selection_ (posisi kursor). Penting untuk mempertahankan posisi kursor yang benar setelah pemformatan.

  - **Phone Number Formatting:**

    - **Peran:** Memformat nomor telepon menjadi pola yang mudah dibaca (misalnya, `(XXX) XXX-XXXX` atau `XXX-XXXX-XXXX`).
    - **Detail:** Ini biasanya melibatkan `FilteringTextInputFormatter.digitsOnly` dan kemudian `CustomTextInputFormatter` yang menambahkan spasi, tanda kurung, atau tanda hubung pada posisi tertentu.
    - **Contoh Kustom (`PhoneNumberFormatter`):**

    <!-- end list -->

    ```dart
    // Contoh PhoneNumberFormatter untuk format +XX XXX-XXXX-XXXX
    class PhoneNumberFormatter extends TextInputFormatter {
      @override
      TextEditingValue formatEditUpdate(
          TextEditingValue oldValue, TextEditingValue newValue) {
        final text = newValue.text;
        if (text.isEmpty) {
          return newValue;
        }

        final newText = StringBuffer();
        int offset = 0;

        // Pastikan hanya angka
        final digitsOnly = text.replaceAll(RegExp(r'\D'), '');

        if (digitsOnly.isNotEmpty) {
          // Contoh format +XX XXX-XXXX-XXXX (untuk 13 digit)
          if (digitsOnly.length > 0) newText.write('+');
          if (digitsOnly.length > 0) newText.write(digitsOnly.substring(0, digitsOnly.length.clamp(0, 2))); // Prefix negara
          if (digitsOnly.length > 2) newText.write(' ');
          if (digitsOnly.length > 2) newText.write(digitsOnly.substring(2, digitsOnly.length.clamp(2, 5))); // 3 digit awal
          if (digitsOnly.length > 5) newText.write('-');
          if (digitsOnly.length > 5) newText.write(digitsOnly.substring(5, digitsOnly.length.clamp(5, 9))); // 4 digit berikutnya
          if (digitsOnly.length > 9) newText.write('-');
          if (digitsOnly.length > 9) newText.write(digitsOnly.substring(9, digitsOnly.length.clamp(9, 13))); // 4 digit terakhir
        }


        offset = newValue.selection.end + (newText.length - text.length);

        return TextEditingValue(
          text: newText.toString(),
          selection: TextSelection.collapsed(offset: offset.clamp(0, newText.length)),
        );
      }
    }
    // Penggunaan:
    // TextFormField(
    //   decoration: const InputDecoration(labelText: 'Nomor Telepon (+XX XXX-XXXX-XXXX)'),
    //   keyboardType: TextInputType.phone,
    //   inputFormatters: [
    //     PhoneNumberFormatter(),
    //     LengthLimitingTextInputFormatter(18), // Estimasi panjang setelah format
    //   ],
    // ),
    ```

    - **Catatan:** Pemformatan nomor telepon bisa sangat kompleks karena variasi format global. Untuk solusi yang lebih robust, pertimbangkan _package_ pihak ketiga seperti `mask_text_input_formatter`.

  - **Currency Formatting:**

    - **Peran:** Memformat masukan numerik menjadi format mata uang (misalnya, `Rp 1.000.000,00` atau `$1,000.00`).
    - **Detail:** Ini melibatkan kombinasi `FilteringTextInputFormatter.digitsOnly` (atau `allow` untuk titik/koma desimal) dan `CustomTextInputFormatter` yang menambahkan pemisah ribuan dan simbol mata uang. Anda juga bisa menggunakan `NumberFormat` dari _package_ `intl`.
    - **Contoh Kustom (`CurrencyInputFormatter`):**

    <!-- end list -->

    ```dart
    import 'package:intl/intl.dart'; // Tambahkan intl: ^latest_version di pubspec.yaml

    class CurrencyInputFormatter extends TextInputFormatter {
      @override
      TextEditingValue formatEditUpdate(
          TextEditingValue oldValue, TextEditingValue newValue) {
        if (newValue.text.isEmpty) {
          return newValue;
        }

        // Hapus semua non-digit dan non-titik (untuk desimal)
        String cleanedText = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

        // Tangani titik desimal
        List<String> parts = cleanedText.split('.');
        String integerPart = parts[0];
        String decimalPart = parts.length > 1 ? parts[1] : '';

        // Format bagian integer dengan pemisah ribuan
        final formatter = NumberFormat('#,##0', 'id_ID'); // Format Indonesia
        String formattedIntegerPart = integerPart.isEmpty ? '' : formatter.format(int.parse(integerPart));

        String formattedText = formattedIntegerPart;
        if (parts.length > 1) {
          formattedText += ',$decimalPart'; // Gunakan koma untuk desimal di ID
        }

        return TextEditingValue(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      }
    }
    // Penggunaan:
    // TextFormField(
    //   decoration: const InputDecoration(labelText: 'Jumlah Uang (Rp.)'),
    //   keyboardType: TextInputType.number,
    //   inputFormatters: [
    //     CurrencyInputFormatter(),
    //   ],
    // ),
    ```

  - **Date Formatting:**

    - **Peran:** Memandu pengguna untuk memasukkan tanggal dalam format tertentu (misalnya, `DD/MM/YYYY`).
    - **Detail:** Mirip dengan nomor telepon, ini melibatkan `FilteringTextInputFormatter.digitsOnly` dan _custom formatter_ yang menambahkan pemisah ( `/` atau `-`) pada posisi yang benar.
    - **Contoh Kustom (`DateInputFormatter`):**

    <!-- end list -->

    ```dart
    class DateInputFormatter extends TextInputFormatter {
      @override
      TextEditingValue formatEditUpdate(
          TextEditingValue oldValue, TextEditingValue newValue) {
        final text = newValue.text;
        if (text.isEmpty) {
          return newValue;
        }

        final newText = StringBuffer();
        final digitsOnly = text.replaceAll(RegExp(r'\D'), ''); // Hanya angka

        if (digitsOnly.length >= 1) {
          newText.write(digitsOnly.substring(0, digitsOnly.length.clamp(0, 2))); // DD
        }
        if (digitsOnly.length >= 3) {
          newText.write('/');
          newText.write(digitsOnly.substring(2, digitsOnly.length.clamp(2, 4))); // MM
        }
        if (digitsOnly.length >= 5) {
          newText.write('/');
          newText.write(digitsOnly.substring(4, digitsOnly.length.clamp(4, 8))); // YYYY
        }

        return TextEditingValue(
          text: newText.toString(),
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    }
    // Penggunaan:
    // TextFormField(
    //   decoration: const InputDecoration(labelText: 'Tanggal (DD/MM/YYYY)'),
    //   keyboardType: TextInputType.datetime,
    //   inputFormatters: [
    //     DateInputFormatter(),
    //     LengthLimitingTextInputFormatter(10), // Max length "DD/MM/YYYY"
    //   ],
    // ),
    ```

- **2. Mask Text Input Formatter (`mask_text_input_formatter` package)**

  - **Peran:** Untuk pemformatan input yang lebih canggih dan berbasis _mask_ (pola), seperti nomor kartu kredit, nomor telepon internasional, atau kode pos, _package_ `mask_text_input_formatter` sangat direkomendasikan. Ini menyediakan cara deklaratif untuk mendefinisikan _mask_.
  - **Detail:**
    1.  **Tambahkan Dependency:** `mask_text_input_formatter: ^latest_version` ke `pubspec.yaml`.
    2.  **Inisialisasi:** Buat instance `MaskTextInputFormatter` dengan _mask_ dan _filter_ yang diinginkan.
    3.  **Terapkan:** Masukkan objek _formatter_ ini ke properti `inputFormatters` pada `TextField` atau `TextFormField`.
  - **Konsep Mask:**
    - `##`: Digit (0-9)
    - `AA`: Huruf (a-z, A-Z)
    - `NN`: Huruf atau Digit
    - `XX`: Karakter apa pun
    - Karakter lain dalam _mask_ (seperti `-`, `(`, `)`, `/`, `     `) akan menjadi bagian literal dari _mask_.
  - **Contoh Kode:**

  <!-- end list -->

  ```dart
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // Import package

  class MaskInputFormatterDemo extends StatelessWidget {
    MaskInputFormatterDemo({super.key});

    // Masker untuk nomor telepon (+XX XXX-XXXX-XXXX)
    final phoneMaskFormatter = MaskTextInputFormatter(
      mask: '+## ###-####-####',
      filter: {"#": RegExp(r'[0-9]')},
    );

    // Masker untuk nomor kartu kredit (XXXX-XXXX-XXXX-XXXX)
    final creditCardMaskFormatter = MaskTextInputFormatter(
      mask: '####-####-####-####',
      filter: {"#": RegExp(r'[0-9]')},
    );

    // Masker untuk tanggal (DD/MM/YYYY)
    final dateMaskFormatter = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
    );

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mask Input Formatter Demo')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nomor Telepon (+XX XXX-XXXX-XXXX)'),
                keyboardType: TextInputType.phone,
                inputFormatters: [phoneMaskFormatter],
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nomor Kartu Kredit (XXXX-XXXX-XXXX-XXXX)'),
                keyboardType: TextInputType.number,
                inputFormatters: [creditCardMaskFormatter],
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tanggal Lahir (DD/MM/YYYY)'),
                keyboardType: TextInputType.datetime,
                inputFormatters: [dateMaskFormatter],
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

- **3. Advanced Input Handling**

  - **Peran:** Melampaui pemformatan dasar untuk meningkatkan interaksi pengguna dengan _input field_ dan mengintegrasikan kemampuan input lainnya.

  - **Keyboard Type Optimization:**

    - **Peran:** Menampilkan jenis _keyboard_ yang paling sesuai untuk jenis masukan yang diharapkan, membuat _input_ lebih cepat dan akurat bagi pengguna.
    - **Detail:** Properti `keyboardType` pada `TextField` atau `TextFormField`.
    - **Contoh:**
      - `TextInputType.text`: _Keyboard_ standar.
      - `TextInputType.number`: Hanya angka.
      - `TextInputType.emailAddress`: _Keyboard_ dengan `@` dan `.` yang mudah diakses.
      - `TextInputType.phone`: _Keyboard_ numerik dengan simbol telepon.
      - `TextInputType.datetime`: _Keyboard_ yang cocok untuk input tanggal/waktu.
      - `TextInputType.url`: _Keyboard_ dengan `/` dan `.` yang mudah diakses.

  - **Text Input Actions:**

    - **Peran:** Mengubah tombol "Enter" pada _keyboard_ menjadi aksi yang lebih relevan untuk konteks _input_, seperti "Next", "Done", "Send", "Search".
    - **Detail:** Properti `textInputAction` pada `TextField` atau `TextFormField`. Anda dapat merespons aksi ini menggunakan _callback_ `onFieldSubmitted`.
    - **Contoh:**
      - `TextInputAction.next`: Pindah _focus_ ke _field_ berikutnya.
      - `TextInputAction.done`: Selesaikan _input_, seringkali menutup _keyboard_.
      - `TextInputAction.send`: Untuk mengirim pesan atau data.
      - `TextInputAction.search`: Untuk memulai pencarian.
      - `TextInputAction.go`: Untuk menavigasi.
    - **Implementasi:**

    <!-- end list -->

    ```dart
    TextFormField(
      decoration: const InputDecoration(labelText: 'Nama Depan'),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value) {
        FocusScope.of(context).nextFocus(); // Pindahkan focus ke field selanjutnya
      },
    ),
    const SizedBox(height: 16),
    TextFormField(
      decoration: const InputDecoration(labelText: 'Pesan'),
      textInputAction: TextInputAction.send,
      onFieldSubmitted: (value) {
        print('Pesan dikirim: $value');
        FocusScope.of(context).unfocus(); // Tutup keyboard
      },
    ),
    ```

  - **Auto-correction dan Suggestions:**

    - **Peran:** Mengontrol apakah _keyboard_ sistem harus memberikan koreksi otomatis atau saran kata saat pengguna mengetik.
    - **Detail:** Properti `autocorrect` dan `enableSuggestions` pada `TextField`/`TextFormField`.
    - **Contoh:**
      - `autocorrect: false`: Nonaktifkan koreksi otomatis (berguna untuk nama pengguna atau kode).
      - `enableSuggestions: false`: Nonaktifkan saran kata.
      - `spellCheck: false`: Nonaktifkan pemeriksaan ejaan (tersedia di Flutter 3.0+).

  - **Speech-to-text integration:**

    - **Peran:** Memungkinkan pengguna memasukkan teks melalui suara, menggunakan API pengenalan suara perangkat.
    - **Detail:** Flutter tidak memiliki _widget_ bawaan untuk ini. Anda perlu menggunakan _package_ pihak ketiga seperti `speech_to_text`.
    - **Alur Umum:**
      1.  Tambahkan _package_ `speech_to_text` ke `pubspec.yaml`.
      2.  Minta izin mikrofon.
      3.  Inisialisasi _listener_ suara.
      4.  Mulai mendengarkan input suara dan perbarui `TextEditingController` dengan teks yang dikenali.
    - **Catatan:** Ini akan sangat bergantung pada SDK perangkat dan ketersediaan layanan pengenalan suara.

  - **Barcode scanning input:**

    - **Peran:** Mengintegrasikan pemindai _barcode_ atau QR Code sebagai metode input.
    - **Detail:** Mirip dengan _speech-to-text_, ini memerlukan _package_ pihak ketiga, seperti `barcode_widget`, `mobile_scanner`, atau `qr_code_scanner`.
    - **Alur Umum:**
      1.  Tambahkan _package_ pemindai ke `pubspec.yaml`.
      2.  Minta izin kamera.
      3.  Buka _view_ pemindai kamera.
      4.  Ketika _barcode_ terdeteksi, ambil datanya dan perbarui `TextEditingController` atau kirimkan data.
    - **Catatan:** Ini seringkali melibatkan tampilan kamera _overlay_ dan penanganan _permissions_.

- **Visualisasi Input Formatter Flow:**

  ```
  ┌───────────────────────────┐
  │     User Typing Input     │
  │ (e.g., in TextFormField)  │
  └────────────┬──────────────┘
               │
               ▼
  ┌───────────────────────────┐
  │  inputFormatters Property │
  │ ┌───────────────────────┐ │
  │ │ TextInputFormatter 1  │ │
  │ │ (e.g., digitsOnly)    │ │
  │ └────────────┬──────────┘ │
  └──────────────│────────────┘
                 │  (Passes through formatEditUpdate)
                 ▼
  ┌─────────────────────────────┐
  │  TextInputFormatter 2       │
  │ (e.g., PhoneNumberFormatter)│
  └────────────┬────────────────┘
               │  (Transforms text)
               ▼
  ┌───────────────────────────┐
  │  Formatted Text Displayed │
  │  in TextFormField         │
  └───────────────────────────┘
  ```

  **Penjelasan Visual:**
  Alur ini menunjukkan bagaimana teks yang diketik pengguna melewati serangkaian `TextInputFormatter` yang diatur dalam properti `inputFormatters`. Setiap _formatter_ memiliki kesempatan untuk memodifikasi teks, dan hasil akhirnya adalah teks yang diformat yang ditampilkan di _input field_.

- **Terminologi Esensial:**

  - **`TextInputFormatter`:** Kelas abstrak di Flutter untuk memformat teks input.
  - **`formatEditUpdate`:** Metode yang harus diimplementasikan oleh _custom formatter_ untuk melakukan transformasi teks.
  - **`TextEditingValue`:** Objek yang berisi teks dan informasi posisi kursor dalam _input field_.
  - **`FilteringTextInputFormatter`:** _Formatter_ bawaan untuk memfilter karakter (misalnya, `digitsOnly`, `allow`, `deny`).
  - **`LengthLimitingTextInputFormatter`:** _Formatter_ bawaan untuk membatasi panjang input.
  - **`mask_text_input_formatter`:** _Package_ pihak ketiga untuk pemformatan input berbasis pola (masking).
  - **`KeyboardType`:** Properti untuk mengoptimalkan tampilan _keyboard_ virtual.
  - **`TextInputAction`:** Properti untuk mengubah aksi tombol "Enter" pada _keyboard_.
  - **`onFieldSubmitted`:** _Callback_ yang dipicu saat aksi input keyboard diselesaikan.
  - **`autocorrect` / `enableSuggestions`:** Properti untuk mengontrol fitur koreksi otomatis dan saran kata.
  - **`speech_to_text` / `barcode_scanner`:** Contoh _package_ pihak ketiga untuk integrasi input lanjutan.

- **Hubungan dengan Bagian Lain:**

  - **7.1 Form Widgets & Validation:** _Input formatters_ bekerja secara sinergis dengan `TextFormField` dan `Form` untuk memastikan data yang benar dan _well-formatted_ masuk ke dalam sistem validasi. Validasi akan menjadi lebih mudah jika format data sudah dikelola di tahap _input_.
  - **Pengalaman Pengguna (UX):** Penerapan _formatter_ dan fitur _input_ lanjutan secara signifikan meningkatkan UX dengan memandu pengguna dan mengurangi kesalahan input.

- **Tips & Best Practices (untuk peserta):**

  - **Gunakan Kombinasi:** Anda dapat menggunakan beberapa `TextInputFormatter` dalam satu daftar. Urutan _formatter_ dalam daftar itu penting karena mereka diterapkan secara berurutan.
  - **Pertimbangkan _Package_:** Untuk pemformatan kompleks (seperti nomor telepon internasional, kartu kredit), gunakan _package_ `mask_text_input_formatter` karena lebih robust dan mudah dikelola daripada membuat _formatter_ kustom yang sangat kompleks.
  - **Perhatikan Posisi Kursor:** Saat membuat _custom formatter_, pastikan Anda mengembalikan `TextEditingValue` dengan `selection` yang benar agar kursor tidak melompat-lompat secara tidak terduga.
  - **Uji dengan Berbagai Input:** Selalu uji _formatter_ Anda dengan berbagai jenis masukan (angka, huruf, simbol, input kosong, menghapus karakter) untuk memastikan perilakunya stabil.

# Selamat!

---

Dengan ini, kita telah menyelesaikan pembahasan mendalam tentang **7.3 Input Formatters & Masks**, yang mencakup berbagai teknik pemformatan input teks dan penanganan input lanjutan. Ini juga menandai berakhirnya **Fase 5: Forms & Input Handling**.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-4/README.md
[selanjutnya]: ../bagian-6/README.md
[pro5]: ../../pro/bagian-5/README.md

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
