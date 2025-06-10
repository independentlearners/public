// Super Class dengan konstruktor
class Animal {
  String name;

  // Konstruktor
  Animal(this.name);

  void makeSound() {
    print('Animal makes a sound');
  }
}

// Subclass dari Animal
class Dog extends Animal {
  String breed;

  // Menggunakan konstruktor dari super-class
  Dog(super.name, this.breed);

  void makeSound() {
    print('Woof woof!');
  }
}

void main() {
  Dog dog = Dog('Rex', 'German Shepherd');
  dog.makeSound(); // Output: Woof woof!
}
