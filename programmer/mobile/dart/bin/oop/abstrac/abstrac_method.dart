abstract class Location {
  String? name;

  void run() {
    String n;
    return;
  }
}

class City extends Location {
  City(String name) {
    this.name = name;
  }

  // todo: implementasi ini wajib
  @override
  void run() => print('my $name city is the best');
  void get() => print('this $name class City');
}

dynamic batas = '\n' * 1 + '=' * 10 + '\n' * 1;

void main() {
  print('\n' * 5);

  var city = City('Malang');
  print('$city $batas');
  print(city = batas);

  print(batas);
  print(city.name);

  city.name = 'lovely in this';
  city.run();
  city.get();

  print('\n' * 5);
}
