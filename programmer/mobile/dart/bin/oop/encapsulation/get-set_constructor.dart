// # jika terdapat construstor, maka setiap field standart yang tidak diinisialisasi sebagai parameter dari constructor tersebut wajib di tembahkan kata kunci "late", kecuali field tersebut dimasukan kedalam parameter constructor tersebut, jika tidak maka akan menunjukan error exception. Setelah ditambahkan "late", maka kita bebas mau menambhkan nilainya kapan saja

// # field standart yaitu field yang tidak bertipe "final" atau "const"

class GetSetConstructor {
  int _i;
  late int _f;
  final int _g; // $ menjadikan tipe data null adalah option!
  static const int h = 3; // $ menambahkan const, wajib static

  // ignore: unnecessary_getters_setters
  int get i => _i;
  set i(int value) {
    _i = value;
  }

  // ignore: unnecessary_getters_setters
  int get f => _f;
  set f(int value) {
    _f = value;
  }

  int? get g => _g; // $ jika parent field dideklarasikan sebagai "nul", get wajib null?
  set g(int? value) {
    g = value;
    if (g case 0) {
      print('object');
    } else if (value == int) {
      print('oke');
    } else {
      return;
      print('no action!');
    }
  }

  GetSetConstructor(this._i, this._f, this._g);
}

String batas = '\n' * 5;
void main() {
  print(batas);

  var c = GetSetConstructor(1, 2, 5);
  c.i = 2;
  print(c.i);

  c.f = 2;
  print(c.f);

  c.g = 500;
  print(c.g);

  print(batas);
}
/*

 $ Getter dan Setter dalam bahasa pemrograman Dart adalah metode yang digunakan untuk mengakses (get) dan mengubah (set) nilai dari variabel (field) dalam suatu kelas.

 $ Getter:
 Getter adalah metode yang digunakan untuk mendapatkan nilai dari variabel. Metode ini biasanya digunakan untuk membuat variabel bersifat read-only(hanya baca) dari luar kelas atau untuk menambahkan logika saat mendapatkan nilai.



 */
