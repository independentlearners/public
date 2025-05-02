Penjelasan mendalam mengenai fungsi-fungsi berikut, mulai dari tujuan dasar, kemampuan lanjutan, contoh pemakaian, hingga cara integrasinya ke dalam skrip automasi. Disini akan mengelompokkan fungsi-fungsi tersebut berdasarkan modul asalnya, sehingga kita dapat lebih mudah memahami konteks penggunaannya masing-masing.

---

## I. Modul **PSFramework**

### 1. `Add-PSFFilterCondition` (Versi 1.9.310)

- **Tujuan & Kegunaan:**  
  Fungsi ini digunakan untuk menambahkan kondisi filter di dalam _PSFramework_. Filter ini berperan untuk menentukan apakah pesan log atau event tertentu harus diproses atau harus dilewati. Dengan kata lain, Anda dapat menyaring output log sehingga hanya peristiwa yang memenuhi kriteria yang Anda tentukan yang akan tercatat.
- **Kemampuan Lanjutan:**
  - Menyaring log berdasarkan level (misalnya, Debug, Info, Warning, Error).
  - Menggabungkan beberapa kondisi agar log yang kompleks hanya tercatat jika seluruh kondisi terpenuhi.
- **Contoh Implementasi:**
  ```powershell
  Add-PSFFilterCondition -Name "FilterErrorEvents" -Condition {
      $_.Level -eq "Error" -and $_.Source -eq "MyApplication"
  }
  ```
  Di atas, hanya event dengan level "Error" dan berasal dari "MyApplication" yang akan diloloskan.

---

### 2. `Add-PSFLoggingProviderRunspace` (Versi 1.9.310)

- **Tujuan & Kegunaan:**  
  Fungsi ini menambahkan sebuah _logging provider_ ke runspace tertentu. Dalam konteks PSFramework, ketika Anda menjalankan beberapa runspace (misalnya, untuk eksekusi paralel), masing-masing runspace dapat memiliki konfigurasi logging tersendiri.
- **Kemampuan Lanjutan:**
  - Mengarahkan log dari runspace tertentu ke file, konsol, atau sistem logging terpusat.
  - Mengkonfigurasi format dan detail level log secara spesifik untuk runspace tersebut.
- **Contoh Implementasi:**
  ```powershell
  Add-PSFLoggingProviderRunspace -RunspaceId $Runspace.Id -Provider "FileLogger" -LogFilePath "C:\Logs\Runspace_$($Runspace.Id).log"
  ```
  Ini memastikan setiap runspace menulis log-nya ke file yang terpisah, sehingga memudahkan troubleshooting di lingkungan paralel.

---

## II. Modul **Pester**

Pester adalah framework testing PowerShell yang populer. Fungsi-fungsi berikut mendukung penulisan dan eksekusi unit test, serta memverifikasi mock dan perilaku tes.

### 3. `Add-ShouldOperator` (Versi 5.5.0)

- **Tujuan & Kegunaan:**  
  Fungsi ini digunakan untuk menambahkan operator baru ke sistem “Should” di Pester. Nilai tambah ini memungkinkan Anda mendefinisikan logika perbandingan khusus atau kondisi asersi yang tidak disediakan secara default.
- **Kemampuan Lanjutan:**
  - Memungkinkan ekspansi operator asersi untuk tipe data yang kompleks.
  - Menyediakan fleksibilitas untuk menghasilkan pesan error yang lebih spesifik.
- **Contoh Implementasi:**
  ```powershell
  Add-ShouldOperator -OperatorName "ShouldBeEven" -ScriptBlock {
      param($Actual)
      return ($Actual % 2) -eq 0
  }
  # Dalam sebuah test:
  4 | ShouldBeEven
  ```

### 4. Fungsi **AfterAll/AfterEach/Assert-MockCalled/Assert-VerifiableMock(s)**

Pester menyediakan dua versi (misalnya, 5.5.0 dan 3.4.0) yang mencerminkan evolusi framework tersebut.

- **AfterAll (5.5.0 & 3.4.0):**  
  Menjalankan blok kode setelah semua tes dalam satu konteks selesai. Berguna untuk pembersihan sumber daya atau verifikasi akhir.

  ```powershell
  AfterAll {
      # Eksekusi pembersihan global
      Write-Host "Semua test telah selesai."
  }
  ```

- **AfterEach (5.5.0 & 3.4.0):**  
  Menjalankan blok kode setelah masing-masing test, berguna untuk reset state.

  ```powershell
  AfterEach {
      # Reset konfigurasi atau variabel global antar test
      $Global:TestState = $null
  }
  ```

- **Assert-MockCalled (5.5.0 & 3.4.0):**  
  Memastikan bahwa sebuah fungsi mock telah dipanggil dengan parameter yang diharapkan.

  ```powershell
  # Dalam skenario mock:
  Assert-MockCalled -CommandName Get-Data -Times 1
  ```

