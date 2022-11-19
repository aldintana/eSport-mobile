import 'package:e_sport_mobile/pages/TerminiDetalji.dart';
import 'package:e_sport_mobile/pages/TurniriDetalji.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:e_sport_mobile/models/Teren.dart';
import 'package:e_sport_mobile/models/Sport.dart';

class TereniDetalji extends StatelessWidget {
  final Teren? teren;
  const TereniDetalji({Key? key, this.teren}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalji terena'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                teren?.naziv ?? '',
                style: TextStyle(color: Colors.blue, fontSize: 30),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                ('Sport: ' + (teren?.sportNaziv ?? ' ')),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Column(
            children: [
              Padding(padding: EdgeInsets.all(10)),
              Container(
                height: 50,
                width: 170,
                decoration: BoxDecoration(
                    color: Colors.green[900],
                    borderRadius: BorderRadius.circular(15)),
                child: TextButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TerminiDetalji(
                              teren: teren,
                              termin: null,
                            )));
                  },
                  child: Text(
                    'Novi termin',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              if(teren!.sportId == Sport.Fudbal)
              Container(
                height: 50,
                width: 170,
                decoration: BoxDecoration(
                    color: Colors.green[900],
                    borderRadius: BorderRadius.circular(15)),
                child: TextButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TurniriDetalji(
                                  teren: teren,
                                )));
                  },
                  child: Text(
                    'Novi turnir',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
