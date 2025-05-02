Di bagian ini kita akan melihat deretan fungsi yang digunakan untuk **menonaktifkan** (disable) berbagai fitur, layanan, dan konfigurasi pada lingkungan lab, jaringan, penyimpanan, serta sistem operasi secara umum. Fungsi-fungsi ini berguna untuk pengujian, troubleshooting, atau saat kamu ingin memastikan bahwa fitur tertentu tidak mengganggu operasi lain—misalnya agar VM lab tidak terblokir oleh firewall atau agar fitur tertentu pada adapter jaringan dimatikan untuk membantu analisis performa. Di bawah ini, kita ulas secara mendalam tiap kelompok fungsi berikut, lengkap dengan deskripsi, contoh implementasi, dan cara mengintegrasikannya dalam skenario otomatisasi.

---

## Ringkasan Fungsi dalam Bentuk Tabel

| **Nama Fungsi**                                 | **Modul/Konteks**    | **Versi** | **Deskripsi Singkat**                                                                                                       |
| ----------------------------------------------- | -------------------- | --------- | --------------------------------------------------------------------------------------------------------------------------- |
| **Disable pada lingkungan Lab & VM**            |                      |           |                                                                                                                             |
| Disable-LabVMFirewallGroup                      | AutomatedLabCore     | 5.50.0    | Menonaktifkan _firewall group_ pada VM lab agar lalu lintas uji tidak terhalang.                                            |
| Disable-LWAzureAutoShutdown                     | AutomatedLabWorker   | 5.50.0    | Menonaktifkan fitur auto shutdown pada worker VM di Azure.                                                                  |
| Disable-MMAgent                                 | MMAgent              | 1.0       | Menonaktifkan agen modern management (MMAgent), berguna untuk troubleshooting.                                              |
| **Disable untuk Adapter & Jaringan**            |                      |           |                                                                                                                             |
| Disable-NetAdapter                              | NetAdapter           | 2.0.0.0   | Menonaktifkan network adapter tertentu, yang dapat membantu pengujian isolasi.                                              |
| Disable-NetAdapterBinding                       | NetAdapter           | 2.0.0.0   | Mematikan binding (hubungan) pada adapter, mengontrol protokol atau driver yang aktif.                                      |
| Disable-NetAdapterChecksumOffload               | NetAdapter           | 2.0.0.0   | Menonaktifkan fitur checksum offload, berguna saat troubleshooting paket jaringan.                                          |
| Disable-NetAdapterEncapsulatedPacketTaskOffload | NetAdapter           | 2.0.0.0   | Menonaktifkan offload tugas pemrosesan paket terpadu pada adapter.                                                          |
| Disable-NetAdapterIPsecOffload                  | NetAdapter           | 2.0.0.0   | Menonaktifkan kemampuan offload untuk IPsec, agar enkripsi/dekripsi dijalankan software.                                    |
| Disable-NetAdapterLso                           | NetAdapter           | 2.0.0.0   | Mematikan fitur Large Send Offload (LSO) yang menggabungkan paket untuk efisiensi.                                          |
| Disable-NetAdapterPacketDirect                  | NetAdapter           | 2.0.0.0   | Menonaktifkan fitur Packet Direct untuk bypass stack TCP/IP.                                                                |
| Disable-NetAdapterPowerManagement               | NetAdapter           | 2.0.0.0   | Menonaktifkan pengaturan power management pada adapter agar tidak terjadi penurunan performa karena mode hemat energi.      |
| Disable-NetAdapterQos                           | NetAdapter           | 2.0.0.0   | Mematikan Quality of Service (QoS) yang diatur pada adapter.                                                                |
| Disable-NetAdapterRdma                          | NetAdapter           | 2.0.0.0   | Menonaktifkan fitur Remote Direct Memory Access (RDMA) pada adapter.                                                        |
| Disable-NetAdapterRsc                           | NetAdapter           | 2.0.0.0   | Menonaktifkan Receive Segment Coalescing (RSC), penting untuk kinerja penerimaan data.                                      |
| Disable-NetAdapterRss                           | NetAdapter           | 2.0.0.0   | Mematikan Receive Side Scaling (RSS) untuk mengatur alokasi beban pada CPU.                                                 |
| Disable-NetAdapterSriov                         | NetAdapter           | 2.0.0.0   | Menonaktifkan Single Root I/O Virtualization (SR-IOV) pada adapter.                                                         |
| Disable-NetAdapterUro                           | NetAdapter           | 2.0.0.0   | Nonaktifkan fitur URO (Unspecified Receive Offload) jika didukung kartu jaringan.                                           |
| Disable-NetAdapterUso                           | NetAdapter           | 2.0.0.0   | Menonaktifkan Unicast Switch Offload (USO) pada adapter.                                                                    |
| Disable-NetAdapterVmq                           | NetAdapter           | 2.0.0.0   | Menonaktifkan Virtual Machine Queue (VMQ) pada adapter, berguna untuk debugging virtualisasi jaringan.                      |
| Disable-NetDnsTransitionConfiguration           | NetworkTransition    | 1.0.0.0   | Menonaktifkan konfigurasi transisi DNS saat migrasi atau troubleshooting.                                                   |
| Disable-NetFirewallHyperVRule                   | NetSecurity          | 2.0.0.0   | Mematikan aturan firewall Hyper-V khusus pada host.                                                                         |
| Disable-NetFirewallRule                         | NetSecurity          | 2.0.0.0   | Menghentikan aturan firewall umum, baik untuk troubleshooting atau pengaturan baru.                                         |
| Disable-NetIPHttpsProfile                       | NetworkTransition    | 1.0.0.0   | Menonaktifkan profil IP Https untuk tujuan transisi kebijakan jaringan.                                                     |
| Disable-NetIPsecMainModeRule                    | NetSecurity          | 2.0.0.0   | Menonaktifkan aturan IPsec untuk mode utama dalam komunikasi terenkripsi.                                                   |
| Disable-NetIPsecRule                            | NetSecurity          | 2.0.0.0   | Menonaktifkan aturan IPsec (baik mode utama maupun quick mode), guna menguji konektivitas.                                  |
| Disable-NetNatTransitionConfiguration           | NetworkTransition    | 1.0.0.0   | Menghentikan konfigurasi transisi NAT untuk migrasi atau kebijakan khusus.                                                  |
| Disable-NetworkSwitchEthernetPort               | NetworkSwitchManager | 1.0.0.0   | Menonaktifkan port Ethernet pada switch jaringan, berguna pada skenario pengelolaan fisik dan virtual switch.               |
| Disable-NetworkSwitchFeature                    | NetworkSwitchManager | 1.0.0.0   | Menonaktifkan fitur spesifik pada switch yang tidak diperlukan atau mengganggu.                                             |
| Disable-NetworkSwitchVlan                       | NetworkSwitchManager | 1.0.0.0   | Menonaktifkan implementasi VLAN tertentu pada switch.                                                                       |
| **Disable Fungsi Lainnya**                      |                      |           |                                                                                                                             |
| Disable-OdbcPerfCounter                         | Wdac                 | 1.0.0.0   | Menonaktifkan counter performa ODBC, membantu mengurangi overhead di query performance.                                     |
| Disable-PhysicalDiskIdentification              | Storage              | 2.0.0.0   | Menonaktifkan identifikasi fisik disk, misalnya saat LED identifikasi tidak diinginkan.                                     |
| Disable-PnpDevice                               | PnpDevice            | 1.0.0.0   | Menonaktifkan perangkat Plug and Play (Pnp) yang dipilih, membantu isolasi atau debugging hardware.                         |
| Disable-PSFConsoleInterrupt                     | PSFramework          | 1.9.310   | Menonaktifkan intercept pada konsol (misalnya penanganan Ctrl+C) dalam PSFramework.                                         |
| Disable-PSFLoggingProvider                      | PSFramework          | 1.9.310   | Menonaktifkan provider logging tertentu dalam PSFramework untuk mengurangi detail log.                                      |
| Disable-PSFTaskEngineTask                       | PSFramework          | 1.9.310   | Mematikan task engine tertentu di PSFramework, guna menghentikan atau mem-pause tugas background.                           |
| Disable-PSTrace                                 | PSDiagnostics        | 1.0.0.0   | Menonaktifkan pelacakan (trace) di modul PSDiagnostics, mengurangi overhead logging.                                        |
| Disable-PSWSManCombinedTrace                    | PSDiagnostics        | 1.0.0.0   | Menonaktifkan trace gabungan pada WSMan untuk debugging layanan remote.                                                     |
| Disable-ScheduledTask                           | ScheduledTasks       | 1.0.0.0   | Menonaktifkan tugas terjadwal, berguna saat melakukan maintenance atau menghindari tindakan otomatis yang tidak diinginkan. |
| Disable-SmbDelegation                           | SmbShare             | 2.0.0.0   | Menonaktifkan delegasi SMB untuk alasan keamanan atau troubleshooting.                                                      |
| Disable-StorageBusCache                         | StorageBusCache      | 1.0.0.0   | Menonaktifkan caching pada Storage Bus, berguna untuk troubleshooting perangkat penyimpanan.                                |
| Disable-StorageBusDisk                          | StorageBusCache      | 1.0.0.0   | Mematikan cache disk pada Storage Bus, memastikan operasi I/O langsung.                                                     |
| Disable-StorageDataCollection                   | Storage              | 2.0.0.0   | Menonaktifkan pengumpulan data penyimpanan, untuk mengurangi overhead monitoring.                                           |
| Disable-StorageEnclosureIdentification          | Storage              | 2.0.0.0   | Mematikan fitur identifikasi enclosure storage, seperti LED atau sensor internal.                                           |
| Disable-StorageEnclosurePower                   | Storage              | 2.0.0.0   | Menonaktifkan manajemen power pada enclosure storage, ideal saat maintenance.                                               |
| Disable-StorageHighAvailability                 | Storage              | 2.0.0.0   | Menonaktifkan fitur high availability pada storage yang tidak diperlukan untuk pengujian.                                   |
| Disable-StorageMaintenanceMode                  | Storage              | 2.0.0.0   | Menghentikan mode maintenance pada storage, memastikan operasi berjalan normal.                                             |
| Disable-WdacBidTrace                            | Wdac                 | 1.0.0.0   | Menonaktifkan trace bid pada modul Wdac untuk mengurangi detail log diagnostik.                                             |
| Disable-WSManTrace                              | PSDiagnostics        | 1.0.0.0   | Menonaktifkan pelacakan WSMan, berguna setelah proses troubleshooting selesai.                                              |
| **Fungsi Disconnect dan Dismount**              |                      |           |                                                                                                                             |
| Disconnect-IscsiTarget                          | iSCSI                | 1.0.0.0   | Memutus koneksi ke target iSCSI, membantu melepaskan resource penyimpanan jaringan.                                         |
| Disconnect-Lab                                  | AutomatedLabCore     | 5.50.0    | Memutus koneksi dari sesi lab, memastikan cleanup koneksi lab berjalan sempurna.                                            |
| Disconnect-VirtualDisk                          | Storage              | 2.0.0.0   | Memutus mounting virtual disk sehingga disk image tidak lagi tersedia untuk sistem operasi.                                 |
| Dismount-DiskImage                              | Storage              | 2.0.0.0   | Melepas image disk yang sudah dimount, memastikan file image tidak terkunci.                                                |
| Dismount-LabIsoImage                            | AutomatedLabCore     | 5.50.0    | Melepas ISO image yang digunakan dalam sesi lab—misalnya setelah instalasi selesai.                                         |
| Dismount-LWAzureIsoImage                        | AutomatedLabWorker   | 5.50.0    | Melepas ISO image di lingkungan lab Azure, agar resource dilepaskan.                                                        |
| Dismount-LWIsoImage                             | AutomatedLabWorker   | 5.50.0    | Versi lain untuk melepas ISO image pada worker lab (non-Azure), membantu memulihkan state.                                  |