- **Assert-VerifiableMock / Assert-VerifiableMocks:**  
  Validasi bahwa semua ekspektasi pada mock telah terpenuhi sesuai dengan skenario yang diharapkan.
  ```powershell
  Assert-VerifiableMocks
  ```

---

## III. Modul **Storage**

Fungsi-fungsi di modul ini berkaitan dengan pengelolaan dan konfigurasi storage, baik untuk infrastruktur lokal maupun untuk storage area network (SAN).

### 5. `Add-StorageFaultDomain` (Versi 2.0.0.0)

- **Tujuan & Kegunaan:**  
  Menambahkan fault domain ke dalam konfigurasi storage. Fault domain mengelompokkan disk atau node berdasarkan risiko kegagalan bersama, sehingga perancangan redundancy dapat dioptimalkan.
- **Contoh Implementasi:**
  ```powershell
  Add-StorageFaultDomain -StoragePool "Pool1" -FaultDomainNumber 1
  ```

### 6. `Add-TargetPortToMaskingSet` (Versi 2.0.0.0)

- **Tujuan & Kegunaan:**  
  Mengaitkan suatu target port ke dalam masking set, yang merupakan mekanisme pada storage array untuk mengontrol akses ke LUN (Logical Unit Number).
- **Contoh Implementasi:**
  ```powershell
  Add-TargetPortToMaskingSet -MaskingSetId "MS001" -TargetPort "PortA"
  ```

### 7. `Add-VirtualDiskToMaskingSet` (Versi 2.0.0.0)

- **Tujuan & Kegunaan:**  
  Menambahkan virtual disk ke masking set, memastikan virtual disk tersebut hanya dapat diakses sesuai kebijakan masking set.
- **Contoh Implementasi:**
  ```powershell
  Add-VirtualDiskToMaskingSet -MaskingSetId "MS001" -VirtualDiskName "VDisk01"
  ```

### 8. `Add-VMDirectVirtualDisk` (Versi 1.0.0.0 dari modul VMDirectStorage)

- **Tujuan & Kegunaan:**  
  Memungkinkan penambahan virtual disk secara langsung ke mesin virtual, yang dapat memberikan performa mendekati native. Cocok untuk lingkungan yang membutuhkan I/O intensif, seperti database.
- **Contoh Implementasi:**
  ```powershell
  Add-VMDirectVirtualDisk -VMName "LabVM01" -VirtualDiskPath "C:\VHDs\Disk01.vhdx"
  ```

---

## IV. Modul **AutomatedLab** (AutomatedLab.Common & AutomatedLabUnattended)

Modul-modul ini mendukung pembuatan dan konfigurasi lab otomatis untuk lingkungan pengujian dan simulasi.

### 9. `Add-StringIncrement` (Versi 2.3.17 dari AutomatedLab.Common)

- **Tujuan & Kegunaan:**  
  Sebuah utilitas untuk menginkrementasi string. Misalnya, jika Anda memiliki nama "Server01", fungsi ini dapat menghasilkan "Server02" secara otomatis.
- **Contoh Implementasi:**
  ```powershell
  $nextName = Add-StringIncrement -InputString "Server01"
  # Menghasilkan "Server02"
  ```

### 10. `Add-TfsAgentUserCapability` (Versi 2.3.17 dari AutomatedLab.Common)

- **Tujuan & Kegunaan:**  
  Fungsi ini menambahkan kemampuan pengguna (capability) pada agen TFS (Team Foundation Server) dalam lab, memungkinkan agen tersebut untuk menjalankan tugas build atau test sesuai peran yang didefinisikan.
- **Contoh Implementasi:**
  ```powershell
  Add-TfsAgentUserCapability -AgentName "Agent01" -Capability "DockerSupport"
  ```

### 11. `Add-VariableToPSSession` (Versi 2.3.17 dari AutomatedLab.Common)

- **Tujuan & Kegunaan:**  
  Memastikan variabel lokal tersedia di dalam sesi remote PowerShell. Hal ini sangat berguna saat menyebarkan konfigurasi atau data antar sesi.
- **Contoh Implementasi:**
  ```powershell
  $data = "Konfigurasi Lab"
  Add-VariableToPSSession -Session $session -Name "LabConfig" -Value $data
  ```

### 12. `Add-UnattendedNetworkAdapter` (Versi 5.50.0 dari AutomatedLabUnattended)

- **Tujuan & Kegunaan:**  
  Mengonfigurasi adaptor jaringan secara otomatis dalam skenario instalasi tanpa pengawasan.
- **Contoh Implementasi:**
  ```powershell
  Add-UnattendedNetworkAdapter -AdapterName "Ethernet0" -StaticIP "192.168.10.50" -SubnetMask "255.255.255.0"
  ```

