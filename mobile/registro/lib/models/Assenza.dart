import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:registro/models/IEvento.dart';
import 'package:registro/models/Presenza.dart';

import 'HttpRequest.dart';
import 'Studente.dart';

class Assenza extends Presenza {
  DateTime _data;

  Assenza() {
    _data = DateTime.now();
  }

  Future<void> segna(Studente studente) async {
    await HttpRequest.post("/docenti/cancellaPresenza", jsonEncode({"idStudente": studente.matricola}));
    studente.aggiornaStatus(StatusStudente.Assente);
  }

  @override
  Color get colore => Colors.red[800];

  @override
  DateTime get data => _data;

  @override
  String get descrizioneEvento => "L'alunno è stato assente";

  @override
  String get nomeEvento => "Assenza";

  @override
  IconData get icona => Icons.block;
}
