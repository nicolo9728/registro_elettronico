class Utente {
  String username, _token;
  static Utente utenteLoggato;

  String get token => _token;

  Utente({this.username});
}
