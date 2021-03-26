import 'dart:convert';

import 'package:registro/models/HttpRequest.dart';
import 'package:registro/models/Studente.dart';

class Classe {
  String _nome;
  String _id;
  List<Studente> _studenti;

  Classe(Map<String, dynamic> data) {
    _nome = data["nome"];
    _id = data["idClasse"];
    _studenti = [];
  }

  String get nome => _nome;

  operator [](int index) => _studenti[index];

  Future<void> scaricaStudenti() async {
    Map<String, dynamic> data = jsonDecode(await HttpRequest.get("/docenti/ottieniStudenti?idClasse=$_id"));
    (data as List).forEach((studentiData) {
      _studenti.add(new Studente(studentiData));
    });
  }
}
