import 'package:flutter/material.dart';
import 'package:e_sport_mobile/services/APIService.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  var result = null;
  Future<void> GetData() async {
    result = await APIService.Get('Korisnik');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(65),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'eSport',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900]),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    hintText: 'Korisničko ime'),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  hintText: 'Šifra',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.green[900],
                      borderRadius: BorderRadius.circular(15)),
                  child: TextButton(
                      onPressed: () async {
                        APIService.username = usernameController.text;
                        APIService.password = passwordController.text;
                        await GetData();
                        if (result != null) {
                        } else {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Pogresni kredencijali'),
                                    content: const Text(
                                        'Pogresno korisnicko ime ili lozinka!'),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Ok'),
                                          child: const Text('Ok')),
                                    ],
                                  ));
                        }
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
