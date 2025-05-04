Operator penugasan adalah operator yang digabungkan sekaligus kedalam variabel untuk menghasilkan nilai yang sama seperti nilai yang dideklarasikannya.

---

| Operator Aritmatika | Augmrnted Assigment |
| ------------------- | ------------------- |
| a = a + 10          | a += 10             |
| a = a - 10          | a -= 10             |
| a = a \* 10         | a \*= 10            |
| a = a / 10          | a /= 10             |
| a = a ~/ 10         | a ~/= 10            |
| a = a %/ 10         | a %= 10             |

#

**Claasic**

```Dart
String a = a + 10;
```

**Modern**

```dart
String a += 10;
```

# Increment

```dart
var a += 10;

++a;
print(a);

```

#### Kode Saya

```dart
import '../../saya.dart';

void main() {
  var a = 10;
  var b = 20;
  var c = 10;
  var d = 2.0;
  var e = 10;
  var f = 20;
  var g = 10;
  var h = 10;
  var i = 10;
  var j = 10;

  a += 5;
  b -= 10;
  c *= 5;
  d /= 2.0;
  e %= 3;
  f ~/= 2;
  g++;
  h--;
  ++i;
  --j;

  print('$merah $a =>  a += 5 $reg'
      '$biru $b => b -= 10 $reg'
      '$kuning $c => c *= 5 $reg'
      '$hijau $d => d /= 2.0 $reg'
      '$ungu $e => e %= 3 $reg'
      '$cyan $f => f ~/= 2 $reg'
      '$merah$tebal $g => g++ $reg'
      '$biru$tebal $h => h-- $reg'
      '$kuning$tebal $i => ++i $reg'
      '$hijau$tebal $j => --j $reg');
}
```

> Dokumentasi resmi tentang [tentang operator](https://dart.dev/guides/language/language-tour#assignment-operators "dart.dev")
