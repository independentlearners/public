Setelah menulis, menguji, dan mengoptimalkan kode, sekarang saatnya membawa aplikasi kita ke dunia nyata. **Modul 10: Deployment dan Production** akan membahas strategi dan praktik terbaik untuk menjalankan aplikasi OpenResty Anda di lingkungan produksi yang aman, andal, dan dapat diskalakan.

---

### **[Modul 10: Deployment dan Production][0]**

**Tujuan Modul:** Memahami cara mengkonfigurasi, mem-package, dan mendeploy aplikasi OpenResty ke lingkungan produksi dengan fokus pada keamanan, skalabilitas, dan ketersediaan tinggi (_high availability_).

\<div id="modul-10-1"\>\</div\>

#### **10.1 Production Configuration**

**Deskripsi Konkret:**
Konfigurasi yang Anda gunakan untuk development (`nginx.conf`) seringkali tidak cocok untuk produksi. Lingkungan produksi membutuhkan konfigurasi yang "diperkeras" (_hardened_) untuk keamanan, dioptimalkan untuk performa, dan disiapkan untuk logging dan monitoring yang andal.

**Konsep Kunci dan Praktik Terbaik:**

1.  **Security Hardening (Pengerasan Keamanan):**

    - **Jalankan dengan User Non-Root:** Konfigurasikan NGINX untuk menjalankan proses _worker_-nya sebagai pengguna dengan hak akses terbatas (misalnya, `user www-data;` di `nginx.conf`).
    - **Sembunyikan Informasi Server:** Jangan bocorkan versi NGINX atau OpenResty yang Anda gunakan, karena ini bisa membantu penyerang. Gunakan `server_tokens off;`.
    - **Konfigurasi SSL/TLS yang Kuat:** Nonaktifkan protokol SSL/TLS yang sudah usang (SSLv3, TLSv1.0, TLSv1.1) dan gunakan _cipher suite_ yang modern dan aman.
    - **Gunakan Security Headers:** Tambahkan header HTTP untuk memberitahu browser agar mengaktifkan fitur keamanan tambahan, seperti `Strict-Transport-Security` (mewajibkan HTTPS), `X-Frame-Options` (mencegah clickjacking), dan `X-Content-Type-Options` (mencegah MIME-sniffing).

2.  **Performance Tuning (Optimasi Performa):**

    - **`worker_processes auto;`**: Atur jumlah proses worker NGINX agar sesuai dengan jumlah inti CPU yang tersedia.
    - **`worker_connections 1024;`**: Sesuaikan jumlah koneksi yang bisa ditangani oleh setiap worker. Nilai default seringkali sudah cukup, tetapi bisa dinaikkan untuk situs dengan lalu lintas sangat tinggi.
    - **`lua_code_cache on;`**: Ini **wajib** di lingkungan produksi. Direktif ini memberitahu OpenResty untuk meng-cache hasil kompilasi dari skrip Lua Anda. Jika `off`, OpenResty akan membaca dan mengkompilasi ulang skrip dari disk untuk _setiap request_, yang akan membunuh performa.

3.  **Log Management (Manajemen Log):**

    - **`access_log` & `error_log`**: Pastikan log akses dan log error diaktifkan dan disimpan di lokasi yang benar.
    - **Log Rotation:** Konfigurasikan sistem Anda (misalnya dengan utilitas `logrotate` di Linux) untuk memutar (archive dan kompres) file log secara berkala. Ini mencegah satu file log tumbuh terlalu besar hingga memenuhi seluruh disk.

**Contoh Konfigurasi Produksi (potongan `nginx.conf`):**

```nginx
# Jalankan worker sebagai user non-root
user www-data;
worker_processes auto;

# Aktifkan cache kode Lua untuk produksi
lua_code_cache on;

events {
    worker_connections 4096;
}

http {
    # Jangan tampilkan versi NGINX
    server_tokens off;

    # ... (definisi log format, dll)

    server {
        listen 443 ssl http2;
        server_name yourdomain.com;

        # Konfigurasi SSL yang kuat
        ssl_certificate /path/to/your/fullchain.pem;
        ssl_certificate_key /path/to/your/privkey.pem;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:...';

        # Security Headers
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;

        location / {
            # ... logika aplikasi Anda
        }
    }
}
```

**Sumber Referensi:**

