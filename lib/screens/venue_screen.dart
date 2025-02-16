import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:funnavi/screens/map_screen.dart';
import 'package:funnavi/widgets/locat_properyty.dart';

import '../const.dart';
import '../providers/currSelectedProvider.dart';
import '../providers/ulunioneProvider.dart';
import '../widgets/bottom_menu.dart';
import '../widgets/category_slider.dart';

class VenueScreen extends ConsumerStatefulWidget {
  static const id = 'venue';
  const VenueScreen({super.key});

  @override
  ConsumerState<VenueScreen> createState() => _VenueScreenState();
}

class _VenueScreenState extends ConsumerState<VenueScreen> {
  bool is_used = false;
  double? ocena;

  Future<void> addScoreByVenueAttributeId({
    required String venueAttributeId,
    required int additionalScore,
  }) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    print("funkcja");
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
          color: kTlo,
        ),
        child: Column(
          children: [
            const SizedBox(height: 70),

            Text(
              '${wybranyLokal?.nazwaLokalu}',
              style: kTitleTextStyleBlack,
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              flex: 5,
              child: Container(
                color: kTlo,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'STATYSTYKI',
                          style: kSmallerTitleTextStyleBlack,
                        ),
                        IconButton(
                          iconSize: 70,
                          onPressed: () {
                            setState(() {
                              if (ulubioneLokale.any(
                                  (lokal) => lokal.id == wybranyLokal?.id)) {
                                setState(() {
                                  ref
                                      .read(ulubioneProvider.notifier)
                                      .removeFromFavorites(wybranyLokal!);
                                  removeVenueFromUser(wybranyLokal.id);
                                });
                              } else {
                                ulubioneLokale.add(wybranyLokal!);
                                addVenueToUser(wybranyLokal.id);
                              }
                            });
                          },
                          icon: ulubioneLokale
                                  .any((lokal) => lokal.id == wybranyLokal?.id)
                              ? Icon(
                                  Icons.favorite,
                                  color: Color(0xFFDB200C),
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  color: Color(0xFFDB200C),
                                ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          LocalProperyty(
                            wartosc: (wybranyLokal!.usersRating /
                                    wybranyLokal.liczbaOcen)
                                .toStringAsFixed(2),
                            text: 'OCENA W APCE',
                          ),
                          LocalProperyty(
                            wartosc: wybranyLokal.ocena.toStringAsFixed(1),
                            text: 'OCENA',
                          ),
                          LocalProperyty(
                            wartosc: wybranyLokal.czystosc.toStringAsFixed(2),
                            text: 'CZYSTOŚĆ',
                          ),
                          LocalProperyty(
                            wartosc: wybranyLokal.atmosfera.toStringAsFixed(2),
                            text: 'ATMOFERA',
                          ),
                          LocalProperyty(
                            wartosc:
                                wybranyLokal.kameralnosc.toStringAsFixed(2),
                            text: 'KAMERALNOŚĆ',
                          ),
                          LocalProperyty(
                            wartosc: wybranyLokal.muzyka.toStringAsFixed(2),
                            text: 'MUZYKA',
                          ),
                          LocalProperyty(
                            wartosc:
                                wybranyLokal.bezpieczenstwo.toStringAsFixed(2),
                            text: 'BEZPIECZEŃSTWO',
                          ),
                          LocalProperyty(
                            wartosc: wybranyLokal.personel.toStringAsFixed(2),
                            text: 'PERSONEL',
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
                          child: is_used
                              ? Column(
                                  children: [
                                    CategorySlider(
                                      precyzja: 10,
                                      text: 'Ocena: ',
                                      bgcolor1: ocena == null
                                          ? kBgDarker
                                          : Color(0xFFffb114),
                                      bgcolor2: ocena == null
                                          ? kBgDarker
                                          : Color(0xFFDB200C),
                                      maxSlide: 10,
                                      ocena: ocena == null ? 5.0 : ocena!,
                                      onSlide: (value) async {
                                        setState(() {
                                          print('ocena: ${ocena}');
                                          ocena = value;
                                          is_used = true;
                                        });
                                      },
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: kGradientBR,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            if (is_used) {
                                              addScoreByVenueAttributeId(
                                                  venueAttributeId:
                                                      wybranyLokal.id,
                                                  additionalScore:
                                                      ocena!.toInt());
                                            }
                                            ocena = null;
                                            is_used = !is_used;
                                          });
                                        },
                                        child: Text(
                                          'WYŚLIJ',
                                          style: kDesctyprionTextStyleWhite,
                                        ),
                                      ),
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
                          decoration: BoxDecoration(
                            gradient: kGradientBR,
                            borderRadius:
                                BorderRadius.circular(15), // Zaokrąglenie rogów
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.popAndPushNamed(context, MapScreen.id);
                            },
                            child: Text(
                              'PROWADZ',
                              style: kDesctyprionTextStyleWhite,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: kGradientBR,
                            borderRadius:
                                BorderRadius.circular(15), // Zaokrąglenie rogów
                          ),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                is_used = !is_used;
                              });
                            },
                            child: Text(
                              is_used ? 'ANULUJ' : 'OCEŃ',
                              style: kDesctyprionTextStyleWhite,
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
