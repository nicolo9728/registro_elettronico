import 'package:registro/models/IParametro.dart';

class Materia implements IParametro {
  String _nome, _descrizione;

  Materia(Map<String, dynamic> data) {
    _nome = data["nome"];
    _descrizione = data["descrizione"];
  }

  String get nome => _nome;
  String get descrizione => _descrizione;

  @override
  String get titolo => _nome;
}
