import 'package:flutter/material.dart';
import 'package:registro/models/Utente.dart';
import 'package:registro/routes/Caricamento.dart';
import 'package:registro/routes/Home.dart';
import 'package:registro/routes/Login.dart';

class Autenticazione extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Utente.autenticazione(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return AlertDialog(
              title: Text("errore"),
              content: Text(snapshot.error.toString()),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Autenticazione()), (context) => false),
                    child: Text("riprova")),
                TextButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false),
                    child: Text("login"))
              ],
            );
          }

          if (snapshot.hasData) {
            bool successo = snapshot.data;
            if (successo)
              return Home();
            else
              return Login();
          } else
            return Caricamento();
        });
  }
}
