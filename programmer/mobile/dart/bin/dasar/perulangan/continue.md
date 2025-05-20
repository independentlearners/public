// # Kelanjutan dari perulangan Break adalah Continue

void main() {
  print('\n' * 5);

  for (int counter = 0; counter <= 10; counter++) {
    if (counter % 2 == 0) continue; // $ menghasilkan perulangan ganjil

    print('perulangan ke-$counter');
  }

  print('\n' * 5);
}
