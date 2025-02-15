import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:funnavi/widgets/Mega_promocje.dart';

import '../class/local_data.dart';
import '../const.dart';
import '../providers/authProvider.dart';
import '../providers/filterProvider.dart';
import '../providers/filteredLocalsProvider.dart';
import '../providers/lokalsProvider.dart';
import '../providers/offertsProvider.dart';
import '../providers/ulunioneProvider.dart';
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

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: kTlo,
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text('FUNAVI', style: kTitleTextStyleBlack),
            Container(
              height: 180,
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
                      child: Icon(
                        Icons.local_fire_department,
                        size: 40,
                        color: selected_choice == wybor.popularne
                            ? Color(0xFFDB200C)
                            : Color(0xFF1E3A8A),
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
                      child: Icon(
                        Icons.manage_search_outlined,
                        size: 40,
                        color: selected_choice == wybor.filtrowane
                            ? Color(0xFFDB200C)
                            : Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
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
                      child: Icon(
                        Icons.favorite_rounded,
                        size: 40,
                        color: selected_choice == wybor.ulubione
                            ? Color(0xFFDB200C)
                            : Color(0xFF1E3A8A),
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
                                style: kSmallerTitleTextStyleBlack,
                                textAlign: TextAlign.center,
                              ),
                            )
                      : favFb.isNotEmpty
                          ? ScrollableTileFinalNormal(lista: favFb)
                          : Center(
                              child: Text(
                                'Wariacie dodaj cos do ulubionych',
                                style: kTitleTextStyleBlack,
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
