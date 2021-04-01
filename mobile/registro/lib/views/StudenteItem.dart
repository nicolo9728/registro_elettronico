import 'package:flutter/material.dart';
import 'package:registro/models/Studente.dart';

class StudenteItem extends StatelessWidget {
  final Studente studente;

  const StudenteItem({this.studente});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            child: Text("${studente.nome[0].toUpperCase()}${studente.cognome[0].toUpperCase()}"),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${studente.nome} ${studente.cognome}",
                style: TextStyle(fontSize: 20),
              ),
              Text("${studente.dataNascita.day}/${studente.dataNascita.month}/${studente.dataNascita.year}")
            ],
          )
        ],
      ),
    );
  }
}
