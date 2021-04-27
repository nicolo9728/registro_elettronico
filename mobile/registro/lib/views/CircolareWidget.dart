import 'package:flutter/material.dart';
import 'package:registro/models/Circolare.dart';

class CircolareWidget extends StatelessWidget {
  final Circolare circolare;
  final Function onTab;

  CircolareWidget({this.circolare, this.onTab});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromARGB(255, 28, 116, 217),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTab ?? () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.email,
                color: Colors.white60,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    circolare.titolo,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 300,
                    child: Text(
                      circolare.contenuto,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              Expanded(
                child: Text(
                  circolare.nomeSede,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
