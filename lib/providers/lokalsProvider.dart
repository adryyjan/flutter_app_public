import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../class/local_data.dart';

final lokalProvider = StateNotifierProvider<LokalNotifier, List<Lokal>?>((ref) {
  return LokalNotifier();
});

class LokalNotifier extends StateNotifier<List<Lokal>?> {
  LokalNotifier() : super(null);

  void setLokale(List<Lokal> lokales) {
    state = lokales;
  }
}
