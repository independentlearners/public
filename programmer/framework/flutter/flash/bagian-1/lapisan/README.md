# **Contoh Kode dari Tiga Lapisan Utama dalam Arsitektur Flutter**

Penting untuk diingat bahwa sebagai pengembang *Flutter*, Anda akan paling sering berinteraksi langsung dengan **Framework Layer** (ditulis dalam Dart). Dua lapisan lainnya—**Engine Layer** dan **Embedder Layer**—adalah lapisan fundamental yang sebagian besar sudah diimplementasikan oleh tim *Flutter* dan tidak memerlukan penulisan kode langsung dari sisi pengembang aplikasi biasa, melainkan mereka memungkinkan kode Anda berjalan dan berinteraksi dengan sistem operasi.

-----


#### **1. Framework Layer (Lapisan Kerangka Kerja)**

Ini adalah lapisan tempat sebagian besar kode aplikasi *Flutter* Anda ditulis. Seluruhnya berbasis Dart dan terdiri dari *widget*, *rendering*, *animation*, *painting*, dan *gestures*. Anda akan membangun UI Anda menggunakan *widget* dari lapisan ini, seperti `MaterialApp`, `Scaffold`, `Text`, `Column`, `Row`, `Container`, dll.

**Contoh Kode (Dart - Flutter Framework Layer):**
Kode ini adalah contoh sederhana aplikasi *Flutter* yang menampilkan teks dan tombol. Setiap elemen di sini adalah *widget* dari *Framework Layer*.

```dart
// Import package Flutter Material Design.
// Ini adalah bagian dari Framework Layer, menyediakan komponen UI sesuai Material Design.
import 'package:flutter/material.dart';

void main() {
  // runApp adalah fungsi dari Framework Layer yang mengambil root widget aplikasi Anda
  // dan menghubungkannya ke Flutter Engine untuk mulai merender.
  runApp(const MyApp());
}

// MyApp adalah StatelessWidget, sebuah widget yang konfigurasinya tidak berubah setelah dibuat.
// Ini adalah contoh bagaimana Anda mendefinisikan UI Anda di Framework Layer.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp adalah root widget untuk aplikasi Material Design.
    // Ini mengonfigurasi tema, navigasi, dan aspek desain Material lainnya.
    return MaterialApp(
      title: 'Flutter Architecture Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Scaffold menyediakan struktur visual dasar untuk aplikasi Material Design.
      // Ini mencakup AppBar, body, FloatingActionButton, dll.
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Framework Layer Example'),
        ),
        body: Center(
          // Column adalah widget layout yang menata children-nya secara vertikal.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Text adalah widget untuk menampilkan string teks.
              const Text(
                'Halo dari Framework Layer!',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20), // SizedBox adalah widget untuk memberikan spasi.
              // ElevatedButton adalah widget tombol Material Design yang dapat ditekan.
              ElevatedButton(
                onPressed: () {
                  // Ketika tombol ditekan, logika Dart ini dieksekusi.
                  // Ini memicu perubahan state atau navigasi di Framework Layer.
                  print('Tombol ditekan!');
                },
                child: const Text('Tekan Saya'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Penjelasan:**
Kode di atas sepenuhnya ditulis dalam Dart dan menggunakan *widget* serta fungsi yang disediakan oleh *Flutter Framework*. Setiap baris yang mendefinisikan UI, *layout*, atau interaksi dasar berada di lapisan ini. Saat Anda menulis `Text('Halo')` atau `ElevatedButton`, Anda sedang memanfaatkan komponen yang telah dibangun di *Framework Layer*.

#### **2. Engine Layer (Lapisan Mesin)**

Lapisan ini ditulis dalam C++ dan merupakan jantung *Flutter*. Ia menyediakan API tingkat rendah yang diperlukan oleh *Flutter Framework* (Dart). Ini termasuk *Skia Graphics Engine* (untuk *rendering*), *Dart Runtime* (untuk mengeksekusi kode Dart), dan *Platform Channels* (untuk berkomunikasi dengan kode *native*).

**Contoh Kode (Konseptual - Tidak Ditulis Langsung oleh Pengembang Flutter):**
Sebagai pengembang aplikasi *Flutter*, Anda **tidak menulis kode langsung di lapisan Engine**. Kode ini adalah bagian dari *Flutter SDK* itu sendiri dan diimplementasikan oleh tim *Flutter*. Anda hanya memanfaatkan fungsionalitasnya melalui *Framework Layer*.

Namun, secara konseptual, contoh kode di lapisan *Engine* akan terlihat seperti implementasi C++ yang:

  * Menerima perintah gambar dari *Framework Layer* (misalnya, "gambar teks ini dengan ukuran X di posisi Y").
  * Menggunakan *Skia* untuk mengubah perintah tersebut menjadi instruksi *rendering* GPU.
  * Mengelola Dart VM untuk menjalankan kode Dart Anda.
  * Menyediakan fungsi *binding* untuk *Platform Channels* agar kode Dart dapat memanggil API *native*.

**Ilustrasi Konseptual (C++ - Internal Engine Layer):**

```cpp
// Ini adalah ilustrasi konseptual dan sangat disederhanakan dari kode C++ internal Flutter Engine.
// Anda tidak akan menulis kode seperti ini dalam pengembangan aplikasi Flutter sehari-hari.

