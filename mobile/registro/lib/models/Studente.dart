import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:registro/models/GestoreVoti.dart';
import 'package:registro/models/GruppoVoti.dart';
import 'package:registro/models/HttpRequest.dart';
import 'package:registro/models/Utente.dart';
import 'package:registro/models/Voto.dart';
import 'package:registro/routes/StudenteHome.dart';
import 'package:registro/views/StudenteProfilo.dart';

class Studente extends Utente with IterableMixin<GruppoVoti> {
  GestoreVoti _gestoreVoti = new GestoreVoti();

  Studente(Map<String, dynamic> data) : super(data) {
    List l = data["voti"] as List;
    List<Voto> voti = [];
    if (l != null)
      l.forEach((data) {
        voti.add(Voto.fromData(data));
      });

    _generaGruppi(voti);
  }

  void _generaGruppi(List<Voto> voti) {
    voti.forEach((voto) {
      _gestoreVoti.aggiungi(voto);
    });
  }

  int get numeroVoti => _gestoreVoti.totale;

  @override
  Widget get home => StudenteHome();

  Future<void> aggiornaVoti() async {
    List data = jsonDecode(await HttpRequest.get("/studenti/voti"));

    _gestoreVoti.cancella();
    List<Voto> voti = [];
    data.forEach((votoData) {
      voti.add(Voto.fromData(votoData));
    });

    _generaGruppi(voti);
  }

  double get media {
    return 0;
  }

  GruppoVoti operator [](int index) => _gestoreVoti[index];

  @override
  Widget get profilo => StudenteProfilo(
        profilo: this,
      );

  @override
  Iterator<GruppoVoti> get iterator => _gestoreVoti.iterator;

  List<GruppoVoti> get voti {
    return _gestoreVoti.toList();
  }

  int get numeroMaterie => _gestoreVoti.length;

  @override
  String toString() => "$username (Studente)";
}
