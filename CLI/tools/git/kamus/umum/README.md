# Kamus Kata Kunci Git

Berikut adalah daftar lengkap kata kunci Git beserta penjelasan singkatnya:

1. `add`: Menambahkan file ke staging area.
2. `branch`: Membuat, menampilkan, atau menghapus cabang.
3. `checkout`: Beralih antara cabang atau commit.
4. `clone`: Menyalin repositori dari lokasi remote.
5. `commit`: Menyimpan perubahan ke repositori.
6. `config`: Mengatur opsi konfigurasi Git.
7. `diff`: Menampilkan perbedaan antara commit, cabang, dll.
8. `fetch`: Mengunduh objek dan referensi dari repositori remote.
9. `init`: Membuat repositori Git baru.
10. `log`: Menampilkan riwayat commit.
11. `merge`: Menggabungkan dua atau lebih riwayat pengembangan.
12. `pull`: Mengambil dan menggabungkan perubahan dari repositori remote.
13. `push`: Memperbarui repositori remote dengan commit lokal.
14. `rebase`: Menerapkan ulang commit di atas basis yang berbeda.
15. `remote`: Mengelola repositori yang dilacak.
16. `reset`: Mengatur HEAD ke keadaan tertentu.
17. `revert`: Membuat commit baru yang membatalkan perubahan dari commit tertentu.
18. `status`: Menampilkan status working tree.
19. `tag`: Membuat, menampilkan, menghapus, atau memverifikasi tag yang ditandatangani dengan GPG.

## Kata Kunci Tambahan

20. `bisect`: Menggunakan pencarian biner untuk menemukan commit yang memperkenalkan bug.
21. `blame`: Menampilkan informasi tentang siapa yang terakhir memodifikasi setiap baris file.
22. `cherry-pick`: Menerapkan perubahan yang diperkenalkan oleh beberapa commit yang ada.
23. `clean`: Menghapus file yang tidak terlacak dari working tree.
24. `describe`: Memberikan nama yang mudah dibaca manusia untuk objek.
25. `fsck`: Memeriksa integritas database objek.
26. `gc`: Membersihkan file yang tidak perlu dan mengoptimalkan repositori lokal.
27. `grep`: Mencetak baris yang cocok dengan pola.
28. `mv`: Memindahkan atau mengganti nama file, direktori, atau symlink.
29. `reflog`: Mengelola informasi reflog.
30. `rm`: Menghapus file dari working tree dan dari indeks.
31. `show`: Menampilkan berbagai jenis objek.
32. `stash`: Menyimpan perubahan dalam direktori kerja yang kotor.
33. `submodule`: Menginisialisasi, memperbarui, atau memeriksa submodul.
34. `worktree`: Mengelola beberapa working trees yang terhubung ke repositori yang sama.

Setiap kata kunci ini memiliki berbagai opsi dan penggunaan yang dapat Anda pelajari lebih lanjut dengan menjalankan `git [kata_kunci] --help` di terminal Anda.

## Cara Penggunaan

Sebelum melakukan perubahan di suatu perangkat, **sebaiknya** perangkat tersebut menjalankan `git pull` terlebih dahulu untuk memastikan mendapatkan versi terbaru dari repository. Ini menghindari potensi konflik atau kehilangan perubahan yang telah dilakukan oleh orang lain atau dari perangkat lain.

### **Mengapa `git pull` Diperlukan Sebelum Perubahan?**
- **Menghindari Konflik:** Jika ada perubahan terbaru yang belum diambil, bisa saja terjadi _merge conflict_ saat kamu mencoba melakukan `git push`.
- **Memastikan Sinkronisasi:** Perangkat kamu akan selalu bekerja dengan versi terbaru dari repository.
- **Mengurangi Risiko Overwriting:** Jika kamu melakukan perubahan tanpa `git pull` terlebih dahulu, ada risiko perubahan lokal tertimpa oleh versi baru dari repository.

Jadi alur kerja standar tanpa otomatisasi biasanya seperti ini:

1. **Cek Perubahan Terbaru:**  
   ```bash
   git pull origin main
   ```
2. **Lakukan Perubahan di File**
3. **Stage & Commit Perubahan:**  
   ```bash
   git add .
   git commit -m "Pesan perubahan"
   ```
4. **Push ke Repository:**  
   ```bash
   git push origin main
   ```

Cara ini memastikan bahwa semua perangkat yang berkontribusi ke repository selalu bekerja dengan versi yang paling up-to-date.
