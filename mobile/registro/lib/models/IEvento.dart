import 'package:flutter/cupertino.dart';

abstract class IEvento {
  String get nomeEvento;
  String get descrizioneEvento;
  Color get colore;
  DateTime get data;
}
