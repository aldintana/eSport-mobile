import 'package:e_sport_mobile/models/Cjenovnik.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:e_sport_mobile/models/Turnir.dart';
import 'package:e_sport_mobile/models/Teren.dart';
import 'package:intl/intl.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:e_sport_mobile/services/APIService.dart';

class TurniriDetalji extends StatefulWidget {
  final Turnir? turnir;
  final Teren? teren;
  const TurniriDetalji({Key? key, this.teren, this.turnir}) : super(key: key);
  @override
  _TurniriDetalji createState() => _TurniriDetalji();
}

class _TurniriDetalji extends State<TurniriDetalji> {
  TextEditingController datumController = new TextEditingController();
  TextEditingController cijenaController = new TextEditingController();
  TextEditingController nazivController = new TextEditingController();
  int vrijemePocetka = 9;
  int vrijemeZavrsetka = 10;
  Cjenovnik? _selectedCjenovnik = null;
  int _cijena = 0;
  DateTime? _datumPocetka;
  DateTime? _datumKraja;
  var pocetak = [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22];
  var kraj = [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23];
  List<DropdownMenuItem> _cjenovnici = [];
  bool isPopust = false;
  var result = null;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    datumController.text = "";
    cijenaController.text = "Cijena: $_cijena KM";
    nazivController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalji turnira'),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  this.widget.teren?.naziv.toString() ?? '',
                  style: TextStyle(color: Colors.blue, fontSize: 30),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  ('Sport: ' + (this.widget.teren?.sportNaziv ?? ' ')),
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    TextFormField(
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
                    Container(
                      height: 50,
                      // width: 170,
                      child: TextFormField(
                        controller: datumController,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            labelText: "Odaberite period"),
                        readOnly: true,
                        onTap: () async {
                          DateTimeRange? pickedDate = await showDateRangePicker(
                              context: context,
                              initialDateRange: DateTimeRange(
                                  start: DateTime.now(), end: DateTime.now()),
                              firstDate: DateTime(DateTime.now().year),
                              lastDate: DateTime(2101));
                          if (pickedDate != null) {
                            String formattedDate = DateFormat('dd.MM.yyyy')
                                    .format(pickedDate.start) +
                                ' - ' +
                                DateFormat('dd.MM.yyyy').format(pickedDate.end);
                            setState(() {
                              datumController.text = formattedDate;
                              _datumPocetka = pickedDate.start;
                              _datumKraja = pickedDate.end;
                              IzracunajCijenu();
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Datum je obavezan!';
                          else
                            return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: HexColor('#ecedec'),
                        labelText: 'Vrijeme početka',
                      ),
                      items: pocetak.map<DropdownMenuItem<int>>((int item) {
                        return DropdownMenuItem<int>(
                          value: item,
                          child: Text(item.toString()),
                        );
                      }).toList(),
                      value: vrijemePocetka,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      onChanged: (int? newValue) {
                        setState(() {
                          vrijemePocetka = newValue!;
                          if (vrijemeZavrsetka <= vrijemePocetka)
                            vrijemeZavrsetka = vrijemePocetka + 1;
                          IzracunajCijenu();
                        });
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: HexColor('#ecedec'),
                        labelText: 'Vrijeme završetka',
                      ),
                      items: kraj.map<DropdownMenuItem<int>>((int item) {
                        return DropdownMenuItem<int>(
                          value: item,
                          child: Text(item.toString()),
                        );
                      }).toList(),
                      value: vrijemeZavrsetka,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      onChanged: (int? newValue) {
                        setState(() {
                          if (newValue! > vrijemePocetka) {
                            vrijemeZavrsetka = newValue!;
                            IzracunajCijenu();
                          } else {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Pogrešno vrijeme'),
                                      content: const Text(
                                          'Vrijeme završetka mora biti veće od vremena početka'),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'Ok'),
                                            child: const Text('Ok')),
                                      ],
                                    ));
                          }
                        });
                      },
                      validator: (value) {
                        if (value! < vrijemePocetka)
                          return 'Vrijeme zavrsetka mora biti vece od vremena pocetka';
                        else
                          return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CjenovnikDropDownWidget(),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: cijenaController,
                      readOnly: true,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    if (APIService.bodovi >= 40)
                      CheckboxListTile(
                          title: Text('Iskoristi popust'),
                          value: isPopust,
                          onChanged: (bool? value) {
                            setState(() {
                              isPopust = value!;
                              IzracunajCijenu();
                            });
                          }),
                    SizedBox(
                      height: 15,
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
                              var result = await CreateTurnir();
                              if (result != null && result != "204" && result != "500") {
                                Navigator.of(context)
                                    .pushReplacementNamed('/tereni');
                              } else {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text(
                                              'Nije moguće dodati turnir'),
                                          content: const Text(
                                              'Nije moguće dodati turnir. Pokušajte drugi datum/satnicu'),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'Ok'),
                                                child: const Text('Ok')),
                                          ],
                                        ));
                              }
                            },
                            child: Text(
                              'Sačuvaj',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )))
                  ],
                )))
          ],
        ),
      )),
    );
  }

  Widget CjenovnikDropDownWidget() {
    return FutureBuilder<List<Cjenovnik>>(
        future: GetCjenovnike(_selectedCjenovnik),
        builder:
            (BuildContext context, AsyncSnapshot<List<Cjenovnik>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            return DropdownButtonFormField<dynamic>(
              hint: Text('Cjenovnik'),
              isExpanded: true,
              items: _cjenovnici,
              onChanged: (newVal) {
                setState(() {
                  _selectedCjenovnik = newVal as Cjenovnik;
                  IzracunajCijenu();
                });
              },
              value: _selectedCjenovnik,
              validator: (value) {
                if (value == null)
                  return 'Cjenovnik je obavezan!';
                else
                  return null;
              },
            );
          }
        });
  }

  Future<List<Cjenovnik>> GetCjenovnike(Cjenovnik? selectedValue) async {
    Map<String, String> queryParams = {
      'TerenId': this.widget.teren!.id.toString()
    };
    List<String> includeList = ['TipRezervacije'];
    var cjenovnici =
        await APIService.Get('Cjenovnik', queryParams, includeList);
    var cjenovniciList = cjenovnici!.map((i) => Cjenovnik.fromJson(i)).toList();
    _cjenovnici = cjenovniciList.map((item) {
      return DropdownMenuItem<Cjenovnik>(
          child: Text(item.naziv ?? ''), value: item);
    }).toList();
    if (selectedValue != null && selectedValue.id != 0) {
      _selectedCjenovnik = cjenovniciList
          .where((element) => element.id == selectedValue.id)
          .first;
    }
    return cjenovniciList;
  }

  void IzracunajCijenu() {
    if (_selectedCjenovnik != null &&
        _datumKraja != null &&
        _datumKraja != null) {
      if (_selectedCjenovnik!.isDnevna == true) {
        _cijena = ((_datumKraja!.difference(_datumPocetka!).inDays + 1) *
            (_selectedCjenovnik?.cijena ?? 0));
      } else {
        _cijena = (_datumKraja!.difference(_datumPocetka!).inDays + 1) *
            (vrijemeZavrsetka - vrijemePocetka) *
            (_selectedCjenovnik?.cijena ?? 0);
      }
      if (isPopust) {
        _cijena = _cijena - (_cijena ~/ 10);
      }
      cijenaController.text = "Cijena: $_cijena KM";
    }
  }

  Future<dynamic> CreateTurnir() async {
    var turnir = Turnir(
        terenId: this.widget.teren!.id,
        cjenovnikId: _selectedCjenovnik!.id,
        ukupnaCijena: _cijena,
        korisnikId: APIService.loggedUserId,
        datumPocetka: _datumPocetka,
        datumKraja: _datumKraja,
        vrijemeKraja: vrijemeZavrsetka,
        vrijemePocetka: vrijemePocetka,
        naziv: nazivController.text,
        isPopust: isPopust);
    result = await APIService.Post('Turnir', jsonEncode(turnir).toString());
    if(result != null && result != "204" && result != "500") {
      APIService.bodovi += 20;
      if (isPopust) {
        APIService.bodovi -= 40;
      }
    }

    return result;
  }
}
