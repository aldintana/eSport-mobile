class Korisnik {
  final int? id;
  final String? ime;
  final String? prezime;
  final String? email;
  final String? brojTelefona;
  final String? korisnickoIme;
  List<int>? ulogas;
  final bool? updateUloga;
  final String? lozinka;
  final String? lozinkaProvjera;

  Korisnik({
    this.id,
    this.ime,
    this.prezime,
    this.email,
    this.brojTelefona,
    this.korisnickoIme,
    this.updateUloga,
    this.lozinka,
    this.lozinkaProvjera
  });

  factory Korisnik.fromJson(Map<String, dynamic> json){
    return Korisnik(
      id: json['id'],
      ime: json['ime'],
      prezime: json['prezime'],
      email: json['email'],
      brojTelefona: json['brojTelefona'],
      korisnickoIme: json['korisnickoIme']
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "ime": ime,
    "prezime": prezime,
    "email": email,
    "brojTelefona": brojTelefona,
    "korisnickoIme": korisnickoIme,
    "updateUloga": updateUloga,
    "lozinka": lozinka,
    "lozinkaProvjera": lozinkaProvjera
  };
}