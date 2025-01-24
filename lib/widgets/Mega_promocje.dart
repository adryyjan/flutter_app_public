import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../class/ofert_data.dart';
import '../class/riverpod.dart';
import '../screens/offert_screen.dart';

class MegaPromocje extends ConsumerStatefulWidget {
  final Oferta oferta;
  const MegaPromocje({super.key, required this.oferta});

  @override
  ConsumerState<MegaPromocje> createState() => _MegaPromocjeState();
}

class _MegaPromocjeState extends ConsumerState<MegaPromocje> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(35.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFffb114), Color(0xFFFFD700)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(15), // Zaokrąglenie rogów
        ),
        child: TextButton(
          onPressed: () {
            ref.read(selectedOfertaProvider.notifier).state = widget.oferta;
            Navigator.pushNamed(context, OffertScreen.id);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.oferta.oferta,
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                widget.oferta.opisOferta,
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Stack(
                children: [
                  Text(
                    widget.oferta.cena,
                    style: TextStyle(
                      fontSize: 40,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 8
                        ..color = Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    widget.oferta.cena,
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
