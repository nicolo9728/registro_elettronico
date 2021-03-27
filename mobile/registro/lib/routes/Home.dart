import 'package:flutter/material.dart';
import 'package:registro/main.dart';
import 'package:registro/models/Docente.dart';
import 'package:registro/models/Studente.dart';
import 'package:registro/models/Utente.dart';
import 'DocenteHome.dart';
import 'StudenteHome.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Utente utente = Utente.utenteLoggato;

    if (utente.runtimeType == Docente)
      return DocenteHome();
    else
      return StudenteHome();
  }
}
