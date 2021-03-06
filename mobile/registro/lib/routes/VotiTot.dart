import 'package:flutter/material.dart';
import 'package:registro/models/Studente.dart';
import 'package:registro/routes/Caricamento.dart';
import 'package:registro/views/VotoWidget.dart';

class VotiTot extends StatefulWidget {
  Studente studente;

  VotiTot({this.studente});

  @override
  _VotiTotState createState() => _VotiTotState(studente);
}

class _VotiTotState extends State<VotiTot> {
  Studente _studente;

  _VotiTotState(Studente studente) {
    _studente = studente;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _studente.aggiornaVoti();
        setState(() {});
      },
      child: FutureBuilder(
        future: _studente.aggiornaVoti(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return Container(
              child: ListView.builder(
                itemCount: _studente.numeroMaterie,
                itemBuilder: (context, index) => ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _studente[index].materia,
                        style: TextStyle(color: Colors.white60, fontSize: 25),
                      ),
                      Text(
                        _studente[index].media.toStringAsFixed(2),
                        style: TextStyle(color: Colors.white70),
                      )
                    ],
                  ),
                  children: _studente[index].map((element) => VotoWidget(voto: element)).toList(),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
            );
          else
            return Caricamento();
        },
      ),
    );
  }
}
