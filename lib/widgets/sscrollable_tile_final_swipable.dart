import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:funnavi/const.dart';

import '../class/local_data.dart';
import '../providers/ulunioneProvider.dart';
import '../widgets/scrollable_tiles.dart';

class ScrollableTileFinalSwipable extends ConsumerStatefulWidget {
  final List<Lokal>? lista;
  final List<Lokal>? listaUlubionych;

  ScrollableTileFinalSwipable({
    super.key,
    required this.lista,
    required this.listaUlubionych,
  });

  @override
  ConsumerState<ScrollableTileFinalSwipable> createState() =>
      _ScrollableTileFinalSwipableState();
}

class _ScrollableTileFinalSwipableState
    extends ConsumerState<ScrollableTileFinalSwipable> {
  late List<Lokal>? _lista;
  // late List<Lokal>? _listaUlubionych;

  Map<int, double> _offsets = {};

  @override
  void initState() {
    super.initState();
    _lista = widget.lista;
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

  @override
  Widget build(BuildContext context) {
    final ulubioneLokale = ref.watch(ulubioneProvider);
    return Container(
      color: kTlo,
      child: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        scrollDirection: Axis.vertical,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 4,
          crossAxisCount: 1,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: _lista?.length ?? 0,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    right: 20, left: 20, top: 5, bottom: 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Colors.greenAccent,
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    if ((details.primaryDelta ?? 0) < 0) {
                      _offsets[index] =
                          (details.primaryDelta ?? 0) + (_offsets[index] ?? 0);
                    }
                  });
                },
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! < 15) {
                    ulubioneLokale.add(_lista![index]);
                    addVenueToUser(_lista![index].id);
                    setState(() {
                      _offsets[index] = 0;
                    });
                  } else {
                    setState(() {
                      _offsets[index] = 0;
                    });
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  transform:
                      Matrix4.translationValues(_offsets[index] ?? 0, 0, 0),
                  child: ScrollableTiles(
                    nazwa_loklau: _lista![index].nazwaLokalu.toString(),
                    ocena: _lista![index].ocena,
                    dystans: '0.9',
                    lokal: _lista![index],
                    xCord: _lista![index].xCord,
                    yCord: _lista![index].yCord,
                    opis: _lista![index].opis,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
