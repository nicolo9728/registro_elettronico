import 'package:flutter/material.dart';
import 'package:registro/models/Studente.dart';
import 'package:registro/views/Disconnetti.dart';
import 'package:registro/views/ProfiloGeneralita.dart';

class StudenteProfilo extends StatelessWidget {
  final Studente profilo;

  const StudenteProfilo({this.profilo});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfiloGeneralita(
            utente: profilo,
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "media voti",
                  style: TextStyle(fontSize: 30, color: Colors.white70),
                ),
                Text(
                  profilo.media.toString(),
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
          ),
          Expanded(
              child: Container(
            alignment: Alignment.bottomCenter,
            child: Disconnetti(),
          ))
        ],
      ),
    );
  }
}
