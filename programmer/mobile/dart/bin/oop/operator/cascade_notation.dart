String batas = '\n' * 6;
String garis = '-' * 20; // garis pemisah

class User {
  String? username;
  String? name;
  String? email;
}

User? createUser() => null;
// $ ubah return value menjadi "User()" untuk menampilkan hasil dari function ini ke console

void main() {
  print(batas);

  var user = User()
    ..username = 'user'
    ..name = 'orang'
    ..email = 'orang@orang.com';

  print(user.username);
  print(user.name);
  print(user.email);

  print(garis);
  print(batas);

  User? use = createUser()
    ?..username = 'saya'
    ..name = 'manusia'
    ..email = 'manusia@email.com';

  print(use?.username);
  print(use?.name);
  print(use?.email);

  print(garis);
  print(batas);

  print(use?.username = 'username');
  print(use?.name = 'name');
  print(use?.email = 'email@dot.com');

  print(batas);
}
