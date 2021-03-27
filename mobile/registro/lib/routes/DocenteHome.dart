import 'package:flutter/material.dart';
import 'package:registro/models/Classe.dart';
import 'package:registro/models/Docente.dart';
import 'package:registro/models/Utente.dart';

class DocenteHome extends StatefulWidget {
  @override
  _DocenteHomeState createState() => _DocenteHomeState();
}

class _DocenteHomeState extends State<DocenteHome> {
  final Docente _docente = Utente.utenteLoggato;
  Classe _classeSelezionata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_docente.username),
        ),
        body: Column(
          children: [],
        ));
  }
}
