// # Versi sederhana dari while-loop yang tidak membutuhkan init statement juga akan mengeksekusi satu kali meskipun salah. Artinya dieksekusi dulu baru di lakukan perulangan
void main() {
  print('\n' * 5);

  int counter = 0;

  do {
    print('perulangan ke-${counter++}');

    // counter++; // ! Opsional, aktifkan ini atau tambahkan ++ pada pada variabel yang dipanggil dalam print() jika tidak maka akan menyebabkan perulangan yang tidak pernah berhenti
  } while (counter <= 10);

  print('\n' * 5);
}
