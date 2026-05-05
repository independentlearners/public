# Bagian 1 — Placeholder Dasar (Level Paling Awal)

Ini adalah sajian untuk *placeholder* paling fundamental yang muncul pertama kali saat belajar pemrograman. Halaman ini akan mencakup bagaimana setiap entri menyertakan:

<details>
  <summary>📃 Daftar Sajian</summary>

1. **Nama placeholder**
2. **Arti / maksud** (apa yang diwakili)
3. **Konteks penggunaan** (di mana biasa dipakai)
4. **Variasi umum** (alias atau bentuk lain)
5. **Anjuran penggunaan** (best practice singkat)
6. **Risiko / larangan** (jika relevan)
7. **Contoh singkat** (kode/CLI minimal) + **penjelasan kata-per-kata** untuk setiap token pada contoh itu.

</details>

Kita mulai dari level paling dasar — gunakan bagian ini sebagai fondasi sebelum kita melanjutkan ke bidang khusus satu-per-satu.

---

## 1. `foo`, `bar`, `baz`, `qux`, `quux`, ... (klasik)

* **Arti / maksud**: Variabel/fungsi generik tanpa makna domain — hanya penanda untuk contoh.
* **Konteks**: Dokumentasi, contoh kode, testing awal.
* **Variasi**: `fred`, `plugh`, `xyzzy`, `thud` (nama-nama tradisional lainnya).
* **Anjuran**: Pakai hanya di contoh pembelajaran atau prototipe; sertakan komentar yang menjelaskan makna sebenarnya.
* **Risiko**: Jangan commit sebagai nama produksi; jangan gunakan untuk data sensitif.
* **Contoh (Python)**:

```python
foo = 3
bar = 5
baz = foo + bar
print(baz)
```

**Penjelasan kata-per-kata**:

* `foo` → nama variabel placeholder pertama.
* `=` → operator penugasan (assignment).
* `3` → literal integer.
* `bar` → nama variabel placeholder kedua.
* `5` → literal integer.
* `baz` → variabel untuk hasil; placeholder ketiga.
* `foo + bar` → operasi penjumlahan antara nilai `foo` dan `bar`.
* `print(baz)` → fungsi cetak; argumennya adalah nilai `baz`.

---

## 2. `i`, `j`, `k`, `idx`, `index`, `pos`

* **Arti / maksud**: Indeks atau penghitung (counter) pada loop/iterasi.
* **Konteks**: Looping, traversal array/list, pointer counter.
* **Variasi**: `n`, `m` (biasa untuk ukuran), `pos`/`position` untuk posisi lebih deskriptif.
* **Anjuran**: Gunakan `i/j/k` untuk loop singkat; gunakan `idx`/`index` jika konteks butuh kejelasan.
* **Risiko**: `i/j` sulit dipahami untuk blok besar — ubah menjadi nama deskriptif bila perlu.
* **Contoh (Bash)**:

```bash
for i in 1 2 3; do
  echo $i
done
```

**Penjelasan kata-per-kata**:

* `for` → keyword loop.
* `i` → variabel indeks loop.
* `in` → kata kunci yang menunjukkan koleksi/daftar.
* `1 2 3` → daftar elemen yang diiterasi.
* `;` → pemisah pernyataan (opsional sebelum `do`).
* `do` → mulai blok perintah loop.
* `echo` → perintah cetak ke stdout.
* `$i` → substitusi variabel `i`.
* `done` → akhir blok loop.

---

## 3. `tmp`, `tmp1`, `tmp2`, `temp`, `tempfile`

* **Arti / maksud**: Variabel atau path untuk data sementara.
* **Konteks**: Perhitungan antara, file sementara, cache sementara.
* **Variasi**: `t`, `scratch`, `buffer`.
* **Anjuran**: Gunakan direktori sistem temporer (`/tmp`, `TMPDIR`) atau API pembuatan file temporer; jangan simpan data sensitif di file temp tanpa enkripsi.
* **Risiko**: File temp raw berisiko bocor; jangan gunakan predictable names untuk kunci/secret.
* **Contoh (Python)**:

```python
import tempfile
tmp = tempfile.NamedTemporaryFile(delete=False)
tmp.write(b"hello")
tmp.close()
print(tmp.name)
```

**Penjelasan kata-per-kata**:

