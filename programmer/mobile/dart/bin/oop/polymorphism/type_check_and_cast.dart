class Type {
  String? a;
  Type(this.a);
}

class Check extends Type {
  Check(String super.a);
}

class Cast extends Check {
  Cast(super.a);
}

String batas = '\n' * 5;
String garis = '-' * 20;
void type(Type type) {
  if (type is Cast) {
    print('Hello Cast ${type.a}');
  } else if (type is Check) {
    print('Hello Check ${type.a}');
  } else {
    print('Hello ${type.a}');
  }
}

void main() {
  print(batas);

  type(Type('Ameer'));
  print(garis);

  type(Cast('Ameer'));
  print(garis);

  type(Check('Ameer'));

  print(batas);
}