### 13. `Add-UnattendedRenameNetworkAdapters` (Versi 5.50.0 dari AutomatedLabUnattended)

- **Tujuan & Kegunaan:**  
  Membantu mengubah nama adaptor jaringan secara otomatis selama instalasi lab, untuk menjaga konsistensi penamaan.
- **Contoh Implementasi:**
  ```powershell
  Add-UnattendedRenameNetworkAdapters -CurrentName "Ethernet 3" -NewName "DataAdapter"
  ```

### 14. `Add-UnattendedSynchronousCommand` (Versi 5.50.0 dari AutomatedLabUnattended)

- **Tujuan & Kegunaan:**  
  Menambahkan perintah yang harus dijalankan secara sinkron pada proses instalasi atau konfigurasi lab tanpa interaksi pengguna.
- **Contoh Implementasi:**
  ```powershell
  Add-UnattendedSynchronousCommand -Command "Restart-Service -Name wuauserv"
  ```

---

## V. Modul **VpnClient**

Fungsi-fungsi ini digunakan untuk mengonfigurasi koneksi VPN dan menyesuaikan trigger-nya sehingga koneksi dapat aktif secara otomatis berdasarkan kondisi tertentu.

### 15. `Add-VpnConnection` (Versi 2.0.0.0)

- **Tujuan & Kegunaan:**  
  Menambahkan konfigurasi koneksi VPN ke sistem Windows. Anda dapat menentukan parameter seperti nama koneksi, server, tipe tunnel, autentikasi, dan sebagainya.
- **Contoh Implementasi:**
  ```powershell
  Add-VpnConnection -Name "MyVPN" -ServerAddress "vpn.example.com" -TunnelType "IKEv2" -AuthenticationMethod "EAP"
  ```

### 16. `Add-VpnConnectionRoute` (Versi 2.0.0.0)

- **Tujuan & Kegunaan:**  
  Menambahkan rute statis khusus ke dalam koneksi VPN, agar trafik ke jaringan tertentu diarahkan melalui VPN.
- **Contoh Implementasi:**
  ```powershell
  Add-VpnConnectionRoute -ConnectionName "MyVPN" -DestinationPrefix "10.10.0.0/16" -RouteMetric 1
  ```

### 17. `Add-VpnConnectionTriggerApplication` (Versi 2.0.0.0)

- **Tujuan & Kegunaan:**  
  Mengonfigurasi VPN agar secara otomatis terhubung ketika aplikasi tertentu diluncurkan.
- **Contoh Implementasi:**
  ```powershell
  Add-VpnConnectionTriggerApplication -ConnectionName "MyVPN" -Application "chrome.exe"
  ```

### 18. `Add-VpnConnectionTriggerDnsConfiguration` (Versi 2.0.0.0)

- **Tujuan & Kegunaan:**  
  Memungkinkan konfigurasi pemicu VPN berdasarkan pengaturan DNS tertentu. Misalnya, ketika koneksi ke domain spesifik terdeteksi.
- **Contoh Implementasi:**
  ```powershell
  Add-VpnConnectionTriggerDnsConfiguration -ConnectionName "MyVPN" -DnsSuffix "contoso.local"
  ```

### 19. `Add-VpnConnectionTriggerTrustedNetwork` (Versi 2.0.0.0)

- **Tujuan & Kegunaan:**  
  Menetapkan pemicu yang menghubungkan atau memutuskan VPN berdasarkan jaringan tepercaya; jika Anda terdeteksi berada di jaringan yang dianggap aman, VPN dapat secara otomatis dinonaktifkan.
- **Contoh Implementasi:**
  ```powershell
  Add-VpnConnectionTriggerTrustedNetwork -ConnectionName "MyVPN" -TrustedNetwork "OfficeWiFi"
  ```

---

## VI. Integrasi Fungsi Testing dengan **Pester**

Selain fungsi _assertion_ yang telah disebutkan sebelumnya, berikut adalah ringkasan singkat:

- **AfterAll & AfterEach:**  
  Menyusun blok kode pembersihan yang berjalan setelah seluruh tes atau setelah tiap tes, meminimalkan _side effects_ pada pengujian.
- **Assert-MockCalled:**  
  Memverifikasi bahwa mock (fungsi tiruan) dipanggil sesuai ekspektasi—memastikan bahwa logika kontrol dalam skrip test Anda berjalan dengan benar.
- **Assert-VerifiableMock(s):**  
  Memastikan bahwa semua ekspektasi pada mock telah terpenuhi, sehingga bisa menangkap setiap ketidaksesuaian dalam perilaku test.

Kedua versi (misalnya, 5.5.0 dan 3.4.0) ditawarkan karena Pester telah berkembang seiring waktu. Perbedaan utamanya terletak pada parameter dan fitur tambahan yang mendukung skenario testing modern.

