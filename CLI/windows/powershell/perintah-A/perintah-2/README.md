_**Windows PowerShell**_

_Copyright (C) Microsoft Corporation. All rights reserved._

_Install the latest PowerShell for new features and improvements! https://aka.ms/PSWindows_

_Loading personal and system profiles took 751ms._

> Get-Command

**CommandType Name Version Source**

---

### Perintah-perintah ini berkaitan dengan manajemen paket aplikasi (Appx) dan penyebaran aplikasi di Windows melalui PowerShell dan DISM

---

### **1. Add-AppPackage**

- **Deskripsi**:

  `Add-AppPackage` adalah alias untuk perintah yang digunakan untuk menambahkan atau menginstal paket aplikasi bersifat Appx atau AppxBundle ke akun pengguna saat ini. Ini berguna saat Anda ingin menginstal aplikasi yang tidak tersedia melalui Microsoft Store, seperti aplikasi internal perusahaan atau aplikasi yang dikembangkan sendiri.

- **Penggunaan Umum**:

  - Menginstal aplikasi UWP (Universal Windows Platform) secara manual.
  - Menguji aplikasi yang dikembangkan sebelum didistribusikan.
  - Menginstal aplikasi di lingkungan yang tidak memiliki akses ke Microsoft Store.

- **Contoh Penggunaan**:

  ```powershell
  Add-AppPackage -Path "C:\Apps\ContohAplikasi.appx"
  ```

  Perintah ini akan menginstal aplikasi yang berada di `C:\Apps\ContohAplikasi.appx` untuk pengguna saat ini.

- **Parameter Penting**:

  - `-Path`: Menentukan path lengkap ke file paket aplikasi (.appx atau .appxbundle) yang akan diinstal.
  - `-DependencyPath`: Menentukan path ke paket dependensi yang diperlukan oleh aplikasi.
  - `-Register`: Mendaftarkan aplikasi tanpa menginstalnya, sering digunakan untuk pengembangan.

---

### **2. Add-AppPackageVolume**

- **Deskripsi**:

  `Add-AppPackageVolume` adalah perintah yang digunakan untuk menambahkan volume penyimpanan aplikasi (Appx Volume) ke sistem Windows Anda. Dengan menambahkan volume baru, Anda dapat mengatur di mana aplikasi dan data terkait disimpan, yang berguna untuk manajemen penyimpanan dan organisasi data.

- **Penggunaan Umum**:

  - Mengarahkan instalasi aplikasi ke drive atau partisi tertentu.
  - Mengelola ruang penyimpanan dengan mendistribusikan aplikasi ke berbagai volume.
  - Menyiapkan lingkungan dengan konfigurasi penyimpanan khusus.

- **Contoh Penggunaan**:

  ```powershell
  Add-AppPackageVolume -Volume "E:\"
  ```

  Perintah ini akan menambahkan drive E sebagai volume penyimpanan aplikasi. Setelah ditambahkan, Anda dapat mengatur volume ini sebagai lokasi default untuk instalasi aplikasi baru.

- **Parameter Penting**:

  - `-Volume`: Menentukan huruf drive atau path ke volume yang akan ditambahkan sebagai Appx Volume.
  - `-MountPoint`: Alternatif untuk menentukan titik mount volume jika menggunakan sistem penyimpanan yang kompleks.

---

### **3. Add-AppProvisionedPackage**

- **Deskripsi**:

  `Add-AppProvisionedPackage` adalah perintah yang digunakan melalui DISM (Deployment Image Servicing and Management) untuk menambahkan paket aplikasi yang diprovisikan ke image Windows. Aplikasi yang diprovisikan akan diinstal secara otomatis untuk semua pengguna baru yang dibuat pada sistem tersebut.

- **Penggunaan Umum**:

  - Menyiapkan image Windows kustom untuk penyebaran massal.
  - Memastikan aplikasi penting tersedia untuk setiap pengguna tanpa instalasi manual.
  - Mengelola aplikasi default yang akan disertakan dalam instalasi sistem.

- **Contoh Penggunaan**:

  ```powershell
  Add-AppProvisionedPackage -Online -PackagePath "C:\Packages\AplikasiPerusahaan.appx" -LicensePath "C:\Licenses\AplikasiPerusahaan\License.xml"
  ```

  Perintah ini menambahkan `AplikasiPerusahaan.appx` ke image Windows yang sedang berjalan (-Online), sehingga setiap pengguna baru akan memiliki aplikasi ini terinstal secara otomatis.

- **Parameter Penting**:

  - `-Online`: Menyatakan bahwa operasi dilakukan pada sistem operasi saat ini.
  - `-PackagePath`: Menentukan path ke paket aplikasi yang akan ditambahkan.
  - `-LicensePath`: Menentukan path ke file lisensi aplikasi, jika diperlukan.
  - `-SkipLicense`: Menginstruksikan DISM untuk mengabaikan pemasangan lisensi.

---

### **Pemanfaatan dan Contoh Praktis**

Mari kita lihat bagaimana perintah-perintah ini dapat digunakan dalam situasi nyata:

#### **A. Menginstal Aplikasi UWP Secara Manual**