* `import tempfile` → impor modul `tempfile`.
* `tmp` → variabel yang menyimpan objek file sementara.
* `tempfile.NamedTemporaryFile(delete=False)` → panggil pabrik file temporer dengan nama yang dapat diakses; `delete=False` mencegah penghapusan otomatis.
* `.write(b"hello")` → tulis bytes `hello` ke file.
* `.close()` → tutup file.
* `print(tmp.name)` → cetak path file temporer yang dibuat.

---

## 4. `val`, `value`, `v`

* **Arti / maksud**: Nilai generik; sering dipakai ketika tipe/semantik tidak penting untuk contoh.
* **Konteks**: Contoh fungsi, parameter, return.
* **Variasi**: `nval`, `new_val`.
* **Anjuran**: Jika nilai merepresentasikan entitas nyata (mis. `userAge`), gunakan nama yang lebih deskriptif.
* **Risiko**: Ambigu untuk kode produksi; pakai hanya pada snippet pendek.
* **Contoh (Dart)**:

```dart
int add(int a, int b) {
  var val = a + b;
  return val;
}
```

**Penjelasan kata-per-kata**:

* `int` → tipe data integer untuk `add` dan parameter.
* `add` → nama fungsi (di sini contoh sederhana).
* `(int a, int b)` → parameter fungsi `a` dan `b` bertipe `int`.
* `{` `}` → blok fungsi.
* `var val = a + b;` → deklarasi variabel `val` hasil penjumlahan `a` dan `b`.
* `return val;` → kembalikan nilai `val`.

---

## 5. `num`, `sum`, `total`, `avg`, `count`

* **Arti / maksud**: Variabel numerik agregat—jumlah, rata-rata, penghitung.
* **Konteks**: Operasi aritmetika, statistik sederhana.
* **Variasi**: `acc` (accumulator), `cnt` (count).
* **Anjuran**: Gunakan nama yang menunjukkan unit/jenis agregasi (`total_cents`, `avg_ms`).
* **Risiko**: Tidak menyebut unit dapat menimbulkan kebingungan (mis. rupiah vs dolar, ms vs s).
* **Contoh (Python)**:

```python
numbers = [1, 2, 3]
total = sum(numbers)
count = len(numbers)
avg = total / count
```

**Penjelasan kata-per-kata**:

* `numbers` → variabel daftar angka.
* `=` → assignment.
* `[1, 2, 3]` → literal list.
* `total = sum(numbers)` → `sum()` menghitung jumlah elemen `numbers`.
* `count = len(numbers)` → `len()` mengembalikan jumlah elemen.
* `avg = total / count` → hitung rata-rata.

---

## 6. `result`, `res`, `out`, `output`, `return_value`

* **Arti / maksud**: Hasil dari fungsi/operasi.
* **Konteks**: Return value, output piping, hasil kalkulasi.
* **Variasi**: `retval`, `rv`.
* **Anjuran**: Jika fungsi memiliki makna domain, gunakan nama yang menjelaskan hasil (`user_profile`, `order_total`).
* **Risiko**: `res` ambigu saat kode besar; prefer deskriptif di production.
* **Contoh (JavaScript)**:

```javascript
function fetchData() {
  const res = { ok: true, data: [] };
  return res;
}
```

**Penjelasan kata-per-kata**:

* `function` → deklarasi fungsi.
* `fetchData()` → nama fungsi (indicative).
* `{ ok: true, data: [] }` → objek literal hasil.
* `const res = ...` → deklarasi konstanta `res`.
* `return res;` → kembalikan `res`.

---

## 7. `name`, `title`, `label`, `text`, `desc`, `description`

* **Arti / maksud**: Placeholder untuk teks identitas atau deskripsi.
* **Konteks**: UI, model data, dokumentasi.
* **Variasi**: `first_name`, `last_name`, `display_name`.
* **Anjuran**: Teliti kebutuhan lokalisa­si (i18n) — jangan hardcode teks yang perlu diterjemahkan.
* **Risiko**: Hardcoding data PII (mis. nama nyata) pada contoh publik. Gunakan `user@example.com` atau `example_user`.
* **Contoh (HTML/Dart/Flutter minimal)**:

```html
<label for="name">Name</label>
<input id="name" placeholder="Enter name" />
```

**Penjelasan kata-per-kata**:

* `<label for="name">` → elemen label, atribut `for` menunjuk `id` input.
* `Name` → teks label (contoh).
* `<input id="name" placeholder="Enter name" />` → field input dengan `id` `name` dan teks placeholder.

---

## 8. `input`, `stdin`, `stdin_data`, `argv`, `argc`, `args`

* **Arti / maksud**: Data masuk dari pengguna, file, atau baris perintah.
* **Konteks**: Program CLI, fungsi yang membaca input, testing.
* **Variasi**: `in_data`, `raw_input` (Python2), `process.argv` (Node.js).
* **Anjuran**: Validasikan input; jangan percaya input user.
* **Risiko**: Input yang tidak disanitasi → injection (command/SQL/XSS).
* **Contoh (Node.js)**:

```javascript
const args = process.argv.slice(2);
console.log(args);
```

**Penjelasan kata-per-kata**:

* `process.argv` → array argumen proses Node.js (index 0 adalah node, index 1 adalah script).
* `.slice(2)` → ambil argumen setelah poin 0 dan 1.
* `const args = ...` → simpan hasil ke `args`.
* `console.log(args)` → cetak `args`.

---

## 9. `example`, `sample`, `demo`, `test`, `dummy`, `fake`

* **Arti / maksud**: Menandai data non-produksi yang hanya untuk ilustrasi/testing.
* **Konteks**: Dokumentasi, fixtures, tutorial.
* **Variasi**: `example_user`, `sample_data`, `demo_account`.
* **Anjuran**: Gunakan contoh yang aman (mis. `user@example.com`, `example.com`) dan deterministic untuk tests.
* **Risiko**: Jangan gunakan password nyata; hindari contoh yang menyerupai PII nyata.
* **Contoh (YAML fixture)**:

```yaml
user:
  username: test_user
  email: user@example.com
  password: REPLACE_ME
```

**Penjelasan kata-per-kata**:

* `user:` → kunci objek user.
* `username: test_user` → nama login contoh.
* `email: user@example.com` → alamat email contoh (aman untuk dokumentasi).
* `password: REPLACE_ME` → placeholder yang menunjukkan harus diganti.

---

## 10. `REPLACE_ME`, `CHANGE_ME`, `TODO`, `FIXME`, `__REDACTED__`

* **Arti / maksud**: Penanda eksplisit bahwa nilai harus diganti atau tindakan diperlukan.
* **Konteks**: Konfigurasi, template, kode yang perlu finalisasi.
* **Variasi**: `@TODO`, `// TODO:` comment style.
* **Anjuran**: Pastikan CI/linter memblok commit yang meninggalkan tag ini di file sensitif.
* **Risiko**: Tinggal di repo → kebocoran konfigurasi/bug/security hole.
* **Contoh (config.ini)**:

```ini
secret_key = REPLACE_ME
database_url = CHANGE_ME
```

**Penjelasan kata-per-kata**:

* `secret_key` → kunci konfigurasi sensitif.
* `=` → assignment key-value.
* `REPLACE_ME` → placeholder yang harus diganti dengan nilai nyata di environment yang aman.

---

## 11. `file`, `filename`, `filepath`, `dir`, `dirname`, `basename`

* **Arti / maksud**: Placeholder untuk path atau nama file/direktori.
* **Konteks**: I/O file, path manipulations, contoh CLI.
* **Variasi**: `src`, `dst`, `dest`, `out_file`, `in_file`.
* **Anjuran**: Gunakan path relatif di contoh (mis. `./data/example.txt`) atau API path builder (`os.path.join`) untuk keberterimaan lintas OS.
* **Risiko**: Hardcode absolute path dapat merusak portability.
* **Contoh (Bash)**:

```bash
filename="./data/sample.txt"
cat "$filename"
```

**Penjelasan kata-per-kata**:

* `filename` → variabel menyimpan path file contoh.
* `=` → assignment.
* `"./data/sample.txt"` → path relatif ke file.
* `cat "$filename"` → perintah mencetak isi file; `"$filename"` mengekspansi variabel dengan proteksi spasi.

---

## 12. `password`, `pwd`, `pass_hash`, `salt`, `secret_key`