- Praktik Terbaik Produksi: [OpenResty Production-Ready Guide](https://openresty.org/en/production-ready.html)

\<div id="modul-10-2"\>\</div\>

#### **10.2 Containerization dan Orchestration**

**Deskripsi Konkret:**
Daripada menginstal OpenResty dan semua dependensinya langsung di server fisik (yang bisa menyebabkan masalah "di laptop saya jalan, tapi di server tidak"), pendekatan modern adalah dengan **containerization**. Sebuah container membungkus aplikasi Anda beserta semua yang dibutuhkannya (runtime, library sistem, kode) ke dalam satu paket yang terisolasi dan portabel.

**Terminologi Kunci:**

- **Docker:** Platform containerization paling populer. Anda mendefinisikan "gambar" (image) dari aplikasi Anda menggunakan sebuah file bernama `Dockerfile`. Image ini adalah cetak biru statis. Saat dijalankan, ia menjadi sebuah "container" yang hidup.
- **Kubernetes (K8s):** Ketika aplikasi Anda berjalan di banyak container, Anda butuh alat untuk mengelolanya secara otomatis. Inilah yang disebut "orkestrasi". Kubernetes adalah standar industri untuk orkestrasi container. Ia menangani deployment, scaling (menambah/mengurangi jumlah container), networking, dan self-healing (me-restart container yang gagal).
- **Service Mesh (misal: Istio, Linkerd):** Lapisan infrastruktur canggih yang berjalan di atas Kubernetes. Ia menyediakan fitur-fitur seperti routing lalu lintas yang kompleks, observabilitas mendalam, dan keamanan antar layanan (mTLS) tanpa perlu mengubah kode aplikasi Anda.

**Contoh `Dockerfile` untuk Aplikasi OpenResty:**

```dockerfile
# Gunakan image resmi OpenResty berbasis Alpine Linux (yang sangat kecil)
FROM openresty/openresty:alpine

# Hapus konfigurasi default
RUN rm /etc/nginx/conf.d/default.conf

# Salin file konfigurasi nginx produksi kita ke dalam image
COPY nginx.conf /etc/nginx/nginx.conf

# Salin direktori aplikasi kita yang berisi semua modul Lua
COPY app/ /usr/local/openresty/nginx/app/

# (Opsional) Salin direktori template jika menggunakan SSR
COPY templates/ /usr/local/openresty/nginx/templates/

# Beritahu Docker bahwa container akan listen di port 80
EXPOSE 80

# Perintah default yang akan dijalankan saat container启动
# '-g "daemon off;"' membuat NGINX berjalan di foreground, yang merupakan praktik standar untuk container
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
```

Dengan `Dockerfile` ini, Anda bisa membangun dan menjalankan aplikasi Anda di mana saja Docker terinstal dengan perintah sederhana `docker build` dan `docker run`.

**Sumber Referensi:**

- Image Docker Resmi OpenResty: [Official OpenResty Docker Images on Docker Hub](https://hub.docker.com/r/openresty/openresty/)

\<div id="modul-10-3"\>\</div\>

#### **10.3 Scaling dan High Availability**

**Deskripsi Konkret:**
Satu server tunggal memiliki dua kelemahan utama: kapasitasnya terbatas dan ia merupakan _single point of failure_ (jika server itu mati, seluruh aplikasi Anda mati). Strategi berikut mengatasi kedua masalah tersebut.

**Konsep Kunci: Horizontal Scaling (Scaling Out)**
Ini adalah praktik menambahkan _lebih banyak server_ untuk menangani peningkatan beban, alih-alih membuat satu server menjadi lebih kuat (_vertical scaling_). Ini adalah cara yang lebih fleksibel dan hemat biaya untuk menskalakan aplikasi web. Untuk melakukan ini, Anda memerlukan **Load Balancer**.

**Ilustrasi Arsitektur Skalabel:**

```
            Pengguna
                |
                V
+-------------------------------+
|       Load Balancer           |  <-- Bisa juga NGINX/OpenResty
| (Membagi lalu lintas)          |
+-------------------------------+
      |          |          |
      V          V          V
+----------+ +----------+ +----------+
| Server 1 | | Server 2 | | Server 3 |
| (App Anda)| | (App Anda)| | (App Anda)|  <-- Semua menjalankan container yang sama
+----------+ +----------+ +----------+
```

**Konsep Kunci: High Availability (HA)**
_High Availability_ adalah desain sistem yang bertujuan untuk memastikan aplikasi tetap beroperasi (tersedia) meskipun terjadi kegagalan pada salah satu komponennya. Arsitektur di atas secara inheren sudah memiliki HA. Jika `Server 2` tiba-tiba mati, Load Balancer akan mendeteksinya dan secara otomatis berhenti mengirimkan lalu lintas ke sana. Pengguna akan tetap dilayani oleh `Server 1` dan `Server 3`, seringkali tanpa menyadari adanya masalah.

**Terminologi Kunci:**

- **Load Balancer:** Sebuah perangkat lunak (atau keras) yang mendistribusikan request dari client ke sekelompok server backend.
- **Disaster Recovery (DR):** Rencana untuk pulih dari bencana besar, seperti kegagalan seluruh pusat data. Ini seringkali melibatkan replikasi seluruh infrastruktur Anda ke lokasi geografis yang berbeda.

**Sumber Referensi:**

- Panduan Scaling OpenResty (mengacu pada dokumentasi instalasi untuk berbagai lingkungan): [OpenResty Scaling Guide](https://openresty.org/en/installation.html)

---

Dengan menguasai Modul 10, Anda telah melengkapi seluruh siklus hidup pengembangan perangkat lunak: dari ide, ke kode, ke pengujian, ke optimasi, dan akhirnya ke deployment produksi yang tangguh.

Selanjutnya, kita akan melihat beberapa kasus penggunaan tingkat lanjut yang paling populer untuk OpenResty dalam **Modul 11: Advanced Use Cases**.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-7/README.md
[selanjutnya]: ../bagian-10/README.md

<!----------------------------------------------------->

[0]: ../README.md#modul-10-deployment-dan-production
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
