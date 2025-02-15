import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../class/ofert_data.dart';
import '../class/riverpod.dart';
import '../const.dart';
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
    return Container(
        decoration: BoxDecoration(
          boxShadow: [
            // PRZENIOSŁEM BoxShadow DO ZEWNĘTRZNEGO CONTAINERA
            BoxShadow(
              color: Color(0xFFDB200C).withValues(), // Czerwony blask
              blurRadius: 5, // Większe rozmycie dla lepszego efektu
              spreadRadius: 5, // Większa widoczność
            ),
          ],
          borderRadius: BorderRadius.circular(35),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
          child: Container(
            decoration: BoxDecoration(
              gradient: kGradientBR,
              borderRadius: BorderRadius.circular(35),
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
                  Stack(
                    children: [
                      Text(
                        widget.oferta.oferta,
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
                        widget.oferta.oferta,
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Text(
                        widget.oferta.opisOferta,
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
                        widget.oferta.opisOferta,
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Text(
                        widget.oferta.cena,
                        style: TextStyle(
                          fontSize: 30,
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
                          fontSize: 30,
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
        ));
  }
}
