# **short-circuiting** 

## **Definisi**

**Short-circuiting** adalah *mekanisme evaluasi logika* di mana suatu ekspresi logika **berhenti dievaluasi lebih awal** begitu hasilnya sudah bisa ditentukan, tanpa memeriksa sisa operasinya.

---

## **Bagaimana cara kerjanya**

Ini biasanya berlaku di **operator logika** seperti:

| Operator | Nama resmi          | Perilaku short-circuit                                             |
| -------- | ------------------- | ------------------------------------------------------------------ |
| `&&`     | AND (*logical AND*) | Jika operand pertama **false**, operand kedua **tidak dievaluasi** |
| `\|\|`    | OR (*logical OR*)   | Jika operand pertama **true**, operand kedua **tidak dievaluasi**  |

---

## **Contoh umum**

### 1. **Di Bash**

```bash
# AND short-circuit
[ -f file.txt ] && echo "File ada"
# Jika file.txt tidak ada → echo tidak dijalankan

# OR short-circuit
[ -f file.txt ] || echo "File tidak ada"
# Jika file.txt ada → echo tidak dijalankan
```

---

### 2. **Di Dart / JavaScript**

```dart
bool checkA() {
  print('checkA called');
  return false;
}

bool checkB() {
  print('checkB called');
  return true;
}

void main() {
  print(checkA() && checkB()); // checkB tidak dipanggil
  print(checkA() || checkB()); // checkB dipanggil (karena perlu hasil)
}
```

---

### 3. **Di PowerShell**

```powershell
($false -and (Write-Host "Hello")) # "Hello" tidak muncul
($true -or  (Write-Host "Hello"))  # "Hello" tidak muncul
```

---

## **Kapan berguna**

* **Efisiensi** → Menghindari evaluasi atau eksekusi yang tidak perlu.
* **Pengaman** (*guard clauses*) → Mencegah error.

  Contoh Bash:

  ```bash
  [ -f "$config" ] && source "$config"
  # Hanya source kalau file ada
  ```

  Contoh Dart:

  ```dart
  user != null && user.isLoggedIn
  // Hindari NullPointerException
  ```

---

## **Poin penting**

* Short-circuiting bukan cuma soal “cepat berhenti”, tapi juga **kontrol alur logika**.
* Kalau di shell scripting, sering dipakai sebagai *one-liner condition*.
* Kalau di bahasa terkompilasi, sering dimanfaatkan untuk *null-check*.

## **Tabel Perbandingan Short-Circuiting**

| Bahasa / Shell | Operator | Nama Resmi  | Perilaku Short-Circuit                                      | Contoh Kode                            | Hasil & Penjelasan                        |
| -------------- | -------- | ----------- | ----------------------------------------------------------- | ---------------------------------------|------------------------------------------ |
| **Bash**       | `&&`     | Logical AND | Jika kiri `false` → kanan tidak dievaluasi                  | `[ -f file.txt ] && echo "Ada"`        | `echo` hanya jalan kalau file ada         |
|                | `\|\|`    | Logical OR  | Jika kiri `true` → kanan tidak dievaluasi                  | `[ -f file.txt ] \|\| echo "Tidak ada"`| `echo` hanya jalan kalau file tidak ada   |
| **Zsh**        | `&&`     | Logical AND | Sama seperti bash                                           | `[ -n "$var" ] && echo "Var diisi"`    | Cek isi var sebelum print                 |
|                | `\|\|`    | Logical OR  | Sama seperti bash                                          | `[ -n "\$var" ] \|\| echo "Var kosong"`| Print hanya kalau kosong                  |
| **PowerShell** | `-and`   | Logical AND | Jika kiri `$false` → kanan tidak dievaluasi                 | `$false -and (Write-Host "Run")`       | `"Run"` tidak tampil                      |
|                | `-or`    | Logical OR  | Jika kiri `$true` → kanan tidak dievaluasi                  | `$true -or (Write-Host "Run")`         | `"Run"` tidak tampil                      |
| **Dart**       | `&&`     | Logical AND | Jika kiri `false` → kanan tidak dievaluasi                  | `false && print("Run")`                | Tidak print sama sekali                   |
|                | `\|\|`    | Logical OR  | Jika kiri `true` → kanan tidak dievaluasi                  | `true \|\| print("Run")`               | Tidak print sama sekali                   |
| **Lua**        | `and`    | Logical AND | Jika kiri `false`/`nil` → return kiri, tidak evaluasi kanan | `false and print("Run")`               | Tidak print, hasil `false`                |
|                | `or`     | Logical OR  | Jika kiri truthy → return kiri, tidak evaluasi kanan        | `true or print("Run")`                 | Tidak print, hasil `true`                 |

---

## **Catatan Lintas Bahasa**

1. **Nilai return berbeda-beda**:

   * Bash/zsh → Hasilnya status exit code (`0` sukses, `1` gagal) bukan boolean murni.
   * Dart → Hasilnya boolean `true`/`false`.
   * Lua → Mengembalikan *operand* yang berhenti evaluasi, bukan boolean murni.
   * PowerShell → Boolean murni `$true`/`$false`.

2. **Side-effect dicegah**:
   Eksekusi fungsi atau perintah di sisi kanan akan dilewati jika short-circuit terpenuhi.

3. **Perbedaan keyword**:

   * Bash/zsh/Dart → pakai simbol (`&&`, `||`).
   * PowerShell → pakai keyword (`-and`, `-or`).
   * Lua → pakai keyword (`and`, `or`).

4. **Null-check umum**:

   * Dart:

     ```dart
     user != null && user.isLoggedIn
     ```
   * Lua:

     ```lua
     user and user.loggedIn
     ```
   * Bash:

     ```bash
     [ -n "$user" ] && echo "Logged in"
     ```

---
