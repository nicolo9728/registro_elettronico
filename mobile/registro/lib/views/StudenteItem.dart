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
      borderRadius: BorderRadius.circular(10),
      color: Color.fromARGB(255, 30, 33, 43),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text("${studente.dataNascita.day}/${studente.dataNascita.month}/${studente.dataNascita.year}")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
