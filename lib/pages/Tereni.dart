import 'dart:async';
import 'dart:core';
import 'package:e_sport_mobile/pages/KorisnikDetalji.dart';
import 'package:e_sport_mobile/pages/Login.dart';
import 'package:e_sport_mobile/pages/Termini.dart';
import 'package:e_sport_mobile/pages/Turniri.dart';
import 'package:flutter/material.dart';
import 'package:e_sport_mobile/models/Teren.dart';
import 'package:e_sport_mobile/services/APIService.dart';
import 'package:e_sport_mobile/pages/TereniDetalji.dart';

class Tereni extends StatefulWidget {
  @override
  _TereniState createState() => _TereniState();
}

class _TereniState extends State<Tereni> {
  TextEditingController searchController = new TextEditingController();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Tereni');
  String filter = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (customIcon.icon == Icons.search) {
                    customIcon = const Icon(Icons.cancel);
                    customSearchBar = ListTile(
                      leading: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28,
                      ),
                      title: TextField(
                        controller: searchController,
                        onChanged: (text) {
                          setState(() {
                            filter = text;
                            if (text != '') {
                              GetTereni(text);
                            } else {
                              GetTereni();
                            }
                          });
                        },
                        decoration: InputDecoration(
                            hintText: 'Unesite pretragu..',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                            border: InputBorder.none),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text('Termini');
                    searchController.text = '';
                    filter = '';
                  }
                });
              },
              icon: customIcon)
        ],
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                  child: Text(
                'eSport: ' + APIService.bodovi.toString() + ' bodova',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
              decoration: BoxDecoration(color: Colors.blue[700]),
            ),
            ListTile(
              title: Text('Profil'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => KorisnikDetalji()));
              },
            ),
            ListTile(
              title: Text('Moji termini'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Termini()));
              },
            ),
            ListTile(
                title: Text('Moji turniri'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Turniri()));
                }),
            ListTile(
              title: Text('Odjava'),
              onTap: () {
                APIService.Logout();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Login()));
              },
            )
          ],
        ),
      ),
      body: bodyWidget(),
    );
  }

  Widget bodyWidget() {
    return FutureBuilder<List<Teren>>(
      future: GetTereni(filter),
      builder: (BuildContext context, AsyncSnapshot<List<Teren>> snapshot) {
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
                  snapshot.data?.map((e) => TereniWidget(e)).toList() ?? [],
            );
          }
        }
      },
    );
  }

  Future<List<Teren>> GetTereni([String? search]) async {
    Map<String, String>? queryParams = null;
    if (search != null) queryParams = {'TekstPretraga': search, 'KorisnikId': APIService.loggedUserId.toString()};
    List<String> includeList = ['Sport'];
    var tereni = await APIService.Get('Teren', queryParams, includeList);
    if (tereni != null) {
      return tereni.map((i) => Teren.fromJson(i)).toList();
    }
    return List.empty();
  }

  Widget TereniWidget(teren) {
    return Card(
        child: TextButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TereniDetalji(
                      teren: teren,
                    )));
      },
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          teren.naziv,
          style: TextStyle(fontSize: 20),
        ),
      ),
    ));
  }
}
