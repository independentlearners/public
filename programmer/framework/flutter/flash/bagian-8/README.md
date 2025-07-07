> [flash][pro8]

# **[FASE 8: Platform Integration & Native Features][0]**

Fase ini akan membekali Anda dengan kemampuan untuk berinteraksi dengan fungsionalitas khusus perangkat dan _platform_ yang tidak sepenuhnya di-_expose_ oleh Flutter _framework_ inti.

<details>
  <summary>📃 Struktur Daftar Isi</summary>

---

- **[13. Platform Channels & Native Integration](#13-platform-channels--native-integration)**

  - 13.1 Method Channels
    - Platform Channel Implementation
    - Method channel setup
    - Native code integration (Android/iOS)
    - Data type mapping
    - Error handling across platforms
    - Platform Channels
    - Writing Platform-Specific Code
  - 13.2 Native Plugin Development
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

- **14. Device Features Integration**

  - 14.1 Camera & Media
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
  - 14.2 Sensors & Hardware
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
  - 14.3 Biometric & Security
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

Dengan ini, kita telah menyelesaikan **13.2 Native Plugin Development** dan seluruh topik **13. Platform Channels & Native Integration**! Ini adalah salah satu area paling canggih dalam pengembangan Flutter, memungkinkan Anda untuk memperluas kemampuan aplikasi Anda di luar batas _framework_ inti.

Selanjutnya, kita akan masuk ke **14. Device Features Integration**, di mana kita akan melihat bagaimana _plugin_ yang sudah ada (bukan yang kita buat sendiri) digunakan untuk mengakses fitur-fitur umum perangkat seperti kamera, media, sensor, dan biometrik.

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
