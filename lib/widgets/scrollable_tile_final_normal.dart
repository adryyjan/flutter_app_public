import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:funnavi/widgets/scrollable_tiles.dart';

import '../class/local_data.dart';
import '../class/riverpod.dart';

class ScrollableTileFinalNormal extends ConsumerStatefulWidget {
  List<Lokal>? lista;
  ScrollableTileFinalNormal({super.key, required this.lista});

  @override
  ConsumerState<ScrollableTileFinalNormal> createState() =>
      _ScrollableTileFinalNormalState();
}

class _ScrollableTileFinalNormalState
    extends ConsumerState<ScrollableTileFinalNormal> {
  late List<Lokal>? _lista;
  Map<int, double> _offsets = {};

  @override
  void initState() {
    super.initState();
    _lista = widget.lista;
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

        setState(() {
          _lista = _lista!.where((lokal) => lokal.id != venueId).toList();
          _offsets.removeWhere((key, value) => key >= _lista!.length);
        });

        print("Venue removed successfully!");
      } catch (e) {
        print("Error removing venue: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ulubioneLokale = ref.watch(ulubioneProvider);
    return Container(
      color: Color.fromRGBO(254, 255, 218, 1),
      child: GridView.builder(
        padding: EdgeInsets.all(10.0),
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 4,
            crossAxisCount: 1, // Jeden rząd
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10),
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
                    color: Colors.redAccent,
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    if ((details.primaryDelta ?? 0) > 0) {
                      _offsets[index] =
                          (details.primaryDelta ?? 0) + (_offsets[index] ?? 0);
                    }
                  });
                },
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! > 15) {
                    setState(() {
                      removeVenueFromUser(_lista![index].id);
                      ulubioneLokale.remove(_lista![index]);
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
              )
            ],
          );
        },
      ),
    );
  }
}
