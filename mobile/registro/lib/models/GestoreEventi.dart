import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:registro/models/HttpRequest.dart';
import 'package:registro/models/IEvento.dart';
import 'package:registro/models/Presenza.dart';
import 'package:registro/models/Voto.dart';

class GestoreEventi with IterableMixin {
  List<IEvento> _eventi = [];
  int _numeroGiorni;

  Future<void> scaricaEventi(DateTime data) async {
    Map<String, dynamic> dati = jsonDecode(await HttpRequest.get("/studenti/ottieniEventi?data=$data"));
    _eventi.clear();

    (dati["voti"] as List).forEach((data) {
      _eventi.add(Voto.fromData(data));
    });

    (dati["presenze"] as List).forEach((data) {
      _eventi.add(Presenza.fromData(data));
    });
  }

  @override
  Iterator get iterator => _eventi.iterator;
  IEvento operator [](int index) => _eventi[index];
}
