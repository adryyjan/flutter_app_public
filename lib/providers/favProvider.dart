// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../class/local_data.dart';
//
// final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Lokal>>(
//       (ref) => FavoritesNotifier(),
// );
//
// class FavoritesNotifier extends StateNotifier<List<Lokal>> {
//   FavoritesNotifier() : super([]);
//
//   void addFavorite(Lokal lokal) {
//     if (!state.contains(lokal)) {
//       state = [...state, lokal];
//     }
//   }
//
//   void removeFavorite(Lokal lokal) {
//     state =
//         state.where((item) => item.nazwaLokalu != lokal.nazwaLokalu).toList();
//   }
// }
