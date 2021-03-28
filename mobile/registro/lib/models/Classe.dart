import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:registro/models/HttpRequest.dart';
import 'package:registro/models/Studente.dart';

class Classe with IterableMixin<Studente> {
  String _nome;
  int _id;
  List<Studente> _studenti;

  Classe(Map<String, dynamic> data) {
    _nome = data["nome"];
    _id = data["idclasse"];
    _studenti = [];
  }

  String get nome => _nome;
  int get numeroStudenti => _studenti.length;

  Studente operator [](int index) => _studenti[index];

  Future<void> scaricaStudenti() async {
    List data = jsonDecode(await HttpRequest.get("/docenti/ottieniStudenti?idClasse=$_id"));

    data.forEach((element) {
      _studenti.add(new Studente(element as Map<String, dynamic>));
    });
  }

  Widget toWidget() => SizedBox(
        height: 30,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _nome,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  @override
  Iterator<Studente> get iterator => _studenti.iterator;
}
