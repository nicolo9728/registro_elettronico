import 'package:flutter/material.dart';
import 'package:registro/models/Docente.dart';
import 'package:registro/models/Materia.dart';
import 'package:registro/models/Studente.dart';
import 'package:registro/models/Utente.dart';
import 'package:registro/models/Voto.dart';
import 'package:registro/routes/Caricamento.dart';

class AggiungiVoto extends StatefulWidget {
  final Studente studente;

  const AggiungiVoto({this.studente}) : super();

  @override
  _AggiungiVotoState createState() => _AggiungiVotoState(studente);
}

class _AggiungiVotoState extends State<AggiungiVoto> {
  final Studente studente;
  final Docente utenteLoggato = Utente.utenteLoggato;
  Materia _materiaSelezionata;
  List<Voto> _voti;
  List<int> _votiTot = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int _votoSelezionato;
  TextEditingController _txtDescrizione = new TextEditingController();

  _AggiungiVotoState(this.studente);

  @override
  void initState() {
    super.initState();
    utenteLoggato.ottieniVoti(studente).then((value) {
      setState(() {
        _voti = value;
      });
    }).catchError((error) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("errore"),
                content: Text(error.toString()),
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(bottom: 50),
        color: Color.fromARGB(255, 30, 33, 43),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Voti",
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(height: 30),
              _voti != null
                  ? Container(
                      height: 70,
                      alignment: Alignment.center,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _voti.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Wrap(
                            children: [_voti[index].toWidget()],
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 70,
                      child: Caricamento(),
                    ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Aggiungi voto",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "descrizione"),
                style: TextStyle(color: Colors.white60),
                controller: _txtDescrizione,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<Materia>(
                    hint: Text("seleziona materia"),
                    items: utenteLoggato.materie
                        .map((e) => DropdownMenuItem<Materia>(
                            value: e,
                            child: Text(
                              e.nome,
                              style: TextStyle(color: Colors.white60),
                            )))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _materiaSelezionata = value;
                      });
                    },
                    value: _materiaSelezionata,
                    focusColor: Colors.white60,
                    dropdownColor: Color.fromARGB(255, 30, 33, 43),
                  ),
                  DropdownButton(
                      value: _votoSelezionato,
                      hint: Text("valutazione"),
                      dropdownColor: Color.fromARGB(255, 30, 33, 43),
                      onChanged: (value) {
                        setState(() {
                          _votoSelezionato = value;
                        });
                      },
                      items: _votiTot.map((e) => DropdownMenuItem(value: e, child: Text(e.toString(), style: TextStyle(color: Colors.white60)))).toList())
                ],
              ),
              SizedBox(height: 20),
              TextButton(
                  onPressed: () async {
                    try {
                      Voto voto = new Voto.creaConDataOdierna(
                        _votoSelezionato,
                        _materiaSelezionata?.nome ?? "",
                        _txtDescrizione.text,
                      );
                      await utenteLoggato.caricaVoto(studente, voto);
                      Navigator.pop(context);
                    } catch (e) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("impossibile caricare il voto"),
                                content: Text(e.toString()),
                              ));
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      Text(
                        "aggiungi voto",
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
