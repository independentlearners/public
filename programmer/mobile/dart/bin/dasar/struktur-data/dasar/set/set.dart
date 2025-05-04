// % Sets (Himpunan)
// # Set Dalam dart, "set" adalah istilah yang digunakan untuk menyatakan bagian dari permainan yang lebih besar, biasanya terdiri dari beberapa leg. Sebuah set biasanya dimainkan dalam format best of (terbaik dari), misalnya, best of 5 legs berarti pemain pertama yang memenangkan 3 legs akan memenangkan set tersebut. Set sering digunakan dalam pertandingan dart yang lebih panjang untuk membantu menjaga permainan tetap terstruktur dan menarik. Jadi, intinya, set adalah unit yang lebih besar yang terdiri dari beberapa leg.
void main() {
  print('\n' * 5);

  // ^ Membuat Set kosong
  Set<String> string = {};

  var booll = <bool>{}; // $ tanpa tipe data akan menjadi Dynamic

  var set = {'String', 123, false, 12.3};

  print(
    '$string\n'
    '$booll'
    '${set.length}\n',
  );

  string.add(' Amirzain');
  string.add('Malang' ' Jawa Timur');
  string.add('Indonesia ');

  booll.add(false);

  print(
    '$string\n'
    '$booll\n'
    '$set'
    '${set.add(string is Set)}'
    '${booll.add(booll is bool)}'
    '${booll.add(string is int)}'
    '${set.remove('String')}'
    '${set.remove('Tidak ada')}',
  );

  print('\n' * 5);
}
