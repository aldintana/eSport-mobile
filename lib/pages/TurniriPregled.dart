import 'package:e_sport_mobile/pages/TimDetalji.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:e_sport_mobile/models/Turnir.dart';
import 'package:e_sport_mobile/models/Tim.dart';
import '../services/APIService.dart';

class TurniriPregled extends StatefulWidget {
  final Turnir? turnir;
  const TurniriPregled({Key? key, this.turnir}) : super(key: key);
  @override
  _TurniriPregled createState() => _TurniriPregled();
}

class _TurniriPregled extends State<TurniriPregled> {
  var result = null;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pregled turnira'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    this.widget.turnir?.naziv.toString() ?? '',
                    style: TextStyle(color: Colors.blue, fontSize: 30),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    ('Sport: ' + (this.widget.turnir?.terenNaziv ?? ' ')),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              if(this.widget.turnir?.isGenerisan == false)
              Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.green[900],
                      borderRadius: BorderRadius.circular(15)),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimDetalji(
                                  turnir: this.widget.turnir,
                                )));
                      },
                      child: Text(
                        'Dodaj tim',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ))),
              Expanded(child: bodyWidget()),
            ],
          ),
        ));
  }

    Widget bodyWidget() {
      return FutureBuilder<List<Tim>>(
        future: GetTimove(),
        builder: (BuildContext context, AsyncSnapshot<List<Tim>> snapshot) {
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
              return dataBody(snapshot.data?.toList() ?? []);
            }
          }
        },
      );
    }

    SingleChildScrollView dataBody(List<Tim> list)
    {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Naziv')),
            DataColumn(label: Text('P')),
            DataColumn(label: Text('N')),
            DataColumn(label: Text('I')),
            DataColumn(label: Text('DG')),
            DataColumn(label: Text('PG')),
            DataColumn(label: Text('B'))
          ],
          rows: list
              .map(
                (tim) => DataRow(
                cells: [
                  DataCell(
                      Text(tim.naziv ?? " ")
                  ),
                  DataCell(
                    Text(tim!.brojPobjeda.toString()),
                  ),
                  DataCell(
                    Text(tim!.brojNerijesenih.toString()),
                  ),
                  DataCell(
                    Text(tim!.brojPoraza.toString()),
                  ),
                  DataCell(
                    Text(tim!.brojDatihGolova.toString()),
                  ),
                  DataCell(
                    Text(tim!.brojPrimljenihGolova.toString()),
                  ),
                  DataCell(
                    Text(tim!.brojBodova.toString()),
                  ),
                ]),
          )
              .toList(),
        ),
      );
    }

  // Widget bodyWidget() {
  //   return FutureBuilder<List<Tim>>(
  //     future: GetTimove(),
  //     builder: (BuildContext context, AsyncSnapshot<List<Tim>> snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(
  //           child: Text('Loading...'),
  //         );
  //       } else {
  //         if (snapshot.hasError) {
  //           return Center(
  //             child: Text('${snapshot.error}'),
  //           );
  //         } else {
  //           return ListView(
  //             children:
  //             snapshot.data?.map((e) => TimWidget(e)).toList() ?? [],
  //           );
  //         }
  //       }
  //     },
  //   );
  // }

  Future<List<Tim>> GetTimove() async {
    Map<String, String>? queryParams = {
      'TurnirId': this.widget.turnir!.id.toString()
    };
    List<String> includeList = ['Turnir'];
    var timovi = await APIService.Get('Tim', queryParams, includeList);
    if (timovi != null) {
      return timovi.map((i) => Tim.fromJson(i)).toList();
    }
    return List.empty();
  }



  Widget TimWidget(tim) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          tim.naziv,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