---

## VII. Best Practices dan Skenario Integrasi

1. **Penggunaan Modular & Pipeline:**
   - Pecahlah skrip kompleks menjadi blok fungsi terpisah.
   - Gunakan pipeline untuk mengoper output satu fungsi ke fungsi lain bila memungkinkan.
2. **Logging dan Debugging:**

   - Gabungkan `Add-PSFFilterCondition` dan `Add-PSFLoggingProviderRunspace` untuk memantau aktivitas skrip di lingkungan fungsional yang paralel.
   - Selalu sertakan logging pada fungsi yang mengubah konfigurasi sistem—misalnya saat menggunakan fungsi VPN atau storage—untuk memudahkan troubleshooting.

3. **Automasi Lab:**

   - Fungsi dari `AutomatedLab.Common` dan `AutomatedLabUnattended` memungkinkan skenario deployment lab secara otomatis.
   - Kombinasikan dengan fungsi seperti `Add-VariableToPSSession` untuk mensinkronisasi variabel antar sesi saat mengelola beberapa mesin virtual atau node dalam lab.

4. **VPN dan Jaringan:**
   - Saat mengonfigurasi VPN dengan trigger, uji secara menyeluruh baik secara manual maupun dalam test otomatis menggunakan Pester agar pemicu aktif seperti yang diharapkan.
5. **Testing Otomatis:**
   - Manfaatkan Pester untuk membuat suite test yang memastikan bahwa fungsi-fungsi Anda (misalnya, integrasi VPN atau storage) berperilaku tepat.
   - Gunakan `Add-ShouldOperator` untuk memperluas asersi khusus bila diperlukan.

---

## Kesimpulan

Fungsi-fungsi yang telah dibahas menyediakan sejumlah kemampuan yang sangat beragam:

- **PSFramework:** Memperluas logging dan filtering, sangat berguna di aplikasi besar yang memerlukan pengelolaan runspace dan logging terpisah.
- **Pester:** Meningkatkan kemampuan testing dengan dukungan custom operator, blok post-test (AfterAll/AfterEach), dan verifikasi panggilan mock yang ketat.
- **Storage:** Mengelola aspek storage seperti fault domain, masking set, dan integrasi disk virtual yang esensial untuk lingkungan enterprise.
- **AutomatedLab:** Menyederhanakan deployment lab otomatis dengan utilitas untuk penamaan, manajemen variabel remote, dan konfigurasi adaptor jaringan tanpa pengawasan.
- **VpnClient:** Memudahkan penyusunan dan pemicu koneksi VPN berdasarkan aplikasi, DNS, dan jaringan tepercaya, memberikan fleksibilitas tinggi dalam manajemen konektivitas.

Dengan pemahaman mendalam mengenai setiap fungsi tersebut, maka dapat mengembangkan skrip automasi yang kompleks dan handal sesuai dengan kebutuhan infrastruktur atau lab

#

### Di bawah contoh memaparkan tiga topik mendalam yang mencakup:

1. **Parameter Lanjutan** – bagaimana penggunaan parameter tambahan, parameter set, dan opsi tersembunyi pada fungsi-fungsi PowerShell yang kompleks.
2. **Studi Kasus Integrasi antara Modul** – contoh nyata integrasi beberapa modul (seperti AutomatedLab, Storage, VPN, dan PSFramework) untuk mencapai automasi lingkungan lab yang koheren.
3. **Pengembangan Custom Operators di Pester** – cara menambahkan operator pengecekan khusus untuk menyesuaikan asersi dalam framework testing Pester.

---

## 1. Parameter Lanjutan dalam Fungsi PowerShell

Banyak fungsi PowerShell—terutama yang berasal dari modul-modul lanjutan—mendukung parameter lanjutan yang memungkinkan konfigurasi yang lebih detail. Berikut beberapa pendekatan dan contoh:

### A. **Parameter Set dan Opsi Terspesifikasi**

Beberapa fungsi memiliki parameter set yang berbeda untuk mengakomodasi berbagai skenario. Misalnya, fungsi `Add-VpnConnection` mungkin mendukung parameter untuk menetapkan metode autentikasi atau tunnel type. Anda bisa melihat daftar parameter lengkap dengan:

```powershell
Get-Help Add-VpnConnection -Full
```

**Contoh Parameter Lanjutan:**

