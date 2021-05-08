import 'package:flutter/material.dart';
import 'package:registro/models/Assenza.dart';
import 'package:registro/models/EntrataPosticipata.dart';
import 'package:registro/models/Presenza.dart';
import 'package:registro/models/Studente.dart';
import 'package:registro/models/UscitaAnticipata.dart';
import 'package:registro/routes/AggiungiVoto.dart';
import 'package:registro/views/ProfiloGeneralita.dart';

class GestioneStudente extends StatefulWidget {
  Studente _studente;

  GestioneStudente(Studente studente) {
    _studente = studente;
  }

  @override
  _GestioneStudenteState createState() => _GestioneStudenteState(_studente);
}

class _GestioneStudenteState extends State<GestioneStudente> {
  Studente _studente;
  StatusStudente _status;
  String status = "";
  int _ora;
  List<int> _oreValide = [1, 2, 3, 4, 5, 6];

  _GestioneStudenteState(Studente studente) {
    _studente = studente;
    _status = studente.status;
  }

  Future<void> segna() async {
    try {
      Presenza p;
      if (_status == StatusStudente.Presente)
        p = new Presenza();
      else if (_status == StatusStudente.Uscito)
        p = new UscitaAnticipata(_ora);
      else if (_status == StatusStudente.Entrato)
        p = new EntrataPosticipata(_ora);
      else
        p = new Assenza();

      await p.segna(_studente);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Errore"),
                content: Text(e.message),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestione Studente"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfiloGeneralita(
              utente: _studente,
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Status",
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    _studente.statusString,
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    "Imposta status:",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Flexible(
                    child: DropdownButton<StatusStudente>(
                      onChanged: (value) {
                        setState(() {
                          _status = value;
                        });
                      },
                      value: _status,
                      dropdownColor: Color.fromARGB(255, 30, 33, 43),
                      hint: Text("status"),
                      items: StatusStudente.values
                          .map((status) => DropdownMenuItem<StatusStudente>(
                              value: status,
                              child: Container(
                                child: Text(
                                  status.toString().split('.').last,
                                  style: TextStyle(color: Colors.white60),
                                ),
                              )))
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  if (_status == StatusStudente.Entrato || _status == StatusStudente.Uscito)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<int>(
                            hint: Text("ora"),
                            value: _ora,
                            dropdownColor: Color.fromARGB(255, 30, 33, 43),
                            onChanged: (value) {
                              setState(() {
                                _ora = value;
                              });
                            },
                            items: _oreValide
                                .map((e) => DropdownMenuItem<int>(
                                    value: e,
                                    child: Text(
                                      e.toString(),
                                      style: TextStyle(color: Colors.white60),
                                    )))
                                .toList()),
                        SizedBox(
                          width: 20,
                        ),
                        TextButton(
                            onPressed: segna,
                            child: Text(
                              "segna",
                              style: TextStyle(color: Colors.black),
                            ))
                      ],
                    )
                  else
                    TextButton(
                        onPressed: segna,
                        child: Text(
                          "segna",
                          style: TextStyle(color: Colors.black),
                        ))
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AggiungiVoto(
            studente: _studente,
          ),
        )),
        icon: Icon(
          Icons.add,
          size: 30,
        ),
        label: Text(
          "Voto",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