---

## Pembahasan Per Fungsi dan Skenario Implementasi

### A. **Fungsi Disable di Lingkungan Lab & VM**

1. **Disable-LabVMFirewallGroup**

   - **Tujuan:** Mematikan firewall group pada VM di lingkungan lab.
   - **Contoh Penggunaan:**
     ```powershell
     Disable-LabVMFirewallGroup -VMName "TestVM" -Group "InBoundRules"
     ```
     Dengan mematikan firewall group ini, kamu memberi keleluasaan untuk menguji aplikasi tanpa gangguan aturan firewall—namun pastikan digunakan  
     hanya di lingkungan uji.

2. **Disable-LWAzureAutoShutdown**

   - **Tujuan:** Menghentikan mekanisme auto shutdown di worker VM Azure agar sistem tetap aktif selama proses debugging atau pengujian lama.
   - **Contoh Penggunaan:**
     ```powershell
     Disable-LWAzureAutoShutdown -VMName "AzureWorker01"
     ```

3. **Disable-MMAgent**
   - **Tujuan:** Menonaktifkan agen modern management yang mungkin mengganggu skenario troubleshooting aplikasi modern.
   - **Contoh Penggunaan:**
     ```powershell
     Disable-MMAgent -Verbose
     ```

### B. **Fungsi Disable untuk Adapter & Jaringan**

