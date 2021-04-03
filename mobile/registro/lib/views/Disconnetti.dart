import 'package:flutter/material.dart';
import 'package:registro/models/Utente.dart';
import 'package:registro/routes/Login.dart';

class Disconnetti extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: Colors.black,
            ),
            Text(
              "logout",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
        onPressed: () async {
          try {
            await Utente.logout();
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()), (route) => false);
          } catch (e) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("Errore"),
                      content: Text(e.toString()),
                    ));
          }
        },
      ),
    );
  }
}
