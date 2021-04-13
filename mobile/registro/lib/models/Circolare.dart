import 'package:flutter/cupertino.dart';
import 'package:registro/views/CircolareWidget.dart';

class Circolare {
  String _titolo, _contenuto, _nomeSede;
  int _numero;

  Circolare(Map<String, dynamic> data) {
    _titolo = data["titolo"];
    _contenuto = data["contenuto"];
    _nomeSede = data["nomesede"];
    _numero = data["numero"];
  }

  String get titolo => _titolo;
  String get contenuto => _contenuto;
  String get nomeSede => _nomeSede;
  int get numero => _numero;

  Widget toWidget(Function onTap) => CircolareWidget(
        circolare: this,
        onTab: onTap,
      );
}
