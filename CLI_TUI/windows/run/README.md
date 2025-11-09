Di Windows 10 dan 11, jumlah perintah yang bisa kamu panggil lewat dialog Run sebenarnya tergantung pada seberapa dalam kamu menghitungnya:

- **Perintah “inti” (core)** – yaitu yang paling sering dipakai untuk membuka aplikasi dan settings umum – berjumlah sekitar **60 perintah**. Ini sudah mencakup applets Control Panel, tool bawaan, hingga game simple seperti `freecell` atau `winmine` ([Thundercloud][1]).
- **Seluruh applet Control Panel, snap-in MMC, utilitas sistem, dan perintah legacy** – kalau dihitung semua, minimal ada **112 perintah** default yang bisa kamu jalankan di Run tanpa tambahan software pihak ketiga ([LizardSystems][2]).

Jadi, kalau kamu cuma butuh akses cepat ke fitur umum, sekitar 60 perintah sudah lebih dari cukup. Tapi kalau termasuk seluruh Control Panel applets dan tool-tool bawaan Windows, angkanya menembus 112. Kalau butuh lebih banyak lagi—misalnya perintah dari software lain yang kamu pasang—angka itu bisa bertambah terus. Berikut **5 perintah dasar** Win + R yang paling sering dipakai oleh pengguna awam.

[1]: https://www.thundercloud.net/infoave/new/60-run-commands-for-windows-10-windows-11/?utm_source=chatgpt.com "60 Run Commands for Windows 10 & Windows 11"
[2]: https://lizardsystems.com/articles/112-windows-run-commands/ "112 Windows run commands - LizardSystems"

1. **notepad**

   - **Fungsi:** Membuka aplikasi Notepad, editor teks sederhana.
   - **Di CMD/PS:** Bisa langsung ketik `notepad` lalu Enter.

2. **calc**

   - **Fungsi:** Menjalankan Kalkulator Windows.
   - **Di CMD/PS:** Cukup ketik `calc` lalu Enter.

3. **mspaint**

   - **Fungsi:** Menjalankan Microsoft Paint untuk menggambar atau mengedit gambar sederhana.
   - **Di CMD/PS:** Ketik `mspaint` lalu Enter.

4. **explorer**

   - **Fungsi:** Membuka File Explorer (jendela folder).
   - **Di CMD/PS:**

     - `explorer` → buka jendela “This PC”
     - `explorer <path>` → buka folder tertentu, misalnya `explorer C:\Users`

5. **cmd**

   - **Fungsi:** Membuka Command Prompt.
   - **Di CMD/PS:**

     - Dari PS: `cmd` → akan meluncurkan CMD baru
     - Dari CMD: jalankan `start cmd` atau cukup klik Win+R

---

Semua perintah di atas dijalankan dari CMD maupun PowerShell, hasilnya **identik** dengan menekan Win + R. Berikutnya **5 perintah tingkat “menengah”** (level IT support) dan kemudian yang “lanjutan” (tech-savvy/sysadmin). yang cocok buat support IT / teknisi lapangan. Urutannya dari #6 sampai #10: perintah ini juga “langsung” dipanggil via CMD atau PowerShell, tinggal ketik nama file `.exe`/`.msc`-nya. Kalau tiba-tiba error “command not found”, tambahkan `start` di depan (mis. `start services.msc`).

6. **control**

   - **Fungsi:** Membuka Control Panel klasik (semua applet).
   - **Di CMD/PS:**

     - `control` → langsung terbuka Control Panel.
     - Bisa juga `start control` untuk jaga-jaga kalau ada masalah PATH.

7. **eventvwr**

   - **Fungsi:** Event Viewer – lihat log sistem, aplikasi, keamanan. Penting untuk troubleshooting error.
   - **Di CMD/PS:**

     - Cukup `eventvwr`, Enter.
     - Atau `start eventvwr` kalau mau panggil via `start`.

8. **devmgmt.msc**

   - **Fungsi:** Device Manager – kelola driver, cek hardware conflict.
   - **Di CMD/PS:**

     - Ketik `devmgmt.msc`, Enter.
     - Atau `mmc devmgmt.msc` untuk pakai Microsoft Management Console secara eksplisit.

9. **compmgmt.msc**

   - **Fungsi:** Computer Management – gabungan Event Viewer, Disk Management, Services, dsb. Super handy untuk sekali buka banyak tool.
   - **Di CMD/PS:**

     - `compmgmt.msc`, Enter.
     - Atau `mmc compmgmt.msc` kalau perlu load MMC manual.

10. **services.msc**

- **Fungsi:** Services – start/stop/disable service Windows. Kunci buat optimasi startup & security.
- **Di CMD/PS:**

  - `services.msc`, Enter.
  - Atau `mmc services.msc`.

---

