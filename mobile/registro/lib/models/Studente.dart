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

enum StatusStudente { Presente, Entrato, Uscito, Assente }

class Studente extends Utente with IterableMixin<GruppoVoti> {
  GestoreVoti _gestoreVoti = new GestoreVoti();
  StatusStudente _status;
  int _entrata, _uscita;

  Studente(Map<String, dynamic> data) : super(data) {
    List l = data["voti"] as List;
    List<Voto> voti = [];
    if (l != null)
      l.forEach((data) {
        voti.add(Voto.fromData(data));
      });

    int entrata = data["entrata"], uscita = data["uscita"];
    if (entrata != null && uscita != null) {
      if (uscita < 6)
        _status = StatusStudente.Uscito;
      else if (entrata > 1)
        _status = StatusStudente.Entrato;
      else
        _status = StatusStudente.Presente;
    } else
      _status = StatusStudente.Assente;

    this._entrata = entrata;
    this._uscita = uscita;

    _generaGruppi(voti);
  }

  void _generaGruppi(List<Voto> voti) {
    voti.forEach((voto) {
      _gestoreVoti.aggiungi(voto);
    });
  }

  int get numeroVoti => _gestoreVoti.totale;
  int get entrata => _entrata;
  int get uscita => _uscita;
  StatusStudente get status => _status;

  String get statusString {
    switch (status) {
      case StatusStudente.Assente:
        return "Assente";
        break;
      case StatusStudente.Presente:
        return "Presente";
        break;
      case StatusStudente.Entrato:
        return "Entrato/a";
        break;
      case StatusStudente.Uscito:
        return "Uscito/a";
        break;
      default:
        return "Non identificato";
        break;
    }
  }

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
    int somma = 0;
    List<Voto> voti = _gestoreVoti.list();
    voti.forEach((voto) {
      somma += voto.valutazione;
    });

    return somma / voti.length;
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

  void aggiornaStatus(StatusStudente status) {
    if (status == StatusStudente.Entrato && _status == StatusStudente.Uscito) return;

    _status = status;
  }

  Future<void> resetPresenza() async {
    await HttpRequest.post("/docenti/cancellaPresenza", jsonEncode({"idStudente": matricola}));
    _status = StatusStudente.Assente;
  }

  @override
  String toString() => "$username (Studente)";
}
