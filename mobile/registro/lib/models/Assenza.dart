import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:registro/models/IEvento.dart';

class Assenza implements IEvento {
  DateTime _data;

  Assenza(DateTime data) {
    _data = data;
  }

  @override
  Color get colore => Colors.red[800];

  @override
  DateTime get data => _data;

  @override
  String get descrizioneEvento => "L'alunno è stato assente";

  @override
  String get nomeEvento => "Assenza";

  @override
  IconData get icona => Icons.block;
}
