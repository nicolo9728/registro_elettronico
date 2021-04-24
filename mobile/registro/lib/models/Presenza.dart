import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:registro/models/HttpRequest.dart';
import 'package:registro/models/IEvento.dart';
import 'package:registro/models/Studente.dart';

class Presenza implements IEvento {
  DateTime _data;

  Presenza() {
    _data = DateTime.now();
  }

  DateTime get data => _data;
  @override
  Color get colore => Color.fromARGB(255, 28, 116, 217);

  @override
  String get nomeEvento => "Presente";

  factory Presenza.fromData(Map<String, dynamic> data) {
    Presenza p = new Presenza();
    p._data = DateTime.parse(data["data"]);

    return p;
  }

  @protected
  set data(DateTime data) => _data = data;

  Future<void> segna(Studente studente) async {
    await HttpRequest.post("/docenti/segnaPresenza", jsonEncode({"idStudente": studente.matricola}));
    studente.aggiornaStatus(StatusStudente.Presente);
  }

  @override
  String get descrizioneEvento => "lo studente è stato presente a lezione";

  @override
  IconData get icona => Icons.alarm_on;
}
