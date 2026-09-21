Gunakan perintah `git tag`. Untuk menambahkan tag dalam Git, biasanya digunakan untuk menandai titik tertentu dalam sejarah proyek, seperti merilis versi baru.

Berikut adalah langkah-langkah untuk menambahkan tag di Git:

1. **Tag Sederhana:**

   ```bash
   git tag nama_tag
   ```

   Perintah ini akan membuat tag dengan nama yang kamu tentukan (`nama_tag`) pada commit saat ini.

2. **Tag dengan Pesan Annotated:**
   Tag annotated menyimpan lebih banyak informasi, seperti pesan tag, nama pembuat tag, dan tanggal.

   ```bash
   git tag -a nama_tag -m "Pesan tag"
   ```

   Perintah ini akan membuat tag annotated dengan nama yang kamu tentukan (`nama_tag`) dan pesan yang kamu berikan (`"Pesan tag"`).

3. **Mengirim Tag ke Repository Remote:**
   Setelah membuat tag, kamu harus mengirimnya ke repository remote agar tag tersebut tersedia untuk orang lain.
   ```bash
   git push origin nama_tag
   ```
   Atau untuk mengirim semua tag yang ada:
   ```bash
   git push --tags
   ```

Contoh lengkap menambahkan tag annotated dan mengirimnya ke repository remote:

```bash
git tag -a v1.0 -m "Versi 1.0 dirilis"
git push origin v1.0
```
