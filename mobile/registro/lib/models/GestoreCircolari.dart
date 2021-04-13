import 'dart:convert';

import 'package:registro/models/Circolare.dart';
import 'package:registro/models/HttpRequest.dart';

class GestoreCircolari {
  List<Circolare> _circolari = [];

  Circolare operator [](int index) => _circolari[index];
  int get totale => _circolari.length;

  void _generaCircolari(List data) {
    _circolari.clear();
    data.forEach((value) {
      _circolari.add(new Circolare(value));
    });
  }

  Future<void> scaricaCircolari() async {
    List data = jsonDecode(await HttpRequest.get("/circolari/"));
    _generaCircolari(data);
  }

  Future<void> scaricaCircolariConSede(String nomeSede) async {
    List data = jsonDecode(await HttpRequest.get("/circolari/?nomeSede=$nomeSede"));
    _generaCircolari(data);
  }
}
