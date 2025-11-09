# Perintah Chocolate

Beberapa perintah yang berguna dalam Chocolatey:

1. **install**

   - **Deskripsi**: Menginstal paket.
   - **Contoh Penggunaan**: `choco install git`
   - **Dokumentasi Resmi**: [Install Command](https://docs.chocolatey.org/en-us/choco/commands/install)

2. **upgrade**

   - **Deskripsi**: Memperbarui paket yang sudah diinstal.
   - **Contoh Penggunaan**: `choco upgrade git`
   - **Dokumentasi Resmi**: [Upgrade Command](https://docs.chocolatey.org/en-us/choco/commands/upgrade)

3. **uninstall**

   - **Deskripsi**: Menghapus paket yang sudah diinstal.
   - **Contoh Penggunaan**: `choco uninstall git`
   - **Dokumentasi Resmi**: [Uninstall Command](https://docs.chocolatey.org/en-us/choco/commands/uninstall)

4. **list**

   - **Deskripsi**: Menampilkan daftar paket yang tersedia atau yang sudah diinstal.
   - **Contoh Penggunaan**: `choco list`
   - **Dokumentasi Resmi**: [List Command](https://docs.chocolatey.org/en-us/choco/commands/list)

5. **search**

   - **Deskripsi**: Mencari paket yang tersedia.
   - **Contoh Penggunaan**: `choco search git`
   - **Dokumentasi Resmi**: [Search Command](https://docs.chocolatey.org/en-us/choco/commands/search)

6. **config**

   - **Deskripsi**: Mengelola konfigurasi Chocolatey.
   - **Contoh Penggunaan**: `choco config set cacheLocation C:\chocoCache`
   - **Dokumentasi Resmi**: [Config Command](https://docs.chocolatey.org/en-us/choco/commands/config)

7. **source**

   - **Deskripsi**: Mengelola sumber paket.
   - **Contoh Penggunaan**: `choco source add -n=mySource -s="https://myrepo.com"`
   - **Dokumentasi Resmi**: [Source Command](https://docs.chocolatey.org/en-us/choco/commands/source)

8. **pack**

   - **Deskripsi**: Membuat paket Chocolatey dari file nuspec.
   - **Contoh Penggunaan**: `choco pack mypackage.nuspec`
   - **Dokumentasi Resmi**: [Pack Command](https://docs.chocolatey.org/en-us/choco/commands/pack)

9. **push**

   - **Deskripsi**: Mengunggah paket ke repository Chocolatey.
   - **Contoh Penggunaan**: `choco push mypackage.nupkg -s="https://myrepo.com"`
   - **Dokumentasi Resmi**: [Push Command](https://docs.chocolatey.org/en-us/choco/commands/push)

10. **new**

    - **Deskripsi**: Membuat template paket baru.
    - **Contoh Penggunaan**: `choco new mypackage`
    - **Dokumentasi Resmi**: [New Command](https://docs.chocolatey.org/en-us/choco/commands/new)

11. **outdated**

    - **Deskripsi**: Menampilkan daftar paket yang sudah usang.
    - **Contoh Penggunaan**: `choco outdated`
    - **Dokumentasi Resmi**: [Outdated Command](https://docs.chocolatey.org/en-us/choco/commands/outdated)

12. **pin**

    - **Deskripsi**: Menandai paket agar tidak diperbarui.
    - **Contoh Penggunaan**: `choco pin add -n=git`
    - **Dokumentasi Resmi**: [Pin Command](https://docs.chocolatey.org/en-us/choco/commands/pin)

13. **feature**

    - **Deskripsi**: Mengelola fitur Chocolatey.
    - **Contoh Penggunaan**: `choco feature enable -n=allowGlobalConfirmation`
    - **Dokumentasi Resmi**: [Feature Command](https://docs.chocolatey.org/en-us/choco/commands/feature)

14. **apikey**

    - **Deskripsi**: Mengelola API key untuk repository Chocolatey.
    - **Contoh Penggunaan**: `choco apikey add -k="your-api-key" -s="https://myrepo.com"`
    - **Dokumentasi Resmi**: [API Key Command](https://docs.chocolatey.org/en-us/choco/commands/apikey)

15. **template**

    - **Deskripsi**: Mengelola template paket.
    - **Contoh Penggunaan**: `choco template pack mytemplate`
    - **Dokumentasi Resmi**: [Template Command](https://docs.chocolatey.org/en-us/choco/commands/template)

16. **export**

    - **Deskripsi**: Mengekspor daftar paket yang diinstal ke file.
    - **Contoh Penggunaan**: `choco export -o="packages.config"`
    - **Dokumentasi Resmi**: [Export Command](https://docs.chocolatey.org/en-us/choco/commands/export)

17. **import**
    - **Deskripsi**: Mengimpor daftar paket dari file.
    - **Contoh Penggunaan**: `choco import -i="packages.config"`
    - **Dokumentasi Resmi**: [Import Command](https://docs.chocolatey.org/en-us/choco/commands/import)

Untuk daftar lengkap perintah yang tersedia, Anda bisa mengunjungi [dokumentasi resmi Chocolatey](https://docs.chocolatey.org/en-us/).
