import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:funnavi/widgets/promotion_tile.dart';

import '../class/local_data.dart';
import '../const.dart';
import '../providers/filteredLocalsProvider.dart';
import '../providers/lokalsProvider.dart';
import '../providers/offertsProvider.dart';
import '../providers/ulunioneProvider.dart';
import '../widgets/bottom_menu.dart';
import '../widgets/scrollable_tile_final_normal.dart';
import '../widgets/sscrollable_tile_final_swipable.dart';

enum wybor {
  popularne,
  filtered,
  ulubione,
}

class MainScreen extends ConsumerStatefulWidget {
  static const id = 'main';

  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  wybor selected_choice = wybor.popularne;
  UserCredential? credentials;
  List<Lokal> fav = [];

  @override
  Widget build(BuildContext context) {
    final filtered = ref.watch(filteredLocalsProvider);
    final localsList = ref.watch(lokalProvider);
    final offertsList = ref.watch(ofertyProvider);
    final fav = ref.watch(ulubioneProvider);

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
                itemCount: offertsList?.length ?? 0,
                itemBuilder: (context, index) {
                  return MegaPromocje(oferta: offertsList![index]);
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
                          selected_choice = wybor.filtered;
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: selected_choice == wybor.filtered
                            ? Colors.white
                            : Colors.transparent,
                      ),
                      child: Icon(
                        Icons.manage_search_outlined,
                        size: 40,
                        color: selected_choice == wybor.filtered
                            ? Color(0xFFDB200C)
                            : Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        ref.read(ulubioneProvider.notifier).addLokale(fav);

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
                      key: ValueKey(localsList),
                      lista: localsList,
                      listaUlubionych: fav,
                    )
                  : (selected_choice == wybor.filtered)
                      ? filtered.isNotEmpty
                          ? ScrollableTileFinalSwipable(
                              key: ValueKey(filtered),
                              lista: filtered,
                              listaUlubionych: fav,
                            )
                          : Center(
                              child: Text(
                                'Niestety, za dużo chcesz od życia :?',
                                style: kSmallerTitleTextStyleBlack,
                                textAlign: TextAlign.center,
                              ),
                            )
                      : fav.isNotEmpty
                          ? ScrollableTileFinalNormal(lista: fav)
                          : Center(
                              child: Text(
                                'Wariacie dodaj cos do ulubionych',
                                style: kSmallerTitleTextStyleBlack,
                                textAlign: TextAlign.center,
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
