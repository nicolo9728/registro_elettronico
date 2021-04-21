import 'package:flutter/material.dart';
import 'package:registro/models/IEvento.dart';

class EventoWidget extends StatelessWidget {
  final IEvento evento;
  const EventoWidget({this.evento});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: evento.colore,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            evento.nomeEvento,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 250,
                  child: Text(
                    evento.descrizioneEvento,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18),
                  )),
              Text(
                "${evento.data.day}/${evento.data.month}/${evento.data.year}",
                style: TextStyle(fontSize: 20),
              )
            ],
          )
        ],
      ),
    );
  }
}