Fungsi-fungsi dari `Disable-NetAdapter*` memungkinkan kamu mengontrol berbagai fitur pada adapter jaringan. Misalnya:

- **Disable-NetAdapterBinding**

  - **Tujuan:** Mengurangi binding protokol atau driver tertentu, misalnya saat kamu ingin mengisolasi masalah driver.
  - **Contoh:**
    ```powershell
    Disable-NetAdapterBinding -Name "Ethernet0" -ComponentID "ms_tcpip6"
    ```

- **Disable-NetAdapterChecksumOffload, Disable-NetAdapterLso, dsb.**
  - **Tujuan:** Mematikan fitur-fitur offload untuk mendiagnosa isu jaringan atau mengoptimalkan performa di lingkungan uji.
  - **Contoh:**
    ```powershell
    Disable-NetAdapterChecksumOffload -Name "Ethernet0"
    ```

Serangkaian fungsi seperti **Disable-NetAdapterRss**, **Disable-NetAdapterSriov**, dan lainnya biasa digunakan untuk mengubah setting hardware melalui skrip otomatisasi, misalnya dalam proses benchmarking atau migrasi driver.

Selain itu, fungsi dari modul _NetSecurity_ (seperti **Disable-NetFirewallRule**, **Disable-NetIPsecRule**) digunakan untuk mematikan aturan firewall dan IPsec—sering kali dilakukan sebelum instalasi aplikasi tertentu atau saat menyiapkan lingkungan uji jaringan yang lebih "terbuka."

