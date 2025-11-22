> [flash][pro8]

# **[FASE 8: Platform Integration & Native Features][0]**

Fase ini akan membekali Anda dengan kemampuan untuk berinteraksi dengan fungsionalitas khusus perangkat dan _platform_ yang tidak sepenuhnya di-_expose_ oleh Flutter _framework_ inti.

<details>
  <summary>📃 Struktur Daftar Isi</summary>

---

- **[13. Platform Channels & Native Integration](#13-platform-channels--native-integration)**

  - [13.1 Method Channels](#131-method-channels)
    - Platform Channel Implementation
    - Method channel setup
    - Native code integration (Android/iOS)
    - Data type mapping
    - Error handling across platforms
    - Platform Channels
    - Writing Platform-Specific Code
  - [13.2 Native Plugin Development](#132-native-plugin-development)
    - Creating Custom Plugins
    - Plugin package structure
    - Platform-specific implementations
    - Pub.dev publishing
    - Plugin testing strategies
    - Version management
    - Developing Flutter Plugins
    - Plugin Best Practices
    - Federated Plugin Architecture
    - Platform interface separation
    - Implementation packages
    - Web platform support
    - Desktop platform support
    - Federated Plugins

- **[14. Device Features Integration](#14-device-features-integration)**

  - [14.1 Camera & Media](#141-camera--media)
    - Camera Integration
    - Camera controller setup
    - Photo capture dan video recording
    - Camera preview customization
    - Multiple camera support
    - Camera permissions handling
    - Camera Plugin
    - Image Picker
    - Camera Advanced Usage
    - Media Processing
    - Image editing dan filters
    - Video processing
    - Audio recording dan playback
    - Media compression
    - Thumbnail generation
    - Image Editor
    - Video Player
    - Audio Players
  - [14.2 Sensors & Hardware](#142-sensors--hardware)
    - Device Sensors
    - Accelerometer dan gyroscope
    - GPS location services
    - Proximity sensor
    - Light sensor
    - Compass integration
    - Sensors Plus
    - Geolocator
    - Location Permissions
    - Connectivity Features
    - Bluetooth integration
    - WiFi management
    - NFC communication
    - Network connectivity monitoring
    - Flutter Bluetooth Serial
    - WiFi Info
    - Connectivity Plus
  - [14.3 Biometric & Security](#143-biometric--security)
    - Biometric Authentication
    - Fingerprint authentication
    - Face ID/Face recognition
    - Device credential authentication
    - Biometric availability checking
    - Local Auth
    - Biometric Authentication Guide
    - Security Implementation
    - App signing dan verification
    - Root/Jailbreak detection
    - Screenshot prevention
    - App lock implementation
    - Flutter Jailbreak Detection
    - Screenshot Callback

</details>

---

#### **13. Platform Channels & Native Integration**

- **Peran:** Flutter, sebagai _framework_ UI lintas _platform_, memiliki kemampuan untuk membangun antarmuka pengguna yang indah dan berperforma tinggi. Namun, seringkali aplikasi perlu berinteraksi dengan fungsionalitas spesifik _platform_ yang tidak tersedia di Dart API. Inilah peran dari _Platform Channels_: sebuah jembatan komunikasi yang memungkinkan kode Dart di sisi Flutter untuk memanggil kode _native_ (Kotlin/Java untuk Android, Swift/Objective-C untuk iOS) dan sebaliknya.

---

##### **13.1 Method Channels**

- **Peran:** _Method Channels_ adalah bentuk komunikasi _asynchronous_ antara kode Dart di sisi Flutter dan kode _native_. Ini memungkinkan Anda untuk memanggil metode (fungsi) pada sisi _native_ dari Dart, dan mendapatkan kembali hasilnya. Ini adalah mekanisme yang paling umum digunakan untuk mengakses API spesifik _platform_.

- **Platform Channel Implementation:**

  - **Konsep:** Komunikasi melalui _Platform Channel_ melibatkan pengiriman "pesan" serial yang direpresentasikan sebagai nilai standar. Pesan-pesan ini dikirim melalui `BinaryMessenger` dan diinterpretasikan oleh _Codec_ (misalnya, `StandardMethodCodec`).
  - **Alur Komunikasi:**
    1.  Kode Dart memanggil metode pada `MethodChannel`.
    2.  Flutter _engine_ mengirimkan pesan ke sisi _native_.
    3.  Kode _native_ menerima pesan, mengidentifikasi metode yang diminta dan argumennya.
    4.  Kode _native_ mengeksekusi logika yang relevan.
    5.  Kode _native_ mengirimkan hasil (atau _error_) kembali ke Flutter _engine_.
    6.  Flutter _engine_ mengembalikan hasil ke kode Dart.

- **Method Channel Setup:**

  - **Di Sisi Dart (Flutter):**

    - Anda membuat `MethodChannel` dengan nama unik. Nama ini harus sama persis di sisi Dart dan _native_.
    - Anda kemudian dapat memanggil metode seperti `invokeMethod<T>(String method, [dynamic arguments])` untuk mengirim data dan menunggu respons.

  - **Di Sisi Native (Android - Kotlin/Java):**

    - Anda juga membuat `MethodChannel` dengan nama yang sama.
    - Anda mengatur `MethodCallHandler` pada _channel_ tersebut. Handler ini akan menerima `MethodCall` (berisi nama metode dan argumen) dan `Result` (untuk mengirim kembali respons).

  - **Di Sisi Native (iOS - Swift/Objective-C):**

    - Mirip dengan Android, Anda membuat `MethodChannel` dengan nama yang sama.
    - Anda mengatur _handler_ untuk menerima `FlutterMethodCall` dan `FlutterResult`.

- **Data Type Mapping:**

  - **Peran:** Ketika data dikirim antara Dart dan kode _native_, data tersebut harus di-_serialize_ dan di-_deserialize_. Flutter menyediakan `StandardMessageCodec` yang secara otomatis menangani pemetaan tipe data umum.
  - **Pemetaan Umum:**
    - Dart `bool` \<-\> Android `java.lang.Boolean` \<-\> iOS `NSNumber (BOOL)`
    - Dart `int` \<-\> Android `java.lang.Integer` \<-\> iOS `NSNumber (NSInteger)`
    - Dart `double` \<-\> Android `java.lang.Double` \<-\> iOS `NSNumber (double)`
    - Dart `String` \<-\> Android `java.lang.String` \<-\> iOS `NSString`
    - Dart `List` \<-\> Android `java.util.ArrayList` \<-\> iOS `NSArray`
    - Dart `Map` \<-\> Android `java.util.HashMap` \<-\> iOS `NSDictionary`
    - Dart `Uint8List`, `Int32List`, `Int64List`, `Float64List` \<-\> Android `byte[]`, `int[]`, `long[]`, `double[]` \<-\> iOS `NSData`, `NSArray<NSNumber>` (untuk int/long/double array).
  - **Penting:** Jika Anda perlu mengirim tipe data yang kompleks atau kustom, Anda mungkin perlu mengonversinya ke salah satu tipe dasar yang didukung sebelum mengirimkannya melalui _channel_.

- **Error Handling Across Platforms:**

  - **Peran:** Penting untuk menangani _error_ yang mungkin terjadi selama komunikasi _channel_, baik di sisi _native_ maupun di sisi Dart.
  - **Mekanisme:**
    - **Dari Native ke Dart:** Di sisi _native_, Anda dapat mengirimkan _error_ kembali menggunakan `Result.error(errorCode, errorMessage, errorDetails)`. Di sisi Dart, Anda menangkap _error_ ini menggunakan blok `try-catch` di sekitar panggilan `invokeMethod()`, yang akan memunculkan `PlatformException`.
    - **Dari Dart ke Native:** Jarang terjadi, tetapi jika panggilan `invokeMethod` gagal di sisi Dart sebelum mencapai _native_, _error_ akan muncul di Dart.

- **Contoh Kode (Method Channel):**

  Kita akan membuat aplikasi sederhana yang meminta _native_ API untuk mendapatkan versi OS perangkat.

  **Langkah 1: Deklarasikan `MethodChannel` di Flutter (lib/main.dart)**

  ```dart
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart'; // Import untuk MethodChannel

  void main() {
    runApp(const PlatformChannelApp());
  }

  class PlatformChannelApp extends StatelessWidget {
    const PlatformChannelApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Platform Channel Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
        ),
        home: const MethodChannelScreen(),
      );
    }
  }

  class MethodChannelScreen extends StatefulWidget {
    const MethodChannelScreen({super.key});

    @override
    State<MethodChannelScreen> createState() => _MethodChannelScreenState();
  }

  class _MethodChannelScreenState extends State<MethodChannelScreen> {
    // 1. Buat MethodChannel dengan nama unik
    // Nama ini harus sama di kode native!
    static const platform = MethodChannel('com.example.platform_channel_demo/device');

    String _osVersion = 'Unknown OS Version';
    String _errorMessage = '';

    Future<void> _getOsVersion() async {
      String osVersion;
      try {
        // 2. Panggil metode 'getOsVersion' di sisi native
        // Anda bisa mengirim argumen jika diperlukan: invokeMethod('getOsVersion', {'param': 'value'})
        final String result = await platform.invokeMethod('getOsVersion');
        osVersion = 'OS Version: $result';
        _errorMessage = ''; // Hapus pesan error sebelumnya
      } on PlatformException catch (e) {
        // 3. Tangani error jika terjadi di sisi native
        osVersion = 'Failed to get OS version.';
        _errorMessage = "Error: '${e.message}'.";
        print("PlatformException: ${e.code}, ${e.message}, ${e.details}");
      } catch (e) {
        // Tangani error umum lainnya
        osVersion = 'An unexpected error occurred.';
        _errorMessage = "Error: '$e'.";
        print("General Error: $e");
      }

      setState(() {
        _osVersion = osVersion;
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Method Channels'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Mengambil informasi OS dari Native Code:',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                _osVersion,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: _osVersion.startsWith('Unknown') || _osVersion.startsWith('Failed')
                      ? Colors.red : Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _getOsVersion,
                child: const Text('Get OS Version'),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Tekan tombol untuk memanggil kode native Android/iOS guna mendapatkan versi sistem operasi perangkat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

  **Langkah 2: Implementasi Native Android (Kotlin)**

  - Buka proyek Flutter Anda di Android Studio.
  - Navigasi ke `android/app/src/main/kotlin/com/example/platform_channel_demo/MainActivity.kt` (atau `MainActivity.java` jika Anda menggunakan Java).

  <!-- end list -->

  ```kotlin
  package com.example.platform_channel_demo

  import io.flutter.embedding.android.FlutterActivity
  import io.flutter.embedding.engine.FlutterEngine
  import io.flutter.plugin.common.MethodChannel // Import MethodChannel
  import android.os.Build // Import untuk mendapatkan versi OS Android

  class MainActivity: FlutterActivity() {
      // Nama channel harus sama dengan di Flutter
      private val CHANNEL = "com.example.platform_channel_demo/device"

      override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
          super.configureFlutterEngine(flutterEngine)

          // 1. Buat MethodChannel
          MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
              // 2. Tangani panggilan metode dari Flutter
              call, result ->
              if (call.method == "getOsVersion") {
                  // Mendapatkan versi OS Android
                  val osVersion = Build.VERSION.RELEASE
                  // Mengirim hasil kembali ke Flutter
                  result.success(osVersion)
              } else {
                  // Jika metode tidak dikenal, kirim error
                  result.notImplemented()
              }
          }
      }
  }
  ```

  **Langkah 3: Implementasi Native iOS (Swift)**

  - Buka proyek Flutter Anda di Xcode.
  - Navigasi ke `ios/Runner/AppDelegate.swift` (atau `AppDelegate.m` jika Anda menggunakan Objective-C).

  <!-- end list -->

  ```swift
  import UIKit
  import Flutter

  @UIApplicationMain
  @objc class AppDelegate: FlutterAppDelegate {
    override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
      // Mendapatkan FlutterViewController
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      // Nama channel harus sama dengan di Flutter
      let deviceChannel = FlutterMethodChannel(name: "com.example.platform_channel_demo/device",
                                                binaryMessenger: controller.binaryMessenger)

      // 1. Tangani panggilan metode dari Flutter
      deviceChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        // 2. Periksa nama metode yang dipanggil
        if call.method == "getOsVersion" {
          // Mendapatkan versi OS iOS
          let osVersion = UIDevice.current.systemVersion
          // Mengirim hasil kembali ke Flutter
          result(osVersion)
        } else {
          // Jika metode tidak dikenal, kirim error
          result(FlutterMethodNotImplemented)
        }
      })

      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
  }
  ```

- **Visualisasi Konseptual: Method Channel Flow**

  ```mermaid
  graph TD
      subgraph Flutter (Dart)
          F1[MethodChannel('com.example.device')] -- invokeMethod('getOsVersion') --> F2[Flutter Engine];
      end

      subgraph Communication Bridge
          F2 -- Binary Message (Serialized Call) --> NB[Native Bridge];
          NB -- Deserialized Call --> NA[Native Android / iOS];
      end

      subgraph Native Platform
          NA[Native Android / iOS] -- Executing Logic --> NR[Result (OS Version)];
          NR -- Serialized Result --> NB;
      end

      subgraph Back to Flutter
          NB -- Binary Message (Serialized Result) --> F2;
          F2 -- Deserialized Result --> F1[MethodChannel Future.then()];
      end
  ```

  **Penjelasan Visual:**
  Diagram ini mengilustrasikan alur komunikasi melalui _Method Channel_. Kode Dart di Flutter memanggil sebuah metode yang kemudian dikirim melalui Flutter _engine_ sebagai pesan biner. Pesan ini diterima dan di-_deserialize_ oleh sisi _native_ (Android atau iOS), yang kemudian mengeksekusi logika _native_ dan mengembalikan hasilnya. Hasil tersebut kemudian di-_serialize_ kembali, dikirim melalui _engine_, dan di-_deserialize_ oleh Dart untuk digunakan di aplikasi Flutter.

- **Sumber Daya Tambahan:**

  - [Platform Channels](https://docs.flutter.dev/platform-integration/platform-channels) (Dokumentasi resmi Flutter)
  - [Writing Platform-Specific Code](https://docs.flutter.dev/platform-integration/platform-channels/platform-views) (Dokumentasi resmi Flutter - meskipun judulnya platform-views, ini relevan untuk implementasi native)

---

Dengan ini, kita telah menyelesaikan **13.1 Method Channels**, fondasi untuk berinteraksi dengan kode _native_. Anda sekarang memahami bagaimana komunikasi _Method Channel_ bekerja dari ujung ke ujung.

Jika _Method Channels_ adalah untuk komunikasi _request-response_ satu kali, _Event Channels_ berikut ini adalah untuk aliran data berkelanjutan.

---

##### **13.1 Event Channels (Lanjutan)**

- **Peran:** _Event Channels_ digunakan untuk mengirimkan aliran data (atau "peristiwa") dari sisi _native_ ke sisi Dart (Flutter) secara berkelanjutan. Ini sangat berguna untuk skenario di mana _native_ mengirim pembaruan secara berkala, seperti data sensor, status koneksi jaringan, atau kemajuan unduhan.

- **Event Stream Setup:**

  - **Di Sisi Dart (Flutter):**

    - Anda membuat `EventChannel` dengan nama unik (lagi-lagi, nama ini harus sama di kedua sisi).
    - Anda kemudian dapat mengakses `stream` properti dari `EventChannel` untuk mendapatkan `Stream<dynamic>`.
    - Anda akan menggunakan `listen()` pada _stream_ ini untuk menerima peristiwa.

  - **Di Sisi Native (Android - Kotlin/Java):**

    - Anda membuat `EventChannel` dengan nama yang sama.
    - Anda mengatur `StreamHandler` pada _channel_ tersebut. `StreamHandler` memiliki dua metode: `onListen` (dipanggil saat Flutter mulai mendengarkan) dan `onCancel` (dipanggil saat Flutter berhenti mendengarkan).
    - Di dalam `onListen`, Anda mendapatkan `EventSink` yang akan digunakan untuk mengirimkan peristiwa ke Flutter.

  - **Di Sisi Native (iOS - Swift/Objective-C):**

    - Mirip dengan Android, Anda membuat `EventChannel` dan mengatur `FlutterStreamHandler`.
    - `FlutterStreamHandler` juga memiliki `onListen` dan `onCancel` yang memberi Anda `FlutterEventSink`.

- **Native Event Broadcasting:**

  - **Peran:** Mengirimkan data dari kode _native_ ke _sink_ peristiwa yang disediakan oleh `EventChannel`, yang kemudian meneruskannya ke _stream_ di Dart.
  - **Mekanisme:** Di sisi _native_, setelah `onListen` dipanggil dan Anda memiliki `EventSink`, Anda dapat memanggil `sink.success(data)` untuk mengirimkan data ke Dart. Anda juga dapat menggunakan `sink.error(errorCode, errorMessage, errorDetails)` untuk mengirimkan _error_.

- **Stream Subscription Management:**

  - **Peran:** Penting untuk mengelola langganan _stream_ di sisi Dart untuk mencegah kebocoran memori. Saat _widget_ yang mendengarkan _stream_ tidak lagi diperlukan (misalnya, saat dihancurkan), langganan harus dibatalkan.
  - **Mekanisme:** Saat Anda memanggil `stream.listen()`, ia mengembalikan objek `StreamSubscription`. Anda harus menyimpan objek ini dan memanggil `cancel()` pada `dispose()` dari `StatefulWidget` Anda.

- **Error Handling dalam Streams:**

  - **Peran:** Menangani _error_ yang mungkin terjadi di sisi _native_ atau selama pengiriman peristiwa.
  - **Mekanisme:** Saat Anda berlangganan _stream_ di Dart, Anda dapat menyediakan _callback_ `onError` ke metode `listen()`. Setiap _error_ yang dikirim dari sisi _native_ melalui `sink.error()` akan ditangkap oleh _callback_ ini di Dart.

- **Contoh Kode (Event Channel):**

  Kita akan membuat aplikasi yang mendengarkan perubahan orientasi layar dari _native_ (meskipun Flutter memiliki API sendiri untuk ini, ini adalah contoh yang baik untuk _Event Channel_).

  **Langkah 1: Deklarasikan `EventChannel` di Flutter (lib/main.dart)**

  ```dart
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart'; // Import untuk EventChannel

  void main() {
    runApp(const EventChannelApp());
  }

  class EventChannelApp extends StatelessWidget {
    const EventChannelApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Event Channel Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          useMaterial3: true,
        ),
        home: const EventChannelScreen(),
      );
    }
  }

  class EventChannelScreen extends StatefulWidget {
    const EventChannelScreen({super.key});

    @override
    State<EventChannelScreen> createState() => _EventChannelScreenState();
  }

  class _EventChannelScreenState extends State<EventChannelScreen> {
    // 1. Buat EventChannel dengan nama unik
    static const EventChannel _orientationChannel =
        EventChannel('com.example.platform_channel_demo/orientation');

    String _currentOrientation = 'Unknown';
    String _errorMessage = '';

    // Langganan stream untuk mengelolanya
    StreamSubscription<dynamic>? _orientationSubscription;

    @override
    void initState() {
      super.initState();
      // 2. Mulai mendengarkan stream event dari native
      _orientationSubscription = _orientationChannel.receiveBroadcastStream().listen(
        (dynamic event) {
          // Callback ketika event baru diterima
          setState(() {
            _currentOrientation = event.toString();
            _errorMessage = '';
          });
          print('Received orientation event: $event');
        },
        onError: (dynamic error) {
          // Callback ketika ada error dari stream native
          setState(() {
            _errorMessage = 'Error receiving orientation: ${error.message}';
          });
          print('Error receiving orientation: $error');
        },
        onDone: () {
          // Callback ketika stream ditutup
          setState(() {
            _errorMessage = 'Orientation stream closed.';
          });
          print('Orientation stream closed.');
        },
        cancelOnError: true, // Otomatis batalkan langganan jika ada error
      );
    }

    @override
    void dispose() {
      // 3. Pastikan untuk membatalkan langganan saat widget dibuang
      _orientationSubscription?.cancel();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Event Channels'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Current Device Orientation:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                _currentOrientation,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Putar perangkat Anda untuk melihat perubahan orientasi yang dikirim dari kode native melalui Event Channel.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

  **Langkah 2: Implementasi Native Android (Kotlin)**

  - Buka proyek Flutter Anda di Android Studio.
  - Navigasi ke `android/app/src/main/kotlin/com/example/platform_channel_demo/MainActivity.kt`.

  <!-- end list -->

  ```kotlin
  package com.example.platform_channel_demo

  import io.flutter.embedding.android.FlutterActivity
  import io.flutter.embedding.engine.FlutterEngine
  import io.flutter.plugin.common.EventChannel // Import EventChannel
  import android.content.BroadcastReceiver
  import android.content.Context
  import android.content.Intent
  import android.content.IntentFilter
  import android.content.res.Configuration // Untuk mendeteksi perubahan orientasi

  class MainActivity: FlutterActivity() {
      private val ORIENTATION_CHANNEL = "com.example.platform_channel_demo/orientation"

      // BroadcastReceiver untuk mendengarkan perubahan orientasi
      private var orientationChangeReceiver: BroadcastReceiver? = null

      override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
          super.configureFlutterEngine(flutterEngine)

          // 1. Buat EventChannel
          EventChannel(flutterEngine.dartExecutor.binaryMessenger, ORIENTATION_CHANNEL).setStreamHandler(
              object : EventChannel.StreamHandler {
                  // 2. Dipanggil saat Flutter mulai mendengarkan stream
                  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                      // Daftarkan BroadcastReceiver untuk mendengarkan perubahan konfigurasi (orientasi)
                      orientationChangeReceiver = object : BroadcastReceiver() {
                          override fun onReceive(context: Context?, intent: Intent?) {
                              if (intent?.action == Intent.ACTION_CONFIGURATION_CHANGED) {
                                  val newConfig = context?.resources?.configuration
                                  if (newConfig != null) {
                                      val orientation = when (newConfig.orientation) {
                                          Configuration.ORIENTATION_LANDSCAPE -> "Landscape"
                                          Configuration.ORIENTATION_PORTRAIT -> "Portrait"
                                          else -> "Unknown"
                                      }
                                      // 3. Kirim event ke Flutter
                                      events?.success(orientation)
                                  }
                              }
                          }
                      }
                      context.registerReceiver(orientationChangeReceiver, IntentFilter(Intent.ACTION_CONFIGURATION_CHANGED))
                  }

                  // 4. Dipanggil saat Flutter berhenti mendengarkan stream
                  override fun onCancel(arguments: Any?) {
                      // Batalkan pendaftaran receiver untuk mencegah kebocoran memori
                      orientationChangeReceiver?.let {
                          context.unregisterReceiver(it)
                      }
                      orientationChangeReceiver = null
                  }
              }
          )
      }
  }
  ```

  **Catatan untuk Android:** Untuk `ACTION_CONFIGURATION_CHANGED`, Android 12 (API 31) dan yang lebih tinggi memerlukan deklarasi `android:configChanges` yang lebih spesifik di `AndroidManifest.xml` agar perubahan ini memicu _restart_ `Activity` atau `onConfigurationChanged`. Namun, untuk contoh _EventChannel_ ini, receiver akan tetap menerima pembaruan konfigurasi. Jika Anda ingin mencegah _Activity_ di-_restart_ saat orientasi berubah (yang umum untuk aplikasi Flutter), pastikan `AndroidManifest.xml` Anda memiliki baris berikut di tag `<activity>` utama:

  ```xml
  <activity
      ...
      android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
      android:hardwareAccelerated="true"
      android:windowSoftInputMode="adjustResize">
      ...
  </activity>
  ```

  **Langkah 3: Implementasi Native iOS (Swift)**

  - Buka proyek Flutter Anda di Xcode.
  - Navigasi ke `ios/Runner/AppDelegate.swift`.

  <!-- end list -->

  ```swift
  import UIKit
  import Flutter

  @UIApplicationMain
  @objc class AppDelegate: FlutterAppDelegate {
    override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let orientationChannel = FlutterEventChannel(name: "com.example.platform_channel_demo/orientation",
                                                   binaryMessenger: controller.binaryMessenger)

      // 1. Buat StreamHandler
      orientationChannel.setStreamHandler(OrientationStreamHandler())

      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
  }

  // 2. Implementasi FlutterStreamHandler
  class OrientationStreamHandler: NSObject, FlutterStreamHandler {
      private var eventSink: FlutterEventSink?

      // Dipanggil saat Flutter mulai mendengarkan stream
      func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
          self.eventSink = events
          // Daftarkan notifikasi untuk perubahan orientasi perangkat
          NotificationCenter.default.addObserver(self,
                                                 selector: #selector(deviceDidRotate),
                                                 name: UIDevice.orientationDidChangeNotification,
                                                 object: nil)
          // Kirim orientasi awal
          sendOrientationEvent()
          return nil
      }

      // Dipanggil saat Flutter berhenti mendengarkan stream
      func onCancel(withArguments arguments: Any?) -> FlutterError? {
          NotificationCenter.default.removeObserver(self)
          eventSink = nil
          return nil
      }

      // Method yang dipanggil saat notifikasi orientasi diterima
      @objc private func deviceDidRotate() {
          sendOrientationEvent()
      }

      // Fungsi untuk mengirim orientasi saat ini ke Flutter
      private func sendOrientationEvent() {
          let orientation = UIDevice.current.orientation
          var orientationString: String

          switch orientation {
          case .portrait, .portraitUpsideDown:
              orientationString = "Portrait"
          case .landscapeLeft, .landscapeRight:
              orientationString = "Landscape"
          default:
              orientationString = "Unknown" // FaceUp, FaceDown
          }

          // 3. Kirim event ke Flutter
          eventSink?(orientationString)
      }
  }
  ```

  **Catatan untuk iOS:** Pastikan `AppDelegate` Anda tidak memblokir `UIDevice.orientationDidChangeNotification` jika Anda memiliki konfigurasi _landscape_ spesifik.

- **Binary Messenger:**

  - **Peran:** `BinaryMessenger` adalah antarmuka inti yang digunakan oleh `MethodChannel` dan `EventChannel` untuk mengirim dan menerima pesan biner antara Dart dan _native_. Ini adalah mekanisme tingkat terendah yang beroperasi di bawah _Codec_ (misalnya, `StandardMethodCodec`).
  - **Detail:** Anda jarang berinteraksi langsung dengan `BinaryMessenger`. _Channels_ tingkat lebih tinggi (seperti `MethodChannel`, `EventChannel`) mengabstraksi detail ini. Namun, penting untuk memahami bahwa ini adalah "pipa" di mana semua komunikasi _platform_ mengalir. Setiap `FlutterEngine` memiliki `BinaryMessenger` sendiri.

- **Visualisasi Konseptual: Event Channel Flow**

  ```mermaid
  graph TD
      subgraph Native Platform
          NA[Native Android / iOS] -- Event Trigger (e.g., Orientation Change) --> ES[EventSink];
          ES -- Data (e.g., "Portrait") --> NB[Native Bridge];
      end

      subgraph Communication Bridge
          NB -- Binary Message (Serialized Event) --> FE[Flutter Engine];
      end

      subgraph Flutter (Dart)
          FE -- Deserialized Event --> EC[EventChannel Stream];
          EC -- Stream.listen() --> SU[Stream Subscriber (Flutter Widget)];
          SU[Stream Subscriber (Flutter Widget)] -- Update UI --> UI[User Interface];
      end
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan bagaimana _Event Channel_ bekerja. Peristiwa terjadi di sisi _native_ (misalnya, perubahan orientasi perangkat). Kode _native_ mengirimkan data peristiwa melalui `EventSink` ke _Native Bridge_. Pesan biner yang diserialkan kemudian mengalir melalui Flutter _engine_ ke _stream_ di `EventChannel` di sisi Dart. Di sisi Dart, _widget_ yang berlangganan _stream_ menerima peristiwa tersebut dan memperbarui UI.

---

Dengan ini, kita telah menyelesaikan pembahasan **Event Channels** dan pemahaman Anda tentang **Binary Messenger**.

Selanjutnya, kita akan masuk ke **13.2 Native Plugin Development**, di mana kita akan menggabungkan pemahaman _Method_ dan _Event Channels_ untuk membangun _plugin_ kustom Anda sendiri.

Berikut Ini adalah langkah alami setelah memahami _Platform Channels_, karena _plugin_ pada dasarnya adalah _wrapper_ yang dapat digunakan kembali di atas _Platform Channels_ untuk mengakses fungsionalitas _native_.

---

##### **13.2 Native Plugin Development**

- **Peran:** Flutter _plugin_ adalah paket yang berisi kode Dart API untuk Flutter dan implementasi _platform-specific_ untuk Android (Kotlin/Java) dan/atau iOS (Swift/Objective-C), dan _platform_ lain seperti _web_, _desktop_. _Plugin_ memungkinkan pengembang Flutter untuk mengakses fungsionalitas _native_ perangkat (misalnya, kamera, GPS, sensor) atau berinteraksi dengan API _platform_ pihak ketiga, kemudian membagikannya sebagai _package_ yang dapat dipublikasikan di [pub.dev](https://pub.dev/).

---

###### **Creating Custom Plugins**

- **Konsep:** Membuat _plugin_ kustom pada dasarnya adalah membungkus logika _Platform Channel_ yang telah kita pelajari ke dalam struktur _package_ yang terdefinisi dengan baik, sehingga dapat dengan mudah diimpor dan digunakan oleh aplikasi Flutter lain.

- **Plugin Package Structure:**

  - **Proyek Root:** Sebuah folder yang berisi semua bagian _plugin_.
  - **`lib/`:**
    - `your_plugin_name.dart`: Berkas utama yang berisi API Dart yang akan diekspos ke pengguna _plugin_. Ini akan menjadi tempat `MethodChannel` atau `EventChannel` dideklarasikan dan metode `invokeMethod` dipanggil.
    - `src/` (opsional): Untuk kode Dart internal _plugin_ jika diperlukan.
  - **`android/`:**
    - Folder proyek Android (misalnya, `src/main/kotlin/com/example/your_plugin_name/YourPluginNamePlugin.kt`). Ini adalah tempat implementasi _native_ Android berada.
    - File `build.gradle` untuk konfigurasi Android.
  - **`ios/`:**
    - Folder proyek iOS (misalnya, `Classes/YourPluginNamePlugin.swift`). Ini adalah tempat implementasi _native_ iOS berada.
    - File `your_plugin_name.podspec` untuk konfigurasi CocoaPods.
  - **`pubspec.yaml`:**
    - Mendefinisikan metadata _package_, dependensi, dan yang paling penting, bagian `flutter.plugin` yang mendeklarasikan _plugin_ dan implementasi _platform-specific_-nya.
  - **`example/`:**
    - Direktori yang berisi aplikasi Flutter contoh yang menggunakan _plugin_ Anda. Ini sangat penting untuk pengembangan dan pengujian _plugin_.

- **Platform-Specific Implementations:**

  - **Android (Kotlin/Java):**
    - Anda akan membuat kelas _plugin_ yang mengimplementasikan `FlutterPlugin` dan `MethodCallHandler` (untuk `MethodChannel`) atau `StreamHandler` (untuk `EventChannel`).
    - Di `onAttachedToEngine`, Anda akan mendaftarkan `MethodChannel`/`EventChannel`.
    - Di `onMethodCall`, Anda akan mengimplementasikan logika _native_ untuk metode yang dipanggil dari Dart.
    - Di `onDetachedFromEngine`, Anda akan membersihkan _channel_ dan sumber daya.
  - **iOS (Swift/Objective-C):**
    - Anda akan membuat kelas _plugin_ yang mengimplementasikan `FlutterPlugin` dan `FlutterStreamHandler` (untuk `EventChannel`) atau `FlutterMethodChannel` (untuk `MethodChannel`).
    - Mirip dengan Android, Anda mendaftarkan _channel_ dan mengimplementasikan logika di _handler_ masing-masing.

- **Pub.dev Publishing:**

  - **Peran:** [pub.dev](https://pub.dev/) adalah repositori paket resmi untuk Dart dan Flutter. Menerbitkan _plugin_ Anda di sana membuatnya tersedia bagi pengembang lain di seluruh dunia.
  - **Proses:**
    1.  Pastikan `pubspec.yaml` Anda memiliki metadata yang lengkap (nama, deskripsi, versi, beranda, repositori, dll.).
    2.  Jalankan `flutter pub publish --dry-run` untuk memverifikasi bahwa _package_ Anda valid untuk publikasi.
    3.  Jalankan `flutter pub publish` untuk benar-benar menerbitkan _plugin_. Anda akan memerlukan akun Google dan mengikuti instruksi otentikasi.

- **Plugin Testing Strategies:**

  - **Unit Tests (Dart):** Untuk menguji logika Dart murni dalam _plugin_ Anda.
  - **Integration Tests:** Menggunakan aplikasi `example/` untuk menguji interaksi penuh antara kode Dart dan kode _native_. Ini sering melibatkan `flutter_driver` atau `integration_test`.
  - **Manual Testing:** Menjalankan aplikasi contoh pada perangkat fisik atau _emulator_ Android/iOS untuk memverifikasi fungsionalitas secara visual.

- **Version Management:**

  - Gunakan [Semantic Versioning](https://semver.org/) (misalnya, `1.0.0`, `1.0.1`, `2.0.0`).
  - **MAJOR.MINOR.PATCH:**
    - **MAJOR:** Perubahan API yang tidak kompatibel ke belakang.
    - **MINOR:** Penambahan fungsionalitas yang kompatibel ke belakang.
    - **PATCH:** Perbaikan _bug_ yang kompatibel ke belakang.
  - Perbarui versi di `pubspec.yaml` setiap kali Anda merilis pembaruan.

- **Contoh Sederhana (Bagian Kunci) Pembuatan Plugin:**

  Misalkan Anda ingin membuat _plugin_ sederhana bernama `my_device_info` yang mengembalikan nama perangkat.

  **1. Buat Proyek Plugin Baru:**

  ```bash
  flutter create --org com.example --template=plugin my_device_info
  ```

  Ini akan membuat struktur dasar _plugin_.

  **2. `my_device_info/lib/my_device_info.dart` (Dart API):**

  ```dart
  import 'package:flutter/services.dart';

  /// Saluran komunikasi antara Dart dan native.
  const MethodChannel _channel = MethodChannel('my_device_info');

  /// Mengembalikan nama perangkat dari native.
  Future<String?> getDeviceName() async {
    try {
      // Panggil metode 'getDeviceName' di native.
      final String? deviceName = await _channel.invokeMethod('getDeviceName');
      return deviceName;
    } on PlatformException catch (e) {
      print("Gagal mendapatkan nama perangkat: '${e.message}'.");
      return null;
    }
  }
  ```

  **3. `my_device_info/android/src/main/kotlin/com/example/my_device_info/MyDeviceInfoPlugin.kt` (Android Implementation):**

  ```kotlin
  package com.example.my_device_info

  import io.flutter.embedding.engine.plugins.FlutterPlugin
  import io.flutter.plugin.common.MethodCall
  import io.flutter.plugin.common.MethodChannel
  import io.flutter.plugin.common.MethodChannel.MethodCallHandler
  import io.flutter.plugin.common.MethodChannel.Result
  import android.os.Build // Untuk mendapatkan nama perangkat Android

  /** MyDeviceInfoPlugin */
  class MyDeviceInfoPlugin: FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will communicate between Flutter and native Android
    ///
    /// This is the FlutterPlugin's "official" channel to be used for
    /// communicating method calls from Flutter to the native Android code.
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
      // Inisialisasi MethodChannel saat plugin terpasang ke engine Flutter
      channel = MethodChannel(flutterPluginBinding.binaryMessenger, "my_device_info")
      // Daftarkan handler untuk MethodChannel ini
      channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
      // Tangani panggilan metode dari Flutter
      if (call.method == "getDeviceName") {
        // Dapatkan nama perangkat
        val deviceName = Build.MODEL
        // Kirim hasilnya kembali ke Flutter
        result.success(deviceName)
      } else {
        // Jika metode tidak dikenal, beri tahu Flutter
        result.notImplemented()
      }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
      // Bersihkan MethodChannel saat plugin dilepas dari engine
      channel.setMethodCallHandler(null)
    }
  }
  ```

  **4. `my_device_info/ios/Classes/MyDeviceInfoPlugin.swift` (iOS Implementation):**

  ```swift
  import Flutter
  import UIKit

  public class MyDeviceInfoPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
      // Daftarkan MethodChannel saat plugin didaftarkan
      let channel = FlutterMethodChannel(name: "my_device_info", binaryMessenger: registrar.messenger())
      let instance = MyDeviceInfoPlugin()
      registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      // Tangani panggilan metode dari Flutter
      if call.method == "getDeviceName" {
        // Dapatkan nama perangkat iOS
        let deviceName = UIDevice.current.name
        // Kirim hasilnya kembali ke Flutter
        result(deviceName)
      } else {
        // Jika metode tidak dikenal, beri tahu Flutter
        result(FlutterMethodNotImplemented)
      }
    }
  }
  ```

  **5. `my_device_info/pubspec.yaml` (Metadata Plugin):**

  ```yaml
  name: my_device_info
  description: Plugin Flutter untuk mendapatkan informasi dasar perangkat.
  version: 0.0.1
  homepage: https://example.com/my_device_info

  environment:
    sdk: ">=3.0.0 <4.0.0"
    flutter: ">=3.0.0"

  dependencies:
    flutter:
      sdk: flutter

  dev_dependencies:
    flutter_test:
      sdk: flutter
    flutter_lints: ^2.0.0

  # Bagian penting untuk deklarasi plugin
  flutter:
    plugin:
      platforms:
        android:
          package: com.example.my_device_info # Nama package Android
          pluginClass: MyDeviceInfoPlugin # Nama kelas plugin Android
        ios:
          pluginClass: MyDeviceInfoPlugin # Nama kelas plugin iOS
  ```

- **Visualisasi Konseptual: Plugin Structure**

  ```mermaid
  graph TD
      A[Flutter Application (Uses Plugin)] -- Imports --> B[Dart API (lib/my_device_info.dart)];
      B -- Communicates via MethodChannel --> C[Flutter Engine];

      subgraph Plugin Package
          D[lib/my_device_info.dart]
          E[android/src/main/.../MyDeviceInfoPlugin.kt]
          F[ios/Classes/MyDeviceInfoPlugin.swift]
          G[pubspec.yaml]
          H[example/ (Flutter App)]
          D -- Contains --> C;
          E -- Implements Native Logic --> C;
          F -- Implements Native Logic --> C;
          G -- Defines Plugin Metadata --> E;
          G -- Defines Plugin Metadata --> F;
      end

      C -- Calls Native Code --> E;
      C -- Calls Native Code --> F;
      E -- Returns Result --> C;
      F -- Returns Result --> C;
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan struktur _plugin_ Flutter. Aplikasi Flutter menggunakan API Dart dari _plugin_. API Dart ini berkomunikasi dengan Flutter _engine_ melalui _MethodChannel_ (atau _EventChannel_), yang kemudian memanggil implementasi _native_ (Kotlin/Java untuk Android, Swift/Objective-C untuk iOS) yang berada dalam struktur _package_ _plugin_. Berkas `pubspec.yaml` mendefinisikan bagaimana _plugin_ dikonfigurasi untuk setiap _platform_. Direktori `example/` berisi aplikasi Flutter yang mendemonstrasikan penggunaan _plugin_.

