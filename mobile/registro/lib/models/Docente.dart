import 'dart:collection';
import 'dart:convert';

import 'package:registro/models/Classe.dart';
import 'package:registro/models/HttpRequest.dart';
import 'package:registro/models/Materia.dart';
import 'package:registro/models/Studente.dart';
import 'package:registro/models/Utente.dart';
import 'package:registro/models/Voto.dart';

class Docente extends Utente with IterableMixin<Classe> {
  List<Classe> _classi;
  List<Materia> _materie;
  int _i = 0;

  Docente(Map<String, dynamic> data) : super(data) {
    _classi = [];
    _materie = [];

    (data["materie"] as List).forEach((materiaData) {
      _materie.add(new Materia(materiaData));
    });

    (data["classi"] as List).forEach((classeData) {
      _classi.add(new Classe(classeData));
    });
  }

  Classe operator [](int index) => _classi[index];
  List<Materia> get materie => _materie;
  int get numeroClassi => _classi.length;

  Future<void> caricaVoto(Studente studente, Voto voto) async {
    await HttpRequest.post(
        "/docenti/aggiungiVoto",
        jsonEncode({
          "idStudente": studente.matricola,
          "valutazione": voto.valutazione,
          "data": voto.data.toIso8601String(),
          "nomeMateria": voto.nomeMateria,
          "descrizione": voto.descrizione
        }));
  }

  @override
  Iterator<Classe> get iterator => _classi.iterator;
}
