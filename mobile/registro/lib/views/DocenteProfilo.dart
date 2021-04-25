import 'package:flutter/material.dart';
import 'package:registro/models/Docente.dart';
import 'package:registro/views/Disconnetti.dart';
import 'package:registro/views/ProfiloGeneralita.dart';
import 'package:registro/views/VisualizzatoreParametri.dart';

class DocenteProfilo extends StatelessWidget {
  final Docente docente;

  const DocenteProfilo({this.docente});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfiloGeneralita(
              utente: docente,
            ),
            SizedBox(
              height: 30,
            ),
            VisualizzatoreParametri(
              parametri: docente.map((element) => element).toList(),
              titolo: "Classi",
            ),
            SizedBox(
              height: 10,
            ),
            VisualizzatoreParametri(
              parametri: docente.materie,
              titolo: "Materie",
            ),
            SizedBox(
              height: 30,
            ),
            Disconnetti()
          ],
        ),
      ),
    );
  }
}
