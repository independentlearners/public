Sekarang kita memasuki **Modul 14: DevOps dan CI/CD Integration**. Setelah Anda bisa membangun, menguji, dan mengamankan aplikasi, langkah berikutnya adalah mengotomatiskan seluruh proses ini. DevOps adalah budaya dan serangkaian praktik yang bertujuan untuk mempercepat dan mengefisienkan siklus hidup pengembangan perangkat lunak, dari penulisan kode hingga rilis ke produksi.

---

### **Modul 14: DevOps dan CI/CD Integration**

**Tujuan Modul:** Mengintegrasikan aplikasi OpenResty ke dalam alur kerja DevOps modern, mengotomatiskan proses build, test, dan deploy menggunakan pipeline CI/CD, serta mengelola infrastruktur sebagai kode (Infrastructure as Code).

#### **14.1 Configuration Management**

**Deskripsi Konkret:**
Aplikasi Anda akan berjalan di berbagai lingkungan (development di laptop, staging untuk testing, produksi untuk pengguna). Setiap lingkungan memerlukan konfigurasi yang berbeda (misalnya, URL database, level log, kunci API). Mengelola file-file konfigurasi ini secara manual sangat rentan terhadap kesalahan (_error-prone_). **Manajemen Konfigurasi** adalah praktik mengelola perbedaan ini secara sistematis dan otomatis.

**Konsep Kunci:**

- **Environment-specific Configurations:** Pisahkan konfigurasi dari kode. Kode aplikasi Anda harus tetap sama di semua lingkungan. Yang berbeda hanyalah nilai-nilai konfigurasi yang dimuat saat runtime, seringkali melalui _environment variables_ (variabel lingkungan).
- **Secret Management:** **Jangan pernah menyimpan informasi rahasia** (password, token, kunci API) di dalam repositori Git Anda. Gunakan layanan eksternal yang aman seperti HashiCorp Vault, AWS Secrets Manager, atau Google Secret Manager untuk menyimpan rahasia. Aplikasi Anda akan mengambil rahasia ini saat startup.
- **Configuration Validation:** Sebelum mendeploy aplikasi, jalankan skrip untuk memvalidasi file konfigurasi. Apakah semua variabel yang dibutuhkan sudah ada? Apakah formatnya benar? Ini mencegah deployment gagal karena kesalahan konfigurasi sepele.
- **Blue-Green Deployment:** Ini adalah strategi deployment tingkat lanjut untuk mencapai _zero downtime_.
  1.  Anda memiliki dua lingkungan produksi yang identik: "Blue" (yang sedang live) dan "Green" (yang idle).
  2.  Anda mendeploy versi baru aplikasi Anda ke lingkungan Green.
  3.  Setelah semua tes di lingkungan Green lolos, Anda mengalihkan _load balancer_ untuk mengirim semua lalu lintas pengguna dari Blue ke Green.
  4.  Green sekarang menjadi lingkungan live yang baru. Blue menjadi idle dan siap untuk deployment berikutnya atau sebagai cadangan untuk _rollback_ cepat jika terjadi masalah.

**Contoh (Menggunakan Environment Variables untuk Konfigurasi):**
Anda bisa menggunakan template untuk `nginx.conf` dan mengganti nilainya saat container di-build atau dijalankan.
**`nginx.conf.template`:**

```nginx
# ...
http {
    upstream my_backend {
        server ${BACKEND_URL}; # Nilai akan disuntikkan dari env var
    }
    # ...
}
```

Saat container Docker dijalankan, sebuah skrip entrypoint akan menggunakan `envsubst` untuk membuat `nginx.conf` yang final:
`envsubst < /etc/nginx/templates/nginx.conf.template > /etc/nginx/nginx.conf && openresty -g "daemon off;"`

**Sumber Referensi:**

