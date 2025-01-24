class Lokal {
  final String id;
  final String nazwaLokalu;
  final String rodzajLokalu;
  final String glownaSpecjalnosc;
  final bool strefaPalenia;
  final bool naRandke;
  final bool przystosowany;
  final double ocena;
  final double xCord;
  final double yCord;
  final double halas;
  final double bezpieczenstwo;
  final double czystosc;
  final double atmosfera;
  final double kameralnosc;
  final double muzyka;
  final double personel;
  final String opis;
  late int usersRating;
  late int liczbaOcen;

  Lokal({
    required this.id,
    required this.nazwaLokalu,
    required this.rodzajLokalu,
    required this.glownaSpecjalnosc,
    required this.strefaPalenia,
    required this.naRandke,
    required this.przystosowany,
    required this.ocena,
    required this.xCord,
    required this.yCord,
    required this.halas,
    required this.bezpieczenstwo,
    required this.atmosfera,
    required this.czystosc,
    required this.kameralnosc,
    required this.muzyka,
    required this.personel,
    required this.opis,
    required this.usersRating,
    required this.liczbaOcen,
  });

  Lokal.copy(
    Lokal lokal,
  )   : id = lokal.id,
        nazwaLokalu = lokal.nazwaLokalu,
        rodzajLokalu = lokal.rodzajLokalu,
        glownaSpecjalnosc = lokal.glownaSpecjalnosc,
        strefaPalenia = lokal.strefaPalenia,
        naRandke = lokal.naRandke,
        przystosowany = lokal.przystosowany,
        ocena = lokal.ocena,
        xCord = lokal.xCord,
        yCord = lokal.yCord,
        halas = lokal.halas,
        bezpieczenstwo = lokal.bezpieczenstwo,
        atmosfera = lokal.atmosfera,
        czystosc = lokal.czystosc,
        kameralnosc = lokal.kameralnosc,
        muzyka = lokal.muzyka,
        personel = lokal.personel,
        opis = lokal.opis,
        usersRating = lokal.usersRating,
        liczbaOcen = lokal.liczbaOcen;

  // Metoda do konwersji z mapy (np. z JSON-a)
  factory Lokal.fromMap(Map<String, dynamic> map) {
    return Lokal(
      id: map['id'],
      nazwaLokalu: map['nazwa'],
      rodzajLokalu: map['rodzaj_lokalu'],
      glownaSpecjalnosc: map['glowna_specjalonsc'],
      strefaPalenia: map['strefa_palenia'] == "1",
      naRandke: map['na_randke'] == "1",
      przystosowany: map['przystosowany'] == "1",
      ocena: double.parse(map['ocena']),
      xCord: double.parse(map['x_cord']),
      yCord: double.parse(map['y_cord']),
      halas: double.parse(map['halas']),
      bezpieczenstwo: double.parse(map['bezpieczenstwo']),
      czystosc: double.parse(map['czystosc']),
      atmosfera: double.parse(map['atmosfera']),
      kameralnosc: double.parse(map['kameralnosc']),
      muzyka: double.parse(map['muzyka']),
      personel: double.parse(map['personel']),
      opis: map['opis'],
      usersRating: map['users_rating'],
      liczbaOcen: map['liczba_ocen'],
    );
  }

  void updateUserRating(int newRating) {
    usersRating = newRating;
    liczbaOcen++;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nazwa': nazwaLokalu,
      'rodzaj_lokalu': rodzajLokalu,
      'glowna_specjalonsc': glownaSpecjalnosc,
      'strefa_palenia': strefaPalenia ? "1" : "0",
      'na_randke': naRandke ? "1" : "0",
      'przystosowany': przystosowany ? "1" : "0",
      'ocena': ocena.toString(),
      'x_cord': xCord.toString(),
      'y_cord': yCord.toString(),
      'halas': halas.toString(),
      'bezpieczenstwo': bezpieczenstwo.toString(),
      'opis': opis,
      'czystosc': czystosc.toString(),
      'atmosfera': atmosfera.toString(),
      'kameralnosc': kameralnosc.toString(),
      'muzyka': muzyka.toString(),
      'personel': personel.toString(),
      'users_rating': usersRating.toString(),
      'liczba_ocen': liczbaOcen.toString(),
    };
  }
}
