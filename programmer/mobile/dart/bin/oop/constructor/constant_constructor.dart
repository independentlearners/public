class ImmutablePoint {
  final int x;
  final int y;

  const ImmutablePoint(this.x, this.y);
}

void main() {
  print('\n' * 5);

  // ! agar aman ketika di Sharing, tambahkan kata kuncu "const", demikian ini bast paractice-nya
  // %  di deklarasikan secara eksplisit tanpa menggunakan konsep non-polymorphism
  var a = const ImmutablePoint(1, 1);
  print(a.x);
  print(a.y);

  print('=' * 20);

  var b = ImmutablePoint(1, 1);
  print(b.x);
  print(b.y);

  print(a == b); // ! perhatikan bahwa ini akan menghasilkan "false"

  print('\n' * 5);
}
