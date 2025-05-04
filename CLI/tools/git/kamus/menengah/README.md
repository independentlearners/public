# Kamus Kata Kunci Git Komprehensif

Berikut adalah daftar lengkap kata kunci Git beserta penjelasan detail, cara penggunaan, dan informasi tambahan:

## Perintah Dasar

1. `git init`

   - Fungsi: Menginisialisasi repositori Git baru.
   - Penggunaan: `git init [nama-direktori]`
   - Penjelasan: Jika nama direktori tidak ditentukan, akan menginisialisasi repositori di direktori saat ini.

2. `git clone`

   - Fungsi: Menyalin repositori dari lokasi remote.
   - Penggunaan: `git clone <url-repositori> [nama-direktori]`
   - Penjelasan: Jika nama direktori tidak ditentukan, akan menggunakan nama repositori sebagai nama direktori.

3. `git add`

   - Fungsi: Menambahkan file ke staging area.
   - Penggunaan:
     - `git add <file>`: Menambahkan file tertentu
     - `git add .`: Menambahkan semua file yang dimodifikasi
   - Penjelasan: Dapat digunakan dengan `git commit` untuk menyimpan perubahan.

4. `git commit`

   - Fungsi: Menyimpan perubahan ke repositori.
   - Penggunaan:
     - `git commit -m "pesan commit"`
     - `git commit -am "pesan commit"`: Menambahkan semua perubahan dan melakukan commit sekaligus.
   - Penjelasan: `-a` menambahkan semua perubahan pada file yang sudah di-track.

5. `git status`

   - Fungsi: Menampilkan status working tree.
   - Penggunaan: `git status`
   - Penjelasan: Menunjukkan file yang dimodifikasi, ditambahkan ke staging area, atau belum di-track.

6. `git log`
   - Fungsi: Menampilkan riwayat commit.
   - Penggunaan:
     - `git log`
     - `git log --oneline`: Menampilkan dalam format satu baris
     - `git log --graph`: Menampilkan grafik cabang
   - Penjelasan: Dapat dikombinasikan dengan berbagai opsi untuk menyesuaikan output.

## Branching dan Merging

7. `git branch`

   - Fungsi: Membuat, menampilkan, atau menghapus cabang.
   - Penggunaan:
     - `git branch`: Menampilkan semua cabang
     - `git branch <nama-cabang>`: Membuat cabang baru
     - `git branch -d <nama-cabang>`: Menghapus cabang
   - Penjelasan: Dapat digunakan dengan `git checkout` untuk beralih antar cabang.

8. `git checkout`

   - Fungsi: Beralih antara cabang atau commit.
   - Penggunaan:
     - `git checkout <nama-cabang>`
     - `git checkout -b <nama-cabang-baru>`: Membuat dan beralih ke cabang baru
   - Penjelasan: Juga dapat digunakan untuk mengembalikan file ke versi tertentu.

9. `git merge`

   - Fungsi: Menggabungkan dua atau lebih riwayat pengembangan.
   - Penggunaan: `git merge <nama-cabang>`
   - Penjelasan: Menggabungkan cabang yang ditentukan ke cabang saat ini.

10. `git rebase`
    - Fungsi: Menerapkan ulang commit di atas basis yang berbeda.
    - Penggunaan: `git rebase <nama-cabang>`
    - Penjelasan: Alternatif untuk `merge`, menghasilkan riwayat yang lebih linear.

## Remote Repositories

11. `git remote`

    - Fungsi: Mengelola repositori yang dilacak.
    - Penggunaan:
      - `git remote add <nama> <url>`
      - `git remote -v`: Menampilkan daftar remote
    - Penjelasan: Biasanya digunakan untuk menambahkan remote repository baru.

12. `git fetch`

    - Fungsi: Mengunduh objek dan referensi dari repositori remote.
    - Penggunaan: `git fetch [remote-name]`
    - Penjelasan: Tidak otomatis menggabungkan perubahan ke working directory.

13. `git pull`

    - Fungsi: Mengambil dan menggabungkan perubahan dari repositori remote.
    - Penggunaan: `git pull [remote-name] [branch-name]`
    - Penjelasan: Kombinasi dari `git fetch` dan `git merge`.

