# Stack dan Align

```dart
import 'package:flutter/material.dart';

void main() => runApp(My());

class My extends StatelessWidget {
  const My({super.key});

  Widget buildColoredFlex(Color color) {
    return Flexible(
      flex: 2,
      child: Container(
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Stack and Align',
          ),
        ),
        body: Stack(
            //menyusun wiged menumpuk
            children: [
              Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Flexible(
                            flex: 1,
                            child: buildColoredFlex(Colors.white)),
                        Flexible(
                            flex: 1,
                            child: buildColoredFlex(Colors.black12)),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Flexible(
                            flex: 1,
                            child: buildColoredFlex(Colors.black12)),
                        Flexible(
                            flex: 1,
                            child: buildColoredFlex(Colors.white)),
                      ],
                    ),
                  )
                ],
              ),
              ListView(
                children: [
                  Column(
                    children: [
                      Text(
                        (' Halo dunia, Oke siap ' * 1000),
                      )
                    ],
                  )
                ],
              ),
              Align(
                alignment: Alignment(0, 0), //posisi tombol
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('tombol'),
                ),
              )
            ]),
      ),
    );
  }
}
```
