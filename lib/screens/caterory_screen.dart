import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:funnavi/widgets/bottom_menu.dart';
import 'package:funnavi/widgets/category_list.dart';
import 'package:funnavi/widgets/category_slider.dart';

import '../API_PRIVATE.dart';
import '../class/Location.dart';
import '../class/LokalFilter.dart';
import '../class/local_data.dart';
import '../class/riverpod.dart';
import '../const.dart';
import '../data/jsonData.dart';
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

    final Map<String, dynamic> parsedData = jsonDecode(jsonData);
    List<Lokal> daneWejsciowe = parsedData.entries.map((entry) {
      return Lokal.fromMap(entry.value);
    }).toList();

    lokale = daneWejsciowe.map((lokal) => Lokal.copy(lokal)).toList();
    lokale!.sort((a, b) => b.ocena.compareTo(a.ocena));
    lokale_temp = lokale;
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
                      Text('FILTRY', style: kTitleTextStyle),
                      const SizedBox(height: 30),
                      Expanded(
                        child: Container(
                          color: Color.fromRGBO(254, 255, 218, 1),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CategoryRodzajList(
                                  bgcolor: filter.rodzajLokalu == null
                                      ? Color(0xFFe8e8a5)
                                      : Color.fromRGBO(255, 227, 0, 1),
                                  filterKey: 'rodzajLokalu',
                                  lista: _rodzajLokalu,
                                  text: 'Rodzaj lokalu',
                                  onSelect: (value) {
                                    setState(() {
                                      filter.rodzajLokalu = value;
                                    });
                                  },
                                ),
                                CategoryRodzajList(
                                  bgcolor: filter.glownaSpecjalnosc == null
                                      ? Color(0xFFe8e8a5)
                                      : Color.fromRGBO(255, 227, 0, 1),
                                  filterKey: 'glownaSpecjalnosc',
                                  lista: _glownaSpecka,
                                  text: 'Główna specjalność',
                                  onSelect: (value) {
                                    setState(() {
                                      filter.glownaSpecjalnosc = value;
                                    });
                                  },
                                ),
                                CategorySwitch(
                                  bgcolor: filter.strefaPalenia == null ||
                                          filter.strefaPalenia == false
                                      ? Color(0xFFe8e8a5)
                                      : Color.fromRGBO(255, 227, 0, 1),
                                  isSwitched: filter.strefaPalenia ?? false,
                                  text: 'Strefa palenia',
                                  onSwitch: (value) {
                                    setState(() {
                                      filter.strefaPalenia = value;
                                    });
                                  },
                                ),
                                CategorySwitch(
                                  bgcolor: filter.naRandke == null ||
                                          filter.naRandke == false
                                      ? Color(0xFFe8e8a5)
                                      : Color.fromRGBO(255, 227, 0, 1),
                                  isSwitched: filter.naRandke == null
                                      ? false
                                      : filter.naRandke!,
                                  text: 'Na romantyczną randkę',
                                  onSwitch: (value) {
                                    setState(() {
                                      filter.naRandke = value;
                                    });
                                  },
                                ),
                                CategorySwitch(
                                  bgcolor: filter.przystosowany == null ||
                                          filter.przystosowany == false
                                      ? Color(0xFFe8e8a5)
                                      : Color.fromRGBO(255, 227, 0, 1),
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
                                  bgcolor: filter.ocena == null
                                      ? Color(0xFFe8e8a5)
                                      : Color.fromRGBO(255, 227, 0, 1),
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
                                  bgcolor: filter.odleglosc == null
                                      ? Color(0xFFe8e8a5)
                                      : Color.fromRGBO(255, 227, 0, 1),
                                  text: 'Odległość',
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
                                  bgcolor: filter.halas == null
                                      ? Color(0xFFe8e8a5)
                                      : Color.fromRGBO(255, 227, 0, 1),
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
                                  bgcolor: filter.bezpieczenstwo == null
                                      ? Color(0xFFe8e8a5)
                                      : Color.fromRGBO(255, 227, 0, 1),
                                  text: 'Bezpieczny',
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
                      decoration: kGradient,
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
                        child: const Text(
                          'OK',
                          style: kDesctyprionTextStyle,
                        ),
                      ),
                    ),
                    Container(
                      decoration: kGradient,
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
                        child: const Text(
                          'Resetuj filtry',
                          style: kDesctyprionTextStyle,
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
