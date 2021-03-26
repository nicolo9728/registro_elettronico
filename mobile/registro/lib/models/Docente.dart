import 'package:registro/models/Classe.dart';
import 'package:registro/models/Materia.dart';
import 'package:registro/models/Utente.dart';

class Docente extends Utente {
  List<Classe> classi;
  List<Materia> materie;
  Docente(Map<String, dynamic> data) : super(data["username"], data["nome"], data["cognome"], DateTime.parse(data["dataNascita"])) {
    classi = [];
    materie = [];

    (data["materie"] as List).forEach((materiaData) {
      materie.add(new Materia(materiaData));
    });

    (data["classi"] as List).forEach((classeData) {
      classi.add(new Classe(classeData));
    });
  }
}
