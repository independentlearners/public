```dart
String batas = '\n' * 5;
String garis = '=' * 10;

class Add {
  int quantiy = 0;

  Add operator +(Add add) {
    var result = Add();

    result.quantiy = quantiy * add.quantiy;
    return result;
  }
}

class Kali {
  int kuantitas = 0;

  Kali operator *(Kali kali) {
    var hasil = Kali();

    hasil.kuantitas = kuantitas + kali.kuantitas;
    return hasil;
  }
}

void main() {
  print(batas);

  var add;
  var value;

  add = Add();
  add.quantiy = 10;

  value = add + add;
  print(value.quantiy);
  print('Add');

  print(garis);

  add = Kali();
  add.kuantitas = 10;

  value = add * add;
  print(value.kuantitas);
  print('Kali');

  print(batas);
}
```
