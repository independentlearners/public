```dart
String batas = '\n' * 5;
String garis = '=' * 5;

class Computer {
  String name = 'Qubit';
  String? address;
  final String country = 'Indonesia';

  startup(String paramName) => ('Hello $paramName, thi name is $name');

  void shutdown(String paramAddress) => print('from $paramAddress, technology $address');

  String getOperatingSystem(String paramCountry) =>
      'in $paramCountry, technology $country';
}

// % membuat method extension
extension System on Computer {
  void system(String paramName) => print('this system on $paramName');
}

void main() {
  print(batas);

  var computer = Computer();

  // % memanggil method dalam class
  print(computer.startup('World'));
  print(garis);

  computer.shutdown('Qubit');
  print(garis);

  print(computer.getOperatingSystem('System'));
  print(garis);

  // % memanggil method extension
  print(computer.startup('linux'));

  print(garis);
  computer.system('Windows');
  print(batas);
}
```
