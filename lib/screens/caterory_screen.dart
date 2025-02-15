import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:funnavi/widgets/bottom_menu.dart';
import 'package:funnavi/widgets/category_list.dart';
import 'package:funnavi/widgets/category_slider.dart';

import '../API_PRIVATE.dart';
import '../class/Location.dart';
import '../class/LokalFilter.dart';
import '../class/local_data.dart';
import '../const.dart';
import '../providers/filterProvider.dart';
import '../providers/filteredLocalsProvider.dart';
import '../providers/lokalsProvider.dart';
import '../providers/userLocationProvider.dart';
import '../widgets/category_switch.dart';
import 'main_screen.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  static const id = 'category';

  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  static const List<String> _rodzajLokalu = [
    'Bar',
    'Pub',
    'Koktajlbar',
    'Piwiarnia',
    'Sportsbar',
    'klub muzyczny'
  ];
  static const List<String> _glownaSpecka = [
    'Piwko',
    'Piwko Craftowe',
    'Shoty',
    'Drineczki',
    'Koktajle',
    'Fancy drineczki'
  ];

  String? rodzajLokalu;
  String? specjalnoscLokalu;
  bool? strefaPalenia;
  double? ocenaMin;
  double? odleglosc;
  double? halas;
  double? bezpieczenstwo;
  bool? naRandke;
  bool? przystosowany;
  List<Lokal>? lokale;
  List<Lokal>? lokale_temp;

  final routeService = RouteService(GOOGLE_API);

  final lokalFilterService = LokalFilterService(RouteService(GOOGLE_API));

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final listaLokaliRiverpod = ref.read(lokalProvider);

      if (listaLokaliRiverpod!.isNotEmpty) {
        setState(() {
          lokale =
              listaLokaliRiverpod.map((lokal) => Lokal.copy(lokal)).toList();
          lokale!.sort((a, b) => b.ocena.compareTo(a.ocena));
          lokale_temp = List.from(lokale!);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(filterProvider);
    final userLocation = ref.watch(userLocationProvider);

    return Scaffold(
      body: Column(children: [
        Expanded(
          child: Container(
            color: kTlo,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Text('FILTRY', style: kTitleTextStyleBlack),
                      const SizedBox(height: 30),
                      Expanded(
                        child: Container(
                          color: kTlo,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CategoryRodzajList(
                                  bgcolor1: filter.rodzajLokalu == null
                                      ? kBgDarker
                                      : Color(0xFFffb114),
                                  bgcolor2: filter.rodzajLokalu == null
                                      ? kBgDarker
                                      : Color(0xFFDB200C),
                                  filterKey: 'rodzajLokalu',
                                  lista: _rodzajLokalu,
                                  text: 'Rodzaj',
                                  onSelect: (value) {
                                    setState(() {
                                      filter.rodzajLokalu = value;
                                    });
                                  },
                                ),
                                CategoryRodzajList(
                                  bgcolor1: filter.glownaSpecjalnosc == null
                                      ? kBgDarker
                                      : Color(0xFFffb114),
                                  bgcolor2: filter.glownaSpecjalnosc == null
                                      ? kBgDarker
                                      : Color(0xFFDB200C),
                                  filterKey: 'glownaSpecjalnosc',
                                  lista: _glownaSpecka,
                                  text: 'Specjalność',
                                  onSelect: (value) {
                                    setState(() {
                                      filter.glownaSpecjalnosc = value;
                                    });
                                  },
                                ),
                                CategorySwitch(
                                  bgcolor1: filter.strefaPalenia == null ||
                                          filter.strefaPalenia == false
                                      ? kBgDarker
                                      : Color(0xFFffb114),
                                  bgcolor2: filter.strefaPalenia == null ||
                                          filter.strefaPalenia == false
                                      ? kBgDarker
                                      : Color(0xFFDB200C),
                                  isSwitched: filter.strefaPalenia == null
                                      ? false
                                      : filter.strefaPalenia!,
                                  text: 'Strefa palenia',
                                  onSwitch: (value) {
                                    setState(() {
                                      filter.strefaPalenia = value;
                                    });
                                  },
                                ),
                                CategorySwitch(
                                  bgcolor1: filter.naRandke == null ||
                                          filter.naRandke == false
                                      ? kBgDarker
                                      : Color(0xFFffb114),
                                  bgcolor2: filter.naRandke == null ||
                                          filter.naRandke == false
                                      ? kBgDarker
                                      : Color(0xFFDB200C),
                                  isSwitched: filter.naRandke == null
                                      ? false
                                      : filter.naRandke!,
                                  text: 'Na randkę',
                                  onSwitch: (value) {
                                    setState(() {
                                      filter.naRandke = value;
                                    });
                                  },
                                ),
                                CategorySwitch(
                                  bgcolor1: filter.przystosowany == null ||
                                          filter.przystosowany == false
                                      ? kBgDarker
                                      : Color(0xFFffb114),
                                  bgcolor2: filter.przystosowany == null ||
                                          filter.przystosowany == false
                                      ? kBgDarker
                                      : Color(0xFFDB200C),
                                  isSwitched: filter.przystosowany == null
                                      ? false
                                      : filter.przystosowany!,
                                  text: 'Przystosowany',
                                  onSwitch: (value) {
                                    setState(() {
                                      filter.przystosowany = value;
                                    });
                                  },
                                ),
                                CategorySlider(
                                  precyzja: 25,
                                  bgcolor1: filter.ocena == null
                                      ? kBgDarker
                                      : Color(0xFFffb114),
                                  bgcolor2: filter.ocena == null
                                      ? kBgDarker
                                      : Color(0xFFDB200C),
                                  text: 'Ocena',
                                  onSlide: (value) {
                                    setState(() {
                                      ref.read(filterProvider.notifier).update(
                                            filter.copyWith(ocena: value),
                                          );
                                    });
                                  },
                                  ocena: filter.ocena == null
                                      ? 2.5
                                      : filter.ocena!,
                                  maxSlide: 5,
                                ),
                                CategorySlider(
                                  precyzja: 25,
                                  bgcolor1: filter.odleglosc == null
                                      ? kBgDarker
                                      : Color(0xFFffb114),
                                  bgcolor2: filter.odleglosc == null
                                      ? kBgDarker
                                      : Color(0xFFDB200C),
                                  text: 'Dystans',
                                  onSlide: (value) {
                                    setState(() {
                                      ref.read(filterProvider.notifier).update(
                                            filter.copyWith(odleglosc: value),
                                          );
                                    });
                                  },
                                  ocena: filter.odleglosc == null
                                      ? 5.0
                                      : filter.odleglosc!,
                                  maxSlide: 10,
                                ),
                                CategorySlider(
                                  precyzja: 25,
                                  bgcolor1: filter.halas == null
                                      ? kBgDarker
                                      : Color(0xFFffb114),
                                  bgcolor2: filter.halas == null
                                      ? kBgDarker
                                      : Color(0xFFDB200C),
                                  text: 'Hałas',
                                  onSlide: (value) {
                                    setState(() {
                                      ref.read(filterProvider.notifier).update(
                                            filter.copyWith(halas: value),
                                          );
                                    });
                                  },
                                  ocena: filter.halas ?? 2.5,
                                  maxSlide: 5,
                                ),
                                CategorySlider(
                                  precyzja: 25,
                                  bgcolor1: filter.bezpieczenstwo == null
                                      ? kBgDarker
                                      : Color(0xFFffb114),
                                  bgcolor2: filter.bezpieczenstwo == null
                                      ? kBgDarker
                                      : Color(0xFFDB200C),
                                  text: 'Safe',
                                  onSlide: (value) {
                                    setState(() {
                                      ref.read(filterProvider.notifier).update(
                                            filter.copyWith(
                                                bezpieczenstwo: value),
                                          );
                                    });
                                  },
                                  ocena: filter.bezpieczenstwo ?? 2.5,
                                  maxSlide: 5,
                                ),
                              ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: kGradientBR,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            filter.odleglosc = null;
                            filter.rodzajLokalu = null;
                            filter.glownaSpecjalnosc = null;
                            filter.naRandke = null;
                            filter.strefaPalenia = null;
                            filter.przystosowany = null;
                            filter.ocena = null;

                            filter.halas = null;
                            filter.bezpieczenstwo = null;

                            List<Lokal>? lokaleFilter =
                                lokalFilterService.filtrujLokale(
                                    lokale_temp!,
                                    filter,
                                    userLocation.latitude,
                                    userLocation.longitude);
                            ref
                                .read(filteredLocalsProvider.notifier)
                                .updateFilteredLocals(lokaleFilter);
                          });
                        },
                        child: Text(
                          'Resetuj filtry',
                          style: kDesctyprionTextStyleWhite,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: kGradientBR,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextButton(
                        onPressed: () {
                          print(filter.odleglosc);
                          List<Lokal>? lokaleFilter =
                              lokalFilterService.filtrujLokale(
                                  lokale_temp!,
                                  filter,
                                  userLocation.latitude,
                                  userLocation.longitude);
                          ref
                              .read(filteredLocalsProvider.notifier)
                              .updateFilteredLocals(lokaleFilter);

                          Navigator.popAndPushNamed(context, MainScreen.id);
                        },
                        child: Text(
                          'OK',
                          style: kDesctyprionTextStyleWhite,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                BottomMenu(
                  list: false,
                  map: false,
                  filter: true,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
