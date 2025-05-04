abstract class Location {
  String? name;
}

// ! abstract class tidak bisa menginstansiasi objeknya ksrenanya, kelas turunannyalah yang akan menginstansi objek tersebut
class City extends Location {
  @override
  City(String name) {
    this.name = name;
  }
}

void main() {
  var city = City('Nusantara');
  // $ var location = Location{} // ini pasti error
}
