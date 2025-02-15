import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../API_PRIVATE.dart';
import '../class/Location.dart';
import '../class/local_data.dart';
import '../class/riverpod.dart';
import '../screens/venue_screen.dart';

class ScrollableTiles extends ConsumerWidget {
  final String dystans;
  final String nazwa_loklau;
  final double ocena;
  final Lokal lokal;
  final double xCord;
  final double yCord;
  final String opis;

  ScrollableTiles(
      {super.key,
      required this.nazwa_loklau,
      required this.ocena,
      required this.dystans,
      required this.lokal,
      required this.xCord,
      required this.yCord,
      required this.opis});

  final routeService = RouteService(GOOGLE_API);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLocation = ref.watch(userLocationProvider);
    final ulubioneLokale = ref.watch(ulubioneProvider);
    return Container(
      margin: EdgeInsets.only(right: 10, left: 10),
      child: GestureDetector(
        onTap: () {
          for (int i = 0; i < ulubioneLokale.length; i++) {
            print(ulubioneLokale[i].nazwaLokalu);
          }
          ref.read(selectedLokalProvider.notifier).state = lokal;
          Navigator.pushNamed(context, VenueScreen.id);
        },
        child: Card(
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFffb114),
                  Color(0xFFDB200C),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF1E3A8A).withValues(), // Czerwony blask
                  blurRadius: 10, // Rozmycie
                  spreadRadius: 5, // Rozciągnięcie
                ),
              ],
              // Zaokrąglenie rogów
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
                                '$nazwa_loklau',
                                style: TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.w900),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 30,
                                    ),
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
                          child: Text('$opis'),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            width: double.infinity,
                            child: Center(child: Text("data")),
                          ),
                        ),
                      ],
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
