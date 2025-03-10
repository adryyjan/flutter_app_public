import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final userLocationProvider =
    StateNotifierProvider<UserLocationNotifier, LatLng>(
  (ref) => UserLocationNotifier(),
);

class UserLocationNotifier extends StateNotifier<LatLng> {
  UserLocationNotifier() : super(const LatLng(52.2297, 21.0122)) {
    _initializeLocationTracking();
  }

  Future<void> _initializeLocationTracking() async {
    final lastPosition = await Geolocator.getLastKnownPosition();

    if (lastPosition != null) {
      state = LatLng(lastPosition.latitude, lastPosition.longitude);
    } else {
      final currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      state = LatLng(currentPosition.latitude, currentPosition.longitude);
    }

    await _checkLocationPermission();

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
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
