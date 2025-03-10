import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../API_PRIVATE.dart';
import '../const.dart';
import '../providers/currSelectedProvider.dart';
import '../providers/filteredLocalsProvider.dart';
import '../providers/ulunioneProvider.dart';
import '../providers/userLocationProvider.dart';
import '../widgets/bottom_menu.dart';

enum MarkerColor { zielony, ciemnoZielony, ulubiony, rozowy, czerwony }

enum MarkerPng { beer, loop, user_marker }

class MapScreen extends ConsumerStatefulWidget {
  static const id = 'map';
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  late Set<Polyline> _polylines = {};
  final MarkerId _userMarkerId = MarkerId('user_location');
  LatLng? _selectedDestination;
  String? odleglosc;
  double? selectedX;
  double? selectedY;

  void _updateUserMarker(LatLng userLocation, MarkerPng namePng) {
    setState(() {
      _markers.removeWhere((marker) => marker.markerId == _userMarkerId);

      final userMarker = Marker(
          markerId: _userMarkerId,
          position: userLocation,
          infoWindow: const InfoWindow(
            title: "Twoja lokalizacja",
          ),
          icon: _getMarkerPng(namePng),
          anchor: Offset(0.5, 1));

      _markers.add(userMarker);
    });
  }

  void _addMarker(double x, double y, String name, String description,
      double rating, MarkerColor color, MarkerPng namePng) {
    final markerId = MarkerId('$name');

    if (_markers.any((marker) => marker.markerId == markerId)) {
      return;
    }

    final marker = Marker(
        onTap: () {
          final userLocation = ref.read(userLocationProvider);
          _selectedDestination = LatLng(x, y);
          _calculateRoute(userLocation, LatLng(x, y));
          _refreshRoute(userLocation, LatLng(x, y));
          selectedX = x;
          selectedY = y;
        },
        markerId: markerId,
        position: LatLng(x, y),
        infoWindow: InfoWindow(
          title: name,
          snippet: "$description, $rating ⭐",
        ),
        icon: _getMarkerPng(namePng),
        anchor: Offset(0.5, 0.5));

    setState(() {
      _markers.add(marker);
    });
  }

  AssetMapBitmap _getMarkerPng(MarkerPng nazwa_png) {
    switch (nazwa_png) {
      case MarkerPng.beer:
        return AssetMapBitmap(
          'images/PIWO.png',
          height: 32,
          width: 32,
        );
      case MarkerPng.loop:
        return AssetMapBitmap(
          'images/loop.png',
          height: 32,
          width: 32,
        );
      case MarkerPng.user_marker:
        return AssetMapBitmap(
          'images/user.png',
          height: 50,
          width: 40,
        );
    }
  }

