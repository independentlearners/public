Berikut lanjutan penjelasan komprehensif untuk perintah PowerShell yang telah dikelompokkan berdasarkan modul dan fungsionalitasnya.

---

### **1. Modul Appx (MSIX Package Management)**

#### **Alias: Get-MsixLog, Get-MsixPackage, Get-MsixPackageVolume (v2.0.1.0)**

- **Fungsi**: Mengelola log, metadata, dan volume paket MSIX.
  - **Get-MsixLog**: Mengambil log operasi MSIX untuk troubleshooting.
  - **Get-MsixPackage**: Menampilkan daftar paket MSIX yang terinstal.
  - **Get-MsixPackageVolume**: Melihat volume tempat paket MSIX disimpan.
- **Contoh**:

  ```powershell
  # Cari paket Microsoft Teams
  Get-MsixPackage -Name "*Teams*"

  # Ekspor log MSIX ke file
  Get-MsixLog | Out-File "C:\MsixLog.txt"

  # Tampilkan volume dengan paket MSIX
  Get-MsixPackageVolume | Format-Table Name, FreeSpace
  ```

#### **Alias: Mount-MsixVolume, Remove-MsixPackage (v2.0.1.0)**

- **Fungsi**:
  - **Mount-MsixVolume**: Memasang volume MSIX ke sistem.
  - **Remove-MsixPackage**: Menghapus paket MSIX yang terinstal.
- **Contoh**:

  ```powershell
  # Pasang volume MSIX dari direktori
  Mount-MsixVolume -Path "D:\MsixStorage"

  # Hapus aplikasi MSIX
  Remove-MsixPackage -Package "ContosoApp_1.0.0.0_x64__abcd1234"
  ```

#### **Alias: Move-MsixPackage (v2.0.1.0)**

- **Fungsi**: Memindahkan paket MSIX antar volume.
- **Kemampuan**:
  - Berguna untuk mengoptimalkan penyimpanan atau migrasi data.
- **Contoh**:
  ```powershell
  Move-MsixPackage -Package "AppXPackage" -DestinationVolume (Get-MsixPackageVolume -Name "E:")
  ```

---

### **2. Modul Storage & VMDirectStorage (Manajemen Disk)**

#### **Alias: Get-PhysicalDiskSNV, Get-StorageEnclosureSNV (v2.0.0.0)**

- **Fungsi**:
  - **Get-PhysicalDiskSNV**: Mendapatkan informasi **Serial Number Vendor (SNV)** disk fisik.
  - **Get-StorageEnclosureSNV**: Melihat SNV enclosure penyimpanan.
- **Kegunaan**:
  - Audit inventaris hardware.
  - Validasi keaslian disk dalam lingkungan enterprise.
- **Contoh**:

  ```powershell
  # Tampilkan SNV semua disk
  Get-PhysicalDisk | Get-PhysicalDiskSNV | Format-Table DeviceId, SerialNumber

  # Cek SNV enclosure
  Get-StorageEnclosure | Get-StorageEnclosureSNV
  ```

#### **Alias: Initialize-Volume (v2.0.0.0)**

- **Fungsi**: Menginisialisasi volume baru (format partisi).
- **Kemampuan**:
  - Menentukan sistem file (NTFS, ReFS) dan label volume.
  - Mendukung parameter `-FileSystem` dan `-AllocationUnitSize`.
- **Contoh**:
  ```powershell
  Initialize-Volume -DriveLetter "F" -FileSystem NTFS -NewFileSystemLabel "DataDrive"
  ```

---

### **3. Modul Dism (Deployment Image Servicing)**

#### **Alias: Get-ProvisionedAppPackage, Remove-ProvisionedAppPackage (v3.0)**

- **Fungsi**:
  - **Get-ProvisionedAppPackage**: Melihat daftar paket Appx yang diprovisikan di citra Windows.
  - **Remove-ProvisionedAppPackage**: Menghapus paket dari citra.
- **Contoh**:
  ```powershell
  # Hapus aplikasi Xbox yang diprovisikan
  Get-ProvisionedAppPackage -Path "C:\WindowsImage" | Where-Object DisplayName -like "*Xbox*" | Remove-ProvisionedAppPackage
  ```

