import 'package:flutter/material.dart';
import 'package:registro/routes/Autenticazione.dart';

void main(List<String> args) {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Autenticazione(),
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 30, 33, 43),
          appBarTheme: AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
          textTheme: TextTheme(
              bodyText1: TextStyle(color: Colors.white60),
              bodyText2: TextStyle(color: Colors.white60),
              headline1: TextStyle(color: Colors.white60),
              button: TextStyle(color: Colors.white60)),
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              labelStyle: TextStyle(color: Colors.white70),
              hintStyle: TextStyle(color: Colors.white60)),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                  shadowColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                  textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(color: Colors.black)),
                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white70))),
          hintColor: Colors.white60),
    );
  }
}