  Future<List<LatLng>> _getRouteCoordinates(
      LatLng origin, LatLng destination) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json'
      '?origin=${origin.latitude},${origin.longitude}'
      '&destination=${destination.latitude},${destination.longitude}'
      '&mode=walking&key=$GOOGLE_API',
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
      }
      throw Exception('API Error: ${data['status']}');
    }
    throw Exception('HTTP Error: ${response.reasonPhrase}');
  }

  void _calculateRoute(LatLng start, LatLng end) async {
    if (start.latitude == 0.0 && start.longitude == 0.0) {
      return;
    }

    try {
      final routePoints = await _getRouteCoordinates(start, end);
      if (routePoints.isNotEmpty) {
        _polylines = {};
        setState(() {
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: routePoints,
              color: Colors.blue,
              width: 5,
            ),
          );
        });

        final distance = _calculatePolylineLength(routePoints);

        odleglosc = (distance / 1000).toStringAsFixed(1);
      }
    } catch (e) {}
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
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

  double _calculatePolylineLength(List<LatLng> points) {
    double totalDistance = 0;

    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += _calculateDistance(points[i], points[i + 1]);
    }

    return totalDistance;
  }

  void _updatePolylineWithUserPosition(LatLng userLocation) {
    if (_polylines.isEmpty) return;

    final polyline = _polylines.first;
    final points = List<LatLng>.from(polyline.points);

    points.removeWhere((point) {
      return _calculateDistance(userLocation, point) < 5;
    });

    setState(() {
      _polylines.remove(polyline);
      _polylines.add(Polyline(
        polylineId: polyline.polylineId,
        points: points,
        color: polyline.color,
        width: polyline.width,
      ));
    });
  }

  void _refreshRoute(LatLng userLocation, LatLng destination) async {
    try {
      final routePoints = await _getRouteCoordinates(userLocation, destination);

      setState(() {
        _polylines = {};

        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: routePoints,
            color: Colors.blue,
            width: 5,
          ),
        );
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final wybranyLokal = ref.watch(selectedLokalProvider);
    final ulubione = ref.watch(ulubioneProvider);
    final userLocation = ref.watch(userLocationProvider);
    final filtrowane = ref.watch(filteredLocalsProvider);
    setState(() {
      ref.listen<LatLng>(userLocationProvider, (previous, next) {
        _updateUserMarker(next, MarkerPng.user_marker);

        _updatePolylineWithUserPosition(next);
        if (previous != null) {
          final destination = LatLng(
              _selectedDestination!.latitude, _selectedDestination!.longitude);
          _refreshRoute(next, destination);
        }

        if (previous == null) {
          _mapController.animateCamera(
            CameraUpdate.newLatLngZoom(next, 17.0),
          );
        }
      });
    });

    if (selectedY != null) {
      _calculateRoute(
        userLocation,
        LatLng(selectedX!, selectedY!),
      );
    } else if (wybranyLokal != null) {
      _calculateRoute(
        userLocation,
        LatLng(wybranyLokal.xCord, wybranyLokal.yCord),
      );
    }

    _updatePolylineWithUserPosition(userLocation);
    _updateUserMarker(userLocation, MarkerPng.user_marker);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: BottomMenu(
        list: false,
        map: true,
        filter: false,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;

              if (userLocation.latitude != 0.0 ||
                  userLocation.longitude != 0.0) {
                _mapController.animateCamera(
                  CameraUpdate.newLatLngZoom(userLocation, 17.0),
                );

                if (ulubione != null) {
                  for (final lokal in ulubione) {
                    _addMarker(
                        lokal.xCord,
                        lokal.yCord,
                        lokal.nazwaLokalu,
                        lokal.rodzajLokalu,
                        lokal.ocena,
                        MarkerColor.ulubiony,
                        MarkerPng.beer);
                  }
                }
                print('ULUBIONE');
                for (int i = 0; i < ulubione.length; i++) {
                  print(ulubione[i].nazwaLokalu);
                }

                if (wybranyLokal != null) {
                  _addMarker(
                      wybranyLokal.xCord,
                      wybranyLokal.yCord,
                      wybranyLokal.nazwaLokalu,
                      wybranyLokal.rodzajLokalu,
                      wybranyLokal.ocena,
                      MarkerColor.ciemnoZielony,
                      MarkerPng.loop);
                  _calculateDistance(userLocation,
                      LatLng(wybranyLokal.xCord, wybranyLokal.yCord));
                }

                print('WYBRANY');
                print(wybranyLokal?.nazwaLokalu);

                if (filtrowane != null) {
                  for (final lokal in filtrowane) {
                    _addMarker(
                        lokal.xCord,
                        lokal.yCord,
                        lokal.nazwaLokalu,
                        lokal.rodzajLokalu,
                        lokal.ocena,
                        MarkerColor.zielony,
                        MarkerPng.loop);
                  }
                }
                print('FILTRY');
                for (int i = 0; i < filtrowane.length; i++) {
                  print(filtrowane[i].nazwaLokalu);
                }

                final destination =
                    LatLng(wybranyLokal!.xCord, wybranyLokal.yCord);
                _refreshRoute(userLocation, destination);

                _updateUserMarker(userLocation, MarkerPng.user_marker);
                _updatePolylineWithUserPosition(userLocation);
              }
            },
            initialCameraPosition: CameraPosition(
              target: userLocation,
              zoom: 17.0,
            ),
            markers: _markers,
            polylines: _polylines,
            mapType: MapType.normal,
          ),
          Positioned(
            top: 70,
            left: 16,
            right: 16,
            child: Container(
              decoration: kGradientYO,
              child: odleglosc == null
                  ? Text(
                      textAlign: TextAlign.center,
                      'Wybierz lokal',
                      style: kSmallerTitleTextStyleBlack,
                    )
                  : Text(
                      textAlign: TextAlign.center,
                      'Trasa:   ${odleglosc} km',
                      style: kSmallerTitleTextStyleBlack,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
