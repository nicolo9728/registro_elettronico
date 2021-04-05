import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:registro/models/Docente.dart';
import 'package:registro/models/HttpRequest.dart';
import 'package:registro/models/Studente.dart';

abstract class Utente {
  String _username, _nome, _cognome;
  int _matricola;
  DateTime _dataNascita;

  static String _token;
  static Utente utenteLoggato;

  String get nome => _nome;
  String get cognome => _cognome;
  DateTime get dataNascita => _dataNascita;
  String get username => _username;
  int get matricola => _matricola;
  Widget get home;

  static String get token => _token;

  Utente(Map<String, dynamic> data) {
    this._cognome = data["cognome"];
    this._nome = data["nome"];
    this._dataNascita = DateTime.parse(data["datanascita"]);
    this._username = data["username"];
    this._matricola = data["matricola"];
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
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

  static Future<void> salvaToken() async {
    String localPath = await _localPath;
    File file = new File("$localPath/token");

    if (!(await file.exists())) await file.create();

    await file.writeAsString(_token);
  }

  static Future<bool> autenticazione() async {
    bool successo = true;
    String localPath = await _localPath;
    File file = new File("$localPath/token");
    if (!(await file.exists())) successo = false;

    if (successo) _token = await file.readAsString();

    if (successo) await _scaricaDati();

    return successo;
  }

  static get loggato => token != null;

  static Future<void> logout() async {
    String localPath = await _localPath;
    File file = new File("$localPath/token");
    await file.delete();
    _token = null;
    utenteLoggato = null;
  }

  Widget get profilo;

  @override
  String toString() => "$username";
}