14. `git push`
    - Fungsi: Memperbarui repositori remote dengan commit lokal.
    - Penggunaan: `git push [remote-name] [branch-name]`
    - Penjelasan: Mengirim perubahan lokal ke repositori remote.

## Perintah Lanjutan

15. `git stash`

    - Fungsi: Menyimpan perubahan sementara tanpa commit.
    - Penggunaan:
      - `git stash save "pesan"`
      - `git stash list`: Menampilkan daftar stash
      - `git stash apply`: Menerapkan stash terakhir
    - Penjelasan: Berguna ketika perlu beralih tugas tanpa melakukan commit.

16. `git reset`

    - Fungsi: Mengatur HEAD ke keadaan tertentu.
    - Penggunaan:
      - `git reset --soft HEAD~1`: Membatalkan commit terakhir, menjaga perubahan
      - `git reset --hard HEAD~1`: Membatalkan commit terakhir, menghapus perubahan
    - Penjelasan: Hati-hati dengan `--hard` karena dapat menghapus perubahan permanen.

17. `git revert`

    - Fungsi: Membuat commit baru yang membatalkan perubahan dari commit tertentu.
    - Penggunaan: `git revert <commit-hash>`
    - Penjelasan: Lebih aman daripada `reset` untuk membatalkan perubahan yang sudah di-push.

18. `git cherry-pick`

    - Fungsi: Menerapkan perubahan dari commit tertentu.
    - Penggunaan: `git cherry-pick <commit-hash>`
    - Penjelasan: Berguna untuk memilih commit spesifik dari cabang lain.

19. `git bisect`

    - Fungsi: Menggunakan pencarian biner untuk menemukan commit yang memperkenalkan bug.
    - Penggunaan:
      - `git bisect start`
      - `git bisect bad`: Menandai commit saat ini sebagai bermasalah
      - `git bisect good <commit>`: Menandai commit terakhir yang diketahui baik
    - Penjelasan: Membantu menemukan commit yang menyebabkan masalah dengan cepat.

20. `git reflog`
    - Fungsi: Mengelola informasi reflog.
    - Penggunaan: `git reflog`
    - Penjelasan: Menampilkan log referensi lokal, berguna untuk memulihkan commit yang hilang.

## Perintah Jarang Digunakan

21. `git submodule`

    - Fungsi: Mengelola submodul dalam repositori.
    - Penggunaan:
      - `git submodule add <url> <path>`
      - `git submodule update --init --recursive`
    - Penjelasan: Berguna untuk proyek yang memiliki dependensi pada repositori lain.

22. `git worktree`

    - Fungsi: Mengelola beberapa working trees yang terhubung ke repositori yang sama.
    - Penggunaan:
      - `git worktree add <path> <branch>`
      - `git worktree list`
    - Penjelasan: Memungkinkan bekerja pada beberapa cabang secara bersamaan.

23. `git filter-branch`

    - Fungsi: Menulis ulang cabang menggunakan skrip penyaringan tertentu.
    - Penggunaan: `git filter-branch --tree-filter 'rm -f passwords.txt' HEAD`
    - Penjelasan: Berguna untuk menghapus file sensitif dari riwayat repositori.

24. `git gc`

    - Fungsi: Membersihkan file yang tidak perlu dan mengoptimalkan repositori lokal.
    - Penggunaan: `git gc`
    - Penjelasan: Biasanya dijalankan otomatis, tapi bisa dijalankan manual untuk optimisasi.

25. `git fsck`
    - Fungsi: Memeriksa integritas database objek.
    - Penggunaan: `git fsck`
    - Penjelasan: Berguna untuk menemukan objek yang rusak dalam repositori.

Setiap perintah Git ini memiliki berbagai opsi tambahan yang dapat Anda pelajari lebih lanjut dengan menjalankan `git [perintah] --help` di terminal Anda. Perintah-perintah ini dapat dikombinasikan dan digunakan bersama untuk manajemen repositori yang lebih efektif.
