// #
void main() {
  print('\n' * 5);

  var nilai = 'A';
  switch (nilai) {
    case 'A':
      print('Wow Anda Lulus Dengan Baik');
      break;
    case 'B':
    case 'C':
      print('Anda Lulus');
      break;
    case 'D':
      print('Anda Tiudak Lulus');
      break;
    default:
      print('Mungkin Anda Salah Jurusan');
  }

  print('\n' * 5);
}
