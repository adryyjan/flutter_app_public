import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'filter.dart';
import 'local_data.dart';
import 'ofert_data.dart';

///todo: rozgraniczyc na osobne providery

final selectedLokalProvider = StateProvider<Lokal?>((ref) => null);

final selectedOfertaProvider = StateProvider<Oferta?>((ref) => null);

final lokalProvider = StateNotifierProvider<LokalNotifier, List<Lokal>?>((ref) {
  return LokalNotifier();
});

class LokalNotifier extends StateNotifier<List<Lokal>?> {
  LokalNotifier() : super(null);

  void setLokale(List<Lokal> lokales) {
    state = lokales;
  }
}

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

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Lokal>>(
  (ref) => FavoritesNotifier(),
);

class FavoritesNotifier extends StateNotifier<List<Lokal>> {
  FavoritesNotifier() : super([]);

  void addFavorite(Lokal lokal) {
    if (!state.contains(lokal)) {
      state = [...state, lokal];
    }
  }

  void removeFavorite(Lokal lokal) {
    state =
        state.where((item) => item.nazwaLokalu != lokal.nazwaLokalu).toList();
  }
}

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

final userLocationProvider =
    StateNotifierProvider<UserLocationNotifier, LatLng>(
  (ref) => UserLocationNotifier(),
);

class UserLocationNotifier extends StateNotifier<LatLng> {
  UserLocationNotifier() : super(const LatLng(52.2297, 21.0122)) {
    _initializeLocationTracking();
  }

  Future<void> _initializeLocationTracking() async {
    // Pobierz ostatnią znaną lokalizację
    final lastPosition = await Geolocator.getLastKnownPosition();

    if (lastPosition != null) {
      // Ustaw ostatnią znaną lokalizację jako początkową
      state = LatLng(lastPosition.latitude, lastPosition.longitude);
    } else {
      // Jeśli brak znanej lokalizacji, wymuś jej uzyskanie
      final currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      state = LatLng(currentPosition.latitude, currentPosition.longitude);
    }

    await _checkLocationPermission();

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high, // Wysoka precyzja
        distanceFilter: 10, // Aktualizacja co 10 metrów
      ),
    ).listen((Position position) {
      state = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Lokalizacja została zablokowana. Włącz ją w ustawieniach.');
      }
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

class AuthState {
  final String email;
  final String haslo;

  AuthState({this.email = '', this.haslo = ''});

  AuthState copyWith({String? email, String? haslo}) {
    return AuthState(
      email: email ?? this.email,
      haslo: haslo ?? this.haslo,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setHaslo(String haslo) {
    state = state.copyWith(haslo: haslo);
  }

  void reset() {
    state = AuthState();
  }
}