- **Parameter Binding:**  
  Fitur seperti `ValueFromPipeline` dan `ValueFromPipelineByPropertyName` memungkinkan fungsi menerima input secara otomatis dari pipeline. Misalnya, sebuah fungsi yang mengelola storage mungkin menerima objek disk dari `Get-PhysicalDisk` secara otomatis:

  ```powershell
  function Add-CustomStorageConfig {
      [CmdletBinding()]
      param (
          [Parameter(Mandatory, ValueFromPipeline)]
          [Microsoft.Management.Infrastructure.CimInstance]$DiskInfo,

          [Parameter(Mandatory)]
          [string]$PoolName
      )
      process {
          # Contoh: menambahkan disk ke Storage Pool dengan pengecekan ukurannya
          if ($DiskInfo.Size -gt 500GB) {
              "Menambahkan disk $($DiskInfo.DeviceId) ke Storage Pool $PoolName"
          } else {
              Write-Warning "Disk $($DiskInfo.DeviceId) tidak memenuhi syarat ukuran minimum."
          }
      }
  }
  ```

- **Parameter Validasi:**  
  Penggunaan atribut seperti `[ValidateSet()]`, `[ValidateRange()]`, dan `[ValidateScript()]` meningkatkan keandalan fungsi. Contohnya, pada fungsi VPN Anda dapat membatasi tipe tunnel:

  ```powershell
  function Add-VpnConnection {
      [CmdletBinding()]
      param (
          [Parameter(Mandatory)]
          [string]$Name,

          [Parameter(Mandatory)]
          [string]$ServerAddress,

          [Parameter(Mandatory)]
          [ValidateSet("PPTP", "L2TP", "IKEv2")]
          [string]$TunnelType,

          [Parameter(Mandatory)]
          [ValidateSet("PAP", "CHAP", "EAP")]
          [string]$AuthenticationMethod
      )
      process {
          "Membuat VPN dengan nama: $Name, Server: $ServerAddress, Tunnel: $TunnelType, Auth: $AuthenticationMethod"
          # Lakukan logika pembuatan VPN di sini
      }
  }
  ```

Pada contoh di atas, parameter `TunnelType` dan `AuthenticationMethod` hanya akan menerima nilai yang sudah didefinisikan, sehingga meminimalkan kesalahan input.

### B. **Parameter untuk Logging dan Debugging**

Beberapa fungsi, terutama yang berkaitan dengan PSFramework, memiliki parameter untuk mengatur logging detail atau debug level. Misalnya:

```powershell
Add-PSFLoggingProviderRunspace -RunspaceId $Runspace.Id -Provider "FileLogger" -LogFilePath "C:\Logs\Runspace_$($Runspace.Id).log" -Verbose:$true
```

Dengan parameter `-Verbose:$true` (atau opsi logging lain), Anda bisa mendapatkan output yang lebih detail untuk troubleshooting.

---

## 2. Studi Kasus Integrasi antara Modul

Mari kita lihat sebuah studi kasus di mana berbagai modul diintegrasikan ke dalam satu skrip automasi untuk membangun lingkungan lab yang lengkap.

### **Skenario: Automasi Lab Infrastruktur Terintegrasi**

**Tujuan:**

- Mengkonfigurasi mesin virtual dan storage untuk lab menggunakan modul AutomatedLab.
- Menyiapkan koneksi VPN untuk akses remote yang aman menggunakan modul VpnClient.
- Menerapkan monitoring spesifik pada runspace dengan PSFramework.
- Memastikan pengaturan storage dan masking set di sisi SAN dengan modul Storage.

**Langkah-Langkah dan Implementasi:**

1. **Pengaturan Lab Virtual dan Storage:**  
   Gunakan fungsi dari `AutomatedLab.Common` dan modul Storage. Misalnya, menambahkan mesin virtual, menginkrement nama server, dan memasukkan disk ke storage pool.

   ```powershell
   # Menambahkan mesin virtual dan mengatur variabel lab
   $vmName = Add-StringIncrement -InputString "Server01"
   Add-LabMachineDefinition -Name $vmName -Memory 4096 -Roles "DomainController"

   # Mengonfigurasi storage dengan menambahkan access path dan disk
   Add-PartitionAccessPath -DiskNumber 1 -PartitionNumber 2 -AccessPath "D:\Data"
   Add-PhysicalDisk -StoragePoolFriendlyName "Pool1" -PhysicalDisks (Get-PhysicalDisk -CanPool $true)
   Add-VirtualDiskToMaskingSet -MaskingSetId "MS001" -VirtualDiskName "VDisk01"
   ```

2. **Konfigurasi VPN untuk Akses Remote:**  
   Membangun koneksi VPN dengan parameter lanjutan serta menambahkan pemicu agar VPN aktif berdasarkan aplikasi, DNS, atau jaringan tepercaya.

   ```powershell
   Add-VpnConnection -Name "LabVPN" -ServerAddress "vpn.lab.example.com" -TunnelType "IKEv2" -AuthenticationMethod "EAP"
   Add-VpnConnectionRoute -ConnectionName "LabVPN" -DestinationPrefix "10.0.0.0/24" -RouteMetric 1
   Add-VpnConnectionTriggerApplication -ConnectionName "LabVPN" -Application "powershell.exe"
   Add-VpnConnectionTriggerTrustedNetwork -ConnectionName "LabVPN" -TrustedNetwork "LabWiFi"
   ```

