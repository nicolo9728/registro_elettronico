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
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 30, 33, 43),
        appBarTheme: AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
        textTheme: TextTheme(bodyText2: TextStyle(color: Colors.white60), headline1: TextStyle(color: Colors.white60)),
      ),
    );
  }
}
