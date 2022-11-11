import 'package:flutter/material.dart';
import 'package:e_sport_mobile/pages/Login.dart';
import 'package:e_sport_mobile/pages/Tereni.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      routes: {
        '/tereni':(context)=> Tereni()
      },
    );
  }
}