3. **Logging dan Monitoring Runspace dengan PSFramework:**  
   Untuk lingkungan multiprocess, setiap runspace ditetapkan logging terpisah agar memudahkan audit dan troubleshooting.

   ```powershell
   $runspace = [runspacefactory]::CreateRunspace()
   $runspace.Open()
   Add-PSFLoggingProviderRunspace -RunspaceId $runspace.InstanceId -Provider "FileLogger" -LogFilePath "C:\Logs\Runspace_$($runspace.InstanceId).log"
   ```

4. **Integrasi dengan Pengujian Otomatis Menggunakan Pester:**  
   Setelah konfigurasi diterapkan, buat test suite dengan Pester untuk memastikan setiap bagian berfungsi seperti yang diharapkan.

   ```powershell
   Describe "Environment Lab Configuration" {
       Context "VPN Connection" {
           It "should create a VPN connection named LabVPN" {
               # Pengecekan dengan cara custom atau menggunakan cmdlet get jika tersedia
               $vpn = Get-VpnConnection -Name "LabVPN"
               $vpn | Should -Not -BeNullOrEmpty
           }
       }
       Context "Storage Configuration" {
           It "should assign the partition access path correctly" {
               $partition = Get-Partition -DiskNumber 1 -PartitionNumber 2
               $partition.AccessPaths | Should -Contain "D:\Data"
           }
       }
   }
   Invoke-Pester -Script .\LabTests.Tests.ps1
   ```

Pada contoh di atas, integrasi antar modul memungkinkan alur kerja yang mulus, mulai dari penyediaan VM, pengaturan storage, konfigurasi VPN, hingga verifikasi konfigurasi melalui test otomatis.

---

## 3. Pengembangan Custom Operators di Pester

Pester memungkinkan pengembangan operator kustom untuk memperluas cara asersi dilakukan. Operator “Should” default mungkin tidak mencakup beberapa kondisi spesifik yang Anda butuhkan. Berikut adalah cara mengembangkan custom operator menggunakan `Add-ShouldOperator`.

### A. **Membuat Operator Custom (Contoh: ShouldBePalindrome)**

**Tujuan:**  
Membuat operator asersi yang memverifikasi apakah sebuah string adalah palindrome (sama jika dibaca maju dan mundur).

**Implementasi:**

1. **Definisikan Operator:**

   ```powershell
   Add-ShouldOperator -OperatorName "ShouldBePalindrome" -ScriptBlock {
       param(
           $Actual,
           $Expected  # Parameter Expected di sini opsional, misal untuk pesan custom.
       )
       # Hilangkan spasi dan ubah ke huruf kecil untuk perbandingan
       $normalized = ($Actual -replace '\s','').ToLower()
       $reversed = -join ($normalized.ToCharArray() | Reverse)
       return $normalized -eq $reversed
   }
   ```

2. **Menggunakan Operator Custom dalam Test Pester:**

   ```powershell
   Describe "Palindrome Test" {
       It "should identify a palindrome" {
           "Madam In Eden Im Adam" | ShouldBePalindrome
       }
       It "should fail for non-palindrome" {
           { "Hello World" | ShouldBePalindrome } | Should -Throw
       }
   }
   Invoke-Pester
   ```

Pada contoh di atas, operator `ShouldBePalindrome` digunakan untuk memastikan bahwa kondisi palindrome terpenuhi. Anda juga bisa memodifikasi skrip untuk menerima opsi tambahan seperti pesan error khusus jika kondisi tidak terpenuhi.

### B. **Custom Operator Lain (Misalnya: ShouldMatchRegex dengan Kondisi Tambahan)**

Jika Anda ingin mengadaptasi operator default `Should -Match` dengan fitur tambahan, Anda dapat menulis operator seperti:

```powershell
Add-ShouldOperator -OperatorName "ShouldMatchRegex" -ScriptBlock {
    param(
        $Actual,
        $Pattern
    )
    if ($Actual -match $Pattern) {
        return $true
    }
    else {
        Throw "String '$Actual' tidak cocok dengan pola regex '$Pattern'."
    }
}
```

Penggunaan dalam test:

```powershell
Describe "Regex Custom Operator Test" {
    It "should match the specified regex pattern" {
        "PowerShell2023" | ShouldMatchRegex "\w+\d+"
    }
}
Invoke-Pester
```

---

## Kesimpulan dan Langkah Selanjutnya

**Parameter Lanjutan:**  
Memahami dan menggunakan parameter lanjutan pada fungsi PowerShell dapat meningkatkan fleksibilitas serta mencegah terjadinya error selama eksekusi script. Pastikan memanfaatkan atribut seperti `ValidateSet` dan `ValueFromPipeline` untuk menciptakan fungsi yang robust.

