import 'package:flutter/material.dart';
import 'package:registro/models/IEvento.dart';

class EventoWidget extends StatelessWidget {
  final IEvento evento;
  const EventoWidget({this.evento});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: evento.colore,
        ),
        child: Row(
          children: [
            Icon(
              evento.icona,
              color: Colors.white60,
              size: 30,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        evento.nomeEvento,
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${evento.data.day}/${evento.data.month}/${evento.data.year}",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                  Text(
                    evento.descrizioneEvento,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
