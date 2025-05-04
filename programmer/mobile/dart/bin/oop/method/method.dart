String batas = '\n' * 5;
String garis = '=' * 10;

class KelasPersonal {
  String name =
      'Guest'; // secara default pendeklarasian field dalam class wajib menyertakan nilanya
  String?
      address; // agar nilai bisa diubah nantinya, tipe data harus diubah menjadi nullable
  final String country = 'Indonesia'; // tidak bisa diubah

  void sayHello(String paramName) => print('Hello $paramName, My Name is $name');

  void hello(String paramAddress) {
    print('Kota $paramAddress, Propinsi $address');
  }

  String getName(String paramCountry) {
    if (paramCountry is String) {
      print('Kota $paramCountry, di $country');
    }

    return paramCountry;
  }
}

void main(A) {
  print(batas);

  var person = KelasPersonal();

  // % printt langsung
  print(person.name);
  print(garis);

  print(person.address);
  print(garis);

  print(person.country);
  print(garis);

  print(batas);

  // % memodifikasi nilai field
  person.name = 'Amirkulal';
  person.address = 'Jawa Timur';
  // person.country = 'Nusantara'; tidak bisa diubah, sebab induknya bersifat final

  print(person.name);
  print(garis);

  print(person.address);
  print(garis);

  print(batas);

  // % memanggil method dalam class
  person.sayHello('World');
  print(garis);

  person.hello('Malang');
  print(garis);

  person.getName('Maju');
  print(garis);

  print(batas);
}
