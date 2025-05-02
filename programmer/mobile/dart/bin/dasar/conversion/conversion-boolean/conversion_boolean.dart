void main() {
  print('\n' * 5);

  bool inputBool = false;
  String inputString = inputBool.toString();

  print("$inputBool$inputString");

  String stringToBool = 'true';
  bool contains = stringToBool.contains('true');
  String boolToString = contains.toString();

  print(
    "$stringToBool"
    "$contains"
    "$boolToString",
  );

  String str = "oke";
  bool value = str.toLowerCase() == 'GOOGLE';
  print("$value");

  print('-' * 10);

  bool parseBoolean(String value) {
    return value.toLowerCase().contains('true');
  }

  print(parseBoolean('true'));

  print('-' * 10);

  String string = 'dart is awesome';

  if (string.contains('dart is awesome')) {
    print('String contains true');
  } else {
    print('String does not contain true');
  }

  print(string);

  print('\n' * 5);
}
