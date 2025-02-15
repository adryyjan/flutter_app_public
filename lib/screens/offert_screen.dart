import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:funnavi/screens/venue_screen.dart';
import 'package:funnavi/widgets/bottom_menu.dart';

import '../class/local_data.dart';
import '../const.dart';
import '../providers/currSelectedProvider.dart';
import '../providers/lokalsProvider.dart';
import '../widgets/locat_properyty.dart';
import 'map_screen.dart';

class OffertScreen extends ConsumerStatefulWidget {
  static const id = 'offert';
  const OffertScreen({super.key});

  @override
  ConsumerState<OffertScreen> createState() => _OffertScreenState();
}

class _OffertScreenState extends ConsumerState<OffertScreen> {
  @override
  Widget build(BuildContext context) {
    final wybranaOferta = ref.watch(selectedOfertaProvider);
    final listaLokali = ref.watch(lokalProvider);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: kTlo,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            Text(
              '${wybranaOferta?.nazwa}',
              style: kTitleTextStyleBlack,
            ),
            SizedBox(
              height: 5,
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            wybranaOferta!.oferta,
                            style: kSmallerTitleTextStyleBlack,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          LocalProperyty(
                            wartosc: wybranaOferta.opisOferta,
                            text: 'Promocja',
                          ),
                          LocalProperyty(
                            wartosc: wybranaOferta.przedmiotOferty,
                            text: 'Dotyczy',
                          ),
                          LocalProperyty(
                            wartosc: wybranaOferta.data,
                            text: 'Ważna do',
                          ),
                          LocalProperyty(
                            wartosc: wybranaOferta.czas,
                            text: 'W godzinach',
                          ),
                          LocalProperyty(
                            wartosc: wybranaOferta.wielorazowa,
                            text: 'Czy wielorazowa',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                              Lokal znalezionyLokal = listaLokali!.firstWhere(
                                  (lokal) => lokal.id == wybranaOferta.id);

                              ref.read(selectedLokalProvider.notifier).state =
                                  znalezionyLokal;
                              Navigator.popAndPushNamed(
                                  context, VenueScreen.id);
                            },
                            child: Text(
                              'POKAŻ LOKAL',
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
                              Lokal znalezionyLokal = listaLokali!.firstWhere(
                                  (lokal) => lokal.id == wybranaOferta.id);

                              ref.read(selectedLokalProvider.notifier).state =
                                  znalezionyLokal;
                              Navigator.popAndPushNamed(context, MapScreen.id);
                            },
                            child: Text(
                              'PROWADŻ',
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
