Penjelasan komprehensif tentang perintah PowerShell, termasuk kemampuan dasar hingga lanjutan, implementasi, dan interaksi dengan perintah lain. Perintah ini dikelompokkan berdasarkan modul dan fungsionalitas utamanya.

---

### **1. Modul Pester (Testing Framework)**

#### **Alias: Add-AssertionOperator (v5.5.0)**

- **Fungsi**: Menambahkan operator asersi kustom ke Pester untuk validasi hasil pengujian.
- **Kemampuan**:
  - Membuat operator validasi khusus (e.g., `BeEven`, `BeUpperCase`).
  - Digunakan dalam blok `Should` untuk pengujian unit.
- **Contoh**:
  ```powershell
  Add-AssertionOperator -Name "BeEven" -Test { $Value % 2 -eq 0 }
  # Penggunaan
  2 | Should -BeEven
  ```
- **Advanced**:
  - Kombinasikan dengan `-Not` untuk negasi.
  - Gunakan parameter `Alias` untuk membuat nama alternatif.

#### **Alias: Get-AssertionOperator (v5.5.0)**

- **Fungsi**: Mendaftarkan semua operator asersi yang tersedia di Pester.
- **Kemampuan**:
  - Menampilkan operator bawaan (e.g., `Be`, `HaveCount`) dan kustom.
- **Contoh**:
  ```powershell
  Get-AssertionOperator | Format-Table Name, Aliases
  ```

---

### **2. Modul Appx (MSIX Package Management)**

#### **Alias: Add-MsixPackage, Add-MsixPackageVolume, Add-MsixVolume (v2.0.1.0)**

- **Fungsi**: Menginstal paket MSIX (format aplikasi modern Windows) ke volume atau direktori.
- **Kemampuan**:
  - Menambahkan aplikasi MSIX ke sistem.
  - Mengelola volume penyimpanan untuk paket MSIX.
- **Contoh**:
  ```powershell
  Add-MsixPackage -Path "C:\App.msix" -Volume (Get-AppPackageVolume -Name "D:")
  ```
- **Advanced**:
  - Gunakan `Get-AppPackageVolume` untuk melihat volume yang tersedia.
  - Kombinasikan dengan `Dismount-MsixVolume` untuk melepaskan volume.

#### **Alias: Get-AppPackage, Get-AppPackageManifest (v2.0.1.0)**

- **Fungsi**: Mendapatkan informasi paket MSIX yang terinstal.
- **Kemampuan**:
  - Menampilkan metadata aplikasi (versi, publisher, dll.).
  - Mengekstrak manifes XML dari paket.
- **Contoh**:
  ```powershell
  Get-AppPackage -Name "*Microsoft.Office*" | Select-Object Name, Version
  Get-AppPackageManifest -Package "Microsoft.Store_2023.1.0.0" | Format-List
  ```

#### **Alias: Dismount-MsixPackageVolume (v2.0.1.0)**

- **Fungsi**: Memisahkan volume MSIX dari sistem.
- **Kemampuan**:
  - Menghapus akses ke paket MSIX di volume tertentu.
  - Berguna untuk maintenance atau pembaruan.
- **Contoh**:
  ```powershell
  Dismount-MsixPackageVolume -Volume (Get-AppPackageVolume -Name "E:")
  ```

---

### **3. Modul Dism (Deployment Image Servicing and Management)**

#### **Alias: Add-ProvisionedAppxPackage (v3.0)**

- **Fungsi**: Menambahkan paket Appx ke citra Windows yang diprovisikan (e.g., untuk deployment massal).
- **Kemampuan**:
  - Menyiapkan aplikasi untuk instalasi otomatis pada pengguna baru.
  - Mendukung parameter seperti `-LicensePath` untuk lisensi aplikasi.
- **Contoh**:
  ```powershell
  Add-ProvisionedAppxPackage -PackagePath "C:\App.appx" -SkipLicense
  ```

#### **Alias: Apply-WindowsUnattend (v3.0)**

- **Fungsi**: Menerapkan file jawaban `unattend.xml` ke citra Windows.
- **Kemampuan**:
  - Mengotomatiskan konfigurasi sistem selama instalasi Windows.
  - Menyesuaikan pengaturan regional, partisi, dll.
- **Contoh**:
  ```powershell
  Apply-WindowsUnattend -UnattendPath "C:\unattend.xml" -ImagePath "D:\Windows"
  ```

---

### **4. Modul Provisioning (Windows Provisioning)**

#### **Alias: Add-ProvisioningPackage (v3.0)**

- **Fungsi**: Menerapkan paket provisi (.ppkg) ke perangkat.
- **Kemampuan**:
  - Mengonfigurasi pengaturan sistem, kebijakan, atau aplikasi secara massal.
  - Digunakan dalam skenario Autopilot atau enterprise deployment.
