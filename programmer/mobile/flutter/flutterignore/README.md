# .flutterignore

Kalau kamu punya folder yang **nggak mau** dibaca Flutter (baik untuk bundling asset maupun untuk analisis kode), ada dua jurus ampuh:

---

## 1. Exclude dari bundling (build) lewat `.flutterignore`

Flutter akan mengabaikan file/folder yang terdaftar di `.flutterignore` saat membuat paket APK/IPA. Caranya:

1. Buat file `.flutterignore` di root project (selevel `pubspec.yaml`).

2. Tambahkan path folder yang ingin di–ignore. Misal foldermu namanya `secret_assets/`:

```yaml
# .flutterignore
secret_assets/
*.psd
logs/
saya/ # disini saya menambahkan ignore pada folder "saya"
```

3. Jalankan ulang build/run, Flutter tidak akan menyertakan konten dalam `secret_assets/` ke dalam bundle.

> ⚠️ `pubspec.yaml > assets:` hanya akan memasukkan apa yang **di-define** di situ. Tapi kalau kamu punya folder besar yang lain-lain, `.flutterignore` adalah cara yang lebih universal.

---

## 2. Exclude dari Dart Analyzer (IDE & lint)

Kalau maksudmu folder itu juga tidak perlu “dibaca” oleh analyzer (error/warning, autocomplete, dsb), bikin file `analysis_options.yaml` di root:

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - secret_assets/**
    - logs/**
    - saya/** # disini saya menambahkan ignore pada folder "saya"
    - test/temp/**
```

Dengan ini, saat kamu ketik `flutter analyze` atau pakai VS Code/Android Studio, folder `secret_assets/`, `logs/`, dan `test/temp/` akan diabaikan.

---

## Ringkasnya

- **Paket/bundle** ➔ `.flutterignore`
- **Analisis kode** ➔ `analysis_options.yaml`
