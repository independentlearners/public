// % contoh satu
class Constructor {
  String a = 'Guest';
  String? b;
  final String c = 'Diplomat';

  Constructor(String aa, String bb);
}

// % contoh dua
class ConstructorDua {
  String a1 = 'Orang';
  String? b1;
  final String c1 = 'Indonesia';

  ConstructorDua(String a2, String? b2, String c2) {
    String a3 = a2;
    print(a3);
    a2 = a1;
    print(a2);
  }
}

dynamic batas = '\n' * 1 + '=' * 10 + '\n' * 1;
void main() {
  print('\n' * 5);

  // %  di deklarasikan menggunakan konsep polymorphism
  var aaa;

  aaa = Constructor('quantity', 'construktor');
  print('${aaa.a}\n' '${aaa.b}\n' '${aaa.c}');
  print('\n$aaa');
  print(batas);

  // ! mencetak dengan cara "print(garis + aaa);" atau "print(garis + (aaa));" atau "print(aaa + (garis));" mungkin tidak menemukan error exception atau sejenisnya yang lebih ringan dalam editor compiler, namun itu dapat menyebabkan pesan muncul di consol: "Unhandled exception"

  aaa = ConstructorDua('kedua', 'lagi', 'ini final');
  print(batas);
  print('\n' * 5);
}
