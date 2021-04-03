import 'package:flutter/material.dart';
import 'package:registro/models/Voto.dart';

class VotoWidget extends StatelessWidget {
  final Voto voto;

  const VotoWidget({this.voto});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            height: 60,
            width: 60,
            child: CircleAvatar(
              backgroundColor: voto.valutazione >= 6 ? Colors.green[800] : Colors.red,
              child: Text(
                voto.valutazione.toString(),
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                voto.nomeMateria,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(voto.descrizione),
              Text("${voto.data.day}/${voto.data.month}/${voto.data.year}")
            ],
          )
        ],
      ),
    );
  }
}
