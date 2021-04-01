import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:registro/models/HttpRequest.dart';
import 'package:registro/models/Utente.dart';
import 'package:registro/models/Voto.dart';
import 'package:registro/views/StudenteProfilo.dart';

class Studente extends Utente with IterableMixin<Voto> {
  List<Voto> _voti = [];

  Studente(Map<String, dynamic> data) : super(data) {
    List l = data["voti"] as List;
    if (l != null)
      l.forEach((data) {
        _voti.add(Voto.fromData(data));
      });
  }

  int get numeroVoti => _voti.length;

  Future<void> aggiornaVoti() async {
    List data = jsonDecode(await HttpRequest.get("/studenti/voti"));
    print(data);
    _voti.clear();
    data.forEach((votoData) {
      _voti.add(Voto.fromData(votoData));
    });
  }

  Voto operator [](int index) => _voti[index];

  @override
  Widget get profilo => StudenteProfilo();

  @override
  Iterator<Voto> get iterator => _voti.iterator;

  @override
  String toString() => "$username (Studente)";
}
