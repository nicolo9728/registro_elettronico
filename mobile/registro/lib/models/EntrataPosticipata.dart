import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:registro/models/HttpRequest.dart';
import 'package:registro/models/Presenza.dart';

class EntrataPosticipata extends Presenza {
  int _entrata;

  EntrataPosticipata(int entrata) {
    this.entrata = entrata;
  }

  int get entrata => _entrata;
  set entrata(int entrata) {
    if (entrata > 1)
      _entrata = entrata;
    else
      throw new ArgumentError("l'ora di entrata deve essere maggiore di 1");
  }

  @override
  String get nomeEvento => "Entrata posticipata";

  @override
  String get descrizioneEvento => "lo studente è entrato alla $entrata^a ora";

  factory EntrataPosticipata.fromData(Map<String, dynamic> data) {
    EntrataPosticipata entrataAnticipata = new EntrataPosticipata(data["entrata"]);
    entrataAnticipata.data = DateTime.parse(data["data"]);

    return entrataAnticipata;
  }

  @override
  Color get colore => Color.fromARGB(255, 233, 99, 32);

  @override
  Future<void> segna(int idStudente) async {
    await HttpRequest.post("/docenti/segnaEntrata", jsonEncode({"idStudente": idStudente, "entrata": entrata}));
  }

  @override
  IconData get icona => Icons.alarm;
}
