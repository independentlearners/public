// # Konsep Factorial Recursive

int factorialLoop(int value) {
  var result = 1;

  for (var i = 1; i <= value; i++) {
    result *= i;
  }

  return result;
}

int factorialRecursive(int value) {
  if (value == 1) {
    return 1;
  } else {
    return value * factorialRecursive(value - 1);
  }
}

void main() {
  print('\n' * 5);

  print(factorialLoop(10)); // output: 3628800

  print('' * 1 + '=' * 10 + '\n' * 1);

  print(factorialLoop(1 * 2 * 3 * 4 * 5 * 6 * 7 * 8 * 9 * 10)); // output: 0

  print('' * 1 + '=' * 10 + '\n' * 1);

  print(1 * 2 * 3 * 4 * 5 * 6 * 7 * 8 * 9 * 10); // output: 3628800

  print('' * 1 + '=' * 10 + '\n' * 1);

  print(factorialRecursive(10)); // output: 3628800

  print('\n' * 5);
}
