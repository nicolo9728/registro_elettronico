import 'dart:collection';

import 'package:registro/models/Voto.dart';

class GruppoVoti with IterableMixin<Voto> {
  List<Voto> _voti = [];
  String _materia;

  GruppoVoti(String materia) {
    _materia = materia;
  }

  String get materia => _materia;

  Voto operator [](int index) => _voti[index];

  bool operator ==(o) {
    GruppoVoti gruppoVoti = o;

    return gruppoVoti.materia == this.materia;
  }

  void aggiungiVoto(Voto voto) {
    _voti.add(voto);
  }

  double get media {
    int media = 0;
    _voti.forEach((v) {
      media += v.valutazione;
    });

    return media / _voti.length;
  }

  int get totale => _voti.length;

  @override
  Iterator<Voto> get iterator => _voti.iterator;
}
