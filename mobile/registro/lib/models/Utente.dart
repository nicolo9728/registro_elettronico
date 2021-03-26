import 'dart:convert';
import 'dart:io';

import 'package:registro/models/Docente.dart';
import 'package:registro/models/HttpRequest.dart';
import 'package:registro/models/Studente.dart';

abstract class Utente {
  String _username, _nome, _cognome;
  DateTime _dataNascita;

  static String _token;
  static Utente utenteLoggato;

  String get nome => _nome;
  String get cognome => _cognome;
  DateTime get dataNascita => _dataNascita;
  String get username => _username;

  static String get token => _token;

  Utente(String username, String nome, String cognome, DateTime dataNascita) {
    this._cognome = cognome;
    this._nome = nome;
    this._dataNascita = dataNascita;
    this._username = username;
  }

  static Future<void> login(String username, String password) async {
    String token = await HttpRequest.post("/utenti/login", jsonEncode({"username": username, "password": password}));
    _token = token;
    await _scaricaDati();
  }

  static Future<void> _scaricaDati() async {
    Map<String, dynamic> data = jsonDecode(await HttpRequest.get("/utenti/"));

    if (data["tipo"] == "Docente")
      utenteLoggato = new Docente(data);
    else
      utenteLoggato = new Studente(data);
  }

  static void salvaToken() async {
    File file = new File("token");

    if (!(await file.exists())) await file.create();

    await file.writeAsString(_token);
  }

  static Future<bool> autenticazione() async {
    bool successo = true;

    File file = new File("token");
    if (!(await file.exists())) successo = false;

    if (successo) _token = await file.readAsString();

    if (successo) await _scaricaDati();

    return successo;
  }

  static void logout() async {
    File file = new File("token");
    await file.delete();
  }
}
