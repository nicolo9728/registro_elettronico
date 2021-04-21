import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:registro/models/Docente.dart';
import 'package:registro/models/HttpRequest.dart';
import 'package:registro/models/IEvento.dart';
import 'package:registro/models/Utente.dart';

class Presenza implements IEvento {
  DateTime _data;
  String _nomeDocente;
  String _cognomeDocente;
  int _idStudente;

  Presenza(int idStudente, Docente docente) {
    _data = DateTime.now();
    _idStudente = idStudente;
    if (docente != null) {
      _nomeDocente = docente.nome;
      _cognomeDocente = docente.cognome;
    } else {
      _nomeDocente = "";
      _cognomeDocente = "";
    }
  }

  DateTime get data => _data;
  String get nomeDocente => _nomeDocente;
  String get cognomeDocente => _cognomeDocente;
  int get idStudente => _idStudente;

  @override
  Color get colore => Color.fromARGB(255, 28, 116, 217);

  @override
  String get descrizione => "$nomeDocente $cognomeDocente";

  @override
  String get nomeEvento => "Presente";

  factory Presenza.fromData(Map<String, dynamic> data) {
    Presenza p = new Presenza(data["idstudente"], null);
    p._data = DateTime.parse(data["data"]);
    p._nomeDocente = data["nomedocente"];
    p._cognomeDocente = data["cognomedocente"];

    return p;
  }

  Future<void> carica() async {
    await HttpRequest.post("/segnaPresenza", jsonEncode({"idStudente": idStudente}));
  }
}
