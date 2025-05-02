# Path gagal terdaftar ke lingkungan variasi sistem

**Tambahkan Git ke PATH environment variable**

Untuk memudahkan pengerjaan kita akan sering menggunakan terminal dan keyboard serta tools-tools yang lain sebagai jalan dan alternatifnya, jadi cari lokasi instalasi git, secara default itu ada di `C:\Program Files\Git\bin`, jika kalian tidak mengubahnya langsung jalankan perintah berikut untuk secara otomatis menambahkan path pada variable tanpa melalui cara-cara manual

**Jalankan di terminal**

```PS
setx PATH "%PATH%;C:\Program Files\Git\bin" # ubah direktori jika lokasi instalasi berbeda
```

Cara lain untuk mengatur `path` pada **Environment Variable** adalah melalui **Windows Run** / `Win + R` lalu masukan kata `sysdm.cpl` dan **Enter**. Kita juga bisa mengetikan perintah ini `sysdm.cpl` dalam terminal untuk menghasilkan fungsi yang sama,

Melalui **Windows Run** kita juga dapat membukan `cmd` atau `powershell`, jika tertarik untuk mempelajarinya, klik [**disini**](https://winpoin.com/daftar-lengkap-perintah-windows-run/ "winpoin.com")

Jika kita ingin menambahkan path pada **Environment Variable** secara manual masuk pada Control Panel > System and Security > System > Advanced system settings > Environment Variables. Cari variabel PATH dan tambahkan folder Git ke path, misalnya direktori berikut `C:\Program Files\Git\bin`. Selanjutnya jalankan perintah terminal untuk mengkonfirmasi perubahan
