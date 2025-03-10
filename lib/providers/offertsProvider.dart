import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../class/ofert_data.dart';

final ofertyProvider =
    StateNotifierProvider<OfertyNotifier, List<Oferta>?>((ref) {
  return OfertyNotifier();
});

class OfertyNotifier extends StateNotifier<List<Oferta>?> {
  OfertyNotifier() : super(null);

  void setOferty(List<Oferta> oferty) {
    state = oferty;
  }
}
