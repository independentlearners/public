<!-- Terjemahkan tutorial ini kedalam bahasa inggris dan berikann penjelasan opsional atau penjelasan yang direkomendasikan, tetapi sertakan juga teks bahasa indonesianya apabila kamu memberikan penjasan tambahan, oh iya berikan penjelasan tambahan tentang mendownload video dari platform yang lain seperti video story fakebook, TikTok atau media ssosial lainnya, dimana juga disertakan pendownloadan untuk video saja atau yang dikonversi ke mp3 sekaligus -->

# Tutorial yt-dlp

Satu hal yang pasti selalu kita ingat, bahwa untuk menjalankan perintah dalam terminal apapun, tidak diperbolehkan mengalami kesalahan dalam penulisan perintah apapun

Pertama, anda harus mendownload tools terminal terlebih dahulu, yaitu tools yt-dlp, sebab tools inilah yang akan mendownload semua yang diperlukan. Gunakan `winget` atau `choco` jika di windows dan seharusnya kita tidak perlu menjelaskan tentang pengunduhan ini disini, mari kita fokus pada tujuan utama, namun sebelumnya perlu diingat bahwa ini adalah tutorial `ytdlp` untuk:

## Pengunduhan audio

Selanjutnya, anda bisa memilih beberapa cara berikut, untuk yang pertama saya akan mendownload secara manual dimana kita menentukan sendiri terhadap direktori yang kita inginkan. oh iya, tautan disini bersifat bebas, anda bisa menggunakan alamat tautan playlist untuk mendoownload secara global atau alamat tautan lagu tertentu. saya akan menggunakan keduanya

```ps
yt-dlp -x --audio-format mp3 --audio-quality 0 "https://music.youtube.com/watch?v=aqgam74tLA8&si=eYtA4L8hj0TVDPDf"; exit
```

---

berikut ini saya akan mendownload tanpa harus disibukan dengan masuk ke berbagai tempat tetapi lebih tepatnya bahwa tempat-tempat itu sudah ada. jadi kita hanya tinggal membuka Win+R, lalu kita tempelkan path direkotori jika belum, dan jika sudah, maka selanjutya kita menempelkan tautan yang akan kita unduh.

```ps
yt-dlp -x --audio-format mp3 --audio-quality 0 -o "D:\Musik Baru\Indonesia\Noah\%(title)s.%(ext)s" "https://music.youtube.com/playlist?list=PLyRnOgSp4LD_ntrkg2HPn1v6Fkji980cO&si=F25KkYLx01Zq60mk"; exit
```

---

ada dua baris yang diapit titik dua koma atas, dimana keduanya di batasi oleh spasi

baris pertama kita mengarahkan file unduhan pada direktor yang kita inginkan. baru berikutnya menunjukan tautan untuk fie yang akan kita unduh, dalam contoh ini saya mengubah baris pertama yang diapit dua titik koma atas, ini adalah direktori yang kita tuju
`-o "D:\Musik\Asyik\%(title)s.%(ext)s"`

---

ubah baris kedua yang diapit kedua titik koma atas dengan tauatan unduhan kita
`"https://music.youtube.com/playlist?list=PLyRnOgSp4LD_ntrkg2HPn1v6Fkji980cO&si=F25KkYLx01Zq60mk"`

---

jika anda ingin tetap berada di dalam terminal, hapuslah perintah seperti yang saya contohkan berikut
`; exit`

---

jika anda ingin megetahui lebih banyak, gunakan perintah panduan untuk menemukan berbagai fitur melalui perintah ini.

Oke selesai, saya berharap kalian menuliskan komentar dibawah! saya menunggu tanggapan kalian semua apakah tutorial ini berfungsi atau tidak. karena seharusnya ini berfungsi untuk semua sistem operasi

## Pengunduhan khusus video

```ps
yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mkv -o "%(playlist_index)s - %(title)s.%(ext)s" "URL VIDEO ATAU PLAYLIST YOUTUBE" ;exit
```