**Integrasi Modul:**  
Studi kasus di atas menunjukkan bagaimana modul-modul berbeda—mulai dari AutomatedLab, VPN, Storage, hingga PSFramework—dapat terintegrasi dalam satu skrip automasi yang menyeluruh. Pendekatan modul ekspresif ini memungkinkan pengelolaan seluruh infrastruktur dengan cara yang lebih terstruktur dan otomatis.

**Pengembangan Custom Operators di Pester:**  
Dengan menambahkan custom operator, Anda tak hanya memperluas kemampuan asersi default, namun juga menyesuaikan framework testing dengan kebutuhan spesifik proyek Anda. Ini sangat berguna untuk pengujian kondisi-kondisi unik yang tidak tertangani oleh operator standar.

Jika Anda ingin mengeksplorasi lebih jauh, beberapa arah pengembangan bisa mencakup:

- **Pengembangan modul PowerShell kustom** dengan dokumentasi parameter lanjutan dan integrasi tinggi.
- **Menerapkan logging praktis** dengan PSFramework dalam skenario produksi yang kompleks.
- **Membangun suite test otomatis** untuk validasi end-to-end lingkungan lab yang di-deploy secara otomatis.

#

Berikut adalah contoh kasus lain yang melibatkan beberapa aspek lanjutan—mulai dari deployment, konfigurasi jaringan dan storage, hingga monitoring dan validasi melalui testing otomatis dengan Pester. Kasus ini menggambarkan bagaimana Anda dapat mengotomatiskan deployment klaster web server dengan failover, akses VPN untuk manajemen jarak jauh, logging terintegrasi, serta pengujian kondisi sehat infrastruktur. Saya akan membaginya ke dalam beberapa langkah berikut:

---

## **Contoh Kasus: Otomatisasi Deployment Klaster Web Server dengan Monitoring Terintegrasi**

### **Tujuan Proyek**

- **Deployment dan Konfigurasi Virtual Machines (VM):**  
  Menggunakan modul AutomatedLab untuk membuat VM web server dengan konfigurasi yang konsisten—misalnya, penamaan otomatis menggunakan utilitas seperti `Add-StringIncrement` untuk nama server.

- **Konfigurasi Jaringan dan Storage:**  
  Membuat NIC teaming (load balancing/failover) melalui fungsi dari modul NetLbfo, menetapkan jalur akses pada partisi storage dengan `Add-PartitionAccessPath` serta menambahkan disk ke dalam storage pool. Ini memastikan high availability untuk data dan aplikasi web.

- **Penyusunan Koneksi VPN untuk Manajemen Remote:**  
  Menggunakan modul VpnClient untuk membangun koneksi VPN yang memungkinkan administrator mengakses infrastruktur dari lokasi manapun.

- **Logging dan Monitoring Runspace:**  
  Mengintegrasikan logging untuk setiap runspace (misalnya, memakai `Add-PSFLoggingProviderRunspace`) sehingga setiap aktivitas dan error terekam secara terpisah guna memudahkan troubleshooting.

- **Pengujian Otomatis dengan Pester:**  
  Membuat suite test otomatis—menggabungkan custom operator (misalnya, operator untuk mengecek “kesehatan” server) dan verifikasi konfigurasi—agar setiap deployment tervalidasi.

---

### **Langkah-Langkah Implementasi**

#### **1. Deployment VM Web Server dan Penamaan Otomatis**

Pertama, kita buat VM berdasarkan template lab dengan AutomatedLab. Fungsi `Add-StringIncrement` membantu dalam penamaan berurutan.

```powershell
# Contoh: Membuat VM web server dengan nama otomatis
$baseName = "WebServer01"
$vmName = Add-StringIncrement -InputString $baseName  # menghasilkan misalnya: "WebServer02"

Add-LabMachineDefinition -Name $vmName -Memory 4096 -Roles "WebServer", "ApplicationServer"
```

#### **2. Konfigurasi NIC Teaming dan Storage**

Konfigurasi NIC teaming untuk high availability dan load balancing:

```powershell
# Menambahkan NIC ke dalam tim jaringan untuk failover
Add-NetLbfoTeamMember -Team "WebTeam" -InterfaceAlias "Ethernet 2"
Add-NetLbfoTeamMember -Team "WebTeam" -InterfaceAlias "Ethernet 3"
```

Kemudian, atur akses storage:

```powershell
# Menetapkan access path ke partisi tertentu; memastikan data log dan aplikasi tertata rapi
Add-PartitionAccessPath -DiskNumber 1 -PartitionNumber 2 -AccessPath "D:\WebData"
# Menggabungkan disk ke sebuah storage pool (misalnya, untuk virtual disk atau LUN)
Add-PhysicalDisk -StoragePoolFriendlyName "WebPool" -PhysicalDisks (Get-PhysicalDisk -CanPool $true)
```

