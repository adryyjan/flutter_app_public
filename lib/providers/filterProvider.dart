import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../class/filter.dart';

final filterProvider = StateNotifierProvider<FilterNotifier, FilterData>(
  (ref) => FilterNotifier(),
);

class FilterNotifier extends StateNotifier<FilterData> {
  FilterNotifier() : super(FilterData());

  void resetFilters() {
    state = FilterData();
  }

  void update(FilterData newFilter) {
    state = newFilter;
  }
}
