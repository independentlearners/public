# **Bahasa pemrograman berparadigma deklaratif**.

---

## Bahasa Pemrograman Berparadigma Deklaratif

Paradigma deklaratif adalah pendekatan pemrograman yang berfokus pada **“apa yang ingin dicapai”**, bukan pada **“bagaimana cara mencapainya”**. Dengan kata lain, programmer **mendeskripsikan tujuan** dan **aturan logis atau relasi**, lalu **sistem (compiler/interpreter) yang menentukan langkah eksekusi** secara otomatis.

Paradigma ini merupakan kebalikan dari paradigma imperatif (seperti prosedural), di mana programmer wajib menginstruksikan **urutan langkah operasional** secara eksplisit.

---

### Esensi Paradigma Deklaratif

1. **Mendeskripsikan hasil akhir**, bukan urutan proses
2. **Minim kontrol alur** seperti loop, kondisi eksplisit, atau state yang berubah
3. **Lebih menekankan ekspresi dan logika**, bukan mutasi data
4. Eksekusi langkah-langkah dihitung oleh **mesin**, seringkali dengan optimisasi otomatis

Contoh ide:

* Alih-alih “loop dari 1 sampai 100 dan hitung yang genap”
* Programmer cukup **menyatakan**: “ambil semua angka genap dari rentang 1–100”

---

### Karakteristik Utama

| Aspek             | Karakteristik dalam Deklaratif      |
| ----------------- | ----------------------------------- |
| Gaya berpikir     | Spesifikasi hasil                   |
| Kontrol alur      | Diatur oleh sistem                  |
| State/Mutasi data | Sangat minim atau tidak ada         |
| Abstraksi         | Tinggi                              |
| Evaluasi          | Bisa *lazy* (sesuai kebutuhan)      |
| Keamanan logika   | Tinggi, karena sedikit efek samping |

Paradigma deklaratif cenderung lebih **aman**, **ringkas**, dan **mudah diverifikasi**, terutama pada sistem kompleks.

---

### Sub-Paradigma di dalam Deklaratif

Paradigma deklaratif mencakup beberapa model lain, antara lain:

| Sub-Paradigma                       | Fokus                        | Contoh Bahasa            |
| ----------------------------------- | ---------------------------- | ------------------------ |
| Fungsional (Functional Programming) | Ekspresi matematis murni     | Haskell, F#, Erlang      |
| Logika (Logic Programming)          | Hubungan dan inferensi logis | Prolog, Datalog          |
| Pemrograman Basis Data              | Deskripsi data dan query     | SQL                      |
| Pemrograman Konfiguratif/Aturan     | Definisi aturan, pola        | YAML, Terraform, Ansible |

Jadi **fungsional adalah bagian dari deklaratif**, tetapi tidak semua deklaratif bersifat fungsional.

---

### Keuntungan Paradigma Deklaratif

1. **Kode lebih singkat** dan mudah dipahami
2. **Minim bug akibat state mutable**
3. **Peningkatan performa otomatis**

   * Compiler/engine bebas mengoptimalkan eksekusi
4. **Mudah diparalelkan**

   * Karena tidak ada mutasi data yang saling konflik
5. Lebih **mudah diuji** dan dibuktikan kebenarannya secara matematis

---

### Kekurangan dan Tantangan

1. **Kurang eksplisit** mengenai urutan eksekusi
2. **Kesulitan debugging**

   * Karena kontrol sepenuhnya di mesin, error kadang abstrak
3. **Tidak intuitif** bagi pemula yang terbiasa dengan paradigma imperatif
4. Tidak selalu cocok untuk:

   * Sistem dengan interaksi state intensif
   * Aplikasi yang membutuhkan kontrol timing sangat spesifik

---

### Domain Penggunaan yang Sangat Cocok

* Sistem analisis data dan big data
* Machine learning dan artificial intelligence
* Query database
* Pemrograman **parallel** dan **distributed**
* Pendefinisian konfigurasi dan orkestrasi (DevOps)
* Sistem berbasis logika/formal verification

Paradigma deklaratif sering dipilih ketika **kebenaran logika** dan **skalabilitas** lebih penting daripada detail langkah prosedural.

---

### Posisi Paradigma Deklaratif dalam Evolusi Pemrograman

Deklaratif mencerminkan evolusi ke arah **abstraksi yang semakin tinggi**. Manusia fokus pada pemodelan masalah, komputer menangani eksekusi operasional.

Gerak evolusi paradigma:

Prosedural → Imperatif → Berorientasi Objek → Fungsional/Deklaratif → Sistem Otomatis dan Self-Optimizing

Paradigma ini sangat relevan dengan era modern bertumpu otomatisasi, AI, dan skala sistem global.

---

