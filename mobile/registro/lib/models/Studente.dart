import 'package:registro/models/Utente.dart';
import 'package:registro/models/Voto.dart';

class Studente extends Utente {
  List<Voto> _voti = [];

  Studente(Map<String, dynamic> data) : super(data["username"], data["nome"], data["cognome"], DateTime.parse(data["dataNascita"])) {
    List l = data["voti"] as List;
    l.forEach((data) {
      _voti.add(Voto.fromData(data));
    });
  }

  Future<void> aggiornaVoti() async {}

  Voto operator [](int index) => _voti[index];
}