Jika Anda seorang pengembang yang ingin menguji aplikasi UWP sebelum dirilis, atau Anda memiliki aplikasi dari sumber tepercaya di luar Microsoft Store, Anda dapat menggunakan `Add-AppPackage`:

```powershell
Add-AppPackage -Path "C:\Develop\MyApp.appx"
```

#### **B. Mengelola Ruang Penyimpanan Aplikasi**

Jika drive sistem Anda hampir penuh, Anda dapat menambahkan drive lain sebagai lokasi instalasi aplikasi:

```powershell
Add-AppPackageVolume -Volume "D:\"
Set-AppPackageDefaultVolume -Volume (Get-AppxVolume -Path "D:\")
```

Sekarang, semua aplikasi baru akan diinstal ke drive D.

#### **C. Menyiapkan Image Windows dengan Aplikasi Khusus**

Dalam lingkungan perusahaan, Anda mungkin ingin setiap komputer baru memiliki serangkaian aplikasi standar:

```powershell
Add-AppProvisionedPackage -Online -PackagePath "\\Server\Deploy\CRMApp.appx" -LicensePath "\\Server\Deploy\CRMAppLicense.xml"
```

Dengan begitu, setiap karyawan baru akan memiliki aplikasi CRM siap pakai.

---

### **Tips dan Trik**

- **Memeriksa Daftar Appx Volume yang Ada**:

  Untuk melihat volume yang saat ini terdaftar:

  ```powershell
  Get-AppxVolume
  ```

- **Mengatur Volume Default untuk Instalasi Aplikasi**:

  Setelah menambahkan volume baru:

  ```powershell
  Set-AppxDefaultVolume -Volume (Get-AppxVolume -Path "D:\")
  ```

- **Mengelola Aplikasi Provisioned yang Sudah Terpasang**:

  Melihat daftar aplikasi provisioned:

  ```powershell
  Get-AppProvisionedPackage -Online
  ```

  Menghapus aplikasi provisioned:

  ```powershell
  Remove-AppProvisionedPackage -Online -PackageName "Nama.Paket.Aplikasi"
  ```

- **Menginstal Aplikasi dengan Dependencies**:

  Jika aplikasi memerlukan paket pendukung:

  ```powershell
  Add-AppPackage -Path "C:\Apps\MainApp.appx" -DependencyPath "C:\Apps\Dependency1.appx","C:\Apps\Dependency2.appx"
  ```

---

### **Pertimbangan Keamanan dan Izin**

- **Jalankan sebagai Administrator**: Beberapa perintah memerlukan hak istimewa administrator. Jalankan PowerShell dengan hak administrator untuk menghindari masalah izin.

- **Sumber Terpercaya**: Hanya instal aplikasi dari sumber yang Anda percayai untuk mencegah risiko keamanan.

- **Periksa Ketersediaan Lisensi**: Pastikan Anda memiliki lisensi yang benar saat menginstal aplikasi berlisensi.

- **Cadangkan Sistem**: Sebelum melakukan perubahan signifikan, terutama pada image Windows, lakukan backup untuk menghindari kehilangan data.

---

### **Memecahkan Masalah Umum**

- **Kesalahan Izin**: Jika Anda mendapatkan pesan kesalahan terkait izin, pastikan Anda menjalankan PowerShell sebagai administrator.

- **Paket Tidak Valid**: Jika paket aplikasi tidak dapat diinstal, periksa apakah file tersebut tidak korup dan berasal dari sumber tepercaya.

- **Dependensi Hilang**: Jika aplikasi memerlukan dependensi, pastikan semua paket dependensi disertakan dalam perintah `Add-AppPackage`.

---

### **Mendalami Lebih Lanjut**

Untuk memperluas pengetahuan Anda tentang manajemen aplikasi dan penyebaran di Windows:

- **Pelajari Modul DISM**: DISM adalah alat yang kuat untuk menangani image Windows dan dapat melakukan lebih dari sekadar menambahkan aplikasi.

- **Eksplorasi Appx Cmdlets**: Gunakan `Get-Command -Module Appx` untuk melihat semua cmdlet yang tersedia dalam modul Appx.

- **Otomatisasi dengan Skrip**: Buat skrip PowerShell untuk mengotomatisasi penyebaran aplikasi dan konfigurasi sistem, yang berguna dalam lingkungan skala besar.

- **Mengikuti Update Teknologi**: Teknologi selalu berkembang. Ikuti blog dan dokumentasi resmi Microsoft untuk informasi terbaru.

---

### **Sumber Daya Tambahan**

- **Dokumentasi Resmi Microsoft**:

  - [Add-AppxPackage](https://docs.microsoft.com/id-id/powershell/module/appx/add-appxpackage)
  - [Add-AppxProvisionedPackage](https://docs.microsoft.com/id-id/windows-hardware/manufacture/desktop/dism-provisioning-commands)

- **Komunitas dan Forum**:

  - **Microsoft Tech Community**: Tempat berdiskusi dan bertanya.
  - **Stack Overflow**: Untuk solusi pemecahan masalah spesifik.

- **Buku dan Kursus Online**:

  - **"Learn PowerShell in a Month of Lunches"**: Buku bagus untuk memperdalam pemahaman PowerShell.
  - **Microsoft Virtual Academy**: Menawarkan kursus gratis tentang berbagai topik teknologi.

> Copilot
