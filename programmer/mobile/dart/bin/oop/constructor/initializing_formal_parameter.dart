class InitializingFormalParameter {
  String a = 'Smoke';
  String? b;
  final String c = 'Diplomat';

  InitializingFormalParameter(
    this.a,
    this.b,
  );
}

String batas = '\n' * 5;
void main() {
  print(batas);

  var aaa = InitializingFormalParameter(
    'Initializing Formal Parameter',
    'Succes',
  );

  // $ di cetak menggunakan String Interpolation, penejelasan lengkap mengenai String dan $String Interpolation ada di>> bin\dasar\variabel\string.dart
  print(
    '${aaa.a}\n'
    '${aaa.b}\n'
    '$aaa',
  );

  print('=' * 20);

  print(batas);
}
