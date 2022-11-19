class Teren {
  final int? id;
  final String? naziv;
  final String? sportNaziv;
  final int? sportId;

  Teren({
    this.id,
    this.naziv,
    this.sportNaziv,
    this.sportId
  });

  factory Teren.fromJson(Map<String, dynamic> json){
    return Teren(
      id: json['id'],
      naziv: json['naziv'],
      sportNaziv: json['sportNaziv'],
        sportId: json['sportId']
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "naziv": naziv,
    "sportNaziv": sportNaziv,
    "sportId": sportId
  };
}