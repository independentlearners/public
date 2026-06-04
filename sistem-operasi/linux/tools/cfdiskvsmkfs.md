### Dokumentasi: Prosedur Pembuatan dan Pemformatan Partisi untuk Instalasi Sistem Operasi Linux

**Ringkasan**  
Dokumen ini menjelaskan perbedaan fungsi antara utilitas pembuatan partisi seperti `fdisk`/`cfdisk` dengan perintah pemformatan sistem berkas `mkfs` dan `mkswap` dalam konteks instalasi sistem operasi Linux.

**1. Fungsi Utilitas Partisi (`fdisk`, `cfdisk`)**  
Utilitas `fdisk` dan `cfdisk` digunakan untuk memanipulasi tabel partisi pada perangkat penyimpanan. Fungsi utamanya meliputi:  
1.  **Pembuatan Partisi**: Menentukan batas awal dan akhir sektor untuk setiap partisi pada disk.  
2.  **Penentuan Tipe Partisi**: Menetapkan kode tipe partisi, misalnya `83` untuk *Linux filesystem*, `82` untuk *Linux swap*, atau `EF` untuk *EFI System Partition*.  

Penentuan tipe partisi hanya berfungsi sebagai penanda atau label pada tabel partisi. Proses ini tidak membuat struktur sistem berkas di dalam partisi. Partisi yang baru dibuat masih berada dalam kondisi *raw* dan tidak dapat digunakan untuk menyimpan data sebelum diformat.

**2. Fungsi Perintah Pemformatan**  
Untuk dapat digunakan oleh sistem operasi, partisi yang telah dibuat wajib diformat menggunakan perintah khusus:  
1.  **`mkfs.ext4`**: Perintah ini membuat struktur sistem berkas ext4 pada partisi target. Proses ini menulis *superblock*, tabel *inode*, dan *journal* sehingga kernel dapat melakukan operasi baca/tulis berkas. Contoh: `sudo mkfs.ext4 /dev/nvme0n1p8`  
2.  **`mkswap`**: Perintah ini menginisialisasi partisi sebagai ruang *swap* dengan menuliskan *header* dan *signature* khusus. Setelah itu, partisi swap harus diaktifkan menggunakan `swapon`. Contoh: `sudo mkswap /dev/nvme0n1p9 && sudo swapon /dev/nvme0n1p9`

**3. Perbedaan Konseptual: Tipe Partisi dan Sistem Berkas**

| Aspek | Tipe Partisi di `cfdisk` | Sistem Berkas oleh `mkfs` |
| --- | --- | --- |
| **Fungsi** | Memberikan label pada tabel partisi | Membuat struktur data fisik pada partisi |
| **Hasil** | Kode heksadesimal pada *partition table* | *Superblock*, *inode*, *journal* ext4 |
| **Status Partisi** | Tetap *raw*, tidak dapat di-*mount* | Siap di-*mount* dan menyimpan data |
| **Verifikasi** | `lsblk -f` kolom FSTYPE kosong | `lsblk -f` kolom FSTYPE terisi `ext4` |

**4. Prosedur Standar Instalasi Manual**  
Urutan yang benar untuk instalasi Linux secara manual adalah sebagai berikut:  
1.  Membuat partisi menggunakan `cfdisk /dev/nvme0n1`.  
2.  Memformat partisi root: `sudo mkfs.ext4 /dev/nvme0n1p8`.  
3.  Menginisialisasi dan mengaktifkan swap: `sudo mkswap /dev/nvme0n1p9 && sudo swapon /dev/nvme0n1p9`.  
4.  Melakukan *mount* partisi root sebelum proses instalasi: `sudo mount /dev/nvme0n1p8 /mnt`.

**5. Pengecualian**  
Installer grafis pada distribusi seperti Ubuntu, Fedora, atau Manjaro umumnya akan menjalankan proses pemformatan secara otomatis setelah pengguna memilih partisi. Dengan demikian, perintah `mkfs` dan `mkswap` tidak perlu dijalankan secara manual.

**Kesimpulan**  
Penentuan tipe partisi melalui `cfdisk` tidak menggantikan kebutuhan untuk melakukan pemformatan. Tipe partisi hanya merupakan metadata, sedangkan `mkfs` dan `mkswap` adalah proses yang membuat partisi tersebut benar-benar dapat digunakan oleh sistem operasi.
