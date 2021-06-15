import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:registro/models/HttpRequest.dart';
import 'package:registro/models/Presenza.dart';
import 'package:registro/models/Studente.dart';

class UscitaAnticipata extends Presenza {
  int _uscita;

  UscitaAnticipata(int uscita) {
    this.uscita = uscita;
  }

  int get uscita => _uscita;
  set uscita(int uscita) {
    if (uscita == null) throw new ArgumentError("ora di uscita non selezionata");

    if (uscita < 6)
      _uscita = uscita;
    else
      throw new ArgumentError("l'ora di uscita deve essere minore di 6");
  }

  factory UscitaAnticipata.fromData(Map<String, dynamic> data) {
    UscitaAnticipata uscitaAnticipata = new UscitaAnticipata(data["uscita"]);
    uscitaAnticipata.data = DateTime.parse(data["data"]);

    return uscitaAnticipata;
  }

  @override
  String get nomeEvento => "Uscita anticipata";
  @override
  String get descrizioneEvento => "lo studente è uscito alla $uscita^a ora";

  @override
  Color get colore => Color.fromARGB(255, 233, 99, 32);

  @override
  IconData get icona => Icons.alarm;

  @override
  Future<void> segna(Studente studente) async {
    if (uscita >= studente.entrata) {
      await HttpRequest.post("/docenti/segnaUscita", jsonEncode({"idStudente": studente.matricola, "uscita": uscita}));
      studente.aggiornaStatus(StatusStudente.Uscito, uscita);
    } else
      throw new ArgumentError("lo studente non puo essere uscito prima di entrare");
  }
}
