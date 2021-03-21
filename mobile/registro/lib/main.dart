import 'package:flutter/material.dart';
import 'package:registro/routes/Home.dart';

void main(List<String> args) {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      themeMode: ThemeMode.dark,
    );
  }
}
