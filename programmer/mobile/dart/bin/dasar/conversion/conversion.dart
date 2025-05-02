void main() {
  print('\n' * 5);

  // ^ Berikut adalah konversi tipe data yang implisit:
  String inputString = '1000';
  print(inputString);

  var inputInt = int.parse(inputString);
  print(inputInt);

  var inputDouble = double.parse(inputString);
  print(inputDouble);

  var inputStringInt = inputInt.toString();
  print(inputStringInt);

  print('\n' * 1);
  print('=' * 10);
  print('\n' * 1);

  // ^ Contoh Konversi Tipe Data secara eksplisit
  int intToDouble = 1000;
  print(intToDouble);

  double angkaDouble = intToDouble.toDouble();
  print(angkaDouble);

  int doubleToInt = angkaDouble.toInt();
  print(doubleToInt);

  String angkaString = doubleToInt.toString();
  print(angkaString);

  print('\n' * 5);
}
