import 'package:flutter/material.dart';
import 'package:e_sport_mobile/services/APIService.dart';
import 'package:e_sport_mobile/models/Korisnik.dart';

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
    if(result == null)
      return;
    var users = result.map((e) => Korisnik.fromJson((e))).toList();
    if(users.length > 0){
      var user = users.where((e)=> e.korisnickoIme == usernameController.text).first;
      APIService.loggedUserId = user.id;
    }
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900]),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    hintText: 'Korisničko ime'),
              ),
              SizedBox(
                height: 10,
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
                height: 10,
              ),
              Container(
                  height: 50,
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
                          Navigator.of(context).pushReplacementNamed('/tereni');
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
