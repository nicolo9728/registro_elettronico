import 'package:flutter/material.dart';
import 'package:registro/models/Docente.dart';
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

  _AggiungiVotoState(this.studente);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            FutureBuilder<List<Voto>>(
              future: utenteLoggato.ottieniVoti(studente),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) return Text(snapshot.error.toString());
                  List<Voto> voti = snapshot.data;
                  return Container(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: voti.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Wrap(
                          children: [voti[index].toWidget()],
                        ),
                      ),
                    ),
                  );
                } else
                  return Expanded(child: Caricamento());
              },
            ),
            Text("Inserisci il dati")
          ],
        ),
      ),
    );
  }
}
