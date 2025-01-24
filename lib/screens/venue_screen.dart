import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:funnavi/screens/map_screen.dart';
import 'package:funnavi/widgets/locat_properyty.dart';

import '../class/riverpod.dart';
import '../const.dart';
import '../widgets/bottom_menu.dart';
import '../widgets/category_slider.dart';

class VenueScreen extends ConsumerStatefulWidget {
  static const id = 'venue';
  const VenueScreen({super.key});

  @override
  ConsumerState<VenueScreen> createState() => _VenueScreenState();
}

class _VenueScreenState extends ConsumerState<VenueScreen> {
  bool is_schowed = false;
  bool is_used = false;
  double? ocena;

  Future<void> addScoreByVenueAttributeId({
    required String venueAttributeId,
    required int additionalScore,
  }) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await db
          .collection('venues')
          .where('id', isEqualTo: venueAttributeId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference venueRef = querySnapshot.docs.first.reference;

        await venueRef.update({
          'users_rating': FieldValue.increment(additionalScore),
          'liczba_ocen': FieldValue.increment(1),
        });

        print(
            "Successfully updated venue with attribute ID: $venueAttributeId");
      } else {
        print("No document found with attribute ID: $venueAttributeId");
      }
    } catch (e) {
      print("Error updating venue by attribute ID: $e");
    }
  }

  Future<void> addVenueToUser(String venueId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'venue_ids': FieldValue.arrayUnion([venueId])
        });
        print("Venue added successfully!");
      } catch (e) {
        print("Error adding venue: $e");
      }
    }
  }

  Future<void> removeVenueFromUser(String venueId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'venue_ids': FieldValue.arrayRemove([venueId])
        });

        print("Venue removed successfully!");
      } catch (e) {
        print("Error removing venue: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wybranyLokal = ref.watch(selectedLokalProvider);
    final ulubioneLokale = ref.watch(ulubioneProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(254, 255, 218, 1),
        ),
        child: Column(
          children: [
            const SizedBox(height: 70),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${wybranyLokal?.nazwaLokalu}',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                ),
                IconButton(
                  iconSize: 70,
                  onPressed: () {
                    setState(() {
                      if (ulubioneLokale
                          .any!((lokal) => lokal.id == wybranyLokal?.id)) {
                        setState(() {
                          ref
                              .read(ulubioneProvider.notifier)
                              .removeFromFavorites(wybranyLokal!);
                          removeVenueFromUser(wybranyLokal!.id);
                        });
                      } else {
                        ulubioneLokale.add(wybranyLokal!);
                        addVenueToUser(wybranyLokal.id);
                      }
                    });
                  },
                  icon: ulubioneLokale
                          .any!((lokal) => lokal.id == wybranyLokal?.id)
                      ? Icon(
                          Icons.favorite,
                          color: Colors.greenAccent.shade100,
                        )
                      : Icon(
                          Icons.favorite_border,
                          color: Colors.greenAccent.shade100,
                        ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  elevation: 10,
                  child: TextButton(
                    onPressed: () {
                      print('menu');
                    },
                    child: Text('MENU'),
                  ),
                ),
                Card(
                  elevation: 10,
                  child: TextButton(
                    onPressed: () {
                      print('zdjecia');
                    },
                    child: Text('ZDJECIA'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              flex: 5,
              child: Container(
                color: Color.fromRGBO(254, 255, 218, 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'STATYSTYKI LOKLAU',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          LocalProperyty(
                            wartosc: wybranyLokal?.ocena.toStringAsFixed(2),
                            text: 'OCENA',
                          ),
                          LocalProperyty(
                            wartosc: wybranyLokal?.czystosc.toStringAsFixed(2),
                            text: 'CZYSTOŚĆ',
                          ),
                          LocalProperyty(
                            wartosc: wybranyLokal?.atmosfera.toStringAsFixed(2),
                            text: 'ATMOFERA',
                          ),
                          LocalProperyty(
                            wartosc:
                                wybranyLokal?.kameralnosc.toStringAsFixed(2),
                            text: 'KAMERALNOŚĆ',
                          ),
                          LocalProperyty(
                            wartosc: wybranyLokal?.muzyka.toStringAsFixed(2),
                            text: 'MUZYKA',
                          ),
                          LocalProperyty(
                            wartosc:
                                wybranyLokal?.bezpieczenstwo.toStringAsFixed(2),
                            text: 'BEZPIECZEŃSTWO',
                          ),
                          LocalProperyty(
                            wartosc: wybranyLokal?.personel.toStringAsFixed(2),
                            text: 'PERSONEL',
                          ),
                          LocalProperyty(
                            wartosc: (wybranyLokal!.usersRating /
                                    wybranyLokal.liczbaOcen)
                                .toStringAsFixed(2),
                            text: 'OCENA W APCE',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: is_schowed
                              ? Column(
                                  children: [
                                    CategorySlider(
                                      precyzja: 10,
                                      text: 'Ocena: ',
                                      bgcolor: kTlo,
                                      maxSlide: 10,
                                      ocena: 5,
                                      onSlide: (value) async {
                                        setState(() {
                                          is_used = true;
                                          ocena = value;
                                          print('ocena: ${ocena}');
                                        });
                                      },
                                    ),
                                    Container(
                                      decoration: kGradient,
                                      child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              is_schowed = false;
                                              if (is_used) {
                                                print(
                                                    'ocena: ${ocena!.toInt()}');
                                                addScoreByVenueAttributeId(
                                                    venueAttributeId:
                                                        wybranyLokal.id,
                                                    additionalScore:
                                                        ocena!.toInt());
                                              }
                                            });
                                          },
                                          child: Text('WYŚLIJ')),
                                    )
                                  ],
                                )
                              : SizedBox.shrink(),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: kGradient,
                          child: TextButton(
                            onPressed: () {
                              Navigator.popAndPushNamed(context, MapScreen.id);
                            },
                            child: Text(
                              'PROWADZ',
                              style: kDesctyprionTextStyle,
                            ),
                          ),
                        ),
                        Container(
                          decoration: kGradient,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                is_schowed = true;
                                if (is_used) {}
                              });

                              print(is_schowed);
                              // Navigator.popAndPushNamed(context, MapScreen.id);
                            },
                            child: Text(
                              'OCEŃ',
                              style: kDesctyprionTextStyle,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //     ],
            //   ),
            // ),
            // )
          ],
        ),
      ),
      bottomNavigationBar: BottomMenu(
        list: false,
        map: false,
        filter: false,
      ),
    );
  }
}
