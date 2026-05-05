# Placeholder

## Prinsip singkat penggunaan placeholder

* **Tujuan**: ilustrasi struktur / alur tanpa memusingkan nama sebenarnya.
* **Sifat**: sementara, non-produksi — jangan commit placeholder ke branch utama tanpa diganti.
* **Konvensi**: gunakan nama yang ringkas, konsisten, dan kalau memungkinkan beri komentar yang menjelaskan makna sebenarnya.
* **Gaya penamaan**: `i, j, k` (loop index), `tmp` (temporary), `val`, `result`, `res`, `err`, `foo/bar/baz` (generic), `user`, `admin` (role), `example.com` / `localhost` (host).

## Aturan baik (best practices) saat menggunakan placeholder

1. **Jelaskan maksud placeholder**: selalu sertakan komentar yang menjelaskan jika konteks tidak jelas.
2. **Gunakan placeholder yang idiomatik** untuk bahasa tertentu (`i, j` untuk loop di C/Python; `idx` jika lebih jelas).
3. **Jangan gunakan placeholder untuk kredensial nyata** — selalu `REPLACE_ME` atau `__REDACTED__`.
4. **Ganti placeholder sebelum produksi**: buat checklist CI agar PR gagal bila `TODO`/`REPLACE_ME` masih ada.
5. **Prefer deskriptif ketika mungkin**: `userEmail` lebih baik dari `val` jika konteks adalah email.
6. **Document conventions** pada repositori (CONTRIBUTING.md) agar kontributor tahu kapan boleh memakai placeholder.

---

## Kapan **tidak** memakai placeholder

* Saat menulis dokumentasi API publik — gunakan contoh realistis namun non-sensitif (e.g., `user@example.com`, `example.com`).
* Saat membuat fixtures/end-to-end tests yang perlu validasi produksi (harus menggunakan data test yang deterministik).
* Saat commit konfigurasi — selalu gunakan environment variable placeholder (`${DB_HOST}`) bukan literal.

---

[Masuk ke daftar](./bagian-1/README.md)
