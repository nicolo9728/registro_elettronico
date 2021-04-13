import 'package:flutter/material.dart';
import 'package:registro/models/Circolare.dart';

class VisualizzaCircolare extends StatelessWidget {
  final Circolare circolare;

  VisualizzaCircolare({this.circolare});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Circolare N° ${circolare.numero}"), Text("Sede: ${circolare.nomeSede}")],
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                circolare.titolo,
                style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                circolare.contenuto,
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ));
  }
}
