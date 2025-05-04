## Contoh kasus

```pwsh
winget --version winget : The term 'winget' is not recognized as the name of a cmdlet, function, script file, or operable program. Check the spelling of the name, or if a path was included, verify that the path is correct and try again. At line:1 char:1 + winget --version + ~~~~~~ + CategoryInfo : ObjectNotFound: (winget:String) [], CommandNotFoundException + FullyQualifiedErrorId : CommandNotFoundException
```

Terkadang masalah seperti ini berkaitan dengan Windows Package Manager (winget) yang tidak dapat ditemukan oleh sistem. Padahal sebelumnya tidak ada kendala, situasi seperti ini bisa muncul karena beberapa hal, seperti update sistem, perubahan konfigurasi PATH, atau masalah pada instalasi App Installer. Berikut ini adalah beberapa langkah yang bisa kamu coba untuk mengatasinya:

---

### 1. Pastikan App Installer Terpasang dan Terupdate

Winget merupakan bagian dari App Installer di Windows. Jika terjadi update Windows atau perubahan lain, ada kemungkinan App Installer tidak terupdate atau terpasang dengan benar.

- **Buka Microsoft Store:**  
  Cari aplikasi **App Installer** dan pastikan kamu menginstal versi terbaru.  
- **Instal Ulang Jika Perlu:**  
  Jika App Installer sudah terpasang tetapi masih ada masalah, cobalah untuk menguninstall dan menginstal kembali dari Microsoft Store.

---

### 2. Periksa Environment Variable PATH

Winget biasanya berada di dalam folder:
```
C:\Users\<NamaPengguna>\AppData\Local\Microsoft\WindowsApps
```
Pastikan folder tersebut sudah tercantum di dalam variabel PATH.

- **Di PowerShell, jalankan:**
  ```powershell
  $env:Path -split ';'
  ```
  Periksa apakah folder WindowsApps muncul dalam daftar tersebut.

- **Jika Folder Tidak Ada:**  
  Kamu bisa menambahkannya secara manual melalui *System Properties* → *Advanced* → *Environment Variables*.

**Contoh Kasus**:

```pwsh
PS C:\Users\username> $env:Path -split ';'
C:\Program Files\Eclipse Adoptium\jdk-17.0.14.7-hotspot\bin
C:\Program Files\Eclipse Adoptium\jdk-21.0.6.7-hotspot\bin
C:\WINDOWS\system32 C:\WINDOWS
C:\WINDOWS\System32\Wbem
C:\WINDOWS\System32\WindowsPowerShell\v1.0\
C:\WINDOWS\System32\OpenSSH\
C:\ProgramData\chocolatey\bin C:\Program Files\Git\cmd
C:\Program Files\Java\jdk1.8.0_211\bin
C:\Android\android-sdk\tools
C:\Android\android-sdk\platform-tools
C:\Android\android-sdk\tools\bin
C:\Android\android-sdk\cmdline-tools\latest\bin
C:\src\flutter\bin C:\Program Files\Cloudflare\Cloudflare WARP\
C:\Program Files\Eclipse Adoptium\jdk-17.0.14.7-hotspot\bin
C:\Program Files\Eclipse Adoptium\jdk-21.0.6.7-hotspot\bin
C:\WINDOWS\system32
C:\WINDOWS
C:\WINDOWS\System32\Wbem
C:\WINDOWS\System32\WindowsPowerShell\v1.0\
C:\WINDOWS\System32\OpenSSH\
C:\ProgramData\chocolatey\bin
C:\Program Files\Git\cmd
C:\Program Files\Java\jdk1.8.0_211\bin
C:\Android\android-sdk\tools
C:\Android\android-sdk\platform-tools
C:\Android\android-sdk\tools\bin
C:\Android\android-sdk\cmdline-tools\latest\bin
C:\src\flutter\bin
C:\Program Files\Cloudflare\Cloudflare WARP\ C:\Users\username\AppData\Local\Programs\Microsoft VS Code\bin
```
Dalam contoh di atas direktori yang seharusnya berisi winget tidak ditemukan dalam sistem variabel lingkungan. Jik seperti ini maka soluainya adalah **Tambahkan Folder ke PATH**, tapi sebelum menambahkannya coba perilksa apakah folder `C:\Users\username\AppData\Local\Microsoft\WindowsApps` ada, jika ternyata ada tetapi belum tercantum di variabel PATH, kamu dapat menambahkannya secara manual:

