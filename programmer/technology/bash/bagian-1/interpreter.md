# Interpreter

Dalam istilah *scripting*, **interpreter** (penerjemah) adalah sebuah program perangkat lunak yang menjalankan instruksi kode sumber secara langsung, tanpa perlu mengubahnya terlebih dahulu menjadi file *executable* (yang dapat dieksekusi) yang terpisah.

Berikut adalah poin-poin penting untuk memahaminya:

### ⚙️ Cara Kerja Interpreter

Interpreter bekerja dengan membaca kode sumber **baris demi baris atau pernyataan demi pernyataan**, lalu langsung menerjemahkannya ke dalam bahasa mesin dan menjalankannya saat itu juga (*on the fly*). Proses ini memungkinkan eksekusi program secara langsung dan interaktif.

### 🔄 Perbedaan Utama dengan Compiler

Perbedaan paling mendasar terletak pada **waktu dan cara penerjemahan**:

*   **Compiler**: Menerjemahkan **seluruh** kode sumber menjadi kode mesin sekaligus, sebelum program dijalankan, dan menghasilkan file *executable* terpisah.
*   **Interpreter**: Menerjemahkan dan menjalankan kode **baris per baris** pada saat program dieksekusi, tanpa menghasilkan file *executable* permanen.

### 🎯 Peran dalam *Scripting*

Bahasa *scripting* seperti **Python, JavaScript, dan Ruby** sangat bergantung pada interpreter. Alasannya:

1.  **Eksekusi Langsung**: Interpreter memungkinkan pengembang untuk menulis dan langsung menjalankan *script* tanpa melalui langkah kompilasi yang memakan waktu. Ini sangat cocok untuk tugas-tugas otomasi, *prototyping* cepat, dan pengembangan yang bersifat iteratif.
2.  **Portabilitas**: Kode *script* yang sama dapat dijalankan di sistem operasi atau arsitektur perangkat keras apa pun selama sistem tersebut memiliki interpreter yang sesuai. Ini menghilangkan kebutuhan untuk mengompilasi ulang program untuk setiap platform yang berbeda.

### ⚖️ Kelebihan dan Kekurangan

*   **Kelebihan**: Siklus pengembangan lebih cepat, proses *debugging* lebih mudah karena kesalahan dapat langsung terlihat pada baris kode sumber, dan program bersifat portabel.
*   **Kekurangan**: Eksekusi program umumnya lebih lambat dibandingkan bahasa yang dikompilasi karena proses penerjemahan terjadi setiap kali kode dijalankan. Selain itu, interpreter membutuhkan lebih banyak memori.

Singkatnya, dalam *scripting*, interpreter adalah "mesin" yang membuat kode sumber dapat langsung "hidup" dan menjalankan tugasnya tanpa perlu proses kompilasi yang rumit terlebih dahulu.

---

### 🐚 Bash: Interpreter "Murni" yang Bekerja Baris-per-Baris

Bash (Bourne Again SHell) adalah contoh paling murni dari apa yang digambarkan dalam dokumen ini. Bash adalah **interpreter satu-lintasan (*single-pass interpreter*)** yang membaca, menafsirkan, dan menjalankan satu perintah pada satu waktu, saat itu juga.

Secara internal, Bash tidak melakukan pra-kompilasi file menjadi *bytecode* atau kode mesin. Ia memproses skrip secara **tekstual murni**. Alurnya sederhana: shell menggunakan `reader_loop()` untuk membaca input, lalu memanggil `read_command()` yang di dalamnya terdapat parser YACC (`yyparse()`) untuk memproses perintah **baris demi baris**, lalu `execute_command()` menjalankannya.

Konsekuensi praktisnya terlihat jelas: jika sebuah skrip Bash memiliki kesalahan sintaks di baris ke-3, baris ke-1 dan ke-2 **tetap akan dieksekusi** terlebih dahulu sebelum error dilaporkan. Ini berbeda dengan bahasa yang melakukan pemeriksaan sintaks di awal (seperti Perl atau Python), yang akan menolak menjalankan seluruh skrip jika ada kesalahan sintaks di bagian mana pun.

Namun, perlu dicatat bahwa banyak perintah yang dijalankan oleh skrip Bash sebenarnya adalah **program binary eksternal** (seperti `ls`, `grep`, `awk`), sehingga Bash berfungsi sebagai *makro-prosesor* atau *glue language* yang mengorkestrasi program-program lain.

---

### ⚙️ Model Eksekusi Bahasa Scripting Lain: Hybrid dan JIT

Berbeda dengan Bash, bahasa scripting modern umumnya menggunakan pendekatan **hybrid**: kode sumber tidak langsung dieksekusi, melainkan dikompilasi terlebih dahulu ke representasi perantara (bytecode) sebelum dijalankan oleh mesin virtual (VM).

