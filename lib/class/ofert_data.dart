class Oferta {
  final String id;
  final String nazwa;
  final String oferta;
  final String opisOferta;
  final String przedmiotOferty;
  final String data;
  final String czas;
  final String cena;
  final String wielorazowa;

  Oferta({
    required this.id,
    required this.nazwa,
    required this.oferta,
    required this.opisOferta,
    required this.przedmiotOferty,
    required this.data,
    required this.czas,
    required this.cena,
    required this.wielorazowa,
  });
  Oferta.copy(
    Oferta oferta,
  )   : id = oferta.id,
        nazwa = oferta.nazwa,
        oferta = oferta.oferta,
        opisOferta = oferta.opisOferta,
        przedmiotOferty = oferta.przedmiotOferty,
        data = oferta.data,
        czas = oferta.czas,
        cena = oferta.cena,
        wielorazowa = oferta.wielorazowa;

  factory Oferta.fromMap(Map<String, dynamic> map) {
    return Oferta(
      id: map['id'],
      nazwa: map['nazwa'],
      oferta: map['oferta'],
      opisOferta: map['opis_oferta'],
      przedmiotOferty: map['przedmiot_oferty'],
      data: map['data'],
      czas: map['czas'],
      cena: map['cena'],
      wielorazowa: map['wielorazowa'],
    );
  }
}
