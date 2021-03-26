import 'package:registro/models/Utente.dart';
import 'package:registro/models/Voto.dart';

class Studente extends Utente {
  List<Voto> _voti = [];

  Studente(Map<String, dynamic> dati) : super(dati["username"], dati["nome"], dati["cognome"], DateTime.parse(dati["dataNascita"])) {
    List l = dati["voti"] as List;
    l.forEach((data) {
      _voti.add(Voto.fromData(data));
    });
  }

  Future<void> aggiornaVoti() async {
    
  }

  Voto operator [](int index) => _voti[index];
}
