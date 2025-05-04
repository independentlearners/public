# Instalasi manual

Agar semua proses instalasi berjalan maksimal pastikan terminal selalu dibuka sebagai admin dan jalankan:

#### Mendownload Chocolatey
_Paket manager_
```pwsh
Set-ExecutionPolicy Bypass -Scope Process -Force; `
[System.Net.ServicePointManager]::SecurityProtocol = `
[System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Tutup dan jalankan kembali terminal lalu periksa hasil instalasi choco
choco --version
# Output seharusnya menunjukan versi
```
#### Instalasi VS Code
_IDE Code Editor_
```pwsh
choco install vscode -y

# Seteah selesai tutup dan jalankan ulang terminal
code .
```
#### Mendownload Git
_Sistem versi pengontrol_
```pwsh
# Mendownload melalui choco
choco search git # Mencari git dan catat nama beserta versinya
choco install git.install --version 2.48.1 # Versi yang muncul pada saat tutorial ini ditulis, jadi sesuaikan
```
Jika instalasi menggunakan terminal membingungkan, unduh secara manual [disini.](https://git-scm.com/downloads "git-scm.com") Kemudian bukan dan klik Next terus, itu akan membuat git diinstall secara default
#### Membuat profil git
```pwsh
git config --global user.name "username" # Sesuaikan username anda
git config --global user.email "email@email.com" # Sesuaikan email anda
```

#### Membuat direktori dan menginstal flutter
```pwsh
# Membuat folder src di partisi c (system)
mkdir -p C:\src

# Masuk kedalam direktori
cd C:\src

# Mengkloning repositori flutter di github
git clone https://github.com/flutter/flutter.git flutter

# Setelah kloning berhasil, di dalam folder src akan muncul folder baru bernama flutter
```
#### Tambahkan ke lingkungan variable
Jalankan berikut dan tutup terminal kemudian jalankan kembali
```pwsh
# Menambahkan ke lingkungan variabel
setx PATH "C:\src\flutter\bin"

# Setelah membuka terminal saatnya memeriksa hasil kloning
flutter doctor -v
```
Sampai disini seharusnya flutter doctor berhasil dijalankan dan output menampilkan **Selamat datang di flutter** seperti berikut 
```
Checking Dart SDK version...
Downloading Dart SDK from Flutter engine ...
Expanding downloaded archive with PowerShell...
Building flutter tool...
Running pub upgrade...
Resolving dependencies... (1.9s)
Downloading packages... (20.1s)
Got dependencies.

  ╔════════════════════════════════════════════════════════════════════════════╗
  ║                 Welcome to Flutter! - https://flutter.dev                  ║
  ║                                                                            ║
  ║ The Flutter tool uses Google Analytics to anonymously report feature usage ║
  ║ statistics and basic crash reports. This data is used to help improve      ║
  ║ Flutter tools over time.                                                   ║
  ║                                                                            ║
  ║ Flutter tool analytics are not sent on the very first run. To disable      ║
  ║ reporting, type 'flutter config --no-analytics'. To display the current    ║
  ║ setting, type 'flutter config'. If you opt out of analytics, an opt-out    ║
  ║ event will be sent, and then no further information will be sent by the    ║
  ║ Flutter tool.                                                              ║
  ║                                                                            ║
  ║ By downloading the Flutter SDK, you agree to the Google Terms of Service.  ║
  ║ The Google Privacy Policy describes how data is handled in this service.   ║
  ║                                                                            ║
  ║ Moreover, Flutter includes the Dart SDK, which may send usage metrics and  ║
  ║ crash reports to Google.                                                   ║
  ║                                                                            ║
  ║ Read about data we send with crash reports:                                ║
  ║ https://flutter.dev/to/crash-reporting                                     ║
  ║                                                                            ║
  ║ See Google's privacy policy:                                               ║
  ║ https://policies.google.com/privacy                                        ║
  ║                                                                            ║
  ║ To disable animations in this tool, use                                    ║
  ║ 'flutter config --no-cli-animations'.                                      ║
  ╚════════════════════════════════════════════════════════════════════════════╝


Downloading Material fonts...                                      819ms
Downloading Gradle Wrapper...                                       41ms
Downloading package sky_engine...                                  382ms
Downloading package flutter_gpu...                                  76ms
Downloading flutter_patched_sdk tools...                           960ms
Downloading flutter_patched_sdk_product tools...                   919ms
Downloading windows-x64 tools...                                    7.4s
Downloading windows-x64/font-subset tools...                     1,634ms
[✓] Flutter (Channel master, 3.31.0-1.0.pre.184, on Microsoft Windows [Version 10.0.26100.3476], locale en-ID) [2.6s]
    • Flutter version 3.31.0-1.0.pre.184 on channel master at C:\src\flutter
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision efa81a7af6 (3 hours ago), 2025-03-21 20:38:20 -0700
    • Engine revision efa81a7af6
    • Dart version 3.8.0 (build 3.8.0-217.0.dev)
    • DevTools version 2.45.0-dev.0

[✓] Windows Version (Windows 11 or higher, 24H2, 2009) [1,557ms]

[✗] Android toolchain - develop for Android devices [32ms]
    ✗ Unable to locate Android SDK.
      Install Android Studio from: https://developer.android.com/studio/index.html
      On first launch it will assist you in installing the Android SDK components.
      (or visit https://flutter.dev/to/windows-android-setup for detailed instructions).
      If the Android SDK has been installed to a custom location, please use
      `flutter config --android-sdk` to update to that location.


[✗] Chrome - develop for the web (Cannot find Chrome executable at .\Google\Chrome\Application\chrome.exe) [13ms]
    ! Cannot find Chrome. Try setting CHROME_EXECUTABLE to a Chrome executable.

[✗] Visual Studio - develop Windows apps [12ms]
    ✗ Visual Studio not installed; this is necessary to develop Windows apps.
      Download at https://visualstudio.microsoft.com/downloads/.
      Please install the "Desktop development with C++" workload, including all of its default components

[!] Android Studio (not installed) [10ms]
    • Android Studio not found; download from https://developer.android.com/studio/index.html
      (or visit https://flutter.dev/to/windows-android-setup for detailed instructions).

[✓] VS Code (version 1.98.2) [10ms]
    • VS Code at C:\Users\ameer\AppData\Local\Programs\Microsoft VS Code
    • Flutter extension can be installed from:
      🔨 https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter

[✓] Connected device (2 available) [78ms]
    • Windows (desktop) • windows • windows-x64    • Microsoft Windows [Version 10.0.26100.3476]
    • Edge (web)        • edge    • web-javascript • Microsoft Edge 134.0.3124.72

[✓] Network resources [1,341ms]
    • All expected network resources are available.

! Doctor found issues in 4 categories.
```
jika tidak berhasil, coba buka lingkungan varibel dengan menjalankan perintah `sysdm.cpl` di terminal atau di **Windows Run** lalu pilih `**Advanced**` dan klik `**Environment Variables**` pada halaman popup ini akan tampil dua variable. Bagian atas menunjukan lingkungan khusus user sedangkan bagian bawah adalah lingkungan umum dimana semua izin tersedia untuk meaksesnya, agar setiap perintah berhasil dijalankan pada saat termial dibuka secara admin atau tidak, maka tambahkan jalur flutter kedua jalur lingkungan tersebut kemudian pilih path pada bagian `Variable` dan klik edit. Nantinya cara-cara semacam ini akan kita lakukan dalam banyak kasus instalasi tools. Jika pengecekan `flutter doctor` atau `flutter doctor -v` sudah berhasil dijalankan, maka selalu gunakan perintah pengecekan tersebut setiap kali selesai menginstal komponen-komponen yang lain untuk memastikan apakah instalasi komponen tersebut sesuai dengan ekspektasi flutter
#### Menginstal java
[Klik Disini](https://adoptium.net/) untuk menginstal java secara manual dan ambil versi terbaru di adoptium karena versi tersebut merupakan salah satu yang paling kompetibel, pada bagian instalasi pilih `_Enthier feature will be installed on local hard drive_`.
Jika tertarik untuk menginstal melalui terminal menggunakan choco, ikuti berikut:
```pwsh
# Cari java, dicontoh ini kita tetap menggunakan adoptium
choco search adoptium
```
Pilih versi! pada saat tutorial ini di buat, pencarian muncul dan saya memilih baris berikut `adoptopenjdk 16.0.1.901 [Approved]` Oke kita akan menginstalnya. Ingat gunakan versi terbaru, jika bingung untuk memilih versi, gunakan instalasi manual seperti yang sudah saya sebutkan diatas
```pwsh
choco install adoptopenjdk --version 16.0.1.901
# Pada saat mengonfirmasi sebuah pilihan, pilih Y atau A

# Tutup dan jalankan ulang terminal lalu periksa hasil instalasinya
java --version
```

#### Konfirmasi browser sebagai chrome
Karena saya tidak menggunakan google chrome, jadi saya memaksa brave sebagai gantinya dengan cara menambahkan path brave sebagai Ekskutabel Chrome
```pwsh
setx CHROME_EXECUTABLE "C:\Users\oke\AppData\Local\BraveSoftware\Brave-Browser\Application\brave.exe"
```

#### Instlasi Gradel
```pwsh
choco install gradle -y
```

#### Instalasi Android SDK Command-line Tools
```pwsh
choco install android-sdk -y
```
tutup dan jalankan kembali terminal untuk memeriksa apakah Android Tools SDK berhasil di instal, jalankan berikut
```pwsh
sdkmanager --version
```
jika terjadi kegagalan saatnya menambahkan ke lingkungan variabel
#### Setel Variabel Lingkungan untuk Android SDK
Misalnya, jika Android SDK diinstal ke direktori tertentu (seperti: C:\Android\android-sdk), maka set variabel lingkungan sebagai:
```pwsh
setx ANDROID_HOME "C:\Android\android-sdk"
```
Dan pastikan direktori seperti platform-tools sudah ada di PATH jika belum, kita bisa jalankan perintah berikut untuk menambahkannya ke lingkungan variabel:
```pwsh
setx PATH "%PATH%;%ANDROID_HOME%\platform-tools"
```
atau anda bisa menambahkan path ke lingkungan variabel secara manual, kunjungi direktori `C:\Android\android-sdk` dan akan ada folder bawaan dari instalasi tersebut tetapi kita butuh beberpa komponen yang akhirnya akan membuat direktori berisi folder seperti berikut:
```
C:\Android
└───android-sdk
	├── build-tools
	├── cmdline-tools
	│   └── latest
        │       └── bin
	│           └─ sdkmanager.bat
	├── licenses
	├── platforms
	├── platforms-tools
	└── tools
	     └── bin
		  └─ sdkmanager.bat
```
untuk mencapai tujuan tersebut kita perlu untuk #### Mengunduh komponen tambahan
```pwsh
sdkmanager --install "platform-tools" "platforms;android-33" "build-tools;33.0.2"
```
terakhir kita perlu mendowload [cmdline-tools](https://developer.android.com/studio?hl=id#command-line-tools-only:~:text=Khusus%20alat%20command%2Dline), ekstrak dan letakan ke direktori sesuai gambaran diagram diatas lalu Verifikasi Instalasi dan Penerimaan Lisensi
```pwsh
flutter doctor --android-licenses
```
jika semua sudah selesai saatnya menjalankan `flutter doctor -v` untuk memastikan komponen apa saja yang berhasil terinstal, berikutnya kita akan menginstal `Visual Studio` agar proyek flutter kita mampu menguji coba khusus sotfware windows
