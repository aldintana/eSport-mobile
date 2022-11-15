class Termin {
  final int? id;
  final DateTime? pocetak;
  final DateTime? kraj;
  final DateTime? datum;
  final int? terenId;
  final int? cjenovnikId;
  final int? korisnikId;
  final int? ukupnaCijena;
  final String? terenNaziv;

  Termin({
    this.id,
    this.pocetak,
    this.kraj,
    this.datum,
    this.terenId,
    this.cjenovnikId,
    this.korisnikId,
    this.ukupnaCijena,
    this.terenNaziv
  });

  factory Termin.fromJson(Map<String, dynamic> json){
    return Termin(
        id: int.parse(json['id'].toString()),
        pocetak: json['pocetak'] == null ? null : DateTime.parse(json['pocetak']),
        kraj: json['kraj'] == null ? null : DateTime.parse(json['kraj']),
        datum: json['datum'] == null ? null : DateTime.parse(json['datum']),
        terenId: int.parse(json['terenId'].toString()),
        cjenovnikId: int.parse(json['cjenovnikId'].toString()),
        ukupnaCijena: int.parse(json['ukupnaCijena'].toString()),
        korisnikId: int.parse(json['korisnikId'].toString())
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "pocetak": pocetak == null ? null : pocetak!.toIso8601String(),
    "kraj": kraj == null ? null : kraj!.toIso8601String(),
    "datum": datum == null ? null : datum!.toIso8601String(),
    "terenId": terenId,
    "cjenovnikId": cjenovnikId,
    "ukupnaCijena": ukupnaCijena,
    "terenNaziv": terenNaziv,
    "korisnikId": korisnikId
  };
}