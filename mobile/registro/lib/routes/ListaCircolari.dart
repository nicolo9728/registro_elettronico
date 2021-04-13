import 'package:flutter/material.dart';
import 'package:registro/models/GestoreCircolari.dart';
import 'package:registro/routes/Caricamento.dart';
import 'package:registro/routes/VisualizzaCircolare.dart';

class ListaCircolari extends StatefulWidget {
  @override
  _ListaCircolariState createState() => _ListaCircolariState();
}

class _ListaCircolariState extends State<ListaCircolari> {
  GestoreCircolari _gestoreCircolari = new GestoreCircolari();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: FutureBuilder(
        future: _gestoreCircolari.scaricaCircolari(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: _gestoreCircolari.totale,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: _gestoreCircolari[index].toWidget(() {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VisualizzaCircolare(
                            circolare: _gestoreCircolari[index],
                          )));
                }),
              ),
            );
          } else
            return Caricamento();
        },
      ),
    );
  }
}
