abstract class Utente {
  String _username, _token, _nome, _cognome;
  DateTime _dataNascita;

  static Utente utenteLoggato;

  String get nome => _nome;
  String get cognome => _cognome;
  DateTime get dataNascita => _dataNascita;
  String get username => _username;

  String get token => _token;

  Utente(String username, String nome, String cognome, DateTime dataNascita) {
    this._cognome = cognome;
    this._nome = nome;
    this._dataNascita = dataNascita;
    this._username = username;
  }
}