Berikut **5 perintah lanjutan** (#11–#15) yang umum dipakai untuk administrasi dan diagnostik tingkat menengah–mahir.

**11. msconfig**

- **Fungsi:** System Configuration Utility – mengelola program startup, layanan, boot options (Safe Boot, Diagnostic Startup).
- **Penggunaan di CMD/PowerShell:**

  ```
  msconfig
  ```

  atau jika diperlukan:

  ```
  start msconfig
  ```

**12. regedit**

- **Fungsi:** Registry Editor – menelusuri dan memodifikasi Windows Registry (HKLM, HKCU, dsb.).
- **Penggunaan di CMD/PowerShell:**

  ```
  regedit
  ```

  atau

  ```
  start regedit
  ```

**13. msinfo32**

- **Fungsi:** System Information – menampilkan ringkasan hardware, resource conflicts, software environment, dan komponen sistem.
- **Penggunaan di CMD/PowerShell:**

  ```
  msinfo32
  ```

  atau

  ```
  start msinfo32
  ```

**14. diskmgmt.msc**

- **Fungsi:** Disk Management – membuat, menghapus, dan memformat partition; mengubah drive letter; menginisialisasi disk baru.
- **Penggunaan di CMD/PowerShell:**

  ```
  diskmgmt.msc
  ```

  atau

  ```
  mmc diskmgmt.msc
  ```

**15. perfmon**

- **Fungsi:** Performance Monitor – memantau real-time counter kinerja CPU, memori, disk, jaringan; merekam data untuk analisis mendalam.
- **Penggunaan di CMD/PowerShell:**

  ```
  perfmon
  ```

  atau

  ```
  start perfmon
  ```

**Catatan Umum:**
Semua perintah di atas dapat langsung dijalankan pada Command Prompt maupun PowerShell dengan mengetik nama perintah. Jika terjadi kesalahan “command not found”, gunakan prefix `start` atau `mmc` sesuai kebutuhan. Perintah berikutnya adalah **20 perintah lanjutan** (#16–#35) untuk dokumentasi pembelajaran formal. Setiap entri mencakup deskripsi fungsi dan cara pemanggilan dari CMD maupun PowerShell.

**16. gpedit.msc**

- **Fungsi:** Group Policy Editor – konfigurasi kebijakan lokal untuk pengguna dan komputer.
- **Di CMD/PS:**

  ```
  gpedit.msc
  ```

  atau

  ```
  mmc gpedit.msc
  ```

**17. taskmgr**

- **Fungsi:** Task Manager – memonitor dan mengelola proses, performa, serta riwayat aplikasi.
- **Di CMD/PS:**

  ```
  taskmgr
  ```

  atau

  ```
  start taskmgr
  ```

**18. taskschd.msc**

- **Fungsi:** Task Scheduler – menjadwalkan tugas otomatis (backup, maintenance, dsb.).
- **Di CMD/PS:**

  ```
  taskschd.msc
  ```

  atau

  ```
  mmc taskschd.msc
  ```

**19. lusrmgr.msc**

- **Fungsi:** Local Users and Groups – manajemen akun lokal dan grup (hanya di edisi Pro/Enterprise).
- **Di CMD/PS:**

  ```
  lusrmgr.msc
  ```

  atau

  ```
  mmc lusrmgr.msc
  ```

**20. dfrgui**

- **Fungsi:** Defragment and Optimize Drives – optimasi dan defragmentasi disk.
- **Di CMD/PS:**

  ```
  dfrgui
  ```

  atau

  ```
  start dfrgui
  ```

**21. cleanmgr**

- **Fungsi:** Disk Cleanup – membersihkan file sementara dan sampah sistem.
- **Di CMD/PS:**

  ```
  cleanmgr
  ```

  atau

  ```
  start cleanmgr
  ```

**22. powercfg.cpl**

- **Fungsi:** Power Options – konfigurasi rencana daya dan pengaturan sleep/hibernate.
- **Di CMD/PS:**

  ```
  powercfg.cpl
  ```

  atau

  ```
  control powercfg.cpl
  ```

**23. sysdm.cpl**

- **Fungsi:** System Properties – pengaturan nama komputer, hardware, remote, dan system protection.
- **Di CMD/PS:**

  ```
  sysdm.cpl
  ```

  atau

  ```
  control sysdm.cpl
  ```

**24. control userpasswords2**

- **Fungsi:** User Accounts (advanced) – pengelolaan login otomatis dan keanggotaan grup.
- **Di CMD/PS:**

  ```
  control userpasswords2
  ```

  atau

  ```
  start control userpasswords2
  ```

**25. ncpa.cpl**

- **Fungsi:** Network Connections – daftar dan konfigurasi adapter jaringan.
- **Di CMD/PS:**

  ```
  ncpa.cpl
  ```

  atau

  ```
  control ncpa.cpl
  ```

**26. firewall.cpl**

- **Fungsi:** Windows Defender Firewall – konfigurasi aturan firewall inbound/outbound.
- **Di CMD/PS:**

  ```
  firewall.cpl
  ```

  atau

  ```
  control firewall.cpl
  ```

**27. mrt.exe**

- **Fungsi:** Microsoft Removal Tool – pemindaian dan pembersihan malware secara berkala.
- **Di CMD/PS:**

  ```
  mrt
  ```

  atau

  ```
  start mrt.exe
  ```

**28. chkdsk**

- **Fungsi:** Check Disk – pemeriksaan integritas sistem file dan bad sector.
- **Di CMD/PS:**

  ```
  chkdsk C: /f /r
  ```

  (menambahkan parameter sesuai kebutuhan)

**29. sfc**

- **Fungsi:** System File Checker – memeriksa dan memperbaiki file sistem yang korup.
- **Di CMD/PS:**

  ```
  sfc /scannow
  ```

**30. gpupdate**

- **Fungsi:** Group Policy Update – menerapkan ulang kebijakan grup tanpa reboot.
- **Di CMD/PS:**

  ```
  gpupdate /force
  ```

**31. cipher**

- **Fungsi:** Encrypting File System – mengelola enkripsi file pada sistem berformat NTFS.
- **Di CMD/PS:**

  ```
  cipher /e <file_or_folder>
  ```

  atau

  ```
  cipher /w:<drive>
  ```

**32. diskpart**

- **Fungsi:** Disk Partitioning – membuat, menghapus, dan mengatur partisi disk melalui CLI.
- **Di CMD/PS:**

  ```
  diskpart
  ```

  kemudian gunakan perintah internal DISKPART.

**33. bcdedit**

- **Fungsi:** Boot Configuration Data Editor – memodifikasi opsi boot Windows (dual-boot, timeout, dsb.).
- **Di CMD/PS:**

  ```
  bcdedit /enum
  ```

  atau parameter lainnya sesuai dokumentasi.

**34. resmon**

- **Fungsi:** Resource Monitor – pemantauan real-time penggunaan CPU, disk, memori, dan jaringan.
- **Di CMD/PS:**

  ```
  resmon
  ```

  atau

  ```
  perfmon /res
  ```

**35. wsreset.exe**

- **Fungsi:** Windows Store Reset – membersihkan cache Microsoft Store untuk memperbaiki masalah instalasi/app.
- **Di CMD/PS:**

  ```
  wsreset.exe
  ```

  atau

  ```
  start wsreset.exe
  ```

---

Semua perintah di atas dapat dijalankan langsung di Command Prompt maupun PowerShell. Untuk yang berupa `.msc`, gunakan `mmc <nama>.msc` jika diperlukan, dan untuk URI/CPL gunakan `control <nama>.cpl` atau `start <protocol>`. Dengan demikian, seluruh perintah Win+R—dari yang awam hingga super-user—telah terdokumentasi. Berikut **20 perintah lanjutan** (#36–#55) dengan deskripsi fungsi dan cara pemanggilan dari Command Prompt maupun PowerShell. Disusun secara formal untuk dokumentasi pembelajaran.

**36. winver**

- **Fungsi:** Menampilkan jendela “About Windows” yang memuat versi dan build Windows terpasang.
- **Di CMD/PS:**

  ```
  winver
  ```

**37. whoami**

- **Fungsi:** Menampilkan nama user yang sedang aktif beserta grup-keanggotaan di domain/lokal.
- **Di CMD/PS:**

  ```
  whoami
  ```

**38. hostname**

- **Fungsi:** Menampilkan nama komputer saat ini di jaringan.
- **Di CMD/PS:**

  ```
  hostname
  ```

**39. ipconfig**

- **Fungsi:** Menampilkan konfigurasi TCP/IP dari semua adapter jaringan (IP address, subnet mask, default gateway).
- **Di CMD/PS:**

  ```
  ipconfig /all
  ```

**40. ping**

- **Fungsi:** Mengirim paket ICMP echo ke target (host/IP) untuk menguji koneksi jaringan.
- **Di CMD/PS:**

  ```
  ping <host_or_ip>
  ```

**41. tracert**

- **Fungsi:** Melacak rute paket IP menuju target dengan menampilkan setiap hop yang dilewati.
- **Di CMD/PS:**

  ```
  tracert <host_or_ip>
  ```

**42. pathping**

- **Fungsi:** Kombinasi ping dan tracert untuk analisis kehilangan paket pada setiap hop.
- **Di CMD/PS:**

  ```
  pathping <host_or_ip>
  ```

**43. nslookup**

- **Fungsi:** Query DNS untuk menerjemahkan nama host ke IP atau sebaliknya.
- **Di CMD/PS:**

  ```
  nslookup <host_or_domain>
  ```

**44. arp**

- **Fungsi:** Menampilkan dan memodifikasi tabel ARP (Address Resolution Protocol).
- **Di CMD/PS:**

  ```
  arp -a
  ```

**45. route**

- **Fungsi:** Menampilkan dan memodifikasi tabel routing IP.
- **Di CMD/PS:**

  ```
  route print
  ```

**46. netstat**

- **Fungsi:** Menampilkan koneksi jaringan aktif, port listening, statistik protokol.
- **Di CMD/PS:**

  ```
  netstat -an
  ```

**47. telnet**

- **Fungsi:** Klien Telnet untuk menguji koneksi ke port TCP pada host remote (jika Telnet Client telah diaktifkan).
- **Di CMD/PS:**

  ```
  telnet <host> <port>
  ```

**48. ftp**

- **Fungsi:** Klien FTP bawaan untuk transfer file ke/dari server FTP.
- **Di CMD/PS:**

  ```
  ftp <server_address>
  ```

**49. tasklist**

- **Fungsi:** Menampilkan daftar proses yang sedang berjalan beserta PID dan penggunaan memori.
- **Di CMD/PS:**

  ```
  tasklist
  ```

**50. shutdown**

- **Fungsi:** Mematikan atau merestart komputer, memaksa aplikasi tertutup, dan menampilkan pesan.
- **Di CMD/PS:**

  ```
  shutdown /s /t 0      (mematikan)
  shutdown /r /t 0      (merestart)
  shutdown /l           (log off)
  ```

**51. msg**

- **Fungsi:** Mengirim pesan singkat ke session pengguna lain dalam domain atau lokal.
- **Di CMD/PS:**

  ```
  msg <username> "Pesan Anda di sini"
  ```

**52. at**

- **Fungsi:** (Legacy) Menjadwalkan tugas pada waktu tertentu. Telah digantikan oleh `schtasks`.
- **Di CMD/PS:**

  ```
  at 14:00 /every:M,T,W c:\backup.bat
  ```

**53. schtasks**

- **Fungsi:** Menjadwalkan, menampilkan, memodifikasi, dan menghapus tugas terjadwal.
- **Di CMD/PS:**

  ```
  schtasks /create /tn "BackupHarian" /tr "c:\backup.bat" /sc daily /st 02:00
  ```

**54. net**

- **Fungsi:** Sekumpulan sub-perintah untuk manajemen jaringan dan service, misalnya `net user`, `net share`, `net use`.
- **Di CMD/PS:**

  ```
  net user
  net share
  net use
  ```

**55. shell\:startup**

- **Fungsi:** Membuka folder Startup pengguna saat ini (aplikasi yang berjalan otomatis saat login).
- **Di CMD/PS:**

  ```powershell
  start shell:startup
  ```

  atau

  ```cmd
  explorer shell:startup
  ```

---

Dengan ini, keseluruhan **55 perintah** Win + R—dari tingkat dasar hingga super-user—telah didokumentasikan lengkap beserta petunjuk penggunaan di Command Prompt dan PowerShell.

**56. osk**

- **Fungsi:** On-Screen Keyboard – menampilkan keyboard virtual di layar.
- **Di CMD/PS:**

  ```
  osk
  ```

**57. write**

- **Fungsi:** Membuka WordPad, editor teks kaya fitur (Rich Text).
- **Di CMD/PS:**

  ```
  write
  ```

**58. quickassist**

- **Fungsi:** Quick Assist – berbagi layar untuk bantuan jarak jauh Windows.
- **Di CMD/PS:**

  ```
  quickassist
  ```

**59. msra**

- **Fungsi:** Remote Assistance – membuka alat Remote Assistance klasik.
- **Di CMD/PS:**

  ```
  msra
  ```

**60. snippingtool**

- **Fungsi:** Snipping Tool – mengambil tangkapan layar area bebas atau jendela.
- **Di CMD/PS:**

  ```
  snippingtool
  ```

**61. recdisc**

- **Fungsi:** Create a recovery disc – wizard untuk membuat CD/DVD pemulihan sistem.
- **Di CMD/PS:**

  ```
  recdisc
  ```

**62. fsutil**

- **Fungsi:** File System Utility – pemeriksaan dan konfigurasi tingkat lanjut filesystem (NTFS).
- **Di CMD/PS:**

  ```
  fsutil <subcommand> [options]
  ```

  Contoh:

  ```
  fsutil dirty query C:
  ```

**63. takeown**

- **Fungsi:** Mengambil kepemilikan (ownership) file atau folder.
- **Di CMD/PS:**

  ```
  takeown /f "<path>"
  ```

**64. icacls**

- **Fungsi:** Mengelola izin (ACL) file dan folder.
- **Di CMD/PS:**

  ```
  icacls "<path>" /grant <user>:(F)
  ```

**65. dism**

- **Fungsi:** Deployment Image Servicing and Management – perbaikan dan manajemen image Windows (WIM/VHD).
- **Di CMD/PS:**

  ```
  dism /Online /Cleanup-Image /RestoreHealth
  ```

**66. bootrec**

- **Fungsi:** Boot Recovery Tool – memperbaiki sektor boot, BCD, MBR.
- **Di CMD/PS (dalam WinRE atau elevated):**

  ```
  bootrec /fixmbr
  bootrec /fixboot
  bootrec /rebuildbcd
  ```

**67. bcdboot**

- **Fungsi:** Boot Configuration Data Boot Files – membuat atau memperbaiki file boot pada partisi sistem.
- **Di CMD/PS (dengan akses admin):**

  ```
  bcdboot C:\Windows /l en-us /s C:
  ```

**68. driverquery**

- **Fungsi:** Menampilkan daftar driver yang terpasang beserta modul, tanggal, dan versi.
- **Di CMD/PS:**

  ```
  driverquery /v /fo table
  ```

**69. wevtutil**

- **Fungsi:** Windows Event Utility – ekspor, impor, menghapus, dan mengonfigurasi log Event.
- **Di CMD/PS:**

  ```
  wevtutil qe System /c:10 /rd:true
  ```

**70. eventcreate**

- **Fungsi:** Membuat entri log custom di Event Viewer.
- **Di CMD/PS:**

  ```
  eventcreate /T INFORMATION /ID 1000 /L APPLICATION /D "Contoh entri log"
  ```

**71. logman**

- **Fungsi:** Performance Counter Logger – membuat dan mengelola data collector set untuk Performance Monitor.
- **Di CMD/PS:**

  ```
  logman create counter MyTrace -c "\Processor(_Total)\% Processor Time" -f csv -o C:\Logs\trace.csv
  ```

**72. reagentc**

- **Fungsi:** Recovery Environment Configuration – mengonfigurasi WinRE (enable/disable, lokasi image).
- **Di CMD/PS (admin):**

  ```
  reagentc /enable
  reagentc /info
  ```

**73. rpcping**

- **Fungsi:** Menguji konektivitas RPC dan endpoint mapper pada server.
- **Di CMD/PS (administrative tools diperlukan):**

  ```
  rpcping -s <server> -e 0x12345678 -t ncacn_ip_tcp
  ```

**74. attrib**

- **Fungsi:** Menampilkan/mengubah atribut file (Read-only, Hidden, System).
- **Di CMD/PS:**

  ```
  attrib +h +s "C:\Secret\File.txt"
  ```

**75. subst**

- **Fungsi:** Membuat drive virtual yang memetakan folder ke huruf drive.
- **Di CMD/PS:**

  ```
  subst X: "C:\MyFolder"
  ```

**76. mstsc**

- **Fungsi:** Remote Desktop Connection – membuka klien Remote Desktop.
- **Di CMD/PS:**

  ```
  mstsc
  ```

  atau dengan parameter:

  ```
  mstsc /v:<server>
  ```

**77. optionalfeatures**

- **Fungsi:** Windows Features – mengaktifkan/mematikan fitur Windows (Hyper-V, IIS, .NET, dsb.).
- **Di CMD/PS:**

  ```
  optionalfeatures
  ```

  atau

  ```
  start optionalfeatures.exe
  ```

**78. soundrecorder**

- **Fungsi:** Windows Sound Recorder – merekam audio dari mikrofon (hanya pada versi Windows lama).
- **Di CMD/PS:**

  ```
  soundrecorder
  ```

**79. wmplayer**

- **Fungsi:** Windows Media Player – pemutar media bawaan Windows.
- **Di CMD/PS:**

  ```
  wmplayer
  ```

**80. magnify**

- **Fungsi:** Magnifier – pembesar layar untuk aksesibilitas.
- **Di CMD/PS:**

  ```
  magnify
  ```

**81. narrator**

- **Fungsi:** Narrator – pembaca layar bawaan Windows.
- **Di CMD/PS:**

  ```
  narrator
  ```

**82. control printers**

- **Fungsi:** Membuka langsung applet Printers & Scanners di Control Panel.
- **Di CMD/PS:**

  ```
  control printers
  ```

**83. desk.cpl**

- **Fungsi:** Display Properties – pengaturan resolusi layar, multiple displays, orientasi.
- **Di CMD/PS:**

  ```
  desk.cpl
  ```

  atau

  ```
  control desk.cpl
  ```

**84. intl.cpl**

- **Fungsi:** Region & Language – pengaturan format tanggal/waktu, bahasa, lokasi sistem.
- **Di CMD/PS:**

  ```
  intl.cpl
  ```

  atau

  ```
  control intl.cpl
  ```

**85. timedate.cpl**

- **Fungsi:** Date and Time – mengubah tanggal, waktu, zona waktu, dan sinkronisasi Internet Time.
- **Di CMD/PS:**

  ```
  timedate.cpl
  ```

  atau

  ```
  control timedate.cpl
  ```

**86. control folders**

- **Fungsi:** Folder Options – pengaturan tampilan dan perilaku File Explorer (hidden files, extensions).
- **Di CMD/PS:**

  ```
  control folders
  ```

**87. shell\:common startup**

- **Fungsi:** Membuka folder Startup untuk semua pengguna (program yang berjalan otomatis saat login).
- **Di CMD/PS:**

  ```powershell
  start shell:common startup
  ```

  atau

  ```cmd
  explorer shell:common startup
  ```

**88. shell\:common programs**

- **Fungsi:** Membuka folder Programs di Start Menu untuk semua pengguna.
- **Di CMD/PS:**

  ```powershell
  start shell:common programs
  ```

**89. shell\:sendto**

- **Fungsi:** Membuka folder SendTo (menu klik kanan → Send to).
- **Di CMD/PS:**

  ```powershell
  start shell:sendto
  ```

**90. shell\:recent**

- **Fungsi:** Membuka folder Recent Items (file yang baru dibuka).
- **Di CMD/PS:**

  ```powershell
  start shell:recent
  ```

**91. shell\:desktop**

- **Fungsi:** Membuka folder Desktop pengguna saat ini.
- **Di CMD/PS:**

  ```powershell
  start shell:desktop
  ```

**92. shell\:personal**

- **Fungsi:** Membuka folder Documents (My Documents) pengguna saat ini.
- **Di CMD/PS:**

  ```powershell
  start shell:personal
  ```

**93. rstrui**

- **Fungsi:** System Restore – membuka wizard Pemulihan Sistem untuk mengembalikan keadaan Windows ke titik sebelumnya.
- **Di CMD/PS:**

  ```
  rstrui
  ```

**94. SystemPropertiesAdvanced**

- **Fungsi:** Buka langsung tab Advanced di System Properties (Performance, User Profiles, Startup and Recovery).
- **Di CMD/PS:**

  ```
  SystemPropertiesAdvanced
  ```

  atau

  ```
  control sysdm.cpl,,3
  ```

**95. mdsched**

- **Fungsi:** Windows Memory Diagnostic – memeriksa RAM untuk kesalahan hardware.
- **Di CMD/PS:**

  ```
  mdsched
  ```

  (akan meminta reboot dan menjalankan diagnosa sebelum Windows boot)

**96. msdt**

- **Fungsi:** Microsoft Support Diagnostic Tool – menjalankan paket diagnostik dan wizard troubleshooting.
- **Di CMD/PS:**

  ```
  msdt
  ```

**97. mshta**

- **Fungsi:** Microsoft HTML Application Host – menjalankan aplikasi HTML (.hta) sebagai desktop app.
- **Di CMD/PS:**

  ```
  mshta <path_to_.hta>
  ```

  Contoh:

  ```
  mshta "%windir%\system32\mshta.exe"
  ```

**98. secpol.msc**

- **Fungsi:** Local Security Policy – konfigurasi kebijakan keamanan lokal (password policy, audit policy, dsb.).
- **Di CMD/PS:**

  ```
  secpol.msc
  ```

  atau

  ```
  mmc secpol.msc
  ```

**99. certmgr.msc**

- **Fungsi:** Certificate Manager – meninjau dan mengelola sertifikat user dan mesin lokal.
- **Di CMD/PS:**

  ```
  certmgr.msc
  ```

  atau

  ```
  mmc certmgr.msc
  ```

**100. gpresult**

- **Fungsi:** Group Policy Result – menampilkan kebijakan grup yang diterapkan pada komputer dan user.
- **Di CMD/PS:**

  ```
  gpresult /r
  ```

  atau untuk output ke file:

  ```
  gpresult /h report.html
  ```

**101. netsh**

- **Fungsi:** Network Shell – konfigurasi jaringan lanjutan (firewall, interface, routing, WLAN, dsb.).
- **Di CMD/PS:**

  ```
  netsh <context> <subcommand>
  ```

  Contoh:

  ```
  netsh interface ip show config
  ```

**102. winrm**

- **Fungsi:** Windows Remote Management – konfigurasi layanan WinRM (PowerShell remoting).
- **Di CMD/PS:**

  ```
  winrm quickconfig
  ```

**103. winrs**

- **Fungsi:** Windows Remote Shell – mengeksekusi perintah secara remote lewat WinRM.
- **Di CMD/PS:**

  ```
  winrs -r:<remote_computer> dir C:\
  ```

**104. wmic**

- **Fungsi:** Windows Management Instrumentation Command-line – query dan kontrol WMI (hardware, software, service).
- **Di CMD/PS:**

  ```
  wmic <alias> <command>
  ```

  Contoh:

  ```
  wmic cpu get name,MaxClockSpeed
  ```

**105. lpksetup**

- **Fungsi:** Language Pack Installer – menambah atau menghapus language pack Windows.
- **Di CMD/PS:**

  ```
  lpksetup
  ```

**106. hdwwiz.cpl**

- **Fungsi:** Add Hardware Wizard – wizard pemasangan perangkat keras baru.
- **Di CMD/PS:**

  ```
  hdwwiz.cpl
  ```

  atau

  ```
  control hdwwiz.cpl
  ```

**107. eudcedit**

- **Fungsi:** Private Character Editor – membuat karakter khusus untuk font.
- **Di CMD/PS:**

  ```
  eudcedit
  ```

**108. msiexec**

- **Fungsi:** Windows Installer – instalasi, uninstalasi, dan konfigurasi paket MSI.
- **Di CMD/PS:**

  ```
  msiexec /i <package.msi>
  ```

  atau untuk uninstall:

  ```
  msiexec /x <package.msi>
  ```

**109. odbcad32**

- **Fungsi:** ODBC Data Source Administrator – mengelola DSN (32-bit).
- **Di CMD/PS:**

  ```
  odbcad32
  ```

**110. migwiz**

- **Fungsi:** User State Migration Tool – wizard transfer data & settings (Easy Transfer).
- **Di CMD/PS:**

  ```
  migwiz
  ```

**111. sdclt**

- **Fungsi:** Backup and Restore (Windows 7) – menjalankan wizard cadangan dan pemulihan.
- **Di CMD/PS:**

  ```
  sdclt
  ```

**112. sysprep**

- **Fungsi:** System Preparation Tool – generalisasi image Windows untuk deployment.
- **Di CMD/PS:**

  ```
  sysprep
  ```

  (membuka GUI Sysprep)

**113. dxdiag**

- **Fungsi:** DirectX Diagnostic Tool – informasi lengkap tentang komponen DirectX dan GPU.
- **Di CMD/PS:**

  ```
  dxdiag
  ```

**114. rasphone**

- **Fungsi:** Remote Access Phonebook – mengelola koneksi dial-up dan VPN.
- **Di CMD/PS:**

  ```
  rasphone
  ```

**115. agentactivation**

- **Fungsi:** Windows Defender Scheduled Scan Activation – memicu scan terjadwal (custom URI).
- **Di CMD/PS:**

  ```powershell
  start ms-windows-defender://|scheduledscan
  ```

**116. shell\:fonts**

- **Fungsi:** Membuka folder Fonts, tempat instalasi font sistem.
- **Di CMD/PS:**

  ```
  start shell:fonts
  ```

**117. shell\:network**

- **Fungsi:** Membuka tampilan Network (Network Connections di File Explorer).
- **Di CMD/PS:**

  ```
  start shell:network
  ```

**118. shell\:downloads**

- **Fungsi:** Membuka folder Downloads pengguna saat ini.
- **Di CMD/PS:**

  ```
  start shell:downloads
  ```

**119. shell\:music**

- **Fungsi:** Membuka folder Music (My Music).
- **Di CMD/PS:**

  ```
  start shell:music
  ```

**120. shell\:pictures**

- **Fungsi:** Membuka folder Pictures (My Pictures).
- **Di CMD/PS:**

  ```
  start shell:pictures
  ```

**121. shell\:videos**

- **Fungsi:** Membuka folder Videos (My Videos).
- **Di CMD/PS:**

  ```
  start shell:videos
  ```

**122. shell:"camera roll"**

- **Fungsi:** Membuka folder Camera Roll, tempat foto/video import dari kamera.
- **Di CMD/PS:**

  ```
  start shell:"camera roll"
  ```

**123. shell\:links**

- **Fungsi:** Membuka folder Links, shortcut pada Favorites di Internet Explorer.
- **Di CMD/PS:**

  ```
  start shell:links
  ```

**124. ms-settings\:display**

- **Fungsi:** Membuka halaman Display Settings pada Settings modern Windows 10/11.
- **Di CMD/PS:**

  ```
  start ms-settings:display
  ```

**125. ms-settings\:network**

- **Fungsi:** Membuka halaman Network & Internet Settings.
- **Di CMD/PS:**

  ```
  start ms-settings:network
  ```

**126. ms-settings\:windowsupdate**

- **Fungsi:** Membuka halaman Windows Update untuk pengecekan dan instalasi patch.
- **Di CMD/PS:**

  ```
  start ms-settings:windowsupdate
  ```

**127. ms-settings\:bluetooth**

- **Fungsi:** Membuka halaman pengaturan Bluetooth & perangkat lain.
- **Di CMD/PS:**

  ```
  start ms-settings:bluetooth
  ```

**128. ms-settings\:privacy**

- **Fungsi:** Membuka halaman Privacy Settings (kamera, mikrofon, dsb.).
- **Di CMD/PS:**

  ```
  start ms-settings:privacy
  ```

**129. ms-settings\:appsfeatures**

- **Fungsi:** Membuka halaman Apps & features untuk instalasi/pencopotan aplikasi.
- **Di CMD/PS:**

  ```
  start ms-settings:appsfeatures
  ```

**130. ms-settings\:storagesense**

- **Fungsi:** Membuka halaman Storage Settings & Storage Sense.
- **Di CMD/PS:**

  ```
  start ms-settings:storagesense
  ```

**131. ms-settings\:defaultapps**

- **Fungsi:** Membuka halaman Default Apps untuk pengaturan aplikasi bawaan (browser, media).
- **Di CMD/PS:**

  ```
  start ms-settings:defaultapps
  ```

**132. ms-settings\:regionlanguage**

- **Fungsi:** Membuka halaman Region & Language Settings.
- **Di CMD/PS:**

  ```
  start ms-settings:regionlanguage
  ```

**133. ms-settings\:dateandtime**

- **Fungsi:** Membuka halaman Date & time Settings.
- **Di CMD/PS:**

  ```
  start ms-settings:dateandtime
  ```

**134. ms-settings\:about**

- **Fungsi:** Membuka halaman About untuk informasi sistem dan build Windows.
- **Di CMD/PS:**

  ```
  start ms-settings:about
  ```

**135. ms-settings\:troubleshoot**

- **Fungsi:** Membuka halaman Troubleshoot, wizard pemecahan masalah perangkat keras & sistem.
- **Di CMD/PS:**

  ```
  start ms-settings:troubleshoot
  ```

---

Berikut **20 perintah tambahan** (#136–#155) berbasis URI `ms-settings:` dan `shell:` yang masih dapat dijalankan lewat dialog Run, CMD, atau PowerShell pada Windows 10/11. Disusun secara formal untuk dokumentasi pembelajaran.

**136. `ms-settings:personalization-background`**

- **Fungsi:** Membuka halaman Background di Settings → Personalization.
- **Di CMD/PS:**

  ```
  start ms-settings:personalization-background
  ```

**137. `ms-settings:personalization-lockscreen`**

- **Fungsi:** Membuka halaman Lock screen di Settings → Personalization.
- **Di CMD/PS:**

  ```
  start ms-settings:personalization-lockscreen
  ```

**138. `ms-settings:personalization-colors`**

- **Fungsi:** Membuka halaman Colors di Settings → Personalization.
- **Di CMD/PS:**

  ```
  start ms-settings:personalization-colors
  ```

**139. `ms-settings:themes`**

- **Fungsi:** Membuka halaman Themes di Settings → Personalization.
- **Di CMD/PS:**

  ```
  start ms-settings:themes
  ```

**140. `ms-settings:fonts`**

- **Fungsi:** Membuka halaman Fonts di Settings.
- **Di CMD/PS:**

  ```
  start ms-settings:fonts
  ```

**141. `ms-settings:privacy-location`**

- **Fungsi:** Membuka halaman Location privacy di Settings.
- **Di CMD/PS:**

  ```
  start ms-settings:privacy-location
  ```

**142. `ms-settings:privacy-camera`**

- **Fungsi:** Membuka halaman Camera privacy di Settings.
- **Di CMD/PS:**

  ```
  start ms-settings:privacy-camera
  ```

**143. `ms-settings:privacy-microphone`**

- **Fungsi:** Membuka halaman Microphone privacy di Settings.
- **Di CMD/PS:**

  ```
  start ms-settings:privacy-microphone
  ```

**144. `ms-settings:privacy-notifications`**

- **Fungsi:** Membuka halaman Notifications & actions di Settings.
- **Di CMD/PS:**

  ```
  start ms-settings:privacy-notifications
  ```

**145. `ms-settings:privacy-backgroundapps`**

- **Fungsi:** Membuka halaman Background apps di Settings.
- **Di CMD/PS:**

  ```
  start ms-settings:privacy-backgroundapps
  ```

**146. `ms-settings:devices-bluetooth`**

- **Fungsi:** Membuka halaman Bluetooth & devices di Settings.
- **Di CMD/PS:**

  ```
  start ms-settings:devices-bluetooth
  ```

**147. `ms-settings:devicesprinters`**

- **Fungsi:** Membuka halaman Printers & scanners di Settings.
- **Di CMD/PS:**

  ```
  start ms-settings:devicesprinters
  ```

**148. `ms-settings:easeofaccess-display`**

- **Fungsi:** Membuka halaman Display di Settings → Ease of Access.
- **Di CMD/PS:**

  ```
  start ms-settings:easeofaccess-display
  ```

**149. `ms-settings:easeofaccess-magnifier`**

- **Fungsi:** Membuka halaman Magnifier di Settings → Ease of Access.
- **Di CMD/PS:**

  ```
  start ms-settings:easeofaccess-magnifier
  ```

**150. `ms-settings:easeofaccess-narrator`**

- **Fungsi:** Membuka halaman Narrator di Settings → Ease of Access.
- **Di CMD/PS:**

  ```
  start ms-settings:easeofaccess-narrator
  ```

**151. `ms-settings:developers`**

- **Fungsi:** Membuka halaman For developers di Settings.
- **Di CMD/PS:**

  ```
  start ms-settings:developers
  ```

**152. `ms-settings:gaming-gamebar`**

- **Fungsi:** Membuka halaman Xbox Game Bar di Settings → Gaming.
- **Di CMD/PS:**

  ```
  start ms-settings:gaming-gamebar
  ```

**153. `ms-settings:gaming-xboxnetworking`**

- **Fungsi:** Membuka halaman Xbox Networking di Settings → Gaming.
- **Di CMD/PS:**

  ```
  start ms-settings:gaming-xboxnetworking
  ```

**154. `ms-settings:network-proxy`**

- **Fungsi:** Membuka halaman Proxy di Settings → Network & Internet.
- **Di CMD/PS:**

  ```
  start ms-settings:network-proxy
  ```

**155. `shell:appsfolder`**

- **Fungsi:** Membuka folder Applications, memperlihatkan semua aplikasi (termasuk aplikasi UWP).
- **Di CMD/PS:**

  ```powershell
  start shell:appsfolder
  ```

  atau

  ```cmd
  explorer shell:appsfolder
  ```

**156. `ms-settings:network-wifi`**

- **Fungsi:** Membuka halaman Wi-Fi di Settings → Network & Internet.
- **Di CMD/PS:**

  ```
  start ms-settings:network-wifi
  ```

**157. `ms-settings:network-datausage`**

- **Fungsi:** Menampilkan penggunaan data (Data usage) per aplikasi dan per adapter.
- **Di CMD/PS:**

  ```
  start ms-settings:network-datausage
  ```

**158. `ms-settings:network-mobilehotspot`**

- **Fungsi:** Mengatur Mobile hotspot (penyediaan tethering via Wi-Fi).
- **Di CMD/PS:**

  ```
  start ms-settings:network-mobilehotspot
  ```

**159. `ms-settings:privacy-contacts`**

- **Fungsi:** Mengelola izin akses kontak oleh aplikasi.
- **Di CMD/PS:**

  ```
  start ms-settings:privacy-contacts
  ```

**160. `ms-settings:privacy-messages`**

- **Fungsi:** Mengelola izin akses SMS/Messaging oleh aplikasi.
- **Di CMD/PS:**

  ```
  start ms-settings:privacy-messages
  ```

**161. `ms-settings:privacy-voicenavigation`**

- **Fungsi:** Mengelola izin asisten suara (Voice activation).
- **Di CMD/PS:**

  ```
  start ms-settings:privacy-voicenavigation
  ```

**162. `ms-settings:gaming-broadcasting`**

- **Fungsi:** Pengaturan broadcasting (Game DVR & streaming) di Settings → Gaming.
- **Di CMD/PS:**

  ```
  start ms-settings:gaming-broadcasting
  ```

**163. `ms-settings:windowsbackup`**

- **Fungsi:** Mengatur File History dan opsi backup ke OneDrive.
- **Di CMD/PS:**

  ```
  start ms-settings:windowsbackup
  ```

**164. `shell:ControlPanelFolder`**

- **Fungsi:** Membuka folder utama Control Panel (Mode icon).
- **Di CMD/PS:**

  ```
  explorer shell:ControlPanelFolder
  ```

**165. `shell:PrintersFolder`**

- **Fungsi:** Membuka langsung daftar printer yang terpasang.
- **Di CMD/PS:**

  ```
  explorer shell:PrintersFolder
  ```

**166. `shell:DocumentsLibrary`**

- **Fungsi:** Membuka Libraries → Documents (jika diaktifkan).
- **Di CMD/PS:**

  ```
  explorer shell:DocumentsLibrary
  ```

**167. `shell:SearchHome`**

- **Fungsi:** Membuka tampilan Search Home di File Explorer (Windows 11).
- **Di CMD/PS:**

  ```
  explorer shell:SearchHome
  ```

**168. `ms-info:`**

- **Fungsi:** Alias URI untuk membuka System Information (setara `msinfo32`).
- **Di CMD/PS:**

  ```
  start ms-info:
  ```

**169. `windowsdefender:`**

- **Fungsi:** Membuka Windows Security (Security Center) modern.
- **Di CMD/PS:**

  ```
  start windowsdefender:
  ```

**170. `ms-contact-support:`**

- **Fungsi:** Membuka halaman “Get Help” (Contact Support) di Windows.
- **Di CMD/PS:**

  ```
  start ms-contact-support:
  ```

> **Catatan:**
> – Setelah barisan ini, sisanya umumnya adalah perintah khusus dari aplikasi pihak ketiga yang terpasang, atau URI/protokol custom (misalnya `spotify:`, `mailto:`) bukan bagian Windows default.
> – Untuk memastikan daftar lengkap sesuai konfigurasi PC Anda, Anda dapat mengekspor registry key RunMRU (`HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU`) atau melihat dokumentasi Microsoft terbaru.

Dengan tambahan #156–#170, kini tercakup **170 perintah** bawaan Windows 10/11 yang dapat dieksekusi melalui dialog Run, Command Prompt, maupun PowerShell.

# Contoh Kasus

File `sysdm.cpl`—yang memanggil dialog “System Properties” (Control Panel → System → Advanced system settings)—sebenarnya terletak di folder sistem Windows, biasanya di:

- `C:\Windows\System32\sysdm.cpl`
- Pada sistem 64-bit, versi 32-bit CPL ada di `C:\Windows\SysWOW64\sysdm.cpl` juga.

---

## Cara agar aplikasi apa pun bisa dipanggil lewat Win+R

Dialog Run (`Win+R`) pada dasarnya mencari:

1. **Nama executable** di folder yang tercantum pada variabel lingkungan **PATH**.
2. **Key registry** di bawah
   `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\<nama>.exe`
3. **Protocol/URI handler** (misal `ms-settings:…`, `shell:…`), atau entry di folder Windows (mis. System32).

Berikut beberapa metode untuk “mendaftarkan” aplikasi Anda agar mudah dipanggil lewat Run:

| Metode                                                                                                                                                                                                                                                                  | Langkah                                                                                                                                                                                            |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Tambahkan ke PATH**                                                                                                                                                                                                                                                   | 1. Salin atau instal aplikasi di folder khusus (mis. `C:\Tools\MyApp`). <br>2. Edit Environment Variables → PATH → Tambahkan `C:\Tools\MyApp`. <br>3. Buka CMD/PowerShell/Run → ketik `myapp.exe`. |
| **Registry App Paths**                                                                                                                                                                                                                                                  | 1. Buka `regedit`. <br>2. Arahkan ke:                                                                                                                                                              |
| `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\MyApp.exe`                                                                                                                                                                                      |                                                                                                                                                                                                    |
| (atau `…\App Paths\MyApp` untuk tanpa `.exe`) <br>3. Buat `Default` (String) → nilai: penuh path ke `MyApp.exe`, mis. `C:\Program Files\MyApp\MyApp.exe`. <br>4. (Opsional) Buat `Path` (String) untuk folder kerja. <br>5. Sekarang Win+R → `MyApp` langsung meluncur. |                                                                                                                                                                                                    |
| **Copy ke System32**                                                                                                                                                                                                                                                    | Menyalin `MyApp.exe` ke `C:\Windows\System32` (atau `SysWOW64`) sehingga Windows otomatis menemukannya. <br>_(Kurang disarankan karena mengacaukan folder sistem.)_                                |
| **Shortcut di Windows folder**                                                                                                                                                                                                                                          | Buat shortcut `MyApp.lnk` di `%WINDIR%` atau `%WINDIR%\system32`. Run dapat menjalankan shortcut juga: ketik nama shortcut tanpa ekstensi.                                                         |

---

### Contoh: Mendaftarkan “MyTool.exe”

1. **Letakkan** `MyTool.exe` di folder `C:\Tools\MyTool\MyTool.exe`.
2. **Registry:**

   - Jalankan `regedit`.
   - Navigasi ke
     `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\MyTool.exe`
   - (Jika belum ada, klik kanan → New → Key → beri nama `MyTool.exe`.)
   - Di panel kanan, buat `(Default)` (String) dengan nilai
     `C:\Tools\MyTool\MyTool.exe`.
   - (Opsional) Buat nilai String `Path` dengan `C:\Tools\MyTool`.

3. **Coba:** Tekan Win+R, ketik `MyTool` → Enter → aplikasi Anda akan terbuka.

Dengan menambahkan aplikasi Anda ke salah satu mekanisme ini, pengguna (atau skrip) tinggal mengetik nama program di Run, CMD, atau PowerShell tanpa perlu mengetik path lengkap. Pertanyaan muncul! apakah ketika kita ingin memanggil aplikasi dari terminal baik cmd maupun pwsh juga memiliki mekanisme yang sama? Ya, prinsip dasarnya sama: Windows Terminal (Command Prompt maupun PowerShell) akan mencari executable berdasarkan:

1. **Variabel Lingkungan `PATH`**
   – Jika folder tempat aplikasi Anda berada sudah tercantum di `PATH`, maka cukup ketik nama executable-nya (mis. `MyApp.exe` atau cukup `MyApp` jika extensi sudah di‐associate).
   – Anda bisa menambah folder aplikasi ke `PATH` melalui:

   - **Control Panel → System → Advanced system settings → Environment Variables**
   - Pilih variabel **User** atau **System** → Edit → Append folder (pisahkan dengan titik koma).

2. **Registry “App Paths”**
   – Sama seperti untuk Win+R, shell (CMD/PowerShell) juga memeriksa
   `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\MyApp.exe`
   – Dengan mendaftarkan disitu, Anda tidak perlu memodifikasi `PATH`.

3. **Folder Khusus Sistem**
   – Menyalin atau membuat symlink/hardlink aplikasi ke salah satu folder yang sudah di‐scan otomatis (mis. `C:\Windows\System32`, atau folder lain di `PATH`).
   – _Catatan:_ Menaruh aplikasi kustom di `System32` tidak direkomendasikan karena bisa mengacaukan sistem atau memerlukan izin administrator.

4. **Alias dan Fungsi di PowerShell**
   – Untuk script atau modul PowerShell, Anda bisa membuat:

   - **Global Alias** (mis. `Set-Alias MyScript C:\Tools\MyScript.ps1`)
   - **PowerShell Profile** (`$PROFILE`) berisi fungsi atau `Import-Module` otomatis.
     – Dengan demikian cukup panggil `MyScript` di PS, tanpa `.ps1` atau path lengkap.

5. **Shortcut `.lnk` atau Skrip Pembungkus**
   – Buat file batch kecil (`MyApp.bat`) yang memanggil aplikasi, lalu letakkan di folder yang ada di `PATH`.
   – Contoh `C:\Tools\bin\MyApp.bat`:

   ```bat
   @echo off
   "C:\Program Files\MyApp\MyApp.exe" %*
   ```

   – Terminal akan mengeksekusi `MyApp` seperti native command.

---

### Contoh Implementasi

| Metode                 | Langkah Singkat                                                                                                               |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| **Tambah ke `PATH`**   | 1. Buat folder mis. `C:\Tools\bin` <br>2. Taruh `MyApp.exe` atau skrip wrapper di sana <br>3. Tambah `C:\Tools\bin` ke `PATH` |
| **Registry App Paths** | 1. `regedit` → buat kunci di `…\App Paths\MyApp.exe` <br>2. Set `(Default)` ke full path `C:\Program Files\MyApp\MyApp.exe`   |
| **Alias PowerShell**   | Di profile (`notepad $PROFILE`), tambahkan: <br>`Set-Alias MyApp 'C:\Tools\MyApp\MyApp.exe'`                                  |
| **Batch Wrapper**      | Buat `MyApp.bat` di folder `PATH` berisi: <br>`@"C:\Path\MyApp\MyApp.exe" %*`                                                 |

Dengan salah satu cara di atas, Anda tidak hanya bisa menjalankannya lewat Win+R, tetapi juga cukup mengetikkan **nama aplikasi** di CMD atau PowerShell—tanpa mengetikkan path lengkap.