// Di dalam Flutter Engine (C++):

// Sebuah fungsi hipotetis yang menerima "Layer" dari Framework Dart dan merendernya
void FlutterEngine::RenderFrame(const Dart_Handle& dart_layer_data) {
    // 1. Menerima data rendering dari Framework Layer (melalui Dart VM)
    // 2. Mengurai instruksi gambar
    // 3. Menggunakan Skia untuk menggambar ke permukaan rendering (misalnya, OpenGL/Vulkan/Metal)
    SkCanvas* canvas = GetCanvasFromContext(); // Dapatkan kanvas Skia
    // ... Logika Skia untuk menggambar shapes, teks, dll.
    // Contoh: canvas->drawRect(...); canvas->drawText(...);
    canvas->flush(); // Kirim perintah gambar ke GPU
}

// Sebuah fungsi hipotetis di mana Dart memanggil native code melalui Platform Channel
void FlutterEngine::RegisterPlatformChannelMethod(const std::string& method_name, NativeMethodCallback callback) {
    // Mendaftarkan callback C++ yang akan dipanggil ketika method_name dipanggil dari Dart
    // ...
}

// ... dan banyak kode C++ lainnya untuk manajemen memori, event loop, input handling, dll.
```

**Penjelasan:**
Kode C++ ini adalah bagaimana *Flutter Engine* mengambil instruksi *rendering* dari *widget* Dart Anda dan mengubahnya menjadi piksel di layar, atau bagaimana ia memungkinkan Dart berbicara dengan API *native*. Anda berinteraksi dengan fungsionalitasnya secara tidak langsung melalui *widget* dan metode Dart yang Anda panggil di *Framework Layer*.

#### **3. Embedder Layer (Lapisan Penanam)**

Lapisan ini adalah kode spesifik *platform* (misalnya Kotlin/Java untuk Android, Swift/Objective-C untuk iOS, C++ untuk Desktop, JavaScript untuk Web) yang bertanggung jawab untuk menyediakan *entry point* bagi *Flutter* dan mengintegrasikannya dengan sistem operasi host. Ini adalah bagian yang "menanamkan" (*embeds*) *Flutter Engine* ke dalam aplikasi *native*.

**Contoh Kode (Platform-specific - Android (Kotlin) / iOS (Swift)):**
Anda akan menemukan kode ini di dalam direktori `android/` dan `ios/` dari proyek *Flutter* Anda.

**Android (Kotlin - `android/app/src/main/kotlin/com/example/yourapp/MainActivity.kt`):**

```kotlin
package com.example.yourapp

import io.flutter.embedding.android.FlutterActivity // Import kelas FlutterActivity
import io.flutter.embedding.engine.FlutterEngine // Import FlutterEngine

