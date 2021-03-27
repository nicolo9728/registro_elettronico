import 'package:flutter/material.dart';
import 'package:registro/models/Utente.dart';
import 'package:registro/routes/Home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _txtUsername = TextEditingController(), _txtPassword = TextEditingController();
  void login() async {
    try {
      await Utente.login(_txtUsername.text, _txtPassword.text);
      if (Utente.loggato) {
        await Utente.salvaToken();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (route) => false);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Errore nel login"),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("ok"))
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("eseguire il login"),
      ),
      body: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _txtUsername,
                decoration: InputDecoration(hintText: "username"),
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _txtPassword,
                obscureText: true,
                decoration: InputDecoration(hintText: "password"),
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: login,
                  child: Text(
                    "login",
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
