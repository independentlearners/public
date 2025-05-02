sealed class Bentuk {
  void gambar();
}

class Lungkaran extends Bentuk {
  @override
  void gambar() {
    print("Menggambar lingkaran");
  }
}

class Persegi extends Bentuk {
  @override
  void gambar() {
    print("Menggambar persegi");
  }
}

void main() {
  Bentuk lingkaran = Lungkaran();
  lingkaran.gambar(); // Outputs: Menggambar lingkaran

  Bentuk persegi = Persegi();
  persegi.gambar(); // Outputs: Menggambar persegi

  Shape shape = Circle(1);
  // shape.calculateArea(1);
}

sealed class Shape {}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);
}

class Square extends Shape {
  final double side;
  Square(this.side);
}

class Triangle extends Shape {
  final double base;
  final double height;
  Triangle(this.base, this.height);
}

double calculateArea(Shape shape) {
  switch (shape) {
    case Circle():
      return 3.14 * shape.radius * shape.radius;
    case Square():
      return shape.side * shape.side;
    case Triangle():
      return 0.5 * shape.base * shape.height;
  }
}
