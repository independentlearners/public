void main() {
  print('\n' * 5);

  // ignore: unused_local_variable
  int number1;
  int? number2;

  print(
    //'$number1' // $ aktifkan untuk membuat Error
    '$number2',
  );

  print('\n' * 5);
}
