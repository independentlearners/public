String flutter = "framework flutter";
String dart = 'dart dan $flutter';
String google = "deikembangkan oleh google";
String bahasa = 'bahasa pemrograman ${dart + google}';

void main() {
  print('\n' * 5);

  print(google);
  print(dart);
  print(flutter);
  print(bahasa);

  print('\n' * 5);
}
