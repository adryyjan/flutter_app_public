import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../class/local_data.dart';

final ulubioneProvider = StateNotifierProvider<UlubioneNotifier, List<Lokal>>(
  (ref) => UlubioneNotifier(),
);

class UlubioneNotifier extends StateNotifier<List<Lokal>> {
  UlubioneNotifier() : super([]);

  void addToFavorites(Lokal lokal) {
    if (!state.contains(lokal)) {
      state = [...state, lokal];
    }
  }

  void addLokale(List<Lokal> lokale) {
    final newLokale = lokale
        .where((lokal) => !state.any((item) => item.id == lokal.id))
        .toList();
    if (newLokale.isNotEmpty) {
      state = [...state, ...newLokale];
    }
  }

  void removeFromFavorites(Lokal lokal) {
    state =
        state.where((item) => item.nazwaLokalu != lokal.nazwaLokalu).toList();
  }
}
