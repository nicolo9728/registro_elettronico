import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class IEvento {
  String get nomeEvento;
  String get descrizioneEvento;
  Color get colore;
  DateTime get data;
  IconData get icona;
}
