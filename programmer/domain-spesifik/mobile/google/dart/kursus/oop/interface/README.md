```dart
class One {
  String? name;
}

class Two extends One {
  // $ kongkrit medthod
  Two(String name) {
    this.name = name;
  }
}

// class Tree extends Two {
//   Tree(String name) {
//     this.name = name;
//   }
//   city(String name) {
//     this.name = name;
//   }
//  }

// class Interface implements One {
//   String? name;
// }

// class User implements Interface {
//   String? name;
//   String? n;
// }

void main() {
  var city = Two('Nusantara');
}
```
