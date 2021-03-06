import 'dart:collection';

import 'package:registro/models/GruppoVoti.dart';
import 'package:registro/models/Voto.dart';

class GestoreVoti with IterableMixin<GruppoVoti> {
  List<GruppoVoti> _gruppi = [];

  void aggiungi(Voto voto) {
    int index = _gruppi.indexWhere((gruppo) => gruppo.materia == voto.nomeMateria);

    if (index < 0) {
      GruppoVoti gruppo = new GruppoVoti(voto.nomeMateria);
      gruppo.aggiungiVoto(voto);
      _gruppi.add(gruppo);
    } else
      _gruppi[index].aggiungiVoto(voto);
  }

  GruppoVoti operator [](int index) => _gruppi[index];

  int get totale {
    int tot = 0;

    _gruppi.forEach((element) {
      tot += element.totale;
    });

    return tot;
  }

  void cancella() {
    _gruppi.clear();
  }

  List<Voto> list({bool growable = true}) {
    List<Voto> voti = [];
    _gruppi.forEach((element) {
      element.forEach((element) {
        voti.add(element);
      });
    });

    voti.sort();

    return voti;
  }

  @override
  Iterator<GruppoVoti> get iterator => _gruppi.iterator;
}
