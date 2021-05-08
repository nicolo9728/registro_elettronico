import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:registro/models/Classe.dart';
import 'package:registro/models/Docente.dart';
import 'package:registro/models/Studente.dart';
import 'package:registro/models/Utente.dart';
import 'package:registro/routes/Caricamento.dart';
import 'package:registro/routes/GestioneStudente.dart';
import 'package:registro/views/StudenteItem.dart';

class DocenteHome extends StatefulWidget {
  @override
  _DocenteHomeState createState() => _DocenteHomeState();
}

class _DocenteHomeState extends State<DocenteHome> {
  Docente _docente = Utente.utenteLoggato;
  Classe _classeSelezionata;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  hint: Text(
                    "sez.",
                    style: TextStyle(color: Colors.black),
                  ),
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
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: RefreshIndicator(
            onRefresh: () async {
              await _classeSelezionata.scaricaStudenti();
              setState(() {});
            },
            child: FutureBuilder(
                future: _classeSelezionata?.scaricaStudenti() ?? null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return ListView.builder(
                        itemCount: _classeSelezionata?.numeroStudenti ?? 0,
                        itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: StudenteItem(
                                studente: _classeSelezionata[index],
                                onTap: () async {
                                  Studente studente = _classeSelezionata[index];
                                  await Navigator.of(context).push(MaterialPageRoute(builder: (context) => GestioneStudente(studente)));
                                  setState(() {});
                                },
                              ),
                            ));
                  else if (snapshot.connectionState == ConnectionState.waiting)
                    return Caricamento();
                  else
                    return Center(
                      child: Text(
                        "Seleziona una classe",
                        style: TextStyle(fontSize: 30),
                      ),
                    );
                }),
          ))
        ],
      ),
    );
  }
}
