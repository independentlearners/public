// % Errors dan Exceptions
// # Digunakan untuk menangani kesalahan dan pengecualian.

void main() {
  print('\n' * 5);

  void checkAge(int age) {
    if (age < 18) {
      throw ArgumentError('Age must be 18 or older');
    }
  }

  try {
    checkAge(16);
  } catch (e) {
    print(e);
  }

  print('\n' * 5);
}
