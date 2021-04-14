import 'package:flutter/material.dart';
import 'package:registro/models/Studente.dart';
import 'package:registro/models/Utente.dart';
import 'package:registro/routes/Caricamento.dart';

class StudenteHome extends StatefulWidget {
  @override
  _StudenteHomeState createState() => _StudenteHomeState();
}

class _StudenteHomeState extends State<StudenteHome> {
  final Studente _studente = Utente.utenteLoggato as Studente;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _studente.aggiornaVoti();
        setState(() {});
      },
      child: FutureBuilder(
        future: _studente.aggiornaVoti(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return Container(
              child: ListView.builder(
                itemCount: _studente.numeroVoti,
                itemBuilder: (context, index) => Text("data"),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
            );
          else
            return Caricamento();
        },
      ),
    );
  }
}
