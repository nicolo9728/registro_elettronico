import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:registro/models/Classe.dart';
import 'package:registro/models/Docente.dart';
import 'package:registro/models/Studente.dart';
import 'package:registro/models/Utente.dart';
import 'AggiungiVoto.dart';

class DocenteHome extends StatefulWidget {
  @override
  _DocenteHomeState createState() => _DocenteHomeState();
}

class _DocenteHomeState extends State<DocenteHome> {
  Docente _docente = Utente.utenteLoggato;
  Classe _classeSelezionata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_docente.username),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Classe",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.white60, borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButton<Classe>(
                      isDense: false,
                      items: _docente
                          .map((classe) => DropdownMenuItem<Classe>(
                              value: classe,
                              child: Text(
                                classe.nome,
                                style: TextStyle(fontSize: 20),
                              )))
                          .toList(),
                      onChanged: (value) async {
                        await value.scaricaStudenti();
                        print(value[0].nome);
                        setState(() {
                          _classeSelezionata = value;
                        });
                      },
                      value: _classeSelezionata,
                      iconEnabledColor: Colors.black,
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: _classeSelezionata?.numeroStudenti ?? 0,
                      itemBuilder: (context, index) => InkWell(
                            child: _classeSelezionata[index].toWidget(),
                            onTap: () {
                              Studente studente = _classeSelezionata[index];
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => AggiungiVoto(
                                        studente: studente,
                                      ));
                            },
                          )))
            ],
          ),
        ));
  }
}