**Python (CPython)**
Interpreter Python (CPython) mengubah kode sumber `.py` melalui proses *tokenizing*, *parsing*, dan *compiling* menjadi **bytecode**. Bytecode ini kemudian dieksekusi oleh **Virtual Machine (VM) yang berbasis stack** (*stack-based VM*). Artinya, VM menggunakan struktur data stack untuk mendorong (*push*) dan menarik (*pop*) objek selama operasi berlangsung. CPython tidak melakukan kompilasi JIT secara default, sehingga eksekusinya bisa lebih lambat dibanding implementasi lain seperti PyPy yang memiliki JIT.

**JavaScript (V8 Engine)**
JavaScript modern (terutama di mesin V8 seperti Chrome dan Node.js) telah berevolusi dari interpreter murni menjadi sistem **Just-In-Time (JIT) Compilation**. Pipeline eksekusinya menggunakan dua tingkat:
1.  **Ignition (Interpreter):** Meng-compile kode JavaScript menjadi bytecode yang ringkas untuk startup cepat.
2.  **TurboFan (Optimizing Compiler):** Memantau kode yang sering dieksekusi (*hot functions*). Jika suatu fungsi dianggap "panas", bytecode dan data profilnya dikirim ke TurboFan untuk dikompilasi menjadi **kode mesin asli yang sangat optimal**.

**Ruby (MRI - Matz's Ruby Interpreter)**
Ruby modern (sejak versi 1.9) juga mengadopsi pendekatan hybrid. Kode Ruby dikompilasi menjadi **bytecode**, lalu dieksekusi di dalam **Virtual Machine** yang dibangun di memori. VM ini mensimulasikan mesin fisik dengan *program counter*, stack untuk nilai antara, dan set instruksi primitif.

**Lua**
Lua mengadopsi pendekatan yang sedikit berbeda. Kode sumber Lua dikompilasi menjadi bytecode, tetapi bytecode tersebut dieksekusi oleh **Virtual Machine berbasis register** (*register-based VM*), bukan berbasis stack seperti Python atau JVM. VM berbasis register umumnya lebih cepat karena operasinya lebih mirip dengan cara kerja CPU fisik, meskipun bytecode-nya cenderung lebih besar. LuaJIT, implementasi alternatif, menambahkan kompilasi JIT untuk performa yang jauh lebih tinggi.

---

### 📊 Tabel Perbedaan Utama Antar Bahasa Scripting

Tabel berikut merangkum perbedaan model eksekusi dan karakteristik utama dari kelima bahasa yang dibahas.

| Aspek | **Bash** | **Python (CPython)** | **JavaScript (V8)** | **Ruby (MRI)** | **Lua** |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Model Eksekusi** | Interpreter baris-per-baris (tekstual murni) | Kompilasi ke bytecode → VM berbasis *stack* | **JIT Compilation** (Interpreter `Ignition` + Compiler `TurboFan`) | Kompilasi ke bytecode → VM (berbasis *stack*) | Kompilasi ke bytecode → VM berbasis *register* |
| **Representasi Perantara** | Tidak ada (hanya teks) | Bytecode (`.pyc`) | Bytecode (di memori) & Kode Mesin | Bytecode (di memori) | Bytecode (dapat disimpan) |
| **Kebutuhan Runtime** | Shell (Bash) itu sendiri | Python VM | Lingkungan JavaScript (Browser/Node.js) | Ruby VM | Lua VM (sangat ringan) |
| **Kelebihan Utama** | Startup sangat cepat, kontrol OS langsung, *glue language* yang ampuh | Mudah dibaca, ekosistem luas, portabel | Performa eksekusi tinggi (JIT), *event-driven* | Sintaks ekspresif, fokus pada kebahagiaan *developer* | Sangat ringan, mudah ditanam (*embeddable*), cepat |
| **Kekurangan Utama** | Sulit dipelihara untuk skala besar, penanganan error terbatas | Kecepatan eksekusi lebih lambat (tanpa JIT), startup moderat | Kompleksitas manajemen kode pada skrip besar, pola asinkron | Eksekusi lebih lambat untuk skrip, startup moderat | Perkakas standalone terbatas, ekosistem lebih kecil |
| **Penggunaan Utama** | Otomasi sistem, administrasi server, skrip *shell* | Otomasi umum, *server-side*, ilmu data, *scripting* | *Client-side* web, *server-side* (Node.js), aplikasi interaktif | Pengembangan web *server-side* (Ruby on Rails), otomasi | *Embedded scripting* (game, router, aplikasi), konfigurasi |

---

### 💎 Kesimpulan

Pembahasan di atas menunjukkan bahwa istilah "interpreter" mencakup spektrum implementasi yang luas. **Bash** adalah contoh klasik interpreter murni yang membaca dan mengeksekusi teks baris demi baris. Sementara itu, bahasa scripting modern seperti **Python, JavaScript, Ruby, dan Lua** telah berkembang menjadi sistem hybrid yang lebih canggih, menggunakan kompilasi ke *bytecode* dan mesin virtual untuk mencapai keseimbangan antara portabilitas, kecepatan pengembangan, dan performa eksekusi. JavaScript (V8) melangkah lebih jauh dengan JIT compilation, yang mendekatkan performanya ke bahasa terkompilasi native.
