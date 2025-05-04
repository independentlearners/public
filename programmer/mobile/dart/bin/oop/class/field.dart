class KelasPersonal {
  String name =
      'Guest'; // secara default pendeklarasian field dalam class wajib menyertakan nilanya
  String?
      address; // agar nilai bisa diubah nantinya, tipe data harus diubah menjadi nullable
  final String country = 'Indonesia'; // tidak bisa diubah
}

dynamic garis = '=' * 50;
void main(A) {
  print('\n' * 5);

  var person = KelasPersonal();

  // % printt langsung
  print(person.name);
  print(garis);

  print(person.address);
  print(garis);

  print(person.country);
  print(garis);

  print('\n' * 5);

  // % memodifikasi nilai field
  person.name = 'Amirkulal';
  person.address = 'Jawa Timur';
  // person.country = 'Nusantara'; tidak bisa diubah, sebab induknya bersifat final

  print(person.name);
  print(garis);

  print(person.address);
  print(garis);

  print('\n' * 5);
}
