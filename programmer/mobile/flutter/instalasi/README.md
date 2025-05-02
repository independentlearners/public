# Instalasi Flutter

Ada banyak cara untuk menginstal **flutter**, seperti instalasi yang simpel tetapi menumpuk banyak file yang bagi saya pribadi itu tidak terlalu dibutuhkan sebagai pemula. Atau yang manual tetapi kompleks dan sangat rumit bahkan berkali-kali saya kebignungan jika itu di download dan di konfigurasi secara manual. Sebagai gantinya kita akan meminta bantuan AI untuk menyelesaikan masalah ini dimana tujuan kita adalah mendapatkan flutter yang ringan untuk memori tetapi sama seperti kita mendapatkannya secara utuh, bedanya adalah bahwa kita tidak menggunakan android studio dan tidak juga menggunakan **Chrome** ataupun **Visual Studio Installer**, kecuali jika nantinya kita membutuhkan itu semua. Untuk saat ini kita hanya membutuhkan bagaimana **flutter** berfungsi demi untuk memenuhi kebutuhan pembelajaran awal. Sebelum melanjutkan, pastikan bahwa perangkat yang kalian gunakan memenuhi [persyaratan perangkat keras](https://docs.flutter.dev/get-started/install/windows/mobile#hardware-requirements "docs.flutter.dev") agar **flutter** dapat dijalankan. Jika tidak kalian bisa menggunakan **[IDX](https://idx.google.com) By Google** yang merupakan Online Code Editor yang sudah di sediakan oleh google, kalian bisa mendaftarnya melalui tautan tersebut. Atau jika kalian hanya ingin menjalankan kode **Dart** kalian bisa menggunakan **[dartpad.dev](https://dartpad.dev/)**

Pertama, pastikan bahwa koneksi internet stabil. Software atau persyaratan perangkat lunak yang kita butuhkan disini sesuai dengan yang di [dokumentasikan secara resmi](https://docs.flutter.dev/get-started/install/windows/mobile "docs.flutter.dev") tetapi tidak kita unduh semuanya secara lengkap, hanya bagian yang paling penting:

- **[Windows PowerShell 5 atau Terbaru](https://learn.microsoft.com/id-id/powershell/scripting/what-is-windows-powershell?view=powershell-7.5 "microsoft.com")**
- **[Microsoft Visual Studio Code](https://code.visualstudio.com/docs/setup/windows "visualstudio.com")**

Sepertinya anda hanya cukup mendownload **VSCode** saja, karena secara default, **PowerShell** sudah pasti ada di desktop kalian, jadi selanjutnya pilih sistem desktop yang tersedia, untuk sementara ini saya hanya memiliki dua jenis operasi sistem, **linux** dan **windows**

# Setelah Instalasi

Buat proyek flutter atau dart terlebih dahulu, selanjutnya jika ingin tetap mempertahankan fitur **Trailing Commas** maka ubahlah versi sdk dalam file **pubspec.yaml** ke versi 3.5 seperti contoh pada saat tulisan ini dibuat saya menggunakan versi dart dan flutter pada versi berikut:

```pwsh
[√] Flutter (Channel master, 3.32.0-1.0.pre.170, on Microsoft Windows [Version 10.0.26100.3775], locale en-ID) [8.3s]
    • Flutter version 3.32.0-1.0.pre.170 on channel master at C:\src\flutter
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision f71b4fe21a (29 hours ago), 2025-04-20 17:49:31 -0400
    • Engine revision f71b4fe21a
    • Dart version 3.9.0 (build 3.9.0-32.0.dev)
    • DevTools version 2.45.0
```

Kemudian saya mengubah versi sdk dalam file pubspec.yaml seperti ini:

```yaml
name: flutterku
description: "A new Flutter project."
publish_to: "none"
version: 0.1.0

environment:
  sdk: ^3.5.0-32.0.dev

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
```

Jadi baris ini awalnya adalah

```yaml
environment:
  sdk: ^3.9.0-32.0.dev
```

Kemudian saya mengubahnya menjadi seperti

```yaml
environment:
  sdk: ^3.5.0-32.0.dev
```

Sekarang kita bisa menambahkan koma secara manual kemudian kode akan disusun secara otomatis sesuai koma yang kita tambahkan

# Aktifkan Syntax Highlighting

**Bracket Pair**

`vscode://settings/editor.guides.bracketPairs`

`dart.previewFlutterUiGuides`

**Highlighting**

`dart.previewFlutterUiGuides`

`dart.previewFlutterUiGuidesCustomTracking`
