class Materia {
  String _nome, _descrizione;

  Materia(Map<String, dynamic> data) {
    _nome = data["nome"];
    _descrizione = data["descrizione"];
  }

  String get nome => _nome;
  String get descrizione => _descrizione;
}
