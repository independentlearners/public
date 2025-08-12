# **Pattern Matching**

## **Definisi**

**Pattern matching** adalah proses mencocokkan data (string, angka, struktur, dll.) terhadap suatu *pola* yang didefinisikan oleh aturan tertentu.

* Polanya bisa sederhana (*wildcard*, literal string) atau kompleks (regex, destructuring pattern).
* Bisa dilakukan oleh **shell**, **bahasa pemrograman**, atau **tool**.

> Intinya: pattern matching adalah konsep umum.
> Globbing adalah *salah satu* bentuk pattern matching yang dilakukan shell untuk nama file.

---

## **Jenis Pattern Matching Berdasarkan Konteks**

| Jenis                            | Contoh Bahasa/Alat                                      | Pola               | Lingkup                                               |
| -------------------------------- | ------------------------------------------------------- | ------------------ | ----------------------------------------------------- |
| **String matching sederhana**    | `case` di bash/zsh, `switch` di Dart/Lua                | `*.txt`, `foo?bar` | Mencocokkan teks terhadap pola wildcard               |
| **Globbing (filename matching)** | bash/zsh, PowerShell                                    | `*`, `?`, `[a-z]`  | Mencari file yang cocok di filesystem                 |
| **Regex (regular expression)**   | grep, sed, Dart `RegExp`, Lua `string.match`            | `^foo.*bar$`       | Mencocokkan pola teks kompleks                        |
| **Structural pattern matching**  | Python `match/case`, Dart `switch` dengan destructuring | `case [x, y]:`     | Mencocokkan bentuk/struktur data                      |
| **Wildcard PowerShell**          | PowerShell cmdlet                                       | `*.ps1`            | Mirip globbing tapi dijalankan di cmdlet, bukan shell |

---

## **Contoh Pattern Matching di Berbagai Bahasa**

### 1. **Bash / Zsh (case statement)**

```bash
case "$filename" in
  *.txt) echo "Teks file" ;;
  *.jpg|*.png) echo "Gambar" ;;
  *) echo "Lainnya" ;;
esac
```

> Ini **pattern matching**, tapi bukan globbing — walau sintaks polanya mirip.

---

### 2. **PowerShell**

```powershell
if ("report.txt" -like "*.txt") {
    "Ini file teks"
}
```

> Operator `-like` menggunakan wildcard pattern `.NET`.

---

### 3. **Dart**

```dart
void check(var value) {
  switch (value) {
    case int n when n > 0:
      print("Positif");
    case String s when s.endsWith('.txt'):
      print("Teks file");
    default:
      print("Tidak cocok");
  }
}
```

> Dart 3+ mendukung **pattern matching** dalam `switch`.

---

### 4. **Lua**

```lua
if string.match("report.txt", "%.txt$") then
    print("File teks")
end
```

> Di Lua, pattern matching dilakukan lewat fungsi seperti `string.match`, tapi polanya **bukan regex full**, melainkan *Lua patterns*.

---

## **Pattern Matching vs Globbing vs Regex**

| Fitur                     | Pattern Matching                | Globbing                          | Regex                                  |
| ------------------------- | ------------------------------- | --------------------------------- | -------------------------------------- |
| Konsep umum               | ✅                               | ❌ (hanya subset khusus file)      | ❌ (subset untuk teks)                  |
| Matching file             | Bisa (jika implementasi dukung) | ✅                                 | Bisa (di program)                      |
| Simbol wildcard sederhana | ✅                               | ✅                                 | Tidak (regex punya sintaks sendiri)    |
| Kompleksitas              | Bervariasi                      | Rendah                            | Tinggi                                 |
| Lingkup eksekusi          | Di bahasa, shell, atau tool     | Di shell sebelum eksekusi command | Di program yang mendukung regex engine |

---

## **Hubungan dengan Short-Circuiting**

Pattern matching sering dipakai bersama short-circuit untuk *guard checks*:

```bash
[[ "$file" == *.txt ]] && echo "File teks"
```

→ Jika pola cocok (`true`), jalankan perintah kanan; jika tidak, perintah kanan dilewati.

---

## **Tabel Perbandingan Pattern Matching**

| Bahasa / Shell | Fitur Pattern Matching                                | Operator / Keyword                         | Tipe Pola                            | Contoh                                   | Hasil & Catatan                                                           |
| -------------- | ----------------------------------------------------- | ------------------------------------------ | ------------------------------------ | ---------------------------------------- | ------------------------------------------------------------------------- |
| **Bash**       | Wildcard pattern dalam `[[ ]]`, `case`                | `[[ string == pattern ]]` / `case`         | Wildcard (`*`, `?`, `[ ]`)           | `[[ "a.txt" == *.txt ]]`                 | `true` jika string cocok pola, mirip globbing tapi tidak akses filesystem |
| **Zsh**        | Sama seperti Bash + **extended pattern**              | `[[ string == pattern ]]` / `case`         | Wildcard & extended (`^`, `~`)       | `[[ foo != ^bar* ]]`                     | Cocokkan string, bisa negasi pattern dengan `^`                           |
| **PowerShell** | Wildcard matching berbasis .NET                       | `-like`, `-notlike`, `-match`, `-notmatch` | Wildcard (`*`, `?`, `[ ]`) dan Regex | `"data.txt" -like "*.txt"`               | `true` jika cocok wildcard, `-match` untuk regex                          |
| **Dart**       | Pattern matching (Dart 3+) dalam `switch` / `if-case` | `switch`, `case`, `when`                   | Literal, destructuring, guard clause | `case String s when s.endsWith('.txt'):` | Bisa cocokkan tipe data & kondisi tambahan                                |
| **Lua**        | String pattern matching                               | `string.match`, `string.find`              | *Lua patterns* (`%d`, `%a`, `.`)     | `string.match("data.txt", "%.txt$")`     | Bukan regex full, `%` digunakan untuk escape                              |

---

## **Contoh Implementasi Tiap Bahasa**

### **Bash**

```bash
file="report.txt"
if [[ $file == *.txt ]]; then
    echo "File teks"
fi
```

### **Zsh (extendedglob)**

```zsh
setopt extendedglob
[[ $file == ^(*.jpg|*.png) ]] && echo "Bukan gambar"
```

### **PowerShell**

```powershell
if ("report.txt" -like "*.txt") {
    "File teks"
}
```

### **Dart**

```dart
void main() {
  var file = "report.txt";
  switch (file) {
    case String s when s.endsWith(".txt"):
      print("File teks");
    default:
      print("Bukan teks");
  }
}
```

### **Lua**

```lua
local file = "report.txt"
if string.match(file, "%.txt$") then
    print("File teks")
end
```

---

## **Perbedaan Penting**

| Aspek     | Bash / Zsh                        | PowerShell            | Dart                           | Lua                         |
| --------- | --------------------------------- | --------------------- | ------------------------------ | --------------------------- |
| Target    | String literal                    | String literal        | String, tipe data, struktur    | String literal              |
| Tipe pola | Wildcard shell                    | Wildcard .NET / Regex | Literal / tipe / destructuring | Lua pattern syntax          |
| Lingkup   | Di shell (tidak akses filesystem) | Di cmdlet             | Di bahasa langsung             | Fungsi `string`             |
| Regex     | ❌ (butuh `=~`)                    | ✅ (`-match`)          | ✅ (pakai `RegExp`)             | Terbatas (bukan regex full) |

---
