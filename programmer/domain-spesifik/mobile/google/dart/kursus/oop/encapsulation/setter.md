class Setter {
  int _i;

  Setter(this._i);
}

void main() {
  var c = Setter(4);
  c._i = 2;
  print(c._i);
}
