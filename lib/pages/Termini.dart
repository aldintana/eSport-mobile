import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:e_sport_mobile/models/Termin.dart';
import 'package:e_sport_mobile/services/APIService.dart';
import 'package:intl/intl.dart';

class Termini extends StatefulWidget {
  @override
  _TerminiState createState() => _TerminiState();
}

class _TerminiState extends State<Termini> {
  String filter = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Termini'),
        centerTitle: true,
      ),
      body: bodyWidget(),
    );
  }

  Widget bodyWidget() {
    return FutureBuilder<List<Termin>>(
      future: GetTermini(),
      builder: (BuildContext context, AsyncSnapshot<List<Termin>> snapshot) {
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
                  snapshot.data?.map((e) => TerminWidget(e)).toList() ?? [],
            );
          }
        }
      },
    );
  }

  Future<List<Termin>> GetTermini() async {
    Map<String, String>? queryParams = {
      'KorisnikId': APIService.loggedUserId.toString()
    };
    List<String> includeList = ['Teren'];
    var termini = await APIService.Get('Termin', queryParams, includeList);
    if (termini != null) {
      return termini.map((i) => Termin.fromJson(i)).toList();
    }
    return List.empty();
  }

  Widget TerminWidget(termin) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          termin.terenNaziv +
              ' - ' +
              DateFormat('dd.MM.yyyy').format(termin.datum) +
              ' - ' +
              termin.pocetak.hour.toString() +
              'h - ' +
              termin.kraj.hour.toString() +
              'h ' +
              termin.ukupnaCijena.toString() +
              'KM',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
