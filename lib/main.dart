import 'package:flutter/material.dart';
import 'package:relief/home.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawing Paths',
      home: Home(),
    );
  }
}
