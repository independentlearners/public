# Saran Mental Logika Prmrograman

Untuk membangun pondasi OOP yang kuat di Dart, perhatikan saran urutan mental berikut.

```
Data
 │
 ▼
Field (State)
 │
 ▼
Getter / Setter
 │
 ▼
Method (Behavior)
 │
 ▼
Object
 │
 ▼
Interaksi antar Object
 │
 ▼
Abstraction
 │
 ▼
Inheritance
 │
 ▼
Interface / Implements
 │
 ▼
Mixin
 │
 ▼
Composition
 │
 ▼
Design Pattern
```

Namun yang lebih penting daripada urutan materi adalah **cara berpikir** setiap kali melihat sebuah kelas.

Misalnya ketika melihat:

```dart
class BankAccount {
  double _balance = 0;

  double get balance => _balance;

  void deposit(double amount) {
    _balance += amount;
  }
}
```

Jangan langsung membaca sintaksnya. Biasakan bertanya:

1. **Apa state dari objek ini?**

   * `_balance`

2. **Siapa yang boleh membaca state?**

   * Getter `balance`

3. **Siapa yang boleh mengubah state?**

   * Method `deposit()`

4. **Mengapa tidak langsung membuat `balance` menjadi public?**

   * Agar perubahan state dapat dikontrol dan divalidasi.

5. **Apakah objek ini memiliki satu tanggung jawab?**

   * Ya, mengelola saldo rekening.

Dengan latihan seperti ini, Anda sedang melatih pola pikir seorang software engineer.

---

## **Saran menavigasi aliran data dengan baik**

Contoh sederhana:

```
main()
 │
 │ membuat
 ▼
BankAccount
 │
 │ deposit(100)
 ▼
_balance berubah
 │
 │ balance
 ▼
getter membaca
 │
 ▼
print()
```

Lama-kelamaan, Anda akan mampu membayangkan aliran data bahkan tanpa menjalankan program.

---

Disrankan untuk membedakan tiga hal berikut dalam setiap kelas yang Anda buat.

```
State
└── data yang dimiliki objek
    contoh:
    name
    age
    balance

Behavior
└── apa yang dapat dilakukan objek
    contoh:
    login()
    deposit()
    move()

Identity
└── objek mana yang sedang bekerja
    contoh:
    user1
    user2
    accountA
```

Banyak pemula mencampur ketiganya sehingga kelas menjadi sulit dipelihara.

---

Menurut saya, sebelum beralih ke inheritance atau mixin, ada beberapa konsep yang sebaiknya benar-benar dikuasai karena akan menjadi fondasi hampir semua kode Dart dan Flutter:

1. Field dan lifecycle objek.
2. Constructor dan proses inisialisasi.
3. Getter dan setter.
4. Method dan parameter.
5. `this`.
6. Enkapsulasi (`_private`).
7. Referensi objek (memahami bahwa variabel menyimpan referensi, bukan menyalin objek).
8. Static member.
9. Composition (objek di dalam objek).

Jika sembilan konsep ini benar-benar dipahami, maka materi seperti inheritance, mixin, extension, hingga widget Flutter akan terasa jauh lebih alami.

