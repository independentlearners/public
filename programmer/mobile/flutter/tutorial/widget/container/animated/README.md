# Animated Container
```dart
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(M());

class M extends StatefulWidget {
  const M({super.key});

  @override
  State<M> createState() => _MState();
}

class _MState extends State<M> {
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Animated Container')),
        body: Center(
          child: GestureDetector(
            onTap: () => setState(() {}),

            child: AnimatedContainer(
              color: Color.fromARGB(
                255,
                random.nextInt(256),
                random.nextInt(256),
                random.nextInt(256),
              ),
              duration: Duration(seconds: 1),
              width: 50.0 + random.nextInt(101),
              height: 50.0 + random.nextInt(101),
            ),
          ),
        ),
      ),
    );
  }
}
```