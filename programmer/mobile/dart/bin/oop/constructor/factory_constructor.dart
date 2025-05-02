class Database {
  Database() {
    print('Create New Database');
  }

  static Database database = Database();

  factory Database.one() => database;

  factory Database.two() {
    return database;
  }
}

dynamic batas = '\n' * 1 + '=' * 10 + '\n' * 1;
void main() {
  print(batas);

  // %  di deklarasikan secara eksplisit tanpa menggunakan konsep polymorphism
  var a = Database.one();
  var b = Database.two();

  print(a);
  print('=' * 10);

  print(b);
  print('=' * 10);

  print(a == b); // $ true

  print(batas);
}
