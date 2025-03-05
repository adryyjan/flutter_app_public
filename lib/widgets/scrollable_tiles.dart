import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../API_PRIVATE.dart';
import '../class/local_data.dart';
import '../class/location.dart';
import '../providers/currSelectedProvider.dart';
import '../providers/userLocationProvider.dart';
import '../screens/venue_screen.dart';

class ScrollableTiles extends ConsumerWidget {
  final String nazwa_loklau;
  final double ocena;
  final Lokal lokal;
  final double xCord;
  final double yCord;
  final String opis;
  final String rodzajLokalu;

  ScrollableTiles({
    super.key,
    required this.nazwa_loklau,
    required this.ocena,
    required this.lokal,
    required this.xCord,
    required this.yCord,
    required this.opis,
    required this.rodzajLokalu,
  });

  final routeService = RouteService(GOOGLE_API);

  Future<String> getDistance(LatLng start, LatLng end) async {
    return await routeService.calculateRoute(start, end);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLocation = ref.watch(userLocationProvider);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          ref.read(selectedLokalProvider.notifier).state = lokal;
          Navigator.pushNamed(context, VenueScreen.id);
        },
        child: Card(
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFffb114), Color(0xFFDB200C)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF1E3A8A).withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                nazwa_loklau,
                                style: TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.w900),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  children: [
                                    FutureBuilder<String>(
                                        future: getDistance(
                                            LatLng(userLocation.latitude,
                                                userLocation.longitude),
                                            LatLng(xCord, yCord)),
                                        builder: (context, snapshot) {
                                          if (snapshot.data == null) {
                                            return Text("");
                                          } else {
                                            return Text("${snapshot.data} km");
                                          }
                                        }),
                                    SizedBox(width: 5),
                                    Icon(Icons.star, size: 30),
                                    Text(
                                      '$ocena',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(opis),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF1E3A8A),
                            Color(0xFFDB200C),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      width: double.infinity,
                      child: Center(
                        child: Image.asset(
                          "images/${rodzajLokalu}.png",
                          height: 90,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