1. **Buka Settings Sistem:**  
   - Tekan `Win + X` kemudian pilih **System** → **About** → **Advanced system settings**. atau dengan menjalankan perintah `sysdm.cpl` di **Win Run** atau di dalam terminal itu sendiri
2. **Klik Environment Variables:**  
   Di bagian bawah jendela *System Properties*.
3. **Cari Variabel PATH:**  
   Pilih *Path* di daftar *User variables* lalu klik **Edit**.
4. **Tambah Baris Baru:**  
   Masukkan `C:\Users\username\AppData\Local\Microsoft\WindowsApps`.
5. **Simpan Perubahan dan Restart Terminal:**  
   Restart PowerShell/Command Prompt untuk memastikan perubahan diterapkan.


---

### 3. Periksa Versi Windows

Winget tersedia untuk Windows 10 (versi 1809 ke atas) dan Windows 11. Pastikan kamu menggunakan versi Windows yang sesuai. Jika sistem operasi kamu belum terupdate, pertimbangkan untuk melakukan pembaruan.

- **Cara mengecek versi Windows:**  
  Tekan `Win + R`, ketik `winver`, dan tekan Enter. Pastikan versi OS kamu mendukung winget.

---

### 4. Restart Komputer

Kadang-kadang, perubahan instalasi atau update pada environment variable baru akan efektif setelah komputer di-restart. Cobalah restart terlebih dahulu sebelum menjalankan `winget --version` lagi.

---

### 5. Cek Hak Akses dan Kebijakan Sistem

Pastikan akun pengguna yang kamu gunakan (meskipun menggunakan email Hotmail) memiliki hak akses yang cukup untuk menjalankan program-program di direktori tersebut. Pada beberapa kasus, kebijakan keamanan atau pengaturan grup (Group Policy) dapat mempengaruhi akses ke folder tertentu.

---

### Diagram Alur Pencegahan Masalah

```plaintext
Mulai
  │
  ├─► Periksa versi Windows (>=1809)?
  │         │
  │         ├─► Tidak → Update Windows
  │         │
  │         └─► Ya → Lanjutkan
  │
  ├─► Periksa keberadaan App Installer di Microsoft Store
  │         │
  │         ├─► Tidak terpasang/terupdate → Instal/Ubah App Installer
  │         │
  │         └─► Terupdate → Lanjutkan
  │
  ├─► Periksa PATH (folder WindowsApps)
  │         │
  │         ├─► Tidak ada → Tambahkan folder ke PATH
  │         │
  │         └─► Ada → Lanjutkan
  │
  ├─► Restart Komputer
  │
  └─► Jalankan kembali “winget --version”
```

---

### Informasi Tambahan

- **Akun Microsoft:**  
  Penggunaan email Hotmail sebagai akun Windows seharusnya tidak mempengaruhi ketersediaan winget. Masalah yang kamu hadapi lebih berkaitan dengan instalasi atau konfigurasi sistem.

- **Update Windows:**  
  Kadang-kadang update Windows atau pembaruan pada Microsoft Store dapat menyebabkan komponen tertentu tidak terdeteksi. Memastikan semua update sudah terpasang dengan benar dapat menghindari masalah ini.

- **Jalankan sebagai Administrator:**  
  Jika masih mendapat error, cobalah buka Command Prompt atau PowerShell sebagai Administrator dan jalankan kembali perintah tersebut.

---

Coba langkah-langkah di atas secara berurutan, dan jika masih mengalami masalah, mungkin ada baiknya juga mencari informasi lebih lanjut di forum Microsoft atau komunitas pengguna Windows.
> Copilot