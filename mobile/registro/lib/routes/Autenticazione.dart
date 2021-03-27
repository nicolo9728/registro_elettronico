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
