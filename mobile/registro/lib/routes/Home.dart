import 'package:flutter/material.dart';
import 'package:registro/models/Docente.dart';
import 'package:registro/models/Utente.dart';
import 'package:registro/routes/Profilo.dart';
import 'DocenteHome.dart';
import 'StudenteHome.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Utente _utente = Utente.utenteLoggato;
  int _index = 0;

  List<Widget> routes;

  _HomeState() {
    this.routes = [
      _utente.home,
      Profilo(
        utente: Utente.utenteLoggato,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_utente.toString()),
      ),
      body: routes[_index],
      bottomNavigationBar: BottomNavigationBar(
        items: [BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"), BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "profilo")],
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
