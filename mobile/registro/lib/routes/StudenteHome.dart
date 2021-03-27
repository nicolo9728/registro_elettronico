import 'package:flutter/material.dart';
import 'package:registro/models/Studente.dart';
import 'package:registro/models/Utente.dart';

class StudenteHome extends StatelessWidget {
  final Studente _studente = Utente.utenteLoggato as Studente;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(_studente.username), Text("Voti")],
        ),
      ),
      body: ListView.builder(
        itemCount: _studente.numeroVoti,
        itemBuilder: (context, index) => _studente[index].toWidget(),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black26,
        selectedItemColor: Colors.white60,
        unselectedItemColor: Colors.white60,
        items: [
          BottomNavigationBarItem(
              label: "voti",
              icon: Icon(
                Icons.book,
              )),
          BottomNavigationBarItem(label: "circolari", icon: Icon(Icons.label))
        ],
      ),
    );
  }
}
