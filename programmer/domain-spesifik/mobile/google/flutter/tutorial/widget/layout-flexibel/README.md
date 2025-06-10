# Layout Flexibel

```dart
import 'package:flutter/material.dart';

void main() => runApp(My());

class My extends StatelessWidget {
  const My({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Layout Flexibel')),
        body: Center(
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.all(5),
                        color: Colors.blueGrey,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.all(5),
                        color: Colors.indigo,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.all(5),
                        color: Colors.tealAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(flex: 1, child: Container(color: Colors.red)),
              Flexible(flex: 2, child: Container(color: Colors.amber)),
              Flexible(flex: 1, child: Container(color: Colors.blue)),
            ],
          ),
        ),
      ),
    );
  }
}
```