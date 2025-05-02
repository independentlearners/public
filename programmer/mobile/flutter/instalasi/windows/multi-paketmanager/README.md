# $Instalasi Flutter Di Windows$

### Menggunakan Baris Terminal

**Download VSCode**

Jika windows kalian ditautkan dengan akun **Microsoft**,
berarti memiliki fitur _winget-**app manager**_ di termialnya. Sekarang kita gunakan **winget** untuk mendownload **VSCode**, pastekan perintah berikut melalui pada terminal

```PS
winget install Microsoft.VisualStudioCode
```

Setelah mendownload, jalankan perintah `code .` untuk memastikan apakah **VSCode** terintegrasi dengan **PowerShell.** Ingat! patikan anda menuliskan perintah tersebut dengan kata `code` lalu spasi dan tambahkan titik `.` ini akan secara otomatis membuka software **Visual Studio Code,** berikutnya:

**Download Git**

```PS
winget install Git.Git
```

Selesai mendownload tutup dan bukan kembali terminal PowerShell-nya, lalu jalankan perintah `git --version` jika output menunjukan versi, **Git** berhasil terinstal, jika output versi tidak muncul mungkin [tulisan disini bisa membantu](../../../git/gagal-terinstal/README.md "menuju repositori saya").

> Disarankan untuk menyelesaikan instalsi Git terlebih dahulu sebelum melanjutkan

kemudian jalankan perintah berikut untuk membuat profil **Git**

```PS
git config --global user.name "username" # ganti dengan username kalian
```

```PS
git config --global user.email "email@email.com" # ganti dengan email kalian
```

Terakhir jalankan perintah berikut untuk memastikan profil berhasil dibuat

`git config --list`

#

Pada bagian ini kita akan mendownload **flutter** tetapi kita akan tetap menggunakan terminal untuk memudahkannya, oleh karena itu kita membutuhkan **app-manager** sebagai alternatif kedua dari **Ekosistem Windows Microsoft** tools ini bernama **Chocolatey**

```PS
winget install Chocolatey.Chocolatey
```

> Tentang winget dan chocolatey, kita akan membahasnya secara terpisah. Untuk saat ini kita hanya fokus menyelesaikan tantangan ini terlebih dahulu. Mari kita lanjutkan

