void main() {
  String nama = 'amirzain';
  String kata = "halo dunia";
  String dart = "'pemrograman dart menyenangkan'";
  String flutter = """

framework flutter keren

  """;

  print('''
      nama = $nama
      kata = $kata
      dart = $dart
      flutter = $flutter
      ''');

  String string = '$nama'
      '\n$kata'
      '\n$dart'
      '\n$flutter';
  var vr = string;
  print('$vr\n');

  var single = nama + kata;
  var saya = 'nama ' ' saya' ' amirkulal';
  print(single + saya);

  String multiLineString = """
      Oke Google
      Halo Google
      Oke Siap
      """;
  print(multiLineString);
}
