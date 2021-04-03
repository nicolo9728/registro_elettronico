import 'package:flutter/material.dart';
import 'package:registro/models/Utente.dart';

class ProfiloGeneralita extends StatelessWidget {
  final Utente utente;

  const ProfiloGeneralita({this.utente});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: 150,
              width: 150,
              child: CircleAvatar(
                  child: Text(
                "${utente.nome[0]}${utente.cognome[0]}",
                style: TextStyle(fontSize: 40),
              ))),
          SizedBox(
            height: 20,
          ),
          Text(
            "${utente.nome} ${utente.cognome}",
            style: TextStyle(fontSize: 30),
          ),
          Text("${utente.dataNascita.day}/${utente.dataNascita.month}/${utente.dataNascita.year}"),
        ],
      ),
    );
  }
}
