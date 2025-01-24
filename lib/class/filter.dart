class FilterData {
  String? rodzajLokalu;
  String? glownaSpecjalnosc;
  bool? strefaPalenia;
  double? ocena;
  double? odleglosc;
  double? halas;
  double? bezpieczenstwo;
  bool? naRandke;
  bool? przystosowany;
  double? rating;

  FilterData(
      {this.rodzajLokalu,
      this.bezpieczenstwo,
      this.halas,
      this.przystosowany,
      this.strefaPalenia,
      this.naRandke,
      this.ocena,
      this.odleglosc,
      this.glownaSpecjalnosc,
      this.rating});

  void resetToDefaults() {
    rodzajLokalu = null;
    glownaSpecjalnosc = null;
    strefaPalenia = null;
    ocena = null;
    odleglosc = null;
    halas = null;
    bezpieczenstwo = null;
    naRandke = null;
    przystosowany = null;
  }

  FilterData copyWith({
    String? rodzajLokalu,
    String? glownaSpecjalnosc,
    bool? strefaPalenia,
    double? ocena,
    double? odleglosc,
    double? halas,
    double? bezpieczenstwo,
    bool? naRandke,
    bool? przystosowany,
  }) {
    return FilterData(
      rodzajLokalu: rodzajLokalu ?? this.rodzajLokalu,
      glownaSpecjalnosc: glownaSpecjalnosc ?? this.glownaSpecjalnosc,
      strefaPalenia: strefaPalenia ?? this.strefaPalenia,
      ocena: ocena ?? this.ocena,
      odleglosc: odleglosc ?? this.odleglosc,
      halas: halas ?? this.halas,
      bezpieczenstwo: bezpieczenstwo ?? this.bezpieczenstwo,
      naRandke: naRandke ?? this.naRandke,
      przystosowany: przystosowany ?? this.przystosowany,
    );
  }
}
