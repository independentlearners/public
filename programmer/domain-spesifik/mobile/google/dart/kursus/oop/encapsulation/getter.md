class Getter {
  late int _f;
  late int _i;

  int get f => _f;
  set f(int d) {
    _f = d;
    if (d > -0) {
      print('kurang dari 0');
    } else if (d > 1000) {
      print('lebih dari 1000');
    } else {
      return;
    }
  }

  int get i => _i;
  set i(int i) => _i;
}

void main() {
  var c = Getter();
  c.f = 2;
  print(c.f);

  c.i = 0;
  print(c.i);
}