- Praktik Terbaik DevOps untuk OpenResty: [OpenResty DevOps Best Practices](https://openresty.org/en/devops.html)

#### **14.2 Continuous Integration**

**Deskripsi Konkret:**
**Continuous Integration (CI)** adalah praktik di mana developer secara teratur menggabungkan perubahan kode mereka ke repositori pusat. Setelah setiap penggabungan, sebuah proses otomatis akan berjalan untuk membangun dan menguji kode tersebut. Tujuannya adalah untuk menemukan dan memperbaiki bug secepat mungkin.

**Konsep Kunci: The CI Pipeline**
Pipeline CI adalah serangkaian langkah (tahap/stage) otomatis yang dijalankan oleh server CI/CD (seperti Jenkins, GitLab CI, GitHub Actions) setiap kali ada perubahan kode.

1.  **Checkout Code:** Mengunduh versi kode terbaru.
2.  **Lint:** Menjalankan `luacheck` untuk memastikan kode mematuhi standar gaya dan tidak memiliki kesalahan sintaksis.
3.  **Unit & Integration Test:** Menjalankan _test suite_ Anda menggunakan `Test::Nginx` untuk memastikan semua fungsionalitas bekerja seperti yang diharapkan dan tidak ada regresi.
4.  **Security Scan:** Menjalankan alat pemindai keamanan (seperti SonarQube atau Snyk) untuk mencari kerentanan yang diketahui dalam kode atau dependensinya.
5.  **Build Artifact:** Jika semua langkah sebelumnya berhasil, pipeline akan membuat "artefak" rilis, yang paling umum adalah sebuah image Docker.
6.  **Push Artifact:** Mengunggah image Docker ke sebuah _container registry_ (seperti Docker Hub, Google Artifact Registry, atau AWS ECR).

Jika salah satu dari langkah-langkah ini gagal, pipeline akan berhenti dan memberitahu developer. Ini menciptakan "gerbang kualitas" (_quality gate_) yang mencegah kode buruk masuk ke tahap selanjutnya.

**Contoh Kerangka Pipeline CI (misal, dalam format YAML untuk GitHub Actions):**

```yaml
name: OpenResty CI

on: [push]

jobs:
  test-and-build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup OpenResty
        # ... (langkah untuk menginstal OpenResty, Test::Nginx, dll.)

      - name: Run Linter
        run: luacheck .

      - name: Run Tests
        run: prove -r tests/

      - name: Build Docker Image
        if: success() # Hanya jalankan jika tes berhasil
        run: docker build -t my-openresty-app:${{ github.sha }} .

      - name: Push to Registry
        if: success()
        # ... (langkah untuk login dan push image ke registry)
```

**Sumber Referensi:**

- Integrasi CI/CD dengan Test::Nginx: [Test::Nginx CI/CD Integration](https://github.com/openresty/test-nginx)

#### **14.3 Infrastructure as Code**

**Deskripsi Konkret:**
**Infrastructure as Code (IaC)** adalah praktik mengelola dan memprovisikan infrastruktur (server, load balancer, database, jaringan) melalui file definisi yang bisa dibaca mesin (kode), bukan melalui konfigurasi manual. Ini membuat infrastruktur Anda dapat direproduksi, diberi versi, dan otomatis.

**Terminologi Kunci dan Alat-alatnya:**

- **Terraform:** Alat IaC yang paling populer untuk **memprovisikan** infrastruktur. Anda menulis kode deklaratif yang mendeskripsikan sumber daya cloud apa yang Anda inginkan (misalnya, 2 server virtual, 1 load balancer, 1 database), dan Terraform akan berkomunikasi dengan API provider cloud (AWS, GCP, Azure) untuk membuatnya.
- **Ansible:** Alat manajemen konfigurasi yang hebat untuk **mengkonfigurasi** server yang sudah ada. Setelah Terraform membuat server, Ansible bisa masuk melalui SSH untuk menginstal OpenResty, menyalin file `nginx.conf`, dan memulai layanan.
- **Helm Charts:** "Manajer paket untuk Kubernetes". Jika Anda mendeploy aplikasi OpenResty Anda ke Kubernetes, Helm chart membungkus semua file manifest Kubernetes yang rumit (Deployment, Service, Ingress, dll.) ke dalam satu paket yang mudah diinstal dan dikelola.
- **GitOps:** Evolusi dari IaC di mana repositori Git adalah satu-satunya sumber kebenaran (_single source of truth_) untuk keadaan yang diinginkan dari seluruh sistem Anda (baik aplikasi maupun infrastruktur). Sebuah agen otomatis (seperti Argo CD atau Flux) berjalan di dalam cluster Kubernetes Anda, terus-menerus membandingkan keadaan live dengan apa yang didefinisikan di Git. Jika ada perbedaan, agen tersebut secara otomatis menyinkronkan cluster agar sesuai dengan Git.

**Contoh Konseptual (Ansible Playbook untuk Setup OpenResty):**

```yaml
---
- name: Configure OpenResty Server
  hosts: webservers
  become: yes # Menjalankan sebagai root (sudo)
  tasks:
    - name: Install OpenResty
      apt:
        name: openresty
        state: present

    - name: Copy Nginx configuration
      copy:
        src: files/nginx.conf
        dest: /etc/nginx/nginx.conf
      notify:
        - restart openresty

  handlers:
    - name: restart openresty
      service:
        name: openresty
        state: restarted
```

**Sumber Referensi:**

- Otomatisasi Infrastruktur OpenResty: [OpenResty Infrastructure Automation](https://openresty.org/en/infrastructure.html)

---

Dengan menguasai Modul 14, Anda melengkapi keterampilan Anda sebagai seorang developer dengan pola pikir seorang insinyur DevOps. Anda dapat membangun sistem yang tidak hanya berfungsi dengan baik, tetapi juga dapat dirilis dengan cepat, andal, dan berulang kali.

#

> - **[Ke Atas](#)**
> - **[Selanjutnya][selanjutnya]**
> - **[Sebelumnya][sebelumnya]**
> - **[Kurikulum][kurikulum]**
> - **[Domain Spesifik][domain]**

[domain]: ../../../../../../README.md
[kurikulum]: ../../../../README.md
[sebelumnya]: ../bagian-11/README.md
[selanjutnya]: ../bagian-13/README.md

<!----------------------------------------------------->

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
