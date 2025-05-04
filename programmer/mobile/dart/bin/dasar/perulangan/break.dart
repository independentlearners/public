// # Sebelum perulangan Continue adalah perulangan Break
void main() {
  print('\n' * 5);

  var counter = 0;
  while (true) {
    print('Perulangan ke- $counter');
    counter++; // % persingkat dan pindah ke dalam print()

    if (counter > 10) {
      break;
    }
  }

  print('\n' * 5);
}
