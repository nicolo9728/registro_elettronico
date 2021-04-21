import 'package:flutter/material.dart';
import 'package:registro/models/GestoreEventi.dart';
import 'package:registro/routes/Caricamento.dart';
import 'package:registro/views/EventoWidget.dart';

class ListaEventi extends StatefulWidget {
  @override
  _ListaEventiState createState() => _ListaEventiState();
}

class _ListaEventiState extends State<ListaEventi> {
  GestoreEventi _gestoreEventi = new GestoreEventi();
  DateTime _dataSelezionata = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Data: ${_dataSelezionata.day}/${_dataSelezionata.month}/${_dataSelezionata.year}",
                style: TextStyle(fontSize: 20),
              ),
              TextButton(
                  onPressed: () async {
                    DateTime dataOdierna = DateTime.now();

                    DateTime data = await showDatePicker(
                        context: context, initialDate: _dataSelezionata, firstDate: DateTime(dataOdierna.year - 1), lastDate: DateTime(dataOdierna.year + 1));

                    if (data != null) {
                      setState(() {
                        _dataSelezionata = data;
                      });
                    }
                  },
                  child: Text(
                    "seleziona data",
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          ),
          FutureBuilder(
              future: _gestoreEventi.scaricaEventi(_dataSelezionata),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Expanded(
                    child: Container(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await _gestoreEventi.scaricaEventi(_dataSelezionata);
                          setState(() {});
                        },
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: EventoWidget(evento: _gestoreEventi[index]),
                            );
                          },
                          itemCount: _gestoreEventi.length,
                        ),
                      ),
                    ),
                  );
                } else
                  return Expanded(child: Caricamento());
              })
        ],
      ),
    );
  }
}