Jika diperlukan, tambahkan virtual disk ke masking set agar disk hanya dapat diakses oleh VM yang berwenang:

```powershell
Add-VirtualDiskToMaskingSet -MaskingSetId "MS_Web" -VirtualDiskName "VD_WebLogs"
```

#### **3. Konfigurasi Koneksi VPN untuk Remote Management**

Membuat koneksi VPN dengan parameter lanjutan, misalnya tipe tunnel IKEv2 dan autentikasi EAP:

```powershell
Add-VpnConnection -Name "WebServerVPN" -ServerAddress "vpn.corp.example.com" `
                  -TunnelType "IKEv2" -AuthenticationMethod "EAP"

# Menambahkan rute agar hanya trafik ke jaringan internal yang masuk melalui VPN
Add-VpnConnectionRoute -ConnectionName "WebServerVPN" -DestinationPrefix "10.20.0.0/16" -RouteMetric 1

# Menambahkan trigger agar VPN aktif saat menjalankan aplikasi manajemen tertentu
Add-VpnConnectionTriggerApplication -ConnectionName "WebServerVPN" -Application "mmc.exe"
```

#### **4. Menyusun Logging untuk Runspace dan Monitoring**

Setiap runspace yang menjalankan deployment atau konfigurasi dapat diarahkan ke file log terpisah. Misalnya, buat runspace baru dan tetapkan log-nya:

```powershell
$runspace = [runspacefactory]::CreateRunspace()
$runspace.Open()
Add-PSFLoggingProviderRunspace -RunspaceId $runspace.InstanceId -Provider "FileLogger" `
                                -LogFilePath "C:\Logs\Runspace_$($runspace.InstanceId).log"
```

Ini membantu Anda mendapatkan rincian apabila terjadi error atau penurunan performa saat operasi paralel.

#### **5. Pengujian Otomatis dengan Pester dan Custom Asersi**

Setelah deployment, buat suite test menggunakan Pester untuk memverifikasi bahwa setiap bagian sistem berfungsi dengan baik. Berikut contoh penggunaan custom operator untuk mengecek "kesehatan" web server:

**Membuat Custom Operator:**

```powershell
Add-ShouldOperator -OperatorName "ShouldBeHealthy" -ScriptBlock {
    param(
        $Actual
    )
    # Misalnya, cek jika status respons HTTP dari server adalah 200
    if ($Actual -eq 200) { return $true }
    else { Throw "Respons server tidak sehat: $Actual" }
}
```

**Mengintegrasikan Test Pester:**

Buat file test (misalnya `WebCluster.Tests.ps1`):

```powershell
Describe "Deployment Web Server Cluster" {
    Context "VPN Connection" {
        It "should create a VPN connection named WebServerVPN" {
            $vpn = Get-VpnConnection -Name "WebServerVPN"
            $vpn | Should -Not -BeNullOrEmpty
        }
    }
    Context "Storage Configurations" {
        It "should assign partition access path D:\WebData" {
            $partition = Get-Partition -DiskNumber 1 -PartitionNumber 2
            $partition.AccessPaths | Should -Contain "D:\WebData"
        }
    }
    Context "Web Server Health Check" {
        It "should return HTTP 200 OK" {
            # Contoh: Mengecek status respons dari alamat IP VM web server
            $responseCode = (Invoke-WebRequest -Uri "http://$vmName" -UseBasicParsing).StatusCode
            $responseCode | ShouldBeHealthy
        }
    }
}

Invoke-Pester -Script .\WebCluster.Tests.ps1
```

Di sini, operator `ShouldBeHealthy` memvalidasi bahwa web server merespons dengan kode HTTP 200, menandakan bahwa server dalam keadaan sehat.

---

## **Kesimpulan & Manfaat Kasus Ini**

Dengan mengintegrasikan berbagai modul dan fungsi—mulai dari AutomatedLab untuk penyediaan VM, modul jaringan dan storage untuk konfigurasi infrastruktur, VPN untuk remote management, serta PSFramework dan Pester untuk logging dan pengujian—Anda menciptakan solusi automasi yang lengkap dan terintegrasi. Hal ini memungkinkan:

- **Deployment yang konsisten dan reproducible:** Mengurangi human error dan meningkatkan kecepatan konfigurasi.
- **Monitoring dan troubleshooting yang efisien:** Log terpisah per runspace dan pengujian otomatis membantu mengidentifikasi masalah dengan cepat.
- **Validasi sistem end-to-end:** Pester dan custom operator memastikan integritas dan kesehatan infrastruktur sebelum masuk ke lingkungan produksi.

Kasus seperti ini tidak hanya meningkatkan efisiensi operasional tetapi juga menyediakan dasar untuk skalabilitas dan pengelolaan lingkungan secara otomatis.