* **Arti / maksud**: Placeholder yang berkaitan dengan kredensial dan kunci.
* **Konteks**: Contoh autentikasi, dokumentasi enkripsi.
* **Variasi**: `API_KEY`, `JWT_SECRET`, `DB_PASSWORD`.
* **Anjuran**: Jangan simpan nilai nyata; gunakan `REPLACE_ME` atau secrets manager; tunjukkan praktik hashing (bcrypt/argon2) pada contoh.
* **Risiko**: Kebocoran → kompromi sistem. Sangat sensitif.
* **Contoh (pseudo-code)**:

```text
password = REPLACE_ME
hashed = bcrypt.hash(password)
```

**Penjelasan kata-per-kata**:

* `password` → nilai credential placeholder.
* `REPLACE_ME` → harus diganti oleh developer/ops dengan rahasia aman.
* `bcrypt.hash(password)` → contoh panggilan fungsi hashing password.

---

## 13. `example.com`, `example.org`, `test.example`, `localhost`, `127.0.0.1`

* **Arti / maksud**: Hostname domain contoh atau loopback.
* **Konteks**: Dokumentasi URL, contoh konfigurasi jaringan.
* **Variasi**: `dev.example.com`, `staging.example.com`.
* **Anjuran**: Gunakan domain `example.*` yang direservasi untuk dokumentasi (aman). Untuk lokal gunakan `localhost` / `127.0.0.1`.
* **Risiko**: Jangan gunakan domain nyata tanpa izin; hindari menyertakan API endpoints produksi di docs publik.
* **Contoh (URL)**:

```
https://api.example.com/v1/users
```

**Penjelasan kata-per-kata**:

* `https://` → protokol aman.
* `api.example.com` → host / subdomain contoh.
* `/v1/users` → path API versi 1 untuk resource `users`.

---

## 14. `env`, `ENV_VAR`, `PATH`, `HOME`, `TMPDIR`

* **Arti / maksud**: Lingkungan sistem / variabel environment yang sering dipakai.
* **Konteks**: Konfigurasi aplikasi, CI, container.
* **Variasi**: `DATABASE_URL`, `PORT`, `NODE_ENV`, `FLUTTER_ENV`.
* **Anjuran**: Simpan konfigurasi yang sensitif di environment variables; jangan commit `.env` dengan nilai nyata (gunakan `.env.example`).
* **Risiko**: Commit file env dengan secret → leak.
* **Contoh (Bash)**:

```bash
export DATABASE_URL="postgres://user:REPLACE_ME@localhost:5432/db"
echo $DATABASE_URL
```

**Penjelasan kata-per-kata**:

* `export` → set environment variable untuk subshell.
* `DATABASE_URL=...` → key-value connection string.
* `user:REPLACE_ME` → user dan placeholder password.
* `echo $DATABASE_URL` → cetak nilai environment variable.

---

## 15. `test_user`, `demo_user`, `admin`, `guest`, `root`

* **Arti / maksud**: Akun contoh/role yang sering muncul dalam dokumen dan fixtures.
* **Konteks**: Testing, demo, tutorial akses kontrol.
* **Variasi**: `service_account`, `ci_user`, `bot_user`.
* **Anjuran**: Gunakan nama yang tidak mewakili individu nyata; hindari memberi akses produksi pada akun demo.
* **Risiko**: Jika demo akun diberi akses tinggi di environment nyata → security risk.
* **Contoh (SQL seed)**:

```sql
INSERT INTO users(username, role) VALUES ('test_user', 'guest');
```

**Penjelasan kata-per-kata**:

* `INSERT INTO users(...)` → perintah tambah baris ke tabel `users`.
* `VALUES ('test_user', 'guest')` → nilai username dan role contoh.

---

### Catatan penutup untuk Bagian 1

* Bagian ini mencakup **placeholder paling dasar** yang wajib dikuasai oleh pelajar.
* Semua contoh di atas disusun ringkas supaya Anda bisa langsung pakai di tutorial, dokumentasi, atau tests.
* **Aturan praktis**: tiap placeholder yang sensitif harus diberi tag `REPLACE_ME` dan ada proses CI untuk mencegah kebocoran.

---

### 1.3 Placeholder untuk Struktur Data Dasar

Kategori ini mencakup nama-nama generik yang sering dipakai untuk: list, array, map, object key-value.

