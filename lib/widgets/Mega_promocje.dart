import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../class/ofert_data.dart';
import '../const.dart';
import '../providers/currSelectedProvider.dart';
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
            BoxShadow(
              color: Color(0xFFDB200C).withValues(),
              blurRadius: 5,
              spreadRadius: 5,
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
              child: Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Text(
                          widget.oferta.oferta,
                          style: kOffertHeadBg,
                        ),
                        Text(
                          widget.oferta.oferta,
                          style: kOffertHead,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Stack(
                              children: [
                                Text(
                                  widget.oferta.opisOferta,
                                  style: kOffertDiscountBg,
                                ),
                                Text(
                                  widget.oferta.opisOferta,
                                  style: kOffertDiscount,
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                Text(widget.oferta.cena, style: kOffertHeadBg),
                                Text(widget.oferta.cena, style: kOffertHead),
                              ],
                            ),
                          ],
                        ),
                        Image.asset(
                          "images/wine.png",
                          height: 80,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
