import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Voto {
  int _valutazione;
  DateTime _data;
  String _nomeMateria, _descrizione, _nomeDocente;

  Voto(int valutazione, String nomeMateria, String descrizione, DateTime data) {
    this.data = data;
    this.descrizione = descrizione;
    this.nomeMateria = nomeMateria;
    this.valutazione = valutazione;
  }

  factory Voto.creaConDataOdierna(int valutazione, String nomeMateria, String descrizione) {
    return new Voto(valutazione, nomeMateria, descrizione, DateTime.now());
  }

  int get valutazione => _valutazione;
  set valutazione(int valutazione) {
    if (valutazione >= 1 && valutazione <= 10)
      _valutazione = valutazione;
    else
      throw new ArgumentError("la valutazione deve essere comprese tra 1 e 10");
  }

  DateTime get data => _data;
  set data(DateTime data) {
    if (data.compareTo(DateTime.now()) <= 0)
      _data = data;
    else
      throw new ArgumentError("data non valida");
  }

  String get nomeMateria => _nomeMateria;
  set nomeMateria(String nomeMateria) {
    if (nomeMateria.isNotEmpty)
      _nomeMateria = nomeMateria;
    else
      throw new ArgumentError("il nome materia non puo essere vuoto");
  }

  String get descrizione => _descrizione;
  set descrizione(String descrizione) {
    if (descrizione.length <= 50)
      _descrizione = descrizione;
    else
      throw new ArgumentError("la descrizione non puo superare i 50 caratteri");
  }

  String get nomeDocente => _nomeDocente;

  factory Voto.fromData(Map<String, dynamic> data) {
    Voto v = new Voto(data["valutazione"], data["nomemateria"], data["descrizione"], DateTime.parse(data["data"]));
    return v;
  }

  Widget toWidget() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: CircleAvatar(
                backgroundColor: valutazione >= 6 ? Colors.green[800] : Colors.red,
                child: Text(
                  valutazione.toString(),
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nomeMateria,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(descrizione),
                Text(data.toString())
              ],
            )
          ],
        ),
      );
}