| Placeholder | Arti & Maksud           | Konteks Penggunaan                       | Variasi       | Risiko                |
| ----------- | ----------------------- | ---------------------------------------- | ------------- | --------------------- |
| list        | daftar urutan           | Struktur data yang menyimpan banyak item | list1, myList | Aman                  |
| arr         | array                   | Ketika jenis data adalah array           | arr1, arrData | Aman                  |
| vec         | vector (array dinamis)  | Bahasa C++, Rust                         | v, vect       | Aman                  |
| set         | himpunan unik           | Operasi logika/set theory                | uniqueSet     | Aman                  |
| map         | pasangan key-value      | struktur asosiatif                       | hashmap, dict | Aman                  |
| dict        | dictionary              | Python, data berpasangan                 | d, myDict     | Aman                  |
| obj         | object                  | Representasi entitas                     | o, myObj      | Aman                  |
| item        | elemen dalam koleksi    | Loop & akses                             | element, elem | Aman                  |
| node        | simpul dalam graph/tree | Data terhubung                           | n, nd         | Aman                  |
| key         | indeks seleksi          | Akses map/dict                           | k, lookupKey  | Waspada (bisa ambigu) |
| val/value   | nilai tersimpan         | Isi data                                 | v, val_       | Aman                  |

#### Catatan Profesional

* Meskipun populer, **use meaningful names** lebih diutamakan dalam produksi
* Exception: konteks sementara, contoh pengajaran, pseudo-code

#### Contoh dalam kode (Dart)

Saya jelaskan kata per kata sesuai permintaan Anda:

```
var numbers = [1, 2, 3, 4];
```

Penjelasan:

* `var` = deklarasi variabel dengan inferensi tipe otomatis
* `numbers` = nama placeholder mewakili array angka
* `=` = operator assignment ( memberikan nilai ke variabel )
* `[1, 2, 3, 4]` = literal array berisi elemen integer

Bantuan CLI Dart:

```
dart help
dart doc
dart analyze
```

---

### 1.4 Placeholder untuk Iterasi / Perulangan

Nama kecil satu huruf sering digunakan pada loop

| Placeholder | Arti             | Konteks               | Risiko |
| ----------- | ---------------- | --------------------- | ------ |
| i           | index            | Perulangan awal dasar | Aman   |
| j           | index kedua      | Nested loop           | Aman   |
| k           | index ketiga     | Nested lebih dalam    | Aman   |
| idx         | index deskriptif | Akses array           | Aman   |
| it          | iterator         | Iteration object      | Aman   |
| elem        | element          | Iterasi koleksi       | Aman   |
| pos         | position         | Penanda posisi        | Aman   |
| row / col   | baris/kolom      | Matriks               | Aman   |

Contoh dalam Bash:

```
for i in {1..5}; do echo $i; done
```

Penjelasan:

* `for i in {1..5};` = loop dari 1 hingga 5
* `do` = mulai blok perintah
* `echo $i` = tampilkan nilai index i
* `done` = akhir loop

Dapatkan bantuan:

```
help for
man bash
```

---

### 1.5 Placeholder untuk Input dan Output

Digunakan ketika data berasal dari pengguna atau proses lain.

| Placeholder | Arti                    | Konteks          |
| ----------- | ----------------------- | ---------------- |
| input       | data masuk              | CLI / UI         |
| output      | hasil data keluar       | CLI / file       |
| arg         | argument CLI            | PEMROGRAMAN CLI  |
| opts        | options (flag opsional) | Konfigurasi      |
| param       | parameter               | Fungsi           |
| msg/message | pesan text              | komunikasi / log |
| line        | satu baris              | parsing teks     |
| args[]      | daftar argumen          | banyak bahasa    |

Contoh Python:

```
name = input("Enter name: ")
print(name)
```

Penjelasan kata per kata:

* `name` = placeholder untuk input nama
* `=` assignment
* `input("Enter name: ")` = fungsi built-in, meminta data
* `print(name)` = tampilkan output

Bantuan CLI Python:

```
python3 -h
help(input)
```

---

### 1.6 Placeholder untuk Boolean dan Kondisi

Variabel penanda keadaan benar / salah

| Placeholder | Arti           | Keterangan        |
| ----------- | -------------- | ----------------- |
| flag        | penanda status | Boolean sederhana |
| toggle      | saklar         | On/Off            |
| isOk        | berhasil       | Konvensi boolean  |
| canDo       | hak / izin     | Izin operasi      |

