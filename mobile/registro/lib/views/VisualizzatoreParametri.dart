import 'package:flutter/material.dart';
import 'package:registro/models/IParametro.dart';

class VisualizzatoreParametri extends StatelessWidget {
  final List<IParametro> parametri;
  final String titolo;

  const VisualizzatoreParametri({this.parametri, this.titolo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titolo, style: TextStyle(fontSize: 30)),
        Container(
          height: 100,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: parametri.length,
              itemBuilder: (context, index) => Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: 10),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Text(
                          parametri[index].titolo,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                  )),
        ),
      ],
    );
  }
}
