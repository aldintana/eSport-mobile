class Tim {
  final int? id;
  final String? naziv;
  final int? turnirId;
  final int? brojBodova;
  final int? brojPobjeda;
  final int? brojNerijesenih;
  final int? brojPoraza;
  final int? brojDatihGolova;
  final int? brojPrimljenihGolova;

  Tim({
    this.id,
    this.naziv,
    this.turnirId,
    this.brojBodova,
    this.brojPobjeda,
    this.brojNerijesenih,
    this.brojPoraza,
    this.brojDatihGolova,
    this.brojPrimljenihGolova
  });

  factory Tim.fromJson(Map<String, dynamic> json){
    return Tim(
        id: int.parse(json['id'].toString()),
        naziv: json['naziv'],
        turnirId: int.parse(json['turnirId'].toString()),
        brojBodova: int.parse(json['brojBodova'].toString()),
        brojPobjeda: int.parse(json['brojPobjeda'].toString()),
        brojNerijesenih: int.parse(json['brojNerijesenih'].toString()),
        brojPoraza: int.parse(json['brojPoraza'].toString()),
        brojDatihGolova: int.parse(json['brojDatihGolova'].toString()),
        brojPrimljenihGolova: int.parse(json['brojPrimljenihGolova'].toString())
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "naziv": naziv,
    "turnirId": turnirId,
    "brojBodova": brojBodova,
    "brojPobjeda": brojPobjeda,
    "brojNerijesenih": brojNerijesenih,
    "brojPoraza": brojPoraza,
    "brojDatihGolova": brojDatihGolova,
    "brojPrimljenihGolova": brojPrimljenihGolova
  };
}