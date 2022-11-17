import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:e_sport_mobile/models/Turnir.dart';
import 'package:e_sport_mobile/pages/TurniriPregled.dart';
import 'package:e_sport_mobile/services/APIService.dart';
import 'package:intl/intl.dart';

class Turniri extends StatefulWidget {
  @override
  _TurniriState createState() => _TurniriState();
}

class _TurniriState extends State<Turniri> {
  String filter = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Turniri'),
        centerTitle: true,
      ),
      body: bodyWidget(),
    );
  }

  Widget bodyWidget() {
    return FutureBuilder<List<Turnir>>(
      future: GetTurniri(),
      builder: (BuildContext context, AsyncSnapshot<List<Turnir>> snapshot) {
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
            return ListView(
              children:
                  snapshot.data?.map((e) => TurnirWidget(e)).toList() ?? [],
            );
          }
        }
      },
    );
  }

  Future<List<Turnir>> GetTurniri() async {
    Map<String, String>? queryParams = {
      'KorisnikId': APIService.loggedUserId.toString()
    };
    List<String> includeList = ['Teren'];
    var turniri = await APIService.Get('Turnir', queryParams, includeList);
    if (turniri != null) {
      return turniri.map((i) => Turnir.fromJson(i)).toList();
    }
    return List.empty();
  }

  Widget TurnirWidget(turnir) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TurniriPregled(
                          turnir: turnir,
                        )));
          },
          child: Text(
            turnir.naziv + ' - ' +
            turnir.terenNaziv +
                ' - ' +
                DateFormat('dd.MM.yyyy').format(turnir.datumPocetka) +
                ' - ' +
                DateFormat('dd.MM.yyyy').format(turnir.datumKraja) +
                ' ' +
                turnir.vrijemePocetka.toString() +
                'h - ' +
                turnir.vrijemeKraja.toString() +
                'h - ' +
                turnir.ukupnaCijena.toString() +
                'KM',
            style: TextStyle(fontSize: 20),
          ),
        ),
        // child: Text(
        //   turnir.terenNaziv + ' - ' + DateFormat('dd.MM.yyyy').format(turnir.datumPocetka) + ' - ' + DateFormat('dd.MM.yyyy').format(turnir.datumKraja) + ' ' + turnir.vrijemePocetka.toString() + 'h - ' + turnir.vrijemeKraja.toString() + 'h - ' + turnir.ukupnaCijena.toString() + 'KM',
        //   style: TextStyle(fontSize: 20),
        // ),
      ),
    );
  }
}
