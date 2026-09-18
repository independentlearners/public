# Pengaruh Fungsi Di Bash

### > Apakah setiap [fungsi di bash mempengaruhi exit status][0] meskipun fungsi tersebut tidak ada kaitannya dengan logika pada baris tersebut

Ya, tetapi perlu dibedakan antara **fungsi yang didefinisikan** dan **fungsi yang dipanggil**.

Dalam Bash, **mendefinisikan fungsi tidak memengaruhi exit status** dari perintah/baris lain. Namun, **ketika fungsi dipanggil, fungsi tersebut menghasilkan exit status**, dan status itu dapat menjadi exit status dari command yang memanggilnya.

Contoh:

```bash
#!/usr/bin/env bash

foo() {
    echo "Halo"
}

echo "Sebelum"
foo
echo "Sesudah"
```

`foo` tidak secara eksplisit melakukan `return`, sehingga exit status fungsi adalah **exit status dari perintah terakhir yang dieksekusi di dalam fungsi**:

```bash
foo() {
    echo "Halo"
}
```

`echo "Halo"` berhasil → status `0`.

Jadi:

```bash
foo
echo $?
```

menghasilkan:

```text
Halo
0
```

Yang penting adalah hubungan ini:

```text
command
   │
   └── memanggil fungsi
             │
             └── fungsi menjalankan beberapa command
                         │
                         └── command terakhir
                                  │
                                  └── exit status fungsi
```

Misalnya:

```bash
foo() {
    echo "Halo"
    false
}
```

Kemudian:

```bash
foo
echo $?
```

hasilnya:

```text
Halo
1
```

Karena `false` adalah command terakhir dalam fungsi.

---

### Lalu bagaimana dengan `set -e`?

Ini menjadi sangat penting dengan konfigurasi yang sedang kamu pelajari:

```bash
set -euo pipefail
```

`set -e` membuat Bash memperlakukan exit status non-zero tertentu sebagai kondisi untuk menghentikan script.

Misalnya:

```bash
foo() {
    echo "Halo"
    false
    echo "Selesai"
}

foo
echo "Program selesai"
```

Karena `false` menghasilkan `1`, Bash dapat menghentikan eksekusi sebelum:

```bash
echo "Selesai"
```

dan:

```bash
echo "Program selesai"
```

Namun ada pengecualian penting: **`set -e` tidak berarti "setiap command yang menghasilkan non-zero selalu langsung menghentikan script."** Konteks command sangat menentukan.

Contohnya:

```bash
if foo; then
    echo "berhasil"
fi
```

Jika `foo` menghasilkan non-zero, `set -e` tidak otomatis menghentikan script hanya karena fungsi tersebut gagal, karena fungsi berada dalam konteks kondisi `if`.

---

### Pertanyaan inti kamu: "fungsi yang tidak ada kaitannya dengan logika baris tersebut?"

Misalnya:

```bash
set -e

hitung() {
    false
}

echo "Halo"
```

Di sini `hitung` **tidak pernah dipanggil**.

Maka:

```text
hitung() { ... }
       │
       └── hanya definisi
             ↓
        tidak dieksekusi
             ↓
        tidak memengaruhi
        exit status
```

Tetapi:

```bash
hitung

echo "Halo"
```

berbeda. Fungsi benar-benar dieksekusi, sehingga exit statusnya menjadi bagian dari alur eksekusi.

---

Ada satu konsep yang sangat penting untuk kamu pahami:

```bash
foo
bar
```

Bukan berarti exit status `foo` terus "menempel" dan memengaruhi `bar`.

Setiap command memiliki exit statusnya sendiri.

```bash
foo        # exit status foo
bar        # exit status bar
```

Setelah `bar` selesai:

```bash
echo $?
```

akan mengambil **exit status `bar`**, bukan `foo`.

Contoh:

```bash
false
true

echo $?
```

hasil:

```text
0
```

Walaupun `false` menghasilkan `1`, `true` kemudian menghasilkan `0`, sehingga `$?` menjadi `0`.

Jadi model mental yang tepat adalah:

```text
                EXIT STATUS
                     │
                     ▼
        command yang BARU SELESAI
                     │
                     ▼
                    $?
```

Bukan:

```text
false → status 1
          │
          └── terus memengaruhi command berikutnya ❌
```

Melainkan:

```text
false → 1
         ↓
      digantikan
         ↓
true → 0
         ↓
       $? = 0
```

**Kesimpulan:** fungsi Bash tidak memiliki pengaruh global hanya karena fungsi itu ada. **Fungsi yang dipanggil menghasilkan exit status**, dan exit status tersebut dapat memengaruhi alur script—terutama ketika menggunakan `set -e`. Yang menentukan adalah **kapan fungsi dipanggil dan dalam konteks apa fungsi tersebut dipanggil**.

Untuk pembelajaran Bash-mu, konsep berikutnya yang sangat penting adalah **"fungsi mewarisi status command terakhir" vs `return` vs `set -e`**, karena tiga hal ini sering terlihat sama tetapi perilakunya berbeda.
