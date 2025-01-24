import 'dart:convert';
import 'dart:math';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RouteService {
  final String googleApiKey;

  RouteService(this.googleApiKey);

  Future<List<LatLng>> getRouteCoordinates(
      LatLng origin, LatLng destination) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&mode=walking&key=$googleApiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final points = PolylinePoints().decodePolyline(
            data['routes'][0]['overview_polyline']['points'],
          );
          return points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
        } else {
          throw Exception('API Error: ${data['status']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching route: $e');
      rethrow;
    }
  }

  double calculateTotalDistance(List<LatLng> points) {
    double totalDistance = 0;

    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += calculateDistance(points[i], points[i + 1]);
    }

    return totalDistance;
  }

  double calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000;

    final lat1 = point1.latitude * pi / 180;
    final lat2 = point2.latitude * pi / 180;
    final lon1 = point1.longitude * pi / 180;
    final lon2 = point2.longitude * pi / 180;

    final deltaLat = lat2 - lat1;
    final deltaLon = lon2 - lon1;

    final a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1) * cos(lat2) * sin(deltaLon / 2) * sin(deltaLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }
}
