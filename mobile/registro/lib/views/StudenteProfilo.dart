import 'package:flutter/material.dart';
import 'package:registro/models/Studente.dart';
import 'package:registro/views/Disconnetti.dart';
import 'package:registro/views/ProfiloGeneralita.dart';

class StudenteProfilo extends StatelessWidget {
  final Studente profilo;

  const StudenteProfilo({this.profilo});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfiloGeneralita(
            utente: profilo,
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 60),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "media voti",
                      style: TextStyle(fontSize: 40, color: Colors.white70),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: CircularProgressIndicator(
                            value: profilo.media / 10,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                          ),
                        ),
                        Text(
                          profilo.media.toStringAsFixed(1),
                          style: TextStyle(fontSize: 35),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Disconnetti()
        ],
      ),
    );
  }
}
