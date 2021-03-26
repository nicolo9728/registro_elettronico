import 'package:flutter/material.dart';
import 'package:registro/main.dart';
import 'package:registro/models/Utente.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("registro elettronico"),
      ),
      body: Center(
        child: FutureBuilder(
          future: Utente.autenticazione(),
          builder: (context, snapshot) {
            if (snapshot.hasData) return Text("successo");
            if (snapshot.hasError) return Text(snapshot.error.toString());

            return Text("caricamento");
          },
        ),
      ),
    );
  }
}
