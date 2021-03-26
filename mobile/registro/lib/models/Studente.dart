import 'dart:convert';

import 'package:registro/models/HttpRequest.dart';
import 'package:registro/models/Utente.dart';
import 'package:registro/models/Voto.dart';

class Studente extends Utente {
  List<Voto> _voti = [];

  Studente(Map<String, dynamic> data) : super(data) {
    List l = data["voti"] as List;
    l.forEach((data) {
      _voti.add(Voto.fromData(data));
    });
  }

  Future<void> aggiornaVoti() async {
    Map<String, dynamic> data = jsonDecode(await HttpRequest.get("studenti/voti"));
    _voti.clear();

    (data as List).forEach((votoData) {
      _voti.add(Voto.fromData(votoData));
    });
  }

  Voto operator [](int index) => _voti[index];
}
