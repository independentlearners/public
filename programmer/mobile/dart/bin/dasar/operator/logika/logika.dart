// # Operator logika dalam dart adalah operator yang digunakan untuk melakukan operasi logika seperti AND, OR, dan NOT. Untuk melakukan operasi logika, kita dapat menggunakan operator && (AND), || (OR), dan ! (NOT). Operator logika mengembalikan nilai boolean, yaitu true atau false. Untuk info lebih lanjut tentang operator logika, silahkan kunjungi: https://dart.dev/guides/language/language-tour#logical-operators

void main() {
  var nilaiAkhir = 80;
  var nilaiAbsen = 50;

  var nilaiAkhirBagus = nilaiAkhir >= 75;
  var nilaiAbsenBagus = nilaiAbsen >= 75;

  print(nilaiAkhirBagus);
  print(nilaiAbsenBagus);

  var lulus = nilaiAkhirBagus && nilaiAbsenBagus;
  print(lulus);

  lulus = nilaiAkhirBagus || nilaiAbsenBagus;
  print(lulus);
  print(!true);
  print(!false);

  print('=' * 5 + '\n');

  print('AND');
  print(true && true); // true
  print(true && false); // false

  // ignore: dead_code
  print(false && true); // false
  // ignore: dead_code
  print(false && false); // false

  // OR
  print('OR');

  // ignore: dead_code
  print(true || true); // true

  // ignore: dead_code
  print(true || false); // true

  print(false || true); // true
  print(false || false); // false

  // NOT
  print('NOT');
  print(!true); // false
  print(!false); // true

  // Operator AND dan OR juga bisa digunakan untuk mengecek nilai null
  print('Operator AND dan OR juga bisa digunakan untuk mengecek nilai null');
}
