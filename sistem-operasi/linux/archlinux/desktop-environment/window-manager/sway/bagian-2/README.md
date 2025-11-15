### `status_command while date +'%Y-%m-%d %X'; do sleep 1; done`

* `status_command` — pengaturan untuk `bar`/`swaybar` yang menetapkan program atau perintah yang dijalankan untuk menghasilkan status JSON/teks.
* `while date +'%Y-%m-%d %X'; do sleep 1; done` — sebuah loop shell sederhana:

  * `while ...; do ...; done` — bentuk loop shell `while` yang terus berjalan.
  * `date +'%Y-%m-%d %X'` — memanggil utilitas `date` untuk mencetak tanggal dan waktu dengan format `YYYY-MM-DD HH:MM:SS`.
  * `sleep 1` — jeda 1 detik antara iterasi.
* Ketika loop ini mencetak baris baru, swaybar akan mengambil/memperbarui tampilannya. Dalam konfigurasi produksi biasanya `status_command` meng-output JSON khusus (i3bar protocol) atau menggunakan utilitas seperti `waybar`, `swaybar` dengan `i3status`, `polybar` (polybar but not native wayland) atau script custom.

**Note:** contoh di file adalah contoh minimal; seringnya orang memakai `swaystatus`, `i3status`, `waybar` atau script berbasis `jq`.

---

## `colors { statusline #ffffff background #323232 inactive_workspace #32323200 #32323200 #5c5c5c }`

* `colors { ... }` — blok konfigurasi untuk warna pada `bar` (swaybar).
* `statusline #ffffff` — warna teks utama (putih).
* `background #323232` — warna latar (abu gelap).
* `inactive_workspace #32323200 #32323200 #5c5c5c` — beberapa argumen yang mewakili warna untuk workspace yang tidak aktif (format tergantung versi sway bar).

  * `#32323200` kemungkinan termasuk nilai alpha/hex (transparansi) tergantung implementasi.

**Catatan:** warna biasanya dalam format hex `#RRGGBB` atau `#RRGGBBAA` (jika alpha). Jika Anda memodifikasi, pastikan format sesuai versi sway Anda.


<!-----
<details>
  <summary>📃 Daftar Isi</summary>

</details>

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-1/README.md
[selanjutnya]: ../bagian-3/README.md

-->
[0]: ../README.md
[1]: ../
[2]: ../
[3]: ../
[4]: ../
[5]: ../
[6]: ../
[7]: ../
[8]: ../
[9]: ../
[10]: ../
[11]: ../
[12]: ../
[13]: ../
[14]: ../
[15]: ../
[16]: ../
[17]: ../
[18]: ../
