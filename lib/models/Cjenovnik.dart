import 'dart:convert';
class Cjenovnik {
  final int? id;
  final int? cijena;
  final int? terenId;
  final int? tipRezervacijeId;
  final String? naziv;
  final bool? isDnevna;

  Cjenovnik({
    this.id,
    this.cijena,
    this.terenId,
    this.tipRezervacijeId,
    this.naziv,
    this.isDnevna
  });

  factory Cjenovnik.fromJson(Map<String, dynamic> json){
    return Cjenovnik(
        id: json['id'],
        cijena: json['cijena'],
        terenId: json['terenId'],
        tipRezervacijeId: json['tipRezervacijeId'],
        naziv: json['naziv'],
        isDnevna: json['isDnevna']
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "cijena": cijena,
    "terenId": terenId,
    "tipRezervacijeId": tipRezervacijeId,
    "naziv": naziv,
    "isDnevna": isDnevna
  };
}