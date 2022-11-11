class Teren {
  final id;
  final String? naziv;
  final String? sportNaziv;

  Teren({
    this.id,
    this.naziv,
    this.sportNaziv
  });

  factory Teren.fromJson(Map<String, dynamic> json){
    return Teren(
      id: ['id'],
      naziv: json['naziv'],
      sportNaziv: json['sportNaziv']
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "naziv": naziv,
    "sportNaziv": sportNaziv
  };
}