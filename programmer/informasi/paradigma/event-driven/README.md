
# **Bahasa dan paradigma Event-Driven Programming**.

---

## Paradigma Pemrograman Event-Driven

Event-driven programming adalah pendekatan pemrograman yang berfokus pada **peristiwa (event)** sebagai pemicu eksekusi program. Program tidak berjalan secara linear dari awal ke akhir, melainkan **bereaksi** terhadap event yang terjadi, baik dari:

1. Pengguna (input)
2. Sistem atau OS
3. Jaringan atau hardware
4. Waktu (timer)
5. Perubahan state eksternal

Dengan kata lain, logika program ditentukan oleh:
**Jika event X terjadi → lakukan aksi Y**

Paradigma ini sangat erat dengan konsep **asynchronous** dan **concurrency**, terutama ketika banyak event terjadi bersamaan.

---

### Esensi Paradigma Event-Driven

1. Ada **Event Source** (sumber event)
2. Ada **Event Listener/Handler** (penyambut dan pemroses)
3. Ada **Event Loop** yang memantau dan mendistribusikan event

Program terus aktif dalam keadaan siaga sambil menunggu event masuk. Eksekusi terjadi **berdasarkan kejadian**, bukan sesuai urutan instruksi yang sudah ditentukan.

---

### Karakteristik Utama

| Aspek          | Deskripsi                                 |
| -------------- | ----------------------------------------- |
| Alur kontrol   | Tidak linear, tergantung event            |
| Arsitektur     | Callback, listener, observer, pub-sub     |
| Model eksekusi | Asynchronous / Concurrent                 |
| Interaksi      | Responsif dan Reaktif                     |
| Cocok untuk    | Aplikasi UI, server I/O, sistem real-time |

Paradigma ini meningkatkan **responsiveness** dan **scalability**.

---

### Struktur Dasar Sistem Event-Driven

1. **Event Emitters**
   Entitas yang menghasilkan event (misalnya klik mouse, request HTTP)

2. **Event Queue**
   Antrian untuk menyimpan event yang terjadi sementara menunggu diproses

3. **Event Loop**
   Mekanisme yang terus mengecek queue dan meneruskan event ke handler

4. **Event Handlers/Callbacks**
   Fungsi yang akan dijalankan sebagai respon event tertentu

Contoh alur umum:

* Pengguna klik tombol → event masuk ke queue → event loop memproses → handler dijalankan

---

### Model Komunikasi Umum dalam Event-Driven

| Model                       | Penjelasan                                         |
| --------------------------- | -------------------------------------------------- |
| Callback-based              | Fungsi dipanggil ketika event terjadi              |
| Observer / Listener pattern | Komponen mendaftar untuk “mendengarkan” event      |
| Publish-Subscribe (Pub/Sub) | Pemisahan total antara pengirim dan penerima event |
| Reactive Streams            | Reaksi terhadap aliran data event secara kontinu   |

Semakin modern platformnya, semakin abstrak model event-driven yang digunakan.

---

### Contoh Domain Penerapan

1. **UI/UX**

   * Web, mobile, desktop GUI
   * Semua interaksi pengguna berbasis event

2. **Networking**

   * Server web modern (Node.js, Nginx, Erlang OTP)

3. **IoT dan Hardware**

   * Sensor yang memicu event berdasarkan perubahan lingkungan

4. **Game Development**

   * Input player, collision, frame update

5. **Reaktif Sistem**

   * Stream data real-time (misal data pasar saham)

Paradigma ini mendukung pengalaman responsif dan realtime.

---

### Keuntungan

1. **Responsif tinggi**
   Program bereaksi instan terhadap stimulasi eksternal
2. **Efisien I/O**
   Sangat baik menangani banyak koneksi atau input bersamaan
3. **Cocok untuk UI modern dan aplikasi reaktif**
4. **Lebih dekat dengan cara dunia nyata bekerja**
   Event selalu terjadi di sekitar kita

---

### Kekurangan dan Tantangan

1. **Sulit menelusuri alur program**
   Karena urutan eksekusi bergantung pada urutan event
2. **Callback Hell**
   Jika struktur event saling bersarang
3. **Resiko kondisi balapan (race condition)**
   Bila banyak event mengubah state bersama
4. **Testing lebih sulit**
   Karena hasil tergantung timing event

Untuk alasan ini, banyak framework modern menggunakan **reactive architecture** untuk menertibkan kompleksitas event.

---

### Hubungan dengan Paradigma Lain

| Paradigma  | Hubungan dengan Event-Driven                                                   |
| ---------- | ------------------------------------------------------------------------------ |
| Prosedural | Event memicu eksekusi blok prosedural                                          |
| OOP        | Objek sebagai sumber dan pendengar event                                       |
| Fungsional | Handler dapat berupa fungsi murni (immutability → aman untuk concurrency)      |
| Deklaratif | Deskripsi *when event happens → this should occur* (mis. Reactive Programming) |

Jadi, event-driven **bukan pengganti**, tapi **bisa bekerja bersama** paradigma lain.

---

### Posisi Event-Driven dalam Evolusi Sistem Modern

* Era GUI → UI event-centric
* Era Web → I/O asynchronous
* Era IoT → event dari dunia fisik
* Era Cloud/Microservices → event streaming dan pub-sub global
* Era AI → sistem otonom reaktif terhadap input dinamis

Paradigma event-driven semakin penting untuk sistem berskala besar dan real-time.

---