### C. **Fungsi Disable di Level Sistem, Penyimpanan, dan Lainnya**

Fungsi-fungsi seperti **Disable-PnpDevice**, **Disable-PSFConsoleInterrupt**, hingga **Disable-ScheduledTask** membantu kamu:

- Menghentikan layanan atau tugas terjadwal yang mengganggu,
- Mengontrol logging serta task engine dalam PSFramework, atau
- Mematikan fitur-fitur _tracing_ pada sistem agar mengurangi beban dan mempermudah troubleshooting.

Contoh penggunaan **Disable-ScheduledTask**:

```powershell
Disable-ScheduledTask -TaskName "DailyBackup"
```

Ini memastikan bahwa tugas backup otomatis tidak berjalan saat kamu sedang melakukan maintenance pada sistem.

### D. **Fungsi Disconnect dan Dismount**

Fungsi-fungsi di bagian ini memfasilitasi proses **pembebasan resource**:

- **Disconnect-IscsiTarget** memutuskan koneksi ke storage berbasis iSCSI sesudah penggunaan.
- **Disconnect-Lab** menghentikan sesi koneksi lab sehingga resource bisa dikembalikan dan koneksi tidak terbuka terus.
- **Dismount-DiskImage** serta fungsi Dismount-Lab\* berfungsi untuk melepas mount dari ISO image atau disk image, menjamin bahwa file gambar tidak terkunci dan bisa digunakan kembali atau dihapus.

_Contoh Dismount:_

```powershell
Dismount-DiskImage -ImagePath "C:\Images\setup.iso"
```