- **Contoh**:
  ```powershell
  Add-ProvisioningPackage -PackagePath "C:\config.ppkg" -QuietInstall
  ```

#### **Alias: Add-TrustedProvisioningCertificate (v3.0)**

- **Fungsi**: Menambahkan sertifikat tepercaya untuk proses provisi.
- **Kemampuan**:
  - Memvalidasi paket provisi yang ditandatangani secara digital.
  - Menjamin keamanan deployment.
- **Contoh**:
  ```powershell
  Add-TrustedProvisioningCertificate -CertificatePath "C:\cert.pfx"
  ```

---

### **5. Modul WebAdministration (IIS Management)**

#### **Alias: Begin-WebCommitDelay, End-WebCommitDelay (v1.0.0.0)**

- **Fungsi**: Menunda komit perubahan ke konfigurasi IIS untuk transaksi batch.
- **Kemampuan**:
  - Mengelompokkan perubahan konfigurasi IIS (e.g., situs, aplikasi pool).
  - Mencegah pemblokiran file `applicationHost.config`.
- **Contoh**:
  ```powershell
  Begin-WebCommitDelay
  New-WebSite -Name "TestSite" -Port 8080
  Set-WebAppPoolState -Name "DefaultAppPool" -Started
  End-WebCommitDelay
  ```

---

### **6. Modul Storage & VMDirectStorage (Disk Management)**

#### **Alias: Enable/Disable-PhysicalDiskIndication (v2.0.0.0)**

- **Fungsi**: Mengaktifkan/menonaktifkan indikator LED pada disk fisik (e.g., untuk identifikasi).
- **Kemampuan**:
  - Berguna dalam lingkungan penyimpanan besar dengan banyak disk.
  - Hanya bekerja pada hardware yang mendukung.
- **Contoh**:
  ```powershell
  Get-PhysicalDisk | Enable-PhysicalDiskIndication
  ```

#### **Alias: Flush-Volume (v2.0.0.0)**

- **Fungsi**: Memastikan semua data tertulis ke disk (flush cache).
- **Kemampuan**:
  - Menghindari kehilangan data setelah operasi tulis kritis.
- **Contoh**:
  ```powershell
  Flush-Volume -DriveLetter "D"
  ```

---

### **7. Modul AutomatedLabCore (Lab Management)**

#### **Alias: Disable-LabHostRemoting (v5.50.0)**

- **Fungsi**: Menonaktifkan remoting PowerShell pada host lab.
- **Kemampuan**:
  - Meningkatkan keamanan dengan membatasi akses jarak jauh.
  - Digunakan dalam skenario lab terisolasi.
- **Contoh**:
  ```powershell
  Disable-LabHostRemoting -Force
  ```

---

### **8. Modul PSFramework (PowerShell Framework)**

#### **Alias: Get-LastResult (v1.9.310)**

- **Fungsi**: Mendapatkan hasil eksekusi perintah terakhir dalam framework.
- **Kemampuan**:
  - Debugging eksekusi skrip yang kompleks.
  - Menampilkan pesan error, durasi, dan status.
- **Contoh**:
  ```powershell
  Invoke-SomeCommand -ErrorAction SilentlyContinue
  Get-LastResult | Format-List
  ```

---

### **Best Practices & Advanced Scenarios**

1. **Pipeline Integration**:

   ```powershell
   # Contoh: Nonaktifkan indikator LED untuk semua disk berstatus "Unhealthy"
   Get-PhysicalDisk | Where-Object HealthStatus -ne "Healthy" | Disable-PhysicalDiskIndication
   ```

2. **Error Handling**:

   ```powershell
   try {
       Add-MsixPackage -Path "C:\Broken.msix" -ErrorAction Stop
   } catch {
       Get-AppPackageLastError | Out-File "C:\Error.log"
   }
   ```

3. **Automated Deployment**:

   ```powershell
   # Deploy aplikasi ke citra Windows
   Add-ProvisionedAppxPackage -PackagePath "C:\App.appx" -Path "D:\Mount"
   Apply-WindowsUnattend -ImagePath "D:\Mount" -UnattendPath "C:\unattend.xml"
   ```

4. **Combining Modules**:
   ```powershell
   # Setelah menambahkan paket MSIX, validasi dengan Pester
   Add-MsixPackage -Path "C:\App.msix"
   Describe "MSIX Test" {
       It "Should be installed" {
           (Get-AppPackage -Name "App").Status | Should -Be "Ok"
       }
   }
   ```

---

### **Catatan Versi dan Kompatibilitas**

- Beberapa cmdlet (e.g., `VMDirectStorage`) khusus untuk lingkungan virtualisasi.
- Pastikan modul diimpor dengan `Import-Module <NamaModul>` sebelum digunakan.
- Gunakan `Get-Command -Module <NamaModul>` untuk melihat daftar lengkap cmdlet.
