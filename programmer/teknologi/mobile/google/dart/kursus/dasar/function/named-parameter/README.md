# Named Parameter

Penjelasan mendalam soal **named parameters** di Dart, gimana cara pakainya di Flutter, seberapa fleksibel fungsi dengan named parameters ini, plus contoh–contoh kasus umum pemakaiannya.

## 1. Apa itu Named Parameters di Dart?

- **Named parameters** memungkinkan kita mengirim argumen ke fungsi dengan menyebut nama parameter-nya, bukan hanya urutan posisi.
- Sintaksnya pakai `{}` di deklarasi fungsi:
  ```dart
  void greet({String name, int age}) {
    print('Halo, $name! Kamu $age tahun.');
  }
  ```
- Saat memanggil, tulis `greet(name: 'Budi', age: 20);`
- **Manfaat utamanya**:
  - Bikin kode lebih **jelas** (self-documenting): kita tahu apa makna tiap argumen.
  - Bisa **optional**: kamu nggak perlu kirim semua parameter kalau diberi default atau bertipe nullable.

---

## 2. Optional vs Required Named Parameters

### 2.1 Optional Named Parameters

- Tanpa anotasi tambahan, parameter di `{}` otomatis jadi optional dan nullable (sejak Dart 2.12 dengan null-safety, jika tipenya nullable).
- Kamu bisa beri **default value**:
  ```dart
  void greet({String name = 'Teman', int age = 0}) {
    print('Halo, $name! Usiamu $age.');
  }
  ```
- Panggilan `greet();` → “Halo, Teman! Usiamu 0.”

### 2.2 Required Named Parameters

- Untuk memastikan pemanggil wajib mengisi named parameter tertentu, pakai keyword `required`:
  ```dart
  void greet({ required String name, int age = 0 }) {
    print('Halo, $name! Usiamu $age.');
  }
  ```
- Kalau `greet();` → compile-time error.
- Sejak Dart 2.12, ini cara standar menggantikan anotasi `@required`.

---

## 3. Sejauh Apa Fungsi Named Parameters Dapat Digunakan?

1. **Konstruktur Widget**  
   Hampir semua widget Flutter—mulai `Text`, `Container`, hingga `CustomWidget`—pakai named parameters untuk properti.
2. **Callback & Event Handler**  
   Definisi fungsi callback dengan named parameters memudahkan pengguna widget memahami maksud tiap argumen.
3. **API Client / Helper**  
   Fungsi request HTTP sering punya banyak opsi (headers, queryParams, timeout): named parameters sangat cocok.
4. **Konfigurasi**  
   Saat fungsi butuh banyak opsi konfigurasi, named parameters menjaga signature tetap readable.

Intinya, kapan pun jumlah parameter >2 atau ada banyak opsi, **pertimbangkan** named parameters.

## 4. Contoh Penggunaan di Flutter

### 4.1 Contoh Konstruktur Widget

```dart
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final double borderRadius;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.color = Colors.blue,
    this.borderRadius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
```

Pemakaian:

```dart
CustomButton(
  label: 'Submit',
  onPressed: () => print('Diklik!'),
  color: Colors.green,
),
```

✓ Jelas: `label`, `onPressed`, `color` langsung tahu fungsinya.

### 4.2 Fungsi Helper dengan Banyak Opsi

```dart
Future<void> fetchData({
  required String url,
  Map<String, String>? headers,
  Map<String, dynamic>? queryParams,
  Duration timeout = const Duration(seconds: 10),
}) async {
  // implementasi HTTP request...
}
```

Panggilan:

```dart
await fetchData(
  url: 'https://api.example.com/data',
  queryParams: {'page': 1, 'limit': 20},
);
```

Kamu nggak usah repot urut-urutan: asal sebut nama param, lengkapilah yang perlu.

---

## 5. Contoh Kasus Umum Pemakaian Named Parameters

| Kasus                                        | Kenapa Pakai Named Params?                                 |
| -------------------------------------------- | ---------------------------------------------------------- |
| Widget dengan banyak properti                | Biar kode UI mudah dibaca dan di-maintain                  |
| Fungsi networking / API client               | Banyak opsi (headers, body, timeout) → jelas dan fleksibel |
| Utility function dengan konfigurasi opsional | Default value, optional → lebih ringkas saat pemakaian     |
| Callback / Event handler custom              | Memudahkan developer lain memahami apa yang mereka terima  |

---

## 6. Tips & Best Practices

- **Jangan berlebihan**: kalau fungsi cuma 1–2 parameter wajib, positional parameter (`()` tanpa `{}`) kadang lebih ringkas.
- **Berikan default** bila masuk akal, untuk mengurangi boilerplate.
- **Gunakan `required`** agar compiler membantu cegah bug karena lupa mengisi argumen penting.
- **Dokumentasikan** di doc comment `///` tiap named parameter, supaya muncul di quick help IDE.

---

Semoga membantu! 🎉  
Dengan named parameters, kode Dart/Flutter kamu bakal lebih **terstruktur**, **jelas**, dan **mudah dikembangkan** ke depan. Jangan ragu eksperimen bikin helper atau widget baru pakai trik ini! 🚀

> GPT-o4

**[source code](named_parameter.dart)**

```dart
void namedParameter({name, age}) {
  print("Named Parameter");
  print("Name: $name");
  print("Age: $age");
}

var garis = '-' * 20;
void main() {
  print('\n' * 5);

  namedParameter(name: "John", age: 30);
  print(garis);

  namedParameter(age: 25, name: "Doe");
  print(garis);

  namedParameter(name: "Alice");
  print(garis);

  namedParameter(age: 22);
  print('\n' * 5);
}
```
