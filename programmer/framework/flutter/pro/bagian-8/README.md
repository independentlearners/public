> [pro][flash8]

# **[FASE 8: Platform Integration & Native Features][0]**

### **Daftar Isi**

<details>
  <summary>📃 Struktur Daftar Isi</summary>

---

- **[13. Platform Channels & Native Integration](#13-platform-channels--native-integration)**
  - **[13.1. Method Channels](#131-method-channels)**
    - [13.1.1. Platform Channel Implementation](#1311-platform-channel-implementation)
    - [13.1.2. Event Channels](#1312-event-channels)
    - [13.1.3. Binary Messenger (Konseptual)](#1313-binary-messenger-konseptual)
  - **[13.2. Native Plugin Development](#132-native-plugin-development)**
    - [13.2.1. Creating Custom Plugins](#1321-creating-custom-plugins)
    - [13.2.2. Federated Plugin Architecture](#1322-federated-plugin-architecture)
- **[14. Device Features Integration](#14-device-features-integration)**
  - **[14.1. Camera & Media](#141-camera--media)**
    - [14.1.1. Camera Integration & Image Picker](#1411-camera-integration--image-picker)
    - [14.1.2. Media Processing](#1412-media-processing)
  - **[14.2. Sensors & Hardware](#142-sensors--hardware)**
    - [14.2.1. Device Sensors & Location](#1421-device-sensors--location)
    - [14.2.2. Connectivity Features](#1422-connectivity-features)
  - **[14.3. Biometric & Security](#143-biometric--security)**
    - [14.3.1. Biometric Authentication](#1431-biometric-authentication)
    - [14.3.2. Security Implementation](#1432-security-implementation)

</details>

---

### **13. Platform Channels & Native Integration**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Meskipun Flutter sangat kuat, ada kalanya kita perlu mengakses API atau SDK yang spesifik untuk platform Android atau iOS yang belum tersedia sebagai paket Flutter. Di sinilah **Platform Channels** berperan. Ini adalah sebuah "jembatan" yang memungkinkan kode Dart Anda untuk mengirim pesan dan memanggil fungsi di kode _native_ (Kotlin/Java untuk Android, Swift/Objective-C untuk iOS), dan sebaliknya. Menguasai ini adalah kunci untuk membuka potensi penuh dari perangkat keras dan fitur-fitur sistem operasi, memungkinkan Anda untuk membuat aplikasi yang benar-benar tanpa batas.

---

#### **13.1. Method Channels**

##### **13.1.1. Platform Channel Implementation**

**Deskripsi Konkret & Peran dalam Kurikulum:**
`MethodChannel` adalah jenis _platform channel_ yang paling umum, yang digunakan untuk komunikasi **panggilan-dan-respons (call-and-response)** asinkron. Alurnya sederhana: kode Dart "memanggil" sebuah metode di sisi _native_ dengan sebuah nama dan argumen, lalu menunggu (`await`) hingga sisi _native_ selesai bekerja dan mengembalikan sebuah hasil. Ini sangat cocok untuk operasi satu kali seperti mengambil level baterai, mendapatkan versi OS, atau memicu API _native_ tertentu.

**Konsep Kunci & Filosofi Mendalam:**

- **Asynchronous Message Passing:** Komunikasi antara Dart dan _native_ tidak terjadi secara langsung. Sebaliknya, pesan akan di-_serialize_ (diubah menjadi format biner yang dapat dikirim), dikirim melalui jembatan, lalu di-_deserialize_ di sisi lain. Proses ini bersifat asinkron, sehingga semua panggilan _channel_ akan mengembalikan sebuah `Future`.
- **Shared Channel Name:** Jembatan antara Dart dan _native_ diidentifikasi oleh sebuah nama `String` yang unik (misalnya, `com.yourapp/battery`). Kedua sisi (Dart dan _native_) harus membuat _channel_ dengan nama yang sama persis agar dapat berkomunikasi.
- **Data Type Serialization:** Tidak semua tipe data bisa dikirim melalui _channel_. Flutter menggunakan `StandardMessageCodec` yang secara otomatis menangani tipe-tipe data standar seperti `null`, `bool`, `int`, `double`, `String`, `Uint8List`, `List`, dan `Map`. Untuk objek yang lebih kompleks, Anda harus mengubahnya menjadi `Map` terlebih dahulu.

**Sintaks Dasar / Contoh Implementasi Inti:**
Contoh ini akan membuat fungsi untuk mendapatkan level baterai perangkat dari kode Android asli.

**Langkah 1: Kode Flutter (Dart)**

```dart
// file: lib/battery_service.dart
import 'package:flutter/services.dart';

class BatteryService {
  // 1. Definisikan nama channel yang unik
  static const platform = MethodChannel('com.example.app/battery');

  // 2. Buat fungsi untuk memanggil metode native
  Future<int> getBatteryLevel() async {
    try {
      // 3. Panggil metode 'getBatteryLevel' di sisi native
      // Hasilnya akan dikembalikan sebagai Future
      final int result = await platform.invokeMethod('getBatteryLevel');
      return result;
    } on PlatformException catch (e) {
      // Tangani jika metode gagal atau tidak diimplementasikan
      print("Gagal mendapatkan level baterai: '${e.message}'.");
      return -1;
    }
  }
}

// Di UI, Anda bisa memanggilnya seperti ini:
// final batteryLevel = await BatteryService().getBatteryLevel();
```

**Langkah 2: Kode Native (Android - Kotlin)**
Anda perlu mengedit file `MainActivity.kt`.

```kotlin
// file: android/app/src/main/kotlin/com/example/app/MainActivity.kt
package com.example.app

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES

class MainActivity: FlutterActivity() {
    // 1. Definisikan nama channel yang SAMA PERSIS dengan di Dart
    private val CHANNEL = "com.example.app/battery"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // 2. Buat MethodChannel dan set MethodCallHandler
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            // 3. Periksa nama metode yang dipanggil dari Dart
            if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()

                if (batteryLevel != -1) {
                    // 4a. Kirim hasil kembali ke Dart jika berhasil
                    result.success(batteryLevel)
                } else {
                    // 4b. Kirim error kembali ke Dart jika gagal
                    result.error("UNAVAILABLE", "Level baterai tidak tersedia.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    // Fungsi helper untuk mendapatkan data baterai dari Android OS
    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }
        return batteryLevel
    }
}
```

### **Representasi Diagram Alur (Method Channel)**

```
┌───────────────────────────┐         ┌───────────────────────────────┐
│  Kode Dart (Flutter)      │         │  Kode Native (Android/iOS)    │
└───────────┬───────────────┘         └───────────────┬───────────────┘
            │                                         │
┌───────────▼───────────────┐           ┌─────────────▼────────────────────────────────┐
│ platform.invokeMethod(    │           │ MethodChannel(...).setMethodCallHandler(...) │
│   'getBatteryLevel'       ├──────────►│ (Mendengarkan panggilan)                     │
│ )                         │           └─────────────┬────────────────────────────────┘
│ (Mengirim pesan)          │                         │
└───────────┬───────────────┘                         │
            │                                         │ call.method == 'getBatteryLevel'?
            │ (Future menunggu...)                    │
            │                               ┌─────────▼───────────────┐
            │                               │ getBatteryLevel()       │
            │                               │(Menjalankan kode native)│
            │                               └─────────┬───────────────┘
            │                                         │
┌───────────▼───────────────┐           ┌─────────────▼───────────────┐
│ Future selesai dengan     │◄──────────┤ result.success(batteryLevel)│
│ nilai dari native         │           │ (Mengirim hasil kembali)    │
└───────────────────────────┘           └─────────────────────────────┘
```

---

##### **13.1.2. Event Channels**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Jika `MethodChannel` adalah untuk komunikasi satu kali, **`EventChannel`** adalah untuk komunikasi **streaming** atau berkelanjutan. Ia memungkinkan kode _native_ untuk mengirim aliran (_stream_) _event_ ke kode Dart. Ini sangat ideal untuk mendengarkan perubahan state yang terjadi di sisi _native_, seperti data sensor (perubahan lokasi GPS, data akselerometer), status konektivitas jaringan, atau progres unduhan file.

**Konsep Kunci & Filosofi Mendalam:**

- **Aliran Data Satu Arah (Native ke Dart):** `EventChannel` pada dasarnya adalah `Stream` di sisi Dart. Kode _native_ bertindak sebagai "produsen" yang dapat mengirim data (`sink.success(event)`) atau error (`sink.error(...)`) ke _stream_ tersebut kapan saja.
- **Manajemen Langganan:** Di sisi _native_, Anda akan mendapatkan _callback_ `onListen` saat kode Dart mulai mendengarkan _stream_, dan `onCancel` saat langganan dibatalkan. Ini memungkinkan Anda untuk memulai dan menghentikan sumber _event_ (misalnya, mendaftarkan dan membatalkan pendaftaran _listener_ sensor) secara efisien untuk menghemat baterai.

---

#### **13.1.3. Binary Messenger (Konseptual)**

**Deskripsi Konkret & Peran dalam Kurikulum:**
`BinaryMessenger` adalah inti atau "saluran pipa" tingkat terendah yang menjadi dasar dari semua komunikasi _platform channel_ di Flutter. Baik `MethodChannel` maupun `EventChannel` yang telah kita bahas sebenarnya adalah abstraksi atau "pembungkus" yang lebih mudah digunakan di atas `BinaryMessenger`. Ia bertanggung jawab untuk mengirim dan menerima pesan biner mentah antara kode Dart dan sisi _native_. Memahaminya secara konseptual penting untuk mengetahui "apa yang sebenarnya terjadi di balik layar" dan berguna saat Anda perlu membuat _codec_ pesan kustom atau membutuhkan optimisasi kinerja tingkat sangat rendah yang tidak disediakan oleh `MethodChannel` standar.

**Konsep Kunci & Filosofi Mendalam:**

- **Lapisan Transportasi Fundamental:** Anggap `BinaryMessenger` sebagai protokol TCP/IP dalam komunikasi jaringan. Anda jarang berinteraksi dengannya secara langsung, tetapi semua komunikasi tingkat tinggi (seperti HTTP) dibangun di atasnya. `MethodChannel` dan `EventChannel` menyediakan "protokol aplikasi" yang lebih mudah (seperti memanggil metode dengan nama), sementara `BinaryMessenger` hanya peduli pada pengiriman paket data biner dari titik A ke B.
- **Codec (Encoder/Decoder):** Karena `BinaryMessenger` hanya mengirim data biner, ia memerlukan sebuah `MessageCodec` untuk mengubah data terstruktur (seperti `Map` atau `List`) menjadi format biner, dan sebaliknya. `StandardMessageCodec` adalah yang paling umum dan digunakan secara default oleh `MethodChannel`.

### **Representasi Diagram Alur (Hirarki Platform Channel)**

```
┌────────────────────────────────────────────────────────┐
│  Anda sebagai Developer Berinteraksi dengan ini        │
│  (API Tingkat Tinggi)                                  │
├──────────────────────┬─────────────────────────────────┤
│  MethodChannel       │  EventChannel                   │
│  (Untuk Panggilan    │  (Untuk Streaming Data)         │
│   Satu Kali)         │                                 │
└──────────┬───────────┴───────────────┬─────────────────┘
           │ (Keduanya menggunakan...) │
┌──────────▼───────────────────────────▼─────────────────┐
│  BinaryMessenger                                       │
│  (API Tingkat Rendah - "Saluran Pipa" Inti)            │
│  Tugas: Mengirim & Menerima Pesan Biner Mentah         │
└──────────────────────┬─────────────────────────────────┘
                       │ (Berkomunikasi melalui...)
┌──────────────────────▼─────────────────────────────────┐
│  Jembatan Platform Flutter                             │
│  (Antara Dart VM dan Kode Native Android/iOS)          │
└────────────────────────────────────────────────────────┘
```

Diagram ini menunjukkan bahwa `BinaryMessenger` adalah fondasi yang memungkinkan `MethodChannel` dan `EventChannel` untuk bekerja. Anda hampir tidak akan pernah perlu menggunakan `BinaryMessenger` secara langsung, tetapi memahami keberadaannya penting untuk gambaran arsitektur yang lengkap.

---

### **13.2. Native Plugin Development**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Setelah Anda tahu cara menggunakan _platform channels_, langkah selanjutnya adalah mengemasnya menjadi sebuah **plugin** yang dapat digunakan kembali dan bahkan dipublikasikan di [pub.dev](http://pub.dev). Bagian ini mengajarkan struktur standar dari sebuah paket plugin, yang memisahkan API Dart publik dari implementasi spesifik per platform (Android, iOS, Web, dll.).

##### **13.2.1. Creating Custom Plugins**

- **Struktur Direktori:** Saat Anda membuat plugin (`flutter create --template=plugin ...`), Flutter akan membuat struktur proyek yang sudah diatur dengan baik, termasuk direktori `lib` (untuk kode Dart), `android`, `ios`, `linux`, dll. (untuk kode _native_ spesifik platform).
- **API Dart:** Di direktori `lib`, Anda akan mendefinisikan kelas API publik yang akan digunakan oleh developer lain. Kelas ini akan menggunakan `MethodChannel` atau `EventChannel` di belakang layar untuk berkomunikasi dengan kode _native_.

##### **13.2.2. Federated Plugin Architecture**

- **Konsep:** Ini adalah pola arsitektur modern untuk plugin yang mendukung banyak platform. Alih-alih menaruh semua kode (Dart, Android, iOS, Web) dalam satu paket, Anda memecahnya menjadi beberapa paket:
  1.  **`my_plugin_platform_interface`:** Sebuah paket yang hanya berisi **antarmuka (interface) abstrak** dalam Dart. Ia mendefinisikan "apa" yang bisa dilakukan oleh plugin, tanpa implementasi apa pun.
  2.  **`my_plugin`:** Paket utama yang digunakan oleh developer. Ia bergantung pada paket _platform_interface_ dan menyediakan API publik.
  3.  **`my_plugin_android`, `my_plugin_ios`, `my_plugin_web`:** Paket-paket terpisah yang berisi **implementasi konkret** untuk setiap platform. Mereka mengimplementasikan antarmuka dari paket _platform_interface_.
- **Keuntungan:** Arsitektur ini sangat modular. Tim yang berbeda dapat bekerja pada implementasi platform yang berbeda secara independen. Pengguna juga hanya perlu menyertakan implementasi untuk platform yang mereka targetkan.

---

Kita telah membahas fondasi dari komunikasi _native_, yaitu **Platform Channels**. Ini adalah topik yang sangat teknis. Berikutnya kita akan melihat bagaimana konsep ini diterapkan untuk mengakses fitur-fitur seperti kamera dan sensor.

### **14. Device Features Integration**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Sebuah aplikasi seluler menjadi benar-benar berdaya guna ketika ia dapat berinteraksi dengan dunia fisik melalui sensor dan perangkat keras perangkat. Bagian ini adalah tentang mengintegrasikan fitur-fitur perangkat seperti kamera, GPS, sensor gerak, dan otentikasi biometrik. Dengan menguasai ini, Anda dapat membangun aplikasi yang jauh lebih kaya dan kontekstual, mulai dari aplikasi media sosial yang memungkinkan unggahan foto, aplikasi kebugaran yang melacak gerakan, hingga aplikasi perbankan yang aman dengan sidik jari.

---

### **14.1. Camera & Media**

#### **14.1.1. Camera Integration & Image Picker**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah dua skenario paling umum terkait media.

- **Image Picker:** Cara **sederhana** untuk mendapatkan gambar atau video. Ia akan membuka antarmuka kamera atau galeri bawaan sistem operasi, dan pengguna memilih satu media. Aplikasi Anda kemudian akan menerima file yang dipilih. Ini adalah pilihan terbaik jika Anda hanya butuh pengguna untuk mengunggah sebuah foto (misalnya, untuk foto profil).
- **Camera Integration:** Cara **lanjutan** untuk mendapatkan kontrol penuh atas perangkat keras kamera. Dengan paket `camera`, Anda dapat membangun antarmuka kamera kustom di dalam aplikasi Anda, menampilkan pratinjau langsung, dan mengontrol hal-hal seperti _flash_, zoom, dan pergantian kamera depan/belakang. Ini diperlukan untuk aplikasi yang berfokus pada fotografi atau yang memerlukan pengalaman kamera yang terintegrasi.

**Konsep Kunci & Filosofi Mendalam:**

- **Pemisahan Tanggung Jawab:** `image_picker` mendelegasikan seluruh UI dan logika ke sistem operasi, membuatnya sangat mudah digunakan. `camera` memberi Anda semua kontrol, tetapi juga semua tanggung jawab untuk membangun UI dan mengelola _state_ kamera (`initialize`, `takePicture`, `dispose`).
- **Manajemen Bereizinan (Permissions):** Mengakses kamera atau galeri adalah operasi yang memerlukan izin dari pengguna. Paket-paket ini biasanya menangani permintaan izin, tetapi praktik terbaiknya adalah menggunakan paket seperti `permission_handler` untuk memeriksa dan meminta izin secara proaktif guna memberikan pengalaman pengguna yang lebih baik.
- **Siklus Hidup Controller:** Saat menggunakan paket `camera`, `CameraController` adalah objek stateful yang harus dikelola dengan hati-hati. Ia harus diinisialisasi (`initialize()`) sebelum digunakan dan dihancurkan (`dispose()`) saat widget tidak lagi terlihat untuk melepaskan sumber daya kamera.

**Sintaks Dasar / Contoh Implementasi Inti:**

**Contoh 1: `image_picker` (Sederhana)**

```dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});
  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Picker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!, height: 200)
                : const Text('Tidak ada gambar dipilih.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: const Text('Pilih dari Galeri'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: const Text('Ambil dari Kamera'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Contoh 2: `camera` (Lanjutan - Konseptual)**

```dart
// Implementasi penuhnya sangat panjang, ini adalah konsep utamanya
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CustomCameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CustomCameraScreen({super.key, required this.cameras});
  @override
  State<CustomCameraScreen> createState() => _CustomCameraScreenState();
}

class _CustomCameraScreenState extends State<CustomCameraScreen> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    // 1. Inisialisasi controller dengan kamera pertama yang tersedia
    _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {}); // Rebuild untuk menampilkan preview
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container(); // Tampilkan loading atau container kosong
    }
    // 2. Tampilkan pratinjau kamera
    return Scaffold(
      body: CameraPreview(_controller),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 3. Ambil gambar
          final XFile image = await _controller.takePicture();
          // Lakukan sesuatu dengan file gambar...
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}
```

### **Visualisasi Hasil Kode**

```
┌──────────────────────────┐        ┌──────────────────────────┐
│ Tampilan `image_picker`  │        │Tampilan `camera` (Kustom)│
├──────────────────────────┤        ├──────────────────────────┤
│ AppBar: [Image Picker]   │        │                          │
│ ------------------------ │        │                          │
│                          │        │  ┌────────────────────┐  │
│    [Tidak ada gambar]    │        │  │                    │  │
│                          │        │  │   Tampilan Preview │  │
│    ┌───────────────┐     │        │  │    Kamera Langsung │  │
│    │Pilih dari Galeri    │        │  │                    │  │
│    └───────────────┘     │        │  └────────────────────┘  │
│                          │        │                          │
│    ┌───────────────┐     │        │                          │
│    │Ambil dari Kamera    │        │                      [▢] │
│    └───────────────┘     │        │                          │
└──────────────────────────┘        └──────────────────────────┘
```

### **Representasi Diagram Alur (Perbandingan)**

```
┌──────────────────────────────────┐
│  Aplikasi Anda                   │
└───────────────┬──────────────────┘
      ┌─────────┴─────────┐
      │                   │
┌─────▼─────────────┐ ┌───▼──────────────────┐
│ image_picker      │ │ camera               │
└─────┬─────────────┘ └──────┬───────────────┘
      │                      │
┌─────▼─────────────┐ ┌──────▼───────────────┐
│ Membuka UI        │ │ Menampilkan          │
│ Kamera/Galeri     │ │ `CameraPreview` di   │
│ BAWAAN OS         │ │ dalam widget Anda    │
└─────┬─────────────┘ └──────┬───────────────┘
      │                      │
┌─────▼─────────────┐ ┌──────▼───────────────┐
│ Pengguna memilih  │ │ Pengguna menekan     │
│ media             │ │ tombol jepret kustom │
└─────┬─────────────┘ └───────┬──────────────┘
      │                       │
      └─────────┬─────────────┘
                │
┌───────────────▼───────────────┐
│ Aplikasi menerima `XFile`     │
│ (Hasil akhir)                 │
└───────────────────────────────┘
```

---

#### **14.1.2. Media Processing**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Setelah mendapatkan gambar atau video, seringkali kita perlu memprosesnya lebih lanjut. Ini bisa berupa operasi sederhana seperti memotong (_cropping_) atau memutar gambar, menerapkan filter, atau bahkan memutar video dengan kontrol kustom. Bagian ini memperkenalkan konsep dan paket-paket populer untuk memanipulasi media di dalam aplikasi Flutter Anda.

**Konsep & Paket Populer:**

- **Image Editing (`image`):** Paket `image` adalah _library_ Dart murni yang sangat kuat untuk manipulasi gambar di sisi klien. Anda dapat mengubah ukuran, memotong, menggambar di atas gambar, atau menerapkan filter kompleks.
- **Video Playback (`video_player`):** Paket resmi dari Flutter untuk memutar video. Ia menyediakan `VideoPlayerController` dan widget `VideoPlayer` untuk menampilkan video, dengan kontrol untuk putar, jeda, dan mencari posisi (_seeking_).
- **Audio Playback (`just_audio`, `audioplayers`):** Untuk audio, ada beberapa paket canggih. `just_audio` sangat populer karena kemampuannya menangani daftar putar (_playlist_), _streaming_, dan efek audio.

---

### **14.2. Sensors & Hardware**

#### **14.2.1. Device Sensors & Location**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Setiap ponsel pintar dilengkapi dengan berbagai sensor yang membuatnya sadar akan lingkungan sekitarnya. Ini termasuk **akselerometer** (mengukur percepatan/guncangan), **giroskop** (mengukur orientasi/rotasi), dan yang paling umum digunakan, **GPS** (untuk mendapatkan lokasi geografis). Bagian ini mengajarkan cara mengakses data dari sensor-sensor ini untuk membangun aplikasi berbasis lokasi, game berbasis gerak, atau aplikasi kebugaran.

**Konsep & Paket Populer:**

- **Sensor Gerak (`sensors_plus`):** Paket populer yang menyediakan akses ke data akselerometer, giroskop, dan magnetometer melalui `Stream`. Anda cukup mendengarkan _stream_ yang sesuai untuk mendapatkan pembaruan data sensor secara _real-time_.
- **Lokasi GPS (`geolocator`, `location`):** `geolocator` adalah paket yang sangat populer untuk semua kebutuhan lokasi. Ia dapat:
  - Mendapatkan lokasi terakhir yang diketahui.
  - Mendapatkan lokasi saat ini (satu kali).
  - Mendengarkan perubahan lokasi secara berkelanjutan (misalnya, untuk aplikasi navigasi).
  - Menghitung jarak antara dua koordinat.
  - Menangani permintaan izin lokasi, yang merupakan bagian paling kritis.

**Sintaks Dasar / Contoh `geolocator` (Konseptual):**

```dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    // 1. Cek apakah layanan lokasi aktif
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Layanan lokasi dinonaktifkan.');
    }

    // 2. Cek dan minta izin
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin lokasi ditolak.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Izin lokasi ditolak secara permanen.');
    }

    // 3. Jika izin diberikan, dapatkan lokasi
    return await Geolocator.getCurrentPosition();
  }
}
```

---

#### **14.2.2. Connectivity Features**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Bagian ini mencakup cara aplikasi berinteraksi dengan radio nirkabel perangkat, seperti **Wi-Fi** dan **Bluetooth**. Kasus penggunaan yang paling umum adalah memeriksa status koneksi internet untuk menampilkan pesan "Anda sedang offline" atau untuk menunda operasi jaringan. Untuk aplikasi IoT (_Internet of Things_) atau yang berinteraksi dengan perangkat keras eksternal, integrasi Bluetooth menjadi sangat penting.

**Konsep & Paket Populer:**

- **Network Connectivity (`connectivity_plus`):** Paket standar untuk memantau status koneksi jaringan. Ia menyediakan `Stream` yang akan memancarkan _event_ baru setiap kali status koneksi berubah (misalnya, dari Wi-Fi ke data seluler, atau menjadi offline).
- **Bluetooth (`flutter_blue_plus`, `flutter_reactive_ble`):** Interaksi Bluetooth jauh lebih kompleks karena melibatkan proses pemindaian (_scanning_), penyambungan (_connecting_), dan komunikasi dengan perangkat _peripheral_. Paket-paket ini menyediakan API tingkat tinggi untuk mengelola alur kerja tersebut.

---

### **14.3. Biometric & Security**

#### **14.3.1. Biometric Authentication**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Memberikan lapisan keamanan tambahan tanpa mengorbankan kenyamanan pengguna adalah hal yang sangat penting, terutama untuk aplikasi keuangan atau yang menyimpan data sensitif. Otentikasi biometrik (sidik jari di Android, Face ID/Touch ID di iOS) adalah solusinya. Paket `local_auth` memungkinkan Anda untuk memicu dialog otentikasi biometrik dari sistem operasi dan mendapatkan hasilnya.

**Konsep Kunci & Implementasi:**

- **Delegasi ke OS:** Sama seperti `image_picker`, `local_auth` mendelegasikan seluruh UI dan logika verifikasi yang aman ke sistem operasi. Anda tidak pernah mendapatkan akses langsung ke data sidik jari atau wajah pengguna.
- **Pemeriksaan Ketersediaan & Fallback:** Sebelum mencoba otentikasi, Anda harus selalu memeriksa apakah perangkat mendukung biometrik (`canCheckBiometrics`) dan apakah ada biometrik yang sudah terdaftar. Jika tidak, Anda harus menyediakan metode login alternatif (seperti PIN atau password).

**Sintaks Dasar / Contoh `local_auth`:**

```dart
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    final bool canAuthenticate = await _auth.canCheckBiometrics;
    if (canAuthenticate) {
      try {
        return await _auth.authenticate(
          localizedReason: 'Harap otentikasi untuk melanjutkan',
          options: const AuthenticationOptions(
            biometricOnly: true, // Hanya izinkan biometrik, bukan PIN perangkat
          ),
        );
      } catch (e) {
        print(e);
        return false;
      }
    }
    return false;
  }
}
```

#### **14.3.2. Security Implementation**

**Deskripsi Konkret & Peran dalam Kurikulum:**
Ini adalah topik luas yang mencakup berbagai praktik untuk membuat aplikasi Anda lebih tahan terhadap serangan atau penyalahgunaan.

- **Root/Jailbreak Detection (`flutter_jailbreak_detection`):** Beberapa aplikasi (terutama perbankan) perlu mendeteksi apakah perangkat telah di-_root_ (Android) atau di-_jailbreak_ (iOS), karena ini dapat mengindikasikan lingkungan yang kurang aman. Paket ini membantu melakukan pengecekan tersebut.
- **Screenshot Prevention (`screenshot_callback`, _platform channel_):** Untuk layar yang menampilkan informasi sangat sensitif, Anda mungkin ingin mencegah pengguna mengambil tangkapan layar atau bahkan mendapatkan notifikasi jika itu terjadi.
- **App Signing:** Proses menandatangani aplikasi Anda dengan kunci kriptografis sebelum merilisnya. Ini adalah langkah **wajib** untuk publikasi ke Play Store dan App Store, yang membuktikan bahwa APK/IPA tersebut benar-benar berasal dari Anda dan tidak dimodifikasi oleh pihak lain.

---

# **Selamat!**

Anda telah belajar cara mendobrak batasan _framework_ Flutter dan memanfaatkan kekuatan sesungguhnya dari perangkat keras dan sistem operasi _native_. Anda kini dapat:

- Berkomunikasi dengan kode Kotlin/Swift melalui **Platform Channels**.
- Mengintegrasikan **Kamera** dan memilih media dari galeri.
- Mengakses data dari **sensor** perangkat dan **lokasi GPS**.
- Memeriksa **konektivitas** dan menggunakan **otentikasi biometrik**.

Dengan pengetahuan ini, tidak ada lagi fitur _native_ yang berada di luar jangkauan Anda. Aplikasi yang Anda bangun kini dapat menjadi lebih cerdas, lebih aman, dan lebih terintegrasi dengan dunia nyata.

---

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-7/README.md
[selanjutnya]: ../bagian-9/README.md
[flash8]: ../../flash/bagian-8/README.md

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
