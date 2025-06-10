void main() {
  print('\n' * 5);

  // # penggunaan untuk List yang menyediakan Indext
  var string = <String>['Amirkulal', 'A-Qurthubi', 'Averroez'];

  for (var i in string) {
    print(i);
  }

  print('=' * 10);

  // # penggunaan untuk Sets yang tidak menyediakan indext
  var set = <String>{'Malang', 'A-Indonesia', 'Nusantara'};

  for (var i in set) {
    print(i);
  }

  print('\n' * 5);
}
