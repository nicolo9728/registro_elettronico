import 'package:flutter/material.dart';

class Caricamento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 12, 48, 90),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
