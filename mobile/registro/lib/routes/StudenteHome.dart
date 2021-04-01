import 'package:flutter/material.dart';
import 'package:registro/models/Studente.dart';
import 'package:registro/models/Utente.dart';

class StudenteHome extends StatelessWidget {
  final Studente _studente = Utente.utenteLoggato as Studente;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _studente.numeroVoti,
      itemBuilder: (context, index) => _studente[index].toWidget(),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    );
  }
}
