import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:funnavi/widgets/Mega_promocje.dart';

import '../class/local_data.dart';
import '../class/riverpod.dart';
import '../const.dart';
import '../widgets/bottom_menu.dart';
import '../widgets/scrollable_tile_final_normal.dart';
import '../widgets/sscrollable_tile_final_swipable.dart';

enum wybor { popularne, filtrowane, ulubione }

class MainScreen extends ConsumerStatefulWidget {
  static const id = 'main';

  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  wybor selected_choice = wybor.popularne;
  UserCredential? credentials;
  List<Lokal> favFb = [];
  //
  Future<List<Lokal>> pobierzUlubione() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String userId = await getUser();

    try {
      DocumentSnapshot userDoc = await db.collection('users').doc(userId).get();

      List<dynamic> venuesIdDynamic = userDoc.get('venue_ids');
      List<String> venuesId = venuesIdDynamic.cast<String>();

      List<Lokal> selectedVenues = [];

      const int batchSize = 10;
      for (int i = 0; i < venuesId.length; i += batchSize) {
        int end =
            (i + batchSize < venuesId.length) ? i + batchSize : venuesId.length;
        List<String> batch = venuesId.sublist(i, end);

        QuerySnapshot query =
            await db.collection('venues').where('id', whereIn: batch).get();

        for (var doc in query.docs) {
          selectedVenues.add(Lokal.fromMap(doc.data() as Map<String, dynamic>));
        }
      }

      return selectedVenues;
    } catch (e) {
      print("Error fetching venues: $e");
      return [];
    }
  }

  Future<String> getUser() async {
    final authState = ref.read(authProvider);
    credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: authState.email, password: authState.haslo);

    return credentials!.user!.uid;
  }

  ///todo: oddzielna klasa na wczytywanie bo w 2 ekranach już jest

  @override
  Widget build(BuildContext context) {
    final filtrowane = ref.watch(filteredLocalsProvider);
    final listaLokali = ref.watch(lokalProvider);
    final listaOfert = ref.watch(ofertyProvider);
    var favFb = ref.watch(ulubioneProvider);
    final filter = ref.watch(filterProvider);

    return Scaffold(
      body: Container(
        color: kTlo,
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text('FUNAVI', style: kTitleTextStyle),
            Container(
              height: 200,
              child: GridView.builder(
                padding: EdgeInsets.all(8.0),
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.6,
                  crossAxisCount: 1,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: listaOfert?.length ?? 0,
                itemBuilder: (context, index) {
                  return MegaPromocje(oferta: listaOfert![index]);
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: kTlo,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        setState(() {
                          selected_choice = wybor.popularne;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selected_choice == wybor.popularne
                            ? Colors.white
                            : Colors.transparent,
                      ),
                      child: Text(
                        'Popularne',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize:
                              selected_choice == wybor.popularne ? 18 : 14,
                          fontWeight: selected_choice == wybor.popularne
                              ? FontWeight.w900
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        setState(() {
                          selected_choice = wybor.filtrowane;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selected_choice == wybor.filtrowane
                            ? Colors.white
                            : Colors.transparent,
                      ),
                      child: Text(
                        'Twoje lokale',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize:
                              selected_choice == wybor.filtrowane ? 19 : 14,
                          fontWeight: selected_choice == wybor.filtrowane
                              ? FontWeight.w900
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        favFb = await pobierzUlubione();
                        ref.read(ulubioneProvider.notifier).addLokale(favFb);

                        setState(() {
                          selected_choice = wybor.ulubione;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selected_choice == wybor.ulubione
                            ? Colors.white
                            : Colors.transparent,
                      ),
                      child: Text(
                        'Ulubione',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: selected_choice == wybor.ulubione ? 19 : 14,
                          fontWeight: selected_choice == wybor.ulubione
                              ? FontWeight.w900
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: selected_choice == wybor.popularne
                  ? ScrollableTileFinalSwipable(
                      key: ValueKey(listaLokali),
                      lista: listaLokali,
                      listaUlubionych: favFb,
                    )
                  : (selected_choice == wybor.filtrowane)
                      ? filtrowane.isNotEmpty
                          ? ScrollableTileFinalSwipable(
                              key: ValueKey(filtrowane),
                              lista: filtrowane,
                              listaUlubionych: favFb,
                            )
                          : Center(
                              child: Text(
                                'Niestety, za dużo chcesz od życia :?',
                                style: kTitleTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            )
                      : favFb.isNotEmpty
                          ? ScrollableTileFinalNormal(lista: favFb)
                          : Center(
                              child: Text(
                                'Wariacie dodaj cos do ulubionych',
                                style: kTitleTextStyle,
                              ),
                            ),
            ),
            BottomMenu(
              list: true,
              map: false,
              filter: false,
            ),
          ],
        ),
      ),
    );
  }
}
