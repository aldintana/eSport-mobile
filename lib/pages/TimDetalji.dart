import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:e_sport_mobile/models/Turnir.dart';
import 'package:e_sport_mobile/pages/TurniriPregled.dart';
import 'package:e_sport_mobile/models/Tim.dart';
import 'package:e_sport_mobile/services/APIService.dart';

class TimDetalji extends StatefulWidget {
  final Turnir? turnir;
  const TimDetalji({Key? key, this.turnir}) : super(key: key);
  @override
  _TimDetalji createState() => _TimDetalji();
}

class _TimDetalji extends State<TimDetalji> {
  TextEditingController nazivController = new TextEditingController();
  var result = null;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    nazivController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dodaj tim'),
        ),
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.max, children: [
          Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Column(children: [
                Padding(
                  padding: EdgeInsets.all(65),
                  child: TextFormField(
                    controller: nazivController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        hintText: 'Naziv'),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Naziv je obavezan!';
                        else
                          return null;
                      },
                  ),
                ),
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
                          var result = await CreateTim();
                          if (result != null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TurniriPregled(
                                      turnir: this.widget.turnir,
                                    )));
                                // .pushReplacementNamed('/tereni');
                          } else {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text(
                                          'Nije moguće dodati tim'),
                                      content: const Text(
                                          'Nije moguće dodati tim.'),
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
              ])))
        ])));
  }

  Future<dynamic> CreateTim() async {
    var tim =
        Tim(turnirId: this.widget.turnir!.id, naziv: nazivController.text, brojBodova: 0, brojDatihGolova: 0, brojNerijesenih: 0, brojPobjeda: 0, brojPoraza: 0, brojPrimljenihGolova: 0);
    result = await APIService.Post('Tim', jsonEncode(tim).toString());
    return result;
  }
}