Untuk memastikan apakah choco berhasil terinstal, seperti biasa yaitu tutup dan jalankan ulang dengan menggunakan hak administrator. Gunakan pintasan keyboard `Win + X` lalu pilih _**Terminal (Admin)** - Urutan ke 11 dari atas,_ atau lihat gambar [disini.](https://postimg.cc/1gTS1rdQ "postimg.cc") Coba jalankan perintah `choco --version`. Jika versi muncul di output, `choco` berhasil di instal, saatnya menginstal **flutter**

#

Karena kita menggunakan `choco`. Maka untuk menginstalnya kita harus menyertakan versi yang tersedia sesuai dalam **Repositori Chocolatey**, untuk dapat melihat versi tersebut janalankan perintah

```PS
choco search flutter
```

Kemudian jalankan perintah seperti berikut dan sesuaikan dengan versi flutter yang sekarang

```PS
choco install flutter --version 3.27.1 #  ganti dengan versi yang sesuai
```

> Pada saat tulisan ini dibuat, versi flutter yang tersedia dalam repository choco dalah `3.27.1` sedangkan dalam repository resmi flutter sudah diupgrade menjadi `3.27.4` tidak masalah dengan versi berapapun yang tersedia, intinya adalah kita mendapatkan filenya tanpa perlu mengekstrak secara manual.

#

Selsesai mendownload dan menginstalnya, buka file direktori biasanya ada di `C:\tools\flutter` atau kopi pastekan alamat direktori tersebut ke **Windows Run** supaya langsung menuju ke folder target dengan menekan `Win + R` atau menulisnya seperti ini **`c:\tools`** dan **Enter.**

**Mengkonfigurasikan Flutter Dengan Repository Resmi**

Setelah memastikan folder flutter ada, jalankan perintah berikut

```PS
git config --global --add safe.directory C:\tools\flutter #  ubah alamat folder sesuai direktori kalian
```

dan perintah berikut ini untuk mengecek komponen apa saja yang di perlukan, kita juga dapat menggunakan perintah tersebut ketika nantinya ada masalah pada flutter

```PS
flutter doctor -v
```

Tanda merah menunjukan ada bagian penting yang belum di install, tetapi kita akan menghindari beberapa yang sebetulnya itu tidak diperlukan, seperti **Chrome** mungkin.

**Instal OpenJDK**

```PS
winget install EclipseAdoptium.Temurin.11.JDK
```

```PS
choco install openjdk11

```

Jalankan perintah berikut untuk menyetel **JAVA_HOME** yang secara otomatis ditambahkan ke **PATH**:

```PS
$jdkPath = (Get-ChildItem 'C:\Program Files\Eclipse Adoptium\jdk-11*' -Directory | Select-Object -First 1).FullName
[Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkPath, "User")
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$jdkPath\bin", "User")

```

**Instal SDK Manager**

_command line tools_

```PS
Invoke-WebRequest -Uri "https://dl.google.com/android/repository/commandlinetools-win-8512546_latest.zip" -OutFile "commandlinetools.zip"
```

Buka **Windows Explore** dengan menekan pintasan `Win + E` lalu masuk ke `C:\Android\cmdline-tools`. Buat folder `latest` di dalam cmdline-tools dan pindahkan isi folder cmdline-tools ke dalam `latest` hingga direktori menjadi seperti ini `C:\Android\cmdline-tools\latest`

Selanjutnya jalankan berikut ini untuk memasukan `path` ke dalam **Environment Variable**

```PS
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Android\cmdline-tools\latest\bin", "User")
```

Sekarang jalankan `sdkmanager --version`

**Instal Komponen SDK yang Dibutuhkan**

```PS
sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2"
```

**Setel ANDROID_HOME:**

```PS
[Environment]::SetEnvironmentVariable("ANDROID_HOME", "C:\Android", "User")
```

#

### **Menginstal Visual Studio Build Tools tanpa Visual Studio**

Untuk mengembangkan aplikasi Windows, Anda memerlukan Build Tools saja.

**Unduh dan Instal Visual Studio Build Tools:**

- **Unduh Installer:**

  ```powershell
  Invoke-WebRequest -Uri "https://aka.ms/vs/17/release/vs_BuildTools.exe" -OutFile "vs_BuildTools.exe"
  ```

- **Instal Komponen yang Diperlukan:**

  ```powershell
  .\vs_BuildTools.exe --quiet --wait --norestart --nocache `
  --add Microsoft.VisualStudio.Workload.VCTools `
  --includeRecommended
  ```

_Catatan:_ Proses ini akan menginstal "Desktop development with C++" workload yang diperlukan oleh Flutter untuk pengembangan aplikasi Windows.

```powershell
flutter doctor -v
```

#

Untuk memenuhi kebutuhan Flutter tanpa menginstal Google Chrome sepenuhnya, Anda bisa menggunakan metode alternatif dengan mengunduh Chromium, yang merupakan versi open-source dari Chrome.

### **Langkah-langkah Mengunduh dan Mengonfigurasi Chromium:**

1. **Unduh Chromium:**

   ```powershell
   Invoke-WebRequest -Uri "https://download-chromium.appspot.com/dl/Win?type=snapshots" -OutFile "chromium.zip"
   Expand-Archive -Path "chromium.zip" -DestinationPath "C:\Chromium"
   Remove-Item "chromium.zip"
   ```

2. **Setel Path Eksekutabel Chromium:**

   Tentukan file path ke eksekutabel Chromium (misalnya `chrome.exe` atau `chrome-win32`).

   ```powershell
   $chromiumExecutable = Get-ChildItem -Path "C:\Chromium" -Filter "chrome.exe" -Recurse | Select-Object -First 1
   [Environment]::SetEnvironmentVariable("CHROME_EXECUTABLE", $chromiumExecutable.FullName, "User")
   ```

### **Ringkasan Perintah:**

```powershell
# Unduh dan Ekstrak Chromium
Invoke-WebRequest -Uri "https://download-chromium.appspot.com/dl/Win?type=snapshots" -OutFile "chromium.zip"
Expand-Archive -Path "chromium.zip" -DestinationPath "C:\Chromium"
Remove-Item "chromium.zip"

# Setel Path Eksekutabel Chromium
$chromiumExecutable = Get-ChildItem -Path "C:\Chromium" -Filter "chrome.exe" -Recurse | Select-Object -First 1
[Environment]::SetEnvironmentVariable("CHROME_EXECUTABLE", $chromiumExecutable.FullName, "User")
```

Dengan langkah-langkah ini, Anda dapat menggunakan Chromium sebagai pengganti Google Chrome untuk kebutuhan Flutter tanpa harus menginstal aplikasi Google Chrome sepenuhnya.

_Sekarang seharusnya terlihat bahwa sebagian besar telah selesai dan 99% semua masalah berhasil teratasi._

---

### **Tambahan untuk Optimalisasi dan Keamanan**

- **Mengkonfigurasi Editor Teks:**

  Mengingat preferensi Anda terhadap lingkungan yang minimalis dan berorientasi keyboard seperti i3WM, Anda bisa mengoptimalkan Visual Studio Code dengan ekstensi dan keybindings yang sesuai. Pastikan untuk:

  - Menginstal ekstensi Flutter dan Dart.
  - Menyesuaikan keybindings untuk navigasi yang lebih efisien.
  - Menggunakan terminal terintegrasi untuk menjalankan perintah Flutter.

- **Keamanan Lingkungan Kerja:**

  Dengan latar belakang Anda di bidang cybersecurity, pertimbangkan hal berikut:

  - **Verifikasi Sumber Unduhan:**
    Selalu pastikan Anda mengunduh perangkat lunak dari sumber resmi untuk menghindari malware.

  - **Isolasi Lingkungan:**
    Gunakan mesin virtual atau containerization jika ingin menguji komponen yang mungkin berisiko.

  - **Monitoring dan Logging:**
    Aktifkan logging untuk memantau aktivitas selama instalasi dan pembangunan aplikasi.

- **Kustomisasi Lebih Lanjut:**

  Jika Anda ingin lebih mengontrol lingkungan pembangunan:

  - **Gunakan Flutter Embedder:**
    Anda bisa membangun embedder Anda sendiri untuk platform tertentu.

  - **Kontribusi ke Flutter:**
    Dengan keahlian Anda, Anda mungkin tertarik untuk melihat kode sumber Flutter dan mungkin berkontribusi.

---

### **Penutup**

Dengan mengikuti langkah-langkah di atas, Anda dapat memenuhi kebutuhan Flutter tanpa harus mengunduh Android Studio atau Visual Studio secara penuh, semuanya melalui baris perintah di PowerShell. Pendekatan ini tidak hanya efisien tetapi juga memberi Anda kontrol lebih besar atas lingkungan pengembangan Anda, sesuai dengan pendekatan Anda yang teliti dan detail.

Jika Anda tertarik untuk mengintegrasikan aspek historis atau mistis dalam pengembangan Anda, mungkin mengeksplorasi tema-tema tersebut dalam aplikasi Flutter Anda bisa menjadi proyek yang menarik.