#### **Alias: Optimize-ProvisionedAppPackages (v3.0)**

- **Fungsi**: Mengoptimalkan ukuran citra Windows dengan menghapus cache paket yang tidak diperlukan.
- **Kegunaan**:
  - Mengurangi ukuran citra untuk deployment yang lebih efisien.
- **Contoh**:
  ```powershell
  Optimize-ProvisionedAppPackages -Path "C:\WindowsImage"
  ```

---

### **4. Modul LanguagePackManagement**

#### **Alias: Get-PreferredLanguage, Get-SystemLanguage (v1.0)**

- **Fungsi**:
  - **Get-PreferredLanguage**: Menampilkan bahasa preferensi pengguna saat ini.
  - **Get-SystemLanguage**: Melihat bahasa default sistem.
- **Contoh**:
  ```powershell
  # Ubah bahasa sistem
  Set-SystemLanguage -Language "fr-FR"
  Get-SystemLanguage
  ```

---

### **5. Modul xDscDiagnostics**

#### **Alias: Get-xDscDiagnosticsZip (v2.8.0)**

- **Fungsi**: Membuat file ZIP berisi log DSC (Desired State Configuration) untuk analisis error.
- **Contoh**:
  ```powershell
  Get-xDscDiagnosticsZip -OutputPath "C:\DscLogs.zip"
  ```

---

### **6. Modul SmbWitness**

#### **Alias: Move-SmbClient (v2.0.0.0)**

- **Fungsi**: Memindahkan koneksi SMB client ke node lain dalam cluster failover.
- **Kegunaan**:
  - Maintenance server tanpa downtime.
  - Load balancing koneksi SMB.
- **Contoh**:
  ```powershell
  Move-SmbClient -ClientName "Client01" -DestinationNode "FileServer02"
  ```

---

### **7. Modul EventTracingManagement**

#### **Alias: Remove-EtwTraceSession (v1.0.0.0)**

- **Fungsi**: Menghentikan dan menghapus sesi ETW (Event Tracing for Windows).
- **Kegunaan**:
  - Membersihkan sesi trace setelah debugging kinerja.
- **Contoh**:
  ```powershell
  Remove-EtwTraceSession -Name "MyTraceSession"
  ```

---

### **8. Modul Provisioning**

#### **Alias: Remove-ProvisioningPackage (v3.0)**

- **Fungsi**: Menghapus paket provisi (.ppkg) dari perangkat.
- **Contoh**:
  ```powershell
  Remove-ProvisioningPackage -PackageId "ContosoConfig_2023"
  ```

---

### **Best Practices & Advanced Scenarios**

#### **1. Automatisasi Deployment MSIX**

```powershell
# Pasang volume MSIX, tambahkan paket, lalu optimalkan
Mount-MsixVolume -Path "\\Server\MsixRepo"
Add-MsixPackage -Path "\\Server\MsixRepo\App.msix"
Optimize-ProvisionedAppPackages -Path "C:\WindowsImage"
```

#### **2. Audit Bahasa dan Lokalisasi**

```powershell
# Ekspor preferensi bahasa pengguna dan sistem ke CSV
Get-PreferredLanguage | Export-Csv -Path "C:\Languages.csv"
Get-SystemLanguage | Export-Csv -Path "C:\SystemLang.csv"
```

#### **3. Manajemen Disk Otomatis**

```powershell
# Inisialisasi disk baru dan pasang sebagai volume MSIX
Initialize-Volume -DiskNumber 1 -PartitionStyle GPT -DriveLetter "G"
Mount-MsixPackageVolume -DriveLetter "G"
```

#### **4. Troubleshooting dengan Log**

```powershell
# Ambil log MSIX dan DSC untuk analisis
Get-MsixLog | Where-Object Message -like "*error*" | Out-File "C:\MsixErrors.log"
Get-xDscDiagnosticsZip -OutputPath "C:\DscLogs.zip"
```

---

### **Catatan Versi dan Batasan**

- **VMDirectStorage**: Khusus untuk lingkungan virtual (Hyper-V/Azure).
- **Dism**: Hanya bekerja pada citra Windows yang dimount.
- **Appx**: Membutuhkan hak admin untuk menambah/menghapus paket.


