void af(final int a) {
  int? b;
  late int c = a;

  print('nilai b $b\n' 'nilai c $c');
}

int av(final int a) {
  int? b;
  late int c = a;

  return c = 7;
}

void main() {
  print('' * 5);

  var d = af(1);

  print(
    '\n' * 1 + '=' * 10 + '\n' * 1,
  );

  var e = av(8);
  print('nilai e $e');

  print('' * 5);
}
