import 'package:flutter/material.dart';
import 'package:registro/models/Studente.dart';

class StudenteItem extends StatelessWidget {
  final Studente studente;
  final Function onTap;

  const StudenteItem({this.studente, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Color.fromARGB(255, 28, 116, 217),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Text(
                  "${studente.nome[0].toUpperCase()}${studente.cognome[0].toUpperCase()}",
                  style: TextStyle(color: Color.fromARGB(255, 248, 248, 248)),
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${studente.nome} ${studente.cognome}",
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text("${studente.dataNascita.day}/${studente.dataNascita.month}/${studente.dataNascita.year}")
                ],
              ),
              Expanded(
                  child: Text(
                studente.statusString,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 18),
              )),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
