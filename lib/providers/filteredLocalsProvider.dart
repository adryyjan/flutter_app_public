import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../class/local_data.dart';

final filteredLocalsProvider =
    StateNotifierProvider<FilteredLocalsNotifier, List<Lokal>>(
  (ref) => FilteredLocalsNotifier(),
);

class FilteredLocalsNotifier extends StateNotifier<List<Lokal>> {
  FilteredLocalsNotifier() : super([]);

  void updateFilteredLocals(List<Lokal> filteredLocals) {
    state = filteredLocals;
  }

  void clearFilteredLocals() {
    state = [];
  }
}
