import 'package:flutter/material.dart';
import 'package:registro/models/Utente.dart';

class Profilo extends StatelessWidget {
  final Utente utente;

  const Profilo({this.utente});

  @override
  Widget build(BuildContext context) {
    return utente.profilo;
  }
}