Contoh C:

```
bool flag = true;
if (flag) { printf("OK"); }
```

---

### 1.7 Placeholder untuk Fungsi / Prosedur Generik

Fungsi pada tahap awal pembelajaran biasanya belum jelas tujuannya. Oleh karena itu, placeholder ini digunakan untuk menggambarkan suatu aksi secara umum.

| Placeholder | Arti / Maksud       | Konteks Penggunaan              | Risiko |
| ----------- | ------------------- | ------------------------------- | ------ |
| func        | fungsi generik      | Contoh awal konsep fungsi       | Aman   |
| doSomething | lakukan sesuatu     | Ketika operasi belum ditentukan | Aman   |
| run         | menjalankan aksi    | Pemanggilan prosedur            | Aman   |
| process     | memproses data      | Operasi pada input              | Aman   |
| handle      | menangani sesuatu   | Event / callback                | Aman   |
| compute     | menghitung nilai    | Algoritma numerik               | Aman   |
| main        | titik masuk program | Standar global                  | Aman   |
| init        | inisialisasi        | Setup program/objek             | Aman   |
| cleanup     | bersih-bersih akhir | Free resource                   | Aman   |

Contoh Dart:

```
void doSomething() {
  print("Doing...");
}
```

Penjelasan kata per kata:

* `void` = tipe pengembalian tanpa nilai
* `doSomething()` = nama placeholder fungsi
* `{ ... }` = blok kode
* `print("Doing...");` = mencetak string

Bantuan:

```
dart doc
dart analyze
```

---

### 1.8 Placeholder untuk Konsep OOP Dasar

Digunakan untuk representasi objek umum sebelum domain aplikasi jelas.

| Placeholder      | Arti / Maksud                | Konteks                    |
| ---------------- | ---------------------------- | -------------------------- |
| obj              | objek generik                | Pemula belajar OOP         |
| classA / classB  | dua kelas contoh             | Polimorfisme & inheritance |
| Base / Derived   | kelas dasar & turunan        | OOP klasik                 |
| entity           | objek penting                | Domain modelling           |
| item             | satu entitas                 | List items                 |
| person           | contoh objek kehidupan nyata | Pembelajaran               |
| animal, cat, dog | pewarisan OOP dasar          | Abstraksi sifat            |

Contoh Java:

```
class Animal {}
class Dog extends Animal {}
```

Penjelasan kata per kata:

* `class` = mendefinisikan kelas
* `Animal` = placeholder kelas induk
* `extends` = mewarisi properti dan method
* `Dog` = placeholder kelas turunan

Bantuan:

```
man javac
```

---

### 1.9 Placeholder untuk Error dan Exception

Nama untuk menandai kondisi kegagalan atau penanganan error.

| Placeholder | Arti                | Konteks              | Risiko                         |
| ----------- | ------------------- | -------------------- | ------------------------------ |
| err         | kesalahan           | Pesan error singkat  | Waspada (jangan di production) |
| error       | kesalahan umum      | Debug awal           | Aman                           |
| e           | exception           | Catches try/catch    | Aman                           |
| ex          | exception (variasi) | Debug menengah       | Aman                           |
| warning     | peringatan          | Logging              | Aman                           |
| fail        | status gagal        | Testing              | Aman                           |
| notFound    | tidak ditemukan     | File, user, resource | Aman                           |

Contoh Python:

```
try:
    risky()
except Exception as e:
    print(e)
```

Penjelasan:

* `try:` = blok yang berpotensi error
* `except Exception as e:` = tangkap semua exception
* `print(e)` = tampilkan pesan error

Bantuan:

```
help(Exception)
```

---

Bab ini telah mencakup seluruh placeholder klasik universal tingkat pemula:

1.1 Variabel generik
1.2 Angka dasar
1.3 Struktur data
1.4 Iterasi
1.5 Input/Output
1.6 Boolean & kondisi
1.7 Fungsi
1.8 OOP
1.9 Error handling

---

> - **[Selanjutnya][selanjutnya]**
> - **[Kurikulum][kurikulum]**
> - **[Home][domain]**

[domain]: ../../../../README.md
[kurikulum]: ../../README.md
[selanjutnya]: ../bagian-2/README.md

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
