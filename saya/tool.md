# Dart

Kumpulan data-data

```dart
import 'dart:io';

class Item {
  String nama;
  bool selesai;

  Item({required this.nama, this.selesai = false});

  void tandaiSelesai() {
    selesai = true;
  }
}

void main() => daftar(title: '=== APLIKASI DAFTAR ITEM ===');

void daftar({required String title}) {
  print(title);

  List<Item> daftarItem = [];
  bool sedangBerjalan = true;

  clear();
  while (sedangBerjalan) {
    print(
      '\nPilih Menu:\n'
      '1. Lihat Daftar Item\n'
      '2. Tambah Item Baru\n'
      '3. Tandai Item Selesai\n'
      '4. Keluar',
    );

    stdout.write('Masukkan pilihan Anda (1-4): ');
    String? masukan = stdin.readLineSync();

    switch (masukan) {
      case '1':
        clear();
        tampilkanDaftar(daftarItem);
        break;
      case '2':
        clear();
        tambahItemBaru(daftarItem);
        break;
      case '3':
        clear();
        selesaikanItem(daftarItem);
        break;
      case '4':
        clear();
        print('\nTerima kasih telah menggunakan aplikasi ini!');
        sedangBerjalan = false;
        break;
      default:
        print('\nPilihan tidak valid! Silakan masukkan angka 1 sampai 4.');
    }
  }
}

void tampilkanDaftar(List<Item> daftar) {
  print('\n--- DAFTAR ITEM ---');
  if (daftar.isEmpty) {
    print('Daftar masih kosong.');
  } else {
    for (int i = 0; i < daftar.length; i++) {
      String status = daftar[i].selesai ? '[V]' : '[ ]';
      print('${i + 1}. $status ${daftar[i].nama}');
    }
  }
}

void tambahItemBaru(List<Item> daftar) {
  stdout.write('\nMasukkan nama item baru: ');
  String? namaBaru = stdin.readLineSync();

  if (namaBaru != null && namaBaru.trim().isNotEmpty) {
    Item itemBaru = Item(nama: namaBaru.trim());
    daftar.add(itemBaru);
    print('Item "${namaBaru.trim()}" berhasil ditambahkan!');
  } else {
    print('Nama item tidak boleh kosong!');
  }
}

void selesaikanItem(List<Item> daftar) {
  if (daftar.isEmpty) {
    print('\nTidak ada item untuk ditandai!');
    return;
  }

  tampilkanDaftar(daftar);
  stdout.write('Masukkan nomor item yang selesai: ');
  String? masukanNomor = stdin.readLineSync();

  if (masukanNomor != null) {
    int? nomor = int.tryParse(masukanNomor);
    if (nomor != null && nomor > 0 && nomor <= daftar.length) {
      daftar[nomor - 1].tandaiSelesai();
      print('Item "${daftar[nomor - 1].nama}" telah ditandai selesai!');
    } else {
      print('Nomor item tidak valid!');
    }
  }
}

void clear() => stdout.writeln('\x1B[2J\x1B[0;0H');
```