// MainActivity adalah Activity utama untuk aplikasi Android Anda.
// Ia meng-extend FlutterActivity, yang menyediakan integrasi dasar dengan Flutter Engine.
class MainActivity: FlutterActivity() {

    // Anda bisa mengoverride configureFlutterEngine jika perlu melakukan konfigurasi khusus
    // pada FlutterEngine, misalnya mendaftarkan Platform Channel kustom.
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Contoh konseptual: Mendaftarkan method channel untuk komunikasi native-Dart
        // MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.yourapp/battery")
        //     .setMethodCallHandler { call, result ->
        //         if (call.method == "getBatteryLevel") {
        //             // ... implementasi native untuk mendapatkan level baterai
        //         } else {
        //             result.notImplemented()
        //         }
        //     }
    }
}
```

**iOS (Swift - `ios/Runner/AppDelegate.swift`):**

```swift
import UIKit
import Flutter // Import framework Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate { // AppDelegate meng-extend FlutterAppDelegate

  // Metode didFinishLaunchingWithOptions adalah entry point utama aplikasi iOS.
  // FlutterAppDelegate menyediakan implementasi dasar untuk menginisialisasi Flutter Engine.
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Ini memastikan bahwa Flutter Engine diinisialisasi dan dihubungkan dengan view.
    GeneratedPluginRegistrant.register(with: self) // Mendaftarkan plugin Flutter
    
    // Anda bisa menambahkan logika kustom di sini, misalnya untuk Platform Channel.
    // let controller = window?.rootViewController as! FlutterViewController
    // let batteryChannel = FlutterMethodChannel(name: "com.example.yourapp/battery", binaryMessenger: controller.binaryMessenger)
    // batteryChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
    //    if call.method == "getBatteryLevel" {
    //        // ... implementasi native untuk mendapatkan level baterai
    //    } else {
    //        result(FlutterMethodNotImplemented)
    //    }
    // }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

**Penjelasan:**
Kode di atas adalah kode *native* yang dihasilkan secara otomatis saat Anda membuat proyek *Flutter*. `MainActivity.kt` (Android) dan `AppDelegate.swift` (iOS) adalah titik masuk utama yang memuat dan menjalankan *Flutter Engine*. Meskipun Anda jarang mengubah file-file ini dalam pengembangan *Flutter* sehari-hari, mereka menjadi penting ketika Anda perlu menambahkan fungsionalitas spesifik *platform* yang tidak dapat dijangkau oleh Dart (misalnya, mengakses *hardware* yang sangat spesifik atau API sistem yang tidak tersedia melalui *plugin* *Flutter* yang ada). Di sinilah *Platform Channels* digunakan untuk menjembatani komunikasi antara kode Dart dan kode *native*.

-----

**Ringkasan Tiga Lapisan Arsitektur:**

  * **Framework Layer (Dart):** Di sinilah Anda menghabiskan sebagian besar waktu Anda, membangun UI dan logika bisnis menggunakan *widget* yang kaya dan ekspresif.
  * **Engine Layer (C++):** Mesin performa tinggi yang menangani *rendering* piksel ke layar (Skia), menjalankan kode Dart Anda (Dart VM), dan menyediakan jembatan ke *platform native* (Platform Channels). Anda berinteraksi dengannya secara tidak langsung.
  * **Embedder Layer (Native - Kotlin/Java/Swift/C++/JS):** Kode *platform-specific* yang menginisialisasi dan menanamkan *Flutter Engine* ke dalam lingkungan *host*, memungkinkan aplikasi *Flutter* berjalan di berbagai *platform*.

Memahami pembagian tanggung jawab ini akan membantu Anda mengidentifikasi di mana letak masalah yang terjadi, dan bagaimana *Flutter* mampu memberikan performa *native* dan pengalaman pengembangan yang cepat. Ini adalah kekuatan inti di balik fleksibilitas dan kecepatan *Flutter*.

**[Kembali][0]**

[0]:../README.md