---

## Alur Kerja Skenario Otomatisasi

Bayangkan kamu sedang menyiapkan sebuah pipeline pengujian di mana kamu perlu:

1. **Mengonfigurasi jaringan VM** dengan mematikan firewall dan fitur adapter tertentu agar aplikasi dapat diuji dalam lingkungan "terbuka".
2. **Melakukan maintenance**—misalnya, menonaktifkan auto shutdown pada worker VM Azure serta mematikan tugas-tugas tertentu yang bisa mengganggu operasi uji.
3. **Menyelesaikan pengujian** dengan melepaskan semua resource, seperti memutus koneksi iSCSI atau melepas disk image.

Alur kerja tersebut bisa divisualisasikan secara sederhana sebagai berikut:

```
 ┌─────────────────────────────────────┐
 │ 1. Nonaktifkan Firewall & AutoShutdown  │
 │    (Disable-LabVMFirewallGroup,           │
 │     Disable-LWAzureAutoShutdown)          │
 └─────────────────────────────────────┘
                │
                ▼
 ┌─────────────────────────────────────┐
 │ 2. Atur Pengaturan Adapter & Jaringan    │
 │    (Disable-NetAdapter*, Disable-NetFirewallRule, │
 │     Disable-NetIPsecRule)               │
 └─────────────────────────────────────┘
                │
                ▼
 ┌─────────────────────────────────────┐
 │ 3. Nonaktifkan Layanan & Debugging Sistem │
 │    (Disable-PnpDevice, Disable-PSFConsoleInterrupt,    │
 │     Disable-ScheduledTask, dsb.)         │
 └─────────────────────────────────────┘
                │
                ▼
 ┌─────────────────────────────────────┐
 │ 4. Lepas Koneksi dan Mount            │
 │    (Disconnect-IscsiTarget, Disconnect-Lab,          │
 │     Dismount-DiskImage, Dismount-LabIsoImage)         │
 └─────────────────────────────────────┘
```

Pipeline tersebut memastikan bahwa sistem tetap stabil selama fase pengujian, dan semua perubahan konfigurasi yang dimatikan bisa diaktivasi kembali bila dibutuhkan melalui fungsi _Enable_ yang biasanya tersedia di masing-masing modul.

---

## Kesimpulan dan Tips Lanjutan

1. **Penggunaan Terintegrasi:**  
   Kombinasikan fungsi-fungsi disable ini dalam skrip yang modular. Misalnya, sebelum memulai pengujian aplikasi, pastikan kamu menonaktifkan firewall internal VM dan fitur adapter yang dapat mengganggu konektivitas. Setelah pengujian selesai, lakukan pembersihan dengan fungsi disconnect dan dismount.

2. **Eksperimen & Troubleshooting:**  
   Setiap fungsi disable sebaiknya diuji di lingkungan lab terlebih dahulu. Gunakan logging dan Pester untuk memastikan bahwa penonaktifan fitur bukan menjadi penyebab masalah lain pada sistem.

3. **Dokumentasi dan Rollback:**  
   Simpan catatan konfigurasi sebelum menonaktifkan layanan (misalnya, dengan backup rule firewall atau setting adapter) sehingga kamu dapat mengembalikan konfigurasi asli jika pengujian selesai atau terjadi kesalahan.

4. **CI/CD Integration:**  
   Integrasikan fungsi-fungsi ini dalam pipeline otomatisasi. Misalnya, sebelum deployment, sistem dapat menjalankan skrip yang menonaktifkan fitur-fitur tertentu agar area update lebih mudah diisolasi dari lalu lintas produksi.

Dengan pemahaman mendalam terhadap fungsi-fungsi disable, disconnect, dan dismount ini, kamu dapat mengendalikan lingkungan sistem dan lab secara lebih terperinci—memastikan tiap fitur aktif hanya saat diperlukan, dan dengan demikian mendukung pengujian yang lebih akurat serta troubleshooting yang efektif.

Apakah kamu ingin mendalami contoh skrip lengkap untuk salah satu skenario tersebut atau ingin mengeksplorasi bagaimana memonitor hasil perubahan konfigurasi secara dinamis?
