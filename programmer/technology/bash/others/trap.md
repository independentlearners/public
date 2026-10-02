# trap

Perintah `trap` di Bash digunakan untuk **menangkap sinyal atau kejadian tertentu**, lalu menjalankan perintah yang kita tentukan saat sinyal/kejadian itu terjadi.

### Kegunaan utama `trap`

1. **Membersihkan resource saat script berhenti**
   Misalnya menghapus file sementara, menutup koneksi, atau mengembalikan setting.

2. **Menangani interupsi dari user**
   Contoh: saat user menekan `Ctrl+C` (`SIGINT`), script bisa menampilkan pesan atau keluar dengan rapi.

3. **Menangani error**
   Dengan `ERR`, script bisa menjalankan aksi tertentu jika ada perintah yang gagal.

4. **Mengabaikan sinyal tertentu**
   Contoh: `trap '' TERM` membuat script mengabaikan sinyal `TERM`.

5. **Debugging**
   Dengan `DEBUG`, perintah bisa dijalankan sebelum setiap perintah dieksekusi.

6. **Menjalankan aksi saat shell keluar**
   Dengan `EXIT`, trap dijalankan saat shell/script berakhir, baik normal maupun karena error.

### Sintaks dasar

```bash
trap 'perintah' SIGNAL
```

Contoh:

```bash
trap 'echo "Script selesai"; rm -f /tmp/data.tmp' EXIT
```

Artinya: saat script keluar, tampilkan pesan dan hapus file sementara.

### Contoh penggunaan

**1. Cleanup file sementara**

```bash
#!/bin/bash

tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"; echo "File sementara dihapus"' EXIT

echo "Data penting" > "$tmpfile"
# ... proses lain ...
```

**2. Menangani Ctrl+C**

```bash
trap 'echo "Dibatalkan oleh user"; exit 130' INT

while true; do
  echo "Berjalan..."
  sleep 1
done
```

**3. Mengabaikan sinyal TERM**

```bash
trap '' TERM
```

**4. Menjalankan aksi saat error**

```bash
trap 'echo "Terjadi error di baris $LINENO"' ERR
```

**5. Melihat trap yang aktif**

```bash
trap -p
```

**6. Menghapus/reset trap**

```bash
trap - INT
```

### Sinyal/kejadian yang umum dipakai

| Nama | Keterangan |
|---|---|
| `EXIT` | Saat shell/script keluar |
| `ERR` | Saat perintah gagal |
| `DEBUG` | Sebelum setiap perintah dieksekusi |
| `RETURN` | Saat fungsi atau `source` selesai |
| `INT` | Interupsi, biasanya `Ctrl+C` |
| `TERM` | Permintaan terminasi |
| `HUP` | Hangup, sering saat terminal ditutup |
| `QUIT` | Quit, biasanya `Ctrl+\` |

### Catatan penting

- `SIGKILL` dan `SIGSTOP` **tidak bisa** ditangkap oleh `trap`.
- Trap dipasang di shell saat itu; child process umumnya tidak mewarisi trap, kecuali sinyal yang diabaikan.
- Untuk cleanup, `trap ... EXIT` biasanya paling aman karena selalu dijalankan saat script berakhir.
- Trap harus dipasang **sebelum** sinyal/kejadian terjadi.

Jadi, `trap` adalah alat penting untuk membuat script Bash lebih aman, rapi, dan mudah menangani kondisi tak terduga.
