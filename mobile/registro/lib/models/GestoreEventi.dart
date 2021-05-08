import 'dart:collection';
import 'dart:convert';
import 'package:registro/models/Assenza.dart';
import 'package:registro/models/EntrataPosticipata.dart';
import 'package:registro/models/HttpRequest.dart';
import 'package:registro/models/IEvento.dart';
import 'package:registro/models/Presenza.dart';
import 'package:registro/models/Studente.dart';
import 'package:registro/models/UscitaAnticipata.dart';
import 'package:registro/models/Utente.dart';
import 'package:registro/models/Voto.dart';

class GestoreEventi with IterableMixin {
  List<IEvento> _eventi = [];

  Future<void> scaricaEventi(DateTime data) async {
    Map<String, dynamic> dati = jsonDecode(await HttpRequest.get("/eventi?data=$data"));
    _eventi.clear();

    (dati["voti"] as List).forEach((data) {
      _eventi.add(Voto.fromData(data));
    });

    List presenze = dati["presenze"] as List;
    if (presenze != null)
      presenze.forEach((data) {
        int entrata = data["entrata"], uscita = data["uscita"];

        if (entrata > 1 && uscita < 6)
          _eventi.addAll([EntrataPosticipata.fromData(data), UscitaAnticipata.fromData(data)]);
        else if (entrata > 1)
          _eventi.add(EntrataPosticipata.fromData(data));
        else if (uscita < 6)
          _eventi.add(UscitaAnticipata.fromData(data));
        else
          _eventi.add(Presenza.fromData(data));
      });

    if (presenze != null && presenze.length == 0 && Utente.utenteLoggato.runtimeType == Studente) _eventi.add(new Assenza());
  }

  @override
  Iterator get iterator => _eventi.iterator;
  IEvento operator [](int index) => _eventi[index];
}
