// # Untuk menyimpan hasil dari fungsi ke dalam variabel, fungsi tersebut perlu mengembalikan nilai. Jadi, jika fungsi awalnya bertipe void (tidak mengembalikan nilai), Maka harus menggantinya dengan tipe data yang sesuai dengan nilai yang ingin dikembalikan, misalnya String, int, double, dll. Wajib diperhatikan dalam hal ini, bahwa hanya bisa mengembalikan satu tipe data saja dan tidak bisa melebihi dari satu.

// % contoh sederhana
String sayHello() => 'Konsep Function Return Value';

// % contoh kompleks dimana variable disini menghitung total data yang ada di dalam List
int sum(List<int> number) {
  var total = 0;

  for (var value in number) {
    total += value;
  }

  return total;
}

void main() {
  print(
    '\n' * 5,
  );

  // $ Panggil fungsi sayHello dan simpan hasilnya ke dalam variabel
  var fangsion = sayHello();
  print(fangsion); // $ Cetak nilai yang dikembalikan oleh fungsi sayHello

  print(
    '\n' * 1 + '=' * 10 + '\n' * 1,
  );

  // $ bisa dicetak dengan cara seperti ini
  var a = sum([10, 101, 10, 10]);
  print(a);
  // $ atau seperti ini
  print(sum([10, 10, 10, 10]));

  print(
    '\n' * 5,
  );
}
