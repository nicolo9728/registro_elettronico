import 'package:flutter/material.dart';
import 'package:registro/models/Studente.dart';
import 'package:registro/models/Utente.dart';
import 'package:registro/routes/Caricamento.dart';
import 'package:registro/views/VotoWidget.dart';

class StudenteHome extends StatefulWidget {
  @override
  _StudenteHomeState createState() => _StudenteHomeState();
}

class _StudenteHomeState extends State<StudenteHome> {
  final Studente _studente = Utente.utenteLoggato as Studente;
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
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: ExpansionTile(
                    collapsedBackgroundColor: Color.fromARGB(255, 28, 116, 217),
                    backgroundColor: Color.fromARGB(100, 28, 116, 217),
                    title: Row(
                      children: [
                        Icon(
                          Icons.all_inbox,
                          color: Colors.white60,
                          size: 35,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            _studente[index].materia,
                            style: TextStyle(color: Colors.white60, fontSize: 25, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                value: _studente[index].media / 10,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                              ),
                            ),
                            Text(
                              _studente[index].media.toStringAsFixed(1),
                              style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w800),
                            )
                          ],
                        )
                      ],
                    ),
                    children: _studente[index]
                        .map((element) => Padding(
                              padding: EdgeInsets.all(8.0),
                              child: VotoWidget(voto: element),
                            ))
                        .toList(),
                  ),
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
