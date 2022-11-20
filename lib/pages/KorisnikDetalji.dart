import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'package:e_sport_mobile/pages/Tereni.dart';
import 'package:flutter/material.dart';
import 'package:e_sport_mobile/models/Korisnik.dart';
import 'package:e_sport_mobile/services/APIService.dart';
import 'package:intl/intl.dart';

class KorisnikDetalji extends StatefulWidget {
  @override
  _KorisnikDetaljiState createState() => _KorisnikDetaljiState();
}

class _KorisnikDetaljiState extends State<KorisnikDetalji> {
  String filter = '';
  TextEditingController imeController = new TextEditingController();
  TextEditingController prezimeController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController brojTelefonaController = new TextEditingController();
  TextEditingController lozinkaController = new TextEditingController();
  TextEditingController lozinkaProvjeraController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        centerTitle: true,
      ),
      body: bodyWidget(),
    );
  }

  Widget bodyWidget() {
    return FutureBuilder<Korisnik>(
      future: GetKorisnik(),
      builder: (BuildContext context, AsyncSnapshot<Korisnik> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text('Loading...'),
          );
        } else {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            var korisnik = snapshot.data;
            imeController.text = korisnik!.ime ?? '';
            prezimeController.text = korisnik!.prezime ?? '';
            emailController.text = korisnik!.email ?? '';
            brojTelefonaController.text = korisnik!.brojTelefona ?? '';
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: KorisnikWidget(korisnik))
                ],
              ),
            );
          }
        }
      },
    );
  }

  Future<Korisnik> GetKorisnik() async {
    List<String> includeList = ['KorisnikUlogas'];
    var korisnik = await APIService.GetById(
        APIService.loggedUserId, 'Korisnik', null, includeList);
    if (korisnik != null) {
      return Korisnik.fromJson(korisnik);
    }
    return korisnik;
  }

  Widget KorisnikWidget(korisnik) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text('Ime'),
          TextFormField(
            controller: imeController,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Ime'),
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Ime je obavezno!';
              else
                return null;
            },
          ),
          SizedBox(height: 10),
          Text('Prezime'),
          TextFormField(
            controller: prezimeController,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Prezime'),
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Prezime je obavezno!';
              else
                return null;
            },
          ),
          SizedBox(height: 10),
          Text('Email'),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Email je obavezan!';
              else {
                if (!isEmailValid(value)) {
                  return 'Unesite valjan email format';
                } else
                  return null;
              }
            },
          ),
          SizedBox(height: 10),
          Text('Broj telefona'),
          TextFormField(
            controller: brojTelefonaController,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Broj telefona'),
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Broj telefona je obavezan!';
              else {
                if (!isBrojTelefonaValid(value)) {
                  return 'Format za broj telefona: 000-000-000 ili 000-000-0000';
                } else
                  return null;
              }
            },
          ),
          Text(
              'Napomena: lozinku unosite samo ako želite promijeniti trenutnu.'),
          SizedBox(height: 10),
          Text('Lozinka'),
          TextFormField(
            controller: lozinkaController,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Lozinka'),
          ),
          SizedBox(height: 10),
          Text('Potvrdi lozinku'),
          TextFormField(
            controller: lozinkaProvjeraController,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Potvrdi lozinku'),
            validator: (value) {
              if (value != lozinkaController.text)
                return 'Lozinke se ne podudaraju.';
              else
                return null;
            },
          ),
          SizedBox(height: 10),
          Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.green[900],
                  borderRadius: BorderRadius.circular(15)),
              child: TextButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    var result = await UpdateKorisnik();
                    if (result != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Tereni()));
                    } else {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Greška'),
                                content: const Text('Došlo je do greške'),
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
                    'Sačuvaj',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )))
        ],
      ),
    );
  }

  Future<dynamic> UpdateKorisnik() async {
    var korisnik = Korisnik(
        korisnickoIme: APIService.username,
        ime: imeController.text,
        prezime: prezimeController.text,
        email: emailController.text,
        brojTelefona: brojTelefonaController.text,
        lozinka: lozinkaController.text,
        lozinkaProvjera: lozinkaProvjeraController.text,
        updateUloga: false,
        bodovi: APIService.bodovi);
    var result = await APIService.Put(
        APIService.loggedUserId, 'Korisnik', jsonEncode(korisnik).toString());

    if(result != null && lozinkaController.text != "" && lozinkaController.text == lozinkaProvjeraController.text)
    {
      APIService.password = lozinkaController.text;
    }
    return result;
  }

  bool isEmailValid(String email) {
    RegExp regex = new RegExp(
        r"^(([^<>()[\]\\.,;:\s@']+(\.[^<>()[\]\\.,;:\s@']+)*)|('.+'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$");
    return regex.hasMatch(email);
  }

  bool isBrojTelefonaValid(String brojTelefona) {
    RegExp regex = new RegExp(r"^\d{3}-\d{3}-(\d{4}|\d{3})$");
    return regex.hasMatch(brojTelefona);
  }

  bool isPasswordValid(String password) {
    RegExp regex = new RegExp(
        r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$");
    return regex.hasMatch(password);
  }
}
