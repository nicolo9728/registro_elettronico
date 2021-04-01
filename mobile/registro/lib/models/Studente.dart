import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:registro/models/HttpRequest.dart';
import 'package:registro/models/Utente.dart';
import 'package:registro/models/Voto.dart';

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
  Iterator<Voto> get iterator => _voti.iterator;

  Widget toWidget() => Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              child: Text("${nome[0].toUpperCase()}${cognome[0].toUpperCase()}"),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$nome $cognome",
                  style: TextStyle(fontSize: 20),
                ),
                Text("${dataNascita.day}/${dataNascita.month}/${dataNascita.year}")
              ],
            )
          ],
        ),
      );
}
