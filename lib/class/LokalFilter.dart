import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../class/Location.dart';
import '../class/filter.dart';
import 'local_data.dart';

class LokalFilterService {
  RouteService routeService;

  LokalFilterService(this.routeService);

  List<Lokal> filtrujLokale(
      List<Lokal> lista, FilterData filtry, double userLat, double userLng) {
    return lista.where((lokal) {
      if (!_checkRodzajLokalu(filtry, lokal)) return false;
      if (!_checkGlownaSpecjalnosc(filtry, lokal)) return false;
      if (!_checkStrefaPalenia(filtry, lokal)) return false;
      if (!_checkNaRandke(filtry, lokal)) return false;
      if (!_checkPrzystosowany(filtry, lokal)) return false;
      if (!_checkOcena(filtry, lokal)) return false;
      if (!_checkHalas(filtry, lokal)) return false;
      if (!_checkBezpieczenstwo(filtry, lokal)) return false;
      if (!_checkOdleglosc(filtry, lokal, userLat, userLng)) return false;
      return true;
    }).toList();
  }

  bool _checkRodzajLokalu(FilterData filtry, Lokal lokal) {
    return filtry.rodzajLokalu == null ||
        lokal.rodzajLokalu == filtry.rodzajLokalu;
  }

  bool _checkGlownaSpecjalnosc(FilterData filtry, Lokal lokal) {
    return filtry.glownaSpecjalnosc == null ||
        lokal.glownaSpecjalnosc == filtry.glownaSpecjalnosc;
  }

  bool _checkStrefaPalenia(FilterData filtry, Lokal lokal) {
    return filtry.strefaPalenia == null ||
        lokal.strefaPalenia == filtry.strefaPalenia;
  }

  bool _checkNaRandke(FilterData filtry, Lokal lokal) {
    return filtry.naRandke == null || lokal.naRandke == filtry.naRandke;
  }

  bool _checkPrzystosowany(FilterData filtry, Lokal lokal) {
    return filtry.przystosowany == null ||
        lokal.przystosowany == filtry.przystosowany;
  }

  bool _checkOcena(FilterData filtry, Lokal lokal) {
    return filtry.ocena == null || lokal.ocena >= filtry.ocena!;
  }

  bool _checkHalas(FilterData filtry, Lokal lokal) {
    return filtry.halas == null || lokal.halas > filtry.halas!;
  }

  bool _checkBezpieczenstwo(FilterData filtry, Lokal lokal) {
    return filtry.bezpieczenstwo == null ||
        lokal.bezpieczenstwo > filtry.bezpieczenstwo!;
  }

  bool _checkOdleglosc(
      FilterData filtry, Lokal lokal, double userLat, double userLng) {
    if (filtry.odleglosc == null) return true;
    double distance = routeService.calculateDistance(
          LatLng(userLat, userLng),
          LatLng(lokal.xCord, lokal.yCord),
        ) /
        1000;

    return distance < filtry.odleglosc!;
  }
}
