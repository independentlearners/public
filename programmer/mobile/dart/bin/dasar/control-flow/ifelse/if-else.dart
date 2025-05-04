void main() {
  print('\n' * 5);

  var nilai = 70;
  var absen = 70;
  if (nilai >= 80 && absen >= 80) {
    print("Anda Lulus 😁");
  } else if (nilai >= 70 && absen >= 70) {
    print("Nilai Anda A 😊");
  } else if (nilai >= 60 && absen >= 60) {
    print("Nilai Anda B 😉");
  } else if (nilai >= 50 && absen >= 50) {
    print("Nilai Anda C 🤨");
  } else {
    print("Anda Tidak Lulus! 😒");
  }

  print('\n' * 5);
}
