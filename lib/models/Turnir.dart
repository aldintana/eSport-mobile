class Turnir {
  final int? id;
  final String? naziv;
  final DateTime? datumPocetka;
  final DateTime? datumKraja;
  final int? vrijemePocetka;
  final int? vrijemeKraja;
  final int? terenId;
  final int? cjenovnikId;
  final int? korisnikId;
  final int? ukupnaCijena;
  final String? terenNaziv;

  Turnir({
    this.id,
    this.naziv,
    this.datumPocetka,
    this.datumKraja,
    this.vrijemePocetka,
    this.vrijemeKraja,
    this.terenId,
    this.cjenovnikId,
    this.korisnikId,
    this.ukupnaCijena,
    this.terenNaziv
  });

  factory Turnir.fromJson(Map<String, dynamic> json){
    return Turnir(
        id: int.parse(json['id'].toString()),
        datumPocetka: json['datumPocetka'] == null ? null : DateTime.parse(json['datumPocetka']),
        datumKraja: json['datumKraja'] == null ? null : DateTime.parse(json['datumKraja']),
        vrijemePocetka: int.parse(json['vrijemePocetka'].toString()),
        vrijemeKraja: int.parse(json['vrijemeKraja'].toString()),
        terenId: int.parse(json['terenId'].toString()),
        cjenovnikId: int.parse(json['cjenovnikId'].toString()),
        ukupnaCijena: int.parse(json['ukupnaCijena'].toString()),
        korisnikId: int.parse(json['korisnikId'].toString()),
        terenNaziv: json['terenNaziv'].toString()
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "datumPocetka": datumPocetka == null ? null : datumPocetka!.toIso8601String(),
    "datumKraja": datumKraja == null ? null : datumKraja!.toIso8601String(),
    "vrijemePocetka": vrijemePocetka,
    "vrijemeKraja": vrijemeKraja,
    "terenId": terenId,
    "cjenovnikId": cjenovnikId,
    "ukupnaCijena": ukupnaCijena,
    "terenNaziv": terenNaziv,
    "korisnikId": korisnikId
  };
}