---

###### **Developing Flutter Plugins**

- **Sumber Daya Utama:** Dokumentasi resmi Flutter tentang pengembangan _plugin_ adalah panduan terbaik.
  - [Developing Flutter Plugins](https://docs.flutter.dev/platform-integration/platform-channels/plugins) (Dokumentasi resmi Flutter)
  - [Plugin Best Practices](https://docs.flutter.dev/platform-integration/platform-channels/plugins%23best-practices) (Dokumentasi resmi Flutter)

---

###### **Federated Plugin Architecture**

- **Peran:** Untuk _plugin_ yang kompleks atau yang mendukung banyak _platform_ (Android, iOS, _web_, _desktop_), arsitektur _federated plugin_ adalah praktik terbaik. Ini memisahkan API _platform_ independen (Dart) dari implementasi spesifik _platform_.

- **Struktur:**

  - **`your_plugin_name` (Package Utama):** Berisi API Dart yang menghadap ke pengguna. Ini akan memiliki dependensi pada `your_plugin_name_platform_interface` dan `your_plugin_name_web` (jika ada _web_), `your_plugin_name_android`, `your_plugin_name_ios`, dll. Ini adalah _package_ yang akan diimpor dan digunakan oleh aplikasi.
  - **`your_plugin_name_platform_interface`:**
    - Berisi definisi _interface_ Dart abstrak (kelas abstrak) yang mendefinisikan API yang harus diimplementasikan oleh setiap _platform_. Ini memastikan semua implementasi _platform_ memiliki kontrak yang sama.
    - Tidak memiliki kode _native_ dan tidak bergantung pada _package_ `flutter`.
  - **`your_plugin_name_android`:** Implementasi spesifik Android dari _interface_ yang didefinisikan dalam `your_plugin_name_platform_interface`. Bergantung pada `your_plugin_name_platform_interface`.
  - **`your_plugin_name_ios`:** Implementasi spesifik iOS dari _interface_. Bergantung pada `your_plugin_name_platform_interface`.
  - **`your_plugin_name_web`:** Implementasi spesifik _web_ dari _interface_. Bergantung pada `your_plugin_name_platform_interface`.
  - **`your_plugin_name_macos`**, **`your_plugin_name_windows`**, **`your_plugin_name_linux`:** Implementasi untuk _platform_ _desktop_ masing-masing.

- **Manfaat:**

  - **Modularitas:** Memungkinkan pengembangan dan pengujian implementasi _platform_ secara independen.
  - **Skalabilitas:** Memudahkan penambahan dukungan untuk _platform_ baru tanpa memengaruhi kode yang ada.
  - **Maintainability:** Mengurangi _bug_ karena API _platform_ konsisten.
  - **Pengembang dapat memilih implementasi:** Jika ada beberapa implementasi untuk satu _platform_ (misalnya, dua versi implementasi Android), pengguna dapat memilih mana yang akan digunakan.

- **Contoh Penerapan (Konseptual):**

  - API utama (di `your_plugin_name`):

    ```dart
    // lib/your_plugin_name.dart
    import 'package:your_plugin_name_platform_interface/your_plugin_name_platform_interface.dart';

    class YourPluginName {
      static YourPluginNamePlatform get _platform {
        return YourPluginNamePlatform.instance;
      }

      Future<String?> getPlatformVersion() {
        return _platform.getPlatformVersion();
      }
    }
    ```

  - Platform Interface (di `your_plugin_name_platform_interface`):

    ```dart
    // lib/your_plugin_name_platform_interface.dart
    import 'package:plugin_platform_interface/plugin_platform_interface.dart';

    abstract class YourPluginNamePlatform extends PlatformInterface {
      YourPluginNamePlatform() : super(token: _token);

      static final Object _token = Object();

      static YourPluginNamePlatform _instance = _MethodChannelYourPluginName(); // Default implementation

      static YourPluginNamePlatform get instance => _instance;

      static set instance(YourPluginNamePlatform instance) {
        PlatformInterface.verifyToken(instance, _token);
        _instance = instance;
      }

      Future<String?> getPlatformVersion() {
        throw UnimplementedError('getPlatformVersion() has not been implemented.');
      }
    }

    // Default MethodChannel implementation (seringkali di package implementasi sendiri)
    class _MethodChannelYourPluginName extends YourPluginNamePlatform {
      static const MethodChannel _methodChannel = MethodChannel('your_plugin_name');

      @override
      Future<String?> getPlatformVersion() async {
        final version = await _methodChannel.invokeMethod<String>('getPlatformVersion');
        return version;
      }
    }
    ```

  - Implementasi Android (di `your_plugin_name_android`):

    ```dart
    // lib/your_plugin_name_android.dart
    import 'package:flutter/services.dart';
    import 'package:your_plugin_name_platform_interface/your_plugin_name_platform_interface.dart';

    class YourPluginNameAndroid extends YourPluginNamePlatform {
      // Set instance to this implementation
      static void registerWith() {
        YourPluginNamePlatform.instance = YourPluginNameAndroid();
      }

      final MethodChannel _methodChannel = const MethodChannel('your_plugin_name');

      @override
      Future<String?> getPlatformVersion() async {
        return await _methodChannel.invokeMethod<String>('getPlatformVersion');
      }
    }
    ```

    (Dan kemudian implementasi Kotlin/Java sebenarnya ada di folder `android/` dari _package_ `your_plugin_name_android`).

- **Web Platform Support & Desktop Platform Support:**

  - Untuk _web_, implementasi _plugin_ akan menggunakan API JavaScript _browser_.
  - Untuk _desktop_ (Windows, macOS, Linux), implementasi akan menggunakan API _native_ C++ (Windows), Objective-C/Swift (macOS), atau C++/GTK (Linux).
  - Arsitektur _federated plugin_ sangat ideal untuk mengelola kompleksitas yang datang dengan mendukung begitu banyak _platform_.

- **Sumber Daya Tambahan:**

  - [Federated Plugins](https://docs.flutter.dev/platform-integration/platform-channels/federated-plugins) (Dokumentasi resmi Flutter)

---

Dengan ini, kita telah menyelesaikan seluruh topik **13. Platform Channels & Native Integration**! Ini adalah salah satu area paling canggih dalam pengembangan Flutter, memungkinkan Anda untuk memperluas kemampuan aplikasi Anda di luar batas _framework_ inti. Selanjutnya, kita akan masuk ke **14. Device Features Integration**, di mana kita akan melihat bagaimana _plugin_ yang sudah ada (bukan yang kita buat sendiri) digunakan untuk mengakses fitur-fitur umum perangkat seperti kamera, media, sensor, dan biometrik.

#### **14. Device Features Integration**

- **Peran:** Setelah kita memahami bagaimana Flutter berinteraksi dengan kode _native_ melalui _Platform Channels_ dan _plugin_ kustom, sekarang kita akan melihat bagaimana _plugin_ yang sudah ada digunakan untuk mengakses fitur-fitur perangkat keras dan sistem yang umum. Ini memungkinkan aplikasi Flutter Anda untuk memanfaatkan kemampuan penuh _smartphone_, seperti kamera, GPS, sensor, dan banyak lagi.

---

##### **14.1 Camera & Media**

- **Peran:** Kemampuan untuk berinteraksi dengan kamera perangkat dan memproses media (gambar, video, audio) adalah fitur inti bagi banyak aplikasi modern. Flutter menyediakan _plugin_ resmi dan komunitas yang kuat untuk mencapai fungsionalitas ini dengan mudah di berbagai _platform_.

---

###### **Camera Integration**

- **Peran:** Mengakses kamera perangkat adalah fungsionalitas umum di banyak aplikasi, mulai dari aplikasi media sosial hingga _utility_. _Plugin_ `camera` resmi Flutter menyediakan API yang komprehensif untuk mengontrol kamera.

- **Prasyarat:**

  - **Tambahkan dependensi:** Di `pubspec.yaml`, tambahkan _package_ `camera`:
    ```yaml
    dependencies:
      camera: ^latest_version # Ganti dengan versi terbaru
      path_provider: ^latest_version # Untuk menyimpan gambar/video
    ```
  - **Konfigurasi Native:**
    - **Android:** Tambahkan izin kamera di `android/app/src/main/AndroidManifest.xml` di dalam tag `<manifest>`:
      ```xml
      <uses-permission android:name="android.permission.CAMERA" />
      <uses-permission android:name="android.permission.RECORD_AUDIO" /> <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="28" /> <uses-feature android:name="android.hardware.camera" android:required="false" />
      <uses-feature android:name="android.hardware.camera.autofocus" android:required="false" />
      ```
    - **iOS:** Tambahkan deskripsi penggunaan kamera dan mikrofon di `ios/Runner/Info.plist`:
      ```xml
      <key>NSCameraUsageDescription</key>
      <string>Aplikasi ini membutuhkan akses kamera untuk mengambil foto/video.</string>
      <key>NSMicrophoneUsageDescription</key>
      <string>Aplikasi ini membutuhkan akses mikrofon untuk merekam audio dengan video.</string>
      ```
      `Info.plist` adalah berkas konfigurasi kunci-nilai untuk aplikasi iOS. `NSCameraUsageDescription` dan `NSMicrophoneUsageDescription` adalah kunci standar yang, ketika diisi dengan string, akan menampilkan pesan kepada pengguna saat aplikasi meminta izin untuk mengakses kamera atau mikrofon.

- **Camera Controller Setup:**

  - **Mekanisme:** Anda perlu menginisialisasi `CameraController` dengan `CameraDescription` (yang mewakili kamera tertentu di perangkat, seperti kamera depan atau belakang). `CameraController` bertanggung jawab untuk mengelola _lifecycle_ kamera, _preview_, dan operasi pengambilan.
  - **Langkah-langkah:**
    1.  Dapatkan daftar kamera yang tersedia menggunakan `await availableCameras()`.
    2.  Pilih kamera yang ingin Anda gunakan (`CameraDescription`).
    3.  Buat _instance_ `CameraController`, tentukan resolusi, dan inisialisasi.
    4.  Gunakan `controller.initialize()` dan tunggu hingga selesai.
    5.  Tampilkan _preview_ kamera menggunakan `CameraPreview` _widget_.

- **Photo Capture dan Video Recording:**

  - **Photo Capture:** Setelah _controller_ diinisialisasi, Anda dapat memanggil `controller.takePicture()` yang akan mengembalikan `XFile` yang berisi _path_ ke gambar yang diambil.
  - **Video Recording:** Gunakan `controller.startVideoRecording()` untuk memulai dan `controller.stopVideoRecording()` untuk menghentikan rekaman. Ini juga akan mengembalikan `XFile` untuk berkas video.

- **Camera Preview Customization:**

  - **Mekanisme:** _Widget_ `CameraPreview` secara otomatis menampilkan _feed_ kamera. Anda dapat menyesuaikannya dengan membungkusnya dalam _widget_ lain seperti `AspectRatio`, `FittedBox`, atau `ClipRRect` untuk mengontrol ukuran, rasio aspek, dan bentuk _preview_.
  - **Orientasi:** `CameraPreview` akan secara otomatis menyesuaikan orientasinya. Anda dapat mengontrol `previewSize` atau `previewFormat` jika diperlukan.

- **Multiple Camera Support:**

  - **Mekanisme:** `availableCameras()` mengembalikan daftar semua kamera yang tersedia (depan, belakang, eksternal jika ada). Anda dapat memilih kamera mana pun dari daftar ini untuk diinisialisasi.
  - **Pengalihan Kamera:** Untuk beralih kamera, Anda perlu membuang `CameraController` yang ada, memilih `CameraDescription` baru, dan menginisialisasi `CameraController` baru.

- **Camera Permissions Handling:**

  - **Peran:** Sebelum mengakses kamera, Anda harus meminta izin dari pengguna. Jika izin ditolak, aplikasi Anda harus memberikan _feedback_ yang sesuai.
  - **Mekanisme:** Gunakan _plugin_ seperti `permission_handler` (meskipun `camera` _plugin_ seringkali memiliki penanganan izin bawaan) untuk memeriksa dan meminta izin kamera dan mikrofon.

- **Contoh Kode (Camera Integration):**

  ```dart
  import 'package:flutter/material.dart';
  import 'package:camera/camera.dart'; // Import package camera
  import 'package:path_provider/path_provider.dart'; // Untuk mendapatkan direktori penyimpanan
  import 'dart:io'; // Untuk File

  // Variabel global untuk menyimpan daftar kamera yang tersedia
  List<CameraDescription> cameras = [];

  Future<void> main() async {
    // Pastikan binding Flutter sudah diinisialisasi
    WidgetsFlutterBinding.ensureInitialized();
    // Dapatkan daftar kamera yang tersedia di perangkat
    cameras = await availableCameras();
    runApp(const CameraApp());
  }

  class CameraApp extends StatelessWidget {
    const CameraApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Camera App',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          useMaterial3: true,
        ),
        home: const CameraScreen(),
      );
    }
  }

  class CameraScreen extends StatefulWidget {
    const CameraScreen({super.key});

    @override
    State<CameraScreen> createState() => _CameraScreenState();
  }

  class _CameraScreenState extends State<CameraScreen> {
    CameraController? _controller; // Controller untuk kamera
    Future<void>? _initializeControllerFuture; // Future untuk inisialisasi controller
    bool _isRecording = false; // Status rekaman video

    @override
    void initState() {
      super.initState();
      // Inisialisasi kamera pertama yang ditemukan (biasanya kamera belakang)
      if (cameras.isNotEmpty) {
        _initializeCamera(cameras[0]);
      }
    }

    Future<void> _initializeCamera(CameraDescription cameraDescription) async {
      _controller = CameraController(
        cameraDescription, // Kamera yang dipilih
        ResolutionPreset.medium, // Resolusi preview
        enableAudio: true, // Aktifkan audio untuk perekaman video
      );

      // Inisialisasi controller dan simpan Future-nya
      _initializeControllerFuture = _controller?.initialize();

      // Perbarui UI setelah controller diinisialisasi atau jika ada error
      if (mounted) {
        setState(() {});
      }
    }

    @override
    void dispose() {
      // Buang controller saat widget tidak lagi digunakan untuk mencegah kebocoran memori
      _controller?.dispose();
      super.dispose();
    }

    // Fungsi untuk mengambil gambar
    Future<void> _takePicture() async {
      try {
        // Pastikan controller sudah diinisialisasi sebelum mengambil gambar
        await _initializeControllerFuture;

        final XFile file = await _controller!.takePicture(); // Ambil gambar

        // Tampilkan gambar yang diambil
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gambar disimpan ke: ${file.path}')),
        );

        // Anda bisa menavigasi ke halaman tampilan gambar atau menyimpannya
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DisplayPictureScreen(imagePath: file.path),
        //   ),
        // );
      } catch (e) {
        print(e);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil gambar: $e')),
        );
      }
    }

    // Fungsi untuk memulai/menghentikan rekaman video
    Future<void> _recordVideo() async {
      if (!_controller!.value.isInitialized) {
        return;
      }

      if (_isRecording) {
        // Hentikan rekaman
        try {
          final XFile file = await _controller!.stopVideoRecording();
          setState(() {
            _isRecording = false;
          });
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Video disimpan ke: ${file.path}')),
          );
          print('Video saved to: ${file.path}');
        } catch (e) {
          print(e);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghentikan rekaman video: $e')),
          );
        }
      } else {
        // Mulai rekaman
        try {
          await _controller!.startVideoRecording();
          setState(() {
            _isRecording = true;
          });
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mulai merekam video...')),
          );
        } catch (e) {
          print(e);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memulai rekaman video: $e')),
          );
        }
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Camera Integration')),
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // Jika CameraController sudah diinisialisasi
              if (_controller!.value.isInitialized) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // CameraPreview untuk menampilkan feed kamera
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: CameraPreview(_controller!),
                    ),
                    // Overlay tombol
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FloatingActionButton(
                            heroTag: 'takePicture', // Penting jika ada beberapa FAB
                            onPressed: _takePicture,
                            child: const Icon(Icons.camera_alt),
                          ),
                          FloatingActionButton(
                            heroTag: 'recordVideo',
                            onPressed: _recordVideo,
                            backgroundColor: _isRecording ? Colors.red : Colors.blue,
                            child: Icon(_isRecording ? Icons.stop : Icons.videocam),
                          ),
                          // Tombol untuk beralih kamera (jika ada lebih dari satu)
                          if (cameras.length > 1)
                            FloatingActionButton(
                              heroTag: 'switchCamera',
                              onPressed: () {
                                // Temukan kamera aktif saat ini dan beralih ke yang lain
                                final CameraDescription currentCamera = _controller!.description;
                                final int currentCameraIndex = cameras.indexOf(currentCamera);
                                final int nextCameraIndex = (currentCameraIndex + 1) % cameras.length;
                                _initializeCamera(cameras[nextCameraIndex]);
                              },
                              child: const Icon(Icons.switch_camera),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text('Kamera tidak dapat diinisialisasi.'));
              }
            } else {
              // Tampilkan loading spinner saat menunggu inisialisasi
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      );
    }
  }
  ```

- **Visualisasi Konseptual: Camera Plugin Workflow**

  ```mermaid
  graph TD
      A[Flutter App (Dart)] -- 1. availableCameras() --> B[Camera Plugin];
      B -- 2. Get Camera List --> A;
      A -- 3. CameraController(cameraDesc).initialize() --> B;
      B -- 4. Init Camera Hardware & Preview Stream --> A;
      A -- 5. Display CameraPreview --> C[Device Screen];
      A -- 6. controller.takePicture()/startVideoRecording() --> B;
      B -- 7. Capture Image/Video --> D[Native Camera API];
      D -- 8. Save File --> E[Device Storage];
      E -- 9. Return XFile Path --> B;
      B -- 10. Return XFile Path --> A;
  ```

  **Penjelasan Visual:**
  Diagram ini mengilustrasikan alur kerja integrasi kamera di Flutter. Aplikasi Flutter meminta daftar kamera yang tersedia, menginisialisasi `CameraController`, dan menampilkan _preview_. Ketika pengguna memicu pengambilan gambar atau video, `CameraController` memanggil API kamera _native_, yang menangani pengambilan dan penyimpanan berkas ke penyimpanan perangkat. _Path_ berkas kemudian dikembalikan ke aplikasi Flutter.

- **Sumber Daya Tambahan:**

  - [Camera Plugin](https://pub.dev/packages/camera) (Dokumentasi resmi _plugin_ `camera`)
  - [Image Picker](https://pub.dev/packages/image_picker) (Untuk memilih gambar/video dari galeri, sering digunakan bersamaan dengan kamera)
  - [Camera Advanced Usage](https://docs.flutter.dev/cookbook/plugins/retrieve-display-videos) (Contoh-contoh lanjutan dari dokumentasi Flutter)

---

###### **Media Processing**

- **Peran:** Setelah media (gambar, video, audio) ditangkap atau dipilih, seringkali ada kebutuhan untuk memprosesnya—mengedit, mengompres, memutar, atau menghasilkan _thumbnail_. Flutter, melalui berbagai _plugin_ dan pendekatan, memungkinkan Anda untuk melakukan operasi ini.

- **Image Editing dan Filters:**

  - **Mekanisme:** Meskipun Flutter tidak memiliki _framework_ pengeditan gambar bawaan yang kompleks, ada _plugin_ yang memungkinkan Anda menerapkan filter, memotong, memutar, atau bahkan menggambar di atas gambar.
  - **Contoh Plugin:** `image_editor_plus`, `image`.

- **Video Processing:**

  - **Mekanisme:** Mirip dengan gambar, pemrosesan video (misalnya, _trimming_, _transcoding_, penambahan _watermark_) biasanya memerlukan _plugin_ yang mengintegrasikan dengan pustaka _native_ yang kuat seperti FFmpeg.
  - **Contoh Plugin:** `video_trimmer`, `ffmpeg_kit_flutter`.

- **Audio Recording dan Playback:**

  - **Mekanisme:** Untuk merekam audio, Anda memerlukan _plugin_ yang mengakses mikrofon perangkat. Untuk pemutaran audio, Anda dapat memutar berkas audio lokal atau dari _URL_.
  - **Contoh Plugin:**
    - **Recording:** `record`, `flutter_sound`.
    - **Playback:** `audioplayers`, `just_audio`.

- **Media Compression:**

  - **Peran:** Mengurangi ukuran berkas media (gambar atau video) untuk menghemat ruang penyimpanan atau bandwidth jaringan.
  - **Mekanisme:** _Plugin_ tertentu menawarkan kompresi gambar (misalnya, mengubah kualitas JPEG) atau video (misalnya, mengurangi resolusi, _bitrate_).
  - **Contoh Plugin:** `flutter_image_compress`, `video_compress`.

- **Thumbnail Generation:**

  - **Peran:** Membuat gambar _thumbnail_ kecil dari gambar atau berkas video yang lebih besar. Ini umum untuk tampilan daftar atau _preview_.
  - **Mekanisme:** Beberapa _plugin_ dapat mengekstrak _frame_ dari video sebagai gambar, atau menghasilkan _thumbnail_ dari gambar resolusi tinggi.
  - **Contoh Plugin:** `video_thumbnail`, `image_picker` (juga dapat mengembalikan _thumbnail_).

- **Sumber Daya Tambahan (Plugin yang Direkomendasikan):**

  - [Image Editor](https://pub.dev/packages/image_editor_plus) (Contoh _plugin_ pengeditan gambar)
  - [Video Player](https://pub.dev/packages/video_player) (Untuk memutar video)
  - [Audio Players](https://pub.dev/packages/audioplayers) (Untuk memutar berbagai format audio)

---

Dengan ini, kita telah mencakup integrasi kamera dan berbagai aspek pemrosesan medi pada sub-bagian **14.1 Camera & Media**.Selanjutnya, kita akan menjelajahi aplikasi Flutter dapat berinteraksi dengan sensor dan fitur perangkat keras lainnya seperti GPS, _Bluetooth_, dan Wi-Fi.

---

##### **14.2 Sensors & Hardware**

- **Peran:** Perangkat _smartphone_ modern dilengkapi dengan berbagai sensor dan kemampuan perangkat keras yang memungkinkan aplikasi berinteraksi dengan lingkungan fisik dan jaringan. Mengintegrasikan sensor-sensor ini membuka peluang untuk aplikasi yang lebih imersif dan kontekstual, seperti aplikasi kebugaran, navigasi, atau otomasi.

---

###### **Device Sensors**

- **Peran:** Sensor perangkat memberikan data mentah tentang gerakan, orientasi, lokasi geografis, dan kondisi lingkungan. Flutter tidak memiliki API sensor bawaan, tetapi _plugin_ komunitas menyediakan akses mudah ke data ini.

- **Accelerometer dan Gyroscope:**

  - **Peran:**
    - **Accelerometer:** Mengukur percepatan linear (termasuk gravitasi) di sepanjang tiga sumbu (X, Y, Z). Digunakan untuk mendeteksi kemiringan, goyangan, dan gerakan perangkat.
    - **Gyroscope:** Mengukur kecepatan sudut rotasi perangkat di sekitar tiga sumbu. Digunakan untuk mendeteksi orientasi yang lebih presisi dan gerakan berputar.
  - **Mekanisme:** _Plugin_ seperti `sensors_plus` mengekspos _stream_ yang dapat Anda langganan untuk menerima pembaruan data sensor secara _real-time_.

- **GPS Location Services:**

  - **Peran:** Mengakses lokasi geografis perangkat (lintang, bujur, ketinggian, kecepatan, arah) menggunakan GPS, Wi-Fi, dan _cell tower triangulation_. Penting untuk aplikasi berbasis lokasi seperti navigasi, _ride-sharing_, atau pelacakan.
  - **Mekanisme:** _Plugin_ `geolocator` menyediakan API untuk mendapatkan lokasi sekali jalan atau berlangganan pembaruan lokasi berkelanjutan.

- **Proximity Sensor:**

  - **Peran:** Mendeteksi kedekatan objek ke layar perangkat, seringkali digunakan untuk mematikan layar saat melakukan panggilan telepon atau mengaktifkan fitur tertentu saat perangkat dekat dengan wajah.
  - **Mekanisme:** _Plugin_ `sensors_plus` atau _plugin_ khusus _proximity sensor_ dapat menyediakan _stream_ data kedekatan.

- **Light Sensor:**

  - **Peran:** Mengukur tingkat cahaya sekitar (iluminasi) di lingkungan perangkat. Dapat digunakan untuk secara otomatis menyesuaikan kecerahan layar atau mengaktifkan mode gelap/terang.
  - **Mekanisme:** _Plugin_ `sensors_plus` dapat mengekspos data _ambient light_.

- **Compass Integration:**

  - **Peran:** Memberikan informasi tentang arah perangkat relatif terhadap kutub magnetik bumi. Digunakan dalam aplikasi kompas atau realitas tertambah (AR).
  - **Mekanisme:** Data kompas seringkali berasal dari kombinasi _magnetometer_ dan _accelerometer_. _Plugin_ seperti `flutter_compass` atau `geolocator` (yang dapat memberikan arah) menyediakan fungsionalitas ini.

- **Prasyarat (Izin Native untuk Sensor):**

  - **Android:** Tambahkan izin di `android/app/src/main/AndroidManifest.xml`:
    - **Lokasi:**
      ```xml
      <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
      <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
      <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
      ```
      Untuk Android 10 (API 29) ke atas, Anda perlu meminta izin lokasi di latar belakang secara terpisah jika aplikasi Anda perlu mengakses lokasi saat tidak digunakan secara aktif.
    - Sensor lain seperti akselerometer, giroskop, dll., biasanya tidak memerlukan izin eksplisit dalam manifes, tetapi akses ke data mereka mungkin terbatas atau memerlukan izin _runtime_ jika dianggap sensitif oleh sistem (misalnya, sensor `BODY_SENSORS`).
  - **iOS:** Tambahkan deskripsi penggunaan di `ios/Runner/Info.plist`:
    - **Lokasi:**
      ```xml
      <key>NSLocationWhenInUseUsageDescription</key>
      <string>Aplikasi ini membutuhkan akses lokasi untuk menunjukkan posisi Anda.</string>
      <key>NSLocationAlwaysAndWhenInUseUsageDescription</key> <string>Aplikasi ini membutuhkan akses lokasi untuk melacak posisi Anda bahkan saat aplikasi ditutup.</string>
      ```

- **Contoh Kode (Sensor: Accelerometer & GPS):**

  ```dart
  import 'package:flutter/material.dart';
  import 'package:sensors_plus/sensors_plus.dart'; // Import sensors_plus
  import 'package:geolocator/geolocator.dart'; // Import geolocator
  import 'dart:async'; // Untuk StreamSubscription

  void main() {
    runApp(const SensorApp());
  }

  class SensorApp extends StatelessWidget {
    const SensorApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Sensor & GPS Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),
        home: const SensorScreen(),
      );
    }
  }

  class SensorScreen extends StatefulWidget {
    const SensorScreen({super.key});

    @override
    State<SensorScreen> createState() => _SensorScreenState();
  }

  class _SensorScreenState extends State<SensorScreen> {
    // Stream subscriptions untuk sensor
    StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
    StreamSubscription<Position>? _positionSubscription;

    // Data sensor
    AccelerometerEvent? _accelerometerEvent;
    Position? _currentPosition;
    String _locationError = '';

    @override
    void initState() {
      super.initState();
      _listenToAccelerometer();
      _listenToLocation();
    }

    @override
    void dispose() {
      // Pastikan untuk membatalkan langganan saat widget dibuang
      _accelerometerSubscription?.cancel();
      _positionSubscription?.cancel();
      super.dispose();
    }

    // Mendengarkan data Accelerometer
    void _listenToAccelerometer() {
      _accelerometerSubscription = accelerometerEventStream().listen((event) {
        setState(() {
          _accelerometerEvent = event;
        });
      });
    }

    // Mendengarkan data Lokasi GPS
    Future<void> _listenToLocation() async {
      bool serviceEnabled;
      LocationPermission permission;

      // Cek apakah layanan lokasi diaktifkan
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Layanan lokasi dinonaktifkan. Harap aktifkan.';
        });
        return;
      }

      // Cek izin lokasi
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = 'Izin lokasi ditolak. Tidak dapat mengakses lokasi.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = 'Izin lokasi ditolak secara permanen. Silakan ubah di pengaturan aplikasi.';
        });
        return;
      }

      // Jika semua OK, mulai mendengarkan pembaruan lokasi
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10, // Perbarui hanya jika posisi berubah 10 meter
        ),
      ).listen((Position position) {
        setState(() {
          _currentPosition = position;
          _locationError = ''; // Hapus error jika berhasil
        });
      }, onError: (e) {
        setState(() {
          _locationError = 'Error mendapatkan lokasi: ${e.toString()}';
        });
        print('Location Error: $e');
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sensors & GPS Integration')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Accelerometer Data:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text('X: ${_accelerometerEvent?.x.toStringAsFixed(2) ?? 'N/A'}'),
              Text('Y: ${_accelerometerEvent?.y.toStringAsFixed(2) ?? 'N/A'}'),
              Text('Z: ${_accelerometerEvent?.z.toStringAsFixed(2) ?? 'N/A'}'),
              const Divider(height: 40),
              Text(
                'GPS Location Data:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (_locationError.isNotEmpty)
                Text(
                  'Error: $_locationError',
                  style: const TextStyle(color: Colors.red),
                )
              else if (_currentPosition == null)
                const Text('Mencari lokasi...')
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Latitude: ${_currentPosition!.latitude.toStringAsFixed(6)}'),
                    Text('Longitude: ${_currentPosition!.longitude.toStringAsFixed(6)}'),
                    Text('Accuracy: ${_currentPosition!.accuracy.toStringAsFixed(2)}m'),
                    Text('Altitude: ${_currentPosition!.altitude.toStringAsFixed(2)}m'),
                    Text('Speed: ${_currentPosition!.speed.toStringAsFixed(2)}m/s'),
                  ],
                ),
              const SizedBox(height: 30),
              const Text(
                'Catatan: Untuk menjalankan contoh ini, pastikan Anda telah menambahkan `sensors_plus` dan `geolocator` ke `pubspec.yaml`, serta mengkonfigurasi izin lokasi di `AndroidManifest.xml` (Android) dan `Info.plist` (iOS). Anda perlu menjalankan ini di perangkat fisik atau emulator dengan sensor yang didukung.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

- **Sumber Daya Tambahan:**

  - [Sensors Plus](https://pub.dev/packages/sensors_plus) (Untuk sensor gerak dan lingkungan)
  - [Geolocator](https://pub.dev/packages/geolocator) (Untuk layanan lokasi GPS)
  - [Location Permissions](https://www.google.com/search?q=https://docs.flutter.dev/platform-integration/platform-channels/plugins%23permissions) (Panduan izin lokasi di dokumentasi Flutter)

---

###### **Connectivity Features**

- **Peran:** Fitur konektivitas memungkinkan aplikasi Anda berinteraksi dengan perangkat lain atau layanan jaringan melalui teknologi seperti _Bluetooth_, Wi-Fi, dan NFC, serta memantau status koneksi internet.

- **Bluetooth Integration:**

  - **Peran:** Memungkinkan aplikasi untuk memindai, terhubung, dan berkomunikasi dengan perangkat _Bluetooth_ lain (misalnya, _headphone_, perangkat IoT, _wearables_). Ini bisa berupa _Bluetooth_ Klasik atau _Bluetooth Low Energy_ (BLE).
  - **Mekanisme:** _Plugin_ `flutter_blue_plus` (untuk BLE) atau `flutter_bluetooth_serial` (untuk _Bluetooth_ Klasik) menyediakan API untuk mengelola _adapter Bluetooth_, memindai perangkat, membuat koneksi, dan mengirim/menerima data.
  - **Prasyarat (Izin Native Bluetooth):**
    - **Android (API 30+):**
      ```xml
      <uses-permission android:name="android.permission.BLUETOOTH_SCAN" android:usesPermissionFlags="neverForLocation" />
      <uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />
      <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
      <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
      ```
    - **iOS:**
      ```xml
      <key>NSBluetoothPeripheralUsageDescription</key>
      <string>Aplikasi ini membutuhkan akses Bluetooth untuk terhubung dengan perangkat eksternal.</string>
      ```

- **WiFi Management:**

  - **Peran:** Mengelola koneksi Wi-Fi perangkat, seperti mendapatkan informasi SSID, BSSID, kekuatan sinyal, atau bahkan terhubung ke jaringan Wi-Fi tertentu.
  - **Mekanisme:** _Plugin_ seperti `wifi_info_flutter` atau `connectivity_plus` (untuk informasi Wi-Fi dasar) menyediakan fungsionalitas ini.
  - **Prasyarat (Izin Native Wi-Fi):**
    - **Android:**
      ````xml
      <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
      <uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />
      <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" /> ```
      ````
    - **iOS:** Umumnya tidak memerlukan izin khusus di `Info.plist` untuk mendapatkan informasi Wi-Fi dasar, tetapi akses penuh ke manajemen Wi-Fi mungkin terbatas.

- **NFC Communication:**

  - **Peran:** Memungkinkan aplikasi membaca dan menulis tag NFC (_Near Field Communication_) atau berkomunikasi dengan perangkat NFC lain yang berdekatan. Digunakan untuk pembayaran _contactless_, _ticketing_, atau berbagi data.
  - **Mekanisme:** _Plugin_ seperti `nfc_manager` atau `ndef`.
  - **Prasyarat (Izin Native NFC):**
    - **Android:**
      ```xml
      <uses-permission android:name="android.permission.NFC" />
      <uses-feature android:name="android.hardware.nfc" android:required="true" />
      ```
    - **iOS:**
      - Aktifkan kemampuan NFC di Xcode (`Signing & Capabilities` -\> `+ Capability` -\> `Near Field Communication Tag Reading`).
      - Tambahkan `NFCReaderUsageDescription` di `Info.plist`.
      - Daftarkan _schemes_ URL Universal Links yang terkait dengan jenis tag NFC yang akan Anda baca.

- **Network Connectivity Monitoring:**

  - **Peran:** Memantau status koneksi internet perangkat secara _real-time_ (terhubung/tidak terhubung, jenis koneksi: Wi-Fi, _mobile data_, _ethernet_). Penting untuk aplikasi yang perlu menyesuaikan perilakunya berdasarkan ketersediaan jaringan.
  - **Mekanisme:** _Plugin_ `connectivity_plus` menyediakan _stream_ perubahan status konektivitas.

- **Contoh Kode (Connectivity: Network Monitoring):**

  ```dart
  import 'package:flutter/material.dart';
  import 'package:connectivity_plus/connectivity_plus.dart'; // Import connectivity_plus
  import 'dart:async'; // Untuk StreamSubscription

  void main() {
    runApp(const ConnectivityApp());
  }

  class ConnectivityApp extends StatelessWidget {
    const ConnectivityApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Connectivity Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
        ),
        home: const ConnectivityScreen(),
      );
    }
  }

  class ConnectivityScreen extends StatefulWidget {
    const ConnectivityScreen({super.key});

    @override
    State<ConnectivityScreen> createState() => _ConnectivityScreenState();
  }

  class _ConnectivityScreenState extends State<ConnectivityScreen> {
    ConnectivityResult _connectivityResult = ConnectivityResult.none;
    late StreamSubscription<ConnectivityResult> _connectivitySubscription;

    @override
    void initState() {
      super.initState();
      // Inisialisasi status konektivitas awal
      _initConnectivity();
      // Langganan pembaruan status konektivitas
      _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    }

    @override
    void dispose() {
      // Batalkan langganan saat widget dibuang
      _connectivitySubscription.cancel();
      super.dispose();
    }

    Future<void> _initConnectivity() async {
      late ConnectivityResult result;
      try {
        result = await Connectivity().checkConnectivity();
      } on PlatformException catch (e) {
        print('Couldn\'t check connectivity status: $e');
        result = ConnectivityResult.none;
      }

      if (!mounted) {
        return Future.value();
      }

      return _updateConnectionStatus(result);
    }

    Future<void> _updateConnectionStatus(ConnectivityResult result) async {
      setState(() {
        _connectivityResult = result;
      });
    }

    String _getConnectionType(ConnectivityResult result) {
      switch (result) {
        case ConnectivityResult.wifi:
          return 'Wi-Fi';
        case ConnectivityResult.mobile:
          return 'Mobile Data';
        case ConnectivityResult.ethernet:
          return 'Ethernet';
        case ConnectivityResult.bluetooth:
          return 'Bluetooth'; // Koneksi melalui Bluetooth tethering
        case ConnectivityResult.none:
          return 'No Connection';
        case ConnectivityResult.vpn:
          return 'VPN'; // Saat ini hanya tersedia di Android dan iOS 14+
        case ConnectivityResult.other:
          return 'Other'; // Untuk kasus yang tidak tercakup
        default:
          return 'Unknown';
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Connectivity Features')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Current Network Status:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                _getConnectionType(_connectivityResult),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: _connectivityResult == ConnectivityResult.none ? Colors.red : Colors.green,
                ),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Aplikasi ini memantau status koneksi internet perangkat secara real-time. Putuskan atau sambungkan Wi-Fi/Mobile Data Anda untuk melihat perubahan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Catatan: Pastikan Anda telah menambahkan `connectivity_plus` ke `pubspec.yaml` untuk menjalankan contoh ini.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

- **Sumber Daya Tambahan:**

  - [Flutter Bluetooth Serial](https://pub.dev/packages/flutter_bluetooth_serial) (Untuk _Bluetooth_ Klasik)
  - [Flutter Blue Plus](https://pub.dev/packages/flutter_blue_plus) (Untuk _Bluetooth Low Energy_ - BLE)
  - [WiFi Info](https://pub.dev/packages/wifi_info_flutter) (Untuk mendapatkan informasi Wi-Fi)
  - [Connectivity Plus](https://pub.dev/packages/connectivity_plus) (Untuk memantau status jaringan)
  - [NFC Manager](https://pub.dev/packages/nfc_manager) (Untuk komunikasi NFC)

---

Dengan ini, kita telah mencakup integrasi dengan berbagai sensor perangkat dan fitur konektivitas.

Selanjutnya, masuk ke bagian terakhir dari **Fase 8**: **14.3 Biometric & Security**, di mana kita akan menjelajahi otentikasi biometrik dan implementasi keamanan lainnya. Bagian ini sangat krusial untuk membangun aplikasi yang aman dan nyaman bagi pengguna.

---

##### **14.3 Biometric & Security**

- **Peran:** Dalam era digital saat ini, keamanan aplikasi menjadi prioritas utama. Integrasi biometrik memberikan metode otentikasi yang cepat dan aman, sementara fitur keamanan lainnya membantu melindungi integritas aplikasi dan data pengguna dari ancaman potensial.

---

###### **Biometric Authentication**

- **Peran:** Memungkinkan pengguna untuk mengautentikasi diri menggunakan karakteristik biologis unik mereka, seperti sidik jari atau pengenalan wajah. Ini memberikan pengalaman pengguna yang mulus sekaligus meningkatkan keamanan.

- **Fingerprint Authentication:**

  - **Mekanisme:** Menggunakan pemindai sidik jari perangkat (misalnya, Touch ID di iOS, sensor sidik jari di Android) untuk memverifikasi identitas pengguna.
  - **Implementasi:** Umumnya melibatkan _plugin_ seperti `local_auth`. Anda akan memanggil metode dari _plugin_ ini untuk memulai proses otentikasi sidik jari.

- **Face ID/Face Recognition:**

  - **Mekanisme:** Menggunakan sistem pengenalan wajah perangkat (misalnya, Face ID di iPhone, atau sistem pengenalan wajah di Android) untuk otentikasi.
  - **Implementasi:** Sama seperti sidik jari, `local_auth` juga mendukung otentikasi wajah jika tersedia di perangkat.

- **Device Credential Authentication:**

  - **Peran:** Jika biometrik tidak tersedia atau tidak diaktifkan, atau sebagai _fallback_, Anda dapat menggunakan kredensial perangkat (PIN, pola, atau kata sandi) yang telah diatur oleh pengguna.
  - **Mekanisme:** `local_auth` juga dapat memicu permintaan kredensial perangkat ini.

- **Biometric Availability Checking:**

  - **Peran:** Sebelum mencoba otentikasi biometrik, penting untuk memeriksa apakah perangkat mendukung biometrik, apakah biometrik telah terdaftar oleh pengguna, dan jenis biometrik apa yang tersedia.
  - **Mekanisme:** `local_auth` menyediakan metode seperti `canCheckBiometrics()` dan `getAvailableBiometrics()` untuk melakukan pemeriksaan ini.

- **Prasyarat (Izin Native Biometrik):**

  - **Android:** Tambahkan izin di `android/app/src/main/AndroidManifest.xml`:
    ```xml
    <uses-permission android:name="android.permission.USE_BIOMETRIC" />
    <uses-permission android:name="android.permission.USE_FINGERPRINT" />
    ```
  - **iOS:** Tambahkan deskripsi penggunaan di `ios/Runner/Info.plist`:
    ```xml
    <key>NSFaceIDUsageDescription</key>
    <string>Aplikasi ini membutuhkan akses Face ID untuk otentikasi cepat.</string>
    ```
    Untuk Touch ID, tidak perlu deklarasi khusus di `Info.plist`, karena sudah tercakup oleh izin sistem.

- **Contoh Kode (Biometric Authentication):**

  ```dart
  import 'package:flutter/material.dart';
  import 'package:local_auth/local_auth.dart'; // Import local_auth
  import 'package:flutter/services.dart'; // Untuk PlatformException

  void main() {
    runApp(const BiometricApp());
  }

  class BiometricApp extends StatelessWidget {
    const BiometricApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Biometric Auth Demo',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          useMaterial3: true,
        ),
        home: const BiometricAuthScreen(),
      );
    }
  }

  class BiometricAuthScreen extends StatefulWidget {
    const BiometricAuthScreen({super.key});

    @override
    State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
  }

  class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
    final LocalAuthentication auth = LocalAuthentication();
    String _authorized = 'Not Authorized';
    bool _canCheckBiometrics = false;
    List<BiometricType> _availableBiometrics = [];

    @override
    void initState() {
      super.initState();
      _checkBiometrics();
    }

    // Memeriksa apakah biometrik dapat digunakan dan jenis yang tersedia
    Future<void> _checkBiometrics() async {
      late bool canCheckBiometrics;
      try {
        canCheckBiometrics = await auth.canCheckBiometrics;
      } on PlatformException catch (e) {
        canCheckBiometrics = false;
        print(e);
      }
      if (!mounted) {
        return;
      }

      late List<BiometricType> availableBiometrics;
      try {
        availableBiometrics = await auth.getAvailableBiometrics();
      } on PlatformException catch (e) {
        availableBiometrics = <BiometricType>[];
        print(e);
      }
      if (!mounted) {
        return;
      }

      setState(() {
        _canCheckBiometrics = canCheckBiometrics;
        _availableBiometrics = availableBiometrics;
      });
    }

    // Melakukan otentikasi biometrik
    Future<void> _authenticate() async {
      bool authenticated = false;
      try {
        setState(() {
          _authorized = 'Authenticating...';
        });
        authenticated = await auth.authenticate(
          localizedReason: 'Pindai sidik jari Anda untuk mengakses fitur ini', // Pesan yang ditampilkan kepada pengguna
          options: const AuthenticationOptions(
            stickyAuth: true, // Biarkan otentikasi tetap aktif sampai selesai
            useErrorDialogs: true, // Tampilkan dialog error default
          ),
        );
      } on PlatformException catch (e) {
        print(e);
        setState(() {
          _authorized = 'Error: ${e.message}';
        });
        return;
      }
      if (!mounted) {
        return;
      }

      setState(() {
        _authorized = authenticated ? 'Authorized' : 'Not Authorized';
      });

      if (authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Otentikasi berhasil!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Otentikasi gagal.')),
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Biometric Authentication')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Can check biometrics: $_canCheckBiometrics',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Available biometrics: $_availableBiometrics',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _authenticate,
                child: const Text('Authenticate with Biometrics'),
              ),
              const SizedBox(height: 20),
              Text(
                'Authentication Status: $_authorized',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _authorized == 'Authorized' ? Colors.green : (_authorized == 'Not Authorized' ? Colors.red : Colors.orange),
                ),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Tekan tombol untuk mencoba otentikasi menggunakan sidik jari atau Face ID. Pastikan Anda telah mengatur biometrik di pengaturan perangkat Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Catatan: Pastikan Anda telah menambahkan `local_auth` ke `pubspec.yaml` dan mengkonfigurasi izin native di `AndroidManifest.xml` (Android) dan `Info.plist` (iOS).',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

- **Visualisasi Konseptual: Biometric Authentication Flow**

  ```mermaid
  graph TD
      A[Flutter App (Dart)] -- 1. local_auth.authenticate() --> B[Local Auth Plugin];
      B -- 2. Request Biometric Auth --> C[Native Biometric API (Android/iOS)];
      C -- 3. Show Biometric Prompt --> D[User Device (Fingerprint Sensor / Face ID)];
      D -- 4. User Authenticates --> C;
      C -- 5. Result (Success/Fail) --> B;
      B -- 6. Return Result (bool) --> A;
      A -- 7. Update UI / Grant Access --> E[App Feature / Secured Area];
  ```

  **Penjelasan Visual:**
  Diagram ini menunjukkan alur otentikasi biometrik. Aplikasi Flutter memanggil `local_auth` _plugin_. _Plugin_ ini kemudian memicu permintaan otentikasi ke API biometrik _native_ perangkat. Pengguna kemudian berinteraksi dengan sensor biometrik perangkat. Hasil otentikasi dikembalikan melalui _plugin_ ke aplikasi Flutter, yang kemudian dapat mengambil tindakan yang sesuai (misalnya, memberikan akses ke fitur yang dilindungi).

- **Sumber Daya Tambahan:**

  - [Local Auth](https://pub.dev/packages/local_auth) (Plugin resmi untuk otentikasi lokal/biometrik)
  - [Biometric Authentication Guide](https://www.google.com/search?q=https://docs.flutter.dev/cookbook/plugins/local-auth) (Panduan otentikasi biometrik di dokumentasi Flutter)

---

###### **Security Implementation**

- **Peran:** Selain otentikasi, ada aspek keamanan lain yang perlu dipertimbangkan untuk melindungi aplikasi dan penggunanya dari potensi kerentanan.

- **App Signing dan Verification:**

  - **Peran:** Proses _signing_ mengidentifikasi pengembang aplikasi dan memastikan bahwa aplikasi tidak diubah setelah diterbitkan. Ini adalah fondasi keamanan untuk distribusi aplikasi.
  - **Mekanisme:**
    - **Android:** Aplikasi ditandatangani dengan _keystore_ pribadi saat membangun rilis (`flutter build appbundle --release`). Google Play Store juga memiliki fitur _App Signing_ di mana Google mengelola kunci _signing_ Anda.
    - **iOS:** Aplikasi ditandatangani dengan sertifikat pengembang Apple dan profil penyediaan (`flutter build ios --release`).
  - **Verifikasi:** Meskipun Flutter tidak memiliki API bawaan untuk memverifikasi _signature_ aplikasi saat _runtime_, Anda dapat menggunakan _plugin_ _native_ untuk memeriksa _integrity_ _signature_ aplikasi jika diperlukan untuk kasus penggunaan keamanan yang sangat tinggi.

- **Root/Jailbreak Detection:**

  - **Peran:** Mendeteksi apakah perangkat Android telah di-_root_ atau perangkat iOS telah di-_jailbreak_. Perangkat yang di-_root_/di-_jailbreak_ lebih rentan terhadap serangan karena kontrol keamanannya melemah.
  - **Mekanisme:** _Plugin_ seperti `flutter_jailbreak_detection` (atau `is_rooted` di masa lalu) menyediakan metode untuk memeriksa status _root_/ _jailbreak_ perangkat. Aplikasi dapat memilih untuk tidak berfungsi atau membatasi fungsionalitasnya pada perangkat semacam itu.

- **Screenshot Prevention:**

  - **Peran:** Mencegah pengguna mengambil _screenshot_ atau merekam layar aplikasi, seringkali digunakan untuk melindungi konten sensitif (misalnya, data finansial, gambar medis).
  - **Mekanisme:**
    - **Android:** Anda dapat mengatur _flag_ `FLAG_SECURE` pada `Window` _native_.
    - **iOS:** Tidak ada API publik langsung untuk mencegah _screenshot_, tetapi Anda dapat mendeteksi saat _screenshot_ diambil atau mendeteksi perekaman layar.
    - **Implementasi di Flutter:** Biasanya memerlukan _plugin_ yang mengimplementasikan logika _native_ ini. Contohnya bisa dilakukan dengan _MethodChannel_ kustom yang memanggil `getWindow().setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)` di Android.

- **App Lock Implementation:**

  - **Peran:** Menerapkan layar kunci atau otentikasi ulang saat pengguna kembali ke aplikasi dari latar belakang, atau setelah periode tidak aktif tertentu. Ini menambah lapisan keamanan lain di atas kunci perangkat.
  - **Mekanisme:** Ini biasanya diimplementasikan di sisi Dart dengan mendengarkan perubahan `AppLifecycleState` (misalnya, dari `paused` ke `resumed`) dan kemudian memicu otentikasi biometrik atau permintaan PIN/kata sandi khusus aplikasi.

- **Sumber Daya Tambahan:**

  - [Flutter Jailbreak Detection](https://pub.dev/packages/flutter_jailbreak_detection) (Plugin untuk mendeteksi _root_/ _jailbreak_)
  - [Screenshot Callback](https://pub.dev/packages/screenshot_callback) (Untuk mendeteksi _screenshot_ di iOS, bukan mencegah)

# Selamat!

Dengan ini, kita telah menandai selesainya seluruh **Fase 8: Platform Integration & Native Features**!

Anda sekarang memiliki pemahaman yang kuat tentang bagaimana aplikasi Flutter dapat berinteraksi secara mendalam dengan fitur _native_ perangkat, mulai dari sensor, media, hingga lapisan keamanan biometrik dan sistem.

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-7/README.md
[selanjutnya]: ../bagian-9/README.md
[pro8]: ../../pro/bagian-8/README.md

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
