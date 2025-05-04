class Encapsulation {
  int _f = 0;
  final int _i = 1;

  // ignore: unnecessary_getters_setters
  int get a => _f;
  set a(int d) {
    _f = d;
  }

  int get i => _i;
  set i(int n) {
    n = _i;
  }
}

void main() {
  var c = Encapsulation();
  c.a = 2;
  print(c.a);

  c.i = 2;
  print(c.i);
}
